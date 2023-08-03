@isTest
private class CrearCuenta_tst {

    static testMethod void dataCreditoCrearCuenta() {
        objPruebas_tst.confPersonalizadas();
    	Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseScoreDeDatacredito());
        test.startTest();
        MockServiciosWeb.CodError='13';
    	PageReference pageRef0 = Page.CrearCuenta;
    	Test.setCurrentPage(pageRef0);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Account());
        CrearCuenta_ctr sD=new CrearCuenta_ctr(sc);
        sD.getTiposDeRegistro();
        sD.registro='Aliado';
        sD.crearRegistro();
        sD.registro='Cliente Principal';
        sD.crearRegistro();
        sD.cuenta.Name='ETB SA';
        sD.cuenta.AccountNumber='4803483408';
        sD.cuenta.Phone='12355656';
        sd.cuenta.Tipodedocumento__c='Cédula de ciudadanía';
        sd.cuenta.Direccion__c='Cédula de ciudadanía';
        MockServiciosWeb.CodError='13';
        sD.Guardar();
        sD.cuenta.Cuenta__c=sD.cuenta.id;
        sD.Sucursales();
        sD.showPopup();
        sD.closePopup();
        test.stopTest();
    }
}