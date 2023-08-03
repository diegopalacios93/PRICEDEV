public class objPruebas_tst {
    
    public static Map<string,string> valoreGlobalesTest =new Map<string,string>();
    
    public Account objAccount(){
        return new Account(Name ='ETB SUCURSAL COLOMBIA'+Math.random()*100,
                           RazonSocial__c='ETB SUCURSAL COLOMBIA',
                           Tipodedocumento__c= 'NIT',
                           AccountNumber = '823698522',
                           Phone = '12345678',
                           Direccion__c='CRA 7 No. 20 37',
                           Description='Description',
                           Estado_Cuenta__c='Activo',
                           Segmento__c='Empresas',
                           SubSegmento__c='sub seg');
    }
    
    public Account objAccountPartner(){
        return new Account(Name ='Aliado'+Math.random()*100,
                           RazonSocial__c='Aliado',
                           Tipodedocumento__c= 'NIT',
                           RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Aliado').getRecordTypeId(),
                           AccountNumber = '823698522',
                           TipodeAliado__c = 'Proveedor',
                           Phone = '12345678',
                           Direccion__c='CRA 7 No. 20 37',
                           Description='Description',
                           Estado_Cuenta__c='Activo');
    }
    
    public Opportunity objOpt(){
        return new Opportunity(Name='PRUEBAS',StageName='Análisis de necesidades', CloseDate=Date.today());
    }
    
    public Mecna__c objMecna(){
        return new Mecna__c(Name ='ETB SUCURSAL COLOMBIA',TipodedocumentoM__c= 'NIT',AccountNumber__c = '823698522');
    }
    
    public Contact objContact(){
        return new Contact(IsTEST__c = true,
                           LastName='Sheen',
                           FirstName='Charlie',
                           Area__c='Presidencia',
                           Genero__c='Masculino',
                           Direccion__c='CRA 7 No. 20 37',
                           MobilePhone='3133124587',
                           Email='test@test.com',
                           LeadSource='Campaña publicidad - Correo Directo',
                           Estado__c='Activo');
    }
    
    public Case objCase(){
        return new Case(Origin='Telefono',
                        Subject='Caso Prueba',
                        Priority='Alta',
                        TipoCaso__c='SOPORTE TECNICO',
                        Fechaderadicacion__c=Date.today().addDays(-2),
                        IDServicio__c='26628728');
    }
    
    public MatrizTipificacion__c objMatrTip(){
        return new MatrizTipificacion__c(Agrupacion__c='Agrupacion',
                                         Descripcion__c='Descripcion',
                                         EsMigrado__c=false,
                                         Estado__c='Activo',
                                         Name='Name',
                                         Nivel_1__c='Nivel_1',
                                         Nivel_2__c='Nivel_2',
                                         Nivel_3__c='Nivel_3',
                                         Proceso__c='Proceso',
                                         Requiere_CUN__c=true,
                                         TiempoSolucion__c='tre',
                                         TipoCaso__c='SOPORTE TECNICO',
                                         Tipologia__c='Tipologia');
    }
    
    public Contract objContrato(){
        return new Contract(Name='Pruebas',
                            Forma_de_Pago__c='No',
                            Duracion__c=0,
                            ValorNuevoNetworking__c=0,
                            ValorAnteriorDatos__c=0,
                            ValorAnteriorNetworking__c=0,
                            ValorAnteriorNoRecurrente__c=0,
                            ValorAntSolTIAliado__c=0,
                            ValorAntNrSolTIAliado__c=0,
                            ContractTerm=12,
                            ValorNuevoNoRecurrente__c=300000,
                            ValorNuevoSolTIAliado__c=1000000,
                            ValorNuevoNrSolTIAliado__c=1000000,
                            ValorNuevoInt__c=4000000,
                            Renovacion_Automatica__c=false,
                            Afecta_Tiempo_Inicial__c=false,
                            Clausula_Cobro_de_Equipos__c=false,
                            Modelo_de_Negoc__c=false,
                            IncrementoAnual__c='IPC',
                            Ajuste_a_la_Decena__c='Si'
                           );
    }
    
    public Legalizacion__c objLeg(){
        return new Legalizacion__c();
    }
    
    public Checklist__c objChecklist(){
        return new Checklist__c();
    }
    
    public ActivoETB__c objServicio(){
        return new ActivoETB__c();
    }
    
    public CatalogoProductos__c objCatalogo(){
        return new CatalogoProductos__c(Name='Linea Telefonica',
                                        Estado__c='Activo',
                                        Descripcion__c='La Linea Telefonica le permite a su empresa estar conectado ilimitadamente',
                                        AtributosEstandar__c='1. Si la linea es para configurar un PBX',
                                        EsMigrado__c=true,
                                        CodigoProducto__c='LineaTelefonica001',
                                        Familia__c='VOZ',
                                        LineaNegocio__c='LOCAL'
                                       );
    }
    
    public planes__c objPlan(){
        return new planes__c(Name='Plan Basico Linea Telefonica',
                             Descripcion__c='La telefonia fija permite a su empresa estar conectado a la Red Publica de una forma segura y con calidad',
                             FechaInicio__c=Date.today().addMonths(-24),
                             Tarifa__c=14710.0,
                             CondicionesComerciales__c='1. Es de caracter obligatorio solicitar siempre al cliente los numeros de contacto (Fijo o Celular)',
                             Esmigrado__c=true,
                             Estado__c='Activo',
                             Espromocion__c=false,
                             ANSFactibilidad__c=1.0,
                             ANSAprovisionamiento__c=5.0,
                             ANSAseguramiento__c=1.0,
                             TipodePlan__c='Principal',
                             PlanesAdicionalesporPlanPpal__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;',
                             IdUnico__c='PlanBasicoLineaTelefonica001',
                             InformacionPlanesAdicionales__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;'
                            );
    }
    
    public OperacionComercial__c objOc(){
        return new OperacionComercial__c(
            Planes_Convenio_Cupo__c='27000',
            Valorunicavez__c=0.0,
            Tarifa__c=0.0,
            Margen_Soluciones_TI__c=0.0,
            Duracion_Meses__c=10.0,
            Duracion_Dias__c=2.0,
            EnvSopVen__c=Datetime.now(),
            FechadeActivacion__c=Date.today(),
            Fecha_Final_Estado__c=Date.today(),
            EnvGteProy__c=Datetime.now(),
            ValorTarifaPlan__c=95492.24,
            Estado__c='Activa',
            Destinatario_Notificacion_Cambio_Estados__c='hbayona@avanxo.com',
            Incidencia_en_ingresos__c='Incremento',
            TipodeInternetSeguridadenlaNube__c='Internet +',
            Categoria__c='LDN',
            EnvioFacturacion__c=true,
            Tipo_de_Conectividad__c='Remoto',
            moneda__c=valoreGlobalesTest.get('OCmoneda__c'),
            RangosDisponibilidad__c='xx'
        );
    }
    
    public CuentaFacturacion__c objCuentaFacturacion(){
        return new CuentaFacturacion__c(DirCorresp__c='carrera 29 # 33 - 44');
    }
    
    public TOPP__c objTopp(){
        return new TOPP__c(
            Name='Venta- Plan Ilimitado Linea Telefonica',
            Tipoderegistro__c='R1',
            AplicaPreventa__c=false,
            AplicaGerenteProyecto__c=false,
            ValorTarifaPlan__c=95492.24,
            Valorunicavez__c=0.0,
            RequiereAnchodeBanda__c=false,
            Esmigrado__c=false,
            DisponibleVentainicial__c=true,
            TipodeOperacionporplan__c='Venta',
            Afecta_Ingresos__c=true,
            Facturable__c=true
        );
    }
    
    public Generico__c objGenerico(){
        Generico__c generico = new Generico__c();
        generico.name='prueba';
        return generico;
    }
    
    public static PlanFacturacion__c objPlanFacturacion(){
        return new PlanFacturacion__c(Name='Servicio Mensual Backup Remoto');
    }
    
    public static CatalogoProductosFacturacion__c objCatalogoProductosFacturacion(){
        return new CatalogoProductosFacturacion__c(Name='Cargo Prorrateado con Participacion',
                                                   Servicio__c='Suministro Equipos');
    }
    
    public static ParametroFacturacion__c objParametroFacturacion(){
        return new ParametroFacturacion__c(Name='Cargo',Campo__c='ValorTarifaPlan__c');
    }
    
    public static SubPlanFacturacion__c objSubPlanFacturacion(){
        return new SubPlanFacturacion__c(Name='Sub Plan Facturacion');
    }
    
    public case objCaso(){
        case caso = new case();
        return caso;
    }
    
    public static void confPersonalizadas(){
        List<SObject> inConf=new List<SObject>();
        
        inConf.add(new EjecucionIntegracion__c(Ejecucion__c=true,Name='RevChain'));
        inConf.add(new HomologacionCampos__c(Valor__c='NIT',Name='NIT'));
        inConf.add(new HomologacionSegmentos__c(Name='Defecto',Segmento__c='JURIDICO'));
        inConf.add(new HomologacionSegmentos2__c(Name='Empresas',Segmento__c='JURIDICO EMPRESAS'));
        inConf.add(new ServiciosWeb__c(Name='RevChain',EndPoint__c='https://request.com',Action__c='/metodo'));
        inConf.add(new ServiciosWeb__c(Name='NormalizacionDireccion',EndPoint__c='https://requestX.com',Action__c='/metodoX'));
        inConf.add(new  CodigosConexionProductos__c(Name='Soluciones TI',idConexion__c='2000060',idTipoConexion__c='2000060'));
        inConf.add(new Perfiles_Acciones__c(Name='DataCreditoScore',Usuarios__c=Userinfo.getProfileId()));
        inConf.add(new Perfiles_Acciones__c(Name='Adjuntos',Usuarios__c=Userinfo.getProfileId()));
        insert inConf;
        // Solo se permite insertar 10 objetos en la lista
        inConf=new List<SObject>();
        inConf.add(new ConfPerfilesOportunidad__c(Name=String.valueOf(Userinfo.getProfileId()).substring(0,15)));
        inConf.add(new VariablesGlobales__c(Name='NumeroReservas',Valor__c='5'));
        inConf.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        inConf.add(new HomologacionTOPPFacturacion__c(Name='Venta',valor__c='Venta'));
        inConf.add(new PerfilDesbloqeoIMEI__c(Name='Administrador del sistema'));
        inConf.add(new ValoresIntegracionTiposDocumento__c(Name='Cédula de ciudadanía', Valor__c='CC'));
        inConf.add(new ServiciosWeb__c(Name='ConsultaIMEI',EndPoint__c='https://requestIMEI1.com',Action__c='/metodo1'));
        inConf.add(new ServiciosWeb__c(Name='DesbloqueoIMEI',EndPoint__c='https://requestIMEI2.com',Action__c='/metodo2'));
        insert inConf;
    }
    
    public static void confPersonalizadas2(){
        List<SObject> inConf=new List<SObject>();
        inConf.add(new ConfFamiliasProductos__c(Name='VOZ',Campo__c='IDServicio__c') );
        inConf.add(new EjecucionIntegracion__c(Ejecucion__c=true,Name='Direcciones'));
        insert inConf;
    }
    
    public static void RedIntel(){
        Map<String,Schema.RecordTypeInfo> RecordTypeId = Schema.SObjectType.DetalleConfRedInteligente__c.getRecordTypeInfosByName();
        List<SObject> inConf=new List<SObject>();
        
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='CentroRespuesta',RecordTypeId__c=RecordTypeId.get('Centros de Respuesta').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='reenrutamiento',RecordTypeId__c=RecordTypeId.get('Enrutamiento').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='horadia',RecordTypeId__c=RecordTypeId.get('Hora de dia').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='listanegra',RecordTypeId__c=RecordTypeId.get('Lista Negra').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='locuciones',RecordTypeId__c=RecordTypeId.get('locuciones').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='menu',RecordTypeId__c=RecordTypeId.get('menus Interactivos').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='origen',RecordTypeId__c=RecordTypeId.get('Origen').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='porcentaje',RecordTypeId__c=RecordTypeId.get('Porcentaje').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='prefijos',RecordTypeId__c=RecordTypeId.get('Prefijos').getRecordTypeId()));
        inConf.add(new RecordTypesDetConfRedInteligente__c(Name='tipodia',RecordTypeId__c=RecordTypeId.get('Tipo de Dia').getRecordTypeId()));
        
        insert inConf;       
    }
    
    public static Map<String,sObject> general(){
        confPersonalizadas2();
        
        Map<String,sObject> xdata=new Map<String,sObject>();
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        objPruebas_tst obj =new objPruebas_tst();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        insert cliente;
        
        Account aliado=obj.objAccountPartner();
        insert aliado;
        
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.id;
        insert contacto;
        
        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
        Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
        Account sucursal=obj.ObjAccount();
        sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
        insert sucursal;
        
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        insert Catalogo;
        
        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        insert plan;
        
        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        topp.Facturable__c=true;
        insert topp;
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        leg.estado__c='Gestionado';
        insert leg;
        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        servicio.Tipodeprogramacion__c='Arranque';
        insert servicio;
        
        ActivoETB__c servicio2 =obj.objServicio();
        servicio2.NombredelaCuenta__c=cliente.Id;
        servicio2.SucursalDestino__c=sucursal.id;
        servicio2.SucursalOrigen__c=sucursal.id;
        servicio2.Plan__c=plan.id;
        servicio2.NombredelProducto__c=Catalogo.Id;
        servicio2.Oportunidad__c=opt.id;
        servicio2.Tipodeprogramacion__c='Troncal';
        servicio2.Activo_Relacionado__c=servicio.id;
        insert servicio2;
        
        Poblacion__c objPoblacion = new Poblacion__c();
        objPoblacion.Name = 'Bogota';
        objPoblacion.CodigoDane__c = '1101';
        objPoblacion.EsMunicipio__c = true;
        insert objPoblacion;
        
        CuentaFacturacion__c objCuentaFacturacion=obj.objCuentaFacturacion();
        objCuentaFacturacion.Cliente__c=cliente.id;
        objCuentaFacturacion.DirCorresp__c='carrera 7 # 20 00';
        objCuentaFacturacion.Ciudad__c=objPoblacion.Id;
        objCuentaFacturacion.PeriodoConsumo__c='201708';
        insert objCuentaFacturacion;
        
        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();
        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.Estado__c='Activa';
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.IDServicio__c='CAV1024234';
        oc.RecordTypeId=ocRecordTypeId;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=objCuentaFacturacion.id;
        insert oc;
        
        xdata.put('cli',cliente);
        xdata.put('ali',aliado);
        xdata.put('opt',opt);
        xdata.put('oc',oc);
        xdata.put('ac',servicio);
        xdata.put('su',sucursal);
        xdata.put('co',contacto);
        xdata.put('cotr',contrato);
        xdata.put('topp',topp);
        xdata.put('plan',plan);
        xdata.put('catalogo',Catalogo);
        xdata.put('leg',leg);
        xdata.put('fac',objCuentaFacturacion);
        return xdata;
    }
    
    public static void revchain(Map<String,sObject> xdata, Map<string,string> escenarios){
        PlanFacturacion__c objPlanFacturacion=objPruebas_tst.objPlanFacturacion();
        objPlanFacturacion.Plan__c=xdata.get('plan').id;
        if(escenarios.get('objPlanFacturacion.Name')!=null){
            objPlanFacturacion.Name=escenarios.get('objPlanFacturacion.Name');
            objPlanFacturacion.Codigo__c='2468';
        }
        insert objPlanFacturacion;
        
        CatalogoProductosFacturacion__c objCatalogoProductosFacturacion=objPruebas_tst.objCatalogoProductosFacturacion();
        objCatalogoProductosFacturacion.CatalogoProductos__c=xdata.get('catalogo').id;
        insert objCatalogoProductosFacturacion;
        
        SubPlanFacturacion__c objSubPlanFacturacion=objPruebas_tst.objSubPlanFacturacion();
        objSubPlanFacturacion.CatalogoProductosFacturacion__c=objCatalogoProductosFacturacion.id;
        objSubPlanFacturacion.PlanFacturacion__c=objPlanFacturacion.id;
        objSubPlanFacturacion.valordependiente__c='Remoto';
        objSubPlanFacturacion.CampoDependiente__c='Tipo_de_Conectividad__c';
        objSubPlanFacturacion.Codigo__c='2468';
        if(escenarios.get('campoDependiente')!=null){
            objSubPlanFacturacion.valordependiente__c=null;
        }
        insert objSubPlanFacturacion;
        
        ParametroFacturacion__c objParametroFacturacion=objPruebas_tst.objParametroFacturacion();
        objParametroFacturacion.PlanFacturacion__c=objPlanFacturacion.id;
        objParametroFacturacion.SubPlanFacturacion__c=objSubPlanFacturacion.id;
        insert objParametroFacturacion;
        
    }
    
    public static void revchainSolTI(Map<String,sObject> xdata, Map<string,string> escenarios){
        //producto Soluciones TI
        CatalogoProductos__c Catalogo =new CatalogoProductos__c();
        Catalogo.Name='Soluciones TI';
        Catalogo.CodigoProducto__c='Soluciones TI001';
        Catalogo.Familia__c='SOLUCIONES TI';
        Catalogo.LineaNegocio__c='NEGOCIOS ESPECIALES';
        insert Catalogo;
        //plan Soluciones TI
        ObjPruebas_tst obj = new ObjPruebas_tst(); 
        Planes__c Plan = obj.objPlan();
        Plan.Name='VideoVigilancia';
        plan.IdUnico__c='VideoVigiliancia';
        Plan.NombredelProducto__c=Catalogo.id;
        Plan.NombrePlanSolucionTI__c='plan de pruebas';
        insert plan;
        
        //creacion operacion comercial
        Legalizacion__c leg =(Legalizacion__c)xdata.get('leg');
        CuentaFacturacion__c cuent = (CuentaFacturacion__c)xdata.get('fac');
        ActivoETB__c servicio = (ActivoETB__c)xdata.get('ac');
        OperacionComercial__c oc =obj.objOc();
        TOPP__c topp = (TOPP__c)xdata.get('topp');
        Account cliente = (Account)xdata.get('cli');
        Account aliado = (Account)xdata.get('ali');
        Account sucursal = (Account)xdata.get('su');
        Opportunity opt = (Opportunity)xdata.get('opt');
        topp.plan__c=plan.id;
        update topp;
        
        PlanSolucionTI__c plansolti= new PlanSolucionTI__c();
        plansolti.name='plan de prueba';
        plansolti.Producto__c='tales';
        plansolti.Reventa__c=true;
        plansolti.plan__c=plan.id;
        plansolti.AliadoRel__c=aliado.Id;
        insert plansolti;
        
        ParametroFacturacion__c parametro=objParametroFacturacion();
        parametro.campo__c='ValorUnicaVez__c';
        parametro.name='cargo';
        parametro.planSolucionTI__c=plansolti.id;
        insert parametro;
        
        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.idServicio__c=servicio.name;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=Cuent.id;
        oc.Estado__c='Activa';
        oc.FechadeActivacion__c=system.today();
        oc.AliadoColaborador__c = aliado.Id;
        oc.TipoFacturacion__c='Cobro Unico';
        oc.TipoVenta__c='Reventa';
        oc.ValorUnicaVez__c=13000;
        oc.ValorTarifaPlan__c=0;
        insert oc;
        
        xdata.put('oc2',oc);
    }
    
    public static void revchainSolTI2(Map<String,sObject> xdata, Map<string,string> escenarios){
        //producto Soluciones TI
        CatalogoProductos__c Catalogo =new CatalogoProductos__c();
        Catalogo.Name='Soluciones TI';
        Catalogo.CodigoProducto__c='Soluciones TI002';
        Catalogo.Familia__c='SOLUCIONES TI';
        Catalogo.LineaNegocio__c='NEGOCIOS ESPECIALES';
        insert Catalogo;
        //plan Soluciones TI
        ObjPruebas_tst obj = new ObjPruebas_tst(); 
        Planes__c Plan = obj.objPlan();
        Plan.Name='VideoVigilancia';
        plan.IdUnico__c='VideoVigiliancia111';
        Plan.NombredelProducto__c=Catalogo.id;
        Plan.NombrePlanSolucionTI__c='plan de pruebas';
        insert plan;
        
        //creacion operacion comercial
        Legalizacion__c leg =(Legalizacion__c)xdata.get('leg');
        CuentaFacturacion__c cuent = (CuentaFacturacion__c)xdata.get('fac');
        ActivoETB__c servicio = (ActivoETB__c)xdata.get('ac');
        OperacionComercial__c oc =obj.objOc();
        TOPP__c topp = (TOPP__c)xdata.get('topp');
        Account cliente = (Account)xdata.get('cli');
        Account aliado = (Account)xdata.get('ali');
        Account sucursal = (Account)xdata.get('su');
        Opportunity opt = (Opportunity)xdata.get('opt');
        topp.plan__c=plan.id;
        update topp;
        
        PlanSolucionTI__c plansolti= new PlanSolucionTI__c();
        plansolti.name='plan de prueba';
        plansolti.Producto__c='tales';
        plansolti.Productivizacion__c=true;
        plansolti.plan__c=plan.id;
        plansolti.AliadoRel__c=aliado.Id;
        insert plansolti;
        
        ParametroFacturacion__c parametro=objParametroFacturacion();
        parametro.campo__c='ValorUnicaVez__c';
        parametro.name='cargo';
        parametro.planSolucionTI__c=plansolti.id;
        insert parametro;
        
        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.idServicio__c=servicio.name;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=Cuent.id;
        oc.Estado__c='Activa';
        oc.FechadeActivacion__c=system.today();
        oc.AliadoColaborador__c = aliado.Id;
        oc.TipoFacturacion__c='Cobro Unico';
        oc.TipoVenta__c='Productivizacion';
        oc.ValorUnicaVez__c=13000;
        oc.ValorTarifaPlan__c=0;
        insert oc;
        
        xdata.put('oc3',oc);
    }
    
    public static void revchainSolTI3(Map<String,sObject> xdata, Map<string,string> escenarios){
        //producto Soluciones TI
        CatalogoProductos__c Catalogo =new CatalogoProductos__c();
        Catalogo.Name='Soluciones TI';
        Catalogo.CodigoProducto__c='Soluciones TI003';
        Catalogo.Familia__c='SOLUCIONES TI';
        Catalogo.LineaNegocio__c='NEGOCIOS ESPECIALES';
        insert Catalogo;
        //plan Soluciones TI
        ObjPruebas_tst obj = new ObjPruebas_tst(); 
        Planes__c Plan = obj.objPlan();
        Plan.Name='VideoVigilancia';
        plan.IdUnico__c='VideoVigiliancia2222';
        Plan.NombredelProducto__c=Catalogo.id;
        Plan.NombrePlanSolucionTI__c='plan de pruebas';
        insert plan;
        
        //creacion operacion comercial
        Legalizacion__c leg =(Legalizacion__c)xdata.get('leg');
        CuentaFacturacion__c cuent = (CuentaFacturacion__c)xdata.get('fac');
        ActivoETB__c servicio = (ActivoETB__c)xdata.get('ac');
        OperacionComercial__c oc =obj.objOc();
        TOPP__c topp = (TOPP__c)xdata.get('topp');
        Account cliente = (Account)xdata.get('cli');
        Account aliado = (Account)xdata.get('ali');
        Account sucursal = (Account)xdata.get('su');
        Opportunity opt = (Opportunity)xdata.get('opt');
        topp.plan__c=plan.id;
        update topp;
        
        PlanSolucionTI__c plansolti= new PlanSolucionTI__c();
        plansolti.name='plan de prueba';
        plansolti.Producto__c='tales';
        plansolti.Aliado__c=true;
        plansolti.plan__c=plan.id;
        plansolti.AliadoRel__c=aliado.Id;
        insert plansolti;
        
        ParametroFacturacion__c parametro=objParametroFacturacion();
        parametro.campo__c='ValorUnicaVez__c';
        parametro.name='cargo';
        parametro.planSolucionTI__c=plansolti.id;
        insert parametro;
        
        ParametroFacturacion__c parametro2=objParametroFacturacion();
        parametro2.campo__c='Valor_Unica_Vez_Aliado__c';
        parametro2.name='cargo2';
        parametro2.planSolucionTI__c=plansolti.id;
        insert parametro2;
        
        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.idServicio__c=servicio.name;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=Cuent.id;
        oc.Estado__c='Activa';
        oc.FechadeActivacion__c=system.today();
        oc.AliadoColaborador__c = aliado.Id;
        oc.TipoFacturacion__c='Cobro Unico';
        oc.TipoVenta__c='Alianza';
        oc.ValorUnicaVez__c=13000;
        oc.Valor_unica_vez_aliado__c=223423;
        oc.ValorTarifaPlan__c=0;
        oc.AliadoColaborador__c=aliado.id;
        insert oc;
        
        Viabilidad__c via = new Viabilidad__c();
        via.Aliado__c=Aliado.id;
        via.Respuestadeviabilidad__c='Viable';
        via.EstadoViabilidad__c='Cerrada';
        via.Observaciones__c='oewrwerewrew';
        via.OperacionComercial__c=oc.id;
        
        insert via;
        
        
        xdata.put('oc4',oc);
        xdata.put('via',via);
        
        //cambio de estado
        
    }
    
    public static void revchainSolTI4(Map<String,sObject> xdata, Map<string,string> escenarios){
        //producto Soluciones TI
        CatalogoProductos__c Catalogo =new CatalogoProductos__c();
        Catalogo.Name='Soluciones TI';
        Catalogo.CodigoProducto__c='Soluciones TI004';
        Catalogo.Familia__c='SOLUCIONES TI';
        Catalogo.LineaNegocio__c='NEGOCIOS ESPECIALES';
        insert Catalogo;
        //plan Soluciones TI
        ObjPruebas_tst obj = new ObjPruebas_tst(); 
        Planes__c Plan = obj.objPlan();
        Plan.Name='VideoVigilancia';
        plan.IdUnico__c='VideoVigiliancia4';
        Plan.NombredelProducto__c=Catalogo.id;
        Plan.NombrePlanSolucionTI__c='plan de pruebas';
        insert plan;
        
        //creacion operacion comercial
        Legalizacion__c leg =(Legalizacion__c)xdata.get('leg');
        CuentaFacturacion__c cuent = (CuentaFacturacion__c)xdata.get('fac');
        ActivoETB__c servicio = (ActivoETB__c)xdata.get('ac');
        OperacionComercial__c oc =obj.objOc();
        TOPP__c topp = (TOPP__c)xdata.get('topp');
        Account cliente = (Account)xdata.get('cli');
        Account aliado = (Account)xdata.get('ali');
        Account sucursal = (Account)xdata.get('su');
        Opportunity opt = (Opportunity)xdata.get('opt');
        topp.plan__c=plan.id;
        update topp;
        
        PlanSolucionTI__c plansolti= new PlanSolucionTI__c();
        plansolti.name='plan de prueba';
        plansolti.Producto__c='tales';
        plansolti.Reventa__c=true;
        plansolti.plan__c=plan.id;
        plansolti.AliadoRel__c=aliado.Id;
        insert plansolti;
        
        PlanSolucionTI__c plansolti2= new PlanSolucionTI__c();
        plansolti2.name='plan de prueba';
        plansolti2.Producto__c='tales';
        plansolti2.Reventa__c=true;
        plansolti2.plan__c=plan.id;
        plansolti2.Recurrente__c = true;
        plansolti.AliadoRel__c=aliado.Id;
        insert plansolti2;
        
        ParametroFacturacion__c parametro=objParametroFacturacion();
        parametro.campo__c='ValorUnicaVez__c';
        parametro.name='cargo';
        parametro.planSolucionTI__c=plansolti.id;
        insert parametro;
        
        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.idServicio__c=servicio.name;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=Cuent.id;
        oc.Estado__c='Activa';
        oc.FechadeActivacion__c=system.today();
        oc.AliadoColaborador__c = aliado.Id;
        oc.TipoFacturacion__c='Cobro Unico';
        oc.TipoVenta__c='Reventa';
        oc.ValorUnicaVez__c=13000;
        oc.ValorTarifaPlan__c=5000;
        insert oc;
        
        xdata.put('oc5',oc);
    }
    
    public static void revchainSolTI5(Map<String,sObject> xdata, Map<string,string> escenarios){
        //producto Soluciones TI
        CatalogoProductos__c Catalogo =new CatalogoProductos__c();
        Catalogo.Name='Soluciones TI';
        Catalogo.CodigoProducto__c='Soluciones TI005';
        Catalogo.Familia__c='SOLUCIONES TI';
        Catalogo.LineaNegocio__c='NEGOCIOS ESPECIALES';
        insert Catalogo;
        //plan Soluciones TI
        ObjPruebas_tst obj = new ObjPruebas_tst(); 
        Planes__c Plan = obj.objPlan();
        Plan.Name='VideoVigilancia';
        plan.IdUnico__c='VideoVigiliancia5';
        Plan.NombredelProducto__c=Catalogo.id;
        Plan.NombrePlanSolucionTI__c='plan de pruebas';
        insert plan;
        
        //creacion operacion comercial
        Legalizacion__c leg =(Legalizacion__c)xdata.get('leg');
        CuentaFacturacion__c cuent = (CuentaFacturacion__c)xdata.get('fac');
        ActivoETB__c servicio = (ActivoETB__c)xdata.get('ac');
        OperacionComercial__c oc =obj.objOc();
        TOPP__c topp = (TOPP__c)xdata.get('topp');
        Account cliente = (Account)xdata.get('cli');
        Account aliado = (Account)xdata.get('ali');
        Account sucursal = (Account)xdata.get('su');
        Opportunity opt = (Opportunity)xdata.get('opt');
        topp.plan__c=plan.id;
        update topp;
        
        PlanSolucionTI__c plansolti= new PlanSolucionTI__c();
        plansolti.name='plan de prueba';
        plansolti.Producto__c='tales';
        plansolti.Productivizacion__c=true;
        plansolti.plan__c=plan.id;
        plansolti.AliadoRel__c=aliado.Id;
        insert plansolti;
        
        ParametroFacturacion__c parametro=objParametroFacturacion();
        parametro.campo__c='ValorUnicaVez__c';
        parametro.name='cargo';
        parametro.planSolucionTI__c=plansolti.id;
        insert parametro;
        
        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.idServicio__c=servicio.name;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=Cuent.id;
        oc.Estado__c='Activa';
        oc.FechadeActivacion__c=system.today();
        oc.AliadoColaborador__c = aliado.Id;
        oc.TipoFacturacion__c='Cobro Unico';
        oc.TipoVenta__c='Productivizacion';
        oc.ValorUnicaVez__c=13000;
        oc.ValorTarifaPlan__c=5000;
        insert oc;
        
        xdata.put('oc6',oc);
    }
}