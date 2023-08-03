/*******************************************************************************
Desarrollado por:       SQDM
Autor:                  John Guevara
Proyecto:               ETB - Proyecto LTE
Descripción:            Clase de prueba encargada de realizar las pruebas del APN

Cambios (Versiones)
-------------------------------------
No.     Fecha(DD-MM-YYYY)       Autor                       Descripción
------  -----------------   --------------------        -----------------------
1.0     28-09-2016          John Guevara (SQDM)         Creación de la clase..
1.1     12-07-2018          Fernando Sarasty (FS)       Se modifica método CreateData, para incluir en la creación del objeto Poblacion__c, el campo Tipo_de_instalacion__c
*******************************************************************************/
@isTest
public class ProcesosAPN_tst {
    
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
    public static ActivoETB__c objServicio;
    public static ActivoETB__c objServicio2;
    public static TOPP__c objTOPP;
    public static TOPP__c objTOPP2;
    public static Planes__c objPlan;
    public static Planes__c objPlan2;
    public static Case objCaso;
    public static APN__c objAPN;
    public static POOL_APN__c tPool;
    public static List<IP__c> lstIP;
    public static Equipo__c tEq;
    public static List<SubPlanFacturacion__c> lstSbPlan;
    public static List<OperacionComercial__c> lstjOpComercial;
    public static OperacionComercial__c objOpComercial;
    public static OperacionComercial__c objOpComercial2;
    public static Reserva__c objReserva;
    public static LTE_DetalleOferta__c ObjDetalleOferta;
    public static List<LTE_DetalleOferta__c> lstDetalleOferta;
    public static Viabilidad__c objViabilidad;
    
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

        objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        ObjAccount.Phone = '3158181818';
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
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;

        objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
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
        objContact.Phone = '32432432';
        objContact.MobilePhone = '3105667655';
        objContact.Email = 'scampos@avanxo.com';
        objContact.Ciudad__c = objMunicipio.Id;
        insert objContact;
        
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
        while(iEquipo<10){
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
        objOpComercial2.TOPP__c = objTOPP2.Id;
        objOpComercial2.Oportunidad__c = objOportunidad.Id;
        objOpComercial2.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial2.Estado__c = 'En Curso';
        objOpComercial2.NumeroConexion__c = '3057000501';
        objOpComercial2.FechadeActivacion__c = system.today();
        objOpComercial2.Tipo_de_APN__c = 'Datos';
        objOpComercial2.Tipo_de_Plan_APN__c = 'APN Datos UM Principal (Sede Fija)';
        objOpComercial2.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial2;
        
        objViabilidad = new Viabilidad__c();
        //objViabilidad.OperacionComercial__c = objOpComercial2.Id;
        objViabilidad.EstadoViabilidad__c = 'Pendiente';
        insert objViabilidad;
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
        update objViabilidad;
        objViabilidad.EstadoViabilidad__c = 'Cerrada';
        update objViabilidad;
        Test.startTest();
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
    
    static testMethod void ActualizarEstadosOCTest(){    
        CreateData();
        List<Legalizacion__c> Leg = [SELECT Id, name FROM Legalizacion__c];
        String Response ='';
        VariablesGlobales__c setting = new VariablesGlobales__c();
        setting.Name = 'EstadoActualizaOC';
        setting.Valor__c = 'Equipo entregado';
        insert setting;
        test.startTest();
        try {
          Response = ProcesosAPN_cls.ActualizarEstadosOC(String.valueOf(Leg[0].Id));
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
    }

}