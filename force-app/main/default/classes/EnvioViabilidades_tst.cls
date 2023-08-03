/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para controlador de la página EnvioViabilidades_pag encargada de seleccionar
                        los activos para solicitar la viabilidad a Preventa

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-10-2013  Daniel Guana (DGUANA)       Creación de la clase. (81%)
1.1		16-07-2018	Fernando Sarasty (FSARASTY) Se incluye código para proyecto de portafolio superior.
*******************************************************************************/

@isTest
private class EnvioViabilidades_tst {
    
    public static Contact 		objContact;
    public static Account 		objAccount;
    public static Poblacion__c  objPoblacion;
    public static Contract 		objContract;
    public static Dato_Contacto_Cliente__c objDatoContactoCliente;
    public static CatalogoProductos__c objCatalogoProducto;
	public static Planes__c objPlan;
    public static Planes__c objPlan2;
    public static OperacionComercial__c objOperacionComercial;
    public static OperacionComercial__c objOperacionComercial2;
    public static ActivoETB__c objActivoETB;
    public static Opportunity objOportunity;
    public static TOPP__c objTopp;
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
        generarPlan();
        generarPlan2();
        generarTopp();   
        generarOpportunity();
         generarActivoETB();                  
        generarContacto();		
        generarContrato();
        generarLegalizacion();
        generarAnchoBanda();
        generarOperacionComercial2();
        generarOperacionComercial();
       
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

    static testMethod void ViabilidadTestOC() {
      	// GeneraData_cls.generarData();
        CreateData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadEspecifica_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        VariablesGlobales__c nVarglob = new VariablesGlobales__c(Name = 'NombreComercialAPN', Valor__c = 'APN CORPORATIVO');
        insert nVarglob;
		nVarglob = new VariablesGlobales__c(Name = 'NombreComercialLTE', Valor__c = 'TELEFONIA MOVIL (LTE)');
        insert nVarglob;
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        insert nLTEAPN;
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        insert nLTEAPN;
        
        Campos_Obligatorios_OC__c cmpReq = new Campos_Obligatorios_OC__c();
        cmpReq.Name = 'F22';
        cmpReq.Nombre_API__c = 'AnchoBanda__c';
        cmpReq.Obligatorio__c = true;
        cmpReq.Tipo_de_Registro__c = 'F22';
        insert cmpReq;
        test.startTest();
        
        EnvioViabilidades_ctr cls = new EnvioViabilidades_ctr();
        ApexPages.currentPage().getParameters().put('id',objOperacionComercial.Id);//GeneraData_cls.oc.id);
        
        EnvioViabilidades_ctr.wrpResultados wrp = new EnvioViabilidades_ctr.wrpResultados();
        wrp.blnSel = true;
        
        List<EnvioViabilidades_ctr.wrpResultados> lstWRP = new List<EnvioViabilidades_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;        
        
        //cls.CargarLabels();
        cls.AnalizaAccion();
        cls.SelTodos();
        cls.Crear();        
        //cls.obtenerDatosOC();        
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.ObtenerViabilidadesPorIntegrar();
        cls.GenerarIntegracion();
        cls.Cancelar();
        cls.Crear();        
        //cls.SelTodos();
        cls.SelNada();

        Viabilidad__c viab = [SELECT Id FROM Viabilidad__c WHERE OperacionComercial__c = :objOperacionComercial.Id LIMIT 1];
        viab.Respuestadeviabilidad__c = 'Viable';
        viab.Viabilidad_Adicional__c = 'Si requiere';        
        update viab;
        test.stopTest();
    }
    
    static testMethod void ViabilidadTestOpp() {
		VariablesGlobales__c nVarglob = new VariablesGlobales__c(Name = 'NombreComercialLTE', Valor__c = 'TELEFONIA MOVIL (LTE)');
        insert nVarglob;
        Perfiles_Reglas_OC__c nRegla = new Perfiles_Reglas_OC__c(Name = 'Escenario01', Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zweAAA', Detalles__c = 'si la operación comercial no aplica para preventa y no tiene legalización');
        insert nRegla;
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadEspecifica_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        
       	// GeneraData_cls.generarData();
           CreateData();
        String id = objOportunity.Id;// GeneraData_cls.generarOpportunity();        
        OperacionComercial__c ocm = objOperacionComercial;//GeneraData_cls.oc;
        ocm.Oportunidad__c=id;
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        update ocm;
        BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        test.startTest();
        
        EnvioViabilidades_ctr cls = new EnvioViabilidades_ctr();
        ApexPages.currentPage().getParameters().put('id',id);
        
        EnvioViabilidades_ctr.wrpResultados wrp = new EnvioViabilidades_ctr.wrpResultados();
        wrp.blnSel = true;
        
        List<EnvioViabilidades_ctr.wrpResultados> lstWRP = new List<EnvioViabilidades_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;
        //cls.CargarLabels();
        cls.AnalizaAccion();
        cls.Cancelar();
        cls.SelTodos();
        cls.SelNada();
        cls.lstResult[0].blnSel = true;
        //cls.Crear();
        //cls.obtenerDatosOC();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.ObtenerViabilidadesPorIntegrar();
        //cls.GenerarIntegracion();
        test.stopTest();
        
    }
    
    static testMethod void ViabilidadTestOCAPN() {
        ProcesosAPN_tst.CreateData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadEspecifica_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        
        Campos_Obligatorios_OC__c cmpReq = new Campos_Obligatorios_OC__c();
        cmpReq.Name = 'F22';
        cmpReq.Nombre_API__c = 'AnchoBanda__c';
        cmpReq.Obligatorio__c = true;
        cmpReq.Tipo_de_Registro__c = 'F22';
        insert cmpReq;
        test.startTest();
        
        EnvioViabilidades_ctr cls = new EnvioViabilidades_ctr();
        ApexPages.currentPage().getParameters().put('id',ProcesosAPN_tst.objOportunidad.id);
        
        EnvioViabilidades_ctr.wrpResultados wrp = new EnvioViabilidades_ctr.wrpResultados();
        wrp.blnSel = true;
        
        List<EnvioViabilidades_ctr.wrpResultados> lstWRP = new List<EnvioViabilidades_ctr.wrpResultados>();
        lstWRP.add(wrp);
        cls.lstResult = lstWRP;        
        
        //cls.CargarLabels();
        cls.AnalizaAccion();
        cls.Cancelar();        
        cls.SelTodos();
        cls.Crear();
        //cls.obtenerDatosOC();
        //cls.obtenerAttachment();
        //cls.obtenerParametrosIntegracion();
        //cls.ObtenerViabilidadesPorIntegrar();
        //cls.GenerarIntegracion();
        cls.SelNada();
        
        
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
        String strEstadoAPN = vGlobalAPN.get('EstadosViaAPN').valor__c;
        List<String> lstEstadoAPN = new List<String>(strEstadoAPN.split(','));
        Viabilidad__c viab = [SELECT Id FROM Viabilidad__c WHERE OperacionComercial__c = :ProcesosAPN_tst.objOpComercial2.id];
        viab.Respuestadeviabilidad__c = 'Viable';
        viab.EstadoViabilidad__c = lstEstadoAPN[0];
        viab.APN__c = ProcesosAPN_tst.objAPN.Id;
        update viab;
        test.stopTest();
    }
}