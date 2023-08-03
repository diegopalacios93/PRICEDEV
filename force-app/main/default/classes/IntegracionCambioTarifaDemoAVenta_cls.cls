public class IntegracionCambioTarifaDemoAVenta_cls {
    
	public static void ProcesarSolicitud(List<OperacionComercial__c> scope){        
        list<LogTransacciones__c> LstlogsToInsert  = new list<LogTransacciones__c>();
        list<OperacionComercial__c> lstOCstoUpdate = new list<OperacionComercial__c>();
        Dom.Document docResponse; 
        String xmlRequest;
        Datetime datToday 		 = system.now();
        String correlationId;
        string parameterTypeName;
        string featureTypeName;
        string xmlResponse;
        String status;
        String errorCode;
        String errorMessage;
        String MensajeRespuesta;
        string NameLog;
        for(OperacionComercial__c objOc:scope){
            try{                
                if(objOc.TOPP__r.Tipoderegistro__c == 'Conversion_Demo_a_Venta' && objOc.FechaFacturacion__c == null &&
                   ((objOc.ValorTarifaPlan__c != null && objOc.ValorTarifaPlan__c != 0) ||
                    (objOc.Valor_Equipos__c != null && objOc.Valor_Equipos__c != 0) ||
                    (objOc.ValorObraCivil__c != null && objOc.ValorObraCivil__c != 0) ||
                    (objOc.Valorunicavez__c != null && objOc.Valorunicavez__c != 0) ||
                    (objOc.Valor_Recurrente_Aliado__c != null && objOc.Valor_Recurrente_Aliado__c != 0) ||
                    (objOc.DescuentoPorc__c != null && objOc.DescuentoPorc__c != 0))){
                    xmlRequest     	  = '';                    
                    correlationId  	  = objOc.Id + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year());                
                    parameterTypeName = '';
                    featureTypeName	  = '';
                    xmlResponse		  = '';
                    status 			  = '';
                    errorCode		  = '';
                    errorMessage	  = '';
                    MensajeRespuesta  = '';
                    NameLog 		  = 'Conversion Demo a Venta - Actualizacion valor recurrente';                        
                                 
                    list<PlanFacturacion__c> ListPlanes = [Select p.CampoDependiente__c,p.ValorDependiente__c,p.Name,p.Plan__c, p.PlanFacturacion__c, p.CatalogoProductosFacturacion__c,p.CatalogoProductosFacturacion__r.Name,p.CatalogoProductosFacturacion__r.ConnectionTypeID__c,p.CatalogoProductosFacturacion__r.ConnectionID__c,p.CatalogoProductosFacturacion__r.Servicio__c, (Select Name, PlanFacturacion__c,CatalogoProductosFacturacion__r.Name,CatalogoProductosFacturacion__r.Servicio__c,CatalogoProductosFacturacion__c,CampoDependiente__c,ValorDependiente__c From SubPlanesFacturacion__r), (Select Name, Objeto__c, Campo__c,Comillas__c,Obligatorio__c,Financiador__c From Parametros_de_Facturacion__r) From PlanFacturacion__c p where plan__c =: objOc.Plan__r.Id];                    
                    xmlRequest = ArmarCanonico(objOc, ListPlanes, CorrelationId, datToday);                    
                    system.debug('n\n IntegracionCambioTarifaDemoAVenta_cls Request '+xmlRequest);
		
                    if(xmlRequest != null){
                        xmlResponse = invokeTransferService(xmlRequest);
                        system.debug('n\n IntegracionCambioTarifaDemoAVenta_cls Response '+xmlResponse);
                        //Manejo de la respuesta         
                        docResponse = new Dom.Document();
                        docResponse.load(xmlResponse);
                        
                        Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
             			
                        if(serviceResponseNode.getName() !='Vacio')
                           status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();                       
                        
                        LogTransacciones__c logServicio = new LogTransacciones__c();                        
                        if (status == 'PASS'){
                            Dom.XMLNode BodyResponse = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'BodyResponse');
                            if(BodyResponse.getName() !='Vacio'){
                                Dom.XMLNode faults = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(BodyResponse,'faults');                                
                                if(faults != null){
                                	NameLog = 'No Exitoso Facturación - Actualizacion valor recurrente';   
                                    objOc.Estado__c = 'No Exitoso Facturacion';
                            		lstOCstoUpdate.add(objOc);  
                                }else{                                    
                                    objOc.FechaFacturacion__c = system.now();
                                    lstOCstoUpdate.add(objOc);  
                                }
                            }                        
                        }else{
                            NameLog = 'No Exitoso Facturación - Actualizacion valor recurrente';
                            objOc.Estado__c = 'No Exitoso Facturacion';
                            lstOCstoUpdate.add(objOc);                 
                        }
                        //Insertar log de envio de facturación                        
                        logServicio.AC_CorrelationID_Random__c = correlationId;
                        logServicio.LTE_Operacion_Comercial__c = objOc.Id;
                        logServicio.Informacion_Enviada__c = String.valueOf(xmlRequest);
                        logServicio.Name = NameLog;
                        logServicio.Informacion_Recibida__c = String.valueOf(xmlResponse);
                        LstlogsToInsert.add(logServicio);
                    }                                
                }            
            }catch(Exception e){
                //Insertar log de envió de facturación erróneo                                
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = objOc.Id;
                logServicio.LTE_Operacion_Comercial__c = objOc.Id;
                logServicio.Error_Apex__c = ('Message: ' +  e.getMessage() + ', StackTraceString: ' +  e.getStackTraceString() + ', TypeName:' + e.getTypeName());
                logServicio.Name = 'No Exitoso Facturación - Actualizacion valor recurrente';
                logServicio.Informacion_Enviada__c = String.valueOf(xmlRequest);                
                logServicio.Informacion_Recibida__c = String.valueOf(xmlResponse);
                LstlogsToInsert.add(logServicio);
            } 
            if(!Test.isRunningTest()){
                if(LstlogsToInsert.size() > 0)
                    insert LstlogsToInsert;
                if(lstOCstoUpdate.size() > 0)
                    update lstOCstoUpdate; 
           	}
        }
    }
    public static string invokeTransferService(String strRequest){                 
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
        System.debug('\n\n Request Actualización tarifa servicio -----------> ' + strRequest);
        //Consume el servicio y almacena el response.
        String strResponse;
        if(!Test.isRunningTest())
        	strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);        	
        else            
            strResponse ='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:InvokeServiceProvisioningOutput xmlns:ns0="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp"><ns2:WSResponseHeader2 xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp" xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns2:System><ns2:name>Tibco</ns2:name><ns2:correlationID>a09m0000005b0U4AAI932021</ns2:correlationID><ns2:processingServer>Tibco</ns2:processingServer></ns2:System><ns2:Service><ns2:status>PASS</ns2:status><ns2:responseDate>2021-03-09T00:29:30.115-05:00</ns2:responseDate></ns2:Service></ns2:WSResponseHeader2><ns0:BodyResponse><ns1:response xmlns:ns1="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/RVCResponse" system="RevChain" operation="P" result="S"/></ns0:BodyResponse></ns0:InvokeServiceProvisioningOutput></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        return strResponse;
	}
    
    public static string ArmarCanonico( OperacionComercial__c objOc, list<PlanFacturacion__c> PlanFac, string CorrelationId, Datetime datToday){        
        String xmlFeature = null; 
        Boolean FeatureExists = false;
        String xml = '<?xml version="1.0" encoding="UTF-8"?>'
                       +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inv="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp" xmlns:ser="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/ServiceProvisioning" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0">'
                       +'    <soapenv:Header />'
                       +'    <soapenv:Body>'
                       +'       <inv:InvokeServiceProvisioningInput>'
                       +'          <v1:WSRequestHeader2>'
                       +'             <v1:System>'
                       +'                <v1:name>Salesforce</v1:name>'
                       +'                <v1:correlationID>'+CorrelationId+'</v1:correlationID>'
                       +'                <v1:processingServer>Tibco</v1:processingServer>'
                       +'             </v1:System>'
                       +'          </v1:WSRequestHeader2>'
                       +'          <inv:BodyRequest>'
                       +'             <ser:services>'
                       +'                <ser:service_particulars>'
                       +'                   <ser:subscriber_id>'+ObjOc.Activo__r.CuentaFacturacion__r.name+'</ser:subscriber_id>'
                       +'                   <ser:service>'
                       +'                      <ser:finder>'
                       +'                         <ser:external_service_id>'+objOc.Activo__r.name+'</ser:external_service_id>'
                       +'                         <ser:active_date>'
                       +'                            <ser:month>'+String.valueOf(datToday.month())+'</ser:month>'
                       +'                            <ser:day>'+String.valueOf(datToday.day())+'</ser:day>'
                       +'                            <ser:year>'+String.valueOf(datToday.year())+'</ser:year>'
                       +'                         </ser:active_date>'
                       +'                      </ser:finder>';    
        
        for(PlanFacturacion__c planfactu : PlanFac){
            xmlFeature = generarFeaturesPlan(objOc,planfactu,datToday);
            if(xmlFeature != null){
            	xml += xmlFeature;
                FeatureExists = true;
            }
            //procesar sub planes de facturación
            for(SubPlanFacturacion__c subplan :planfactu.SubPlanesFacturacion__r)
            {
                list<ParametroFacturacion__c> listParSubPlan = ObtenerParametrosSubPlanes(subplan.Id);                
                xmlFeature = generarFeaturesSubPlan(objOc,subplan,datToday,listParSubPlan);
                if(xmlFeature != null){
                    xml += xmlFeature; 
                    FeatureExists = true;
                }
            }
        }
        if(FeatureExists){            
            xml +=  '</ser:service>'
                +'                </ser:service_particulars>'
                +'             </ser:services>'
                +'          </inv:BodyRequest>'
                +'       </inv:InvokeServiceProvisioningInput>'
                +'    </soapenv:Body>'
                +' </soapenv:Envelope>';
        }else
           xml = null;
                
        return xml;
    }
    
    public static string generarFeaturesPlan(OperacionComercial__c objOc, PlanFacturacion__c PlanFac, Datetime datToday){        
        Boolean paramExists = false;
        string xmlParamDraft = null;
        string xml = '<ser:feature>'
                   + '<ser:feature_type_name>'+planFac.CatalogoProductosFacturacion__r.Name+'</ser:feature_type_name>';        		   
        			for(ParametroFacturacion__c parametro : planFac.Parametros_de_Facturacion__r){
                       if(parametro.Campo__c == 'ValorTarifaPlan__c' || parametro.Campo__c == 'Valor_Equipos__c' || 
                          parametro.Campo__c == 'ValorObraCivil__c' || parametro.Campo__c == 'Valorunicavez__c' || 
                          parametro.Campo__c == 'Valor_Recurrente_Aliado__c' || parametro.Campo__c == 'DescuentoPorc__c'){                       		  
                              xmlParamDraft = parametro(parametro,objOc,datToday);
                              if(xmlParamDraft != null){
                                paramExists = true;  
                              	xml += xmlParamDraft;
                              }
                         }
                    }
        	   xml += '</ser:feature>';
        if(paramExists)            
        	return xml;
        else
            return null;
    }
    
    public static string generarFeaturesSubPlan(OperacionComercial__c objOc, SubPlanFacturacion__c SubPlanFac, Datetime datToday, list<ParametroFacturacion__c> listParSubPlan){
        Boolean paramExists = false;
        string xmlParamDraft = null;
        string xml = '<ser:feature>'
                   + '<ser:feature_type_name>'+SubPlanFac.CatalogoProductosFacturacion__r.Name+'</ser:feature_type_name>';        		   
        			for(ParametroFacturacion__c parametro : listParSubPlan){                       
                       if(parametro.SubPlanFacturacion__r.CampoDependiente__c != 'ValorEquipos2__c' && (parametro.Campo__c == 'ValorTarifaPlan__c' || parametro.Campo__c == 'Valor_Equipos__c' || 
                          parametro.Campo__c == 'ValorObraCivil__c' || parametro.Campo__c == 'Valorunicavez__c' || 
                          parametro.Campo__c == 'Valor_Recurrente_Aliado__c' || parametro.Campo__c == 'DescuentoPorc__c')){
                              xmlParamDraft = parametro(parametro,objOc,datToday);
                              if(xmlParamDraft != null){
                                paramExists = true;  
                              	xml += xmlParamDraft;
                              }
                         }
                    }
        	   xml += '</ser:feature>';
                    
        if(paramExists)            
        	return xml;
        else
            return null;
    }
    
    public static String parametro(ParametroFacturacion__c param,OperacionComercial__c OC, Datetime datToday){
    	string parametro = null;        
        string valor = LibreriaUtilitaria_cls.recorreCampos(OC,Param.Campo__c);
        if(valor!=null && integer.valueof(valor) > 0){
            parametro ='<ser:parameter action="modify">'
                	  +'<ser:parameter_type_name>'+param.Name+'</ser:parameter_type_name>'
                      +'<ser:parameter_value>'+valor+'</ser:parameter_value>'
            		  +'<ser:start_date>'
                      +'<ser:month>'+String.valueOf(datToday.month())+'</ser:month>'
                      +'<ser:day>'+String.valueOf(datToday.day())+'</ser:day>'
                      +'<ser:year>'+String.valueOf(datToday.year())+'</ser:year>'
                      +'</ser:start_date>'
                      +'</ser:parameter>';
        }
        return parametro;
    }
    public static list<ParametroFacturacion__c> ObtenerParametrosSubPlanes(string idsub)
    {
        list<ParametroFacturacion__c> listPar = new list<ParametroFacturacion__c>();
        listPar = [Select p.SubPlanFacturacion__r.CampoDependiente__c, p.SubPlanFacturacion__c,p.CatalogoProductosFacturacion__c,p.CatalogoProductosFacturacion__r.Name,p.CatalogoProductosFacturacion__r.Servicio__c, p.Objeto__c, p.Name, p.Campo__c,p.Comillas__c,p.Obligatorio__c,p.Financiador__c From ParametroFacturacion__c p where p.SubPlanFacturacion__c =: idsub];        
        return listPar;
    }
}