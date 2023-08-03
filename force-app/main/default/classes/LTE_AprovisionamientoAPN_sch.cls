global class LTE_AprovisionamientoAPN_sch implements Schedulable 
{
	global void execute(SchedulableContext sc)
	{
		Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
				
		LTE_AprovisionamientoAPN_bch batchA = new LTE_AprovisionamientoAPN_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=(Integer)apr.get('AprovisionamientoAPN').LTE_Noche__c;
		ID batchprocessid = Database.executeBatch(batchA, 1);
	}
}