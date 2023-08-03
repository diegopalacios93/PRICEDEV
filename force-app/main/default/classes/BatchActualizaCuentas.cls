/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Batch encargado de actualizar todas las cuentas que tengan el campo EstadoRestriccionVenta__c en TRUE para pasarlas a FALSE

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     10-10-2013  Daniel Guana (AAC)       	Creación de la clase..
*******************************************************************************/

global class BatchActualizaCuentas implements Database.Batchable<SObject>,Database.Stateful, Database.AllowsCallouts{
	global String consulta;
	
	public BatchActualizaCuentas()
	{		
		consulta='SELECT id, EstadoRestriccionVenta__c FROM Account where EstadoRestriccionVenta__c = TRUE';							
	}
	
	/* Este método se ejecuta al inicio y sirve para obtener los registros que se le pasan al metodo execute */
    global Database.QueryLocator start(Database.BatchableContext DB) 
    {        
        return Database.getQueryLocator(consulta);
    }
    
    global void execute(Database.BatchableContext DB, List<sObject> scope)
    {
    	List<Account> lstAccount = (List<Account>)scope;
    	for(Account acc : lstAccount){
    		acc.EstadoRestriccionVenta__c = false;
    	}    	
    	update lstAccount;
    }
    global void finish(Database.BatchableContext DB){
    	    	
    }
}