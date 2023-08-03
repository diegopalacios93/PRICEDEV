public class ConstruccionCanonicoCtasFact_cls {
    
	public map<string,string> mapResultInteg	 	= new map<string,string>();                
    public map<string,string> mapRtaSync	   		= new map<string,string>();     
    public String 			  strAccion;
    
    public map<string, string> orquestarIntegracion(List<CuentaFacturacion__c> lstCF, string accion){
        string xml 					= '';                  
        string strIdCuentaCliente	= '';
        strAccion  					= accion;
        
        map<string,string> 	 mapParametros 	= new map<string,string>(); 
        map<string,string> 	 mapCanonicos  	= new map<string,string>();         
        map<string,string> 	 mapIdsCF	   	= new map<string,string>(); 
                
    	System.debug('@@-@@-lstCF - UpdateCuentasFacturacion:: '+lstCF); 
        for(CuentaFacturacion__c cfAux : lstCF){
            // generar canonico
            mapParametros.put('CorrelationID', obtenerCorrelationId());
            mapParametros.put('StateCode',     recortarDane(cfAux.Ciudad__r.Padre__r.CodigoDane__c));
            mapParametros.put('DeliveryType',  (cfAux.LTE_MetodoEnvio__c == 'Servicio postal')?'Postal Service':'Email');
            mapParametros.put('User',  'Salesforce');
            mapParametros.put('EmailIsPrimaryFlag',  'Y');
             
            xml 	= armarCanonicoUpdateCtaFact(cfAux,mapParametros);
            system.debug('Mensaje XML - UpdateCuentasFacturacion: '+xml);
            
            mapCanonicos.put(cfAux.Name,xml);                               
            mapIdsCF.put(cfAux.Name,cfAux.Id);            
            strIdCuentaCliente = cfAux.Cliente__c;
        }         
        generarIntegracion(mapCanonicos,mapIdsCF);
                
        if(strAccion == 'ActualizarNombre')
        	actualizarNombreCuentasFact(strIdCuentaCliente);  
        
        return mapRtaSync;
    }
    
    public void generarIntegracion(map<string,string> mapCanonicos, map<string,string> mapIdsCF){
        string request  = '';
        string response = '';
        list<LogTransacciones__c> logs   	= new list<LogTransacciones__c>();
        //ServiciosWeb__c sw 				= ServiciosWeb__c.getValues('SincronizacionCuentasFactRevchain');  
        ServiciosWeb__c sw 				 	= ServiciosWeb__c.getValues('ActualizarDatosCuentasFact');  
        tibcoXml_cls tXml  				 	= new tibcoXml_cls();
        tibcoXml_cls.xmlMap proReq 		 	= new tibcoXml_cls.xmlMap();
        Map<string,string>   mapValues	 	= new map<string,string>();  
        Map<string,string> mapValuesUpdacc	= new map<string,string>(); 
       
        for(string cfId :mapCanonicos.keySet()){
            System.debug('@@-cfId-UpdateCuentasFacturacion->'+cfId);
            request= mapCanonicos.get(cfId);      
            if(!Test.isRunningTest())
            	response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);                                                         
            else
            	//response = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:GetAccountCycleOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>GETACCCIC-001</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service>       <ns1:status>PASS</ns1:status><ns1:responseDate>2020-03-27T08:09:35.327-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:GetAccountCycleOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleMsg"><ns2:ResponseService><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>MdmCmpRevchain</ns2:System><ns2:portalfija_data><ns2:ciclo_cuenta><ns2:cuenta>1490890</ns2:cuenta><ns2:ciclo>55</ns2:ciclo></ns2:ciclo_cuenta><ns2:resultado>0</ns2:resultado><ns2:descError>OK</ns2:descError></ns2:portalfija_data></ns2:ResponseService></ns2:GetAccountCycleOutput></ns0:GetAccountCycleOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            	response = '<?xml version = "1.0" encoding = "UTF-8"?><ns0:UpdateAccountDataSystemsOUT xmlns:ns0 = "http://www.etb.com.co/LTE/WS/BillingCorporate/UpdateAccountDataSystemsOp"><ns1:WSResponseHeader2 xmlns:ns1 = "http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>08072020114951816382</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2020-07-08T17:34:59.788-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns1:UpdateAccountDataSystemsOutput xmlns:ns1 = "http://www.etb.com.co/LTE/WS/BillingCorporate/UpdateAccountDataSystemsMsgs"><ns2:ResponseData xmlns:ns2 = "http://www.etb.com.co/LTE/WS/BillingCorporate/ResponseDataUpdateAcc"><ns2:UpdateAccountDataRVCResponse><ns2:Code>S</ns2:Code><ns2:Description>operation is successful</ns2:Description></ns2:UpdateAccountDataRVCResponse><ns2:UpdateAccountDataRMCAResponse><ns2:Item><ns2:Code>S</ns2:Code><ns2:Description>Nombre y/o email actualizado</ns2:Description></ns2:Item><ns2:Item><ns2:Code>S</ns2:Code><ns2:Description>Dirección actualizada</ns2:Description></ns2:Item></ns2:UpdateAccountDataRMCAResponse><ns2:UpdateAccountDataMDMResponse><ns2:Code>0</ns2:Code><ns2:Description>Ejecutado Exitosamente</ns2:Description></ns2:UpdateAccountDataMDMResponse></ns2:ResponseData></ns1:UpdateAccountDataSystemsOutput></ns0:UpdateAccountDataSystemsOUT>';
            mapValues = proReq.getMap(response); 
            String TipoCuenta = '';
            mapValuesUpdacc = IntegracionTramitesCuentaFacturacion_cls.UpdateAccountDataSystemsResponseValues(response, cfId);
            System.debug('@@-cfId-UpdateCuentasFacturacion-> mapValuesUpdacc' + mapValuesUpdacc);
            logs.add(generarLog(mapIdsCF.get(cfId),request,response,mapValuesUpdacc.get('status'),mapValuesUpdacc.get('ResponseCode'),mapValues.get('correlationID'), cfId, 'Actualizar Cuenta Facturación'));
            mapResultInteg.put(cfId,mapValuesUpdacc.get('ResponseCode'));
           
            if(strAccion == 'ActualizarDatos'){
                mapRtaSync.put('Code', mapValuesUpdacc.get('ResponseCode'));
            	mapRtaSync.put('Description', mapValuesUpdacc.get('ResponseDescription'));
            }      
        }   
        insert logs;                                
    }    
    public string armarCanonicoUpdateCtaFact(CuentaFacturacion__c objCtaFactAux, map<string, string> MapParametrosAux){
        string xml;          
        //xml = ConstruirXMLCtasFact_cls.CrearXMLActualizarDatosCtaFacturacion(objCtaFactAux, MapParametrosAux, strAccion);
        xml = ConstruirXMLCtasFact_cls.CrearXMLUpdateAccountDataSystems(objCtaFactAux, MapParametrosAux, strAccion);
        return xml;
    }  
    public String obtenerCorrelationId(){    	
    	Datetime dttFechaHoraActual	= System.now();
    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
    	
    	return strCorrelationId;
    } 
    public String recortarDane(String strCod)
	{
		String strCodigo='';
		if(strCod!=null){
			if(strCod.length()==5)
			{
				strCodigo=strCod.substring(0,2);
			}
			else if(strCod.length()==4)
			{
				strCodigo=strCod.substring(0,1);
			}
		}
		return strCodigo;
	}
    public LogTransacciones__c generarLog(id idCF, string request,string response, string estado, string CodigoRespuesta, string AC_Random, string NumCuenta, string tipoLog){        
        LogTransacciones__c lt =new LogTransacciones__c(LTE_CuentaFacturacionLTE__c=idCF,CorrelationId__c=NumCuenta,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name=(tipoLog+' '+NumCuenta),CodigoRespuesta__c=CodigoRespuesta,AC_CorrelationID_Random__c=AC_Random);        
        return lt;    
    }  
    public void actualizarNombreCuentasFact(string strIdCuentaCliente){
        Account objAccount						= new Account();
        List<CuentaFacturacion__c> lstCF 		= new List<CuentaFacturacion__c>(); 
        List<CuentaFacturacion__c> lstCFUpdate 	= new List<CuentaFacturacion__c>(); 
        List<string> 	   		   lstIdsCF		= new List<string>();
        if(!mapResultInteg.isEmpty()){
            for(string cfId :mapResultInteg.keySet()){
                if(mapResultInteg.get(cfId) == '0'){
                    lstIdsCF.add(cfId);
                } 				
        	}
        }
        if(lstIdsCF.size() > 0){
         	lstCF = [SELECT Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name From CuentaFacturacion__c Where Name IN  : lstIdsCF];   
            if(lstCF.size() > 0){
                for(CuentaFacturacion__c objCFAux : lstCF){
                    objCFAux.LTE_NombreCuentaFacturacion__c = objCFAux.Cliente__r.Name;
                    lstCFUpdate.Add(objCFAux);
                }
                system.debug('lstCFUpdate-UpdateCuentasFacturacion '+lstCFUpdate);
                update lstCFUpdate;
            }            
        }
        objAccount = [Select Id, Actualizar_nombres_cuentas_facturacion__c From Account Where Id=:strIdCuentaCliente];
        objAccount.Actualizar_nombres_cuentas_facturacion__c = false;
        update objAccount;
    }
}