/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Carlos Gonzalez
Proyecto:           LTE Evolutivos
Descripción:        Batch para procesar las operaciones comerciales de desbloqueo de IMEI que esten en curso

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     15-07-2016  Carlos Gonzalez (CG)        Creación de la clase.
***********************************************************************************************************************/
global class DesbloqueoIMEI_bch implements Database.Batchable<SObject>,Database.AllowsCallouts 
{
    global Database.Querylocator start(Database.Batchablecontext bc)
    {
        Id gestionId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get(Label.LTE_Titulo_Gestion_IMEI).getRecordTypeId();
		String strEstado = 'En Curso';
	    String query = 'SELECT NumeroConexion__c, IMEI_del_Equipo__c, Activo__r.Name, Estado__c, Comentarios__c FROM OperacionComercial__c WHERE Estado__c = \'' + strEstado + '\' ';
        query += ' AND RecordTypeId = \'' + gestionId + '\' ';

        System.debug('\n@@-ConsultaBatch: '+query);
        return Database.getQueryLocator(query);    
    }

    global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope)
    {
        LTE_gestionIMEI_ctr gestion = new LTE_gestionIMEI_ctr(scope);
        gestion.debloquearBch();
    
    }
    
    global void finish(Database.BatchableContext bc)
    {        
        DesbloqueoIMEI_sch.ProgramarJob();
        system.debug('!!!EXITO');
    }    

}