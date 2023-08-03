@isTest
private class LTE_Descuento_tst {
	
	@isTest static void test_method_one() {
		// Implement test code 
		Test.startTest();
		
		Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
		
		LTE_NivelesDescuento__c objNivelesDto = new LTE_NivelesDescuento__c();
		objNivelesDto.LTE_NoCuotasNivel1__c = 1;
		objNivelesDto.LTE_DescuentoNivel1__c = 70;
		objNivelesDto.LTE_Oportunidad__c = objOportunidad.Id;
		objNivelesDto.LTE_Indice__c = 0;
		insert objNivelesDto;
		
		Pagereference vfTest = Page.LTE_Descuento_pag;
		Test.setCurrentPage(vfTest);
		
		system.currentPageReference().getParameters().put('type', 'DtoVoz');
		system.currentPageReference().getParameters().put('name', objNivelesDto.Name );
		system.currentPageReference().getParameters().put('row', String.valueOf(0));
		system.currentPageReference().getParameters().put('opp', objOportunidad.Id );
		
        
        LTE_Descuento_ctr testController = new LTE_Descuento_ctr(new Apexpages.Standardcontroller(objNivelesDto));
        testController.guardar();
        testController.poblarCampos();
        
        objNivelesDto.LTE_DescuentoNivel3__c = 1400;
        testController.guardar();
		Test.stopTest();
	}
	
}