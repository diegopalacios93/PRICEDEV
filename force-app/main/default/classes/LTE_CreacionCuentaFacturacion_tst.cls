/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase controladora de la visualforce encargada de capturar la información de creación de cuentas de facturación en salesforce.                          
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     26/08/2015  Carlos A. Rodriguez B.          Class creation.

*******************************************************************************/
@isTest
private class LTE_CreacionCuentaFacturacion_tst
{
  public static Account objAccount;
  public static Poblacion__c objDepto;
  public static Poblacion__c objMunicipio;
  public static CuentaFacturacion__c objCtaFact;

  public static void CreateData()
    {
      objAccount = new Account();
      objAccount.Name = 'Test Name';
      objAccount.RazonSocial__c = 'Test razon social';
      objAccount.Tipodedocumento__c = '123456765432';
      objAccount.Estado_Cuenta__c = 'Activo'; 
      objAccount.Phone = '3133212321';
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
      objCtaFact.Fue_creada_en_revchain__c = true;
      objCtaFact.DirCorresp__c = 'Test DirCorresp';
      insert objCtaFact;
    }
  
  @isTest static void unitTest()      
  {
    Test.startTest();
    CreateData();

    system.currentPageReference().getParameters().put('Id', objCtaFact.Id);
    ApexPages.Standardcontroller controller = new ApexPages.StandardController(objCtaFact);        
        LTE_CreacionCuentaFacturacion_ctr ctr = new LTE_CreacionCuentaFacturacion_ctr(controller);
        ctr.redirectPage();
        ctr.guardar();

        list<SelectOption> lstOpcionesMetodoEnvio   = ctr.lstOpcionesMetodoEnvio;
        list<SelectOption> lstOpcionesCicloFact   = ctr.lstOpcionesCicloFact;
        list<SelectOption> lstOpcionesMetodoReclam   = ctr.lstOpcionesMetodoReclam;

    Test.stopTest();
  }
  
  @isTest static void unitTest1()
  {
    Test.startTest();
    CreateData();

    objCtaFact.LTE_CuentaFacturacionLTE__c = false;
    update objCtaFact;

    system.currentPageReference().getParameters().put('Id', objCtaFact.Id);
    ApexPages.Standardcontroller controller = new ApexPages.StandardController(objCtaFact);        
        LTE_CreacionCuentaFacturacion_ctr ctr = new LTE_CreacionCuentaFacturacion_ctr(controller);
        ctr.redirectPage();

    Test.stopTest();
  }

  @isTest static void unitTest2()
  {
    Test.startTest();
    CreateData();

    //system.currentPageReference().getParameters().put('Id', objCtaFact.Id);
    ApexPages.Standardcontroller controller = new ApexPages.StandardController(objCtaFact);        
        LTE_CreacionCuentaFacturacion_ctr ctr = new LTE_CreacionCuentaFacturacion_ctr(controller);  
        ctr.objCuentaFact.LTE_NombreCuentaFacturacion__c = '';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.LTE_NombreCuentaFacturacion__c = 'nombre cta fact';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.Cliente__c = objAccount.Id;
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.LTE_CuentaFacturacionPadre__c = objCtaFact.Id;
        ctr.objCuentaFact.Facturable__c = true;
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.strMetodoEnvioSelec = 'Email';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.strCicloFactSelec = '15';
        ctr.objCuentaFact.LTE_Email__c = '';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.LTE_Email__c = 'test';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.LTE_Email__c = 'test@test.com';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        //[AG:2016-02-15 Se quita el campo LTE_DireccionFacturacion__c
        //ctr.objCuentaFact.LTE_DireccionFacturacion__c = 'direccion test';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.Ciudad__c = objMunicipio.Id;
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.LTE_CiudadAlterna__c = objMunicipio.Id;
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();
        ctr.objCuentaFact.LTE_CiudadAlterna__c = null;
        ctr.objCuentaFact.LTE_DireccionAlterna__c = 'test alterna';
        ctr.objCuentaFact.DirCorresp__c = 'Test DirCorresp';
        ctr.guardar();

    Test.stopTest();
  }
  
}