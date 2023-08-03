/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para la consulta de los archivos adjuntos asociados a una actividad de seguimiento en Remedy
Clase test: CE_ConsultarAdjuntos_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     18/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConsultarAdjuntos_cls {
    
    //Excepción personalizada
    public class ConsultarAdjuntosException extends Exception{}
    
    //Wrapper con la estructura de los archivos adjuntos en las actividades de seguimiento
    public class WrapperAttachment{
        //Nombre del archivo
        public String AttachmentName{get;set;}
        //Tamaño del archivo
        public String AttachmentSize{get;set;}
        //binaryData del archivo
        public String AttachmentData{get;set;}
    }
    
    //Parámetros necesarios para la consulta de los archivos adjuntos
    public class ParametrosAdjuntos{
        //Id actividad en Salesforce asociada a la actividad de seguimiento
        @InvocableVariable
        public String activityIdSalesforce;
        
        //Id actividad en Remedy asociada a la actividad de seguimiento
        @InvocableVariable
        public String activityIdRemedy;
        
        //Id del caso asociado al agendamiento que contiene la actividad de seguimiento
        @InvocableVariable
        public String caseId;
        
        //EndPoint asociado al servicio web
        @InvocableVariable
        public String endPointWS;
        
        //Action asociado al servicio web
        @InvocableVariable
        public String actionWS;
    }
    
    //Valores de respuesta para la consulta de los archivos adjuntos
    public class ResultadoAdjuntos{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;
        
        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
    }
    
    /**
     * @description método encargado de hacer el envío de correo electrónico al usuario
     * @param mensajeEmail texto con el cuerpo del correo electrónico a ser enviado
     * @param idActividadSalesforce id de la actividad de seguimiento en Salesforce
     */
    public static void publishEmail(String mensajeEmail, Id idActividadSalesforce){
        OrgWideEmailAddress owea = [SELECT Id, Address FROM OrgWideEmailAddress 
                                    WHERE Address =: Label.CE_EmailSender LIMIT 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{System.UserInfo.getUserEmail()});
        mail.setSubject(Label.CE_AsuntoCorreo);
        mail.setPlainTextBody(mensajeEmail);
        mail.setOrgWideEmailAddressId(owea.Id);
        mail.setSaveAsActivity(true);
        mail.setWhatId(idActividadSalesforce);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail}, false);
    }
    
    /**
    * @description método utilizado para la consulta en Remedy de los archivos adjuntos asociados a una
    *              actividad de seguimiento - Método llamado desde el flujo CE_Consultar_Adjuntos
    * @param ParametrosAdjuntos parámetros asociados a la actividad de seguimiento para la consulta de los archivos
    *        adjuntos
    * @return List<ResultadoAdjuntos> resultados de la operación de la consulta de los archivos adjuntos
    */
    @InvocableMethod(label='Consultar Adjuntos' description='Retorna un listado de archivos adjuntos.' category='Agenda')
    public static List<ResultadoAdjuntos> flujoAdjuntos(List<ParametrosAdjuntos> parametrosAdjuntos){
        ResultadoAdjuntos resultadoAdjuntos = new ResultadoAdjuntos();
        resultadoAdjuntos.operacionExitosa = false;
        string requestXML = '';
        try{
            //Se realiza la generación del XML para el Request
            requestXML = CE_ConsultarAdjuntosXML_cls.crearXMLConsultaAdjuntos(parametrosAdjuntos[0].activityIdRemedy);
        }catch(Exception exc){
            resultadoAdjuntos.mensajeOperacion = exc.getMessage();
            return new List<ResultadoAdjuntos>{resultadoAdjuntos};
        }
        consultarAdjuntos(parametrosAdjuntos[0].activityIdSalesforce, requestXML, parametrosAdjuntos[0].activityIdRemedy, parametrosAdjuntos[0].caseId, parametrosAdjuntos[0].endPointWS, parametrosAdjuntos[0].actionWS);
        resultadoAdjuntos.operacionExitosa = true;
        resultadoAdjuntos.mensajeOperacion = Label.CE_ExitoAdjuntos;
        return new List<ResultadoAdjuntos>{resultadoAdjuntos};
    }
    
    /**
    * @description método utilizado para la consulta en Remedy de los archivos adjuntos asociados a una
    *              actividad de seguimiento
    * @param idActividadSalesforce id de la actividad de seguimiento en Salesforce
    * @param requestXML XML para el Request del servicio web
    * @param idActividadRemedy id de la actividad de seguimiento en Remedy
    * @param caseId parámetros id del caso asociado a la tarea de agendamiento a la que pertenece la actividad 
    *        de seguimiento
    * @param endpointWS endpoint para el servicio web
    * @param actionWS action para el servicio web
    */
    @future(callout=true)
    public static void consultarAdjuntos(Id idActividadSalesforce, String requestXML, String idActividadRemedy, Id caseId, String endpointWS, String actionWS){
        String response = '';
        String mensajeEmail = 'La consulta de los archivos adjuntos asociados a la actividad de seguimiento '+ idActividadRemedy + ' ha finalizado. \n';
        try{
            /*Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración 
            del servicio web*/
            response = CE_UtilityWS_cls.consultarServicio(requestXML, actionWS, endPointWS , caseId);
        }catch(Exception exc){
            publishEmail(mensajeEmail + exc.getMessage(), idActividadSalesforce);
        }
        if(!String.isBlank(response)){
            Map<String, String> getAttachmentsResult = new Map<String, String>();
            tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
            //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
            getAttachmentsResult.putAll(proReq.getMap(response));
            //Se valida si el Response fue exitoso o si hubo algún error
            if(!getAttachmentsResult.get('Codigo').startsWithIgnoreCase('F')){
                Boolean emailEnviado = false;
                List<WrapperAttachment> listadoAdjuntos = new List<WrapperAttachment>();
                if(!String.isBlank(getAttachmentsResult.get('SoportesIngreso'))){
                    try{
                        //Se deserealiza el JSON con el listado de los archivos adjuntos
                        listadoAdjuntos = (List<WrapperAttachment>) JSON.deserialize(getAttachmentsResult.get('SoportesIngreso'), List<WrapperAttachment>.class);
                    }catch(System.JSONException jsonException){
                        emailEnviado = true;
                        publishEmail(mensajeEmail + 'El formato del JSON con la información de los archivos adjuntos es incorrecto.', idActividadSalesforce);
                    }
                }
                if(listadoAdjuntos.size()>0){
                    //Del listado obtenido anteriormente se realiza el proceso de inserción
                    deserealizarAdjuntos(idActividadSalesforce, idActividadRemedy, listadoAdjuntos);
                }
                else{
                    if(!emailEnviado){
                        publishEmail(mensajeEmail + 'No se han encontrado archivos adjuntos asociados a la actividad de seguimiento.', idActividadSalesforce);
                    }
                }  
            }
            else{
                publishEmail(mensajeEmail + getAttachmentsResult.get('DetalleEstado'), idActividadSalesforce);
            }
        }
    }
    
    /**
    * @description método utilizado para la creación de los archivos adjuntos de la actividad de seguimiento
    * @param idActividadSalesforce id de la actividad de seguimiento en Salesforce
    * @param idActividadRemedy id de la actividad en Remedy asociada a los archivos adjuntos
    * @param adjuntosWrapper listado con los archivos adjuntos obtenidos desde Remedy
    */
    public static void deserealizarAdjuntos(Id idActividadSalesforce, String idActividadRemedy, List<WrapperAttachment> adjuntosWrapper){
        List<Attachment> adjuntosRemedy = new List<Attachment>();
        CE_FollowUpActivity__c actividadSeguimiento = [SELECT Id, CE_ActivityId__c, CE_UploadedAttachments__c,
                                                       (SELECT Id, Name, ParentId, Description FROM attachments) 
                                                       FROM CE_FollowUpActivity__c 
                                                       WHERE CE_ActivityId__c=:idActividadRemedy Limit 1];
        //Se valida si el archivo adjunto ya fue creado anteriormente para excluirlo del proceso de creación
        for(Attachment archivoAdjunto : actividadSeguimiento.Attachments){
            for(Integer index = 0; index<adjuntosWrapper.size(); index++){
                if(archivoAdjunto.Name==adjuntosWrapper[index].AttachmentName && 
                   archivoAdjunto.Description=='Remedy'){
                       adjuntosWrapper.remove(index);
                }
            }
        }
        //Se realiza la creación de los archivos adjuntos nuevos en Salesforce                                                   
        for(WrapperAttachment archivoCrearWP : adjuntosWrapper){
            if(!String.isBlank(archivoCrearWP.AttachmentName) && !String.isBlank(archivoCrearWP.AttachmentData)){   
                /*Se hace la asignación de la información contenida en los wrapper a los registros de los
                archivos adjuntos*/
                Attachment archivoCrear = new Attachment();
                archivoCrear.Name = archivoCrearWP.AttachmentName;
                archivoCrear.Body = EncodingUtil.base64Decode(archivoCrearWP.AttachmentData);
                archivoCrear.ParentId = actividadSeguimiento.Id;
                archivoCrear.Description = 'Remedy';
                adjuntosRemedy.add(archivoCrear);
            }
        }
        String mensajeEmail = 'La consulta de los archivos adjuntos asociados a la actividad de seguimiento '+ idActividadRemedy + ' ha finalizado. \n';
        if(adjuntosRemedy.size()>0){
            Decimal contadorAdjuntos = actividadSeguimiento.CE_UploadedAttachments__c;
            //Se realiza la inserción de los archivos adjuntos
            List<Database.UpsertResult> upsertResults = Database.upsert(adjuntosRemedy, False);
            String mensajeFallo = '';
            String mensajeExito= '';
            for(Integer index = 0; index<upsertResults.size(); index++){
                if(!upsertResults[index].isSuccess()){
                    mensajeFallo = mensajeFallo +  'Nombre archivo adjunto: ' + adjuntosRemedy[index].Name +'. Errores:';
                    for(Database.Error errorMensaje : upsertResults[index].getErrors()){
                        mensajeFallo = mensajeFallo + ' ' +errorMensaje.getMessage() + '.';
                    }
                    mensajeFallo = mensajeFallo + '\n';
                }else{
                    actividadSeguimiento.CE_UploadedAttachments__c++;
                    mensajeExito = mensajeExito + 'Nombre archivo adjunto: ' + adjuntosRemedy[index].Name + '. \n';
                }
            }
            //Se valida si hubo algún cambio en el contador de archivos adjuntos
            if(actividadSeguimiento.CE_UploadedAttachments__c!=contadorAdjuntos){
                Database.update(actividadSeguimiento, false);
            }
            //Se valida si algún archivo adjunto completó su proceso de inserción para notificar al usuario
            if(!String.isBlank(mensajeExito)){
                mensajeEmail = mensajeEmail + 'Los siguientes archivos adjuntos fueron generados correctamente: \n' + mensajeExito;
            }
            //Se valida si algún archivo adjunto falló su proceso de inserción para notificar al usuario sobre el error
            if(!String.isBlank(mensajeFallo)){
                mensajeEmail = mensajeEmail + 'Los siguientes archivos adjuntos no pudieron ser generados correctamente: \n' + mensajeFallo;
            }
        }else{
            mensajeEmail = mensajeEmail + 'No se han encontrado archivos adjuntos nuevos asociados a la actividad de seguimiento.';
        }
        publishEmail(mensajeEmail, idActividadSalesforce);
    }
}