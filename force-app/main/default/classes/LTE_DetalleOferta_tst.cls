@isTest
private class LTE_DetalleOferta_tst {
    
    public static List<VariablesGlobales__c> lstVariablesGlobales;
	public static Perfiles_Acciones__c objPerfiles;
	public static Perfiles_Reglas_OC__c objRegalsOC;
	public static Account objAccount;
	public static Contract objContrato;
	public static Poblacion__c objDepto;
	public static Poblacion__c objMunicipio;
	public static CuentaFacturacion__c objCtaFact;
	public static Contact objContact;
	public static Opportunity objOportunidad;
	public static Legalizacion__c objLegalizacion;
	public static CatalogoProductos__c objProducto;
	public static ActivoETB__c objServicio;
	public static Reserva__c objOferta;
	public static LTE_DetalleOferta__c objDetalleOferta;
	public static LTE_DetalleOferta__c objDetalleOferta2;
	public static TOPP__c objTOPP;
	public static Equipo__c objEquipoTraido;	
	public static Planes__c objPlan2;
	public static SubPlanFacturacion__c objSubPlanTroncal;
	public static SubPlanFacturacion__c objSubPlanRecVoz;
	public static SubPlanFacturacion__c objSubPlanRecDatos;
	public static Case objCaso;
	public static OperacionComercial__c objOpComercial;
	
	
    public static void testSetup(){
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
        vGlobal.Name = 'RolLTEBolsasCompartidas';
        vGlobal.Valor__c = 'Total-';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;
        
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

		objEquipoTraido = new Equipo__c();
		objEquipoTraido.Name = 'Samsung s20';
		objEquipoTraido.LTE_PartNumber__c = '3456786543';
		objEquipoTraido.LTE_Marca__c = 'Dummy';
		objEquipoTraido.LTE_Color__c = 'Negro';
		objEquipoTraido.Valor_del_Equipo__c = 0;
		objEquipoTraido.LTE_IVA__c = 0;
		objEquipoTraido.LTE_PrecioConIVA__c = 0;
		objEquipoTraido.LTE_Activo__c = true;
		insert objEquipoTraido;

        objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456'; 
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';  
        objAccount.Phone = '3057447474';
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
		objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
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
		
		objPlan2 = new Planes__c ();
		objPlan2.Name = 'PLAN NEGOCIOS POSPAGO M';
		objPlan2.NombredelProducto__c = objProducto.Id;
		objPlan2.TipodePlan__c = 'Principal';
		objPlan2.Tarifa__c = 96000;
		objPlan2.Estado__c = 'Activo';
		objPlan2.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
		objPlan2.CondicionesComerciales__c = 'Tarificacion por segundo';
		objPlan2.LTE_PlanEstructurados__c = true;
		objPlan2.LTE_TipoControl__c = 'Control';
		insert objPlan2;
				

		objSubPlanRecVoz = new SubPlanFacturacion__c();
		objSubPlanRecVoz.Codigo__c = 'SVA-VOZ A LA MEDIDA 850 MIN';
		objSubPlanRecVoz.LTE_NetworkIndicator__c = 'false';
		objSubPlanRecVoz.LTE_Precio__c = 50000;
		objSubPlanRecVoz.LTE_ServiceIndicator__c = 'false';
		objSubPlanRecVoz.LTE_TipoSubplan__c = 'SVA-Bolsa Recurrente de voz';
		objSubPlanRecVoz.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanRecVoz.MonedaExtranjera__c = false;
		objSubPlanRecVoz.Name = 'VOZ A LA MEDIDA 850 MIN';
		insert objSubPlanRecVoz;
		
		objSubPlanRecDatos = new SubPlanFacturacion__c();
		objSubPlanRecDatos.Codigo__c = 'SVA-DATOS A LA MEDIDA 3GB';
		objSubPlanRecDatos.LTE_NetworkIndicator__c = 'false';
		objSubPlanRecDatos.LTE_Precio__c = 35000;
		objSubPlanRecDatos.LTE_ServiceIndicator__c = 'false';
		objSubPlanRecDatos.LTE_TipoSubplan__c = 'SVA-Bolsa Recurrente de datos';
		objSubPlanRecDatos.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanRecDatos.MonedaExtranjera__c = false;
		objSubPlanRecDatos.Name = 'DATOS A LA MEDIDA 3GB';
        objSubPlanRecDatos.Aplica_SVA_Voz_Relacionados__c = true;
		insert objSubPlanRecDatos;

		objOferta = new Reserva__c();
		objOferta.Oportunidad__c = objOportunidad.Id;
		objOferta.Estado__c = 'Pendiente';
		objOferta.Equipo__c = objEquipoTraido.Id;
		objOferta.LTE_Plan__c = objPlan2.Id;
		insert  objOferta;

		objServicio = new ActivoETB__c();
		objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan2.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        objServicio.CuentaFacturacion__c = objCtaFact.Id;
        insert objServicio;

		objOpComercial = new OperacionComercial__c();
		objOpComercial.CuentaCliente__c = objAccount.Id;
		objOpComercial.Activo__c = objServicio.Id;
		objOpComercial.Plan__c = objPlan2.Id;
		objOpComercial.TOPP__c = objTOPP.Id;
		objOpComercial.Oportunidad__c = objOportunidad.Id;
		objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial.Estado__c = 'Activa';
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
		objDetalleOferta.LTE_ReferenciaEquipo__c = objEquipoTraido.Id;
		objDetalleOferta.LTE_IMEI__c = '980684862113805';
		objDetalleOferta.LTE_ICCID__c = '8957187113000000506';
		objDetalleOferta.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta.Plan__c = objPlan2.Id;
        objDetalleOferta.IMEIProcesado__c = false;        
		insert objDetalleOferta;

		

		objServicio.LTE_DetalleOferta__c = objDetalleOferta.id;
		upsert objServicio;    
    }
    
    @isTest 
    static void unitTest1(){
        testSetup();
		List<LTE_DetalleOferta__c> detalles = new List<LTE_DetalleOferta__c>();
		objDetalleOferta2 = new LTE_DetalleOferta__c();
		objDetalleOferta2.LTE_OperacionComercial__c = objOpComercial.Id;
		objDetalleOferta2.LTE_Cliente__c = objAccount.Id;
		objDetalleOferta2.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta2.LTE_Estado__c = 'Pendiente';
		objDetalleOferta2.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta2.LTE_ReferenciaEquipo__c = objEquipoTraido.Id;
		objDetalleOferta2.LTE_IMEI__c = '980684862113804';
		objDetalleOferta2.LTE_ICCID__c = '8957187113000000501';
		objDetalleOferta2.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta2.Plan__c = objPlan2.Id;
		objDetalleOferta2.IMEIProcesado__c = false;
		detalles.add(objDetalleOferta2);
		LTE_DetalleOferta__c objDetalleOferta3 = new LTE_DetalleOferta__c();
		objDetalleOferta3.LTE_OperacionComercial__c = objOpComercial.Id;
		objDetalleOferta3.LTE_Cliente__c = objAccount.Id;
		objDetalleOferta3.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta3.LTE_Estado__c = 'Pendiente';
		objDetalleOferta3.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta3.LTE_ReferenciaEquipo__c = objEquipoTraido.Id;
		objDetalleOferta3.LTE_IMEI__c = '980684862113802';
		objDetalleOferta3.LTE_ICCID__c = '8957187113000000505';
		objDetalleOferta3.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta3.Plan__c = objPlan2.Id;
		objDetalleOferta3.IMEIProcesado__c = false;
		detalles.add(objDetalleOferta3);
        Test.startTest();
			insert detalles;
        Test.stopTest();
    }
	@isTest
	static void unitTest2(){
        testSetup();
		List<LTE_DetalleOferta__c> detalles = new List<LTE_DetalleOferta__c>();
		LTE_DetalleOferta__c objDetalleOferta4 = new LTE_DetalleOferta__c();
		objDetalleOferta4.LTE_OperacionComercial__c = objOpComercial.Id;
		objDetalleOferta4.LTE_Cliente__c = objAccount.Id;
		objDetalleOferta4.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta4.LTE_Estado__c = 'Pendiente';
		objDetalleOferta4.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta4.LTE_IMEI__c = '980684862113804';
		objDetalleOferta4.LTE_ICCID__c = '8957187113000000501';
		objDetalleOferta4.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta4.Plan__c = objPlan2.Id;
		objDetalleOferta4.IMEIProcesado__c = false;
		objDetalleOferta4.ReferenciaEquipoAliado__c = 'Samsung s8';
		detalles.add(objDetalleOferta4);
		LTE_DetalleOferta__c objDetalleOferta3 = new LTE_DetalleOferta__c();
		objDetalleOferta3.LTE_OperacionComercial__c = objOpComercial.Id;
		objDetalleOferta3.LTE_Cliente__c = objAccount.Id;
		objDetalleOferta3.LTE_Oferta_Economica__c = objOferta.Id;
		objDetalleOferta3.LTE_Estado__c = 'Pendiente';
		objDetalleOferta3.LTE_Estado_Detalle_Oferta__c = 'Reservado';
		objDetalleOferta3.LTE_ReferenciaEquipo__c = objEquipoTraido.Id;
		objDetalleOferta3.LTE_IMEI__c = '980684862113802';
		objDetalleOferta3.LTE_ICCID__c = '8957187113000000505';
		objDetalleOferta3.ReferenciaEquipoAliado__c = 'Samsung s9';
		objDetalleOferta3.LTEValorEquipoDescuento__c = 458999;
		objDetalleOferta3.Plan__c = objPlan2.Id;
		objDetalleOferta3.IMEIProcesado__c = false;
		detalles.add(objDetalleOferta3);
        Test.startTest(); 
			insert detalles;
        Test.stopTest();
    }
}