/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase encargada del consumo del servicio web para la actualización de las cuentas de facturación.                          
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     04/09/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
@isTest
private class LTE_ModificarCuentasFacturacion_tst 
{
    public static Account objAccount;
    public static Poblacion__c objDepto;
    public static Poblacion__c objDepto2;
    public static Poblacion__c objMunicipio;
    public static Poblacion__c objMunicipio2;
    public static CuentaFacturacion__c objCtaFact;
    public static CuentaFacturacion__c objCtaFact2;
    public static CuentaFacturacion__c objCtaFactHija;
    public static CuentaFacturacion__c objCtaFactHija2;
    public static set<String> setIdPoblacion;
    public static map<String, Poblacion__c> mapPoblaciones;
    public static ServiciosWeb__c objSW;

    public static void CreateData()
    {
        objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456';    
        insert objAccount;

        objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;

        objDepto2 = new Poblacion__c();
        objDepto2.Name = 'ANTIOQUIA';
        objDepto2.CodigoDane__c = '1200';
        objDepto2.EsDepartamento__c = true;
        insert objDepto2;

        objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;

        setIdPoblacion = new set<String>();
        setIdPoblacion.add(objMunicipio.Id);

        objMunicipio2 = new Poblacion__c();
        objMunicipio2.Name = 'MEDELLIN';
        objMunicipio2.CodigoDane__c = '11002';
        objMunicipio2.EsMunicipio__c = true;
        objMunicipio2.Padre__c = objDepto2.Id;
        insert objMunicipio2;
        setIdPoblacion.add(objMunicipio2.Id);

        LTE_SincronizacionCtasFact_Revchain_cls objSinc = new LTE_SincronizacionCtasFact_Revchain_cls();        
        mapPoblaciones = new map<String, Poblacion__c>();
        mapPoblaciones = objSinc.consultarCodigoPoblacion(setIdPoblacion);

        objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;

        objCtaFact2 = new CuentaFacturacion__c();
        objCtaFact2.LTE_NombreCuentaFacturacion__c = '1234567';
        objCtaFact2.Cliente__c = objAccount.Id;
        objCtaFact2.Facturable__c = true;
        objCtaFact2.LTE_MetodoEnvio__c = null;
        objCtaFact2.LTE_CicloFacturacion__c = '5';
        objCtaFact2.LTE_Email__c = 'test3@test3.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact2.DirCorresp__c = 'Direccion test3';
        objCtaFact2.Ciudad__c = objMunicipio2.Id;
        objCtaFact2.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact2.Fue_creada_en_revchain__c = true;
        objCtaFact2.LTE_PendienteModificacion__c = true;
        objCtaFact2.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact2;

        objCtaFactHija = new CuentaFacturacion__c();
        objCtaFactHija.LTE_NombreCuentaFacturacion__c = 'Cta fact Hija test';
        objCtaFactHija.Cliente__c = objAccount.Id;
        objCtaFactHija.Facturable__c = false;
        objCtaFactHija.LTE_MetodoEnvio__c = 'Servicio postal';
        objCtaFactHija.LTE_CicloFacturacion__c = '15';
        objCtaFactHija.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFactHija.DirCorresp__c = 'Direccion test';
        objCtaFactHija.Ciudad__c = objMunicipio.Id;
        objCtaFactHija.LTE_CuentaFacturacionLTE__c = true;
        objCtaFactHija.LTE_CuentaFacturacionPadre__c = objCtaFact.Id;
        objCtaFactHija.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFactHija;

        objCtaFactHija2 = new CuentaFacturacion__c();
        objCtaFactHija2.LTE_NombreCuentaFacturacion__c = 'Cta fact Hija test 2';
        objCtaFactHija2.Cliente__c = objAccount.Id;
        objCtaFactHija2.Facturable__c = false;
        objCtaFactHija2.LTE_MetodoEnvio__c = 'Servicio postal e Email';
        objCtaFactHija2.LTE_CicloFacturacion__c = '15';
        objCtaFactHija2.LTE_Email__c = 'test2@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFactHija2.DirCorresp__c = 'Direccion test 2';
        objCtaFactHija2.Ciudad__c = objMunicipio2.Id;
        objCtaFactHija2.LTE_CuentaFacturacionLTE__c = true;
        objCtaFactHija2.LTE_CuentaFacturacionPadre__c = objCtaFact2.Id;
        objCtaFactHija2.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFactHija2;

        objSW = new ServiciosWeb__c();
        objSW.Name = 'EdicionCuentasFact';
        objSW.EndPoint__c = 'http://201.245.171.239:7052/Service/BillingCorporate/Endpoint ';
        objSW.Action__c = '/Service/BillingCorporate.serviceagent//UpdateInvoiceData';
        insert objSW;      
    }
    
    @isTest static void unitTest()
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('Code','0');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact());
        Poblacion__c objPoblacion = new Poblacion__c();
        
        Test.startTest();
        if(mapPoblaciones.containsKey(objCtaFact.Ciudad__c))
            objPoblacion = mapPoblaciones.get(objCtaFact.Ciudad__c);
        LTE_ModificarCuentasFacturacion_cls objModificar = new LTE_ModificarCuentasFacturacion_cls();
        objModificar.modificarCuentaRevchain(objCtaFact, objPoblacion);
        Test.stopTest();
    }
    
    @isTest static void test_method_two() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('Code','0');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact());
        Poblacion__c objPoblacion = new Poblacion__c();
        
        Test.startTest();
        if(mapPoblaciones.containsKey(objCtaFact2.Ciudad__c))
            objPoblacion = mapPoblaciones.get(objCtaFact2.Ciudad__c);
        LTE_ModificarCuentasFacturacion_cls objModificar = new LTE_ModificarCuentasFacturacion_cls();
        objModificar.modificarCuentaRevchain(objCtaFact2, objPoblacion);
        Test.stopTest();
    }

    @isTest static void test_method_three() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('Code','45');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact());
        Poblacion__c objPoblacion = new Poblacion__c();
        
        Test.startTest();
        if(mapPoblaciones.containsKey(objCtaFactHija.Ciudad__c))
            objPoblacion = mapPoblaciones.get(objCtaFactHija.Ciudad__c);
        LTE_ModificarCuentasFacturacion_cls objModificar = new LTE_ModificarCuentasFacturacion_cls();
        objModificar.modificarCuentaRevchain(objCtaFactHija, objPoblacion);
        Test.stopTest();
    }

    @isTest static void test_method_four() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('Code','45');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact());
        Poblacion__c objPoblacion = new Poblacion__c();
        
        Test.startTest();
        if(mapPoblaciones.containsKey(objCtaFactHija2.Ciudad__c))
            objPoblacion = mapPoblaciones.get(objCtaFactHija2.Ciudad__c);
        LTE_ModificarCuentasFacturacion_cls objModificar = new LTE_ModificarCuentasFacturacion_cls();
        objModificar.modificarCuentaRevchain(objCtaFactHija2, objPoblacion);
        Test.stopTest();
    }
    
}