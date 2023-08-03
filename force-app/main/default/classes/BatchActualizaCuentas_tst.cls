/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para proceso batch de actualización de cuentas

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     10-10-2013  Daniel Guana (AAC)       	Creación de la clase.
*******************************************************************************/
@isTest
private class BatchActualizaCuentas_tst {
    static testMethod void myUnitTest() {
    	Account acc= new Account();
    	acc.Name = 'testtetsttetswtes';
    	acc.EstadoRestriccionVenta__c = true;
    	insert acc;
    	
    	Database.executeBatch(new BatchActualizaCuentas(),1);  
    	
    	BatchActualizaCuentasExec bat = new BatchActualizaCuentasExec();
		DateTime fechaActual= System.now().addMinutes(1);
		Integer minutos=fechaActual.minute();
		Integer hora=fechaActual.hour();
		Integer dia=fechaActual.day();
		integer mes=fechaActual.month();
		Integer anio=fechaActual.year();
		//Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
		String sch = '0 '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
		System.debug('\n\n###sch'+sch);
		Id tarea=System.schedule('BatchActualizaCuentasExec -'+System.now(), sch, bat);
		
    	system.debug('..== Final...');        
    }
}