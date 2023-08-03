@isTest
public with sharing class deg_updatecsv_tst {
    /**
    * @description inserción de registros de prueba para los métodos test
    */
    @testSetup 
    static void setup() 
    {
        String tipoRegistroCuenta = Schema.sObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        Account cuenta = new Account(Name='Digital Engagement NO BORRAR', Phone='12345678', RecordTypeId=tipoRegistroCuenta);
        Insert cuenta;
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        Contact contacto = new Contact(FirstName='pedro12', LastName='romero2', DEG_Numero_Celular__c='23344435',NumerodeIdentificacion__c='312121222',Tipodedocumento__c='Cédula de ciudadanía', RecordTypeId=idrec, AccountId=cuenta.id);
        insert contacto;
        List<ContentVersion> csvList = new List<ContentVersion>();
        ContentVersion cveFile = new ContentVersion();
        cveFile.ContentLocation = 'S';
        cveFile.VersionData = Blob.valueOf('Nombre;Apellido;Número Celular;Número de Identificación;Tipo de documento \r\n pedro12;romero2;23344435;312121222;Cédula de ciudadanía');
        cveFile.Title = 'TestFile.csv';
        cveFile.PathOnClient = 'TestFile.csv';
        csvList.add(cveFile);
        ContentVersion cveFile2 = new ContentVersion();
        cveFile2.ContentLocation = 'S';
        cveFile2.VersionData = Blob.valueOf('Nombre;Apellido;Número Celular;Número de Identificación;Tipo de documento \r\n ;;"23344435";;');
        cveFile2.Title = 'TestFile2.csv';
        cveFile2.PathOnClient = 'TestFile2.csv';
        csvList.add(cveFile2);
        ContentVersion cveFile3 = new ContentVersion();
        cveFile3.ContentLocation = 'S';
        cveFile3.VersionData = Blob.valueOf('Nombre;Apellido;Número Celular;Número de Identificación;Tipo de documento \r\n ;;;;');
        cveFile3.Title = 'TestFile3.csv';
        cveFile3.PathOnClient = 'TestFile3.csv';
        csvList.add(cveFile3);
        ContentVersion cveFile4 = new ContentVersion();
        cveFile4.ContentLocation = 'S';
        cveFile4.VersionData = Blob.valueOf('Nombre;Apellido;Número Celular;Número de Identificación;Tipo de documento \r\n test');
        cveFile4.Title = 'TestFile4.csv';
        cveFile4.PathOnClient = 'TestFile4.csv';
        csvList.add(cveFile4);
        insert csvList;
    }
    
    @isTest
    Public static void correctCSV(){
        Test.startTest();
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        ContentVersion cveFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='TestFile.csv' Limit 1];
        deg_updatecsv_ctr.readCSVFile(cveFile.ContentDocumentId,'ReinjectionCharge',idrec);  
        Test.stopTest();
    }
    
    @isTest
    Public static void incorrectCSV(){
        Test.startTest();
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        ContentVersion cveFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='TestFile2.csv' Limit 1];
        deg_updatecsv_ctr.readCSVFile(cveFile.ContentDocumentId,'ReinjectionCharge',idrec);  
        Test.stopTest();
    }
    
    @isTest
    Public static void incorrectCSV2(){
        Test.startTest();
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        ContentVersion cveFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='TestFile3.csv' Limit 1];
        deg_updatecsv_ctr.readCSVFile(cveFile.ContentDocumentId,'ReinjectionCharge',idrec);  
        Test.stopTest();
    }
    
    @isTest
    Public static void incorrectCSV3(){
        Test.startTest();
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        ContentVersion cveFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title='TestFile4.csv' Limit 1];
        try{
            deg_updatecsv_ctr.readCSVFile(cveFile.ContentDocumentId,'ReinjectionCharge',idrec);
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }
}