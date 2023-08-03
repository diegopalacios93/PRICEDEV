/**
 * @description       : 
 * @author            : Pablo Arrieta
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   03-12-2021   Pablo Arrieta   Initial Version
**/
public with sharing class DEG_Login { 

    public class RequestInput {
        @AuraEnabled public String password {get;set;}
        @AuraEnabled public String mail {get;set;}
        @AuraEnabled public String sessionId {get;set;}
        @AuraEnabled public String tokenWatson {get;set;}
    }

    @AuraEnabled
    public static string authenticate(RequestInput login){
        string encrypted = DEG_Login.HashMD5(login.password);

        DEG_WrapperFrames_cls.wrapRequestToken wsRequest = DEG_Login.initRequest(login.mail, encrypted);
        String tokenFrames = '';
        Map<string,string> mapHeaders = new Map<string,string>();
        if (Cache.Org.contains('tokenFrames')) {
            tokenFrames = (String)Cache.Org.get('tokenFrames');
        }
        else {
            tokenFrames = DEG_TokenFrames_cls.callOutToken();
        }
        mapHeaders.put('Content-Type','application/json');
        mapHeaders.put('Authorization', 'Bearer ' + tokenFrames);
        DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
        request.setHttpHeaders(mapHeaders);
        String body = JSON.Serialize(wsRequest);
        String replaced = body.replace('Systema','System');
        request.setTextRequest(replaced);
        request.setUri('DEG_AuthMail');
        request.setNamedCredential('DEG_botdevPortallteqaAzurewebsites');
        request.init();
        try {
            HttpResponse response = request.execute();
            if(response.getStatusCode() == 403){
                DEG_TokenFrames_cls.callOutToken();
                return authenticate(login);
            }
            if(response.getStatusCode() == 200){
                String rptBody = response.getBody();
                System.debug(JSON.serialize(rptBody));
                System.debug('***Success***');
                String reqBody = '{'+
                '"idResponse": "LoginAuth",'+
                '"idConversacion":"'+login.sessionId+'",'+
                '"data":'+rptBody+
                '}';
                DEG_ResponseFrames_ws.createFrameResponse(reqBody, '', login.tokenWatson );
                return reqBody;
            }
            else {
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

    public static string HashMD5(string text) {
        Blob myBlob = Blob.valueOf(text);
        Blob md5hash = Crypto.generateDigest('MD5', myBlob);
        string encrypted = EncodingUtil.convertToHex(md5hash);
        return encrypted;
    }

    public static DEG_WrapperFrames_cls.wrapRequestToken initRequest(string mail, string password) {
        DEG_WrapperFrames_cls.wrapRequestToken wsRequest = new DEG_WrapperFrames_cls.wrapRequestToken();
        DEG_WrapperFrames_cls.WSRequestHeader oWSRequestHeader = new DEG_WrapperFrames_cls.WSRequestHeader();
        DEG_WrapperFrames_cls.Systema oSystema = new DEG_WrapperFrames_cls.Systema();
        List<DEG_WrapperFrames_cls.Property> lProperty = new List<DEG_WrapperFrames_cls.Property>();
        DEG_WrapperFrames_cls.WSRequestBody requestBody = new DEG_WrapperFrames_cls.WSRequestBody();
        DEG_WrapperFrames_cls.Audit oAudit = new DEG_WrapperFrames_cls.Audit();

        oSystema.name = 'MAX';
		oSystema.correlationID = 'DE-0001';
        oWSRequestHeader.Systema = oSystema;
        oWSRequestHeader.lProperty = lProperty;


        requestBody.Mail = mail;
        requestBody.Password = password;
        requestBody.Type = 'MAXMD5';
        oAudit.Canal = '1';
        oAudit.Id_Device = '1';
        oAudit.SO = '1';
        oAudit.IP_Address = '1';
        oAudit.IP_Latitude = '1';
        oAudit.IP_Longitude = '1';
        oAudit.WhatsApp_Phone_Number = '1';
        oAudit.Facebook_User = '1';
        oAudit.Twitter_User = '1';

        requestBody.Audit = oAudit;

        wsRequest.WSRequestBody = requestBody;
        wsRequest.WSRequestHeader = oWSRequestHeader;

        return wsRequest;
    }

}