/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase LTE_ConstruccionCanonico_cls correspondiente al proceso de facturación.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     08/09/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
@isTest
private class LTE_ConstruccionCanonico_tst
{
  public static Account objAccount;
  public static Contract objContrato;
  public static Poblacion__c objDepto;
  public static Poblacion__c objMunicipio;
  public static CuentaFacturacion__c objCtaFact;
  public static Contact objContact;
  public static Opportunity objOportunidad;
  public static Legalizacion__c objLegalizacion;
  public static CatalogoProductos__c objProducto;
  public static TOPP__c objTOPP;
    public static TOPP__c objTOPP2;
    public static TOPP__c objTOPP3;
    public static TOPP__c objTOPP4;
    public static TOPP__c objTOPP5;
  public static Equipo__c objEquipo;
  public static Planes__c objPlan;
  public static ActivoETB__c objServicio;
    public static ActivoETB__c objServicio2;
  public static LTE_Servicios_adicionales__c objServAdicional;
  public static LTE_Servicios_adicionales__c objServAdicional2;
    public static LTE_Servicios_adicionales__c objServAdicional3;
    public static LTE_Servicios_adicionales__c objServAdicional4;
    public static LTE_Servicios_adicionales__c objServAdicional5;
  public static LTE_SpecificationGroupXA__c objSpecification;
  public static LTE_SpecificationGroupXA__c objSpecification2;
    public static LTE_SpecificationGroupXA__c objSpecification3;
    public static LTE_SpecificationGroupXA__c objSpecification4;
    public static LTE_SpecificationGroupXA__c objSpecification5;
  public static OperacionComercial__c objOpComercial;
    public static OperacionComercial__c objOpComercial2;
  public static Reserva__c objOferta;
  public static LTE_DetalleOferta__c objDetalleOferta;
  public static VariablesGlobales__c objVariables;
  public static HomologacionMetodosReclamacion__c objMetodosReclamacion;
  public static HomologacionCampos__c objHomologacionCampos;
  public static ServiciosWeb__c objServicioWeb;
    public static Perfiles_Acciones__c objPerfiles;
    public static Perfiles_Reglas_OC__c objRegalsOC;

  public static void CreateData()
    {
        objVariables = new VariablesGlobales__c();
        objVariables.Name = 'NombreComercialLTE';
        objVariables.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert objVariables;

        objMetodosReclamacion = new HomologacionMetodosReclamacion__c();
        objMetodosReclamacion.Name = 'Gobierno Distrital-Mediana';
        objMetodosReclamacion.MetodoReclamacion__c = '0006';
        insert objMetodosReclamacion;

        objHomologacionCampos = new HomologacionCampos__c();
        objHomologacionCampos.Name = 'NIT';
        objHomologacionCampos.Valor__c = 'JURIDICO';
        insert objHomologacionCampos;

        objServicioWeb = new ServiciosWeb__c();
        objServicioWeb.Name = 'RevChain';
        objServicioWeb.EndPoint__c = 'http://201.245.171.239:7082/Service/SalesForce.serviceagent/Endpoint';
        objServicioWeb.Action__c = '/Service/SalesForce.serviceagent/soapEndpoint1/SFRevChainOP';
        insert objServicioWeb;

        objPerfiles = new Perfiles_Acciones__c();
        objPerfiles.Name = 'PerfilesCambioEstadosLTE';
        objPerfiles.Usuarios__c = userinfo.getProfileId();
        insert objPerfiles;

        objRegalsOC = new Perfiles_Reglas_OC__c();
        objRegalsOC.Name = 'Escenario08';
        objRegalsOC.Desactivar__c = true;
        objRegalsOC.esCreador__c = false;
        objRegalsOC.Detalles__c = 'en estado activa o declinada';
        objRegalsOC.esPropietario__c = false;
        objRegalsOC.Perfiles__c = userinfo.getProfileId();
        insert objRegalsOC;

      objAccount = new Account();
   	  objAccount.Name = 'Test Name';
      objAccount.RazonSocial__c = 'Test razon social';
      objAccount.Tipodedocumento__c = 'NIT';
      objAccount.Estado_Cuenta__c = 'Activo';
      objAccount.AccountNumber = '1029837456'; 
      objAccount.Phone= '1029837456';
      objAccount.Segmento__c = 'Gobierno Distrital';
      objAccount.SubSegmento__c = 'Mediana';   
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
      insert objDepto;

    objMunicipio = new Poblacion__c();
      objMunicipio.Name = 'BOGOTA D.C.';
      objMunicipio.CodigoDane__c = '11001';
      objMunicipio.EsMunicipio__c = true;
      objMunicipio.Padre__c = objDepto.Id;
      insert objMunicipio;

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
      objCtaFact.Fue_creada_en_revchain__c = true;
      objCtaFact.DirCorresp__c = 'Test DirCorresp';
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
      objContact.LTE_RolLTE__c = 'Total';
      objContact.Genero__c = 'Masculino';
      objContact.Direccion__c = 'Calle 12 # 34 - 53';
      objContact.Phone = '432432432';
      objContact.MobilePhone = '3105667655';
      objContact.Email = 'scampos@avanxo.com';
      objContact.Ciudad__c = objMunicipio.Id;
      insert objContact;

      objOportunidad = new Opportunity();
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
      objProducto.Name = 'TELEFONIA MOVIL (LTE)';
      objProducto.Familia__c = 'LTE';
      objProducto.LineaNegocio__c = 'Redes Móviles';
      objProducto.CodigoProducto__c = '7635736';
      objProducto.Estado__c = 'Activo';
      objProducto.Descripcion__c = 'Teste';
      objProducto.AtributosEstandar__c = 'Teste';
      insert objProducto;

      objTOPP = new TOPP__c();
      objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
      objTOPP.TipodeOperacionporplan__c = 'Venta';
      objTOPP.Tipoderegistro__c = 'Venta_LTE';
      objTOPP.DisponibleVentainicial__c = true;
      objTOPP.Facturable__c = true;
      objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP;

        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Venta Equipos- TELEFONIA MOVIL (LTE)';
        objTOPP2.TipodeOperacionporplan__c = 'Venta Equipos';
        objTOPP2.Tipoderegistro__c = 'Venta_LTE';
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = true;
        objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP2;

        objTOPP3 = new TOPP__c();
        objTOPP3.Name = 'Retiro- TELEFONIA MOVIL (LTE)';
        objTOPP3.TipodeOperacionporplan__c = 'Retiro';
        objTOPP3.Tipoderegistro__c = 'Retiros';
        objTOPP3.Facturable__c = true;
        objTOPP3.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP3;

        objTOPP4 = new TOPP__c();
        objTOPP4.Name = 'Renovación- TELEFONIA MOVIL (LTE)';
        objTOPP4.TipodeOperacionporplan__c = 'Renovación';
        objTOPP4.Tipoderegistro__c = 'Reposicion_LTE';
        objTOPP4.Facturable__c = true;
        objTOPP4.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP4;

        objTOPP5 = new TOPP__c();
        objTOPP5.Name = 'Adición SVA- TELEFONIA MOVIL (LTE)';
        objTOPP5.TipodeOperacionporplan__c = 'Adición SVA';
        objTOPP5.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP5.Facturable__c = true;
        objTOPP5.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP5;

      objEquipo = new Equipo__c();
      objEquipo.Name = 'Ascend G6 Negro';
      objEquipo.LTE_PartNumber__c = '129456789987654';
      objEquipo.LTE_Marca__c = 'Huawei';
      objEquipo.LTE_Color__c = 'Negro';
      objEquipo.LTE_Activo__c = true;
      objEquipo.Valor_del_Equipo__c = 395689;
      objEquipo.LTE_IVA__c = 63310;
      objEquipo.LTE_PrecioConIVA__c = 459000;
      insert objEquipo;

      objPlan = new Planes__c ();
      objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
      objPlan.NombredelProducto__c = objProducto.Id;
      objPlan.TipodePlan__c = 'Principal';
      objPlan.Tarifa__c = 96000;
      objPlan.Estado__c = 'Activo';
      objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan.LTE_PlanEstructurados__c = true;
      objPlan.LTE_TipoControl__c = 'Abierto';
      insert objPlan;

      objOferta = new Reserva__c();
      objOferta.Oportunidad__c = objOportunidad.Id;
      objOferta.Estado__c = 'Pendiente';
      objOferta.Equipo__c = objEquipo.Id;
      objOferta.LTE_Plan__c = objPlan.Id;
      insert  objOferta;

      objServicio = new ActivoETB__c();
      objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;

        objServicio2 = new ActivoETB__c();
        objServicio2.Oportunidad__c = objOportunidad.Id;
        objServicio2.NombredelaCuenta__c = objAccount.Id;
        objServicio2.Plan__c = objPlan.Id;
        objServicio2.Estado__c = 'Pendiente';
        insert objServicio2;        

      objOpComercial = new OperacionComercial__c();
      objOpComercial.CuentaCliente__c = objAccount.Id;
      objOpComercial.Activo__c = objServicio.Id;
      objOpComercial.Plan__c = objPlan.Id;
      objOpComercial.TOPP__c = objTOPP.Id;
      objOpComercial.Oportunidad__c = objOportunidad.Id;
      objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
      objOpComercial.Estado__c = 'Activa';
      objOpComercial.FechadeActivacion__c = system.today();
      objOpComercial.NumeroConexion__c = '3057000501';
      objOpComercial.FechadeActivacion__c = system.today();
      objOpComercial.Legalizacion__c = objLegalizacion.Id;
      insert objOpComercial;

        objOpComercial2 = new OperacionComercial__c();
        objOpComercial2.CuentaCliente__c = objAccount.Id;
        objOpComercial2.Activo__c = objServicio2.Id;
        objOpComercial2.Plan__c = objPlan.Id;
        objOpComercial2.TOPP__c = objTOPP2.Id;
        objOpComercial2.Oportunidad__c = objOportunidad.Id;
        objOpComercial2.Estado__c = 'Activa';
        objOpComercial2.FechadeActivacion__c = system.today();
        objOpComercial2.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial2;

      objDetalleOferta = new LTE_DetalleOferta__c();
      objDetalleOferta.LTE_OperacionComercial__c = objOpComercial.Id;
      objDetalleOferta.LTE_Cliente__c = objAccount.Id;
      objDetalleOferta.LTE_Oferta_Economica__c = objOferta.Id;
      objDetalleOferta.LTE_Estado__c = 'Pendiente';
      objDetalleOferta.LTE_Estado_Detalle_Oferta__c = 'Reservado';
      objDetalleOferta.LTE_ReferenciaEquipo__c = objEquipo.Id;
      objDetalleOferta.LTE_IMEI__c = '980684862113805';
      objDetalleOferta.LTE_ICCID__c = '8957187113000000506';
      objDetalleOferta.LTEValorEquipoDescuento__c = 458999;
      objDetalleOferta.Plan__c = objPlan.Id;
      insert objDetalleOferta;

        objServAdicional = new LTE_Servicios_adicionales__c();
        objServAdicional.Name = 'TELEFONIA MOVIL (LTE)';
        objServAdicional.LTE_Estado__c = 'Pendiente';
        objServAdicional.LTE_ServicioETB__c = objServicio.Id;
        objServAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
        insert objServAdicional;

        objServAdicional2 = new LTE_Servicios_adicionales__c();
        objServAdicional2.Name = 'OTRO NOMBRE';
        objServAdicional2.LTE_Estado__c = 'Pendiente';
        objServAdicional2.LTE_ServicioETB__c = objServicio.Id;
        objServAdicional2.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
        objServAdicional2.LTE_PrimaryClassificationCode__c = 'CLASE FINANCIAMIENTO LTE';
        insert objServAdicional2;

        objServAdicional3 = new LTE_Servicios_adicionales__c();
        objServAdicional3.Name = 'EQUIPO PROPIEDAD CLIENTE';
        objServAdicional3.LTE_Estado__c = 'Pendiente';
        objServAdicional3.LTE_ServicioETB__c = objServicio2.Id;
        insert objServAdicional3;

        objServAdicional4 = new LTE_Servicios_adicionales__c();
        objServAdicional4.Name = 'TELEFONIA MOVIL (LTE)';
        objServAdicional4.LTE_Estado__c = 'Pendiente';
        objServAdicional4.LTE_ServicioETB__c = objServicio2.Id;
        insert objServAdicional4;

        objServAdicional5 = new LTE_Servicios_adicionales__c();
        objServAdicional5.Name = 'PLAN DE PAGOS';
        objServAdicional5.LTE_Estado__c = 'Pendiente';
        objServAdicional5.LTE_ServicioETB__c = objServicio2.Id;
        objServAdicional5.LTE_PrimaryClassificationCode__c = 'CLASE FINANCIAMIENTO LTE';
        insert objServAdicional5;

        objSpecification = new LTE_SpecificationGroupXA__c();
        objSpecification.Name = 'RVC PARM LTE Contract ID';
        objSpecification.LTE_ActionCode__c = 'ADD';
        objSpecification.LTE_Value__c = '1000Min-3GB-100-2';
        objSpecification.LTE_ServiciosAdicionales__c = objServAdicional2.Id;
        insert objSpecification;

        objSpecification2 = new LTE_SpecificationGroupXA__c();
        objSpecification2.Name = 'RVC PLN';
        objSpecification2.LTE_ActionCode__c = 'ADD';
        objSpecification2.LTE_Value__c = 'Plan Unico Pago Equipos LTE';
        objSpecification2.LTE_ServiciosAdicionales__c = objServAdicional2.Id;
        insert objSpecification2;

        objSpecification3 = new LTE_SpecificationGroupXA__c();
        objSpecification3.Name = 'MARCA';
        objSpecification3.LTE_ActionCode__c = 'ADD';
        objSpecification3.LTE_Value__c = 'Samsung';
        objSpecification3.LTE_ServiciosAdicionales__c = objServAdicional3.Id;
        insert objSpecification3;

        objSpecification4 = new LTE_SpecificationGroupXA__c();
        objSpecification4.Name = 'RVC PARM LTE Contract ID';
        objSpecification4.LTE_ActionCode__c = 'ADD';
        objSpecification4.LTE_Value__c = '1000Min-3GB-100-2';
        objSpecification4.LTE_ServiciosAdicionales__c = objServAdicional5.Id;
        insert objSpecification4;

        objSpecification5 = new LTE_SpecificationGroupXA__c();
        objSpecification5.Name = 'RVC PLN';
        objSpecification5.LTE_ActionCode__c = 'ADD';
        objSpecification5.LTE_Value__c = 'Plan Unico Pago Equipos LTE';
        objSpecification5.LTE_ServiciosAdicionales__c = objServAdicional5.Id;
        insert objSpecification5;        
    }
  
  @isTest static void test_method_one()
  {
    CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','Y');
    Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
    list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
    lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,CuentaCliente__c,LTE_TipoTransaccion__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
              From OperacionComercial__c
              Where Plan__r.NombredelProducto__r.Familia__c = 'LTE' and Id =: objOpComercial.Id
              and  FechadeActivacion__c != null and TOPP__c != null and ((Estado__c ='Activa' or Estado__c='Equipo Facturado') or (TOPP__r.TipodeOperacionporplan__c = 'Retiro' and Estado__c = 'Inactivo'))];
    Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();
  }
  
  @isTest static void test_method_two()
  {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','Y');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Plan__r.NombredelProducto__r.Familia__c = 'LTE' and Id =: objOpComercial2.Id
                            and  FechadeActivacion__c != null and TOPP__c != null and ((Estado__c ='Activa' or Estado__c='Equipo Facturado') or (TOPP__r.TipodeOperacionporplan__c = 'Retiro' and Estado__c = 'Inactivo'))];
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();    
  }

    @isTest static void test_method_three()
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','N');
        
        OperacionComercial__c oc=objOpComercial.clone(false,false,false,false);
        oc.TOPP__c = objTOPP3.Id;
        
        insert oc;
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Plan__r.NombredelProducto__r.Familia__c = 'LTE' and Id =: oc.Id
                            and  FechadeActivacion__c != null and TOPP__c != null and ((Estado__c ='Activa' or Estado__c='Equipo Facturado') or (TOPP__r.TipodeOperacionporplan__c = 'Retiro' and Estado__c = 'Inactivo'))];
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();        
    }

    @isTest static void test_method_four() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','N');

        OperacionComercial__c oc=objOpComercial.clone(false,false,false,false);
        oc.TOPP__c = objTOPP4.Id;
        insert oc;
        
        objDetalleOferta.LTE_OperacionComercial__c = oc.Id;
        update objDetalleOferta;

        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Plan__r.NombredelProducto__r.Familia__c = 'LTE' and Id =: oc.Id
                            //and  FechadeActivacion__c != null and TOPP__c != null and ((Estado__c ='Activa' or Estado__c='Equipo Facturado') or (TOPP__r.TipodeOperacionporplan__c = 'Retiro' and Estado__c = 'Inactivo'))
		];
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();        
    }
    
    @isTest static void test_method_five() 
    {
        list<sobject> vg=new list<sobject>();
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
        vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='DisponibilidadM6',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='Facturacion',Ejecucion__c=true));
        insert vg;        
               
        objVariables = new VariablesGlobales__c();
        objVariables.Name = 'NombreComercialLTE';
        objVariables.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert objVariables;
        
        LTE_TramitesSuspenda__c tramiteSuspenda;
        tramiteSuspenda = new LTE_TramitesSuspenda__c();
        tramiteSuspenda.Name = 'Retiro, Portabilidad Saliente';
        tramiteSuspenda.LTE_Estado__c = 'Activo';
        tramiteSuspenda.LTE_Causal__c = 'Inactivo';
        insert tramiteSuspenda;
        
        Test.startTest();
        SchedulableContext sc;
		LTE_Facturacion_sch sch = new LTE_Facturacion_sch();
		sch.execute(sc);	
        Test.stopTest();       
    }
    
    @isTest static void test_method_six() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','Y');
        objTOPP4.TipodeOperacionporplan__c = 'Cambio Número';
        update objTOPP4;

        OperacionComercial__c oc=objOpComercial.clone(false,false,false,false);
        oc.TOPP__c = objTOPP4.Id;
        oc.FechaInicioReconexion__c = Date.today();
        insert oc;

        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Id =: oc.Id
		];
        
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();        
    }
    
    @isTest static void test_method_seven() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','Y');
        objTOPP4.TipodeOperacionporplan__c = 'Suspensión';
        update objTOPP4;

        OperacionComercial__c oc=objOpComercial.clone(false,false,false,false);
        oc.TOPP__c = objTOPP4.Id;
        oc.FechaInicioReconexion__c = Date.today();
        oc.TipoSuspension__c = 'Voluntaria';
        insert oc;

        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Id =: oc.Id
		];
        
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();        
    }

    @isTest static void test_method_eight() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','Y');
        objTOPP4.TipodeOperacionporplan__c = 'Adición SVA';
        update objTOPP4;

        OperacionComercial__c oc=objOpComercial.clone(false,false,false,false);
        oc.TOPP__c = objTOPP4.Id;
        oc.FechaInicioReconexion__c = Date.today();
        oc.Categoria__c = 'Seguro de terminales';
        insert oc;

        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Id =: oc.Id
		];
        
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();        
    }
    
    @isTest static void test_method_nine() 
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('BillingResponse','Y');
        objTOPP4.TipodeOperacionporplan__c = 'Cambio de Plan';
        update objTOPP4;

        OperacionComercial__c oc=objOpComercial.clone(false,false,false,false);
        oc.TOPP__c = objTOPP4.Id;
        oc.FechaInicioReconexion__c = Date.today();
        oc.Categoria__c = 'Seguro de terminales';
        oc.PlanAnterior__c = 'PLAN NEGOCIOS POSPAGO M';
        insert oc;
        
        objDetalleOferta.LTE_OperacionComercial__c = oc.Id;
        update objDetalleOferta;

        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        list<OperacionComercial__c> lstOpComercial = new list<OperacionComercial__c>();
        lstOpComercial = [  Select id,TOPP__c,TOPP__r.Name,Activo__c,LTE_TipoTransaccion__c,CuentaCliente__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c
                            From OperacionComercial__c
                            Where Id =: oc.Id
		];
        
        Test.startTest();
        LTE_ConstruccionCanonico_cls objCanonico = new LTE_ConstruccionCanonico_cls();
        objCanonico.CrearFacturacion(lstOpComercial);
        Test.stopTest();        
    }  
    
    @isTest static void test_method_ten() 
    {
        list<sobject> vg=new list<sobject>();
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
        vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='DisponibilidadM6',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='Facturacion',Ejecucion__c=true));
        insert vg;
        
        /*VariablesGlobales__c objVar = new VariablesGlobales__c();
        objVar.Name = 'NombreComercialLTE';
        objVar.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert objVar;*/
        CreateData();
        
    	OperacionComercial__c objOpComercial3;
        objOpComercial3 = new OperacionComercial__c();
        objOpComercial3.CuentaCliente__c = objAccount.Id;
        objOpComercial3.Activo__c = objServicio2.Id;
        objOpComercial3.Plan__c = objPlan.Id;
        objOpComercial3.TOPP__c = objTOPP5.Id;
        objOpComercial3.Oportunidad__c = objOportunidad.Id;
        objOpComercial3.Estado__c = 'Pendiente Facturacion';
        objOpComercial3.Categoria__c = 'Seguro de terminales';
        objOpComercial3.FechaInicioReconexion__c = system.today();
        objOpComercial3.FechadeActivacion__c = system.today();
        objOpComercial3.EnviadaFacturacionEquipo__c	=	true;
        objOpComercial3.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial3;
        delete objOpComercial2;
        delete objOpComercial;
        
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRevChain());
        Test.startTest();
        SchedulableContext sc;
		LTE_Facturacion_bch sch = new LTE_Facturacion_bch();
		sch.limitQ = true;
		sch.limiteTotal=40;
        ID batchprocessid = Database.executeBatch(sch,1);
		Test.stopTest();
    }
}