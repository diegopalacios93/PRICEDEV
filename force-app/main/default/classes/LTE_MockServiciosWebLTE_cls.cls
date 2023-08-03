/*******************************************************************************
Develope by:            Avanxo Colombia
Project:                ETB-LTE   
Description:            Clase encargada de contener los Mock para los servicos web consumidos en fase1 LTE.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     10/08/2015  Avanxo                          Class creation.
*******************************************************************************/
global class LTE_MockServiciosWebLTE_cls
{
    public static Map<string,string> variablesMock=new Map<string,string>();
    
    global class MockHttpResponseCrearCtasFact implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            list<CuentaFacturacion__c> lstCtaFact = [SELECT Id FROM    CuentaFacturacion__c ];
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:CreacionCuentaResponse xmlns:ns0="http://www.etb.com.co/LTE                                    /WS/SiebelSvrs/CreacionCuentaResponse/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System>TIBCO</ns1:System>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>PASS</ns1:status>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'          <ns1:CreacionCuentaOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/integration/SiebelSrvs/CreacionCuenta/Output/v1.0">'
                                +'              <ns1:InvokeEJBURevChainOut>'
                                +'                  <ns1:response system="RevChain" operation="S" result="S">'
                                +'                      <ns1:faults>'
                                +'                          <ns1:subscriber_id>12050799339</ns1:subscriber_id>'
                                +'                          <ns1:account_id>'+lstCtaFact.get(0).id+'</ns1:account_id>'
                                +'                          <ns1:plan_impuestos>'
                                +'                              <ns1:type_name>PLAN DE IMPUESTOS ETB LTE</ns1:type_name>'
                                +'                              <ns1:tax_plan_vendor/>'
                                +'                          </ns1:plan_impuestos>'
                                +'                          <ns1:ciclo_facturacion>91</ns1:ciclo_facturacion>'
                                +'                          <ns1:fault_detail error_description="operation is successful" error_code="0"/>'
                                +'                      </ns1:faults>'
                                +'                  </ns1:response>'
                                +'              </ns1:InvokeEJBURevChainOut>'
                                +'              <ns1:ResponseHijos>'
                                +'                  <ns1:h_InvokeEJBURevChainOut>'
                                +'                      <ns1:h_response system="RevChain" operation="S" result="E">'
                                +'                          <ns1:h_faults>'
                                +'                              <ns1:h_subscriber_id> </ns1:h_subscriber_id>'
                                +'                              <ns1:h_account_id>a05560000003lFPAAY</ns1:h_account_id>'
                                +'                              <ns1:h_plan_impuestos>'
                                +'                                  <ns1:h_type_name>PLAN DE IMPUESTOS ETB LTE</ns1:h_type_name>'
                                +'                                  <ns1:h_tax_plan_vendor/>'
                                +'                              </ns1:h_plan_impuestos>'
                                +'                              <ns1:h_ciclo_facturacion>91</ns1:h_ciclo_facturacion>'
                                +'                              <ns1:h_fault_detail h_error_description="Could not parse element value into correct type. Element: characteristic_type, Value: Sin Valor." h_error_code="70059"/>'
                                +'                          </ns1:h_faults>'
                                +'                      </ns1:h_response>'
                                +'                  </ns1:h_InvokeEJBURevChainOut>'
                                +'              </ns1:ResponseHijos>'
                                +'          </ns1:CreacionCuentaOutput>'
                                +'      </ns0:CreacionCuentaResponse>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponseCrearCtasFactHijas implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:CreacionCuentaResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/SiebelSvrs/CreacionCuentaResponse/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System>TIBCO</ns1:System>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>PASS</ns1:status>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'          <ns1:CreacionCuentaOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/integration/SiebelSrvs/CreacionCuenta/Output/v1.0">'
                                +'              <ns1:ResponseHijos>'
                                +'                  <ns1:h_InvokeEJBURevChainOut>'
                                +'                      <ns1:h_response system="RevChain" operation="S" result="E">'
                                +'                          <ns1:h_faults>'
                                +'                              <ns1:h_subscriber_id> </ns1:h_subscriber_id>'
                                +'                              <ns1:h_account_id>a05560000003lS9AAI</ns1:h_account_id>'
                                +'                              <ns1:h_plan_impuestos>'
                                +'                                  <ns1:h_type_name>PLAN DE IMPUESTOS ETB LTE</ns1:h_type_name>'
                                +'                                  <ns1:h_tax_plan_vendor/>'
                                +'                              </ns1:h_plan_impuestos>'
                                +'                              <ns1:h_ciclo_facturacion>91</ns1:h_ciclo_facturacion>'
                                +'                              <ns1:h_fault_detail h_error_description="[RevChainSubscriberValidatorException: 2015-09-03 11:05:20.311 newtibco 17188 SubscriberDataRules.performValidation Parent Subscriber ID &apos;null&apos; is invalid for subscriber ID &apos;12050799499&apos; ]" h_error_code="17188"/>'
                                +'                          </ns1:h_faults>'
                                +'                      </ns1:h_response>'
                                +'                  </ns1:h_InvokeEJBURevChainOut>'
                                +'              </ns1:ResponseHijos>'
                                +'          </ns1:CreacionCuentaOutput>'
                                +'      </ns0:CreacionCuentaResponse>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponseActualizarCtasFact implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:WSOutputUpdateInvoiceData xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/UpdateInvoiceData/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System correlationID="a05560000003l97AAA2082015105214" processingServer=""/>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'                  <ns1:responseDate>2015-08-20T10:52:13.571-05:00</ns1:responseDate>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'          <ns1:UpdateInvoiceDataOutput xmlns:ns1="http://www.etb.com.co/LTE/Billing/UpdateInvoiceDataMsgs">'
                                +'              <ns1:Code>'+variablesMock.get('Code')+'</ns1:Code>'
                                +'              <ns1:Description>Invoice Data Updated.</ns1:Description>'
                                +'          </ns1:UpdateInvoiceDataOutput>'
                                +'      </ns0:WSOutputUpdateInvoiceData>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }   

// Response del servicio Web de Remedy

    global class MockHttpResponseRemedy implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:WSOutputCreateIncident xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/CreateIncident/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System correlationID="50056000000V87WAAS2882015113826" processingServer="?">?</ns1:System>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>PASS</ns1:status>'
                                +'                  <ns1:responseDate>2015-08-28T11:38:30.455-05:00</ns1:responseDate>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'              <ns1:OutputCreateIncident xmlns:ns1="http://www.etb.com.co/LTE/BillingCorporate/OutputCreateIncident">'
                                +'                  <ns1:requestID>INC000000003220</ns1:requestID>'
                                +'                  <ns1:acknowledge>Exitoso</ns1:acknowledge>'
                                +'                  <ns1:incidentStatus>Assigned</ns1:incidentStatus>'
                                +'              </ns1:OutputCreateIncident>'
                                +'      </ns0:WSOutputCreateIncident>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponsePlib implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:WSOutputCreateServiceOrder xmlns:ns0="http://www.etb.com.co/LTE/WS/DeviceManagement/CreateServiceOrder/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System correlationID="50056000000cJxfAAE292015165632" processingServer=""/>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'                  <ns1:responseDate>2015-09-02T16:56:30.547-05:00</ns1:responseDate>'
                                +'                  <ns1:statusDetail>'
                                +'                      <ns1:errorCode>'+variablesMock.get('errorCode')+'</ns1:errorCode>'
                                +'                      <ns1:errorMessage/>'
                                +'                  </ns1:statusDetail>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'          <ns1:OutputCreateServiceOrder xmlns:ns1="http://www.etb.com.co/LTE/LogisticsOperator/OutputCreateServiceOrder">'
                                +'              <ns1:ErrorCode/>'
                                +'          </ns1:OutputCreateServiceOrder>'
                                +'      </ns0:WSOutputCreateServiceOrder>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponseAprovisionamiento implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'<SOAP-ENV:Body>'
                                +'<ns0:WSDeliveryLTEResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/ProvisioningLTECorp/Delivery/OUT/1.0">'
                                +'<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'<ns1:System correlationID="a0956000000B2YwAAK" processingServer="Salesforce">Salesforce</ns1:System>'
                                +'<ns1:Service>'
                                +'<ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'<ns1:responseDate>2015-09-23T15:16:45.543-05:00</ns1:responseDate>'
                                +'</ns1:Service>'
                                +'<ns1:Property xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ProvisioningLTECorp/Delivery/IN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0" name="" value=""/>'
                                +'</ns1:WSResponseHeader>'
                                +'<ns1:DeliveryLTEResponse xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/ltecorp/delivery/response/v1.0">'
                                +'<ns1:OrderId>a0956000000B2YwAAK</ns1:OrderId>'
                                +'<ns1:TIBCOResponseCode>'+variablesMock.get('TIBCOResponseCode')+'</ns1:TIBCOResponseCode>'
                                +'<ns1:TIBCOResponseDescription>'+variablesMock.get('TIBCOResponseDescription')+'</ns1:TIBCOResponseDescription>'
                                +'</ns1:DeliveryLTEResponse>'
                                +'</ns0:WSDeliveryLTEResponse>'
                                +'</SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponseAprovisionamientoAPN implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'<SOAP-ENV:Body>'
                                +'<ns0:WsOutputProvisioningApn xmlns:ns0="http://www.etb.com.co/LTE/LTEServiceManagement/WsOutputProvisioningApn">'
                                +'<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'<ns1:System correlationID="08112016153448979338">CFG.ASAP</ns1:System>'
                                +'<ns1:Service>'
                                +'<ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'<ns1:responseDate>2015-09-23T15:16:45.543-05:00</ns1:responseDate>'
                                +'</ns1:Service>'
                                +'</ns1:WSResponseHeader>'
                                +'<ns1:OutProvisioningApn xmlns:ns1="http://www.etb.com.co/LTE/LTEServiceManagement/OutProvisioningApn">'
                                +'<ns1:Result>'
                                +'<ns1:Message_Result>closed.completed</ns1:Message_Result>'
                                +'<ns1:Code_Result>'+variablesMock.get('TIBCOResponseCode')+'</ns1:Code_Result>'
                                +'</ns1:Result>'
                                +'</ns1:OutProvisioningApn>'
                                +'</ns0:WsOutputProvisioningApn>'
                                +'</SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class MockHttpResponseDisponibilidad implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'<SOAP-ENV:Body>'
                                +'<ns0:WSAQOLTEResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/ProvisioningLTECorp/AvailabilitQueryOrder/OUT/1.0">'
                                +'<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'<ns1:System correlationID="'+variablesMock.get('correlationID')+'" processingServer="Salesforce">Salesforce</ns1:System>'
                                +'<ns1:Service>'
                                +'<ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'<ns1:responseDate>2015-09-09T09:15:05.936-05:00</ns1:responseDate>'
                                +'</ns1:Service>'
                                +'<ns1:Property/>'
                                +'</ns1:WSResponseHeader>'
                                +'<ns1:AQOLTEResponse xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/ltecorp/aqo/response/v1.0">'
                                +'<ns1:OrderId>'+variablesMock.get('correlationID')+'</ns1:OrderId>'
                                +'<ns1:TIBCOResponseCode>'+variablesMock.get('TIBCOResponseCode')+'</ns1:TIBCOResponseCode>'
                                +'<ns1:TIBCOResponseDescription>FACTIBLE</ns1:TIBCOResponseDescription>'
                                +'<ns1:Number>3057000524</ns1:Number>'
                                +'<ns1:IMSI>732187100000526</ns1:IMSI>'
                                +'<ns1:PIN>0000</ns1:PIN>'
                                +'<ns1:PUK>86147157</ns1:PUK>'
                                +'<ns1:PIN2>0026</ns1:PIN2>'
                                +'<ns1:PUK2>86147126</ns1:PUK2>'
                                +'</ns1:AQOLTEResponse>'
                                +'</ns0:WSAQOLTEResponse>'
                                +'</SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponseRevChain implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('RevChain');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:WSResponseSFRevchain xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/WSComplementoRevchain/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System correlationID="a0956000000AuocAAC" processingServer="Test">TIBCO</ns1:System>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'                  <ns1:responseDate>2015-09-08T11:10:28.107-05:00</ns1:responseDate>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'          <ns2:CanonicalMessage xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/framework/BusMessage/v1.0" xmlns:ns2="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
                                +'              <ns2:OrderFulfilment>'
                                +'                  <Sender xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0" xmlns="">'
                                +'                      <ID xmlns="">A</ID>'
                                +'                      <Description xmlns="">A</Description>'
                                +'                      <IPAddress xmlns="">A</IPAddress>'
                                +'                      <SenderMessageID xmlns="">A</SenderMessageID>'
                                +'                      <TransactionCode xmlns="">A</TransactionCode>'
                                +'                      <CallingServiceName xmlns="">A</CallingServiceName>'
                                +'                      <ApplicationID xmlns="">A</ApplicationID>'
                                +'                      <ApplicationVersion xmlns="">A</ApplicationVersion>'
                                +'                      <ContactName xmlns="">A</ContactName>'
                                +'                      <ContactEmail xmlns="">A</ContactEmail>'
                                +'                      <ContactPhoneNumber xmlns="">A</ContactPhoneNumber>'
                                +'                  </Sender>'
                                +'              </ns2:OrderFulfilment>'
                                +'              <ns2:BillingProcess>'
                                +'                  <CustomerBill xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0" xmlns="">'
                                +'                      <BillNo xmlns="">12050799456</BillNo>'
                                +'                      <SuscriberId xmlns="">12050799456</SuscriberId>'
                                +'                      <InvoicingCycle xmlns="">4</InvoicingCycle>'
                                +'                      <TaxPlan xmlns="">PLAN DE IMPUESTOS ETB LTE</TaxPlan>'
                                +'                      <Billable xmlns="">true</Billable>'
                                +'                      <BillBillingName xmlns="">SAMSUNG CP09 01.09.2015</BillBillingName>'
                                +'                      <CustomerBillSpec xmlns="">'
                                +'                          <DeliveryMethod xmlns="">Postal Service</DeliveryMethod>'
                                +'                      </CustomerBillSpec>'
                                +'                      <BillAmount xmlns="">'
                                +'                          <CurrencyCode xmlns="">COP</CurrencyCode>'
                                +'                      </BillAmount>'
                                +'                  </CustomerBill>'
                                +'                  <Tax xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0" xmlns="">'
                                +'                      <TaxAmount xmlns="">0</TaxAmount>'
                                +'                  </Tax>'
                                +'                  <BillingResponse xmlns="">'+variablesMock.get('BillingResponse')+'</BillingResponse>'
                                +'              </ns2:BillingProcess>'
                                +'          </ns2:CanonicalMessage>'
                                +'      </ns0:WSResponseSFRevchain>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }

    global class MockHttpResponseFormateador implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Formateador');

            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'  <SOAP-ENV:Body>'
                                +'      <ns0:WSOutputGetInvoiceFormat xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetInvoiceFormat/OUT/1.0">'
                                +'          <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'              <ns1:System correlationID="123456789-1492015164512">WS.BillingLTECorporate</ns1:System>'
                                +'              <ns1:Service>'
                                +'                  <ns1:status>'+variablesMock.get('status')+'</ns1:status>'
                                +'                  <ns1:responseDate>2015-09-14T16:45:06.751-05:00</ns1:responseDate>'
                                +'              </ns1:Service>'
                                +'          </ns1:WSResponseHeader>'
                                +'          <ns1:OutputGetInvoiceFormat xmlns:ns1="http://www.etb.com.co/LTE/BillingCorporate/OutputGetInvoiceFormat">'
                                +'              <ns1:mimeType>PDF</ns1:mimeType>'
                                +'              <ns1:fileName>'+variablesMock.get('fileName')+'</ns1:fileName>'
                                +'          </ns1:OutputGetInvoiceFormat>'
                                +'      </ns0:WSOutputGetInvoiceFormat>'
                                +'  </SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>';
                                
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class MockHttpResponseConsultaSuspenda implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('SuspendaConsulta');
                                
            String strResponse  = '<?xml version="1.0" encoding="UTF-8"?>'
									+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
									+	'<SOAP-ENV:Body>'
									+		'<ns0:QueryTramitsOutput xmlns:ns0="http://www.etb.com.co/schemas/collections/QueryTramitsOp.xsd">'
									+			'<ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
									+			'<ns1:System>'
									+					'<ns1:name>Tibco</ns1:name>'
									+					'<ns1:correlationID>"2018-02-06 21:08:55"</ns1:correlationID>'
									+					'<ns1:processingServer>Tibco MDM</ns1:processingServer>'
									+				'</ns1:System>'
									+				'<ns1:Service>'
									+					'<ns1:status>PASS</ns1:status>'
									+				'</ns1:Service>'
									+			'</ns1:WSResponseHeader2>'
									+			'<ns1:Outcomes xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/schemas/collections/QueryTramits.xsd">'
									+				'<ns1:Outcome>'
									+					'<ns1:Service>'
									+						'<ns1:connectionNumber>'+variablesMock.get('NumeroConexion')+'</ns1:connectionNumber>'
									+					'</ns1:Service>'
									+					'<ns1:WorkPlan>'
									+						'<ns1:code>'+variablesMock.get('CodigoRespuesta')+'</ns1:code>'
									+						'<ns1:description/>'
									+					'</ns1:WorkPlan>'
									+					'<ns1:Orders/>'
									+					'<ns1:Action>'
									+						'<ns1:code>'+variablesMock.get('CodigoRespuesta')+'</ns1:code>'
									+						'<ns1:description>'+variablesMock.get('DescripcionFlujo')+'</ns1:description>'
									+						'<ns1:reason/>'
									+					'</ns1:Action>'
									+				'</ns1:Outcome>'
									+			'</ns1:Outcomes>'
									+			'<ns0:Result>'
									+				'<ns0:code>SUCCESS</ns0:code>'
									+				'<ns0:description>SUCCESS</ns0:description>'
									+			'</ns0:Result>'
									+		'</ns0:QueryTramitsOutput>'
									+	'</SOAP-ENV:Body>'
									+'</SOAP-ENV:Envelope>';

                                
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class MockHttpResponseRegistroSuspenda implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('SuspendaRegistro');
                                
            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'                               
                                +'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wso="http://www.etb.com.co/LTE/WS/SuspensionsReconnections/RegistroSuspenda_Masivo/WSOutputRegistroSuspenda" xmlns:v1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0" xmlns:res="http://www.etb.com.co/LTE/WS/SuspensionsReconnections/RegistroSuspenda_Masivo/ResponseRegistroSuspenda">'
                                +'  <soapenv:Header/>'
                                +'  <soapenv:Body>'
                                +'      <wso:WSOutputRegistroSuspenda>'
                                +'          <v1:WSResponseHeader>'
                                +'              <v1:System correlationID="?" processingServer="?">?</v1:System>'
                                +'              <v1:Service>'
                                +'                  <v1:status>PASS</v1:status>'
                                +'                  <v1:responseDate>2016-02-12</v1:responseDate>'
                                +'                  <v1:statusDetail>'
                                +'                      <v1:errorCode>?</v1:errorCode>'
                                +'                      <v1:errorDetailCode>?</v1:errorDetailCode>'
                                +'                      <v1:errorMessage>?</v1:errorMessage>'
                                +'                  </v1:statusDetail>'
                                +'              </v1:Service>'
                                +'              <v1:Property name="?" value="?">?</v1:Property>'
                                +'          </v1:WSResponseHeader>'
                                +'          <res:ResponseRegistroSuspenda>'
                                +'              <res:NumerosConexion>'
                                +'                  <res:IdPedido>?</res:IdPedido>'
                                +'                  <res:CodigoRespuesta>?</res:CodigoRespuesta>'
                                +'                  <res:DescripcionRespuesta>?</res:DescripcionRespuesta>'
                                +'              </res:NumerosConexion>'
                                +'              <res:NumerosConexion>'
                                +'                  <res:IdPedido>?</res:IdPedido>'
                                +'                  <res:CodigoRespuesta>?</res:CodigoRespuesta>'
                                +'                  <res:DescripcionRespuesta>?</res:DescripcionRespuesta>'
                                +'              </res:NumerosConexion>'
                                +'          </res:ResponseRegistroSuspenda>'
                                +'      </wso:WSOutputRegistroSuspenda>'
                                +'  </soapenv:Body>'
                                +'</soapenv:Envelope>';
                                
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }
    
    
        global class MockHttpResponseConsultaIMEI implements HttpCalloutMock
    {
        global HTTPResponse respond(HTTPRequest req)
        {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('SuspendaRegistro');
                                
            String strResponse  ='<?xml version="1.0" encoding="UTF-8"?>'
								+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
								+'	<SOAP-ENV:Body>'
								+'		<ns0:WSResponseConsultaBDO'
								+'			xmlns:ns0="http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaBDO/OUT/1.0">'
								+'			<ns1:WSResponseHeader'
								+'				xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
								+'				<ns1:System correlationID="?" processingServer="TIBCO" />'
								+'				<ns1:Service>'
								+'					<ns1:status>'+variablesMock.get('status')+'</ns1:status>'
								+'					<ns1:responseDate>2016-07-21T15:41:46.723-05:00</ns1:responseDate>'
								+'				</ns1:Service>'
								+'			</ns1:WSResponseHeader>'
								+'			<ns1:ResponseBDO xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms"'
								+'				xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0"'
								+'				xmlns:ns1="http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaBDO/Output">'
								+'				<ns1:IMEI>356264061292803</ns1:IMEI>'
								+'				<ns1:Estado />'
								+'				<ns1:Marca>Q SMART</ns1:Marca>'
								+'				<ns1:CodigoRespuestaListas>'+variablesMock.get('CodigoRespuestaListas')+'</ns1:CodigoRespuestaListas>'
								+'				<ns1:Modelo>QS08</ns1:Modelo>'
								+'				<ns1:RespuestaGSMA>NO_4G</ns1:RespuestaGSMA>'
								+'				<ns1:ProbadoRedETB>NO</ns1:ProbadoRedETB>'
								+'				<ns1:RespuestaPruebaRedETB />'
								+'				<ns1:HomologadoColombia>NO EXISTE</ns1:HomologadoColombia>'
								+'				<ns1:TamanoSIM />'
								+'				<ns1:PartNumberSIM />'
								+'				<ns1:CodigoError>0</ns1:CodigoError>'
								+'				<ns1:DescripcionError />'
								+'			</ns1:ResponseBDO>'
								+'		</ns0:WSResponseConsultaBDO>'
								+'	</SOAP-ENV:Body>'
								+'</SOAP-ENV:Envelope>';
                                
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(200);
            return res;
        }
    }
}