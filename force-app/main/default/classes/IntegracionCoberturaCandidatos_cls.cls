public class IntegracionCoberturaCandidatos_cls {
    public Map<Id,Map<String,Object>> GenerarDatamap(List<Lead> lstLead, String strListaHomlogacion){
        Mensaje_Integracion__c lstMensajes = [SELECT Id, Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Candidato Cobertura'];
        String sFields = lstMensajes.Mensaje__c;
        Set<String> setFields = new Set<String>();
        setFields.addAll(sFields.split(','));
        
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        Map<String,Object> tmpMapHierarchy_TipoHomologacion = new Map<String,Object>();
        if(!String.isEmpty(strListaHomlogacion)){
            String selectParametersQuery = 'SELECT ' + 'Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c' + ' FROM '+strListaHomlogacion;
            List<SObject> lstHomologacion = Database.query(selectParametersQuery);
            
            List<Map<String,Object>> lstMapHierarchy_Homologacion = new List<Map<String,Object>>();
            for(SObject sglHomologacion:lstHomologacion){
                if(tmpMapHierarchy_TipoHomologacion.containskey(String.valueof(sglHomologacion.get('Tipo_Lista__c')))){
                    lstMapHierarchy_Homologacion = (List<Map<String,Object>>)tmpMapHierarchy_TipoHomologacion.get(String.valueof(sglHomologacion.get('Tipo_Lista__c')));
                    Map<String,Object> tmpMapHierarchy_Homologacion = new Map<String,Object>();
                    tmpMapHierarchy_Homologacion.put('Valor_API__c',String.valueof(sglHomologacion.get('Valor_API__c')));
                    tmpMapHierarchy_Homologacion.put('Valor_Usuario__c',String.valueof(sglHomologacion.get('Valor_Usuario__c')));
                    lstMapHierarchy_Homologacion.add(tmpMapHierarchy_Homologacion);
                    tmpMapHierarchy_TipoHomologacion.put(String.valueof(sglHomologacion.get('Tipo_Lista__c')),lstMapHierarchy_Homologacion);
                }else{
                    lstMapHierarchy_Homologacion = new List<Map<String,Object>>();
                    Map<String,Object> tmpMapHierarchy_Homologacion = new Map<String,Object>();
                    tmpMapHierarchy_Homologacion.put('Valor_API__c',String.valueof(sglHomologacion.get('Valor_API__c')));
                    tmpMapHierarchy_Homologacion.put('Valor_Usuario__c',String.valueof(sglHomologacion.get('Valor_Usuario__c')));
                    lstMapHierarchy_Homologacion.add(tmpMapHierarchy_Homologacion);
                    tmpMapHierarchy_TipoHomologacion.put(String.valueof(sglHomologacion.get('Tipo_Lista__c')),lstMapHierarchy_Homologacion);
                }
            }
        }
        
        Map<String, Schema.SObjectField> oLeadType = Schema.SObjectType.Lead.fields.getMap();
        for(Lead sglLead:lstLead){
            
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            for(String sglfield:setFields){
                if(oLeadType.containskey(sglfield.trim())){
                    if(oLeadType.get(sglfield.trim()).getDescribe().getType()==Schema.DisplayType.DATETIME){
                        Datetime dtFecha = (Datetime)sglLead.get(sglfield.trim());
                        Map<String,Object> mapDate = new Map<String,Object>();
                        mapDate.put('fulldate', dtFecha!=null?String.valueOf(dtFecha):'');
                        mapDate.put('GTZ', dtFecha!=null?dtFecha.format('yyyy-MM-dd\'T\'HH:mm:ssXXX','America/Bogota'):'');
                        mapDate.put('day', dtFecha!=null?String.valueOf(dtFecha.day()).leftpad(2,'0'):'');
                        mapDate.put('month', dtFecha!=null?String.valueOf(dtFecha.month()).leftpad(2,'0'):'');
                        mapDate.put('year', dtFecha!=null?String.valueOf(dtFecha.year()):'');
                        tmpMapHierarchy.put(sglfield.trim(),mapDate);
                    }else{
                        tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglLead, sglfield.trim()));
                    }
                }else{
                    tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglLead, sglfield.trim()));
                }
                if(tmpMapHierarchy.get(sglfield.trim())==null){
                    tmpMapHierarchy.put(sglfield.trim(), '');
                }
            }
            tmpMapHierarchy.put('Homologacion', tmpMapHierarchy_TipoHomologacion);
            mapHierarchy.put(sglLead.Id,tmpMapHierarchy.clone());
        }
        return mapHierarchy;

}
        public String EnvioSuma(List<Lead> lstLead, Map<Id,Map<String,Object>> mapDatos){
        String strErrMessage = '';
        ServiciosWeb__c sw;
        List<LogTransacciones__c> lstLogTransacciones = new List<LogTransacciones__c>();
        String sIdLead = '';
        try{
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='ConsultarCoberturaCandidato'];
            System.debug(lstMensajes + '****************lstm');
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplate = new Dom.Document();
            docMessageTemplate.load(mapMensajesIntegracion.get('ConsultarCoberturaCandidato'));
            Dom.Document docServices;
            
            for(Lead sglLead:lstLead){
                System.debug(sglLead);
                strErrMessage = '';
                sIdLead = sglLead.Id;
                PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
                docServices = clsHelper.PopulateXML(docMessageTemplate, mapDatos.get(sglLead.Id));
                
                DOM.Document docResponse;
                String correlationID = sglLead.Id;
                
                sw = ServiciosWeb__c.getValues('SumaConsultarCobertura');
                String endpoint = sw.EndPoint__c;
                String method = sw.Action__c;

                //Invocar servicio web 
                PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
                docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
                
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.Lead__c = sglLead.Id;
                logServicio.Name = 'Envio Suma Consulta Cobertura';
                logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
                System.debug(strErrMessage+'**************************************');
                try{
                    strErrMessage = RespuestaSuma(docResponse,sglLead);
                }catch(Exception e){
                    strErrMessage = e.getMessage() + e.getStackTraceString();
                }
                logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
                if(String.isNotEmpty(strErrMessage)){
                    logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
                }                    
                lstLogTransacciones.add(logServicio);
            }
        }catch(Exception e){
            strErrMessage = e.getMessage();
            if(String.isNotEmpty(sIdLead)){
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.Lead__c = sIdLead;
                logServicio.Name = 'Envio Suma Consulta Cobertura';
                logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
                logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
                lstLogTransacciones.add(logServicio);
            }
        }
        if(!lstLogTransacciones.isEmpty()){
        	insert lstLogTransacciones;
        }
        return strErrMessage;
    }

    public String RespuestaSuma(DOM.Document docResponse, Lead sglLead){
        String strErrMessage = 'Error en la integracion';
        String descripcionCobertura ='';
        String tipoDeDistancia = '';
        String tecnologia = '';
        Dom.XMLNode errorMessageNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'mensajeError');
        Dom.XMLNode coberturaNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Cobertura'); 
        if(errorMessageNode.getText() != ''){
            strErrMessage = errorMessageNode.getText();
            sglLead.Descripcion_cobertura__c =strErrMessage;
            update sglLead;
        }else{
            strErrMessage = errorMessageNode.getText();
            List<Homologacion_Cobertura__mdt> lstHCmdt = [
                SELECT Tipo_Lista__c,Valor_Usuario__c
                FROM Homologacion_Cobertura__mdt
            ];
            
            Map<String, String> mapHCmdt = new Map<String,String>();
            
            for(Homologacion_Cobertura__mdt HCmdt : lstHCmdt){
                mapHCmdt.put(HCmdt.Tipo_Lista__c, HCmdt.Valor_Usuario__c);
            }

            for(Dom.XMLNode child : coberturaNode.getChildElements()){
                if(mapHCmdt.containsKey(child.getName())){ 
                    descripcionCobertura += mapHCmdt.get(child.getName()) + ': '+ child.getText();
                    descripcionCobertura+= '\r\n';
                    if(child.getName() == '_x003C_TipoDistancia_x003E_k__BackingField'){
                        tipoDeDistancia = child.getText();
                    }else if (child.getName() == '_x003C_Tecnologia_x003E_k__BackingField'){
                        tecnologia = child.getText();
                    }
                }
            }
            Dom.XMLNode direccionNormalizadaNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'direccionNormalizada'); 
            descripcionCobertura += 'Dirección normalizada: '+direccionNormalizadaNode.getText();
            System.debug(descripcionCobertura + '--------------');
            sglLead.Descripcion_cobertura__c =descripcionCobertura;
            sglLead.Tipo_de_Distancia__c =tipoDeDistancia;
            sglLead.Tecnologia__c =tecnologia;
            update sglLead;
        }
        return strErrMessage;
    }
    
}