/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Luis Eduardo Mogollon
Proyecto:				ETB - Integraciones Facturacion SFDC - RevChain
Descripci?n:			Batch para procesar las operaciones comerciales que se deben enviar a facturacion
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0		23-01-2015	Luis Eduardo Mogollon(LEM)	Creaci?n de la clase
*******************************************************************************/
global class Facturacion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
	
	global Database.Querylocator start(Database.Batchablecontext bc)
	{		
		//String query = 'Select id from OperacionComercial__c where EnvioFacturacion__c=true';
		String query = System.Label.ConsultaFacturacion;
		System.debug('\n@@-ConsultaBatch: '+query);
		return Database.getQueryLocator(query);
	}
	
		global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
		//llamar todas las operaciones comerciales que tengan el check habilitado.
		//se valida que este activa la facturacion
		EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('RevChain');
		if(integra!=null && integra.Ejecucion__c==true)
		{
		ConstruccionCanonico_cls canonico = new ConstruccionCanonico_cls();
		canonico.CrearFacturacion(scope);
		}
		
	
	
	}
	global void finish(Database.BatchableContext bc){
		
		Facturacion_sch.ProgramarJob();
		system.debug('!!!EXITO');
	}

}