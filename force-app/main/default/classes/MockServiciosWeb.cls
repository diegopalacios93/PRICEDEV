/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraciones Clientes CUN
Descripción:			Clase Para la creacion de Mock Response de los servicios web
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		21-03-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
@isTest
global class MockServiciosWeb {
	
	public static string CodError='5013';
	public static Map<string,string> variablesMock=new Map<string,string>();

	global class MockHttpResponseRevchainOK implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        ServiciosWeb__c sw = ServiciosWeb__c.getValues('RevChain');
	        //System.assertEquals(sw.EndPoint__c, req.getEndpoint());
	        //System.assertEquals('POST', req.getMethod());
	        
	        // Create a fake response
	        string response='<?xml version="1.0" encoding="UTF-8"?>'
							+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
							+'   <SOAP-ENV:Body>'
							+'      <ns0:WSResponseSFRevchain xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/WSComplementoRevchain/OUT/1.0">'
							+'         <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
							+'            <ns1:System correlationID="AC-003666" processingServer="?"/>'
							+'            <ns1:Service>'
							+'               <ns1:status>'+variablesMock.get('status')+'</ns1:status>'
							+'               <ns1:responseDate>2015-02-04T18:27:27.101-05:00</ns1:responseDate>'
							+'            </ns1:Service>'
							+'         </ns1:WSResponseHeader>'
							+'         <ns1:CanonicalMessage xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'            <v11:OrderFulfilment xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'               <Sender>'
							+'                  <ID>SFDC</ID>'
							+'                  <Description>SFDC</Description>'
							+'                  <IPAddress>SFDC</IPAddress>'
							+'                  <SenderMessageID>SFDC</SenderMessageID>'
							+'                  <TransactionCode>SFDC</TransactionCode>'
							+'                  <CallingServiceName>SFDC</CallingServiceName>'
							+'                  <ApplicationID>SFDC</ApplicationID>'
							+'                  <ApplicationVersion>SFDC</ApplicationVersion>'
							+'                  <ContactName>SFDC</ContactName>'
							+'                  <ContactEmail>SFDC</ContactEmail>'
							+'                  <ContactPhoneNumber/>'
							+'               </Sender>'
							+'               <Identification>'
							+'                  <ID>AC-003666</ID>'
							+'                  <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                  <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                  <RevisionNumber>1</RevisionNumber>'
							+'               </Identification>'
							+'               <SalesOrder>'
							+'                  <OrderDateTime>2015-02-04T06:27:13-05:00</OrderDateTime>'
							+'                  <DeliveryDateTime>2015-02-04T06:27:13-05:00</DeliveryDateTime>'
							+'                  <TypeCode>Venta</TypeCode>'
							+'                  <FulfilmentPriorityCode>Medium</FulfilmentPriorityCode>'
							+'                  <FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>'
							+'                  <StatusCode>En Facturacion</StatusCode>'
							+'               </SalesOrder>'
							+'               <BusinessReference>'
							+'                  <Id>AC-003666</Id>'
							+'                  <ComponentId>AC-003666</ComponentId>'
							+'                  <ApplicationObjectKeyId>AC-003666</ApplicationObjectKeyId>'
							+'               </BusinessReference>'
							+'               <CustomerPartyAccount>'
							+'                  <Identification>'
							+'                     <ID>AC-003666</ID>'
							+'                     <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                     <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                  </Identification>'
							+'                  <Name>Empanadas y Buñuelos S.A</Name>'
							+'                  <Address>'
							+'                     <Identification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </Identification>'
							+'                     <LineOne>AC-003666</LineOne>'
							+'                     <CityName>BOGOTÁ, D.C.</CityName>'
							+'                     <StateName>BOGOTÁ, D.C.</StateName>'
							+'                     <CountryCode/>'
							+'                     <CountryName/>'
							+'                     <GisID/>'
							+'                     <Latitude/>'
							+'                     <Longitude/>'
							+'                     <CityCode>11001</CityCode>'
							+'                     <StateCode/>'
							+'                     <PurposeCode/>'
							+'                  </Address>'
							+'                  <ContactPerson>'
							+'                     <FirstName/>'
							+'                     <FamilyName/>'
							+'                     <CompleteNumber/>'
							+'                  </ContactPerson>'
							+'                  <TypeCode>JURIDICO</TypeCode>'
							+'                  <Custom>'
							+'                     <DocumentType>NIT</DocumentType>'
							+'                     <DocumentNumber>900788654</DocumentNumber>'
							+'                  </Custom>'
							+'               </CustomerPartyAccount>'
							+'               <Custom>'
							+'                  <OrderSubType>Venta</OrderSubType>'
							+'                  <SignedDocumentIndicator>true</SignedDocumentIndicator>'
							+'               </Custom>'
							+'               <PartyIdentification>'
							+'                  <ID>AC-003666</ID>'
							+'                  <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                  <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'               </PartyIdentification>'
							+'               <SalesOrderLine>'
							+'                  <Identification>'
							+'                     <ID>AC-003666</ID>'
							+'                     <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                     <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                  </Identification>'
							+'                  <OrderQuantity>1</OrderQuantity>'
							+'                  <ServiceActionCode>ADD</ServiceActionCode>'
							+'                  <FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>'
							+'                  <ParentSalesOrderLineIdentification>'
							+'                     <ID>AC-003666</ID>'
							+'                     <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                     <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                  </ParentSalesOrderLineIdentification>'
							+'                  <RootParentSalesOrderLineIdentification>'
							+'                     <ID>AC-003666</ID>'
							+'                     <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                     <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                  </RootParentSalesOrderLineIdentification>'
							+'                  <StatusCode>Orden Cumplida</StatusCode>'
							+'                  <ServiceAddress>'
							+'                     <Identification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </Identification>'
							+'                     <LineOne>AC-003666</LineOne>'
							+'                     <CityName>BOGOTÁ, D.C.</CityName>'
							+'                     <StateName>BOGOTÁ, D.C.</StateName>'
							+'                     <CountryCode/>'
							+'                     <CountryName>Colombia</CountryName>'
							+'                     <GisID/>'
							+'                     <Latitude/>'
							+'                     <Longitude/>'
							+'                     <CityCode>11001</CityCode>'
							+'                     <StateCode/>'
							+'                     <PurposeCode/>'
							+'                  </ServiceAddress>'
							+'                  <ItemReference>'
							+'                     <ItemIdentification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </ItemIdentification>'
							+'                     <Name>Datos Conectividad</Name>'
							+'                     <ServiceIndicator>false</ServiceIndicator>'
							+'                     <TypeCode>Datos Conectividad</TypeCode>'
							+'                     <NetworkIndicator>false</NetworkIndicator>'
							+'                     <PrimaryClassificationCode>no ip</PrimaryClassificationCode>'
							+'                     <ExternalServiceId>AC-003666</ExternalServiceId>'
							+'                  </ItemReference>'
							+'                  <SalesOrderSchedule>'
							+'                     <RequestedDeliveryDate>2015-02-04T06:27:13-05:00</RequestedDeliveryDate>'
							+'                     <ExpectedDeliveryDate>2015-02-04T06:27:13-05:00</ExpectedDeliveryDate>'
							+'                     <ShipTo>'
							+'                        <GisID/>'
							+'                        <Latitude/>'
							+'                        <Longitude/>'
							+'                        <CityCode/>'
							+'                        <StateCode/>'
							+'                        <PurposeCode/>'
							+'                        <Reference/>'
							+'                     </ShipTo>'
							+'                  </SalesOrderSchedule>'
							+'                  <OwnerPartyReference>'
							+'                     <ID>AC-003666</ID>'
							+'                     <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                     <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                  </OwnerPartyReference>'
							+'                  <ScheduleOrderIndicator>true</ScheduleOrderIndicator>'
							+'                  <SupplementaryInfo>'
							+'                     <Identification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </Identification>'
							+'                     <OrderQuantity>1</OrderQuantity>'
							+'                     <ServiceActionCode>ADD</ServiceActionCode>'
							+'                     <FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>'
							+'                     <ParentSalesOrderLineIdentification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </ParentSalesOrderLineIdentification>'
							+'                     <RootParentSalesOrderLineIdentification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </RootParentSalesOrderLineIdentification>'
							+'                     <StatusCode>AC-003666</StatusCode>'
							+'                     <ServiceAddress/>'
							+'                     <ItemReference>'
							+'                        <ItemIdentification>'
							+'                           <ID>1-JWPK</ID>'
							+'                           <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                           <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                        </ItemIdentification>'
							+'                        <Name>Cargo Fijo Conectividad Nal</Name>'
							+'                        <ServiceIndicator>true</ServiceIndicator>'
							+'                        <TypeCode>Cargo Fijo Conectividad Nal</TypeCode>'
							+'                        <NetworkIndicator>false</NetworkIndicator>'
							+'                        <PrimaryClassificationCode>no ip</PrimaryClassificationCode>'
							+'                        <ExternalServiceId>AC-003666</ExternalServiceId>'
							+'                     </ItemReference>'
							+'                     <SalesOrderSchedule>'
							+'                        <RequestedDeliveryDate>2015-02-04T06:27:13-05:00</RequestedDeliveryDate>'
							+'                        <ExpectedDeliveryDate>2015-02-04T06:27:13-05:00</ExpectedDeliveryDate>'
							+'                        <ShipTo/>'
							+'                     </SalesOrderSchedule>'
							+'                     <OwnerPartyReference>'
							+'                        <ID>A</ID>'
							+'                        <BusinessComponentID>A</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>A</ApplicationObjectKeyID>'
							+'                     </OwnerPartyReference>'
							+'                     <ScheduleOrderIndicator>true</ScheduleOrderIndicator>'
							+'                     <OrderSubType/>'
							+'                     <SignedDocumentsIndicator/>'
							+'                     <StartDateTime>02/04/2015 06:27:13</StartDateTime>'
							+'                     <Parameter>'
							+'                        <Name>Direccion Destino</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Capacidad</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Unidad de Capacidad</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Ciudad Destino</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Cargo</Name>'
							+'                        <Value>0.00</Value>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Direccion Origen</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Descuento</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <Parameter>'
							+'                        <Name>Ciudad Origen</Name>'
							+'                        <Value/>'
							+'                     </Parameter>'
							+'                     <RatePlan>'
							+'                        <Name>"Plan Conectividad Avanzada Nal"</Name>'
							+'                     </RatePlan>'
							+'                  </SupplementaryInfo>'
							+'                  <SupplementaryInfo>'
							+'                     <Identification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </Identification>'
							+'                     <OrderQuantity>1</OrderQuantity>'
							+'                     <ServiceActionCode>ADD</ServiceActionCode>'
							+'                     <FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>'
							+'                     <ParentSalesOrderLineIdentification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </ParentSalesOrderLineIdentification>'
							+'                     <RootParentSalesOrderLineIdentification>'
							+'                        <ID>AC-003666</ID>'
							+'                        <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                     </RootParentSalesOrderLineIdentification>'
							+'                     <StatusCode>AC-003666</StatusCode>'
							+'                     <ServiceAddress/>'
							+'                     <ItemReference>'
							+'                        <ItemIdentification>'
							+'                           <ID>1-JWPK</ID>'
							+'                           <BusinessComponentID>AC-003666</BusinessComponentID>'
							+'                           <ApplicationObjectKeyID>AC-003666</ApplicationObjectKeyID>'
							+'                        </ItemIdentification>'
							+'                        <Name>Compensacion Datos</Name>'
							+'                        <ServiceIndicator>true</ServiceIndicator>'
							+'                        <TypeCode>Compensacion Datos</TypeCode>'
							+'                        <NetworkIndicator>false</NetworkIndicator>'
							+'                        <PrimaryClassificationCode>no ip</PrimaryClassificationCode>'
							+'                        <ExternalServiceId>AC-003666</ExternalServiceId>'
							+'                     </ItemReference>'
							+'                     <SalesOrderSchedule>'
							+'                        <RequestedDeliveryDate>2015-02-04T06:27:13-05:00</RequestedDeliveryDate>'
							+'                        <ExpectedDeliveryDate>2015-02-04T06:27:13-05:00</ExpectedDeliveryDate>'
							+'                        <ShipTo/>'
							+'                     </SalesOrderSchedule>'
							+'                     <OwnerPartyReference>'
							+'                        <ID>A</ID>'
							+'                        <BusinessComponentID>A</BusinessComponentID>'
							+'                        <ApplicationObjectKeyID>A</ApplicationObjectKeyID>'
							+'                     </OwnerPartyReference>'
							+'                     <ScheduleOrderIndicator>true</ScheduleOrderIndicator>'
							+'                     <OrderSubType/>'
							+'                     <SignedDocumentsIndicator/>'
							+'                     <StartDateTime>02/04/2015 06:27:13</StartDateTime>'
							+'                     <RatePlan>'
							+'                        <Name>"Compensacion CAIP,ID,RAS,VPN,Seguridad 99.60"</Name>'
							+'                     </RatePlan>'
							+'                  </SupplementaryInfo>'
							+'                  <Discounts>'
							+'                     <Discount>'
							+'                        <Feature>'
							+'                           <TypeName/>'
							+'                           <Parameter>'
							+'                              <Name/>'
							+'                              <Value/>'
							+'                              <Description/>'
							+'                              <Validity/>'
							+'                           </Parameter>'
							+'                        </Feature>'
							+'                     </Discount>'
							+'                  </Discounts>'
							+'                  <SpecificationGroupXA>'
							+'                     <XAID/>'
							+'                     <ParentID/>'
							+'                     <ID/>'
							+'                     <ActionCode/>'
							+'                     <Name/>'
							+'                     <Value/>'
							+'                  </SpecificationGroupXA>'
							+'                  <Custom>'
							+'                     <PartNumber>A</PartNumber>'
							+'                     <AssetIntegrationID>AC-003666</AssetIntegrationID>'
							+'                  </Custom>'
							+'                  <Billing>'
							+'                     <BillKey/>'
							+'                     <ArrayIPs/>'
							+'                     <Permanence/>'
							+'                     <Quota/>'
							+'                     <FlowConfiguration/>'
							+'                  </Billing>'
							+'                  <AltKey>'
							+'                     <AltKeyName>USO</AltKeyName>'
							+'                     <AltKeyValue>\'Corp\'</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>Segmento</AltKeyName>'
							+'                     <AltKeyValue>\'\'</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>Subsegmento</AltKeyName>'
							+'                     <AltKeyValue>\'\'</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>BACON</AltKeyName>'
							+'                     <AltKeyValue>Colombia</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>BACYT</AltKeyName>'
							+'                     <AltKeyValue>BOGOTÁ, D.C.</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>BAAID</AltKeyName>'
							+'                     <AltKeyValue>AC-003666</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>BAADD</AltKeyName>'
							+'                     <AltKeyValue>Cll 100 # 49-20</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>PHONE</AltKeyName>'
							+'                     <AltKeyValue>7804560</AltKeyValue>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>BAUSO</AltKeyName>'
							+'                     <AltKeyValue/>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>ETBFN</AltKeyName>'
							+'                     <AltKeyValue/>'
							+'                  </AltKey>'
							+'                  <AltKey>'
							+'                     <AltKeyName>ETBLN</AltKeyName>'
							+'                     <AltKeyValue>Empanadas y Buñuelos S.A</AltKeyValue>'
							+'                  </AltKey>'
							+'               </SalesOrderLine>'
							+'               <ProvisioningResponse>Y</ProvisioningResponse>'
							+'            </v11:OrderFulfilment>'
							+'            <ns1:BillingProcess>'
							+'               <Customer xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'                  <FirstName>Empanadas y Buñuelos S.A</FirstName>'
							+'                  <Surname/>'
							+'                  <FullName>Empanadas y Buñuelos S.A</FullName>'
							+'                  <ContactInfo>'
							+'                     <FirstName/>'
							+'                     <LastName/>'
							+'                     <PhoneNumber>7804560</PhoneNumber>'
							+'                     <ContactAddress>'
							+'                        <LineOne/>'
							+'                        <CityName>BOGOTÁ, D.C.</CityName>'
							+'                        <StateName/>'
							+'                        <CountryCode/>'
							+'                        <CountryName/>'
							+'                        <GisID/>'
							+'                        <Latitude/>'
							+'                        <Longitude/>'
							+'                        <CityCode/>'
							+'                        <StateCode/>'
							+'                        <PurposeCode/>'
							+'                        <DaneCode>11001</DaneCode>'
							+'                        <Postcode/>'
							+'                        <GeoGroup/>'
							+'                     </ContactAddress>'
							+'                  </ContactInfo>'
							+'                  <MarketType>JURIDICO</MarketType>'
							+'                  <DocumentType>NIT</DocumentType>'
							+'                  <DocumentNo>900788654</DocumentNo>'
							+'               </Customer>'
							+'               <CustomerBill>'
							+'                  <BillNo>AC-003666</BillNo>'
							+'                  <SuscriberId>'+variablesMock.get('SuscriberId')+'</SuscriberId>'
							+'                  <InvoicingCycle>16</InvoicingCycle>'
							+'                  <TaxPlan/>'
							+'                  <Billable>true</Billable>'
							+'                  <BillBillingName>Empanadas y Buñuelos S.A</BillBillingName>'
							+'                  <CustomerBillSpec xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'                     <DeliveryMethod>Postal Service</DeliveryMethod>'
							+'                  </CustomerBillSpec>'
							+'                  <BillAmount xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'                     <CurrencyCode>COP</CurrencyCode>'
							+'                  </BillAmount>'
							+'                  <BillingAddress xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'                     <LineOne>Cll 100 # 49-20</LineOne>'
							+'                     <CityName>BOGOTÁ, D.C.</CityName>'
							+'                     <StateName>BOGOTÁ, D.C.</StateName>'
							+'                     <CountryCode>57</CountryCode>'
							+'                     <CountryName/>'
							+'                     <GisID/>'
							+'                     <Latitude/>'
							+'                     <Longitude/>'
							+'                     <CityCode/>'
							+'                     <StateCode>11</StateCode>'
							+'                     <PurposeCode/>'
							+'                     <DaneCode>11001</DaneCode>'
							+'                     <Postcode/>'
							+'                     <GeoGroup>11001</GeoGroup>'
							+'                  </BillingAddress>'
							+'               </CustomerBill>'
							+'               <Tax xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ns="http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
							+'                  <TaxAmount>0</TaxAmount>'
							+'               </Tax>'
							+'               <BillingResponse>'+variablesMock.get('billingResponse')+'</BillingResponse>'
							+'            </ns1:BillingProcess>'
							+'         </ns1:CanonicalMessage>'
							+'      </ns0:WSResponseSFRevchain>'
							+'   </SOAP-ENV:Body>'
							+'</SOAP-ENV:Envelope>';
	        System.debug('Ingresa mock');
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
	    }
	}
	
	global class MockHttpResponseCun implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        ServiciosWeb__c sw = ServiciosWeb__c.getValues('CodigoCun');
	        //System.assertEquals(sw.EndPoint__c, req.getEndpoint());
	        //System.assertEquals('POST', req.getMethod());
	        
	        // Create a fake response
	        string response='<?xml version="1.0" encoding="UTF-8"?>'
							+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
							+'	<SOAP-ENV:Body>'
							+'		<ns0:WSResponseAsignarCun xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/AsignarCun/OUT/1.0">'
							+'			<ns1:ResponseCUN xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/ConsultaCUN/RequestCUN/v1.0/AsignaResponseCUN.xsd">'
							+'				<ns1:NumCun>4347140000001684</ns1:NumCun>'
							+'				<ns1:FechaCun>08/04/2014 11:12:22 a.m.</ns1:FechaCun>'
							+'				<ns1:CodError>'+CodError+'</ns1:CodError>'
							+'			</ns1:ResponseCUN>'
							+'		</ns0:WSResponseAsignarCun>'
							+'	</SOAP-ENV:Body>'
							+'</SOAP-ENV:Envelope>';
	        System.debug('Ingresa mock');
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
	    }
	}


	global class MockHttpResponseScoreDeDatacredito implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        ServiciosWeb__c sw = ServiciosWeb__c.getValues('DataCredito');
	        //System.assertEquals(sw.EndPoint__c, req.getEndpoint());
	        //System.assertEquals('POST', req.getMethod());
	        
	        // Create a fake response
	        string response='<?xml version="1.0" encoding="UTF-8"?>'
							+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
							+'    <SOAP-ENV:Body>'
							+'        <ns0:WSResponseScoring xmlns:ns0="http://www.etb.com.co/LTE/WS/WebServiceConsultas/Scoring/OUT/1.0">'
							+'            <ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
							+'                <ns1:System correlationID="001f000000igAX3AAM" processingServer="WS.Consultas"/>'
							+'                <ns1:Service>'
							+'                    <ns1:status>PASS</ns1:status>'
							+'                </ns1:Service>'
							+'            </ns1:WSResponseHeader>'
							+'            <ns1:GestionClientes xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/GestionClientes">'
							+'                <head xmlns="">'
							+'                    <Interfaz xmlns=""/>'
							+'                    <Destino xmlns=""/>'
							+'                    <Respuesta xmlns="">'
							+'                        <ns1:CodigoRespuesta>VIGENTE</ns1:CodigoRespuesta>'
							+'                        <ns1:FechaRespuesta>2014-11-28-05:00</ns1:FechaRespuesta>'
							+'                        <ns1:CodigoError>'+CodError+'</ns1:CodigoError>'
							+'                    </Respuesta>'
							+'                </head>'
							+'                <body xmlns="">'
							+'                    <Cliente xmlns="">'
							+'                        <ns1:TipoDocumento>1</ns1:TipoDocumento>'
							+'                        <ns1:NumeroDocumento>9810887766</ns1:NumeroDocumento>'
							+'                        <ns1:EstadoDocumento>Hombre</ns1:EstadoDocumento>'
							+'                        <ns1:FechaExpedicionDocumento>04/30/2004</ns1:FechaExpedicionDocumento>'
							+'                        <ns1:DepartamentoExpedicionDocumento>CUNDINAMAR</ns1:DepartamentoExpedicionDocumento>'
							+'                        <ns1:Nombres>RICARDO ALFONSO</ns1:Nombres>'
							+'                        <ns1:PrimerApellido>LOPEZ</ns1:PrimerApellido>'
							+'                        <ns1:SegundoApellido>QUIÑONES</ns1:SegundoApellido>'
							+'                        <ns1:Genero>Score a la medida</ns1:Genero>'
							+'                        <ns1:Edad>22-28</ns1:Edad>'
							+'                        <ns1:Pais/>'
							+'                        <ns1:Ciudad>SANTAFE DE BOGO</ns1:Ciudad>'
							+'                        <ns1:Score>'
							+'                            <ns1:tipo>13</ns1:tipo>'
							+'                            <ns1:puntaje>600</ns1:puntaje>'
							+'                            <ns1:clasificacion>5</ns1:clasificacion>'
							+'                        </ns1:Score>'
							+'                    </Cliente>'
							+'                </body>'
							+'            </ns1:GestionClientes>'
							+'        </ns0:WSResponseScoring>'
							+'    </SOAP-ENV:Body>'
							+'</SOAP-ENV:Envelope>';
	        System.debug('Ingresa mock');
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
	    }
	}

	global class MockHttpResponseIMEIRegistroNegativo implements HttpCalloutMock {
	    // Implement this interface method
	    global HTTPResponse respond(HTTPRequest req) {
	        // Optionally, only send a mock response for a specific endpoint
	        // and method.
	        ServiciosWeb__c sw = ServiciosWeb__c.getValues('DesbloqueoIMEI');
	        //System.assertEquals(sw.EndPoint__c, req.getEndpoint());
	        //System.assertEquals('POST', req.getMethod());
	        
	        // Create a fake response
			string response='<?xml version="1.0" encoding="UTF-8"?>'
				+'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
				+'	<SOAP-ENV:Body>'
				+'		<ns0:WSResponseConsultaBDO xmlns:ns0="http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaBDO/OUT/1.0">'
				+'			<ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0">'
				+'				<ns1:System correlationID="?" processingServer="TIBCO"/>'
				+'				<ns1:Service>'
				+'					<ns1:status>PASS</ns1:status>'
				+'					<ns1:responseDate>2016-07-15T16:24:16.659-05:00</ns1:responseDate>'
				+'				</ns1:Service>'
				+'			</ns1:WSResponseHeader>'
				+'			<ns1:ResponseBDO xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaBDO/Output">'
				+'				<ns1:IMEI>354589658745155</ns1:IMEI>'
				+'				<ns1:Estado>Inválido</ns1:Estado>'
				+'				<ns1:Marca/>'
				+'				<ns1:CodigoRespuestaListas/>'
				+'				<ns1:Modelo/>'
				+'				<ns1:RespuestaGSMA/>'
				+'				<ns1:ProbadoRedETB/>'
				+'				<ns1:RespuestaPruebaRedETB/>'
				+'				<ns1:HomologadoColombia/>'
				+'				<ns1:TamanoSIM/>'
				+'				<ns1:PartNumberSIM/>'
				+'				<ns1:CodigoError>0</ns1:CodigoError>'
				+'				<ns1:DescripcionError/>'
				+'			</ns1:ResponseBDO>'
				+'		</ns0:WSResponseConsultaBDO>'
				+'	</SOAP-ENV:Body>'
				+'</SOAP-ENV:Envelope>';
	        System.debug('Ingresa mock');
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
	    }
	}
	
	
}