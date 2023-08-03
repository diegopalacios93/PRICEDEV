/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 08-17-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-09-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@isTest
public with sharing class DEG_ConsumeOrquestadorDBWhatsApp_tst {
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

		Cache.Org.put('tokenWatson','TOKENRESPONSE');
		MessagingChannel msgChannel = [SELECT Id, DeveloperName
								  FROM MessagingChannel
								  WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];
		
        System.runAs(u){

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
		
	}
    @isTest
    static void testMensajewhatappButtons(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('whatappButtons');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);

		String expectedResponse = 	'Selecciona tu tipo de documento \n'+
									'1- NIT\n'+
									'2- CC\n'+
									'3- CE\n'+
									'4- RUT\n'+
									'5- PASAPORTE\n'+
									'6- TARJETA DE IDENTIDAD\n \n'+
									'Es importante que aceptes nuestros términos y condiciones, puedes consultarlos en el siguiente link. \n \n'+
									'https://bit.etb.com/2JTveql\n \n'+
									'¿Aceptas? \n'+
									'1- Sí\n'+
									'2- No';




		System.debug('##expectedResponse: '+expectedResponse);
		System.debug('##response '+response[0]);
		System.assertEquals(expectedResponse, response[0].allMessage);
    }
	@istest
	static void testEventoWsp(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('eventoWhatApp');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();

		List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
		
	}
	@istest
	static void testVideo(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('mensajeVideoWsp');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);

        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();

        response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
		
	}
	@istest
	static void testPasoAgente(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('pasoagente');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);

    }
	@istest
	static void testMotivoContacto(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('motivocontacto');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);

    }
	@istest
	static void testNameCapture(){
        testCapture('askNameRequestResponse','GetName');
	}
	@istest
	static void testLastNameCapture(){
        testCapture('askLastNameRequestResponse','GetLastName');
	}
	@istest
	static void testDocTypeCapture(){
        testCapture('askDocumentTypeResponse','GetDoctype');
	}
	@isTest
	static void testDocTypeCaptureBussiness(){
        testCapture('askDocTypeResponseBussiness','GetDoctype');
	}
	@istest
	static void testDocNumberCapture(){
        testCapture('askDocumentNumberResponse','GetDocNumber');
	}
	@istest
	static void testDocNumberCaptureBussiness(){
        testCapture('askDocNumberResposeBussiness','GetDocNumber');
	}
	@istest
	static void testEmailCapture(){
        testCapture('askEmailResponse','GetEmail');
	}
    
	@isTest
	static void testConfirmation(){
		String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar' OR Name='Standard User'];
        User u = [SELECT Id, ProfileId FROM User where ProfileId =: p.Id and alias = 'standt' limit 1];
        
        System.runAs(u) {
            DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('confirmationResponse');
            List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst =  botConfigurationWsp();
            Test.setMock(HttpCalloutMock.class, mock);
            Test.startTest();		
            List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Output> OutputLst = DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
            Test.stopTest();
            List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigurationConfirmationResponseWsp();
            List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
        
        	System.debug(response[0]);
            System.assertEquals('Rodrigo',response[0].name);
            System.assertEquals('Martin',response[0].lastName);
            System.assertEquals('CC',response[0].documentType);
            System.assertEquals('123456789',response[0].documentNumber);
            System.assertEquals('rodrigo.martin@globant.com',response[0].email);
        }

	}

	@isTest
	static void testconfirmationBussiness(){

		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('confirmationResponseBussiness');

        List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst =  botConfigurationWsp();
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Output> OutputLst = DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
        Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigurationConfirmationResponseWsp();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);

		System.debug(response[0]);
		System.assertEquals('Rodrigo',response[0].name);
		System.assertEquals('Martin',response[0].lastName);
		System.assertEquals('CC',response[0].documentType);
		System.assertEquals('123456789',response[0].documentNumber);
		System.assertEquals('rodrigo.martin@globant.com',response[0].email);

		
	}

    private static List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> botConfigurationWsp(){
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input());
		orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
        orquestInLst[0].whatsAppInfo='{"state":"DocNumber","documentType":"Seleccion 1","documentNumber":"","buttonsMap":{}}';
		return orquestInLst;
	}

	private static List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> botConfigurationConfirmationResponseWsp(){

        String whatsAppInfo='{"state":"","documentType":"CC","documentNumber":"123456789","name":"Rodrigo","lastName":"Martin","email":"rodrigo.martin@globant.com","buttonsMap":{}}';
    	return botConfigDBResponseWsp(whatsAppInfo);
	}

    private static List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> botConfigDBResponseWsp(String whatsAppInfoJSON){
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = new List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> ();
        inputLst.add(new DEG_ConsumeOrquestadorDBWhatsApp_cls.Input());
        inputLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
        inputLst[0].whatsAppInfo = whatsAppInfoJSON;
        return inputLst;
    }

    private static void testCapture(String mockUp,String State){

		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck(mockUp);
		Test.setMock(HttpCalloutMock.class, mock);
        Cache.Org.put('tokenWatson','TOKENRESPONSE');
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Output> OutputLst = DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
		System.debug(response[0]);
        System.assertEquals(true, response[0].whatsAppInfo.contains('"state":"'+State+'"'));

	}
    
     @isTest
    static void testCallout2() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar' OR Name='Standard User'];
        User u = [SELECT Id, ProfileId FROM User where ProfileId =: p.Id and alias = 'standt' limit 1];

        System.runAs(u) {
            MessagingSession chat = [SELECT ID, DEG_LastResponse__c, DEG_TransferToAgent__c FROM MessagingSession LIMIT 1];
            List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = new List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input>();
            inputLst.add(new DEG_ConsumeOrquestadorDBWhatsApp_cls.Input());
            inputLst[0].conversationId = chat.Id;
            Test.startTest();
            chat.DEG_TransferToAgent__c = true;
            chat.DEG_NombredelaCola__c = System.Label.DEG_SoporteTecnicoMasivos;
            update chat;
            DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
            Test.stopTest();  
            System.assertNotEquals(null, chat);
        }       
    }
	@istest
	static void testFueradeHorario(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('FueradeHorario');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);

    }
}