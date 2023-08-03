trigger Fidelizacion_Servicio_tgr on Fidelizacion_Servicio__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	
	
	if(!BanderasEjecucion.ValidarEjecucion('Fidelizacion_Servicio_tgr')){
		
		Fidelizacion_Servicio_cls fd=new Fidelizacion_Servicio_cls();

		if (trigger.isBefore) {
	        //  Bloque de ejecución Before Insert
	        if (trigger.isInsert) {
	            
                Map<String,Object> mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Homologacion_Gestor__mdt','');
                Boolean blnEnvioIntegracion = PS_IntegracionSalidaGestor_cls.validarUsuarioLV(userinfo.getUserId(),(List<Map<String,String>>)mpListaValores.get('PER_ALARMA_RETENCION'),'Valor_API__c');
                
                Set<Id> lstServicioRelacionado = new Set<Id>();
                Map<Id,ActivoETB__c> mapServicioRelacionado = new Map<Id,ActivoETB__c>();
                for (Fidelizacion_Servicio__c sglRetencionServicio : trigger.new) {
                    if(sglRetencionServicio.Servicio_ETB__c != null){
                        lstServicioRelacionado.add(sglRetencionServicio.Servicio_ETB__c);
                    }
                }
                if(!lstServicioRelacionado.isEmpty()){
                	mapServicioRelacionado = new Map<Id,ActivoETB__c>([SELECT Id, Name, ProveedorUM__c,NombredelProducto__c,NombredelProducto__r.Name,NombredelProducto__r.Catalogo__c,Plan__r.TipodePlan__c,Plan__r.Plan_Troncales_Sip_Movil__c FROM ActivoETB__c WHERE Id IN :lstServicioRelacionado]);
                }
                for (Fidelizacion_Servicio__c sglRetencionServicio : trigger.new) {
                    if(sglRetencionServicio.Servicio_ETB__c!=null && !mapServicioRelacionado.isEmpty()){
                        if(mapServicioRelacionado.containskey(sglRetencionServicio.Servicio_ETB__c)){
                            if(sglRetencionServicio.Estado_de_cierre__c == 'En curso con aliado' && !blnEnvioIntegracion){
                                if(sglRetencionServicio.Servicio_ETB__c != null){
                                    if(mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).ProveedorUM__c == null || mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).ProveedorUM__c == 'ETB'){
                                        sglRetencionServicio.addError('ARV_01 El estado \'En curso con aliado\' no esta disponible para este servicio debido al valor que posee en el campo Proveedor UM');
                                    }else if(!(mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).NombredelProducto__r.Catalogo__c == 'Portafolio Superior' || mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).Plan__r.TipodePlan__c == 'Troncal SIP' || (mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).Plan__r.TipodePlan__c == 'Principal' && mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).Plan__r.Plan_Troncales_Sip_Movil__c == true))){
                                        sglRetencionServicio.addError('ARV_02 El estado \'En curso con aliado\' no esta disponible para este servicio debido al tipo de producto');
                                    }
                                }else{
                                    sglRetencionServicio.addError('ARV_02 El estado \'En curso con aliado\' no esta disponible ya que la retencion no posee un servicio asociado');
                                }
                            }
                        }
                    }
                }
	        }
	        //  Bloque de ejecución Before Update
	        if (trigger.isUpdate){
	            
                Map<String,Object> mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Homologacion_Gestor__mdt','');
                Boolean blnEnvioIntegracion = PS_IntegracionSalidaGestor_cls.validarUsuarioLV(userinfo.getUserId(),(List<Map<String,String>>)mpListaValores.get('PER_ALARMA_RETENCION'),'Valor_API__c');
                
                Set<Id> lstServicioRelacionado = new Set<Id>();
                Map<Id,ActivoETB__c> mapServicioRelacionado = new Map<Id,ActivoETB__c>();
                for (Fidelizacion_Servicio__c sglRetencionServicio : trigger.new) {
                    if(sglRetencionServicio.Servicio_ETB__c != null){
                        lstServicioRelacionado.add(sglRetencionServicio.Servicio_ETB__c);
                    }
                }
                if(!lstServicioRelacionado.isEmpty()){
                	mapServicioRelacionado = new Map<Id,ActivoETB__c>([SELECT Id, Name, ProveedorUM__c,NombredelProducto__c,NombredelProducto__r.Name,NombredelProducto__r.Catalogo__c,Plan__r.TipodePlan__c,Plan__r.Plan_Troncales_Sip_Movil__c FROM ActivoETB__c WHERE Id IN :lstServicioRelacionado]);
                }
                for (Fidelizacion_Servicio__c sglRetencionServicio : trigger.new) {
                    if(sglRetencionServicio.Servicio_ETB__c!=null && !mapServicioRelacionado.isEmpty()){
                        if(mapServicioRelacionado.containskey(sglRetencionServicio.Servicio_ETB__c)){
                            if(sglRetencionServicio.Estado_de_cierre__c == 'En curso con aliado' && !blnEnvioIntegracion){
                                if(sglRetencionServicio.Servicio_ETB__c != null){
                                    if(mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).ProveedorUM__c == null || mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).ProveedorUM__c == 'ETB'){
                                        sglRetencionServicio.addError('ARV_01 El estado \'En curso con aliado\' no esta disponible para este servicio debido al valor que posee en el campo Proveedor UM');
                                    }else if(!(mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).NombredelProducto__r.Catalogo__c == 'Portafolio Superior' || mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).Plan__r.TipodePlan__c == 'Troncal SIP' || (mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).Plan__r.TipodePlan__c == 'Principal' && mapServicioRelacionado.get(sglRetencionServicio.Servicio_ETB__c).Plan__r.Plan_Troncales_Sip_Movil__c == true))){
                                        sglRetencionServicio.addError('ARV_02 El estado \'En curso con aliado\' no esta disponible para este servicio debido al tipo de producto');
                                    }
                                }else{
                                    sglRetencionServicio.addError('ARV_02 El estado \'En curso con aliado\' no esta disponible ya que la retencion no posee un servicio asociado');
                                }
                            }
                        }
                    }
                }
	        }
	        //  Bloque de ejecución Before Delete
	        if (trigger.isDelete) {
	
	        }
	    }
	    
	    //  Bloque de ejecución After
	    if (trigger.isAfter) {
	        //  Bloque de ejecución After Insert
	        if (trigger.isInsert) {
	        	fd.crearOcActivos(trigger.new);	
	        }
	        //  Bloque de ejecución After Update
	        if (trigger.isUpdate) {
                List<Id> lstRetencionServicioCierre = new List<Id>();
                Map<Id,OperacionComercial__c> mapOC = new Map<Id,OperacionComercial__c>();
                for (Fidelizacion_Servicio__c sglRetencionServicio : trigger.new) {                
                    if(sglRetencionServicio.Estado_de_cierre__c == 'No exitosa' || sglRetencionServicio.Estado_de_cierre__c == 'En curso con aliado'){
                        lstRetencionServicioCierre.add(sglRetencionServicio.Id);
                    }
                }
                if(!lstRetencionServicioCierre.isEmpty()){
                    mapOC = new Map<Id,OperacionComercial__c>([SELECT Id FROM OperacionComercial__c WHERE Fidelizacion__c IN :lstRetencionServicioCierre AND EstadoAprovisionamiento__c = 'En Aprovisionamiento' AND CausalRetiro__c != 'Migración Tecnológica']);
                }
                if(!mapOC.isEmpty()){
                    BatchGenerico_bch bch = new BatchGenerico_bch();
                    bch.idImediato = mapOC.keyset();
                    bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.RETENCION;
                    ID batchprocessid = Database.executeBatch(bch,1);
                }
	        }
	        //  Bloque de ejecución After Delete
	        if (trigger.isDelete) {
	            
	        }
	        //  Bloque de ejecución After Undelete
	        if (trigger.isUndelete) {
	
	        }
	
	    }
		//BanderasEjecucion.setEjecucion('Fidelizacion_Servicio_tgr');
	}


}