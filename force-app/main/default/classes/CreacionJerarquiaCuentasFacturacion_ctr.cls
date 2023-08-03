/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              --
Proyecto:           Jerarquia Cuentas Facturacion
Descripción:        --

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2020-12-04      --               							Creación de la clase.
***********************************************************************************************************************/
public class CreacionJerarquiaCuentasFacturacion_ctr {    
    public List<String>					lstIdCuentaFacturacion;
    public CuentaFacturacion__c 		objCuentaFact 				{get; set;}
    public Account						objCuentaCliente			{get; set;}    
    public boolean				 		blnDisplayPopup 			{get; set;}
    public Boolean 						blnHabilitarControles		{get; set;}
    public Boolean 						blnFacturable				{get; set;}
    public String 						strCicloFactSelec 			{get; set;}
    public String 						strTipoFactura	 			{get; set;}
    public String 						strTipoFacturacion 			{get; set;}
    public String 						strMedioFacturacion			{get; set;}
    public String 						strMetodoEnvio	 			{get; set;}
    public String 						strCicloFacturacion			{get; set;}
    public String 						strTipoCuenta	 			{get; set;}    
    public String 						strIdCuentaCliente 			{get; set;}
    public String 						strNombreCuentaFactPadre 	{get; set;}    
    public String 			  			objectId					{get; set;}        
    public String 						strResponse;
    public String 						strRequest;
    public String 						strError;
    public string 						jsonStringCF;
    public String SitePrefix (){return Site.getBaseUrl();}
    
    public CreacionJerarquiaCuentasFacturacion_ctr(ApexPages.StandardController controller) 
    {
        getCuentaCliente(ApexPages.currentPage().getParameters().get('ObjectId'));
        objCuentaFact 		  			= new CuentaFacturacion__c();                
        objCuentaFact.Cliente__c		= objCuentaCliente.Id;         
        blnHabilitarControles 			= false;
    }        
    
    public PageReference redirectPage()
    {        
        PageReference returnPage;               
        objectId = ApexPages.currentPage().getParameters().get('objectId');
        return returnPage;
    }
    public list<SelectOption> lstOpcionesCicloFact
    {
        get 
        {
            list<SelectOption> 			lstAux 			= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 	= CuentaFacturacion__c.LTE_CicloFacturacion__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries	= fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    }
    
    public list<SelectOption> lstOpcionesTipoFact
    {
        get 
        {
            list<SelectOption> 			lstAux			= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 	= CuentaFacturacion__c.TipoFactura__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries = fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    }
    
    public list<SelectOption> lstOpcionesTipoFacturacion
    {
        get 
        {
            list<SelectOption> 			lstAux				= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.Tipo_Facturacion__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    } 
    public list<SelectOption> lstOpcionesMetodoEnvio
    {
        get 
        {
            list<SelectOption> 			lstAux				= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.LTE_MetodoEnvio__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    } 
    public list<SelectOption> lstOpcionesTipoCuenta
    {
        get 
        {
            list<SelectOption> 			lstAux				= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.Tipo_de_cuenta__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    }  
    public list<SelectOption> lstOpcionesMedioFacturacion
    {
        get 
        {
            list<SelectOption> 			lstAux				= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.LTE_MetodoEnvio__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    }
    public list<SelectOption> lstOpcionesCicloFactLTE
    {
        get 
        {
            list<SelectOption> 			lstAux				= new list<SelectOption>();
            Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.LTE_CicloFacturacion__c.getDescribe();
            list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();
            
            lstAux.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstAux.add(new SelectOption(entry.getValue(), entry.getLabel()));
            
            return lstAux;
        }
        set;
    }
    public PageReference guardar()
    {
        String strMensajeValidacion = '';
        // Asignación de campos
        if(strTipoCuenta == 'Padre')
            objCuentaFact.Facturable__c 			= true;
        else
            objCuentaFact.Facturable__c 			= false;
        
        objCuentaFact.LTE_MetodoEnvio__c 			= strMetodoEnvio;
        objCuentaFact.TipoFactura__c	 			= strTipoFactura;
        objCuentaFact.Tipo_Facturacion__c			= strTipoFacturacion;
        objCuentaFact.MedioFacturacion__c			= strMedioFacturacion;
        objCuentaFact.Tipo_de_cuenta__c				= strTipoCuenta;
        objCuentaFact.LTE_CicloFacturacion__c		= strCicloFacturacion;   
        
        if(objCuentaFact.Cuenta_para_servicios_Demo__c)
            objCuentaFact.LTE_NombreCuentaFacturacion__c = 'DEMO - '+objCuentaFact.LTE_NombreCuentaFacturacion__c;
        
        strMensajeValidacion = validaciones();        
        if(strMensajeValidacion != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMensajeValidacion));
            return null;
        }else{
            PageReference returnPage;                
            // Estandarizar dirección
            estandarizarDireccion();
            
            // Insertar objeto
            insert objCuentaFact;                                    
            
            // Generar log estandarizar dirección
            generarLogEstandarizarDireccion();           
            
            // Integrar cuenta de facturación
            if(!objCuentaFact.No_requiere_crear_cuenta_en_Revchain__c){
                lstIdCuentaFacturacion = new list<string>();
                lstIdCuentaFacturacion.add(objCuentaFact.Id);
                jsonStringCF = JSON.serializePretty(lstIdCuentaFacturacion);			    
                FutureSincronizarCtasFact_Revchain_cls.integrarRevchain(jsonStringCF);                
            }
            // Return
            returnPage = new PageReference('/' + objCuentaFact.Id);
            returnPage.setRedirect(true);
            return returnPage;
        }
    }
    public string validaciones(){
        String strMensajeValidacion = null;        
        
        if(objCuentaFact.Facturable__c == false && objCuentaFact.LTE_CuentaFacturacionPadre__c == null)
            strMensajeValidacion = label.Msj_CuentaFactPadreEnBlanco;
        
        if(strMensajeValidacion == null && objCuentaFact.Facturable__c == true && objCuentaFact.LTE_CuentaFacturacionPadre__c != null)
            strMensajeValidacion = label.Msj_NoAsignarCuentaFactPadre;
        
        if(strMensajeValidacion == null && objCuentaFact.LTE_CuentaFacturacionLTE__c == true && strCicloFacturacion == null)
            strMensajeValidacion = label.Msj_EscribirCicloFactLTE;
        
        if(strMensajeValidacion == null && objCuentaFact.LTE_CuentaFacturacionLTE__c == false && strCicloFacturacion != null)
            strMensajeValidacion = label.Msj_NoEscribirCicloFactLTE;
        
        if(strMensajeValidacion == null && objCuentaFact.DirCorresp__c == null || objCuentaFact.DirCorresp__c == '')
            strMensajeValidacion = label.Msj_AsignarDireccion;
        
        if(strMensajeValidacion == null && (objCuentaFact.LTE_Email__c != null && objCuentaFact.Confirmacion_Email__c != null) && (objCuentaFact.LTE_Email__c != objCuentaFact.Confirmacion_Email__c))
            strMensajeValidacion = label.Msj_CoincidirEmailyConfirmacion;            
        
        if(strMensajeValidacion == null && objCuentaFact.Facturable__c == false && objCuentaFact.LTE_CuentaFacturacionLTE__c == true && consultaTecnologiaCuentaFactPadre(objCuentaFact.LTE_CuentaFacturacionPadre__c) == false)
            strMensajeValidacion = label.Msj_CuentaPadreNoCompatibleLTE;
        
        if(strMensajeValidacion == null && objCuentaFact.Facturable__c == false && objCuentaFact.LTE_CuentaFacturacionLTE__c == false && consultaTecnologiaCuentaFactPadre(objCuentaFact.LTE_CuentaFacturacionPadre__c))
            strMensajeValidacion = label.Msj_CuentaPadreNoCompatible;        
        
        return strMensajeValidacion;
    }
    public Pagereference closePopup() {        
        blnDisplayPopup = false; 
        return null;   
    } 
    public Pagereference showPopup() {                 
        blnDisplayPopup = true;  
        return null;  
    }	
    public string getCuentaFacturacionInfo(){	        
        String mySite = SitePrefix();
        Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();        
        return  mySite+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__r.Id =\''+objectId+'\' AND Fue_creada_en_revchain__c = True AND Facturable__c = True ')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c')+'&infoParam=CuentaFacturacion';
    }
    public void getCuentaCliente(String idCuentaCliente){
        objCuentaCliente = [Select Id, Name From Account Where Id =:idCuentaCliente];
    }
    
    public void estandarizarDireccion() {
        EjecucionIntegracion__c integra = EjecucionIntegracion__c.getValues('Direcciones');
        Boolean hasError				= false;	
        
        tibcoXml_cls tXml=new tibcoXml_cls();
        map<string,string> values=new map<string,string>();
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('NormalizacionDireccion');
        values.put('direccion',objCuentaFact.DirCorresp__c);
        values.put( 'correlationID', obtenerCorrelationId() );
        string request=tibcoXml_cls.normalizacionDireccion(values);
        system.debug('entrada:'+request);
        string response = '';
        if( !Test.isRunningTest() ){
            response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
        }else{
            response='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:WSResponceConsultaNormalizacionEmpresa xmlns:ns0="http://www.etb.com.co/NPlay/SisExt/WS/WSResponceConsultaNormalizacionEmpresa/IN/1.0"><ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0"><ns1:System correlationID="null" processingServer="?">TIBCO</ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2016-08-26T12:26:30.191-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader><ns1:ConsultaNormalizacionEmpresaReponce xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/integration/SisExt/NorGeoCov/ConsultaNormalizacionEmpresa/responce/v1.0"><ns1:direccionNormalizada>AC 26 40 20</ns1:direccionNormalizada><ns1:error>false</ns1:error></ns1:ConsultaNormalizacionEmpresaReponce></ns0:WSResponceConsultaNormalizacionEmpresa></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        }
        
        system.debug(response);
        
        tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
        
        values.putAll(proReq.getMap(response));
        
        String direccion = values.get('direccionNormalizada');
        
        if(values.get('error') == 'true') {
            hasError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, label.Msj_DireccionConErrores.replace('%direccion%',direccion)));
            
            if(direccion.contains('*')) {
                objCuentaFact.AVX_EstadoDireccion__c = 'Con Errores';
            } else {
                objCuentaFact.AVX_EstadoDireccion__c = 'No Normalizada';
            }
        } else {
            System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Validado' + '   <<<<<<<<<<\n-=#=-\n');
            hasError                    = false;
        }        
        strRequest						= request;
        strResponse						= response;
        strError						= '';	
    }
    public String obtenerCorrelationId(){    	
        Datetime dttFechaHoraActual	= System.now();
        Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
        String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
        
        return strCorrelationId;
    }    
    
    public void generarLogEstandarizarDireccion(){
        LogTransacciones__c objLog		= new LogTransacciones__c(
            LTE_CuentaFacturacionLTE__c = objCuentaFact.id,
            Informacion_Enviada__c  	= strRequest,
            Informacion_Recibida__c 	= strResponse,
            Estado__c               	= objCuentaFact.AVX_EstadoDireccion__c,
            Name                    	= 'Estandarizar direcciones',
            CodigoRespuesta__c      	= strError
        );		
        insert objLog;
    } 
    
    public Boolean consultaTecnologiaCuentaFactPadre(String idCtaPadre){
        if(idCtaPadre != null){
            CuentaFacturacion__c objCFParentAux = new CuentaFacturacion__c();
            objCFParentAux = [SELECT LTE_CuentaFacturacionLTE__c FROM CuentaFacturacion__c WHERE Id =:idCtaPadre LIMIT 1];
            return objCFParentAux.LTE_CuentaFacturacionLTE__c;
        }else
            return null;        
    }
}