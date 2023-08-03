public without sharing class etb_legalizacionHelper {
   public class MgmtLegalizationException extends exception{}   
    
    @InvocableMethod(label='Get Legalizations' description='Iterate over legalizations')
    public static void legalizacionHelperMethod(List<Legalizacion__c> legaList){
        List<String> legaIdList = new List<String>();
        for(Legalizacion__c leg : legaList){
            if(leg.Estado__c == 'Gestionado'){
                legaIdList.add(leg.Id);
                String procedureName = 'etb_AsyncEngineLegalizacion';
                Map<String, Object> ipInput = new Map<String, Object>();
                Map<String, Object> ipOutput = new Map<String, Object>();
                Map<String, Object> ipOptions = new Map<String, Object>();
                ipInput.put('legalizationId', leg.Id);
                try{
                   	 if(!Test.isRunningTest()) {
                        ipOutput = (Map<String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName,ipInput,ipOptions);
                     }else{
                         if (leg.Portacion__c == 'No'){
                            ipOutput.put('success',true);
                            ipOutput.put('ErrorMessage','Transaction successful');                      
                         }else{
                            ipOutput.put('success',false);
                            ipOutput.put('ErrorMessage','Transaction error');                          
                         }
                     }                       
                        Boolean resp = (Boolean)ipOutput.get('success');
                        String errMsg = (String)ipOutput.get('ErrorMessage');
                        If(!resp){
                            throw new MgmtLegalizationException(errMsg);  
                        }
                    }catch(MgmtLegalizationException ex){
                        ipOutput.put('Result','Error');
                        ipOutput.put('Message',ex.getMessage());
                        throw ex;
                    }
                }
            }
        }
    }