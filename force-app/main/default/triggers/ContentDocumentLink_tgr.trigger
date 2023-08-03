/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Trigger para el objeto ContentDocumentLink usado al momento de crear notas en lightning

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    	Descripción
----    ----------   ----------------------   	---------------
1.0     2021-07-20   John Guevara (ETB)   		Creación de la clase.
***********************************************************************************************************************/
trigger ContentDocumentLink_tgr on ContentDocumentLink (before insert) {
    for(ContentDocumentLink cont : Trigger.new)
    { 
        cont.Visibility = 'AllUsers'; 
    }
}