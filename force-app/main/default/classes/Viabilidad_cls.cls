/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripcion:            Clase que contendra todos los metodos necesarios para 
                        asegurar el proceso de las Viabilidades

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     14-06-2021  Luisina Platino (LP)    Creacion de la clase. 
                                            Unificacion de metodos en una unica clase
*******************************************************************************/

public class Viabilidad_cls {

    public void sendBellNotification(ACO__c aco, Set<String> idrecipient) {

        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName 
            FROM CustomNotificationType 
            WHERE DeveloperName ='Viabilidad_Cerrada'
        ]; 

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        // Set the contents for the notification
        notification.setTitle('Viabilidad Cerrada');
        notification.setBody('La Viabilidad relacionada a su ACO ' + aco.Name +' ha sido cerrada.');

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

    public void ObtenerDestinatarioViabilidad (map<Id, Viabilidad__c> mapNew, map<Id, Viabilidad__c> mapOld) {
		if (mapNew != null && !mapNew.isEmpty()) {
			list<Id> lstIdViabilidades = new list<Id>();
			for (Viabilidad__c v : mapNew.values()) {
				if (v.EstadoViabilidad__c != mapOld.get(v.Id).EstadoViabilidad__c) {
					lstIdViabilidades.add(v.id);
				}
			}
			if (!lstIdViabilidades.isEmpty()) {
				list<Viabilidad__c> lstViabilidades = [select id, OperacionComercial__r.CuentaCliente__r.Owner.Email,  Destinatario_Notificacion_Cambio_Estados__c from Viabilidad__c where id in :lstIdViabilidades];
				for (Viabilidad__c v : lstViabilidades) {
					mapNew.get(v.id).Destinatario_Notificacion_Cambio_Estados__c = v.OperacionComercial__r.CuentaCliente__r.Owner.Email;
				}
				System.debug('lstViabilidades:' + lstViabilidades);
			}
		}
	}

    public void ActualizarTipoVentaOC(List<Viabilidad__c> lstViabilidades) {
            System.debug('@@-lstViabilidades->'+lstViabilidades);
            //configuracion personalizada para excluir servicios LTE	
            VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
            Set<String> setIdOperacionComercial = new Set<String>();
            //Crear un Set con los Ids de las Operaciones Comerciales
            for(Viabilidad__c objViabilidad: lstViabilidades) 
                setIdOperacionComercial.add(objViabilidad.OperacionComercial__c);
            
            //Crear un mapa con las Operaciones comerciales a actualizar
            Map<Id, OperacionComercial__c> mapOCs = new Map<Id, OperacionComercial__c>([SELECT Id,TipoVenta__c,Plan__r.NombredelProducto__r.Name 
                                                                                       FROM OperacionComercial__c 
                                                                                       WHERE Id IN: setIdOperacionComercial
                                                                                       AND Plan__r.NombredelProducto__r.Name !=: vGlobal.Valor__c]);
            System.debug('@@-mapOCs-1->'+mapOCs);
            //Recorrer las Viabilidades Actualizando las OCs
            
            for(Viabilidad__c objViabilidad: lstViabilidades) { 
                if(mapOCs.get(objViabilidad.OperacionComercial__c).Plan__r.NombredelProducto__r.Name != vGlobal.Valor__c) {
                    if(objViabilidad.Tipo_de_Aliado__c== Label.Colaborador)
                        mapOCs.get(objViabilidad.OperacionComercial__c).TipoVenta__c = Label.Alianza;
                    if(objViabilidad.Tipo_de_Aliado__c== Label.Proveedor)
                        mapOCs.get(objViabilidad.OperacionComercial__c).TipoVenta__c = Label.Reventa;
                    if(objViabilidad.Tipo_de_Aliado__c== Label.Reventa)
                        mapOCs.get(objViabilidad.OperacionComercial__c).TipoVenta__c = Label.Reventa;
                    if(objViabilidad.Tipo_de_Aliado__c==Label.Distribuidor)
                        mapOCs.get(objViabilidad.OperacionComercial__c).TipoVenta__c = Label.Reventa;
                    if(objViabilidad.Tipo_de_Aliado__c==Label.Productivizacion)
                        mapOCs.get(objViabilidad.OperacionComercial__c).TipoVenta__c = Label.Productivizacion;
                    if(objViabilidad.Aliado__c!=null)
                        mapOCs.get(objViabilidad.OperacionComercial__c).AliadoColaborador__c = objViabilidad.Aliado__c;
                }
            }
            System.debug('@@-mapOCs-2->'+mapOCs);
            //Actualiazar las OCs
            update mapOCs.values();		
    }
}