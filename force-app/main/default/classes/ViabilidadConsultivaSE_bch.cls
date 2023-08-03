global class ViabilidadConsultivaSE_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    global Database.Querylocator start(Database.Batchablecontext bc)
	{		
		String query = System.Label.ConsultaViabilidadConsultivaCSC;
		System.debug('\n@@-ConsultaBatch: '+query);
		return Database.getQueryLocator(query);
	}
	
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){


        String strMjsErrorValidaciones = '';
        List<Viabilidad__c> lstViab = new list<Viabilidad__c>();

        for(Opportunity opp :scope){
            try{
                Set<String> lstCampoParam = new Set<String>();
                String sObjetoBase = 'Opportunity';
                Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Oportunidad Gestor PS'];
                String sFields = lstMensajes.Mensaje__c;
                for(String sglfieldname:sFields.split(',')){
                    lstCampoParam.add(sglfieldname.trim());
                }
                String joinedString = String.join(new List<String>(lstCampoParam), ',');
                String sql = 'SELECT '+joinedString+' FROM '+ sObjetoBase+' WHERE Id ='+ '\''+opp.id + '\'';
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
                        insVia.Oportunidad__c = opp.id;
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
            GenerarIntegracion(strMjsErrorValidaciones,lstViab);
        }
	
	}
	global void finish(Database.BatchableContext bc){
		
		system.debug('!!!EXITO');
	}

    public void GenerarIntegracion(String strMjsErrorValidaciones,List<Viabilidad__c> lstViab )
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
                
                            system.debug(mpResultado);
                        }else{
                        }
                    }
                }
            }
        }
        else {
            
        }
    }
}