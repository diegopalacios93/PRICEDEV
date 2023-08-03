/*******************************************************************************
Develope by:            ETB
Author:                 Samuel Rodriguez 
Project:                Jerarquia de Cuentas   
Description:            Clase encargada de recolectar y manejar la información necesaria 
						para integrar tramites sobre cuentas de facturación.

Cambios (Versiones)
--------------------------------------------------------------
No.      Date          Autor                   Description
-----    ----------    --------------------    ---------------
1.0      10/05/2020    Samuel Rodriguez        Class creation.
*******************************************************************************/
public class IntegracionTramitesCuentaFacturacion_cls {

/*
* @Método: 		TransferService
* @Parámetros:	OperacionComercial__c
* @Descripción:	Método que aprovisiona el translado del servicio en RVC, MDM y OCS .
*/    
    
	public static void TransferService(List<OperacionComercial__c> scope){
        
    	list<LogTransacciones__c> LstlogsToInsert  = new list<LogTransacciones__c>();
        list<OperacionComercial__c> lstOCstoUpdate = new list<OperacionComercial__c>();
        
        for(OperacionComercial__c OC:scope){
            if(OC.TOPP__r.Tipoderegistro__c != 'Conversion_Demo_a_Venta' || 
               (OC.TOPP__r.Tipoderegistro__c == 'Conversion_Demo_a_Venta' && 
                (OC.FechaFacturacion__c != null || 
                 ((OC.ValorTarifaPlan__c == null || OC.ValorTarifaPlan__c == 0) &&
                  (OC.Valor_Equipos__c == null || OC.Valor_Equipos__c == 0) &&
                  (OC.ValorObraCivil__c == null || OC.ValorObraCivil__c == 0) &&
                  (OC.Valorunicavez__c == null || OC.Valorunicavez__c == 0) &&
                  (OC.Valor_Recurrente_Aliado__c == null || OC.Valor_Recurrente_Aliado__c == 0) &&
                  (OC.DescuentoPorc__c == null || OC.DescuentoPorc__c == 0))) 
                && OC.FechadeActivacion__c <=Date.today()))
            {
                list<OperacionComercial__c> lstOCs = new list<OperacionComercial__c>();
                list<CuentaFacturacion__c> lstBillingAccs = new list<CuentaFacturacion__c>();
                Dom.Document docResponse; 
                String SubscriberId='';
                String SubscriberIdDestination='';
                String ExternalServiceId='';
                String SubscriberNumber='';
                String CurrentCycle='';
                String NewCycle='';
                String xmlRequest='';
                String xmlResponse='';
                String IsLTEService = 'Y';
                String CorrelationId='';
                String Producto = ''; 
               //Respuesta
                String status ='';
                String errorCode =''; 
                String errorMessage='';
                String TransferServiceRVCResponseCode ='';
                String TransferServiceMDMResponseCode ='';
                String UpdateCycleOCSResponseCode = ''; 
                String TransferServiceRVCResponseDescription ='';
                String TransferServiceMDMResponseDescription ='';
                String UpdateCycleOCSResponseDescription = '';
                String MensajeRespuesta ='';
                Boolean integracionTrasladoOk = false;
            
                lstOCs= [SELECT id, name, Activo__r.name, Activo__r.CuentaFacturacion__r.name,
                    CuentaFacturacion__r.name, Activo__r.ExternalServiceID__c, Activo__r.NumeroConexion__c,
                     Activo__r.CuentaFacturacion__r.CodCicloFac__c,Activo__r.CuentaFacturacion__r.LTE_CuentaFacturacionLTE__c,
                     TOPP__r.name,Activo__r.NombredelProducto__r.name
                     FROM OperacionComercial__c WHERE id=:OC.Id];
             
                system.debug('lstOCs------------->' + lstOCs);
                     
                SubscriberId=lstOCs[0].Activo__r.CuentaFacturacion__r.name;
                SubscriberIdDestination=lstOCs[0].CuentaFacturacion__r.name;
                ExternalServiceId=lstOCs[0].Activo__r.ExternalServiceID__c;
                SubscriberNumber='57'+lstOCs[0].Activo__r.NumeroConexion__c;
                CurrentCycle = lstOCs[0].Activo__r.CuentaFacturacion__r.CodCicloFac__c;
                CorrelationId = lstOCs[0].Id;
                Producto = lstOCs[0].Activo__r.NombredelProducto__r.name;
            
                system.debug('Producto------------->' + Producto);
                 
                 if(Producto == 'TELEFONIA MOVIL (LTE)')
                 {
                     IsLTEService = 'Y';
                 }
                 else{
                     IsLTEService = 'N';
                 }
                 system.debug('IsLTEService------------->' + IsLTEService);
             
                lstBillingAccs = [SELECT id, name, CodCicloFac__c FROM CuentaFacturacion__c WHERE name =: SubscriberIdDestination];
                NewCycle = lstBillingAccs[0].CodCicloFac__c;
                 
                 If(NewCycle == '96'){
                     NewCycle = '5';
                 }
                  If(NewCycle == '97'){
                     NewCycle = '15';
                 }
             
                xmlRequest= ConstruirXMLCtasFact_cls.CrearXMLTransferServicesSystems(CorrelationId, SubscriberId, SubscriberIdDestination, ExternalServiceId, SubscriberNumber, NewCycle, IsLTEService);
                System.debug('******* Request Trasferencia Servicios cuenta Fact-----------> ' + xmlRequest);
                xmlResponse = invokeTransferService(xmlRequest);
                //Simular respuesta correcta
               /*xmlResponse = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                               +'<SOAP-ENV:Body>'
                                 +'<ns0:TransferServicesSystemsOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/TransferServicesSystemsOp">'
                                     +'<ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
                                         +'<ns1:System>'
                                             +'<ns1:name>Salesforce</ns1:name>'
                                               +'<ns1:correlationID>TRSSERSYS-001</ns1:correlationID>'
                                                +'<ns1:processingServer>Tibco</ns1:processingServer>'
                                            +'</ns1:System>'
                                            +'<ns1:Service>'
                                               +' <ns1:status>PASS</ns1:status>'
                                               +' <ns1:responseDate>2020-05-11T09:41:29.659-05:00</ns1:responseDate>'
                                           +' </ns1:Service>'
                                        +'</ns1:WSResponseHeader2>'
                                       +'<ns1:TransferServicesSystemsOutput xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/TransferServicesSystemsMsgs">'
                                            +'<ns2:ResponseData xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/ResponseDataTransfer">'
                                               +' <ns2:TransferServiceRVCResponse>'
                                                   +' <ns2:Code>S</ns2:Code>'
                                                    +'<ns2:Description>success</ns2:Description>'
                                                   +' <ns3:response system="RevChain" operation="P" result="S" xmlns:ns3="InvokeEJBURevChainOutResponse">'
                                                      +'  <ns3:faults>'
                                                            +' <ns3:subscriber_id>12052842235</ns3:subscriber_id>'
                                                       +' </ns3:faults>'
                                                    +'</ns3:response>'
                                                +'</ns2:TransferServiceRVCResponse>'
                                               +' <ns2:TransferServiceMDMResponse>'
                                                    +'<ns2:Code>0</ns2:Code>'
                                                   +' <ns2:Description>Ejecutado Exitosamente</ns2:Description>'
                                               +' </ns2:TransferServiceMDMResponse>'
                                              +'  <ns2:UpdateCycleOCSResponse>'
                                                +'    <ns2:Code>0</ns2:Code>'
                                                 +'   <ns2:Description>Ejecutado Exitosamente</ns2:Description>'
                                               +' </ns2:UpdateCycleOCSResponse>'
                                            +'</ns2:ResponseData>'
                                       +' </ns1:TransferServicesSystemsOutput>'
                                   +' </ns0:TransferServicesSystemsOUT>'
                                +'</SOAP-ENV:Body>'
                            +'</SOAP-ENV:Envelope>';*/
                System.debug('*******Response Trasferencia Servicios cuenta Fact-----------> ' + xmlResponse);
            
                //Insertar log de envio de facturación
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = OC.Id;
                logServicio.LTE_Operacion_Comercial__c = OC.Id;
                logServicio.Informacion_Enviada__c = String.valueOf(xmlRequest);
                logServicio.Name = (oc.TOPP__r.Tipoderegistro__c == 'Conversion_Demo_a_Venta'?'Conversion Demo a Venta - Traslado Servicio':'Envio Traslado a Sistemas');
                logServicio.Informacion_Recibida__c = String.valueOf(xmlResponse);
                LstlogsToInsert.add(logServicio);
                
                
                //Manejo de la respuesta 
        
                docResponse = new Dom.Document();
                docResponse.load(xmlResponse);
             
                Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
         
                if(serviceResponseNode.getName() !='Vacio'){
                   status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();
                   System.debug('serviceResponseNode.status---------->' + status);
                }            
                if (status == 'FAIL'){
                    Dom.XMLNode statusDetailNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(serviceResponseNode,'statusDetail');
                    if(serviceResponseNode.getName() !='Vacio'){
                        errorCode = statusDetailNode.getChildElement('errorCode', statusDetailNode.getNamespace()).getText();
                        System.debug('errorCode---------->' + errorCode);
                        errorMessage = statusDetailNode.getChildElement('errorMessage', statusDetailNode.getNamespace()).getText();
                        System.debug('errorMessage---------->' + errorMessage);
                        MensajeRespuesta = 'errorCode: ' + errorCode + '</br>'+'<br>errorMessage: ' + errorMessage + '</br>';
                        OC.LTE_URLFallos__c = MensajeRespuesta;
                        //Actualizar estado OC
                        OC.Estado__c = 'No Exitoso Facturacion';
                        lstOCstoUpdate.add(OC);
                        //update OC;
                    }
                }
                if (status == 'PASS'){
    
                    Dom.XMLNode ResponseDataNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'ResponseData');
                    System.debug('ResponseDataNode---------->' + ResponseDataNode);
                    //Obtener TransferServiceRVCResponseNode
                    Dom.XMLNode TransferServiceRVCResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(ResponseDataNode,'TransferServiceRVCResponse');
                    //System.debug('TransferServiceRVCResponseNode---------->' + TransferServiceRVCResponseNode);
                    if(TransferServiceRVCResponseNode != Null){
                     if(TransferServiceRVCResponseNode.getName() !='Vacio'){
                        TransferServiceRVCResponseCode = TransferServiceRVCResponseNode.getChildElement('Code', TransferServiceRVCResponseNode.getNamespace()).getText();
                        TransferServiceRVCResponseDescription = TransferServiceRVCResponseNode.getChildElement('Description', TransferServiceRVCResponseNode.getNamespace()).getText();
                        }
                    }
                    //Obtener TransferServiceMDMResponseNode
                    Dom.XMLNode TransferServiceMDMResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(ResponseDataNode,'TransferServiceMDMResponse');
                    //System.debug('TransferServiceMDMResponseNode---------->' + TransferServiceMDMResponseNode);
                    if(TransferServiceMDMResponseNode != null){
                        if(TransferServiceMDMResponseNode.getName() !='Vacio'){
                           TransferServiceMDMResponseCode = TransferServiceMDMResponseNode.getChildElement('Code', TransferServiceMDMResponseNode.getNamespace()).getText();
                           TransferServiceMDMResponseDescription = TransferServiceMDMResponseNode.getChildElement('Description', TransferServiceMDMResponseNode.getNamespace()).getText();
                       }
                    }
                       
                    //Obtener UpdateCycleOCSResponseNode
                    Dom.XMLNode UpdateCycleOCSResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(ResponseDataNode,'UpdateCycleOCSResponse');
                    //System.debug('UpdateCycleOCSResponseNode---------->' + UpdateCycleOCSResponseNode);
                    if(UpdateCycleOCSResponseNode != null){
                       if(UpdateCycleOCSResponseNode.getName() !='Vacio'){
                           UpdateCycleOCSResponseCode = UpdateCycleOCSResponseNode.getChildElement('Code', UpdateCycleOCSResponseNode.getNamespace()).getText();
                           UpdateCycleOCSResponseDescription = UpdateCycleOCSResponseNode.getChildElement('Description', UpdateCycleOCSResponseNode.getNamespace()).getText();
                       }
                    }   
                    
                    System.debug('IsLTEService---------->' + IsLTEService); 
                    System.debug('TransferServiceRVCResponseCode---------->' + TransferServiceRVCResponseCode);
                    System.debug('TransferServiceRVCResponseDescription---------->' + TransferServiceRVCResponseDescription); 
                    System.debug('TransferServiceMDMResponseCode---------->' + TransferServiceMDMResponseCode);
                    System.debug('TransferServiceMDMResponseDescription---------->' + TransferServiceMDMResponseDescription); 
                    System.debug('UpdateCycleOCSResponseCode---------->' + UpdateCycleOCSResponseCode);
                    System.debug('UpdateCycleOCSResponseDescription---------->' + UpdateCycleOCSResponseDescription); 
                    //Actualizar estado OC
                       //Si es LTE
                    if(IsLTEService == 'Y'){
                        MensajeRespuesta = 'CodeRevchain: ' + TransferServiceRVCResponseCode + '<br>DescriptionRevchain: ' + TransferServiceRVCResponseDescription +'</br>'+ 
                                             '<br>CodeMDM: ' + TransferServiceMDMResponseCode + '</br><br>DescriptionMDM: ' + TransferServiceMDMResponseDescription +'</br>'+
                                             '<br>CodeOCS: ' + UpdateCycleOCSResponseCode + '</br><br>DescriptionOCS: ' + UpdateCycleOCSResponseDescription + '</br>';  
                        OC.LTE_URLFallos__c = MensajeRespuesta;
                        if(TransferServiceRVCResponseCode == 'S' && TransferServiceMDMResponseCode == '0' && UpdateCycleOCSResponseCode == '0'){ //
                            integracionTrasladoOk = true;
                            OC.Estado__c = 'Facturado';
                            OC.EnvioFacturacion__c = false;
                            lstOCstoUpdate.add(OC);
                            //update OC;  
                        }else{
                            OC.Estado__c = 'No Exitoso Facturacion';
                            lstOCstoUpdate.add(OC);
                            //update OC; 
                           }
                     }
                     //Si no es LTE
                     if(IsLTEService == 'N'){
                        MensajeRespuesta = 'CodeRevchain: ' + TransferServiceRVCResponseCode + '<br>DescriptionRevchain: ' + TransferServiceRVCResponseDescription +'</br>'+ 
                                             '<br>CodeMDM: ' + TransferServiceMDMResponseCode + '</br><br>DescriptionMDM: ' + TransferServiceMDMResponseDescription +'</br>';
                        OC.LTE_URLFallos__c = MensajeRespuesta;
                        if(TransferServiceRVCResponseCode == 'S'){ // && TransferServiceMDMResponseCode == '0'
                            integracionTrasladoOk = true;
                            OC.Estado__c = 'Facturado';
                            OC.EnvioFacturacion__c = false;
                            lstOCstoUpdate.add(OC);
                            //update OC;  
                        }else{
                            OC.Estado__c = 'No Exitoso Facturacion';
                            lstOCstoUpdate.add(OC);
                            //update OC; 
                        }
                     }
                 }
            }   		
        }        
        //insert logServicio; 
        insert LstlogsToInsert;
        update lstOCstoUpdate;
        
    }

/*
* @Método: 		invokeTransferService
* @Parámetros:	OperacionComercial__c
* @Descripción:	Método que invoka servcio de traslado del servicio en RVC, MDM y OCS .
*/  
   	public static string invokeTransferService(String strRequest){
                 
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('TransferenciaServiciosCuentasFact');
        System.debug('\n\n Request Trasferencia Servicios cuenta Fact-----------> ' + strRequest);
        //Consume el servicio y almacena el response.
        String strResponse;
        if(!Test.isRunningTest())
        	strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);
      	else
            strResponse ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"> '
                +'<SOAP-ENV:Body>'
                +'<ns0:TransferServicesSystemsOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/TransferServicesSystemsOp">'
                    +'<ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
                        +'<ns1:System>'
                            +'<ns1:name>Salesforce</ns1:name>'
                            +'<ns1:correlationID>TRSSERSYS-001</ns1:correlationID>'
                            +'<ns1:processingServer>Tibco</ns1:processingServer>'
                        +'</ns1:System>'
                        +'<ns1:Service>'
                            +'<ns1:status>PASS</ns1:status>'
                            +'<ns1:responseDate>2020-05-11T09:41:29.659-05:00</ns1:responseDate>'
                        +'</ns1:Service>'
                    +'</ns1:WSResponseHeader2>'
                    +'<ns1:TransferServicesSystemsOutput xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/TransferServicesSystemsMsgs">'
                        +'<ns2:ResponseData xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/ResponseDataTransfer">'
                            +'<ns2:TransferServiceRVCResponse>'
                                +'<ns2:Code>S</ns2:Code>'
                                +'<ns2:Description>[RevChainService: 2020-05-11 09:37:50.364 ]</ns2:Description>'
                                +'<ns3:response system="RevChain" operation="P" result="S" xmlns:ns3="InvokeEJBURevChainOutResponse">'
                                    +'<ns3:faults>'
                                        +'<ns3:subscriber_id>12052842235</ns3:subscriber_id>'
                                    +'</ns3:faults>'
                                +'</ns3:response>'
                            +'</ns2:TransferServiceRVCResponse>'
                            +'<ns2:TransferServiceMDMResponse>'
                                +'<ns2:Code>0</ns2:Code>'
                                +'<ns2:Description>Ejecutado Exitosamente</ns2:Description>'
                            +'</ns2:TransferServiceMDMResponse>'
                            +'<ns2:UpdateCycleOCSResponse>'
                                +'<ns2:Code>0</ns2:Code>'
                                +'<ns2:Description>Ejecutado Exitosamente</ns2:Description>'
                            +'</ns2:UpdateCycleOCSResponse>'
                        +'</ns2:ResponseData>'
                    +'</ns1:TransferServicesSystemsOutput>'
                +'</ns0:TransferServicesSystemsOUT>'
            +'</SOAP-ENV:Body>'
        +'</SOAP-ENV:Envelope>';
        
        return strResponse;
	 }
     
/*
* @Método: 		UpdateAccountDataSystemsResponseValues
* @Parámetros:	String
* @Descripción:	Método que obtiene los datos de la respuesta del servicio.
*/    
    
    public static map<string,string> UpdateAccountDataSystemsResponseValues( String XmlResponse, String cfId ){
        
        map<string,string> valores			= new map<string,string>();
        List<CuentaFacturacion__c> lstCF 	= new List<CuentaFacturacion__c>(); 
        Dom.Document docResponse 			= new Dom.Document();
        String status 						= '';
        String ResponseDescriptionError 	= 'Error en la actualización: ';
        Boolean Facturable                  = false;
        
        lstCF = [SELECT Id, Facturable__c From CuentaFacturacion__c Where CuentaFacturacion__c.Name =: cfId];
        if(!Test.isRunningTest()){
        Facturable = lstCF[0].Facturable__c;
        }else{
    	Facturable = true; }
        docResponse.load(xmlResponse);        
        Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
            
        if(serviceResponseNode.getName() !='Vacio'){
        	status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();
            valores.put('status',status);		
        }            
        if (status == 'FAIL'){
                Dom.XMLNode statusDetailNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(serviceResponseNode,'statusDetail');
                if(serviceResponseNode.getName() !='Vacio'){
                    valores.put('errorCode',statusDetailNode.getChildElement('errorCode', statusDetailNode.getNamespace()).getText());
                    valores.put('errorMessage',statusDetailNode.getChildElement('errorMessage', statusDetailNode.getNamespace()).getText());
                 }
        }
        if (status == 'PASS'){

           		Dom.XMLNode ResponseDataNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'ResponseData');
                //Obtener UpdateAccountDataRVCResponseNode
                Dom.XMLNode UpdateAccountDataRVCResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(ResponseDataNode,'UpdateAccountDataRVCResponse');
                if(UpdateAccountDataRVCResponseNode != Null){
                 if(UpdateAccountDataRVCResponseNode.getName() !='Vacio'){
                    valores.put('UpdateAccountDataRVCResponseCode',UpdateAccountDataRVCResponseNode.getChildElement('Code', UpdateAccountDataRVCResponseNode.getNamespace()).getText());
                    valores.put('UpdateAccountDataRVCResponseDescription',UpdateAccountDataRVCResponseNode.getChildElement('Description', UpdateAccountDataRVCResponseNode.getNamespace()).getText());
                    }
                }
                //Obtener UpdateAccountDataRMCAResponseNode
                Dom.XMLNode UpdateAccountDataRMCAResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(ResponseDataNode,'UpdateAccountDataRMCAResponse');
                if(UpdateAccountDataRMCAResponseNode != null){
                    if(UpdateAccountDataRMCAResponseNode.getName() !='Vacio'){
                        List<Dom.XmlNode> ListNodes = new List<Dom.XmlNode>();
                        ListNodes = UpdateAccountDataRMCAResponseNode.getChildElements();
                        if(Facturable){
                            for( dom.XMLNode dxm : ListNodes){
                                if(dxm.getChildElement('Code', dxm.getNamespace()).getText()!= Null && dxm.getChildElement('Description', dxm.getNamespace()).getText()!=Null){
                                   if(valores.get('UpdateAccountDataRMCAResponseCode')== '' || valores.get('UpdateAccountDataRMCAResponseCode') == NULL){
                                        valores.put('UpdateAccountDataRMCAResponseCode',dxm.getChildElement('Code', dxm.getNamespace()).getText());
                                        valores.put('UpdateAccountDataRMCAResponseDescription',dxm.getChildElement('Description', dxm.getNamespace()).getText());   
                                   }else{
                                       if(dxm.getChildElement('Code', dxm.getNamespace()).getText() !='S'){
                                       //if(dxm.getChildElement('Code', dxm.getNamespace()).getText() =='S'){
                                        valores.put('UpdateAccountDataRMCAResponseCode',dxm.getChildElement('Code', dxm.getNamespace()).getText());
                                        valores.put('UpdateAccountDataRMCAResponseDescription',dxm.getChildElement('Description', dxm.getNamespace()).getText());
                                       }
                                   }
                                }
                            }
                        }else{
                        	valores.put('UpdateAccountDataRMCAResponseCode','S');
                            valores.put('UpdateAccountDataRMCAResponseDescription','Cuenta No Facturable');
                        }
                   }
                }
                   
                //Obtener UpdateAccountDataMDMResponse
                Dom.XMLNode UpdateAccountDataMDMResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(ResponseDataNode,'UpdateAccountDataMDMResponse');
                if(UpdateAccountDataMDMResponseNode != null){
                   if(UpdateAccountDataMDMResponseNode.getName() !='Vacio'){
                       valores.put('UpdateAccountDataMDMResponseCode',UpdateAccountDataMDMResponseNode.getChildElement('Code', UpdateAccountDataMDMResponseNode.getNamespace()).getText());
                       valores.put('UpdateAccountDataMDMResponseDescription',UpdateAccountDataMDMResponseNode.getChildElement('Description', UpdateAccountDataMDMResponseNode.getNamespace()).getText());
                   }
                }   
        }
        
        if(valores.get('UpdateAccountDataRVCResponseCode')== 'S' && valores.get('UpdateAccountDataRMCAResponseCode')== 'S' && valores.get('UpdateAccountDataMDMResponseCode')== '0'){
            valores.put('ResponseCode','0');
            valores.put('ResponseDescription','Actualización Exitosa');
        }else{
            valores.put('ResponseCode','E');
            If(valores.get('UpdateAccountDataRVCResponseCode')!= 'S'){
                ResponseDescriptionError = ResponseDescriptionError +' Revchain: '+valores.get('UpdateAccountDataRVCResponseDescription');
       	    }
            If(valores.get('UpdateAccountDataRMCAResponseCode')!= 'S'){
                ResponseDescriptionError = ResponseDescriptionError +' RMCA: '+valores.get('UpdateAccountDataRMCAResponseDescription');
       	    }
            If(valores.get('UpdateAccountDataMDMResponseCode')!= '0'){
                ResponseDescriptionError = ResponseDescriptionError +' MDM: '+valores.get('UpdateAccountDataMDMResponseDescription');
       	    }
            
            valores.put('ResponseDescription',ResponseDescriptionError);
        }
        System.debug('valores---------->' + valores);
		return valores;
    }

}