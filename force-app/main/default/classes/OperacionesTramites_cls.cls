/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase con la logica para la creacion de las OCs para tramites
                         por causal de Pago y causal ente Controlador.
						 
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     12-08-2015   Sergio Ortiz                	Creación de la clase.
**************************************************************************************/
public with sharing class OperacionesTramites_cls {

	//Metodo Para el llamado a crear los OCs para los servicios asociados a la cuenta de facturacion del tramite.
	public void  CrarOperacionesComercialesTramites(List<Tramites__c> lstTramites) {

		System.debug('@@-lstTramites->'+lstTramites);
		Map<String, Tramites__c> mapTramitesPago            = new Map<String, Tramites__c>();
		Map<String, Tramites__c> mapTramitesEnteControlador = new Map<String, Tramites__c>();
		Set<String> setCuentasFacturacionSuspensionPago     = new Set<String>();
		Set<String> setCuentasFacturacionReconexionPago     = new Set<String>();
		Set<String> setCuentasFacturacionRetiroPago         = new Set<String>();
		Set<String> setCuentasFacturacionSuspensionEnteControlador    = new Set<String>();
		Set<String> setCuentasFacturacionReconexionEnteControlador    = new Set<String>();
		Set<String> setCuentasFacturacionRetiroEnteControlador        = new Set<String>();
		

		//Seleccionar los tipos de registro para tramites y asignarlos en un mapa
		List<RecordType> lstTipoRegistroTramites = [SELECT Id,Name,DeveloperName FROM RecordType WHERE SobjectType = 'Tramites__c'];
		System.debug('@@-lstTipoRegistroTramites ->'+lstTipoRegistroTramites);
		Map<String, String> mapTipoRegistroTramites = new Map<String, String>();

		for(RecordType objTipoRegistro: lstTipoRegistroTramites) {
			String strRecordTypeName = objTipoRegistro.Name;
			if(strRecordTypeName.toLowerCase().contains('pago'))
				mapTipoRegistroTramites.put('pago', objTipoRegistro.Id);
			if(strRecordTypeName.toLowerCase().contains('controlador'))
				mapTipoRegistroTramites.put('controlador', objTipoRegistro.Id);
		}
		System.debug('@@-mapTipoRegistroTramites->'+mapTipoRegistroTramites);

		//recorrer la lista de tramites y crear un set para cada tipo de tramite y un mapa para los dos tipos de causal.
		for(Tramites__c objTramites: lstTramites) {
			String strOrigenTramite = objTramites.OrigenTramite__c;
			objTramites.Estado__c   = 'No Exitoso';
			if(strOrigenTramite.toLowerCase().contains('pago')){
				objTramites.RecordTypeId = mapTipoRegistroTramites.get('pago');
				if (objTramites.TipoDeTramite__c == 'Suspensión') 			    				
					setCuentasFacturacionSuspensionPago.add(objTramites.CuentaDeFacturacion__c);
				if (objTramites.TipoDeTramite__c == 'Reconexión') 			    				
					setCuentasFacturacionReconexionPago.add(objTramites.CuentaDeFacturacion__c);
				if (objTramites.TipoDeTramite__c == 'Retiro') 			    				
					setCuentasFacturacionRetiroPago.add(objTramites.CuentaDeFacturacion__c);
				mapTramitesPago.put(objTramites.CuentaDeFacturacion__c, objTramites);
				
			}
			if(strOrigenTramite.toLowerCase().contains('controlador')){
				objTramites.RecordTypeId = mapTipoRegistroTramites.get('controlador');
				if (objTramites.TipoDeTramite__c == 'Suspensión') 
					setCuentasFacturacionSuspensionEnteControlador.add(objTramites.CuentaDeFacturacion__c);
				if (objTramites.TipoDeTramite__c == 'Reconexión') 			    				
					setCuentasFacturacionReconexionEnteControlador.add(objTramites.CuentaDeFacturacion__c);
				if (objTramites.TipoDeTramite__c == 'Retiro') 			    				
					setCuentasFacturacionRetiroEnteControlador.add(objTramites.CuentaDeFacturacion__c);
				mapTramitesEnteControlador.put(objTramites.CuentaDeFacturacion__c, objTramites);
			}
		}

		//Lista de Servicios/Activos relacionados a la cuenta de facturacion para tramites de Suspension
		List<ActivoETB__c> lstActivosTramitesSuspension = [SELECT 
		  					Id,CuentaFacturacion__c,CuentaFacturacion__r.Name,NombredelaCuenta__r.Name, 
		  					Name,NombredelProducto__r.Name,Oportunidad__c,Oportunidad__r.Name,
		  					SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,
		  					NombredelProducto__c,NombredelaCuenta__c,IDservicio__c,Estado__c
		  					FROM ActivoETB__c 
		  					WHERE (CuentaFacturacion__r.Name IN: setCuentasFacturacionSuspensionPago
		  					OR CuentaFacturacion__r.Name IN: setCuentasFacturacionSuspensionEnteControlador)
							AND Estado__c = 'Activo'];

		//Lista de Servicios/Activos relacionados a la cuenta de facturacion para tramites de Reconexion
		List<ActivoETB__c> lstActivosTramitesReconexion = [SELECT 
		  					Id,CuentaFacturacion__c,CuentaFacturacion__r.Name,NombredelaCuenta__r.Name, 
		  					Name,NombredelProducto__r.Name,Oportunidad__c,Oportunidad__r.Name,
		  					SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,
		  					NombredelProducto__c,NombredelaCuenta__c,IDservicio__c,Estado__c
		  					FROM ActivoETB__c 
		  					WHERE (CuentaFacturacion__r.Name IN: setCuentasFacturacionReconexionPago
		  					OR CuentaFacturacion__r.Name IN: setCuentasFacturacionReconexionEnteControlador)
							AND Estado__c = 'Suspendido'];

		//Lista de Servicios/Activos relacionados a la cuenta de facturacion para tramites de Retiro
		List<ActivoETB__c> lstActivosTramitesRetiro = [SELECT 
		  					Id,CuentaFacturacion__c,CuentaFacturacion__r.Name,NombredelaCuenta__r.Name, 
		  					Name,NombredelProducto__r.Name,Oportunidad__c,Oportunidad__r.Name,
		  					SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,
		  					NombredelProducto__c,NombredelaCuenta__c,IDservicio__c,Estado__c
		  					FROM ActivoETB__c 
		  					WHERE (CuentaFacturacion__r.Name IN: setCuentasFacturacionRetiroPago
		  					OR CuentaFacturacion__r.Name IN: setCuentasFacturacionRetiroEnteControlador)
							AND (Estado__c = 'Suspendido' OR Estado__c = 'Activo')];
		

		// Crear Operaciones Comerciales (OC)  para los tramite de Suspension.
		if(!lstActivosTramitesSuspension.isEmpty())
			CrearOC(lstActivosTramitesSuspension, mapTramitesPago, mapTramitesEnteControlador);

		// Crear Operaciones Comerciales (OC)  para los tramite de Reconexion.
		if(!lstActivosTramitesReconexion.isEmpty())
			CrearOC(lstActivosTramitesReconexion, mapTramitesPago, mapTramitesEnteControlador);

		// Crear Operaciones Comerciales (OC)  para los tramite de Retiro.
		if(!lstActivosTramitesRetiro.isEmpty())
			CrearOC(lstActivosTramitesRetiro, mapTramitesPago, mapTramitesEnteControlador);

	}


	//Metodo que retorna un mapa con los Tipos de operacion por plan para suspension, reconexion y retiro.
	public Map<string,Topp__c> topps(set<Id> producto){
			
		Map<string,Topp__c> mapTopp=new Map<string,Topp__c>(); 		
		List<Topp__c> lstTOPP =new List<Topp__c>([SELECT Name,Id,TipodeOperacionporplan__c,Plan__c,Plan__r.NombredelProducto__c,Tipoderegistro__c 
											FROM  Topp__c 
											WHERE Plan__r.NombredelProducto__c IN :producto 
											AND TipodeOperacionporplan__c IN ('Suspensión','Reconexión','Retiro')]);
		
		for(Topp__c objTopp: lstTOPP){
			mapTopp.put(objTopp.Plan__c+''+objTopp.TipodeOperacionporplan__c,objTopp);			
		}
		return mapTopp;			
	}


	//Metodo para la creacion de las OC
	public void CrearOC(List<ActivoETB__c> lstActivosTramites, Map<String, Tramites__c> mapTramitesPago, Map<String, Tramites__c> mapTramitesEnteControlador){

		//formar un set con los productos de los servicios para la busqueda y asignacion del TOPP
		Set<Id> setProductosId               = new Set<Id>();
		for(ActivoETB__c objActivoCP: lstActivosTramites) {
			setProductosId.add(objActivoCP.NombredelProducto__c);
		}
		
		//mapa del tipo de operacion por plan
		Map<string,Topp__c> mapaTopp = topps(setProductosId); 
		System.debug('@@-mapaTopp->'+mapaTopp);

		//Mapa con los tipos de registro para la operacion comercial para asignar segun el TOPP
		Map<string,Schema.RecordTypeInfo> mapTipoRegistro = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();
		
		// Crear Operaciones Comerciales (OC)  para cada servicio , dependiendo del tipo de tramite.
		Map<String, OperacionComercial__c> mapOperacionesComercialesTramites = new Map<String, OperacionComercial__c>();
		for(ActivoETB__c objActivoCP: lstActivosTramites) {
			String strTipoOperacionPorPlan 	 = '';
			String strTipoTramite 			 = '';
			OperacionComercial__c objOC      = new OperacionComercial__c();
			objOC.Activo__c                  = objActivoCP.Id;
			objOC.CuentaCliente__c           = objActivoCP.NombredelaCuenta__c;
			objOC.SucursalOrigen__c          = objActivoCP.SucursalOrigen__c;
			objOC.SucursalDestino__c         = objActivoCP.SucursalDestino__c;
			objOC.Plan__c                    = objActivoCP.Plan__c;			
			objOC.IDServicio__c              = objActivoCP.IDservicio__c;
			objOC.NumeroConexion__c          = objActivoCP.NumeroConexion__c;	
			objOC.CuentaFacturacion__c       = objActivoCP.CuentaFacturacion__c;
			objOC.AnchoBanda__c 			 = objActivoCP.AnchoBanda__c;
			objOC.Estado__c 				 = 'En Curso';
			//Asignar el tipo de Operacion y el tipo de tramite segun la causal por pago
			if(mapTramitesPago.containsKey(objActivoCP.CuentaFacturacion__r.Name)){
				strTipoTramite               = mapTramitesPago.get(objActivoCP.CuentaFacturacion__r.Name).TipoDeTramite__c;												
				if (strTipoTramite.contains('Suspensión')) { 
					objOC.TipoSuspension__c	 = 'Por pago';
					strTipoOperacionPorPlan  = 'Suspensión';	
				}	
				if (strTipoTramite.contains('Reconexión')) {
					objOC.TipoSuspension__c	 = 'Por pago';
					strTipoOperacionPorPlan  = 'Reconexión';
				}
				if (strTipoTramite.contains('Retiro')) {
					objOC.CausalRetiro__c	 = 'Por Falta de Pago';
					strTipoOperacionPorPlan  = 'Retiro';				
				}
			}
			//Asignar el tipo de Operacion y el tipo de tramite segun la causal por ente controlador
			if(mapTramitesEnteControlador.containsKey(objActivoCP.CuentaFacturacion__r.Name)){
				strTipoTramite               = mapTramitesEnteControlador.get(objActivoCP.CuentaFacturacion__r.Name).TipoDeTramite__c;
				if (strTipoTramite.contains('Suspensión')){ 
					objOC.TipoSuspension__c	 = 'Por ente controlador';
					strTipoOperacionPorPlan  = 'Suspensión';	
				}	
				if (strTipoTramite.contains('Reconexión')) {
					objOC.TipoSuspension__c	 = 'Por ente controlador';
					strTipoOperacionPorPlan  = 'Reconexión';
				}
				if (strTipoTramite.contains('Retiro')) {
					objOC.CausalRetiro__c	 = 'Por Ente de Control y Vigilancia';
					strTipoOperacionPorPlan  = 'Retiro';				
				}
			}			

			//Asignar el TOPP y el Tipo de Registro
			if(mapaTopp.containsKey(objOC.Plan__c+strTipoOperacionPorPlan)){
				System.debug('@@-mapaTopp.get(objOC.Plan__c+strTipoOperacionPorPlan).id->'+mapaTopp.get(objOC.Plan__c+strTipoOperacionPorPlan).Id);
				objOC.TOPP__c = mapaTopp.get(objOC.Plan__c+strTipoOperacionPorPlan).Id;
				objOC.RecordTypeId=mapTipoRegistro.get(mapaTopp.get(objOC.Plan__c+strTipoOperacionPorPlan).Tipoderegistro__c).getRecordTypeId();
				mapOperacionesComercialesTramites.put(objActivoCP.Id, objOC);	
				//marcar en el tramite si creo alguna Operacion Comercial
				if(mapTramitesEnteControlador.containsKey(objActivoCP.CuentaFacturacion__r.Name))			
					mapTramitesEnteControlador.get(objActivoCP.CuentaFacturacion__r.Name).Estado__c = 'Exitoso'; 
				if(mapTramitesPago.containsKey(objActivoCP.CuentaFacturacion__r.Name))			
					mapTramitesPago.get(objActivoCP.CuentaFacturacion__r.Name).Estado__c = 'Exitoso';	
			}									
		} 
							
		insert mapOperacionesComercialesTramites.values();	
		System.debug('@@-mapOperacionesComercialesTramites->'+mapOperacionesComercialesTramites);		
	}

}