/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para el controlador LTE_SeleccionTipoVenta_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-02-08      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_SeleccionTipoVenta_tst {
	
	public static List<LTE_Tipo_Venta__c> lstLTETipoVenta;
	public static Perfiles_Acciones__c objPerfiles;
	public static Perfiles_Reglas_OC__c objRegalsOC;
	public static Account objAccount;
	public static Contract objContrato;
	public static Poblacion__c objDepto;
	public static Poblacion__c objMunicipio;
	public static CuentaFacturacion__c objCtaFact;
	public static Contact objContact;
	public static Opportunity objOportunidad;
	
	public static void CreateData(){
		
		lstLTETipoVenta = new List<LTE_Tipo_Venta__c>();
        LTE_Tipo_Venta__c tipoVenta = new LTE_Tipo_Venta__c();
        tipoVenta.Name = 'LTE';
        tipoVenta.URL__c = '/apex/LTE_OfertaEconomica_pag?scontrolCaching=1&id=<<id>>';
        lstLTETipoVenta.add(tipoVenta);
        
        tipoVenta = new LTE_Tipo_Venta__c();
        tipoVenta.Name = 'SIP Trunking';
        tipoVenta.URL__c = '/apex/LTE_TroncalesSIP_pag?scontrolCaching=1&id=<<id>>';
        lstLTETipoVenta.add(tipoVenta);
        
        insert lstLTETipoVenta;
        
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
		objAccount.Phone = '12000000';
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
		
		
    	
    }
    
    static testMethod void myUnitTest(){
    	//Aca se crean los datos necesarios para la prueba
    	CreateData();
        
    	LTE_SeleccionTipoVenta_cls testController;
    	Test.startTest();
    		PageReference pageRef = Page.LTE_SeleccionTipoVenta_pag;
	        Test.setCurrentPage(pageRef);
    		testController = new LTE_SeleccionTipoVenta_cls(new Apexpages.Standardcontroller(objOportunidad));
    		testController.tipoVenta = 'SIP Trunking';
    		testController.continuar();
    	Test.stopTest();
    }
    
}