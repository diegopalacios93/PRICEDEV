/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              --
Proyecto:           Jerarquia Cuentas Facturacion
Descripción:        Clase de prueba para el controlador CreacionJerarquiaCuentasFacturacion_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2020-12-04      --               							Creación de la clase.
***********************************************************************************************************************/
@isTest
private class CreacionJerarquiaCuentasFacturacion_tst{
    public static Account 				objAccount;
  	public static Poblacion__c	 		objDepto;
  	public static Poblacion__c 			objMunicipio;
  	public static CuentaFacturacion__c 	objCtaFact;    
    public static CuentaFacturacion__c 	objCtaFact2;    
    public static CuentaFacturacion__c 	objCtaFact3;    
    public static CuentaFacturacion__c 	objCtaFact4; 
    public static map<string, string> mapTestTransferC = new map<string, string>(); 
        
    
    static testMethod void unitTest() {
        CreateData();
        system.currentPageReference().getParameters().put('ObjectId', objAccount.Id);
    	ApexPages.Standardcontroller controller 	= new ApexPages.StandardController(objAccount);                
        CreacionJerarquiaCuentasFacturacion_ctr ctr = new CreacionJerarquiaCuentasFacturacion_ctr(controller);
        ctr.redirectPage();
        list<SelectOption> lstOpcionesCicloFact 		= ctr.lstOpcionesCicloFact;
        list<SelectOption> lstOpcionesTipoFact  		= ctr.lstOpcionesTipoFact;
        list<SelectOption> lstOpcionesTipoFacturacion	= ctr.lstOpcionesTipoFacturacion;
        list<SelectOption> lstOpcionesMetodoEnvio		= ctr.lstOpcionesMetodoEnvio;
        list<SelectOption> lstOpcionesTipoCuenta		= ctr.lstOpcionesTipoCuenta;
        list<SelectOption> lstOpcionesMedioFacturacion	= ctr.lstOpcionesMedioFacturacion;
        list<SelectOption> lstOpcionesCicloFactLTE		= ctr.lstOpcionesCicloFactLTE;
        CreateCuentaFact(ctr.objCuentaFact);
        ctr.guardar();   
	}
    
    static testMethod void unitTest2() {
        CreateData();
        system.currentPageReference().getParameters().put('ObjectId', objAccount.Id);
    	ApexPages.Standardcontroller controller 	= new ApexPages.StandardController(objAccount);                
        CreacionJerarquiaCuentasFacturacion_ctr ctr = new CreacionJerarquiaCuentasFacturacion_ctr(controller);
        ctr.redirectPage();
        list<SelectOption> lstOpcionesCicloFact 		= ctr.lstOpcionesCicloFact;
        list<SelectOption> lstOpcionesTipoFact  		= ctr.lstOpcionesTipoFact;
        list<SelectOption> lstOpcionesTipoFacturacion	= ctr.lstOpcionesTipoFacturacion;
        list<SelectOption> lstOpcionesMetodoEnvio		= ctr.lstOpcionesMetodoEnvio;
        list<SelectOption> lstOpcionesTipoCuenta		= ctr.lstOpcionesTipoCuenta;
        list<SelectOption> lstOpcionesMedioFacturacion	= ctr.lstOpcionesMedioFacturacion;
        list<SelectOption> lstOpcionesCicloFactLTE		= ctr.lstOpcionesCicloFactLTE;
        CreateCuentaFact2(ctr.objCuentaFact);
        ctr.guardar();
	}
    
    static testMethod void unitTest3() {
        CreateData();
        SincronizacionCtasFact_Revchain_cls cls = new SincronizacionCtasFact_Revchain_cls();
        map<string, string> mapTest = new map<string, string>();        
        cls.consultarDiaFacturacionRevchain('5');
		ConstruirXMLCtasFact_cls.CrearXMLCreacionCtaFacturacionRMCA(objCtaFact3);
        ConstruirXMLCtasFact_cls.CrearXMLActualizarDatosCtaFacturacionRMCA(objCtaFact3);
        ConstruirXMLCtasFact_cls.CrearXMLActualizarDatosCtaFacturacion(objCtaFact3,mapTest,'test');
    }
    
    static testMethod void unitTest4() {
        CreateData();
        ConstruirXMLCtasFact_cls cls = new ConstruirXMLCtasFact_cls();
        ConstruirXMLCtasFact_cls.CrearXMLconsultarServicioEnRevchain('CTA1','CTA2','EXT');
    }
    
    static testMethod void unitTest5() {
        CreateData();
        CuentasFacturacion_bch facttbtch = new CuentasFacturacion_bch();               
        ID batchprocessid = Database.executeBatch(facttbtch,10);
    }
    
    static testMethod void unitTest6() {
        CreateData();
        system.currentPageReference().getParameters().put('ObjectId', objCtaFact4.Id);    	
        CrearCuentaFacturacionEnFacturador_cls cls  = new CrearCuentaFacturacionEnFacturador_cls();
        cls.GenerarIntegracion();	 
        cls.Cancelar();
    }
    
    static testMethod void unitTest7(){
        CreateData();
        List<CuentaFacturacion__c> scope = new List<CuentaFacturacion__c>();
        scope.add(objCtaFact4);
        ConstruccionCanonicoCtasFact_cls canonico = new ConstruccionCanonicoCtasFact_cls();
		canonico.orquestarIntegracion(scope,'ActualizarNombre');
    }
    
    static testMethod void unitTest8() {
        CreateData();
		ConstruirXMLCtasFact_cls.CrearXMLTransferServicesSystems(mapTestTransferC.get('CorrelationId'),mapTestTransferC.get('SubscriberId'),mapTestTransferC.get('SubscriberIdDestination'),mapTestTransferC.get('ExternalServiceId'),mapTestTransferC.get('SubscriberNumber'),mapTestTransferC.get('NewCycle'),mapTestTransferC.get('IsLTEService'));
        ConstruirXMLCtasFact_cls.CrearXMLGetAccountCycle(mapTestTransferC.get('SubscriberId'),mapTestTransferC.get('ExternalServiceId'));
    }
    
    public static void CreateData()
    {
      objAccount = new Account();
      objAccount.Name = 'Test Name';
      objAccount.RazonSocial__c = 'Test razon social';
      objAccount.Tipodedocumento__c = 'NIT';
      objAccount.Estado_Cuenta__c = 'Activo';     
      objAccount.Phone = '3033033033';
      objAccount.AccountNumber = '12587458';
      objAccount.DigitodeVerificacion__c = 9;      
      insert objAccount;

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
        
      HomologacionCampos__c objHomologacionCampos = new HomologacionCampos__c();
      objHomologacionCampos.Name = 'NIT';
	  objHomologacionCampos.Valor__c = 'JURIDICO';
	  insert objHomologacionCampos;
        
      objCtaFact3 = new CuentaFacturacion__c();
      objCtaFact3.LTE_NombreCuentaFacturacion__c = 'Cta fact test 3';
      objCtaFact3.Name = '1234567890';
      objCtaFact3.Cliente__c = objAccount.Id;
      objCtaFact3.Facturable__c = true;
      objCtaFact3.LTE_MetodoEnvio__c = 'Email';      
      objCtaFact3.LTE_Email__c = 'test@test.com';      
      objCtaFact3.DirCorresp__c = 'Direccion test';
      objCtaFact3.Ciudad__c = objMunicipio.Id;
      objCtaFact3.LTE_CuentaFacturacionLTE__c = false;
      objCtaFact3.Fue_creada_en_revchain__c = true;     
      objCtaFact3.LTE_CuentaFacturacionLTE__c = true;
      objCtaFact3.No_requiere_crear_cuenta_en_Revchain__c = true;
      insert objCtaFact3;
        
      objCtaFact4 = new CuentaFacturacion__c();
      objCtaFact4.LTE_NombreCuentaFacturacion__c = 'Cta fact test 3';
      objCtaFact4.Name = '1234567891';
      objCtaFact4.Cliente__c = objAccount.Id;
      objCtaFact4.Facturable__c = true;
      objCtaFact4.LTE_MetodoEnvio__c = 'Email';      
      objCtaFact4.LTE_Email__c = 'test@test.com';      
      objCtaFact4.DirCorresp__c = 'Direccion test';
      objCtaFact4.Ciudad__c = objMunicipio.Id;
      objCtaFact4.LTE_CuentaFacturacionLTE__c = false;
      objCtaFact4.Fue_creada_en_revchain__c = false;        
      objCtaFact4.No_requiere_crear_cuenta_en_Revchain__c = true;
      insert objCtaFact4;
        
      new ServiciosWeb__c(Name='CreacionCuentasFact',EndPoint__c='http://201.245.171.239:7052/Service/BillingCorporate/Endpoint',Action__c='/Service/BillingCorporate.serviceagent//CreateIncident');
      
      map<string, string> mapTestTransfer = new map<string, string>(); 
      mapTestTransfer.put('CorrelationId','a09m0000005AQtAAAW');
      mapTestTransfer.put('SubscriberId','15052851091');
      mapTestTransfer.put('SubscriberIdDestination','15052851092');
      mapTestTransfer.put('ExternalServiceId','AC-813931');
      mapTestTransfer.put('SubscriberNumber','573057000459');
      mapTestTransfer.put('NewCycle','5');
      mapTestTransfer.put('IsLTEService','Y');
      
      mapTestTransferC = mapTestTransfer;
    }
    
    public static void CreateCuentaFact(CuentaFacturacion__c objCtaFact){      
      objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test Parent';
      objCtaFact.Cliente__c = objAccount.Id;
      objCtaFact.Facturable__c = true;
      objCtaFact.LTE_MetodoEnvio__c = 'Email';
      //objCtaFact.LTE_CicloFacturacion__c = '5';
      objCtaFact.LTE_Email__c = 'test@test.com';      
      objCtaFact.DirCorresp__c = 'Direccion test';
      objCtaFact.Ciudad__c = objMunicipio.Id;
      objCtaFact.LTE_CuentaFacturacionLTE__c = false;
      objCtaFact.Fue_creada_en_revchain__c = false;    
      objCtaFact.No_requiere_crear_cuenta_en_Revchain__c = true;
    }
    
    public static void CreateCuentaFact2(CuentaFacturacion__c objCtaFact){ 
      objCtaFact2 = new CuentaFacturacion__c();
      objCtaFact2.LTE_NombreCuentaFacturacion__c = 'Cta fact test Parent';
      objCtaFact2.Cliente__c = objAccount.Id;
      objCtaFact2.Facturable__c = true;
      objCtaFact2.LTE_MetodoEnvio__c = 'Email';
      //objCtaFact.LTE_CicloFacturacion__c = '5';
      objCtaFact2.LTE_Email__c = 'test@test.com';      
      objCtaFact2.DirCorresp__c = 'Direccion test';
      objCtaFact2.Ciudad__c = objMunicipio.Id;
      objCtaFact2.LTE_CuentaFacturacionLTE__c = false;
      objCtaFact2.Fue_creada_en_revchain__c = true;   
      objCtaFact2.No_requiere_crear_cuenta_en_Revchain__c = true;
      insert objCtaFact2;
        
      objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test Child';
      objCtaFact.Cliente__c = objAccount.Id;
      objCtaFact.Facturable__c = false;
      objCtaFact.LTE_MetodoEnvio__c = 'Email';
      //objCtaFact.LTE_CicloFacturacion__c = '5';
      objCtaFact.LTE_Email__c = 'test@test.com';      
      objCtaFact.DirCorresp__c = 'Direccion test';
      objCtaFact.Ciudad__c = objMunicipio.Id;
      objCtaFact.LTE_CuentaFacturacionLTE__c = false;
      objCtaFact.Fue_creada_en_revchain__c = false;           
      objCtaFact.LTE_CuentaFacturacionPadre__c = objCtaFact2.Id;
      objCtaFact.No_requiere_crear_cuenta_en_Revchain__c = true;
    }
}