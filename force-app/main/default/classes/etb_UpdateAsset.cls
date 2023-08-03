/*
* @Author:      Victor Pacheco
* @Company:     LabsXD
* @Date:        
* @Reviewer:    
* @Review Date: 
* @Description: 
* -------------------------------------------------------------
*/
global without sharing class etb_UpdateAsset implements vlocity_cmt.VlocityOpenInterface2 {
	@TestVisible
    private static final String METHOD_UPDATE_ASSET_DATA_LABEL          = 'UpdateAssetData';
    @TestVisible
    private static final String METHOD_FAIL_LABEL          = 'FailMethod';
    
    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            if(Test.isRunningTest() && METHOD_FAIL_LABEL.equalsIgnoreCase(methodName)) {
                 throw new HandledException('Invalid Value');
             }
            if (METHOD_UPDATE_ASSET_DATA_LABEL.equalsIgnoreCase(methodName)) {
                return updateAssetData(inputMap, outMap, options); 
            }
            else {
                //return OiUtilErrorHandling.throwMethodNotFoundException(OiAsset.class, methodName);
                return false;
            }
        }
        catch (Exception thrownException) {
            //OiUtilErrorHandling.handle(outMap, OiSubscription.class, thrownException);
            return false;
        }
    }
    
	private Boolean updateAssetData(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        System.debug(LoggingLevel.DEBUG, 'input '+ JSON.serializePretty(inputMap));
        Id orderID = (Id)inputMap.get('OrderId');
		
        System.debug(LoggingLevel.DEBUG, 'orderID '+ orderID);
        
        List<Asset> assetLst = [SELECT Id FROM Asset WHERE vlocity_cmt__OrderId__c =: orderID];
        
        for (Asset ass:assetLst){
            ass.Status = 'Active';
            ass.vlocity_cmt__ContractNumber__c = String.valueOf(Integer.valueof((Math.random() * 10000)));
            ass.Price = 100;
            ass.InstallDate = System.today();
            ass.UsageEndDate = System.today() + 30;
            ass.vlocity_cmt__ServiceIdentifier__c = String.valueOf(Integer.valueof((Math.random() * 100000)));
        }
		Update assetLst;
        outMap.put('result', true);
        return true;
    }
}