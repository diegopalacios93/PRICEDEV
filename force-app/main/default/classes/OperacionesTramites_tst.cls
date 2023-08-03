/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase de prueba para OperacionesTramites_cls
						 
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     21-08-2015   Sergio Ortiz                	Creación de la clase.
**************************************************************************************/
@isTest
private class OperacionesTramites_tst {

	public static Id recordTypeIdTramitesPago            = Schema.SObjectType.Tramites__c.getRecordTypeInfosByName().get('Causal de Pago').getRecordTypeId();
	public static Id recordTypeIdTramitesEnteControlador = Schema.SObjectType.Tramites__c.getRecordTypeInfosByName().get('Causal Ente Controlador').getRecordTypeId();
	public static CuentaFacturacion__c objFac;
	public static CuentaFacturacion__c objFac2;
	
	//Metodo con el llamado a creacion de tramites por causal de pago para tramites de suspension
	static testMethod void myUnitTestOperacionesTramitesPago1() {

		fnCreateData();
		Test.startTest();
		List<Tramites__c> lstTramites 		   = new List<Tramites__c>();
		Tramites__c objTramitesPago 		   = new Tramites__c();
		objTramitesPago.CuentaDeFacturacion__c = objFac.Name;
		objTramitesPago.OrigenTramite__c 	   = 'Causal de pago';
		objTramitesPago.TipoDeTramite__c 	   = 'Suspensión';
		objTramitesPago.RecordTypeId 		   = recordTypeIdTramitesPago;
		lstTramites.add(objTramitesPago);
		try {
			insert lstTramites;
		} catch(Exception e) { System.debug(e.getMessage());}
		Test.stopTest();

	}

	//Metodo con el llamado a creacion de tramites por causal de pago para tramites de reconexion
	static testMethod void myUnitTestOperacionesTramitesPago2() {

		fnCreateData();
		Test.startTest();
		List<Tramites__c> lstTramites 		   		= new List<Tramites__c>();
		Tramites__c objtramiteReconexion       		= new Tramites__c();
		objtramiteReconexion.CuentaDeFacturacion__c = objFac.Name;
		objtramiteReconexion.OrigenTramite__c 	   	= 'Causal de pago';
		objtramiteReconexion.TipoDeTramite__c 	   	= 'Reconexión';
		objtramiteReconexion.RecordTypeId 		   	= recordTypeIdTramitesPago;
		lstTramites.add(objtramiteReconexion);
		try {
			insert lstTramites;
		} catch(Exception e) { System.debug(e.getMessage());}
		Test.stopTest();
	}

	//Metodo con el llamado a creacion de tramites por causal de pago para tramites de retiro
	static testMethod void myUnitTestOperacionesTramitesPago3() {

		fnCreateData();
		Test.startTest();
		List<Tramites__c> lstTramites 		   		= new List<Tramites__c>();
		Tramites__c objtramiteRetiro	       		= new Tramites__c();
		objtramiteRetiro.CuentaDeFacturacion__c 	= objFac.Name;
		objtramiteRetiro.OrigenTramite__c 	   		= 'Causal de pago';
		objtramiteRetiro.TipoDeTramite__c 	   		= 'Retiro';
		objtramiteRetiro.RecordTypeId 		   		= recordTypeIdTramitesPago;
		lstTramites.add(objtramiteRetiro);
		try {
			insert lstTramites;
		} catch(Exception e) { System.debug(e.getMessage());}
		Test.stopTest();
	}

	//Metodo con el llamado a creacion de tramites por ente controlador para tramites de suspension
	static testMethod void myUnitTestOperacionesTramitesEnteControlador1() {

		fnCreateData();
		Test.startTest();
		List<Tramites__c> lstTramites 		   		  = new List<Tramites__c>();
		Tramites__c objtramiteSuspensionEC            = new Tramites__c();
		objtramiteSuspensionEC.CuentaDeFacturacion__c = objFac2.Name;
		objtramiteSuspensionEC.OrigenTramite__c       = 'Causal Ente Controlador';
		objtramiteSuspensionEC.TipoDeTramite__c       = 'Suspensión';
		objtramiteSuspensionEC.RecordTypeId           = recordTypeIdTramitesEnteControlador;
		lstTramites.add(objtramiteSuspensionEC);
		try {
			insert lstTramites;
		} catch(Exception e) { System.debug(e.getMessage());}
		Test.stopTest();
	}

	//Metodo con el llamado a creacion de tramites por ente controlador para tramites de reconexion
	static testMethod void myUnitTestOperacionesTramitesEnteControlador2() {

		fnCreateData();
		Test.startTest();
		List<Tramites__c> lstTramites 		   		  = new List<Tramites__c>();
		Tramites__c objtramiteReconexionEC            = new Tramites__c();
		objtramiteReconexionEC.CuentaDeFacturacion__c = objFac2.Name;
		objtramiteReconexionEC.OrigenTramite__c       = 'Causal Ente Controlador';
		objtramiteReconexionEC.TipoDeTramite__c       = 'Reconexión';
		objtramiteReconexionEC.RecordTypeId           = recordTypeIdTramitesEnteControlador;
		lstTramites.add(objtramiteReconexionEC);
		try {
			insert lstTramites;
		} catch(Exception e) { System.debug(e.getMessage());}
		Test.stopTest();
	}

	//Metodo con el llamado a creacion de tramites por ente controlador para tramites de retiro
	static testMethod void myUnitTestOperacionesTramitesEnteControlador3() {

		fnCreateData();
		Test.startTest();
		List<Tramites__c> lstTramites 		   		  = new List<Tramites__c>();
		Tramites__c objtramiteRetiroEC                = new Tramites__c();
		objtramiteRetiroEC.CuentaDeFacturacion__c     = objFac2.Name;
		objtramiteRetiroEC.OrigenTramite__c           = 'Causal Ente Controlador';
		objtramiteRetiroEC.TipoDeTramite__c           = 'Retiro';
		objtramiteRetiroEC.RecordTypeId               = recordTypeIdTramitesEnteControlador;
		lstTramites.add(objtramiteRetiroEC);
		try {
			insert lstTramites;
		} catch(Exception e) { System.debug(e.getMessage());}
		Test.stopTest();
	}
	
	//Metodo con la creacion de los datos para las pruebas de tamites
	private static void fnCreateData()
	{
		Id devRecordTypeId                               = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
		Id SdevRecordTypeId                              = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();		
		Id recordTypeIdOCsuspensionReconexion            = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('SuspensionReconexion').getRecordTypeId();
		Id recordTypeIdOCRetiro                          = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Retiros').getRecordTypeId();
		
		objPruebas_tst obj                               = new objPruebas_tst();
		
		Account cliente                                  = obj.ObjAccount();
		cliente.RecordTypeId                             = devRecordTypeId;
		cliente.AccountNumber                            = '1234567890';
		cliente.Tipodedocumento__c                       = 'Cédula de ciudadanía';
		System.debug(devRecordTypeId);
		insert cliente;
		
		Account Scliente                                 = obj.ObjAccount();
		Scliente.RecordTypeId                            = SdevRecordTypeId;
		Scliente.AccountNumber                           = '1234567890';
		Scliente.Tipodedocumento__c                      = 'Cédula de ciudadanía';
		Scliente.Cuenta__c								 = cliente.Id;
		insert Scliente;
				
		CatalogoProductos__c Catalogo                    = obj.objCatalogo();
		Catalogo.Name                                    = 'Internet Dedicado';
		Catalogo.Familia__c                              = 'Conectividad';
		Catalogo.LineaNegocio__c                         = 'INTERNET';
		Catalogo.Estado__c                               = 'Activo';
		insert Catalogo;
		
		planes__c plan                                   =obj.objPlan();
		plan.Name                                        = 'Plan Internet Dedicado';
		plan.NombredelProducto__c                        =Catalogo.id;
		plan.TipodePlan__c                               = 'Principal';
		plan.Estado__c                                   = 'Activo';
		insert plan;
		
		TOPP__c topp                                     = obj.objTopp();
		topp.Name                                        = 'Suspensión- Plan Internet Dedicado';
		topp.TipodeOperacionporplan__c                   = 'Suspensión';
		//topp.Tipo_de_Operacion_por_plan_Tramite_Unico__c = 'Suspensión';
		topp.Tipoderegistro__c                           = 'SuspensionReconexion';
		topp.Activo__c                                   = true;
		topp.Plan__c                                     =plan.id;                      
		insert topp;

		Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'ANTIOQUIA';
        objDepto.CodigoDane__c = '1200';
        objDepto.EsDepartamento__c = true;
        insert objDepto;

        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'MEDELLIN';
        objMunicipio.CodigoDane__c = '11002';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
		
		objFac                             = new CuentaFacturacion__c();
		objFac.Cliente__c                 = cliente.id;
		objFac.Estado__c                  = 'Activo';
		objFac.Name 					  = '246810';
		objFac.Facturable__c              = true;
		objFac.Fue_creada_en_revchain__c  = true;
		objFac.Ciudad__c = objMunicipio.Id;
      	objFac.DirCorresp__c = 'Test DirCorresp';
		insert objFac;
				
		ActivoETB__c objAct               = new ActivoETB__c();
		objAct.NombredelaCuenta__c        = cliente.id;
		objAct.Estado__c                  = 'Activo';
		objAct.SucursalDestino__c         = Scliente.id;
		objAct.SucursalOrigen__c          = Scliente.id;
		objAct.CuentaFacturacion__c       = objFac.Id;
		insert objAct;
		
		ActivoETB__c objAct2               = new ActivoETB__c();
		objAct2.NombredelaCuenta__c        = cliente.id;
		objAct2.Estado__c                  = 'Suspendido';
		objAct2.SucursalDestino__c         = Scliente.id;
		objAct2.SucursalOrigen__c          = Scliente.id;
		objAct2.CuentaFacturacion__c       = objFac.Id;
		insert objAct2;

		objFac2       					   = new CuentaFacturacion__c();
		objFac2.Cliente__c                 = cliente.id;
		objFac2.Estado__c                  = 'Activo';
		objFac2.Name 					   = '1357911';
		objFac2.Facturable__c              = true;
		objFac2.Fue_creada_en_revchain__c  = true;
		objFac2.Ciudad__c = objMunicipio.Id;
      	objFac2.DirCorresp__c = 'Test DirCorresp';
		insert objFac2;
		
		ActivoETB__c objAct3               = new ActivoETB__c();
		objAct3.NombredelaCuenta__c        = cliente.id;
		objAct3.Estado__c                  = 'Activo';
		objAct3.SucursalDestino__c         = Scliente.id;
		objAct3.SucursalOrigen__c          = Scliente.id;
		objAct3.CuentaFacturacion__c       = objFac2.Id;
		insert objAct3;

		ActivoETB__c objAct4               = new ActivoETB__c();
		objAct4.NombredelaCuenta__c        = cliente.id;
		objAct4.Estado__c                  = 'Suspendido';
		objAct4.SucursalDestino__c         = Scliente.id;
		objAct4.SucursalOrigen__c          = Scliente.id;
		objAct4.CuentaFacturacion__c       = objFac2.Id;
		insert objAct4;	

	}	
}