global class LTE_MigracionParametrizacion_bch implements Database.Batchable<SObject> {
	
	global boolean limitQ=false;
	global integer limiteTotal=30;
	global boolean esVIP=false;
	
	global Database.Querylocator start(Database.Batchablecontext bc)
	{
		
		
		VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
		
		String query = 'SELECT  Id,Name,Activo__c,CuentaCliente__c,CuentaCliente__r.Name,SucursalDestino__r.Direccion__c,SucursalDestino__r.Ciudad__r.Name,SucursalDestino__r.Ciudad__r.Padre__r.Name,SucursalDestino__r.Ciudad__r.CodigoDane__c, CuentaCliente__r.AccountNumber,CuentaCliente__r.OwnerId,CuentaFacturacion__r.LTE_CicloFacturacion__c,CuentaCliente__r.Tipodedocumento__c,CreatedDate,TOPP__r.TipodeOperacionporplan__c,Portacion__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,LTE_PUK__c,LTE_PUK2__c,LTE_PIN__c,LTE_PIN2__c,LTE_IMSI__c,Legalizacion__r.Cuotas__c,LTE_TipoTransaccion__c '
		+'FROM OperacionComercial__c '
		+'WHERE (Estado__c = \'Exitoso Migracion\') AND Plan__r.NombredelProducto__r.Name=\''+vGlobal.Valor__c+'\' AND (TOPP__r.TipodeOperacionporplan__c=\'Migracion\') ';
		
		if(esVIP){
			query+=' AND LTE_AplicaOnline__c=true ';
		}
		
		query+=' ORDER BY LastModifiedDate DESC ';
		
		if(limitQ){
			query+=' Limit '+limiteTotal+' ';		
		}
		system.debug('\nConsultaBatch: '+query);
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){

		VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreFacturacionLTE');
		Map<Id,string>parentMaId=new Map<Id,string>();
		
		set<Id> ocIds=new set<Id>();
		
		for(OperacionComercial__c oc:scope){
			ocIds.add(oc.id);
			system.debug(oc.id);
		}
		
		list<LTE_Servicios_adicionales__c> sAdicionales=new list<LTE_Servicios_adicionales__c>([SELECT Id,LTE_CatalogoProducto__c,LTE_DetalleOfertaEReservadoRegContable__c,LTE_Estado__c,LTE_ItemIdentification__c,LTE_NetworkIndicator__c,LTE_ParentId__c,LTE_PlanFacturacion__c,LTE_PrimaryClassificationCode__c,LTE_ServiceActionCode__c,LTE_ServiceIndicator__c,LTE_ServicioETB__c,LTE_SubPlaFacturacion__c,LTE_TypeCode__c,Name,
		LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Direccion__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Padre__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.CodigoDane__c,
		LTE_NivelDescuento__r.LTE_DescuentoNivel1__c,
		LTE_NivelDescuento__r.LTE_DescuentoNivel2__c,
		LTE_NivelDescuento__r.LTE_DescuentoNivel3__c,
		LTE_NivelDescuento__r.LTE_Indice__c,
		LTE_NivelDescuento__r.LTE_NoCuotasNivel1__c,
		LTE_NivelDescuento__r.LTE_NoCuotasNivel2__c,
		LTE_NivelDescuento__r.LTE_NoCuotasNivel3__c,
		LTE_NivelDescuento__r.LTE_Nombre__c,
(select id,Name,LTE_Value__c,LTE_ServiciosAdicionales__c,LTE_ActionCode__c,LTE_ParametroFacturacion__r.Campo__c,LTE_ParametroFacturacion__r.Objeto__c
		from SpecificationGroupXA__r) 
		FROM LTE_Servicios_adicionales__c
		Where LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c=:ocIds and LTE_ServiceActionCode__c!='DELETE'
		]);

		List<LTE_DetalleOferta__c> detOf =new list<LTE_DetalleOferta__c>([select
			Id,LTE_OperacionComercial__c,LTE_ReferenciaEquipo__r.LTE_Marca__c,LTE_ReferenciaEquipo__r.LTE_ModeloComercial__c,LTE_ReferenciaEquipo__r.LTE_PartNumber__c,LTE_EsPortabilidad__c
			from LTE_DetalleOferta__c where LTE_OperacionComercial__c=:ocIds]);
		map<Id,LTE_DetalleOferta__c> doMap=new map<Id,LTE_DetalleOferta__c>();

		for(LTE_DetalleOferta__c dof:detOf){
			doMap.put(dof.LTE_OperacionComercial__c,dof);
		}



		
		system.debug(sAdicionales);
		set<Id> parametros=new set<Id>(); 
		
		map<id,list<LTE_Servicios_adicionales__c>> serVad=new map<id,list<LTE_Servicios_adicionales__c>>();
		
		for(LTE_Servicios_adicionales__c sa:sAdicionales){
			Id idOc=sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c;
			if(serVad.get(idOc)==null){
				serVad.put(idOc,new list<LTE_Servicios_adicionales__c>());
			}
			serVad.get(idOc).add(sa);
			system.debug('Name sales'+sa.Name+' - '+vGlobal.Valor__c);
			if(sa.Name==vGlobal.Valor__c){
				parentMaId.put(idOc,sa.id);
			}
		}
		
		map<Id,String> xmlS=new map<Id,String>();
		list<consultaServ> cs=new list<consultaServ>();
		List<LTE_SpecificationGroupXA__c> lstSgXa=new list<LTE_SpecificationGroupXA__c>();
		
		for(OperacionComercial__c oc:scope){
			ocIds.add(oc.id);
			LTE_Aprovisionamiento_cls.SalesOrdelineXML sX =new LTE_Aprovisionamiento_cls.SalesOrdelineXML(serVad.get(oc.Id),oc,doMap.get(oc.Id),parentMaId,new list<LTE_Servicios_adicionales__c>());
			//system.debug(sX.getBody().replace('>null<', '><'));
			cs.add(new consultaServ(oc,sX.getBody().replace('>null<', '><')));
			lstSgXa.addAll(sx.lstSgXa);
		}
		guardar(cs,lstSgXa);
		
	
	
	}
	
	global void finish(Database.BatchableContext bc)
	{
		List<LTE_Servicios_adicionales__c> lstServicioAdicional = [SELECT Id,LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Activo__c,LTE_ServicioETB__c 
										FROM LTE_Servicios_adicionales__c 
										WHERE LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Estado__c = 'Migrado' 
										AND LTE_ServicioETB__c = null];
		for
		(LTE_Servicios_adicionales__c sa:lstServicioAdicional){
				sa.LTE_ServicioETB__c=sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Activo__c;
		}
		update lstServicioAdicional;
	}
	
	global class consultaServ{
		
		public OperacionComercial__c oc;
		public string response;
		public string request;
		public LogTransacciones__c log=new LogTransacciones__c();
			
		public consultaServ(OperacionComercial__c oc,string request){
			this.oc=oc;
			this.request=request;
			consultar();
		}
		//Consume el servicio web
		public void consultar()
		{
			oc.Estado__c='Migrado';
		}
		
	}
	
	global void guardar(list<consultaServ> con,List<LTE_SpecificationGroupXA__c> lstSgXa){
		
		List<OperacionComercial__c> ocLst=new List<OperacionComercial__c>();
		List<LogTransacciones__c> logLst=new List<LogTransacciones__c>();
		
		for(consultaServ cs: con){
			ocLst.add(cs.oc);
			logLst.add(cs.log);
		}
		
		Database.SaveResult[] srSgXA =Database.update(lstSgXa,false);
		Database.SaveResult[] srList =Database.update(ocLst,false);
		
		for(Integer i=0;i<srList.size();i++){
		    
		    if (srList[i].isSuccess()) {
		    }
		    else {
		        for(Database.Error err : srList[i].getErrors()) {
		            logLst[i].Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
		        }
		    }
		}
		
		insert logLst;
		
	}


}