@isTest
private class DEG_ParamWebServicesHandler_tst {

    @isTest
    static void testCreateParamWebServices(){
        Test.startTest();
        DEG_ParamWebServicesHandler_cls paramWebService = new DEG_ParamWebServicesHandler_cls('Cobertura');
        Test.stopTest();
    }
    @isTest
    static void testCreateTokenParamWebServices(){
        DEG_ParamWebServicesHandler_cls paramWebService = new DEG_ParamWebServicesHandler_cls();
        Test.startTest();
        paramWebService.createTokenParamWebServices('2bbbb85f-c678-4db3-a3cd-4c1c87e1284e');
        Test.stopTest();
    }
    @isTest
    static void testUpdateTokenParamWebServices(){
        Id RecordTypeId = Schema.SObjectType.DEG_ParamWebServices__c.getRecordTypeInfosByName().get('DEG_Token').getRecordTypeId();
        DEG_ParamWebServices__c paramWebServices = new DEG_ParamWebServices__c(RecordTypeId = RecordTypeId ,
                                                    DEG_Token__c = '2bbbb85f-c678-4db3-a3cd-4c1c87e1284e' ); 
        insert paramWebServices;

        Test.startTest();
        DEG_ParamWebServicesHandler_cls paramWebService = new DEG_ParamWebServicesHandler_cls();
        paramWebService.createTokenParamWebServices('2bbbb85f-c678-4db3-a3cd-4c1c87e1284e');
        Test.stopTest();
    }
    @isTest
    static void testgetInstance(){
        Test.startTest();
        DEG_ParamWebServicesHandler_cls.getInstance('Cobertura');
        Test.stopTest();
    }

    
}