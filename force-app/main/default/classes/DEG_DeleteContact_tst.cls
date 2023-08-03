@isTest
public class DEG_DeleteContact_tst {
    static testMethod void myTestMethod() {    
        LTE_AprovisionamientoBolsaCompartida_tst.CreateData();
        contact objcontact=LTE_AprovisionamientoBolsaCompartida_tst.objContact;
        objcontact.DEG_DeleteContact__c=true;
        update objcontact;
        Test.startTest();   
        SchedulableContext sc;        
        DEG_DeleteContact_bch sch = new DEG_DeleteContact_bch();
        ID batchprocessid = Database.executeBatch(sch,1);
        Test.stopTest(); 
    }
}