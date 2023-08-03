/**
 * @description       : 
 * @author            : Adrian Bohorquez
 * @group             : 
 * @last modified on  : 08-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   10-08-2021   Adrian Bohorquez   Initial Version
**/
public with sharing class DEG_LoginEmpresas_cls { 

    public class RequestInput {
        @AuraEnabled public String password {get;set;}
        @AuraEnabled public String mail {get;set;}
        @AuraEnabled public String sessionId {get;set;}
        @AuraEnabled public String tokenWatson {get;set;}
    }

    @AuraEnabled
    public static string authenticate(RequestInput login){
        System.debug('##login'+login);

        DEG_WrapperFrames_cls.RequestEmpresasLogin wsRequest = initRequest(login.mail, login.password, login.sessionId);
        System.debug('##Prueba'+wsRequest);
        String tokenFrames = '';
        Map<string,string> mapHeaders = new Map<string,string>();
        // if (Cache.Org.contains('tokenFrames')) {
        //     tokenFrames = (String)Cache.Org.get('tokenFrames');
        // }
        // else {
        //     tokenFrames = DEG_TokenFrames_cls.callOutToken();
        // }
        mapHeaders.put('Content-Type','application/json');
        // mapHeaders.put('Authorization', 'Bearer ' + tokenFrames);
        DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
        request.setHttpHeaders(mapHeaders);
        String body = JSON.Serialize(wsRequest);
        // String replaced = body.replace('Systema','System');
        request.setTextRequest(body);
        request.setUri('DEG_authetb');
        request.setNamedCredential('DEG_LoginEmpresasFrame');
        request.init();
		request.setTimeOut(120000);
        try {
            HttpResponse response = request.execute();
            if(response.getStatusCode() == 403){
                // DEG_TokenFrames_cls.callOutToken();
                return authenticate(login);
            }
            if(response.getStatusCode() == 200){

                // {"Respuesta": [{
                //     "Nombre_emp": null,
                //     "Nit": null,
                //     "UserName": null,
                //     "Cuenta": null,
                //     "Mensaje": "Consulta Exitosa",
                //     "ListaCuentas": null,
                //     "Resultado": null,
                //     "UrlGestionUnificada": null,
                //     "UrlMRTG": null
                //  }]}

                // [{
                //     "Nombre_emp": null,
                //     "Nit": null,
                //     "UserName": null,
                //     "Cuenta": null,
                //     "Mensaje": "Consulta Exitosa",
                //     "ListaCuentas": null,
                //     "Resultado": null,
                //     "UrlGestionUnificada": null,
                //     "UrlMRTG": null
                //  }]

                String rptBody = response.getBody();
                rptBody = rptBody.substringAfter(':').trim();  
                rptBody = rptBody.substringBeforeLast('}');  
                System.debug('##rptSubstring '+rptBody);                 
                System.debug(JSON.serialize(rptBody));
                System.debug('***Success***'); 
     
                String reqBody = '{'+
                '"idResponse": "LoginAuthCompanies",'+
                '"idConversacion":"'+login.sessionId+'",'+
                '"data":'+rptBody+
                '}';
                DEG_ResponseFrames_ws.createFrameResponse(reqBody, '', login.tokenWatson );
                System.debug('##reqBody '+reqBody);
                return reqBody;
            }
            else {
                System.debug('##response.getBody() '+response.getBody());
                return response.getBody();    
            }
        } catch (Exception e) {
            System.debug('Error Message: '+e.getMessage());
            System.debug('Error Line: '+e.getLineNumber());
            System.debug('***getCpuTime() consume catcht ***'+Limits.getCpuTime());
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static string cancelAuth(String sessionId, String token){
        String sResponse =  '{'+
                            '"idResponse": "LoginCancel",'+
                            '"data":{'+
                                '"login": false,'+
                                '"menssage":"autenticación cancelada"'+
                                '},'+
                            '"idConversacion":"'+sessionId+'"'+
                            '}';

        DEG_ResponseFrames_ws.createFrameResponse(sResponse, '', token );

        return sResponse;
    }


    public static DEG_WrapperFrames_cls.RequestEmpresasLogin initRequest(string mail, string password, String sessionId) {
        DEG_WrapperFrames_cls.RequestEmpresasLogin wsRequest = new DEG_WrapperFrames_cls.RequestEmpresasLogin();
        wsRequest.user = mail;
        wsRequest.password = password;
        wsRequest.idConversacion = sessionId ;
        return wsRequest;
    }

}