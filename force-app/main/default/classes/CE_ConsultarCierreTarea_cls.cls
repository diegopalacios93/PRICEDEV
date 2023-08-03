/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para la consulta de la información de cierre de una tarea de agendamiento en Remedy
Clase test: CE_ConsultarCierreTarea_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     28/12/2021      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConsultarCierreTarea_cls {

    //Nombre de la configuración del servicio web
    public static final String SERVICE_NAME ='Remedy_CreateScheduleOP_PS';
    
    //Excepción personalizada
    public class ConsultarCierreTareaException extends Exception{}
    
    //Parámetros necesarios para la consulta del cierre de la tarea de agendamiento
    public class ParametrosCierre{
        //Id tarea asociada al agendamiento
        @InvocableVariable
        public String taskId;
        
        //Id del caso asociado al agendamiento
        @InvocableVariable
        public String caseId;
    }
    
    //Valores de respuesta para el cierre de la tarea de agendamiento
    public class ResultadoCierre{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;
        
        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
        
        //Nivel 1 del cierre de la agenda
        @InvocableVariable
        public String nivel1;
        
        //Nivel 2 del cierre de la agenda
        @InvocableVariable
        public String nivel2;
        
        //Nivel 3 del cierre de la agenda
        @InvocableVariable
        public String nivel3;
        
        //Nivel 4 del cierre de la agenda
        @InvocableVariable
        public String nivel4;
        
        //Nivel 5 del cierre de la agenda
        @InvocableVariable
        public String nivel5;
        
        //Código del cierre de la agenda
        @InvocableVariable
        public String codigoCierre;
        
        //Solución para el cierre de la agenda
        @InvocableVariable
        public String solucion;
    }
    
    /**
    * @description método utilizado para la consulta en Remedy de la información del cierre de la tarea de agendamiento
    * @param parametrosCierre parámetros asociados al agendamiento para la consulta del cierre
    * @return List<ResultadoCierre> resultado de la consulta de cierre de la agenda con toda la información pertinente
    * 		  a ser almacenada en Salesforce
    */
    @InvocableMethod(label='Consultar Cierre' description='Retorna la información de un cierre de agenda desde Remedy.' category='Agenda')
    public static List<ResultadoCierre> consultarCierreRemedy(List<ParametrosCierre> parametrosCierre){
        ResultadoCierre resultadoCierre = new ResultadoCierre();
        resultadoCierre.operacionExitosa = false;
        if(String.isBlank(parametrosCierre[0].taskId))
        {
            resultadoCierre.mensajeOperacion = 'No es posible realizar la consulta por no contar con un Id Tarea asociado';
            return new List<ResultadoCierre>{resultadoCierre};
        }
        Map<String, String> closingTaskResult = new Map<String, String>();
        ServiciosWeb__c objServiciosWeb = new ServiciosWeb__c();
        try
        {
            //Se obtiene la configuración del servicio web
            objServiciosWeb  = [SELECT Id, Name, Action__c, EndPoint__c FROM ServiciosWeb__c  WHERE Name =: SERVICE_NAME LIMIT 1];
        } catch (System.QueryException queryException)
        {
            resultadoCierre.mensajeOperacion = 'No hay configuración asociada para el servicio web';
            return new List<ResultadoCierre>{resultadoCierre};
        }
        string requestXML = '';
        string response = '';
        try{
            //Se realiza la generación del XML para el Request
        	requestXML = CE_ConsultarCierreTareaXML_cls.crearXMLConsultaCierre(parametrosCierre[0].taskId);
            //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        	response = CE_UtilityWS_cls.consultarServicio(requestXML, objServiciosWeb.Action__c, objServiciosWeb.EndPoint__c, parametrosCierre[0].caseId);
        }catch(Exception exc){
            resultadoCierre.mensajeOperacion = exc.getMessage();
            return new List<ResultadoCierre>{resultadoCierre};
        }
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        closingTaskResult.putAll(proReq.getMap(response));
        if(!closingTaskResult.get('Codigo').startsWithIgnoreCase('F')){
            //Se asigna la información obtenida en el response a los atributos del resultado del cierre
            resultadoCierre.nivel1 = closingTaskResult.get('SubEstado');
            resultadoCierre.nivel2 = closingTaskResult.get('GrupoAsignado');
            resultadoCierre.nivel3 = closingTaskResult.get('TecnicosAsignados');
            resultadoCierre.nivel4 = closingTaskResult.get('CedulasTecnicos');
            resultadoCierre.nivel5 = closingTaskResult.get('SoportesIngreso');
            resultadoCierre.codigoCierre = closingTaskResult.get('FechaHoraAgendaConfirmada');
            resultadoCierre.solucion = closingTaskResult.get('TipoSolicitud');
            resultadoCierre.operacionExitosa = true;
            resultadoCierre.mensajeOperacion = Label.CE_AgendaConsultaCierreExitosa;
            return new List<ResultadoCierre>{resultadoCierre};
        }
        else{
            resultadoCierre.mensajeOperacion = closingTaskResult.get('DetalleEstado');
            return new List<ResultadoCierre>{resultadoCierre};
        }
    }  
}