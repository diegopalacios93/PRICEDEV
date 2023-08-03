/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Test AsignacionLinea desarrollo LD
Descripción:            Test AsignacionLinea desarrollo LD
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     29-05-2015  Hector Bayona (HB)      Creación de la clase
*******************************************************************************/

@isTest
private class AsignacionLinea_tst {

    static testMethod void AsignacionLineaIni(){

        PageReference pageRef = Page.AsignacionLinea_pag;
        Test.setCurrentPage(pageRef);

        Test.startTest();
        AsignacionLinea_ctr aL =new AsignacionLinea_ctr();
        Test.stopTest();

        OperacionPorPlan_cls.Step oP=new OperacionPorPlan_cls.Step();
        oP.procesar(new set<ID>());
    }
    
    static testMethod void AsignacionLinea(){

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;

        Map<String,sObject> xdata=new Map<String,sObject>();

        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');

        
        objPruebas_tst obj =new objPruebas_tst();

        objPruebas_tst.confPersonalizadas();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        insert cliente;
        
        /*
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.id;
        insert contacto;

        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        */      
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='Convenio de cupo';
        Catalogo.CodigoProducto__c='Conveniodecupo001';

        
        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.Name='Plan Larga Distancia '+Catalogo.Name;
        plan.IdUnico__c='PlanLargaDistancia';
        insert plan;

        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;

        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion;   

        Poblacion__c objDepto = new Poblacion__c();
      objDepto.Name = 'BOGOTA D.C.';
      objDepto.CodigoDane__c = '11000';
      objDepto.EsDepartamento__c = true;
      insert objDepto;

    Poblacion__c objMunicipio = new Poblacion__c();
      objMunicipio.Name = 'BOGOTA D.C.';
      objMunicipio.CodigoDane__c = '11001';
      objMunicipio.EsMunicipio__c = true;
      objMunicipio.Padre__c = objDepto.Id;
      insert objMunicipio;

        CuentaFacturacion__c objCuentaFacturacion=obj.objCuentaFacturacion();
        objCuentaFacturacion.Cliente__c=cliente.id;        
        objCuentaFacturacion.Ciudad__c = objMunicipio.Id;
        objCuentaFacturacion.DirCorresp__c = 'Test DirCorresp';
        insert objCuentaFacturacion;

        List<TOPP__c> toppList=new List<TOPP__c>();

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        topp.Facturable__c=true;
        topp.TipodeOperacionporplan__c='Venta';
        toppList.add(topp);

        TOPP__c topp2= obj.objTopp();
        topp2.Plan__c=plan.id;
        topp2.Facturable__c=true;
        topp2.TipodeOperacionporplan__c='Retiro';
        toppList.add(topp2);

        TOPP__c topp3= obj.objTopp();
        topp3.Plan__c=plan.id;
        topp3.Facturable__c=true;
        topp3.TipodeOperacionporplan__c='Retiro Lineas de LD';
        toppList.add(topp3);

        TOPP__c topp4= obj.objTopp();
        topp4.Plan__c=plan.id;
        topp4.Facturable__c=true;
        topp4.TipodeOperacionporplan__c='Adición Lineas de LD';
        toppList.add(topp4);

        insert toppList;

        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        //servicio.Oportunidad__c=opt.id;
        insert servicio;

        list<OperacionComercial__c> ocsList=new list<OperacionComercial__c>();

        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        //oc.Oportunidad__c=opt.id;
        oc.TOPP__c=topp.id;
        oc.CuentaFacturacion__c=objCuentaFacturacion.id;
        oc.Estado__c='Pendiente';
        ocsList.add(oc);

        OperacionComercial__c ocR =obj.objOc();
        ocR.CuentaCliente__c=cliente.id;
        ocR.Activo__c=servicio.id;
        ocR.Plan__c=plan.id;
        //ocAL.Oportunidad__c=opt.id;
        ocR.TOPP__c=topp4.id;
        ocR.CuentaFacturacion__c=objCuentaFacturacion.id;
        ocR.Estado__c='Pendiente';
        ocsList.add(ocR);

        /*
        OperacionComercial__c ocR =obj.objOc();
        ocR.CuentaCliente__c=cliente.id;
        ocR.Activo__c=servicio.id;
        ocR.Plan__c=plan.id;
        //ocR.Oportunidad__c=opt.id;
        ocR.TOPP__c=topp2.id;
        ocR.CuentaFacturacion__c=objCuentaFacturacion.id;
        ocR.Estado__c='Pendiente';
        ocsList.add(ocR);

        OperacionComercial__c ocRL =obj.objOc();
        ocRL.CuentaCliente__c=cliente.id;
        ocRL.Activo__c=servicio.id;
        ocRL.Plan__c=plan.id;
        //ocRL.Oportunidad__c=opt.id;
        ocRL.TOPP__c=topp3.id;
        ocRL.CuentaFacturacion__c=objCuentaFacturacion.id;
        ocRL.Estado__c='Pendiente';
        ocsList.add(ocRL);
        */

        insert ocsList;

        PageReference pageRef = Page.AsignacionLinea_pag;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('newid', oc.id);
        ApexPages.currentPage().getParameters().put('id',cliente.id);
        ApexPages.currentPage().getParameters().put('topp',topp.id);
        
        ServiciosWeb__c sw = new ServiciosWeb__c();
        sw.Name = 'LDConsultaConexionNumber';
        sw.EndPoint__c = 'http://endpoint';
        sw.Action__c = '/action';
        insert sw;
        
        Test.startTest();
        AsignacionLinea_ctr aL =new AsignacionLinea_ctr();
        string conf=aL.getConf();
        string conpon=aL.getComponentes();
        string lineas=AsignacionLinea_ctr.buscarLineas('12345678,12345679',conf);

        List<AsignacionLinea_ctr.lineaJson> listjs=new List<AsignacionLinea_ctr.lineaJson>();
        Linea__c l=new Linea__c(Codigo_de_linea__c='12345678',Name='12345678');
        AsignacionLinea_ctr.lineaJson lj= new AsignacionLinea_ctr.lineaJson(l,true,'form','');
        listjs.add(lj);
        string rj=AsignacionLinea_ctr.guardarLineas(JSON.serialize(listjs),conf);

        oc.Estado__c='Activa';
        oc.FechadeActivacion__c=Date.Today();
        Profile p = [SELECT Id FROM Profile WHERE Name='Integraciones']; // JDUR 2016/01/08
		User u = new User(Alias = 'intusr', Email='intusr@testorg.com', 
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = p.Id, 
		TimeZoneSidKey='America/Los_Angeles', UserName='intusr@testorg.com');
		System.runAs(u) {
			update oc;
		}

        //RETIRO LD
        PageReference pageRefRet = Page.RetiroLD;
        Test.setCurrentPage(pageRefRet);
        ApexPages.currentPage().getParameters().put('newid', ocR.id);
        ApexPages.currentPage().getParameters().put('id',cliente.id);
        ApexPages.currentPage().getParameters().put('topp',topp2.id);
        RetiroLD_ctr ret =new RetiroLD_ctr();
        string confRet=ret.getConf();
        string lineasRet=ret.getLineas();
        Map<String,List<RetiroLD_ctr.lineaJson>> lineasRetMap =(Map<String,List<RetiroLD_ctr.lineaJson>>)JSON.deserialize(lineasRet, Map<String,List<RetiroLD_ctr.lineaJson>>.class);
        lineasRet=JSON.serialize(lineasRetMap.get('correcto'));
        RetiroLD_ctr.guardarLineas(lineasRet,confRet);
        
        Test.stopTest();

    }

}