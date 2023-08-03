@isTest
public with sharing class deg_downloadData_tst {
    /**
    * @description inserción de registros de prueba para los métodos test
    */
    @testSetup 
    static void setup() 
    {
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                       FROM MessagingChannel
                                       WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
        MessagingEndUser msgEndUser= new MessagingEndUser(Name = 'whatsapp:+573125127626' ,
                                                          MessagingPlatformKey = 'whatsapp:+573125127626',
                                                          MessagingChannelId= msgChannel.Id,
                                                          MessageType = 'WhatsApp');
        insert msgEndUser;
        MessagingSession primerMensaje = new MessagingSession( MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = msgEndUser.Id,
                                                           Status = 'Ended',
                                                           DEG_TelefonoCliente__c = msgEndUser.MessagingPlatformKey.substringAfter('whatsapp:+57'),
                                                           DEG_SentReinjectionMessage__c = False);
        insert primerMensaje;
    }
    
    @isTest
    Public static void test1(){
        Test.startTest();
        MessagingSession primerMensaje = [SELECT ID FROM MessagingSession LIMIT 1];
        list<Id> lstid = new  list<id>{primerMensaje.Id};
        string fields='lastname,firstname';
        string query='SELECT id,Name,case.CaseNumber FROM  messagingSession WHERE DEG_SentReinjectionMessage__c =false';
        deg_downloadData_ctr.getData(lstid,query,fields,true);
        Test.stopTest();
    }
    
    @isTest
    Public static void test2(){
        Test.startTest();
        MessagingSession primerMensaje = [SELECT ID FROM MessagingSession LIMIT 1];
        list<Id> lstid = new  list<id>{primerMensaje.Id};
        string fields='lastname,firstname';
        string query='SELECT id,Name,case.CaseNumber FROM  messagingSession WHERE DEG_SentReinjectionMessage__c =false';
        deg_downloadData_ctr.getData(lstid,query,fields,false);
        Test.stopTest();
    }
}