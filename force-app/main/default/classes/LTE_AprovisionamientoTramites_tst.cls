@isTest
private class LTE_AprovisionamientoTramites_tst {
  
    public static Map<string,string> variablesTest=new Map<string,string>();
    public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();

  static testMethod void aprovisionamientoTramites() {
    BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate'); 
      	BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');

        variablesTest.put('oc.Estado__c','Exitoso M6');
        crearData();
        
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','17');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseDescription','ENVIADO');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseAprovisionamiento());
        Test.startTest();
    	//String jobId = System.schedule('LTE_AprovisionamientoTramites_sch','0 0 0 * * ? *',new LTE_AprovisionamientoTramites_sch());
    	LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
      	batchA.idImediato = (new Map<Id,SObject>([SELECT Id FROM OperacionComercial__c])).keySet();
      	batchA.limitQ = true;
            
	 	ID batchprocessid = Database.executeBatch(batchA);
    	Test.stopTest();  
  }


    static testMethod void aprovisionamientoRespuesta() {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate'); 
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');

        variablesTest.put('oc.Estado__c','Enviado Aprovisionamiento');
        crearData();
        
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden estOrdent=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        estOrdent.EstadoOrden='COMPLETE';
        estOrdent.OrderId=variablesObj.get('OperacionComercial')[0].id;
        estOrdent.LineItems=new list<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        LTE_ServiciosAprovisionamiento_ws.LineItem LineItem=new LTE_ServiciosAprovisionamiento_ws.LineItem();
        LineItem.IdLineItem=variablesObj.get('LTE_Servicios_adicionales')[0].id;
        estOrdent.LineItems.add(LineItem);
        
        
        Test.startTest();
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(estOrdent);
        estOrdent.OrderId=variablesObj.get('OperacionComercial')[1].id;
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(estOrdent);
        estOrdent.OrderId=variablesObj.get('OperacionComercial')[2].id;
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(estOrdent);
        estOrdent.OrderId=variablesObj.get('OperacionComercial')[3].id;
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(estOrdent);
        estOrdent.OrderId=variablesObj.get('OperacionComercial')[4].id;
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(estOrdent);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(variablesObj.get('OperacionComercial')[0].id+'');


       
        Test.stopTest();
        
        
        
    }
    
  public static void crearConfiguracion(){
      List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
      
      list<sobject> vg=new list<sobject>();
      vg.add(new VariablesGlobales__c(Name='NombreDefaultaFacturacionLTE',Valor__c='DEFAULT FACTURACION LTE'));
      vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
      vg.add(new VariablesGlobales__c(Name='NombreFacturacionLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
      vg.add(new VariablesGlobales__c(Name='NombrePlanDefectorLTE',Valor__c='DEFAULT FACTURACION LTE'));
      vg.add(new VariablesGlobales__c(Name='aprovisionamientoOnline',Valor__c='3'));
      vg.add(new ServiciosWeb__c(Name='DisponibilidadM6',Action__c='/action',EndPoint__c='https://salesforce.com'));
      vg.add(new ServiciosWeb__c(Name='Aprovisionar',Action__c='/action',EndPoint__c='https://salesforce.com'));
      vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=UserInfo.getProfileId()));
      vg.add(new Perfiles_Acciones__c(Name='DataCreditoScore',Usuarios__c=Userinfo.getProfileId()));
      vg.add(new Perfiles_Acciones__c(Name='Adjuntos',Usuarios__c=Userinfo.getProfileId()));
      vg.add(new HomologacionCampos__c(Valor__c='NIT',Name='AprovNIT'));
      vg.add(new AprovisionamientoOnline__c(Name='Disponibilidad M6',LTE_Noche__c=3));
      vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento',LTE_Noche__c=3));
      vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento Tramites',LTE_Noche__c=3));
      vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
      vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));
      vg.add(new EjecucionIntegracion__c(Name='DisponibilidadM6',Ejecucion__c=true));
      vg.add(new EjecucionIntegracion__c(Name='Facturacion',Ejecucion__c=true));
      
      
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
      
      
      list<TOPP__c> toppLst=new list<TOPP__c>();      
      TOPP__c topp= obj.objTopp();
        topp.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp.Facturable__c=true;
        
      TOPP__c topp2= obj.objTopp();
        topp2.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp2.Facturable__c=true;
        topp2.TipodeOperacionporplan__c='Suspensión';
        
      TOPP__c topp3= obj.objTopp();
        topp3.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp3.Facturable__c=true;
        topp3.TipodeOperacionporplan__c='Reconexión';
        
      TOPP__c topp4= obj.objTopp();
        topp4.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp4.Facturable__c=true;
        topp4.TipodeOperacionporplan__c='Retiro';
        
      TOPP__c topp5= obj.objTopp();
        topp5.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp5.Facturable__c=true;
        topp5.TipodeOperacionporplan__c='Reposición';
        
      TOPP__c topp6= obj.objTopp();
        topp6.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp6.Facturable__c=true;
        topp6.TipodeOperacionporplan__c='Cambio Número';
        
      TOPP__c topp7= obj.objTopp();
        topp7.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp7.Facturable__c=true;
        topp7.TipodeOperacionporplan__c='Adición SVA';
        
      TOPP__c topp8= obj.objTopp();
        topp8.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp8.Facturable__c=true;
        topp8.TipodeOperacionporplan__c='Retiro SVA';
        
       TOPP__c topp9= obj.objTopp();
        topp9.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp9.Facturable__c=true;
        topp9.TipodeOperacionporplan__c='Suspensión'; 
        
        
        toppLst.add(topp);
        toppLst.add(topp2);
        toppLst.add(topp3);
        toppLst.add(topp4);
        toppLst.add(topp5);
        toppLst.add(topp6);
        toppLst.add(topp7);
        toppLst.add(topp8);
        toppLst.add(topp9);
        
        insert toppLst;

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
        
        ActivoETB__c servicio2 =obj.objServicio();
        servicio2.NombredelaCuenta__c=cliente.Id;
        servicio2.SucursalDestino__c=sucursal.id;
        servicio2.SucursalOrigen__c=sucursal.id;
        servicio2.Plan__c=plan.id;
        servicio2.NombredelProducto__c=Catalogo.Id;
        servicio2.Oportunidad__c=opt.id;
        servicio2.Tipodeprogramacion__c='Troncal';
        insert servicio2;
        
        
        ActivoETB__c servicio3 =obj.objServicio();
        servicio3.NombredelaCuenta__c=cliente.Id;
        servicio3.SucursalDestino__c=sucursal.id;
        servicio3.SucursalOrigen__c=sucursal.id;
        servicio3.Plan__c=plan.id;
        servicio3.NombredelProducto__c=Catalogo.Id;
        servicio3.Oportunidad__c=opt.id;
        servicio3.Tipodeprogramacion__c='Troncal';
        insert servicio3;
        
        
        ActivoETB__c servicio5 =obj.objServicio();
        servicio5.NombredelaCuenta__c=cliente.Id;
        servicio5.SucursalDestino__c=sucursal.id;
        servicio5.SucursalOrigen__c=sucursal.id;
        servicio5.Plan__c=plan.id;
        servicio5.NombredelProducto__c=Catalogo.Id;
        servicio5.Oportunidad__c=opt.id;
        servicio5.Tipodeprogramacion__c='Troncal';
        insert servicio5;
        
        ActivoETB__c servicio6 =obj.objServicio();
        servicio6.NombredelaCuenta__c=cliente.Id;
        servicio6.SucursalDestino__c=sucursal.id;
        servicio6.SucursalOrigen__c=sucursal.id;
        servicio6.Plan__c=plan.id;
        servicio6.NombredelProducto__c=Catalogo.Id;
        servicio6.Oportunidad__c=opt.id;
        servicio6.Tipodeprogramacion__c='Troncal';
        servicio6.LTE_Fecha_Alta_inicial__c = System.today();
        insert servicio6;
        
        
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

    list<OperacionComercial__c> ocLst=new list<OperacionComercial__c>();
    ocLst.add(oc);
        
        OperacionComercial__c oc2=oc.clone(false,false,false,false);
        oc2.TOPP__c=topp2.id;
        ocLst.add(oc2);
        OperacionComercial__c oc3=oc.clone(false,false,false,false);
        oc.TOPP__c=topp3.id;
        ocLst.add(oc3);
        OperacionComercial__c oc4=oc.clone(false,false,false,false);
        oc4.TOPP__c=topp4.id;
        ocLst.add(oc4);
        OperacionComercial__c oc5=oc.clone(false,false,false,false);
        oc5.TOPP__c=topp5.id;
        ocLst.add(oc5);
		OperacionComercial__c oc6=oc.clone(false,false,false,false);
        oc6.TOPP__c=topp6.id;
        oc6.Estado__c= 'Exitoso M6';
        oc6.NumeroConexion__c= '12345634';
        oc6.Activo__c = servicio2.id;
        ocLst.add(oc6);
        
        OperacionComercial__c oc7=oc.clone(false,false,false,false);
        oc7.TOPP__c=topp7.id;
        oc7.Estado__c= 'En Curso';
        oc7.Activo__c = servicio3.id;
        oc7.categoria__c = 'Bolsa Recurrente';
        oc7.FechaInicioReconexion__c = System.today();
        ocLst.add(oc7);
        
        
        
        OperacionComercial__c oc8=oc.clone(false,false,false,false);
        oc8.TOPP__c=topp8.id;
        oc8.Estado__c= 'En Curso';
        oc8.Activo__c = servicio3.id;
        oc8.FechaInicioReconexion__c = System.today();
        oc8.categoria__c = 'Bolsa Recurrente';
        ocLst.add(oc8);
        
        OperacionComercial__c oc9=oc.clone(false,false,false,false);
        oc9.TOPP__c=topp9.id;
        oc9.TipoSuspension__c = 'Voluntaria';
        oc9.Activo__c = servicio6.id;
        oc9.FechaInicioReconexion__c = System.today();
        ocLst.add(oc9);
        
        //// Se crea la oferta
        /* 
        
        Reserva__c objOferta = new Reserva__c();
		objOferta.Oportunidad__c = oportunidad.Id;
		objOferta.Estado__c = 'Pendiente';
		objOferta.Equipo__c = equipo.Id;
		objOferta.LTE_Plan__c = plan.Id;
        objOferta.LTE_MinutoVoz__c = subPlanb.Id;
        objOferta.LTE_DatosNavegacion__c = subPlanb.Id;
		insert  objOferta;
        
        LTE_DetalleOferta__c objDetalleOferta = new LTE_DetalleOferta__c();
		objDetalleOferta.LTE_OperacionComercial__c = oc8.Id;
		objDetalleOferta.LTE_Cliente__c = sucursal.Id;
		objDetalleOferta.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta.LTE_Estado__c = 'Pendiente';
		objDetalleOferta.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta.LTE_ReferenciaEquipo__c = equipo.Id;
		objDetalleOferta.LTE_IMEI__c = '980684862113805';
		objDetalleOferta.LTE_ICCID__c = '8957187113000000506';
		objDetalleOferta.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta.Plan__c = plan.Id;
        insert objDetalleOferta;
        */
        // FIN Se crea la oferta
    
    	insert ocLst;
        variablesObj.put('OperacionComercial',ocLst);

        
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

        
           LTE_Servicios_adicionales__c saAd2=new LTE_Servicios_adicionales__c();
          saAd2.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
          saAd2.LTE_Estado__c='ADD';
          saAd2.LTE_ItemIdentification__c=Catalogo.Id;
          insert saAd2;
          
        LTE_Servicios_adicionales__c saAd3 =new LTE_Servicios_adicionales__c();
        saAd3.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd3.LTE_Estado__c='ADD';
        saAd3.LTE_ItemIdentification__c=Catalogo.Id;
        saAd3.LTE_SubPlaFacturacion__c=subPlanb.Id;
        saAd3.LTE_ServicioETB__c = servicio3.id; 
        insert saAd3;
        
        
        LTE_Servicios_adicionales__c saAd4 =new LTE_Servicios_adicionales__c();
        saAd4.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd4.LTE_Estado__c='ADD';
        saAd4.LTE_ItemIdentification__c=Catalogo.Id;
        saAd4.LTE_SubPlaFacturacion__c=subPlanb.Id;
        saAd4.LTE_ServicioETB__c = servicio3.id; 
        saAd4.LTE_Operacion_Comercial_SVA__c = oc7.Id;
        insert saAd4;
        
        
        LTE_Servicios_adicionales__c saAd5 =new LTE_Servicios_adicionales__c();
        saAd5.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd5.LTE_Estado__c='ADD';
        saAd5.LTE_ItemIdentification__c=Catalogo.Id;
        saAd5.LTE_SubPlaFacturacion__c=subPlanb.Id;
        saAd5.LTE_ServicioETB__c = servicio5.id;
        saAd5.LTE_OC_Tramite__c = oc8.Id;
        insert saAd5;
        
        
        
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
        
		  List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
       	  LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');

      
    
    }
}