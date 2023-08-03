@isTest
private class PlanLD_tst {
    
      static testMethod void cupo(){

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

        Linea__c l=new Linea__c(Codigo_de_linea__c='12345678',Name='12345678',Operacion_Comercial_Anterior__c=oc.id);
        insert l;

        map<Id,OperacionComercial__c> mapOC=new map<Id,OperacionComercial__c>();
        mapOC.put(oc.id,oc);

        map<id,SObject> lineaMap=new map<id,SObject>();
        lineaMap.put(l.id,l);

        map<string,map<id,SObject>> objetosAdicionales=new map<string,map<id,SObject>>();
        objetosAdicionales.put('linea__c',lineaMap);
        objetosAdicionales.put('ServiciosActualizar',new map<id,SObject>());


        //Flujos Convenio de cupo
        PlanLargaDistanciaConveniodeCupo.VentaActiva plv=new PlanLargaDistanciaConveniodeCupo.VentaActiva();        plv.camposAdicionales=mapOC;
        plv.ocNew=mapOC;
        plv.ocOld=mapOC;
        plv.objetosAdicionales=objetosAdicionales;
        plv.procesar(mapOC.keySet());
        oc.Planes_Convenio_Cupo__c=null;
        l.Activo__c=servicio.id;
        plv.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeCupo.AdicionLineasdeLDActiva pla=new PlanLargaDistanciaConveniodeCupo.AdicionLineasdeLDActiva();
        pla.camposAdicionales=mapOC;
        pla.ocNew=mapOC;
        pla.ocOld=mapOC;
        pla.objetosAdicionales=objetosAdicionales;
        pla.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeCupo.RetiroActiva plr=new PlanLargaDistanciaConveniodeCupo.RetiroActiva();
        plr.camposAdicionales=mapOC;
        plr.ocNew=mapOC;
        plr.ocOld=mapOC;
        plr.objetosAdicionales=objetosAdicionales;
        plr.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeCupo.RetiroLineasdeLDActiva plrl=new PlanLargaDistanciaConveniodeCupo.RetiroLineasdeLDActiva();
        plrl.camposAdicionales=mapOC;
        plrl.ocNew=mapOC;
        plrl.ocOld=mapOC;
        plrl.objetosAdicionales=objetosAdicionales;
        plrl.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeCupo.CambiodePlanActiva plrc=new PlanLargaDistanciaConveniodeCupo.CambiodePlanActiva();
        plrc.camposAdicionales=mapOC;
        plrc.ocNew=mapOC;
        plrc.ocOld=mapOC;
        plrc.objetosAdicionales=objetosAdicionales;
        plrc.procesar(mapOC.keySet());

        //Flujos Convenio de voz
        PlanLargaDistanciaConveniodeVoz.VentaActiva plvv=new PlanLargaDistanciaConveniodeVoz.VentaActiva();
        plvv.camposAdicionales=mapOC;
        plvv.ocNew=mapOC;
        plvv.ocOld=mapOC;
        plvv.objetosAdicionales=objetosAdicionales;
        plvv.procesar(mapOC.keySet());
        oc.Planes_Convenio_Cupo__c=null;
        l.Activo__c=servicio.id;
        plvv.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeVoz.AdicionLineasdeLDActiva plav=new PlanLargaDistanciaConveniodeVoz.AdicionLineasdeLDActiva();
        plav.camposAdicionales=mapOC;
        plav.ocNew=mapOC;
        plav.ocOld=mapOC;
        plav.objetosAdicionales=objetosAdicionales;
        plav.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeVoz.RetiroActiva plrv=new PlanLargaDistanciaConveniodeVoz.RetiroActiva();
        plrv.camposAdicionales=mapOC;
        plrv.ocNew=mapOC;
        plrv.ocOld=mapOC;
        plrv.objetosAdicionales=objetosAdicionales;
        plrv.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeVoz.RetiroLineasdeLDActiva plrlv=new PlanLargaDistanciaConveniodeVoz.RetiroLineasdeLDActiva();
        plrlv.camposAdicionales=mapOC;
        plrlv.ocNew=mapOC;
        plrlv.ocOld=mapOC;
        plrlv.objetosAdicionales=objetosAdicionales;
        plrlv.procesar(mapOC.keySet());

        PlanLargaDistanciaConveniodeVoz.CambiodePlanActiva plrcv=new PlanLargaDistanciaConveniodeVoz.CambiodePlanActiva();
        plrcv.camposAdicionales=mapOC;
        plrcv.ocNew=mapOC;
        plrcv.ocOld=mapOC;
        plrcv.objetosAdicionales=objetosAdicionales;
        plrcv.procesar(mapOC.keySet());



      } 

}