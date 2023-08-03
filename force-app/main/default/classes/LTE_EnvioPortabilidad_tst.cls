/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases: LTE_EnvioPortabilidad_ctr

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-27      Walter Rodríguez (WR)		Creación de la clase.
***********************************************************************************************************************/
@isTest(SeeAllData=true)
private class LTE_EnvioPortabilidad_tst
{
	/*static testMethod void myUnitTest() 
	{
		Legalizacion__c objLegalizacion = [select Id, Fecha1radevolucion__c, FechaRadicacion__c from Legalizacion__c limit 1];
		
		Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller( objLegalizacion );
		LTE_EnvioPortabilidad_ctr controller = new LTE_EnvioPortabilidad_ctr( stdController );
	}*/
	
	static testMethod void myUnitTest2() 
	{
		Legalizacion__c objLegalizacion = [select Id, Fecha1radevolucion__c, FechaRadicacion__c from Legalizacion__c limit 1];
		//LTE_Lote__c objLote = [select Id, LTE_Legalizacion__c from LTE_Lote__c limit 1];
		LTE_Lote__c objLote = new LTE_Lote__c( LTE_Legalizacion__c = objLegalizacion.Id);
		objLote.LTE_Legalizacion__c = objLegalizacion.Id;
		insert objLote;
		
		Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller( objLegalizacion );
		LTE_EnvioPortabilidad_ctr controller = new LTE_EnvioPortabilidad_ctr( stdController );
		controller.datFechaPortabilidad = system.today();
	}
	
	static testMethod void myUnitTest3() 
	{
		Legalizacion__c objLegalizacion = [select Id, Fecha1radevolucion__c, FechaRadicacion__c from Legalizacion__c limit 1];
		//LTE_Lote__c objLote = [select Id, LTE_Legalizacion__c from LTE_Lote__c limit 1];
		LTE_Lote__c objLote = new LTE_Lote__c( LTE_Legalizacion__c = objLegalizacion.Id);
		objLote.LTE_Legalizacion__c = objLegalizacion.Id;
		insert objLote;
		
		Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller( objLegalizacion );
		LTE_EnvioPortabilidad_ctr controller = new LTE_EnvioPortabilidad_ctr( stdController );
		controller.datFechaPortabilidad = system.today().addDays(8);
		controller.enviarPortabilidad();
		controller.regresar();
	}
	
	
}