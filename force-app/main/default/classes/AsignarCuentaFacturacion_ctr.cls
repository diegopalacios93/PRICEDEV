global with sharing class AsignarCuentaFacturacion_ctr {

    global Boolean blnCuentaCobro {get;set;}
    public boolean blnDisplayPopup {get; set;}    
    public String  renderCheckNuevaCuenta {get; set;}
    public String SitePrefix (){return Site.getBaseUrl();}
    
	/* BEGIN - Manuel Medina - Variables para almacenar resultado de la integracion de direcciones - 05092016 */
    public static String strResponse;
    public static String strRequest;
    public static String strError;
    public static CuentaFacturacion__c objCuentaFacturacion;
    /* END - Manuel Medina - Variables para almacenar resultado de la integracion de direcciones - 05092016 */
    public String idImgLupa	{get; set;} 
    List<OperacionComercial__c> listOCsConversionDemo;

    public String getData() {
                
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE'); //-SAO
        set<string> noBuscarProd=new set<string>{'Convenio de voz','Convenio de cupo'}; //Comentado para prueba LD permitiendo convenio de cupo
                
        list<OperacionComercial__c> oc=new list<OperacionComercial__c>([Select Id,Name,Activo__c,Activo__r.Name,Plan__r.Name
            from OperacionComercial__c
            Where Legalizacion__c=:leg.id AND Estado__c='Pendiente' AND CuentaFacturacion__c=null AND TOPP__r.Facturable__c=true
            AND Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c
            /*AND Plan__r.NombredelProducto__r.Name NOT IN :noBuscarProd*/]);
        
        return JSON.serialize(oc);        
    }

    /*
    *@Description: Cierra el popup
    */
    public void closePopup() {        
        blnDisplayPopup = false; 
    }     
    
    /*
    *@Description: Muestra el popup
    */
    public void showPopup() {                 
        blnDisplayPopup = true;  
    }
    
    public Legalizacion__c leg{get;set;}
    
    
    public AsignarCuentaFacturacion_ctr() {   
        Document objeDoc = new Document();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=7'); 
        ApexPages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8'); 
        
        string legId=ApexPages.currentPage().getParameters().get('id');

        leg=[select Nombredelacuenta2__c,id, Legalizacion_servicios_Demo__c from Legalizacion__c where id=:legId];       
        
        listOCsConversionDemo =  new List<OperacionComercial__c>(
            [select Id From OperacionComercial__c 
             Where TOPP__r.TipodeOperacionporplan__c = 'Conversión Demo a Venta' AND
                   Legalizacion__c =: legId]);
        
        objeDoc = [Select Id from Document where Name = 'search' limit 1];
        idImgLupa = objeDoc.Id;
        blnCuentaCobro = false;        
        if(leg.Legalizacion_servicios_Demo__c || listOCsConversionDemo.size() > 0)
        	renderCheckNuevaCuenta = 'none';
        else
            renderCheckNuevaCuenta = '';        
    }

    @RemoteAction
    public static string setCuentaFacturacion(string cf){

        CuentaFacturacion__c cuenta=(CuentaFacturacion__c)JSON.deserializeStrict(cf,CuentaFacturacion__c.class);
        cuenta.Fue_creada_en_revchain__c=false;
        responsejs r=new responsejs();
        
        /* BEGIN - Manuel Medina - Asignacion de estado por defecto para validar direccion - 23082016 */
        cuenta.AVX_EstadoDireccion__c			= 'Pendiente';
        /* END - Manuel Medina - Asignacion de estado por defecto para validar direccion - 23082016 */

        try{
        	/* BEGIN - Manuel Medina - Asignacion de la cuenta creada y validacion de la direccion - 05092016 */
            objCuentaFacturacion = new CuentaFacturacion__c();
            objCuentaFacturacion = cuenta;
            consultarDireccion();
            insert objCuentaFacturacion;
            generarLogDirecciones();
            /* END - Manuel Medina - Asignacion de la cuenta creada y validacion de la direccion - 05092016 */
        	
            //insert cuenta;

            cuenta =[select Id, Name from CuentaFacturacion__c where id=:cuenta.id];
            r.obj=(sObject)cuenta;
            LibreriaUtilitaria_cls.GenerarExcepcionTest();

        }catch(exception e){
            r.error=e.getmessage();
        }

        return JSON.serialize(r);
    }

    @RemoteAction
    public static string setOC(string oc, string cf){	
        List<OperacionComercial__c> ocs=(List<OperacionComercial__c>)JSON.deserializeStrict(oc,List<OperacionComercial__c>.class);        
        string cuentaFact=(string)JSON.deserializeStrict(cf,string.class);
        string strResultValidacionCiclo = consultarCicloFact(cuentaFact);
        
        if(strResultValidacionCiclo != ''){			
            return JSON.serialize(strResultValidacionCiclo,true);
        }else{
            responsejs r=new responsejs();
            try{
                update ocs;
                LibreriaUtilitaria_cls.GenerarExcepcionTest();
            }catch(exception e){
                r.error=e.getmessage();
            }        
        	return JSON.serialize(r);
        }
    }

    public string getCiudad(){
        String mySite = SitePrefix();
        Schema.DescribeSObjectResult p = Poblacion__c.sObjectType.getDescribe();
        return  mySite+'/apex/Filtro?id='+p.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where EsMunicipio__c =true ')+'&f='+filtro_cls.codificar(',Name,Padre__r.Name')+'&infoParam=Poblacion';
    }
    
    
    public string getCuentaFact(){        
        System.debug('@@-valor blnCuentaCobro->'+blnCuentaCobro);
        String mySite = SitePrefix();
        if(blnCuentaCobro){
            Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();
            return  mySite+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' AND Tipo_Facturacion__c = \'Cuenta de Cobro\' ')+'&f='+filtro_cls.codificar(',Name,NombreContratoCxC__c')+'&infoParam=CuentaFacturacion';
        }else if(leg.Legalizacion_servicios_Demo__c){
            Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();            
            return  mySite+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' AND Tipo_Facturacion__c != \'Cuenta de Cobro\' AND LTE_CuentaFacturacionLTE__c = False AND Cuenta_para_servicios_Demo__c = true AND Fue_creada_en_revchain__c = true')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Ciudad__r.Name,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name,CodCicloFac__c')+'&infoParam=CuentaFacturacion&nom='+Filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Ciudad,Tipo de cuenta,Cuenta de facturación padre,Ciclo de facturación');
        }else if(listOCsConversionDemo.size()>0){
            Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();            
            return  mySite+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' AND Tipo_Facturacion__c != \'Cuenta de Cobro\' AND LTE_CuentaFacturacionLTE__c = False AND Cuenta_para_servicios_Demo__c != true AND Fue_creada_en_revchain__c = true')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Ciudad__r.Name,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name,CodCicloFac__c')+'&infoParam=CuentaFacturacion&nom='+Filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Ciudad,Tipo de cuenta,Cuenta de facturación padre,Ciclo de facturación');                        
        }else{
            Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();            
            return  mySite+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' AND Tipo_Facturacion__c != \'Cuenta de Cobro\' AND LTE_CuentaFacturacionLTE__c = False AND Cuenta_para_servicios_Demo__c != true')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Ciudad__r.Name,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name,CodCicloFac__c')+'&infoParam=CuentaFacturacion&nom='+Filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Ciudad,Tipo de cuenta,Cuenta de facturación padre,Ciclo de facturación');                        
        }
    }
    
    public string getCuentaFactPadre(){
        Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();
        String mySite = SitePrefix();
        return  mySite+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' AND Tipo_Facturacion__c != \'Cuenta de Cobro\' AND Facturable__c = TRUE AND Fue_creada_en_revchain__c = TRUE AND  LTE_CuentaFacturacionLTE__c = False')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Ciudad__r.Name')+'&infoParam=CuentaFacturacionPadre&nom='+Filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Ciudad');
    }
    
    public string getOpcionesMetodoEnvio(){
        string arrayValue  = '';
        integer count	   = 0;
        
        Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.LTE_MetodoEnvio__c.getDescribe();
        list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();        
        
        for(Schema.PicklistEntry entry : picklistEntries){
            if(count==0)
            	arrayValue = '"'+entry.getLabel()+'"';
            else
                arrayValue += ',"'+entry.getLabel()+'"';            
            count++;
        }  
        return arrayValue;
    }
    
    public string getOpcionesTipoCuenta(){
        string arrayValue  = '';
        integer count	   = 0;
        
        Schema.DescribeFieldResult 	fieldResult 		= CuentaFacturacion__c.Tipo_de_cuenta__c.getDescribe();
        list<Schema.PicklistEntry>  picklistEntries 	= fieldResult.getPicklistValues();        
        
        for(Schema.PicklistEntry entry : picklistEntries){
            if(count==0)
            	arrayValue = '"'+entry.getLabel()+'"';
            else
                arrayValue += ',"'+entry.getLabel()+'"';            
            count++;
        }  
        return arrayValue;
    }

    
    public void changeCheckbox(){
        System.debug('@@-blnCuentaCobro->'+blnCuentaCobro);
    }

    public class responsejs{
        public string error='';
        public sObject obj;
    }

	/**
	* @Method: 		consultarDireccion
	* @param: 		NA
	* @Description: Envia la direccion al normalizador y al finalizar el guardado de la cuenta de facturacion; adicional se registra el log de la transaccion.
	* @author 		Manuel Medina - 05092016
	*/
	public static void consultarDireccion() {
		EjecucionIntegracion__c integra = EjecucionIntegracion__c.getValues('Direcciones');
		Boolean hasError	= false;
	
		/*if(integra!=null && integra.Ejecucion__c==false) {
			//return redireccion();
		} else {*/
			tibcoXml_cls tXml=new tibcoXml_cls();
			map<string,string> values=new map<string,string>();
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('NormalizacionDireccion');
			values.put('direccion',objCuentaFacturacion.DirCorresp__c);
			values.put( 'correlationID', obtenerCorrelationId() );
			string request=tibcoXml_cls.normalizacionDireccion(values);
			system.debug('entrada:'+request);        	
			string response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
			system.debug(response);
	
			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
	
			values.putAll(proReq.getMap(response));
	
			String direccion = values.get('direccionNormalizada');
	
			if(values.get('error') == 'true') {
				hasError = true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'La direccion ingresada presenta errores por favor valide e intente de nuevo: ' + direccion));
	
				if(direccion.contains('*')) {
					objCuentaFacturacion.AVX_EstadoDireccion__c = 'Con Errores';
				} else {
					objCuentaFacturacion.AVX_EstadoDireccion__c = 'No Normalizada';
				}
			} else {
				System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Validado' + '   <<<<<<<<<<\n-=#=-\n');
	
				hasError                    = false;
				//objCuentaFacturacion.AVX_EstadoDireccion__c  = 'Validado';
				//objCuentaFacturacion.DirCorresp__c         = direccion;
			}
	
			strRequest						= request;
			strResponse						= response;
			strError						= '';
	
			/*return redireccion();
		}*/
	}
	
	/**
	* @Method:		generarLogDirecciones
	* @param:		NA
	* @Description:	Crea regirstro de log para las transacciones de estandarizacion de direcciones
	* @author		Manuel Medina - 05092016
	*/
	public static void generarLogDirecciones(){
        LogTransacciones__c objLog		= new LogTransacciones__c(
							                LTE_CuentaFacturacionLTE__c = objCuentaFacturacion.id,
							                Informacion_Enviada__c  = strRequest,
							                Informacion_Recibida__c = strResponse,
							                Estado__c               = objCuentaFacturacion.AVX_EstadoDireccion__c,
							                Name                    = 'Estandarizar direcciones',
							                CodigoRespuesta__c      = strError
							             );
		
		insert objLog;
    }
    
    /**
	* @Method:		obtenerCorrelationId
	* @param:		NA
	* @Description:	Obtener id de correlacion para las transacciones.
	* @author		Manuel Medina - 05092016
	*/
    public static String obtenerCorrelationId(){
    	
    	Datetime dttFechaHoraActual	= System.now();
    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
    	
    	return strCorrelationId;
    }
    public static string consultarCicloFact(string numCuenta){        
        Map<string,string>   	  mapValuesIntegRV	 		= new map<string,string>();
        List<String> 	   		  lstCiclosFactNoDisp   	= Label.Param_Jerarquia_CF_CiclosNoFacturables.split(',');        
        tibcoXml_cls.xmlMap  	  proReq		 			= new tibcoXml_cls.xmlMap();
        ServiciosWeb__c 		  wsRV		 	        	= ServiciosWeb__c.getValues('ConsultaCicloFactRevchain');
        string	 				  requestIntegRV			= '';
		string	 				  responseIntegRV			= '';
        string	 				  strStatusInteg			= '';
        string   				  strResultInteg			= '';
        string					  strCicloFact				= '';
        string					  strResultValidacionCiclo	= '';
        
        if(!numCuenta.contains('Fact-')){            
            requestIntegRV 	  = ConstruirXMLCtasFact_cls.CrearXMLGetAccountCycle(numCuenta,obtenerCorrelationId());
            
            if(!Test.isRunningTest())
            	responseIntegRV	  = LibreriaUtilitariaJobs_cls.consultarServicio(requestIntegRV,wsRV.Action__c,wsRV.EndPoint__c);
            else
            	responseIntegRV = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:GetAccountCycleOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>GETACCCIC-001</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service>       <ns1:status>PASS</ns1:status><ns1:responseDate>2020-03-27T08:09:35.327-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:GetAccountCycleOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleMsg"><ns2:ResponseService><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>MdmCmpRevchain</ns2:System><ns2:portalfija_data><ns2:ciclo_cuenta><ns2:cuenta>1490890</ns2:cuenta><ns2:ciclo>55</ns2:ciclo></ns2:ciclo_cuenta><ns2:resultado>0</ns2:resultado><ns2:descError>OK</ns2:descError></ns2:portalfija_data></ns2:ResponseService></ns2:GetAccountCycleOutput></ns0:GetAccountCycleOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            
            mapValuesIntegRV  = proReq.getMap(responseIntegRV);            
            
            if(mapValuesIntegRV.size() > 0){
                strStatusInteg    = mapValuesIntegRV.get('status');
                strResultInteg    = mapValuesIntegRV.get('Result');              
                if(strStatusInteg == 'PASS' && strResultInteg == 'S'){
                    strCicloFact	  = mapValuesIntegRV.get('ciclo');                
                    if(lstCiclosFactNoDisp.contains(strCicloFact) && strCicloFact != 'N/A')
                        strResultValidacionCiclo = Label.Msj_ErrorCicloFactCuenta.replace('%cuenta%',numCuenta).replace('%ciclo%',strCicloFact);
                }
            } 
        }                           
        return strResultValidacionCiclo;
    }
}