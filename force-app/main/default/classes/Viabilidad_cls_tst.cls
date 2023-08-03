@isTest
public class Viabilidad_cls_tst {

    @IsTest
    static void testSendBellNotification(){

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        LTE_APN__c uvGlobal = new LTE_APN__c();
        uvGlobal.Name = 'EstadosViaAPN';
        uvGlobal.Valor__c = 'Cerrada';
        insert uvGlobal;
        
        Id clientePrincipalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();

        Account acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.recordTypeId = clientePrincipalRecordTypeId;
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3054658978';

        insert acc;

        Contact con = new Contact();
        con.LastName = 'contactoconconconcontest';
        con.AccountId = acc.Id;
        con.Phone = '12345678';
        con.MobilePhone = '3125689741';
        con.Estado__c = 'Activo';
        insert con;

        Id ofertaespecialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oferta Comercial').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.recordTypeId = ofertaespecialRecordTypeId;
        opp.Name = 'Test';
        opp.AccountId = acc.Id;
        opp.StageName = 'Propuesta de valor';
        opp.PDC__c = '80% - Probabilidad de Éxito';
        opp.Tipo_de_Operacion__c = 'Venta';
        opp.Amount = 100000;
        opp.ForecastCategoryName = 'En Construcción';
        opp.Valor_unica_vez_ETB__c = 12000;
        opp.CloseDate = Date.today()+5;

        insert opp;

        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;

        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
        insert objMunicipio;

        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = acc.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;

        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = acc.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;

        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = acc.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.LTE_DocumentoCC__c = 'sfdf.E12334';
        objLegalizacion.LTE_DocumentoAT__c = 'sdfdsf.E53242';
        objLegalizacion.LTE_DocumentoID__c = 'sdsf.E35436';
        insert objLegalizacion;

        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = acc.Id;
        insert objServicio;

        objPruebas_tst obj =new objPruebas_tst();

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        insert Catalogo;

        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.Name = 'testplannplanaplan';
        insert plan;

        Id ocSolTIRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta_SolucionesTI').getRecordTypeId();

        OperacionComercial__c oc = new OperacionComercial__c();
        oc.recordTypeId = ocSolTIRecordTypeId;
        oc.CuentaCliente__c = acc.Id;
        oc.Portacion__c = true;
        oc.CuentaFacturacion__c = objCtaFact.Id;
        oc.Estado__c = 'Pendiente';
        oc.NumeroConexion__c = '3057000501';
        oc.FechadeActivacion__c = system.today();
        oc.Legalizacion__c = objLegalizacion.Id;
        oc.Activo__c = objServicio.Id;
        oc.LTE_Donante__c='Código Operador virtual ETB-10007';
        oc.LTE_Tipo_de_Servicio__c = 'Pospago';
        oc.LTE_SolicitadoPorTercero__c = true;
        oc.Plan__c = plan.Id;
        insert oc;

        Id viaEspecificaRecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByName().get('Viabilidad Específica').getRecordTypeId();

        Viabilidad__c objViabilidad = new Viabilidad__c();
        objViabilidad.recordTypeId = viaEspecificaRecordTypeId;
        objViabilidad.EstadoViabilidad__c = 'Pendiente';
        objViabilidad.Respuestadeviabilidad__c = 'Viable';
        objViabilidad.Observaciones__c = 'viable';
        objViabilidad.OperacionComercial__c = oc.Id;
        insert objViabilidad;

        Oferta_Op__c oferta = new Oferta_Op__c();
        oferta.RecordTypeId = Schema.SObjectType.Oferta_Op__c.getRecordTypeInfosByName().get('Gestionado').getRecordTypeId();
        oferta.Nombre_de_la_cuenta__c = 'Donec risus';
        oferta.Oportunidad__c = opp.Id;
        oferta.Concepto__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
        oferta.Fecha_Presentacion_Oferta__c = Date.today();
        oferta.Estado_Oferta__c = 'En Proceso';

        insert oferta;

        Oferta_Op_Viabilidad__c ofopv = new Oferta_Op_Viabilidad__c();
        ofopv.Viabilidad__c = objViabilidad.Id;
        ofopv.Oferta_Op__c = oferta.Id;
        
        insert ofopv;
        
        ACO__c aco = new ACO__c();
        aco.RecordTypeId = Schema.SObjectType.ACO__c.getRecordTypeInfosByName().get('ACO').getRecordTypeId();
        aco.Actividad__c = 'Entrega Soportes por Preventa';
        aco.Estado_Actividad__c = 'Pendiente';
        aco.Nombre_de_la_Oportunidad__c = opp.Id;
        aco.Identificador_Oferta_OP__c = oferta.Id;
        aco.Nombre_del_Cliente__c = acc.Id;

        insert aco;

        Viabilidad__c via = [SELECT Id, EstadoViabilidad__c FROM Viabilidad__c LIMIT 1];
        
        Test.startTest();
        via.EstadoViabilidad__c = 'Cerrada';
        update via;
        Test.stopTest();

        Viabilidad__c result = [SELECT EstadoViabilidad__c FROM Viabilidad__c LIMIT 1];
        
        System.assertEquals('Cerrada', result.EstadoViabilidad__c, '[!] Los estados no coinciden');
    }

    @isTest 
    static void test_method_one() {

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        LTE_APN__c uvGlobal = new LTE_APN__c();
        uvGlobal.Name = 'EstadosViaAPN';
        uvGlobal.Valor__c = 'Cerrada';
        insert uvGlobal;
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
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;

    	Id recordTypeIdAliado = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Aliado').getRecordTypeId();

    	Account aliado=obj.ObjAccount();
    	aliado.RecordTypeId =recordTypeIdAliado;
    	System.debug(devRecordTypeId);
    	insert aliado;

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
        plan.Name = 'testplannplanaplan';
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
        oc.AliadoColaborador__c = aliado.Id;
        //oc.CompensacionDatos__c = objCompensacion.Id;
        insert oc;    	

        Viabilidad__c objViabilidad = new Viabilidad__c();
        objViabilidad.EstadoViabilidad__c = 'Cerrada';
        objViabilidad.Respuestadeviabilidad__c = 'Viable';
        objViabilidad.OperacionComercial__c = oc.Id;
        objViabilidad.Observaciones__c = 'viable';
        insert objViabilidad;
    	
    	test.startTest();
    	Profile p = [SELECT Id FROM Profile WHERE Name='Integraciones']; // JDUR 2016/01/08
		User u = new User(Alias = 'intusr', Email='intusr@testorg.com', 
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = p.Id, 
		TimeZoneSidKey='America/Los_Angeles', UserName='intusr@testorg.com');
		System.runAs(u) {
	        objViabilidad.Tipo_de_Aliado__c=Label.Colaborador;
	        update objViabilidad;
	
	        objViabilidad.Tipo_de_Aliado__c=Label.Proveedor;
	        update objViabilidad;
	
	        objViabilidad.Tipo_de_Aliado__c=Label.Distribuidor;
	        update objViabilidad;
		}
        test.stopTest();
		
	}
	
	@isTest 
    static void test_method_one2() {

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        LTE_APN__c uvGlobal = new LTE_APN__c();
        uvGlobal.Name = 'EstadosViaAPN';
        uvGlobal.Valor__c = 'Cerrada';
        insert uvGlobal;
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
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;

    	Id recordTypeIdAliado = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Aliado').getRecordTypeId();

    	Account aliado=obj.ObjAccount();
    	aliado.RecordTypeId =recordTypeIdAliado;
    	System.debug(devRecordTypeId);
    	insert aliado;

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
        plan.Name = 'testplannplanaplan';
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
        oc.AliadoColaborador__c = aliado.Id;
        //oc.CompensacionDatos__c = objCompensacion.Id;
        insert oc;    	

        APN__c objAPN = new APN__c();
        objAPN.Charguing_Characteristics__c = '100';
        objAPN.Cuenta_Cliente__c = cliente.Id;
        objAPN.Estado__c = 'Disponible';
        objAPN.Servicio__c = 'DATOS';
        objAPN.APN__c = 'empresas.etb.net.co';
        objAPN.Identificador_APN__c = '4';
        insert objAPN;

        Viabilidad__c objViabilidad = new Viabilidad__c();
        objViabilidad.EstadoViabilidad__c = 'Pendiente';
        objViabilidad.Respuestadeviabilidad__c = 'Viable';
        objViabilidad.OperacionComercial__c = oc.Id;
        objViabilidad.Observaciones__c = 'viable';
        objViabilidad.APN__c = objAPN.Id;
        insert objViabilidad;
    	
    	test.startTest();
    	Profile p = [SELECT Id FROM Profile WHERE Name='Integraciones']; // JDUR 2016/01/08
		User u = new User(Alias = 'intusr', Email='intusr@testorg.com', 
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = p.Id, 
		TimeZoneSidKey='America/Los_Angeles', UserName='intusr@testorg.com');
		System.runAs(u) {
            objViabilidad.EstadoViabilidad__c = 'Cerrada';
	        objViabilidad.Tipo_de_Aliado__c=Label.Colaborador;
	        objViabilidad.Tipo_de_Aliado__c=Label.Proveedor;
	        objViabilidad.Tipo_de_Aliado__c=Label.Distribuidor;
	        update objViabilidad;
		}
        test.stopTest();
		
	}

}