/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              John Guevara
Proyecto:           PS Fase I
Descripción:        Clase de Test para la ventana de ampliacion

Cambios (Versiones)
--------------------------------------
----    ----------      --------------              ---------------
1.0     2019-09-25      John Guevara.	            Creación de la clase.
***********************************************************************************************************************/
@isTest
public class LTE_TramitesAPN_AmpliacionAPN_tst {
	
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
	public static Case objCaso;
	public static OperacionComercial__c objOpComercial;
	public static PlanFacturacion__c objPlanFacturacion;
	public static CatalogoProductosFacturacion__c objCatalogoProductosFacturacion;
	public static APN__c objAPN;
	
	public static void CreateData(){
        
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO'));
        vg.add(new VariablesGlobales__c(Name='CambioPlanRegxPag',Valor__c='5'));
        vg.add(new VariablesGlobales__c(Name='ViabilidadTroncalesSIP_LTE_CambioPlan',Valor__c='Enlaces de Voz'));
        vg.add(new VariablesGlobales__c(Name='RolLTEAmpliacionAPN',Valor__c='Total'));
        vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        insert vg;

		objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456';
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '3056478987';
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

		objContact = new Contact();
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
		objContact.Phone = '13455676';
		objContact.MobilePhone = '3105667655';
		objContact.Email = 'scampos@avanxo.com';
		objContact.Ciudad__c = objMunicipio.Id;
		insert objContact;

		objProducto = new CatalogoProductos__c();
		objProducto.Name = 'APN CORPORATIVO';
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

		objPlan = new Planes__c ();
		objPlan.Name = 'APN PARA SERVICIOS DE DATOS';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Principal';
		objPlan.Tarifa__c = 42500000;
		objPlan.Estado__c = 'Activo';
		objPlan.Descripcion__c = 'Test';
		objPlan.CondicionesComerciales__c = 'Test';
		insert objPlan;

        objTOPP = new TOPP__c();
        objTOPP.Name = 'Ampliación- APN PARA SERVICIOS DE DATOS';
        objTOPP.TipodeOperacionporplan__c = 'Ampliación';
        objTOPP.Tipoderegistro__c = 'Ampliacion_Disminucion_AnchodeBanda';
        objTOPP.DisponibleVentainicial__c = true;
        objTOPP.Facturable__c = true;
        objTOPP.Plan__c = objPlan.Id;
        insert objTOPP;
		
		objAPN = new APN__c();
		objAPN.Charguing_Characteristics__c = '100';
		objAPN.Cuenta_Cliente__c = objAccount.Id;
		objAPN.Estado__c = 'Disponible';
		objAPN.Servicio__c = 'DATOS';
		objAPN.APN__c = 'empresas.etb.net.co';
		objAPN.Identificador_APN__c = '4';
		insert objAPN;
		
		objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
		objServicio.APN__c = objAPN.Id;
        insert objServicio;
		
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
		
		List<Case> lstCasos = new List<Case>();
		lstCasos = [SELECT AccountId, AccountNumber__c, Fechaderadicacion__c, Operadores__c, RecordTypeId, Origin, Plan__c, Status, Causal_Estado__c, Subject, ContactId, Aprobaciones__c, CaseNumber FROM Case WHERE Id = :objCaso.Id];
		objCaso = lstCasos.get(0);
    	
    }
    
    static testMethod void myUnitTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        
        LTE_TramitesAPN_AmpliacionAPN_ctr testController;
        Test.startTest();
        PageReference pageRef = Page.LTE_TramitesAPN_AmpliacionAPN_pag;
        Test.setCurrentPage(pageRef);
        
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        
        //Se prueba el controlador de la pagina de tal manera que los parametros se vallan llendo nulos
        //hasta que al final se envian todos los parametros y pasa las validaciones iniciales del controlador
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('estadoAprobacion', 'Oferta Realizada');
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('estadoAprobacion', '');
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idCase', objCaso.Id);
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idAccount', objCaso.AccountId);
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('caseNumber', objCaso.CaseNumber);
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idTOPP', objTOPP.id);
        ApexPages.currentPage().getParameters().put('estadoAprobacion', objCaso.Aprobaciones__c);
        //ApexPages.currentPage().getParameters().put('idContact', '00323000002L5Q6');
        //testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idContact', objCaso.ContactId);
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('strTipo', 'Ampliacion APN');
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        
        objContact.LTE_RolLTE__c = 'Total';
        update objContact;
        testController = new LTE_TramitesAPN_AmpliacionAPN_ctr(new Apexpages.Standardcontroller(objCaso));
        
        ActivoETB__c otAPN = [SELECT Name FROM ActivoETB__c LIMIT 1];
        
        testController.buscar();
        testController.numerosAPN = 'xxxxxxxx';
        testController.buscar();
        testController.numerosAPN = '3057000502';
        testController.buscar();
        testController.numerosAPN = otAPN.Name;
        testController.buscar();
        testController.blnAllChecked = true;
        testController.seleccionarTodos();
        
        testController.guardar();
        
        Test.stopTest();
    }
}