/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase de prueba para la clase AutomatizacionEstadosActivosETB_tst 

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		29-01-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/
@isTest (seeAllData=true)
private class AutomatizacionEstadosActivosETB_tst {
    @isTest static void TestCambiosEstadoRetiro() {
    	//Preparación del test
    	//List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
    	GeneraData_cls.generarData();
    	GeneraData_cls.topp.TipodeOperacionporplan__c = 'Retiro';
    	update GeneraData_cls.topp;
    	GeneraData_cls.oc.Estado__c = 'Pendiente';
    	update GeneraData_cls.oc;
    	// Inicio test
    	Test.startTest();
    	GeneraData_cls.oc.Estado__c = 'Activa';
    	update GeneraData_cls.oc;
    	//	Verificación del desarrollo
    	OperacionComercial__c ocVerificacion = [select Id, TOPP__r.TipodeOperacionporplan__c, Estado__c, Activo__r.Estado__c from OperacionComercial__c where id = :GeneraData_cls.oc.id limit 1];
    	System.debug('ocVerificacion:' + ocVerificacion);
    	System.assertEquals('Retiro',ocVerificacion.TOPP__r.TipodeOperacionporplan__c);
    	System.assertEquals('Activa',ocVerificacion.Estado__c);
    	System.assertEquals('Inactivo',ocVerificacion.Activo__r.Estado__c);
    	Test.stopTest();
    }
}