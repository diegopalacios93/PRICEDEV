/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para la consulta de las actividades de seguimiento asociadas a una tarea de agendamiento en Remedy
Clase test: CE_ConsultarActividadesRemedy_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     07/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConsultarActividadesRemedy_cls {
    
    //Excepción personalizada
    public class ConsultarActividadesRemedyException extends Exception{}
        
    //Wrapper con la estructura de la información para las actividades de seguimiento
    public class WrapperActivity {
        //String correspondiente al id de la actividad de seguimiento en Remedy
        public String ActividadID{get;set;}
        //String correspondiente al tipo de información de la actividad de seguimiento
        public String TipoInformacion{get;set;}
        //String correspondiente a la fecha de avance de la actividad de seguimiento
        public String FechaAvance{get;set;}
        //String correspondiente al resumen de la actividad de seguimiento
        public String Resumen{get;set;}
        //String correspondiente a las notas de la actividad de seguimiento
        public String Notas{get;set;}
        //String correspondiente al usuario que actualiza la actividad de seguimiento
        public String UsuarioActualiza{get;set;}
    }
    
    //Parámetros necesarios para la consulta de las actividades de seguimiento
    public class ParametrosActividad{
        //Id tarea asociada al agendamiento
        @InvocableVariable
        public String taskId;
        
        //Id del caso asociado al agendamiento
        @InvocableVariable
        public String caseId;
        
        //EndPoint asociado al servicio web
        @InvocableVariable
        public String endPointWS;
        
        //Action asociado al servicio web
        @InvocableVariable
        public String actionWS;
    }
    
    //Valores de respuesta para la consulta de las actividades de seguimiento
    public class ResultadoActividad{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;
        
        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
    }
    
    /**
    * @description método utilizado para la consulta en Remedy de las actividades de seguimiento asociadas a una
    * 			   tarea de agendamiento
    * @param ParametrosActividad parámetros asociados al agendamiento para la consulta de las actividades de 
    * 		 seguimiento
    * @return List<ResultadoActividad> resultados de la operación de la consulta de actividades de seguimiento
    */
    @InvocableMethod(label='Consultar Actividades' description='Retorna un listado de actividades de seguimiento.' category='Agenda')
    public static List<ResultadoActividad> flujoActividadesRemedy(List<ParametrosActividad> parametrosActividad){
        ResultadoActividad resultadoActividad = new ResultadoActividad();
        resultadoActividad.operacionExitosa = false;
		Map<String, String> getActivitiesResult = new Map<String, String>();
        string requestXML = '';
        String response = '';
        try{
            //Se realiza la generación del XML para el Request
        	requestXML = CE_ConsultarActividadesXML_cls.crearXMLConsultaActividades(parametrosActividad[0].taskId);
            //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        	response = CE_UtilityWS_cls.consultarServicio(requestXML, parametrosActividad[0].actionWS, parametrosActividad[0].endPointWS , parametrosActividad[0].caseId);
        }catch(Exception exc){
            resultadoActividad.mensajeOperacion = exc.getMessage();
            return new List<ResultadoActividad>{resultadoActividad};
        }
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        getActivitiesResult.putAll(proReq.getMap(response));
        //Se valida si el Response fue exitoso o si hubo algún error
        if(!getActivitiesResult.get('Codigo').startsWithIgnoreCase('F')){
            List<WrapperActivity> listadoActividades = new List<WrapperActivity>();
            if(!String.isBlank(getActivitiesResult.get('SoportesIngreso'))){
                try{
                    //Se deserealiza el JSON con el listado de las actividades de seguimiento
                    listadoActividades = (List<WrapperActivity>) JSON.deserialize(getActivitiesResult.get('SoportesIngreso'), List<WrapperActivity>.class);
                }catch(System.JSONException jsonException){
            		resultadoActividad.mensajeOperacion = 'El formato del JSON con la información de las actividades de seguimiento es incorrecto';
            		return new List<ResultadoActividad>{resultadoActividad};
                }   
            }
            if(listadoActividades.size()>0){
                //Del listado obtenido anteriormente se realiza el proceso de Inserción/Actualización
                resultadoActividad.operacionExitosa = true;
                resultadoActividad.mensajeOperacion = deserealizarActividades(listadoActividades, parametrosActividad[0].taskId);
                return new List<ResultadoActividad>{resultadoActividad};
            }
            else{
                resultadoActividad.mensajeOperacion = 'No se han encontrado actividades de seguimiento asociadas al agendamiento';
                return new List<ResultadoActividad>{resultadoActividad};
            }  
        }
        else{
            resultadoActividad.mensajeOperacion = getActivitiesResult.get('DetalleEstado');
            return new List<ResultadoActividad>{resultadoActividad};
        }
    }
    
    /**
    * @description método utilizado para la creación/actualización de las actividades de seguimiento
    * @param listadoActividades listado de las actividades de seguimiento obtenidas desde Remedy
	* @param idTarea id en Remedy de la tarea de agendamiento asociada a las actividades de seguimiento
	* @return String mensaje resultante para el usuario
    */
    public static String deserealizarActividades(List<WrapperActivity> listadoActividades, String idTarea){
        //Mensaje que se irá generando para mostrar al finalizar al usuario
        String mensajeFlujo = 'La consulta de las actividades de seguimiento ha finalizado. \n';
        //Listado donde se almacenarán las actividades de seguimiento a ser creadas/actualizadas
        List<CE_FollowUpActivity__c> actividadesActualizar = new List<CE_FollowUpActivity__c>();
        for(CE_ConsultarActividadesRemedy_cls.WrapperActivity actividadSeguimientoWP : listadoActividades){
            /*Se hace la asignación de la información contenida en los wrapper a los registros de actividades de 
            seguimiento*/
            CE_FollowUpActivity__c actividadSeguimiento = new CE_FollowUpActivity__c();
            CE_Schedule__c agendamiento = new CE_Schedule__c(CE_TaskId__c=idTarea);
            actividadSeguimiento.CE_Schedule__r = agendamiento;
            actividadSeguimiento.CE_ActivityId__c = actividadSeguimientoWP.ActividadID;
            actividadSeguimiento.CE_JobInformationType__c = actividadSeguimientoWP.TipoInformacion;
            actividadSeguimiento.CE_AdvanceDate__c = (String.isBlank(actividadSeguimientoWP.FechaAvance)) ? (Null) : (DateTime.valueOfGmt(actividadSeguimientoWP.FechaAvance));
            actividadSeguimiento.CE_Resume__c = actividadSeguimientoWP.Resumen;
            actividadSeguimiento.CE_Notes__c =  actividadSeguimientoWP.Notas;
            actividadSeguimiento.CE_UserUpdatingActivity__c =  actividadSeguimientoWP.UsuarioActualiza;
            actividadesActualizar.add(actividadSeguimiento);
        }
        if(actividadesActualizar.size()>0){
            //Se realiza la inserción o actualización de las actividades de seguimiento
            List<Database.UpsertResult> upsertResults = Database.upsert(actividadesActualizar, CE_FollowUpActivity__c.fields.CE_ActivityId__c, false);
            String mensajeFallo = '';
            //String mensajeExito= '';
            for(Integer index = 0; index<upsertResults.size(); index++){
                if(upsertResults[index].isSuccess()){
                    //mensajeExito = mensajeExito + 'Actividad de seguimiento: ' + actividadesActualizar[index].CE_ActivityId__c + '.\n';
                }
                else{
                    mensajeFallo = mensajeFallo + 'Actividad de seguimiento: ' + actividadesActualizar[index].CE_ActivityId__c + '. Errores:';
                    for(Database.Error errorMensaje : upsertResults[index].getErrors()){
                        mensajeFallo = mensajeFallo + ' ' +errorMensaje.getMessage() + '.';
                    }
                    mensajeFallo = mensajeFallo + '\n';
                }
            }
            /*//Se valida si alguna actividad de seguimiento completó su proceso de inserción/actualización
            if(!String.isBlank(mensajeExito)){
                mensajeFlujo = mensajeFlujo + 'Las siguientes actividades de seguimiento fueron generadas correctamente: \n' + mensajeExito;
            }*/
            /*Se valida si alguna actividad de seguimiento falló su proceso de inserción/actualización para notificar
            al usuario sobre el error*/
            if(!String.isBlank(mensajeFallo)){
                mensajeFlujo = mensajeFlujo + 'Las siguientes actividades de seguimiento no pudieron ser consultadas correctamente: \n' + mensajeFallo;
            }
        }
        return mensajeFlujo;
    }
}