/*******************************************************************************
Develope by:            ETB
Author:                 Samuel Rodriguez 
Project:                Jerarquia de Cuentas   
Description:            Clase de prueba de servcios mock para clases de integación tramites sobre cuentas de facturación.

Cambios (Versiones)
--------------------------------------------------------------
No.      Date          Author                  Description
-----    ----------    --------------------    ---------------
1.0      10/05/2020    Samuel Rodriguez        Class creation.
*******************************************************************************/
@isTest
global class IntegracionTramitesCFMock_tst {
    
     global class invokeTransferServiceOK_Test implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
           ServiciosWeb__c sw = ServiciosWeb__c.getValues('TransferenciaServiciosCuentasFact');
            	            
           String response ='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"> '
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
            System.debug('Ingresa mock');
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
        }
        
    }
    
    
     global class invokeGetHierarchyAccountDataOK_Test implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
           ServiciosWeb__c sw = ServiciosWeb__c.getValues('ConsultaFechaFactServicioRevchain');
            	            
            String response = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:GetHierarchyAccountDataOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetHierarchyAccountDataOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>AC-811622</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2020-02-08T15:40:05.972-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:GetHierarchyAccountDataOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetHierarchyAccountDataOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/GetHierarchyAccountDataMsg"><ns2:ResponseService><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>MdmCmpRevchain</ns2:System><ns2:PortalData><ns2:HierarchyAccounts><ns2:InvoiceDate>2020-03-29</ns2:InvoiceDate><ns2:State>I</ns2:State><ns2:SourceBillingCycle>N/A</ns2:SourceBillingCycle><ns2:DestinationBillingCycle>18</ns2:DestinationBillingCycle></ns2:HierarchyAccounts><ns2:ErrorResult>0</ns2:ErrorResult><ns2:ErrorDescription>OK</ns2:ErrorDescription></ns2:PortalData></ns2:ResponseService></ns2:GetHierarchyAccountDataOutput></ns0:GetHierarchyAccountDataOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            System.debug('Ingresa mock');
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
        }
        
    }

}