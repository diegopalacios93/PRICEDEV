/***********************************************************************************************************************
Desarrollado por:   SQDM
Autor:              John Guevara
Proyecto:           Proyecto LTE
Descripción:        Clase de prueba para el controlador LTE_TramitesAPN_conectarAPN_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------		---------------
1.0     2016-10-10      John Guevara (SQDM)               	Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_TramitesAPN_RetiroLineaAPN_tst {
	
	public static List<VariablesGlobales__c> lstVariablesGlobales;
	public static Account objAccount;
	public static Contract objContrato;
	public static Poblacion__c objDepto;
	public static Poblacion__c objMunicipio;
	public static CuentaFacturacion__c objCtaFact;
	public static Contact objContact;
	public static Opportunity objOportunidad;
	public static Legalizacion__c objLegalizacion;
	public static CatalogoProductos__c objProducto;
	public static CatalogoProductos__c objProducto2;
	public static ActivoETB__c objServicio;
	public static ActivoETB__c objServicio2;
	public static TOPP__c objTOPP;
	public static TOPP__c objTOPP2;
	public static Planes__c objPlan;
	public static Planes__c objPlan2;
	public static Case objCaso;
	public static APN__c objAPN;
	
	public static void CreateData(){
		
		lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c(Name = 'NombreComercialAPN',Valor__c='APN CORPORATIVO');
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c(Name = 'CambioPlanRegxPag',Valor__c='5');
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c(Name = 'RolLTERetiroAPN',Valor__c='Total, Parcial');
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;

		objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456'; 
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';   
		insert objAccount;

		objContrato = new Contract();
		objContrato.Name = 'Test name contrato';
		objContrato.AccountId = objAccount.Id;
		objContrato.Status = 'Borrador';
		insert objContrato;

		objDepto = new Poblacion__c();
		objDepto.Name = 'BOGOTA D.C.';
		objDepto.CodigoDane__c = '11000';
		objDepto.EsDepartamento__c = true;
		insert objDepto;

		objMunicipio = new Poblacion__c();
		objMunicipio.Name = 'BOGOTA D.C.';
		objMunicipio.CodigoDane__c = '11001';
		objMunicipio.EsMunicipio__c = true;
		objMunicipio.Padre__c = objDepto.Id;
		insert objMunicipio;

		objCtaFact = new CuentaFacturacion__c();
		objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
		objCtaFact.Cliente__c = objAccount.Id;
		objCtaFact.Facturable__c = true;
		objCtaFact.LTE_MetodoEnvio__c = 'Email';
		objCtaFact.LTE_CicloFacturacion__c = '5';
		objCtaFact.LTE_Email__c = 'test@test.com';
		objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
		objCtaFact.Ciudad__c = objMunicipio.Id;
		objCtaFact.LTE_CuentaFacturacionLTE__c = true;
		objCtaFact.Fue_creada_en_revchain__c = true;
		objCtaFact.DirCorresp__c = 'Test DirCorresp';
		insert objCtaFact;

		objContact = new Contact(IsTEST__c = true);
		objContact.FirstName = 'Andres';
		objContact.LastName = 'Lopez';
		objContact.AccountId = objAccount.Id;
		objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
		objContact.NumerodeIdentificacion__c = '345678904';
		objContact.Estado__c = 'Activo';
		objContact.Cargo__c = 'Ingeniero';
		objContact.Area__c = 'Dpto. Financiero';
		objContact.Rol__c = 'Administrativo';
		objContact.LTE_RolLTE__c = 'Total-';
		objContact.Genero__c = 'Masculino';
		objContact.Direccion__c = 'Calle 12 # 34 - 53';
		objContact.Phone = '32432432';
		objContact.MobilePhone = '3105667655';
		objContact.Email = 'scampos@avanxo.com';
		objContact.Ciudad__c = objMunicipio.Id;
		insert objContact;
		
		objAPN = new APN__c();
		objAPN.Charguing_Characteristics__c = '100';
		objAPN.Cuenta_Cliente__c = objAccount.Id;
		objAPN.Estado__c = 'Disponible';
		objAPN.Servicio__c = 'DATOS';
		objAPN.APN__c = 'empresas.etb.net.co';
		objAPN.Identificador_APN__c = '4';
		insert objAPN;

		objOportunidad = new Opportunity();
		objOportunidad.Name = 'Test name';
		objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
		objOportunidad.AccountId = objAccount.Id;
		objOportunidad.StageName = 'Análisis de necesidades';
		objOportunidad.CloseDate = system.today();
		objOportunidad.Amount = 1000;
		objOportunidad.Valor_unica_vez_ETB__c = 150;
		objOportunidad.LTE_Scoring__c = 9000000;
		objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
		objOportunidad.LTE_NumeroLinea__c = 2;
		insert objOportunidad;
		
		objLegalizacion = new Legalizacion__c();
		objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
		objLegalizacion.Contrato__c = objContrato.Id;
		objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
		objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
		objLegalizacion.LTE_FechaGestion__c = system.today();
		objLegalizacion.Estado__c = 'Gestionado';
		objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
		objLegalizacion.Cuotas__c = 2;
		insert objLegalizacion;

		objProducto = new CatalogoProductos__c();
		objProducto.Name = 'TELEFONIA MOVIL (LTE)';
		objProducto.Familia__c = 'LTE';
		objProducto.LineaNegocio__c = 'Redes Móviles';
		objProducto.CodigoProducto__c = '7635736';
		objProducto.Estado__c = 'Activo';
		objProducto.Descripcion__c = 'Teste';
		objProducto.AtributosEstandar__c = 'Teste';
		insert objProducto;

		objProducto2 = new CatalogoProductos__c();
		objProducto2.Name = 'APN CORPORATIVO';
		objProducto2.Familia__c = 'LTE';
		objProducto2.LineaNegocio__c = 'Redes Móviles';
		objProducto2.CodigoProducto__c = '222222';
		objProducto2.Estado__c = 'Activo';
		objProducto2.Descripcion__c = 'APN Moviles Test';
		objProducto2.AtributosEstandar__c = 'APN Moviles Teste';
		insert objProducto2;
		
		objPlan = new Planes__c ();
		objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Principal';
		objPlan.Tarifa__c = 96000;
		objPlan.Estado__c = 'Activo';
		objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
		objPlan.LTE_PlanEstructurados__c = true;
		objPlan.LTE_TipoControl__c = 'Control';
		insert objPlan;

		objPlan2 = new Planes__c ();
		objPlan2.Name = 'APN PARA SERVICIOS DE DATOS';
		objPlan2.NombredelProducto__c = objProducto2.Id;
		objPlan2.TipodePlan__c = 'Principal';
		objPlan2.Tarifa__c = 0;
		objPlan2.Estado__c = 'Activo';
		objPlan2.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
		objPlan2.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
		objPlan2.LTE_PlanEstructurados__c = false;
		insert objPlan2;
		
		objTOPP = new TOPP__c();
		objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
		objTOPP.TipodeOperacionporplan__c = 'Venta';
		objTOPP.Tipoderegistro__c = 'Venta_LTE';
		objTOPP.DisponibleVentainicial__c = true;
		objTOPP.Facturable__c = true;
		objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
		insert objTOPP;

        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Venta- APN PARA SERVICIOS DE DATOS';
        objTOPP2.TipodeOperacionporplan__c = 'Venta';
        objTOPP2.Tipoderegistro__c = 'VentaAPN';
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = false;
		objTOPP2.Plan__c = objPlan2.Id;
        insert objTOPP2;
		
		
		objServicio = new ActivoETB__c();
		objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
		objServicio.APN__c = objAPN.Id;
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;
		
		objServicio2 = new ActivoETB__c();
		objServicio2.Oportunidad__c = objOportunidad.Id;
        objServicio2.NombredelaCuenta__c = objAccount.Id;
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
		objServicio2.APN__c = objAPN.Id;
		objServicio2.Tipo_de_APN__c = 'Datos';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;
		
		objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        //objCaso.AccountNumber__c = objAccount.AccountNumber;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan2.Id;
        objCaso.Status = 'Abierto';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
		insert objCaso;
    }
    
    static testMethod void myUnitTest(){
    	//Aca se crean los datos necesarios para la prueba
    	CreateData();
    	LTE_TramitesAPN_RetiroLineaAPN_ctr testController;
    	Test.startTest();
    		PageReference pageRef = Page.LTE_TramitesAPN_RetiroLineaAPN_pag;
	        Test.setCurrentPage(pageRef);
    	
    		//Se prueba el controlador de la pagina de tal manera que los parametros se vallan llendo nulos
			//hasta que al final se envian todos los parametros y pasa las validaciones iniciales del controlador
	        testController = new LTE_TramitesAPN_RetiroLineaAPN_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idCase', objCaso.Id);
	        testController = new LTE_TramitesAPN_RetiroLineaAPN_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idAccount', objCaso.AccountId);
	        testController = new LTE_TramitesAPN_RetiroLineaAPN_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('caseNumber', objCaso.CaseNumber);
	        ApexPages.currentPage().getParameters().put('idTOPP', objTOPP2.id);
	        ApexPages.currentPage().getParameters().put('idContact', objCaso.ContactId);
	        testController = new LTE_TramitesAPN_RetiroLineaAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        
	        testController.buscar();
	        testController.numerosConexion = 'xxxxxxxx';
        	String numerosConexion = 'xxxxxxxx';        
	        testController.buscar();
	        testController.numerosConexion = '3057000501';
	        testController.buscar();
	        
	        //Se hace el llamado a todos los metodos de la paginacion
			Boolean blnAux;
			Integer intAux;
    		blnAux = testController.hasNext;
			blnAux = testController.hasPrevious;
			intAux = testController.pageNumber;
			
			testController.first();
			testController.last();
			testController.previous();
			testController.next();
			//testController.cancel();
			testController.buscar();
			LTE_TramitesAPN_RetiroLineaAPN_ctr.LTE_ActivoETB_Wrapper aw = new LTE_TramitesAPN_RetiroLineaAPN_ctr.LTE_ActivoETB_Wrapper(new ActivoETB__c());
			aw.desactivar();
        
	        testController.lstActivos = new List<ActivoETB__c>();
	        testController.guardar();
	        testController.buscar();
	        testController.guardar();
	        testController.blnAllChecked = true;
			testController.seleccionarTodos();
			testController.guardar();
			objServicio.CuentaFacturacion__c = objCtaFact.Id;
			update objServicio;
			testController.buscar();
			testController.blnAllChecked = true;
			testController.seleccionarTodos();
			testController.guardar();
	        testController.regresar();
    	
    	Test.stopTest();
    }
}