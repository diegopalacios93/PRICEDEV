/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases: LTE_EnvioFechaProgramada_cls

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-27      Walter Rodríguez (WR)		Creación de la clase.
***********************************************************************************************************************/
@isTest(SeeAllData=true)
private class LTE_EnvioFechaProgramada_tst 
{
	static testMethod void myUnitTest()
	{
		LTE_Lote__c objLote = new LTE_Lote__c();
		objLote.LTE_Observaciones__c = 'Prueba';
		objLote.LTE_Identificador__c = '12345678';
		objLote.LTE_FechaVentanaCambio__c = System.today();
		insert objLote;
		
		//list<LTE_Lote__c>lstLote = [select Id from LTE_Lote__c where LTE_Legalizacion__c != null and LTE_FechaVentanaCambio__c != null limit 1];
		//LTE_EnvioFechaProgramada_cls.envioFechaProgramada(lstLote[0].Id);
		LTE_EnvioFechaProgramada_cls.envioFechaProgramada(objLote.Id);
	}
	
	//static testMethod void myUnitTest2()
	//{
		//list<LTE_Lote__c>lstLote = [select Id from LTE_Lote__c where LTE_Legalizacion__c != null and LTE_FechaVentanaCambio__c != null limit 1];
	//	LTE_EnvioFechaProgramada_cls.envioFechaProgramada('');
	//}
}