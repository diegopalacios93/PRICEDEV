/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para el llamado del servicio desde el LWC
Clase test: CE_ConstruirCanonicoScheduleRemedy_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     17/11/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConstruirCanonicoScheduleRemedy_cls {
    
    //Nombre de la configuración del servicio web
    public static final String SERVICE_NAME ='Remedy_CreateScheduleOP_PS';
    
    //Excepción personalizada
    public class ConstruirCanonicoScheduleRemedyException extends Exception{}
    
    /**
     * @description método llamado desde el LWC para solicitar la creación del XML y hacer el llamado de la clase utilitario para hacer
     * el callout
     * @param scheduleForm mapa con los valores obtenidos desde el formulario de agendamiento del LWC que se usarán en el XML
     * @param caseID id del caso desde el cual se diligenció el formulario de agendamiento del cual se obtendrá información
     * complementaria para la creación del XML
     * @return Map<String, String> mapa de los valores obtenidos del XML de response con la información complementaria desde ETA para
     * ser procesada por el LWC
     */
    @AuraEnabled
    public static Map<String, String> orquestarIntegracion(Map<String, Object> scheduleForm, Id caseID)
    {
        Map<String, String> scheduleResult = new Map<String, String>();
        ServiciosWeb__c objServiciosWeb = new ServiciosWeb__c();
        try
        {
            //Se obtiene la configuración del servicio web
            objServiciosWeb  = [SELECT Id, Name, Action__c, EndPoint__c FROM ServiciosWeb__c  WHERE Name =: SERVICE_NAME LIMIT 1];
        } catch (System.QueryException queryException)
        {
            throw new ConstruirCanonicoScheduleRemedyException('No hay configuración asociada para el servicio web');
        }
        //Se realiza la generación del XML para el Request
        string requestXML = CE_ConstruirXMLScheduleRemedy_cls.crearXMLSchedule(scheduleForm, caseID);
        //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        string response = CE_UtilityWS_cls.consultarServicio(requestXML, objServiciosWeb.Action__c, objServiciosWeb.EndPoint__c , caseId); 
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        scheduleResult.putAll(proReq.getMap(response));
        return scheduleResult;
    }
}