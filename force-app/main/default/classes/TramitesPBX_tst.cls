@isTest
public class TramitesPBX_tst {

	public static Map<String,sObject> general(){

		Map<String,sObject> xdata=new Map<String,sObject>();

		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');

		
        objPruebas_tst obj =new objPruebas_tst();
        
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;

        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
    	
        
    	Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
    	Account sucursal=obj.ObjAccount();
    	sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
    	insert sucursal;

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        insert Catalogo;

        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        insert plan;

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        insert topp;

        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;

        insert servicio;

        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();

        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.TOPP__c=topp.id;
        insert oc;

        xdata.put('opt',opt);
        xdata.put('oc',oc);
        xdata.put('ac',servicio);

        return xdata;
	}

	static testMethod void crearPBX() {

    	Map<String,sObject> objx=general();
    	
    	test.startTest();


    	//PageReference pageRef0 = Page.TramitesCrearPbx;
    	//Test.setCurrentPage(pageRef0);
        //ApexPages.currentPage().getParameters().put('id', opt.id);


        ApexPages.StandardController sc = new ApexPages.StandardController(objx.get('opt'));
    	TramitesCrearPbx_ctr tPbx=new TramitesCrearPbx_ctr(sc);



 
        test.stopTest();


	}

	static testMethod void tramitesPBX() {

    	Map<String,sObject> objx=general();
    	
    	test.startTest();


    	PageReference pageRef0 = Page.TramitesCrearPbx;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('oc', objx.get('oc').id);


        ApexPages.StandardController sc = new ApexPages.StandardController(objx.get('ac'));
    	Tramites_ctr tPbx=new Tramites_ctr(sc);



 
        test.stopTest();


	}

}