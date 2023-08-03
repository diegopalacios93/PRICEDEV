/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraciones Clientes CUN
Descripción:			Tarea programada, para el Batch procesar los CUN que estan pendientes de ser generados
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		29-08-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
@isTest
private class ActualizarGenerico_tst {

    static testMethod void datacredito() {
        // TO DO: implement unit test
        //crear registro objeto generico
        //llamar el batch
        
        
        List<sObject> ls = Test.loadData(HomologacionCampos__c.sObjectType, 'HomologacionCampos');
        List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
        
        objPruebas_tst obj =new objPruebas_tst();
        
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	cliente.AccountNumber='1234567890';
    	cliente.Tipodedocumento__c='Cédula de ciudadanía';
    	System.debug(devRecordTypeId);
    	insert cliente;
    	objPruebas_tst.confPersonalizadas();
    	
    	Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseScoreDeDatacredito());
        test.startTest();
        MockServiciosWeb.CodError='13';
    	PageReference pageRef0 = Page.ScoreDeDatacredito_pag;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', cliente.id); 
        ScoreDeDatacredito_ctr sD=new ScoreDeDatacredito_ctr();
        sD.inicio();
        cliente.DataCredito_Fecha_Scoring__c=Date.today();
        update cliente;
        MockServiciosWeb.CodError='14';
        sD.consultar(); 
        test.stopTest();

    }
    
    static testMethod void dataCreditoCrearCuenta() {
        // TO DO: implement unit test
        //crear registro objeto generico
        //llamar el batch
        

        List<sObject> ls = Test.loadData(HomologacionCampos__c.sObjectType, 'HomologacionCampos');
        List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
        
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
        sd.cuenta.Tipodedocumento__c='Cédula de ciudadanía';
        MockServiciosWeb.CodError='13';
        sD.Guardar(); 
        test.stopTest();


    }

    static testMethod void batchGenerico() {

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();

        Database.executeBatch(new ActualizarGenerico_bch(),5);
        objPruebas_tst obj =new objPruebas_tst();
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        cliente.AccountNumber='1234567890';
        cliente.Tipodedocumento__c='Cédula de ciudadanía';
        System.debug(devRecordTypeId);
        insert cliente;

        Generico__c gen =new Generico__c(Datacredito_clasificacion__c='222',
            DataCredito_Fecha_Scoring__c=Date.today(),
            Datacredito_Fecha_Validacion__c=Date.today(),
            Datacredito_puntaje__c='puntaje',
            Datacredito_tipo__c='tipo',
            NO_Estado__c='Pendiente',
            NO_Ids__c=cliente.id);
        insert gen;
        
        test.startTest();
        Database.executeBatch(new ActualizarGenerico_bch(),5);
        test.stopTest();

    }
}