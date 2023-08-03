global class LTE_AprovisionamientoTramites_sch implements Schedulable{
	
	global void execute(SchedulableContext sc)
	{
		//Database.executeBatch(new LTE_AprovisionamientoTramites_bch(),1);
		
		
		Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
				
		LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=(Integer)apr.get('Aprovisionamiento Tramites').LTE_Noche__c;
		ID batchprocessid = Database.executeBatch(batchA, 1);
	}

}