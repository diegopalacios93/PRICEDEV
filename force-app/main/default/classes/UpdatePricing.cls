global class UpdatePricing implements Database.Batchable<sObject>, Database.Stateful {
    
    public Id Id;
    public UpdatePricing(Id Id) {
    	this.Id = Id;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Calculado__c, Cotizacion__c  FROM ETB_CotizacionAvanzada__c WHERE Calculado__c = FALSE AND Cotizacion__c  = \'' + Id + '\'';
        system.debug(query);
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<ETB_CotizacionAvanzada__c> scope) {
     for (ETB_CotizacionAvanzada__c PID: scope) {
             Map<String,Object> input   = new Map<String, Object>{'Id' => PID.Id};
             Map<String,Object> options = new Map<String, Object>();
             Id output = vlocity_cmt.IntegrationProcedureService.runIntegrationProcedureQueueable('ETB_GetVariablesMatrices', input, options);       
       System.debug('IP output: ' + output);
         
     }
    
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}