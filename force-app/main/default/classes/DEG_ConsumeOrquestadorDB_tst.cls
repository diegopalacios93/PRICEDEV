/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-17-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class DEG_ConsumeOrquestadorDB_tst {
    
    @TestSetup
	static void makeData(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar' OR Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
                                         LIMIT 1];
        
        System.runAs(u){
    
            LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
            insert liveChatVisitor;
    
            LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
            chat.DEG_LastResponse__c = 'Last response';
            insert chat;
        }
	}
    
    @isTest
    static void testCallOut() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar' OR Name='Standard User'];
        User u = [SELECT Id, ProfileId FROM User where ProfileId =: p.Id and alias = 'standt' limit 1];

        System.runAs(u) {
            LiveChatTranscript chat = [SELECT ID, DEG_LastResponse__c, DEG_TransferToAgent__c FROM LiveChatTranscript LIMIT 1];
            List<DEG_ConsumeOrquestadorDB_cls.Input> inputLst = new List<DEG_ConsumeOrquestadorDB_cls.Input>();
            inputLst.add(new DEG_ConsumeOrquestadorDB_cls.Input());
            inputLst[0].conversationId = chat.Id;
            Test.startTest();
            DEG_ConsumeOrquestadorDB_cls.makeGetCallout(inputLst);
            chat.DEG_TransferToAgent__c = true;
            chat.DEG_LastResponse__c = 'Last response 2';
            update chat;
            DEG_ConsumeOrquestadorDB_cls.makeGetCallout(inputLst);
            Test.stopTest();  
        }
        
    }

    @isTest
    static void testCallout2() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar' OR Name='Standard User'];
        User u = [SELECT Id, ProfileId FROM User where ProfileId =: p.Id and alias = 'standt' limit 1];

        System.runAs(u) {
            LiveChatTranscript chat = [SELECT ID, DEG_LastResponse__c, DEG_TransferToAgent__c FROM LiveChatTranscript LIMIT 1];
            List<DEG_ConsumeOrquestadorDB_cls.Input> inputLst = new List<DEG_ConsumeOrquestadorDB_cls.Input>();
            inputLst.add(new DEG_ConsumeOrquestadorDB_cls.Input());
            inputLst[0].conversationId = chat.Id;
            Test.startTest();
            chat.DEG_TransferToAgent__c = true;
            chat.DEG_NombredelaCola__c = System.Label.DEG_SoporteTecnicoMasivos;
            update chat;
            DEG_ConsumeOrquestadorDB_cls.makeGetCallout(inputLst);
            Test.stopTest();  
            System.assertNotEquals(null, chat);
        }       
    }

}