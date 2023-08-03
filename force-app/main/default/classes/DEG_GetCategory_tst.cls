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
private class DEG_GetCategory_tst {
    
    @TestSetup
    static void makeData(){

        Cache.Org.put('tokenWatson','TOKENRESPONSE');
        Cache.Org.put('tokenFrame','TOKENFRAME');

        Id RecordTypeId = Schema.SObjectType.DEG_ParamWebServices__c.getRecordTypeInfosByName().get('DEG_Param').getRecordTypeId();

        DEG_ParamWebServices__c paramWebServices = new DEG_ParamWebServices__c(RecordTypeId = RecordTypeId ,
                                                    DEG_Frame__c = 'token' ); 
        insert paramWebServices;

        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatTranscript chat = DEG_TestDataGenerator_cls.createChat(liveChatVisitor.Id, true);
        
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
		insert msgSession;
    }

    @isTest
    static void testGetCategoryWeb() {        
        
        Test.startTest();
        List<DEG_GetCategory_ws.OrquestInput> lstOrquestInput = new List<DEG_GetCategory_ws.OrquestInput>();
        DEG_GetCategory_ws.OrquestInput input = new DEG_GetCategory_ws.OrquestInput();
        input.TipoDocumento = 'CC';
        input.canalBot = 'WEB';
        input.conversationId = [SELECT ID FROM LiveChatTranscript LIMIT 1].Id;
 		input.numeroDocumento = '1033698588';
        
        lstOrquestInput.add(input);
        Test.setMock(HttpCalloutMock.class, new DEG_GetCategory_callout('200'));
        DEG_GetCategory_ws.getCategory(lstOrquestInput);
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetCategoryWsp() {        
        Test.startTest();
        List<DEG_GetCategory_ws.OrquestInput> lstOrquestInput = new List<DEG_GetCategory_ws.OrquestInput>();
        DEG_GetCategory_ws.OrquestInput input = new DEG_GetCategory_ws.OrquestInput();
        input.TipoDocumento = 'CC';
        input.canalBot = 'WPP';
        input.conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
 		input.numeroDocumento = '1033698588';
        
        lstOrquestInput.add(input);
        
        Test.setMock(HttpCalloutMock.class, new DEG_GetCategory_callout('200'));
        DEG_GetCategory_ws.getCategory(lstOrquestInput);
        
        Test.stopTest();
    }
    @isTest
    static void testGetCategoryWspError() {        
        Test.startTest();
        List<DEG_GetCategory_ws.OrquestInput> lstOrquestInput = new List<DEG_GetCategory_ws.OrquestInput>();
        DEG_GetCategory_ws.OrquestInput input = new DEG_GetCategory_ws.OrquestInput();
        input.TipoDocumento = 'CC';
        input.canalBot = 'WPP';
        input.conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
 		input.numeroDocumento = '1033698588';
        
        lstOrquestInput.add(input);
        Test.setMock(HttpCalloutMock.class, new DEG_GetCategory_callout('201'));
        DEG_GetCategory_ws.getCategory(lstOrquestInput);
        Test.stopTest();
    }
    @isTest
    static void testGetCategoryChatError() {        
        Test.startTest();
        List<DEG_GetCategory_ws.OrquestInput> lstOrquestInput = new List<DEG_GetCategory_ws.OrquestInput>();
        DEG_GetCategory_ws.OrquestInput input = new DEG_GetCategory_ws.OrquestInput();
        input.TipoDocumento = 'CC';
        input.canalBot = 'WEB';
        input.conversationId = [SELECT ID FROM LiveChatTranscript LIMIT 1].Id;
 		input.numeroDocumento = '1033698588';
        
        lstOrquestInput.add(input);
        Test.setMock(HttpCalloutMock.class, new DEG_GetCategory_callout('201'));
        DEG_GetCategory_ws.getCategory(lstOrquestInput);
        
        Test.stopTest();
    }
    
}