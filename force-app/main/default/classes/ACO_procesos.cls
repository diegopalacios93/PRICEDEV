/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripcion:            Clase que contendra todos los metodos necesarios para 
                        asegurar el proceso de los ACO

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     14-06-2021  Luisina Platino (LP)    Creacion de la clase.
*******************************************************************************/

public class ACO_procesos {
    public void sendBellNotification(ACO__c aco, Set<String> idrecipient) {

        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName 
            FROM CustomNotificationType 
            WHERE DeveloperName ='Oferta_Actualizada'
        ]; 

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        
        // Set the contents for the notification
        notification.setTitle('ACO - Oferta Actualizada');
        notification.setBody('El Estado Actividad de su ACO ' + aco.Name + ' fue actualizado.');
 
        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(aco.Id);
            
        // Actually send the notification
        try {
            notification.send(idrecipient);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

    public void sendMailToEngineer(Map<Id,ACO__c> mapACO, List<Oferta_Op_Viabilidad__c> lstOfV){
        
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(lstOfV.size());
        
        for(Oferta_Op_Viabilidad__c OfV : lstOfV){

            ACO__c aco = mapACO.get(OfV.Oferta_Op__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String[] toAddresses = new String[] {OfV.Viabilidad__r.Correo_Ing_Factibilidad__c};
            
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('no-responder@etb.com.co');
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName('ETB');
            
            // Specify the subject line for your email address.
            mail.setSubject('El ACO ' + aco.Name + ' fue devuelto');
            
            mail.setBccSender(false);
            mail.setUseSignature(false);
            
            mail.setHtmlBody('El ACO:<b> ' + aco.Name +' </b>ha se encuentra Devuelto.<p>'+
                'Debido a las siguientes observaciones: '+aco.Observaciones__c+'.');
            
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}