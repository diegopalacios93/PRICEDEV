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
private class SeleccionProductoCatalogo_tst {
	public static Opportunity opp;  
    public static TOPP__c topp;
    public static Planes__c plan;
    public static CatalogoProductos__c cat;
    public static Account acc;
    public static Poblacion__c pob;
    public static OperacionComercial__c oc;
    public static Contact cont;
    public static ActivoETB__c act;
    public static Cuentafacturacion__c cf;
    public static Linea__c linea;
    public static LTE_Servicios_adicionales__c lstSVA;
    public static LTE_SpecificationGroupXA__c lstXA ;
    
    static testMethod void myUnitTest_opp() {
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='PerfilSusRecRet',Valor__c='Facturación Datos,Administrador del sistema'));
        vg.add(new VariablesGlobales__c(Name='ProductoLD',Valor__c='a04c0000008PzCqAAK,a04c0000008PzCrAAK',Valor02__c = 'Venta,Cambio de Plan'));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario09',Perfiles__c='a04c0000008PzCqAAK',Desactivar__c=false,Detalles__c='Detalles'));
        insert vg;
		// generar data
		generarPoblacion();
        generarCuenta();
        generarContacto();
        generarCatalogoProductos();        
        generarPlanes();     
        generarTopp();        
        generarOpportunity();
        generarOperacionComercial();
        generarActivoETB();
        generarCuentaFacturacion();
        generarLinea();
        
		// fin generar data
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');        
        //GeneraData_cls.generarData();
        
        SeleccionProductoCatalogo_ctr dpc = new SeleccionProductoCatalogo_ctr();
        dpc.blnEditarCantidad = null;
        PageReference pageRef = Page.SeleccionProductoCatalogo_pag;
        Test.setCurrentPage(pageRef);       
        ApexPages.currentPage().getParameters().put('GN', 'true');
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        dpc.AnalizaAccion();
        dpc.CargarProd1();
        dpc.Refresco1();
        dpc.Refresco2();
        dpc.Refresco3();
        dpc.Refresco4();
        dpc.Refresco5();
        dpc.Refresco6();
        
        dpc.BuscarTipoRegistro(topp);
        
        //dpc.ValidaPlanSecundario('elPlansecundario');
        dpc.CargarAnchoBanda();
        
        dpc.strInOperacion= topp.Id;
        dpc.strInPlan=plan.Id;
        dpc.strInProducto=cat.Id;
        dpc.insOpp=opp;
        dpc.insCata=cat;
        dpc.blnEditarCantidad=null;        
        dpc.strInBW='Test';
                       
        dpc.GuardarNuevo();
        dpc.Guardar();
        dpc.verificaPostVentaNIP(oc.Id); 
		dpc.relacionarActivosNIPaOC('123',oc.Id);        
        dpc.Cancelar();        
        update(oc);   
        
    }
    
    static testMethod void myUnitTest_act() {  
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='PerfilSusRecRet',Valor__c='Facturación Datos,Administrador del sistema'));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario09',Perfiles__c='',Desactivar__c=false,Detalles__c='Detalles'));
        insert vg;  
      
        //GeneraDataLight_cls.generarData();
        // generar data
		generarPoblacion();
        generarCuenta();
        generarContacto();
        generarCatalogoProductos();        
        generarPlanes();     
        generarTopp();        
        generarOpportunity();
        generarOperacionComercial();
        generarActivoETB();
        generarCuentaFacturacion();
        generarlinea();
        test.startTest();
        SeleccionProductoCatalogo_ctr dpc = new SeleccionProductoCatalogo_ctr();
        set<String> planesLD=new set<String>(('aa,bb').split(','));        
       // Boolean aux  = dpc.validarToopLD(planesLD);
        Boolean aux2 = dpc.blnEditarCantidad;
        dpc.blnEditarCantidad = true;
        PageReference pageRef = Page.SeleccionProductoCatalogo_pag;
        Test.setCurrentPage(pageRef);       
        ApexPages.currentPage().getParameters().put('GN', 'true');
        ApexPages.currentPage().getParameters().put('id', act.id); //GeneraDataLight_cls.act.Id);
        dpc.AnalizaAccion();
        //dpc.CargarProd1();
        dpc.Refresco1();
        dpc.Refresco2();
        dpc.Refresco3();
        dpc.Refresco4();
        dpc.Refresco5();
        dpc.strIdOpp=null;        
        dpc.strIdActivo= act.Id; //GeneraDataLight_cls.act.Id;
        dpc.strInOperacion= TOPP.Id; //GeneraDataLight_cls.topp.Id;
        dpc.strInPlan= Plan.ID; //GeneraDataLight_cls.plan.Id;
        dpc.strInProducto= cat.Id; //GeneraDataLight_cls.cat.Id;
        dpc.GuardarNuevo();
        dpc.Cancelar();
        dpc.obtenerFechaCorte(20);
        dpc.obtenerPlanFacturacionId(plan.Id); //(GeneraDataLight_cls.plan.Id);
        dpc.obtenerPlanFacturacionName(plan.Id,'Name');//(GeneraDataLight_cls.plan.Id,'Name');
        dpc.obtenerSubPlanFacturacionName(plan.Id,'Name');//(GeneraDataLight_cls.plan.Id,'Name');
        dpc.creaOCCambioPlanACPrincipal(act.Id, oc.Id); //(GeneraDataLight_cls.objServicio.Id, GeneraDataLight_cls.oc.Id);
        dpc.buscarOCCambioPlan(topp.Id,cf.Id); //(GeneraDataLight_cls.topp.Id,GeneraDataLight_cls.cf.Id);
        dpc.asociarLineas(linea.id,false);//(GeneraDataLight_cls.linea.id,false);
        dpc.getPlanesLD();
        test.stopTest();
    }
    
    static testMethod void myUnitTest_act2() {  
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='PerfilSusRecRet',Valor__c='Facturación Datos,Administrador del sistema'));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario09',Perfiles__c='',Desactivar__c=false,Detalles__c='Detalles'));
        insert vg;  
      
        //GeneraDataLight_cls.generarData();
        // generar data
		generarPoblacion();
        generarCuenta();
        generarContacto();
        generarCatalogoProductos();        
        generarPlanes();     
        generarTopp();        
        generarOpportunity();
        generarOperacionComercial();
        generarActivoETB();
        generarCuentaFacturacion();
        generarlinea();          
        test.startTest();
        SeleccionProductoCatalogo_ctr dpc = new SeleccionProductoCatalogo_ctr();
        set<String> planesLD=new set<String>(('aa,bb').split(','));        
       // Boolean aux  = dpc.validarToopLD(planesLD);
        Boolean aux2 = dpc.blnEditarCantidad;
        dpc.blnEditarCantidad = true;
        PageReference pageRef = Page.SeleccionProductoCatalogo_pag;
        Test.setCurrentPage(pageRef);       
        ApexPages.currentPage().getParameters().put('GN', 'true');
        ApexPages.currentPage().getParameters().put('id', act.id); // GeneraDataLight_cls.act.Id);
        dpc.AnalizaAccion();
        //dpc.CargarProd1();
        dpc.Refresco1();
        dpc.Refresco2();
        dpc.Refresco3();
        dpc.Refresco4();
        dpc.Refresco5();
        dpc.strIdOpp=null;        
        dpc.strIdActivo=Act.id; //GeneraDataLight_cls.act.Id;
        dpc.strInOperacion=Topp.Id; // GeneraDataLight_cls.topp.Id;
        dpc.strInPlan=Plan.Id; //GeneraDataLight_cls.plan.Id;
        dpc.strInProducto=cat.Id; //GeneraDataLight_cls.cat.Id;
        dpc.GuardarNuevo();
        dpc.Cancelar();
        dpc.obtenerFechaCorte(20);
        dpc.obtenerPlanFacturacionId(plan.Id); //(GeneraDataLight_cls.plan.Id);
        dpc.obtenerPlanFacturacionName(plan.Id,'Name');//(GeneraDataLight_cls.plan.Id,'Name');
        dpc.obtenerSubPlanFacturacionName(plan.Id,'Name');//(GeneraDataLight_cls.plan.Id,'Name');
        //Planes__c plan = GeneraDataLight_cls.plan;
        //plan.Name = System.Label.Nombre_Plan_Troncal_SIP_Alterna;
        //update plan;
        dpc.creaOCCambioPlanACPrincipal(act.Id, oc.Id); //(GeneraDataLight_cls.objServicio.Id, GeneraDataLight_cls.oc.Id);
        test.stopTest();
    }
    
    public static Id generarOpportunity(){
        opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Opportunity Test Case';
        opp.CloseDate = System.today()+1;
        opp.StageName = 'En Estudio';
        opp.OwnerId = Userinfo.getUserId();
        opp.Valor_unica_vez_ETB__c = 1;    
        opp.Plan__r = Plan;
        opp.Plan__c = Plan.Id;
        opp.ANS__c = 10;
        opp.Plan__r.Tipo_Operaci_n_por_Plan__r = topp;
        opp.Plan__r.Tipo_Operaci_n_por_Plan__c = topp.Id;     
        insert opp;    
        return opp.Id;
      }
    public static id generarContacto(){
        cont = new Contact();
        cont.LastName = 'Perez';
        cont.Estado__c = 'Activo';
        cont.AccountId = acc.ID;
        cont.Phone = '12345678';
        insert cont;
        return cont.Id;
    }
    public static Id generarActivoETB(){
        act = new ActivoETB__c();
        act.Oportunidad__c = opp.Id;
        act.Estado__c = 'Activo';  
        act.NombredelProducto__c = cat.Id;
        act.NombredelaCuenta__c = acc.Id;
        insert act;  
        
        return act.Id;  
    }
    public static Id generarLinea(){
        linea = new Linea__c();
        linea.Name = '12345678';
        linea.Codigo_de_linea__c = '12345678';
        //linea.Tipo_Linea__c = 'Arranque';
        //linea.Estado_Aprovisionamiento__c = 'Activo';
        linea.OperacionComercialTramite__c = oc.Id;
       	linea.Activo__c = act.id;
        linea.ActivaServicioLD__c = false;
        insert linea;
      	return linea.Id;
  }

    public static Id generarCuentaFacturacion(){  
    cf = new CuentaFacturacion__c();
    cf.Ciudad__c = pob.Id;
    cf.Cliente__c = acc.Id;
    cf.Estado__c='Activo';
    cf.DirCorresp__c = 'Test direccion';
    cf.LTE_CicloFacturacion__c = '97';
    insert cf;
    
    return cf.Id;
  }
    public static id generarTopp(){  
        topp = new TOPP__c();
        topp.Name ='Cambio de Plan- TELEFONIA MOVIL (LTE)';
        topp.Plan__c = plan.Id;
        topp.AplicaPreventa__c = true;
        topp.Tipoderegistro__c='A1';
        topp.Activo__c=true;
        topp.AplicaPreventa__c = true;   
        topp.TipodeOperacionporplan__c = 'Cambio de Plan';
        topp.LTE_Parte_caso__c  = true;
        insert topp;
        
        return topp.Id;
      }
    
    public static Id generarPlanes(){
        plan = new Planes__c();
        plan.Name = 'TELEFONIA MOVIL (LTE)';
        plan.NombredelProducto__c = cat.Id;
        plan.TipodePlan__c = 'Principal';
        plan.Estado__c = 'Activa';
        insert plan;
        
        return plan.Id;
      } 
    
    public static Id generarCatalogoProductos(){
        cat = new CatalogoProductos__c();
        cat.Name = 'cattesteste';
        insert cat;
        
        return cat.Id;
    }
    
    public static Id generarCuenta(){
        acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.Ciudad__c = pob.Id;
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone = '31564589';
        insert acc;
        
        return acc.Id;
    }
   
    public static Id generarPoblacion(){
    pob = new Poblacion__c();
    pob.CodigoDane__c = '1100001';
    pob.EsMunicipio__c = true;
    pob.name = 'testland';
    pob.Tipo_de_instalacion__c = 'Bogotá';
    insert pob;
    
    return pob.Id;
  }
    
    public static Id generarOperacionComercial(){    
    oc = new OperacionComercial__c();
    oc.Estado__c = 'Pendiente';
    oc.FechadeActivacion__c=System.today();
    //oc.Activo__c = act.Id;
    //oc.AnchoBanda__c = ab.Id;
    oc.Oportunidad__c = opp.Id;
    //oc.ContratoAliado__c = contr.Id;
    //oc.Legalizacion__c = leg.Id;
    oc.TOPP__c = topp.Id;
    oc.Plan__c = plan.Id;
    //oc.AnchoBanda__c = ab.Id;
    //oc.CuentaFacturacion__c = cf.Id;
    oc.CuentaCliente__c = acc.Id;
    //oc.Caso__c = caso.Id;
    //oc.Fidelizacion__c = retencionServicio.Id;
    oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
    //oc.Operacion_Comercial_Relacionada__c = oc2.Id;
    insert oc;
    
    return oc.Id;
  } 
    
    private static void createSVA(){
        CatalogoProductos__c producto = new CatalogoProductos__c();
        producto.Name = 'E-Commerce';
        producto.Familia__c = 'VOZ';
        producto.LineaNegocio__c = 'LOCAL';
        producto.CodigoProducto__c = 'xxxxxxxxx';
        //producto.NEMONICO__c = '1XY00XXXXX';
        producto.Estado__c = 'Activo';
        producto.Tipo_de_Producto__c = 'Avanzado';
        producto.Catalogo__c = 'Basico';
        //producto.Descripcion__c = 'En la parte motiva de la Res. 5968 de 2020 se señala que: El artículo 2.2.12.2.1.14. del Decreto 1078 de 2015, estableció que la numeración para los servicios semiautomáticos y especiales de abonado de estructura 1XY es un Recurso de Identificación destinado a cubrir la necesidad de prestar algunos servicios de interés social que por su naturaleza exijan facilidades de recordación y marcación al usuario. Esta numeración no está destinada al uso comercial.';
        //producto.AtributosEstandar__c = 'Los números semiautomáticos y especiales de marcación 1XY están concebidos para proveer un acceso de fácil recordación al usuario a todos aquellos servicios de interés social que no tienen uso comercial, y que por agilidad requieren que la marcación sea sencilla. Cuentan con una atribución genérica dispuesta en cuatro modalidades que definen las características de éstos al momento de su asignación, las cuales se enfocan en el tipo de servicio a soportar y los costos que deben ser asumidos por el PRST, el Prestador del Servicio 1XY y el usuario:'
        //+'\n'+'Modalidad 1'
        //+'\n'+'Modalidad 2'
        //+'\n'+'Modalidad 3'
        //+'\n'+'Modalidad 4';
        //producto.CodigoFacturacion__c = '0161440668';
        producto.PremisasFacturacion__c = 'ENLACES DE VOZ,IP CENTREX,LARGA DISTANCIA,RED INTELIGENTE,VOZ';
        insert producto;
        
        Planes__c plan = new Planes__c();
        
        plan.Name = 'Troncal SIP Móvil Alterna';
        plan.NombredelProducto__c = producto.id;
        plan.TipodePlan__c = 'Principal';
        plan.Tarifa__c = 0;
        plan.Estado__c = 'Activo';
        //pln1.Descripcion__c = 'Producto DNO';
        //pln1.CondicionesComerciales__c = '<p><span style="font-size: 14px;">Producto DNO</span></p>';
        plan.FechaInicio__c = date.today();
        plan.ANSFactibilidad__c = 1;
        plan.ANSAprovisionamiento__c = 14;
        plan.ANSAseguramiento__c = 1;
        plan.Esmigrado__c = true;
        plan.Funcion_autorizada__c = 'Negocios';
        
        insert plan;
        
        TOPP__c toppVenta = new TOPP__c();
        toppVenta.Name = 'Venta - Plan '+plan.Name;
        toppVenta.TipodeOperacionporplan__c = 'Venta';
        toppVenta.Plan__c = plan.id;
        toppVenta.Tipoderegistro__c = 'R3';
        toppVenta.ANS_Factibilidad__c = '7';
        toppVenta.ANS__c = 21;
        toppVenta.ValorTarifaPlan__c = 0;
        toppVenta.Valorunicavez__c = 0;
        toppVenta.Activo__c = true;
        toppVenta.Facturable__c = true;
        toppVenta.Afecta_Ingresos__c = true;
        toppVenta.AplicaPreventa__c = true;
        toppVenta.DisponibleVentainicial__c = true;
        toppVenta.AplicaGerenteProyecto__c = true;
        toppVenta.Requiere_Numeracion__c = true;
        toppVenta.Disponible_LTE__c = true;
        insert toppVenta;
        
        CatalogoProductos__c producto1 = new CatalogoProductos__c();
        producto1.Name = 'TELEFONIA MOVIL (LTE)';
        producto1.Familia__c = 'VOZ';
        producto1.LineaNegocio__c = 'LOCAL';
        producto1.CodigoProducto__c = 'xxxxxxxxy';
        //producto1.NEMONICO__c = '1XY00XXXXX';
        producto1.Estado__c = 'Activo';
        producto1.Tipo_de_Producto__c = 'Avanzado';
        producto1.Catalogo__c = 'Basico';
        //producto1.Descripcion__c = 'En la parte motiva de la Res. 5968 de 2020 se señala que: El artículo 2.2.12.2.1.14. del Decreto 1078 de 2015, estableció que la numeración para los servicios semiautomáticos y especiales de abonado de estructura 1XY es un Recurso de Identificación destinado a cubrir la necesidad de prestar algunos servicios de interés social que por su naturaleza exijan facilidades de recordación y marcación al usuario. Esta numeración no está destinada al uso comercial.';
        //producto1.AtributosEstandar__c = 'Los números semiautomáticos y especiales de marcación 1XY están concebidos para proveer un acceso de fácil recordación al usuario a todos aquellos servicios de interés social que no tienen uso comercial, y que por agilidad requieren que la marcación sea sencilla. Cuentan con una atribución genérica dispuesta en cuatro modalidades que definen las características de éstos al momento de su asignación, las cuales se enfocan en el tipo de servicio a soportar y los costos que deben ser asumidos por el PRST, el Prestador del Servicio 1XY y el usuario:'
        //+'\n'+'Modalidad 1'
        //+'\n'+'Modalidad 2'
        //+'\n'+'Modalidad 3'
        //+'\n'+'Modalidad 4';
        //producto1.CodigoFacturacion__c = '0161440668';
        producto1.PremisasFacturacion__c = 'ENLACES DE VOZ,IP CENTREX,LARGA DISTANCIA,RED INTELIGENTE,VOZ';
        insert producto1;
        
        Planes__c plan1 = new Planes__c();
        
        plan1.Name = 'TELEFONIA MOVIL (LTE)';
        plan1.NombredelProducto__c = producto1.id;
        plan1.TipodePlan__c = 'Principal';
        plan1.Tarifa__c = 0;
        plan1.Estado__c = 'Activo';
        //plan1.Descripcion__c = 'Producto DNO';
        //plan1.CondicionesComerciales__c = '<p><span style="font-size: 14px;">Producto DNO</span></p>';
        plan1.FechaInicio__c = date.today();
        plan1.ANSFactibilidad__c = 1;
        plan1.ANSAprovisionamiento__c = 14;
        plan1.ANSAseguramiento__c = 1;
        plan1.Esmigrado__c = true;
        plan1.Funcion_autorizada__c = 'Negocios';
        
        insert plan1;
        
        TOPP__c toppCambio = new TOPP__c();
        toppCambio.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        toppCambio.TipodeOperacionporplan__c = 'Cambio de Plan';
        toppCambio.Plan__c = plan1.id;
        toppCambio.Tipoderegistro__c = 'CambiodePlan';
        toppCambio.ANS_Factibilidad__c = '7';
        toppCambio.ANS__c = 21;
        toppCambio.ValorTarifaPlan__c = 0;
        toppCambio.Valorunicavez__c = 0;
        toppCambio.Activo__c = true;
        toppCambio.Afecta_Ingresos__c = true;
        toppCambio.AplicaPreventa__c = true;
        toppCambio.AplicaGerenteProyecto__c = true;
        toppCambio.LTE_Parte_caso__c = true;
        insert toppCambio;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
        insert objMunicipio;
        
        PlanFacturacion__c planFac = new PlanFacturacion__c();
        planFac.Name = 'testPlanFac';
        planFac.Tipo_agrupador__c = 'Usuario';
        planFac.Plan__c = plan.id;
        insert planFac;
        
        ParametroFacturacion__c paramFac = new ParametroFacturacion__c();
        paramFac.Name = 'testName';
        paramFac.PlanFacturacion__c = planFac.id;
        paramFac.LTE_ValorDefecto__c = 'testValor';
        insert paramFac;
        
        ParametroFacturacion__c paramFac2 = new ParametroFacturacion__c();
        paramFac2.Name = 'testName2';
        paramFac2.PlanFacturacion__c = planFac.id;
        paramFac2.LTE_ValorDefecto__c = 'testValor2';
        insert paramFac2;   
        
        Account acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3054658978';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Opportunity Test Case';
        opp.CloseDate = System.today()+1;
        opp.StageName = 'En Estudio';
        opp.OwnerId = Userinfo.getUserId();
        opp.Valor_unica_vez_ETB__c = 1;    
        opp.Plan__c = plan.Id;
        opp.ANS__c = 10;  
        insert opp; 
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = acc.Id;
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
            
        ActivoETB__c act1 = new ActivoETB__c();
        act1.Oportunidad__c = opp.Id;
        act1.NombredelaCuenta__c = acc.Id;
        act1.Plan__c = plan.Id;
        act1.Estado__c = 'Activo';
        act1.IMEI_del_Equipo__c = '980684862113222';
        act1.LTE_ICCID__c = '8957187113000000222';
        act1.NumeroConexion__c = '3057000213';
        act1.Fecha_Activacion__c = system.now();
        act1.CuentaFacturacion__c = objCtaFact.id;
        insert act1;
        
        ActivoETB__c act = new ActivoETB__c();
        act.Oportunidad__c = opp.Id;
        act.NombredelaCuenta__c = acc.Id;
        act.Plan__c = plan.Id;
        act.Estado__c = 'Activo';
        act.IMEI_del_Equipo__c = '980684862113811';
        act.LTE_ICCID__c = '8957187113000000511';
        act.NumeroConexion__c = '3057000501';
        act.Fecha_Activacion__c = system.now();
        act.Activo_Relacionado__c = act1.id;
        insert act;
        
        CompensacionDatos__c compen = new CompensacionDatos__c();
        compen.Name = 'testName';
        compen.Plan__c = plan.id;
        insert compen;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = acc.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = acc.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        insert objLegalizacion;
        
        
        
        OperacionComercial__c oc = new OperacionComercial__c();
        oc.Estado__c = 'Pendiente';
        oc.FechadeActivacion__c=System.today();
        oc.Activo__c = act.Id;
        oc.Oportunidad__c = opp.Id;
        oc.TOPP__c = toppVenta.Id;
        oc.Plan__c = plan.Id;
        oc.CuentaCliente__c = acc.Id;
        oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta').getRecordTypeId();
        oc.CompensacionDatos__c = compen.id;
        //oc.Legalizacion__c = objLegalizacion.Id;
        insert oc;
        
        LTE_Servicios_adicionales__c sva = new LTE_Servicios_adicionales__c();
        
        sva.Name = 'Configuracion Tecnica';
        sva.recordTypeId = Schema.Sobjecttype.LTE_Servicios_adicionales__c.getRecordTypeInfosByName().get('Empaquetamiento').getRecordTypeId(); 
        sva.LTE_ServiceActionCode__c = 'ADD';
        sva.Plan__c = plan.id;
        sva.LTE_Estado__c = 'Pendiente';
        sva.LTE_OC_Tramite__c = oc.id;
        sva.LTE_PlanFacturacion__c = planFac.id;
        sva.LTE_ServicioETB__c = act.id;
        
        insert sva;
        
        List<LTE_SpecificationGroupXA__c> lstXA = new list<LTE_SpecificationGroupXA__c>();
        
        LTE_SpecificationGroupXA__c xa1 = new LTE_SpecificationGroupXA__c();
        
        xa1.Name = 'Duración Servicio en Meses';
        xa1.LTE_ServiciosAdicionales__c = sva.id;
        xa1.ApiName__c = 'Duracion_Meses__c';  //PREGUNTAR a JOHN
        xa1.LTE_Value__c = 'Falta Definir';
        //xa1.LTE_ActionCode__c = 'Falta Definir';
        lstXA.add(xa1);
        
        LTE_SpecificationGroupXA__c xa2 = new LTE_SpecificationGroupXA__c();
        
        xa2.Name = 'Número de canales';
        xa2.LTE_ServiciosAdicionales__c = sva.id;
        xa2.ApiName__c = 'NumeroCanales__c';
        xa2.LTE_Value__c = 'Falta Definir';
        //xa2.LTE_ActionCode__c = 'Falta Definir';
        lstXA.add(xa2);
        
        LTE_SpecificationGroupXA__c xa3 = new LTE_SpecificationGroupXA__c();
        
        xa3.Name = 'Valor Recurrente ETB';
        xa3.LTE_ServiciosAdicionales__c = sva.id;
        xa3.ApiName__c = 'ValorTarifaPlan__c';
        xa3.LTE_Value__c = 'Falta Definir';
        //xa3.LTE_ActionCode__c = 'Falta Definir';
        lstXA.add(xa3);
        
        LTE_SpecificationGroupXA__c xa4 = new LTE_SpecificationGroupXA__c();
        
        xa4.Name = 'Comentarios';
        xa4.LTE_ServiciosAdicionales__c = sva.id;
        xa4.ApiName__c = 'Comentarios__c';
        xa4.LTE_Value__c = 'Falta Definir';
        //xa4.LTE_ActionCode__c = 'Falta Definir';
        lstXA.add(xa4);
        
        insert lstXA;
        
        Equipo__c objEquipo = new Equipo__c();
        objEquipo.Name = 'Equipo Traido';
        objEquipo.LTE_PartNumber__c = '129456789987654';
        objEquipo.LTE_Marca__c = 'Huawei';
        objEquipo.LTE_Color__c = 'Negro';
        objEquipo.Valor_del_Equipo__c = 395689;
        objEquipo.LTE_IVA__c = 63310;
        objEquipo.LTE_PrecioConIVA__c = 459000;
        objEquipo.LTE_Activo__c=true; // JDUR 2016-01-12
        insert objEquipo;
    }
    
    @isTest
    private static void testSVA(){
        createSVA();
        test.startTest();
        SeleccionProductoCatalogo_ctr selClass = new SeleccionProductoCatalogo_ctr();
        OperacionComercial__c oc = [SELECT id FROM OperacionComercial__c];
        ActivoETB__c act = [SELECT id, Plan__r.Name FROM ActivoETB__c WHERE IMEI_del_Equipo__c = '980684862113811'];
        system.debug('hola 2:'+act.id);
        PlanFacturacion__c planFac = [SELECT id FROM PlanFacturacion__c];
        Planes__c plan = [SELECT id FROM Planes__c WHERE Name = 'Troncal SIP Móvil Alterna'];
        selClass.clonarSVA(oc.id, act.id);
        selClass.crearSVAyXA(oc.id, plan.id);
        SeleccionProductoCatalogo_ctr.getMapSVAyXA(oc.id);
        Map<String,List<LTE_SpecificationGroupXA__c>> mapXA = new Map<String,List<LTE_SpecificationGroupXA__c>>();
        List<LTE_SpecificationGroupXA__c> lstXA = [SELECT id FROM LTE_SpecificationGroupXA__c];
        mapXA.put('Configuracion Tecnica',lstXA);
        SeleccionProductoCatalogo_ctr.updateXA(mapXA);
        PageReference pgRef = selClass.IniciaModificarAtributos();
        selClass.creaOCCambioPlanACPrincipal(act.id,oc.id);
        ModificarAtributos.getMapSVAyXA(oc.id);
        ModificarAtributos.updateXA(mapXA);
        test.stopTest();
    }
}