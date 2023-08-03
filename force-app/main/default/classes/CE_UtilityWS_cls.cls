/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase utilitaria para realizar el callout para la integración Salesforce - ETA  
Clase test: CE_ConstruirCanonicoScheduleRemedy_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     22/11/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_UtilityWS_cls { 
    
    //Excepción personalizada
    public class UtilityWSException extends Exception{}
    
    /**
     * @description método encargado de consultar SOAP via Http
     * @param xml String correspondiente al XML con el Request para el servicio web
     * @param metodo String correspondiente al método a ser usado en el servicio web
     * @param endpoint String correspondiente al endpoint a ser usado en el servicio web
     * @return String XML asociado al body del response obtenido en el servicio web
     */
    public static string consultarServicio(String xml, String metodo, String endpoint, Id caseId){
        //Se valida que esté la información necesaria de la configuración del servicio web
        if(String.isBlank(metodo) || String.isBlank(endpoint))
        {
            throw new UtilityWSException('Faltan atributos en la configuración del servicio web');
        }
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('SOAPAction',metodo);
        request.setHeader('Accept-Encoding','gzip,deflate');
        request.setHeader('Content-Type','text/xml;charset=UTF-8');
        request.setHeader('User-Agent','Apache-HttpClient/4.5.5 (Java/12.0.1)');
        request.setTimeout(120000);
        request.setBody(xml);
        request.setEndpoint(endpoint);
        
        string bodyRes = '';
        
        HttpResponse response = new HttpResponse();
        WrapperRequest wrpReq = new WrapperRequest();
        wrpReq.metodo          = metodo;
        wrpReq.caseId          = caseId;
        wrpReq.request         = xml;
        try 
        {
            response = http.send(request);
            bodyRes = response.getBody();

            wrpReq.response        = bodyRes!=null?bodyRes:null;
            wrpReq.estado          = response.getStatus() != null?response.getStatus():null;
            wrpReq.CodigoRespuesta = response.getStatusCode() !=null?String.valueOf(response.getStatusCode()):null;

            if(response.getStatusCode()>=400)
            {
                publishException(wrpReq);
                throw new UtilityWSException('La conexión con el sistema no se pudo realizar \nCódigo de error: ' + String.valueOf(response.getStatusCode()) + '\nEstado: ' + response.getStatus());
            }
        }
        catch(System.CalloutException e) 
        {
            wrpReq.response        = e.getMessage();
            wrpReq.estado          = null;
            wrpReq.CodigoRespuesta = null;

            publishException(wrpReq);
            throw new UtilityWSException(e.getMessage());
        }
        
        publishException(wrpReq);
        return bodyRes; 
    }
    
    /**
     * @description método encargado de publicar platformEvents para la generación de los logs de las transacciones
     * @param wrpReq Wrapper con la estructura de la información del servicio web para la generación de los logs de las integraciones
     */
    public static void publishException(WrapperRequest wrpReq){
        CE_ExceptionLogging__e logException = new CE_ExceptionLogging__e();
        logException.CE_Name__c = wrpReq.metodo;
        logException.CE_Case__c = wrpReq.caseId; 
        logException.CE_Request__c = wrpReq.request; 
        logException.CE_Response__c = wrpReq.response;
        logException.CE_Status__c = wrpReq.estado;
        logException.CE_StatusCode__c = wrpReq.CodigoRespuesta;
        //Se publica el platform event
        eventBus.publish(logException);
    }

    //Wrapper con la estructura de la información del servicio web para la generación de los logs de las integraciones
    public class WrapperRequest {
        //String correspondiente al método a ser usado en el servicio web
        public String metodo{get;set;}
        //String correspondiente al caso asociado al agendamiento a ser creado
        public String caseId{get;set;}
        //String correspondiente al XML con el Request para el servicio web
        public String request{get;set;}
        //String correspondiente al response obtenido en el servicio web
        public String response{get;set;}
        //String correspondiente al estado obtenido en el servicio web
        public String estado{get;set;}
        //String correspondiente al código de respuesta obtenido en el servicio web
        public String CodigoRespuesta{get;set;}
    }
}