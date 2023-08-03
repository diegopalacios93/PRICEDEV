@isTest
private class LTE_LibreriaUtilitaria_tst {

    static testMethod void myUnitTest() {
    	
    	objPruebas_tst obj=new objPruebas_tst();
    	
        LTE_LibreriaUtilitaria_cls.checkImei('1637356273');
        LTE_LibreriaUtilitaria_cls.checkImei(null);
        LTE_LibreriaUtilitaria_cls.checkImei('123456789012345');
        
        
        list<Account>lstAccount=new list<Account>();
        Account cliente =obj.objAccount();
        lstAccount.add(cliente);
    	
    	insert lstAccount;
    	
    	LTE_LibreriaUtilitaria_cls.DigitoVerificacion(lstAccount);
        
    }
}