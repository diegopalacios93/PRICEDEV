@isTest
private class AsignarOC_SDWAN_tst {
	public static OperacionComercial__c 	oc;
    public static OperacionComercial__c 	oc2;
    public static ActivoETB__c 				act;
    public static ActivoETB__c 				act2;
    public static Opportunity 				opp;  
    public static Account 					acc;
    public static Poblacion__c 				pob;
    public static Planes__c 				plan;
    public static Planes__c 				plan2;
    public static CatalogoProductos__c 		cat;
    public static CatalogoProductos__c 		cat2;
    public static TOPP__c 					topp;  
    public static TOPP__c 					topp2;  
    public static Contract 					contr;
    public static Contact 					con;
    public static Legalizacion__c 			leg;
    public static CuentaFacturacion__c 		cf;
        
    static testMethod void unitTest() {               
        PageReference objPageRef;       
        generarData();
        system.currentPageReference().getParameters().put('ObjectId', oc.Id);
        AsignarOC_SDWAN_ctr asignaSD = new AsignarOC_SDWAN_ctr();
        asignaSD.filtrarOCs();
        asignaSD.stringBusqueda = 'OC';
        asignaSD.filtrarOCs();
        asignaSD.checkAll();        
        objPageRef = asignaSD.regresar();   
        objPageRef = asignaSD.buscarServicio();   
        objPageRef = asignaSD.asignarOCs(); 
        asignaSD.consultarOC();
        
    }
    public static void generarData(){
        generarPoblacion();
        generarCuenta();
        generarCatalogoProductos();
        generarCatalogoProductos2();
        generarContacto();
        generarContrato();        
        generarPlanes();        
        generarPlanes2();        
        generarTopp();
        generarTopp2();
        generarOpportunity();             
        generarActivoETB();        
        generarActivoETB2();        
        generarCuentaFacturacion();
        generarLegalizacion();
        generarOperacionComercial();        
        generarOperacionComercial2();        
    }
	public static id generarTopp(){  
        topp = new TOPP__c();
        topp.Name ='Venta';
        topp.Plan__c = plan.Id;
        topp.AplicaPreventa__c = true;
        topp.Tipoderegistro__c='A1';
        topp.Activo__c=true;
        topp.AplicaPreventa__c = true;
        topp.TipodeOperacionporplan__c = 'Venta';
        insert topp;        
        return topp.Id;
    }   
    public static id generarTopp2(){  
        topp2 = new TOPP__c();
        topp2.Name ='Venta';
        topp2.Plan__c = plan2.Id;
        topp2.AplicaPreventa__c = true;
        topp2.Tipoderegistro__c='A1';
        topp2.Activo__c=true;
        topp2.AplicaPreventa__c = true;
        topp2.TipodeOperacionporplan__c = 'Venta';
        insert topp2;        
        return topp2.Id;
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
    public static Id generarLegalizacion(){  
        leg = new Legalizacion__c();
        leg.Contrato__c = contr.Id;
        leg.Estado__c = Label.EntregaGestionProy_EstGestionado;
        //leg.AnalistaSoporteVentas__c=generarUsuarioSAV();
        leg.Fecha_de_solicitud_cliente__c=system.today();
        insert leg;        
        return leg.Id;
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
    public static Id generarContrato(){
        contr = new Contract();
        contr.AccountId = acc.Id;
        contr.Contacto__c = con.Id;
        insert contr;        
        return contr.Id;
    }  
    public static Id generarCatalogoProductos(){
        cat = new CatalogoProductos__c();
        cat.Name = 'SD-WAN';
        insert cat;        
        return cat.Id;
    }
    public static Id generarCatalogoProductos2(){
        cat2 = new CatalogoProductos__c();
        cat2.Name = 'Conectividad Avanzada IP';
        insert cat2;        
        return cat2.Id;
    }
    public static Id generarPlanes(){
        plan = new Planes__c();
        plan.Name = 'Plan Control de Aplicaciones SDWAN';
        plan.NombredelProducto__c = cat.Id;
        plan.TipodePlan__c = 'Principal';
        plan.Estado__c = 'Activa';
        insert plan;        
        return plan.Id;
    } 
    public static Id generarPlanes2(){
        plan2 = new Planes__c();
        plan2.Name = 'Plan Conectividad Avanzada IP';
        plan2.NombredelProducto__c = cat2.Id;
        plan2.TipodePlan__c = 'Principal';
        plan2.Estado__c = 'Activa';
        insert plan2;        
        return plan2.Id;
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
    public static Id generarActivoETB(){
        act = new ActivoETB__c();
        act.Oportunidad__c = opp.Id;
        act.Estado__c = 'Activo';  
        act.NombredelProducto__c = cat.Id;
        act.NombredelaCuenta__c = acc.Id;
        act.Plan__c = plan.Id;
        insert act;          
        return act.Id;  
    }
    public static Id generarActivoETB2(){
        act2 = new ActivoETB__c();
        act2.Oportunidad__c = opp.Id;
        act2.Estado__c = 'Activo';  
        act2.NombredelProducto__c = cat2.Id;
        act2.NombredelaCuenta__c = acc.Id;
        act2.Plan__c = plan2.Id;
        insert act2;          
        return act2.Id;  
    }
    public static Id generarOperacionComercial(){        
        oc = new OperacionComercial__c();
        oc.Estado__c = 'Pendiente';
        oc.FechadeActivacion__c=System.today();
        oc.Activo__c = act.Id;        
        oc.Oportunidad__c = opp.Id;
        oc.ContratoAliado__c = contr.Id;
        oc.Legalizacion__c = leg.Id;
        oc.TOPP__c = topp.Id;
        oc.Plan__c = plan.Id;
        //oc.AnchoBanda__c = ab.Id;
        oc.CuentaFacturacion__c = cf.Id;
        oc.CuentaCliente__c = acc.Id;
        //oc.Caso__c = caso.Id;
        //oc.Fidelizacion__c = retencionServicio.Id;
        oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();        
        insert oc;        
        return oc.Id;
    }   
    public static Id generarOperacionComercial2(){        
        oc2 = new OperacionComercial__c();
        oc2.Estado__c = 'Pendiente';
        oc2.FechadeActivacion__c=System.today();
        oc2.Activo__c = act2.Id;        
        oc2.Oportunidad__c = opp.Id;
        oc2.ContratoAliado__c = contr.Id;
        oc2.Legalizacion__c = leg.Id;
        oc2.TOPP__c = topp2.Id;
        oc2.Plan__c = plan2.Id;
        //oc.AnchoBanda__c = ab.Id;
        oc2.CuentaFacturacion__c = cf.Id;
        oc2.CuentaCliente__c = acc.Id;
        //oc.Caso__c = caso.Id;
        //oc.Fidelizacion__c = retencionServicio.Id;
        oc2.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();        
        insert oc2;        
        return oc2.Id;
    }   
}