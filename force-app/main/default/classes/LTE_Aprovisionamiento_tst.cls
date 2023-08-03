@isTest
public class LTE_Aprovisionamiento_tst {

    public static Map<string,string> variablesTest=new Map<string,string>();
    public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();
    public static boolean conf=false;


    static testMethod void obtenerEstructurado() {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate'); 
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');

        variablesTest.put('oc.Estado__c','Equipo entregado');


        crearData();
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        string producto=vGlobal.get('NombreComercialLTE').valor__c;
        
    map<id, OperacionComercial__c> ocsMap=new map<id, OperacionComercial__c>([  
    SELECT  Id,Name,CuentaCliente__c,Activo__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c
    FROM OperacionComercial__c
    WHERE (
    (((Estado__c = 'Equipo entregado' And Portacion__c=False And Legalizacion__r.Estado__c='Gestionado') OR ((Estado__c = 'Pendiente' OR Estado__c = 'Equipo entregado') And Portacion__c=True  And FechadeActivacion__c <= TODAY)) AND TOPP__r.TipodeOperacionporplan__c='Venta') OR 
    ((TOPP__r.TipodeOperacionporplan__c='Renovación' OR TOPP__r.TipodeOperacionporplan__c='Reposición') AND (LTE_TipoTransaccion__c = 'SIM' OR LTE_TipoTransaccion__c = 'Equipo más SIM') And Estado__c = 'Equipo entregado') )
    AND TOPP__r.LTE_Catalogo_de_Producto__r.Name=:producto 
    AND Plan__r.NombredelProducto__r.Name=:producto
    AND LTE_ICCID__c!=null ]);
    
        LTE_Aprovisionamiento_cls.obtenerEstructurado(ocsMap);


    }
    
    static testMethod void DisponibilidadM6() {

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate'); 
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');

        variablesTest.put('oc.Estado__c','Equipo entregado');


        crearData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','01');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('correlationID','PASS');
        
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseDisponibilidad());
        Test.startTest();
        String jobId = System.schedule('LTE_AvailabilitQueryOrder_sch','0 0 0 * * ? *',new LTE_AvailabilitQueryOrder_sch());
        Test.stopTest();

    }
    
    static testMethod void Aprovisionar() {

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        variablesTest.put('oc.Estado__c','Exitoso M6');
        variablesTest.put('esAprovisionamiento','si');
        crearData();
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseDisponibilidad());
         
        Test.startTest();
        LTE_aprovisionar_ctr aprovisionar=new LTE_aprovisionar_ctr();
        aprovisionar.getItems();
        aprovisionar.opcion='Disponibilidad M6';
        aprovisionar.ejecutar();        
        aprovisionar.opcion='Aprovisionamiento';
        aprovisionar.ejecutar();
        aprovisionar.opcion='Facturacion';
        aprovisionar.ejecutar();
        aprovisionar.opcion='Aprovisionamiento Tramites';
        aprovisionar.ejecutar();
        aprovisionar.opcion='AprovisionamientoAPN';
        aprovisionar.ejecutar();
        aprovisionar.opcion='AprovisionamientoAPNDatos';
        aprovisionar.ejecutar();
        aprovisionar.opcion='AprovTramiteBolsaCompartida';
        aprovisionar.ejecutar();
        Test.stopTest();


        
    }
    

    static testMethod void Aprovisionamiento() {

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        variablesTest.put('oc.Estado__c','Exitoso M6');
        variablesTest.put('esAprovisionamiento','si');  


        crearData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','17');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseDescription','ENVIADO');
        
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseAprovisionamiento());
        Test.startTest();
        String jobId = System.schedule('LTE_Aprovisionamiento_sch','0 0 0 * * ? *',new LTE_Aprovisionamiento_sch());
        Test.stopTest();
        
        list<OperacionComercial__c>ocLst=new list<OperacionComercial__c>([select TOPP__r.Name,TOPP__r.LTE_Catalogo_de_Producto__r.Name,Plan__r.NombredelProducto__r.Name,Estado__c,FechadeActivacion__c,Portacion__c,Legalizacion__r.Estado__c FROM OperacionComercial__c]);
        system.debug(ocLst[0].TOPP__r.Name+' '+ocLst[0].Plan__r.NombredelProducto__r.Name);
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
        vg.add(new AprovisionamientoOnline__c(Name='Disponibilidad M6',LTE_Noche__c=30));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento',LTE_Noche__c=30));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento Tramites',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='AprovisionamientoAPN',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='AprovisionamientoAPNDatos',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='AprovTramiteBolsaCompartida',LTE_Noche__c=3));
        vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='DisponibilidadM6',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='Facturacion',Ejecucion__c=true));
        vg.add(new LTE_TramitesSuspenda__c(Name='Suspensión, Fraude',LTE_Estado__c='Suspendido',LTE_Causal__c='Fraude'));
        vg.add(new LTE_TramitesSuspenda__c(Name='Suspensión, Fraude, Otro',LTE_Estado__c='Suspendido',LTE_Causal__c='Fraude'));
        vg.add(new LTE_TramitesSuspenda__c(Name='Retiro, Portabilidad Saliente',LTE_Estado__c='Activa',LTE_Causal__c='Portabilidad Saliente'));
        
        insert vg;
    
    }
    
    public static void crearData(){
        
        crearConfiguracion();
        variablesObj.put('Account',new list<sobject>());
            
   
        objPruebas_tst obj=new objPruebas_tst();
        
        Account cliente =obj.objAccount();
        insert cliente;
        variablesObj.get('Account').add(cliente);
        
        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
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
        
        list<PlanFacturacion__c>PlanFactLst=new list<PlanFacturacion__c>();
       
        PlanFacturacion__c objPlanFacturacion=objPruebas_tst.objPlanFacturacion();
        objPlanFacturacion.name='PLAN NEGOCIOS CONTROL S';
        objPlanFacturacion.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        objPlanFacturacion.Plan__c=plan.id;
        PlanFactLst.add(objPlanFacturacion);
        
        PlanFacturacion__c objPlanFactDeft=objPruebas_tst.objPlanFacturacion();
        objPlanFactDeft.Name='DEFAULT FACTURACION LTE';
        objPlanFactDeft.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        PlanFactLst.add(objPlanFactDeft);
        insert PlanFactLst;
        
        SubPlanFacturacion__c subPlan =objPruebas_tst.objSubPlanFacturacion();
        subPlan.Name='NUMERO SIM CARD';
        subPlan.PlanFacturacion__c=objPlanFactDeft.id;
        subPlan.codigo__c=subPlan.Name;
        insert subPlan;

        SubPlanFacturacion__c subPlanb =objPruebas_tst.objSubPlanFacturacion();
        subPlanb.Name='BOLSA ADIC DE DATOS 5GB';
        subPlanb.PlanFacturacion__c=objPlanFactDeft.id;
        subPlanb.codigo__c=subPlanb.Name;
        subPlanb.LTE_TipoSubplan__c='Bolsa de Datos a la medida';
        insert subPlanb;
        
        system.debug('por aca'+objPlanFacturacion.Id);
        
        list<ParametroFacturacion__c> paraMetros=new list<ParametroFacturacion__c>();
        paraMetros.add(new ParametroFacturacion__c (Name='RVC PLN',LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',CatalogoProductosFacturacion__c=objCatalogoProdFact.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='IMEI_del_Equipo__c',Name='IMEI',Objeto__c='OperacionComercial__c',PlanFacturacion__c=objPlanFacturacion.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='LTE_EsPortabilidad__c',Name='EsPortabilidad',Objeto__c='LTE_DetalleOferta__c',PlanFacturacion__c=objPlanFactDeft.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlan.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlanb.Id));
        insert paraMetros;
        
        TOPP__c topp= obj.objTopp();
        topp.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp.Facturable__c=true;
        insert topp;

        Equipo__c equipo=new Equipo__c(
            Descripcion__c='Info',
            LTE_Categoria__c='alta',LTE_Color__c='Morado',LTE_Gama__c='D',LTE_IVA__c=20,LTE_Marca__c='Lokia',
            LTE_MemoriaInternaROM_GB__c='1TB',LTE_ModeloComercial__c='Lok',LTE_OEM__c='Oem',
            LTE_PartNumber__c='38383838383',LTE_PrecioConIVA__c=1222,Name='LOKia',Tipo__c='ssss',
            Valor_del_Equipo__c=20,LTE_Activo__c=true
        );
        insert equipo;
        
        Reserva__c reserva=new Reserva__c(
            Equipo__c=equipo.Id,Estado__c='Pendiente',LTE_Plan__c=plan.Id,Oportunidad__c=oportunidad.Id,
            LTE_DatosNavegacion__c=subPlanb.id
        );
        insert reserva;
        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        servicio.Tipodeprogramacion__c='Troncal';
        insert servicio;
        variablesObj.put('ActivoETB',new list<ActivoETB__c>());
        variablesObj.get('ActivoETB').add(servicio);

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
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        leg.estado__c='Gestionado';
        insert leg;
        
        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.IDServicio__c='CAV1024234';
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=objCuentaFacturacion.id;
        oc.Estado__c=variablesTest.get('oc.Estado__c');
        oc.LTE_ICCID__c='490816320198746';
        oc.LTE_AplicaOnline__c=true;
        oc.LTE_IMSI__c='23244';
        oc.LTE_PIN__c='34343';
        oc.LTE_PUK__c='33434';
        insert oc;
        variablesObj.put('OperacionComercial',new list<OperacionComercial__c>());
        variablesObj.get('OperacionComercial').add(oc);
        
        LTE_DetalleOferta__c detOf=new LTE_DetalleOferta__c(
            LTE_Oferta_Economica__c=reserva.Id,
            LTE_OperacionComercial__c=oc.id,
            LTE_ReferenciaEquipo__c=equipo.id,
            Plan__c=plan.id,
            LTE_DatosNavegacion__c=subPlanb.Id);
        insert detOf;
        variablesObj.put('LTE_DetalleOferta',new list<LTE_DetalleOferta__c>());
        variablesObj.get('LTE_DetalleOferta').add(detOf);
        
        detOf.LTE_IMEI__c='490816320198746';
        detOf.LTE_ICCID__c='490816320198746';
        update detOf;


        LTE_Servicios_adicionales__c saAd=new LTE_Servicios_adicionales__c();
        saAd.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd.LTE_Estado__c='ADD';
        saAd.LTE_ItemIdentification__c=Catalogo.Id;
        saAd.LTE_SubPlaFacturacion__c=subPlanb.Id;
        insert saAd;
        variablesObj.put('LTE_Servicios_adicionales',new list<LTE_Servicios_adicionales__c>());
        variablesObj.get('LTE_Servicios_adicionales').add(saAd);

        
        if(variablesTest.get('esAprovisionamiento')=='si'){
            LTE_Servicios_adicionales__c saAd2=new LTE_Servicios_adicionales__c();
            saAd2.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
            saAd2.LTE_Estado__c='ADD';
            saAd2.LTE_ItemIdentification__c=Catalogo.Id;
            insert saAd2;
            
            
            list<LTE_SpecificationGroupXA__c> spGX=new list<LTE_SpecificationGroupXA__c>();
            spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[0].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
            spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[1].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
            spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[2].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
            spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[3].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
            spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[4].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
            
            insert spGX;
            
            variablesObj.get('LTE_Servicios_adicionales').add(saAd2);
            variablesObj.put('LTE_SpecificationGroupXA',new list<LTE_SpecificationGroupXA__c>());
            variablesObj.get('LTE_SpecificationGroupXA').addAll((list<sobject>)spGX);
        }
		List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
       	LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        
    }
    
}