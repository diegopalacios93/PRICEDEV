public with sharing class LTE_genXmlFormateador_cls {
	public LTE_genXmlFormateador_cls() {
		/*map<string,string> values = new map<string,string>();
		String request = generaXMLFormateador(values);
		
       String response1 = LibreriaUtilitaria_cls.consultarServicio(request,'/Service/BillingCorporate.serviceagent/soapEndpoint1/GetInvoiceFormat','http://201.245.171.239:7052/Service/BillingCorporate/Endpoint');
       system.debug('Response1-->'+response1);*/
	}
	
	public static string generaXMLFormateador(LTE_EnviarInfoFactEquipos_cls.DatosFormateador datosFacturador, String cadenaDetalle){ 
		string xml=''; 
		xml= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/BillingCorporate/GetInvoiceFormat/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/BillingCorporate/InputGetInvoiceFormat">'
			+'   <soapenv:Header/>'
			+'   <soapenv:Body>'
			+'      <ns:WSInputGetInvoiceFormat>'
			+'         <v1:WSRequestHeader>'
			+'            <v1:System correlationID="'+datosFacturador.correlationId+'" processingServer="?">WS.BillingLTECorporate</v1:System>'
			+'            <v1:Property name="?" value="?">?</v1:Property>'
			+'         </v1:WSRequestHeader>'
			+'         <inp:InputGetInvoiceFormat>'
			+'            <inp:clientName>'+datosFacturador.clientName+'</inp:clientName>'
			+'            <inp:clientNumber>'+datosFacturador.clientNumber+'</inp:clientNumber>'
			+'            <inp:invoiceNumber>'+datosFacturador.invoiceNumber+'</inp:invoiceNumber>'
			+'            <inp:invoiceDate>'+datosFacturador.invoiceDate+'</inp:invoiceDate>'
			+'            <inp:PIN1>'+datosFacturador.PIN1+'</inp:PIN1>'
			+'            <inp:PIN2>'+datosFacturador.PIN2+'</inp:PIN2>'
			+'            <inp:amount>'+datosFacturador.amount+'</inp:amount>'
			+'            <inp:IVA>'+datosFacturador.IVA+'</inp:IVA>'
			+'            <inp:totalAmount>'+datosFacturador.totalAmount+'</inp:totalAmount>'
			+'            <inp:invoiceDetail>';
			xml+=cadenaDetalle;
			xml+='</inp:invoiceDetail>'
			+'         </inp:InputGetInvoiceFormat>'
			+'      </ns:WSInputGetInvoiceFormat>'
			+'   </soapenv:Body>'
			+'</soapenv:Envelope>';
           //String encoded = EncodingUtil.urlEncode(xml, 'UTF-8');
		system.debug('xml-->'+xml);
		return xml;			
	}	
	
	public static string generaXMLFormateadorDummy(map<string,string> values){
		string xml='';
		xml= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/BillingCorporate/GetInvoiceFormat/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/BillingCorporate/InputGetInvoiceFormat">'
			+'   <soapenv:Header/>'
			+'   <soapenv:Body>'
			+'      <ns:WSInputGetInvoiceFormat>'
			+'         <v1:WSRequestHeader>'
			+'            <v1:System correlationID="234567" processingServer="?">?</v1:System>'
			+'            <!--Zero or more repetitions:-->'
			+'            <v1:Property name="?" value="?">?</v1:Property>'
			+'         </v1:WSRequestHeader>'
			+'         <inp:InputGetInvoiceFormat>'
			+'            <inp:clientName>Cliente Prueba</inp:clientName>'
			+'            <inp:clientNumber>NIT-8090909001</inp:clientNumber>'
			+'            <inp:invoiceNumber>9709090001</inp:invoiceNumber>'
			+'            <inp:invoiceDate>2015-01-01</inp:invoiceDate>'
			+'            <inp:PIN1>121212</inp:PIN1>'
			+'            <inp:PIN2>323232</inp:PIN2>'
			+'            <inp:amount>100000</inp:amount>'
			+'            <inp:IVA>16000</inp:IVA>'
			+'            <inp:totalAmount>116000</inp:totalAmount>'
			+'            <inp:invoiceDetail>'
			+'               <!--Zero or more repetitions:-->'
			+'               <inp:item>'
			+'                  <inp:description>iPhone 5|Simcard|iPhone 5|Simcard|iPhone 5|Simcard|iPhone 5|Simcard|iPhone 5|Simcard|Descuento</inp:description>'
			+'                  <inp:IMEI>1900001|9900001|1900002|9900002|1900003|9900003|1900004|9900004|1900005|9900005|10%</inp:IMEI>'
			+'                  <inp:deviceCost>20000|0|20000|0|20000|0|20000|0|20000|0|20000</inp:deviceCost>'
			+'                  <inp:IVA>3200|0|3200|0|3200|0|3200|0|3200|0</inp:IVA>'
			+'                  <inp:totalIVA>23200|0|23200|0|23200|0|23200|0|23200|0</inp:totalIVA>'
			+'               </inp:item>'
			+'            </inp:invoiceDetail>'
			+'         </inp:InputGetInvoiceFormat>'
			+'      </ns:WSInputGetInvoiceFormat>'
			+'   </soapenv:Body>'
			+'</soapenv:Envelope>';

		system.debug('xml-->'+xml);
		return xml;			
	}	
}