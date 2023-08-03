@isTest
private class DEG_BacklandingActualizar_tst {
@testSetup
static void setup(){
    List<Case> lstCasTest;
        lstCasTest = DEG_TestDataGenerator_cls.createCaseVentas(1);
        insert lstCasTest;  
        system.debug(lstCasTest);
        ServiciosWeb__c servicioWeb = DEG_TestDataGenerator_cls.createEndpoint();
        insert servicioWeb;
}
@isTest
static void testCallout(){
test.startTest();
Test.setMock(WebServiceMock.class, new DEG_BacklandingCalloutMock());
List<Case> lstCase = [SELECT id, DEG_Nivel3__c
                      FROM Case LIMIT 1];
                      lstCase[0].DEG_Nivel3__c ='PBX';
                      update lstCase;     
                      system.debug(lstCase);         
DEG_BacklandingActualizar.inicializarMetodo(lstCase.get(0).Id);
test.stopTest();
}
}