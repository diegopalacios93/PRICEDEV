/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripci?n:            Clase encargada de generar data para las dem?s clases de prueba

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     18-10-2013  Daniel Guana (DGUANA)       Creaci?n de la clase..
1.1     12-07-2018  Fernando Sarasty (FSARASTY) Se modifica la clase para incluir nuevos registros que son utilizados en las clases 
de test del proyecto de portafolio superior.
*******************************************************************************/
@isTest (SeeAllData=true)
public class GeneraData_cls {
    
    public static Poblacion__c pob;
    public static Account acc;
    public static Account accServ;
    public static Contact con;
    public static CuentaFacturacion__c cf;
    public static Contract contr;
    public static Legalizacion__c leg;
    public static Opportunity opp;  
    public static CatalogoProductos__c cat;
    public static Planes__c plan;
    public static Planes__c objPlan2;
    public static Planes__c objPlan3;
    public static Planes__c objPlan4;
    public static Planes__c objPlan5;
    public static Planes__c objPlan6;
    public static LTE_Servicios_adicionales__c objServicioAdicional;    
    public static TOPP__c topp;  
    public static TOPP__c topp2;
    public static TOPP__c topp3;
    public static TOPP__c topp4;
    public static AnchodeBanda__c ab;
    public static ActivoETB__c act;
    public static OperacionComercial__c oc;
    public static OperacionComercial__c oc2;
    public static OperacionComercial__c oc3;
    public static OperacionComercial__c oc4;
    public static OperacionComercial__c oc5;
    public static OperacionComercial__c oc6;
    public static OperacionComercial__c oc7;
    public static OperacionComercial__c oc8;
    public static User us;
    public static MatrizTipificacion__c mt;
    public static MatrizTipificacion__c mt2;
    public static Account cuenta1;
    public static Account cuenta2;
    public static Account cuenta3;
    public static Account cuenta4;
    public static Viabilidad__c via;
    public static Viabilidad__c via2;
    public static Viabilidad__c via3;
    public static CatalogoProductos__c objProducto;
    public static CatalogoProductos__c objProducto2;
    public static ActivoETB__c objServicio;
    public static ActivoETB__c objServicio2;
    public static ActivoETB__c objServicio3;
    public static ActivoETB__c objServicio4;
    public static Equipo__c objEquipo;
    public static case caso;
    public static case caso2;
    public static Fidelizacion__c retencion;
    public static Fidelizacion_Servicio__c retencionServicio;
    public static Grupo_Aseguramiento__c grupoAseg;
    
    public static void generarData(){
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new EjecucionIntegracion__c(Name='Remedy',Ejecucion__c=true));
        insert vg;
        generarPoblacion();
        generarGrupoAseuramiento();
        generarCuenta();
        generarContacto();
        generarCuentaFacturacion();
        generarCuentaServicio();
        generarContrato();
        generarLegalizacion();    
        generarCatalogoProductos();
        generarProducto2();
        generarPlanes();     
        generarTopp();
        generarTopp2();
        generarTopp3();  
        generarTopp4();  
        generarParametrosInteg();
        generarPlanes3();    
        generarPlanes4();
        generarPlanes5();
        generarServicioAdicional();
        generarOpportunity();
        generarServicio2();
        generarServicio3();
        generarServicio4();
        generarServicio();    
        generarAnchoBanda();
        generarActivoETB();
        generarCaso();
        generarCaso2();
        generarRetencion();
        generarRetencionServicio();
        generarOperacionComercial();
        generarOperacionComercial3();
        generarOperacionComercial4();
        //generarOperacionComercial5();
        //generarOperacionComercial6();
        //generarOperacionComercial7();
        //generarOperacionComercial8();
        generarPlanes2();        
        generarEquipo();
        generarViabilidad();
        generarViabilidad2();
        generarViabilidad3();
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
    
    public static Id generarEquipo(){
        objEquipo = new Equipo__c();
        objEquipo.Name = 'Equipo Traido';
        objEquipo.LTE_PartNumber__c = '1294567899800000';
        objEquipo.LTE_Marca__c = 'sin Marca';
        objEquipo.LTE_Color__c = 'Negro';
        objEquipo.Valor_del_Equipo__c = 395689;
        objEquipo.LTE_IVA__c = 63310;
        objEquipo.LTE_PrecioConIVA__c = 459000;
        objEquipo.LTE_Activo__c=true; // JDUR 2016-01-12
        insert objEquipo;
        return objEquipo.Id;
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
        acc.Phone='3054658978';
        insert acc;
        
        return acc.Id;
    }
    
    public static Id generarCuentaServicio(){
        RecordType objRT 	   = [select id, developername from RecordType where Developername='Sucursales'];
        accServ = new Account();
        accServ.Name = 'Sucursal';
        accServ.Ciudad__c = pob.Id;
        accServ.Type = 'Prospecto';
        accServ.RecordTypeId = objRT.Id;
        accServ.Cuenta__c = acc.Id;
        accServ.Estado_Cuenta__c='Activo';
        accServ.Phone='3054658978';
		accServ.Direccion__c='Cr 8 20 00';
        insert accServ;
        
        return accServ.Id;
    }
    
    public static Id generarContacto(){  
        con = new Contact(IsTEST__c = true);
        con.LastName = 'contactoconconconcontest';
        con.AccountId = acc.Id;
        con.Phone = '3125689741';
        con.MobilePhone = '3125689741';
        con.Estado__c = 'Activo';
        insert con;
        
        return con.Id;
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
    
    public static Id generarContrato(){
        contr = new Contract();
        contr.AccountId = acc.Id;
        contr.Contacto__c = con.Id;
        insert contr;
        
        return contr.Id;
    }  
    
    public static Id generarLegalizacion(){  
        leg = new Legalizacion__c();
        leg.Contrato__c = contr.Id;
        leg.Estado__c = Label.EntregaGestionProy_EstGestionado;
        leg.AnalistaSoporteVentas__c=generarUsuarioSAV();
        leg.Fecha_de_solicitud_cliente__c=system.today();
        insert leg;
        
        return leg.Id;
    }
    
    public static Legalizacion__c generarLegalizacion2(){  
        Legalizacion__c leg2 = new Legalizacion__c();
        leg2.Contrato__c = contr.Id;
        leg2.Estado__c = 'No Gestionado';
        
        return leg2;
    }
    
    public static Id generarOpportunity(){
        opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Opportunity Test Case';
        opp.CloseDate = System.today()+1;
        opp.StageName = 'En Estudio';
        opp.OwnerId = Userinfo.getUserId();
        opp.Valor_unica_vez_ETB__c = 1;    
        opp.Plan__r = objPlan3;
        opp.Plan__c = objPlan3.Id;
        opp.ANS__c = 10;
        opp.Plan__r.Tipo_Operaci_n_por_Plan__r = topp3;
        opp.Plan__r.Tipo_Operaci_n_por_Plan__c = topp3.Id;     
        insert opp;    
        return opp.Id;
    }
    
    public static Id generarCatalogoProductos(){
        cat = new CatalogoProductos__c();
        cat.Name = 'cattesteste';
        insert cat;
        
        return cat.Id;
    }
    
    public static Id generarPlanes(){
        plan = new Planes__c();
        plan.Name = 'testplannplanaplan';
        plan.NombredelProducto__c = cat.Id;
        plan.TipodePlan__c = 'Principal';
        plan.Estado__c = 'Activa';
        insert plan;
        
        return plan.Id;
    } 
    
    public static Id generarPlanes2(){
        objPlan2 = new Planes__c ();
        objPlan2.Name = 'Troncal SIP Móvil Alterna';
        objPlan2.NombredelProducto__c = objProducto.Id;
        objPlan2.TipodePlan__c = 'Principal';
        objPlan2.Tarifa__c = 96000;
        objPlan2.Estado__c = 'Activo';
        objPlan2.Descripcion__c = 'Troncal SIP Movil ALterna';
        objPlan2.CondicionesComerciales__c = 'Servicio alterno';
        objPlan2.LTE_PlanEstructurados__c = true;
        insert objPlan2;
        return objPlan2.id;
    }
    
    public static Id generarPlanes3(){        
        objPlan3 = new Planes__c();
        objPlan3.Name = 'Plan Conectividad Avanzada IP';
        objPlan3.NombredelProducto__c = objProducto2.Id;
        objPlan3.TipodePlan__c = 'Principal';
        objPlan3.Tarifa__c = 96000;
        objPlan3.Estado__c = 'Activo';
        objPlan3.Descripcion__c = 'Conectividad Avanzada IP';
        objPlan3.CondicionesComerciales__c = 'Servicio alterno';
        objPlan3.LTE_PlanEstructurados__c = true;
        objPlan3.Tipo_Operaci_n_por_Plan__c = topp3.id;
        insert objPlan3;    
        return objPlan3.id;
    }
    
    public static Id generarServicioAdicional(){
        objServicioAdicional = new LTE_Servicios_adicionales__c();
        objServicioAdicional.Name = 'Test Servicio Adicional';
        objServicioAdicional.Tipo_Operacion_por_Plan__c = topp3.Id;
        objServicioAdicional.Plan__c = objPlan4.Id;
        insert objServicioAdicional;
        return objServicioAdicional.id;
    }
    
    public static Id generarPlanes4(){        
        objPlan4 = new Planes__c();
        objPlan4.Name = 'Plan Conectividad Avanzada IP';
        objPlan4.NombredelProducto__c = objProducto.Id;
        objPlan4.TipodePlan__c = 'Principal';
        objPlan4.Tarifa__c = 96000;
        objPlan4.Estado__c = 'Activo';
        objPlan4.Descripcion__c = 'Conectividad Avanzada IP';
        objPlan4.CondicionesComerciales__c = 'Servicio alterno';
        objPlan4.LTE_PlanEstructurados__c = true;
        objPlan4.Tipo_Operaci_n_por_Plan__c = topp3.id;
        insert objPlan4;    
        return objPlan4.id;
    }
    
    public static Id generarPlanes5(){        
        objPlan5 = new Planes__c();
        objPlan5.Name = 'Troncal SIP Movil 6.000.000 Min 3.0';
        objPlan5.NombredelProducto__c = objProducto.Id;
        objPlan5.TipodePlan__c = 'Troncal SIP';
        objPlan5.Tarifa__c = 96000;
        objPlan5.Estado__c = 'Activo';
        objPlan5.Descripcion__c = 'Troncal SIP Movil 6.000.000 Min 3.0';
        objPlan5.CondicionesComerciales__c = 'Servicio alterno';
        objPlan5.LTE_PlanEstructurados__c = true;
        objPlan5.Tipo_Operaci_n_por_Plan__c = topp3.id;
        insert objPlan5;    
        return objPlan5.id;
    }
    
    public static Id generarPlanes6(){        
        objPlan6 = new Planes__c();
        objPlan6.Name = 'PLAN A LA MEDIDA CONTROL EMPRESAS';
        objPlan6.NombredelProducto__c = objProducto.Id;
        objPlan6.TipodePlan__c = 'Principal';        
        objPlan6.Estado__c = 'Activo';
        objPlan6.Descripcion__c = 'PLAN A LA MEDIDA CONTROL EMPRESAS';
        objPlan6.CondicionesComerciales__c = 'NA';        
        objPlan6.Tipo_Operaci_n_por_Plan__c = topp3.id;
        insert objPlan6;    
        return objPlan6.id;
    }
    
    public static Id generarParametrosInteg(){
        ParametroIntegracion__c objParamInteg;      
        objParamInteg = new ParametroIntegracion__c();
        objParamInteg.Activo__c = true;
        objParamInteg.Campo__c = 'Comentarios__c';  
        objParamInteg.Objeto_base__c = 'OperacionComercial__c';
        objParamInteg.TipoIntegracion__c = 'Viabilidad';
        objParamInteg.Region_de_la_etiqueta__c = 'DatosAdicionalesViabilidad';
        objParamInteg.Tipo_Operacion_por_Plan__c = topp3.id;    
        insert objParamInteg;
        return objParamInteg.id;
    }    
    public static id generarProducto(){  
        objProducto = new CatalogoProductos__c();
        objProducto.Name = 'TELEFONIA MOVIL (LTE)';
        objProducto.Familia__c = 'LTE';
        objProducto.LineaNegocio__c = 'Redes Móviles';
        objProducto.CodigoProducto__c = '7635736';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        insert objProducto;
        return objProducto.id;
    }
    
    public static id generarProducto2(){  
        objProducto2 = new CatalogoProductos__c();
        objProducto2.Name = 'Conectividad Avanzada IP';
        objProducto2.Familia__c = 'Conectividad';
        objProducto2.LineaNegocio__c = 'DATOS';
        objProducto2.CodigoProducto__c = 'ConectividadAvanzadaIP001';
        objProducto2.Estado__c = 'Activo';
        objProducto2.Catalogo__c = 'Portafolio Superior';
        objProducto2.Descripcion__c = 'test conectividad avanzada';
        objProducto2.AtributosEstandar__c = 'test conectividad avanzada';
        insert objProducto2;
        return objProducto2.id;
    }    
    
    public static id generarTopp(){  
        topp = new TOPP__c();
        topp.Name ='topptestestest';
        topp.Plan__c = plan.Id;
        topp.AplicaPreventa__c = true;
        topp.Tipoderegistro__c='A1';
        topp.Activo__c=true;
        topp.AplicaPreventa__c = true;
        insert topp;
        
        return topp.Id;
    }
    
    public static id generarTopp2(){
        generarProducto();
        topp2 = new TOPP__c();
        topp2.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
        topp2.TipodeOperacionporplan__c = 'Cambio de Plan';
        topp2.Tipoderegistro__c = 'CambioPlan_LTE';
        topp2.Facturable__c = true;
        topp2.LTE_Parte_caso__c = true;
        topp2.LTE_Catalogo_de_Producto__c = objProducto.id;
        topp2.AplicaPreventa__c = true;
        insert topp2;
        return topp2.Id;
    }
    
    public static id generarTopp3(){    
        topp3 = new TOPP__c();
        topp3.Name = 'Venta- Plan Conectividad Avanzada IP';
        topp3.TipodeOperacionporplan__c = 'Venta';
        topp3.Tipoderegistro__c = 'C1';
        topp3.Facturable__c = true;
        topp3.LTE_Parte_caso__c = true;
        topp3.LTE_Catalogo_de_Producto__c = objProducto2.id;
        topp3.AplicaGerenteProyecto__c = true;    
        insert topp3;
        return topp3.Id;
    }
    
    public static id generarTopp4(){        
        topp4 = new TOPP__c();
        topp4.Name = 'Suspensión- TELEFONIA MOVIL (LTE)';
        topp4.TipodeOperacionporplan__c = 'Suspensión';
        topp4.Tipoderegistro__c = 'Suspension_Reconexion';
        topp4.Facturable__c = true;
        topp4.LTE_Parte_caso__c = true;
        topp4.LTE_Catalogo_de_Producto__c = objProducto.id;        
        insert topp4;
        return topp4.Id;
    }
    
    public static id generarServicio2(){  
        generarPlanes2();
        objServicio2 = new ActivoETB__c();
        objServicio2.Oportunidad__c = opp.Id;
        objServicio2.CuentaFacturacion__r = cf; 
        objServicio2.CuentaFacturacion__c = cf.Id;
        objServicio2.NombredelaCuenta__c = acc.Id;
        objServicio2.Plan__r = objPlan2;
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
        objServicio2.IMEI_del_Equipo__c = '980684862113811';
        objServicio2.LTE_ICCID__c = '8957187113000000511';
        objServicio2.NumeroConexion__c = '3057000501';
        objServicio2.Fecha_Activacion__c = system.now();
        objServicio2.SucursalOrigen__c = accServ.Id;
        insert objServicio2;
        return objServicio2.Id;
    } 
    
    public static id generarServicio3(){
        objServicio3 = new ActivoETB__c();
        objServicio3.Oportunidad__c = opp.Id;
        objServicio3.CuentaFacturacion__c = cf.Id;
        objServicio3.NombredelaCuenta__c = acc.Id;
        objServicio3.Plan__c = objPlan3.Id;
        objServicio3.NombredelProducto__c = objProducto2.Id;
        objServicio3.Estado__c = 'Activo';
        objServicio3.NumeroConexion__c = '3057000501';
        objServicio3.IDservicio__c = 'CAIP000001';
        objServicio3.Fecha_Activacion__c = system.now();
        insert objServicio3;
        return objServicio3.Id;
    } 
    
    public static id generarServicio(){  
        generarPlanes2();  
        generarServicio2();
        objServicio = new ActivoETB__c();
        objServicio.Oportunidad__c = opp.Id;
        objServicio.CuentaFacturacion__r = cf;   
        objServicio.CuentaFacturacion__c = cf.Id;
        objServicio.NombredelaCuenta__c = acc.Id;
        objServicio.Plan__c = objPlan2.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        objServicio.Activo_Relacionado__r = objServicio2;      
        objServicio.Activo_Relacionado__c = objServicio2.Id;   
        insert objServicio;
        return objServicio.Id;
    }
    public static id generarServicio4(){  
        generarPlanes6();          
        objServicio4 = new ActivoETB__c();
        objServicio4.Oportunidad__c = opp.Id;
        objServicio4.CuentaFacturacion__r = cf;   
        objServicio4.CuentaFacturacion__c = cf.Id;
        objServicio4.NombredelaCuenta__c = acc.Id;
        objServicio4.Plan__c = objPlan6.Id;
        objServicio4.NombredelProducto__c = objProducto.Id;
        objServicio4.Estado__c = 'Activo';
        objServicio4.IMEI_del_Equipo__c = '980684862113805';
        objServicio4.LTE_ICCID__c = '8957187113000000506';
        objServicio4.NumeroConexion__c = '3057000501';
        objServicio4.Fecha_Activacion__c = system.now();        
        insert objServicio4;
        return objServicio4.Id;
    }
    public static Id generarAnchoBanda(){
        ab = new AnchodeBanda__c();
        ab.Name = 'testabtestanchobanda';
        ab.Numero__c = '1';
        ab.Descripcion__c = 'desc';
        ab.Unidaddemedida__c = 'kbps';
        insert ab;
        
        return ab.Id;
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
    
    public static Id generarOperacionComercial(){
        generarOperacionComercial2();
        oc = new OperacionComercial__c();
        oc.Estado__c = 'Pendiente';
        oc.FechadeActivacion__c=System.today();
        oc.Activo__c = act.Id;
        oc.AnchoBanda__c = ab.Id;
        oc.Oportunidad__c = opp.Id;
        oc.ContratoAliado__c = contr.Id;
        oc.Legalizacion__c = leg.Id;
        oc.TOPP__c = topp.Id;
        oc.Plan__c = plan.Id;
        oc.AnchoBanda__c = ab.Id;
        oc.CuentaFacturacion__c = cf.Id;
        oc.CuentaCliente__c = acc.Id;
        oc.Caso__c = caso.Id;
        oc.Fidelizacion__c = retencionServicio.Id;
        oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        oc.Operacion_Comercial_Relacionada__c = oc2.Id;
        insert oc;
        
        return oc.Id;
    }
    
    public static Id generarOperacionComercial2(){
        oc2 = new OperacionComercial__c();
        oc2.Estado__c = 'Pendiente';
        oc2.FechadeActivacion__c=System.today();
        oc2.Activo__c = act.Id;
        oc2.AnchoBanda__c = ab.Id;
        oc2.Oportunidad__c = opp.Id;
        oc2.ContratoAliado__c = contr.Id;
        oc2.Legalizacion__c = leg.Id;
        oc2.TOPP__c = topp.Id;
        oc2.Plan__c = plan.Id;
        oc2.AnchoBanda__c = ab.Id;
        oc2.CuentaFacturacion__c = cf.Id;
        oc2.CuentaCliente__c = acc.Id;
        oc2.Comentarios__c = 'OC2';
        oc2.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc2;
        
        return oc2.Id;
    }
    
    public static Id generarOperacionComercial3(){
        oc3 = new OperacionComercial__c();
        oc3.Estado__c = 'Pendiente';
        oc3.FechadeActivacion__c=System.today();
        oc3.Activo__c = act.Id;
        oc3.AnchoBanda__c = ab.Id;
        oc3.Oportunidad__c = opp.Id;
        oc3.ContratoAliado__c = contr.Id;
        oc3.Legalizacion__c = leg.Id;
        oc3.TOPP__c = topp3.Id;
        oc3.Plan__c = plan.Id;
        oc3.AnchoBanda__c = ab.Id;
        oc3.CuentaFacturacion__c = cf.Id;
        oc3.CuentaCliente__c = acc.Id;
        oc3.EstadoAprovisionamiento__c = '';
        oc3.Contacto_Tecnico__c = con.Id;
        oc3.Comentarios__c = 'OC3';
        oc3.OC_Principal_Empaquetamiento__c = oc2.Id;
        oc3.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        oc3.Integrar_con_gestor__c = false;
        insert oc3;
        return oc3.Id;
    }
    
    public static Id generarOperacionComercial4(){
        oc4 = new OperacionComercial__c();
        oc4.Estado__c = 'En Curso';
        oc4.FechadeActivacion__c=System.today();
        oc4.Activo__c = act.Id;
        oc4.AnchoBanda__c = ab.Id;
        oc4.Oportunidad__c = opp.Id;
        oc4.ContratoAliado__c = contr.Id;
        oc4.Legalizacion__r = leg;
        oc4.Legalizacion__c = leg.Id;
        oc4.TOPP__r = topp3;
        oc4.TOPP__c = topp3.Id;  
        oc4.Plan__r = objPlan5;
        oc4.Plan__c = objPlan5.Id;
        oc4.AnchoBanda__c = ab.Id;
        oc4.CuentaFacturacion__c = cf.Id;
        oc4.CuentaCliente__c = acc.Id;
        oc4.EstadoAprovisionamiento__c = '';
        oc4.Contacto_Tecnico__c = con.Id;
        oc4.Comentarios__c = 'OC4';    
        oc4.Tarifa_mensual_Troncales_SIP__c = 1000000;
        oc4.Tarifa_mensual_Bolsa_de_Moviles__c = 1000000;
        oc4.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc4;
        return oc4.Id;
    }
    
    public static Id generarOperacionComercial5(){
        oc5 = new OperacionComercial__c();
        oc5.Estado__c = 'En Curso';
        oc5.FechadeActivacion__c=System.today();
        oc5.Activo__c = act.Id;
        oc5.AnchoBanda__c = ab.Id;
        oc5.Oportunidad__c = opp.Id;
        oc5.ContratoAliado__c = contr.Id;
        oc5.Legalizacion__r = leg;
        oc5.Legalizacion__c = leg.Id;
        oc5.TOPP__r = topp3;
        oc5.TOPP__c = topp3.Id;  
        oc5.Plan__r = objPlan5;
        oc5.Plan__c = objPlan5.Id;
        oc5.AnchoBanda__c = ab.Id;
        oc5.CuentaFacturacion__c = cf.Id;
        oc5.CuentaCliente__c = acc.Id;
        oc5.EstadoAprovisionamiento__c = '';
        oc5.Contacto_Tecnico__c = con.Id;
        oc5.Comentarios__c = 'OC5'; 
        oc5.Tarifa_mensual_Troncales_SIP__c = null;
        oc5.Tarifa_mensual_Bolsa_de_Moviles__c = null;
        oc5.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc5;
        return oc5.Id;
    }
    
    public static Id generarOperacionComercial6(){      
        oc6 = new OperacionComercial__c();
        oc6.Estado__c = 'Pendiente Activacion Bolsa';
        oc6.FechadeActivacion__c=System.today();
        oc6.Activo__c = act.Id;
        oc6.AnchoBanda__c = ab.Id;
        oc6.Oportunidad__c = opp.Id;
        oc6.ContratoAliado__c = contr.Id;
        oc6.Legalizacion__r = leg;
        oc6.Legalizacion__c = leg.Id;
        oc6.TOPP__r = topp3;
        oc6.TOPP__c = topp3.Id;  
        oc6.Plan__r = objPlan5;
        oc6.Plan__c = objPlan5.Id;
        oc6.AnchoBanda__c = ab.Id;
        oc6.CuentaFacturacion__c = cf.Id;
        oc6.CuentaCliente__c = acc.Id;
        oc6.EstadoAprovisionamiento__c = '';
        oc6.Contacto_Tecnico__c = con.Id;
        oc6.Comentarios__c = 'OC6';    
        oc6.NumeroConexion__c = '3057448565';
        oc6.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc6;
        return oc6.Id;
    }
    
    public static Id generarOperacionComercial7(){      
        oc7 = new OperacionComercial__c();
        oc7.Estado__c = 'Pendiente Activacion Bolsa';
        oc7.FechadeActivacion__c=System.today();
        oc7.Activo__c = act.Id;
        oc7.AnchoBanda__c = ab.Id;
        oc7.Oportunidad__c = opp.Id;
        oc7.ContratoAliado__c = contr.Id;
        oc7.Legalizacion__r = leg;
        oc7.Legalizacion__c = leg.Id;
        oc7.TOPP__r = topp3;
        oc7.TOPP__c = topp3.Id;  
        oc7.Plan__r = objPlan5;
        oc7.Plan__c = objPlan5.Id;
        oc7.AnchoBanda__c = ab.Id;
        oc7.CuentaFacturacion__c = cf.Id;
        oc7.CuentaCliente__c = acc.Id;
        oc7.EstadoAprovisionamiento__c = '';
        oc7.Contacto_Tecnico__c = con.Id;
        oc7.Comentarios__c = 'OC7';        
        oc7.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc7;
        return oc7.Id;
    }
    
    public static Id generarOperacionComercial8(){
        oc8 = new OperacionComercial__c();
        oc8.Estado__c = 'En Curso';
        oc8.FechadeActivacion__c=System.today();
        oc8.Activo__c = act.Id;
        oc8.AnchoBanda__c = ab.Id;
        oc8.Oportunidad__c = opp.Id;
        oc8.ContratoAliado__c = contr.Id;
        oc8.Legalizacion__r = leg;
        oc8.Legalizacion__c = leg.Id;
        oc8.TOPP__r = topp3;
        oc8.TOPP__c = topp3.Id;  
        oc8.Plan__r = objPlan5;
        oc8.Plan__c = objPlan5.Id;
        oc8.AnchoBanda__c = ab.Id;
        oc8.CuentaFacturacion__c = cf.Id;
        oc8.CuentaCliente__c = acc.Id;
        oc8.EstadoAprovisionamiento__c = '';
        oc8.Contacto_Tecnico__c = con.Id;
        oc8.Comentarios__c = 'OC8'; 
        oc8.Tarifa_mensual_Troncales_SIP__c = 1000000;
        oc8.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc8;
        return oc8.Id;
    }
    
    public static Id generarUsuario(){
        Profile pro = [select id from Profile where name='Asesor Externos' limit 1];
        system.debug('==>Entrada generarUsuario()');
        us = new User();
        us.LastName = 'testerttesettetwss';
        us.Alias = 'testerst';
        us.Email = 'tester@email.com';
        string userRandom=Math.random()*1000+'userEtb@etb.com';
        us.Username = userRandom;
        us.CommunityNickname = 'testercintest';
        us.TimeZoneSidKey = 'America/Bogota';
        us.LocaleSidKey = 'es_CO';
        us.EmailEncodingKey = 'ISO-8859-1';
        us.ProfileId = pro.Id;
        us.LanguageLocaleKey = 'es';
        us.EsAsesor__c = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert us;
        }
        
        return us.Id;
    }
    
    public static Id generarUsuarioSAV(){
        
        
        Profile pro = [select id from Profile where name='Soporte a Ventas' limit 1];
        system.debug('==>Entrada generarUsuario()');
        string userRandom=Math.random()*1000+'userEtb@etb.com';
        system.debug(userRandom);
        
        User u2 = new User(Alias = 'ETbUser', Email=userRandom, 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName=userRandom);
        //us.EsAsesor__c = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert u2;
        }
        return u2.Id;
        
        
        
    }
    
    public static Id generarMatrizTipificacion(){
        RecordType objRT 	   = [select id, developername from RecordType where Developername='Tipificacion_Apertura_Soporte_PS'];
        mt = new MatrizTipificacion__c();
        mt.Proceso__c = 'FALLA TECNICA';
        mt.Agrupacion__c = 'DA?O TECNICO';
        mt.Tipologia__c = 'CAIDA DE LLAMADAS';
        mt.TipoCaso__c = 'SOPORTE TECNICO';
        mt.Estado__c = Label.MatrizTip_Activo;
        mt.RecordTypeId = objRT.Id;
        insert mt;
        
        return mt.Id;
    }
    
    public static Id generarMatrizTipificacion2(){
        RecordType objRT 	   = [select id, developername from RecordType where Developername='Matriz_de_Tipificaci_n'];
        mt2 = new MatrizTipificacion__c();
        mt2.Nivel_1__c = 'PETICIÓN';
        mt2.Nivel_2__c = 'NPLAY';
        mt2.Nivel_3__c = 'NEGOCIADO';
        mt2.Tipologia__c = 'ACTIVACIÓN DE BUZON';
        mt2.Causal__c = 'NA';
        mt2.TipoCaso__c = 'CASO PQR';
        mt2.Estado__c = Label.MatrizTip_Activo;
        mt2.RecordTypeId = objRT.Id;
        insert mt2;
        
        return mt2.Id;
    }
    
    public static Id generarMatrizTipificacion3(){
        RecordType objRT 	   = [select id, developername from RecordType where Developername='Tipificacion_Cierre_Soporte_PS'];
        mt = new MatrizTipificacion__c();
        mt.Nivel_1__c = 'INFORMACIÓN BACK';
        mt.Nivel_2__c = 'DATOS';
        mt.Nivel_3__c = 'NEGOCIADO';
        mt.Nivel_4__c = 'Nivel_4';
        mt.Nivel_5__c = 'Nivel_5';
        mt.Catalogo__c = 'Portafolio Superior';
        mt.Descripcion__c = 'Descripcion Nivel 5';
        mt.TipoCaso__c = 'SOPORTE TECNICO';
        mt.Estado__c = Label.MatrizTip_Activo;
        mt.RecordTypeId = objRT.Id;
        insert mt;
        
        return mt.Id;
    }
    
    public static void crearClientes(){
        cuenta1 = new Account();
        cuenta1.Name = 'cuenta1';
        cuenta1.AccountNumber = '12';
        cuenta1.Tipodedocumento__c = 'NIT';
        insert cuenta1;
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        cuenta2 = new Account();
        cuenta2.Name = 'cuenta2';
        cuenta2.AccountNumber = '23';
        cuenta2.Tipodedocumento__c = 'NIT';
        insert cuenta2;
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        List<Account> lstCuentas = new List<Account>();
        
        cuenta3 = new Account();
        cuenta3.Name = 'cuenta3';
        cuenta3.AccountNumber = '34'; 
        cuenta3.Tipodedocumento__c = 'NIT';
        lstCuentas.add(cuenta3);
        
        cuenta4 = new Account();
        cuenta4.Name = 'cuenta4';
        cuenta4.AccountNumber = '45';
        cuenta4.Tipodedocumento__c = 'NIT';
        lstCuentas.add(cuenta4);
        
        insert lstCuentas;
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        cuenta1.AccountNumber = '56';
        update cuenta1;
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        lstCuentas = new List<Account>();
        cuenta3.AccountNumber = '67'; 
        lstCuentas.add(cuenta3);
        cuenta4.AccountNumber = '78';
        lstCuentas.add(cuenta4);
        update lstCuentas;
    }
    
    public static Id generarViabilidad(){
        via = new Viabilidad__c();
        via.OperacionComercial__C = oc.id;
        via.Respuestadeviabilidad__c = 'Viable';
        via.EstadoViabilidad__c = 'Cerrada';
        insert via;
        
        return via.Id;
    }
    
    public static Id generarViabilidad2(){
        via2 = new Viabilidad__c();
        via2.OperacionComercial__C = oc2.id;        
        via2.Respuestadeviabilidad__c = 'Viable';
        via2.EstadoViabilidad__c = 'Cerrada';
        insert via2;        
        return via2.Id;         
    }
    
    public static Id generarViabilidad3(){
        via3 = new Viabilidad__c();
        via3.OperacionComercial__C = oc3.id;        
        via3.Respuestadeviabilidad__c = 'Viable';
        via3.EstadoViabilidad__c = 'Cerrada';
        insert via3;
        return via3.Id;         
    }
    
    public static Id generarCaso(){
        caso = new case();  
        caso.AccountId=acc.Id;
        caso.ContactId=con.id;
        insert caso;    
        return caso.Id;
    }
    
    public static Id generarCaso2(){
        RecordType objRT 	   = [select id, developername from RecordType where Developername='SOPORTE_TECNICO'];
        caso2 = new case();
        caso2.AccountId=acc.Id;
        caso2.ContactId=con.id;
        caso2.LTE_Servicio__c = objServicio3.Id;
        caso2.Grupo_Aseguramiento__c = grupoAseg.Id;
        caso2.RecordTypeId = objRT.Id;
        insert caso2;
        return caso2.Id;
    }
    
    public static Id generarRetencion(){
        retencion = new Fidelizacion__c();  
        retencion.Cuenta__c = acc.Id;  
        insert retencion;    
        return retencion.Id;
    }
    
    public static Id generarRetencionServicio(){
        retencionServicio = new Fidelizacion_Servicio__c();  
        retencionServicio.Cuenta_Cliente__c = acc.Id;  
        retencionServicio.Servicio_ETB__c = act.Id;
        retencionServicio.Fidelizacion__c = retencion.Id;
        insert retencionServicio;    
        return retencionServicio.Id;
    }
    
    public static Id generarGrupoAseuramiento(){
        grupoAseg = new Grupo_Aseguramiento__c();
        grupoAseg.Name = 'Grupo Aseguramiento';
        grupoAseg.Nivel1__c = 'ETB PORTAFOLIO SUPERIOR';
        grupoAseg.Nivel2__c = 'CAB';
        grupoAseg.Nivel3__c = 'Nivel3';
        grupoAseg.ID_externo__c = 'ExternalId';
        insert grupoAseg;
        return grupoAseg.Id;
    }
}