/** 
 * 
*/
public class DEG_ParamWebServicesHandler_cls {
    
    public static DEG_ParamWebServicesHandler_cls objInstance = null;
    public DEG_ParamWebServices__c objParamWebServices = null;
    public String sToken;
    
    public DEG_ParamWebServicesHandler_cls() {
        
    }
    
    public DEG_ParamWebServicesHandler_cls(String sFrame) {
        List<DEG_ParamWebServices__c> lParamWebServicesToken = findToken();
        if( lParamWebServicesToken != null ){
            sToken = lParamWebServicesToken[0].DEG_Token__c;
        }
        List<DEG_ParamWebServices__c> lParamWebServicesParam = findParam(sFrame);
        if( lParamWebServicesParam != null ){
            objParamWebServices = lParamWebServicesParam[0];
        }
    }
     
    public static DEG_ParamWebServicesHandler_cls getInstance(String sFrame) {
        if ( objInstance == null )
            objInstance = new DEG_ParamWebServicesHandler_cls(sFrame);
        return objInstance; 
    }

    @TestVisible 
    private static List<DEG_ParamWebServices__c> findToken() {
        List<DEG_ParamWebServices__c> lParamWebServices = [
            SELECT Id, DEG_Token__c
            FROM DEG_ParamWebServices__c
            WHERE RecordType.DeveloperName = 'DEG_Token' 
            LIMIT 1];
        return ( lParamWebServices.isEmpty() ? null : lParamWebServices );
    }
    
    @TestVisible 
    private static List<DEG_ParamWebServices__c> findParam(String sFrame) {
        List<DEG_ParamWebServices__c> lParamWebServices = [
            SELECT DEG_CorrelationID__c,DEG_Frame__c,DEG_Name__c,DEG_Password__c,DEG_ProcessingServer__c,DEG_Username__c,DEG_WhatsAppPhoneNumber__c,
            		DEG_IdDevice__c, DEG_IP_Address__c, DEG_IP_Latitude__c, DEG_IP_Longitude__c, DEG_SO__c, DEG_Twitter_User__c, DEG_Canal__c, DEG_Facebook_User__c
            FROM DEG_ParamWebServices__c 
            WHERE RecordType.DeveloperName = 'DEG_Param'
            AND DEG_Frame__c =: sFrame
            LIMIT 1];
        return ( lParamWebServices.isEmpty() ? null : lParamWebServices );
    }

    public void createTokenParamWebServices(String sToken) {
        try{
            Id RecordTypeId = Schema.SObjectType.DEG_ParamWebServices__c.getRecordTypeInfosByName().get('DEG_Token').getRecordTypeId();
            List<DEG_ParamWebServices__c> lParamWebServices = findToken();
            DEG_ParamWebServices__c oDEG_ParamWebServices;
            Boolean blUpdate = false;
            if( lParamWebServices != null ){
                oDEG_ParamWebServices = lParamWebServices[0];
                blUpdate = true;
            }else{
                oDEG_ParamWebServices = new DEG_ParamWebServices__c();
                oDEG_ParamWebServices.RecordTypeId = RecordTypeId;
            }
            oDEG_ParamWebServices.DEG_Token__c = sToken;
            if( blUpdate ){
				update oDEG_ParamWebServices;
            }else{
				insert oDEG_ParamWebServices;
            }
        }catch( Exception ex ){
            System.debug( 'Error: ' + ex.getMessage() );
        }
    }
}