@isTest
private class DEG_ResultObject_tst {
	
    @isTest
    static void testResultObject() {

        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
        insert liveChatVisitor;
        List<LiveChatVisitor> lstLiveChatVisitor = new List<LiveChatVisitor>();
        lstLiveChatVisitor.add(liveChatVisitor);
        
        Test.startTest();
        DEG_ResultObject_cls ResultObject1 = new DEG_ResultObject_cls(1, 'message', liveChatVisitor);
        DEG_ResultObject_cls ResultObject2 = new DEG_ResultObject_cls(1, 'message', lstLiveChatVisitor);
        DEG_ResultObject_cls ResultObject3 = new DEG_ResultObject_cls(1, 'message', '{"data":"test"}');
        DEG_ResultObject_cls ResultObject4 = new DEG_ResultObject_cls(1, 'message');       
        
        Test.stopTest();
    }
    
}