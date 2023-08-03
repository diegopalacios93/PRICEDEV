/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 06-05-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-09-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@isTest
public with sharing class DEG_ConsumeOrquestadorAsyncWhatsApp_tst {
    @TestSetup
	static void makeData(){

        Profile pro = [select id from Profile where name='System Administrator' OR name = 'Administrador del sistema' limit 1];
		User usu = new User();
		usu.LastName = 'testttetwss';
		usu.Alias = 'tteyst09';
		usu.Email = 'tester@email.com';
		string userRandom=Math.random()*1000+'userEtb@etb.com';
		usu.Username = userRandom;
		usu.CommunityNickname = 'tercintest';
		usu.TimeZoneSidKey = 'America/Bogota';
		usu.LocaleSidKey = 'es_CO';
		usu.EmailEncodingKey = 'ISO-8859-1';
		usu.ProfileId = pro.Id;
		usu.LanguageLocaleKey = 'es';
		usu.EsAsesor__c = true;

        User usr = [SELECT Id, username, profileId FROM User WHERE username LIKE 'autoproc%' LIMIT 1];


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
															Status = 'Active',
                                                            OwnerId = usr.Id);
		insert msgSession;


	}
    @isTest
    private static void testNameCapture(){
        whatsAppCapture('Rodrigo','"name":"Rodrigo"','{"state":"GetName","buttonsMap":{}}');
    }
    @isTest
    private static void testLastNameCapture(){
        whatsAppCapture('Martin','"lastName":"Martin"','{"state":"GetLastName","buttonsMap":{}}');
    }
    @isTest
    private static void testDocTypeCapture(){
        whatsAppCapture('1','"documentType":"Seleccion 1"','{"state":"GetDoctype","buttonsMap":{"1":"Seleccion 1", "2":"Seleccion 2"}}');
    }
    @isTest
    private static void testDocNumberCapture(){
        whatsAppCapture('123456789','"documentNumber":"123456789"','{"state":"GetDocNumber","buttonsMap":{}}');
    }
    @isTest
    private static void testEmailCapture(){
        whatsAppCapture('rodrigo.martin@globant.com','"email":"rodrigo.martin@globant.com"','{"state":"GetEmail","buttonsMap":{}}');
    }

    private static void whatsAppCapture(String textClient,String expectedText,String whatsAppInfo ){
        List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> inputLst = new List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input>();
		inputLst.add(new DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input());
		inputLst[0].sessionId = '';
		inputLst[0].textClient = textClient;
		inputLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		inputLst[0].canalBot = 'WPP';
        inputLst[0].whatsAppInfo= whatsAppInfo;
        
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
        
        DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('welcomeMessage');
		
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();		
        List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Output> response = DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(inputLst);
        Test.stopTest();
        System.assertEquals(true,response[0].whatsAppInfo.contains(expectedText));
    }
	@isTest
    private static void testMessagingSession(){
        User usr = [select id from User limit 1];
        // Case cs = [SELECT Id, OwnerId From Case LIMIT 1];
        MessagingEndUser msu = [SELECT Id, OwnerId From MessagingEndUser LIMIT 1];
        
        msu.OwnerId = usr.Id;

        update msu;
    }
}