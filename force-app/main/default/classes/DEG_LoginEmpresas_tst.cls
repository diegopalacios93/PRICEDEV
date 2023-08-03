/**
 * @description       : 
 * @author            : Adrian Bohorquez
 * @group             : 
 * @last modified on  : 10-08-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   10-08-2021   Adrian Bohorquez   Initial Version
**/
@isTest
private class DEG_LoginEmpresas_tst {
	@TestSetup
	static void makeData(){
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
        Cache.Org.put('tokenFrame','TOKENFRAME');

        Id RecordTypeId = Schema.SObjectType.DEG_ParamWebServices__c.getRecordTypeInfosByName().get('DEG_Param').getRecordTypeId();

        DEG_ParamWebServices__c paramWebServices = new DEG_ParamWebServices__c(RecordTypeId = RecordTypeId ,
                                                    DEG_Frame__c = 'token' ); 
        insert paramWebServices;

        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
										 FROM LiveChatButton
										 WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
										 LIMIT 1];

		LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;

		LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , 
                                                         LiveChatButtonId = liveChatButton.Id,  
                                                         DEG_ClientSessionWatsonId__c = 'Etb 12298791-112221',
                                                         DEG_SessionIdWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226328',
                                                         DEG_TokenWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226328'
                                                         );
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
                                                           	DEG_ClientSessionWatsonId__c = 'whatsapp_573125127626',
                                                            DEG_SessionIdWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226328',
                                                           	DEG_TokenWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226328',
															Status = 'Active' );
        
        insert msgSession;
    }
    @isTest
    static void testAuthentication() {
        List<MessagingSession> msgSession = [SELECT Id FROM MessagingSession LIMIT 1];
        DEG_Login_callout_empresas_cls mock = new DEG_Login_callout_empresas_cls();
        Test.startTest();
        DEG_LoginEmpresas_cls.RequestInput login = new DEG_LoginEmpresas_cls.RequestInput();
        login.password = '8Caracters';
        login.mail = 'victor.aparicio@tivit.com';
        login.sessionId = 'Etb 12298791-112221';
        //login.tokenWatson = '1c3dc37f-99da-4180-9bf2-93b0c7226328';
        Test.setMock(HttpCalloutMock.class, mock);
        DEG_LoginEmpresas_cls.authenticate(login);   
        Test.stopTest();
    }
    
    @isTest
    static void testCancel() {
        Test.startTest();
        DEG_Login.cancelAuth('Etb 12298791-112221', '1c3dc37f-99da-4180-9bf2-93b0c7226328');   
        Test.stopTest();
    }
    
}