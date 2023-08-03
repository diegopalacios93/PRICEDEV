/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Proyecto:               ETB Portafolio Superior
Descripción:            Controlador de la página EnvioViabilidadOportunidad_pag encargado de enviar la solicitud de generación de viabilidad
                        de la oportunidad.
                        

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     23-04-2018  Fernando Sarasty (FS)       Creación de la clase.
*******************************************************************************/
public with sharing class PS_EnvioViabilidadOportunidad_ctr{
    
    public map<string,string> mapParameters;
    public list<Opportunity> lstOpportunity {get;set;}
    public list<LogTransacciones__c> lstLogTransacciones = new list<LogTransacciones__c>();
    Viabilidad__c insVia = new Viabilidad__c();
    Viabilidad__c objViaAux = new Viabilidad__c();
    public string strNombreOpp{get;set;}
    public string id, strIdOpp, consecutivoOP, nombreViabilidad, idViabilidad;
    public Opportunity objOp;
    public boolean blnLista{get;set;}
    public boolean blnLista2{get;set;}
    public boolean blnBtnCrear{get;set;}
    public boolean integracionHabilitada;
    public string strMjsErrorValidaciones;
    list<Viabilidad__c> lstViab;
    
    public PS_EnvioViabilidadOportunidad_ctr(){}
    
    public pageReference Iniciar(){
        strMjsErrorValidaciones = '';
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        id = mapParameters.get('id');
        objOp = new Opportunity();
        objOp = [SELECT Integrar_con_gestor__c,RecordType.Name,Tipo_de_Oportunidad__c,LTE_NumeroLinea__c, Consecutivooportunidades__c, Name FROM Opportunity where Id =: id];
        consecutivoOP 			= objOp.Consecutivooportunidades__c;
        strNombreOpp 			= objOp.Name;
        integracionHabilitada	= objOp.Integrar_con_gestor__c;
        Integer CantMinimaLTE = 0;
        List<LV_Simple__mdt> lstLVSimple = [SELECT DeveloperName,Valor__c FROM LV_Simple__mdt WHERE DeveloperName = 'RV_OP_CantidadMinimaLTE_VIAConsultiva'];
        if(!lstLVSimple.isEmpty()){
            if(lstLVSimple[0].Valor__c.isNumeric())
                CantMinimaLTE = integer.valueof(lstLVSimple[0].Valor__c);
        }
        if(objOp.RecordType.Name == 'LTE' && (objOp.LTE_NumeroLinea__c<CantMinimaLTE || objOp.LTE_NumeroLinea__c == null)){
            blnBtnCrear=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'La Oportunidad pertenece al segmento LTE y por la cantidad de lineas no requiere que se envie una Viabilidad'));
        }else{
            if(integracionHabilitada){
                //Refuerzo de actualizacion para el campo Tipo de oportunidad. Dependiendo de este campo se agregan los campos
                //dinamicos en la viabilidad consultiva
                if(objOp.RecordType.Name == 'LTE' && objOp.Tipo_de_Oportunidad__c!= 'LTE'){
                    objOp.Tipo_de_Oportunidad__c = 'LTE';
                    update objOp;
                }
                integer cantVia = buscarViabilidadesDeLaOportunidad(id);
                strIdOpp = id;
                blnLista=true;
                blnLista2=false;
                blnBtnCrear=true;
                system.debug('DEBUG=>Id='+id);
                if(cantVia > 0)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.ViabilidadesExistentes.replace('%cantVia%',String.valueOf(cantVia))));
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioVia_ConfirmacionOportunidad));
            }else{
                blnLista = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioVia_Integracion_DeshabilitadaOp));
            }
        }
        return null;
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(id!=null){
            p = new PageReference('/'+id);
        }
        return p;
    }
    
    public pageReference Crear(){
        strMjsErrorValidaciones = '';
        lstViab = new list<Viabilidad__c>();
        try{
            Set<String> lstCampoParam = new Set<String>();
            String sObjetoBase = 'Opportunity';
            Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Oportunidad Gestor PS'];
            String sFields = lstMensajes.Mensaje__c;
            for(String sglfieldname:sFields.split(',')){
                lstCampoParam.add(sglfieldname.trim());
            }
            String joinedString = String.join(new List<String>(lstCampoParam), ',');
            String sql = 'SELECT '+joinedString+' FROM '+ sObjetoBase+' WHERE Id = :id';
            List<SObject> lstObjetos = Database.query(sql);
            Map<Id,Map<String,Object>> mapDatos = PS_IntegrationHelper_ctr.PopulateMap(sObjetoBase, lstCampoParam, lstObjetos, 'yyyy-MM-dd\'T\'HH:mm:ssXXX');
            
            PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
            for(Id sglRecordId:mapDatos.keyset()){
                List<Map<String,String>> lstErrores = pscls.ValidarCondicionesCamposObligatorios(mapDatos.get(sglRecordId),'Envio_VIA_Consultiva_PS');
                if(!lstErrores.isEmpty()){
                    String strMensajeIncompletas = '';
                    for(Map<String,String> sglError:lstErrores){
                        if(sglError.get('Condicion__c')=='true' && sglError.get('Nivel_Error__c')=='Error'){
                            strMensajeIncompletas += '<li>' + mapDatos.get(sglRecordId).get('Name') +': '+ sglError.get('Mensaje__c') + '('+ sglError.get('MasterLabel') + ')</li>\n';
                        }
                    }
                    if(String.isNotEmpty(strMensajeIncompletas))
                        strMjsErrorValidaciones = Label.Operaciones_Comerciales_Incompletas.replace('%1',strMensajeIncompletas);
                }
                if(String.isEmpty(strMjsErrorValidaciones)){
                    Viabilidad__c insVia = new Viabilidad__c();
                    insVia.RecordTypeid = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Consultiva').getRecordTypeId();
                    insVia.EstadoViabilidad__c=Label.EnvioVia_EstEnProceso;
                    insVia.Oportunidad__c = id;
                    lstViab.add(insVia);
                }
            }
            Savepoint sp = Database.setSavepoint();
            try{
                if(!lstViab.isEmpty()){
                    insert lstViab;
                }
            }catch(Exception e){
                Database.rollback(sp);
                system.debug(e.getStackTraceString());
                strMjsErrorValidaciones = e.getMessage();
            }
        } catch(Exception e){
            strMjsErrorValidaciones = e.getMessage();
            System.Debug('====================== EXCEPTION ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=======================================================');
        }
        blnLista  = false;
        blnLista2 = true;
        return null;
    }
    
    public pageReference GenerarIntegracion()
    {
        system.debug('GenerarIntegracion');
        Set<Id> lstId = new Set<Id>();
        Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
        PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
        if(String.isEmpty(strMjsErrorValidaciones)){
            system.debug('strMjsErrorValidaciones');
            if(lstViab!=null){
                if(!lstViab.isEmpty()){
                    for(Viabilidad__c sglVia:lstViab){
                        lstId.add(sglVia.Id);
                    }
                    system.debug('mapDatos');
                    system.debug(lstId);
                    mapDatos = pscls.GenerarDatamapOrdenes(lstId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_CONSULTIVA);                    
                    system.debug(mapDatos);
                    for(Id idTempDatos:mapDatos.keyset()){
                        Map<String,Object> mapTempDatos = mapDatos.get(idTempDatos);
                        Map<String,Object> mpViabilidadOrigen = (Map<String,Object>)mapTempDatos.get('ViabilidadOrigen');
                        system.debug('Integrar_con_gestor__c');
                        system.debug(mapTempDatos.get('Integrar_con_gestor__c'));
                        if(String.valueOf(mapTempDatos.get('Integrar_con_gestor__c'))=='true'){
                            Map<Id,String> mpResultado = pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_CONSULTIVA);
                            if(mpResultado.containskey(idTempDatos)){
                                if(String.isEmpty(mpResultado.get(idTempDatos))){
                                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_OP_integracion_Gestor.replace('%NombreViabilidad%',String.valueOf(mpViabilidadOrigen.get('Name')))).replace('%nro_oc%',String.valueOf(mapTempDatos.get('Consecutivooportunidades__c')))).replace('%Identificador%','Envio Exitoso')));
                                }else{
                                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,mpResultado.get(idTempDatos)));
                                }
                            }else{
                                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Error no controlado'));
                            }
                            system.debug(mpResultado);
                        }else{
                            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,Label.Mensaje_ok_creacion_VIA_Consul_sin_integ));
                        }
                    }
                }
            }
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMjsErrorValidaciones));
        }
        blnLista  = false;
        blnLista2 = true;
        return null;
    }
    
    public static Integer buscarViabilidadesDeLaOportunidad(String idOportunidad)
    {
        List<Viabilidad__c> lstViabilidades = new List<Viabilidad__c>();
        Integer cantVia = 0;
        lstViabilidades  = [Select id
                            From Viabilidad__c
                            Where Oportunidad__r.id =: idOportunidad];
        for(Viabilidad__c objVia : lstViabilidades)
            cantVia ++;
        return cantVia;
    }
}