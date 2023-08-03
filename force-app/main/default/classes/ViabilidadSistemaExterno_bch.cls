global class ViabilidadSistemaExterno_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    global Database.Querylocator start(Database.Batchablecontext bc)
	{		
		String query = System.Label.ConsultaVSE;
		System.debug('\n@@-ConsultaBatch: '+query);
		return Database.getQueryLocator(query);
	}
	
		global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
        Map<Id,OperacionComercial__c> mpOCSeleccionadas = new Map<Id,OperacionComercial__c>();
        List<Viabilidad__c> lstViab = new list<Viabilidad__c>();
        list<Viabilidad__c> lstViabtemp = new list<Viabilidad__c>();
        String strMjsErrorValidaciones = '';
        List<OperacionComercial__c> lstOCMarcadas = new List<OperacionComercial__c>();

        Boolean errores = false;
        for(OperacionComercial__c oc: scope){
            mpOCSeleccionadas.put(oc.Id,oc);
            lstOCMarcadas.add(oc);
        }
        
        if(!mpOCSeleccionadas.isEmpty()){
            PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
            Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(mpOCSeleccionadas.keyset(),PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
            for(Id sglRecordId:mapDatos.keyset()){
                List<Map<String,String>> lstErrores = pscls.ValidarCondicionesCamposObligatorios(mapDatos.get(sglRecordId),'Envio_VIA_PS');
                
                if(!lstErrores.isEmpty()){
                     String strMensajeIncompletas = '';
                        for(Map<String,String> sglError:lstErrores){
                            system.debug(mapDatos.get(sglRecordId).get('Name')+' - '+sglError.get('Condicion__c')+' - '+sglError.get('Nivel_Error__c'));
                            if(sglError.get('Condicion__c')=='true' && sglError.get('Nivel_Error__c')=='Error'){
                                strMensajeIncompletas += '<li>' + mapDatos.get(sglRecordId).get('Name') +': '+ sglError.get('Mensaje__c') + '('+ sglError.get('MasterLabel') + ')</li>\n';
                            }
                        }
                        system.debug(strMensajeIncompletas);
                        if(String.isNotEmpty(strMensajeIncompletas))
                            strMjsErrorValidaciones = Label.Operaciones_Comerciales_Incompletas.replace('%1',strMensajeIncompletas);
                    
                }
                if(String.isEmpty(strMjsErrorValidaciones)){
                
                    Viabilidad__c insVia = new Viabilidad__c();
                    if( String.valueOf(mapDatos.get(sglRecordId).get('activo__r.Familia__c')) == 'ENLACES DE VOZ' && String.valueOf(mapDatos.get(sglRecordId).get('TOPP__r.TipodeOperacionporplan__c')) == 'Venta'){
                        insVia.RecordTypeid = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Enlaces_de_Voz').getRecordTypeId();
                    }else
                        insVia.RecordTypeid = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId();
                    
                    if(String.valueOf(mapDatos.get(sglRecordId).get('Plan__r.NombredelProducto__r.Productivizacion__c')) == 'true'){
                        insVia.Aliado__c = String.valueOf(mapDatos.get(sglRecordId).get('Plan__r.NombredelProducto__r.Aliado__c'));
                        insVia.Tipo_de_Aliado__c = Label.Productivizacion1;
                    }
                    insVia.OperacionComercial__c=sglRecordId;
                    insVia.EstadoViabilidad__c=Label.EnvioVia_EstPend;//SR-Modificación de estado En Proceso a Pendiente INI8524
                    insVia.APN__c = String.valueOf(mapDatos.get(sglRecordId).get('APN__c'));
                    lstViab.add(insVia);

                }
            }
            Savepoint sp = Database.setSavepoint();
            try{
                if(!lstOCMarcadas.isEmpty()){
                    BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    update lstOCMarcadas;
                    BanderasEjecucion.unsetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                }
                if(!lstViab.isEmpty()){
                    insert lstViab;
                }
                
            }catch(Exception e){
                Database.rollback(sp);
                system.debug(e.getStackTraceString());
            }
        }else{
           System.debug('Error no existen operaciónes comerciales');
        }

        GenerarIntegracion(strMjsErrorValidaciones,lstViab);
	
	
	}
	global void finish(Database.BatchableContext bc){
		
		//Facturacion_sch.ProgramarJob();
		system.debug('!!!EXITO');
	}

    public void GenerarIntegracion(String strMjsErrorValidaciones,List<Viabilidad__c> lstViab)
    {
        System.debug('GenerarIntegracion');
        Set<Id> lstId = new Set<Id>();
        Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
        PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
        System.debug(strMjsErrorValidaciones);
        if(String.isEmpty(strMjsErrorValidaciones)){
            if(lstViab!=null){
                if(!lstViab.isEmpty()){
                    for(Viabilidad__c sglVia:lstViab){
                        lstId.add(sglVia.Id);
                    }
                    mapDatos = pscls.GenerarDatamapOrdenes(lstId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
                }
                System.debug(lstViab);
                if(lstViab.size()==1){
                    for(Id idTempDatos:mapDatos.keyset()){
                        Map<String,Object> mapTempDatos = mapDatos.get(idTempDatos);
                    //for(Map<String,Object> mapTempDatos:mapDatos.values()){
                        Map<String,Object> mpViabilidadOrigen = (Map<String,Object>)mapTempDatos.get('ViabilidadOrigen');
                        if(String.valueOf(mapTempDatos.get('Integrar_con_gestor__c'))=='true'){
                            Map<Id,String> mpResultado = pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
                            if(mpResultado.containskey(idTempDatos)){
                              
                                
                            }else{
                            }
                            system.debug(mpResultado);
                        }else{
                        }
                    }
                }else{
                    Set<Id> lstIdMasivo = new Set<Id>();
                    for(Id idTempDatos:mapDatos.keyset()){
                        Map<String,Object> mapTempDatos = mapDatos.get(idTempDatos);
                        Map<String,Object> mpViabilidadOrigen = (Map<String,Object>)mapTempDatos.get('ViabilidadOrigen');
                        if(String.valueOf(mapTempDatos.get('Integrar_con_gestor__c'))=='true'){
                            lstIdMasivo.add(String.valueOf(mpViabilidadOrigen.get('Id')));
                        }
                    }
                    BatchGenerico_bch bch = new BatchGenerico_bch();
                    bch.idImediato = lstIdMasivo;
                    bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA;
                    ID batchprocessid = Database.executeBatch(bch,1);
                }
            }
        }else {
        }
       
    } 
}