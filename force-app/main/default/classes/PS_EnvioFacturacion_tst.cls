/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              John Guevara
Proyecto:           Portafolio Superior
Descripción:        Clase de prueba para el controlador PS_EnvioFacturacion_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2020-09-28      John Guevara (JOHNGUE2)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public class PS_EnvioFacturacion_tst {

    public static void CreateData(){
        list<sobject> vg = new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Facturacion PS',Mensaje__c='Id,Name,Plan__c,CuentaFacturacion__c'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Facturacion Lineas PS',Mensaje__c='Id,Name,Operacion_Comercial__r.Plan__c,Operacion_Comercial__r.CuentaFacturacion__c'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Facturacion_Venta',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='InvocacionServiceProvisioning',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        insert vg;

		Account objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456'; 
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';   
        objAccount.Phone = '3132541414';   
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
		//[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
		objCtaFact.DirCorresp__c = 'Direccion test';
		objCtaFact.Ciudad__c = objMunicipio.Id;
		objCtaFact.LTE_CuentaFacturacionLTE__c = false;
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
		objContact.LTE_RolLTE__c = 'Total';
		objContact.Genero__c = 'Masculino';
		objContact.Direccion__c = 'Calle 12 # 34 - 53';
		objContact.Phone = '12345678';
		objContact.MobilePhone = '3105667655';
		objContact.Email = 'scampos@avanxo.com';
		objContact.Ciudad__c = objMunicipio.Id;
		insert objContact;

		Opportunity objOportunidad = new Opportunity();
		objOportunidad.Name = 'Test name';
		objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oferta Comercial').getRecordTypeId();
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
		objProducto.Name = 'Enlaces de Voz E1';
		objProducto.Familia__c = 'ENLACES DE VOZ';
		objProducto.LineaNegocio__c = 'LOCAL';
		objProducto.CodigoProducto__c = 'EnlacesdeVozE1001';
		objProducto.Estado__c = 'Activo';
		objProducto.Descripcion__c = 'Teste';
		objProducto.AtributosEstandar__c = 'Teste';
		insert objProducto;
        
        CatalogoProductosFacturacion__c objProductoFacturacion = new CatalogoProductosFacturacion__c();
        objProductoFacturacion.Name = 'Cargo Fijo E1 RDSI';
        objProductoFacturacion.CatalogoProductos__c = objProducto.Id;
        objProductoFacturacion.ConnectionID__c = 'Test';
        objProductoFacturacion.ConnectionTypeID__c = 'Test';
        objProductoFacturacion.Servicio__c = 'E1 Enlace Voz';
        objProductoFacturacion.Codigo__c = 0;
        insert objProductoFacturacion;

		Planes__c objPlan = new Planes__c ();
		objPlan.Name = 'Plan Básico Enlaces  E1';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Principal';
		objPlan.Tarifa__c = 96000;
		objPlan.Estado__c = 'Activo';
		insert objPlan;
		
		PlanFacturacion__c objPlanFacturacion = new PlanFacturacion__c();
		objPlanFacturacion.CatalogoProductosFacturacion__c = objProductoFacturacion.Id;
		objPlanFacturacion.Plan__c = objPlan.Id;
		objPlanFacturacion.Name = 'Local Cargo Fijo E1 Enlace Voz';
		insert objPlanFacturacion;

		TOPP__c objTOPP = new TOPP__c();
		objTOPP.Name = 'Venta- Plan Básico Enlaces E1';
		objTOPP.TipodeOperacionporplan__c = 'Venta';
		objTOPP.Tipoderegistro__c = 'Venta_Enlaces_de_Voz';
        objTOPP.Plan__c = objPlan.Id;
		objTOPP.DisponibleVentainicial__c = true;
		objTOPP.Facturable__c = true;
        objTOPP.AplicaFacturacion__c = true;
		insert objTOPP;

		ActivoETB__c objServicio = new ActivoETB__c();
		objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Pendiente';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;
        
		OperacionComercial__c objOpComercial = new OperacionComercial__c();
		objOpComercial.CuentaCliente__c = objAccount.Id;
		objOpComercial.Activo__c = objServicio.Id;
		objOpComercial.Plan__c = objPlan.Id;
		objOpComercial.TOPP__c = objTOPP.Id;
		objOpComercial.Oportunidad__c = objOportunidad.Id;
		objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial.Estado__c = 'Activa';
		objOpComercial.NumeroConexion__c = '3057000501';
		objOpComercial.FechadeActivacion__c = system.today();
		objOpComercial.Legalizacion__c = objLegalizacion.Id;
        objOpComercial.EnvioFacturacion__c = true;
		insert objOpComercial;
        
        Linea__c objLinea = new Linea__c();
        objLinea.Name = '3057000501';
        objLinea.Codigo_de_linea__c = '3057000501';
        objLinea.OperacionComercialTramite__c = objOpComercial.Id;
        insert objLinea;
        
        Lineas_OC__c objLineaOC = new Lineas_OC__c();
        objLineaOC.Operacion_Comercial__c = objOpComercial.Id;
        objLineaOC.Linea__c = objLinea.Id;
        objLineaOC.Accion__c = 'Adicionar';
        objLineaOC.Estado__c = 'Pendiente';
        insert objLineaOC;
    }
    
    static testMethod void CancelarTest(){
        CreateData();
        OperacionComercial__c objOc= [SELECT Id FROM OperacionComercial__c LIMIT 1];
        PS_EnvioFacturacion_ctr testController;
        Test.startTest();
        
        PageReference pageRef = Page.EnvioFacturacion_pag;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', objOc.Id);
        PS_EnvioFacturacion_ctr cls = new PS_EnvioFacturacion_ctr();
        
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.ValidaSel();
        cls.SelNada();
        cls.Cancelar();
        
        Test.stopTest();
    }
    
    static testMethod void GenerarIntegracionTest(){
        CreateData();
        OperacionComercial__c objOc= [SELECT Id FROM OperacionComercial__c LIMIT 1];
        PS_EnvioFacturacion_ctr testController;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500,'Error 500'));
        Test.startTest();
        
        PageReference pageRef = Page.EnvioFacturacion_pag;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id', objOc.Id);
        PS_EnvioFacturacion_ctr cls = new PS_EnvioFacturacion_ctr();
        
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.GenerarIntegracion();
        
        Test.stopTest();
    }
    
    public class PS_MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String sstatus;
        
        public PS_MockHttpResponse(Integer statusCode,String sstatus){
            this.statusCode = statusCode;
            this.sstatus = sstatus;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            String strResponse = '';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(this.statusCode);
            res.setStatus(sstatus);
            return res;
        }
    }
}