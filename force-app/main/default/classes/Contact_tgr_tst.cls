/**
 * @description       : 
 * @author            : Juan David Martinez Mercado
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : j.martinez.mercado
**/
@isTest
private class Contact_tgr_tst {

    static testMethod void insertContact(){
        GeneraData_cls.generarPoblacion();
        GeneraData_cls.generarCuenta();
        test.startTest();
            GeneraData_cls.generarContacto();
        test.stopTest();
    }

    static testMethod void updateContact(){
        GeneraData_cls.generarPoblacion();
        GeneraData_cls.generarCuenta();
        test.startTest();
            Id contactId = GeneraData_cls.generarContacto();
            List<Contact> tstContact = [SELECT Id, Email, Name, Ciudad__c 
                                        FROM Contact WHERE Name = 'contactoconconconcontest' 
                                        LIMIT 1];
            tstContact[0].Email = 'ContactoDePrueba@etb.com';
            update tstContact;
        test.stopTest();
    }
}