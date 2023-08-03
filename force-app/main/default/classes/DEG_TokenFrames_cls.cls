/**
 * @description       : Clase para el consumo del Servicio Web para generar el Token de los Frames
 * @author            : Javier Tibamoza (JATC)
 * @group             : ETB
 * @last modified on  : 05-04-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log
 * Ver   Date         Author                              Modification
 * 1.0   03-15-2021   Javier Tibamoza (JATC) 			  Initial Version
 * 1.1   04-29-2021   Harlinsson Chavarro (HCH)			  Added Platform Cache.
 **/
public without sharing class  DEG_TokenFrames_cls {
  
    public static string getTokenFrame() {
        if (Cache.Org.contains('tokenFrames')) {
            return (String)Cache.Org.get('tokenFrames');
        }
        else {
            return DEG_TokenFrames_cls.callOutToken();
        }
    }
    /** 
    * @description: Call Out para crear el Token en Salesforce en el objeto DEG_ParamWebServices__c
    */
    // @future(callout=true)
    public static String callOutToken() {
        // oParamWS = DEG_ParamWebServicesHandler_cls.getInstance('Token');
        String sToken = '';
        DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
        Map<string,string> mapHeaders = new Map<string,string>();
        mapHeaders.put('Content-Type','application/json');
        //mapHeaders.put('Authorization', 'Bearer ' + DEG_TokenFrames_cls.getTokenFrame() );
        request.setNamedCredential('DEG_botdevPortallteqaAzurewebsites');
        request.setUri('DEG_TokenFrames');
        request.setHttpHeaders( mapHeaders );
        request.setTextRequest( createJson() );      
        request.init();
        HttpResponse response = request.execute();
        String rptBody = response.getBody();
        if (response.getStatusCode() == 200) {
            rptBody = rptBody.replace('System', 'Systema');
            System.debug('##rptBody: '+rptBody);
            DEG_WrapperFrames_cls.wrapResponseToken oWrapToken = (DEG_WrapperFrames_cls.wrapResponseToken) JSON.deserialize(rptBody,DEG_WrapperFrames_cls.wrapResponseToken.class);
            System.debug('##oWrapToken: '+oWrapToken);
            if( oWrapToken.WSResponseHeader.Service.status == 'OK' ){
				if( oWrapToken != null && oWrapToken.WSResponseBody != null && oWrapToken.WSResponseBody.SecurityToken != null ){
                    sToken = oWrapToken.WSResponseBody.SecurityToken;
                    // oParamWS.createTokenParamWebServices(sToken);
                    Cache.Org.put('tokenFrames',sToken);
                }
            }
        }
        return sToken;
    }
    /** 
    * @description: Método para generar el JSON
    */
    @TestVisible
    private static string createJson(){
        List<DEG_ParamWebServices__c> lParamWebServices = [
            SELECT DEG_CorrelationID__c,DEG_Frame__c,DEG_Name__c,DEG_Password__c,DEG_ProcessingServer__c,DEG_Username__c,DEG_WhatsAppPhoneNumber__c,
            		DEG_IdDevice__c, DEG_IP_Address__c, DEG_IP_Latitude__c, DEG_IP_Longitude__c, DEG_SO__c, DEG_Twitter_User__c, DEG_Canal__c, DEG_Facebook_User__c
            FROM DEG_ParamWebServices__c 
            WHERE RecordType.DeveloperName = 'DEG_Param'
            AND DEG_Frame__c = 'token'
            LIMIT 1];
        DEG_WrapperFrames_cls.WSRequestHeader oWSRequestHeader = new DEG_WrapperFrames_cls.WSRequestHeader();
        DEG_WrapperFrames_cls.Systema oSystema = new DEG_WrapperFrames_cls.Systema();
        List<DEG_WrapperFrames_cls.Property> lProperty = new List<DEG_WrapperFrames_cls.Property>();
        DEG_WrapperFrames_cls.WSRequestBody oWSRequestBody = new DEG_WrapperFrames_cls.WSRequestBody();
        DEG_WrapperFrames_cls.Audit oAudit = new DEG_WrapperFrames_cls.Audit();
        oSystema.name = lParamWebServices[0].DEG_Name__c;//'DIGITAL';
		oSystema.correlationID = lParamWebServices[0].DEG_CorrelationID__c;//'DEG-WPP-ALFANÚMERICO';
        oSystema.processingServer = lParamWebServices[0].DEG_ProcessingServer__c;//'DIGITAL';
        
        oWSRequestHeader.Systema = oSystema;
        oWSRequestHeader.lProperty = lProperty;
        
        oWSRequestBody.Username = lParamWebServices[0].DEG_Username__c;//'DIGITAL';
        oWSRequestBody.Password = lParamWebServices[0].DEG_Password__c;//'DIGI2020';
        oAudit.Canal = lParamWebServices[0].DEG_Canal__c;//'1';
        oAudit.Id_Device = lParamWebServices[0].DEG_IdDevice__c;//'1';
        oAudit.SO = lParamWebServices[0].DEG_SO__c;//'1';
        oAudit.IP_Address = lParamWebServices[0].DEG_IP_Address__c;//'1';
        oAudit.IP_Latitude = lParamWebServices[0].DEG_IP_Latitude__c;//'1';
        oAudit.IP_Longitude = lParamWebServices[0].DEG_IP_Longitude__c;//'1';
        oAudit.WhatsApp_Phone_Number = lParamWebServices[0].DEG_WhatsAppPhoneNumber__c;//'1';
        oAudit.Facebook_User = lParamWebServices[0].DEG_Facebook_User__c;//'1';
        oAudit.Twitter_User = lParamWebServices[0].DEG_Twitter_User__c;//'1';
        oWSRequestBody.Audit = oAudit;
        
        DEG_WrapperFrames_cls.wrapRequestToken owrapRequestToken = new DEG_WrapperFrames_cls.wrapRequestToken();
        owrapRequestToken.WSRequestHeader = oWSRequestHeader;
        owrapRequestToken.WSRequestBody = oWSRequestBody;
        
        String sJson = JSON.serialize(owrapRequestToken);
        
        sJson = sJson.replace('Systema', 'System');
        
        return sJson;
    }
    
    
}