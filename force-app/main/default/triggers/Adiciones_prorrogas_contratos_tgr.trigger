trigger Adiciones_prorrogas_contratos_tgr on Adiciones_y_prorrogas_contratos__c (after delete, after insert, after undelete, 
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
        
        SincronizarContratoColaborador_cls sincronizarcontratocolaborador = new SincronizarContratoColaborador_cls();                   
        if (trigger.isUpdate || trigger.isInsert) {            
          	sincronizarcontratocolaborador.SincronizaFechaContrato(trigger.newMap,'Upsert');               
        } 
		
        if (trigger.isDelete) {            
          	sincronizarcontratocolaborador.SincronizaFechaContrato(trigger.oldMap,'Delete');
        } 
    } 
}