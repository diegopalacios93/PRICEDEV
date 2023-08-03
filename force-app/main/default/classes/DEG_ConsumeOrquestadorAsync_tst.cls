/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-24-2022
 * @last modified by  : j.martinez.mercado@accenture.com
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-09-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@IsTest
public with sharing class DEG_ConsumeOrquestadorAsync_tst{
	@TestSetup
	static void makeData(){
		LiveChatButton liveChatButton = [SELECT Id, DeveloperName
										 FROM LiveChatButton
										 WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
										 LIMIT 1];

		LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;

		LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
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
															Status = 'Active' );
		insert msgSession;

	}
		
	@isTest
	static void testMensajeBienvenida(){

		String expectedResponse = '[{"videoLst":[],"urlEvent":null,"tokenWatson":"","tipo":"","sessionIdWatson":"","orden":"","mensaje":"","lBotones":[],"imageLst":[],"idEvent":"","esVideo":false,"esMsn":false,"esImage":false,"esBtnLink":false,"esBtn":false,"days":null,"datesLst":[],"btnLinkLst":[]},' + 
						  '{"videoLst":null,"urlEvent":null,"tokenWatson":null,"tipo":"msn","sessionIdWatson":null,"orden":"2","mensaje":"Bienvenido Daniel soy Max tu asistente virtual, estoy listo para ayudarte con:","lBotones":null,"imageLst":null,"idEvent":null,"esVideo":null,"esMsn":true,"esImage":null,"esBtnLink":null,"esBtn":false,"days":null,"datesLst":null,"btnLinkLst":null},' + 
						  '{"videoLst":null,"urlEvent":null,"tokenWatson":null,"tipo":"btn","sessionIdWatson":null,"orden":"3","mensaje":null,"lBotones":[{"texto":"Solicitar soporte técnico"},{"texto":"Consultar factura"},{"texto":"Consultar consumos"},{"texto":"Solicitar Trámites"},{"texto":"Solicitar reconexión"},{"texto":"Adquirir nuestros servicios"}],"imageLst":null,"idEvent":null,"esVideo":null,"esMsn":false,"esImage":null,"esBtnLink":null,"esBtn":true,"days":null,"datesLst":null,"btnLinkLst":null},' + 
						  '{"videoLst":null,"urlEvent":null,"tokenWatson":null,"tipo":"msn","sessionIdWatson":null,"orden":"4","mensaje":"Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo","lBotones":null,"imageLst":null,"idEvent":null,"esVideo":null,"esMsn":true,"esImage":null,"esBtnLink":null,"esBtn":false,"days":null,"datesLst":null,"btnLinkLst":null}]';
		Test.startTest();
		testResponse('welcomeMessage',expectedResponse);
        Test.stopTest();
	}
	@isTest
	static void testEventos(){
       
		String expectedResponse = '[{"videoLst":[],"urlEvent":null,"tokenWatson":"","tipo":"","sessionIdWatson":"","orden":"","mensaje":"","lBotones":[],"imageLst":[],"idEvent":"","esVideo":false,"esMsn":false,"esImage":false,"esBtnLink":false,"esBtn":false,"days":null,"datesLst":[],"btnLinkLst":[]},'+
								  '{"videoLst":null,"urlEvent":"https://hostname.domain","tokenWatson":null,"tipo":null,"sessionIdWatson":null,"orden":"1","mensaje":null,"lBotones":null,"imageLst":null,"idEvent":"cobertura","esVideo":null,"esMsn":null,"esImage":null,"esBtnLink":null,"esBtn":null,"days":null,"datesLst":null,"btnLinkLst":null}]';

		Test.startTest();
		testResponse('evento',expectedResponse);	
        Test.stopTest();
	}
	@isTest
	static void testdateRange(){
		String expectedResponse = 	'[{"videoLst":[],"urlEvent":null,"tokenWatson":"","tipo":"","sessionIdWatson":"","orden":"","mensaje":"","lBotones":[],"imageLst":[],"idEvent":"","esVideo":false,"esMsn":false,"esImage":false,"esBtnLink":false,"esBtn":false,"days":null,"datesLst":[],"btnLinkLst":[]},'+
									'{"videoLst":null,"urlEvent":null,"tokenWatson":null,"tipo":null,"sessionIdWatson":null,"orden":"1","mensaje":null,"lBotones":null,"imageLst":null,"idEvent":"rango_fechas","esVideo":null,"esMsn":null,"esImage":null,"esBtnLink":null,"esBtn":null,"days":"60","datesLst":[],"btnLinkLst":null}]';
     	Test.startTest();
		testResponse('dateRange',expectedResponse);	
        Test.stopTest();
	}
	@isTest
	static void testresponseCalendario(){
		Test.startTest();
		testResponse('responseCalendario','');	
        Test.stopTest();
	}
	

	@isTest
	static void testCobertura(){
		Test.startTest();
		testResponse('cobertura','');
        Test.stopTest();
	}

	@isTest
	static void testMensajePipe(){
        Test.startTest();
		testResponse('respuestaPipe','');							
        Test.stopTest();
	}
	@isTest
	static void testPasoagente(){
        Test.startTest();
		testResponse('pasoagente','');							
        Test.stopTest();
	}
	@isTest
	static void testCambioCola(){
        Test.startTest();
		testResponse('ColaMensajeria','');							
        Test.stopTest();
	}

	@isTest
	static void testPasoagenteRetencion(){
        Test.startTest();
		testResponse('pasoAgenteRetencion','');	
        Test.stopTest();
	}
	@isTest
	static void testBtnSeleccion(){
        Test.startTest();
		testResponse('responseBtnSeleccion','');							
        Test.stopTest();
	}
	// @isTest
	// public static void testNotificacionEncuesta() {
	// 	Cache.Org.put('tokenWatson','TOKENRESPONSE');
	// 	List<DEG_ConsumeOrquestadorAsync_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
	// 	orquestInLst.add(new DEG_ConsumeOrquestadorAsync_ws.Input());
	// 	orquestInLst[0].sessionId = '';
	// 	orquestInLst[0].textClient = 'encuesta_agente';
	// 	orquestInLst[0].conversationId = [SELECT ID FROM LiveChatTranscript LIMIT 1].Id;
	// 	orquestInLst[0].canalBot = 'WEB';
	// 	DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('eventoNotif');
	// 	System.debug('Mock wpp: ' + mock);
	// 	Test.setMock(HttpCalloutMock.class, mock);
	// 	Test.startTest();
	// 		DE_NotificacionEncuestaLCT.makeGetCalloutOfEndChat(orquestInLst);
	// 	Test.stopTest();
	// }

	@isTest
    static void testWpp(){
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
        List<DEG_ConsumeOrquestadorAsync_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsync_ws.Input());
        orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '';
		orquestInLst[0].conversationId = [SELECT ID FROM MessagingSession LIMIT 1].Id;
		orquestInLst[0].canalBot = 'WPP';
        
       DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('eventoWhatApp');
	   System.debug('Mock wpp: ' + mock);
		Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        DEG_ConsumeOrquestadorAsync_ws.makeGetCallout(orquestInLst, '{"data": ""}');
		Test.stopTest();
    }


	static void testResponse(String mockup,String expectedResponse){

		Cache.Org.put('tokenWatson','TOKENRESPONSE');
		DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck(mockup);
		Test.setMock(HttpCalloutMock.class, mock);
		List<DEG_ConsumeOrquestadorAsync_ws.Input> orquestInLst = botConfiguration();
		//Test.startTest();
		List<DEG_ConsumeOrquestadorAsync_ws.Output> response = DEG_ConsumeOrquestadorAsync_ws.makeGetCallout(orquestInLst);
		//Test.stopTest();

        LiveChatTranscript chat = [ SELECT DEG_LastResponse__c,DEG_TransferToAgent__c  
                                    FROM LiveChatTranscript 
                                    WHERE Id =:orquestInLst[0].conversationId 
                                    LIMIT 1];
  
        System.debug(expectedResponse);
        System.debug(chat.DEG_LastResponse__c);
	}

	private static List<DEG_ConsumeOrquestadorAsync_ws.Input> botConfiguration(){
		List<DEG_ConsumeOrquestadorAsync_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsync_ws.Input());
        orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '';
		orquestInLst[0].conversationId = [SELECT ID FROM LiveChatTranscript LIMIT 1].Id;
		orquestInLst[0].canalBot = 'Web';
		return orquestInLst;
	}    
	@isTest
	static void testFueradeHorario(){
        Test.startTest();
		testResponse('FueradeHorario','');							
        Test.stopTest();
	}       
}