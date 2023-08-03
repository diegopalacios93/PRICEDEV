@IsTest
public class ParaPruebasWSDL_tst {
    
    static testMethod void test(){
        try {
	    	LibreriaUtilitariaJobs_cls.ErrorExcepcionTest=true;
	        ParaPruebasWSDL p=new ParaPruebasWSDL();
        	p.prueba();        	
        	ParaPruebasWSDL.makeRequestNow('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SiebelSvrs/CreacionCuentaRequest/OUT/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/integration/SiebelSrvs/CreacionCuenta/Request/v1.0"> <soapenv:Header/> <soapenv:Body> <ns:CreacionCuentaRequest> <v1:WSRequestHeader> <v1:System correlationID="a04f0000006LZFtAAO29092015" processingServer=""></v1:System> <v1:Property name="" value=""></v1:Property> </v1:WSRequestHeader> <v11:CreacionCuentaInput> <v11:EXT_MARKET_TYP>JURIDICO EMPRESAS</v11:EXT_MARKET_TYP> <v11:GEO_CODE1>11000000</v11:GEO_CODE1> <v11:GEO_CODE2>1</v11:GEO_CODE2> <v11:GEO_CODE3></v11:GEO_CODE3> <v11:ORDER_TYPE>VENTA</v11:ORDER_TYPE> <v11:CT_NUM></v11:CT_NUM> <v11:FD></v11:FD> <v11:CURR_CODE>COP</v11:CURR_CODE> <v11:INV_DAY>0</v11:INV_DAY> <v11:CONV_IND>8</v11:CONV_IND> <v11:SUB_ID></v11:SUB_ID> <v11:PAYMENT_PRD>15</v11:PAYMENT_PRD> <v11:BILL_PRNT_SUB_ID>null</v11:BILL_PRNT_SUB_ID> <v11:BILLABLE>Y</v11:BILLABLE> <v11:DocType>NIT</v11:DocType> <v11:start_date> <v11:month>09</v11:month> <v11:day>29</v11:day> <v11:year>2015</v11:year> </v11:start_date> <v11:Customer> <v11:first_name></v11:first_name> <v11:second_name></v11:second_name> <v11:surname></v11:surname> <v11:last_name></v11:last_name> <v11:second_surname></v11:second_surname> <v11:subscriber_name>PANELA DEL VALLE</v11:subscriber_name> <v11:BillBillingName>PANELA DEL VALLE</v11:BillBillingName> <v11:ContactInfo> <v11:PhoneNumber>23599530 ext 123</v11:PhoneNumber> <v11:ContactEmailAdd></v11:ContactEmailAdd> <v11:DocumentNo>830777999</v11:DocumentNo> </v11:ContactInfo> </v11:Customer> <v11:Billing_address> <v11:LineOne>cr 3 22 33</v11:LineOne> <v11:CityName>BOGOTA D.C..</v11:CityName> <v11:StateCode></v11:StateCode> <v11:postcode></v11:postcode> <v11:DaneCode>11000</v11:DaneCode> </v11:Billing_address> <v11:invoice_delivery_name>Postal Service</v11:invoice_delivery_name> <v11:OrderSubType></v11:OrderSubType> <v11:InvoiceMethod></v11:InvoiceMethod> </v11:CreacionCuentaInput> </ns:CreacionCuentaRequest> </soapenv:Body></soapenv:Envelope>', 'POST', 'https://request.com');      	
        	p.enviar();
        } catch(Exception e) {
        	System.debug(e.getMessage());
        }
       
    }
    

}