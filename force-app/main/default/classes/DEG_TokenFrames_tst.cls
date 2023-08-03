@isTest
private class DEG_TokenFrames_tst {

    @isTest
    static void testAuthentication() {
        Cache.Org.put('tokenFrame','TOKENFRAME');

        Id RecordTypeId = Schema.SObjectType.DEG_ParamWebServices__c.getRecordTypeInfosByName().get('DEG_Param').getRecordTypeId();

        DEG_ParamWebServices__c paramWebServices = new DEG_ParamWebServices__c(RecordTypeId = RecordTypeId ,
                                                    DEG_Frame__c = 'token' ); 
        insert paramWebServices;

        DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('getCalloutToken');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
        DEG_TokenFrames_cls.getTokenFrame();
		DEG_TokenFrames_cls.callOutToken();
		Test.stopTest();

    }
    
}