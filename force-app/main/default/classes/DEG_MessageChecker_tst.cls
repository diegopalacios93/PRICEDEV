@isTest
private class DEG_MessageChecker_tst {
    
    @TestSetup
	static void makeData(){
		LiveChatButton liveChatButton = [SELECT Id, DeveloperName
										 FROM LiveChatButton
										 WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
										 LIMIT 1];

		LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;

		LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id, ChatKey = 'e000000e-9100-4444-890b-3a57a251409b');
		insert chat;
        
	}

    @isTest
    static void testGetMessageJSON(){
        
        Test.startTest();
        DEG_MessageChecker_ctr.getMessageJSON('e000000e-0000-4444-8888-33333444444b');
        DEG_MessageChecker_ctr.getMessageJSON('e000000e-9100-4444-890b-3a57a251409b');
        Test.stopTest();
        
    }
    
}