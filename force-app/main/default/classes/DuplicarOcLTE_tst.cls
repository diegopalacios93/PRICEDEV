@isTest
private class DuplicarOcLTE_tst {
	
	static testMethod void DuplicarOcLTE() {
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');

        objPruebas_tst obj =new objPruebas_tst();

        objPruebas_tst.confPersonalizadas();
        
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	insert cliente;
    	
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        insert leg;

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='Convenio de cupo';
        Catalogo.CodigoProducto__c='Conveniodecupo001';
        Catalogo.LineaNegocio__c='REDES MOVILES';
        insert Catalogo;
        
        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.Name='Plan Larga Distancia '+Catalogo.Name;
        plan.IdUnico__c='PlanLargaDistancia';
        insert plan;

        List<TOPP__c> toppList=new List<TOPP__c>();

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        topp.Facturable__c=true;
        topp.TipodeOperacionporplan__c='Venta';
        toppList.add(topp);
        insert toppList;

        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        insert servicio;

        list<OperacionComercial__c> ocsList=new list<OperacionComercial__c>();
        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.TOPP__c=topp.id;
        oc.Estado__c='Pendiente';
        ocsList.add(oc);
        insert ocsList;

        Test.startTest();
        PageReference pageRef0 = Page.DuplicarOcLTE;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('Id', oc.id);
        DuplicarOcLTE_ctr dup=new DuplicarOcLTE_ctr();

        Map<string,string> mapObj=new Map<string,string>();
        mapObj.put('Id',oc.id);
        mapObj.put('Idac',servicio.id);
        mapObj.put('cantidad','1');
        DuplicarOcLTE_ctr.duplicarOC(JSON.serialize(mapObj),'');
        LibreriaUtilitaria_cls.ErrorExcepcionTest=true;
        DuplicarOcLTE_ctr.duplicarOC(JSON.serialize(mapObj),'');

        Test.stopTest();

	}
	
}