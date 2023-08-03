/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Trigger para evolutivo que no permite eliminar comentarios de chatter

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     12-04-2013  Daniel Guana (DGUANA)       Creación de la clase..
*******************************************************************************/
trigger FeedComment_tgr on FeedComment (before delete) {
    Boolean bCanDeleteFeed = [Select u.Delete_feed__c From User u Where u.id =: Userinfo.getUserId()].Delete_feed__c;
    if(!bCanDeleteFeed){
        FeedComment fi = Trigger.old.get(0);
        fi.addError(Label.Chatter_NoEliminar);
    }
}