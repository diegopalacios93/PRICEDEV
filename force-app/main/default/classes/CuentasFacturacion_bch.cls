global class CuentasFacturacion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{
    
    global Database.Querylocator start(Database.Batchablecontext bc){
        string query  = 'SELECT Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, ';
        	   query += 'LTE_Email__c, DirCorresp__c, Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, ';	
        	   query += 'LTE_MetodoEnvio__c, Name, Facturable__c ';
               query += 'From CuentaFacturacion__c ';
               query += 'Where Fue_creada_en_revchain__c = TRUE AND ';
        	   query += 'Cliente__c IN (SELECT Id From Account Where Actualizar_nombres_cuentas_facturacion__c = TRUE)';
        
        System.debug('\n@@-ConsultaBatch UpdateCuentasFacturacion: '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<CuentaFacturacion__c> scope){
        ConstruccionCanonicoCtasFact_cls canonico = new ConstruccionCanonicoCtasFact_cls();
		canonico.orquestarIntegracion(scope,'ActualizarNombre');
    }
    global void finish(Database.BatchableContext bc){	
		system.debug('\n@@-FinBatch UpdateCuentasFacturacion');
    }
}