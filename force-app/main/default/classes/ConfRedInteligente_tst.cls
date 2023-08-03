@isTest
private class ConfRedInteligente_tst {
	static testMethod void myUnitTest() {
        
        Map<String,sObject> objx=objPruebas_tst.general();
        objPruebas_tst.RedIntel();
		
        PageReference pageRef0 = Page.ConfRedInteligente;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('OC', objx.get('oc').id);
        ApexPages.currentPage().getParameters().put('Acc', objx.get('cli').id);
        ApexPages.currentPage().getParameters().put('local', '2');
        
        ConfRedInteligente_ctr cf =new ConfRedInteligente_ctr();
        cf.Guardar();
        cf.Cancelar();
        cf.AgregarCentro();
        cf.getRepresentanteLegal(objx.get('co').id);
        
        
	}
}