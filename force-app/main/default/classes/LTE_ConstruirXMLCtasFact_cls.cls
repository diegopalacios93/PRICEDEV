/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE   
Description:            Clase encargada de armar los xml para el consumo de los servicios web de creación y edición cuentas de facturación y jerarquia de cuentas.                         
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     31/07/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
public class LTE_ConstruirXMLCtasFact_cls 
{	
	/**
    *   @Method: CrearXMLJerarquiaCuentaFact
    *   @param objJerarquiaCtas: objeto que contiene la información requerida para la creación de una cuenta de facturación padre y sus hijas si las tiene.      
    *   @return String: XML de request.
    *   @description: Se encarga de crear el string que contiene el XML para la creación de cuentas de facturación. 
    */
	public static String CrearXMLJerarquiaCuentaFact(LTE_SincronizacionCtasFact_Revchain_cls.JerarquiaCtas objJerarquiaCtas)
	{ 
		//Se llena el XML con la información que contiene el objeto objJerarquiaCtas.
		String strXml =	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SiebelSvrs/CreacionCuentaRequest/OUT/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/integration/SiebelSrvs/CreacionCuenta/Request/v1.0">'
						+'   <soapenv:Header/>'
						+'   <soapenv:Body>'
						+'      <ns:CreacionCuentaRequest>'
						+'         <v1:WSRequestHeader>'
						+'            <v1:System correlationID="' + objJerarquiaCtas.strCorrelationId + '" processingServer=""></v1:System>'
						+'            <v1:Property name="" value=""></v1:Property>'
						+'         </v1:WSRequestHeader>'
						+'         <v11:CreacionCuentaInput>'
						+'            <v11:EXT_MARKET_TYP>' + objJerarquiaCtas.strMarketType + '</v11:EXT_MARKET_TYP>'
						+'            <v11:GEO_CODE1>' + objJerarquiaCtas.strGeoCode1 + '</v11:GEO_CODE1>'
						+'            <v11:GEO_CODE2>' + objJerarquiaCtas.strGeoCode2 + '</v11:GEO_CODE2>'
						+'            <v11:GEO_CODE3></v11:GEO_CODE3>'
						+'            <v11:ORDER_TYPE>' + objJerarquiaCtas.strOrderType + '</v11:ORDER_TYPE>'
						+'            <v11:CT_NUM>' + objJerarquiaCtas.strNumCta + '</v11:CT_NUM>'
						+'            <v11:FD></v11:FD>'
						+'            <v11:CURR_CODE>' + objJerarquiaCtas.strCurrCode + '</v11:CURR_CODE>'
						+'            <v11:INV_DAY>' + objJerarquiaCtas.strInvDay + '</v11:INV_DAY>'
						+'            <v11:CONV_IND>' + objJerarquiaCtas.strConvInd + '</v11:CONV_IND>'
						+'            <v11:SUB_ID></v11:SUB_ID>'
						+'            <v11:PAYMENT_PRD></v11:PAYMENT_PRD>'
						+'            <v11:BILL_PRNT_SUB_ID>' + objJerarquiaCtas.strBillParent + '</v11:BILL_PRNT_SUB_ID>'
						+'            <v11:BILLABLE>' + objJerarquiaCtas.strBillable + '</v11:BILLABLE>'
						+'            <v11:DocType>' + objJerarquiaCtas.strDoctype + '</v11:DocType>'
						+'            <v11:start_date>'
						+'               <v11:month>' + objJerarquiaCtas.strMonth + '</v11:month>'
						+'               <v11:day>' + objJerarquiaCtas.strDay +  '</v11:day>'
						+'               <v11:year>'  + objJerarquiaCtas.strYear +'</v11:year>'
						+'            </v11:start_date>'
						+'            <v11:Customer>'
						+'               <v11:first_name></v11:first_name>'
						+'               <v11:second_name></v11:second_name>'
						+'               <v11:surname></v11:surname>'
						+'               <v11:last_name></v11:last_name>'
						+'               <v11:second_surname></v11:second_surname>'
						+'               <v11:subscriber_name>' + objJerarquiaCtas.strSubscriberName + '</v11:subscriber_name>'
						+'               <v11:BillBillingName>' + objJerarquiaCtas.strBillBillingName + '</v11:BillBillingName>'
						+'               <v11:ContactInfo>'
						+'                  <v11:PhoneNumber>' + objJerarquiaCtas.strPhoneNumber + '</v11:PhoneNumber>'
						+'                  <v11:ContactEmailAdd>' + objJerarquiaCtas.strContactEmail + '</v11:ContactEmailAdd>'
						+'                  <v11:DocumentNo>' + objJerarquiaCtas.strNumDocument + '</v11:DocumentNo>'
						+'               </v11:ContactInfo>'
						+'            </v11:Customer>'
						+'            <v11:Billing_address>'
						+'               <v11:LineOne>' + objJerarquiaCtas.strLineOne + '</v11:LineOne>'
						+'               <v11:CityName>' + objJerarquiaCtas.strCityName + '.</v11:CityName>'
						+'               <v11:StateCode>' + objJerarquiaCtas.strStateCode + '</v11:StateCode>'
						+'               <v11:postcode></v11:postcode>'
						+'               <v11:DaneCode>' + objJerarquiaCtas.strDaneCode + '</v11:DaneCode>'
						+'            </v11:Billing_address>'
						+'            <v11:invoice_delivery_name>' + objJerarquiaCtas.strInvoiceDelivery + '</v11:invoice_delivery_name>'
						+'            <v11:OrderSubType>' + objJerarquiaCtas.strOrderSubType + '</v11:OrderSubType>'
						+'            <v11:InvoiceMethod>' + objJerarquiaCtas.strInvoiceMethod + '</v11:InvoiceMethod>';

		// si el objeto objJerarquiaCtas contiene cuentas de facturación hijas en la lista se procede a crear el XML para dichas cuentas hijas.
		if(!objJerarquiaCtas.lstDatosCtasHijas.isEmpty())
		{
			system.debug('LISTA DE HIJAS------' + objJerarquiaCtas.lstDatosCtasHijas);
			for(LTE_SincronizacionCtasFact_Revchain_cls.DatosCtaFact objCtaFact : objJerarquiaCtas.lstDatosCtasHijas)
				strXml += CrearCuentaFactHija(objCtaFact);
		}
								            
		strXml +='         </v11:CreacionCuentaInput>'
				+'      </ns:CreacionCuentaRequest>'
				+'   </soapenv:Body>'
				+'</soapenv:Envelope>';
		system.debug('REQUEST------------>' + strXml);
		return strXml;

	}

	/**
    *   @Method: CrearCuentaFactHija
    *   @param objCtaFact: objeto que contiene todos los datos requeridos por el servicio web de creación de cuentas.      
    *   @return String: XML de request para una cuenta hija.
    *   @description: Se encarga de crear el string que contiene el XML para la creación de cuentas de facturación hijas. 
    */
	public static String CrearCuentaFactHija(LTE_SincronizacionCtasFact_Revchain_cls.DatosCtaFact objCtaFact)
	{
		//Se llena el XML con la información que contiene el objeto objCtaFact.
		String strXml ='<v11:CuentasHijo>'
						+'	<v11:h_CreacionCuentaInput>'
						+'		<v11:h_EXT_MARKET_TYP>' + objCtaFact.strMarketType + '</v11:h_EXT_MARKET_TYP>'
						+'		<v11:h_GEO_CODE1>' + objCtaFact.strGeoCode1 + '</v11:h_GEO_CODE1>'
						+'		<v11:h_GEO_CODE2>' + objCtaFact.strGeoCode2 + '</v11:h_GEO_CODE2>'
						+'		<v11:h_GEO_CODE3></v11:h_GEO_CODE3>'
						+'		<v11:h_ORDER_TYPE>' + objCtaFact.strOrderType + '</v11:h_ORDER_TYPE>'
						+'		<v11:h_CT_NUM>' + objCtaFact.strNumCta + '</v11:h_CT_NUM>'
						+'		<v11:h_FD></v11:h_FD>'
						+'		<v11:h_CURR_CODE>' + objCtaFact.strCurrCode + '</v11:h_CURR_CODE>'
						+'		<v11:h_INV_DAY>' + objCtaFact.strInvDay + '</v11:h_INV_DAY>'
						+'		<v11:h_CONV_IND>' + objCtaFact.strConvInd + '</v11:h_CONV_IND>'
						+'		<v11:h_SUB_ID>' + objCtaFact.strBillParent + '</v11:h_SUB_ID>'
						+'		<v11:h_PAYMENT_PRD></v11:h_PAYMENT_PRD>'
						+'		<v11:h_BILL_PRNT_SUB_ID>' + objCtaFact.strBillParent + '</v11:h_BILL_PRNT_SUB_ID>'
						+'		<v11:h_BILLABLE>' + objCtaFact.strBillable + '</v11:h_BILLABLE>'
						+'		<v11:h_DocType>' + objCtaFact.strDoctype + '</v11:h_DocType>'
						+'		<v11:h_start_date>'
						+'			<v11:h_month>' + objCtaFact.strMonth + '</v11:h_month>'
						+'			<v11:h_day>' + objCtaFact.strDay + '</v11:h_day>'
						+'			<v11:h_year>' + objCtaFact.strYear + '</v11:h_year>'
						+'		</v11:h_start_date>'
						+'		<v11:h_Customer>'
						+'			<v11:h_first_name></v11:h_first_name>'
						+'			<v11:h_second_name></v11:h_second_name>'
						+'			<v11:h_surname></v11:h_surname>'
						+'			<v11:h_last_name></v11:h_last_name>'
						+'			<v11:h_second_surname></v11:h_second_surname>'
						+'			<v11:h_subscriber_name>' + objCtaFact.strSubscriberName + '</v11:h_subscriber_name>'
						+'			<v11:h_BillBillingName>' + objCtaFact.strBillBillingName + '</v11:h_BillBillingName>'
						+'			<v11:h_ContactInfo>'
						+'				<v11:h_PhoneNumber>' + objCtaFact.strPhoneNumber + '</v11:h_PhoneNumber>'
						+'				<v11:h_ContactEmailAdd>' + objCtaFact.strContactEmail + '</v11:h_ContactEmailAdd>'
						+'				<v11:h_DocumentNo>' + objCtaFact.strNumDocument + '</v11:h_DocumentNo>'
						+'			</v11:h_ContactInfo>'
						+'		</v11:h_Customer>'
						+'		<v11:h_Billing_address>'
						+'			<v11:h_LineOne>' + objCtaFact.strLineOne + '</v11:h_LineOne>'
						+'			<v11:h_CityName>' + objCtaFact.strCityName + '</v11:h_CityName>'
						+'			<v11:h_StateCode>' + objCtaFact.strStateCode + '</v11:h_StateCode>'
						+'			<v11:h_postcode></v11:h_postcode>'
						+'			<v11:h_DaneCode>' + objCtaFact.strDaneCode + '</v11:h_DaneCode>'
						+'		</v11:h_Billing_address>'
						+'		<v11:h_invoice_delivery_name>' + objCtaFact.strInvoiceDelivery + '</v11:h_invoice_delivery_name>'
						+'		<v11:h_OrderSubType>' + objCtaFact.strOrderSubType + '</v11:h_OrderSubType>'
						+'		<v11:h_InvoiceMethod>' + objCtaFact.strInvoiceMethod + '</v11:h_InvoiceMethod>'
						+'	</v11:h_CreacionCuentaInput>'
						+'</v11:CuentasHijo>';
		return strXml;
	}

	/**
    *   @Method: XMLActualizarCuentaFact
    *   @param objEdicionCta: objeto que contiene todos los datos requeridos por el servicio web de actualización de cuentas.      
    *   @return String: XML de request para la actualización de una cuenta de facturación.
    *   @description: Se encarga de crear el string que contiene el XML para la actualizacipon de una cuenta de facturación. 
    */
	public static String XMLActualizarCuentaFact(LTE_ModificarCuentasFacturacion_cls.EdicionCuentas objEdicionCta)
	{
		//Se llena el XML con la información que contiene el objeto objEdicionCta.
		String strXml =	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/BillingCorporate/UpdateInvoiceData/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:upd="http://www.etb.com.co/LTE/Billing/UpdateInvoiceDataMsgs">'
						+'   <soapenv:Header/>'
						+'   <soapenv:Body>'
						+'      <ns:WSInputUpdateInvoiceData>'
						+'         <v1:WSRequestHeader>'
						+'            <v1:System correlationID="' + objEdicionCta.strCorrelationId + '" processingServer=""></v1:System>'
						+'            <v1:Property name="" value=""></v1:Property>'
						+'         </v1:WSRequestHeader>'
						+'         <upd:UpdateInvoiceDataInput>'
						+'            <upd:SubscriberId>' + objEdicionCta.strSubscriberId + '</upd:SubscriberId>'
						+'            <upd:BillingAddress>'
						+'               <upd:Address>' + objEdicionCta.strAddress + '</upd:Address>'
						+'               <upd:City>' + objEdicionCta.strCity + '</upd:City>'
						+'               <upd:CityCode>' + objEdicionCta.strCityCode + '</upd:CityCode>'
						+'               <upd:CountryCode>' + objEdicionCta.strCountryCode + '</upd:CountryCode>'
						+'               <upd:StateCode>' + objEdicionCta.strStateCode + '</upd:StateCode>'
						+'            </upd:BillingAddress>'
						+'            <upd:InvoiceMethod>'
						+'               <upd:DeliveryType>' + objEdicionCta.strDeliveryType + '</upd:DeliveryType>'
						+'               <upd:Email>' + objEdicionCta.strEmail + '</upd:Email>'
						+'               <upd:MethodName>' + objEdicionCta.strMethodName + '</upd:MethodName>'
						+'            </upd:InvoiceMethod>'
						+'         </upd:UpdateInvoiceDataInput>'
						+'      </ns:WSInputUpdateInvoiceData>'
						+'   </soapenv:Body>'
						+'</soapenv:Envelope>';
		system.debug('REQUEST------------>' + strXml);
		return strXml;
	}	
}