/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para el controlador LTE_SeleccionTramiteCambioPlan_ctr

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2015-12-30      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_SeleccionTramiteCambioPlan_tst {
    
    public static Account objAccount;
    public static Contract objContrato;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static CuentaFacturacion__c objCtaFact;
    public static Perfiles_Acciones__c objPerfiles;
    public static Perfiles_Reglas_OC__c objRegalsOC;
    public static Contact objContact;
    public static Opportunity objOportunidad;
    public static Legalizacion__c objLegalizacion;
    public static CatalogoProductos__c objProducto;
    public static TOPP__c objTOPP;
    public static TOPP__c objTOPP1;
    public static TOPP__c objTOPP2;
    public static TOPP__c objTOPP3;
    public static TOPP__c objTOPP4;
    public static TOPP__c objTOPP5;
    public static TOPP__c objTOPP6;
    public static TOPP__c objTOPP7;
    public static TOPP__c objTOPP8;
    public static TOPP__c objTOPP9;
    public static TOPP__c objTOPP10;
    public static TOPP__c objTOPP11;
    public static Equipo__c objEquipo;
    public static Equipo__c objEquipoTraido;
    public static Planes__c objPlan;
    public static Case objCaso;
    public static Case objCaso2;
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
        insert lstVariablesGlobales;
        
        list<LTE_Tipos_SubTOPP__c> lstSubTOPP = new list<LTE_Tipos_SubTOPP__c>();
        LTE_Tipos_SubTOPP__c subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Tramites LTE';
        subTOPP.Sub_TOPP__c = 'LTE';
        subTOPP.TOPP__c = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/lte_servicioscambioplan_pag?caseNumber=<<caseNumber>>&estadoAprobacion=<<estadoAprobacion>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Suspensión Voluntaria';
        subTOPP.Sub_TOPP__c = 'Voluntaria';
        subTOPP.TOPP__c = 'Suspensión- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/lte_suspensionvoluntaria_pag?caseNumber=<<caseNumber>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>&strTipo=<<strTipo>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Cambio Número';
        subTOPP.Sub_TOPP__c = 'Cambio Número';
        subTOPP.TOPP__c = 'Cambio Número- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/lte_servicioscambionumero_pag?caseNumber=<<caseNumber>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Reconexión Voluntaria';
        subTOPP.Sub_TOPP__c = 'Voluntaria';
        subTOPP.TOPP__c = 'Reconexión- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/lte_reconexionvoluntaria_pag?caseNumber=<<caseNumber>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>&strTipo=<<strTipo>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Adición SVA Bolsa Recurrente';
        subTOPP.Sub_TOPP__c = 'Bolsa Recurrente';
        subTOPP.TOPP__c = 'Adición SVA- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_AdicionSVA_BolsaRecurrente_pag?caseNumber=<<caseNumber>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Retiro SVA Bolsa Recurrente';
        subTOPP.Sub_TOPP__c = 'Bolsa Recurrente';
        subTOPP.TOPP__c = 'Retiro SVA- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_RetiroSVA_pag?caseNumber=<<caseNumber>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>&tipoTramite=<<tipoTramite>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Adición bolsa compartida';
        subTOPP.Sub_TOPP__c = 'LTE';
        subTOPP.TOPP__c = 'Adición bolsa compartida- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_AdicionBolsaCompartida_pag?caseNumber=<<caseNumber>>&estadoAprobacion=<<estadoAprobacion>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Reducción bolsa compartida';
        subTOPP.Sub_TOPP__c = 'LTE';
        subTOPP.TOPP__c = 'Reducción bolsa compartida- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_ReduccionBolsaCompartida_pag?caseNumber=<<caseNumber>>&estadoAprobacion=<<estadoAprobacion>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Modificación Estándar';
        subTOPP.Sub_TOPP__c = 'LTE';
        subTOPP.TOPP__c = 'Modificación Estándar- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_ServiciosModificacionEstandar_pag?caseNumber=<<caseNumber>>&estadoAprobacion=<<estadoAprobacion>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Conversión Demo a Venta';
        subTOPP.Sub_TOPP__c = 'LTE';
        subTOPP.TOPP__c = 'Conversión Demo a Venta- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_ServiciosModificacionEstandar_pag?caseNumber=<<caseNumber>>&estadoAprobacion=<<estadoAprobacion>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        subTOPP = new LTE_Tipos_SubTOPP__c();
        subTOPP.Name = 'Ampliación de Tiempo Demo';
        subTOPP.Sub_TOPP__c = 'LTE';
        subTOPP.TOPP__c = 'Ampliación de Tiempo Demo- TELEFONIA MOVIL (LTE)';
        subTOPP.URL__c = '/apex/LTE_ServiciosModificacionEstandar_pag?caseNumber=<<caseNumber>>&estadoAprobacion=<<estadoAprobacion>>&idAccount=<<idAccount>>&idCase=<<idCase>>&idContact=<<idContact>>&idTOPP=<<idTOPP>>';
        subTOPP.Disponible_postventa__c = true;
        lstSubTOPP.add(subTOPP);
        
        insert lstSubTOPP;

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
        objAccount.Phone = '3055678778';
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
        objTOPP.LTE_Parte_caso__c = false;
        objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP;

        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Cambio Número- TELEFONIA MOVIL (LTE)';
        objTOPP2.TipodeOperacionporplan__c = 'Cambio Número';
        objTOPP2.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP2.Facturable__c = true;
        objTOPP2.LTE_Parte_caso__c = true;
        objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP2;

        objTOPP3 = new TOPP__c();
        objTOPP3.Name = 'Reconexión- TELEFONIA MOVIL (LTE)';
        objTOPP3.TipodeOperacionporplan__c = 'Reconexión';
        objTOPP3.Tipoderegistro__c = 'Suspension_Reconexion';
        objTOPP3.Facturable__c = true;
        objTOPP3.LTE_Parte_caso__c = true;
        objTOPP3.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP3;

        objTOPP4 = new TOPP__c();
        objTOPP4.Name = 'Adición SVA- TELEFONIA MOVIL (LTE)';
        objTOPP4.TipodeOperacionporplan__c = 'Adición SVA';
        objTOPP4.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP4.Facturable__c = true;
        objTOPP4.LTE_Parte_caso__c = true;
        objTOPP4.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP4;
        
        objTOPP1 = new TOPP__c();
        objTOPP1.Name = 'Retiro SVA- TELEFONIA MOVIL (LTE)';
        objTOPP1.TipodeOperacionporplan__c = 'Retiro SVA';
        objTOPP1.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP1.Facturable__c = true;
        objTOPP1.LTE_Parte_caso__c = true;
        objTOPP1.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP1;
        
        objTOPP5 = new TOPP__c();
        objTOPP5.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        objTOPP5.TipodeOperacionporplan__c = 'Cambio de Plan';
        objTOPP5.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP5.Facturable__c = true;
        objTOPP5.LTE_Parte_caso__c = true;
        objTOPP5.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP5;
        
        objTOPP6 = new TOPP__c();
        objTOPP6.Name = 'Suspensión- TELEFONIA MOVIL (LTE)';
        objTOPP6.TipodeOperacionporplan__c = 'Suspensión';
        objTOPP6.Tipoderegistro__c = 'Suspension_Reconexion';
        objTOPP6.Facturable__c = true;
        objTOPP6.LTE_Parte_caso__c = true;
        objTOPP6.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP6;
        
        objTOPP7 = new TOPP__c();
        objTOPP7.Name = 'Adición bolsa compartida- TELEFONIA MOVIL (LTE)';
        objTOPP7.TipodeOperacionporplan__c = 'Adición bolsa compartida';
        objTOPP7.Tipoderegistro__c = 'Adicion_bolsa_compartida';
        objTOPP7.Facturable__c = true;
        objTOPP7.LTE_Parte_caso__c = true;
        objTOPP7.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP7;
        
        objTOPP8 = new TOPP__c();
        objTOPP8.Name = 'Reducción bolsa compartida- TELEFONIA MOVIL (LTE)';
        objTOPP8.TipodeOperacionporplan__c = 'Reducción bolsa compartida';
        objTOPP8.Tipoderegistro__c = 'Reduccion_bolsa_compartida';
        objTOPP8.Facturable__c = true;
        objTOPP8.LTE_Parte_caso__c = true;
        objTOPP8.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP8;
        
        objTOPP9 = new TOPP__c();
        objTOPP9.Name = 'Modificación Estándar- TELEFONIA MOVIL (LTE)';
        objTOPP9.TipodeOperacionporplan__c = 'Modificación Estándar';
        objTOPP9.Tipoderegistro__c = 'Modificacion_Estandar';
        objTOPP9.Facturable__c = true;
        objTOPP9.LTE_Parte_caso__c = true;
        objTOPP9.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP9;
        
        objTOPP10 = new TOPP__c();
        objTOPP10.Name = 'Conversión Demo a Venta- TELEFONIA MOVIL (LTE)';
        objTOPP10.TipodeOperacionporplan__c = 'Conversión Demo a Venta';
        objTOPP10.Tipoderegistro__c = 'Conversion_Demo_a_Venta';
        objTOPP10.Facturable__c = true;
        objTOPP10.LTE_Parte_caso__c = true;
        objTOPP10.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP10;
        
        objTOPP11 = new TOPP__c();
        objTOPP11.Name = 'Ampliación de Tiempo Demo- TELEFONIA MOVIL (LTE)';
        objTOPP11.TipodeOperacionporplan__c = 'Ampliación de Tiempo Demo';
        objTOPP11.Tipoderegistro__c = 'Ampliacion_de_Tiempo_Demo';
        objTOPP11.Facturable__c = true;
        objTOPP11.LTE_Parte_caso__c = true;
        objTOPP11.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP11;
        
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
        
        objCaso2 = new Case();
        objCaso2.Fechaderadicacion__c = Date.today();
        objCaso2.Operadores__c = 'ETB';
        objCaso2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso2.Origin = 'Teléfono';
        objCaso2.Plan__c = objPlan.Id;
        objCaso2.Status = 'Abierto';
        objCaso2.Causal_Estado__c = 'Asignado';
        objCaso2.Subject = 'Prueba cambio plan';
        objCaso2.ContactId = objContact.id;
        objCaso2.Aprobaciones__c = 'Inicial';
        insert objCaso2;
        
        List<Case> lstCasos = new List<Case>();
        lstCasos = [SELECT AccountId, AccountNumber__c, Fechaderadicacion__c, Operadores__c, RecordTypeId, Origin, Plan__c, Status, Causal_Estado__c, Subject, ContactId, Aprobaciones__c, CaseNumber FROM Case WHERE Id = :objCaso.Id];
        objCaso = lstCasos.get(0);
        
        
    }
    
    
    
    
    
    
    static testMethod void myUnitTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        
        LTE_SeleccionTramiteCambioPlan_ctr testController;
        Test.startTest();
            PageReference pageRef = Page.LTE_SeleccionTramiteCambioPlan_pag;
            Test.setCurrentPage(pageRef);
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP6.Id;
            testController.tipoTramite = 'Voluntaria';
            testController.continuar();
            
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP2.Id;
            testController.tipoTramite = 'Cambio Número';
            testController.continuar();
            
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP3.Id;
            testController.tipoTramite = 'Voluntaria';
            testController.continuar();
            
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP4.Id;
            testController.tipoTramite = 'Bolsa Recurrente';
            testController.continuar();
            
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP1.Id;
            testController.tipoTramite = 'Bolsa Recurrente';
            testController.continuar();
            
        	testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP7.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
        
        	testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP8.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
        
        	testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP9.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
                
        	testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP10.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
        	
        	testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP11.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
        
            objCaso.Aprobaciones__c = 'xxxxxxx';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            objCaso.Aprobaciones__c = 'Enviado a aprobación';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            objCaso.Aprobaciones__c = 'Rechazado';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            objCaso.Aprobaciones__c = 'Enviado aprovisionamiento';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            objCaso.Aprobaciones__c = 'Inicial';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            objCaso.Aprobaciones__c = 'Aprobado';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso2));
            testController.tipoOperacion = objTOPP5.Id;
            testController.tipoTramite = 'LTE';
            testController.continuar();
            
            objCaso.Status = 'Cerrado';
            update objCaso;
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            
            //objCaso.AccountNumber__c = objAccount.AccountNumber;
            objCaso.Status = 'Abierto';
            objCaso.Causal_Estado__c = 'Asignado';
            objCaso.Subject = 'Prueba cambio plan';
            objCaso.ContactId = objContact.id;
            objCaso.Aprobaciones__c = 'Inicial';
            update objCaso;
            
            objCaso.Id = '50023000000q8S7';
            testController = new LTE_SeleccionTramiteCambioPlan_ctr(new Apexpages.Standardcontroller(objCaso));
            
        Test.stopTest();
        
    }
    
    //LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
    
}