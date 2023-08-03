/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-09-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-09-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@isTest
private class DEG_ResponseUtilities_tst {
    
    @TestSetup
	static void makeData(){
        Cache.Org.put('tokenWatson','TOKENRESPONSE');
        
		LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                        FROM LiveChatButton
                                        WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo' LIMIT 1];

		LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;

		LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
        chat.DEG_SessionIdWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226328';
		insert chat;
        
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];

		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+573125127626' ,
															MessagingPlatformKey = 'whatsapp:+573125127626',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp'  );
		insert msgEndUser;
		
		MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Active' );
        msgSession.DEG_SessionIdWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226328';
		insert msgSession;

	}
    
    @isTest
    static void testGetCanalBot() {
        DEG_CanalBot__mdt mdtCanal =  [SELECT DEG_NombreCanalBot__c
										FROM DEG_CanalBot__mdt
										LIMIT 1];
        Test.startTest();
        DEG_ResponseUtilities_cls.getCanalBotByName(mdtCanal.DEG_NombreCanalBot__c);
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateChatObjectWPP(){
        Boolean expectedResponse = true;
        List<DEG_ConsumeOrquestadorAsync_ws.Input> lstInput = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
        DEG_ConsumeOrquestadorAsync_ws.Input input = new DEG_ConsumeOrquestadorAsync_ws.Input();
        input.canalBot = 'WPP';
        input.conversationId = [Select ID from MessagingSession limit 1].ID;
        input.sessionId = '';
        lstInput.add(input);
        String message = 'new message';
        DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize analizeWrapper = new DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize();
        
        Test.startTest();
        Boolean response = DEG_ResponseUtilities_cls.updateChatObjectWpp(lstInput, message, analizeWrapper);
        Test.stopTest();
        
        System.assertEquals(expectedResponse, response);
    }
    
    @isTest
    static void testUpdateChatObjectWEB(){
        Boolean expectedResponse = true;
        List<DEG_ConsumeOrquestadorAsync_ws.Input> lstInput = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
        DEG_ConsumeOrquestadorAsync_ws.Input input = new DEG_ConsumeOrquestadorAsync_ws.Input();
        input.canalBot = 'WEB';
        input.conversationId = [Select ID from LiveChatTranscript limit 1].ID;
        input.sessionId = '';
        lstInput.add(input);
        String message = 'new message';
        DEG_ConsumeOrquestadorHelper_cls.wrpAnalize analizeWrapper = new DEG_ConsumeOrquestadorHelper_cls.wrpAnalize();
        
        Test.startTest();
        Boolean response = DEG_ResponseUtilities_cls.updateChatObject(lstInput, message, analizeWrapper);
        Test.stopTest();
        
        System.assertEquals(expectedResponse, response);
    }
    
    @isTest
    static void testToMap(){
        String json = '{'+
            '"data": "test"'+
            '}';
        Test.startTest();
        DEG_ResponseUtilities_cls.toMap(json);
        Test.stopTest();
    }
    
    @isTest
    static void testGetInputByConversationIdWEB(){
        
        LiveChatTranscript chat = [Select ID, DEG_ClientSessionWatsonId__c from LiveChatTranscript limit 1];
        
        chat.DEG_ClientSessionWatsonId__c = 'Etb-'+chat.Id;
        
        update chat;
        
        Test.startTest();
        DEG_ResponseUtilities_cls.getInputByConversationId('', chat.DEG_ClientSessionWatsonId__c);
        Test.stopTest();
    }
    
    @isTest
    static void testGetInputByConversationIdWPP(){
        
        MessagingSession chat = [Select ID, DEG_ClientSessionWatsonId__c from MessagingSession limit 1];
        
        chat.DEG_ClientSessionWatsonId__c = 'WPP-'+chat.Id;
        
        update chat;
        
        Test.startTest();
        DEG_ResponseUtilities_cls.getInputByConversationId('', chat.DEG_ClientSessionWatsonId__c);
        Test.stopTest();
    }

}