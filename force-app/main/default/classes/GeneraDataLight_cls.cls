@isTest (SeeAllData=true)
public class GeneraDataLight_cls {

  public static Poblacion__c pob;
  public static Account acc;
  public static Contact con;
  public static CuentaFacturacion__c cf;
  public static Contract contr;
  public static Legalizacion__c leg;
  public static Opportunity opp;  
  public static CatalogoProductos__c cat;
  public static Planes__c plan;
  public static LTE_Servicios_adicionales__c objServicioAdicional;    
  public static TOPP__c topp;    
  public static AnchodeBanda__c ab;
  public static ActivoETB__c act;
  public static OperacionComercial__c oc;  
  public static User us;
  public static MatrizTipificacion__c mt;
  public static Account cuenta1;  
  public static Viabilidad__c via;  
  public static CatalogoProductos__c objProducto;  
  public static ActivoETB__c objServicio;
  public static ActivoETB__c objServicio2;
  public static Equipo__c objEquipo;
  public static case caso;
  public static Fidelizacion__c retencion;
  public static Fidelizacion_Servicio__c retencionServicio;
  public static VariablesGlobales__c vGlobal;
  public static VariablesGlobales__c vGlobal2;
  public static Linea__c linea;
  
  public static void generarData(){
    generarPoblacion();
    generarCuenta();
    generarContacto();
    generarCuentaFacturacion();
    generarContrato();
    generarLegalizacion();    
    generarCatalogoProductos();    
    generarPlanes();     
    generarTopp();       
    generarParametrosInteg();    
    generarServicioAdicional();
    generarOpportunity();
    generarServicio2();
    generarServicio();    
    generarAnchoBanda();
    generarActivoETB();
    generarCaso();
    generarRetencion();
    generarRetencionServicio();
    generarOperacionComercial();
    generarLinea();
    generarEquipo();
    generarViabilidad(); 
    generarVariablesGlobales();
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
    acc.phone='3102456789';
    insert acc;
    
    return acc.Id;
  }
  
  public static Id generarContacto(){  
    con = new Contact(IsTEST__c = true);
    con.LastName = 'contactoconconconcontest';
    con.AccountId = acc.Id;
    con.Phone = '00000000';
    con.MobilePhone='3102456789';
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
    opp.Plan__r = plan;
    opp.Plan__c = plan.Id;
    opp.ANS__c = 10;
    opp.Plan__r.Tipo_Operaci_n_por_Plan__r = topp;
    opp.Plan__r.Tipo_Operaci_n_por_Plan__c = topp.Id;     
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
    plan.Name = 'TELEFONIA MOVIL (LTE)';
    plan.NombredelProducto__c = cat.Id;
    plan.TipodePlan__c = 'Principal';
    plan.Estado__c = 'Activo';
    insert plan;
    
    return plan.Id;
  }  
    
  public static Id generarServicioAdicional(){
        objServicioAdicional = new LTE_Servicios_adicionales__c();
        objServicioAdicional.Name = 'Test Servicio Adicional';
        objServicioAdicional.Tipo_Operacion_por_Plan__c = topp.Id;
        objServicioAdicional.Plan__c = plan.Id;
        insert objServicioAdicional;
        return objServicioAdicional.id;
    }
      
  public static Id generarParametrosInteg(){
    ParametroIntegracion__c objParamInteg;      
    objParamInteg = new ParametroIntegracion__c();
    objParamInteg.Activo__c = true;
    objParamInteg.Campo__c = 'Comentarios__c';  
    objParamInteg.Objeto_base__c = 'OperacionComercial__c';
    objParamInteg.TipoIntegracion__c = 'Viabilidad';
    objParamInteg.Region_de_la_etiqueta__c = 'DatosAdicionalesViabilidad';
    objParamInteg.Tipo_Operacion_por_Plan__c = topp.id;    
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
    
  public static id generarTopp(){  
    topp = new TOPP__c();
    topp.Name ='Cambio de Plan- TELEFONIA MOVIL (LTE)';
    topp.Plan__c = plan.Id;
    topp.AplicaPreventa__c = true;
    topp.Tipoderegistro__c='A1';
    topp.Activo__c=true;
    topp.AplicaPreventa__c = true;
    topp.LTE_Parte_caso__c = true;    
    topp.TipodeOperacionporplan__c = 'Cambio de Plan';
    topp.Disponible_LTE__c = true;
    topp.RequiereAnchodeBanda__c = true;
    topp.Detalle_del_tramite__c = 'Adición/Disminución MDE;Cambio Equipos;Modificación ANI/Rotación de Número;Traslado Interno;Ampliacion';      
    insert topp;    
    return topp.Id;
  }
  
    public static id generarServicio2(){        
      objServicio2 = new ActivoETB__c();
      objServicio2.Oportunidad__c = opp.Id;
      objServicio2.CuentaFacturacion__r = cf; 
      objServicio2.CuentaFacturacion__c = cf.Id;
      objServicio2.NombredelaCuenta__c = acc.Id;
      objServicio2.Plan__r = plan;
      objServicio2.Plan__c = plan.Id;
      objServicio2.Estado__c = 'Activo';
      objServicio2.IMEI_del_Equipo__c = '980684862113811';
      objServicio2.LTE_ICCID__c = '8957187113000000511';
      objServicio2.NumeroConexion__c = '3057000501';
      objServicio2.Fecha_Activacion__c = system.now();
      insert objServicio2;
      return objServicio2.Id;
  } 
    
  public static id generarServicio(){        
      generarServicio2();
      objServicio = new ActivoETB__c();
      objServicio.Oportunidad__c = opp.Id;
      objServicio.CuentaFacturacion__r = cf;   
      objServicio.CuentaFacturacion__c = cf.Id;
      objServicio.NombredelaCuenta__c = acc.Id;
      objServicio.Plan__c = plan.Id;
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
    insert oc;
    
    return oc.Id;
  } 
  public static Id generarUsuario(){
    Profile pro = [select id from Profile where name='Asesor Comercial' limit 1];
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
    mt = new MatrizTipificacion__c();
    mt.Proceso__c = 'FALLA TECNICA';
    mt.Agrupacion__c = 'DA?O TECNICO';
    mt.Tipologia__c = 'CAIDA DE LLAMADAS';
    mt.TipoCaso__c = 'SOPORTE TECNICO';
    mt.Estado__c = Label.MatrizTip_Activo;
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
               
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        List<Account> lstCuentas = new List<Account>();
        
        insert lstCuentas;
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        cuenta1.AccountNumber = '56';
        update cuenta1;
        ValidacionCreacionCuentas_cls.setFinishedRunningTriggerAccount();
        
        lstCuentas = new List<Account>();        
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
  public static Id generarCaso(){
    caso = new case();  
    caso.AccountId=acc.Id;
    caso.ContactId=con.id;    
    insert caso;    
    return caso.Id;
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
    
  public static Id generarVariablesGlobales(){        
		vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'PerfilSusRecRet';
        vGlobal.Valor__c = 'PerfilSusRecRet';
        insert vGlobal;       
      
        vGlobal2 = new VariablesGlobales__c();
        vGlobal2.Name = 'ProductoLD';
        vGlobal2.Valor__c = 'Valor Unico 1.500.000 BAYPORT,Valor Unico 10.000.000 ABPS';
      	vGlobal2.Valor02__c = 'Valor Unico 1.500.000 BAYPORT,Valor Unico 10.000.000 ABPS';
        insert vGlobal2;       
        return vGlobal.Id;      
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
}