/*************************************************************************************/
/* Desarrollado por: Accenture 
/* Autor:            Diego Alejandro Rico
/* Proyecto:         ETB - DE
/* Descripción:      Batch para eliminar los contactos creados exclusivamente para le envió de mensajes HSM 
/* Clase de prueba DEG_DeleteContact_tst
/* Cambios (Versiones) 
/* ----------------------------------------------------------------------------------- 
/* No.  Fecha       Autor                   Descripción 
/* ---- ----------- ----------------------- ------------------------------------------
/* 1.0  28-09-2021  Diego Rico (DARF)     Creacion de la clase 
/*************************************************************************************/

global class DEG_DeleteContact_bch implements Database.Batchable<SObject>,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('DEG_DeleteContact_bch-start=>');
		String query = 'SELECT id FROM contact WHERE DEG_DeleteContact__c =true';
        System.debug('query-> ' + JSON.serialize(query));
		return Database.getQueryLocator(query);}
    
    global void execute(Database.BatchableContext BC, List<Contact> listCont) {
        system.debug('DEG_DeleteContact_bch-execute=>');
        if(listCont.size() > 0){
        delete listCont;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        DEG_DeleteContact_sch.ProgramarJob();
        system.debug('DEG_DeleteContact_bch-finish=>');
    }

}