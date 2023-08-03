@isTest
private class DEG_ResponseWatson_Test {

    @TestSetup
    static void setup(){
        LiveChatButton lcbutton = [SELECT Id, DeveloperName FROM LiveChatButton WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'];
        LiveChatVisitor lcVisitor = new LiveChatVisitor();
        insert lcVisitor;
        LiveChatTranscript chat = new LiveChatTranscript(
            body = '<p align="center">Chat Started: Wednesday, May 05, 2021, 13:36:02 (+0000)</p><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Agent Chatbot chat resumed with BotId 0Xx29000000007q</p>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br>( 1m 29s ) ETB Canal Chat Masivos: En este momento no contamos con agentes disponibles, por favor intente en los horarios de atención establecidos.<br><p align="center">Agent Chatbot successfully transferred the chat to button ETB Servicio al Cliente Masivo</p><p align="center">Chat Started: Wednesday, May 05, 2021, 13:37:38 (+0000)</p><p align="center">Chat Origin: ETB Servicio al Cliente Masivo</p><p align="center">Chat Transferred From ETB Canal Chat Masivos To Sebastian U</p>',
            DEG_AceptaTerminosCondiciones__c = true,
            DEG_ApellidoCliente__c = 'ETB',
            DEG_NombreCliente__c = 'ETB',
            DEG_NumeroDocCliente__c = '123456789',
            DEG_TelefonoCliente__c = '3333333333',
            DEG_TipoDocCliente__c = 'test',
            DEG_EmailCliente__c = 'test@test.com',            
            LiveChatVisitorId = lcVisitor.Id,
            LiveChatButtonId = lcbutton.Id
        );
        insert chat;

        chat.DEG_ClientSessionWatsonId__c = 'Etb '+chat.Id;
        chat.DEG_TokenWatson__c = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJib3QiOiJrb25lY3RhLWV0YiIsInNpdGUiOiI2MkxiQjgwY0pCQSIsImNvbnYiOiIzTzNwVVd3dk9zeFRWUkVpbU9HUzZqLUEiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvZXRiLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC9ldGIvIiwidXNlciI6ImRpZ2l0YWwuZGV2IiwiaWF0IjoxNjE4MjQ0OTA4LCJleHAiOjE2MTgzMzEzMDh9.-xmRo3Aw2kcEErs96bCXi2JRXf-wCImGl4ICE8LD-MQ';
        chat.DEG_SessionIdWatson__c = '40a731d1-013c-4809-a3e1-4aad52bfd49a';
        update chat;
    }
    
    @isTest
    static void createWatsonResponseTest(){
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        LiveChatTranscript vLiveChatTranscript = [SELECT Id, DEG_SessionIdWatson__c, DEG_ClientSessionWatsonId__c,DEG_TokenWatson__c FROM LiveChatTranscript LIMIT 1];
        String vData = '{"data":{"messages":[{"response_type":"text","text":"hola, respuesta post time out (botones seleccion: si; no)"}]},"client_session_id":"Etb '+vLiveChatTranscript.Id+'","watson_session_id":"abc-defg-1234","meta":{"success":true,"status":200,"message":"Successful execution"}}';

        RestContext.request.requestBody = Blob.valueOf(vData);
        Test.startTest();
        DEG_ResponseWatson_ws.createWatsonResponse();
        Test.stopTest();
        Map<String,Object> vResult = (Map<String,Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals(200, vResult.get('status'), false);
        System.assertEquals('success', vResult.get('message'), false);
    }

    @isTest
    static void createWatsonResponseTestFail(){
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        
        String vData = '{"data":{"messages":[{"response_type":"text","text":"hola, respuesta post time out (botones seleccion: si; no)"}]},"client_session_id":"Etb 57029000000HvZWAA0","watson_session_id":"abc-defg-1234","meta":{"success":true,"status":200,"message":"Successful execution"}}';

        RestContext.request.requestBody = Blob.valueOf(vData);
        Test.startTest();
        DEG_ResponseWatson_ws.createWatsonResponse();
        Test.stopTest();
        Map<String,Object> vResult = (Map<String,Object>) JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        
        System.assertEquals(404, vResult.get('status'), false);
        System.assertEquals('Conversation Not Content', vResult.get('message'), false);
    }

    @isTest
    static void getWatsonCalloutFail(){
        String vData = '{"data":{"messages":[{"response_type":"text","text":"hola, respuesta post time out (botones seleccion: si; no)"}]},"client_session_id":"","watson_session_id":"abc-defg-1234","meta":{"success":true,"status":200,"message":"Successful execution"}}';
        Test.startTest();
        Map<String, Object> result = DEG_ResponseWatson_ws.getWatsonCallout(vData).getMapResult();
        Test.stopTest();
        System.debug(result);
        System.assertEquals(500, result.get('status'), false);
        System.assertEquals('Error', result.get('message'), false);
    }

    @isTest
    static void createWatsonResponseTestEmpty(){
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestBody = null;
        Test.startTest();
        DEG_ResponseWatson_ws.createWatsonResponse();
        Test.stopTest();
        System.assertEquals(500, RestContext.response.statusCode, false);
        System.assert(RestContext.response.responseBody != null, false);
    }
}