@isTest
private class LTE_AsignarCuentaFacturacion_tst {
	public static Map<string,string> variablesTest=new Map<string,string>();
    public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();
    public static string CFactJson;
    
    static testMethod void AsignarCuentaFacturacion() {
    	
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate'); 

        variablesTest.put('oc.Estado__c','Pendiente');
    	
    	crearData();
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'search5';
        document.IsPublic = true;
        document.Name = 'search';
        document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].id;
        insert document;        
        
    	LTE_AsignarCuentaFacturacion_ctr asCuentaFact0=new LTE_AsignarCuentaFacturacion_ctr();
                
        PageReference pageRef0 = Page.LTE_AsignarCuentaFacturacion_pag;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', variablesObj.get('Legalizacion')[0].id);
        
        LTE_AsignarCuentaFacturacion_ctr asCuentaFact=new LTE_AsignarCuentaFacturacion_ctr();
        string datos=asCuentaFact.getData();        
        LTE_AsignarCuentaFacturacion_ctr.setOC(datos,CFactJson);
    }

    public static void crearConfiguracion(){
    	   	
    	List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
    	
    	list<sobject> vg=new list<sobject>();
    	vg.add(new VariablesGlobales__c(Name='NombreDefaultaFacturacionLTE',Valor__c='DEFAULT FACTURACION LTE'));
    	vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
    	vg.add(new VariablesGlobales__c(Name='NombreFacturacionLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
    	vg.add(new VariablesGlobales__c(Name='NombrePlanDefectorLTE',Valor__c='DEFAULT FACTURACION LTE'));
    	vg.add(new VariablesGlobales__c(Name='aprovisionamientoOnline',Valor__c='3'));
    	vg.add(new ServiciosWeb__c(Name='DisponibilidadM6',Action__c='/action',EndPoint__c='https://salesforce.com/x'));
    	vg.add(new ServiciosWeb__c(Name='Aprovisionar',Action__c='/action',EndPoint__c='https://salesforce.com'));
    	vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=UserInfo.getProfileId()));
    	vg.add(new Perfiles_Acciones__c(Name='DataCreditoScore',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new Perfiles_Acciones__c(Name='Adjuntos',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new HomologacionCampos__c(Valor__c='NIT',Name='AprovNIT'));
        
        
        vg.add(new AprovisionamientoOnline__c(Name='Disponibilidad M6',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento Tramites',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
    	    	
    	insert vg;    
    }
    
	public static void crearData(){
    	
    	crearConfiguracion();
    	variablesObj.put('Account',new list<sobject>());
    	  	
   
    	objPruebas_tst obj=new objPruebas_tst();
    	
    	Account cliente =obj.objAccount();
    	insert cliente;
    	variablesObj.get('Account').add(cliente);
    	
   	
    	Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
    	Account sucursal=obj.ObjAccount();
    	sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
    	insert sucursal;
    	
    	Id devRecordOpt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
    	Opportunity oportunidad=obj.objOpt();
    	oportunidad.accountId=cliente.Id;
    	oportunidad.RecordTypeId=devRecordOpt;
    	insert oportunidad;
    	
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c='LTE';
        insert Catalogo;
        
        CatalogoProductosFacturacion__c objCatalogoProdFact=objPruebas_tst.objCatalogoProductosFacturacion();
        objCatalogoProdFact.Name=Catalogo.Name;
        objCatalogoProdFact.CatalogoProductos__c=Catalogo.Id;
        insert objCatalogoProdFact;
    	
    	planes__c Plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.LTE_PlanEstructurados__c=false;
        insert plan;
        
    	TOPP__c topp= obj.objTopp();
        topp.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp.Facturable__c=true;
        insert topp;

        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=oportunidad.id;
        servicio.Tipodeprogramacion__c='Troncal';
        insert servicio;
        variablesObj.put('ActivoETB',new list<ActivoETB__c>());
        variablesObj.get('ActivoETB').add(servicio);
    	
        Poblacion__c objDepto = new Poblacion__c();
      objDepto.Name = 'BOGOTA D.C.';
      objDepto.CodigoDane__c = '09374';
      objDepto.EsDepartamento__c = true;
      insert objDepto;

    Poblacion__c objMunicipio = new Poblacion__c();
      objMunicipio.Name = 'BOGOTA D.C.';
      objMunicipio.CodigoDane__c = '63945';
      objMunicipio.EsMunicipio__c = true;
      objMunicipio.Padre__c = objDepto.Id;
      insert objMunicipio;

    	CuentaFacturacion__c objCuentaFacturacion=obj.objCuentaFacturacion();
        objCuentaFacturacion.Cliente__c=cliente.id;
        objCuentaFacturacion.Ciudad__c = objMunicipio.Id;
        objCuentaFacturacion.DirCorresp__c = 'Test DirCorresp';
        insert objCuentaFacturacion;
        
    	Contract contrato=obj.objContrato();
    	contrato.Accountid =cliente.Id;
    	insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
    	leg.Contrato__c=contrato.id;
    	leg.estado__c='No Gestionado';
    	insert leg;
        variablesObj.put('Legalizacion',new list<Legalizacion__c>());
        variablesObj.get('Legalizacion').add(leg);
    	
    	OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=oportunidad.id;
        oc.IDServicio__c='CAV1024234';
        oc.TOPP__c=topp.id;
        oc.CuentaFacturacion__c=objCuentaFacturacion.id;
        oc.Estado__c=variablesTest.get('oc.Estado__c');
        oc.LTE_ICCID__c='490816320198746';
        oc.LTE_AplicaOnline__c=true;
		oc.LTE_IMSI__c='23244';
		oc.LTE_PIN__c='34343';
		oc.LTE_PUK__c='33434';
		oc.legalizacion__c= leg.id;
        insert oc;
        variablesObj.put('OperacionComercial',new list<OperacionComercial__c>());
        variablesObj.get('OperacionComercial').add(oc);
        
        CuentaFacturacion__c cfact;
        cfact = new CuentaFacturacion__c();
        //cf.Ciudad__c = pob.Id;
        cfact.Cliente__c = cliente.id;
        cfact.Estado__c='Activo';
        cfact.DirCorresp__c = 'Test direccion';
        cfact.LTE_CicloFacturacion__c = '97';
        insert cfact;
        CFactJson=JSON.serialize(cfact.Id);
    
    }
}