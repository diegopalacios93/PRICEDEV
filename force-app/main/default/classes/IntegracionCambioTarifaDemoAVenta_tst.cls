@isTest(SeeAllData=false)
private class IntegracionCambioTarifaDemoAVenta_tst {
	
    public static Account objAccount;
    public static Contract objContrato;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static CuentaFacturacion__c objCtaFact;
    public static Contact objContact;    
    public static Legalizacion__c objLegalizacion;
    public static CatalogoProductos__c objProducto;    
    public static ActivoETB__c objServicio; 
    public static TOPP__c objTOPP;   
    public static Planes__c objPlan;
    public static OperacionComercial__c objOpComercial;
    public static PlanFacturacion__c objPlanFacturacion;
    public static ParametroFacturacion__c objParametro;
    public static ParametroFacturacion__c objParametro2;
    public static SubPlanFacturacion__c objSubPlan;
    public static CatalogoProductosFacturacion__c objProductoFacturacion;
    
    public static void CreateData(){
               
        objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana'; 
        ObjAccount.Phone = '3158181818';
        insert objAccount;

        objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;

        objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;

        objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
        insert objMunicipio;

        objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.CodCicloFac__c = '96';
        objCtaFact.LTE_Email__c = 'test@test.com';
        objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        objCtaFact.Fue_creada_en_revchain__c = true; 
        objCtaFact.Fue_creada_en_RMCA__c = true;
        objCtaFact.Fue_creada_en_MDM__c = true;
        insert objCtaFact;
            
        objContact = new Contact(IsTEST__c = true);
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
        objContact.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
        insert objContact;
               
        objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        insert objLegalizacion;

        objProducto = new CatalogoProductos__c();
        objProducto.Name = 'Conectividad Avanzada IP';
        objProducto.Familia__c = 'Conectividad';
        objProducto.LineaNegocio__c = 'DATOS';
        objProducto.CodigoProducto__c = 'ConectividadAvanzadaIP001';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        objProducto.Linea_Negocio_Aseguramiento__c = 'DATOS';
        objProducto.Catalogo__c = 'Portafolio Superior';
        objProducto.Tipo_de_Producto__c = 'Avanzado';
        insert objProducto;       
        
		objPlan = new Planes__c ();
        objPlan.Name = 'Plan Conectividad Avanzada IP';
        objPlan.NombredelProducto__c = objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 0;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = '';
        objPlan.CondicionesComerciales__c = '';
        objPlan.LTE_PlanEstructurados__c = false;
        insert objPlan;
        
        objTOPP = new TOPP__c();
        objTOPP.Name = 'Conversión Demo a Venta- Plan Demo Conectividad Avanzada IP';
        objTOPP.TipodeOperacionporplan__c = 'Conversión Demo a Venta';
        objTOPP.Tipoderegistro__c = 'Conversion_Demo_a_Venta';
        objTOPP.AplicaPreventa__c=true;
        objTOPP.DisponibleVentainicial__c = true;        
        objTOPP.Activo__c = true;
        objTOPP.Plan__c = objPlan.Id;
        objTOPP.Facturable__c = true;
        insert objTOPP;
        
        objServicio = new ActivoETB__c();        
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.CuentaFacturacion__c = objCtaFact.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;
        
        objOpComercial = new OperacionComercial__c();
        objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Conversión Demo a Venta').getRecordTypeId();
        objOpComercial.CuentaCliente__c = objAccount.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.Plan__c = objPlan.Id;
        objOpComercial.TOPP__c = objTOPP.Id;        
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'Pendiente Facturacion';        
        objOpComercial.FechadeActivacion__c = system.today()-3;        
        objOpComercial.Legalizacion__c = objLegalizacion.Id;
        objOpComercial.EnvioFacturacion__c = true;
        objOpComercial.Demo__c = true;
        objOpComercial.ValorTarifaPlan__c = 500000;
        insert objOpComercial;
        
        CatalogoProductosFacturacion__c objProductoFacturacion = new CatalogoProductosFacturacion__c();
        objProductoFacturacion.Name = 'Cargo Fijo E1 RDSI';
        objProductoFacturacion.CatalogoProductos__c = objProducto.Id;
        objProductoFacturacion.ConnectionID__c = 'Test';
        objProductoFacturacion.ConnectionTypeID__c = 'Test';
        objProductoFacturacion.Servicio__c = 'E1 Enlace Voz';
        objProductoFacturacion.Codigo__c = 0;
        insert objProductoFacturacion;
        
        PlanFacturacion__c objPlanFacturacion = new PlanFacturacion__c();
        objPlanFacturacion.CatalogoProductosFacturacion__c = objProductoFacturacion.Id;
		objPlanFacturacion.Plan__c = objPlan.Id;
		objPlanFacturacion.Name = 'Local Cargo Fijo E1 Enlace Voz';
		insert objPlanFacturacion;
        
        ParametroFacturacion__c objParametro = new ParametroFacturacion__c();
        objParametro.Name = 'CargoDS';
        objParametro.PlanFacturacion__c = objPlanFacturacion.Id;
        objParametro.Campo__c = 'ValorTarifaPlan__c';
        objParametro.Formato__c = 'NUMBERPAD(#.####)';
        insert objParametro;

        SubPlanFacturacion__c objSubPlan = new SubPlanFacturacion__c();
		objSubPlan.Name = 'Plan Equipo Datos';
		objSubPlan.CampoDependiente__c = 'Valor_Equipos__c';
        objSubPlan.Codigo__c = '9';
        objSubPlan.PlanFacturacion__c = objPlanFacturacion.Id;
        objSubPlan.CatalogoProductosFacturacion__c = objProductoFacturacion.Id;
        insert objSubPlan;
            
        ParametroFacturacion__c objParametro2 = new ParametroFacturacion__c();
        objParametro2.Name = 'CargoDS';
        objParametro2.SubPlanFacturacion__c = objSubPlan.Id;
        objParametro2.Campo__c = 'ValorTarifaPlan__c';
        objParametro2.Formato__c = 'NUMBERPAD(#.####)';
        insert objParametro2;
    }
        
    static testMethod void IntegracionCambioTarifaDemoAVenta_tst() {
        CreateData();
        test.startTest();
        try {
        TrasladoServiciosFacturacion_bch facttbtch = new TrasladoServiciosFacturacion_bch();               
        ID batchprocessid = Database.executeBatch(facttbtch,1);
        } catch(Exception e) {
          System.debug(e.getMessage());
        }
        test.stopTest();
    }    

}