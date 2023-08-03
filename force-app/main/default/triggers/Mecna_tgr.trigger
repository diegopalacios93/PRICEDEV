trigger Mecna_tgr on Mecna__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	
	   	if (trigger.isBefore) {
        //  Bloque de ejecuci�n Before Insert
        if (trigger.isInsert) {
            
        }

        //  Bloque de ejecuci�n Before Update
        if (trigger.isUpdate){
            
        }

        //  Bloque de ejecuci�n Before Delete
        if (trigger.isDelete) {

        }

    }
    
    //  Bloque de ejecuci�n After
    if (trigger.isAfter) {

        //  Bloque de ejecuci�n After Insert
        if (trigger.isInsert) {
        	 Mecna_cls.relacionarCuenta(trigger.newMap.keyset());

        }

        //  Bloque de ejecuci�n After Update
        if (trigger.isUpdate) {

        	
        }

        //  Bloque de ejecuci�n After Delete
        if (trigger.isDelete) {
            
        }

        //  Bloque de ejecuci�n After Undelete
        if (trigger.isUndelete) {

        }

    }
	

}