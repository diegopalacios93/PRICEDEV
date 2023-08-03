/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Mock de Callout con excepción  

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     23/11/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
global class CE_ETACalloutExceptionMock_tst implements HttpCalloutMock
{   
    global HTTPResponse respond(HTTPRequest req)
    {
        CalloutException testException = (CalloutException) CalloutException.class.newInstance();
        testException.setMessage('Callout Exception Test');
        throw testException;
    }
}