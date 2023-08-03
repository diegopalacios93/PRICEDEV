trigger Actas_de_contrato_tgr on Actas_de_contrato__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {  
   
    if (trigger.isAfter) {                
        SincronizarContratoColaborador_cls sincronizar = new SincronizarContratoColaborador_cls();                   
        if (trigger.isInsert)            
          	sincronizar.sincronizarConciliacionActaDePago(trigger.newMap,'Insert');        
        if (trigger.isUpdate)
            sincronizar.sincronizarConciliacionActaDePago(trigger.newMap,'Update');     
        if (trigger.isDelete) {         
          	sincronizar.sincronizarConciliacionActaDePago(trigger.oldMap,'Delete');
        } 
    } 
}