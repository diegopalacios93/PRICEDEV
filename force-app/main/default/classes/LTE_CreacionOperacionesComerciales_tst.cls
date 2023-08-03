/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para la clase LTE_CreacionOperacionesComerciales_ctr.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-14      Raul Mora (RM)            Creación de la clase.
***********************************************************************************************************************/
@isTest
private class LTE_CreacionOperacionesComerciales_tst {

  public List<TOPP__c> lstTopp;
  public Equipo__c objEquipo;

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
  public static ActivoETB__c objServ;
  public static LTE_Servicios_adicionales__c objServAdicional;
  public static LTE_Servicios_adicionales__c objServAdicionalS;
  public static LTE_SpecificationGroupXA__c objSpecification;
  public static LTE_SpecificationGroupXA__c objSpecification2;
  public static OperacionComercial__c objOpComercial;
  public static Reserva__c objOferta;
  public static LTE_DetalleOferta__c objDetalleOferta;
  public static VariablesGlobales__c objVariables;
  public static Perfiles_Acciones__c objPerfiles;
  public static Perfiles_Reglas_OC__c objRegalsOC;
  public static ServiciosWeb__c objServicioWeb;
  public static ServiciosWeb__c objServicioWeb2;
  public static ServiciosWeb__c objServicioWeb3;
  public static list<sobject> vg;
  public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();
  public static List<TOPP__c> lstTopp = new List<TOPP__c>();
  public static Case objCaso;
  public static LTE_ConsultaSuspenda__c tram;
  public static ValoresIntegracionHurtoCelulares__c valoresInteg;
  public static void CreateData()
    {
      valoresInteg = new ValoresIntegracionHurtoCelulares__c();
      valoresInteg.Name = 'Blanca';
      valoresInteg.Valor__c = '1';
      insert valoresInteg;
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
        vg.add(new LTE_RangoFactura__c(Name='FactEquiposLTE',Inicio_Rango__c=3)); 
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
        
        objServicioWeb3 = new ServiciosWeb__c();
        objServicioWeb3.Name = 'SuspendaConsulta';
        objServicioWeb3.EndPoint__c = 'http://201.245.171.162:7087/Service.serviceagent/portTypeSuspensionsReconnectionsEndpoint';
        objServicioWeb3.Action__c = '/Service/Service.serviceagent//ConsultaSuspendaOp';
        insert objServicioWeb3;
        
        objServicioWeb2 = new ServiciosWeb__c();
        objServicioWeb2.Name = 'SuspendaRegistro';
        objServicioWeb2.EndPoint__c = 'http://201.245.171.162:7087/Service.serviceagent/portTypeSuspensionsReconnectionsEndpoint';
        objServicioWeb2.Action__c = '/Service/Service.serviceagent//RegistroSuspendaOp';
        insert objServicioWeb2;

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
        objAccount.Phone = '13568956';
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
      objTOPP.LTE_Parte_servicio__c = true; 
      insert objTOPP;

        lstTopp = new List<TOPP__c>();
        
        TOPP__c objToppSusp = objTOPP.clone(false,false,false,false);
        objToppSusp.Facturable__c = true;
        objToppSusp.TipodeOperacionporplan__c = System.Label.LTE_Suspension;
        objToppSusp.LTE_Catalogo_de_Producto__c = Catalogo.Id;
        objToppSusp.DisponibleVentainicial__c = false;
        objToppSusp.LTE_Parte_servicio__c = true;
        lstTopp.add( objToppSusp );
        
        TOPP__c objToppRet = objTOPP.clone(false,false,false,false);
        objToppRet.Facturable__c = true;
        objToppRet.TipodeOperacionporplan__c = System.Label.LTE_Retiro;
        objToppRet.LTE_Catalogo_de_Producto__c = Catalogo.Id;
        objToppRet.DisponibleVentainicial__c = false;
        objToppRet.LTE_Parte_servicio__c = true;
        lstTopp.add( objToppRet );
        
        TOPP__c objToppRec = objTOPP.clone(false,false,false,false);
        objToppRec.Facturable__c = true;
        objToppRec.TipodeOperacionporplan__c = System.Label.LTE_Reconexion;
        objToppRec.LTE_Catalogo_de_Producto__c = Catalogo.Id;
        objToppRec.DisponibleVentainicial__c = false;
        objToppRec.LTE_Parte_servicio__c = true;
        lstTopp.add( objToppRec );
        
        TOPP__c objToppRen = objTOPP.clone(false,false,false,false);
        objToppRen.Facturable__c = true;
        objToppRen.TipodeOperacionporplan__c = System.Label.LTE_Renovacion;
        objToppRen.LTE_Catalogo_de_Producto__c = Catalogo.Id;
        objToppRen.DisponibleVentainicial__c = false;
        objToppRen.LTE_Parte_servicio__c = true;
        lstTopp.add( objToppRen );
        
        insert lstTopp;






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

        PlanFacturacion__c objPlanFactDeft=objPruebas_tst.objPlanFacturacion();
        objPlanFactDeft.Name='DEFAULT FACTURACION LTE';
    objPlanFactDeft.Plan__c=objPlan2.id;
        objPlanFactDeft.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        insert objPlanFactDeft;
        
        SubPlanFacturacion__c subPlan =objPruebas_tst.objSubPlanFacturacion();
        subPlan.Name='NUMERO SIM CARD';
        subPlan.PlanFacturacion__c=objPlanFactDeft.id;
        subPlan.codigo__c=subPlan.Name;
        insert subPlan;
        
        SubPlanFacturacion__c subPlanS =objPruebas_tst.objSubPlanFacturacion();
        subPlanS.Name='SEGURO GAMA A';
        subPlanS.PlanFacturacion__c=objPlanFactDeft.id;
        subPlanS.LTE_TipoSubplan__c = 'SVA-Seguro de terminales';
        subPlanS.codigo__c=subPlanS.Name;
        insert subPlanS;

        SubPlanFacturacion__c subPlanb =objPruebas_tst.objSubPlanFacturacion();
        subPlanb.Name='BOLSA ADIC DE DATOS 5GB';
        subPlanb.PlanFacturacion__c=objPlanFactDeft.id;
        subPlanb.codigo__c=subPlanb.Name;
        subPlanb.LTE_TipoSubplan__c='Bolsa de Datos a la medida';
        insert subPlanb;
        

        
        list<ParametroFacturacion__c> paraMetros=new list<ParametroFacturacion__c>();
        paraMetros.add(new ParametroFacturacion__c (Name='RVC PLN',LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',CatalogoProductosFacturacion__c=objCatalogoProdFact.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='LTE_EsPortabilidad__c',Name='EsPortabilidad',Objeto__c='LTE_DetalleOferta__c',PlanFacturacion__c=objPlanFactDeft.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlan.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlanb.Id));
        insert paraMetros;



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
        objServicio.CuentaFacturacion__c =objCtaFact.id;
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
      objOpComercial.LTE_EmpleoViolencia__c = 'Si';
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
        
        objServAdicionalS = new LTE_Servicios_adicionales__c();
        objServAdicionalS.Name = 'TELEFONIA MOVIL (LTE)';
        objServAdicionalS.LTE_Estado__c = 'Pendiente';
        objServAdicionalS.LTE_ServicioETB__c = objServicio.Id;
        objServAdicionalS.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
        objServAdicionalS.LTE_SubPlaFacturacion__c = subPlanS.Id;
        insert objServAdicionalS;

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
        
        objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        //objCaso.AccountNumber__c = objAccount.AccountNumber;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan.Id;
        objCaso.Status = 'Abierto';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
        insert objCaso; 
        
        tram = new LTE_ConsultaSuspenda__c();
        tram.name = 'Suspensión, Voluntaria';
        tram.Valor__c = 'Suspension Voluntaria';
        insert tram;
    }
  

  static testMethod void myUnitTest() 
  {
    
    BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate'); 
    CreateData();
    Test.startTest();
    LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
    LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c);
    LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoTramite','Suspension Voluntaria');
    LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoDocumento',objAccount.Tipodedocumento__c);
    LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroDocumento',objAccount.AccountNumber);
    LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','2');
    LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
    LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoFlujo','1');
    LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento'); 
    
    Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
    //LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
    //cls.consultarSuspensionSevicios(new set<String>{objServicio.Id}, 'Suspensión, Voluntaria', true, null);
    //Test.stopTest();
    
    
    
    ApexPages.currentPage().getParameters().put( 'id', objServicio.Id ); 
    
    LTE_CreacionOperacionesComerciales_ctr clsClase = new LTE_CreacionOperacionesComerciales_ctr();
    clsClase.strTipoPago='Primera factura';
    clsClase.strTipoRenovRepo = 'Equipo';
    clsClase.objDetOferta.LTE_ReferenciaEquipo__c = objEquipo.Id;
    clsClase.dcPorcentajeDescuento = 1;
    clsClase.objOpCom.Caso__c = objCaso.Id;
    clsClase.strEmpleoViolencia = 'EmpleoPrueba';
    List<SelectOption> options = clsClase.lstEmpleoViolencia;
    clsClase.strUtilizacionArmas = 'ArmasPrueba';
    options = clsClase.lstUtilizacionArmas;
    clsClase.strVictimaMenorEdad = 'VictimasPrueba';
    options = clsClase.lstVictimaMenorEdad;
    clsClase.blnAutorizacionReporteHurto = true;
    system.debug(lstTopp);
    for(TOPP__c objTop : lstTopp)
    {
      clsClase.strTipoPago='Primera factura';
      clsClase.strTipoRenovRepo = 'Equipo';      
      clsClase.strIdOperacion = objTop.Id;
      clsClase.cargarSecciones();
      clsClase.strTipoRenovRepo = 'Equipo';
      //clsClase.guardarOperacionComercial();
    }
    clsClase.mostrarEquipo();
    objServicio.Estado__c='Suspendido';
    //update objServicio;
    clsClase = new LTE_CreacionOperacionesComerciales_ctr();
    clsClase.strTipoPago='Inmediato';
    clsClase.strTipoRenovRepo = 'Equipo';
    clsClase.objDetOferta.LTE_ReferenciaEquipo__c = objEquipo.Id;
    clsClase.dcPorcentajeDescuento = 1;
        clsClase.incluyeDescuento(objOpComercial.id);
        clsClase.habilitarListaNegra();
        clsClase.strTipoSuspension = 'Robo';
        clsClase.habilitarListaNegra();
        clsClase.volverAccion();
        clsClase.obtenerCicloFacturacion();
        clsClase.validarDiasCalendario();
        clsClase.strTipoPagoSim ='si';


    for(TOPP__c objTop : lstTopp)
    {
      clsClase.strTipoPago='Primera factura';
      clsClase.strTipoRenovRepo = 'Equipo';      
      clsClase.strIdOperacion = objTop.Id;
      
      if(objTop.TipodeOperacionporplan__c==System.Label.LTE_Reconexion){
        objServicio.Estado__c='Suspendido';
        //update objServicio;
      }

            system.debug(objTop.TipodeOperacionporplan__c+' '+System.Label.LTE_Renovacion);
      if(objTop.TipodeOperacionporplan__c==System.Label.LTE_Renovacion){
                system.debug('Ingreso');
        clsClase.strTipoRenovRepo=System.Label.LTE_Equipo;
                clsClase.objDetOferta.LTE_ReferenciaEquipo__c = objEquipo.Id;
                clsClase.obtenerValorEquipo();
                system.debug(clsClase.objDetOferta.LTE_ReferenciaEquipo__c);
		
          clsClase.validarCamposRequeridosIntegracionVMR(objOpComercial);

      }

      clsClase.cargarSecciones();
      clsClase.strTipoRenovRepo = 'Equipo';
      clsClase.strTipoSuspension = 'Voluntaria';
      clsClase.objOpCom.Caso__c = objCaso.Id;
      //Test.startTest();
            
            
          clsClase.guardarOperacionComercial();
          LTE_CreacionOperacionesComerciales_ctr.diasTranscurridos(9999999);
          clsClase.validaEstado();
        
        LTE_CreacionOperacionesComerciales_ctr.envioReporteHurto(objOpComercial.id);
      
    }
  Test.stopTest();
         
  }
  
  /*static testMethod void myUnitTest2() {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','2');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c+'');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoTramite','Suspension Voluntaria');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoFlujo','2');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroDocumento',objAccount.AccountNumber);
        LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoDocumento',objAccount.Tipodedocumento__c);
        LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento'); 
        
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
        LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
        cls.consultarSuspensionSevicios(new set<String>{objServicio.Id}, 'Suspensión, Voluntaria', true, null);
    }
    
    static testMethod void myUnitTest3() {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('codigo','2');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('numeroConexion',objServicio.NumeroConexion__c+'');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('tipoTramite','Suspensión, Voluntaria');
        
        //Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
        LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
        cls.consultarSuspensionSevicios(new set<String>{objServicio.Id}, 'Suspensión, Voluntaria', true, null);
        Test.stopTest();
    }*/
  
  
}