/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase LTE_EnviarInfoFactEquipos_cls correspondiente al proceso de facturación.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     15/09/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
@isTest
private class LTE_EnviarInfoFactEquipos_tst
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
  public static Equipo__c objEquipo;
  public static Planes__c objPlan;
  public static Planes__c objPlan2;
  public static ActivoETB__c objServicio;
  public static LTE_Servicios_adicionales__c objServAdicional;
  public static LTE_SpecificationGroupXA__c objSpecification;
  public static LTE_SpecificationGroupXA__c objSpecification2;
  public static OperacionComercial__c objOpComercial;
  public static Reserva__c objOferta;
  public static LTE_DetalleOferta__c objDetalleOferta;
  public static VariablesGlobales__c objVariables;
  public static Perfiles_Acciones__c objPerfiles;
  public static Perfiles_Reglas_OC__c objRegalsOC;
  public static ServiciosWeb__c objServicioWeb;
  public static list<sobject> vg;
  public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();

  public static void CreateData()
    {
      vg=new list<sobject>();
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
      insert vg;

    objPruebas_tst obj=new objPruebas_tst();     
      Account cliente =obj.objAccount();
      insert cliente;
      //variablesObj.get('Account').add(cliente);
      
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c='LTE';
        insert Catalogo;
        
        CatalogoProductosFacturacion__c objCatalogoProdFact=objPruebas_tst.objCatalogoProductosFacturacion();
        objCatalogoProdFact.Name=Catalogo.Name;
        objCatalogoProdFact.CatalogoProductos__c=Catalogo.Id;
        insert objCatalogoProdFact;
        

        objRegalsOC = new Perfiles_Reglas_OC__c();
        objRegalsOC.Name = 'Escenario08';
        objRegalsOC.Desactivar__c = true;
        objRegalsOC.esCreador__c = false;
        objRegalsOC.Detalles__c = 'en estado activa o declinada';
        objRegalsOC.esPropietario__c = false;
        objRegalsOC.Perfiles__c = userinfo.getProfileId();
        system.debug('ID DEL PERFIL------' + objRegalsOC.Perfiles__c);
        insert objRegalsOC;

        objServicioWeb = new ServiciosWeb__c();
        objServicioWeb.Name = 'Formateador';
        objServicioWeb.EndPoint__c = 'http://201.245.171.239:7052/Service/BillingCorporate/Endpoint';
        objServicioWeb.Action__c = '/Service/BillingCorporate.serviceagent/soapEndpoint1/GetInvoiceFormat';
        insert objServicioWeb;

      objPerfiles = new Perfiles_Acciones__c();
        objPerfiles.Name = 'PerfilesCambioEstadosLTE';
        objPerfiles.Usuarios__c = userinfo.getProfileId();
        insert objPerfiles; 

      objAccount = new Account();
    objAccount.Name = 'Test Name';
      objAccount.RazonSocial__c = 'Test razon social';
      objAccount.Tipodedocumento__c = 'NIT';
      objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
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
      objCtaFact.DirCorresp__c = 'Test direccion';
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
      objContact.Phone = '43243243';
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
      objLegalizacion.Estado__c = 'Validación de pago';
      objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.LTE_TipoPago__c = 'Inmediato';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';        
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
      system.debug('objProducto-1->'+objProducto);

      objTOPP = new TOPP__c();
      objTOPP.Name = 'Renovación- TELEFONIA MOVIL (LTE)';
      objTOPP.TipodeOperacionporplan__c = 'Renovación';
      objTOPP.Tipoderegistro__c = 'Reposicion_LTE';
      objTOPP.Facturable__c = true;
      objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP;

      objEquipo = new Equipo__c();
      objEquipo.Name = 'Ascend G6 Negro';
      objEquipo.LTE_PartNumber__c = '129456789987654';
      objEquipo.LTE_Marca__c = 'Huawei';
      objEquipo.LTE_Color__c = 'Negro';
      objEquipo.Valor_del_Equipo__c = 395689;
      objEquipo.LTE_IVA__c = 63310;
      objEquipo.LTE_PrecioConIVA__c = 459000;
      objEquipo.LTE_Activo__c=true; // JDUR 2016-01-12
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
      insert objPlan;


      objPlan2 = new Planes__c ();
      objPlan2.Name = 'PLAN DE PAGOS';
      objPlan2.NombredelProducto__c = objProducto.Id;
      objPlan2.TipodePlan__c = 'Principal';
      objPlan2.Tarifa__c = 96000;
      objPlan2.Estado__c = 'Activo';
      objPlan2.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan2.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan2.LTE_PlanEstructurados__c = true;
      insert objPlan2;



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

        objOpComercial = new OperacionComercial__c();
      objOpComercial.CuentaCliente__c = objAccount.Id;
      objOpComercial.Activo__c = objServicio.Id;
      objOpComercial.Plan__c = objPlan.Id;
      objOpComercial.TOPP__c = objTOPP.Id;
      objOpComercial.Oportunidad__c = objOportunidad.Id;
      objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
      objOpComercial.Estado__c = 'Pendiente';
      objOpComercial.NumeroConexion__c = '3057000501';
      objOpComercial.FechadeActivacion__c = system.today();
      objOpComercial.Legalizacion__c = objLegalizacion.Id;
      insert objOpComercial;

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

        objSpecification = new LTE_SpecificationGroupXA__c();
        objSpecification.Name = 'RVC PARM LTE Contract ID';
        objSpecification.LTE_ActionCode__c = 'ADD';
        objSpecification.LTE_Value__c = '1000Min-3GB-100-2';
        objSpecification.LTE_ServiciosAdicionales__c = objServAdicional.Id;
        insert objSpecification;

        objSpecification2 = new LTE_SpecificationGroupXA__c();
        objSpecification2.Name = 'RVC PLN';
        objSpecification2.LTE_ActionCode__c = 'ADD';
        objSpecification2.LTE_Value__c = 'Plan Unico Pago Equipos LTE';
        objSpecification2.LTE_ServiciosAdicionales__c = objServAdicional.Id;
        insert objSpecification2;        
    }

  @isTest static void test_method_one()
  {
    CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('fileName','//atlas/folder/123456789-1492015164512.PDF');
    Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseFormateador());
    Test.startTest();
    BanderasEjecucion.unSetEjecucion('DesenCadenaFacFacturador');
    objDetalleOferta.LTE_IMEI__c = '919715175389397';
    objDetalleOferta.LTE_DescuentoEquipos__c = 10;
    update objDetalleOferta;
    objLegalizacion.LTE_FacturaEnviada__c = 'Reenviar';
    update objLegalizacion;
        Test.stopTest();
  }
  
  @isTest static void test_method_two()
  {
    CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('fileName','');
    Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseFormateador());
    Test.startTest();
    BanderasEjecucion.unSetEjecucion('DesenCadenaFacFacturador');
    objDetalleOferta.LTE_IMEI__c = '919715175389397';
    objDetalleOferta.LTE_DescuentoEquipos__c = 10;
    update objDetalleOferta;
    objLegalizacion.LTE_FacturaEnviada__c = 'Reenviar';
    update objLegalizacion;
        Test.stopTest();
  }

  @isTest static void test_method_three()
  {
    vg=new list<sobject>();
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
      insert vg;
      
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
 
     objProducto = new CatalogoProductos__c();
      objProducto.Name = 'TELEFONIA MOVIL (LTE)';
      objProducto.Familia__c = 'LTE';
      objProducto.LineaNegocio__c = 'Redes Móviles';
      objProducto.CodigoProducto__c = '7635736';
      objProducto.Estado__c = 'Activo';
      objProducto.Descripcion__c = 'Teste';
      objProducto.AtributosEstandar__c = 'Teste';
      insert objProducto;
      system.debug('objProducto-1->'+objProducto);
      
       objPlan2 = new Planes__c ();
      objPlan2.Name = 'PLAN DE PAGOS';
      system.debug('objProducto-2->'+objProducto);
      objPlan2.NombredelProducto__c = objProducto.Id;
      objPlan2.TipodePlan__c = 'Principal';
      objPlan2.Tarifa__c = 96000;
      objPlan2.Estado__c = 'Activo';
      objPlan2.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan2.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan2.LTE_PlanEstructurados__c = true;
      insert objPlan2;
      
      PlanFacturacion__c objPlanFacturacionPagos = new PlanFacturacion__c();
        objPlanFacturacionPagos.name='PLAN DE PAGOS';
        objPlanFacturacionPagos.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        objPlanFacturacionPagos.Plan__c=objPlan2.id;
        insert objPlanFacturacionPagos;
        
        
      system.debug('objPlan2-->'+objPlan2);      
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

      Poblacion__c objDepto2 = new Poblacion__c();
      objDepto2.Name = 'BOGOTA D.C.';
      objDepto2.CodigoDane__c = '22000';
      objDepto2.EsDepartamento__c = true;
      insert objDepto2;

    Poblacion__c objMunicipio2 = new Poblacion__c();
      objMunicipio2.Name = 'BOGOTA D.C.';
      objMunicipio2.CodigoDane__c = '22002';
      objMunicipio2.EsMunicipio__c = true;
      objMunicipio2.Padre__c = objDepto2.Id;
      insert objMunicipio2;

      CuentaFacturacion__c objCuentaFacturacion=obj.objCuentaFacturacion();
        objCuentaFacturacion.Cliente__c=cliente.id;
        objCuentaFacturacion.Ciudad__c = objMunicipio2.Id;
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
        oc.Estado__c='Pendiente';
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
    Test.startTest();
    LTE_GeneraServAdicVentaEquipos.obtenerEstructuradoPosventa(oc);
    map<id, OperacionComercial__c> ocsMap = new map<id, OperacionComercial__c>();
    ocsMap.put(oc.id,oc);
    LTE_GeneraServAdicVentaEquipos.obtenerEstructurado(ocsMap);
    
    LTE_genXmlFormateador_cls cls = new LTE_genXmlFormateador_cls();
    LTE_genXmlFormateador_cls.generaXMLFormateadorDummy(new map<String,String>());
        Test.stopTest();
  }
  
    
}