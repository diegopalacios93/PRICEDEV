public class IntegracionTramitesCuentasFact_cls {
	
	public static void integrarRevchainPreferenciasFacturacion(String idTramite) {        
        Tramite_cuenta_de_facturacion__c objTramite;
        List<Tramite_cuenta_de_facturacion__c> lstTramite = new List<Tramite_cuenta_de_facturacion__c>(getData(idTramite));        
        if(lstTramite.size() > 0)
        	objTramite = lstTramite[0];
        
        if(idTramite != null && objTramite != null){
            system.debug('===> Update Preferencias Cta Fact: Id trámite: '+idTramite);            
            string strRequest  			= '';
            string strResponse 			= '';
            string strEstadoIntegracion = '';            
            tibcoXml_cls tXml 			= new tibcoXml_cls();            
            ServiciosWeb__c sw 			= ServiciosWeb__c.getValues('SetPreferenciasFactura');
            strRequest 					= crearXMLSetInvoiceParameters(objTramite);
            system.debug('===> Update Preferencias Cta Fact: Request WS: '+strRequest);
            
            if(!Test.isRunningTest())
                strResponse=LibreriaUtilitariaJobs_cls.consultarServicio(strRequest,sw.Action__c,sw.EndPoint__c);
            else
                strResponse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:SetInvoiceParametersOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/SetInvoiceParametersOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>SETINVPAR-001</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2021-01-13T14:42:02.602-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:SetInvoiceParametersOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/SetInvoiceParametersOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/SetInvoiceParametersMsg"><ns2:SetInvoiceParametersResponse><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>Facturacion Corporativa 1.1</ns2:System><ns2:FactCorp><ns2:ErrorResult>0</ns2:ErrorResult><ns2:ErrorDescription>OK</ns2:ErrorDescription></ns2:FactCorp></ns2:SetInvoiceParametersResponse></ns2:SetInvoiceParametersOutput></ns0:SetInvoiceParametersOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';                      
            system.debug('===> Update Preferencias Cta Fact: Response WS: '+strResponse);
            
            //descomponer respuesta del WS:
            tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
            map<string,string> values  = new map<string,string>();
            values = proReq.getMap(strResponse);
            if(values.get('ErrorResult') == '0'){
            	strEstadoIntegracion = 'Facturado';
                sincronizarRtaIntegCuentaFact(objTramite);
            }else
                strEstadoIntegracion = 'No Exitoso Facturacion';
            actualizarTramite(objTramite,strEstadoIntegracion);
            generarLogIntegracion(objTramite.Cuenta_de_Facturacion__r.Id,'Intregración - '+objTramite.Tramite__c+' - ' + objTramite.Cuenta_de_Facturacion__r.Name,strRequest,strResponse,strEstadoIntegracion,values.get('ErrorDescription'),idTramite,'');
        }
    }
    
    public static void integrarRevchainConsultaPlanImpuestos(Map<string,string> MapDatosActivo) {        
        system.debug('Integracion Consulta plan de impuestos, Map: '+MapDatosActivo);
        String IdServicioTramite 	= MapDatosActivo.get('IdServicioTramite');
        String ExternalServiceId	= MapDatosActivo.get('ExternalServiceId');
        String IdActivo				= MapDatosActivo.get('IdActivo');
        String CuentaFacturacion	= MapDatosActivo.get('CuentaFacturacion');
        String IdTramite			= MapDatosActivo.get('IdTramite');
        
        if(IdServicioTramite != null && ExternalServiceId != null && CuentaFacturacion != null && IdActivo != ''){
            system.debug('===> Consulta plan de impuestos: External Service Id: '+ExternalServiceId);
            string strRequest  			= '';
            string strResponse 			= '';
            string strEstadoIntegracion = '';            
            tibcoXml_cls tXml 			= new tibcoXml_cls();            
            ServiciosWeb__c sw 			= ServiciosWeb__c.getValues('ConsultaPlanImpuestos');
            strRequest 					= crearXMLGetPlanImpuestos(IdServicioTramite,ExternalServiceId,CuentaFacturacion);
            system.debug('===> Consulta plan de impuestos: Request WS: '+strRequest);
            
            if(!Test.isRunningTest())
                strResponse=LibreriaUtilitariaJobs_cls.consultarServicio(strRequest,sw.Action__c,sw.EndPoint__c);
            else
                strResponse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:GetTaxPlanOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetTaxPlanOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>MDM</ns1:name><ns1:correlationID>GETTAXPLA-001</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2021-01-21T16:31:11.655-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:GetTaxPlanOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetTaxPlanOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/GetTaxPlanMsg"><ns2:GetTaxPlanResponse><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>Facturacion Corporativa 1.3</ns2:System><ns2:factcorp_data><ns2:factcorp_data><ns2:TaxPlans><ns2:ExternalServiceId>AC-528934</ns2:ExternalServiceId><ns2:Feat_id>108066018</ns2:Feat_id><ns2:Feat_nm>Cargo Fijo Conectividad Nal</ns2:Feat_nm><ns2:Tax_nm>(986) -IMPUESTO VALOR AGREGADO ETB</ns2:Tax_nm></ns2:TaxPlans></ns2:factcorp_data><ns2:Result>0</ns2:Result><ns2:DescError>OK</ns2:DescError></ns2:factcorp_data></ns2:GetTaxPlanResponse></ns2:GetTaxPlanOutput></ns0:GetTaxPlanOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
           	
            system.debug('===> Consulta plan de impuestos: Response WS: '+strResponse);
            //descomponer respuesta del WS:                        
            map<string,string> values  = new map<string,string>();
            values = obtenerCodigoRtaIntegracion(strResponse);            
            
            if(values.get('Result') == '0'){                
                List<Plan_de_impuestos_servicio__c> listPlanImpuestoServ = new List<Plan_de_impuestos_servicio__c>(procesarRtaPlanDeImpuestos(strResponse,IdServicioTramite));
                if(listPlanImpuestoServ.size() > 0){
                    strEstadoIntegracion = 'Plan de impuestos consultado';                    
                    insert listPlanImpuestoServ;
                }else
                    strEstadoIntegracion = 'Plan de impuestos no encontrado';
            }else{
                if(values.get('Result') == 'E' && values.get('DescError') == 'No se encontraron datos')
                    strEstadoIntegracion = 'Servicio no existe en el facturador';
                else
                	strEstadoIntegracion = 'Error en consulta de plan de impuestos';
            }                
         	actualizarServicioTramite(IdServicioTramite,strEstadoIntegracion);            
            validarIntegracionTotalPlanImpuestos(IdServicioTramite, IdTramite);
            generarLogIntegracion('','Intregración - Consulta plan impuestos Servicio - '+ExternalServiceId,strRequest,strResponse,strEstadoIntegracion,values.get('DescError'),'',IdServicioTramite);
        }
    }
	
    public static void integrarRevchainConsolidarConceptosFact(String idTramite){
        Tramite_cuenta_de_facturacion__c objTramite;
        List<Tramite_cuenta_de_facturacion__c> lstTramite = new List<Tramite_cuenta_de_facturacion__c>(getData(idTramite));        
        if(lstTramite.size() > 0)
        	objTramite = lstTramite[0];
        
        if(idTramite != null && objTramite != null){
            system.debug('===> Consolidar conceptos de facturación: Id trámite: '+idTramite);            
            List<Servicio_del_tramite_cuenta_fact__c> lstServiciosTramite = new List<Servicio_del_tramite_cuenta_fact__c>(objTramite.Servicios_del_tramite_cuenta_Fact__r);
            string strRequest  			= '';
            string strResponse 			= '';
            string strEstadoIntegracion = '';            
            tibcoXml_cls tXml 			= new tibcoXml_cls(); 
            ServiciosWeb__c sw 			= ServiciosWeb__c.getValues('ConsolidarConceptosFacturacion');
            if(lstServiciosTramite.size() > 0){
            	strRequest 				= crearXMLSetAgrupacionPlanImpuestos(objTramite,lstServiciosTramite);
                system.debug('===> Consolidar conceptos de facturación: Request WS: '+strRequest);
                if(!Test.isRunningTest())                	
                    strResponse=LibreriaUtilitariaJobs_cls.consultarServicio(strRequest,sw.Action__c,sw.EndPoint__c);
                else
                    strResponse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:SetTaxPlanGroupingOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/SetTaxPlanGroupingOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>SETTAXPLAGRU-001</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2021-01-21T17:17:40.054-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:SetTaxPlanGroupingOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/SetTaxPlanGroupingOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/SetTaxPlanGroupingMsg"><ns2:SetTaxPlanGroupingResponse><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:Factcorp_data><ns2:Result>0</ns2:Result><ns2:DescError>OK</ns2:DescError></ns2:Factcorp_data></ns2:SetTaxPlanGroupingResponse></ns2:SetTaxPlanGroupingOutput></ns0:SetTaxPlanGroupingOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';                
                system.debug('===> Consolidar conceptos de facturación: Response WS: '+strResponse);
                //descomponer respuesta del WS:
                tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
                map<string,string> values  = new map<string,string>();
                values = proReq.getMap(strResponse);
                if(values.get('Result') == '0')
               		strEstadoIntegracion = 'Facturado';                	
                else
                    strEstadoIntegracion = 'No Exitoso Facturacion';
                actualizarTramite(objTramite,strEstadoIntegracion);
                actualizarServiciosDelTramite(lstServiciosTramite,strEstadoIntegracion);
                generarLogIntegracion(objTramite.Cuenta_de_Facturacion__r.Id,'Intregración - '+objTramite.Tramite__c+' - ' + objTramite.Cuenta_de_Facturacion__r.Name,strRequest,strResponse,strEstadoIntegracion,values.get('DescError'),idTramite,'');                
            }
        }
    } 
    private static List<Tramite_cuenta_de_facturacion__c> getData(Id idCuentaFact){        
        List<Tramite_cuenta_de_facturacion__c> lstTramites = new List<Tramite_cuenta_de_facturacion__c>();        
        lstTramites	   = [Select Name, Visualizar_el_saldo_anterior__c, Adjuntar_RUT_y_parafiscales__c, Presentar_PILA__c, Factura_solo_portada__c,
                         		 Presentar_el_ajuste_a_la_decena__c, Presentar_doble_cupon__c, Tramite__c, Estado__c, Nombre_del_concepto_a_consolidar__c,
                         		 Estado_aprobacion_solicitud__c, Cuenta_de_Facturacion__r.Id,Cuenta_de_Facturacion__r.Name,
                         		 (SELECT LastActor.Name, createdBy.Name FROM ProcessInstances order by createdDate desc limit 1),
                          		 (SELECT Name, Activo__r.Name, Estado__c FROM Servicios_del_tramite_cuenta_Fact__r)
            			 From Tramite_cuenta_de_facturacion__c
                         Where Id=: idCuentaFact];           
            
        return lstTramites;
    }
    private static void sincronizarRtaIntegCuentaFact(Tramite_cuenta_de_facturacion__c objTramite){
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c(Id=objTramite.Cuenta_de_Facturacion__r.Id);
        
        objCtaFact.Visualizar_el_saldo_anterior__c 			= objTramite.Visualizar_el_saldo_anterior__c;
        objCtaFact.Adjuntar_RUT_y_parafiscales__c  			= objTramite.Adjuntar_RUT_y_parafiscales__c;
        objCtaFact.Presentar_PILA__c						= objTramite.Presentar_PILA__c;
        objCtaFact.Factura_solo_portada__c					= objTramite.Factura_solo_portada__c;
        objCtaFact.Presentar_el_ajuste_a_la_decena__c		= objTramite.Presentar_el_ajuste_a_la_decena__c;
        objCtaFact.Presentar_doble_cupon__c					= objTramite.Presentar_doble_cupon__c;
        
        update objCtaFact;
    }
    private static void actualizarTramite(Tramite_cuenta_de_facturacion__c objTramite, string estadoTramite){
        
        objTramite.Estado__c			= estadoTramite;
        objTramite.Fecha_integracion__c = DateTime.now();
        update objTramite;
    } 
    
    private static void actualizarServiciosDelTramite(List<Servicio_del_tramite_cuenta_fact__c> ListServiciosTramites, string estadoTramite){
        for(Servicio_del_tramite_cuenta_fact__c ObjServicioTramite : ListServiciosTramites)
            ObjServicioTramite.Estado__c = estadoTramite;
        update ListServiciosTramites;
    }
    
    private static void actualizarServicioTramite(Id IdServicioTramite, string estadoIntegracion){
        Servicio_del_tramite_cuenta_fact__c objServicioTramite = new Servicio_del_tramite_cuenta_fact__c(Id=IdServicioTramite);         
        objServicioTramite.Estado__c 			= estadoIntegracion;  
        objServicioTramite.Fecha_integracion__c = DateTime.now();                
        update objServicioTramite;                
    }    
    
    private static void generarLogIntegracion(string idCtaFact, string strNombreIntegracion, string strRequest, string strResponse, string strEstadoIntegracion, string strCodigoRespuesta, string idTramite, string idServicioTramite){
        
        LogTransacciones__c objLog 				= new LogTransacciones__c();		
		objLog.Estado__c 						= strEstadoIntegracion;
		objLog.Informacion_Enviada__c 			= strRequest;
		objLog.Informacion_Recibida__c 			= strResponse;        
		objLog.Name 							= strNombreIntegracion;
        if(strCodigoRespuesta != null)
			objLog.CodigoRespuesta__c 			= strCodigoRespuesta.abbreviate(250);
        if(idCtaFact != '')
			objLog.LTE_CuentaFacturacionLTE__c		= idCtaFact;
        if(idTramite != '')
        	objLog.Tramite_cuenta_de_facturacion__c = idTramite;
        if(idServicioTramite != '')   
           objLog.Servicio_tramite_cuenta_Fact__c	= idServicioTramite;
		insert objLog;
    }
    
    private static void  validarIntegracionTotalPlanImpuestos(string IdServicioTramite, String IdTramite){        
        List<Servicio_del_tramite_cuenta_fact__c> ListTramiteServicio = new List<Servicio_del_tramite_cuenta_fact__c>();        
        Integer totalServicios 			 	= 0;
        Integer totalServiciosIntegrados 	= 0;
        Integer ServiciosIntegOk	 	  	= 0;
        Integer ServiciosIntegSinPlanImp 	= 0;
        Integer ServiciosIntegError 	  	= 0;
        Integer ServiciosNoEncontrados   	= 0;
        ListTramiteServicio = [Select Estado__c, Tramite_cuenta_de_facturacion__r.Id From Servicio_del_tramite_cuenta_fact__c Where Tramite_cuenta_de_facturacion__r.id =: IdTramite];
        
        for(Servicio_del_tramite_cuenta_fact__c objTramiteServicio : ListTramiteServicio){            
            totalServicios++;
            if(objTramiteServicio.Estado__c == 'Plan de impuestos consultado')
                ServiciosIntegOk++;
            if(objTramiteServicio.Estado__c == 'Plan de impuestos no encontrado')
                ServiciosIntegSinPlanImp++;
            if(objTramiteServicio.Estado__c == 'Error en consulta de plan de impuestos')
                ServiciosIntegError++;
            if(objTramiteServicio.Estado__c == 'Servicio no existe en el facturador')
                ServiciosNoEncontrados++;
        }        
        totalServiciosIntegrados = ServiciosIntegOk + ServiciosIntegSinPlanImp + ServiciosIntegError + ServiciosNoEncontrados;         
        
        if(totalServicios == totalServiciosIntegrados){               
            Tramite_cuenta_de_facturacion__c objTramite = new Tramite_cuenta_de_facturacion__c(Id=IdTramite);
            if(totalServicios == ServiciosIntegOk){                                
                List<string> ListMuestraPlanImp = new List<string>();
                Boolean planImpEncontrado, muestraGenerada=false;
                String strResultValidacion;
                Integer cantPlanImpPorTramiteServ = 0;
                List<Plan_de_impuestos_servicio__c> ListPlanImpuestosServ = new List<Plan_de_impuestos_servicio__c>();
                ListPlanImpuestosServ = [Select Name, Feat_Id__c, Feat_nm__c, Tax_nm__c, Servicio_del_tramite_cuenta_Fact__r.Name, Servicio_del_tramite_cuenta_Fact__r.Id
                                         From Plan_de_impuestos_servicio__c 
                                         Where Servicio_del_tramite_cuenta_Fact__r.Tramite_cuenta_de_facturacion__r.Id =: IdTramite];
                
                for(Servicio_del_tramite_cuenta_fact__c objTramiteServicio : ListTramiteServicio){                     
                    if(strResultValidacion == null){
                        if(!muestraGenerada){
							muestraGenerada = true;                                                        
                            for(Plan_de_impuestos_servicio__c objPlanImpuestos : ListPlanImpuestosServ){                           
                                if(objTramiteServicio.Id == objPlanImpuestos.Servicio_del_tramite_cuenta_Fact__r.Id)                                
                                    ListMuestraPlanImp.add(objPlanImpuestos.Tax_nm__c);
                            }                            
                        }else{                            
                            //comparar plan de impuestos de la muestra con el plan de impuestos de los servicios del trámite                    	
                            cantPlanImpPorTramiteServ = 0;                            
                            for(Plan_de_impuestos_servicio__c objPlanImpuestos : ListPlanImpuestosServ){                                
                                planImpEncontrado = false;
                                if(objTramiteServicio.Id == objPlanImpuestos.Servicio_del_tramite_cuenta_Fact__r.Id){
                                    cantPlanImpPorTramiteServ ++;                                    
                                    for(string planImpuesto : ListMuestraPlanImp){
                                        if(planImpuesto == objPlanImpuestos.Tax_nm__c)                                            
                                            planImpEncontrado = true; 
                                    }
                                    if(!planImpEncontrado)
                                       strResultValidacion = 'No compatible';
                                }                                
                            }
                            // validar si la cantidad de planes de impuesto por servicio corresponde con la cantidad de la muestra                            
                            if(cantPlanImpPorTramiteServ != ListMuestraPlanImp.size() || cantPlanImpPorTramiteServ == 0 || ListMuestraPlanImp.isEmpty())
                                strResultValidacion = 'No compatible';
                        } 
                    }                                       
                }                          
                if(strResultValidacion == null && !ListMuestraPlanImp.isEmpty())
                    objTramite.Validacion_plan_de_impuestos__c = 'Plan de impuesto de los servicios compatible';                
                else
                    objTramite.Validacion_plan_de_impuestos__c = 'Plan de impuesto de los servicios no compatible';                                     
                
            }else if(totalServicios == ServiciosIntegError)
                objTramite.Validacion_plan_de_impuestos__c = 'Error en consulta de plan de impuestos';
            else if(totalServicios == ServiciosNoEncontrados)
                objTramite.Validacion_plan_de_impuestos__c = 'Servicios no existentes en el facturador';
            else if(totalServicios == ServiciosIntegSinPlanImp)
                objTramite.Validacion_plan_de_impuestos__c = 'Servicios sin plan de impuestos en el facturador';
            else
            	objTramite.Validacion_plan_de_impuestos__c = 'Plan de impuesto de los servicios no compatible';
            update objTramite;
        }
    }
    private static map<string,string> obtenerCodigoRtaIntegracion(string strResponse){
        map<string,string> mapRta = new map<string,string>();
        Dom.Document doc = new Dom.Document();
        doc.load(strResponse);
        DOM.XmlNode rootNode = doc.getRootElement();
        list<DOM.xmlNode> lst = rootNode.getChildElements();
        for(DOM.XmlNode re : lst) {            
            if(re.getName() == 'Body') {
                for(DOM.XmlNode re1 : re.getChildElements()) {                    
                    if(re1.getName() == 'GetTaxPlanOUT') {
                        for(DOM.XmlNode re2 : re1.getChildElements()) {
                            if(re2.getName() == 'GetTaxPlanOutput') {
                                for(DOM.XmlNode re3 : re2.getChildElements()) {
                                    if(re3.getName() == 'GetTaxPlanResponse') {                                        
                                        for(DOM.XmlNode re4 : re3.getChildElements()) {
                                            if(re4.getName() == 'factcorp_data') {
                                                for(DOM.XmlNode re5 : re4.getChildElements()) {
                                                    if(re5.getName() == 'Result')
                                                        mapRta.put('Result',re5.getText());
                                                    if(re5.getName() == 'DescError')
                                                        mapRta.put('DescError',re5.getText());
                                                }
                                            }
                                        }                                        
                                    }
                                }                                
                            }
                        }
                    }              
                }
            }
        }        
        return mapRta;
    }
    private static List<Plan_de_impuestos_servicio__c> procesarRtaPlanDeImpuestos(string strResponse, string IdServicioTramite){
        Dom.Document doc = new Dom.Document();
        doc.load(strResponse);
        DOM.XmlNode rootNode = doc.getRootElement();
        string Feat_id, Feat_nm, Tax_nm;        
        Integer cantItem;
        List<Plan_de_impuestos_servicio__c> listPlanImpuestoServ = new List<Plan_de_impuestos_servicio__c>();
        list<DOM.xmlNode> lst = rootNode.getChildElements();
		for(DOM.XmlNode re : lst) {            
            if(re.getName() == 'Body') {
                for(DOM.XmlNode re1 : re.getChildElements()) {                    
                    if(re1.getName() == 'GetTaxPlanOUT') {
                        for(DOM.XmlNode re2 : re1.getChildElements()) {
                            if(re2.getName() == 'GetTaxPlanOutput') {
                                for(DOM.XmlNode re3 : re2.getChildElements()) {
                                    if(re3.getName() == 'GetTaxPlanResponse') {                                        
                                        for(DOM.XmlNode re4 : re3.getChildElements()) {
                                            if(re4.getName() == 'factcorp_data') {
                                                for(DOM.XmlNode re5 : re4.getChildElements()) {
                                                    if(re5.getName() == 'factcorp_data') {
                                                        for(DOM.XmlNode re6 : re5.getChildElements()) {
                                                            Feat_id   = '';
                                                            Feat_nm   = '';
                                                            Tax_nm    = '';  
                                                            cantItem  = 0;
                                                            for(DOM.XmlNode re7 : re6.getChildElements()) {
                                                                cantItem++;
                                                             	if(re7.getName() == 'Feat_id') 
                                                                	Feat_id = re7.getText();
                                                                if(re7.getName() == 'Feat_nm') 
                                                                	Feat_nm = re7.getText();
                                                                if(re7.getName() == 'Tax_nm') 
                                                                	Tax_nm = re7.getText();
                                                                
                                                                if(cantItem > 3){
                                                                	Plan_de_impuestos_servicio__c objPlanImpServ = new Plan_de_impuestos_servicio__c();
                                                                    objPlanImpServ.Feat_Id__c = Feat_id;
                                                                    objPlanImpServ.Feat_nm__c = Feat_nm;
                                                                    objPlanImpServ.Tax_nm__c  = Tax_nm;
                                                                    objPlanImpServ.Servicio_del_tramite_cuenta_Fact__c = IdServicioTramite;
                                                                    listPlanImpuestoServ.add(objPlanImpServ);
                                                                }    
                                                            }       
                                                        }                                                        
                                                    }                                                    
                                                }                                                
                                            }
                                        }                                        
                                    }
                                }                                
                            }
                        }
                    }              
                }
            }
        }
        return listPlanImpuestoServ;
    }    
    private static string crearXMLSetInvoiceParameters(Tramite_cuenta_de_facturacion__c objTramite){
        string userSolicitudCambio, userAprobadorCambio;        
        for(ProcessInstance auxProcessInst : objTramite.ProcessInstances){
            userAprobadorCambio  = auxProcessInst.LastActor.Name;
            userSolicitudCambio  = auxProcessInst.createdBy.Name;
        }              
		
        Datetime datToday = system.now();
        string strXml  = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:set="http://www.etb.com.co/LTE/WS/BillingCorporate/SetInvoiceParametersOp" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0" xmlns:set1="http://www.etb.com.co/LTE/WS/BillingCorporate/SetInvoiceParametersMsg">'
                       +   '<soapenv:Header/>'
                       +   '<soapenv:Body>'
                       +      '<set:SetInvoiceParametersIN>'
                       +         '<v1:WSRequestHeader2>'
                       +            '<v1:System>'
                       +               '<v1:name>Salesforce</v1:name>'
                       +               '<v1:correlationID>'+objTramite.Id + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) +'</v1:correlationID>'
                       +               '<v1:processingServer>Tibco</v1:processingServer>'
                       +            '</v1:System>'
                       +            '<v1:Property>'
                       +               '<v1:name></v1:name>'
                       +               '<v1:value></v1:value>'
                       +            '</v1:Property>'
                       +         '</v1:WSRequestHeader2>'
                       +         '<set1:SetInvoiceParametersInput>'
                       +            '<set1:SetInvoiceParametersRequest>'
                       +               '<set1:FactCorp_Data>'
            		   +                  '<set1:OrderNumber>'+objTramite.Name+'</set1:OrderNumber>'
                       +                  '<set1:Account>'+objTramite.Cuenta_de_Facturacion__r.Name+'</set1:Account>'
                       +                  '<set1:Balance>'+(objTramite.Visualizar_el_saldo_anterior__c==true?'S':'N')+'</set1:Balance>'
                       +                  '<set1:Adjustment>'+(objTramite.Presentar_el_ajuste_a_la_decena__c==true?'S':'N')+'</set1:Adjustment>'
                       +                  '<set1:Rut>'+(objTramite.Adjuntar_RUT_y_parafiscales__c==true?'S':'N')+'</set1:Rut>'
                       +                  '<set1:DoubleCoupon>'+(objTramite.Presentar_doble_cupon__c==true?'S':'N')+'</set1:DoubleCoupon>'
                       +                  '<set1:Pila>'+(objTramite.Presentar_PILA__c==true?'S':'N')+'</set1:Pila>'                                   		   
            		   +				  '<set1:Detailed>'+(objTramite.Factura_solo_portada__c==true?'S':'N')+'</set1:Detailed>'
                       +                  '<set1:User>'+userSolicitudCambio+'</set1:User>'
                       +                  '<set1:Approver>'+userAprobadorCambio+'</set1:Approver>'
                       +               '</set1:FactCorp_Data>'
                       +            '</set1:SetInvoiceParametersRequest>'
                       +         '</set1:SetInvoiceParametersInput>'
                       +      '</set:SetInvoiceParametersIN>'
                       +     '</soapenv:Body>'
                       +   '</soapenv:Envelope>';
        return strXml;
    }
    
    private static string crearXMLGetPlanImpuestos(Id IdServicioTramite, String ExternalServiceId, String CuentaFacturacion){
       
        Datetime datToday = system.now();
        string strXml  = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://www.etb.com.co/LTE/WS/BillingCorporate/GetTaxPlanOp" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0" xmlns:get1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetTaxPlanMsg">'
           			   +	'<soapenv:Header/>'
                       +        '<soapenv:Body>'
                       +           '<get:GetTaxPlanIN>'
                       +              '<v1:WSRequestHeader2>'
                       +                 '<v1:System>'
                       +                    '<v1:name>Salesforce</v1:name>'
                       +                    '<v1:correlationID>'+IdServicioTramite + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) +'</v1:correlationID>'
                       +                    '<v1:processingServer>Tibco</v1:processingServer>'
                       +                 '</v1:System>'                                        
                       +                 '<v1:Property>'
                       +                    '<v1:name></v1:name>'
                       +                    '<v1:value></v1:value>'
                       +                 '</v1:Property>'
                       +              '</v1:WSRequestHeader2>'
                       +              '<get1:GetTaxPlanInput>'
                       +                 '<get1:GetTaxPlanRequest>'
                       +                    '<get1:FactCorp_Data>'
                       +                       '<get1:Account>'+CuentaFacturacion+'</get1:Account>'                                              
                       +                       '<get1:ExternalServiceId>'+ExternalServiceId+'</get1:ExternalServiceId>'
                       +                    '</get1:FactCorp_Data>'
                       +                 '</get1:GetTaxPlanRequest>'
                       +              '</get1:GetTaxPlanInput>'
                       +           '</get:GetTaxPlanIN>'
                       +        '</soapenv:Body>'
                       +     '</soapenv:Envelope>';
        return strXml;
    } 
    
    private static string crearXMLSetAgrupacionPlanImpuestos(Tramite_cuenta_de_facturacion__c objTramite, List<Servicio_del_tramite_cuenta_fact__c> lstServiciosTramite){
        Datetime datToday = system.now();        
        string userSolicitudCambio, userAprobadorCambio;        
        for(ProcessInstance auxProcessInst : objTramite.ProcessInstances){
            userAprobadorCambio  = auxProcessInst.LastActor.Name;
            userSolicitudCambio  = auxProcessInst.createdBy.Name;
        }                 
        string strXml =	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:set="http://www.etb.com.co/LTE/WS/BillingCorporate/SetTaxPlanGroupingOp" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0" xmlns:set1="http://www.etb.com.co/LTE/WS/BillingCorporate/SetTaxPlanGroupingMsg">'
                      +     '<soapenv:Header/>'
                      +     '<soapenv:Body>'
                      +        '<set:SetTaxPlanGroupingIN>'
                      +           '<v1:WSRequestHeader2>'
                      +              '<v1:System>'
                      +                 '<v1:name>Salesforce</v1:name>'
                      +                 '<v1:correlationID>'+objTramite.Id + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) +'</v1:correlationID>'
                      +                 '<v1:processingServer>Tibco</v1:processingServer>'
                      +              '</v1:System>'
                      +              '<v1:Property>'
                      +                 '<v1:name></v1:name>'
                      +                 '<v1:value></v1:value>'
                      +              '</v1:Property>'
                      +           '</v1:WSRequestHeader2>'
                      +           '<set1:SetTaxPlanGroupingInput>'
                      +              '<set1:SetTaxPlanGroupingRequest>'
                      +                 '<set1:FactCorp_Data>'
                      +                    '<set1:OrderNumber>'+objTramite.Name+'</set1:OrderNumber>'
                      +                    '<set1:User>'+userSolicitudCambio+'</set1:User>'
                      +                    '<set1:Approver>'+userAprobadorCambio+'</set1:Approver>'
                      +                    '<set1:Account>'+objTramite.Cuenta_de_Facturacion__r.Name+'</set1:Account>'
                      +                    '<set1:Grouping>'
                      +                       '<set1:Grouper>'+objTramite.Nombre_del_concepto_a_consolidar__c+'</set1:Grouper>';
        			  for(Servicio_del_tramite_cuenta_fact__c objServicio : lstServiciosTramite){
               strXml +=                       '<set1:ExternalService>'
                      +                          '<set1:ExternalServiceId>'+objServicio.Activo__r.Name+'</set1:ExternalServiceId>'
                      +                       '</set1:ExternalService>';
                      }                      
               strXml +=                    '</set1:Grouping>'
                      +                 '</set1:FactCorp_Data>'
                      +              '</set1:SetTaxPlanGroupingRequest>'
                      +           '</set1:SetTaxPlanGroupingInput>'
                      +        '</set:SetTaxPlanGroupingIN>'
                      +     '</soapenv:Body>'
                      +  '</soapenv:Envelope>';              
        
        return strXml;
    }   
    
    private static string crearXMLSetAgrupacionPlanImpuestosTaxGroup(string IdTramite){
        string strXml, strTaxNamePrevio = 'Default';
        List<Plan_de_impuestos_servicio__c> ListPlanImp = new List<Plan_de_impuestos_servicio__c>(
            [SELECT Feat_Id__c,Tax_nm__c, Servicio_del_tramite_cuenta_Fact__r.Tramite_cuenta_de_facturacion__r.Nombre_del_concepto_a_consolidar__c
             FROM Plan_de_impuestos_servicio__c
			 WHERE Servicio_del_tramite_cuenta_Fact__r.Tramite_cuenta_de_facturacion__r.Id =: IdTramite
			 ORDER BY Tax_nm__c]);
        
        for(Plan_de_impuestos_servicio__c objPlanImp : ListPlanImp){			
            if(strTaxNamePrevio == 'Default'){
                strXml =  '<set1:Grouping>'
                       +  '<set1:Grouper>'+objPlanImp.Servicio_del_tramite_cuenta_Fact__r.Tramite_cuenta_de_facturacion__r.Nombre_del_concepto_a_consolidar__c+'</set1:Grouper>'
                       +  '<set1:Tax_nm>'+(objPlanImp.Tax_nm__c==null?'':objPlanImp.Tax_nm__c)+'</set1:Tax_nm>'
                       +  '<set1:Feat>'
                       +  '<set1:Feat_id>'+objPlanImp.Feat_Id__c+'</set1:Feat_id>'
                       +  '</set1:Feat>';
            }else if(strTaxNamePrevio == objPlanImp.Tax_nm__c){				
                strXml += '<set1:Feat>'
                       +  '<set1:Feat_id>'+objPlanImp.Feat_Id__c+'</set1:Feat_id>'
                       +  '</set1:Feat>';
            }else{                
                strXml += '</set1:Grouping>'
				  	   +  '<set1:Grouping>'
                       +  '<set1:Grouper>'+objPlanImp.Servicio_del_tramite_cuenta_Fact__r.Tramite_cuenta_de_facturacion__r.Nombre_del_concepto_a_consolidar__c+'</set1:Grouper>'
                       +  '<set1:Tax_nm>'+(objPlanImp.Tax_nm__c==null?'':objPlanImp.Tax_nm__c)+'</set1:Tax_nm>'
                       +  '<set1:Feat>'
                       +  '<set1:Feat_id>'+objPlanImp.Feat_Id__c+'</set1:Feat_id>'
                       +  '</set1:Feat>';                
            }                        
            strTaxNamePrevio = +objPlanImp.Tax_nm__c;
        }    
        strXml     += '</set1:Grouping>'; 
        return strXml;
    }
}