/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-31-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   01-12-2021   Harlinsson Chavarro (HCH)            Initial Version
**/
public class DEG_RequestManagement_cls {
    private final integer MAXCONT = 3;
    private integer cont = 1;
    private string httpMethod;
    private string namedCredential;
    private string azureWebsite;
    private String sRequest;
    private String uri;
    private String callFrom;
    private Map<string,object> mapRequest;
    private Map<string,string> mapHeaders;
    private DEG_HTTP_Client_cls httpClient;
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: constructor para inicialziar por defecto si no se envia parametros
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public DEG_RequestManagement_cls(){
    // Valores por default
        this.namedCredential='DEG_Bot_Transfer';
        this.azureWebsite='DEG_botdevPortallteqaAzurewebsites';
        this.httpMethod='POST';
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: constructor para inicialziar por defecto si se envia el parametro tipo String
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public DEG_RequestManagement_cls(String httpMethod){
        this.httpMethod=httpMethod;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner Class for setting the request
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setTextRequest(String sRequest){
        this.sRequest=sRequest;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Javier Tibamoza (JATC)
    Descripción: inner Class for setting the Named Credential
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setNamedCredential(String sNamedCredential){
        this.namedCredential=sNamedCredential;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Javier Tibamoza (JATC)
    Descripción: inner Class for setting the URI
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setUri(String sUri){
        this.uri=sUri;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Javier Tibamoza (JATC)
    Descripción: inner Class for setting the callFrom
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setCallFrom(String sCallFRom){
        this.callFrom=sCallFRom;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class for setting a map of request
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setMapRequest(Map<string,object> mapRequest){
        this.mapRequest=mapRequest;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class for setting timeoft of request in milliseconds
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setTimeOut(Integer milliseconds){
        this.httpClient.setTimeOut(milliseconds);
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class for setting all headers in the request
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void setHttpHeaders(Map<string,string> mapHeaders){
        this.mapHeaders=mapHeaders;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class for starting to create request, depending what parameter is recieve since bot
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public void init(String dialogue){
        if(dialogue == 'authMail'){
            setUri('DEG_AuthMail');
        }
        init();
    }
    public void init(){
        // Obtenemos la configuracion del WS al que vamos a consumir since metadata
        String path = '';
        Map<String, DEG_EndpointOquestador__mdt> mapEd = DEG_EndpointOquestador__mdt.getAll();
        // Preparamos el cliente HTTP
        path = mapEd.get(uri).DEG_EndpointName__c;
        this.httpClient = new  DEG_HTTP_Client_cls('callout:'+this.namedCredential+path,this.httpMethod);
        
        if(mapRequest!=null){
            httpClient.setBody(JSON.serializePretty(mapRequest));    
        }else if(sRequest!=null){
            httpClient.setBody(sRequest);
        }
        System.debug('##sRequest '+sRequest);
        
        if(mapHeaders==null) mapHeaders = new  Map<string,string>();
        // Agregamos la cabecera para JSON
        if(mapHeaders!=null) httpClient.setHeaders(mapHeaders);
    }

    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class for executing the request
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    
    public HttpResponse execute(){
        HttpResponse HttpResponse = this.httpClient.getResponse();
        if( HttpResponse.getStatusCode() == 401 && cont < MAXCONT ){
            mapHeaders.put('Authorization', 'Bearer ' + DEG_TokenFrames_cls.getTokenFrame() );
            cont ++;
            execute();
        }
        return HttpResponse;
    }

    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class for getting the http instance in the other class
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/

    public HttpRequest getHttpClient(){
        return this.httpClient.getRequest();
    }
    
}