/**
     * @description       : DEG_GetPasoAgente test class
     * @author            : Nolvis Sanchez
     * @group             : 
     * @last modified on  : 06-01-2022
     * @last modified by  : 
    **/
    @isTest
    public with sharing class DEG_GetPasoAgente_tst {

    @testSetup 
    static void setup() {
    List<Case> lstCasTest;
    User userTest;
    MessagingEndUser msgEndUser;
    List<MessagingSession> lstMsgSession;

    userTest = DEG_TestDataGenerator_cls.createUser();
    insert userTest;
    System.runAs(userTest) {
        lstCasTest = DEG_TestDataGenerator_cls.createCase(userTest.Id, 1);
        insert lstCasTest;        	
        msgEndUser = DEG_TestDataGenerator_cls.createMessagingUser();
        insert msgEndUser;
        lstMsgSession = DEG_TestDataGenerator_cls.createMessagingSessionWithoutCase(msgEndUser.Id, 1);
        insert lstMsgSession;
    }   
    }
    @isTest
    public static void generalTest (){  
    List<MessagingSession> ms =[SELECT Id FROM MessagingSession LIMIT 1] ;  
    DEG_GetPasoAgente_ctr.OrquestInput input = new DEG_GetPasoAgente_ctr.OrquestInput();
    input.transcriptId = ms.get(0).Id;   
    List<DEG_GetPasoAgente_ctr.OrquestInput> inputLst = new List<DEG_GetPasoAgente_ctr.OrquestInput>();
    inputLst.add(input) ;
    test.startTest();
    DEG_GetPasoAgente_ctr.validarPasoAgente(inputLst);
    test.stopTest(); 
    }

    }