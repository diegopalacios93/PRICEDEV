@isTest
(seeAllData=true)
public with sharing class DEG_myPymesConfigurationChannels_tst {
    @isTest
    Public static void test1(){
        
        MessagingChannel msgChannel = [SELECT Id,MessageType,  DeveloperName FROM MessagingChannel
                                       where MessageType='WhatsApp' and isactive= true LIMIT 1];
        
        MessagingEndUser msgEndUser= new MessagingEndUser(Name = 'whatsapp:+57312512' ,
                                                          MessagingPlatformKey = 'whatsapp:+57312512',
                                                          MessagingChannelId= msgChannel.Id,
                                                          MessageType = 'WhatsApp'  );
        insert msgEndUser;
        
        MessagingSession msgSession = new MessagingSession(MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = msgEndUser.Id,
                                                           Status = 'Ended' );
        insert msgSession;
        
        
        ServicePresenceStatus objSpS=[select Id,DeveloperName from ServicePresenceStatus where DeveloperName ='Available'];
        
        
        DEG_myPymesConfigurationChannels.Input objinput= new DEG_myPymesConfigurationChannels.Input();
        objinput.idConversation=string.valueOf(msgSession.id);
        objinput.motivoAgente='Solicitar Tramites';
        list<DEG_myPymesConfigurationChannels.Input> lstinput = new list<DEG_myPymesConfigurationChannels.Input>();
        lstinput.add(objinput);
        Test.startTest();
        DEG_myPymesConfigurationChannels.getStatusAgent(lstinput);
        Test.stopTest();
    }
    @isTest
    Public static void test2(){
        Group g = new Group(Name='Cola canal MiPymes', type='Queue');
        insert g;
        
        Test.startTest();
        MessagingChannel msgChannel = [SELECT Id,MessageType,TargetQueueId,  DeveloperName FROM MessagingChannel
                                       WHERE IsActive =true AND MessageType ='whatsapp'LIMIT 1];
        ServiceChannel objsc= [SELECT Id FROM ServiceChannel WHERE RelatedEntity ='MessagingSession'];
        
        MessagingEndUser msgEndUser= new MessagingEndUser(Name = 'whatsapp:+57312512' ,
                                                          MessagingPlatformKey = 'whatsapp:+57312512',
                                                          MessagingChannelId= msgChannel.Id,
                                                          MessageType = 'WhatsApp'  );
        insert msgEndUser;
        
        MessagingSession msgSession = new MessagingSession(MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = msgEndUser.Id,
                                                           Status = 'Ended' );
        insert msgSession;
        
        PendingServiceRouting objPen = new PendingServiceRouting();
        objPen.ServiceChannelId=objsc.id;
        objPen.ownerid=Userinfo.getUserId();
        objpen.RoutingType ='SkillsBased';
        objpen.CapacityWeight=1;
        objpen.RoutingModel='MostAvailable';
        objpen.RoutingPriority=1;
        objpen.WorkItemId=msgSession.id;
        insert objPen; 
        PendingServiceRouting objPen1 =[select id,queueid from PendingServiceRouting where id=:objPen.id];
        system.debug('msgChannel.TargetQueueId'+msgChannel.TargetQueueId);
        system.debug('objPen.queueid'+objPen1.queueid);
        /* list<PendingServiceRouting> lstPendSe = [SELECT ServiceChannelId,Owner.name,Queue.name,Group.name  
FROM PendingServiceRouting WHERE  queueid=:objMess.MessagingChannel.TargetQueueId ];
*/
        DEG_myPymesConfigurationChannels.Input objinput= new DEG_myPymesConfigurationChannels.Input();
        objinput.idConversation=string.valueOf(msgSession.id);
        objinput.motivoAgente='Solicitar Tramites';
        list<DEG_myPymesConfigurationChannels.Input> lstinput = new list<DEG_myPymesConfigurationChannels.Input>();
        lstinput.add(objinput);
        DEG_myPymesConfigurationChannels.getStatusAgent(lstinput);
        Test.stopTest();
        
    }
    @isTest
    Public static void test3(){
        queuesReasonOfPassage__mdt objmdt =[SELECT id,reasonForPassing__c,DeveloperName FROM queuesReasonOfPassage__mdt limit 1];
        DEG_myPymesConfigurationChannels.getMensage([SELECT Id,DEG_NombreCliente__c FROM MessagingSession limit 1].id);
        DEG_myPymesConfigurationChannels.getqueu(objmdt.reasonForPassing__c);
        DEG_myPymesConfigurationChannels.metodos();
    }
}