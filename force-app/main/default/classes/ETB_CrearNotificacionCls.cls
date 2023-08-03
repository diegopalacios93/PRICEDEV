/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB EPC/CPQ Industries
    Description:    Metodos para generar notificaciones

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         28-09-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase metodo para generar notificacion 
 */
public with sharing class ETB_CrearNotificacionCls {

    /**
     * @description obtener el tipo de notificacion
     * @param nameNotification
     */
    public static CustomNotificationType getNotificationType (String nameNotification){
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
            FROM CustomNotificationType 
            WHERE DeveloperName=:nameNotification]; 
        return notificationType;
    }

    /**
     * @description envio de notificacion
     * @param recipientsIds
     * @param targetId
     * @param title
     * @param body
     * @param notificationType
     */
    public static void notifyUsers(Set<String> recipientsIds, String targetId,String title,String body,CustomNotificationType notificationType) {
        try {           
            // Create a new custom notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();

            // Set the contents for the notification
            notification.setTitle(title);
            notification.setBody(body);

            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(targetId);
        
            // Actually send the notification
        
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'Problem sending notification: ' +e.getLineNumber()+'-'+ e.getMessage());
        }
    }
}