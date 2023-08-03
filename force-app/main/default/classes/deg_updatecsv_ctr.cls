public with sharing class deg_updatecsv_ctr {
   
    public static String columnNotFound;
    public static fileUploadConfiguration__mdt objMdtFuC = new fileUploadConfiguration__mdt();
    public static Map<String, Schema.SObjectType> globalDes = Schema.getGlobalDescribe(); 

    public class updatecsvException extends Exception{}
    
    @AuraEnabled
    public static String  readCSVFile(Id contentDocumentId,string namemdt,id idrt){
        String strMessage;
        wrapperAnswer objWpAn= new wrapperAnswer();
        list <id> lstId = new list <id>();
        List <SObject>lstSobject = new List <SObject>();
        system.debug(namemdt);
        objMdtFuC = [SELECT id,DeveloperName,sobjectName__c, jsonConfig__c, NumberOfColumns__c, Separator__c from fileUploadConfiguration__mdt WHERE DeveloperName=:namemdt];

        if ( contentDocumentId != null ) {
            
            ContentVersion contentVersionObj = [ SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId ];
            List < String > records = contentVersionObj.VersionData.toString().split( '\n' );
            //Removing the Header
            records.remove( 0 );
            id idAccount =[SELECT id FROM account WHERE name =:system.label.DEG_NombreCuentaOutbound].id;

            for ( String record : records ) {
                System.debug('Fila Excel');
                if ( record != null ) {
                    sobject sobj=crearRegistro(objMdtFuC.sobjectName__C,objMdtFuC.Separator__c,record,idrt, idAccount);
                    lstSobject.add(sobj);
                }
            }

            try {    
                if ( lstSobject.size() > 0 ) {
                    Database.DeleteResult deleteResult = Database.delete( contentDocumentId, true );
                    if(objMdtFuC.sobjectName__C.equalsIgnoreCase('contact')){
                        lstSobject=validatecontact(lstSobject);
                    }
                    upsert lstSobject;
                    strMessage = 'Registros creados correctamente.';
                    for(sobject objSObj:lstSobject){
                        lstId.add(string.valueof(objSObj.get('id')));
                    }
                    objWpAn.variant='success';
                }

            }
            catch ( Exception e ) {

                strMessage = 'Se presentaron algunos errores al crear los registros: ';
                strMessage +=e.getMessage();
                objWpAn.variant='error';
                system.debug(e.getMessage() );

            } 
        }
        objWpAn.recordid=lstId;
        objWpAn.strmessage=strMessage;
        strMessage=string.valueof(json.serialize(objWpAn));
        return strMessage;

    }
/*
        Preparación del registro: 
        1. Campo que esté escapado con doble comilla se quita. Ejm: "prueba" -> prueba
        2. Comilla doble duplicada dentro de campo escapado se vuelve comilla doble individual. Ejm: "Restaurante ""El Chamito""" -> Restaurante "El Chamito"
        3. Escapa el separador dentro de los campos agregándole backslash. Ejm: "Frente al D1; al lado del Collins" -> Frente al D1\; al lado del Collins
        4. Separadores contiguos se les agrega un espacio
*/
    public static sobject crearRegistro(String sobjectName,String separator,String record,id idrt, Id idAccount){
        system.debug('idrt=>'+idrt);
        //id idAccount =[SELECT id FROM account WHERE name =:system.label.DEG_NombreCuentaOutbound].id;
        String strProcessed = '';
        Integer intStrIdx = 0;
        string numeroCelular;//ajuste
        Pattern patEscapedCSV = Pattern.compile('"(([^"]|"")*)"'); 
        Matcher matObject = patEscapedCSV.matcher(record); 
        While (matObject.find()) { 
            strProcessed += record.substring(intStrIdx, matObject.start()) + matObject.group(1).replace('""', '"').replaceAll(separator, '\\\\' + separator);
            intStrIdx = matObject.end();
        }
        strProcessed += record.substring(intStrIdx);
        strProcessed = strProcessed.replaceAll('(?<!\\\\)' + separator + separator, separator + ' ' + separator);
        strProcessed = strProcessed.replaceAll('(?<!\\\\)' + separator + '$', separator + ' ');
        System.debug('crearRegistro - strProcessed: ' + strProcessed);
        
        // Separación del registro preparado ignorando el separador cuando se escape
        List<String> lstFields = strProcessed.split('(?<!\\\\)' + separator);
        System.debug(lstFields);   


        string userErrorMessage ='';
        integer sizefile=integer.valueof(objMdtFuC.NumberOfColumns__c);
        map<string,string> mapField = new map<string,string>();
        string strJson =objMdtFuC.jsonConfig__c;
        wrapperVal objWrapper = (wrapperVal) JSON.deserialize(strJson, wrapperVal.class);
        sobject sobj=getNewSobject(sobjectName);
        
        // Determina columnas faltante
        for(wrapperField objWf:objWrapper.fieldsValidations){
            if(objWf.position>lstFields.size()) 
            {
                columnNotFound += objWf.NameColumn;
                columnNotFound += ' ,';
            }    
            
        }
        
        //obtine numero de celular //ajuste
        for(wrapperField objWf:objWrapper.fieldsValidations){
            if(objWf.api=='DEG_Numero_Celular__c'){
                try{
                    numeroCelular=lstFields[objWf.position];
                } catch(Exception exc) {
                    Throw new updatecsvException('El formato del CSV es incorrrecto');
                }
            }
        }

        //Asignar valores
        for(wrapperField objWf:objWrapper.fieldsValidations){
            if(idrt!=null){
                sobj.put('RecordTypeId',idrt);
            }
            if(sobjectName=='contact'){
                sobj.put('AccountId',idAccount);
            }
            system.debug(objWf);
            if(objWf.position<lstFields.size()&&objWf.api!=''){
                system.debug(lstFields[objWf.position]);
                if(objWf.needReplace){
                    if(objWf.isDecimal&&!string.isblank(lstFields[objWf.position])){sobj.put(objWf.api,decimal.valueof(lstFields[objWf.position].replaceAll('\\\\' + separator, separator)));}
                    else if(!objWf.isDecimal){sobj.put(objWf.api,lstFields[objWf.position].replaceAll('\\\\' + separator, separator));}
                }
                else if(!objWf.needReplace){
                    if(objWf.isDecimal&&!string.isblank(lstFields[objWf.position])){sobj.put(objWf.api,decimal.valueof(lstFields[objWf.position]));}
                    else if(!objWf.isDecimal){sobj.put(objWf.api,lstFields[objWf.position]);}
                }
                if(sobjectName=='contact'&&(objWf.necCreate)){//ajuste
                    String valorColumna = String.valueOf(sobj.get(objWf.api))!=null ? (String.valueOf(sobj.get(objWf.api))) : ('');
                    if(String.isBlank(valorColumna)){
						if(objWf.isDecimal){
                            sobj.put(objWf.api,decimal.valueof(numeroCelular.replaceAll('\\\\' + separator, separator)));
                        }
                        else if(!objWf.isDecimal){
                            sobj.put(objWf.api,numeroCelular.replaceAll('\\\\' + separator, separator));
						}                        
                    }
                }
            }
        }
        
        // Valida completitud de datos
        for(wrapperField objWf:objWrapper.fieldsValidations){
            system.debug(objWf);
            system.debug(lstFields.size());
            string strtxt='';
            if(lstFields.size()==objMdtFuC.NumberOfColumns__c&&objWf.necCreate&&(sobj.get(objWf.api)==''||sobj.get(objWf.api)==null)){
                    strtxt+=objWf.NameColumn;
                    strtxt+=', ';
                    userErrorMessage+=strtxt;
                }
        }
        
        if(!String.isBlank(userErrorMessage)){
            throw new CustomException('El/Los campos '+ userErrorMessage +'son obligatorios');
        }
        System.debug('sobj: '+sobj);
        return sobj;
    }

    public static List<SObject> validatecontact(List<SObject> lstSobj){
        id ids;
        list <string> lstNumero2 = new list <string>();
        list <string> lstIdentificacion = new list <string>();
        list <contact> lstContact;
        map <string,contact> mapCntNId = new  map <string,contact>();
        map <string,contact> mapCntNc = new  map <string,contact>();
        for(SObject objSobj:lstSobj)
        {
            if(objSobj.get('DEG_Numero_Celular__c')!= null){
                lstNumero2.add(string.valueof(objSobj.get('DEG_Numero_Celular__c')));
            }
            if(objSobj.get('NumerodeIdentificacion__c')!= null){
                lstIdentificacion.add(string.valueof(objSobj.get('NumerodeIdentificacion__c')));
            }
        }
            
        if(!lstNumero2.isEmpty() || !lstIdentificacion.isEmpty()){
            lstContact =([SELECT id,DEG_Numero_Celular__c,NumerodeIdentificacion__c,recordtype.developername FROM contact 
                                            WHERE recordtype.developername =: 'DEG_MensajeriaHSM' and (DEG_Numero_Celular__c IN: lstNumero2 OR NumerodeIdentificacion__c IN:lstIdentificacion)]);
            system.debug(lstContact);
        }
        if(lstContact!=null && !lstContact.isEmpty()){
            for(contact objcnt : lstContact){
                if(objcnt.DEG_Numero_Celular__c!= null){
                    mapCntNc.put(objcnt.DEG_Numero_Celular__c,objcnt);
                }
                if(objcnt.NumerodeIdentificacion__c!= null){
                    mapCntNId.put(objcnt.NumerodeIdentificacion__c,objcnt);
                }
            }

            for(SObject objSobj:lstSobj)
            {
                if(objSobj.get('DEG_Numero_Celular__c')!= null && mapCntNc.containsKey(string.valueof(objSobj.get('DEG_Numero_Celular__c')))){
                    ids =mapCntNc.get(string.valueof(objSobj.get('DEG_Numero_Celular__c'))).id;
                    objSobj.put('id',ids);
                }
                if(objSobj.get('NumerodeIdentificacion__c')!= null && mapCntNId.containsKey(string.valueof(objSobj.get('NumerodeIdentificacion__c')))){
                    ids =mapCntNId.get(string.valueof(objSobj.get('NumerodeIdentificacion__c'))).id;
                    objSobj.put('id',ids);
                }
            }
        }
        return lstSobj;
    }
    
    public static SObject getNewSobject(String sobjecName) {
        Schema.SObjectType st = globalDes.get(sobjecName);
        Sobject s = st.newSobject();
        return s;
    }
    

        public class CustomException extends Exception {}
        //wrappers

        public class wrapperAnswer{
            public string strmessage {get;set;}
            public string variant {get;set;}
            public list<id> recordid {get;set;}
        } 

        public class wrapperVal{
            public list<wrapperField> fieldsValidations {get;set;}
        } 
        
        public class wrapperField{
            public string api{get;set;}
            public integer position{get;set;}
            public string NameColumn{get;set;}
            public boolean needReplace{get;set;}
            public boolean necCreate{get;set;}
            public boolean isDecimal{get;set;}
        }
}