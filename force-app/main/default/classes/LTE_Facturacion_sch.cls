/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Luis Rafael Peñaranda Alvarez
Proyecto:				ETB - Integraciones SFDC RevChain LTE Fase I
Descripción:			Tarea programada, para el Batch procesar Facturacion LTE
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		15-09-2015	Luis Rafael Peñaranda (LRP)		Creación de la clase
*******************************************************************************/
global class LTE_Facturacion_sch implements Schedulable {
	
	global void execute(SchedulableContext sc){		
		
		LTE_CuentasFacturacion_bch facttbtch = new LTE_CuentasFacturacion_bch();
		facttbtch.limitQ = true; 
		
		Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
		facttbtch.limiteTotal=(Integer)apr.get('Facturacion').LTE_Noche__c;
		
		ID batchprocessid = Database.executeBatch(facttbtch,1);
		system.debug('==>batchprocessid:'+batchprocessid);	
	}	
}