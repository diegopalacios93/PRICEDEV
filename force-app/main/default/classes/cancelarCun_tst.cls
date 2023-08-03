//@IsTest(SeeAllData=true)
@IsTest
private class cancelarCun_tst {

    static testMethod void cancelarCunTest() {
    	
    	objPruebas_tst obj =new objPruebas_tst();
        List<sObject> ls = Test.loadData(CUN_Center_Abajo__c.sObjectType, 'ConfCUN');
    	List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
    	
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;
    	
    	Contact contacto=obj.objContact();
    	contacto.AccountId=cliente.id;
    	insert contacto;
    	
    	Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SOPORTE TECNICO').getRecordTypeId();
    	Case caso=obj.objCase();
    	caso.AccountId=cliente.id;
    	caso.ContactId=contacto.id;
    	caso.RecordTypeId=devRecordTypeIdCase;
    	caso.CodigouniconumericoCUN__c='1234567890123456';
    	insert caso;
    	
    	PageReference pageRef0 = Page.cancelarCun;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', caso.id);    	
    	cancelarCun_ctr cancelarCun=new cancelarCun_ctr();
    	cancelarCun.getItems();
    	cancelarCun.tipologia='Tipología Exenta';
    	cancelarCun.guardar();
    	
    	caso.CodigouniconumericoCUN__c=null;
    	update caso;
    	cancelarCun.guardar();

        Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseCun());
        test.startTest();
        String jobId = System.schedule('cancelarCun_bch','0 0 0 * * ? *',new cancelarCun_sch());
		test.stopTest();

    }
    
    static testMethod void crearTipificacionTest() {
    	
    	objPruebas_tst obj =new objPruebas_tst();
        List<sObject> ls = Test.loadData(CUN_Center_Abajo__c.sObjectType, 'ConfCUN');
    	List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
    	
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;
    	
    	Contact contacto=obj.objContact();
    	contacto.AccountId=cliente.id;
    	insert contacto;
    	
    	Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SOPORTE TECNICO').getRecordTypeId();
    	Case caso=obj.objCase();
    	caso.AccountId=cliente.id;
    	caso.ContactId=contacto.id;
    	caso.RecordTypeId=devRecordTypeIdCase;
    	caso.CodigouniconumericoCUN__c='1234567890123456';
    	insert caso;
    	
    	MatrizTipificacion__c matriz=obj.objMatrTip();
    	insert matriz;
    	
    	PageReference pageRef0 = Page.CrearTipificacion_pag;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('newid', caso.id);
        ApexPages.currentPage().getParameters().put('retURL', '');
    	CrearTipificacion_ctr crearTipificacion=new CrearTipificacion_ctr(new ApexPages.StandardController(new MatrizTipificacion__c()));
    	crearTipificacion.CargarTipoCaso();
    	crearTipificacion.AnalizaAccion();
    	crearTipificacion.Nivel01();
    	crearTipificacion.Refresco0();
    	crearTipificacion.Guardar();
    	//crearTipificacion.Cancelar();
    	
    
    
    }
}