/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Permite asignar la cuenta de facturacion a un conjunto de OC legalizadas
Descripción:			Test AsignarCuentaFacturacion_ctr
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		04-06-2015	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
@isTest
private class AsignarCuentaFacturacion_tst {
	
	static testMethod void AsignarCuentaFacturacion_tst() {

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;

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
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'search4';
        document.IsPublic = true;
        document.Name = 'search';
        document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].id;
        insert document;        
        
        CuentaFacturacion__c cfact;
        cfact = new CuentaFacturacion__c();
        //cf.Ciudad__c = pob.Id;
        cfact.Cliente__c = cliente.id;
        cfact.Estado__c='Activo';
        cfact.DirCorresp__c = 'Test direccion';
        cfact.LTE_CicloFacturacion__c = '97';
        insert cfact;
        string CFactJson=JSON.serialize(cfact.Id);  
        
        Test.startTest();
        PageReference pageRef0 = Page.ConsultaCun_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', leg.id);
        AsignarCuentaFacturacion_ctr asCf=new AsignarCuentaFacturacion_ctr();
        string ocJson=asCf.getData();
        asCf.getCuentaFactPadre();
        asCf.getOpcionesMetodoEnvio();
        asCf.getOpcionesTipoCuenta();
        AsignarCuentaFacturacion_ctr.setOC(ocJson,CFactJson);
        CuentaFacturacion__c cf =obj.objCuentaFacturacion();
        string cfJson=JSON.serialize(cf);
        AsignarCuentaFacturacion_ctr.setCuentaFacturacion(cfJson);

        asCf.getCiudad();
        asCf.getCiudad();
        asCf.getCuentaFact();
        //asCf.getCuentaFactPadre();
        //asCf.getOpcionesMetodoEnvio();
        //asCf.getOpcionesTipoCuenta();
        asCf.showPopup();
        asCf.changeCheckbox();
        asCf.closePopup();
        AsignarCuentaFacturacion_ctr.generarLogDirecciones();

        LibreriaUtilitaria_cls.ErrorExcepcionTest=true;
        AsignarCuentaFacturacion_ctr.setCuentaFacturacion(cfJson);
        AsignarCuentaFacturacion_ctr.setOC(ocJson,CFactJson);


      
        PageReference pageRef1 = Page.ConsultaCun_pag;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('id', leg.id);
        AsignarCuentaFacturacion_ctr asCf1=new AsignarCuentaFacturacion_ctr();
        asCf1.blnCuentaCobro = true;
        string ocJson1=asCf1.getData();
        AsignarCuentaFacturacion_ctr.setOC(ocJson1,CFactJson);
        CuentaFacturacion__c cf1 =obj.objCuentaFacturacion();
        string cfJson1=JSON.serialize(cf1);
        AsignarCuentaFacturacion_ctr.setCuentaFacturacion(cfJson1);

        asCf1.getCiudad();
        asCf1.getCiudad();
        asCf1.getCuentaFact();
        //asCf1.getCuentaFactPadre();
        //asCf1.getOpcionesMetodoEnvio();
        //asCf1.getOpcionesTipoCuenta();
        asCf1.showPopup();
        asCf1.changeCheckbox();
        asCf1.closePopup();     
        
        LibreriaUtilitaria_cls.ErrorExcepcionTest=true;
        AsignarCuentaFacturacion_ctr.setCuentaFacturacion(cfJson1);
        AsignarCuentaFacturacion_ctr.setOC(ocJson1,CFactJson);


        Test.stopTest();
		
	}
}