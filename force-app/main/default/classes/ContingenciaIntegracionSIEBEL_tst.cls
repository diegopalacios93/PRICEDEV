/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Clase de prueba para los desarrollos implementados en la clase ContingenciaIntegracionSIEBEL_cls

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-05-08		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/
@isTest
private class ContingenciaIntegracionSIEBEL_tst {
	public static final Integer intCantidadOC = 100;
	@isTest static void TestNoDataEstadoSiebel() {
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		for (Integer i = 0; i < intCantidadOC; i++) {
			OperacionComercial__c oc = new OperacionComercial__c();
			lstOC.add(oc);
		}
		insert lstOC;
		Test.startTest();
		for (OperacionComercial__c oc : lstOC) {
			oc.Estado_SIEBEL__C = 'Diferente';
		}
		update lstOC;
		Test.stopTest();
		List<Id> lstIdOCTest = new List<Id>();
		for (OperacionComercial__c oc : lstOC) {
			lstIdOCTest.add(oc.Id);
		}
		List<OperacionComercial__c> lstOCTest = [Select Id, Estado_SIEBEL__C from OperacionComercial__c Where Id in :lstIdOCTest];
		for (OperacionComercial__c oc : lstOCTest) {
			System.assertNotEquals('Diferente', oc.Estado_SIEBEL__C);
		}
	}

	@isTest static void TestEstadoSiebelCancelado() {
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		for (Integer i = 0; i < intCantidadOC; i++) {
			OperacionComercial__c oc = new OperacionComercial__c();
			lstOC.add(oc);
		}
		insert lstOC;
		Test.startTest();
		for (OperacionComercial__c oc : lstOC) {
			oc.Estado_SIEBEL__C = 'Cancelado';
		}
		update lstOC;
		Test.stopTest();
		List<Id> lstIdOCTest = new List<Id>();
		for (OperacionComercial__c oc : lstOC) {
			lstIdOCTest.add(oc.Id);
		}
		List<OperacionComercial__c> lstOCTest = [Select Id, Estado__c from OperacionComercial__c Where Id in :lstIdOCTest];
		for (OperacionComercial__c oc : lstOCTest) {
			System.assertEquals('Declinada', oc.Estado__c);
		}
	}

	@isTest static void TestEstadoSiebelCompleto() {
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		for (Integer i = 0; i < intCantidadOC; i++) {
			OperacionComercial__c oc = new OperacionComercial__c();
			lstOC.add(oc);
		}
		insert lstOC;
		Test.startTest();
		for (OperacionComercial__c oc : lstOC) {
			oc.Estado_SIEBEL__C = 'Completo';
			oc.FechadeActivacion__c = Date.today();
		}
		update lstOC;
		Test.stopTest();
		List<Id> lstIdOCTest = new List<Id>();
		for (OperacionComercial__c oc : lstOC) {
			lstIdOCTest.add(oc.Id);
		}
		List<OperacionComercial__c> lstOCTest = [Select Id, Estado__c from OperacionComercial__c Where Id in :lstIdOCTest];
		for (OperacionComercial__c oc : lstOCTest) {
			System.assertEquals('Activa', oc.Estado__c);
		}
	}
}