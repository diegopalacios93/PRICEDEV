/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Clase de Prueba para Lead

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-03-21		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/
@isTest
private class Lead_tst {
	//	Prueba para el método de Asociación de lupas en Lead
	@isTest static void TestTrgCrearLupaPoblacion() {
		Poblacion__c p = new Poblacion__c(name = 'Poblacion Prueba');
		insert p;
		Test.startTest();
		String stridP = String.valueOf(p.Id);
		Lead l = new Lead(FirstName = 'Lead', LastName = 'Prueba', Poblacion_Texto__c = stridP, Company = 'Compañia Prueba', C_dula_o_C_digo_ETB__c = 12998878, LeadSource='Negocios Formulario Web–Contactenos', Nit_de_la_Empresa__c= '12998878');
		insert l;
		Test.stopTest();
		System.assertEquals(strIdP, [Select Id, Poblacion__c from Lead Where Id = :l.Id].Poblacion__c);
	}
}