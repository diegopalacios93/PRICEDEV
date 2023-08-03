global class LTE_AvailabilitQueryOrder_sch implements Schedulable
{
	global void execute(SchedulableContext sc)
	{
		Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
		
		LTE_AvailabilitQueryOrder_bch batchA = new LTE_AvailabilitQueryOrder_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=(Integer)apr.get('Disponibilidad M6').LTE_Noche__c;
		ID batchprocessid = Database.executeBatch(batchA, 1);
		//Database.executeBatch(new LTE_AvailabilitQueryOrder_bch(),1);
	}
}