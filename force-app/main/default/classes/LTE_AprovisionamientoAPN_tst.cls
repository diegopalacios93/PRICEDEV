@isTest
public class LTE_AprovisionamientoAPN_tst {

    static testMethod void AprovisionamientoAPN() {

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        //variablesTest.put('oc.Estado__c','Exitoso M6');
        //variablesTest.put('esAprovisionamiento','si');  


        crearConfiguracionGral();
        CreateData();
        crearConfiguracion();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','1');
        LTE_AprovisionamientoAPN_bch b = new LTE_AprovisionamientoAPN_bch();
        b.esVIP = true;

        List<OperacionComercial__c> ocList = [SELECT Id FROM OperacionComercial__c];
        
        Set<Id> idSet = new Set<Id>();
        for(OperacionComercial__c oc : ocList){
            idSet.add(oc.Id);
        }
        b.idImediato = idSet;
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseAprovisionamientoAPN());
        Test.startTest();
        String jobId = System.schedule('LTE_AprovisionamientoAPN_sch','0 0 0 * * ? *',new LTE_AprovisionamientoAPN_sch());
        Test.stopTest();
    }

    static testMethod void AprovisionamientoAPN_testBatch_WithVIPandAplicaOnline() {

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');


        crearConfiguracionGral();
        CreateData();
        crearConfiguracion();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TIBCOResponseCode','1');
       
        List<OperacionComercial__c> ocList = [SELECT Id, TOPP__r.Name, Aplica_APN__c FROM OperacionComercial__c WHERE TOPP__r.Name = 'Gestion APN/IP- TELEFONIA MOVIL (LTE)'];
        
        Set<Id> idSet = new Set<Id>();
        for(OperacionComercial__c oc : ocList){
            idSet.add(oc.Id);
            oc.Aplica_APN__c=true;
            oc.LTE_AplicaOnline__c=true;
        }
        update ocList;
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseAprovisionamientoAPN());
        Test.startTest();
        LTE_AprovisionamientoAPN_bch b = new LTE_AprovisionamientoAPN_bch();
        b.esVIP = true;
        b.idImediato = idSet;
        Database.executeBatch(b);
        Test.stopTest();
    }

    public static testMethod void MockTest() {

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        //variablesTest.put('oc.Estado__c','Exitoso M6');
        //variablesTest.put('esAprovisionamiento','si');
        crearConfiguracionGral();
        Test.startTest();
        LTE_MockServiciosWebLTE_cls.MockHttpResponseCrearCtasFactHijas clsCrearCtasFactHijas = new LTE_MockServiciosWebLTE_cls.MockHttpResponseCrearCtasFactHijas();
        clsCrearCtasFactHijas.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact clsActualizarCtasFact = new LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact();
        clsActualizarCtasFact.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseRemedy clsRemedy = new LTE_MockServiciosWebLTE_cls.MockHttpResponseRemedy();
        clsRemedy.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponsePlib clsPlib = new LTE_MockServiciosWebLTE_cls.MockHttpResponsePlib();
        clsPlib.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseDisponibilidad clsDisponibilidad = new LTE_MockServiciosWebLTE_cls.MockHttpResponseDisponibilidad();
        clsDisponibilidad.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain clsRevChain = new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain();
        clsRevChain.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseFormateador clsFormateador = new LTE_MockServiciosWebLTE_cls.MockHttpResponseFormateador();
        clsFormateador.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda clsConsultaSuspenda = new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda();
        clsConsultaSuspenda.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseRegistroSuspenda clsRegistroSuspenda = new LTE_MockServiciosWebLTE_cls.MockHttpResponseRegistroSuspenda();
        clsRegistroSuspenda.respond(new HTTPRequest());
        LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaIMEI clsConsultaIMEI = new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaIMEI();
        clsConsultaIMEI.respond(new HTTPRequest());
        Test.stopTest();
    }
    
    public static void crearConfiguracionGral(){
        list<sobject> vg=new list<sobject>();
        vg.add(new ServiciosWeb__c(Name='AprovisionarAPN',Action__c='/action/AprovisionarAPN',EndPoint__c='https://salesforce.com/AprovisionarAPN'));
        vg.add(new ServiciosWeb__c(Name='CreacionCuentasFact',Action__c='/action/CreacionCuentasFact',EndPoint__c='https://salesforce.com/CreacionCuentasFact'));
        vg.add(new ServiciosWeb__c(Name='RevChain',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='Formateador',Action__c='/action/Formateador',EndPoint__c='https://salesforce.com/Formateador'));
        vg.add(new ServiciosWeb__c(Name='SuspendaConsulta',Action__c='/action/SuspendaConsulta',EndPoint__c='https://salesforce.com/SuspendaConsulta'));
        vg.add(new ServiciosWeb__c(Name='SuspendaRegistro',Action__c='/action/SuspendaRegistro',EndPoint__c='https://salesforce.com/SuspendaRegistro'));
        vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='DisponibilidadM6',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='Facturacion',Ejecucion__c=true));
        insert vg;
    }
    public static void crearConfiguracion(){
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        
        list<sobject> vg=new list<sobject>();
        vg.add(new ServiciosWeb__c(Name='AprovisionarAPN',Action__c='/action',EndPoint__c='https://salesforce.com'));
        vg.add(new AprovisionamientoOnline__c(Name='AprovisionamientoAPN',LTE_Noche__c=30));
        vg.add(new LTE_APN__c(Valor__c='4',Name='Adicion DATOS',Tipo__c='Variable'));
        vg.add(new LTE_APN__c(Valor__c='3',Name='Adicion INTERNET',Tipo__c='Variable'));
        vg.add(new LTE_APN__c(Valor__c='2',Name='Retiro',Tipo__c='Variable'));
        vg.add(new LTE_APN__c(Valor__c='NORMAL',Name='DefaultCharge',Tipo__c='Variable'));
        vg.add(new LTE_APN__c(Valor__c='DYNAMIC',Name='Homo-DINAMICO',Tipo__c='Variable'));
        vg.add(new LTE_APN__c(Valor__c='STATIC',Name='Homo-ESTÁTICO',Tipo__c='Variable'));
        
        insert vg;
    
    }
    
	public static void CreateData(){
		
		List<VariablesGlobales__c> lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialAPN';
        vGlobal.Valor__c = 'APN CORPORATIVO';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;
        
    	List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        insert lstLTEAPN;
		
		List<Perfiles_Reglas_OC__c> lstPerfilesReglasOC = new List<Perfiles_Reglas_OC__c>();
        Perfiles_Reglas_OC__c vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario01';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zweAAA';
        vPerfil.Detalles__c = 'si la operación comercial no aplica para preventa y no tiene legalización';
        lstPerfilesReglasOC.add(vPerfil);
		vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario08';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zwYAAQ,00e400000014I5jAAE,00e400000013zwcAAA,00e40000001FZVvAAO,00e400000013zweAAA';
        vPerfil.Detalles__c = 'en estado activa o declinada';
        lstPerfilesReglasOC.add(vPerfil);
        insert lstPerfilesReglasOC;

		Account objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456'; 
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';   
		objAccount.Phone = '13002200';   
		insert objAccount;

		Contract objContrato = new Contract();
		objContrato.Name = 'Test name contrato';
		objContrato.AccountId = objAccount.Id;
		objContrato.Status = 'Borrador';
		insert objContrato;

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

		CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
		objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
		objCtaFact.Cliente__c = objAccount.Id;
		objCtaFact.Facturable__c = true;
		objCtaFact.LTE_MetodoEnvio__c = 'Email';
		objCtaFact.LTE_CicloFacturacion__c = '5';
		objCtaFact.LTE_Email__c = 'test@test.com';
		objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
		objCtaFact.Ciudad__c = objMunicipio.Id;
		objCtaFact.LTE_CuentaFacturacionLTE__c = true;
		objCtaFact.Fue_creada_en_revchain__c = true;
		objCtaFact.DirCorresp__c = 'Test DirCorresp';
		insert objCtaFact;

		Contact objContact = new Contact(IsTEST__c = true);
		objContact.FirstName = 'Andres';
		objContact.LastName = 'Lopez';
		objContact.AccountId = objAccount.Id;
		objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
		objContact.NumerodeIdentificacion__c = '345678904';
		objContact.Estado__c = 'Activo';
		objContact.Cargo__c = 'Ingeniero';
		objContact.Area__c = 'Dpto. Financiero';
		objContact.Rol__c = 'Administrativo';
		objContact.LTE_RolLTE__c = 'Total-';
		objContact.Genero__c = 'Masculino';
		objContact.Direccion__c = 'Calle 12 # 34 - 53';
		objContact.Phone = '32432432';
		objContact.MobilePhone = '3105667655';
		objContact.Email = 'scampos@avanxo.com';
		objContact.Ciudad__c = objMunicipio.Id;
		insert objContact;
		
		APN__c objAPN = new APN__c();
		objAPN.Charguing_Characteristics__c = '100';
		objAPN.Cuenta_Cliente__c = objAccount.Id;
		objAPN.Estado__c = 'Disponible';
		objAPN.Servicio__c = 'DATOS';
		objAPN.APN__c = 'empresas.etb.net.co';
		objAPN.Identificador_APN__c = '4';
		insert objAPN;
		
        POOL_APN__c tPool = new POOL_APN__c();
        tPool.Pooles__c = '170.0.0.1/Test';
        tPool.Niveles__c = 'BASICO';
        tPool.Producto__c = 'DATOS';
        tPool.Direccionamiento__c = 'ESTÁTICO';
        tPool.Estado__c = 'Disponible';
        tPool.IP_Inicial__c = '170.0.0.2';
        tPool.IP_Final__c = '170.0.0.3';
        tPool.APN__c = objAPN.Id;
        insert tPool;
		
        List<IP__c> lstIP = new List<IP__c>();
        Integer iEquipo = 0;
        while(iEquipo<10){
            IP__c objIP = new IP__c();
            objIP.Name = '170.0.0.'+String.valueOf(iEquipo);
            objIP.Estado__c = 'Disponible';
            objIP.POOL_de_APN__c = tPool.Id;
            objIP.APN__c = objAPN.Id;
            lstIP.add(objIP);
            iEquipo++;
        }
        insert lstIP;
		
		List<SubPlanFacturacion__c> lstSbPlan = new List<SubPlanFacturacion__c>();
        SubPlanFacturacion__c tSbPlan = new SubPlanFacturacion__c();
        tSbPlan.Name = 'SVA APN RECURRENTE';
        tSbPlan.Codigo__c = 'SVA APN RECURRENTE';
		lstSbPlan.add(tSbPlan);
		tSbPlan = new SubPlanFacturacion__c();
        tSbPlan.Name = 'SVA APN NO RECURRENTE';
        tSbPlan.Codigo__c = 'SVA APN NO RECURRENTE';
		lstSbPlan.add(tSbPlan);
        insert lstSbPlan;
		
        Equipo__c tEq = new Equipo__c();
        tEq.Name = 'SAMSUNG Galaxy Test';
        tEq.LTE_PartNumber__c = 'ETB-Test';
        tEq.Tipo__c = 'Equipo';
        tEq.Valor_del_Equipo__c = 100;
        tEq.LTE_Activo__c = True;
        insert tEq;

		Opportunity objOportunidad = new Opportunity();
		objOportunidad.Name = 'Test name';
		objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
		objOportunidad.AccountId = objAccount.Id;
		objOportunidad.StageName = 'Análisis de necesidades';
		objOportunidad.CloseDate = system.today();
		objOportunidad.Amount = 1000;
		objOportunidad.Valor_unica_vez_ETB__c = 150;
		objOportunidad.LTE_Scoring__c = 9000000;
		objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
		objOportunidad.LTE_NumeroLinea__c = 2;
		insert objOportunidad;
		
		Legalizacion__c objLegalizacion = new Legalizacion__c();
		objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
		objLegalizacion.Contrato__c = objContrato.Id;
		objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
		objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
		objLegalizacion.LTE_FechaGestion__c = system.today();
		objLegalizacion.Estado__c = 'Gestionado';
		objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
		objLegalizacion.Cuotas__c = 2;
		insert objLegalizacion;

		CatalogoProductos__c objProducto = new CatalogoProductos__c();
		objProducto.Name = 'TELEFONIA MOVIL (LTE)';
		objProducto.Familia__c = 'LTE';
		objProducto.LineaNegocio__c = 'Redes Móviles';
		objProducto.CodigoProducto__c = '7635736';
		objProducto.Estado__c = 'Activo';
		objProducto.Descripcion__c = 'Teste';
		objProducto.AtributosEstandar__c = 'Teste';
		insert objProducto;

		CatalogoProductos__c objProducto2 = new CatalogoProductos__c();
		objProducto2.Name = 'APN CORPORATIVO';
		objProducto2.Familia__c = 'LTE';
		objProducto2.LineaNegocio__c = 'Redes Móviles';
		objProducto2.CodigoProducto__c = '222222';
		objProducto2.Estado__c = 'Activo';
		objProducto2.Descripcion__c = 'APN Moviles Test';
		objProducto2.AtributosEstandar__c = 'APN Moviles Teste';
		insert objProducto2;
		
		Planes__c objPlan = new Planes__c ();
		objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Principal';
		objPlan.Tarifa__c = 96000;
		objPlan.Estado__c = 'Activo';
		objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
		objPlan.LTE_PlanEstructurados__c = true;
		objPlan.LTE_TipoControl__c = 'Control';
		insert objPlan;

		Planes__c objPlan2 = new Planes__c ();
		objPlan2.Name = 'APN PARA SERVICIOS DE DATOS';
		objPlan2.NombredelProducto__c = objProducto2.Id;
		objPlan2.TipodePlan__c = 'Principal';
		objPlan2.Tarifa__c = 0;
		objPlan2.Estado__c = 'Activo';
		objPlan2.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
		objPlan2.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
		objPlan2.LTE_PlanEstructurados__c = false;
		insert objPlan2;
		
		TOPP__c objTOPP = new TOPP__c();
		objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
		objTOPP.TipodeOperacionporplan__c = 'Venta';
		objTOPP.Tipoderegistro__c = 'Venta_LTE';
        objTOPP.AplicaPreventa__c=true;
		objTOPP.DisponibleVentainicial__c = true;
		objTOPP.Facturable__c = true;
		objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
		insert objTOPP;

        TOPP__c objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Venta- APN PARA SERVICIOS DE DATOS';
        objTOPP2.TipodeOperacionporplan__c = 'Venta';
        objTOPP2.Tipoderegistro__c = 'VentaAPN';
        objTOPP2.AplicaPreventa__c=true;
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = false;
		objTOPP2.Plan__c = objPlan2.Id;
        insert objTOPP2;

        TOPP__c objTOPP3 = new TOPP__c();
		objTOPP3.Name = 'Gestion APN/IP- TELEFONIA MOVIL (LTE)';
		objTOPP3.TipodeOperacionporplan__c = 'Gestion APN/IP';
		objTOPP3.Tipoderegistro__c = 'Venta_LTE';
        objTOPP3.AplicaPreventa__c=true;
		objTOPP3.DisponibleVentainicial__c = true;
		objTOPP3.Facturable__c = true;
		objTOPP3.LTE_Catalogo_de_Producto__c = objProducto.Id;
		insert objTOPP3;
		
		ActivoETB__c objServicio = new ActivoETB__c();
		objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        objServicio.IP__c = lstIP[0].Id; 
        insert objServicio;
		
		ActivoETB__c objServicio2 = new ActivoETB__c();
		objServicio2.Oportunidad__c = objOportunidad.Id;
        objServicio2.NombredelaCuenta__c = objAccount.Id;
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
		objServicio2.APN__c = objAPN.Id;
		objServicio2.Tipo_de_APN__c = 'Datos';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;

        ActivoETB__c objServicio3 = new ActivoETB__c();
		objServicio3.Oportunidad__c = objOportunidad.Id;
        objServicio3.NombredelaCuenta__c = objAccount.Id;
        objServicio3.Plan__c = objPlan.Id;
        objServicio3.Estado__c = 'Activo';
        objServicio3.IMEI_del_Equipo__c = '980684862113805';
        objServicio3.LTE_ICCID__c = '8957187113000000506';
        objServicio3.NumeroConexion__c = '3057000501';
        objServicio3.Fecha_Activacion__c = system.now();
        objServicio3.IP__c = lstIP[9].Id;
        objServicio3.APN__c = objAPN.Id;
        objServicio3.POOL_de_APN__c = tPool.Id;
        insert objServicio3;
		
		Case objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        //objCaso.AccountNumber__c = objAccount.AccountNumber;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan2.Id;
        objCaso.Status = 'Abierto';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
		insert objCaso;
		
        List<OperacionComercial__c> lstjOpComercial = new List<OperacionComercial__c>();
        OperacionComercial__c objOpComercial;
        Integer iOpComercial = 0;
        while(iOpComercial<10){
            objOpComercial = new OperacionComercial__c();
            objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Gestion APN/IP').getRecordTypeId();
            objOpComercial.CuentaCliente__c = objAccount.Id;
            objOpComercial.Activo__c = objServicio.Id;
            objOpComercial.Plan__c = objPlan.Id;
            objOpComercial.TOPP__c = objTOPP.Id;
            objOpComercial.caso__c = objCaso.Id;
            //objOpComercial.Oportunidad__c = objOportunidad.Id;
            objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
            objOpComercial.Estado__c = 'Pendiente';
            objOpComercial.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
            objOpComercial.FechadeActivacion__c = system.today();
            objOpComercial.Legalizacion__c = objLegalizacion.Id;
            objOpComercial.Tipo_Operacion_APN__c = 'Adicion';
            if(iOpComercial==1){
            	objOpComercial.Aplica_APN__c=true;
            }
            objOpComercial.Estado_APN__c = 'Pendiente';
            objOpComercial.APN__c = objAPN.Id;
            objOpComercial.POOL_de_APN__c = tPool.Id;
            objOpComercial.IP__c = lstIP[0].Id;        
            lstjOpComercial.add(objOpComercial);
            iOpComercial++;
        }

        objOpComercial = new OperacionComercial__c();
            objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Gestion APN/IP').getRecordTypeId();
            objOpComercial.CuentaCliente__c = objAccount.Id;
            objOpComercial.Activo__c = objServicio3.Id;
            objOpComercial.Plan__c = objPlan.Id;
            objOpComercial.TOPP__c = objTOPP3.Id;
            objOpComercial.caso__c = objCaso.Id;
            //objOpComercial.Oportunidad__c = objOportunidad.Id;
            objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
            objOpComercial.Estado__c = 'Pendiente';
            objOpComercial.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
            objOpComercial.FechadeActivacion__c = system.today();
            objOpComercial.Legalizacion__c = objLegalizacion.Id;
            objOpComercial.Tipo_Operacion_APN__c = 'Retiro';
            //objOpComercial.Aplica_APN__c=true;
            objOpComercial.Estado_APN__c = 'Pendiente';
        lstjOpComercial.add(objOpComercial);

		insert lstjOpComercial;
        
        Reserva__c objReserva = new Reserva__c();
        objReserva.Equipo__c = tEq.Id;
        insert objReserva;
        
        iOpComercial = 0;
        List<LTE_DetalleOferta__c> lstDetalleOferta = new List<LTE_DetalleOferta__c>();
        LTE_DetalleOferta__c ObjDetalleOferta;
        while(iOpComercial<10){
            ObjDetalleOferta = new LTE_DetalleOferta__c();
            ObjDetalleOferta.LTE_OperacionComercial__c = objOpComercial.Id;
            ObjDetalleOferta.LTE_Oferta_Economica__c = objReserva.Id;
            lstDetalleOferta.add(ObjDetalleOferta);
            iOpComercial++;
        }
        insert lstDetalleOferta;
		
		OperacionComercial__c objOpComercial2 = new OperacionComercial__c();
        objOpComercial2.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Gestion APN/IP').getRecordTypeId();
		objOpComercial2.CuentaCliente__c = objAccount.Id;
		objOpComercial2.Activo__c = objServicio2.Id;
		objOpComercial2.Plan__c = objPlan2.Id;
		objOpComercial2.TOPP__c = objTOPP2.Id;
		objOpComercial.caso__c = objCaso.Id;
            //objOpComercial2.Oportunidad__c = objOportunidad.Id;
		objOpComercial2.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial2.Estado__c = 'En Curso';
		objOpComercial2.NumeroConexion__c = '3057000501';
		objOpComercial2.FechadeActivacion__c = system.today();
        objOpComercial2.Tipo_de_APN__c = 'Datos';
        objOpComercial2.Tipo_de_Plan_APN__c = 'APN Datos UM Principal (Sede Fija)';
		objOpComercial2.Legalizacion__c = objLegalizacion.Id;
		insert objOpComercial2;
        
        Viabilidad__c objViabilidad = new Viabilidad__c();
        //objViabilidad.OperacionComercial__c = objOpComercial2.Id;
        objViabilidad.EstadoViabilidad__c = 'Pendiente';
        insert objViabilidad;
    }
}