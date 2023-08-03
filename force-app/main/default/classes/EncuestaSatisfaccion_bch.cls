global class EncuestaSatisfaccion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {

    global Database.Querylocator start(Database.Batchablecontext bc){
        string estadoDefault   = 'Cerrado';	
        string  query  = 'SELECT Id ';
                query += 'FROM Case ';
                query += 'WHERE Status =\'' + estadoDefault + '\'';
                query += 'AND EncuestaProcesada__c = false ';
        		query += 'AND NoIntentosEncuesta__c < 3 ';
        		query += 'AND NoIntentosEncuesta__c >= 1 ';
        		query += 'AND Account.Segmento__c =\''+'MiPymes'+'\'';
        System.debug('query--->'+query);
        return Database.getQueryLocator(query);
    }   
    global void execute(Database.BatchableContext bc, List<Case> scope){
        Set<Id> idCasos = new Set<Id>();
        for(Case c : scope){
            idCasos.add(c.Id);
        }
        EncuestaSatisfaccion_ws job = new EncuestaSatisfaccion_ws(idCasos);

        ID jobID = System.enqueueJob(job);
    }
    global void finish(Database.BatchableContext bc){
        system.debug('!!!EXITO');
    }
}