trigger Bienes_y_servicios_Acta_de_proveedor_tgr on Bienes_y_servicios_Acta_de_proveedor__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {  
   
    if (trigger.isAfter) {                
        SincronizarContratoColaborador_cls sincronizar = new SincronizarContratoColaborador_cls();                   
        if (trigger.isInsert || trigger.isUpdate)            
          	sincronizar.sincronizarActaProveedor(trigger.newMap);
        if (trigger.isDelete) {         
          	sincronizar.sincronizarActaProveedor(trigger.oldMap);
        }
    } 
}