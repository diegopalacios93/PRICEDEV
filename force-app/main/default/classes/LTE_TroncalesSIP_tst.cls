/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para el controlador LTE_TroncalesSIP_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-01-22      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_TroncalesSIP_tst {
	
	public static List<VariablesGlobales__c> lstVariablesGlobales;
	public static Perfiles_Acciones__c objPerfiles;
	public static Perfiles_Reglas_OC__c objRegalsOC;
	public static Account objAccount;
	public static Contract objContrato;
	public static Poblacion__c objDepto;
	public static Poblacion__c objMunicipio;
	public static CuentaFacturacion__c objCtaFact;
	public static Contact objContact;
	public static Opportunity objOportunidad;
	public static Legalizacion__c objLegalizacion;
	public static CatalogoProductos__c objProducto;
	public static TOPP__c objTOPP;
	public static TOPP__c objTOPP2;
	public static Equipo__c objEquipoTraido;
	public static Planes__c objPlan;
	public static Planes__c objPlan2;
    public static Planes__c objPlan3;
    public static Planes__c objPlan4;
	public static SubPlanFacturacion__c objSubPlanTroncal;
    public static SubPlanFacturacion__c objBolsaTroncalSip;
    public static SubPlanFacturacion__c objBolsaTroncalSip2;
	public static Case objCaso;
	
	public static void CreateData(){
		
		lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'CambioPlanRegxPag';
        vGlobal.Valor__c = '5';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'RolLTECambioPlan';
        vGlobal.Valor__c = 'Total';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;
        
        objPerfiles = new Perfiles_Acciones__c();
		objPerfiles.Name = 'PerfilesCambioEstadosLTE';
		objPerfiles.Usuarios__c = userinfo.getProfileId();
		insert objPerfiles;

		objRegalsOC = new Perfiles_Reglas_OC__c();
		objRegalsOC.Name = 'Escenario08';
		objRegalsOC.Desactivar__c = true;
		objRegalsOC.esCreador__c = false;
		objRegalsOC.Detalles__c = 'en estado activa o declinada';
		objRegalsOC.esPropietario__c = false;
		objRegalsOC.Perfiles__c = userinfo.getProfileId();
		insert objRegalsOC;

		objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456'; 
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';   
        objAccount.Phone = '3135685874';
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
		objContact.LTE_RolLTE__c = 'Total';
		objContact.Genero__c = 'Masculino';
		objContact.Direccion__c = 'Calle 12 # 34 - 53';
		objContact.Phone = '43243243';
		objContact.MobilePhone = '3105667655';
		objContact.Email = 'scampos@avanxo.com';
		objContact.Ciudad__c = objMunicipio.Id;
		insert objContact;

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

		objPlan = new Planes__c ();
		objPlan.Name = 'Troncal SIP Movil L';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Troncal SIP';
		objPlan.Tarifa__c = 42500000;
		objPlan.Estado__c = 'Activo';
		objPlan.Descripcion__c = 'La tarifa adicional es solo moviles Tarificacion por segundo Limite del CB hasta  $127.500.000  adicionales (consumos adicionales Voz) ';
		objPlan.CondicionesComerciales__c = 'La tarifa adicional es solo moviles Tarificacion por segundo Limite del CB hasta  $127.500.000  adicionales (consumos adicionales Voz)';
		objPlan.LTE_PlanEstructurados__c = false;
		objPlan.LTE_TipoControl__c = 'Abierto';
		insert objPlan;
		
		objPlan2 = new Planes__c ();
		objPlan2.Name = 'PLAN NEGOCIOS POSPAGO M';
		objPlan2.NombredelProducto__c = objProducto.Id;
		objPlan2.TipodePlan__c = 'Principal';
		objPlan2.Tarifa__c = 96000;
		objPlan2.Estado__c = 'Activo';
		objPlan2.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan2.CondicionesComerciales__c = 'Tarificacion por segundo';
		objPlan2.LTE_PlanEstructurados__c = true;
		objPlan2.LTE_TipoControl__c = 'Control';
		insert objPlan2;
        
        objPlan3 = new Planes__c ();
		objPlan3.Name = 'Troncal SIP Unif Control 5.000';
		objPlan3.NombredelProducto__c = objProducto.Id;
		objPlan3.TipodePlan__c = 'Troncal SIP';
		objPlan3.Tarifa__c = 96000;
		objPlan3.Estado__c = 'Activo';
		objPlan3.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan3.CondicionesComerciales__c = 'Tarificacion por segundo';
		objPlan3.LTE_PlanEstructurados__c = true;
		objPlan3.LTE_TipoControl__c = 'Control';
        objPlan3.Pertenece_A_Troncal_SIP_Unificada__c = true;
		insert objPlan3;
        
        objPlan4 = new Planes__c ();
		objPlan4.Name = 'Troncal SIP Unif Abierto 5.000';
		objPlan4.NombredelProducto__c = objProducto.Id;
		objPlan4.TipodePlan__c = 'Troncal SIP';
		objPlan4.Tarifa__c = 96000;
		objPlan4.Estado__c = 'Activo';
		objPlan4.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan4.CondicionesComerciales__c = 'Tarificacion por segundo';
		objPlan4.LTE_PlanEstructurados__c = true;
		objPlan4.LTE_TipoControl__c = 'Control';
        objPlan4.Pertenece_A_Troncal_SIP_Unificada__c = true;
		insert objPlan4;
		
		objSubPlanTroncal = new SubPlanFacturacion__c();
		objSubPlanTroncal.Codigo__c = 'Troncal SIP Canales';
		objSubPlanTroncal.LTE_NetworkIndicator__c = 'false';
		objSubPlanTroncal.LTE_Precio__c = 237524;
		objSubPlanTroncal.LTE_ServiceIndicator__c = 'false';
		objSubPlanTroncal.LTE_TipoSubplan__c = 'Troncal SIP';
		objSubPlanTroncal.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanTroncal.MonedaExtranjera__c = false;
        objSubPlanTroncal.LTE_PrimaryClassificationCode__c	 = 'LTE TKSIP Channels';
		objSubPlanTroncal.Name = 'Troncal SIP Canales';
		insert objSubPlanTroncal;
        
        objBolsaTroncalSip = new SubPlanFacturacion__c();
        objBolsaTroncalSip.Codigo__c = 'Bolsa Recurrente Troncal SIP Unif 5.000 Min';
        objBolsaTroncalSip.Name = 'Bolsa Recurrente Troncal SIP Unif 5.000 Min';
		insert objBolsaTroncalSip;
        
        objBolsaTroncalSip2 = new SubPlanFacturacion__c();
        objBolsaTroncalSip2.Codigo__c = 'Bolsa No Recurrente Troncal SIP Unif 5.000 Min';
        objBolsaTroncalSip2.Name = 'Bolsa No Recurrente Troncal SIP Unif 5.000 Min';
        insert objBolsaTroncalSip2;
		
		objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        //objCaso.AccountNumber__c = objAccount.AccountNumber;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan.Id;
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
        
    	LTE_TroncalesSIP_ctr testController;
    	Test.startTest();
    		PageReference pageRef = Page.LTE_TroncalesSIP_pag;
    		Test.setCurrentPage(pageRef);
    		testController = new LTE_TroncalesSIP_ctr(new Apexpages.Standardcontroller(objOportunidad));
    	
			testController.cambioPlan();
    		
    		testController.objOfertaEconomica.LTE_Plan__c = objPlan2.Id;
    		testController.cambioPlan();
    		
    		testController.objOfertaEconomica.LTE_Plan__c = objPlan.Id;
    		testController.cambioPlan();
	        
			testController.objOfertaEconomica.LTE_DatosNavegacion__c = objSubPlanTroncal.Id;
			testController.cambioPlan();
			
			
			testController.objOfertaEconomica.LTE_Plan__c = null;
			testController.continuar();
			
			testController.objOfertaEconomica.LTE_Plan__c = objPlan.Id;
			testController.objOfertaEconomica.LTE_DatosNavegacion__c = null;
			testController.continuar();
			
			testController.objOfertaEconomica.LTE_DatosNavegacion__c = objSubPlanTroncal.Id;
			testController.continuar();
			
			objTOPP = new TOPP__c();
			objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
			objTOPP.TipodeOperacionporplan__c = 'Venta';
			objTOPP.Tipoderegistro__c = 'Venta_LTE';
			objTOPP.DisponibleVentainicial__c = true;
			objTOPP.Facturable__c = true;
			objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
			insert objTOPP;
	
	        objTOPP2 = new TOPP__c();
	        objTOPP2.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
	        objTOPP2.TipodeOperacionporplan__c = 'Cambio de Plan';
	        objTOPP2.Tipoderegistro__c = 'CambioPlan_LTE';
	        objTOPP2.Facturable__c = true;
	        objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
	        insert objTOPP2;
	        
	        testController.continuar();
			
			objEquipoTraido = new Equipo__c();
			objEquipoTraido.Name = 'Equipo Traido';
			objEquipoTraido.LTE_PartNumber__c = '3456786543';
			objEquipoTraido.LTE_Marca__c = 'Dummy';
			objEquipoTraido.LTE_Color__c = 'Negro';
			objEquipoTraido.Valor_del_Equipo__c = 0;
			objEquipoTraido.LTE_IVA__c = 0;
			objEquipoTraido.LTE_PrecioConIVA__c = 0;
			objEquipoTraido.LTE_Activo__c = true;
			insert objEquipoTraido;
			
			testController.continuar();
			
			objPlan.LTE_PlanEstructurados__c = false;
			update objPlan;
			testController.continuar();
    		testController.cerrarPagina();
    	Test.stopTest();
    }
    
    @isTest
    static void testParaCobertura() {
        CreateData();
        
    	LTE_TroncalesSIP_ctr testController;
    	Test.startTest();
        
        PageReference pageRef = Page.LTE_TroncalesSIP_pag;
        Test.setCurrentPage(pageRef);
        testController = new LTE_TroncalesSIP_ctr(new Apexpages.Standardcontroller(objOportunidad));
        
        testController.cambioPlan();
        
        testController.objOfertaEconomica.LTE_Plan__c = objPlan4.Id;
        testController.cambioPlan();
        
        testController.objOfertaEconomica.LTE_Plan__c = objPlan3.Id;
        testController.cambioPlan();
        
        testController.CambioRequiereSVA();
        testController.incrementarCantidadSVAs();
        testController.reducirCantidadSVAs();
        testController.requiereSva = true;
            
        testController.svasSeleccionados.put(0, objBolsaTroncalSip.Name);
        
        testController.continuar();
  		Test.stopTest();
    }
    
}