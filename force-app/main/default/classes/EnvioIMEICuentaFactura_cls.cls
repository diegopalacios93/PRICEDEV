/***********************************************************************************************************************
Desarrollado por:   Accenture Colombia
Autor:              Miguel R. Gómez
Proyecto:           Mypymes
Descripción:        Clase controladora del Batch para la construcción del archivo de IMEI´s y su posterior envío al correo.

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     14-12-2021  Miguel R. Gómez        Creación de la clase.
***********************************************************************************************************************/

public without sharing  class EnvioIMEICuentaFactura_cls {
    
    public static void ProcesarSolicitud(List<CuentaFacturacion__c> cuentasFacturacion)
    {
        String txt = '';
        String attName = 'Insumo_IMEI_';
        Date periodo = Date.Today();
        String subject = 'Insumo IMEI ';
        periodo = periodo.addMonths(-1);
        attName += String.ValueOf(periodo.Year())+'_' + String.ValueOf(periodo.Month())+'.txt';
        subject += String.ValueOf(periodo.Year())+'/' + String.ValueOf(periodo.Month());
        System.Debug('attName ' + attName);
        
        for(CuentaFacturacion__c cf : cuentasFacturacion){
            txt += cf.IMEISCF__c + '\n';
        } 

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Create the email attachment   
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(attName);
        efa.setBody(Blob.valueOf(txt));
        efa.setcontenttype('text/plain');

        // Set the paramaters to the email object
        email.setSubject( subject );
        email.setPlainTextBody( '' );        
        email.setToAddresses( new String[] { Label.CorreoEnvioInsumoImeis} );
        email.setSubject('Insumo de IMEI '+String.ValueOf(periodo.Year())+'/' + String.ValueOf(periodo.Month()));

        // Attach file using setFileAttachments function
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        // Sends the email
        System.Debug('email '+ email);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}, true);  
        System.Debug('Result '+ r);
        
        //Clear CF
        for(CuentaFacturacion__c cf : cuentasFacturacion){
            cf.ContieneIMEI__c = false;
            cf.IMEISCF__c = null;
        } 
        update cuentasFacturacion;
    }
}