/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-05-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   01-20-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
public with sharing class DEG_GetTokenWatson_ws {
    public static String callTokenWatson(){
        String respose;
        DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
        Map<string,string> mapHeaders = new Map<string,string>();

        
        DEG_WrapperJSONBot_cls.rptaLogin bodyRptaLogin = new DEG_WrapperJSONBot_cls.rptaLogin();
        //Get metadata for username and password
        Map<String, DEG_ConfigGenerales__mdt> userInfoMap = DEG_ConfigGenerales__mdt.getAll();
        //Start Create JSON and RequesT REST
        JSONGenerator userLogin = JSON.createGenerator(true);    
        userLogin.writeStartObject();     
        userLogin.writeStringField('user',userInfoMap.get('DEG_ConfigGeneral').DEG_UserName__c);
        userLogin.writeStringField('password',userInfoMap.get('DEG_ConfigGeneral').DEG_PassWord__c);
        userLogin.writeEndObject();    
        String jsonUserLogin = userLogin.getAsString();
        request.setTextRequest(jsonUserLogin); 
        mapHeaders.put('Content-Type','application/json');
        request.setHttpHeaders(mapHeaders);
        request.setNamedCredential('DEG_Bot_Transfer');
        request.setUri('DEG_UserLogin');
        request.init();
        //End Create JSON and RequesT REST
        try{
            HttpResponse response = request.execute();
            //Deseralize rpta REST
            String rptBody = response.getBody();
            bodyRptaLogin = (DEG_WrapperJSONBot_cls.rptaLogin )JSON.deserialize(rptBody, DEG_WrapperJSONBot_cls.rptaLogin.class); 
            respose= bodyRptaLogin.data[0].token;
        }
        catch(Exception e){
            System.debug('Error Message: '+e.getMessage());
            System.debug('Error Line: '+e.getLineNumber());
        }
        if(respose != '' && respose != null) {
            System.debug('##save token');
            Cache.Org.put('tokenWatson',respose);
        }
        System.debug('##No token'+respose);
        return respose;
       
    }
}