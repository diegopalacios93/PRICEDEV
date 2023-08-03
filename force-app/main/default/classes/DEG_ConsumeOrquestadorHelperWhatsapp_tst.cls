@isTest
private class DEG_ConsumeOrquestadorHelperWhatsapp_tst {
       
    @TestSetup
	static void makeData(){

		Cache.Org.put('tokenWatson','TOKENRESPONSE');

		MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];

		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+5731251276' ,
															MessagingPlatformKey = 'whatsapp:+5731251276',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp'  );
		insert msgEndUser;
		
		MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Active' );
		insert msgSession;
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
        DEG_ConsumeOrquestadorHelperWhatsapp_cls.getMotivo('test_test');
		Test.stopTest();

        response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
        
        Case cs = [SELECT Id, DEG_Nombre__c, DEG_Apellido__c, DEG_Celular__c, DEG_NumerodeIdentificacion__c, DEG_TipodeDocumento__c, SuppliedEmail FROM Case LIMIT 1];
        
        System.debug('##test: ' + cs);
		
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
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('motivoContacto');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);

    }
	@istest
	static void testFueradeHorario(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('fueradeHorario');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
	
	}    
    @isTest
    static void testInfoGen(){
        String segmento='Masivo';
        String celular = '6012903300';
        String tecnologia = 'FTTH';
        DEG_ConsumeOrquestadorHelperWhatsapp_cls.InfoGeneral inGeneral = new DEG_ConsumeOrquestadorHelperWhatsapp_cls.InfoGeneral(segmento,tecnologia);
        Test.startTest();
        inGeneral.Segmento=segmento;
        inGeneral.Telefono=celular;
        inGeneral.Tecnologia=tecnologia;
        DEG_ConsumeOrquestadorHelperWhatsapp_cls.General gen = new DEG_ConsumeOrquestadorHelperWhatsapp_cls.General();
        gen.InfoGeneral = inGeneral;
        Test.stopTest();
    }
    
	@istest
	static void testInfoGeneral(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('infogeneral');
		
		List<DEG_ConsumeOrquestadorAsyncWhatsApp_ws.Input> orquestInLst = botConfigurationWsp();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsyncWhatsApp_ws.makeGetCallout(orquestInLst);
		Test.stopTest();
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Input> inputLst = botConfigDBResponseWsp(null);
        List<DEG_ConsumeOrquestadorDBWhatsApp_cls.Output> response =  DEG_ConsumeOrquestadorDBWhatsApp_cls.makeGetCallout(inputLst);
	
	}
		
}