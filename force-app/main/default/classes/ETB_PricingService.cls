public class ETB_PricingService {
    
    public Id Id { get; set; }
    public Quote quote { get; set; }
    
    public ETB_PricingService(ApexPages.StandardController controller) {
    quote = (Quote) controller.getRecord();
    Id = quote.Id;
    }
    
    public PageReference invokeBatch() {
        UpdatePricing updateLineItems = new UpdatePricing(Id);
        Id batchJobId = Database.executeBatch(updateLineItems, 1);
        PageReference pageRef = new PageReference('/'+Id);
        pageRef.setRedirect(false);
        return pageRef;
    }
}