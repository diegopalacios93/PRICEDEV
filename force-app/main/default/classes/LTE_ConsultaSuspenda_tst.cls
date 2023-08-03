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
private class LTE_ConsultaSuspenda_tst {
	
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
	public static Equipo__c objEquipoTraido;
	public static Planes__c objPlan;
	public static Planes__c objPlanPrepago;
	public static Planes__c objPlanMedida;
	public static Planes__c objPlanMedida2;
	public static ActivoETB__c objServicio;
	public static ActivoETB__c objServicio2;
	public static ActivoETB__c objServicio3;
	public static ActivoETB__c objServicio4;
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
	public static LTE_DetalleOferta__c objDetalleOferta2;
	public static LTE_DetalleOferta__c objDetalleOferta3;
	public static VariablesGlobales__c objVariables;
	public static HomologacionMetodosReclamacion__c objMetodosReclamacion;
	public static HomologacionCampos__c objHomologacionCampos;
	public static ServiciosWeb__c objServicioWeb;
	public static ServiciosWeb__c objServicioWeb2;
	public static Perfiles_Acciones__c objPerfiles;
	public static Perfiles_Reglas_OC__c objRegalsOC;
	public static Case objCaso;
	public static LTE_NivelesDescuento__c objNivelDescuentoPlan;
	public static LTE_NivelesDescuento__c objNivelDescuentoVoz;
	public static LTE_NivelesDescuento__c objNivelDescuentoDatos;
	public static LTE_NivelesDescuento__c objNivelDescuentoPlan2;
	public static LTE_NivelesDescuento__c objNivelDescuentoBorrar2;
	public static LTE_NivelesDescuento__c objNivelDescuentoBorrar3;
	public static LTE_NivelesDescuento__c objNivelDescuentoBorrar4;
	public static LTE_NivelesDescuento__c objNivelDescuentoBorrar5;
	public static SubPlanFacturacion__c objSubPlanFacturacionDatos;
	public static SubPlanFacturacion__c objSubPlanFacturacionVoz;
	public static PlanFacturacion__c objPlanFacturacion;
	public static LTE_ConsultaSuspenda__c tram;
    public static LTE_TramitesSuspenda__c tramiteSuspenda;    
	public static List<VariablesGlobales__c> lstVariablesGlobales;

	public static void CreateData()
    {
		lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'CambioPlanRegxPag';
        vGlobal.Valor__c = '5';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'RolLTECambioPlan';
        vGlobal.Valor__c = 'Total';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;

		/*objMetodosReclamacion = new HomologacionMetodosReclamacion__c();
		objMetodosReclamacion.Name = 'Gobierno Distrital-Mediana';
		objMetodosReclamacion.MetodoReclamacion__c = '0006';
		insert objMetodosReclamacion;

		objHomologacionCampos = new HomologacionCampos__c();
		objHomologacionCampos.Name = 'NIT';
		objHomologacionCampos.Valor__c = 'JURIDICO';
		insert objHomologacionCampos;
		*/
		objServicioWeb = new ServiciosWeb__c();
		objServicioWeb.Name = 'SuspendaConsulta';
		objServicioWeb.EndPoint__c = 'http://201.245.171.162:7053/Service.serviceagent/portTypeSuspensionsReconnectionsEndpoint';
		objServicioWeb.Action__c = '/Service/Service.serviceagent//ConsultaSuspendaOp';
		insert objServicioWeb;
		
		objServicioWeb2 = new ServiciosWeb__c();
		objServicioWeb2.Name = 'SuspendaRegistro';
		objServicioWeb2.EndPoint__c = 'http://201.245.171.162:7053/Service.serviceagent/portTypeSuspensionsReconnectionsEndpoint';
		objServicioWeb2.Action__c = '/Service/Service.serviceagent//RegistroSuspendaOp';
		insert objServicioWeb2;

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
		objTOPP.Activo__c = true;
		insert objTOPP;

        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Suspensión- TELEFONIA MOVIL (LTE)';
        objTOPP2.TipodeOperacionporplan__c = 'Suspensión';
        objTOPP2.Tipoderegistro__c = 'Suspension_Reconexion';
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = true;
        objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
        objTOPP2.Activo__c = true;
        insert objTOPP2;
    
		objEquipo = new Equipo__c();
		objEquipo.Name = 'Ascend G6 Negro';
		objEquipo.LTE_PartNumber__c = '129456789987654';
		objEquipo.LTE_Marca__c = 'Huawei';
		objEquipo.LTE_Color__c = 'Negro';
		objEquipo.Valor_del_Equipo__c = 395689;
		objEquipo.LTE_IVA__c = 63310;
		objEquipo.LTE_PrecioConIVA__c = 459000;
		objEquipo.LTE_Activo__c = true;
		insert objEquipo;
		
		objEquipoTraido = new Equipo__c();
		objEquipoTraido.Name = 'Equipo Traido';
		objEquipoTraido.LTE_PartNumber__c = '3456786543';
		objEquipoTraido.LTE_Marca__c = 'Dummy';
		objEquipoTraido.LTE_Color__c = 'Negro';
		objEquipoTraido.Valor_del_Equipo__c = 0;
		objEquipoTraido.LTE_IVA__c = 0;
		objEquipoTraido.LTE_PrecioConIVA__c = 0;
		objEquipoTraido.LTE_Activo__c = true;
		insert objEquipoTraido;

		objPlan = new Planes__c ();
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
		
		objPlanFacturacion = new PlanFacturacion__c();
		//objPlanFacturacion.CatalogoProductosFacturacion__c = objProducto.Id;
		objPlanFacturacion.LTE_NetworkIndicator__c = 'false';
		objPlanFacturacion.LTE_PrimaryClassificationCode__c = 'LTE Control Plan Class';
		objPlanFacturacion.LTE_ServiceIndicator__c = 'false';
		objPlanFacturacion.LTE_TipoControl__c = 'Control';
		objPlanFacturacion.LTE_TypeCode__c = 'PRODUCT';
		objPlanFacturacion.Name = 'PLAN NEGOCIOS POSPAGO M';
		objPlanFacturacion.Plan__c = objPlan.Id;
		insert objPlanFacturacion;

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
		objOpComercial.Estado__c = 'Activa';
		objOpComercial.NumeroConexion__c = '3057000501';
		objOpComercial.FechadeActivacion__c = system.today();
		objOpComercial.Legalizacion__c = objLegalizacion.Id;
		insert objOpComercial;

        objOpComercial2 = new OperacionComercial__c();
        objOpComercial2.CuentaCliente__c = objAccount.Id;
        objOpComercial2.Activo__c = objServicio.Id;
        objOpComercial2.Plan__c = objPlan.Id;
        objOpComercial2.TOPP__c = objTOPP2.Id;
        objOpComercial2.Oportunidad__c = objOportunidad.Id;
        objOpComercial2.Estado__c = 'En Curso';
        objOpComercial2.NumeroConexion__c = '3057000501';
       	objOpComercial2.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial2.FechadeActivacion__c = system.today();
        objOpComercial2.Legalizacion__c = objLegalizacion.Id;
        objOpComercial2.TipoSuspension__c = 'Voluntaria';
        Date fecha = Date.today().addDays(1);
		String strMes = '0'+fecha.month();
		strMes = strMes.subString(strMes.length()-2, strMes.length());
		String strDia = '0'+fecha.day();
		strDia = strDia.subString(strDia.length()-2, strDia.length());
		String strFecha = fecha.year() + '-' + strMes + '-' + strDia;
        objOpComercial2.FechaInicioReconexion__c = Date.valueOf(strFecha);
        insert objOpComercial2;
        
        tram = new LTE_ConsultaSuspenda__c();
		tram.name = 'Suspensión, Voluntaria';
		tram.Valor__c = 'Suspension Voluntaria';
		insert tram;

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
		
		objServicio.LTE_DetalleOferta__c = objDetalleOferta.id;
		upsert objServicio;

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
        
        
        objPlanPrepago = new Planes__c ();
		objPlanPrepago.Name = 'PLAN PAGO POR USO PREPAGO';
		objPlanPrepago.NombredelProducto__c = objProducto.Id;
		objPlanPrepago.TipodePlan__c = 'Principal';
		objPlanPrepago.Tarifa__c = 0;
		objPlanPrepago.Estado__c = 'Activo';
		objPlanPrepago.Descripcion__c = 'Plan prepago';
		objPlanPrepago.CondicionesComerciales__c = 'Plan prepago';
		objPlanPrepago.LTE_PlanEstructurados__c = true;
		objPlanPrepago.LTE_TipoControl__c = 'Prepago';
		insert objPlanPrepago;
		
		objPlanMedida = new Planes__c ();
		objPlanMedida.Name = 'PLAN A LA MEDIDA POSPAGO EMPRESAS';
		objPlanMedida.NombredelProducto__c = objProducto.Id;
		objPlanMedida.TipodePlan__c = 'Principal';
		objPlanMedida.Tarifa__c = 0;
		objPlanMedida.Estado__c = 'Activo';
		objPlanMedida.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales Tarifa para consumo de la recarga Tarificacion por segundo ';
		objPlanMedida.CondicionesComerciales__c = 'La tarifa es todo destino Moviles y Fijos Nacionales Tarifa para consumo de la recarga Tarificacion por segundo';
		objPlanMedida.LTE_PlanEstructurados__c = false;
		objPlanMedida.LTE_TipoControl__c = 'Abierto';
		insert objPlanMedida;
		
		objPlanMedida2 = new Planes__c ();
		objPlanMedida2.Name = 'PLAN A LA MEDIDA CONTROL EMPRESAS';
		objPlanMedida2.NombredelProducto__c = objProducto.Id;
		objPlanMedida2.TipodePlan__c = 'Principal';
		objPlanMedida2.Tarifa__c = 0;
		objPlanMedida2.Estado__c = 'Activo';
		objPlanMedida2.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales Tarifa para consumo de la recarga Tarificación por segundo';
		objPlanMedida2.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales Tarifa para consumo de la recarga Tarificación por segundo';
		objPlanMedida2.LTE_PlanEstructurados__c = false;
		objPlanMedida2.LTE_TipoControl__c = 'Control';
		insert objPlanMedida2;
		
		objServicio3 = new ActivoETB__c();
		objServicio3.Oportunidad__c = objOportunidad.Id;
        objServicio3.NombredelaCuenta__c = objAccount.Id;
        objServicio3.Plan__c = objPlanPrepago.Id;
        objServicio3.Estado__c = 'Activo';
        objServicio3.IMEI_del_Equipo__c = '525490131206095';
        objServicio3.LTE_ICCID__c = '5254901312060';
        objServicio3.NumeroConexion__c = '3057000502';
        objServicio3.Fecha_Activacion__c = system.now();
        insert objServicio3;
		
		objOpComercial3 = new OperacionComercial__c();
		objOpComercial3.CuentaCliente__c = objAccount.Id;
		objOpComercial3.Activo__c = objServicio3.Id;
		objOpComercial3.Plan__c = objPlanPrepago.Id;
		objOpComercial3.TOPP__c = objTOPP.Id;
		objOpComercial3.Oportunidad__c = objOportunidad.Id;
		objOpComercial3.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial3.Estado__c = 'Activa';
		objOpComercial3.NumeroConexion__c = '3057000502';
		objOpComercial3.FechadeActivacion__c = system.today();
		objOpComercial3.Legalizacion__c = objLegalizacion.Id;
		insert objOpComercial3;
		
		objDetalleOferta2 = new LTE_DetalleOferta__c();
		objDetalleOferta2.LTE_OperacionComercial__c = objOpComercial3.Id;
		objDetalleOferta2.LTE_Cliente__c = objAccount.Id;
		objDetalleOferta2.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta2.LTE_Estado__c = 'Pendiente';
		objDetalleOferta2.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta2.LTE_ReferenciaEquipo__c = objEquipo.Id;
		objDetalleOferta2.LTE_IMEI__c = '525490131206095';
		objDetalleOferta2.LTE_ICCID__c = '5254901312060';
		objDetalleOferta2.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta2.Plan__c = objPlanPrepago.Id;
		insert objDetalleOferta2;
		
		objServicio3.LTE_DetalleOferta__c = objDetalleOferta2.id;
		upsert objServicio3;
		
		objServicio4 = new ActivoETB__c();
		objServicio4.Oportunidad__c = objOportunidad.Id;
        objServicio4.NombredelaCuenta__c = objAccount.Id;
        objServicio4.Plan__c = objPlanMedida.Id;
        objServicio4.Estado__c = 'Activo';
        objServicio4.IMEI_del_Equipo__c = '986499009115074';
        objServicio4.LTE_ICCID__c = '9864990091150';
        objServicio4.NumeroConexion__c = '3057000503';
        objServicio4.Fecha_Activacion__c = system.now();
        insert objServicio4;
		
		objOpComercial4 = new OperacionComercial__c();
		objOpComercial4.CuentaCliente__c = objAccount.Id;
		objOpComercial4.Activo__c = objServicio4.Id;
		objOpComercial4.Plan__c = objPlanMedida.Id;
		objOpComercial4.TOPP__c = objTOPP.Id;
		objOpComercial4.Oportunidad__c = objOportunidad.Id;
		objOpComercial4.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial4.Estado__c = 'Activa';
		objOpComercial4.NumeroConexion__c = '3057000503';
		objOpComercial4.FechadeActivacion__c = system.today();
		objOpComercial4.Legalizacion__c = objLegalizacion.Id;
		insert objOpComercial4;
		
		objDetalleOferta3 = new LTE_DetalleOferta__c();
		objDetalleOferta3.LTE_OperacionComercial__c = objOpComercial4.Id;
		objDetalleOferta3.LTE_Cliente__c = objAccount.Id;
		objDetalleOferta3.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta3.LTE_Estado__c = 'Pendiente';
		objDetalleOferta3.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta3.LTE_ReferenciaEquipo__c = objEquipo.Id;
		objDetalleOferta3.LTE_IMEI__c = '986499009115074';
		objDetalleOferta3.LTE_ICCID__c = '9864990091150';
		objDetalleOferta3.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta3.Plan__c = objPlanMedida.Id;
		insert objDetalleOferta3;
		
		objServicio4.LTE_DetalleOferta__c = objDetalleOferta3.id;
		upsert objServicio4;
        
        
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
        
        tramiteSuspenda = new LTE_TramitesSuspenda__c();
        tramiteSuspenda.Name = 'Suspensión, Voluntaria';
        tramiteSuspenda.LTE_Estado__c = 'Suspendido';
        tramiteSuspenda.LTE_Causal__c = 'Fraude';
        insert tramiteSuspenda;
		
		List<Case> lstCasos = new List<Case>();
		lstCasos = [SELECT AccountId, AccountNumber__c, Fechaderadicacion__c, Operadores__c, RecordTypeId, Origin, Plan__c, Status, Causal_Estado__c, Subject, ContactId, Aprobaciones__c, CaseNumber FROM Case WHERE Id = :objCaso.Id];
		objCaso = lstCasos.get(0);
	
		
		
    }

	static testMethod void myUnitTest2() {
		CreateData();
		Test.startTest();
		/*LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('codigo','2');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('numeroConexion',objServicio.NumeroConexion__c+'');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('tipoTramite','Suspensión, Voluntaria');
        
    	//Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());*/
    	//LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c);
		//LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoTramite','Suspension Voluntaria');
		//LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoDocumento',objAccount.Tipodedocumento__c);
		//LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroDocumento',objAccount.AccountNumber);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','2');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoFlujo','2');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento'); 
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
		//Test.stopTest();
		
		LTE_ConsultaSuspenda_bch bch = new LTE_ConsultaSuspenda_bch();
		Database.executeBatch(bch,1);        
		Test.stopTest();
    }      
    static testMethod void myUnitTest() {
		CreateData();
		Test.startTest();
		
    	LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('IdPedido',objOpComercial.Id);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','1');
   		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRegistroSuspenda());
		LTE_ConsultaSuspenda_bch bch = new LTE_ConsultaSuspenda_bch();
		Database.executeBatch(bch,1);
		Test.stopTest();
    }
    
    /*static testMethod void myUnitTest3() {
		CreateData();
		Test.startTest();
		
    	LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoTramite','Suspension Voluntaria');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoDocumento',objAccount.Tipodedocumento__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroDocumento',objAccount.AccountNumber);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','1');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoFlujo','3');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento'); 
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
		LTE_ConsultaSuspenda_bch bch = new LTE_ConsultaSuspenda_bch();
		Database.executeBatch(bch,1);
		Test.stopTest();
    }
    
    static testMethod void myUnitTest4() {
		CreateData();
		Test.startTest();
		
    	LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoTramite','Suspension Voluntaria');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoDocumento',objAccount.Tipodedocumento__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroDocumento',objAccount.AccountNumber);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','1');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoFlujo','4');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento'); 
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
		LTE_ConsultaSuspenda_bch bch = new LTE_ConsultaSuspenda_bch();
		Database.executeBatch(bch,1);
		Test.stopTest();
    }

    static testMethod void myUnitTest() {
		CreateData();
		Test.startTest();
		
    	LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroConexion',objServicio.NumeroConexion__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoTramite','Suspension Voluntaria');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('TipoDocumento',objAccount.Tipodedocumento__c);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('NumeroDocumento',objAccount.AccountNumber);
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoRespuesta','1');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionRespuesta','Consulta Exitosa - Sin Datos en Suspenda');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('CodigoFlujo','1');
		LTE_MockServiciosWebLTE_cls.variablesMock.put('DescripcionFlujo','Aprovisionamiento'); 
		
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseConsultaSuspenda());
		LTE_ConsultaSuspenda_bch bch = new LTE_ConsultaSuspenda_bch();
		Database.executeBatch(bch,1);
		Test.stopTest();
    }*/
    
    
}