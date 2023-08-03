@isTest
private class DEG_RequestManagement_tst {
	
    @isTest
    static void testRequestManagement() {
        
        DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('requestManagementError');
        
        Map<String,String> mapHeaders = new Map<String,String>();
        mapHeaders.put('test', 'test');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        DEG_RequestManagement_cls RequestManagement = new DEG_RequestManagement_cls();
        DEG_RequestManagement_cls RequestManagementTest = new DEG_RequestManagement_cls('test');
        RequestManagement.setTextRequest('test');
        RequestManagement.setNamedCredential('test');
        RequestManagement.setUri('test');
        RequestManagement.setCallFrom('test');
        RequestManagement.setHttpHeaders(mapHeaders);
        RequestManagement.init('authMail');
        //RequestManagement.execute();
        RequestManagement.getHttpClient();
        
        Test.stopTest();
    }
    
}