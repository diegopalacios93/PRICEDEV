/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Evita la eliminacion de adjuntos
Descripción:            trigger Evita la eliminacion de adjuntos
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     15-04-2015  Hector Bayona (HB)      Creación de la trigger
*******************************************************************************/
trigger Attachment_tgr on Attachment (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {


	if (trigger.isBefore) {
        //  Bloque de ejecución Before Insert
        if (trigger.isInsert) {}

        //  Bloque de ejecución Before Update
        if (trigger.isUpdate){}

        //  Bloque de ejecución Before Delete
        if (trigger.isDelete) {
        	Attachment_cls.procesar(trigger.oldMap,trigger.newMap);
        }

    }
    
    //  Bloque de ejecución After
    if (trigger.isAfter) {

        //  Bloque de ejecución After Insert
        if (trigger.isInsert) {}

        //  Bloque de ejecución After Update
        if (trigger.isUpdate) {}

        //  Bloque de ejecución After Delete
        if (trigger.isDelete) {}

        //  Bloque de ejecución After Undelete
        if (trigger.isUndelete) {}

    }


}