/***********************************************************************************************************************
Desarrollado por:   Accenture Colombia
Autor:              Miguel R. Gómez
Proyecto:           LTE Evolutivos
Descripción:        Batch para la construcción del archivo de IMEI´s y su posterior envío al correo.

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     14-12-2021  Miguel R. Gómez        Creación de la clase.
***********************************************************************************************************************/
global class EnvioIMEICuentaFactura_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{
	
    global Database.Querylocator start(Database.Batchablecontext bc){
    	System.debug('=== start EnvioIMEICuentaFactura_bch ===');
        		
	    String query = 'SELECT IMEISCF__c FROM CuentaFacturacion__c WHERE Id IN (SELECT CuentaFacturacion__c FROM OperacionComercial__c ' + 
                       'WHERE Estado__c = \'Facturado\' AND '+
                        'Fecha_Estado_Facturado__c = LAST_MONTH AND CuentaFacturacion__r.ContieneIMEI__c = true)';	  
	    
        System.debug('Query: '+query);
        return Database.getQueryLocator(query);    
    }

    global void execute(Database.BatchableContext bc, List<CuentaFacturacion__c> scope){
        System.debug('=== execute EnvioIMEICuentaFactura_bch ===');
        EnvioIMEICuentaFactura_cls.ProcesarSolicitud(scope);
    }
    
    global void finish(Database.BatchableContext bc){        
        System.debug('=== finish EnvioIMEICuentaFactura_bch === ' + bc );
    } 
}