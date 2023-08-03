@isTest
private class CambioPropietarioCuenta_tst {

    static testMethod void camibioCuenta() {
    	
    	objPruebas_tst obj =new objPruebas_tst();
    	map<String,Schema.RecordTypeInfo> rt= Schema.SObjectType.Account.getRecordTypeInfosByName();
    	//.get('Cliente Principal').getRecordTypeId();
    	
    	
    	//Sucursales
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =rt.get('Cliente Principal').getRecordTypeId();
    	insert cliente;
    	
    	Account suc=obj.ObjAccount();
    	suc.RecordTypeId =rt.get('Sucursales').getRecordTypeId();
        suc.Direccion__c= 'cr 24 # 45 -4';
        suc.Estado_Direccion__c = 'Pendiente';
    	insert suc;
    	
		Profile p = [SELECT Id FROM Profile WHERE Name='Administrador del sistema'];
		
		string userRandom=Math.random()*1000+'userEtb@etb.com';
		system.debug(userRandom);
    	
    	User u2 = new User(Alias = 'ETbUser', Email=userRandom, 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName=userRandom);
         
         System.runAs(new User(Id = Userinfo.getUserId())) {
         insert u2;
         }
         System.runAs(u2){
         	cliente.OwnerId=Userinfo.getUserId();
         	update cliente ;
         }

         Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseScoreDeDatacredito());

         objPruebas_tst.confPersonalizadas();
         Database.executeBatch(new BatchDireccionesSucursales_bch(),10);




    }
}