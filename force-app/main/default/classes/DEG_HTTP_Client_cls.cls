/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-24-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   01-12-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class DEG_HTTP_Client_cls {
    private Http http;
    private HttpRequest client;

    public DEG_HTTP_Client_cls(string endpoint,string httpMethod){
        this.client= new  HttpRequest();
        client.setTimeout(15000);
        client.setEndpoint(endpoint);
        client.setMethod(httpMethod);
    }
    
    public void setHeaders(Map<string,string> mapHeaders){
        for(string key:mapHeaders.keySet()){
            client.setHeader(key,mapHeaders.get(key));
        }
    }
    
    public void setBody(string jsonBody){
        client.setBody(jsonBody);
    }
    
    public void setTimeOut(Integer milliseconds){
        client.setTimeout(milliseconds);
    }
    
    public HttpResponse getResponse(){
        http=new Http();
        HttpResponse resp = http.send(client);
        if( resp.getStatusCode() == 401 ){
            DEG_TokenFrames_cls.callOutToken();
        }
        return resp;
    }
	
    public HttpRequest getRequest(){
        return client;
    }
}