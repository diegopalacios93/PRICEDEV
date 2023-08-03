/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 12-08-2021
 * @last modified by  : j.martinez.mercado
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-05-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@isTest
private class DEG_LiveChatTranscript_tst {
    
    @testSetup static void setup() {
        List<Case> lstCasTest;
        User userTest;
        
        userTest = DEG_TestDataGenerator_cls.createUser();
        insert userTest;
        System.runAs(userTest) {
            lstCasTest = DEG_TestDataGenerator_cls.createCase(userTest.Id, 1);
            insert lstCasTest;       
        }
    }

    @isTest
    static void liveChatEmpresasTest() {
        Test.startTest();
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETBServicioClienteEmpresas'
                                         LIMIT 1];
      

        LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
        insert chat;
        
        chat.DEG_NombreCliente__c = 'testNombreCliente';
        chat.DEG_NumeroDocCliente__c = '23045667';
        chat.DEG_TipoDocCliente__c ='CC';
        chat.body = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Agent Chatbot chat resumed with BotId 0Xx29000000007q</p>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Chat Started: Wednesday, May 05, 2021, 13:37:38 (+0000)</p><p align="center">Chat Origin: ETB Servicio al Cliente Masivo</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>';
        update chat; 
        
        chat.body = '<p align="center">Chat Started: Saturday, March 13, 2021, 15:52:09 (+0000)</p>( 9s ) Canal Chat Masivos: ))<br>';
        update chat;
        
        chat.body = '<p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:32:35 (-0500)</p>( 8s ) ETB Canal Chat Masivos: :<br>( 27s ) Lisa: null<br>( 28s ) ETB Canal Chat Masivos: Bienvenido Lisa soy Max tu asistente virtual, estoy listo para ayudarte con:<br>Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo <br> Si en algún momento necesitas reiniciar la conversación o seleccionas una opción que no necesitabas solo escribe la palabra *INICIO* para volver a comenzar.<br>( 1m 38s ) Lisa: Suativa<br>( 1m 39s ) ETB Canal Chat Masivos: :<br>( 1m 51s ) Lisa: null<br>( 1m 55s ) ETB Canal Chat Masivos: Por favor no te vayas, es necesario pasar tu requerimiento a un agente de servicio experto. En un momento gestionará tu petición. Recuerda soy MAX y puedes buscarme el día que quieras a la hora que quieras<br><p align="center">Agente Chatbot transfirió correctamente la conversación de chat al botón ETB Servicio al Cliente Masivo</p><p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:34:35 (-0500)</p><p align="center">Origen de chat: ETB Servicio al Cliente Masivo</p><p align="center">Chat transferido desde ETB Canal Chat Masivos A (EM) - William C</p>( 2m 11s ) (EM) - William C: Hola<br>( 2m 15s ) Lisa: Test<br> ';
        update chat;

        Test.stopTest();
    }
  
    //
     @isTest
    static void liveChatHOGTest() {
        Test.startTest();
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
                                         LIMIT 1];
      

        LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
        insert chat;
        
        chat.DEG_NombreCliente__c = 'testNombreCliente';
        chat.body = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Agent Chatbot chat resumed with BotId 0Xx29000000007q</p>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Chat Started: Wednesday, May 05, 2021, 13:37:38 (+0000)</p><p align="center">Chat Origin: ETB Servicio al Cliente Masivo</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>';
        update chat; 
        
        chat.body = '<p align="center">Chat Started: Saturday, March 13, 2021, 15:52:09 (+0000)</p>( 9s ) Canal Chat Masivos: ))<br>';
        update chat;
        
        chat.body = '<p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:32:35 (-0500)</p>( 8s ) ETB Canal Chat Masivos: :<br>( 27s ) Lisa: null<br>( 28s ) ETB Canal Chat Masivos: Bienvenido Lisa soy Max tu asistente virtual, estoy listo para ayudarte con:<br>Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo <br> Si en algún momento necesitas reiniciar la conversación o seleccionas una opción que no necesitabas solo escribe la palabra *INICIO* para volver a comenzar.<br>( 1m 38s ) Lisa: Suativa<br>( 1m 39s ) ETB Canal Chat Masivos: :<br>( 1m 51s ) Lisa: null<br>( 1m 55s ) ETB Canal Chat Masivos: Por favor no te vayas, es necesario pasar tu requerimiento a un agente de servicio experto. En un momento gestionará tu petición. Recuerda soy MAX y puedes buscarme el día que quieras a la hora que quieras<br><p align="center">Agente Chatbot transfirió correctamente la conversación de chat al botón ETB Servicio al Cliente Masivo</p><p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:34:35 (-0500)</p><p align="center">Origen de chat: ETB Servicio al Cliente Masivo</p><p align="center">Chat transferido desde ETB Canal Chat Masivos A (EM) - William C</p>( 2m 11s ) (EM) - William C: Hola<br>( 2m 15s ) Lisa: Test<br> ';
        update chat;

        Test.stopTest();
    }

    @isTest
    static void liveChatMiPymesTest() {
        Test.startTest();
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETB_Servicio_al_Cliente_MiPymes'
                                         LIMIT 1];
      

        LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
        insert chat;

        chat.DEG_NombreCliente__c = 'testNombreCliente';
        chat.body = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button ETB Mi Pymes</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>';
        update chat; 
        
        chat.body = '<p align="center">Chat Started: Saturday, March 13, 2021, 15:52:09 (+0000)</p>( 9s ) Canal Chat Masivos: ))<br>';
        update chat;
        
        chat.body = '<p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:32:35 (-0500)</p>( 8s ) ETB Canal Chat Masivos: :<br>( 27s ) Lisa: null<br>( 28s ) ETB Canal Chat Masivos: Bienvenido Lisa soy Max tu asistente virtual, estoy listo para ayudarte con:<br>Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo <br> Si en algún momento necesitas reiniciar la conversación o seleccionas una opción que no necesitabas solo escribe la palabra *INICIO* para volver a comenzar.<br>( 1m 38s ) Lisa: Suativa<br>( 1m 39s ) ETB Canal Chat Masivos: :<br>( 1m 51s ) Lisa: null<br>( 1m 55s ) ETB Canal Chat Masivos: Por favor no te vayas, es necesario pasar tu requerimiento a un agente de servicio experto. En un momento gestionará tu petición. Recuerda soy MAX y puedes buscarme el día que quieras a la hora que quieras<br><p align="center">Agente Chatbot transfirió correctamente la conversación de chat al botón ETB Servicio al Cliente Masivo</p><p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:34:35 (-0500)</p><p align="center">Origen de chat: ETB Servicio al Cliente Masivo</p><p align="center">Chat transferido desde ETB Canal Chat Masivos A (EM) - William C</p>( 2m 11s ) (EM) - William C: Hola<br>( 2m 15s ) Lisa: Test<br> ';
        update chat;

        Test.stopTest();
    }
    @isTest
    static void liveChatVentasTest() {
        Test.startTest();
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETBVentasHogar'
                                         LIMIT 1];
      

        LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
        insert chat;
        
        chat.DEG_NombreCliente__c = 'testNombreCliente';
        chat.body = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button Canal Web Ventas</p><p align="center">Agent Chatbot chat resumed with BotId 0Xx29000000007q</p>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Chat Started: Wednesday, May 05, 2021, 13:37:38 (+0000)</p><p align="center">Chat Origin: ETB Servicio al Cliente Masivo</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>';
        update chat; 
        
        chat.body = '<p align="center">Chat Started: Saturday, March 13, 2021, 15:52:09 (+0000)</p>( 9s ) Canal Chat Masivos: ))<br>';
        update chat;
        
        chat.body = '<p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:32:35 (-0500)</p>( 8s ) ETB Canal Chat Masivos: :<br>( 27s ) Lisa: null<br>( 28s ) ETB Canal Chat Masivos: Bienvenido Lisa soy Max tu asistente virtual, estoy listo para ayudarte con:<br>Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo <br> Si en algún momento necesitas reiniciar la conversación o seleccionas una opción que no necesitabas solo escribe la palabra *INICIO* para volver a comenzar.<br>( 1m 38s ) Lisa: Suativa<br>( 1m 39s ) ETB Canal Chat Masivos: :<br>( 1m 51s ) Lisa: null<br>( 1m 55s ) ETB Canal Chat Masivos: Por favor no te vayas, es necesario pasar tu requerimiento a un agente de servicio experto. En un momento gestionará tu petición. Recuerda soy MAX y puedes buscarme el día que quieras a la hora que quieras<br><p align="center">Agente Chatbot transfirió correctamente la conversación de chat al botón ETB Servicio al Cliente Masivo</p><p align="center">Ha comenzado el chat: miércoles, junio 02, 2021, 17:34:35 (-0500)</p><p align="center">Origen de chat: ETB Servicio al Cliente Masivo</p><p align="center">Chat transferido desde ETB Canal Chat Masivos A (EM) - William C</p>( 2m 11s ) (EM) - William C: Hola<br>( 2m 15s ) Lisa: Test<br> ';
        update chat;

        Test.stopTest();
    }
     
    @isTest
    static void getLiveChatTranscriptTst(){
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatTranscript chat = DEG_TestDataGenerator_cls.createChat(liveChatVisitor.Id, true);
        
        Test.startTest();
        DEG_HelperLiveChatTranscript_cls.getLiveChatTranscript('session_id_tst');

        chat.DEG_ClientSessionWatsonId__c = 'session_id_tst';
        update chat;
        
        DEG_HelperLiveChatTranscript_cls.getLiveChatTranscript('session_id_tst');
        Test.stopTest();
    }
 
    @isTest
    static void updateCasesTst(){
     
     List<Case> lstCase = new List<Case>();
        
                lstCase.add(new Case( DEG_Apellido__c = 'Perez', 
	 		                          DEG_Nombre__c = 'Juan',
	 		                          DEG_TipodeDocumento__c = 'CC' ,
	 		                          DEG_NumerodeIdentificacion__c ='123456789',
	 		                          DEG_Celular__c = '22233111',
	 		                          SuppliedEmail = 'correo@prueba.com' 
                                    )
                           );   
		insert lstCase;
       
         Case consulta = [SELECT DEG_Apellido__c,DEG_Nombre__c,DEG_TipodeDocumento__c  FROM Case 
                          WHERE DEG_NumerodeIdentificacion__c='123456789' LIMIT 1];
                          consulta.DEG_Nombre__c = 'Pedro';
                        
        
        update consulta;
               
        }
    
    //Se acaba de agregar 
    @isTest
    static void getMessagingSessionTst(){
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
        
        Test.startTest();
        DEG_HelperLiveChatTranscript_cls.getMessagingSession('session_id_tst');
        msgSession.DEG_ClientSessionWatsonId__c = 'session_id_tst';
        update msgSession;
        DEG_HelperLiveChatTranscript_cls.getMessagingSession('session_id_tst');                                                                      
        Test.stopTest();

    }
    
    @isTest
    static void Test_addRecord(){
        Test.startTest();
        DEG_HelperLiveChatTranscript_cls instance = new DEG_HelperLiveChatTranscript_cls();
		List<string> talkinglst = new List<string>();
		DEG_ConsumeOrquestadorHelper_cls.wrapMensaje mensaje = new DEG_ConsumeOrquestadorHelper_cls.wrapMensaje();
        mensaje.esVideo = true;
        mensaje.esImage = true;
        mensaje.esBtnLink = true;
        List<DEG_ConsumeOrquestadorHelper_cls.WrapVideo> videos = new List<DEG_ConsumeOrquestadorHelper_cls.WrapVideo>();
        videos.add(new DEG_ConsumeOrquestadorHelper_cls.WrapVideo('video', 'www.youtube.com'));
        mensaje.videoLst = videos;
        
        List<DEG_ConsumeOrquestadorHelper_cls.WrpImage> images = new List<DEG_ConsumeOrquestadorHelper_cls.WrpImage>();
        images.add(new DEG_ConsumeOrquestadorHelper_cls.WrpImage('images', 'www.google.com'));
        mensaje.imageLst = images;
        
        List<DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace> btns = new List<DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace>();
        btns.add(new DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace('btn', 'www.google.com'));
        mensaje.btnLinkLst = btns;
        
		string mensajeelm = '';
		System.Assert(instance.addRecord( talkinglst, mensaje, mensajeelm) != null);
		Test.stopTest();
	}
    @isTest
    static void gerStatusCasesTst(){
        List<Id> lstCaseId = new List<Id>();
        for (Case item : [SELECT Id from Case LIMIT 10]){
         	lstCaseId.add(item.Id);   
        }
     	DEG_HelperLiveChatTranscript_cls helper = new DEG_HelperLiveChatTranscript_cls();
        helper.setStatusResuelto(lstCaseId);
   }
    
    /*@isTest
    static void createDashboardWebTest(){
        Test.startTest();
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETBAppMobile'
                                         LIMIT 1];
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId=liveChatVisitor.Id,
                                                        LiveChatButtonId=liveChatButton.Id,
                                                        DEG_NombreCliente__c='test',
                                                        DEG_ApellidoCliente__c='test',
                                                        DEG_TelefonoCliente__c='11111111',
                                                        DEG_Channel__c='Canal Dashboard Web',
                                                        DEG_MotivoAgente__c='wifi',
                                                        DEG_MotivoContacto__c='Soporte');
        insert chat;
        Test.stopTest();
   }*/
    
    /*@isTest
    static void createDashboardMovilTest(){
        Test.startTest();
        Id masivoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        Case caso = new Case(DEG_Celular__c='11111111', Origin='Canal Dashboard Móvil', RecordTypeId=masivoRTId);
        Insert caso;
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                         FROM LiveChatButton
                                         WHERE DeveloperName = 'DEG_ETBAppMobile'
                                         LIMIT 1];
        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;
        LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId=liveChatVisitor.Id,
                                                        LiveChatButtonId=liveChatButton.Id,
                                                        DEG_NombreCliente__c='test',
                                                        DEG_ApellidoCliente__c='test',
                                                        DEG_TelefonoCliente__c='11111111',
                                                        DEG_Channel__c='Canal Dashboard Móvil',
                                                        DEG_MotivoAgente__c='Internet',
                                                        DEG_MotivoContacto__c='Soporte');
        insert chat;
        Test.stopTest();
   }*/
}