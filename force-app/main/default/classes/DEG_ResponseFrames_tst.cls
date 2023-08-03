/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-09-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@isTest
private class DEG_ResponseFrames_tst {
    
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


		MessagingEndUser msgEndUserEmpresas= new MessagingEndUser(	Name = 'whatsapp:+573125127627' ,
															MessagingPlatformKey = 'whatsapp:+573125127627',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp'  );
		insert msgEndUserEmpresas;
		
		MessagingSession msgSessionEmpresas = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUserEmpresas.Id,
                                                           	DEG_ClientSessionWatsonId__c = 'whatsApp_empresas573125127627',
                                                            DEG_SessionIdWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226329',
                                                           	DEG_TokenWatson__c = '1c3dc37f-99da-4180-9bf2-93b0c7226329',
															Status = 'Active' );

		insert msgSessionEmpresas;

	}

    @isTest
    static void testGetCalloutEmpresas() {
        List<MessagingSession> msgSession = [SELECT Id FROM MessagingSession LIMIT 1];
        Test.startTest();
        String idMessaging = 'DEG-WPP-' + msgSession[0].Id;
        String mck = 
            '{'+
            '  "WSResponseHeader": {'+
            '     "System": {'+
            '         "name": "MAX",'+
            '         "correlationID": "DE-0001",'+
            '         "processingServer": null'+
            '     },'+
            '     "Service": {'+
            '        "status": "OK",'+
            '        "responseDate": "2021-03-25T21:54:38.8825486+00:00",'+
            '        "processingServer": null,'+
            '        "statusDetail": [{'+
            '           "errorCode": "OK_01",'+
            '           "errorDetailCode": "La solicitud MIETB-25032021-16246191 fue exitosa",'+
            '           "errorMessage": "Se autenticó al usuario exitosamente"'+
            '        }]'+
            '     },'+
            '     "Property": []'+
            '  },'+
            '  "WSResponseBody": {}'+
            '}';
            String reqBody = '{'+
                '"data": '+mck+','+
                '"accion":'+ null +','+
                '"idConversacion":"whatsapp_573125127626",'+
                '"palabraClave": "LoginAuth",'+
                '"botId":"etb_max_qa",'+
                '"idMessaging":"'+idMessaging+'"'+
                '}';
            DEG_ResponseFrames_ws.getCallout(reqBody , '', '');
        Test.stopTest();
    }

}