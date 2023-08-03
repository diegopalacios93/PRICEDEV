trigger Conciliaciones_de_contrato_tgr on Conciliaciones_de_contrato__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {   
    
    if (trigger.isAfter) {          
        string idContrato = '';
        if(trigger.isInsert){
            for(Id ids:trigger.newMap.keySet()){
        		idContrato = trigger.newMap.get(ids).Contrato_relacionado__c;
        	}
        }else{
            for(Id ids:trigger.oldMap.keySet()){
                idContrato = trigger.oldMap.get(ids).Contrato_relacionado__c;
            }
        }        
        if(idContrato != ''){
        	Contract objContract = new Contract(Id=idContrato);
            update objContract;
        }
        
        /*
        SincronizarContratoColaborador_cls sincronizar = new SincronizarContratoColaborador_cls();                   
        if (trigger.isUpdate || trigger.isInsert) {              
          	sincronizar.SincronizaContrato(trigger.newMap,'Upsert');            
        } 
        if (trigger.isDelete) {            
          	sincronizar.SincronizaContrato(trigger.oldMap,'Delete');
        } */
    } 
}