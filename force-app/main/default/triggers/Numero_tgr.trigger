/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Luis Eduardo Mogoll�n
Proyecto:               ETB - Evolutivos
Descripcion:            Disparador sobre el objeto NUmero__c

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     06-01-2015  Luis E Mogollon (LEM)      Creacion del disparador.
 
*******************************************************************************/
trigger Numero_tgr on Numero__c (after insert, after update, before insert, 
before update) {

ValidacionesNumeroRedInteligente val = new ValidacionesNumeroRedInteligente();
 if (trigger.isBefore) {

        if (trigger.isUpdate) {
			val.validacionNumero(Trigger.newMap, Trigger.oldMap);
        }
        if(trigger.isInsert){

        }
    }
    
	if (trigger.isAfter) {

        //  Bloque de ejecuci?n After Insert
        if (trigger.isInsert) {

        }

        //  Bloque de ejecuci?n After Update
        if (trigger.isUpdate) {

        	
        }

        //  Bloque de ejecuci?n After Delete
        if (trigger.isDelete) {
            
        }

        //  Bloque de ejecuci?n After Undelete
        if (trigger.isUndelete) {

        }

    }

}