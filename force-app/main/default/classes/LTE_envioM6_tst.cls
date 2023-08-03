@isTest

private class LTE_envioM6_tst
{
	public static OperacionComercial__c objOC;
	public static ActivoETB__c objActivo;
	public static CuentaFacturacion__c objCtaFact;
	public static Account objAccount;
	public static Poblacion__c objDepto;
	public static Poblacion__c objMunicipio;
	public static Opportunity objOpportunity;
	public static CatalogoProductos__c objProducto;
	public static TOPP__c objTOPP;
	public static Planes__c objPlan;
	public static List<VariablesGlobales__c> lstVariablesGlobales;
	public static List<ServiciosWeb__c> lstSW;
	public static list<Perfiles_Reglas_OC__c> lstPerfiles;
	public static LTE_DetalleOferta__c objDetalle;
	public static Reserva__c objReserva;
	public static Equipo__c objEquipo;
	public static list<Id> lstIdOC;
	public static ServiciosWeb__c objSW; 	
		
	static testMethod void myUnitTest1()
    {
    	
    	objSW 				= new ServiciosWeb__c();
    	objSW.Name 			= 'DisponibilidadM6';
    	objSW.EndPoint__c 	= 'http://201.245.171.237:7051/Service/ProvisioningLTECorp.serviceagent/ProvisioningLTECorp/Endpoint';
    	objSW.Action__c		= '/Service/ProvisioningLTECorp.serviceagent/ProvisioningLTECorpEndpoint/AvailabilityQueryOrder';
    	insert objSW;
    	
    	LTE_cobertura_tst.crearConfiguracion();
    	
        Perfiles_Acciones__c objPerfiles 	= new Perfiles_Acciones__c();
		objPerfiles.Name 					= 'Cargas Masivas';
		objPerfiles.Usuarios__c 			= userinfo.getProfileId();
		insert objPerfiles;
    	
    	objAccount 						= new Account();
		objAccount.Name 				= 'Test Name';
		objAccount.RazonSocial__c 		= 'Test razon social';
		objAccount.Tipodedocumento__c 	= 'NIT';
		objAccount.Estado_Cuenta__c 	= 'Activo';
		objAccount.AccountNumber 		= '1029837456'; 
		objAccount.Segmento__c 			= 'Gobierno Distrital';
		objAccount.SubSegmento__c 		= 'Mediana';
		objAccount.Type					= 'Cliente'; 
        objAccount.Phone				= '3009000000';
		insert objAccount;
		
		objDepto 					= new Poblacion__c();
		objDepto.Name 				= 'BOGOTA D.C.';
		objDepto.CodigoDane__c 		= '11000';
		objDepto.EsDepartamento__c 	= true;
		insert objDepto;
		
		objMunicipio 				= new Poblacion__c();
		objMunicipio.Name 			= 'BOGOTA D.C.';
		objMunicipio.CodigoDane__c 	= '11001';
		objMunicipio.EsMunicipio__c = true;
		objMunicipio.Padre__c 		= objDepto.Id;
		insert objMunicipio;
    	
    	objCtaFact 									= new CuentaFacturacion__c();
		objCtaFact.LTE_NombreCuentaFacturacion__c 	= 'Cta fact test';
		objCtaFact.Cliente__c 						= objAccount.Id;
		objCtaFact.Facturable__c 					= true;
		objCtaFact.LTE_MetodoEnvio__c 				= 'Email';
		objCtaFact.LTE_CicloFacturacion__c 			= '5';
		objCtaFact.LTE_Email__c 					= 'test@test.com';
		objCtaFact.LTE_DireccionFacturacion__c		= 'Direccion test';
		objCtaFact.Ciudad__c 						= objMunicipio.Id;
		objCtaFact.LTE_CuentaFacturacionLTE__c 		= true;
		objCtaFact.Fue_creada_en_revchain__c 		= true;
		objCtaFact.DirCorresp__c 					= 'Test DirCorresp';
		insert objCtaFact;
    	
    	objOpportunity 									= new Opportunity();
		objOpportunity.Name 							= 'Test name';
		objOpportunity.RecordTypeId 					= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
		objOpportunity.AccountId 						= objAccount.Id;
		objOpportunity.StageName 						= 'Análisis de necesidades';
		objOpportunity.CloseDate 						= system.today();
		objOpportunity.Amount 							= 1000;
		objOpportunity.Valor_unica_vez_ETB__c 			= 150;
		objOpportunity.LTE_Scoring__c 					= 9000000;
		objOpportunity.LTE_FechaConsultaDatacredito__c	= system.today();
		objOpportunity.LTE_NumeroLinea__c 				= 2;
		insert objOpportunity;
    	
    	/*objProducto 						= new CatalogoProductos__c();
		objProducto.Name 					= 'TELEFONIA MOVIL (LTE)';
		objProducto.Familia__c 				= 'LTE';
		objProducto.LineaNegocio__c 		= 'Redes Móviles';
		objProducto.CodigoProducto__c 		= '7635736';
		objProducto.Estado__c 				= 'Activo';
		objProducto.Descripcion__c 			= 'Teste';
		objProducto.AtributosEstandar__c	= 'Teste';
		insert objProducto;*/
		
		objTOPP 							= new TOPP__c();
		objTOPP.Name 						= 'Venta- TELEFONIA MOVIL (LTE)	';
		objTOPP.TipodeOperacionporplan__c 	= 'Venta';
		objTOPP.Tipoderegistro__c 			= 'Venta_LTE';
		objTOPP.DisponibleVentainicial__c 	= true;
		objTOPP.Facturable__c 				= true;
		objTOPP.LTE_Parte_caso__c 			= false;
		//objTOPP.LTE_Catalogo_de_Producto__c	= objProducto.Id;
		objTOPP.AplicaPreventa__c			= false;
		insert objTOPP;
		
		objPlan 							= new Planes__c();
		objPlan.Name 						= 'PLAN NEGOCIOS POSPAGO M';
		//objPlan.NombredelProducto__c		= objProducto.Id;
		objPlan.TipodePlan__c 				= 'Troncal SIP';
		objPlan.Tarifa__c 					= 96000;
		objPlan.Estado__c 					= 'Activo';
		objPlan.Descripcion__c 				= 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan.CondicionesComerciales__c	= 'Tarificacion por segundo';
		objPlan.LTE_PlanEstructurados__c 	= true;
		objPlan.LTE_TipoControl__c 			= 'Control';
		insert objPlan;
		
		Planes__c objQueryPlan = [SELECT LTE_MetodoDePago__c FROM Planes__c WHERE id = :objPlan.Id];
    	
    	objActivo 						= new ActivoETB__c();
		objActivo.Oportunidad__c 		= objOpportunity.Id;
        objActivo.NombredelaCuenta__c	= objAccount.Id;
        objActivo.Plan__c 				= objPlan.Id;
        objActivo.Estado__c 			= 'Activo';
        objActivo.IMEI_del_Equipo__c 	= '980684862113805';
        objActivo.LTE_ICCID__c 			= '8957187113000000506';
        objActivo.NumeroConexion__c 	= '3057000550';        
        objActivo.Fecha_Activacion__c 	= system.now();
        objActivo.CuentaFacturacion__c	= objCtaFact.Id;
        insert objActivo;
		
		objEquipo 				= new Equipo__c();
		objEquipo.LTE_Activo__c	= true;
		objEquipo.Name			= 'Samnsun XE';
		insert objEquipo;
		
		objOC 							= new OperacionComercial__c();
		objOC.RecordTypeId				= Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
		objOC.CuentaCliente__c 			= objAccount.Id;
		objOC.Activo__c 				= objActivo.Id;
		objOC.Plan__c 					= objPlan.Id;
		objOC.TOPP__c 					= objTOPP.Id;
		objOC.Oportunidad__c 			= objOpportunity.Id;
		objOC.CuentaFacturacion__c  	= objCtaFact.Id;
		objOC.Estado__c 				= 'En Curso';
		objOC.NumeroConexion__c 		= '3057000500'; 
		objOC.FechadeActivacion__c		= system.today();
		objOC.LTE_TipoTransaccion__c	= 'Equipo';
		objOC.LTE_ReferenciaEquipo__c	= objEquipo.Id;
		objOC.LTE_ICCID__c				= '8957187113000000506';
		objOC.IMEI_del_Equipo__c		= '980684862113805';
		objOC.LTE_PIN__c				= '000001';
		objOC.LTE_PIN2__c				= '000002';
		objOC.LTE_PUK2__c				= '000003';
		objOC.LTE_IMSI__c				= '000004';
        objOC.Tarifa_mensual_Troncales_SIP__c 	 = 1000000;
		objOC.Tarifa_mensual_Bolsa_de_Moviles__c = 2000000;
		objOC.Portacion__c				= true;
		
		insert objOC;
		
		LTE_envioM6_ctr testController;
		testController = new LTE_envioM6_ctr();
		
		PageReference pageRef = Page.LTE_envioM6_pag;
	    Test.setCurrentPage(pageRef);
	    
	    ApexPages.currentPage().getParameters().put('Id', objOC.Id);
	    
	    LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
	    LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','01');
	    
	    
	    Test.startTest();
	    	Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseDisponibilidad());
	    	testController.consultar();
	    	
	    	LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAILURE');
	    	LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','03');
	    	
	    	testController.consultar();
        	testController.cerrarPagina();
	    Test.stopTest();
	    
	    
		
    }
}