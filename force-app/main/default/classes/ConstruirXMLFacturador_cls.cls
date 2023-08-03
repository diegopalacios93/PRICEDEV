/**************************************************************************************************
Desarrollado por: Accenture
Autores: Mary Florio
Proyecto: ETB MiPymes y Empresas        
Descripción: Construcción de clase para armar XML request y response para la integración hacia facturador (Promociones, descuentos) 
Salesforce-Tibco --> Tibco-Rechain y almacenamiento del log en el objeto LogTransacciones__c 
Clase test: ConstruirXMLFacturador_tst
 
Cambios (Versiones)
-------------------------------------
No.     Fecha           Autores                Descripción
1.0     07/03/2021      Mary Florio   
***************************************************************************************************/

public class ConstruirXMLFacturador_cls {

    // argumento Lista entregada por el Bach con los registros a procesar   
    public static String CrearXMLFactEnviarProm(PromocionAplicada__c registro, String sfeature){
        string subscriber = registro.Operacion_Comercial__r.CuentaFacturacion__r.Name; 
        string external_service_id = registro.Operacion_Comercial__r.Activo__r.ExternalServiceID__c;
        string feature_name = sfeature;
        Integer Descuento = registro.Descuento__c.intValue();
        date active_date = Date.today();
        date start_Date = registro.Fecha_Inicio__c;
        date end_date = registro.Fecha_Fin__c;
		
        //llenado del XML
        String strXml = '<?xml version="1.0" encoding="UTF-8"?>'+
                      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
                          '<soapenv:Header />'+
                          '<soapenv:Body>'+
                              '<inv:InvokeServiceProvisioningInput xmlns:inv="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp">'+
                                  '<v1:WSRequestHeader2 xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0">' +
                                      '<v1:System>'+
                                          '<v1:name>Salesforce</v1:name>'+
                                          '<v1:correlationID>'+registro.Operacion_Comercial__c+'</v1:correlationID>'+
                                          '<v1:processingServer>Tibco</v1:processingServer>'+
                                      '</v1:System>'+
                                  '</v1:WSRequestHeader2>'+
                                  '<inv:BodyRequest>'+
                                      '<ser:services xmlns:ser="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/ServiceProvisioning">'+
                                          '<ser:service_particulars>'+
                                              '<ser:subscriber_id>'+subscriber+'</ser:subscriber_id>'+
                                              '<ser:service>'+
                                                  '<ser:finder>'+
                                                      '<ser:external_service_id>'+external_service_id+'</ser:external_service_id>'+
                                                      '<ser:active_date>'+
                                                          '<ser:month>'+active_date.month()+'</ser:month>'+
                                                          '<ser:day>'+active_date.day()+'</ser:day>'+
                                                          '<ser:year>'+active_date.year()+'</ser:year>'+
                                                      '</ser:active_date>'+
                                                  '</ser:finder>'+
                                                  '<ser:feature>'+
                                                      '<ser:finder>'+
                                                          '<ser:active_date>'+
                                                              '<ser:month>'+active_date.month()+'</ser:month>'+
                                                              '<ser:day>'+active_date.day()+'</ser:day>'+
                                                              '<ser:year>'+active_date.year()+'</ser:year>'+
                                                          '</ser:active_date>'+
                                                      '</ser:finder>'+
                                                      '<ser:feature_type_name>'+feature_name+'</ser:feature_type_name>'+
                                                      '<ser:parameter action="modify">'+
                                                          '<ser:parameter_type_name>Descuento DS</ser:parameter_type_name>'+
                                                          '<ser:parameter_value>'+Descuento+'.0000</ser:parameter_value>'+
                                                            '<ser:start_date>'+
                                                              '<ser:month>'+start_Date.month()+'</ser:month>'+
                                                              '<ser:day>'+start_Date.day()+'</ser:day>'+
                                                              '<ser:year>'+start_Date.year()+'</ser:year>'+
                                                            '</ser:start_date>'+
                                                            '<ser:end_date>'+
                                                              '<ser:month>'+end_date.month()+'</ser:month>'+
                                                              '<ser:day>'+end_date.day()+'</ser:day>'+
                                                              '<ser:year>'+end_date.year()+'</ser:year>'+
                                                            '</ser:end_date>'+
                                                      '</ser:parameter>'+
                                                  '</ser:feature>'+
                                              '</ser:service>'+
                                          '</ser:service_particulars>'+
                                      '</ser:services>'+
                                  '</inv:BodyRequest>'+
                              '</inv:InvokeServiceProvisioningInput>'+
                          '</soapenv:Body>'+
                      '</soapenv:Envelope>';
      return strXml;
    }

    public static String obtnerResponseTest(){
      String xmlResponse = '<?xml version="1.0" encoding="UTF-8"?>'
      +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
        +  '<SOAP-ENV:Body>'
            +'<ns0:InvokeServiceProvisioningOutput xmlns:ns0="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp">'
                +  '<ns2:WSResponseHeader2'
                    +' xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"'
                    +' xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms"'
                    +' xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0"'
                    +' xmlns:ns1="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp">'
                    +'<ns2:System>'
                      +'<ns2:name>Tibco</ns2:name>'
                        +'<ns2:correlationID>a094y00000WK8BUAA1</ns2:correlationID>'
                        +'<ns2:processingServer>Tibco</ns2:processingServer>'
                      +'</ns2:System>'
                      +'<ns2:Service>'
                        +'<ns2:status>PASS</ns2:status>'
                        +'<ns2:responseDate>2022-02-21T12:03:20.898-05:00</ns2:responseDate>'
                    +'</ns2:Service>'
                  +'</ns2:WSResponseHeader2>'
                  +'<ns0:BodyResponse>'
                        +'<ns1:response system="RevChain" operation="P" result="S" xmlns:ns1="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/RVCResponse" />'
                  +'</ns0:BodyResponse>'
              +'</ns0:InvokeServiceProvisioningOutput>'
          +'</SOAP-ENV:Body>'
      +'</SOAP-ENV:Envelope>';
      return xmlResponse;
    }
}