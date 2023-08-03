@isTest
private class DEG_GetPrechat_tst {

    @isTest
    static void testGetPrechat() {
        LiveChatVisitor lcVisitor = new LiveChatVisitor();
        insert lcVisitor;

        LiveChatTranscript chat = DEG_TestDataGenerator_cls.createChat(lcVisitor.Id, true);
        List<LiveChatTranscript> lstChat = new List<LiveChatTranscript>();
        
        Test.startTest();
        DEG_GetPrechat_cls.prechatInput pcInput = new DEG_GetPrechat_cls.prechatInput();
        DEG_GetPrechat_cls.prechatOutput[] pcOutput = new DEG_GetPrechat_cls.prechatOutput[]{};
        pcInput.routableID = chat.id;
        pcInput.botName = 'test';
        DEG_GetPrechat_cls.prechatInput[] LstPcInput = new DEG_GetPrechat_cls.prechatInput[]{};
        LstPcInput.add(pcInput);
        pcOutput = DEG_GetPrechat_cls.getPrechat(LstPcInput);
        Test.stopTest();

        System.assertEquals(pcOutput[0].documentType, chat.DEG_TipoDocCliente__c);
        System.assertEquals(pcOutput[0].numberDocument, chat.DEG_NumeroDocCliente__c);
    }
    
}