/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para clase encargada de poblar el campo manager del obj usuario según su cargo. 
						Invocada desde el trigger a objeto Opportunity

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-10-2013  Daniel Guana (DGUANA)       Creación de la clase. (100%)
1.1		23-06-2014	Jorge Grimaldos (JG)		Ajuste para compatibilidad con RV-32
*******************************************************************************/
@isTest
private class ActualizarAprobadores_tst {

	//static testMethod void myUnitTest() {
		
	//	String id = GeneraData_cls.generarUsuario();
	//	User us = new User(Id = id);
	//	test.startTest();
	//	System.runAs(us){
	   //		GeneraData_cls.generarData();

	   //		Opportunity opp = new Opportunity();
	   //		opp.OwnerId = Id;

	   //		List<Opportunity> lstOpp = new List<Opportunity>();
	   //		lstOpp.add(opp);

	   //		ActualizarAprobadores_cls cls = new ActualizarAprobadores_cls();
	   //		cls.Actualizar(lstOpp);
	//	}
	//	test.stopTest();
	//}

	@isTest static void TestAsignarAprobadores() {
		User u = new User(Id = Userinfo.getUserId());
		u.EsAsesor__c = true;
		update u;
		Account a = new Account( Name = 'Test Account', OwnerId = u.id);
		insert a;
		System.debug('Name:' + [Select Owner.Username from Account Where Id =: a.id].Owner.UserName);
		Opportunity opp = new Opportunity( AccountId = a.id, Name = 'Test Opp', StageName ='En Estudio', CloseDate = System.today() + 7);
		insert opp;
	}
}