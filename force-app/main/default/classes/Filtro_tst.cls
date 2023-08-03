@isTest
private class Filtro_tst {

	static testMethod void myUnitTest() {
		
		objPruebas_tst misObjetos=new objPruebas_tst();
		
		Account cliente = misObjetos.ObjAccount();
		insert cliente;
		
		string c=filtro_cls.codificar(' Where id =\''+cliente.Id+'\'');
		string f=filtro_cls.codificar(',Name');
		
		PageReference pageRef = Page.filtro;
    	Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', cliente.id);
        ApexPages.currentPage().getParameters().put('c', c);
        ApexPages.currentPage().getParameters().put('f', f);
		
		Filtro_cls ff=new Filtro_cls();
		
		ff.getDynamicTable();
		ff.abuscar='name';
		
		ff.buscar();
		
		//f.init();
	}

}