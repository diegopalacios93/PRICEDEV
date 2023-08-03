@isTest
public with sharing class ProcesosMasivos_tst {
    public static Account objAccount;
    public static Case objCaso;
    public static Case objCaso1;
    public static Contact objContact;
    public static Contact objContact1;
    public static Poblacion__c objMunicipio;
    public static Poblacion__c objDepto;
    public static Planes__c objPlan;
    public static CuentaFacturacion__c objCuentaFact;
    public static TOPP__c objTOPPSusp;
    public static TOPP__c objTOPPRec;
    public static CatalogoProductos__c objProducto;
    public static ActivoETB__c objServicio;
    public static Opportunity objOpportunity;
    public static Perfiles_Acciones__c objPerfiles;
    public static List<VariablesGlobales__c> lstVariablesGlobales;
    public static OperacionComercial__c objOpComercialSusp;
    public static OperacionComercial__c objOpComercialRec;
    public static Case objNumberCase;
    public static Procesos_Masivos__c objProcesoMasivo;
    public static Registro_Proceso_Masivo__c objRegistroProcesoMasivo;
    @TestSetup
    public static void createData()
    {
        
        lstVariablesGlobales 			= new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal 	= new VariablesGlobales__c();
        vGlobal.Name 					= 'NombreComercialLTE';
        vGlobal.Valor__c 				= 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal 			= new VariablesGlobales__c();
        vGlobal.Name 		= 'CambioPlanRegxPag';
        vGlobal.Valor__c 	= '5';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal 			= new VariablesGlobales__c();
        vGlobal.Name 		= 'DiasPreviosSuspension';
        vGlobal.Valor__c	= '5';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal 			= new VariablesGlobales__c();
        vGlobal.Name 		= 'TotalDiasSuspension';
        vGlobal.Valor__c	= '60';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal 			= new VariablesGlobales__c();
        vGlobal.Name 		= 'NumVecesSuspension';
        vGlobal.Valor__c	= '2';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'RolLTESuspensionVoluntaria';
        vGlobal.Valor__c = 'Total';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;
        
        objPerfiles 			= new Perfiles_Acciones__c();
        objPerfiles.Name 		= 'PerfilesCambioEstadosLTE';
        objPerfiles.Usuarios__c = userinfo.getProfileId();
        insert objPerfiles;
        
        objAccount 						= new Account();
        objAccount.RecordTypeId         = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        objAccount.Name 				= 'Test Name';
        objAccount.RazonSocial__c 		= 'Test razon social';
        objAccount.Tipodedocumento__c 	= 'NIT';
        objAccount.Estado_Cuenta__c 	= 'Activo';
        objAccount.AccountNumber 		= '1029837456'; 
        objAccount.Segmento__c 			= 'Gobierno Distrital';
        objAccount.SubSegmento__c 		= 'Mediana';
        objAccount.Telefonodecontacto1__c = '1231231231';
        objAccount.Phone                 = '1231231231';
        insert objAccount;
        
        objDepto 					= new Poblacion__c();
        objDepto.Name 				= 'BOGOTA D.C.';
        objDepto.CodigoDane__c 		= '11000';
        objDepto.EsDepartamento__c 	= true;
        insert objDepto;
        
        objMunicipio 				= new Poblacion__c();
        objMunicipio.Name 			= 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c 	= '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c 		= objDepto.Id;
        insert objMunicipio;
        
        objCuentaFact 									= new CuentaFacturacion__c();
        objCuentaFact.LTE_NombreCuentaFacturacion__c 	= 'Cta fact test';
        objCuentaFact.Cliente__c 						= objAccount.Id;
        objCuentaFact.Facturable__c 					= true;
        objCuentaFact.LTE_MetodoEnvio__c 				= 'Email';
        objCuentaFact.LTE_CicloFacturacion__c 			= '5';
        objCuentaFact.LTE_Email__c 						= 'test@test.com';
        objCuentaFact.LTE_DireccionFacturacion__c		= 'Direccion test';
        objCuentaFact.Ciudad__c 						= objMunicipio.Id;
        objCuentaFact.LTE_CuentaFacturacionLTE__c 		= true;
        objCuentaFact.Fue_creada_en_revchain__c 		= true;
        objCuentaFact.DirCorresp__c 					= 'Test DirCorresp';
        insert objCuentaFact;
        
        objContact 								= new Contact(IsTEST__c = true);
        objContact.FirstName 					= 'Andres';
        objContact.LastName 					= 'Lopez';
        objContact.AccountId 					= objAccount.Id;
        objContact.Tipodedocumento__c 			= 'Cédula de ciudadanía';
        objContact.NumerodeIdentificacion__c	= '345678904';
        objContact.Estado__c 					= 'Activo';
        objContact.Cargo__c 					= 'Ingeniero';
        objContact.Area__c 						= 'Dpto. Financiero';
        objContact.Rol__c 						= 'Administrativo';
        objContact.LTE_RolLTE__c 				= 'Total';
        objContact.Genero__c 					= 'Masculino';
        objContact.Direccion__c 				= 'Calle 12 # 34 - 53';
        objContact.Phone 						= '432432432';
        objContact.MobilePhone 					= '3105667655';
        objContact.Email 						= 'scampos@avanxo.com';
        objContact.Ciudad__c 					= objMunicipio.Id;
        insert objContact;
        
        objContact1 							= new Contact(IsTEST__c = true);
        objContact1.FirstName 					= 'Camila';
        objContact1.LastName 					= 'Diaz';
        objContact1.AccountId 					= objAccount.Id;
        objContact1.Tipodedocumento__c 			= 'Cédula de ciudadanía';
        objContact1.NumerodeIdentificacion__c	= '11223344';
        objContact1.Estado__c 					= 'Activo';
        objContact1.Cargo__c 					= 'Ingeniero';
        objContact1.Area__c 					= 'Dpto. Planeacion';
        objContact1.Rol__c 						= 'Administrativo';
        objContact1.LTE_RolLTE__c 				= 'Parcial';
        objContact1.Genero__c 					= 'Femenino';
        objContact1.Direccion__c 				= 'Calle 19 # 7 - 53';
        objContact1.Phone 						= '1234789';
        objContact1.MobilePhone 				= '3132345789';
        objContact1.Email 						= 'cdiaz@avanxo.com';
        objContact1.Ciudad__c 					= objMunicipio.Id;
        insert objContact1;
        
        objOpportunity 									= new Opportunity();
        objOpportunity.Name 							= 'Test name';
        objOpportunity.RecordTypeId 					= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
        objOpportunity.AccountId 						= objAccount.Id;
        objOpportunity.StageName 						= 'Análisis de necesidades';
        objOpportunity.CloseDate 						= system.today();
        objOpportunity.Amount 							= 1000;
        objOpportunity.Valor_unica_vez_ETB__c 			= 150;
        objOpportunity.LTE_Scoring__c 					= 9000000;
        objOpportunity.LTE_FechaConsultaDatacredito__c	= system.today();
        objOpportunity.LTE_NumeroLinea__c 				= 2;
        insert objOpportunity;
        
        objProducto 						= new CatalogoProductos__c();
        objProducto.Name 					= 'TELEFONIA MOVIL (LTE)';
        objProducto.Familia__c 				= 'LTE';
        objProducto.LineaNegocio__c 		= 'Redes Móviles';
        objProducto.CodigoProducto__c 		= '7635736';
        objProducto.Estado__c 				= 'Activo';
        objProducto.Descripcion__c 			= 'Teste';
        objProducto.AtributosEstandar__c	= 'Teste';
        insert objProducto;
        
        objTOPPSusp 							= new TOPP__c();
        objTOPPSusp.Name 						= 'Suspensión- TELEFONIA MOVIL (LTE)';
        objTOPPSusp.TipodeOperacionporplan__c 	= 'Suspensión';
        objTOPPSusp.Tipoderegistro__c 			= 'Suspension_Reconexion';
        objTOPPSusp.DisponibleVentainicial__c 	= true;
        objTOPPSusp.Facturable__c 				= true;
        objTOPPSusp.LTE_Parte_caso__c 			= false;
        objTOPPSusp.LTE_Catalogo_de_Producto__c	= objProducto.Id;
        insert objTOPPSusp;
        
        objTOPPRec 								= new TOPP__c();
        objTOPPRec.Name 						= 'Reconexión- TELEFONIA MOVIL (LTE)';
        objTOPPRec.TipodeOperacionporplan__c 	= 'Reconexión';
        objTOPPRec.Tipoderegistro__c 			= 'Suspension_Reconexion';
        objTOPPRec.DisponibleVentainicial__c 	= true;
        objTOPPRec.Facturable__c 				= true;
        objTOPPRec.LTE_Parte_caso__c 			= false;
        objTOPPRec.LTE_Catalogo_de_Producto__c	= objProducto.Id;
        insert objTOPPRec;
        
        objPlan 							= new Planes__c ();
        objPlan.Name 						= 'PLAN NEGOCIOS POSPAGO M';
        objPlan.NombredelProducto__c		= objProducto.Id;
        objPlan.TipodePlan__c 				= 'Principal';
        objPlan.Tarifa__c 					= 96000;
        objPlan.Estado__c 					= 'Activo';
        objPlan.Descripcion__c 				= 'La tarifa es todo destino Moviles y Fijos Nacionales ';
        objPlan.CondicionesComerciales__c	= 'Tarificacion por segundo';
        objPlan.LTE_PlanEstructurados__c 	= true;
        objPlan.LTE_TipoControl__c 			= 'Control';
        insert objPlan;
        
        objServicio 						= new ActivoETB__c();
        objServicio.Oportunidad__c 			= objOpportunity.Id;
        objServicio.NombredelaCuenta__c		= objAccount.Id;
        objServicio.Plan__c 				= objPlan.Id;
        objServicio.Estado__c 				= 'Activo';
        objServicio.IMEI_del_Equipo__c 		= '980684862113805';
        objServicio.LTE_ICCID__c 			= '8957187113000000506';
        objServicio.NumeroConexion__c 		= '3057000550';
        objServicio.Fecha_Activacion__c 	= system.now();
        objServicio.CuentaFacturacion__c	= objCuentaFact.Id;
        insert objServicio;
        
        objCaso 						= new Case();
        objCaso.AccountId 				= objAccount.Id;
        objCaso.Fechaderadicacion__c	= Date.today();
        objCaso.Operadores__c 			= 'ETB';
        objCaso.RecordTypeId 			= Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin 					= 'Teléfono';
        objCaso.Plan__c 				= objPlan.Id;
        objCaso.Status 					= 'Abierto';
        objCaso.Causal_Estado__c 		= 'Asignado';
        objCaso.Subject 				= 'Prueba Suspension Voluntaria';
        objCaso.ContactId 				= objContact.id;
        objCaso.Aprobaciones__c 		= 'Inicial';
        insert objCaso;
        
        objCaso1 						= new Case();
        objCaso1.AccountId 				= objAccount.Id;
        objCaso1.Fechaderadicacion__c	= Date.today();
        objCaso1.Operadores__c 			= 'ETB';
        objCaso1.RecordTypeId 			= Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso1.Origin 				= 'Teléfono';
        objCaso1.Plan__c 				= objPlan.Id;
        objCaso1.Status 				= 'Abierto';
        objCaso1.Causal_Estado__c 		= 'Asignado';
        objCaso1.Subject 				= 'Prueba Suspension Voluntaria';
        objCaso1.ContactId 				= objContact1.id;
        objCaso1.Aprobaciones__c 		= 'Inicial';
        insert objCaso1;
        
        objNumberCase = [SELECT id, caseNumber FROM Case WHERE id = :objCaso.id];
        
        objOpComercialSusp 						= new OperacionComercial__c();
        objOpComercialSusp.RecordTypeId			= Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Suspension/Reconexion').getRecordTypeId();
        objOpComercialSusp.CuentaCliente__c 	= objAccount.Id;
        objOpComercialSusp.Activo__c 			= objServicio.Id;
        objOpComercialSusp.Plan__c 				= objPlan.Id;
        objOpComercialSusp.TOPP__c 				= objTOPPSusp.Id;
        objOpComercialSusp.Oportunidad__c 		= objOpportunity.Id;
        objOpComercialSusp.CuentaFacturacion__c = objCuentaFact.Id;
        objOpComercialSusp.Estado__c 			= 'Activa';
        objOpComercialSusp.NumeroConexion__c 	= '3057000500';
        objOpComercialSusp.FechadeActivacion__c	= system.today();
        insert objOpComercialSusp;
        
        objOpComercialRec 						= new OperacionComercial__c();
        objOpComercialRec.RecordTypeId			= Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Suspension/Reconexion').getRecordTypeId();
        objOpComercialRec.CuentaCliente__c 		= objAccount.Id;
        objOpComercialRec.Activo__c 			= objServicio.Id;
        objOpComercialRec.Plan__c 				= objPlan.Id;
        objOpComercialRec.TOPP__c 				= objTOPPRec.Id;
        objOpComercialRec.Oportunidad__c 		= objOpportunity.Id;
        objOpComercialRec.CuentaFacturacion__c 	= objCuentaFact.Id;
        objOpComercialRec.Estado__c 			= 'Activa';
        objOpComercialRec.NumeroConexion__c 	= '3057000500';
        objOpComercialRec.FechadeActivacion__c	= system.today();
        insert objOpComercialRec;    
        
        Procesos_Masivos__c p = new Procesos_Masivos__c();
        p.Proceso_a_ejecutar__c = 'Suspender';
        p.Cuenta_cliente__c =  objAccount.Id;
        p.Fecha_de_inicio__c = Date.today();
        p.Fecha_inicio_suspension__c = Date.today()+10;
        p.Fecha_inicio_reconexion__c = Date.today()+40;
       	p.Estado_del_proceso__c = 'Pendiente';
        insert p;
        
        Registro_Proceso_Masivo__c rp = new Registro_Proceso_Masivo__c();
        rp.Proceso_Masivo__c = p.Id;
        rp.Identificar_Activo__c = objServicio.Name;
        rp.Activo__c = objServicio.Id;
        insert rp;
    }
    
    @isTest static void myUnitTest1(){
        Procesos_Masivos__c p = [SELECT Id FROM Procesos_Masivos__c LIMIT 1];
       	Database.executeBatch(new ProcesosMasivos_bch(p.Id),100);
    }
    
}