/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para el controlador LTE_Descuento_Cambio_Plan_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-01-04      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_Descuento_Cambio_Plan_tst {
	
	static testMethod void myUnitTest(){
		Test.startTest();
		
			LTE_NivelesDescuento__c objNivelesDto = new LTE_NivelesDescuento__c();
			objNivelesDto.LTE_NoCuotasNivel1__c = 1;
			objNivelesDto.LTE_DescuentoNivel1__c = 70;
			objNivelesDto.LTE_Indice__c = 0;
			insert objNivelesDto;
			
			Pagereference vfTest = Page.LTE_Descuento_Cambio_Plan_pag;
			Test.setCurrentPage(vfTest);
			
			system.currentPageReference().getParameters().put('type', 'DtoPlan');
			
	        
	        LTE_Descuento_Cambio_Plan_ctr testController = new LTE_Descuento_Cambio_Plan_ctr(new Apexpages.Standardcontroller(objNivelesDto));
	        testController.guardar();
	        testController.poblarCampos();
	        
	        testController.objNivelDescuento.LTE_DescuentoNivel3__c = 10;
	        testController.guardar();
	        
	        objNivelesDto.LTE_DescuentoNivel1__c = 110;
	        update objNivelesDto;
	        testController = new LTE_Descuento_Cambio_Plan_ctr(new Apexpages.Standardcontroller(objNivelesDto));
	        testController.guardar();
		Test.stopTest();
	}
    
}