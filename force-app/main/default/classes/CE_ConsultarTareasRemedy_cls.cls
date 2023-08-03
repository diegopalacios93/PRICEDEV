/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para la consulta y actualización de la información de las tareas de agendamiento asociadas a un
incidente desde Remedy
Clase test: CE_ConsultarTareasRemedy_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     20/12/2021      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConsultarTareasRemedy_cls {
    
    //Nombre de la configuración del servicio web
    public static final String SERVICE_NAME ='Remedy_CreateScheduleOP_PS';
    
    //Excepción personalizada
    public class ConsultarTareasRemedyException extends Exception{}
    
    //Wrapper con la estructura de la información para el data table de las tareas de agendamiento
    public class WrapperScheduleTask {
        //String correspondiente al id de la tarea de agendamiento en Remedy
        @AuraEnabled 
        public String TaskID{get;set;}
        //String correspondiente al grupo asignado para la tarea de agendamiento
        @AuraEnabled
        public String GrupoAsignado{get;set;}
        //String correspondiente al estado de la tarea de agendamiento
        @AuraEnabled
        public String Estado{get;set;}
    }
    
    //Parámetros del agendamiento relevantes para la consulta de su detalle en Remedy
    public class ParametrosAgendamiento{
        //Id tarea asociada al agendamiento
        @InvocableVariable
        public String taskId;
        
        //Id del caso asociado al agendamiento
        @InvocableVariable
        public String caseId;
    }
    
    //Valores de respuesta para la consulta de su detalle en Remedy
    public class ResultadoAgendamiento{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;
        
        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
        
        //Id del agendamiento
        @InvocableVariable
        public String idAgendamiento;
    }
    
    /**
    * @description método llamado desde el LWC para obtener las tareas de agendamiento en Remedy asociadas al caso
    * @param sistemaLegado id del incidente asociado al caso
	* @param caseId id del caso en pantalla
    * @return List<WrapperScheduleTask> listado de tareas de agendamiento a ser mostradas en el data table del LWC
    */
    @AuraEnabled(cacheable=true)
    public static List<WrapperScheduleTask> obtenerTareas(String sistemaLegado, Id caseId)
    {
        if(String.isBlank(sistemaLegado))
        {
            throw new ConsultarTareasRemedyException('No es posible realizar la consulta por no contar con una incidencia');
        }
        Map<String, String> tasksResult = new Map<String, String>();
        ServiciosWeb__c objServiciosWeb = new ServiciosWeb__c();
        try
        {
            //Se obtiene la configuración del servicio web
            objServiciosWeb  = [SELECT Id, Name, Action__c, EndPoint__c FROM ServiciosWeb__c WHERE Name =: SERVICE_NAME LIMIT 1];
        } catch (System.QueryException queryException)
        {
            throw new ConsultarTareasRemedyException('No hay configuración asociada para el servicio web');
        }
        //Se realiza la generación del XML para el Request
        string requestXML = CE_ConsultarTareasXML_cls.crearXMLConsultaTareas(sistemaLegado, caseId);
        //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        string response = CE_UtilityWS_cls.consultarServicio(requestXML, objServiciosWeb.Action__c, objServiciosWeb.EndPoint__c , caseId); 
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        tasksResult.putAll(proReq.getMap(response));
        //Se valida si el Response fue exitoso o si hubo algún error
        if(!tasksResult.get('Codigo').startsWithIgnoreCase('F')){
            List<WrapperScheduleTask> listadoTareas = new List<WrapperScheduleTask>();
            if(!String.isBlank(tasksResult.get('SoportesIngreso'))){
                try{
                //Se deserealiza el JSON con el listado de las tareas de agendamiento
            	listadoTareas = (List<WrapperScheduleTask>) JSON.deserialize(tasksResult.get('SoportesIngreso'), List<WrapperScheduleTask>.class);
                }catch(System.JSONException jsonException){
                    throw new ConsultarTareasRemedyException('El formato del JSON con el listado de las tareas de agendamiento es incorrecto');
                }
            }
            if(listadoTareas.size()>0){
                return listadoTareas;
            }
            else{
                throw new ConsultarTareasRemedyException('No se han encontrado tareas de agendamiento asociadas al caso');
            }  
        }
        else{
            throw new ConsultarTareasRemedyException(tasksResult.get('DetalleEstado'));
        }
    }
    
    /**
    * @description método utilizado para la consulta de la información de la tarea de agendamiento en Remedy
    * @param parametrosAgendamiento parámetros asociados a la tarea de agendamiento para la actualización desde Remedy
    * @return List<Id> id del agendamiento en Salesforce
    */
    @InvocableMethod(label='Obtener Agenda' description='Retorna una agenda actualizada desde Remedy.' category='Agenda')
    public static List<ResultadoAgendamiento> actualizarAgendaFlujo(List<ParametrosAgendamiento> parametrosAgendamiento){
        ResultadoAgendamiento resultadoAgendamiento = new ResultadoAgendamiento();
        resultadoAgendamiento.operacionExitosa = false;
        try{
            resultadoAgendamiento.idAgendamiento = actualizarAgenda(parametrosAgendamiento[0].taskId, parametrosAgendamiento[0].caseId);
        }catch(Exception exc){
            resultadoAgendamiento.mensajeOperacion = exc.getMessage();
            return new List<resultadoAgendamiento>{resultadoAgendamiento};
        }
        resultadoAgendamiento.operacionExitosa = true;
        resultadoAgendamiento.mensajeOperacion = Label.CE_ConsultaAgendamientoExitosa;
        return new List<ResultadoAgendamiento>{resultadoAgendamiento};
    }
    
    /**
    * @description método utilizado para la consulta de la información de la tarea de agendamiento en Remedy. Este
    * 			   método es llamado desde el LWC correspondiente al data table de las tareas asociadas a un caso
    * @param taskId id tarea asociada al agendamiento
    * @param caseId id del caso asociado al agendamiento
    * @return Id id del registro de agendamiento en Salesforce
    */
    @AuraEnabled
    public static Id actualizarAgenda(String taskId, Id caseId)
    {
        if(String.isBlank(taskId))
        {
            throw new ConsultarTareasRemedyException('No es posible realizar la consulta por no contar con un Id Tarea asociado');
        }
        Map<String, String> taskDetailResult = new Map<String, String>();
        ServiciosWeb__c objServiciosWeb = new ServiciosWeb__c();
        try
        {
            //Se obtiene la configuración del servicio web
            objServiciosWeb  = [SELECT Id, Name, Action__c, EndPoint__c FROM ServiciosWeb__c  WHERE Name =: SERVICE_NAME LIMIT 1];
        } catch (System.QueryException queryException)
        {
            throw new ConsultarTareasRemedyException('No hay configuración asociada para el servicio web');
        }
        //Se realiza la generación del XML para el Request
        string requestXML = CE_ConsultarTareasXML_cls.crearXMLConsultaDetalle(taskId);
        //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        string response = CE_UtilityWS_cls.consultarServicio(requestXML, objServiciosWeb.Action__c, objServiciosWeb.EndPoint__c , caseId); 
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        taskDetailResult.putAll(proReq.getMap(response));
        //Se valida si el Response fue exitoso o si hubo algún error
        if(!taskDetailResult.get('Codigo').startsWithIgnoreCase('F')){
            //Se asigna la información obtenida en el response a un objeto Agendamiento
            CE_Schedule__c agendamiento = new CE_Schedule__c();
            agendamiento.CE_ScheduleIdOutput__c = taskDetailResult.get('IdAgenda');
            agendamiento.CE_StatusOutput__c = taskDetailResult.get('Estado');
            agendamiento.CE_RequestObservationOutput__c = taskDetailResult.get('EstadoProcesadoAgendamiento');
            agendamiento.CE_ScheduleConfirmedDateOutput__c = (String.isBlank(taskDetailResult.get('FechaHoraAgendaConfirmada'))) ? (Null) : (DateTime.valueOfGmt(taskDetailResult.get('FechaHoraAgendaConfirmada')));
            agendamiento.CE_AssignedGroupOutput__c = taskDetailResult.get('GrupoAsignado');
            agendamiento.CE_SubStatusOutput__c = taskDetailResult.get('SubEstado');
            agendamiento.CE_RequestTypeOutput__c = taskDetailResult.get('TipoSolicitud');
            agendamiento.CE_TaskId__c = taskId;
            agendamiento.CE_AssignedTechnicianIds__c = taskDetailResult.get('CedulasTecnicos');
            agendamiento.CE_AssignedTechnicianNames__c = taskDetailResult.get('TecnicosAsignados');
            agendamiento.CE_ScheduleRequestDateOutput__c = (String.isBlank(taskDetailResult.get('SoportesIngreso'))) ? (Null) : (DateTime.valueOfGmt(taskDetailResult.get('SoportesIngreso')));
            agendamiento.CE_ScheduleCase__c = caseId;
            agendamiento.CE_DescriptionOutput__c = taskDetailResult.get('IdTareaCreadaRemedy');
            //Se valida si el registro ya existe en Salesforce para realizar una actualización o inserción
            Database.UpsertResult upsertResult = Database.upsert(agendamiento, CE_Schedule__c.fields.CE_TaskId__c, False);
            if(upsertResult.isSuccess()){
                return upsertResult.getId();
            }
            else{
                String erroresUpsert = '';
                for(Database.Error errorUpsert : upsertResult.getErrors()){
                    erroresUpsert = erroresUpsert + '\n' + errorUpsert;
                }
                throw new ConsultarTareasRemedyException(erroresUpsert);
            }
		}
        else{
            throw new ConsultarTareasRemedyException(taskDetailResult.get('DetalleEstado'));
        }
    }
}