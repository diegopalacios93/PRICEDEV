global class LTE_Aprovisionamiento_sch implements Schedulable
{
	global void execute(SchedulableContext sc)
	{
		Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
				
		LTE_Aprovisionamiento_bch batchA = new LTE_Aprovisionamiento_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=(Integer)apr.get('Aprovisionamiento').LTE_Noche__c;
		ID batchprocessid = Database.executeBatch(batchA, 1);
		//Database.executeBatch(new LTE_Aprovisionamiento_bch(),1);
	}
}