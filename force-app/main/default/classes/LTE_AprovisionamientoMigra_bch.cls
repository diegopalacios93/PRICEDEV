global class LTE_AprovisionamientoMigra_bch implements Database.Batchable<SObject>{
	
	global boolean limitQ=false;
	global integer limiteTotal=30;
	global boolean esVIP=false;
	
	global Database.Querylocator start(Database.Batchablecontext bc)
	{
		
		
		VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
		
		String query = 'SELECT  Id,Plan__c,Name,Activo__c,CuentaCliente__c,CuentaCliente__r.Name,SucursalDestino__r.Direccion__c,SucursalDestino__r.Ciudad__r.Name,SucursalDestino__r.Ciudad__r.Padre__r.Name,SucursalDestino__r.Ciudad__r.CodigoDane__c, CuentaCliente__r.AccountNumber,CuentaCliente__r.OwnerId,CuentaFacturacion__r.LTE_CicloFacturacion__c,CuentaCliente__r.Tipodedocumento__c,CreatedDate,TOPP__r.TipodeOperacionporplan__c,Portacion__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,LTE_PUK__c,LTE_PUK2__c,LTE_PIN__c,LTE_PIN2__c,LTE_IMSI__c,Legalizacion__r.Cuotas__c,LTE_TipoTransaccion__c '
		+'FROM OperacionComercial__c '
		+'WHERE (Estado__c = \'Pendiente migracion\') AND Plan__r.NombredelProducto__r.Name=\''+vGlobal.Valor__c+'\' AND (TOPP__r.TipodeOperacionporplan__c=\'Migracion\') ';
		
		query+=' ORDER BY LastModifiedDate DESC ';
		
		if(limitQ){
			query+=' Limit '+limiteTotal+' ';		
		}
		system.debug('\nConsultaBatch: '+query);
		return Database.getQueryLocator(query);
	}
	
global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
		
		system.debug(scope.size());
		
		List<LogTransacciones__c> logLst=new List<LogTransacciones__c>();
		//Realiza el llamdao
		list<consultaServ> con=new list<consultaServ>();
		
		//Consulta el servicio
		for(OperacionComercial__c col: scope){
		
			try{
				Map<Id,OperacionComercial__c>ocMap=New Map<Id,OperacionComercial__c>();
				col.Estado__c='Exitoso Migracion';
				ocMap.put(col.Id,col);
				LTE_Aprovisionamiento_cls.obtenerEstructurado(ocMap);
				
			}catch(exception e){
				col.Estado__c='Parametrización Fallida';
				LogTransacciones__c logP=new LogTransacciones__c();
				logP.LTE_Operacion_Comercial__c=col.id;
				logP.Name='Error parametrizacion producto '+col.Name;
				logP.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
				logLst.add(logP);
			}
		}
		guardar(con,logLst);
		update scope;

	}
	

	global void guardar(list<consultaServ> con, List<LogTransacciones__c> logLst){
		
		List<OperacionComercial__c> ocLst=new List<OperacionComercial__c>();
		
		for(consultaServ cs: con){
			ocLst.add(cs.oc);
			logLst.add(cs.log);
		}
		Database.SaveResult[] srList =Database.update(ocLst,false);
		
		for(Integer i=0;i<srList.size();i++){
		    
		    if (srList[i].isSuccess()) {
		    }
		    else {
		        for(Database.Error err : srList[i].getErrors()) {
		            logLst[i].Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
		            system.debug(err.getStatusCode() + ': ' + err.getMessage());
		        }
		    }
		}
		system.debug(logLst);
		insert logLst;
		
	}
	
	global void finish(Database.BatchableContext bc){}
	
	global class consultaServ{
		
		public OperacionComercial__c oc;
		public string response='';
		public LogTransacciones__c log=new LogTransacciones__c();
			
		public consultaServ(OperacionComercial__c oc){
			this.oc=oc;
			//consultar();
		}
		/*Consume el servicio web
		public void consultar(){
			
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('DisponibilidadM6');
			map<string,string> values=new map<string,string>();
			string request='';
			string serv='';
			
			request=LTE_Aprovisionamiento_cls.AvailabilitQueryOrder(oc);
			
			response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
			
			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
			
			values=proReq.getMap(response);
						
			if(values.get('status')=='PASS' && values.get('TIBCOResponseCode')=='01'){
				//oc.Estado__c='Pendiente aprovisionar';
				if(values.get('Number')!=null && values.get('Number')!=''){	
					oc.NumeroConexion__c=values.get('Number');
				}
				oc.LTE_PIN__c=values.get('PIN');
				oc.LTE_PIN2__c=values.get('PIN2');
				oc.LTE_PUK__c=values.get('PUK');
				oc.LTE_PUK2__c=values.get('PUK2');
				oc.LTE_IMSI__c=values.get('IMSI');
				
				oc.Estado__c='Exitoso M6';
				log.Estado__c='Exitoso M6';
				//PIN,PUK,PIN2,PUK2
			}else{
				oc.Estado__c='Fallido M6';
				log.Estado__c='Fallido M6';						
			}
			log.Informacion_Enviada__c=request;
			log.Informacion_Recibida__c=response;
			log.LTE_Operacion_Comercial__c=oc.id;
			log.Name='Disponibilidad M6 '+oc.Name;
			if(values.get('TIBCOResponseDescription')!=null){
				log.CodigoRespuesta__c=values.get('TIBCOResponseDescription').abbreviate(250);
			}
			
		}*/
		
	}
    
}