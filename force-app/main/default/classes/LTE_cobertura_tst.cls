@isTest
public class LTE_cobertura_tst {
	
    public static Map<string,string> variablesTest=new Map<string,string>();
    public static list<Account> cuentas=new list<Account>();
    public static list<Opportunity> oportunidades=new list<Opportunity>();
    public static map<string,User> usuarios=new map<string,User>();
    
	public static void crearUsuarios(){
		
		
		set<string> perfiles=new set<string>{'Soporte a Ventas','Asesor Comercial'};
		
		list<Profile> pro = new list<Profile>([select id,Name from Profile where name in :perfiles]);
		for(Profile p: pro){
			
			string userRandom=p.Name.deleteWhitespace()+Math.random()*1000+'userEtb@etb.com';
			User u = new User(Alias = 'ETbUser', Email=userRandom, 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, 
			TimeZoneSidKey='America/Los_Angeles', UserName=userRandom,aprobador_lte__c=userInfo.getUserId());
			
			
			usuarios.put(p.Name,u);
		}
		
		System.runAs(new User(Id = Userinfo.getUserId())) {
		  insert usuarios.values();
		}

	
	}
    
	public static void crearConfiguracion(){
    	
    	List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
    	crearUsuarios();
    	
    	list<sobject> vg=new list<sobject>();
    	vg.add(new VariablesGlobales__c(Name='NombreDefaultaFacturacionLTE',Valor__c='DEFAULT FACTURACION LTE'));
    	vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
    	vg.add(new VariablesGlobales__c(Name='NombreFacturacionLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
    	vg.add(new VariablesGlobales__c(Name='NombrePlanDefectorLTE',Valor__c='DEFAULT FACTURACION LTE'));
    	vg.add(new VariablesGlobales__c(Name='aprovisionamientoOnline',Valor__c='3'));
    	vg.add(new VariablesGlobales__c(Name='LTEPerfilAnaSopLTE',Valor__c=userInfo.getUserId()));
    	
    	vg.add(new ServiciosWeb__c(Name='DisponibilidadM6',Action__c='/action',EndPoint__c='https://salesforce.com/x'));
    	vg.add(new ServiciosWeb__c(Name='Aprovisionar',Action__c='/action',EndPoint__c='https://salesforce.com'));
    	vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=UserInfo.getProfileId()));
    	vg.add(new Perfiles_Acciones__c(Name='DataCreditoScore',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new Perfiles_Acciones__c(Name='Adjuntos',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new HomologacionCampos__c(Valor__c='NIT',Name='AprovNIT'));
        
        
        
        vg.add(new AprovisionamientoOnline__c(Name='Disponibilidad M6',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento Tramites',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
    	
    	
    	insert vg;
    }
    
    public static void crearData(){
    	
    	Map<String,Schema.RecordTypeInfo> cuentaTiposRec = Schema.SObjectType.Account.getRecordTypeInfosByName();
    	Map<String,Schema.RecordTypeInfo> oportunidadTiposRec = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
    	
    	
    	objPruebas_tst obj=new objPruebas_tst();
    	Account cliente =obj.objAccount();
    	cliente.RecordTypeId =cuentaTiposRec.get('Cliente Principal').getRecordTypeId();
    	insert cliente;
    	cuentas.add(cliente);
    	
    	Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
    	
    	Account sucursal=obj.ObjAccount();
    	sucursal.RecordTypeId =cuentaTiposRec.get('Sucursales').getRecordTypeId();
        sucursal.Cuenta__c=cliente.id;
    	insert sucursal;
    	cuentas.add(sucursal);

    	Opportunity oportunidad=obj.objOpt();
    	oportunidad.accountId=cliente.Id;
    	oportunidad.RecordTypeId=oportunidadTiposRec.get('LTE').getRecordTypeId();
    	insert oportunidad;
    	oportunidades.add(oportunidad);
    	
    	if(variablesTest.get('oportunidad')!=null){return;}
    	
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c='LTE';
        insert Catalogo;
        
        CatalogoProductosFacturacion__c objCatalogoProdFact=objPruebas_tst.objCatalogoProductosFacturacion();
        objCatalogoProdFact.Name=Catalogo.Name;
        objCatalogoProdFact.CatalogoProductos__c=Catalogo.Id;
        insert objCatalogoProdFact;
    	
    	planes__c Plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.LTE_PlanEstructurados__c=false;
        insert plan;
        
        list<PlanFacturacion__c>PlanFactLst=new list<PlanFacturacion__c>();
       
        PlanFacturacion__c objPlanFacturacion=objPruebas_tst.objPlanFacturacion();
        objPlanFacturacion.name='PLAN NEGOCIOS CONTROL S';
        objPlanFacturacion.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        objPlanFacturacion.Plan__c=plan.id;
        PlanFactLst.add(objPlanFacturacion);
    	
    	PlanFacturacion__c objPlanFactDeft=objPruebas_tst.objPlanFacturacion();
    	objPlanFactDeft.Name='DEFAULT FACTURACION LTE';
    	objPlanFactDeft.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        PlanFactLst.add(objPlanFactDeft);
        insert PlanFactLst;
        
        SubPlanFacturacion__c subPlan =objPruebas_tst.objSubPlanFacturacion();
        subPlan.Name='NUMERO SIM CARD';
		subPlan.PlanFacturacion__c=objPlanFactDeft.id;
		subPlan.codigo__c=subPlan.Name;
		insert subPlan;

        SubPlanFacturacion__c subPlanb =objPruebas_tst.objSubPlanFacturacion();
        subPlanb.Name='BOLSA ADIC DE DATOS 5GB';
        subPlanb.PlanFacturacion__c=objPlanFactDeft.id;
        subPlanb.codigo__c=subPlanb.Name;
        subPlanb.LTE_TipoSubplan__c='Bolsa de Datos a la medida';
        insert subPlanb;
        
        system.debug('por aca'+objPlanFacturacion.Id);
        
        list<ParametroFacturacion__c> paraMetros=new list<ParametroFacturacion__c>();
        paraMetros.add(new ParametroFacturacion__c (Name='RVC PLN',LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',CatalogoProductosFacturacion__c=objCatalogoProdFact.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='IMEI_del_Equipo__c',Name='IMEI',Objeto__c='OperacionComercial__c',PlanFacturacion__c=objPlanFacturacion.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='LTE_EsPortabilidad__c',Name='EsPortabilidad',Objeto__c='LTE_DetalleOferta__c',PlanFacturacion__c=objPlanFactDeft.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlan.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlanb.Id));
		insert paraMetros;
    	
    	TOPP__c topp= obj.objTopp();
        topp.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp.Facturable__c=true;
        insert topp;

    	Equipo__c equipo=new Equipo__c(
	    	Descripcion__c='Info',
	    	LTE_Categoria__c='alta',LTE_Color__c='Morado',LTE_Gama__c='D',LTE_IVA__c=20,LTE_Marca__c='Lokia',
	    	LTE_MemoriaInternaROM_GB__c='1TB',LTE_ModeloComercial__c='Lok',LTE_OEM__c='Oem',
	    	LTE_PartNumber__c='38383838383',LTE_PrecioConIVA__c=1222,Name='LOKia',Tipo__c='ssss',
	    	Valor_del_Equipo__c=20
    	);
    	insert equipo;
    	
    	Reserva__c reserva=new Reserva__c(
    		Equipo__c=equipo.Id,Estado__c='Pendiente',LTE_Plan__c=plan.Id,Oportunidad__c=oportunidad.Id,
            LTE_DatosNavegacion__c=subPlanb.id
    	);
    	insert reserva;
    	
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        servicio.Tipodeprogramacion__c='Troncal';
        insert servicio;

    	
    	CuentaFacturacion__c objCuentaFacturacion=obj.objCuentaFacturacion();
        objCuentaFacturacion.Cliente__c=cliente.id;
        insert objCuentaFacturacion;
        
    	Contract contrato=obj.objContrato();
    	contrato.Accountid =cliente.Id;
    	insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
    	leg.Contrato__c=contrato.id;
    	leg.estado__c='Gestionado';
    	insert leg;
    	
    	OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.IDServicio__c='CAV1024234';
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=objCuentaFacturacion.id;
        oc.Estado__c=variablesTest.get('oc.Estado__c');
        oc.LTE_ICCID__c='490816320198746';
        oc.LTE_AplicaOnline__c=true;
		oc.LTE_IMSI__c='23244';
		oc.LTE_PIN__c='34343';
		oc.LTE_PUK__c='33434';
        insert oc;
        
    	LTE_DetalleOferta__c detOf=new LTE_DetalleOferta__c(
            LTE_Oferta_Economica__c=reserva.Id,
            LTE_OperacionComercial__c=oc.id,
            LTE_ReferenciaEquipo__c=equipo.id,
            Plan__c=plan.id,
            LTE_DatosNavegacion__c=subPlanb.Id);
    	insert detOf;

    	
    	detOf.LTE_IMEI__c='490816320198746';
    	detOf.LTE_ICCID__c='490816320198746';
    	update detOf;


        LTE_Servicios_adicionales__c saAd=new LTE_Servicios_adicionales__c();
        saAd.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd.LTE_Estado__c='ADD';
        saAd.LTE_ItemIdentification__c=Catalogo.Id;
        saAd.LTE_SubPlaFacturacion__c=subPlanb.Id;
        insert saAd;

        
       	LTE_Servicios_adicionales__c saAd2=new LTE_Servicios_adicionales__c();
        saAd2.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd2.LTE_Estado__c='ADD';
        saAd2.LTE_ItemIdentification__c=Catalogo.Id;
        insert saAd2;
	        
	        
        list<LTE_SpecificationGroupXA__c> spGX=new list<LTE_SpecificationGroupXA__c>();
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[0].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[1].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[2].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[3].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[4].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
	        
        insert spGX;

    }
    
    static testMethod void aprovLTE() {
    	BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        crearConfiguracion();
        
    	
    	variablesTest.put('oportunidad','0');
    	Test.startTest();
	       	System.runAs(usuarios.get('Asesor Comercial')){
	       		crearData();
                oportunidades[0].LTE_OfertaCustomizada__c =true;
                update oportunidades[0];
			}
        Test.stopTest();
    
    }
    

}