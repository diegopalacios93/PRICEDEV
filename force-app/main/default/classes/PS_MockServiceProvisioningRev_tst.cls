/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR FASE II
Descripción:        Clase de prueba con servicios Mock para aprovisionamientos hacia Revchain.

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-01-12   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
@isTest
global class PS_MockServiceProvisioningRev_tst {
    
    global class MockResponseServiceProvisioningOK implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
           ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
            	            
           String response = '<?xml version="1.0" encoding="UTF-8"?>'
                                        +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                            +'<SOAP-ENV:Body>'
                                                +'<ns1:InvokeServiceProvisioningOutput xmlns:ns1="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0">'
                                                    +'<ns2:WSResponseHeader2 xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
                                                        +'<ns2:System>'
                                                            +'<ns2:name>Tibco</ns2:name>'
                                                            +'<ns2:correlationID>a09m0000003QkR5AAK</ns2:correlationID>'
                                                            +'<ns2:processingServer>Tibco</ns2:processingServer>'
                                                        +'</ns2:System>'
                                                        +'<ns2:Service>'
                                                            +'<ns2:status>PASS</ns2:status>'
                                                            +'<ns2:responseDate>2019-02-28T16:38:22.957-05:00</ns2:responseDate>'
                                                        +'</ns2:Service>'
                                                    +'</ns2:WSResponseHeader2>'
                                                    +'<ns1:BodyResponse>'
                                                        +'<ns2:response system="RevChain" operation="P" result="E" xmlns:ns2="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/RVCResponse">'
                                                            +'<ns2:faults>'
                                                                +'<ns2:subscriber_id>12052842234</ns2:subscriber_id>'
                                                                +'<ns2:fault_detail error_description="[RevChainServiceConnectionException: 2019-02-28 16:37:26.931 newtibco 10014 ConnectionConnectionNumberRules.validateConnectionNumber(bundle) Connection Number is not currently available for assignment. Connection Number = 13795634. ]" error_code="10014"/>'
                                                                +'<ns2:fault_detail error_description="[RevChainServiceConnectionException: 2019-02-28 16:37:26.932 newtibco 10014 ConnectionConnectionNumberRules.validateConnectionNumber(bundle) Connection Number is not currently available for assignment. Connection Number = 13795635. ]" error_code="10014"/>'
                                                            +'</ns2:faults>'
                                                        +'</ns2:response>'
                                                    +'</ns1:BodyResponse>'
                                                +'</ns1:InvokeServiceProvisioningOutput>'
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
    
    global class MockResponseServiceProvisioningNOK implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
           ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
            	            
           String response = '<?xml version="1.0" encoding="UTF-8"?>'
                                        +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                            +'<SOAP-ENV:Body>'
                                                +'<ns1:InvokeServiceProvisioningOutput xmlns:ns1="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0">'
                                                    +'<ns2:WSResponseHeader2 xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
                                                        +'<ns2:System>'
                                                            +'<ns2:name>Tibco</ns2:name>'
                                                            +'<ns2:correlationID>a09m0000003QkR5AAK</ns2:correlationID>'
                                                            +'<ns2:processingServer>Tibco</ns2:processingServer>'
                                                        +'</ns2:System>'
                                                        +'<ns2:Service>'
                                                            +'<ns2:status>PASS</ns2:status>'
                                                            +'<ns2:responseDate>2019-02-28T16:38:22.957-05:00</ns2:responseDate>'
                                                        +'</ns2:Service>'
                                                    +'</ns2:WSResponseHeader2>'
                                                    +'<ns1:BodyResponse>'
                                                        +'<ns2:response system="RevChain" operation="P" result="E" xmlns:ns2="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/RVCResponse">'
                                                            +'<ns2:faults>'
                                                                +'<ns2:subscriber_id>12052842234</ns2:subscriber_id>'
                                                                +'<ns2:fault_detail error_description="[RevChainServiceConnectionException: 2019-02-28 16:37:26.931 newtibco 10014 ConnectionConnectionNumberRules.validateConnectionNumber(bundle) Connection Number is not currently available for assignment. Connection Number = 13795634. ]" error_code="10014"/>'
                                                                +'<ns2:fault_detail error_description="[RevChainServiceConnectionException: 2019-02-28 16:37:26.932 newtibco 10014 ConnectionConnectionNumberRules.validateConnectionNumber(bundle) Connection Number is not currently available for assignment. Connection Number = 13795635. ]" error_code="10014"/>'
                                                            +'</ns2:faults>'
                                                        +'</ns2:response>'
                                                    +'</ns1:BodyResponse>'
                                                +'</ns1:InvokeServiceProvisioningOutput>'
                                            +'</SOAP-ENV:Body>'
                                        +'</SOAP-ENV:Envelope>';
            System.debug('Ingresa mock');
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(503);
	        return res;
        }
        
    }
    
    global class MockResponseServiceProvisioningCatch implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
       		CalloutException e = (CalloutException)CalloutException.class.newInstance();
        	e.setMessage('Exception occured during callout');
        	throw e;
            
        }
        
    }

}