trigger CampaignMember_tgr on CampaignMember (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
if (trigger.isBefore) {
        //  Bloque de ejecución Before Insert
        if (trigger.isInsert) {

        }

        //  Bloque de ejecución Before Update
        if (trigger.isUpdate){
        	
        	
            
        }

        //  Bloque de ejecución Before Delete
        if (trigger.isDelete) {

        }

    }
    
    //  Bloque de ejecución After
    if (trigger.isAfter) {

        //  Bloque de ejecución After Insert
        if (trigger.isInsert) {
            if(!system.isFuture()){
        	CampaignMember_cls.CampaignMemberValidation(trigger.oldMap,trigger.newMap);
            }
        }

        //  Bloque de ejecución After Update
        if (trigger.isUpdate) {
            if(!system.isFuture()){
        	CampaignMember_cls.CampaignMemberValidation(trigger.oldMap,trigger.newMap);
            }
        }

        //  Bloque de ejecución After Delete
        if (trigger.isDelete) {
            
        }

        //  Bloque de ejecución After Undelete
        if (trigger.isUndelete) {

        }

    }

}