/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para evolutivo que no permite eliminar comentarios de chatter

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     12-04-2013  Daniel Guana (DGUANA)       Creación de la clase..
*******************************************************************************/
@isTest
private class ChatterNoEliminar_tst {

    static testMethod void myUnitTest() {
        FeedItem fi = new FeedItem();
        fi.ParentId = Userinfo.getUserId();
        fi.Body = 'test';
        insert fi;
        
        FeedComment fc = new FeedComment();
        fc.FeedItemId = fi.Id;
        fc.CommentBody = 'test';
        insert fc;
        try{
        	delete fc;
        }catch(Exception e){
        	system.debug('sale error');
        }
        try{
        	delete fi;
        }catch(Exception e){
        	system.debug('sale error');
        }
    }
}