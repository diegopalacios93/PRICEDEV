/*******************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   
Proyecto:                ETB Fase II
Descripción:             Scheduler para programar la ejecución del batch LTE_ConsultaSuspenda_bch

Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     23-03-2016  Walter Rodríguez M.           	Creación de la clase.
*******************************************************************************/

global class LTE_ConsultaSuspenda_sch implements Schedulable
{
	global void execute(SchedulableContext sc)
	{
		EliminarSch();
		LTE_ConsultaSuspenda_bch batch = new LTE_ConsultaSuspenda_bch();
		ID batchprocessid = Database.executeBatch( batch, 1 );
		system.debug( batchprocessid );
	}
	
	public void EliminarSch()
	{
		List<Crontrigger> a=[Select id,state from CronTrigger where state='DELETED'];
		for(CronTrigger ct : a)
			System.abortjob(ct.Id);
	}
}