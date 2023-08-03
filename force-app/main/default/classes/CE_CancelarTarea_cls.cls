/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase con la lógica para la cancelación de una tarea de agendamiento en Remedy
Clase test: CE_CancelarTarea_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     28/12/2021      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_CancelarTarea_cls {
    
    //Nombre de la configuración del servicio web
    public static final String SERVICE_NAME ='Remedy_CreateScheduleOP_PS';
    
    //Excepción personalizada
    public class CancelarTareaException extends Exception{}
    
    //Parámetros necesarios para la cancelación de la tarea de agendamiento en Remedy
    public class ParametrosCancelacion{
        //Id del caso asociado al agendamiento
        @InvocableVariable
        public String caseId;
        
        //Id del agendamiento
        @InvocableVariable
        public String scheduleId;
        
        //Estado del agendamiento
        @InvocableVariable
        public String estadoAgendamiento;
        
        //Motivo de cancelación de la agenda
        @InvocableVariable
        public String motivoCancelacion;
        
        //Notas para la cancelación de la agenda
        @InvocableVariable
        public String notas;
    }
    
    //Valores de respuesta para la cancelación de la tarea de agendamiento en Remedy
    public class ResultadoCancelacion{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;
        
        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
    }
    
    /**
    * @description método utilizado para la cancelación en Remedy de la tarea de agendamiento
    * @param parametrosCancelacion parámetros necesarios para la cancelación de la agenda
    * @return List<ResultadoCancelacion> mensaje resultante de la integración
    */
    @InvocableMethod(label='Cancelar Agenda' description='Cancela una agenda en Remedy.' category='Agenda')
    public static List<ResultadoCancelacion> cancelarTareaRemedy(List<ParametrosCancelacion> parametrosCancelacion){
        ResultadoCancelacion resultadoCancelacion = new ResultadoCancelacion();
        resultadoCancelacion.operacionExitosa = false;
        if(String.isBlank(parametrosCancelacion[0].scheduleId))
        {
            resultadoCancelacion.mensajeOperacion = 'No es posible realizar la cancelación por no contar con un Id Agenda asociado';
            return new List<resultadoCancelacion>{resultadoCancelacion};
        }
        Map<String, String> cancelTaskResult = new Map<String, String>();
        ServiciosWeb__c objServiciosWeb = new ServiciosWeb__c();
        try
        {
            //Se obtiene la configuración del servicio web
            objServiciosWeb  = [SELECT Id, Name, Action__c, EndPoint__c FROM ServiciosWeb__c  WHERE Name =: SERVICE_NAME LIMIT 1];
        } catch (System.QueryException queryException)
        {
            resultadoCancelacion.mensajeOperacion = 'No hay configuración asociada para el servicio web';
            return new List<resultadoCancelacion>{resultadoCancelacion};
        }
        string requestXML = '';
        string response = '';
        try{
            //Se realiza la generación del XML para el Request
            requestXML = CE_CancelarTareaXML_cls.crearXMLCancelarTarea(parametrosCancelacion[0]);
            //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
            response = CE_UtilityWS_cls.consultarServicio(requestXML, objServiciosWeb.Action__c, objServiciosWeb.EndPoint__c , parametrosCancelacion[0].caseId);
        }catch(Exception exc){
            resultadoCancelacion.mensajeOperacion = exc.getMessage();
            return new List<resultadoCancelacion>{resultadoCancelacion};
        } 
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        cancelTaskResult.putAll(proReq.getMap(response));
        if(!cancelTaskResult.get('Codigo').startsWithIgnoreCase('F')){
            resultadoCancelacion.operacionExitosa = true;
            resultadoCancelacion.mensajeOperacion = Label.CE_AgendaCanceladaExitosa;
            return new List<resultadoCancelacion>{resultadoCancelacion};
        }else{
            resultadoCancelacion.mensajeOperacion = cancelTaskResult.get('DetalleEstado');
            return new List<resultadoCancelacion>{resultadoCancelacion};
        }
    } 
}