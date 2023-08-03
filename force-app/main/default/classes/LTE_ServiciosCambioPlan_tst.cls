/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para el controlador LTE_ServiciosCambioPlan_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2015-12-18      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_ServiciosCambioPlan_tst {
	
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
        
        
        insert new LTE_Planes_Compuestos__c(Name='PLAN A LA MEDIDA CONTROL EMPRESAS',MinutosVoz__c='BOLSA DE VOZ 1000 MIN', DatosNavegacion__c= 'BOLSA DE DATOS 5GB');

		/*objMetodosReclamacion = new HomologacionMetodosReclamacion__c();
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
		insert objServicioWeb;*/

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
		objContact.Phone = '12345678';
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

        /*objTOPP3 = new TOPP__c();
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
        insert objTOPP4;*/
        
        objTOPP5 = new TOPP__c();
        objTOPP5.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        objTOPP5.TipodeOperacionporplan__c = 'Cambio de Plan';
        objTOPP5.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP5.Facturable__c = true;
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
        objPlanMedida.LTE_Es_Plan_Compuesto__c = true;
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
        objPlanMedida2.LTE_Es_Plan_Compuesto__c = true;
		insert objPlanMedida2;
		
		//objServicio3 = new ActivoETB__c();
		//objServicio3.Oportunidad__c = objOportunidad.Id;
        //objServicio3.NombredelaCuenta__c = objAccount.Id;
        //objServicio3.Plan__c = objPlanPrepago.Id;
        //objServicio3.Estado__c = 'Activo';
        //objServicio3.IMEI_del_Equipo__c = '525490131206095';
        //objServicio3.LTE_ICCID__c = '5254901312060';
        //objServicio3.NumeroConexion__c = '3057000502';
        //objServicio3.Fecha_Activacion__c = system.now();
        //insert objServicio3;
		
		//objOpComercial3 = new OperacionComercial__c();
		//objOpComercial3.CuentaCliente__c = objAccount.Id;
		//objOpComercial3.Activo__c = objServicio3.Id;
		//objOpComercial3.Plan__c = objPlanPrepago.Id;
		//objOpComercial3.TOPP__c = objTOPP.Id;
		//objOpComercial3.Oportunidad__c = objOportunidad.Id;
		//objOpComercial3.CuentaFacturacion__c = objCtaFact.Id;
		//objOpComercial3.Estado__c = 'Activa';
		//objOpComercial3.NumeroConexion__c = '3057000502';
		//objOpComercial3.FechadeActivacion__c = system.today();
		//objOpComercial3.Legalizacion__c = objLegalizacion.Id;
		//insert objOpComercial3;
		
		//objDetalleOferta2 = new LTE_DetalleOferta__c();
		//objDetalleOferta2.LTE_OperacionComercial__c = objOpComercial3.Id;
		//objDetalleOferta2.LTE_Cliente__c = objAccount.Id;
		//objDetalleOferta2.LTE_Oferta_Economica__c = objOferta.Id;
		//objDetalleOferta2.LTE_Estado__c = 'Pendiente';
		//objDetalleOferta2.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		//objDetalleOferta2.LTE_ReferenciaEquipo__c = objEquipo.Id;
		//objDetalleOferta2.LTE_IMEI__c = '525490131206095';
		//objDetalleOferta2.LTE_ICCID__c = '5254901312060';
		//objDetalleOferta2.LTEValorEquipoDescuento__c = 458999;
		//objDetalleOferta2.Plan__c = objPlanPrepago.Id;
		//insert objDetalleOferta2;
		
		//objServicio3.LTE_DetalleOferta__c = objDetalleOferta2.id;
		//upsert objServicio3;
		
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
		
		List<Case> lstCasos = new List<Case>();
		lstCasos = [SELECT AccountId, AccountNumber__c, Fechaderadicacion__c, Operadores__c, RecordTypeId, Origin, Plan__c, Status, Causal_Estado__c, Subject, ContactId, Aprobaciones__c, CaseNumber FROM Case WHERE Id = :objCaso.Id];
		objCaso = lstCasos.get(0);
		
		objNivelDescuentoPlan = new LTE_NivelesDescuento__c();
		objNivelDescuentoPlan.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoPlan.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoPlan.LTE_NoCuotasNivel2__c = 4;
		objNivelDescuentoPlan.LTE_DescuentoNivel2__c = 20;
		insert objNivelDescuentoPlan;
		
		objNivelDescuentoVoz = new LTE_NivelesDescuento__c();
		objNivelDescuentoVoz.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoVoz.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoVoz.LTE_NoCuotasNivel2__c = 7;
		objNivelDescuentoVoz.LTE_DescuentoNivel2__c = 15;
		insert objNivelDescuentoVoz;
		
		objNivelDescuentoDatos = new LTE_NivelesDescuento__c();
		objNivelDescuentoDatos.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoDatos.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoDatos.LTE_NoCuotasNivel2__c = 11;
		objNivelDescuentoDatos.LTE_DescuentoNivel2__c = 10;
		insert objNivelDescuentoDatos;
		
		objNivelDescuentoPlan2 = new LTE_NivelesDescuento__c();
		objNivelDescuentoPlan2.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoPlan2.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoPlan2.LTE_NoCuotasNivel2__c = 2;
		objNivelDescuentoPlan2.LTE_DescuentoNivel2__c = 60;
		insert objNivelDescuentoPlan2;
		
		objNivelDescuentoBorrar2 = new LTE_NivelesDescuento__c();
		objNivelDescuentoBorrar2.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoBorrar2.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoBorrar2.LTE_NoCuotasNivel2__c = 3;
		objNivelDescuentoBorrar2.LTE_DescuentoNivel2__c = 40;
		insert objNivelDescuentoBorrar2;
		
		objNivelDescuentoBorrar3 = new LTE_NivelesDescuento__c();
		objNivelDescuentoBorrar3.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoBorrar3.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoBorrar3.LTE_NoCuotasNivel2__c = 3;
		objNivelDescuentoBorrar3.LTE_DescuentoNivel2__c = 40;
		insert objNivelDescuentoBorrar3;
		
		objNivelDescuentoBorrar4 = new LTE_NivelesDescuento__c();
		objNivelDescuentoBorrar4.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoBorrar4.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoBorrar4.LTE_NoCuotasNivel2__c = 3;
		objNivelDescuentoBorrar4.LTE_DescuentoNivel2__c = 40;
		insert objNivelDescuentoBorrar4;
		
		objNivelDescuentoBorrar5 = new LTE_NivelesDescuento__c();
		objNivelDescuentoBorrar5.LTE_NoCuotasNivel1__c = 1;
		objNivelDescuentoBorrar5.LTE_DescuentoNivel1__c = 100;
		objNivelDescuentoBorrar5.LTE_NoCuotasNivel2__c = 3;
		objNivelDescuentoBorrar5.LTE_DescuentoNivel2__c = 40;
		insert objNivelDescuentoBorrar5;
		
		objSubPlanFacturacionDatos = new SubPlanFacturacion__c();
		objSubPlanFacturacionDatos.Codigo__c = 'DATOS A LA MEDIDA 10GB';
		objSubPlanFacturacionDatos.LTE_NetworkIndicator__c = 'false';
		objSubPlanFacturacionDatos.LTE_Precio__c = 85000;
		objSubPlanFacturacionDatos.LTE_PrimaryClassificationCode__c = 'LTE SVA Recurring Package Class';
		objSubPlanFacturacionDatos.LTE_ServiceIndicator__c = 'false';
		objSubPlanFacturacionDatos.LTE_TipoSubplan__c = 'Bolsa de Datos a la medida';
		objSubPlanFacturacionDatos.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanFacturacionDatos.MonedaExtranjera__c = false;
		objSubPlanFacturacionDatos.Name = 'DATOS A LA MEDIDA 10GB';
		insert objSubPlanFacturacionDatos;
		
		objSubPlanFacturacionVoz = new SubPlanFacturacion__c();
		objSubPlanFacturacionVoz.Codigo__c = '4';
		objSubPlanFacturacionVoz.LTE_NetworkIndicator__c = 'false';
		objSubPlanFacturacionVoz.LTE_Precio__c = 55000;
		objSubPlanFacturacionVoz.LTE_PrimaryClassificationCode__c = 'LTE SVA Recurring Package Class';
		objSubPlanFacturacionVoz.LTE_ServiceIndicator__c = 'false';
		objSubPlanFacturacionVoz.LTE_TipoSubplan__c = 'Bolsa de Voz a la medida';
		objSubPlanFacturacionVoz.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanFacturacionVoz.MonedaExtranjera__c = false;
		objSubPlanFacturacionVoz.Name = 'VOZ A LA MEDIDA 1000 MIN';
		insert objSubPlanFacturacionVoz;
		
		
    }
	
	
	
	
	
	
    static testMethod void myUnitTest(){
    	//Aca se crean los datos necesarios para la prueba
    	CreateData();
        
    	LTE_ServiciosCambioPlan_ctr testController;
    	Test.startTest();
    		PageReference pageRef = Page.LTE_ServiciosCambioPlan_pag;
	        Test.setCurrentPage(pageRef);
	        
	        ApexPages.currentPage().getParameters().put('estadoAprobacion', 'Oferta Realizada');
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        
	        ApexPages.currentPage().getParameters().put('estadoAprobacion', '');
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        
			
			//Se prueba el controlador de la pagina de tal manera que los parametros se vallan llendo nulos
			//hasta que al final se envian todos los parametros y pasa las validaciones iniciales del controlador
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idCase', objCaso.Id);
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idAccount', objCaso.AccountId);
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('caseNumber', objCaso.CaseNumber);
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idTOPP', objTOPP5.id);
	        
	        ApexPages.currentPage().getParameters().put('estadoAprobacion', objCaso.Aprobaciones__c);
	        
	        ApexPages.currentPage().getParameters().put('idContact', '00323000002L5Q6');
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        ApexPages.currentPage().getParameters().put('idContact', objCaso.ContactId);
	        testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
	        system.debug('controller creado');
    	
    		//Se hace la invocacion a los metodos del controlador de los servicios de cambio de plan
    		testController = new LTE_ServiciosCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
    		
    		testController.getCuentaFact();
    		
			//Se hace como si se hubiese seleccionado el check bos de Planes Homologados y Aplica Descuentos
    		testController.blnPlanesHomogeneos = false;
    		testController.mostrarPlanHomogeneo();
    		testController.blnPlanesHomogeneos = true;
    		testController.mostrarPlanHomogeneo();
    		testController.blnDctosHomogeneos = true;
			testController.mostrarDctoHomogeneo();
			
			//Se hace como si se hubiese seleccionado un plan en la casilla de plan homologado
			testController.objReservaHomogeneo.LTE_Plan__c = objPlan.Id;
			testController.objReservaHomogeneo.LTE_DescuentoDatos__c = objNivelDescuentoBorrar2.Id;
			testController.objReservaHomogeneo.LTE_DescuentoVoz__c = objNivelDescuentoBorrar3.Id;
			testController.ocultarDescuentoPlanHomogeneo();
    		
			//Se hace somo si se hubiese seleccionado un descuento al plan anterior
    		testController.strDescuentoType = 'DtoPlan';
    		testController.strDescuentoId = objNivelDescuentoPlan.Id;
			testController.strDescuentoName = objNivelDescuentoPlan.Name;
			testController.mostrarDescuento();
			
			//Se hace como si hubiesemos cambiado del plan anterior a un nuevo plan (Prepago)
			testController.objReservaHomogeneo.LTE_Plan__c = objPlanPrepago.Id;
			testController.ocultarDescuentoPlanHomogeneo();
    		
			//Se hace como si hubiesemos cambiado del plan anterior (Prepago) a un nuevo plan (a la medida)
    		testController.objReservaHomogeneo.LTE_Plan__c = objPlanMedida.Id;
			testController.ocultarDescuentoPlanHomogeneo();
			
			//Se hace somo si se hubiese seleccionado un descuento de voz
			testController.objReservaHomogeneo.LTE_MinutoVoz__c = objSubPlanFacturacionVoz.Id;
			testController.strDescuentoType = 'DtoVoz';
    		testController.strDescuentoId = objNivelDescuentoVoz.Id;
			testController.strDescuentoName = objNivelDescuentoVoz.Name;
			testController.mostrarDescuento();
			
			//Se hace somo si se hubiese seleccionado un descuento de datos
			testController.objReservaHomogeneo.LTE_DatosNavegacion__c = objSubPlanFacturacionDatos.Id;
			testController.strDescuentoType = 'DtoDato';
    		testController.strDescuentoId = objNivelDescuentoDatos.Id;
			testController.strDescuentoName = objNivelDescuentoDatos.Name;
			testController.mostrarDescuento();
    		
			//Se llama el metodo que se invoca cuando se da clic en el boton buscar pero como si no hubiesemos diginado ningun numero a buscar
    		testController.buscar();
    		testController.numerosConexion = 'xxxxxxx,yyyyyyy';
			//Se llama el metodo que se invoca cuando se da clic en el boton buscar pero como si hubiesemos digitado en numero xxxxxxx,yyyyyyy 
			//para que la consulta no traiga ningun resultado
    		testController.buscar();
			System.Debug('=====> Tamaño lstActivos con xxxxxxx,yyyyyyy: ' + testController.lstActivos.Size());
    		testController.numerosConexion = '3057000501,3057000502,3057000503';
			//Se llama el metodo que se invoca cuando se da clic en el boton buscar ahora si con datos correctos para continuar el proceso
    		testController.buscar();
			System.Debug('=====> Tamaño lstActivos con 3057000501,3057000502,3057000503: ' + testController.lstActivos.Size());
			
			//Se hace como si hubiesemos dado clic en la casilla de seleccionar todos
			testController.blnAllChecked = true;
			testController.seleccionarTodos();
    		
			//Se hace el llamado a todos los metodos de la paginacion
			Boolean blnAux;
			Integer intAux;
    		blnAux = testController.hasNext;
			blnAux = testController.hasPrevious;
			intAux = testController.pageNumber;
			
			testController.first();
			testController.last();
			testController.previous();
			testController.next();
			testController.cancel();
			testController.buscar();
			
			//Se hace somo si hubiesemos dado clic en seleccionar todo pero para que des-seleccione todos
			testController.blnAllChecked = false;
			testController.seleccionarTodos();
			//Se llama el metodo que se invoca cuando se da clic en el boton continuar pero en el paso anterior des-seleccionamos
			//todos los servicios.
			testController.continuar();
			
			//Se seleccionan nuevamente todos los servicios
			testController.blnAllChecked = true;
			testController.seleccionarTodos();
			System.debug('=================================================');
			System.debug('=================================================');
			System.debug(testController.lstActivosWrapper);
			System.debug('=================================================');
			System.debug('=================================================');
			
			
			//ACA  QUITO EL PLAN Y LOS SUBPLANES CON SUS DESCUENTO Y VUELVO A continuar A FACTURAR PARA CUBRIR MAS CODIGO
			//LUEGO VUELVO Y PONGO LOS PLANES Y TODO Y VUELVO A LLAMAR A continuar
			testController.objReservaHomogeneo = new Reserva__c();
			testController.continuar();
			testController.objReservaHomogeneo.LTE_Plan__c = objPlanMedida.Id;
			testController.objReservaHomogeneo.LTE_PlanMedida__c = true;
			testController.blnDctosHomogeneos = true;
			testController.continuar();
			
			testController.objReservaHomogeneo.LTE_Plan__c = objPlanPrepago.Id;
			testController.ocultarDescuentoPlanHomogeneo();
			testController.objReservaHomogeneo.LTE_PlanMedida__c = false;
			testController.objReservaHomogeneo.LTE_DescuentoPlan__c = null;
			testController.objReservaHomogeneo.LTE_DescuentoVoz__c = null;
    		testController.continuar();
			
    		testController.objReservaHomogeneo.LTE_Plan__c = objPlan.Id;
			testController.ocultarDescuentoPlanHomogeneo();
			testController.objReservaHomogeneo.LTE_DescuentoPlan__c = null;
			testController.objReservaHomogeneo.LTE_DescuentoVoz__c = null;
			testController.continuar();
			
			testController.blnDctosHomogeneos = false;
			testController.continuar();
			
			testController.blnDctosHomogeneos = true;
			testController.blnDctosHomogeneos = false;
			testController.continuar();
			testController.blnDctosHomogeneos = true;

			//Se hace como si hubiesemos cambiado del plan anterior (Prepago) a un nuevo plan (a la medida)
    		testController.objReservaHomogeneo.LTE_Plan__c = objPlanMedida.Id;
			testController.ocultarDescuentoPlanHomogeneo();
			testController.objReservaHomogeneo.LTE_PlanMedida__c = true;
			testController.objReservaHomogeneo.LTE_DescuentoPlan__c = null;
			testController.objReservaHomogeneo.LTE_DescuentoVoz__c = null;
			testController.continuar();
			
			//Se hace somo si se hubiese seleccionado un descuento de voz
			testController.objReservaHomogeneo.LTE_MinutoVoz__c = objSubPlanFacturacionVoz.Id;
			testController.strDescuentoType = 'DtoVoz';
    		testController.strDescuentoId = objNivelDescuentoVoz.Id;
			testController.strDescuentoName = objNivelDescuentoVoz.Name;
			testController.mostrarDescuento();
			
			//Se hace somo si se hubiese seleccionado un descuento de datos
			testController.objReservaHomogeneo.LTE_DatosNavegacion__c = objSubPlanFacturacionDatos.Id;
			testController.strDescuentoType = 'DtoDato';
    		testController.strDescuentoId = objNivelDescuentoDatos.Id;
			testController.strDescuentoName = objNivelDescuentoDatos.Name;
			testController.mostrarDescuento();
			//Se llama el metodo que se invoca cuando se da clic en el boton continuar ya con los servicios seleccionados
			testController.continuar();
			System.Debug('=====> Tamaño lstCambioPlan despues de continuar(): ' + testController.lstCambioPlan.Size());
			
			//testController.lstCambioPlan[0].LTE_PlanMedida = false;
			//testController.lstCambioPlan[0].detalleOferta_new.Plan__c = null;
			//testController.calcularNuevoValorRecurrente();
			
			testController.lstCambioPlan[0].LTE_PlanMedida = true;
			testController.lstCambioPlan[0].detalleOferta_new.Plan__c = objPlanMedida.Id;
			testController.lstCambioPlan[0].activoETB.NumeroConexion__c = '8888888';
			testController.lstCambioPlan[0].detalleOferta_new.LTE_MinutoVoz__c = null;
			testController.lstCambioPlan[0].detalleOferta_new.LTE_DatosNavegacion__c = null;
			testController.lstCambioPlan[0].idCuentaFacturacion = objCtaFact.Id;
			testController.calcularNuevoValorRecurrente();
			
			testController.continuar();
			
			testController.lstCambioPlan[1].detalleOferta_new.Plan__c = objPlanPrepago.Id;
			testController.intRow = 1;
			testController.ocultarDescuentoPlan();
			
			testController.lstCambioPlan[1].detalleOferta_new.Plan__c = objPlan.Id;
			testController.intRow = 1;
			testController.lstCambioPlan[1].idCuentaFacturacion = objCtaFact.Id;
			testController.ocultarDescuentoPlan();
			
			testController.lstCambioPlan[1].detalleOferta_old.Plan__c = objPlanPrepago.Id;
			testController.lstCambioPlan[1].detalleOferta_new.Plan__c = objPlanPrepago.Id;
			//testController.ocultarDescuentoPlan();
			
			//testController.lstCambioPlan[2].detalleOferta_old.Plan__c = objPlanPrepago.Id;
			//testController.lstCambioPlan[2].detalleOferta_new.Plan__c = objPlanPrepago.Id;
			
			testController.objReservaHomogeneo.LTE_PlanMedida__c = false;
			testController.objReservaHomogeneo.LTE_DescuentoPlan__c = objNivelDescuentoBorrar4.Id;
			testController.lstCambioPlan[0].detalleOferta_new.LTE_DescuentoPlan__c = objNivelDescuentoBorrar4.Id;
			testController.lstCambioPlan[0].detalleOferta_new.LTE_DescuentoVoz__c = objNivelDescuentoBorrar4.Id;
			testController.lstCambioPlan[0].detalleOferta_new.LTE_DescuentoDatos__c = objNivelDescuentoBorrar5.Id;
			testController.lstCambioPlan[0].idCuentaFacturacion = objCtaFact.Id;
			testController.lstCambioPlan[0].detalleOferta_old.Plan__c = objPlan.Id;
			testController.lstCambioPlan[0].detalleOferta_new.Plan__c = objPlanPrepago.Id;
			testController.intRow = 0;
			testController.ocultarDescuentoPlan();
			
			//testController.continuar();
			
			testController.strType = 'DtoPlan';
    		testController.strNivelId = objNivelDescuentoPlan2.Id;
			testController.strNivel = objNivelDescuentoPlan2.Name;
			testController.intRow = 1;
			testController.actualizarTablaDescuentos();
			
			testController.strType = 'DtoVoz';
    		testController.strNivelId = objNivelDescuentoPlan2.Id;
			testController.strNivel = objNivelDescuentoPlan2.Name;
			testController.intRow = 1;
			testController.actualizarTablaDescuentos();
			
			testController.strType = 'DtoDato';
    		testController.strNivelId = objNivelDescuentoPlan2.Id;
			testController.strNivel = objNivelDescuentoPlan2.Name;
			testController.intRow = 1;
			testController.actualizarTablaDescuentos();
			
			testController.intIndexBorrarDcto = 1;
			testController.strDctoBorrar = 'DtoPlan';
			testController.borrarDescuentoCambioPlan();
			
			testController.intIndexBorrarDcto = 1;
			testController.strDctoBorrar = 'DtoVoz';
			testController.borrarDescuentoCambioPlan();
			
			testController.intIndexBorrarDcto = 1;
			testController.strDctoBorrar = 'DtoDato';
			testController.borrarDescuentoCambioPlan();
			
         
			testController.lstCambioPlan[0].detalleOferta_new.Plan__c = objPlan.Id;
                
			testController.calcularNuevoValorRecurrente();
			testController.guardar();
			testController.continuarAprovisionamiento();
			testController.actualizarCtaFacturacion();
			testController.regresar();
			testController.ocultarBotonGuardar();
        	LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
			
			// Parametrizar Servicios adicionales y  generar XA's
			Set<Id> setIdOcs = (new Map<Id,SObject>([SELECT Id FROM OperacionComercial__c])).keySet();
			LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcs,'OC');
			
    	Test.stopTest();
    }
}