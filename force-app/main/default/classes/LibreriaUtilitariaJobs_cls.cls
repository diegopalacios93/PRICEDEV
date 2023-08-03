/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Hector Bayona
Proyecto:           ETB Evolutivos
Descripción:        Librería de funciones útiles de manera transversal que se relaciona con tareas programadas
Nota:				La modificacion de esta clase implica inactivar las tareas que estan en curso a continuacion
					se describen las tareas y su frecuencia.

Tareas Programadas:		Ejecucion

BatchColaCun_sch		Cada 30 Min


Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2014-04-10      Hector Bayona   (HB)        Metodo consultarServicio.
***********************************************************************************************************************/

public with sharing class LibreriaUtilitariaJobs_cls {
	
    static public Boolean ErrorExcepcionTest = false;   //  Variable controladora del lanzado de Excepciones en Test

	//Metodo encargado de consultar soap via Http
    public static string consultarServicio(string xml,string metodo,string endpoint){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        req.setBody(xml);
 
        req.setEndpoint(endpoint);
 
        string bodyRes = '';
        
        HttpResponse res;

        try {
            	res = h.send(req);
            	bodyRes = res.getBody();
                system.debug(bodyRes);
                if(res.getStatusCode()>=400){
                    bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>Error: '+res.getStatusCode()+'</NomError>';
                }
            }
            catch(System.CalloutException e) {
            bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>'+e.getMessage()+'</NomError>';
            }
        system.debug('\nHttpRequest:\n'+bodyRes);
        return bodyRes;
 
       }


}