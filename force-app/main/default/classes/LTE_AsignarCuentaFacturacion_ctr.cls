public with sharing class LTE_AsignarCuentaFacturacion_ctr {
	
	public Legalizacion__c leg{get;set;}
    public String idImgLupa	{get; set;} 
	
    public LTE_AsignarCuentaFacturacion_ctr() {
        Document objeDoc = new Document();
        objeDoc = [Select Id from Document where Name = 'search' limit 1];
        idImgLupa = objeDoc.Id;
        string legId=ApexPages.currentPage().getParameters().get('id');
        
        list<Legalizacion__c>Legalizacion=new list<Legalizacion__c>([select Nombredelacuenta2__c,id,Estado__c,Legalizacion_servicios_Demo__c from Legalizacion__c where id=:legId AND Estado__c!='Gestionado']);

		if(!Legalizacion.isEmpty()){
        	leg=Legalizacion[0];
		}
        
    }

	public string getCuentaFact(){
		
		if(leg==null){
    		return '0';
    	}
		
		Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();
        if(leg.Legalizacion_servicios_Demo__c)
            return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' and (Facturable__c=true or (Facturable__c=false and LTE_CuentaFacturacionPadre__r.Facturable__c=true)) AND Cuenta_para_servicios_Demo__c = true ')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name,CodCicloFac__c')+'&infoParam=CuentaFacturacion&nom='+filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Tipo de cuenta,Cuenta de facturación padre,Ciclo de facturación');
        else
        	return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+leg.Nombredelacuenta2__c+'\' and (Facturable__c=true or (Facturable__c=false and LTE_CuentaFacturacionPadre__r.Facturable__c=true)) AND LTE_CuentaFacturacionLTE__c = true ')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name,CodCicloFac__c')+'&infoParam=CuentaFacturacion&nom='+filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Tipo de cuenta,Cuenta de facturación padre,Ciclo de facturación');
    }
    
    public String getData() {
    	
    	system.debug(leg);
    	if(leg==null){
    	
    		return '0';
    	}

        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        string producto=vGlobal.get('NombreComercialLTE').valor__c;

        set<string> noBuscarProd=new set<string>{'Convenio de voz','Convenio de cupo'};
        
        list<OperacionComercial__c> oc=new list<OperacionComercial__c>([Select Id,Name,Activo__c,Activo__r.Name,Plan__r.Name,Portacion__c,CuentaFacturacion__r.Name
            from OperacionComercial__c
            Where Legalizacion__c=:leg.id AND Estado__c='Pendiente' AND TOPP__r.Facturable__c=true
            AND Plan__r.NombredelProducto__r.Name=:producto]);

        list<wrapper> wr=new list<wrapper>();
        for(OperacionComercial__c o:oc){
            wr.add(new wrapper(o,false));
        }



        return JSON.serialize(wr);
    }
    
    @RemoteAction
    public static string setOC(string oc, string cf){
        list<wrapper> ocs=(list<wrapper>)JSON.deserializeStrict(oc,list<wrapper>.class);
        string cuentaFact=(string)JSON.deserializeStrict(cf,string.class);
        string strResultValidacionCiclo = consultarCicloFact(cuentaFact);
		
        if(strResultValidacionCiclo != ''){			
            return JSON.serialize(strResultValidacionCiclo,true);
        }else{
            responsejs r=new responsejs();
            list<OperacionComercial__c>ocLst=new list<OperacionComercial__c>();
    
            for(wrapper w:ocs){
                ocLst.add(w.oc);
            }    
            try{
                update ocLst;
                LibreriaUtilitaria_cls.GenerarExcepcionTest();
            }catch(exception e){
                r.error=e.getmessage();
            }
            return JSON.serialize(r);
        }
    }
    
    public class responsejs{
        public string error='';
        public sObject obj;
    }

    public class wrapper{
        public OperacionComercial__c oc;
        public boolean option;

        public wrapper(OperacionComercial__c oc,boolean option){
            this.oc=oc;
            this.option=option;
        }
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
    public static String obtenerCorrelationId(){
    	
    	Datetime dttFechaHoraActual	= System.now();
    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
    	
    	return strCorrelationId;
    }
}