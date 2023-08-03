/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Mock de Callout exitoso  

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     23/11/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
global class CE_ETACalloutMock_tst implements HttpCalloutMock
{
    private Integer code;
    private String body;
    
    global CE_ETACalloutMock_tst(Integer code, String body)
    {
        this.code = code;
        this.body = body;
    }
    
    global HTTPResponse respond(HTTPRequest req)
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        response.setBody(this.body);
        response.setStatusCode(this.code);
        return response; 
    }
}