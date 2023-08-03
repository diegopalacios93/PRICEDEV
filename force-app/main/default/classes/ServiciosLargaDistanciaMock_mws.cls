/**
* Avanxo Colombia
* @author           Manuel Medina href=<mmedina@avanxo.com>
* Project:          ETB - Larga Distancia
* Description:      Clase tipo HttpCalloutMock para simular la respuesta de los servcios consumidos por el proceso de Larga Distancia.
*
* Changes (Version)
* -------------------------------------
*           No.     Date                    Author                  Description
*------------------------------------------------------------------------------------------------------------
* @version  1.0     20/11/2015              Manuel Medina (MM)      Definicion inicial del mockService.
*************************************************************************************************************/
@isTest
global class ServiciosLargaDistanciaMock_mws implements HttpCalloutMock {
    
    global Map<String, HTTPResponse> mapHTTPResponseByHTTPSOAPActionHeader          = new Map<String, HTTPResponse>();
    
    global HTTPResponse respond( HTTPRequest httpREQ ) {
        
        /* BEGIN - RESPONSE - Header SOAPAction = ConnectionNumberOp */
        HttpResponse httpRESConnectionNumberOp                                      = new HttpResponse();
        httpRESConnectionNumberOp.setHeader( 'Content-Type', 'application/json' );
        httpRESConnectionNumberOp.setBody( '<?xml version="1.0" encoding="UTF-8"?>' +
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:WSConexionNumbereResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/ConnectionNumber/OUT/1.0">' +
                        '<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">' +
                            '<ns1:System>TIBCO</ns1:System>' +
                            '<ns1:Service>' +
                                '<ns1:status>PASS</ns1:status>' +
                            '</ns1:Service>' +
                        '</ns1:WSResponseHeader>' +
                        '<ns2:ConexionNumberResponse xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns2="http://WSSalesForceLD.etb.com/LD" xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">' +
                            '<return xmlns="">{"service_particulars":[{"connection_number":"12345678","service_id":"8116090","feat_nm_ld":"","external_service_id":"27685657","error_code":"E0006","subscriber_id":"6421571","bill_run_State":"I","rate_plan_name":"","fd":"","lsp_name":"E.T.B.","billing_entity_id":"19","rate_plan_name_cupo":"","billable_parent_id":"4363202","error_description":"La cuenta validada, no tiene asociados los productos esperados","parent_id":"4363202"},{"connection_number":"12345679","service_id":"8116090","feat_nm_ld":"","external_service_id":"27685657","error_code":"E0006","subscriber_id":"6421571","bill_run_State":"I","rate_plan_name":"","fd":"","lsp_name":"E.T.B.","billing_entity_id":"19","rate_plan_name_cupo":"","billable_parent_id":"4363202","error_description":"La cuenta validada, no tiene asociados los productos esperados","parent_id":"4363202"}],"numero_tramite":2315}</return>' +
                        '</ns2:ConexionNumberResponse>' +
                    '</ns0:WSConexionNumbereResponse>' +
                '</SOAP-ENV:Body>' +
            '</SOAP-ENV:Envelope>'
        );
        httpRESConnectionNumberOp.setStatusCode(200);
        this.mapHTTPResponseByHTTPSOAPActionHeader.put( 'ConnectionNumberOp', httpRESConnectionNumberOp );
        /* END - RESPONSE - Header SOAPAction = ConnectionNumberOp */
        
        /* BEGIN - RESPONSE - Header SOAPAction = CreacionCuenta */
        HttpResponse httpRESCreacionCuenta                                          = new HttpResponse();
        httpRESCreacionCuenta.setHeader( 'Content-Type', 'application/json' );
        httpRESCreacionCuenta.setBody( '<?xml version="1.0" encoding="UTF-8"?>' +
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:CreacionCuentaResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/SiebelSvrs/CreacionCuentaResponse/OUT/1.0">' +
                        '<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">' +
                            '<ns1:System>TIBCO</ns1:System>' +
                            '<ns1:Service>' +
                                '<ns1:status>PASS</ns1:status>' +
                            '</ns1:Service>' +
                        '</ns1:WSResponseHeader>' +
                        '<ns1:CreacionCuentaOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/integration/SiebelSrvs/CreacionCuenta/Output/v1.0">' +
                            '<ns1:InvokeEJBURevChainOut>' +
                                '<ns1:response system="RevChain" operation="S" result="S">' +
                                    '<ns1:faults>' +
                                        '<ns1:subscriber_id>12050800477</ns1:subscriber_id>' +
                                        '<ns1:account_id/>' +
                                        '<ns1:plan_impuestos>' +
                                            '<ns1:type_name>PLAN DE IMPUESTOS ETB LOCAL</ns1:type_name>' +
                                        '<ns1:tax_plan_vendor/>' +
                                        '</ns1:plan_impuestos>' +
                                        '<ns1:ciclo_facturacion>18</ns1:ciclo_facturacion>' +
                                        '<ns1:fault_detail error_description="operation is successful" error_code="0"/>' +
                                    '</ns1:faults>' +
                                '</ns1:response>' +
                            '</ns1:InvokeEJBURevChainOut>' +
                        '</ns1:CreacionCuentaOutput>' +
                    '</ns0:CreacionCuentaResponse>' +
                '</SOAP-ENV:Body>' +
            '</SOAP-ENV:Envelope>'
        );
        httpRESCreacionCuenta.setStatusCode(200);
        this.mapHTTPResponseByHTTPSOAPActionHeader.put( 'CreacionCuenta', httpRESCreacionCuenta );
        /* END - RESPONSE - Header SOAPAction = CreacionCuenta */
        
        /* BEGIN - RESPONSE - Header SOAPAction = AccountIdOp */
        HttpResponse httpRESAccountIdOp                                         = new HttpResponse();
        httpRESAccountIdOp.setHeader( 'Content-Type', 'application/json' );
        httpRESAccountIdOp.setBody( '<?xml version="1.0" encoding="UTF-8"?>' +
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:WSAccountIdResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/AccountId/OUT/1.0">' +
                        '<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">' +
                            '<ns1:System>TIBCO</ns1:System>' +
                            '<ns1:Service>' +
                                '<ns1:status>PASS</ns1:status>' +
                            '</ns1:Service>' +
                        '</ns1:WSResponseHeader>' +
                        '<ns2:AcountIdResponse xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns2="http://WSSalesForceLD.etb.com/LD" xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">' +
                            '<return xmlns="">{"service_particulars":[{"service_id":"","billing_entity_id":"18","external_service_id":"","error_code":"E0005","subscriber_id":"12050800477","bill_run_State":"I","error_description":"La cuenta validada, no tiene asociados los servicios esperados","rate_plan_name":""}],"numero_tramite":2277}</return>' +
                        '</ns2:AcountIdResponse>' +
                    '</ns0:WSAccountIdResponse>' +
                '</SOAP-ENV:Body>' +
            '</SOAP-ENV:Envelope>'
        );
        httpRESAccountIdOp.setStatusCode(200);
        this.mapHTTPResponseByHTTPSOAPActionHeader.put( 'AccountIdOp', httpRESAccountIdOp );
        /* END - RESPONSE - Header SOAPAction = AccountIdOp */
        
        /* BEGIN - RESPONSE - Header SOAPAction = SFRevChainOP */
        HttpResponse httpRESSFRevChainOP                                         = new HttpResponse();
        httpRESSFRevChainOP.setHeader( 'Content-Type', 'application/json' );
        httpRESSFRevChainOP.setBody( '<?xml version="1.0" encoding="UTF-8"?>'
                                +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'	<SOAP-ENV:Body>'
                                +'		<ns0:WSResponseSFRevchain xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/WSComplementoRevchain/OUT/1.0">'
                                +'			<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
                                +'				<ns1:System correlationID="VCU-1312" processingServer="?">TIBCO</ns1:System>'
                                +'				<ns1:Service>'
                                +'					<ns1:status>PASS</ns1:status>'
                                +'					<ns1:responseDate>2016-06-13T16:11:29.053-05:00</ns1:responseDate>'
                                +'				</ns1:Service>'
                                +'			</ns1:WSResponseHeader>'
                                +'			<ns2:CanonicalMessage xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/framework/BusMessage/v1.0" xmlns:ns2="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
                                +'				<ns2:OrderFulfilment>'
                                +'					<SalesOrderLine xmlns="">'
                                +'						<AltKey xmlns="">'
                                +'							<Id xmlns="">AC-607683</Id>'
                                +'							<AltKeyName xmlns="">RESULT REVCHAIN</AltKeyName>'
                                +'							<AltKeyValue xmlns="">SUCCESS</AltKeyValue>'
                                +'						</AltKey>'
                                +'					</SalesOrderLine>'
                                +'					<ProvisioningResponse xmlns="">Y</ProvisioningResponse>'
                                +'				</ns2:OrderFulfilment>'
                                +'			</ns2:CanonicalMessage>'
                                +'		</ns0:WSResponseSFRevchain>'
                                +'	</SOAP-ENV:Body>'
                                +'</SOAP-ENV:Envelope>'
        );
        httpRESSFRevChainOP.setStatusCode(200);
        this.mapHTTPResponseByHTTPSOAPActionHeader.put( 'SFRevChainOP', httpRESSFRevChainOP );
        /* END - RESPONSE - Header SOAPAction = AccountIdOp */
        
        System.debug( '\n\n\n@@--> SOAPAction > ' + httpREQ.getHeader( 'SOAPAction' ).substringAfterLast( '/' ) + '\n\n' );
        System.debug( '\n\n\n@@--> mapHTTPResponseByHTTPSOAPActionHeader > ' + mapHTTPResponseByHTTPSOAPActionHeader + '\n\n' );
        
        return mapHTTPResponseByHTTPSOAPActionHeader.get( httpREQ.getHeader( 'SOAPAction' ).substringAfterLast( '/' ) );
    }
}