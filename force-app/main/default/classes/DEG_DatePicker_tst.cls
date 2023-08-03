/**
 * @description       : 
 * @author            : Pablo Arrieta
 * @group             : 
 * @last modified on  : 06-02-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   06-02-2021   Pablo Arrieta   Initial Version
**/
@isTest
private class DEG_DatePicker_tst {
    
    @TestSetup
	static void makeData(){

        Cache.Org.put('tokenWatson','TOKENRESPONSE');

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
        
	}
    
    @isTest
    static void testSendDateRange(){
        String sessionId = 'Etb 12298791-112221';
        
        String expectedResponse = '{ '+
                                    '"idResponse":"SuspencionConfirmada",'+
                                    '"data":{'+
                                    '"dataini":"16/04/2021",'+
                                    '"dataend":"18/04/2021",'+
                                    '"message":"3"'+
                                    '},'+
                                    '"idConversacion":"'+sessionId+'"'+
                                '}';
        
        DEG_DatePicker_ctr.RequestInput reqInput = new DEG_DatePicker_ctr.RequestInput();
        reqInput.dateini = '16/04/2021';
        reqInput.dateend = '18/04/2021';
        reqInput.days = '3';
        reqInput.sessionId = sessionId;
        
        Test.startTest();
        String response = DEG_DatePicker_ctr.sendDateRange(reqInput);
        Test.stopTest();
        
        system.assertEquals(expectedResponse.trim(), response);
    }
    
    @isTest
    static void testSendDate(){
        
        String sessionId = 'Etb 12298791-112221';
        
       


        String expectedResponse =  '{ '+
                                 '"login": false ,'+
                                 '"idResponse":"visita tecnica",'+
                                 '"data":{'+
                                 '"menssage":"16/04/2021"'+
                                 '},'+
            				     '"idConversacion":"'+sessionId+'"'+
                             '}';
        
        DEG_DatePicker_ctr.RequestInput reqInput = new DEG_DatePicker_ctr.RequestInput();
        reqInput.dateVisita = '16/04/2021';
        reqInput.tokenWhatson = '1c3dc37f-99da-4180-9bf2-93b0c7226328';
        reqInput.sessionId = sessionId;
        
        Test.startTest();
        String response = DEG_DatePicker_ctr.sendDate(reqInput);
        Test.stopTest();
        
        system.assertEquals(expectedResponse, response);
    }
    
    @isTest
    static void testCancelDateRange(){
        
        String sessionId = 'Etb 12298791-112221';
        
        String expectedResponse =  '{ '+
                                '"idResponse": "SuspensionCancelada",'+
                                '"login": false ,'+
                                '"menssage":"suspencion cancelada",'+
            				    '"idConversacion":"'+sessionId+'"'+
                                '}';
        
        DEG_DatePicker_ctr.RequestInput reqInput = new DEG_DatePicker_ctr.RequestInput();
        reqInput.sessionId = sessionId;
        reqInput.tokenWhatson = '';
        
        Test.startTest();
        String response = DEG_DatePicker_ctr.cancelDateRange(reqInput);
        Test.stopTest();
        
        system.assertEquals(expectedResponse, response);
    }
    
    @isTest
    static void testCancelDate() {
        String sessionId = 'Etb 12298791-112221';
        
        String expectedResponse =  '{ '+
                                '"login": false ,'+
                                '"menssage":"Cancelo visita tecnica",'+
                                '"idConversacion":"'+sessionId+'"'+
                                '}';
        
        DEG_DatePicker_ctr.RequestInput reqInput = new DEG_DatePicker_ctr.RequestInput();
        reqInput.sessionId = sessionId;
        reqInput.tokenWhatson = '';
        
        Test.startTest();
        String response = DEG_DatePicker_ctr.cancelDate(reqInput);
        Test.stopTest();
        
        system.assertEquals(expectedResponse, response);
    }

}