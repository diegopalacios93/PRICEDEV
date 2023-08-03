@IsTest
public class GenerarOperacionComercialRetiro_tst {
    static testMethod void testClass(){
        test.startTest();
        GeneraData_cls.generarData();      
        OperacionComercial__c ocm = GeneraData_cls.oc2;
        List<id> listId = new List<Id>();
        listId.add(ocm.id);
        GenerarOperacionComercialRetiro.generarOCRetiro(listId);
        test.stopTest();
    }
}