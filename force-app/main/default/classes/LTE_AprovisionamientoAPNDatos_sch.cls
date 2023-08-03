global class LTE_AprovisionamientoAPNDatos_sch implements Schedulable {
    global void execute(SchedulableContext sc)
	{
		Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
				
		LTE_AprovisionamientoAPNDatos_bch batchA = new LTE_AprovisionamientoAPNDatos_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=(Integer)apr.get('AprovisionamientoAPNDatos').LTE_Noche__c;
		ID batchprocessid = Database.executeBatch(batchA, 1);
	}
}