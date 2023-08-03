/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              John Guevara
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de servicios de cambio de numero

Cambios (Versiones)
--------------------------------------
----    ----------      --------------              ---------------
1.0     2019-09-20      John Guevara.	            Creación de la clase.
***********************************************************************************************************************/
@isTest
public class LTE_ServiciosModificacionServicio_tst {
	
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
	public static TOPP__c objTOPP;
	public static TOPP__c objTOPP2;
	public static Equipo__c objEquipoTraido;
	public static Planes__c objPlan;
	public static Planes__c objPlan2;
	public static SubPlanFacturacion__c objSubPlanTroncal;
	public static Case objCaso;
	public static OperacionComercial__c objOpComercial;
	public static PlanFacturacion__c objPlanFacturacion;
	public static CatalogoProductosFacturacion__c objCatalogoProductosFacturacion;
	
	public static void CreateData(){
        
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='CambioPlanRegxPag',Valor__c='5'));
        vg.add(new VariablesGlobales__c(Name='ViabilidadTroncalesSIP_LTE_CambioPlan',Valor__c='Enlaces de Voz'));
        vg.add(new VariablesGlobales__c(Name='RolLTEModificacionEstandar',Valor__c='Total'));
        vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        insert vg;

		objAccount = new Account();
		objAccount.Name = 'Test Name';
		objAccount.RazonSocial__c = 'Test razon social';
		objAccount.Tipodedocumento__c = 'NIT';
		objAccount.Estado_Cuenta__c = 'Activo';
		objAccount.AccountNumber = '1029837456';
		objAccount.Segmento__c = 'Gobierno Distrital';
		objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '3056478987';
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
		objContact.LTE_RolLTE__c = 'Total-';
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
        objTOPP2.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        objTOPP2.TipodeOperacionporplan__c = 'Cambio de Plan';
        objTOPP2.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = true;
        objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP2;
        

		objPlan = new Planes__c ();
		objPlan.Name = 'Troncal SIP Movil L';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Troncal SIP';
		objPlan.Tarifa__c = 42500000;
		objPlan.Estado__c = 'Activo';
		objPlan.Descripcion__c = 'La tarifa adicional es solo moviles Tarificacion por segundo Limite del CB hasta  $127.500.000  adicionales (consumos adicionales Voz) ';
		objPlan.CondicionesComerciales__c = 'La tarifa adicional es solo moviles Tarificacion por segundo Limite del CB hasta  $127.500.000  adicionales (consumos adicionales Voz)';
		objPlan.LTE_PlanEstructurados__c = true;
		objPlan.LTE_TipoControl__c = 'Abierto';
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
		objPlan2.LTE_TipoControl__c = 'Control';
		insert objPlan2;
		
		objSubPlanTroncal = new SubPlanFacturacion__c();
		objSubPlanTroncal.Codigo__c = 'Troncal SIP 5 Canales';
		objSubPlanTroncal.LTE_NetworkIndicator__c = 'false';
		objSubPlanTroncal.LTE_Precio__c = 237524;
		objSubPlanTroncal.LTE_ServiceIndicator__c = 'false';
		objSubPlanTroncal.LTE_TipoSubplan__c = 'Troncal SIP';
		objSubPlanTroncal.LTE_TypeCode__c = 'PRODUCT';
		objSubPlanTroncal.MonedaExtranjera__c = false;
		objSubPlanTroncal.Name = 'Troncal SIP 5 Canales';
		insert objSubPlanTroncal;
		
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
		
		objOpComercial = new OperacionComercial__c();
		objOpComercial.CuentaCliente__c = objAccount.Id;
		objOpComercial.Activo__c = objServicio.Id;
		objOpComercial.Plan__c = objPlan.Id;
		objOpComercial.TOPP__c = objTOPP2.Id;
		objOpComercial.Oportunidad__c = objOportunidad.Id;
		objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
		objOpComercial.Estado__c = 'En Curso';
		objOpComercial.NumeroConexion__c = '3057000502';
		objOpComercial.FechadeActivacion__c = system.today();
		objOpComercial.Legalizacion__c = objLegalizacion.Id;
		insert objOpComercial;
		
		objCatalogoProductosFacturacion = new CatalogoProductosFacturacion__c();
		objCatalogoProductosFacturacion.Name = 'TELEFONIA MOVIL (LTE)';
		objCatalogoProductosFacturacion.CatalogoProductos__c = objProducto.Id;
		insert objCatalogoProductosFacturacion;
		
		objPlanFacturacion = new PlanFacturacion__c();
		objPlanFacturacion.CatalogoProductosFacturacion__c = objCatalogoProductosFacturacion.Id;
		objPlanFacturacion.LTE_TipoControl__c = 'Abierto';
		objPlanFacturacion.Plan__c = objPlan.Id;
		objPlanFacturacion.Name = 'Troncal SIP Movil L';
		insert objPlanFacturacion;
    	
    }
    
    static testMethod void myUnitTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        
        LTE_ServiciosModificacionServicio_ctr testController;
        Test.startTest();
        PageReference pageRef = Page.LTE_ServiciosCambioPlanSIP_pag;
        Test.setCurrentPage(pageRef);
        
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        
        //Se prueba el controlador de la pagina de tal manera que los parametros se vallan llendo nulos
        //hasta que al final se envian todos los parametros y pasa las validaciones iniciales del controlador
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('estadoAprobacion', 'Oferta Realizada');
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('estadoAprobacion', '');
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idCase', objCaso.Id);
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idAccount', objCaso.AccountId);
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('caseNumber', objCaso.CaseNumber);
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idTOPP', objTOPP2.id);
        ApexPages.currentPage().getParameters().put('estadoAprobacion', objCaso.Aprobaciones__c);
        ApexPages.currentPage().getParameters().put('idContact', '00323000002L5Q6');
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        ApexPages.currentPage().getParameters().put('idContact', objCaso.ContactId);
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        objContact.LTE_RolLTE__c = 'Total';
        update objContact;
        testController = new LTE_ServiciosModificacionServicio_ctr(new Apexpages.Standardcontroller(objCaso));
        
        //testController.validaRolCambioPlanSIP('Total');
        //testController.validaRolCambioPlanSIP('');
        testController.buscar();
        testController.numerosConexion = 'xxxxxxxx';
        testController.buscar();
        testController.numerosConexion = '3057000502';
        testController.buscar();
        testController.numerosConexion = '3057000501';
        testController.buscar();
        
        testController.strDetalleTramite = 'Ampliacion';
        testController.guardar();
        
        Test.stopTest();
    }
}