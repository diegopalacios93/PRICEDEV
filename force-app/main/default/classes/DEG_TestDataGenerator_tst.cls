@isTest
private class DEG_TestDataGenerator_tst {

    @isTest
    static void testGenerateRandomString() {

        Test.startTest();
        String tGenerateRandomString = DEG_TestDataGenerator_cls.generateRandomString(5);
        Test.stopTest();

        System.assertEquals(tGenerateRandomString.length(), 5);

    }

    @isTest
    static void testGenerateRandomNumber() {

        Test.startTest();
        String tGenerateRandomNumber = DEG_TestDataGenerator_cls.generateRandomNumber(5);
        Test.stopTest();

        System.assertEquals(tGenerateRandomNumber.length(), 5);

    }

    @isTest
    static void testCreateChat() {

        LiveChatVisitor lcVisitor = new LiveChatVisitor();
        insert lcVisitor;

        Test.startTest();
        LiveChatTranscript TcreateChat = DEG_TestDataGenerator_cls.createChat(lcVisitor.id, true);
        Test.stopTest();

        System.assertEquals(TcreateChat.Body, 'Hello World');
        System.assertEquals(TcreateChat.DEG_AceptaTerminosCondiciones__c, true);
        System.assertEquals(TcreateChat.DEG_ApellidoCliente__c, 'ETB');
        System.assertEquals(TcreateChat.DEG_NombreCliente__c, 'ETB');
        System.assertEquals(TcreateChat.DEG_NumeroDocCliente__c, '123456789');
        System.assertEquals(TcreateChat.DEG_TelefonoCliente__c, '3333333333');
        System.assertEquals(TcreateChat.DEG_TipoDocCliente__c, 'test');
        System.assertEquals(TcreateChat.DEG_EmailCliente__c, 'test@test.com');
        System.assertEquals(TcreateChat.LiveChatVisitorId, lcVisitor.id);

    }
   
}