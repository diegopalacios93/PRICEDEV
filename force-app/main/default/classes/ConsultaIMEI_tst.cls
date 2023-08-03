/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Manuel Cortes
Proyecto:           LTE Evolutivos
Descripción:        Clase de prueba para la consulta de IMEI 

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-07-2016  Manuel Cortes (MC)        Creación de la clase.
***********************************************************************************************************************/
@isTest
private class ConsultaIMEI_tst {
	
	@testSetup static void setup()  {
		List<SObject> lstConfiguraciones = new List <SObject>();
		lstConfiguraciones.add(new Tiempo_Ejecucion_Batch__c(Name='ConsultaIMEI_bch' , Tiempo_Ejecucion__c= 15));
		lstConfiguraciones.add(new ServiciosWeb__c(Name='ConsultaIMEI',EndPoint__c='http://201.245.171.239:7052/XXXService/BillingCorporate/Endpoint',Action__c='/Service/BillingCorporate.serviceagent//CreateIncident'));
		insert lstConfiguraciones;
		
		// Crear un detalle de oferta
		LTE_DataGenerator_cls.CreateOfertaEconomica(true);
		LTE_DataGenerator_cls.createDetalleOfertaListasNegras(true);
		
	}
	
	//Se prueba la clase de GestionBatch_cls
	@isTest static void test_1() {
		GestionBatch_cls.getTime(ConsultaIMEI_bch.class, 150);
		// Otra clase X
		GestionBatch_cls.getTime(ConsultaIMEI_tst.class, 150);
	
	}
    @isTest static void test_2() {
       Test.startTest();
       LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
       LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuestaListas','1');
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaIMEI());
        ConsultaIMEI_bch batch = new ConsultaIMEI_bch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    @isTest static void test_3() {
       Test.startTest();
       LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
       LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuestaListas','3');
       
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaIMEI());
        ConsultaIMEI_bch batch = new ConsultaIMEI_bch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}