/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
@isTest
private class PS_EnvioAPVS_tst{


    public static Map<string,string> valoreGlobalesTest =new Map<string,string>(); 

    public static Contact     objContact;
    public static Account     objAccount;
    public static Poblacion__c  objPoblacion;
    public static Contract     objContract;
    public static Dato_Contacto_Cliente__c objDatoContactoCliente;
    public static CatalogoProductos__c objCatalogoProducto;
    public static CatalogoProductos__c objCatalogoProducto2;
  public static Planes__c objPlan;
    public static Planes__c objPlan2;
    public static Planes__c objPlan3;
    public static OperacionComercial__c objOperacionComercial;
    public static OperacionComercial__c objOperacionComercial2;
    public static OperacionComercial__c objOperacionComercial3;
    public static ActivoETB__c objActivoETB;
    public static ActivoETB__c objActivoETB2;
    public static Opportunity objOportunity;
    public static TOPP__c objTopp;
    public static TOPP__c objTopp2;
    public static CuentaFacturacion__c objCuentaFacturacion;
    public static AnchodeBanda__c objAnchoBanda;
    public static Legalizacion__c objLegalizacion;
    public static Viabilidad__c ObjVia;
    public static Viabilidad__c ObjVia2;

    public static void CreateData(){
       /*generarContratoCompetencia();
        generarDatoContactoCliente();                   
        generarOportunidad();*/
           generarPoblacion();  
          generarCuenta();  
         generarCuentaFacturacion();
         generarCatalogoProducto(); 
         generarCatalogoProducto2(); 
        generarPlan();
        generarPlan2();
        generarPlan3();
        generarTopp(); 
        generarTopp2();  
        generarOpportunity();
        generarActivoETB(); 
        generarActivoETB2();                  
        generarContacto();    
        generarContrato();
        generarLegalizacion();
        generarAnchoBanda();
        generarOperacionComercial2();
        generarOperacionComercial();
        generarOperacionComercial3();
       
        generarViabilidad();
        generarViabilidad2();
         list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new EjecucionIntegracion__c(Name='Remedy',Ejecucion__c=true));
        insert vg;
        
    }
    
     public static Id generarViabilidad(){
        ObjVia = new Viabilidad__c();
        ObjVia.OperacionComercial__C = objOperacionComercial.id;
        ObjVia.Respuestadeviabilidad__c = 'Viable';
        ObjVia.EstadoViabilidad__c = 'Cerrada';
        insert ObjVia;
        
        return ObjVia.Id;
    }
    
    public static Id generarViabilidad2(){
        ObjVia2 = new Viabilidad__c();
        ObjVia2.OperacionComercial__C = objOperacionComercial2.id;
        ObjVia2.Respuestadeviabilidad__c = 'Viable';
        ObjVia2.EstadoViabilidad__c = 'Cerrada';
        insert ObjVia2;
        
        return ObjVia2.Id;
    }
    
    public static Id generarOperacionComercial(){
        objOperacionComercial = new OperacionComercial__c();
        objOperacionComercial.Estado__c = 'Pendiente';
        objOperacionComercial.FechadeActivacion__c=System.today();
        objOperacionComercial.Activo__c = objActivoETB.Id;
        objOperacionComercial.AnchoBanda__c = objAnchoBanda.Id;
        objOperacionComercial.Oportunidad__c = objOportunity.Id;
        objOperacionComercial.ContratoAliado__c = objContract.Id;
        objOperacionComercial.Legalizacion__c = objLegalizacion.Id;
        objOperacionComercial.TOPP__c = objTopp.Id;
        objOperacionComercial.Plan__c = objPlan.Id;
        objOperacionComercial.CuentaFacturacion__c = objCuentaFacturacion.Id;
        objOperacionComercial.CuentaCliente__c = objAccount.Id;
        objOperacionComercial.Comentarios__c = 'OC2';
        objOperacionComercial.Integrar_con_gestor__c = TRUE;
        objOperacionComercial.EstadoAprovisionamiento__c = 'Abierto';
        objOperacionComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        //objOperacionComercial.Operacion_Comercial_Relacionada__c = objOperacionComercial2.Id;
        insert objOperacionComercial;
        
        return objOperacionComercial.Id;
    }
    
    public static Id generarOperacionComercial2(){
        objOperacionComercial2 = new OperacionComercial__c();
        objOperacionComercial2.Estado__c = 'Pendiente';
        objOperacionComercial2.FechadeActivacion__c=System.today();
        objOperacionComercial2.Activo__c = objActivoETB.Id;
        objOperacionComercial2.AnchoBanda__c = objAnchoBanda.Id;
        objOperacionComercial2.Oportunidad__c = objOportunity.Id;
        objOperacionComercial2.ContratoAliado__c = objContract.Id;
        objOperacionComercial2.Legalizacion__c = objLegalizacion.Id;
        objOperacionComercial2.TOPP__c = objTopp.Id;
        objOperacionComercial2.Plan__c = objPlan2.Id;
       // objOperacionComercial2.AnchoBanda__c = ab.Id;
        objOperacionComercial2.CuentaFacturacion__c = objCuentaFacturacion.Id;
        objOperacionComercial2.CuentaCliente__c = objAccount.Id;
        objOperacionComercial2.Comentarios__c = 'OC2';
        objOperacionComercial2.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert objOperacionComercial2;
        
        return objOperacionComercial2.Id;
    }

    public static Id generarOperacionComercial3(){
        objOperacionComercial3 = new OperacionComercial__c();
        objOperacionComercial3.Estado__c = 'Pendiente';
        objOperacionComercial3.FechadeActivacion__c=System.today();
        objOperacionComercial3.Activo__c = objActivoETB.Id;
        objOperacionComercial3.AnchoBanda__c = objAnchoBanda.Id;
        objOperacionComercial3.Oportunidad__c = objOportunity.Id;
        objOperacionComercial3.ContratoAliado__c = objContract.Id;
        objOperacionComercial3.Legalizacion__c = objLegalizacion.Id;
        objOperacionComercial3.TOPP__c = objTopp2.Id;
        objOperacionComercial3.Plan__c = objPlan3.Id;
       // objOperacionComercial2.AnchoBanda__c = ab.Id;
       objOperacionComercial3.CuentaFacturacion__c = objCuentaFacturacion.Id;
       objOperacionComercial3.CuentaCliente__c = objAccount.Id;
       objOperacionComercial3.Comentarios__c = 'OC3';
       objOperacionComercial3.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert objOperacionComercial3;
        
        return objOperacionComercial3.Id;
    }
    
    public static Id generarCuentaFacturacion(){  
        objCuentaFacturacion = new CuentaFacturacion__c();
        objCuentaFacturacion.Ciudad__c = objPoblacion.Id;
        objCuentaFacturacion.Cliente__c = objAccount.Id;
        objCuentaFacturacion.Estado__c='Activo';
        objCuentaFacturacion.DirCorresp__c = 'Test direccion';
        objCuentaFacturacion.LTE_CicloFacturacion__c = '97';
        insert objCuentaFacturacion;
        
        return objCuentaFacturacion.Id;
    }
    
    public static Id generarCatalogoProducto(){
        objCatalogoProducto = new CatalogoProductos__c();
        objCatalogoProducto.Name = 'cattesteste';
        objCatalogoProducto.LineaNegocio__c = 'INTERNET';
        objCatalogoProducto.Catalogo__c = 'Portafolio Superior';
        insert objCatalogoProducto;
        
        return objCatalogoProducto.Id;
    }


    public static Id generarCatalogoProducto2(){
        objCatalogoProducto2 = new CatalogoProductos__c();
        objCatalogoProducto2.Name = 'NIP';
        objCatalogoProducto2.LineaNegocio__c = 'LOCAL';
        objCatalogoProducto2.Catalogo__c = 'Portafolio Superior';
        insert objCatalogoProducto2;
        
        return objCatalogoProducto2.Id;
    }
    
    public static Id generarPlan(){
        objPlan = new Planes__c();
        objPlan.Name = 'testplannplanaplan';
        objPlan.NombredelProducto__c = objCatalogoProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Estado__c = 'Activa';
        insert objPlan;
        
        return objPlan.Id;
    } 
    
    public static Id generarPlan2(){
        objPlan2 = new Planes__c();
        objPlan2.Name = 'testplannplanaplan';
        objPlan2.NombredelProducto__c = objCatalogoProducto.Id;
        objPlan2.TipodePlan__c = 'Principal';
        objPlan2.Estado__c = 'Activa';
        insert objPlan2;
        
        return objPlan2.Id;
    } 


    public static Id generarPlan3(){
        objPlan3 = new Planes__c();
        objPlan3.Name = 'testplannplanaplan';
        objPlan3.NombredelProducto__c = objCatalogoProducto2.Id;
        objPlan3.TipodePlan__c = 'Principal';
        objPlan3.Estado__c = 'Activa';
        insert objPlan3;
        
        return objPlan3.Id;
    } 
    
    public static id generarTopp(){    
        objTopp = new TOPP__c();
        objTopp.Name = 'Venta- Plan Conectividad Avanzada IP';
        objTopp.TipodeOperacionporplan__c = 'Cambio de Suscriptor Nuevo';
        objTopp.Tipoderegistro__c = 'C1';
        objTopp.Facturable__c = true;
        objTopp.LTE_Parte_caso__c = true;
        objTopp.LTE_Catalogo_de_Producto__c = objCatalogoProducto.id;
    objTopp.AplicaGerenteProyecto__c = true;   
        objTopp.AplicaPreventa__c = true;
        
        insert objTopp;
        return objTopp.Id;
    }

    public static id generarTopp2(){    
        objTopp2 = new TOPP__c();
        objTopp2.Name = 'Modificación Estándar- Plan NIP Opcion A';
        objTopp2.TipodeOperacionporplan__c = 'Modificación Estándar';
        objTopp2.Tipoderegistro__c = 'Modificacion_Estandar';
        objTopp2.Facturable__c = true;
        objTopp2.LTE_Parte_caso__c = true;
        objTopp2.LTE_Catalogo_de_Producto__c = objCatalogoProducto2.id;
    objTopp2.AplicaGerenteProyecto__c = true;   
        objTopp2.AplicaPreventa__c = true;    
        objTopp2.Plan__c = objPlan3.Id;
        insert objTopp2;        
        return objTopp2.Id;
    }
    
    public static Id generarOpportunity(){
        objOportunity = new Opportunity();
        objOportunity.AccountId = objAccount.Id;
        objOportunity.Name = 'Opportunity Test Case';
        objOportunity.CloseDate = System.today()+1;
        objOportunity.CausaldePerdida__c = 'Otro';
        objOportunity.ForecastCategoryName = 'Negociacion';
        objOportunity.StageName = 'En Estudio';
        objOportunity.OwnerId = Userinfo.getUserId();
        objOportunity.Tipo_de_Operacion__c = 'Modificacion';
        objOportunity.Amount = 1000000;
        objOportunity.Valor_unica_vez_ETB__c = 1;   
        objOportunity.PDC__c = '80% - Probabilidad de Éxito';
        objOportunity.Plan__r = objPlan;
        objOportunity.Plan__c = objPlan.Id;
        objOportunity.ANS__c = 10;
        objOportunity.Plan__r.Tipo_Operaci_n_por_Plan__r = objTopp;
        objOportunity.Plan__r.Tipo_Operaci_n_por_Plan__c = objTopp.Id;     
        //objOportunity.Viabilidad_Adicional__c = 'No requiere';
        insert objOportunity;    
        return objOportunity.Id;
    }
    
    public static Id generarActivoETB(){
        objActivoETB = new ActivoETB__c();  
        objActivoETB.Oportunidad__c = objOportunity.Id;
        objActivoETB.Estado__c = 'Activo';  
        objActivoETB.NombredelProducto__c = objCatalogoProducto.Id;
        objActivoETB.NombredelaCuenta__c = objAccount.Id;
        insert objActivoETB;  
        
        return objActivoETB.Id;  
    }

    public static Id generarActivoETB2(){
        objActivoETB2 = new ActivoETB__c();  
        objActivoETB2.Oportunidad__c = objOportunity.Id;
        objActivoETB2.Estado__c = 'Activo';  
        objActivoETB2.NombredelProducto__c = objCatalogoProducto2.Id;
        objActivoETB2.NombredelaCuenta__c = objAccount.Id;
        insert objActivoETB2;  
        
        return objActivoETB2.Id;  
    }

    public static Id generarAnchoBanda(){
        objAnchoBanda = new AnchodeBanda__c();
        objAnchoBanda.Name = 'testabtestanchobanda';
        objAnchoBanda.Numero__c = '1';
        objAnchoBanda.Descripcion__c = 'desc';
        objAnchoBanda.Unidaddemedida__c = 'kbps';
        insert objAnchoBanda;
        
        return objAnchoBanda.Id;
    }    
    public static Id generarLegalizacion(){  
        objLegalizacion = new Legalizacion__c();
        objLegalizacion.Contrato__c = objContract.Id;
        objLegalizacion.Estado__c = Label.EntregaGestionProy_EstGestionado;
        objLegalizacion.AnalistaSoporteVentas__c=generarUsuarioSAV();
        objLegalizacion.Fecha_de_solicitud_cliente__c=system.today();
        insert objLegalizacion;
        
        return objLegalizacion.Id;
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
    
     public static Id generarCuenta(){
        objAccount = new Account();
        objAccount.Name = 'cuentacuentacuenta123';
        objAccount.Ciudad__c = objPoblacion.Id;
        objAccount.Type = 'Prospecto';
        objAccount.AccountNumber='240324';
        objAccount.Segmento__c='Empresas';
        objAccount.SubSegmento__c='Grandes';
        objAccount.Tipodedocumento__c='NIT';
        objAccount.Estado_Cuenta__c='Activo';
        objAccount.Phone='3133698521';
        // objAccount.RecordTypeId = [select Id,Name, DeveloperNAme from RecordType where sObjectType='Account' AND DeveloperName = 'Cliente_Principal'][0].Id;
        insert objAccount;    
        return objAccount.Id;
    }
    
    public static Id generarPoblacion(){
        objPoblacion = new Poblacion__c();
        objPoblacion.CodigoDane__c = '1100001';
        objPoblacion.EsMunicipio__c = true;
        objPoblacion.name = 'Bogotá';
        objPoblacion.Tipo_de_instalacion__c = 'Bogotá';
        insert objPoblacion;
        return objPoblacion.Id;
    }
    
    public static Id generarContacto(){  
        objContact = new Contact(IsTEST__c = true);
        objContact.LastName = 'contactoconconconcontest';
        objContact.AccountId = objAccount.Id;
        objContact.Phone = '00000000';
        objContact.MobilePhone = '1234567890';
        objContact.Email = 'abc@gmail.com';
        objContact.Cargo__c = 'Presidente';
        objContact.Estado__c = 'Activo';
        insert objContact;    
        return objContact.Id;
    }
    
    public static Id generarContrato(){
        objContract = new Contract();
        objContract.AccountId = objAccount.Id;
        objContract.Contacto__c = objContact.Id;
        objContract.Anexo__c = 'ACEPTACION DE OFERTA AL objContractATO PARA LA PRESTACION DE LOS SERVICIOS DE TELECOMUNICACIONES';
        objContract.Fecha_de_suscripcion__c = System.today();
        objContract.Fecha_de_inicio__c =   System.today();
        objContract.Fecha_de_terminacion__c =   System.today();
        objContract.Fecha_de_Venta__c = system.today();
        objContract.Tiempo_de_liquidacion__c = 3;
        objContract.Status = 'Ejecución';
        objContract.Valor_sin_IVA__c = 20000000;
        objContract.porcentaje_IVA__c = '19';
        objContract.Valor_adiciones__c = 1000000;
        objContract.Valor_adiciones_sin_iva__c = 1000000;
        objContract.Numero_de_adiciones__c = 2;
        objContract.Ejecutado__c = 200000;
        objContract.Valor_ejecutado_calculado_escritura__c = 200000;
        objContract.Facturado__c = 100000;
        objContract.Conciliado__c = 300000;
        objContract.Valor_mes__c = 50000;
        objContract.Valor_fijo_o_variable__c = 'Fijo';
        objContract.StartDate = System.today();     
    objContract.Param_Anexo_IVA__c = '19';
        objContract.Param_Anexo_Reteica__c = 0.00966;
        objContract.Param_Anexo_Retefuente__c = 4;  
        insert objContract;    
        return objContract.Id;
    }

   

    static testMethod void EnvioAPVSTest() {
        VariablesGlobales__c setting = new VariablesGlobales__c();
        setting.Name = 'EstadoActualizaOC';
        setting.Valor__c = 'Equipo entregado';
        insert setting;
        List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        insert lstLTEAPN;        
       // GeneraData_cls.generarData();
       CreateData();

        test.startTest();
        PS_EnvioAPVS_ctr cls = new PS_EnvioAPVS_ctr();
        //ApexPages.currentPage().getParameters().put('id',GeneraData_cls.leg.id);
        //ApexPages.currentPage().getParameters().put('status',GeneraData_cls.leg.Estado__c);
        System.debug('objLegalizacion '+objLegalizacion);
        ApexPages.currentPage().getParameters().put('id',objLegalizacion.id);
        ApexPages.currentPage().getParameters().put('status',objLegalizacion.Estado__c);
        PS_EnvioAPVS_ctr.wrpResultados wrp = new PS_EnvioAPVS_ctr.wrpResultados();
        wrp.blnSel = true;
        List<PS_EnvioAPVS_ctr.wrpResultados> lstWRP = new List<PS_EnvioAPVS_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.SelNada();
        cls.lstResult[0].blnSel = true;
         System.debug('cls.lstResult[0] '+cls.lstResult[0]);
        //cls.DetallesIntegracion();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.consultarViabilidad();
       //cls.GenerarIntegracion();
        cls.SelNada();
        cls.Cancelar();

        RecordType rt = [select Id from RecordType where Name = 'Retiros' and SobjectType = 'OperacionComercial__c' limit 1];
        
        OperacionComercial__c oc = objOperacionComercial;// GeneraData_cls.oc;
        oc.RecordTypeId = rt.Id;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;
        Account acc = objAccount;
        acc.Segmento__c = 'MiPymes';
        update acc;
        
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.SelNada();
        cls.lstResult[0].blnSel = true;
         System.debug('cls.lstResult[0] '+cls.lstResult[0]);
        //cls.DetallesIntegracion();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.consultarViabilidad();
       //cls.GenerarIntegracion();
        cls.SelNada();
        cls.Cancelar();
        
        test.stopTest();
    }
    
    static testMethod void EnvioAPVSTest2() {
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
        vg.add(new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Envio_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        insert vg;
        
         // GeneraData_cls.generarData();
       CreateData();
        Planes__c sglPlan = objPlan2;//GeneraData_cls.plan;
        sglPlan.Viabilidad_Paquete__c = 'Solo el producto principal';
        update sglPlan;
        
        TOPP__c sglTopp = objTopp;//GeneraData_cls.topp;
        sglTopp.AplicaPreventa__c = true;
        sglTopp.AplicaGerenteProyecto__c = true;
        update sglTopp;
        /*OperacionComercial__c oc = objOperacionComercial;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = true;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;*/
        //system.debug('TOPP: '+oc.Id+' - '+oc.topp__c+' - '+sglTopp.Id+' - '+sglTopp.Name+' - '+sglTopp.AplicaPreventa__c+' - '+oc.Comentarios__c);
        OperacionComercial__c oc2 = objOperacionComercial2;//GeneraData_cls.oc2;
        oc2.Integrar_con_gestor__c = true;
        update oc2;
        OperacionComercial__c oc = objOperacionComercial;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = true;
        oc.Operacion_Comercial_Relacionada__c = oc2.Id;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        Viabilidad__c via= ObjVia;//GeneraData_cls.via;
        via.Respuestadeviabilidad__c = 'No Viable';
        update via;
       /* Opportunity op  = objOportunity;
        op.Viabilidad_Adicional__c = 'No requiere';
        update op;*/
        test.startTest();
        
        PS_EnvioAPVS_ctr cls = new PS_EnvioAPVS_ctr();
         //ApexPages.currentPage().getParameters().put('id',GeneraData_cls.leg.id);
        //ApexPages.currentPage().getParameters().put('status',GeneraData_cls.leg.Estado__c);
        System.debug('objLegalizacion '+objLegalizacion);
        ApexPages.currentPage().getParameters().put('id',objLegalizacion.id);
        ApexPages.currentPage().getParameters().put('status',objLegalizacion.Estado__c);
        PS_EnvioAPVS_ctr.wrpResultados wrp = new PS_EnvioAPVS_ctr.wrpResultados();
        wrp.blnSel = true;
        List<PS_EnvioAPVS_ctr.wrpResultados> lstWRP = new List<PS_EnvioAPVS_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.SelNada();
        cls.lstResult[0].blnSel = true;
        //cls.DetallesIntegracion();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.consultarViabilidad();
        System.debug('**Linea 544 ');
        cls.GenerarIntegracion();
        cls.SelNada();
        cls.Cancelar();
        test.stopTest();
        System.debug('**Linea 549 ');
    }


    static testMethod void EnvioAPVSTest3() {
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
        vg.add(new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Envio_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        insert vg;
        
         // GeneraData_cls.generarData();
       CreateData();
        Planes__c sglPlan = objPlan2;//GeneraData_cls.plan;
        sglPlan.Viabilidad_Paquete__c = 'Solo el producto principal';
        update sglPlan;

        // CatalogoProductos__c prod = objCatalogoProducto;
        // prod.Name = 'NIP';
        // update prod;
        TOPP__c sglTopp;
        List<TOPP__c> tops = [SELECT Id, Name, Nombre_del_Producto__c FROM TOPP__c WHERE Nombre_del_Producto__c = 'NIP' ];
        if(!tops.IsEmpty())
        {
            System.debug('**tops+ '+ tops[0].Nombre_del_Producto__c);
            sglTopp = tops[0];
        }
        //TOPP__c sglTopp = objTopp2;//GeneraData_cls.topp;
        sglTopp.AplicaPreventa__c = true;
        sglTopp.AplicaGerenteProyecto__c = true;        
        update sglTopp;
        System.debug('**sglTopp+ '+ sglTopp.Nombre_del_Producto__c);
        /*OperacionComercial__c oc = objOperacionComercial;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = true;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;*/
        //system.debug('TOPP: '+oc.Id+' - '+oc.topp__c+' - '+sglTopp.Id+' - '+sglTopp.Name+' - '+sglTopp.AplicaPreventa__c+' - '+oc.Comentarios__c);
        OperacionComercial__c oc2 = objOperacionComercial2;//GeneraData_cls.oc2;
        oc2.Integrar_con_gestor__c = true;
        update oc2;
        OperacionComercial__c oc = objOperacionComercial3;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = true;
        oc.Operacion_Comercial_Relacionada__c = oc2.Id;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        Viabilidad__c via= ObjVia;//GeneraData_cls.via;
        via.Respuestadeviabilidad__c = 'No Viable';
        update via;
       /* Opportunity op  = objOportunity;
        op.Viabilidad_Adicional__c = 'No requiere';
        update op;*/
        test.startTest();
        
        PS_EnvioAPVS_ctr cls = new PS_EnvioAPVS_ctr();
         //ApexPages.currentPage().getParameters().put('id',GeneraData_cls.leg.id);
        //ApexPages.currentPage().getParameters().put('status',GeneraData_cls.leg.Estado__c);
        System.debug('objLegalizacion '+objLegalizacion);
        ApexPages.currentPage().getParameters().put('id',objOperacionComercial3.id);
        // ApexPages.currentPage().getParameters().put('status',objLegalizacion.Estado__c);
        PS_EnvioAPVS_ctr.wrpResultados wrp = new PS_EnvioAPVS_ctr.wrpResultados();
        wrp.blnSel = true;
        List<PS_EnvioAPVS_ctr.wrpResultados> lstWRP = new List<PS_EnvioAPVS_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.SelNada();
        cls.lstResult[0].blnSel = true;
        //cls.DetallesIntegracion();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.consultarViabilidad();
        cls.GenerarIntegracion();
        cls.SelNada();
        cls.Cancelar();
        test.stopTest();
    }


    static testMethod void EnvioAPVSTest4() {
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
        vg.add(new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Envio_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        insert vg;
        
         // GeneraData_cls.generarData();
       CreateData();
        Planes__c sglPlan = objPlan2;//GeneraData_cls.plan;
        sglPlan.Viabilidad_Paquete__c = 'Solo el producto principal';
        update sglPlan;

        // CatalogoProductos__c prod = objCatalogoProducto;
        // prod.Name = 'NIP';
        // update prod;
        TOPP__c sglTopp;
        List<TOPP__c> tops = [SELECT Id, Name, Nombre_del_Producto__c FROM TOPP__c WHERE Nombre_del_Producto__c = 'NIP' ];
        if(!tops.IsEmpty())
        {
            System.debug('**tops+ '+ tops[0].Nombre_del_Producto__c);
            sglTopp = tops[0];
        }
        //TOPP__c sglTopp = objTopp2;//GeneraData_cls.topp;
        sglTopp.AplicaPreventa__c = false;
        sglTopp.AplicaGerenteProyecto__c = true;        
        update sglTopp;
        System.debug('**sglTopp+ '+ sglTopp.Nombre_del_Producto__c);
        /*OperacionComercial__c oc = objOperacionComercial;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = true;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;*/
        //system.debug('TOPP: '+oc.Id+' - '+oc.topp__c+' - '+sglTopp.Id+' - '+sglTopp.Name+' - '+sglTopp.AplicaPreventa__c+' - '+oc.Comentarios__c);
        OperacionComercial__c oc2 = objOperacionComercial2;//GeneraData_cls.oc2;
        oc2.Integrar_con_gestor__c = true;
        update oc2;
        OperacionComercial__c oc = objOperacionComercial3;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = false;
        oc.Operacion_Comercial_Relacionada__c = oc2.Id;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        Viabilidad__c via= ObjVia;//GeneraData_cls.via;
        via.Respuestadeviabilidad__c = 'No Viable';
        update via;
       /* Opportunity op  = objOportunity;
        op.Viabilidad_Adicional__c = 'No requiere';
        update op;*/
        test.startTest();
        
        PS_EnvioAPVS_ctr cls = new PS_EnvioAPVS_ctr();
         //ApexPages.currentPage().getParameters().put('id',GeneraData_cls.leg.id);
        //ApexPages.currentPage().getParameters().put('status',GeneraData_cls.leg.Estado__c);
        System.debug('objLegalizacion '+objLegalizacion);
        ApexPages.currentPage().getParameters().put('id',objOperacionComercial3.id);
        // ApexPages.currentPage().getParameters().put('status',objLegalizacion.Estado__c);
        PS_EnvioAPVS_ctr.wrpResultados wrp = new PS_EnvioAPVS_ctr.wrpResultados();
        wrp.blnSel = true;
        List<PS_EnvioAPVS_ctr.wrpResultados> lstWRP = new List<PS_EnvioAPVS_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.SelNada();
        cls.lstResult[0].blnSel = true;
        //cls.DetallesIntegracion();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.consultarViabilidad();
        cls.GenerarIntegracion();
        cls.SelNada();
        cls.Cancelar();
        test.stopTest();
    }

    
    static testMethod void EnvioAPVSTest5() {
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
        vg.add(new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Envio_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        insert vg;
        
         // GeneraData_cls.generarData();
       CreateData();
        Planes__c sglPlan = objPlan2;//GeneraData_cls.plan;
        sglPlan.Viabilidad_Paquete__c = 'Solo el producto principal';
        update sglPlan;

        // CatalogoProductos__c prod = objCatalogoProducto;
        // prod.Name = 'NIP';
        // update prod;
        TOPP__c sglTopp;
        List<TOPP__c> tops = [SELECT Id, Name, Nombre_del_Producto__c FROM TOPP__c WHERE Nombre_del_Producto__c = 'NIP' ];
        if(!tops.IsEmpty())
        {
            System.debug('**tops+ '+ tops[0].Nombre_del_Producto__c);
            sglTopp = tops[0];
        }
        //TOPP__c sglTopp = objTopp2;//GeneraData_cls.topp;
        sglTopp.AplicaPreventa__c = false;
        sglTopp.AplicaGerenteProyecto__c = true;        
        update sglTopp;
        System.debug('**sglTopp+ '+ sglTopp.Nombre_del_Producto__c);
        /*OperacionComercial__c oc = objOperacionComercial;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = true;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;*/
        //system.debug('TOPP: '+oc.Id+' - '+oc.topp__c+' - '+sglTopp.Id+' - '+sglTopp.Name+' - '+sglTopp.AplicaPreventa__c+' - '+oc.Comentarios__c);
        OperacionComercial__c oc2 = objOperacionComercial2;//GeneraData_cls.oc2;
        oc2.Integrar_con_gestor__c = true;
        update oc2;
        OperacionComercial__c oc = objOperacionComercial3;// GeneraData_cls.oc;
        oc.Integrar_con_gestor__c = false;
        oc.Operacion_Comercial_Relacionada__c = oc2.Id;
        oc.Estado__c = 'Activa';
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update oc;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        Viabilidad__c via= ObjVia;//GeneraData_cls.via;
        via.Respuestadeviabilidad__c = 'No Viable';
        update via;
       /* Opportunity op  = objOportunity;
        op.Viabilidad_Adicional__c = 'No requiere';
        update op;*/
        test.startTest();
        
        PS_EnvioAPVS_ctr cls = new PS_EnvioAPVS_ctr();
         //ApexPages.currentPage().getParameters().put('id',GeneraData_cls.leg.id);
        //ApexPages.currentPage().getParameters().put('status',GeneraData_cls.leg.Estado__c);
        System.debug('objLegalizacion '+objLegalizacion);
        ApexPages.currentPage().getParameters().put('id',objOperacionComercial3.id);
        // ApexPages.currentPage().getParameters().put('status',objLegalizacion.Estado__c);
        PS_EnvioAPVS_ctr.wrpResultados wrp = new PS_EnvioAPVS_ctr.wrpResultados();
        wrp.blnSel = true;
        List<PS_EnvioAPVS_ctr.wrpResultados> lstWRP = new List<PS_EnvioAPVS_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.SelNada();
        if(cls.lstResult!=null && cls.lstResult.size()>0)
            cls.lstResult[0].blnSel = true;
        //cls.DetallesIntegracion();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.consultarViabilidad();
        cls.GenerarIntegracion();
        cls.SelNada();
        cls.Cancelar();
        test.stopTest();
    }
}