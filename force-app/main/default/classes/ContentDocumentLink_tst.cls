/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase de prueba para el trigger ContentDocumentLink_tgr

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    	Descripción
----    ----------   ----------------------   	---------------
1.0     2021-07-20   John Guevara (ETB)   		Creación de la clase.
***********************************************************************************************************************/
@isTest
public class ContentDocumentLink_tst {

    static testMethod void CrearDocument(){
        Case sglCaso = new Case();
        insert sglCaso;
        
        Test.startTest();
        ContentNote sglComment = new ContentNote(Title = 'Seguimiento Remedy');
        insert sglComment;
        ContentDocumentLink sglCommentLink = new ContentDocumentLink(LinkedEntityId=sglCaso.Id , ContentDocumentId=sglComment.Id, ShareType='V');
        insert sglCommentLink;
        Test.stopTest();
    }
}