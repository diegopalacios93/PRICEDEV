@isTest
public class DEG_GetSessionIdWatson_tst {

    @TestSetup
	static void makeData(){
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
		LiveChatButton liveChatButton = [SELECT Id, DeveloperName
										 FROM LiveChatButton
										 WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
										 LIMIT 1];

		LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;

		LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
		insert chat;

	}

    @isTest
    static void TestGetSessionId() {
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
        DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('getSessionIdWatsonString');
		Test.setMock(HttpCalloutMock.class, mock);
		List<DEG_GetSessionIdWatson_ws.OrquestInput> orquestInLst = botConfiguration();
		Test.startTest();
		List<DEG_GetSessionIdWatson_ws.OrquestOutput> response = DEG_GetSessionIdWatson_ws.getSessionId(orquestInLst);
		Test.stopTest();

		String expectedResponse = '40a731d1-013c-4809-a3e1-4aad52bfd49a';
		System.assertEquals(expectedResponse, response[0].sessionId);
        
    }

    private static List<DEG_GetSessionIdWatson_ws.OrquestInput> botConfiguration(){
		List<DEG_GetSessionIdWatson_ws.OrquestInput> orquestInLst = new List<DEG_GetSessionIdWatson_ws.OrquestInput>();
		DEG_GetSessionIdWatson_ws.OrquestInput orquestIn = new DEG_GetSessionIdWatson_ws.OrquestInput();
		orquestIn.transcriptId = [SELECT ID FROM LiveChatTranscript LIMIT 1].Id;
        orquestIn.canalBot = 'WEB';
		orquestInLst.add(orquestIn);
		return orquestInLst;
	}

	@isTest
    static void TestGetSessionIdWithoutToken() {
        DEG_ConsumeOrquestador_mck mock = new DEG_ConsumeOrquestador_mck('getSessionIdWatsonString');
		Test.setMock(HttpCalloutMock.class, mock);
		List<DEG_GetSessionIdWatson_ws.OrquestInput> orquestInLst = botConfiguration();
		Test.startTest();
		List<DEG_GetSessionIdWatson_ws.OrquestOutput> response = DEG_GetSessionIdWatson_ws.getSessionId(orquestInLst);
		Test.stopTest();

		String expectedResponse = '40a731d1-013c-4809-a3e1-4aad52bfd49a';
		System.assertEquals(expectedResponse, response[0].sessionId);
        
    }

}