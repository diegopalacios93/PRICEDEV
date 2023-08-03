/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Ramos
Proyecto:               ETB - Integraciones Facturacion SFDC - RevChain
Descripcion:            Batch para procesar las operaciones comerciales de Larga Distancia que se deben enviar a facturacion
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     14-01-2016  Jorge Ramos(JR)             Creacion de la clase
*******************************************************************************/
global class FacturacionLD_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    
    global Database.Querylocator start(Database.Batchablecontext bc)
    {       
        String query = System.Label.ConsultaFacturacionLD;
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
        
        FacturacionLD_sch.ProgramarJob();
        system.debug('!!!EXITO');
    }

}