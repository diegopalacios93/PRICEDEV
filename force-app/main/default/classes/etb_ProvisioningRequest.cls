global without sharing class etb_ProvisioningRequest implements vlocity_cmt.VlocityOpenInterface2 {
    public Map<String, Object> response;
    
    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
            try {
               if (methodName == 'ProvisioningReq') {
                    ProvisioningReq(inputMap, outMap, options);                  
                  }

            } catch (Exception thrownException) {
                   return false;
            }
            
            return true;
        }
  	
    
    public void ProvisioningReq(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        
        String sReq = JSON.serializePretty(input.get('request'));    
        invokeIntegrationProcedure(sReq);
             
    }    
    
    @future(callout = true)
    private static void invokeIntegrationProcedure(String asReq)
    {
       // String procedureAPIName = (String)input.get('ProcedureAPIName');
        String procedureAPIName = 'etb_ProvisioningHTTP';
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        inputMap.put('request',asReq);
        System.debug('Esta es la Petición -> ' + asReq);
        // The runIntegrationService method takes in Type_SubType of the VIP as the first parameter. Address is Type and GetAddress is the SubType in this sample.
        outMap = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureAPIName, inputMap, optionsMap);
     
        IF (Test.isRunningTest()){
            outMap.put('Resultado','Ok');
        }
        
        System.debug('Resultado -> ' + outMap);
         
        // output.put('Result', result);
    }
    
}