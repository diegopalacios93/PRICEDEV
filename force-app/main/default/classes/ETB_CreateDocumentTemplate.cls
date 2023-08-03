global with sharing class ETB_CreateDocumentTemplate implements vlocity_cmt.VlocityOpenInterface
{
global ETB_CreateDocumentTemplate() { }

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('createTemplate'))
            {
                system.debug('Entro a crear Template');
                createTemplate(inputMap,outMap,options);
            }
            else if(methodName.equals('createContract'))
            {    
                system.debug('Entro a crear Contract');
                createContract(inputMap,outMap,options);
                
            }
            else
            {
            result = false;
            }    
        } 
        catch(Exception e)
        {
            System.debug('invokeMethod -> exception: '+e);
            result = false;
        }
        
        return result;
    }
    
      void createTemplate(Map<String, Object> inputMap, Map<String, Object> outMap,Map<String,Object> options)
      {
          Id ContractId;
          String sOrderId = (String)options.get('RecordId');
          If (!Test.isRunningTest()){
         	 ContractId= vlocity_cmt.ContractServiceResource.createContractWithTemplate(sOrderId);
          }else{
             ContractId = (Id)inputMap.get('TestContractId');
          }
          Contract con = New Contract();
           If (!Test.isRunningTest()){
             con.Id=ContractId;
           }else{
             con.Id= (Id)inputMap.get('TestContractId');             
           }
          //con.StartDate=System.Today();
           Update con;
     
           vlocity_cmt__ContractVersion__c conDoc = new vlocity_cmt__ContractVersion__c();
           Contract contr = new Contract();
     
           conDoc=[ Select Id,Name,vlocity_cmt__ContractId__c from vlocity_cmt__ContractVersion__c 
                    WHERE vlocity_cmt__ContractId__c =:ContractId ORDER BY LastmodifiedDate LIMIT 1];
           contr=[ Select Id,ContractNumber from Contract WHERE Id =: ContractId];
          
          outMap.put( 'ContractId', ContractId);
          outMap.put( 'ContractNumber', contr.ContractNumber);
          outMap.put( 'ContractDocumentId', conDoc.Id);
      }
      
      void createContract(Map<String, Object> inputMap, Map<String, Object> outMap,Map<String,Object> options)
      {
          String sOrderId = (String)options.get('RecordId');
          String sTerm;
          String sDate = (String)options.get('Startdate');
          Boolean sFrame = (Boolean)options.get('frame');
          Date contractDate = Date.valueOf(sDate);
          
          If(options.get('Term')!=null)
          {
              sTerm = String.valueOf(options.get('Term'));
          }
          
          Id ContractId;
          
          If (!Test.isRunningTest()){
           	ContractId = vlocity_cmt.ContractServiceResource.createContractWithTemplate(sOrderId);
          }else{
            ContractId = (Id)inputMap.get('TestContractId');
          }
          
          Contract con = New Contract();
         
          con.Id=ContractId;  
          con.StartDate = contractDate;
          If(String.isNotBlank(sTerm))
          {
              con.ContractTerm=Integer.valueOf(sTerm);
          }
          con.vlocity_cmt__IsFrameContract__c=sFrame;
          Update con;
          
          vlocity_cmt__ContractVersion__c conDocVer=[Select Id,Name,vlocity_cmt__ContractId__c from vlocity_cmt__ContractVersion__c WHERE vlocity_cmt__ContractId__c =:ContractId ORDER BY LastmodifiedDate LIMIT 1];
          outMap.put( 'ContractId', ContractId);
          outMap.put( 'ContractDocumentId', conDocVer.Id);
      }
        
}