/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Grupo 7 Checklist
Descripci�n:            Test Checklist para la aprobacion de la Legalización.
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci�n
------  ----------  --------------------        ---------------
1.0     06-11-2014  Hector Bayona (HB)      Creación de la clase
*******************************************************************************/
@isTest
private class Legalizacion_tst {
    
    static testMethod void Legalizacion2() {
        
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
        ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        
        
        objPruebas_tst obj =new objPruebas_tst();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        System.debug(devRecordTypeId);
        insert cliente;
        
        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        insert leg;
        
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
        
        CatalogoProductos__c objProducto = new CatalogoProductos__c();
        objProducto.Name = 'Backup Office 365';
        objProducto.Familia__c = 'Conectividad';
        objProducto.LineaNegocio__c = 'DATOS';        
        insert objProducto;
        
        Planes__c plan2 = new Planes__c();
        plan2.Name = 'Plan Backup Office 365';
        plan2.NombredelProducto__c=objProducto.id;
        insert plan2;
        
        CatalogoProductos__c objProducto2 = new CatalogoProductos__c();
        objProducto2.Name = 'SD-WAN';
        objProducto2.Familia__c = 'Conectividad';
        objProducto2.LineaNegocio__c = 'DATOS';        
        insert objProducto2;
        
        Planes__c plan3 = new Planes__c();
        plan3.Name = 'Plan SD-WAN';
        plan3.NombredelProducto__c=objProducto2.id;
        insert plan3;
        
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion; 
        
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
        oc.Legalizacion__c=leg.id;
        insert oc;
        /*------------------------------------------------*/
        
		TOPP__c topp2 = obj.objTopp();
        topp2.Plan__c=plan.id;
        topp2.TipodeOperacionporplan__c = 'Conversión Demo a Venta';
        insert topp2;
        
        TOPP__c topp3 = obj.objTopp();
        topp3.Plan__c=plan2.id;
        topp3.TipodeOperacionporplan__c = 'Venta';
        insert topp3;
        
        TOPP__c topp4 = obj.objTopp();
        topp4.Plan__c=plan3.id;
        topp4.TipodeOperacionporplan__c = 'Venta';
        insert topp4;
                    
        OperacionComercial__c oc4 =obj.objOc();
        oc4.CuentaCliente__c=cliente.id;
        oc4.Activo__c=servicio.id;
        oc4.Plan__c=plan3.id;
        oc4.SucursalDestino__c=sucursal.id;
        oc4.SucursalOrigen__c=sucursal.id;
        oc4.Oportunidad__c=opt.id;
        oc4.RecordTypeId=ocRecordTypeId;
        oc4.TOPP__c=topp4.id;
        oc4.Legalizacion__c=leg.id;        
        oc4.Estado__c = 'Pendiente';
        oc4.Demo__c=true;
        insert oc4;
        
        OperacionComercial__c oc2 =obj.objOc();
        oc2.CuentaCliente__c=cliente.id;
        oc2.Activo__c=servicio.id;
        oc2.Plan__c=plan.id;
        oc2.SucursalDestino__c=sucursal.id;
        oc2.SucursalOrigen__c=sucursal.id;
        oc2.Oportunidad__c=opt.id;
        oc2.RecordTypeId=ocRecordTypeId;
        oc2.TOPP__c=topp2.id;
        oc2.Legalizacion__c=leg.id;
        oc2.Estado__c = 'Pendiente';
        oc2.Operacion_Comercial_Relacionada__c = oc4.Id;
        insert oc2;
        
        OperacionComercial__c oc3 =obj.objOc();
        oc3.CuentaCliente__c=cliente.id;
        oc3.Activo__c=servicio.id;
        oc3.Plan__c=plan2.id;
        oc3.SucursalDestino__c=sucursal.id;
        oc3.SucursalOrigen__c=sucursal.id;
        oc3.Oportunidad__c=opt.id;
        oc3.RecordTypeId=ocRecordTypeId;
        oc3.TOPP__c=topp3.id;
        oc3.Legalizacion__c=leg.id;
        oc3.Adquisicion_con_ETB_tercero__c = 'ETB';
        oc3.OP_comercial_relacionada_office_365__c = oc2.Id;
        oc3.Estado__c = 'Pendiente';
        insert oc3;
        /*------------------------------------------------*/
        opt.StageName = 'Cerrada ganada';
        update opt;
        
        test.startTest();
        oc.Duracion_Meses__c=24;
        Profile p = [SELECT Id FROM Profile WHERE Name='Integraciones']; // JDUR 2016/01/08
        User u = new User(Alias = 'intusr', Email='intusr@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='intusr@testorg.com');
        System.runAs(u) {
            //	update oc;
        }
        
        
        leg.Contrato__c=null;
        update leg;
        
        BanderasEjecucion.unsetEjecucion('DesenCadenaLegalizacion');
        leg.Contrato__c=contrato.id;
        leg.Estado__c='Gestionado';
        update leg;
        test.stopTest();
        
        
    }
    
    
    static testMethod void Legalizacion() {
        
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        
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
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        insert leg;
        
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
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion; 
        
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
        oc.Legalizacion__c=leg.id;
        insert oc;
        
        
        
        test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Integraciones']; // JDUR 2016/01/08
        User u = new User(Alias = 'intusr', Email='intusr@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='intusr@testorg.com');
        System.runAs(u) {
            
            Perfiles_Acciones__c vGlobal1 = new Perfiles_Acciones__c();
            vGlobal1.Name = 'ValidacionesLegalizacion';
            vGlobal1.Usuarios__c = String.valueof(u.Id);
            insert vGlobal1;
            oc.Duracion_Meses__c=24;
            //update oc;
            
            oc.Legalizacion__c=null;
            //update oc;
        }
        
        leg.Contrato__c=null;
        update leg;
        
        leg.Contrato__c=contrato.id;
        update leg;
        test.stopTest();
        
        
    }
    
    static testMethod void Legalizacion3() {
        
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
        ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        
        
        objPruebas_tst obj =new objPruebas_tst();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        
        Perfiles_Acciones__c vGlobal1 = new Perfiles_Acciones__c();
        vGlobal1.Name = 'ValidacionesLegalizacion';
        vGlobal1.Usuarios__c = '00e400000013ynYAAQ';
        insert vGlobal1;
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        System.debug(devRecordTypeId);
        insert cliente;
        
        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        insert leg;
        
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
        
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion; 
        
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
        oc.Legalizacion__c=leg.id;
        oc.Portacion__c = true;
        insert oc;        
        test.startTest();        
        Legalizacion_cls.creaLote(leg,new list<OperacionComercial__c> {oc});
        test.stopTest();     
    }
    
    static testMethod void Legalizacion4() {
        
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
        ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        
        
        objPruebas_tst obj =new objPruebas_tst();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        
        Perfiles_Acciones__c vGlobal1 = new Perfiles_Acciones__c();
        vGlobal1.Name = 'ValidacionesLegalizacion';
        vGlobal1.Usuarios__c = '00e400000013ynYAAQ';
        insert vGlobal1;
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        System.debug(devRecordTypeId);
        insert cliente;
        
        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        insert leg;
        
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
        
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion; 
        
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
        oc.Legalizacion__c=leg.id;
        oc.Portacion__c = true;
        insert oc;
        
        
        
        test.startTest();
        
        Legalizacion_cls.creaLote(leg,new list<OperacionComercial__c> {oc});
        test.stopTest();
        
        
    }
}