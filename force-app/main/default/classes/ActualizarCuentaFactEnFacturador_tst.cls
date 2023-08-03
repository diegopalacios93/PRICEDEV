/*******************************************************************************
Develope by:            ETB
Author:                 Samuel Rodriguez 
Project:                Jerarquia de Cuentas   
Description:            Clase de prueba para clase encargada de de la actualización de los datos sobre cuentas de facturación.

Cambios (Versiones)
--------------------------------------------------------------
No.      Date          Author                  Description
-----    ----------    --------------------    ---------------
1.0      10/05/2020    Samuel Rodriguez        Class creation.
*******************************************************************************/
@isTest
public class ActualizarCuentaFactEnFacturador_tst {
    
      public static List<VariablesGlobales__c> lstVariablesGlobales;
    public static List<Perfiles_Reglas_OC__c> lstPerfilesReglasOC;
    public static List<LTE_APN__c> lstLTEAPN;
    public static Account objAccount;
    public static Contract objContrato;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static CuentaFacturacion__c objCtaFact;
    public static CuentaFacturacion__c objCtaFact2;
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
    public static Planes__c objPlan;
    public static Planes__c objPlan2;
    public static APN__c objAPN;

    public static List<SubPlanFacturacion__c> lstSbPlan;
    public static List<OperacionComercial__c> lstjOpComercial;
    public static OperacionComercial__c objOpComercial;
    public static OperacionComercial__c objOpComercial2;
    
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
        objCtaFact.CodCicloFac__c = '96';
        objCtaFact.LTE_Email__c = 'test@test.com';
        objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        objCtaFact.Fue_creada_en_revchain__c = true; 
        objCtaFact.Fue_creada_en_RMCA__c = true;
        objCtaFact.Fue_creada_en_MDM__c = true;
        insert objCtaFact;
            
        objCtaFact2 = new CuentaFacturacion__c();
        objCtaFact2.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact2.Cliente__c = objAccount.Id;
        objCtaFact2.Facturable__c = true;
        objCtaFact2.LTE_MetodoEnvio__c = 'Email';
        objCtaFact2.LTE_CicloFacturacion__c = '5';
        objCtaFact2.LTE_Email__c = 'test@test.com';
        objCtaFact2.LTE_DireccionFacturacion__c = 'Direccion test';
        objCtaFact2.Ciudad__c = objMunicipio.Id;
        objCtaFact2.LTE_CuentaFacturacionLTE__c = false;
        objCtaFact2.DirCorresp__c = 'Test DirCorresp';
        objCtaFact2.Fue_creada_en_revchain__c = true; 
        objCtaFact2.Fue_creada_en_RMCA__c = true;
        objCtaFact2.Fue_creada_en_MDM__c = true;
        insert objCtaFact2;

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
        objContact.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
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
        objProducto.Crear_Linea__c=true;
        insert objProducto;

        objProducto2 = new CatalogoProductos__c();
        objProducto2.Name = 'Convenio de cupo';
        objProducto2.Familia__c = 'LARGA DISTANCIA';
        objProducto2.LineaNegocio__c = 'LARGA DISTANCIA';
        objProducto2.CodigoProducto__c = 'Conveniodecupo001';
        objProducto2.Estado__c = 'Activo';
        objProducto2.Descripcion__c = 'Teste';
        objProducto2.AtributosEstandar__c = 'Teste';
        objProducto2.Crear_Linea__c=true;
        insert objProducto2;

        objPlan = new Planes__c ();
        objPlan.Name = 'Plan Datos a la Medida 30GB (2GB 3G/4G - 28GB 4G)';
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
        objPlan2.Name = 'Plan Larga Distancia Convenio de Cupo';
        objPlan2.NombredelProducto__c = objProducto2.Id;
        objPlan2.TipodePlan__c = 'Principal';
        objPlan2.Tarifa__c = 0;
        objPlan2.Estado__c = 'Activo';
        objPlan2.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
        objPlan2.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
        objPlan2.LTE_PlanEstructurados__c = false;
        insert objPlan2;
        

        
        objTOPP = new TOPP__c();
        objTOPP.Name = 'Cambio Cuenta de Facturacion- TELEFONIA MOVIL (LTE)';
        objTOPP.TipodeOperacionporplan__c = 'Cambio Cuenta de Facturacion';
        objTOPP.Tipoderegistro__c = 'CambioCuentaDeFacturacion';
        objTOPP.AplicaPreventa__c=false;
        objTOPP.DisponibleVentainicial__c = true;
        objTOPP.Facturable__c = true;
        objTOPP.Activo__c = true;
        objTOPP.Plan__c = objPlan.Id;
        insert objTOPP;
        
        objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Cambio Cuenta de Facturacion- Plan Larga Distancia Convenio de Cupo';
        objTOPP2.TipodeOperacionporplan__c = 'Cambio Cuenta de Facturacion';
        objTOPP2.Tipoderegistro__c = 'CambioCuentaDeFacturacion';
        objTOPP2.AplicaPreventa__c=false;
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = true;
        objTOPP2.Activo__c = true;
        objTOPP2.Plan__c = objPlan2.Id;
        insert objTOPP2;
        
        
        objServicio = new ActivoETB__c();
        objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.CuentaFacturacion__c = objCtaFact.Id;
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
        objServicio2.CuentaFacturacion__c = objCtaFact2.Id;
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
        objServicio2.Tipo_de_APN__c = 'Datos';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;
        
        
        objOpComercial = new OperacionComercial__c();
        objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('CambioCuentaDeFacturacion').getRecordTypeId();
        objOpComercial.CuentaCliente__c = objAccount.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.Plan__c = objPlan.Id;
        objOpComercial.TOPP__c = objTOPP.Id;
        objOpComercial.Oportunidad__c = objOportunidad.Id;
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'Pendiente Facturacion';
        objOpComercial.NumeroConexion__c = '3057000459';
        objOpComercial.FechadeActivacion__c = system.today()-2;
        objOpComercial.Legalizacion__c = objLegalizacion.Id;
        objOpComercial.EnvioFacturacion__c = true;
        insert objOpComercial;
        
        objOpComercial2 = new OperacionComercial__c();
        objOpComercial2.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('CambioCuentaDeFacturacion').getRecordTypeId();
        objOpComercial2.CuentaCliente__c = objAccount.Id;
        objOpComercial2.Activo__c = objServicio2.Id;
        objOpComercial2.Plan__c = objPlan2.Id;
        objOpComercial2.TOPP__c = objTOPP2.Id;
        objOpComercial2.Oportunidad__c = objOportunidad.Id;
        objOpComercial2.CuentaFacturacion__c = objCtaFact2.Id;
        objOpComercial2.Estado__c = 'Pendiente Facturacion';
        objOpComercial2.NumeroConexion__c = '3057000459';
        objOpComercial2.FechadeActivacion__c = system.today()-2;
        objOpComercial2.Legalizacion__c = objLegalizacion.Id;
        objOpComercial2.EnvioFacturacion__c = true;
        insert objOpComercial2;

    }
    
    static testMethod void ActualizarCuentaFactEnFacturador_Test() {
        
		CreateData();
        List<Account> LstAccount = [Select Id, Actualizar_nombres_cuentas_facturacion__c FROM Account];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.ObjectId = LstAccount[0].id;
            acf.setFlagActualizarCuentasFact(true);
			acf.Cancelar();
            acf.consultarCuentasDeFacturacion();
            acf.consultarCuentaFacturacion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
    static testMethod void ActualizarCuentaFactEnFacturador1_Test() {
        
		CreateData();
        List<Poblacion__c> LstPoblacion = [Select Id, Name, CodigoDane__c, Padre__r.CodigoDane__c, Tipo_Ciudad__c, 
                                           Indicativo__c From Poblacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.ObjectId = LstPoblacion[0].id;
            acf.consultarPoblacion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void ActualizarCuentaFactEnFacturador2_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> LstCFs = [Select Id, Fue_creada_en_revchain__c,Fue_creada_en_RMCA__c,Fue_creada_en_MDM__c  FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = LstCFs;
            acf.accion = 'ActualizarDatos';
            acf.validaciones();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
        static testMethod void ActualizarCuentaFactEnFacturador3_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> LstCFs = [Select Id, Fue_creada_en_revchain__c,Fue_creada_en_RMCA__c,Fue_creada_en_MDM__c  FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = LstCFs;
            acf.accion = 'ActualizarNombre';
            acf.validaciones();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
    }
    
        static testMethod void ActualizarCuentaFactEnFacturador4_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> lstCuentasFacturacion = [SELECT
                                 Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, LTE_Email__c, DirCorresp__c, 
                                 Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, LTE_MetodoEnvio__c, Name, Fue_creada_en_revchain__c,
								 Facturable__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, Confirmacion_Email__c
                        		 FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = lstCuentasFacturacion;
            acf.accion = 'ActualizarDatos';
            //acf.AnalizarAccion();
            acf.GenerarIntegracion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void ActualizarCuentaFactEnFacturador5_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> lstCuentasFacturacion = [SELECT
                                 Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, LTE_Email__c, DirCorresp__c, 
                                 Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, LTE_MetodoEnvio__c, Name, Fue_creada_en_revchain__c,
								 Facturable__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, Confirmacion_Email__c
                        		 FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = lstCuentasFacturacion;
            acf.accion = 'ActualizarNombre';
            acf.GenerarIntegracion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
        static testMethod void ActualizarCuentaFactEnFacturador6_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> lstCuentasFacturacion = [SELECT
                                 Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, LTE_Email__c, DirCorresp__c, 
                                 Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, LTE_MetodoEnvio__c, Name, Fue_creada_en_revchain__c,
								 Facturable__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, Confirmacion_Email__c
                        		 FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = lstCuentasFacturacion;
            acf.accion = 'ActualizarNombre';
            acf.AnalizarAccion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void ActualizarCuentaFactEnFacturador7_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> lstCuentasFacturacion = [SELECT
                                 Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, LTE_Email__c, DirCorresp__c, 
                                 Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, LTE_MetodoEnvio__c, Name, Fue_creada_en_revchain__c,
								 Facturable__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, Confirmacion_Email__c
                        		 FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = lstCuentasFacturacion;
            Apexpages.currentPage().getParameters().put('id', lstCuentasFacturacion[0].id);
            Apexpages.currentPage().getParameters().put('Accion', 'ActualizarDatos');
            acf.ObjectId = lstCuentasFacturacion[0].id;
            acf.AnalizarAccion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
        static testMethod void ActualizarCuentaFactEnFacturador8_Test() {
        
		CreateData();
        List<CuentaFacturacion__c> lstCuentasFacturacion = [SELECT
                                 Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, LTE_Email__c, DirCorresp__c, 
                                 Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, LTE_MetodoEnvio__c, Name, Fue_creada_en_revchain__c,
								 Facturable__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, Confirmacion_Email__c
                        		 FROM CuentaFacturacion__c];
        test.startTest();
        try {
            ActualizarCuentaFactEnFacturador_cls acf = new ActualizarCuentaFactEnFacturador_cls();
            acf.lstCuentasFacturacion = lstCuentasFacturacion;
            Apexpages.currentPage().getParameters().put('id', lstCuentasFacturacion[0].id);
            Apexpages.currentPage().getParameters().put('Accion', 'ActualizarNombre');
            acf.ObjectId = lstCuentasFacturacion[0].id;
            acf.AnalizarAccion();
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }

}