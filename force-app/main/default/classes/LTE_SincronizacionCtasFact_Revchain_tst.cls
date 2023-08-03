/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase encargada del consumo del servicio web para la creación de las cuentas de facturación.                          
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     26/08/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
@isTest(SeeAllData=false)
private class LTE_SincronizacionCtasFact_Revchain_tst
{
    public static Account objAccount;
    public static Account objAccount2;
    public static Poblacion__c objDepto;
    public static Poblacion__c objDepto2;
    public static Poblacion__c objMunicipio;
    public static Poblacion__c objMunicipio2;
    public static CuentaFacturacion__c objCtaFact;
    public static CuentaFacturacion__c objCtaFact2;
    public static CuentaFacturacion__c objCtaFact3;
    public static CuentaFacturacion__c objCtaFactHija;
    public static CuentaFacturacion__c objCtaFactHija2;
    public static OperacionComercial__c objOpComercial;
    public static OperacionComercial__c objOpComercial2;
    public static OperacionComercial__c objOpComercial3;
    public static list<OperacionComercial__c> lstOpComercial;
    public static ServiciosWeb__c objSW;
    public static ServiciosWeb__c objSW2;
    public static LTE_CiclosFacturacion__c objCiclos;
    public static LTE_CiclosFacturacion__c objCiclos1;
    
    public static void CreateData()
    {
        HomologacionCampos__c nHomologacion = new HomologacionCampos__c(Name = 'NIT', Valor__c = 'NIT');
        insert nHomologacion;
		
		objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456';    
        objAccount.Phone = '3003003030';
        insert objAccount;
        
        objAccount2 = new Account();
        objAccount2.Name = 'Test Name';
        objAccount2.RazonSocial__c = 'Test razon social';
        objAccount2.Tipodedocumento__c = 'CC';
        objAccount2.Estado_Cuenta__c = 'Activo';
        objAccount2.AccountNumber = '102828392';    
        objAccount2.Phone = '3003003030';
        insert objAccount2;
        
        objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        objDepto2 = new Poblacion__c();
        objDepto2.Name = 'ANTIOQUIA';
        objDepto2.CodigoDane__c = '1200';
        objDepto2.EsDepartamento__c = true;
        insert objDepto2;
        
        objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        objMunicipio2 = new Poblacion__c();
        objMunicipio2.Name = 'MEDELLIN';
        objMunicipio2.CodigoDane__c = '11002';
        objMunicipio2.EsMunicipio__c = true;
        objMunicipio2.Padre__c = objDepto2.Id;
        insert objMunicipio2;
        
        objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        objCtaFact.Fue_creada_en_revchain__c = true;
        insert objCtaFact;
        
        objCtaFact2 = new CuentaFacturacion__c();
        objCtaFact2.LTE_NombreCuentaFacturacion__c = '1234567';
        objCtaFact2.Cliente__c = objAccount2.Id;
        objCtaFact2.Facturable__c = true;
        objCtaFact2.LTE_MetodoEnvio__c = 'Email';
        objCtaFact2.LTE_CicloFacturacion__c = '5';
        objCtaFact2.LTE_Email__c = 'test2@test2.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact2.DirCorresp__c = 'Direccion test2';
        objCtaFact2.Ciudad__c = objMunicipio2.Id;
        objCtaFact2.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact2.Fue_creada_en_revchain__c = true;
        objCtaFact2.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact2;
        
        objCtaFact3 = new CuentaFacturacion__c();
        objCtaFact3.LTE_NombreCuentaFacturacion__c = '1234567';
        objCtaFact3.Cliente__c = objAccount2.Id;
        objCtaFact3.Facturable__c = true;
        objCtaFact3.LTE_MetodoEnvio__c = '';
        objCtaFact3.LTE_CicloFacturacion__c = '5';
        objCtaFact3.LTE_Email__c = 'test3@test3.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact3.DirCorresp__c = 'Direccion test3';
        objCtaFact3.Ciudad__c = objMunicipio2.Id;
        objCtaFact3.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact3.Fue_creada_en_revchain__c = true;
        objCtaFact3.LTE_PendienteModificacion__c = true;
        objCtaFact3.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact3;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
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
        
        Opportunity objOportunidad = new Opportunity();
        objOportunidad.Name = 'Test name';
        objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
        objOportunidad.AccountId = objAccount.Id;
        objOportunidad.StageName = 'Análisis de necesidades';
        //objOportunidad.StageName = 'Cerrada Ganada';
        objOportunidad.CloseDate = system.today();
        objOportunidad.Amount = 1000;
        objOportunidad.Valor_unica_vez_ETB__c = 150;
        objOportunidad.LTE_Scoring__c = 9000000;
        objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
        objOportunidad.LTE_NumeroLinea__c = 2;
        insert objOportunidad;
        
        CatalogoProductos__c objProducto = new CatalogoProductos__c();
        objProducto.Name = 'TELEFONIA MOVIL (LTE)';
        objProducto.Familia__c = 'LTE';
        objProducto.LineaNegocio__c = 'Redes Móviles';
        objProducto.CodigoProducto__c = '7635736';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        insert objProducto;
        
        TOPP__c objTOPP = new TOPP__c();
        objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
        objTOPP.TipodeOperacionporplan__c = 'Venta';
        objTOPP.Tipoderegistro__c = 'Venta_LTE';
        objTOPP.DisponibleVentainicial__c = true;
        objTOPP.Facturable__c = true;
        objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP;
        
        Planes__c objPlan = new Planes__c ();
        objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
        objPlan.NombredelProducto__c = objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 96000;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
        objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
        objPlan.LTE_PlanEstructurados__c = true;
        insert objPlan;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;     
        
        ActivoETB__c objServicio2 = new ActivoETB__c();
        objServicio2.Oportunidad__c = objOportunidad.Id;
        objServicio2.NombredelaCuenta__c = objAccount2.Id;
        objServicio2.Plan__c = objPlan.Id;
        objServicio2.Estado__c = 'Activo';
        objServicio2.IMEI_del_Equipo__c = '980684862113800';
        objServicio2.LTE_ICCID__c = '8957187113000000500';
        objServicio2.NumeroConexion__c = '3057000500';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;   
        
        ActivoETB__c objServicio3 = new ActivoETB__c();
        objServicio3.Oportunidad__c = objOportunidad.Id;
        objServicio3.NombredelaCuenta__c = objAccount.Id;
        objServicio3.Plan__c = objPlan.Id;
        objServicio3.Estado__c = 'Activo';
        objServicio3.IMEI_del_Equipo__c = '980684862113802';
        objServicio3.LTE_ICCID__c = '8957187113000000502';
        objServicio3.NumeroConexion__c = '3057000502';
        objServicio3.Fecha_Activacion__c = system.now();
        insert objServicio3;  
        
        OperacionComercial__c objOpComercial = new OperacionComercial__c();
        objOpComercial.CuentaCliente__c = objAccount.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.Plan__c = objPlan.Id;
        objOpComercial.TOPP__c = objTOPP.Id;
        //objOpComercial.Portacion__c = true;
        objOpComercial.Oportunidad__c = objOportunidad.Id;
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'Pendiente';
        objOpComercial.NumeroConexion__c = '3057000501';
        objOpComercial.FechadeActivacion__c = system.today();
        objOpComercial.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial;
        
        //objOpComercial = new OperacionComercial__c();
        //objOpComercial.CuentaCliente__c = objAccount.Id;
        //objOpComercial.Estado__c = 'Pendiente';
        //objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        //insert objOpComercial;
        
        lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial.add(objOpComercial);
        
        objCtaFactHija = new CuentaFacturacion__c();
        objCtaFactHija.LTE_NombreCuentaFacturacion__c = 'Cta fact Hija test';
        objCtaFactHija.Cliente__c = objAccount.Id;
        objCtaFactHija.Facturable__c = false;
        objCtaFactHija.LTE_MetodoEnvio__c = 'Servicio postal';
        objCtaFactHija.LTE_CicloFacturacion__c = '15';
        objCtaFactHija.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFactHija.DirCorresp__c = 'Direccion test';
        objCtaFactHija.Ciudad__c = objMunicipio.Id;
        objCtaFactHija.LTE_CuentaFacturacionLTE__c = true;
        objCtaFactHija.LTE_CuentaFacturacionPadre__c = objCtaFact.Id;
        objCtaFactHija.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFactHija;
        
        objCtaFactHija2 = new CuentaFacturacion__c();
        objCtaFactHija2.LTE_NombreCuentaFacturacion__c = 'Cta fact Hija test 2';
        objCtaFactHija2.Cliente__c = objAccount2.Id;
        objCtaFactHija2.Facturable__c = false;
        objCtaFactHija2.LTE_MetodoEnvio__c = 'Servicio postal e Email';
        objCtaFactHija2.LTE_CicloFacturacion__c = '15';
        objCtaFactHija2.LTE_Email__c = 'test2@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFactHija2.DirCorresp__c = 'Direccion test 2';
        objCtaFactHija2.Ciudad__c = objMunicipio2.Id;
        objCtaFactHija2.LTE_CuentaFacturacionLTE__c = true;
        objCtaFactHija2.LTE_CuentaFacturacionPadre__c = objCtaFact2.Id;
        objCtaFactHija2.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFactHija2;
        
        objOpComercial2 = new OperacionComercial__c();
        objOpComercial2.CuentaCliente__c = objAccount2.Id;
        objOpComercial2.Activo__c = objServicio2.Id;
        objOpComercial2.Plan__c = objPlan.Id;
        objOpComercial2.TOPP__c = objTOPP.Id;
        //objOpComercial2.Portacion__c = true;
        objOpComercial2.Oportunidad__c = objOportunidad.Id;
        objOpComercial2.CuentaFacturacion__c = objCtaFactHija.Id;
        objOpComercial2.Estado__c = 'Pendiente';
        objOpComercial2.NumeroConexion__c = '3057000500';
        objOpComercial2.FechadeActivacion__c = system.today();
        objOpComercial2.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial2;
        //objOpComercial2.CuentaCliente__c = objAccount2.Id;
        //objOpComercial2.Estado__c = 'Activa';
        //objOpComercial2.CuentaFacturacion__c = objCtaFactHija2.Id;
        //insert objOpComercial2;
        
        objOpComercial3 = new OperacionComercial__c();
        objOpComercial3.CuentaCliente__c = objAccount2.Id;
        objOpComercial3.Activo__c = objServicio3.Id;
        objOpComercial3.Plan__c = objPlan.Id;
        objOpComercial3.TOPP__c = objTOPP.Id;
        //objOpComercial3.Portacion__c = true;
        objOpComercial3.Oportunidad__c = objOportunidad.Id;
        objOpComercial3.CuentaFacturacion__c = objCtaFactHija.Id;
        objOpComercial3.Estado__c = 'Pendiente';
        objOpComercial3.NumeroConexion__c = '3057000502';
        objOpComercial3.FechadeActivacion__c = system.today();
        objOpComercial3.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial3;
        //objOpComercial3 = new OperacionComercial__c();
        //objOpComercial3.CuentaCliente__c = objAccount2.Id;
        //objOpComercial3.Estado__c = 'Activa';
        //objOpComercial3.CuentaFacturacion__c = objCtaFact3.Id;
        //insert objOpComercial3; 
        
        objSW = new ServiciosWeb__c();
        objSW.Name = 'CreacionCuentasFact';
        objSW.EndPoint__c = 'http://201.245.171.239:7084/Service/intSiebelSrvs.serviceagent/soapEndpoint';
        objSW.Action__c = '/Service/intSiebelSrvs.serviceagent//CreacionCuenta';
        insert objSW;
        
        objSW2 = new ServiciosWeb__c();
        objSW2.Name = 'EdicionCuentasFact';
        objSW2.EndPoint__c = 'http://201.245.171.239:7052/Service/BillingCorporate/Endpoint ';
        objSW2.Action__c = '/Service/BillingCorporate.serviceagent//UpdateInvoiceData';
        insert objSW2;
        
        objCiclos = new LTE_CiclosFacturacion__c();
        objCiclos.Name = '1';
        objCiclos.LTE_DiaCorteOCS__c = 5;
        objCiclos.LTE_DiaCorteRevChain__c = 4;
        insert objCiclos;
        
        objCiclos1 = new LTE_CiclosFacturacion__c();
        objCiclos1.Name = '2';
        objCiclos1.LTE_DiaCorteOCS__c = 15;
        objCiclos1.LTE_DiaCorteRevChain__c = 14;
        insert objCiclos1;        
    }
    
    @isTest static void unitTest()
    {
        CreateData();
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseCrearCtasFact());
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
            LTE_SincronizacionCtasFact_Revchain_cls objSinc = new LTE_SincronizacionCtasFact_Revchain_cls();
            objSinc.CrearCuentasFacturacion(lstOpComercial);
        }
        Test.stopTest();
    }
    
    @isTest static void test_method_two()
    {
        CreateData();
        lstOpComercial.clear();        
        lstOpComercial.add(objOpComercial2);      
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseCrearCtasFactHijas());
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
            LTE_SincronizacionCtasFact_Revchain_cls objSinc = new LTE_SincronizacionCtasFact_Revchain_cls();
            objSinc.CrearCuentasFacturacion(lstOpComercial);
        }
        Test.stopTest();
    }
    
    @isTest static void test_method_three()
    {
        CreateData();
        lstOpComercial.clear();        
        lstOpComercial.add(objOpComercial3);
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseActualizarCtasFact());
        
        Test.startTest();
        LTE_SincronizacionCtasFact_Revchain_cls objSinc = new LTE_SincronizacionCtasFact_Revchain_cls();
        objSinc.CrearCuentasFacturacion(lstOpComercial);
        Test.stopTest();
    }
}