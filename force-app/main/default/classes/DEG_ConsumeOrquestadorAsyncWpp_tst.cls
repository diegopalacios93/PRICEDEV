/**
 * @description       : 
 * @author            : j.martinez.mercado
 * @group             : 
 * @last modified on  : 05-24-2022
 * @last modified by  : j.martinez.mercado@accenture.com
**/
@IsTest
public with sharing class DEG_ConsumeOrquestadorAsyncWpp_tst{
  @TestSetup
  static void makeData(){
        
    MessagingChannel msgChannel = [SELECT Id, DeveloperName, MessageType
                    FROM MessagingChannel
                    WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];
    system.debug('MessaginChannel is > ' + msgChannel.MessageType);
    List<MessagingChannel> lstMessagingChannelEmpresas = [SELECT Id FROM MessagingChannel WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573225721973' LIMIT 1];
        // Por implementar funcionalidad Facebook
    //List<MessagingChannel> lstMessagingChannelFacebook = [SELECT Id FROM MessagingChannel WHERE DeveloperName = 'Facebook_US_106538247497988' LIMIT 1];

    MessagingEndUser msgEndUser= new MessagingEndUser(  Name = 'whatsapp:+573125127626' ,
                              MessagingPlatformKey = 'whatsapp:+573125127626',
                               MessagingChannelId= msgChannel.Id,
                               MessageType = 'WhatsApp'  );
    insert msgEndUser;

    MessagingEndUser msgEndUserEmpresas= new MessagingEndUser(  Name = 'whatsapp:+573125127626' ,
                              MessagingPlatformKey = 'whatsapp:+573125127626',
                               MessagingChannelId= lstMessagingChannelEmpresas[0].Id,
                               MessageType = 'WhatsApp'  );
    insert msgEndUserEmpresas;

    // Por implementar funcionalidad Facebook
    /*MessagingEndUser msgEndUserFacebook= new MessagingEndUser(  MessagingPlatformKey = 'whatsapp:+573125127626',
                               MessagingChannelId= lstMessagingChannelFacebook[0].Id,
                               MessageType = 'Facebook',
                               Name = 'Sebastian Urrutia Furtado'  );
    insert msgEndUserFacebook;
        
        MessagingEndUser msgEndUserFacebook2= new MessagingEndUser(  MessagingPlatformKey = 'whatsapp:+573125127621',
                               MessagingChannelId= lstMessagingChannelFacebook[0].Id,
                               MessageType = 'Facebook',
                               Name = 'Sebastian Urrutia'  );
    insert msgEndUserFacebook2;
        
        MessagingEndUser msgEndUserFacebook3= new MessagingEndUser(  MessagingPlatformKey = 'whatsapp:+573125127622',
                               MessagingChannelId= lstMessagingChannelFacebook[0].Id,
                               MessageType = 'Facebook',
                               Name = 'Sebastian Test Urrutia Furtado'  );
    insert msgEndUserFacebook3;*/
    
    MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
                              MessagingEndUserId = msgEndUser.Id,
                              Status = 'Active',
                              DEG_ResponseiFrames__c = '1,2');
    insert msgSession;

    MessagingSession msgSessionEmpresas = new MessagingSession( MessagingChannelId= lstMessagingChannelEmpresas[0].Id,
                              MessagingEndUserId = msgEndUserEmpresas.Id,
                              Status = 'Active',
                                                            DEG_ResponseiFrames__c = '1,2');
    System.debug('#^_^#: '+ msgSessionEmpresas);
    insert msgSessionEmpresas;
    // Por implementar funcionalidad Facebook
    /*MessagingSession msgSessionFacebook = new MessagingSession( MessagingChannelId= lstMessagingChannelFacebook[0].Id,
                              MessagingEndUserId = msgEndUserFacebook.Id,
                              Status = 'Active',
                                                            DEG_ResponseiFrames__c = '1,2');
    insert msgSessionFacebook;
        
        MessagingSession msgSessionFacebook2 = new MessagingSession( MessagingChannelId= lstMessagingChannelFacebook[0].Id,
                              MessagingEndUserId = msgEndUserFacebook2.Id,
                              Status = 'Active',
                                                            DEG_ResponseiFrames__c = '1,2');
    insert msgSessionFacebook2;
        
        MessagingSession msgSessionFacebook3 = new MessagingSession( MessagingChannelId= lstMessagingChannelFacebook[0].Id,
                              MessagingEndUserId = msgEndUserFacebook3.Id,
                              Status = 'Active',
                                                            DEG_ResponseiFrames__c = '1,2');
    insert msgSessionFacebook3;*/

  }

  @isTest
    static void testWpp(){
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
		List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '1';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
			
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('eventoWhatApp');
		Test.setMock(HttpCalloutMock.class, mock);
			
		Test.startTest();
		DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst, '{"data": ""}');
		DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
    }
    
    @isTest
    static void testWpp2(){
    	Cache.Org.put('tokenWatson','TOKENRESPONSE');
        List<MessagingSession> lstMsgSession = [SELECT Id, DEG_ResponseiFrames__c FROM MessagingSession];
        lstMsgSession.get(0).DEG_ResponseiFrames__c = null;
        update lstMsgSession;
        List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '1';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
			
			DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('eventoWhatApp');
		Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst, '{"data": ""}');
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
		}
    
    @isTest
    static void testWpp3(){
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
		List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = 'texto';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
			
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('eventoWhatApp');
		Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst, '{"data": ""}');
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
    }
    // @isTest
    // public static void testNotificacionEncuesta() {
    //   Cache.Org.put('tokenWatson','TOKENRESPONSE');
    //   List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
    //   orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
    //   orquestInLst[0].sessionId = '';
    //   orquestInLst[0].textClient = 'encuesta_agente';
    //   orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
    //   orquestInLst[0].canalBot = 'WPP';   
    //   DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('eventoNotif');
    //   Test.setMock(HttpCalloutMock.class, mock);
    //   Test.startTest();
    //     DE_NotificacionEncuestaMS.makeGetCalloutOfEndChat(orquestInLst);
    //   Test.stopTest();
    // }

	@isTest
    static void testWpp4(){
    	Cache.Org.put('tokenWatson','TOKENRESPONSE');
        List<MessagingSession> lstMsgSession = [SELECT Id, DEG_ResponseiFrames__c FROM MessagingSession];
        lstMsgSession.get(0).DEG_ResponseiFrames__c = '1';
        update lstMsgSession;
        List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '2';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
			
			DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('pasoagente');
		Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst, '{"data": ""}');
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
	}
    
    @isTest
    static void testWpp5(){
        Cache.Org.put('tokenWatson','TOKENRESPONSE');
        MessagingChannel msgChannel = [SELECT Id, DeveloperName, MessageType
                                       FROM MessagingChannel
                                       WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573225721973' LIMIT 1];
        List<MessagingEndUser> lstMsgEndUser = [SELECT Id FROM MessagingEndUser];
        MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = lstMsgEndUser.get(0).Id,
                                                           Status = 'Ended',
                                                           DEG_HoraInicio__c = null,
                                                           DEG_ResponseiFrames__c = '1,2');
        system.debug('MessaginChannel is > ' + msgChannel.MessageType);
        insert msgSession;
        ConversationEntry objcoen=new ConversationEntry(ActorId=lstMsgEndUser.get(0).Id,
                                                        Message='hola',
                                                        ConversationId=msgSession.id,
                                                        Seq=0,
                                                        EntryTime=datetime.now(), 
                                                        EntryType='text',
                                                        ActorName='whatsapp:+52354',
                                                        ActorType='EndUser');
        insert objcoen;
        ConversationEntry objcoen2 =new ConversationEntry(ActorId=lstMsgEndUser.get(0).Id,
                                                        Message='Is a test',
                                                        ConversationId=msgSession.id,
                                                        Seq=1,
                                                        EntryTime=datetime.now(), 
                                                        EntryType='text',
                                                        ActorName='whatsapp:+52354',
                                                        ActorType='EndUser');
        insert objcoen2;
        ConversationEntry objcoen3 =new ConversationEntry(ActorId=lstMsgEndUser.get(0).Id,
                                                          Message='BotEsalated to Agent',
                                                          ConversationId=msgSession.id,
                                                          Seq=3,
                                                          EntryTime=datetime.now(), 
                                                          EntryType='BotEscalated',
                                                          ActorName='whatsapp:+52354',
                                                          ActorType='EndUser');
        insert objcoen3;
        List<MessagingSession> lstMsgSession = [SELECT Id, DEG_ResponseiFrames__c, Status, ChannelType, DEG_Body__c,
                                               (SELECT Message, EntryType, Seq, ActorType, ActorName FROM ConversationEntries)
                                               		FROM MessagingSession WHERE Status = 'Ended'];

        lstMsgSession.get(0).DEG_ResponseiFrames__c = '1';
        lstMsgSession.get(0).DEG_Body__c = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button ETB Mi Pymes</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>';
        update lstMsgSession;
        system.debug('lstMsgSession is > ' + lstMsgSession.get(0));
        system.debug('lstMsgSession is > ' + lstMsgSession.get(0).ConversationEntries);
        List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '2';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
			
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('pasoagente');
		Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst, '{"data": ""}');
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
    }
    
    @isTest
    static void testWpp6(){
        Cache.Org.put('tokenWatson','TOKENRESPONSE');
        MessagingChannel msgChannel = [SELECT Id, DeveloperName, MessageType
                                       FROM MessagingChannel
                                       WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573225721973' LIMIT 1];
        List<MessagingEndUser> lstMsgEndUser = [SELECT Id FROM MessagingEndUser];
        MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = lstMsgEndUser.get(0).Id,
                                                           Status = 'Ended',
                                                           DEG_HoraInicio__c = null,
                                                           DEG_ResponseiFrames__c = '1,2');
        system.debug('MessaginChannel is > ' + msgChannel.MessageType);
        insert msgSession;
        ConversationEntry objcoen=new ConversationEntry(ActorId=lstMsgEndUser.get(0).Id,
                                                        Message='hola',
                                                        ConversationId=msgSession.id,
                                                        Seq=0,
                                                        EntryTime=datetime.now(), 
                                                        EntryType='text',
                                                        ActorName='whatsapp:+52354',
                                                        ActorType='EndUser');
        insert objcoen;
        ConversationEntry objcoen2 =new ConversationEntry(ActorId=lstMsgEndUser.get(0).Id,
                                                        Message='Is a test',
                                                        ConversationId=msgSession.id,
                                                        Seq=1,
                                                        EntryTime=datetime.now(), 
                                                        EntryType='text',
                                                        ActorName='whatsapp:+52354',
                                                        ActorType='EndUser');
        insert objcoen2;
        List<MessagingSession> lstMsgSession = [SELECT Id, DEG_ResponseiFrames__c, Status, ChannelType, DEG_Body__c,
                                               (SELECT Message, EntryType, Seq, ActorType, ActorName FROM ConversationEntries)
                                               		FROM MessagingSession WHERE Status = 'Ended'];

        lstMsgSession.get(0).DEG_ResponseiFrames__c = '1';
        lstMsgSession.get(0).DEG_Body__c = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button ETB Mi Pymes</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>';
        update lstMsgSession;
        system.debug('lstMsgSession is > ' + lstMsgSession.get(0));
        system.debug('lstMsgSession is > ' + lstMsgSession.get(0).ConversationEntries);
        List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '2';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
			
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('pasoagente');
		Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst, '{"data": ""}');
			DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
    }
}