global class CostosAvanzadosUpdateCart implements Database.Batchable<sObject>, Database.Stateful {
	public List<Costos_Avanzados__c> costos;
    public CostosAvanzadosUpdateCart(List<Costos_Avanzados__c> costos) {
        this.costos = costos;
    }
    
    global List<Costos_Avanzados__c> start(Database.BatchableContext BC) {
        return costos;
    }
    global void execute(Database.BatchableContext BC, List<Costos_Avanzados__c> scope) {
        List<Costos_Avanzados__c> costos = new List<Costos_Avanzados__c>();
        for( Costos_Avanzados__c PID : scope ) {
        	Map<String,Object> input   = new Map<String, Object>{'Id' => PID.Id};
            Map<String,Object> options = new Map<String, Object>();
            Id output = vlocity_cmt.IntegrationProcedureService.runIntegrationProcedureQueueable('ETB_RefreshCart', input, options);
            system.debug('output :: ' + output);
        }
        
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('Finalizo el batch');
    }
}