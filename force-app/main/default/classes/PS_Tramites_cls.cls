/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               Portafolio Superior II
Descripcion:            Clase para el manejo de operaciones RevChain

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     15-03-2019  John Guevara (JG)			Clase padre para el proceso de operaciones por plan hacia RevChain   
*******************************************************************************/
public class PS_Tramites_cls {
    
    public virtual class Step{
        
        public OperacionComercial__c OC;
        public Map<String,Object> mapHierarchy;
        public LogTransacciones__c logServicio;
        
        public void init(){
            logServicio = new LogTransacciones__c();
        }
        
        //Can be overriden
        public virtual void EnvioFacturacion(Map<String,String> mapMsgTemplate){
            String sresponse = '';
            String sOperacion = 'PS_Facturacion_'+LibreriaUtilitaria_cls.quitarCaracteresEsp(OC.TOPP__r.TipodeOperacionporplan__c);
            sOperacion = sOperacion.replaceAll('\\ ', '_').ToUppercase();
            system.debug('sOperacion-'+sOperacion+'-'+mapMsgTemplate.containsKey(sOperacion));
            if(mapMsgTemplate.containsKey(sOperacion)){
                Dom.Document docMessageTemplate = new Dom.Document();
                docMessageTemplate.load(mapMsgTemplate.get(sOperacion));
                
                PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
                Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, mapHierarchy);
                DOM.Document docResponse;
                String correlationID = OC.Id;
                
                //Invocar servicio web 
                //---------------------------------
                PS_InvokeServicesProvisioningRev_cls invokeServicesProvisioningRevchain = new PS_InvokeServicesProvisioningRev_cls();
                docResponse = invokeServicesProvisioningRevchain.InvokeServiceProvisioning(correlationID, OC.Id, docServices);
                
                /*
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
                sresponse=LibreriaUtilitariaJobs_cls.consultarServicio(docServices.toXmlString(),sw.Action__c,sw.EndPoint__c);
                docResponse.load(sresponse);
                
                //Insertar log de envio de facturación
                logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = OC.Id;
                logServicio.LTE_Operacion_Comercial__c = OC.Id;
                logServicio.Name = 'Envio Facturación';
                logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
				*/
                
                RespuestaFacturacion(docResponse);
            }
            //return 'No fue posible armar el mensaje';
        }
        
        //Can be overriden
        public virtual void RespuestaFacturacion(DOM.Document docResponse){
            if(GetResultRevChain(docResponse)){
                if(OC.Lineas_OC__r.size()==0)
                    OC.Estado__c = 'Facturado';
                OC.FechaFacturacion__c = system.now();
                OC.EnvioFacturacion__c = false;
            }else{
                OC.Estado__c = 'No Exitoso Facturacion';
            }
        }
        
        public Boolean GetResultRevChain(DOM.Document docResponse){
            String status = '';
            Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
            if(serviceResponseNode.getName() !='Vacio'){
                status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();
            }
            system.debug('status'+status);
            if (status == 'PASS'){
                Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'response');
                if(ResponseNode.getName() !='Vacio'){
                    String resultResponse = responseNode.getAttribute('result', null);
                    system.debug('result'+resultResponse);
                    //Si resultado es Successful
                    if (resultResponse == 'S'){
                        return true;
                    }
                }
            }
            return false;
        }
    }
    
    //Clase override para modificacion_estandar, tener en cuenta que debe ser en minusculas el nombre de la clase
    public class modificacion_estandar extends PS_Tramites_cls.Step 
    {
        public override void EnvioFacturacion(Map<String,String> mapMsgTemplate){
            String sresponse = '';
            String tipo = 'PS_Facturacion_Modificacion_Estandar_'+LibreriaUtilitaria_cls.quitarCaracteresEsp(OC.Detalle_del_tramite__c).replaceAll('\\ ', '_');
            if(mapMsgTemplate.containsKey(tipo.toUpperCase())){
                Dom.Document docMessageTemplate = new Dom.Document();
                docMessageTemplate.load(mapMsgTemplate.get(tipo.toUpperCase()));
                
                PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
                Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, mapHierarchy);
                DOM.Document docResponse;
                String correlationID = OC.Id;
                
                //Invocar servicio web 
                //---------------------------------
                PS_InvokeServicesProvisioningRev_cls invokeServicesProvisioningRevchain = new PS_InvokeServicesProvisioningRev_cls();
                docResponse = invokeServicesProvisioningRevchain.InvokeServiceProvisioning(correlationID, OC.Id, docServices);
                
                /*
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
                sresponse=LibreriaUtilitariaJobs_cls.consultarServicio(docServices.toXmlString(),sw.Action__c,sw.EndPoint__c);
                docResponse.load(sresponse);
                
                //Insertar log de envio de facturación
                logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = OC.Id;
                logServicio.LTE_Operacion_Comercial__c = OC.Id;
                logServicio.Name = 'Envio Facturación';
                logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
				*/
                
                RespuestaFacturacion(docResponse);
            }
            //return 'No fue posible armar el mensaje';
        }
    }
    
    public class cambio_datos_cliente_o_cuenta extends PS_Tramites_cls.Step 
    {
        public override void EnvioFacturacion(Map<String,String> mapMsgTemplate){
            String sresponse = '';
            String tipo = 'PS_Facturacion_'+'cambio_datos_cliente_o_cuenta';
            if(mapMsgTemplate.containsKey(tipo.toUpperCase())){
                Dom.Document docMessageTemplate = new Dom.Document();
                docMessageTemplate.load(mapMsgTemplate.get(tipo.toUpperCase()));
                
                PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
                Dom.Document docSubscribers = clsHelper.PopulateXML(docMessageTemplate, mapHierarchy);
                DOM.Document docResponse;
                String correlationID = OC.Id;
                
                //Invocar servicio web 
                //---------------------------------
                PS_InvokeServicesProvisioningRev_cls invokeServicesProvisioningRevchain = new PS_InvokeServicesProvisioningRev_cls();
                docResponse = invokeServicesProvisioningRevchain.ModifyBillingProfile(correlationID, OC.Id, docSubscribers);
                /*
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
                sresponse=LibreriaUtilitariaJobs_cls.consultarServicio(docSubscribers.toXmlString(),sw.Action__c,sw.EndPoint__c);
                docResponse.load(sresponse);
                
                //Insertar log de envio de facturación
                logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = OC.Id;
                logServicio.LTE_Operacion_Comercial__c = OC.Id;
                logServicio.Name = 'Envio Facturación';
                logServicio.Informacion_Enviada__c = String.valueOf(docSubscribers.toXmlString());
                logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
                */
                RespuestaFacturacion(docResponse);
            }
            //return 'No fue posible armar el mensaje';
        }
    }
    
    public class FacturacionLineas{
        public Lineas_OC__c LineaOC;
        public Map<String,Object> mapHierarchy;
        public LogTransacciones__c logServicio;
        
        public void init(){
            logServicio = new LogTransacciones__c();
        }
        
        public String EnvioFacturacion(Map<String,String> mapMsgTemplate){
            String sErrorMessage = '';
            ServiciosWeb__c sw;
            Dom.Document docServices;
            DOM.Document docResponse;
            Dom.Document docMessageTemplate = new Dom.Document();
            PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
            system.debug(LineaOC);
            
            //List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name = 'PS_Facturacion_Lineas'];
            //if(!lstMensajes.isEmpty()){
            if(mapMsgTemplate.containsKey('PS_Facturacion_Lineas')){
                try{
                    docMessageTemplate.load(mapMsgTemplate.get('PS_Facturacion_Lineas'));
                    docServices = clsHelper.PopulateXML(docMessageTemplate, mapHierarchy);
                    
                    sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
                    String endpoint = sw.EndPoint__c;
                    String method = sw.Action__c;
                    PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
                    docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
                    
                    logServicio.Linea_OC__c = LineaOC.Id;
                    logServicio.Name = 'Envio Revchain Adicion Linea';
                    logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                    logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
                    try{
                        sErrorMessage = RespuestaFacturacion(docResponse);
                    }catch(Exception e){
                        sErrorMessage = e.getMessage() + e.getStackTraceString();
                    }
                    logServicio.Estado__c = String.isEmpty(sErrorMessage)?'Realizado':'Fallido';
                    if(String.isNotEmpty(sErrorMessage))
                        logServicio.Error_Apex__c = sErrorMessage.length()>255?sErrorMessage.substring(0, 255):sErrorMessage;
                    
                }catch(Exception e){
                    sErrorMessage = e.getMessage() + e.getStackTraceString();
                    system.debug(sErrorMessage);
                    logServicio.Linea_OC__c = LineaOC.Id;
                    logServicio.Name = 'Envio Remedy Creacion Caso';
                    logServicio.Estado__c = String.isEmpty(sErrorMessage)?'Realizado':'Fallido';
                    logServicio.Error_Apex__c = sErrorMessage.length()>255?sErrorMessage.substring(0, 255):sErrorMessage;
                }
            }else{
                sErrorMessage = 'Tipo de mensaje no encontrado';
            }
            return sErrorMessage;
        }
        
        public Boolean GetResult(DOM.Document docResponse){
            String status = '';
            Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
            if(serviceResponseNode.getName() !='Vacio'){
                status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();
            }
            system.debug('status'+status);
            if (status == 'PASS'){
                return true;
            }
            return false;
        }
    
        public String RespuestaFacturacion(DOM.Document docResponse){
            String strErrMessage = 'Error en la integracion';
            LineaOC.Estado__c = 'No Exitoso Facturacion';
            if(GetResult(docResponse)){
                system.debug('OK');
                Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'response');
                system.debug(responseNode);
                if(ResponseNode.getName() !='Vacio'){
                    String attResult = responseNode.getAttributeValue('result', '');
                    if(attResult=='S'){
                        strErrMessage = '';
                        LineaOC.Estado__c = 'Facturada';
                    }else{
                        Dom.XMLNode faultsNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(responseNode,'faults');
                        if(faultsNode.getName() !='Vacio'){
                            for(Dom.XMLNode faultsNodechild:faultsNode.getChildElements()){
                                if(faultsNodechild.getName() == 'fault_detail'){
                                    strErrMessage += ' - ' + faultsNodechild.getAttributeValue('error_description', '');
                                }
                            }
                        }
                    }
                }else{
                    strErrMessage = 'Error leyendo la respuesta de facturación';
                }
            }else{
                system.debug('NOK');
                Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
                if(serviceResponseNode.getName() !='Vacio'){
                    Dom.XMLNode errorMessageNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(serviceResponseNode,'errorMessage');
                    if(errorMessageNode.getName() !='Vacio')
                        strErrMessage = errorMessageNode.getText();
                }
            }
            return strErrMessage;
        }
    }
}