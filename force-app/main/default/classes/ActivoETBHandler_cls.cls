/**
 * @description       : Clase Handler del trigger del objeto ActivoETB__c
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 01-06-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
public with sharing class ActivoETBHandler_cls {
    
    /**
    * @description 
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 12-29-2021 
    * @param activosViejos 
    * @param activosNuevos 
    **/
    public static void AlarmaCambioNumeroConexion(List<ActivoETB__c> activosViejos, List<ActivoETB__c> activosNuevos)
    {
        Map<String,String> activosNumeroCambiado = new Map<String,String>();

        for(ActivoETB__c actN: activosNuevos )
        {
            for(ActivoETB__c actV: activosViejos )
            {
                if (actN.Id == actV.Id && actN.NumeroConexion__c != actV.NumeroConexion__c)
                {
                    activosNumeroCambiado.put(actV.NombredelaCuenta__c, actV.NumeroConexion__c);
                }
            }
        }

        System.Debug('activosNumeroCambiado '+activosNumeroCambiado);

        List<OperacionComercial__c> operacionesAux =[SELECT Id, Enrutamientos__c, Activo_Relacionado__c,  Activo_Relacionado__r.Name, 
                                                    Activo_Relacionado__r.NumeroConexion__c,  Activo_Relacionado__r.NombredelProducto__r.Familia__c, 
                                                    Activo_Relacionado__r.NombredelProducto__r.LineaNegocio__c, CuentaCliente__c,
                                                    CuentaCliente__r.Owner.Email, CuentaCliente__r.Owner.Name, CuentaCliente__r.Name,
                                                    Plan__r.NombredelProducto__r.Name
                                                    FROM OperacionComercial__c 
                                                    WHERE CuentaCliente__c IN :activosNumeroCambiado.keySet()
                                                    AND Activo_Relacionado__r.NombredelProducto__r.Familia__c = 'ENLACES DE VOZ' 
                                                    AND Activo_Relacionado__r.NombredelProducto__r.LineaNegocio__c = 'LOCAL' 
                                                    AND Plan__r.NombredelProducto__r.Name = 'Cobro revertido automatico'
                                                    ];


        System.Debug('operacionesAux '+operacionesAux);
        if(operacionesAux!=null && operacionesAux.Size()>0 && operacionesAux[0].Plan__c!=null)    
        {
            
            System.Debug('operacionesAux[0].Plan__r.NombredelProducto__r.Name '+operacionesAux[0].Plan__r.NombredelProducto__r.Name);    
            
        }                                          
        List<OperacionComercial__c>  operacionesAlarma = new List<OperacionComercial__c>();                                          

        for(OperacionComercial__c op : operacionesAux)
        {
            for(String numero: activosNumeroCambiado.values())
            {
                if (op.Enrutamientos__c != null && !String.IsBlank(op.Enrutamientos__c) && !String.IsBlank(numero) && op.Enrutamientos__c.contains(numero))
                {
                    operacionesAlarma.add(op);
                }
            }
        }

        System.Debug('operacionesAlarma '+operacionesAlarma);
        if(operacionesAlarma.Size()>0)
        {
            EnvioCorreoNotificacionAsesorComercial(operacionesAlarma);
            // System.Debug('Operaciones: '+ operacionesAlarma[0].CuentaCliente__r.Owner.Email +' '+ operacionesAlarma[0].CuentaCliente__r.Owner.Name);
        }
    }

    /**
    * @description Método donde se construye y se envía al correo de notificación al Asesor comercial (Account Owner) de la empresa
    * donde se realizó el cambio del número de conexión
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 12-30-2021 
    * @param operacionesAlarma 
    **/
    public static void EnvioCorreoNotificacionAsesorComercial(List<OperacionComercial__c>  operacionesAlarma)
    {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(OperacionComercial__c op : operacionesAlarma)
        {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String mailBody = 'Cordial Saludo '+op.CuentaCliente__r.Owner.Name+'.<br/>';
            System.debug('op.CuentaCliente__r.Owner.Email '+op.CuentaCliente__r.Owner.Email);
            email.setToAddresses(new String[]{op.CuentaCliente__r.Owner.Email,'caguac@hotmail.com'});//miguel.rafael.gomez@accenture.com
            email.setSubject('Cambio Número de Conexión');
            mailBody+='El presente es para informarle que el cliente '+op.CuentaCliente__r.Name+' ha cambiado el número de conexión ';
            mailBody+='en el Servicio '+op.Activo_Relacionado__r.Name+', lo que puede afectar el buen funcionamiento ';
            mailBody+='de los servicios que tienen los siguientes enrutamientos '+op.Enrutamientos__c+'.<br/>';
            mailBody+='No siendo más. Le deseamos feliz resto de día.';
            email.setHtmlBody(mailBody);
            emails.add(email);
        }
       if(emails.Size()>0)
       {
           System.Debug('emails '+emails[0]);
       }
		Messaging.sendEmail(emails);
    }
}