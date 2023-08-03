@isTest
private class ContactosViabilidad_tst {

    static testMethod void myUnitTest() {
        GeneraData_cls.generarData();
        GeneraData_cls.generarViabilidad();
        
        test.startTest();
        PageReference pageRef = Page.ContactosViabilidad_pag;
        pageRef.getParameters().put('id', GeneraData_cls.via.id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(GeneraData_cls.via);
        
        ContactosViabilidad_ctr controller = new ContactosViabilidad_ctr(standardController);
        controller.idContacto = GeneraData_cls.con.Id;
        controller.paginaContactoRedirect();
        test.stopTest();
    }
}