/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class LTE_OCL_tst {

  public static Account objAccount;
  public static Contract objContrato;
  public static Poblacion__c objDepto;
  public static Poblacion__c objMunicipio;
  public static CuentaFacturacion__c objCtaFact;
  public static Contact objContact;
  public static Opportunity objOportunidad;
  public static Opportunity objOportunidad2;
  public static Legalizacion__c objLegalizacion;
  public static CatalogoProductos__c objProducto;
  public static TOPP__c objTOPP;
  public static TOPP__c objTOPP2;
  public static TOPP__c objTOPP3;
  public static TOPP__c objTOPP4;
  public static TOPP__c objTOPP5;
  public static Equipo__c objEquipo;
  public static Equipo__c objEquipo2;
  public static Planes__c objPlan;
  public static Planes__c objPlan1;
  public static Planes__c objPlan2;
  public static Planes__c objPlan3;
  public static PlanFacturacion__c  objPlanFac;
  public static ActivoETB__c objServicio;
  public static VariablesGlobales__c varGlo;
  public static ActivoETB__c objServicio2;
  public static ActivoETB__c objServicio3;
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
  public static OperacionComercial__c objOpComercial3;
  public static OperacionComercial__c objOpComercial4;
  public static Reserva__c objOferta;
  public static LTE_DetalleOferta__c objDetalleOferta;
  public static VariablesGlobales__c objVariables;
  public static VariablesGlobales__c objVariables1;
  public static VariablesGlobales__c objVariables2;
  public static VariablesGlobales__c objVariables3;
  public static VariablesGlobales__c objVariables4;
  public static HomologacionMetodosReclamacion__c objMetodosReclamacion;
  public static HomologacionCampos__c objHomologacionCampos;
  public static ServiciosWeb__c objServicioWeb;
  public static Perfiles_Acciones__c objPerfiles;
  public static Perfiles_Reglas_OC__c objRegalsOC;
  public static Campos_Obligatorios_OC__c objCamposOb;    
  public static CatalogoProductosFacturacion__c catProdFac;
  public static CatalogoProductos__c catProd;          
  public static PlanFacturacion__c  objPlanFacturacion;
  public static PlanFacturacion__c  objPlanFacturacion2;
  public static SubPlanFacturacion__c  objSubPlanFacturacion;
  public static SubPlanFacturacion__c  objSubPlanFacturacion2;
  public static Viabilidad__c via;

  public static void CreateData()
    {
        objCamposOb = new Campos_Obligatorios_OC__c();
        objCamposOb.Name = 'R16Valorunicavez__c';
        objCamposOb.Nombre_API__c = 'Valorunicavez__c';
        objCamposOb.Obligatorio__c = true;
        objCamposOb.Tipo_de_Registro__c = 'R16';
        insert objCamposOb;
            
      catProd = new CatalogoProductos__c();
      catProd.CodigoProducto__c  = '76357369';
      catProd.Descripcion__c= 'prueba';
      catProd.Familia__c='LTE';
      catProd.LineaNegocio__c='Redes Móviles';
      catProd.Name='TELEFONIA MOVIL (LTE)';
      insert catProd;
      
      catProdFac = new CatalogoProductosFacturacion__c();
      catProdFac.LTE_ServiceIndicator__c='false';
      catProdFac.LTE_TypeCode__c='PRODUCT';
      catProdFac.Name='TELEFONIA MOVIL (LTE)';
      catProdFac.CatalogoProductos__c  =catProd.id;
      insert catProdFac;  
      
        objVariables = new VariablesGlobales__c();
        objVariables.Name = 'NombreComercialLTE';
        objVariables.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert objVariables;

        objVariables2 = new VariablesGlobales__c();
        objVariables2.Name = 'NombreDefaultaFacturacionLTE';
        objVariables2.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert objVariables2;
        
         objVariables1 = new VariablesGlobales__c();
        objVariables1.Name = 'NombreFacturacionLTE';
        objVariables1.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert objVariables1;  

        objVariables3 = new VariablesGlobales__c();
        objVariables3.Name = 'NombreComercialAPN';
        objVariables3.Valor__c = 'APN CORPORATIVO';
        insert objVariables3;
        
        objVariables4 = new VariablesGlobales__c();
        objVariables4.Name = 'NumeracionAbreviada';
        objVariables4.Valor__c = 'Numeración Abreviada';
        insert objVariables4;
        
        
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
      objAccount.Segmento__c = 'Gobierno Distrital';
      objAccount.SubSegmento__c = 'Mediana';   
      objAccount.Phone = '3133332525';  
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
      //objOportunidad.StageName = 'Cerrada Ganada';
      objOportunidad.CloseDate = system.today();
      objOportunidad.Amount = 1000;
      objOportunidad.Valor_unica_vez_ETB__c = 150;
      objOportunidad.LTE_Scoring__c = 9000000;
      objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
      objOportunidad.LTE_NumeroLinea__c = 2;
      insert objOportunidad;
      
      objOportunidad2 = new Opportunity();
      objOportunidad2.Name = 'Test name';
      objOportunidad2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
      objOportunidad2.AccountId = objAccount.Id;
      objOportunidad2.StageName = 'Análisis de necesidades';
      objOportunidad2.CloseDate = system.today();
      objOportunidad2.Amount = 1000;
      objOportunidad2.Valor_unica_vez_ETB__c = 150;
      objOportunidad2.LTE_Scoring__c = 9000000;
      objOportunidad2.LTE_FechaConsultaDatacredito__c = system.today();
      objOportunidad2.LTE_NumeroLinea__c = 2;
      insert objOportunidad2;

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
      objTOPP.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
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
        objTOPP5.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        objTOPP5.TipodeOperacionporplan__c = 'Cambio de Plan';
        objTOPP5.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP5.Facturable__c = true;
        objTOPP5.LTE_Parte_caso__c = true;
        objTOPP5.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP5;

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
        
      objEquipo2 = new Equipo__c();
      objEquipo2.Name = 'Equipo Traido';
      objEquipo2.LTE_PartNumber__c = '1294567899800000';
      objEquipo2.LTE_Marca__c = 'sin Marca';
      objEquipo2.LTE_Color__c = 'Negro';
      objEquipo2.Valor_del_Equipo__c = 395689;
      objEquipo2.LTE_IVA__c = 63310;
      objEquipo2.LTE_PrecioConIVA__c = 459000;
      objEquipo2.LTE_Activo__c=true; // JDUR 2016-01-12
      insert objEquipo2;

      objPlan1 = new Planes__c ();
      objPlan1.Name = system.label.PLANDEPAGOS;
      objPlan1.NombredelProducto__c = objProducto.Id;
      objPlan1.TipodePlan__c = 'Principal';
      objPlan1.Tarifa__c = 96000;
      objPlan1.Estado__c = 'Activo';
      objPlan1.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan1.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan1.LTE_PlanEstructurados__c = true;
      insert objPlan1;

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
      objPlan2.Name = 'PLAN NEGOCIOS POSPAGO M';
      objPlan2.NombredelProducto__c = objProducto.Id;
      objPlan2.TipodePlan__c = 'Principal';
      objPlan2.Tarifa__c = 96000;
      objPlan2.Estado__c = 'Activo';
      objPlan2.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan2.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan2.LTE_PlanEstructurados__c = true;
      insert objPlan2;
      
      objPlan3 = new Planes__c ();
      objPlan3.Name = 'Troncal SIP Móvil Alterna';
      objPlan3.NombredelProducto__c = objProducto.Id;
      objPlan3.TipodePlan__c = 'Principal';
      objPlan3.Tarifa__c = 96000;
      objPlan3.Estado__c = 'Activo';
      objPlan3.Descripcion__c = 'Troncal SIP Movil ALterna';
      objPlan3.CondicionesComerciales__c = 'Servicio alterno';
      objPlan3.LTE_PlanEstructurados__c = true;
      insert objPlan3;
   
       objPlanFacturacion = new PlanFacturacion__c();
      objPlanFacturacion.Plan__c = objPlan.id;
      objPlanFacturacion.name='PLAN NEGOCIOS POSPAGO M';
      //objPlanFacturacion.CatalogoProductosFacturacion__c
      insert objPlanFacturacion;


       objPlanFacturacion2 = new PlanFacturacion__c();
      objPlanFacturacion2.Plan__c = objPlan1.id;
      objPlanFacturacion2.name='PLAN NEGOCIOS POSPAGO M';
      //objPlanFacturacion.CatalogoProductosFacturacion__c
      insert objPlanFacturacion2;
        
      objSubPlanFacturacion = new SubPlanFacturacion__c();
      objSubPlanFacturacion.name='SUB PLAN NEGOCIOS POSPAGO M';
      objSubPlanFacturacion.Codigo__C='12345';
      insert objSubPlanFacturacion;
      
      objSubPlanFacturacion2 = new SubPlanFacturacion__c();
      objSubPlanFacturacion2.name='Troncal SIP Canales';
      objSubPlanFacturacion2.Codigo__C='1234566';
      objSubPlanFacturacion2.LTE_TipoSubplan__c  = 'Bolsa de Datos a la medida';      
      objSubPlanFacturacion2.PlanFacturacion__r = objPlanFacturacion2;
      insert objSubPlanFacturacion2;
        
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

      objServicio3 = new ActivoETB__c();
      objServicio3.Oportunidad__c = objOportunidad.Id;
      objServicio3.CuentaFacturacion__r = objCtaFact;   
      objServicio3.NombredelaCuenta__c = objAccount.Id;
      objServicio3.Plan__c = objPlan.Id;
      objServicio3.Estado__c = 'Activo';
      objServicio3.IMEI_del_Equipo__c = '980684862113805';
      objServicio3.LTE_ICCID__c = '8957187113000000506';
      objServicio3.NumeroConexion__c = '3057000501';
      objServicio3.Fecha_Activacion__c = system.now();
      insert objServicio3;
      
      objOpComercial = new OperacionComercial__c();
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
	  
      objOpComercial3 = new OperacionComercial__c();
      objOpComercial3.CuentaCliente__c = objAccount.Id;
      objOpComercial3.Activo__c = objServicio3.Id;
      objOpComercial3.Plan__c = objPlan3.Id;
      objOpComercial3.Plan__r = objPlan3;
      objOpComercial3.Servicio_ETB_Relacionado_Principal__r = objServicio3;  
      objOpComercial3.TOPP__c = objTOPP5.Id;
      //objOpComercial.Portacion__c = true;
      objOpComercial3.Oportunidad__c = objOportunidad.Id;        
      objOpComercial3.Oportunidad__r = objOportunidad;
      objOpComercial3.CuentaFacturacion__c = objCtaFact.Id;
      objOpComercial3.Estado__c = 'Pendiente';
      objOpComercial3.NumeroConexion__c = '3057000501';
      objOpComercial3.Activo__r = objServicio;
      objOpComercial3.FechadeActivacion__c = system.today();
      objOpComercial3.Legalizacion__c = objLegalizacion.Id;
      insert objOpComercial3;
      /*  
      objOpComercial4 = new OperacionComercial__c();
      objOpComercial4.CuentaCliente__c = objAccount.Id;
      objOpComercial4.Activo__c = objServicio3.Id;
      objOpComercial4.Plan__c = objPlan3.Id;
      objOpComercial4.Plan__r = objPlan3;
      objOpComercial4.Servicio_ETB_Relacionado_Principal__r = objServicio3;  
      objOpComercial4.TOPP__c = objTOPP5.Id;
      //objOpComercial.Portacion__c = true;
      objOpComercial4.Oportunidad__c = objOportunidad.Id;        
      objOpComercial4.Oportunidad__r = objOportunidad;
      objOpComercial4.CuentaFacturacion__c = objCtaFact.Id;
      objOpComercial4.Estado__c = 'Pendiente';
      objOpComercial4.NumeroConexion__c = '3057000501';
      objOpComercial4.Activo__r = objServicio;
      objOpComercial4.FechadeActivacion__c = system.today();
      objOpComercial4.Legalizacion__c = objLegalizacion.Id;
      insert objOpComercial4;*/
      
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
        
        via = new Viabilidad__c();
        via.OperacionComercial__C = objOpComercial3.id;
        insert via;
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'search5';
        document.IsPublic = true;
        document.Name = 'search';
        document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].id;
        insert document; 
    }
  
    static testMethod void myUnitTest() {
        CreateData();
        objOportunidad.StageName = 'Cerrada Ganada';
        update objOportunidad;
        
        objOpComercial.Legalizacion__c = null;
        update objOpComercial;
        
        objOpComercial3.Legalizacion__c = null;
        update objOpComercial3;
        
        Test.startTest();
            Pagereference vfTest = Page.LTE_OCL_pag;
            Test.setCurrentPage(vfTest);
            LTE_OCL_ctr clsClase = new LTE_OCL_ctr();
            ApexPages.currentPage().getParameters().put( 'id', 'xxxxxxxx' );     
            clsClase = new LTE_OCL_ctr();
            ApexPages.currentPage().getParameters().put( 'id', '800230000005Rvn' );     
            clsClase = new LTE_OCL_ctr();
            ApexPages.currentPage().getParameters().put( 'id', objContrato.Id );     
            clsClase = new LTE_OCL_ctr();
            System.Debug('=======> total_size: ' + clsClase.total_size);
            LTE_OCL_ctr.wrpOc wrpOcClass = new LTE_OCL_ctr.wrpOc(objOpComercial);
        wrpOcClass.check=true;
            LTE_OCL_ctr.wrpOpp wrpOppClass = new LTE_OCL_ctr.wrpOpp(objOportunidad);
            clsClase.CrearLegalizacion();
            //clsClase.ObtenerOperacionesComerciales();
            //clsClase.ProcesarOportunidades();
            clsClase.setLstWrapper();
            clsClase.getLstWrapper();
            clsClase.CrearLegalizacion();
            LTE_RangoFactura__c LTE_RangoFactura = new LTE_RangoFactura__c();
            LTE_RangoFactura.Name = 'FactEquiposLTE';
            LTE_RangoFactura.Inicio_Rango__c = 970000000001.00;
            insert LTE_RangoFactura;
            clsClase.CrearLegalizacion();
            clsClase.getCuentaFact();
            clsClase.ventaEquiposLte(objLegalizacion.id);
            String titulo = clsClase.titulo;
            String subTitulo = clsClase.subtitulo;
            Boolean RenderBotonCrear = clsClase.RenderBotonCrear;
            clsClase.ValidarOperacionModificada(objOpComercial);
            clsClase.ValidarOperacionDiligenciada(objOpComercial);
        	clsClase.obtenerFechaCorte(27);	
			clsClase.obtenerPlanFacturacionId(objOpComercial.Plan__c);
        	clsClase.obtenerPlanFacturacionName(objOpComercial.Plan__c, 'Name');
        	clsClase.obtenerSubPlanFacturacionName(objSubPlanFacturacion.Id, 'Name');
        	clsClase.obtenerCicloFacturacion(objOpComercial3.CuentaFacturacion__c);
        	clsClase.creaOCCambioPlanACPrincipal(objOpComercial3);
        	clsClase.obtenerFlagOCCreadaOportunidad(objOpComercial3.Oportunidad__r.id);    
        	//clsClase.ValidarCamposOperacion(objOpComercial3);
            //clsClase.cambiarPaginacion();
            //clsClase.actualizaSeleccion();
            //clsClase.getPaginas();
            //clsClase.setPaginas(1);
            //clsClase.Beginning();
            //clsClase.Previous();
            //clsClase.Next();
            //clsClase.End();
            //clsClase.getDisablePrevious();
            //clsClase.getDisableNext();
            //clsClase.getTotal_size();
            //clsClase.getPageNumber();
            //clsClase.getTotalPages();
            clsClase.Main();
            
        Test.stopTest();
    }
}