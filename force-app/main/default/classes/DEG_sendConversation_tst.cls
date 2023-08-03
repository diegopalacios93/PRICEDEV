@istest
public with sharing class DEG_sendConversation_tst {
    
    @testSetup static void setup() {
        List<Case> lstCasTest;
        case objcastst=new case();
        User userTest;
        List<LiveChatTranscript> lstLiveChatTransc;
        MessagingEndUser msgEndUser;
        List<MessagingSession> lstMsgSession;

            LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
            insert liveChatVisitor;
            lstCasTest = DEG_TestDataGenerator_cls.createCase(UserInfo.getUserId(), 1);
            insert lstCasTest;
        	objcastst.clone(false);
        	objcastst.Subject='Caso de respaldo para el envío de copia de conversaciones de mensajería NO BORRAR';
        	insert  objcastst;
            msgEndUser = DEG_TestDataGenerator_cls.createMessagingUser();
            insert msgEndUser;
            lstMsgSession = DEG_TestDataGenerator_cls.createMessagingSession(msgEndUser.Id, lstCasTest.get(0).Id, 1);
        	insert lstMsgSession;
        	system.debug(lstMsgSession);
        	MessagingSession objmss=lstMsgSession[0];
        	ConversationEntry objcoen=new ConversationEntry(ActorId=lstMsgSession[0].MessagingEndUserId,
                                                           Message='hola',
                                                           ConversationId=lstMsgSession[0].id,
                                                            Seq=0,
                                                            EntryTime=datetime.now(), 
                                                            EntryType='text',
                                                            ActorName='whatsapp:+52354',
                                                            ActorType='EndUser');
        	insert objcoen;
            lstLiveChatTransc = DEG_TestDataGenerator_cls.createLiveChatTranscrip(liveChatVisitor.Id, lstCasTest.get(0).Id, 1);
            insert lstLiveChatTransc;
    }
    
    @istest 
    public static void test1(){
        test.startTest();
        List<MessagingSession> lstMessagingSession = [SELECT Id,CaseId,MessagingChannelId FROM MessagingSession LIMIT 1];
        System.debug('lstCase test: ' +lstMessagingSession);
        list<id> lstid= new list<id>();
        lstid.add(lstMessagingSession[0].CaseId);
        
        DEG_sendConversation.SendMsj(lstid);
        test.stopTest();
    }
}