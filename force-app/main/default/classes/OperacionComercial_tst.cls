/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 03-07-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
@isTest
public class OperacionComercial_tst {
    public static List<VariablesGlobales__c> lstVariablesGlobales;
    public static List<Perfiles_Reglas_OC__c> lstPerfilesReglasOC;
    public static List<LTE_APN__c> lstLTEAPN;
    public static Account objAccount;
    public static Contract objContrato;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static CuentaFacturacion__c objCtaFact;
    public static Contact objContact;
    public static Opportunity objOportunidad;
    public static Legalizacion__c objLegalizacion;
    public static CatalogoProductos__c objProducto;
    public static CatalogoProductos__c objProducto2;
    public static CatalogoProductos__c objProducto3;
    public static ActivoETB__c objServicio;
    public static ActivoETB__c objServicio2;
    public static TOPP__c objTOPP;
    public static TOPP__c objTOPP2;
    public static TOPP__c objTOPP3;
    public static TOPP__c objTOPP7; // Astrid
    public static TOPP__c objTOPPNSVenta; // AStrid
    public static Planes__c objPlan;
    public static Planes__c objPlan2;
    public static Planes__c objPlan3;
    public static Case objCaso;
    public static APN__c objAPN;
    public static POOL_APN__c tPool;
    public static List<IP__c> lstIP;
    public static Equipo__c tEq;
    public static List<SubPlanFacturacion__c> lstSbPlan;
    public static List<OperacionComercial__c> lstjOpComercial;
    public static OperacionComercial__c objOpComercial;
    public static OperacionComercial__c objOpComercial2;
    public static OperacionComercial__c objOpComercial3;
    public static OperacionComercial__c objOpComercial4;
    public static OperacionComercial__c objOpComercial5;
    public static OperacionComercial__c objOpComercial6;
    public static OperacionComercial__c objOpComercial8; // astrid
    public static OperacionComercial__c OCNegocioSeguroVenta; // AStrid
    public static Reserva__c objReserva;
    public static LTE_DetalleOferta__c ObjDetalleOferta;
    public static List<LTE_DetalleOferta__c> lstDetalleOferta;
    public static Viabilidad__c objViabilidad;
    public static Account accountSucursal;
    public static CatalogoProductos__c productoInternetDedicado;
    public static CatalogoProductos__c productoNegocioSeguro;
    public static Planes__c planInternetDedicado;
    public static Planes__c planNegocioSeguro;
    public static ActivoETB__c activoNegocioSeguro;
    public static ActivoETB__c activoInternetDedicado;

    // @TestSetup
    public static void CreateData(){
        
        lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialAPN';
        vGlobal.Valor__c = 'APN CORPORATIVO';
        lstVariablesGlobales.add(vGlobal);
        insert lstVariablesGlobales;
        
        lstLTEAPN = new List<LTE_APN__c>();
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        insert lstLTEAPN;
        
        lstPerfilesReglasOC = new List<Perfiles_Reglas_OC__c>();
        Perfiles_Reglas_OC__c vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario01';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zweAAA';
        vPerfil.Detalles__c = 'si la operación comercial no aplica para preventa y no tiene legalización';
        lstPerfilesReglasOC.add(vPerfil);
        vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario08';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zwYAAQ,00e400000014I5jAAE,00e400000013zwcAAA,00e40000001FZVvAAO,00e400000013zweAAA';
        vPerfil.Detalles__c = 'en estado activa o declinada';
        lstPerfilesReglasOC.add(vPerfil);
        insert lstPerfilesReglasOC;

        Perfiles_Acciones__c perfAcc = new Perfiles_Acciones__c(Name='ValidacionesOC',Usuarios__c='1');
        insert perfAcc;
        ReglasDesarrollos__c vReglasD = new ReglasDesarrollos__c(Name='OC1',Activo__c=true);
        insert vReglasD;

        objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;

        objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
        insert objMunicipio;

        objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana'; 
        ObjAccount.Phone = '3158181818';
        insert objAccount;

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
        objContact.Phone = '32432432';
        objContact.MobilePhone = '3105667655';
        objContact.Email = 'scampos@avanxo.com';
        objContact.Ciudad__c = objMunicipio.Id;
        objContact.Autoriza_Tratamiento_de_Datos_Personales__c='AUTORIZA';//'Si';
        insert objContact;

        accountSucursal = new Account();
        accountSucursal.Name = 'Cuenta Sucursal Test Name';
        accountSucursal.Cuenta__c = objAccount.Id;
        accountSucursal.Tipo_Sucursal__c = 'Principal';
        accountSucursal.Estado_Direccion__c = 'No Normalizada';
        accountSucursal.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sucursales').getRecordTypeId();
        accountSucursal.Ciudad__c = objMunicipio.Id;
        accountSucursal.Phone = '3213213210';
        accountSucursal.LTE_ContactoEntrega__c = objContact.Id;
        accountSucursal.Description = 'Suc Test';
        insert accountSucursal;

        productoInternetDedicado = new CatalogoProductos__c();
        productoInternetDedicado.Name = 'Internet Dedicado';
        productoInternetDedicado.Familia__c = 'Conectividad';
        productoInternetDedicado.LineaNegocio__c = 'INTERNET';
        productoInternetDedicado.CodigoProducto__c = '000111';
        productoInternetDedicado.Estado__c = 'Activo';
        productoInternetDedicado.Descripcion__c = 'Descripcion Internet Dedicado';
        productoInternetDedicado.AtributosEstandar__c = 'Atributos Estandar Internet Dedicado';
        productoInternetDedicado.Tipo_de_Producto__c = 'Avanzado';
        insert productoInternetDedicado;

        productoNegocioSeguro = new CatalogoProductos__c();
        productoNegocioSeguro.Name = 'Negocio Seguro';
        productoNegocioSeguro.Familia__c = 'Conectividad';
        productoNegocioSeguro.LineaNegocio__c = 'INTERNET';
        productoNegocioSeguro.CodigoProducto__c = '000222';
        productoNegocioSeguro.Estado__c = 'Activo';
        productoNegocioSeguro.Descripcion__c = 'Descripcion Negocio Seguro';
        productoNegocioSeguro.AtributosEstandar__c = 'Atributos Estandar Negocio Seguro';
        productoNegocioSeguro.Tipo_de_Producto__c = 'Avanzado';
        insert productoNegocioSeguro;

        planInternetDedicado = new Planes__c ();
        planInternetDedicado.Name = 'Plan Internet Dedicado Empresa Colaborativa';
        planInternetDedicado.NombredelProducto__c = productoInternetDedicado.Id;
        planInternetDedicado.TipodePlan__c = 'Principal';
        planInternetDedicado.Tarifa__c = 1000;
        planInternetDedicado.Estado__c = 'Activo';
        planInternetDedicado.Descripcion__c = 'Descripcion Plan Internet Dedicado Empresa Colaborativa';
        planInternetDedicado.CondicionesComerciales__c = 'Condiciones Comerciales Plan Internet Dedicado Empresa Colaborativa';
        insert planInternetDedicado;

        planNegocioSeguro = new Planes__c ();
        planNegocioSeguro.Name = 'Plan Negocio Seguro Mipymes';
        planNegocioSeguro.NombredelProducto__c = productoNegocioSeguro.Id;
        planNegocioSeguro.TipodePlan__c = 'Principal';
        planNegocioSeguro.Tarifa__c = 1000;
        planNegocioSeguro.Estado__c = 'Activo';
        planNegocioSeguro.Descripcion__c = 'Descripcion Plan Negocio Seguro Mipymes';
        planNegocioSeguro.CondicionesComerciales__c = 'Condiciones Comerciales Plan Negocio Seguro Mipymes';
        insert planNegocioSeguro;

        activoNegocioSeguro = new ActivoETB__c();
        activoNegocioSeguro.NombredelaCuenta__c = objAccount.Id;
        activoNegocioSeguro.NombredelProducto__c = productoNegocioSeguro.Id;
        activoNegocioSeguro.Plan__c = planNegocioSeguro.Id;
        activoNegocioSeguro.Estado__c = 'Activo';
        activoNegocioSeguro.Fecha_Activacion__c = System.now();
        insert activoNegocioSeguro;

        activoInternetDedicado = new ActivoETB__c();
        activoInternetDedicado.NombredelaCuenta__c = objAccount.Id;
        activoInternetDedicado.NombredelProducto__c = productoInternetDedicado.Id;
        activoInternetDedicado.Plan__c = planInternetDedicado.Id;
        activoInternetDedicado.Estado__c = 'Activo';
        activoInternetDedicado.Fecha_Activacion__c = System.now();
        activoInternetDedicado.Activo_Relacionado__c = activoNegocioSeguro.Id;
        insert activoInternetDedicado;

        objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;

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

        Numero__c num = new Numero__c();
        num.name = '123';
        insert num;
        
        objAPN = new APN__c();
        objAPN.Charguing_Characteristics__c = '100';
        objAPN.Cuenta_Cliente__c = objAccount.Id;
        objAPN.Estado__c = 'Disponible';
        objAPN.Servicio__c = 'DATOS';
        objAPN.APN__c = 'empresas.etb.net.co';
        objAPN.Identificador_APN__c = '4';
        insert objAPN;
        
        tPool = new POOL_APN__c();
        tPool.Pooles__c = '170.0.0.1/Test';
        tPool.Niveles__c = 'BASICO';
        tPool.Producto__c = 'DATOS';
        tPool.Direccionamiento__c = 'ESTÁTICO';
        tPool.Estado__c = 'Disponible';
        tPool.IP_Inicial__c = '170.0.0.2';
        tPool.IP_Final__c = '170.0.0.3';
        tPool.APN__c = objAPN.Id;
        insert tPool;
        
        lstIP = new List<IP__c>();
        Integer iEquipo = 0;
        while(iEquipo<15){
            IP__c objIP = new IP__c();
            objIP.Name = '170.0.0.'+String.valueOf(iEquipo);
            objIP.Estado__c = 'Disponible';
            objIP.POOL_de_APN__c = tPool.Id;
            objIP.APN__c = objAPN.Id;
            lstIP.add(objIP);
            iEquipo++;
        }
        insert lstIP;
        
        lstSbPlan = new List<SubPlanFacturacion__c>();
        SubPlanFacturacion__c tSbPlan = new SubPlanFacturacion__c();
        tSbPlan.Name = 'SVA APN RECURRENTE';
        tSbPlan.Codigo__c = 'SVA APN RECURRENTE';
        lstSbPlan.add(tSbPlan);
        tSbPlan = new SubPlanFacturacion__c();
        tSbPlan.Name = 'SVA APN NO RECURRENTE';
        tSbPlan.Codigo__c = 'SVA APN NO RECURRENTE';
        lstSbPlan.add(tSbPlan);
        insert lstSbPlan;
        
        tEq = new Equipo__c();
        tEq.Name = 'SAMSUNG Galaxy Test';
        tEq.LTE_PartNumber__c = 'ETB-Test';
        tEq.Tipo__c = 'Equipo';
        tEq.Valor_del_Equipo__c = 100;
        tEq.LTE_Activo__c = True;
        insert tEq;

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
        objProducto.Crear_Linea__c=true;
        insert objProducto;

        objProducto3 = new CatalogoProductos__c();
        objProducto3.Name = 'Convenio de cupo';
        objProducto3.Familia__c = 'LARGA DISTANCIA';
        objProducto3.LineaNegocio__c = 'LARGA DISTANCIA';
        objProducto3.CodigoProducto__c = 'Conveniodecupo001';
        objProducto3.Estado__c = 'Activo';
        objProducto3.Descripcion__c = 'Teste';
        objProducto3.AtributosEstandar__c = 'Teste';
        objProducto3.Crear_Linea__c=true;
        insert objProducto3;

        objProducto2 = new CatalogoProductos__c();
        objProducto2.Name = 'APN CORPORATIVO';
        objProducto2.Familia__c = 'LTE';
        objProducto2.LineaNegocio__c = 'Redes Móviles';
        objProducto2.CodigoProducto__c = '222222';
        objProducto2.Estado__c = 'Activo';
        objProducto2.Descripcion__c = 'APN Moviles Test';
        objProducto2.AtributosEstandar__c = 'APN Moviles Teste';
        objProducto2.Crear_Linea__c=true;
        insert objProducto2;

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

        objPlan2 = new Planes__c ();
        objPlan2.Name = 'APN PARA SERVICIOS DE DATOS';
        objPlan2.NombredelProducto__c = objProducto2.Id;
        objPlan2.TipodePlan__c = 'Principal';
        objPlan2.Tarifa__c = 0;
        objPlan2.Estado__c = 'Activo';
        objPlan2.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
        objPlan2.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
        objPlan2.LTE_PlanEstructurados__c = false;
        insert objPlan2;

        objPlan3 = new Planes__c ();
        objPlan3.Name = 'Plan Larga Distancia Convenio de Cupo';
        objPlan3.NombredelProducto__c = objProducto3.Id;
        objPlan3.TipodePlan__c = 'Principal';
        objPlan3.Tarifa__c = 0;
        objPlan3.Estado__c = 'Activo';
        objPlan3.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
        objPlan3.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
        objPlan3.LTE_PlanEstructurados__c = false;
        insert objPlan3;
        
        Planes__c objPlan4 = new Planes__c ();
        objPlan4.Name = 'Troncal SIP Movil 600.000 Min 3.0';
        objPlan4.NombredelProducto__c = objProducto.Id;
        objPlan4.TipodePlan__c = 'Troncal SIP';
        objPlan4.Tarifa__c = 0;
        objPlan4.Estado__c = 'Activo';
        objPlan4.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
        objPlan4.CondicionesComerciales__c = 'Tarificacion por segundo';
        objPlan4.LTE_PlanEstructurados__c = false;
        insert objPlan4;
        
        objTOPP = new TOPP__c();
        objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
        objTOPP.TipodeOperacionporplan__c = 'Venta';
        objTOPP.Tipoderegistro__c = 'Venta_LTE';
        objTOPP.AplicaPreventa__c=true;
        objTOPP.DisponibleVentainicial__c = true;
        objTOPP.Facturable__c = true;
        objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP;

        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Venta- APN PARA SERVICIOS DE DATOS';
        objTOPP2.TipodeOperacionporplan__c = 'Venta';
        objTOPP2.Tipoderegistro__c = 'VentaAPN';
        objTOPP2.AplicaPreventa__c=true;
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = false;
        objTOPP2.Plan__c = objPlan2.Id;
        insert objTOPP2;

        objTOPP3 = new TOPP__c();
        objTOPP3.Name = 'Venta- Plan Larga Distancia Covenio de Voz';
        objTOPP3.TipodeOperacionporplan__c = 'Venta';
        objTOPP3.Tipoderegistro__c = 'Venta';
        objTOPP3.AplicaPreventa__c=false;
        objTOPP3.DisponibleVentainicial__c = true;
        objTOPP3.Facturable__c = false;
        objTOPP3.Plan__c = objPlan3.Id;
        insert objTOPP3;
        
        TOPP__c objTOPP5 = new TOPP__c();
        objTOPP5.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        objTOPP5.TipodeOperacionporplan__c = 'Cambio de Plan';
        objTOPP5.Tipoderegistro__c = 'CambioPlan_LTE';
        objTOPP5.AplicaPreventa__c=false;
        objTOPP5.DisponibleVentainicial__c = true;
        objTOPP5.Facturable__c = true;
        objTOPP5.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP5;

        TOPP__c objTOPP4 = new TOPP__c();
        objTOPP4.Name = 'Adición Lineas de LD- Plan Larga Distancia Convenio de Cupo';
        objTOPP4.TipodeOperacionporplan__c = 'Adición Lineas de LD';
        objTOPP4.Tipoderegistro__c = 'AdicionLineas';
        objTOPP4.AplicaPreventa__c=true;
        objTOPP4.DisponibleVentainicial__c = true;
        objTOPP4.Facturable__c = false;
        objTOPP4.Plan__c = objPlan3.Id;
        insert objTOPP4;
        
        objTOPP3.Operacion_Relacionada__c = objTOPP4.Id;
        update objTOPP3;
        
         // AStrid
        TOPP__c objTOPP7  = new TOPP__c();
		objTOPP7.Name  = 'Venta- Plan Internet Dedicado';
		objTOPP7.TipodeOperacionporplan__c = 'Venta';
		//objTOPP7.Tipo_de_Operacion_por_plan_Tramite_Unico__c = 'Suspensión';
		objTOPP7.Tipoderegistro__c = 'Venta_Int_Dedidado_Empresarial';
        objTOPP7.AplicaPreventa__c=true;
		objTOPP7.Activo__c = true;
		objTOPP7.Plan__c  = planInternetDedicado.id;                      
		insert objTOPP7;
        
        TOPP__c objTOPPNSVenta = new TOPP__c();
        objTOPPNSVenta.Name = 'Venta- Plan Negocio Seguro Mipymes';
        objTOPPNSVenta.TipodeOperacionporplan__c = 'Venta';
        objTOPPNSVenta.Tipoderegistro__c = 'Venta';
        //objTOPPNSVenta.AplicaPreventa__ c = false;
        objTOPPNSVenta.DisponibleVentainicial__c = true;
        objTOPPNSVenta.Facturable__c = true;
        
        insert objTOPPNSVenta;
        
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
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
        objServicio2.APN__c = objAPN.Id;
        objServicio2.Tipo_de_APN__c = 'Datos';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;

        objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        //objCaso.AccountNumber__c = objAccount.AccountNumber;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan2.Id;
        objCaso.Status = 'Abierto';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
        insert objCaso;
        
        lstjOpComercial = new List<OperacionComercial__c>();
        Integer iOpComercial = 0;
        while(iOpComercial<10){
            objOpComercial = new OperacionComercial__c();
            objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
            objOpComercial.CuentaCliente__c = objAccount.Id;
            objOpComercial.Activo__c = objServicio.Id;
            objOpComercial.Plan__c = objPlan.Id;
            objOpComercial.TOPP__c = objTOPP.Id;
            objOpComercial.Oportunidad__c = objOportunidad.Id;
            objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
            objOpComercial.Estado__c = 'En Curso';
            objOpComercial.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
            objOpComercial.FechadeActivacion__c = system.today();
            objOpComercial.Legalizacion__c = objLegalizacion.Id;
            lstjOpComercial.add(objOpComercial);
            iOpComercial++;
        }
        
        insert lstjOpComercial;
        
        objReserva = new Reserva__c();
        objReserva.Equipo__c = tEq.Id;
        insert objReserva;
        
        iOpComercial = 0;
        lstDetalleOferta = new List<LTE_DetalleOferta__c>();
        while(iOpComercial<10){
            ObjDetalleOferta = new LTE_DetalleOferta__c();
            ObjDetalleOferta.LTE_OperacionComercial__c = objOpComercial.Id;
            ObjDetalleOferta.LTE_Oferta_Economica__c = objReserva.Id;
            lstDetalleOferta.add(ObjDetalleOferta);
            iOpComercial++;
        }
        insert lstDetalleOferta;
        
        objOpComercial2 = new OperacionComercial__c();
        objOpComercial2.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('VentaAPN').getRecordTypeId();
        objOpComercial2.CuentaCliente__c = objAccount.Id;
        objOpComercial2.Activo__c = objServicio2.Id;
        objOpComercial2.Plan__c = objPlan2.Id;
        objOpComercial2.TOPP__c = objTOPP3.Id;
        objOpComercial2.Oportunidad__c = objOportunidad.Id;
        objOpComercial2.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial2.Estado__c = 'En Curso';
        objOpComercial2.NumeroConexion__c = '3057000501';
        objOpComercial2.FechadeActivacion__c = system.today();
        objOpComercial2.Tipo_de_APN__c = 'Datos';
        objOpComercial2.Tipo_de_Plan_APN__c = 'APN Datos UM Principal (Sede Fija)';
        objOpComercial2.Legalizacion__c = objLegalizacion.Id;
        //insert objOpComercial2;
        
        
        objOpComercial3 = new OperacionComercial__c();
        objOpComercial3.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
        objOpComercial3.CuentaCliente__c = objAccount.Id;
        objOpComercial3.Activo__c = objServicio.Id;
        objOpComercial3.Plan__c = objPlan.Id;
        objOpComercial3.TOPP__c = objTOPP3.Id;
        objOpComercial3.Oportunidad__c = objOportunidad.Id;
        objOpComercial3.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial3.Estado__c = 'En Curso';
        objOpComercial3.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
        objOpComercial3.FechadeActivacion__c = system.today();
        objOpComercial3.Legalizacion__c = objLegalizacion.Id;
        //insert objOpComercial3;
        
        objOpComercial4 = new OperacionComercial__c();
        objOpComercial4.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
        objOpComercial4.CuentaCliente__c = objAccount.Id;
        objOpComercial4.Activo__c = objServicio.Id;
        objOpComercial4.Plan__c = objPlan4.Id;
        objOpComercial4.TOPP__c = objTOPP5.Id;
        objOpComercial4.Oportunidad__c = objOportunidad.Id;
        objOpComercial4.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial4.Estado__c = 'En Curso';
        objOpComercial4.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
        objOpComercial4.FechadeActivacion__c = system.today();
        objOpComercial4.Legalizacion__c = objLegalizacion.Id;
        //insert objOpComercial4;

        objOpComercial5 = new OperacionComercial__c();
        objOpComercial5.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
        objOpComercial5.CuentaCliente__c = objAccount.Id;
        objOpComercial5.Activo__c = objServicio.Id;
        objOpComercial5.Plan__c = objPlan.Id;
        objOpComercial5.TOPP__c = objTOPP.Id;
        objOpComercial5.Oportunidad__c = objOportunidad.Id;
        objOpComercial5.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial5.Estado__c = 'En Curso';
        objOpComercial5.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
        objOpComercial5.FechadeActivacion__c = system.today();
        objOpComercial5.Legalizacion__c = objLegalizacion.Id;
        objOpComercial5.Numero_Abreviado__c = num.Id;
        //insert objOpComercial5;
       
        //AStrid
        OCNegocioSeguroVenta = new OperacionComercial__c();
        OCNegocioSeguroVenta.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta').getRecordTypeId();
        OCNegocioSeguroVenta.CuentaCliente__c = objAccount.Id;
        OCNegocioSeguroVenta.Activo__c = activoNegocioSeguro.Id;
        OCNegocioSeguroVenta.Plan__c = planNegocioSeguro.Id;
        OCNegocioSeguroVenta.TOPP__c = objTOPPNSVenta.Id;
        OCNegocioSeguroVenta.Oportunidad__c = objOportunidad.Id;
        OCNegocioSeguroVenta.CuentaFacturacion__c = objCtaFact.Id;
        OCNegocioSeguroVenta.Estado__c = 'En Curso';
        OCNegocioSeguroVenta.NumeroConexion__c = (String.valueOf(iOpComercial).length() == 1)? '305700050'+String.valueOf(iOpComercial):'30570005'+String.valueOf(iOpComercial);
        OCNegocioSeguroVenta.FechadeActivacion__c = system.today();
        OCNegocioSeguroVenta.Legalizacion__c = objLegalizacion.Id;
        OCNegocioSeguroVenta.Numero_Abreviado__c = num.Id;
        OCNegocioSeguroVenta.ValorTarifaPlan__c = 123000;
        OCNegocioSeguroVenta.Valor_Recurrente_Aliado__c = 12000;
        insert OCNegocioSeguroVenta;
        
        List<OperacionComercial__c> lstOp = new List<OperacionComercial__c>();
        lstOp.add(objOpComercial5);
        lstOp.add(objOpComercial4);
        lstOp.add(objOpComercial3);
        lstOp.add(objOpComercial2);
        insert lstOp;
        
        objOpComercial6 = new OperacionComercial__c();
        objOpComercial6.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
        objOpComercial6.CuentaCliente__c = objAccount.Id;
        objOpComercial6.Activo__c = objServicio2.Id;
        objOpComercial6.Plan__c = objPlan2.Id;
        objOpComercial6.TOPP__c = objTOPP3.Id;
        objOpComercial6.Oportunidad__c = objOportunidad.Id;
        objOpComercial6.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial6.Estado__c = 'En Curso';
        objOpComercial6.NumeroConexion__c = '3057000501';
        objOpComercial6.FechadeActivacion__c = system.today();
        objOpComercial6.Tipo_de_APN__c = 'Datos';
        objOpComercial6.Tipo_de_Plan_APN__c = 'APN Datos UM Principal (Sede Fija)';
        objOpComercial6.Legalizacion__c = objLegalizacion.Id;
        
        LTE_DetalleOferta__c ObjDetalleOfertaSIP = new LTE_DetalleOferta__c();
        ObjDetalleOfertaSIP.LTE_OperacionComercial__c = objOpComercial4.Id;
        ObjDetalleOfertaSIP.LTE_Oferta_Economica__c = objReserva.Id;
        insert ObjDetalleOfertaSIP;
        
        LTE_Servicios_adicionales__c svaSIP = new LTE_Servicios_adicionales__c();
        svaSIP.Name = 'Troncal SIP Canales';
        svaSIP.LTE_DetalleOfertaEReservadoRegContable__c = ObjDetalleOfertaSIP.Id;
        insert svaSIP;
        
        List<LTE_SpecificationGroupXA__c> lstXA = new List<LTE_SpecificationGroupXA__c>();
        lstXA.add(new LTE_SpecificationGroupXA__c(Name = 'RVC PARM Cargo LTE ETB',LTE_ServiciosAdicionales__c=svaSIP.Id));
        lstXA.add(new LTE_SpecificationGroupXA__c(Name = 'RVC PARM Cargo EMP ETB',LTE_ServiciosAdicionales__c=svaSIP.Id));
        lstXA.add(new LTE_SpecificationGroupXA__c(Name = 'RVC PARM CargoDS',LTE_ServiciosAdicionales__c=svaSIP.Id,Servicio_adicional1__c='Troncal SIP Canales'));
        lstXA.add(new LTE_SpecificationGroupXA__c(Name = 'RVC PARM Index DS',LTE_ServiciosAdicionales__c=svaSIP.Id,Servicio_adicional1__c='Troncal SIP Canales'));
        insert lstXA;
        
        objViabilidad = new Viabilidad__c();
        //objViabilidad.OperacionComercial__c = objOpComercial2.Id;
        objViabilidad.EstadoViabilidad__c = 'Pendiente';
        insert objViabilidad;
        
        LTE_Servicios_adicionales__c svaAutomatico = new LTE_Servicios_adicionales__c();
        svaAutomatico.Name = 'SVA Automatico desde TOPP';
        svaAutomatico.Tipo_Operacion_por_Plan__c = objTOPP3.Id;
        insert svaAutomatico;
    }
    
    static testMethod void IPDataTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
            delete lstIP;
            IP__c testIP = new IP__c();
            testIP.Name = '170.0.0.1';
            testIP.Estado__c = 'Disponible';
            testIP.POOL_de_APN__c = tPool.Id;
            insert testIP;
        Test.stopTest();
    }
    
    static testMethod void PoolDataTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
            tPool.APN__c = null;
            update tPool;   
            tPool.APN__c = objAPN.Id;
            update tPool;   
        Test.stopTest();
    }
    
    static testMethod void ViabilidadAprobadaTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
        String strEstadoAPN = vGlobalAPN.get('EstadosViaAPN').valor__c;
        List<String> lstEstadoAPN = new List<String>(strEstadoAPN.split(','));
        Test.startTest();
            objViabilidad.OperacionComercial__c = objOpComercial2.Id;
            objViabilidad.Respuestadeviabilidad__c = 'Viable';
            objViabilidad.EstadoViabilidad__c = lstEstadoAPN[0];
            objViabilidad.Crear_VIA_de_Lineas_LTE__c = true;
            objViabilidad.APN__c=objAPN.Id;
            update objViabilidad;   
        Test.stopTest();
    }
    
    static testMethod void DeclinacionOCTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
        String strEstadoAPN = vGlobalAPN.get('EstadosViaAPN').valor__c;
        List<String> lstEstadoAPN = new List<String>(strEstadoAPN.split(','));
        objViabilidad.OperacionComercial__c = objOpComercial2.Id;
        objViabilidad.Respuestadeviabilidad__c = 'Viable';
        objViabilidad.Crear_VIA_de_Lineas_LTE__c = true;
        objViabilidad.EstadoViabilidad__c = lstEstadoAPN[0];
        objViabilidad.APN__c=objAPN.Id;
        system.debug(objOpComercial2.Id);
        update objViabilidad;
        objViabilidad.EstadoViabilidad__c = 'Cerrada';
        update objViabilidad;
        Test.startTest();
        system.debug('Start_Test');
            objOpComercial2.Estado__c = 'Declinada';
            update objOpComercial2;
        Test.stopTest();
    }
    
    static testMethod void PoolInternetTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
        String strEstadoAPN = vGlobalAPN.get('EstadosViaAPN').valor__c;
        List<String> lstEstadoAPN = new List<String>(strEstadoAPN.split(','));
        Test.startTest();
            objOpComercial2.Tipo_de_APN__c = 'Internet';
            update objOpComercial2;
            objViabilidad.OperacionComercial__c = objOpComercial2.Id;
            objViabilidad.Respuestadeviabilidad__c = 'Viable';
            objViabilidad.EstadoViabilidad__c = lstEstadoAPN[0];
            objViabilidad.Crear_VIA_de_Lineas_LTE__c = true;
            objViabilidad.APN__c=objAPN.Id;
            update objViabilidad;
        Test.stopTest();
    }
    
    static testMethod void AplicaAPNTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
            String res = ProcesosAPN_cls.MarcarActualizaAPN(String.valueOf(objOportunidad.Id));
        Test.stopTest();
    }
    
    static testMethod void DeclinaACTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
            objServicio2.POOL_de_APN__c = tPool.Id;
            objServicio2.IP__c = lstIP[0].Id;
            update objServicio2;
            objServicio2.Estado__c = 'Inactivo';
            update objServicio2;
        Test.stopTest();
    }
    
    static testMethod void UpdateLDTest(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        OperacionComercial__c objOpComercialtemp = [SELECT Id,TOPP__r.Name FROM OperacionComercial__c WHERE Id=:objOpComercial3.Id];
        system.debug(objOpComercialtemp.TOPP__r.Name);
        objOpComercialtemp.Estado__c = 'Facturado';
        update objOpComercialtemp;
        Test.stopTest();
    }
    
    static testMethod void UpdateLDTest02(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        OperacionComercial__c objOpComercialtemp = [SELECT Id,TOPP__r.Name FROM OperacionComercial__c WHERE Id=:objOpComercial3.Id];
        system.debug(objOpComercialtemp.TOPP__r.Name);
        objOpComercialtemp.Estado__c = 'Activa';
        objOpComercialtemp.EnvGteProy__c = Datetime.now();
        update objOpComercialtemp;
        Test.stopTest();
    }
    
    static testMethod void TroncalSip(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        objOpComercial4.Estado__c = 'Activa';
        objOpComercial4.NumeroCanales__c = 120;
        update objOpComercial4;
        Test.stopTest();
    }
    
    static testMethod void NumeracionAbreviada(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        Numero__c num = [Select Id FROM Numero__c WHERE name = '123'];
        num.OperacionComercial__c = objOpComercial5.Id;
        update num;
        
        objOpComercial5.Estado__c = 'Declinada';
        update objOpComercial5;
        Test.stopTest();
    }
    
    /*
    static testMethod void UpdateNumeracionAbreviada(){	
        //Se crean datos necesarios para prueba	
        CreateData();	
        Test.startTest();	
        Numero__c num = [Select Id FROM Numero__c WHERE name = '123'];	
        objOpComercial5.Numero_Abreviado__c = num.Id;	
        update num;	
        Numero__c newNum = new Numero__c(Name='1234');	
        objOpComercial5.Numero_Abreviado__c = newNum.Id;	
        update num;	
        Test.stopTest();	  
    }
	*/
    
    static testMethod void SVA_Automaticos(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        insert objOpComercial6;
        Test.stopTest();
    }
    
    static testMethod void CalculoValoresMonetariostst(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        objOpComercial4.Valor_unica_Vez_Aliado__c = 100000;
        update objOpComercial4;
        Test.stopTest();
    }
    
    static testMethod void actualizarCodigoCCE(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        objOpComercial4.Legalizacion__c = null;
        objOpComercial4.Colombia_Compra_Eficiente__c = 'Si Aplica';
        objOpComercial4.Funcionalidades__c = 'Experto Senior en Blockchain;Experto Senior en Servidores y Aplicaciones Web;Sesión formación o capacitación;Soporte Complementario;Soporte Premium';
        objOpComercial4.Tipo_de_Plan__c = 'Plan Servicios Profesionales';
        objOpComercial4.Zona__c = 'Zona 1';
        objOpComercial4.RecordTypeId = Schema.Sobjecttype.OperacionComercial__c.getRecordTypeInfosByName().get('Venta_NubePublica').getRecordTypeId();
        objOpComercial4.TipodeServicioMS__c = 'Nube Pública AWS';
        update objOpComercial4;
        Test.stopTest();
    }

   /* @isTest
    static void retiroOCConNegocioSeguro(){

        CreateData();
        Id idOCRecordTypeRetiros = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByDeveloperName().get('Retiros').getRecordTypeId();

        OperacionComercial__c OCRetiro = new OperacionComercial__c();
        OCRetiro.CuentaCliente__c = objAccount.Id;
        OCRetiro.Activo__c = activoInternetDedicado.Id;
        OCRetiro.RecordTypeId = idOCRecordTypeRetiros;
        OCRetiro.SucursalOrigen__c = accountSucursal.Id;
        OCRetiro.FechaRetiro__c = Date.today();
        OCRetiro.CausalRetiro__c = 'No Uso o Poco Uso';

        Test.startTest();
        Database.SaveResult resultadoInsertOC = Database.insert(OCRetiro, false);
        Test.stopTest();

        System.debug(resultadoInsertOC);
        System.assertEquals('El producto principal Internet Dedicado aún cuenta con un Negocio Seguro activo', resultadoInsertOC.getErrors()[0].getMessage());

    }*/

    /*@isTest
    static void retiroOCSinNegocioSeguro(){

        CreateData();
        Id idOCRecordTypeRetiros = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByDeveloperName().get('Retiros').getRecordTypeId();

        ActivoETB__c activoNegocioSeguro = [SELECT Id, Estado__c, NombredelProducto__r.name FROM ActivoETB__c WHERE NombredelProducto__r.name = 'Negocio Seguro'];
        activoNegocioSeguro.Estado__c = 'Inactivo';
        update activoNegocioSeguro;

        OperacionComercial__c OCRetiro = new OperacionComercial__c();
        OCRetiro.CuentaCliente__c = objAccount.Id;
        OCRetiro.Activo__c = activoInternetDedicado.Id;
        OCRetiro.RecordTypeId = idOCRecordTypeRetiros;
        OCRetiro.SucursalOrigen__c = accountSucursal.Id;
        OCRetiro.FechaRetiro__c = Date.today();
        OCRetiro.CausalRetiro__c = 'No Uso o Poco Uso';

        Test.startTest();
        insert OCRetiro;
        Test.stopTest();

        OperacionComercial__c ocRetiroConsulta = [SELECT Id FROM OperacionComercial__c WHERE Id = :OCRetiro.Id];

        System.assertEquals(true, ocRetiroConsulta != null);

    }*/
    
    /*static testMethod void NegocioSeguro(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        
        objOpComercial8 = new OperacionComercial__c();
        objOpComercial8.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta_Int_Dedidado_Empresarial').getRecordTypeId();
        objOpComercial8.CuentaCliente__c = objAccount.Id;
        objOpComercial8.Activo__c = activoInternetDedicado.Id;
        objOpComercial8.Plan__c = planInternetDedicado.Id;
        objOpComercial8.Oportunidad__c = objOportunidad.Id;
        objOpComercial8.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial8.SucursalOrigen__c = accountSucursal.Id;
        objOpComercial8.Estado__c = 'Activo';
        objOpComercial8.FechadeActivacion__c = system.today();
        objOpComercial8.Legalizacion__c = objLegalizacion.Id;
                
        Test.startTest();
        insert objOpComercial8;
                
        OCNegocioSeguroVenta.Operacion_Comercial_Relacionada__c = objOpComercial8.Id;
        update OCNegocioSeguroVenta;
        Test.stopTest();
    }*/
}