@isTest
private class EmailMessage_tst {

    static testMethod void myUnitTest() {
        
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');

        
        objPruebas_tst obj =new objPruebas_tst();
        
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	insert cliente;
    	
    	case caso =obj.objCaso();
    	Id recTypeCaso = Schema.SObjectType.case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
    	caso.RecordTypeId=recTypeCaso;
    	caso.AccountId=cliente.id;
        caso.Status='Cerrado';
    	insert caso;
        
        Caso_Cerrado_Tareas__c cct= new Caso_Cerrado_Tareas__c(name='CASO PQR',Id_Usuario__c=UserInfo.getUserId());
        insert cct;

		emailmessage em = new emailmessage();
		em.fromaddress = 'Test@test.com';
		em.toaddress = 'test1@test.com';
		em.subject = 'Test Email';
		em.textbody = 'testing';
		em.parentid = caso.id;
		test.starttest();
		insert em;
		test.stoptest();  

    }
}