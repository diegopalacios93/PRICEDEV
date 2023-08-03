@isTest
private class DEG_TranscriptConversation_Test {
    
    @TestSetup
    static void setup(){
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
										 FROM LiveChatButton
										 WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
										 LIMIT 1];
        LiveChatVisitor lcVisitor = new LiveChatVisitor();
        insert lcVisitor;
        LiveChatTranscript chat = new LiveChatTranscript(
            Body = '<p align="center">Chat Started: Saturday, March 13, 2021, 15:52:09 (+0000)</p>( 9s ) Canal Chat Masivos: [{&quot;videoLst&quot;:null,&quot;tipo&quot;:&quot;msn&quot;,&quot;orden&quot;:&quot;1&quot;,&quot;mensaje&quot;:&quot;Bienvenido sfdfs soy Max tu asistente virtual, estoy listo para ayudarte con:&quot;,&quot;lBotones&quot;:null,&quot;imageLst&quot;:null,&quot;esVideo&quot;:null,&quot;esMsn&quot;:true,&quot;esImage&quot;:null,&quot;esBtnLink&quot;:null,&quot;esBtn&quot;:false,&quot;btnLinkLst&quot;:null},{&quot;videoLst&quot;:null,&quot;tipo&quot;:&quot;btn&quot;,&quot;orden&quot;:&quot;2&quot;,&quot;mensaje&quot;:null,&quot;lBotones&quot;:[{&quot;texto&quot;:&quot;Consultar factura&quot;},{&quot;texto&quot;:&quot;Solicitar reconexión&quot;},{&quot;texto&quot;:&quot;Consultar consumos&quot;},{&quot;texto&quot;:&quot;Solicitar Trámites&quot;},{&quot;texto&quot;:&quot;Solicitar soporte técnico&quot;},{&quot;texto&quot;:&quot;Adquirir nuestros servicios&quot;}],&quot;imageLst&quot;:null,&quot;esVideo&quot;:null,&quot;esMsn&quot;:false,&quot;esImage&quot;:null,&quot;esBtnLink&quot;:null,&quot;esBtn&quot;:true,&quot;btnLinkLst&quot;:null},{&quot;videoLst&quot;:null,&quot;tipo&quot;:&quot;msn&quot;,&quot;orden&quot;:&quot;3&quot;,&quot;mensaje&quot;:&quot;Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo&quot;,&quot;lBotones&quot;:null,&quot;imageLst&quot;:null,&quot;esVideo&quot;:null,&quot;esMsn&quot;:true,&quot;esImage&quot;:null,&quot;esBtnLink&quot;:null,&quot;esBtn&quot;:false,&quot;btnLinkLst&quot;:null}]<br>',
            DEG_AceptaTerminosCondiciones__c = true,
            DEG_ApellidoCliente__c = 'ETB',
            DEG_NombreCliente__c = 'ETB',
            DEG_NumeroDocCliente__c = '123456789',
            DEG_TelefonoCliente__c = '3333333333',
            DEG_TipoDocCliente__c = 'test',
            DEG_EmailCliente__c = 'test@test.com',
            LiveChatVisitorId = lcVisitor.Id,
            LiveChatButtonId = liveChatButton.Id
        );
        insert chat;
    }

    @IsTest
    static void transcriptConversationTest() {
        Test.startTest();
        LiveChatTranscript vLiveChatTranscript = [SELECT Id, Body FROM LiveChatTranscript LIMIT 1];
        /*DEG_TranscriptConversation_cls.TranscripInput vInput = new DEG_TranscriptConversation_cls.TranscripInput();
        vInput.liveChatTranscriptId = vLiveChatTranscript.Id;*/
        Map<String, Object> vOutput = DEG_TranscriptConversation_cls.transcriptConversation(vLiveChatTranscript.Id);
        
        Test.stopTest();
        System.assertEquals(3, vOutput.size());
    }

    @IsTest
    static void activeTranscriptBodyTest(){
        Test.startTest();
        LiveChatTranscript vLiveChatTranscript = [SELECT Id, Body FROM LiveChatTranscript LIMIT 1];
        Integer vCount = DEG_TranscriptConversation_cls.activeTranscriptBody(vLiveChatTranscript.Id);
        Test.stopTest();
        System.assertEquals(1, vCount);
    }

    @IsTest
    static void transcriptConversationTestFail(){
        Test.startTest();
        Map<String, Object> vOutput = DEG_TranscriptConversation_cls.transcriptConversation(null);
        Test.stopTest();        
        System.assertEquals(true, vOutput.get('error'));
    }
}