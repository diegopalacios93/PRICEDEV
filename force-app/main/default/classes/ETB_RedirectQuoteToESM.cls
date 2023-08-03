/*
* @author:      Rebeca Vázquez <rvazquez@labsxd.com>
* @company:     LabsXD
* @date:        05/04/2022
* @reviewer:    
* @review Date: 
* @description: Clase que genera una enterprise quote y luego redirige a ESM
* -------------------------------------------------------------
*/
global without sharing class ETB_RedirectQuoteToESM {
    public class CustomException extends exception{}
    public Opportunity opp {get; set;}    
    public Id Id { get; set; }
    
    public ETB_RedirectQuoteToESM(ApexPages.STandardController ctr){
      opp = (Opportunity)ctr.getRecord();
      Id = Opp.Id;
   	}
    
    public PageReference createQuote(){        
        System.debug('OBJ--------->' + JSON.serialize(opp));
        // logica para llamar al vip y crear la quote
        // para llegar al id de la oppty es -> opp.Id
        // una vez retornada la respuesta del VIP .. llamar a la función ESM()
        Id = procesarOpportunity(opp.Id);
        PageReference pageRef = new PageReference('/apex/vlocity_cmt__B2BCmexConfigureEnterpriseQuote');
      	pageRef.getParameters().put('Id',Id);
        pageRef.setRedirect(true);
       	return pageRef;
    }
    
    public Id procesarOpportunity(Id opportunityId){
        Id quoteId;
        String quoteName;     
         try {
            String procedureName = 'etb_CreateNewEnterpriseQuote';
            Map<String, Object> ipInput = new Map<String, Object>();
            Map<String, Object> ipOutput = new Map<String, Object>();
            Map<String, Object> ipOptions = new Map<String, Object>();
            ipInput.put('OpportunityId', opportunityId);
            ipInput.put('RecordTypeName', 'Enterprise Quote');
            /* Call the IP via runIntegrationService,
             and save the output to ipOutput */
            if(!Test.isRunningTest()) {
                ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName,ipInput,ipOptions);
            }else{
                ipOutput.put('QuoteId','0Q078000000H8nGCAS');
                ipOutput.put('QuoteName','Quote test');                
            }
             
             quoteId = (Id)ipOutput.get('QuoteId');
             quoteName = (String)ipOutput.get('QuoteName'); 
             if((String)quoteId == null || (String)quoteId == '' ){
                 throw new CustomException('el Id de la Quote no fue generado.');
             }  
             
        } catch (Exception e) {
            throw new CustomException('Error al generar la Enterprise Quote: ' + e.getMessage());
        }
        
        return quoteId;
    }
}