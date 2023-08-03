public with sharing class ParaPruebasWSDL {
	
	public string xml{get;set;}
	public string xmlResp{get;set;}
	public string metodo{get;set;}
	public string endpoint{get;set;}
	
	public Pagereference enviar(){
	
		try{
			xmlResp=makeRequestNow(xml, metodo, endpoint);
			
			
		}catch(exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
		}
		
	return null;
	}
	
	public static string makeRequestNow(string xml,string metodo,string endpoint){

		System.debug(metodo);
		
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        //req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(this.accountSid + ':' + this.authToken)));
        req.setBody(xml);
 
        req.setEndpoint(endpoint);
 
        string bodyRes = '';
        
        HttpResponse res;

        try {
            res = h.send(req);
            bodyRes = res.getBody();
            }
            catch(System.CalloutException e) {
            }
        
        return bodyRes;
 
       }
       
       public void prueba(){
       	
       	string xml='<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sol="http://xapps.tial.com.co/webservices/solicitud/"><soap:Body><sol:parSol><id>MovistarSalesforce</id><nDoc>VPGC-39067-2014</nDoc></sol:parSol></soap:Body></soap:Envelope>';
       	string endpoint='http://requestb.in/1k8n4d31';
       	string metodo='solicitud';
       	
       	string respuesta=makeRequestNow(xml, metodo, endpoint);
       	
       
       }

}