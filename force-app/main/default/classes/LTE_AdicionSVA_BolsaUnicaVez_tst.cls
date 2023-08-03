/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para el controlador LTE_AdicionSVA_BolsaUnicaVez_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-02-05      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_AdicionSVA_BolsaUnicaVez_tst {
	
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
	public static ActivoETB__c objServicio;
	public static TOPP__c objTOPP;
	public static TOPP__c objTOPP2;
	public static Equipo__c objEquipoTraido;
	public static Planes__c objPlan;
	public static Planes__c objPlan2;
	public static SubPlanFacturacion__c objSubPlanTroncal;
	public static SubPlanFacturacion__c objSubPlanUnicaVoz;
	public static SubPlanFacturacion__c objSubPlanUnicaDatos;
	public static Case objCaso;
	public static OperacionComercial__c objOpComercial;
	
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
        vGlobal.Name = 'RolLTEAddBolsaUnicaVez';
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
        objAccount.Phone = '12345678';
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
		objContact.Phone = '432432432';
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
		
		objTOPP = new TOPP__c();
		objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
		objTOPP.TipodeOperacionporplan__c = 'Venta';
		objTOPP.Tipoderegistro__c = 'Venta_LTE';
		objTOPP.DisponibleVentainicial__c = true;
		objTOPP.Facturable__c = true;
		objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
		insert objTOPP;

        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Cambio Número- TELEFONIA MOVIL (LTE)';
        objTOPP2.TipodeOperacionporplan__c = 'Cambio Número';
        objTOPP2.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = true;
        objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP2;

		objPlan = new Planes__c ();
		objPlan.Name = 'Troncal SIP Movil L';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Troncal SIP';
		objPlan.Tarifa__c = 42500000;
		objPlan.Estado__c = 'Activo';
		objPlan.Descripcion__c = 'La tarifa adicional es solo moviles Tarificacion por segundo Limite del CB hasta  $127.500.000  adicionales (consumos adicionales Voz) ';
		objPlan.CondicionesComerciales__c = 'La tarifa adicional es solo moviles Tarificacion por segundo Limite del CB hasta  $127.500.000  adicionales (consumos adicionales Voz)';
		objPlan.LTE_PlanEstructurados__c = true;
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
		
		objSubPlanTroncal = new SubPlanFacturacion__c();
		objSubPlanTroncal.Codigo__c = 'Troncal SIP 5 Canales';
		objSubPlanTroncal.LTE_NetworkIndicator__c = 'false';
		objSubPlanTroncal.LTE_Precio__c = 237524;
		objSubPlanTroncal.LTE_ServiceIndicator__c = 'false';
		objSubPlanTroncal.LTE_TipoSubplan__c = 'Troncal SIP';
		objSubPlanTroncal.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanTroncal.MonedaExtranjera__c = false;
		objSubPlanTroncal.Name = 'Troncal SIP 5 Canales';
		insert objSubPlanTroncal;
		
		objSubPlanUnicaVoz = new SubPlanFacturacion__c();
		objSubPlanUnicaVoz.Codigo__c = 'SVA-COMPRA BOLSA ADIC DE VOZ 500 MIN';
		objSubPlanUnicaVoz.LTE_NetworkIndicator__c = 'false';
		objSubPlanUnicaVoz.LTE_Precio__c = 50000;
		objSubPlanUnicaVoz.LTE_ServiceIndicator__c = 'false';
		objSubPlanUnicaVoz.LTE_TipoSubplan__c = 'SVA-Bolsa Única vez de voz';
		objSubPlanUnicaVoz.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanUnicaVoz.MonedaExtranjera__c = false;
		objSubPlanUnicaVoz.Name = 'COMPRA BOLSA ADIC DE VOZ 500 MIN';
		insert objSubPlanUnicaVoz;
		
		objSubPlanUnicaDatos = new SubPlanFacturacion__c();
		objSubPlanUnicaDatos.Codigo__c = 'SVA-COMPRA BOLSA ADIC DE DATOS 1GB';
		objSubPlanUnicaDatos.LTE_NetworkIndicator__c = 'false';
		objSubPlanUnicaDatos.LTE_Precio__c = 35000;
		objSubPlanUnicaDatos.LTE_ServiceIndicator__c = 'false';
		objSubPlanUnicaDatos.LTE_TipoSubplan__c = 'SVA-Bolsa Única vez de datos';
		objSubPlanUnicaDatos.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanUnicaDatos.MonedaExtranjera__c = false;
		objSubPlanUnicaDatos.Name = 'COMPRA BOLSA ADIC DE DATOS 1GB';
		insert objSubPlanUnicaDatos;
		
		
		
		objServicio = new ActivoETB__c();
		objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan2.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;
		
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
		
		List<Case> lstCasos = new List<Case>();
		lstCasos = [SELECT AccountId, AccountNumber__c, Fechaderadicacion__c, Operadores__c, RecordTypeId, Origin, Plan__c, Status, Causal_Estado__c, Subject, ContactId, Aprobaciones__c, CaseNumber FROM Case WHERE Id = :objCaso.Id];
		objCaso = lstCasos.get(0);
		
		objOpComercial = new OperacionComercial__c();
		objOpComercial.CuentaCliente__c = objAccount.Id;
		objOpComercial.Activo__c = objServicio.Id;
		objOpComercial.Plan__c = objPlan2.Id;
		objOpComercial.TOPP__c = objTOPP2.Id;
		objOpComercial.Oportunidad__c = objOportunidad.Id;
		objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial.Estado__c = 'En Curso';
		objOpComercial.NumeroConexion__c = '3057000501';
		objOpComercial.FechadeActivacion__c = system.today();
		objOpComercial.Legalizacion__c = objLegalizacion.Id;
		insert objOpComercial;
    	
    }
    
    static testMethod void myUnitTest(){
    	//Aca se crean los datos necesarios para la prueba
    	CreateData();
        
    	LTE_AdicionSVA_BolsaUnicaVez_ctr testController;
    	Test.startTest();
    		PageReference pageRef = Page.LTE_AdicionSVA_BolsaRecurrente_pag;
	        Test.setCurrentPage(pageRef);
    	
    		//Se prueba el controlador de la pagina de tal manera que los parametros se vallan llendo nulos
			//hasta que al final se envian todos los parametros y pasa las validaciones iniciales del controlador
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idCase', objCaso.Id);
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idAccount', objCaso.AccountId);
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('caseNumber', objCaso.CaseNumber);
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idTOPP', objTOPP2.id);
	        
	        ApexPages.currentPage().getParameters().put('idContact', '00323000002L5Q6');
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idContact', objCaso.ContactId);
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        objContact.LTE_RolLTE__c = 'Total';
	        update objContact;
	        testController = new LTE_AdicionSVA_BolsaUnicaVez_ctr(new Apexpages.Standardcontroller(objCaso));
	        
	        testController.getURLVoz();
	        testController.getURLDatos();
	        
	        testController.validaRolBolsaUnicaVez('Total');
	        testController.buscar();
	        testController.numerosConexion = 'xxxxxxxx';
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
			testController.cancel();
			testController.buscar();
			LTE_AdicionSVA_BolsaUnicaVez_ctr.LTE_ActivoETB_Wrapper aw = new LTE_AdicionSVA_BolsaUnicaVez_ctr.LTE_ActivoETB_Wrapper(new ActivoETB__c());
			aw.desactivar();
	        
	        testController.strInfoParam = 'UnicaVoz';
	        testController.strNivelId = objSubPlanUnicaVoz.Id;
	        testController.strNivel = objSubPlanUnicaVoz.Name;
	        testController.actualizarBolsaUnicaVez();
	        
	        testController.strInfoParam = 'UnicaDatos';
	        testController.strNivelId = objSubPlanUnicaDatos.Id;
	        testController.strNivel = objSubPlanUnicaDatos.Name;
	        testController.actualizarBolsaUnicaVez();
	        
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