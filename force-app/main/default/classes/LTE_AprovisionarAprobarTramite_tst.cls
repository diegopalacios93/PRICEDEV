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
private class LTE_AprovisionarAprobarTramite_tst {
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
	public static Equipo__c objEquipo;
	public static Planes__c objPlan;
	public static ActivoETB__c objServicio;
    public static ActivoETB__c objServicio2;
	public static LTE_Servicios_adicionales__c objServAdicional;
	public static OperacionComercial__c objOpComercial;
	public static Reserva__c objOferta;
	public static LTE_DetalleOferta__c objDetalleOferta;
	public static VariablesGlobales__c objVariables;
	public static HomologacionMetodosReclamacion__c objMetodosReclamacion;
	public static HomologacionCampos__c objHomologacionCampos;
	public static ServiciosWeb__c objServicioWeb;
    public static Perfiles_Acciones__c objPerfiles;
    public static Perfiles_Reglas_OC__c objRegalsOC;
    public static Case objCaso;
    public static LTE_NivelesDescuento__c objNivelesDto ;

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
      	objTOPP.TipodeOperacionporplan__c = 'Cambio de Plan';
      	objTOPP.Tipoderegistro__c = 'Venta_LTE';
      	objTOPP.DisponibleVentainicial__c = true;
      	objTOPP.Facturable__c = true;
      	objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
      	insert objTOPP;

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
        
        objCaso = new Case();
    	objCaso.Fechaderadicacion__c = system.today();
    	objCaso.Origin = 'Correo electrónico';
    	objCaso.Status = 'En Proceso';
    	objCaso.Causal_Estado__c = 'Asignado';
    	objCaso.Plan__c = objPlan.Id;
    	objCaso.Subject = 'teste';
    	objCaso.ContactId = objContact.Id;
    	objCaso.Tipologia__c = 'FALLA ELECTRICA';
    	objCaso.LTE_Garantia__c = 'En Garantia';
    	objCaso.LTE_Servicio__c = objServicio.Id;
    	objCaso.Aprobaciones__c = 'Oferta Realizada';
    	insert objCaso;        

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
      	objOpComercial.Caso__c = objCaso.Id;
      	insert objOpComercial;
      
      	objNivelesDto = new LTE_NivelesDescuento__c();
		objNivelesDto.LTE_NoCuotasNivel1__c = 1;
		objNivelesDto.LTE_DescuentoNivel1__c = 70;
		objNivelesDto.LTE_Indice__c = 0;
		insert objNivelesDto;

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
	  	objDetalleOferta.LTE_DescuentoPlan__c = objNivelesDto.Id;
	  	insert objDetalleOferta;

        objServAdicional = new LTE_Servicios_adicionales__c();
        objServAdicional.Name = 'TELEFONIA MOVIL (LTE)';
        objServAdicional.LTE_Estado__c = 'Pendiente';
        objServAdicional.LTE_ServicioETB__c = objServicio.Id;
        objServAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
        insert objServAdicional;
  
        
         
    }
    static testMethod void myUnitTest() {
    	CreateData();
    	Test.startTest();
    	
    	/*LTE_AprovisionarAprobarTramite_ctr ctr1 = new LTE_AprovisionarAprobarTramite_ctr();
    	ctr1.enviarAprobacionDescuento();
        ctr1.enviarAprovisionamiento();*/
    	
        PageReference pageRef = Page.LTE_AprovisionarAprobarTramite_pag;
    	Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('idCaso', objCaso.id); 
        LTE_AprovisionarAprobarTramite_ctr ctr = new LTE_AprovisionarAprobarTramite_ctr();
        ctr.enviarAprobacionDescuento();
        ctr.enviarAprovisionamiento();

       	//ctr.enviarAprovisionamiento();
       	ctr.obtenerCaso(null);
        Test.stopTest();
    }
}