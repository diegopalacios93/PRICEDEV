/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases LTE_RespuestaSolSaliente_cls y LTE_GenXmlPortabilidadSaliente_cls.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-03      Raul Mora (RM)		        Creación de la clase.
***********************************************************************************************************************/
@isTest
private class LTE_RespuestaSolSaliente_tst
{
	public LTE_Lote__c createData()
	{
		LTE_Lote__c objLote = new LTE_Lote__c();
		objLote.LTE_Identificador__c = 'ClasPrueba';
		objLote.LTE_Observaciones__c = 'ClasePrueba';
		insert objLote;
		
		List<LTE_DetalleLote__c> lstDetLot = new List<LTE_DetalleLote__c>();
		
		LTE_DetalleLote__c objDetLote = new LTE_DetalleLote__c();
		objDetLote.LTE_Lote__c = objLote.Id;
		objDetLote.LTE_NumeroLinea__c = '123321';
		objDetLote.LTE_AdjuntoRechazo1__c = 'ClasePrueba';
		objDetLote.LTE_AdjuntoRechazo2__c = 'ClasePrueba';
		objDetLote.LTE_AdjuntoRechazo3__c = 'ClasePrueba';
		objDetLote.LTE_AdjuntoRechazo4__c = 'ClasePrueba';
		objDetLote.LTE_CodigosRechazo__c = 'Prueba 1;Prueba 2';
		objDetLote.LTE_Rechazado__c = true;
		lstDetLot.add( objDetLote );
		
		LTE_DetalleLote__c objDetLote2 = new LTE_DetalleLote__c();
		objDetLote2.LTE_Lote__c = objLote.Id;
		objDetLote2.LTE_NumeroLinea__c = '3221123';
		objDetLote2.LTE_AdjuntoRechazo1__c = 'ClasePrueba';
		objDetLote2.LTE_AdjuntoRechazo2__c = 'ClasePrueba';
		objDetLote2.LTE_AdjuntoRechazo3__c = 'ClasePrueba';
		objDetLote2.LTE_AdjuntoRechazo4__c = 'ClasePrueba';
		objDetLote2.LTE_CodigosRechazo__c = 'Prueba 1;Prueba 2';
		objDetLote2.LTE_Rechazado__c = true;
		lstDetLot.add( objDetLote2 );
		
		insert lstDetLot;
		
		return objLote;
	}
	
    static testMethod void myUnitTest() 
    {
        LTE_RespuestaSolSaliente_tst clsTest = new LTE_RespuestaSolSaliente_tst();
        
        LTE_Lote__c objDeLo = clsTest.createData();
        
        Test.startTest();
        	//String strTest = LTE_RespuestaSolSaliente_cls.enviarPortabilidadSaliente( objDeLo.Id );
        	LTE_RespuestaSolSaliente_cls testController = new LTE_RespuestaSolSaliente_cls(new Apexpages.Standardcontroller(objDeLo));
        	testController.enviarPortabilidadSaliente();
        Test.stopTest();
    }
}