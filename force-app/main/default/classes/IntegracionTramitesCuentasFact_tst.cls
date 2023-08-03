@isTest
public class IntegracionTramitesCuentasFact_tst {
	public static List<VariablesGlobales__c> lstVariablesGlobales;        
    public static Account objAccount;
    public static CuentaFacturacion__c objCtaFact;    
    public static Contact objContact;    
    public static CatalogoProductos__c objProducto;
    public static CatalogoProductos__c objProducto2;    
    public static ActivoETB__c objServicio;
    public static ActivoETB__c objServicio2;           
    public static Planes__c objPlan;
    public static Planes__c objPlan2;    
    public static case caso;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static Tramite_cuenta_de_facturacion__c tramiteFormatoFact; 
    public static Tramite_cuenta_de_facturacion__c tramiteAgruparConceptos;
    public static Tramite_cuenta_de_facturacion__c tramiteAgruparConceptos2;    
    public static Servicio_del_tramite_cuenta_fact__c servTramiteCF1;
    
    
    public static void CreateData(){
        lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
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
        objCtaFact.Estado__c = 'Activo';
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
        objContact.Autoriza_Tratamiento_de_Datos_Personales__c='Si';
        insert objContact;
        
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
        
        objServicio = new ActivoETB__c();        
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
        objServicio2.NombredelaCuenta__c = objAccount.Id;
        objServicio2.CuentaFacturacion__c = objCtaFact.Id;
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
        objServicio2.Tipo_de_APN__c = 'Datos';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;
        
        caso = new case();  
        caso.AccountId=objAccount.Id;
        caso.ContactId=objContact.id;
        insert caso; 
         
    }
    static testMethod void Test_1() {
        CreateData();
        tramiteFormatoFact = new Tramite_cuenta_de_facturacion__c();
        tramiteFormatoFact.Cuenta_de_Facturacion__c = objCtaFact.Id;
        tramiteFormatoFact.Caso__c = caso.Id;
        tramiteFormatoFact.Tramite__c = 'Configurar parámetros de facturación';
        tramiteFormatoFact.Estado__c = 'Pendiente';
        tramiteFormatoFact.Estado_aprobacion_solicitud__c = 'Solicitud aprobada';
        tramiteFormatoFact.Visualizar_el_saldo_anterior__c = true;
        tramiteFormatoFact.Adjuntar_RUT_y_parafiscales__c = true;
        tramiteFormatoFact.Presentar_PILA__c = true;
        tramiteFormatoFact.Presentar_el_ajuste_a_la_decena__c = true;
        tramiteFormatoFact.Presentar_doble_cupon__c	= true;
        insert tramiteFormatoFact; 
        
        test.startTest();
        IntegracionTramitesCuentasFact_bch facttbtch = new IntegracionTramitesCuentasFact_bch();
		ID batchprocessid = Database.executeBatch(facttbtch,1);		
        test.stopTest();
    }
    static testMethod void Test_2() {
        CreateData();
        tramiteAgruparConceptos = new Tramite_cuenta_de_facturacion__c();
        tramiteAgruparConceptos.Cuenta_de_Facturacion__c = objCtaFact.Id;
        tramiteAgruparConceptos.Caso__c = caso.Id;
        tramiteAgruparConceptos.Tramite__c = 'Agrupar conceptos de facturación';
        tramiteAgruparConceptos.Estado__c = 'Pendiente';
        tramiteAgruparConceptos.Estado_aprobacion_solicitud__c = 'Solicitud aprobada';        
        tramiteAgruparConceptos.Validacion_plan_de_impuestos__c = 'Plan de impuesto de los servicios compatible';
        tramiteAgruparConceptos.Cantidad_de_servicios_a_procesar__c = 2;
        tramiteAgruparConceptos.Nombre_del_concepto_a_consolidar__c = 'Nombre a consolidar';
        insert tramiteAgruparConceptos;
        
        servTramiteCF1 = new Servicio_del_tramite_cuenta_fact__c();
        servTramiteCF1.Activo__c = objServicio.Id;
        servTramiteCF1.Tramite_cuenta_de_facturacion__c = tramiteAgruparConceptos.Id;
        servTramiteCF1.Estado__c = 'Pendiente';
        insert servTramiteCF1;
        test.startTest();
        IntegracionTramitesCuentasFact_bch facttbtch = new IntegracionTramitesCuentasFact_bch();
		ID batchprocessid = Database.executeBatch(facttbtch,1);		
        test.stopTest();
    }
    
    static testMethod void Test_3() {
        CreateData();        
        tramiteAgruparConceptos2 = new Tramite_cuenta_de_facturacion__c();
        tramiteAgruparConceptos2.Cuenta_de_Facturacion__c = objCtaFact.Id;
        tramiteAgruparConceptos2.Caso__c = caso.Id;
        tramiteAgruparConceptos2.Tramite__c = 'Agrupar conceptos de facturación';
        tramiteAgruparConceptos2.Estado__c = 'Pendiente';
        tramiteAgruparConceptos2.Estado_aprobacion_solicitud__c = 'Pendiente';
        tramiteAgruparConceptos2.Validacion_plan_de_impuestos__c = 'Pendiente';
        tramiteAgruparConceptos2.Cantidad_de_servicios_a_procesar__c = 2;
        tramiteAgruparConceptos2.Nombre_del_concepto_a_consolidar__c = 'Nombre a consolidar';
        insert tramiteAgruparConceptos2;
        
        test.startTest();   
        IntegracionServiciosTramitesCtasFact_bch facttbtch = new IntegracionServiciosTramitesCtasFact_bch();
		ID batchprocessid = Database.executeBatch(facttbtch,1);        
        test.stopTest();
    }
    static testMethod void Test_4() {
        CreateData(); 
        tramiteAgruparConceptos = new Tramite_cuenta_de_facturacion__c();
        tramiteAgruparConceptos.Cuenta_de_Facturacion__c = objCtaFact.Id;
        tramiteAgruparConceptos.Caso__c = caso.Id;
        tramiteAgruparConceptos.Tramite__c = 'Agrupar conceptos de facturación';
        tramiteAgruparConceptos.Estado__c = 'Pendiente';
        tramiteAgruparConceptos.Estado_aprobacion_solicitud__c = 'Pendiente';        
        tramiteAgruparConceptos.Validacion_plan_de_impuestos__c = 'Plan de impuesto de los servicios compatible';
        tramiteAgruparConceptos.Cantidad_de_servicios_a_procesar__c = 2;
        tramiteAgruparConceptos.Nombre_del_concepto_a_consolidar__c = 'Nombre a consolidar';
        insert tramiteAgruparConceptos;
        
        servTramiteCF1 = new Servicio_del_tramite_cuenta_fact__c();
        servTramiteCF1.Activo__c = objServicio.Id;
        servTramiteCF1.Tramite_cuenta_de_facturacion__c = tramiteAgruparConceptos.Id;
        servTramiteCF1.Estado__c = 'Pendiente';
        insert servTramiteCF1;
                
        test.startTest();   
        validarPlanDeImpuestosServicios_ctr validarPlanClass = new validarPlanDeImpuestosServicios_ctr();
        ApexPages.currentPage().getParameters().put('ObjectId', tramiteAgruparConceptos.Id);        
        validarPlanClass.GenerarIntegracion();
        test.stopTest();
    }
}