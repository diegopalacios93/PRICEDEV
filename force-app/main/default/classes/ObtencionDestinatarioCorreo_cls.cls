/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase que se encarga de obtener el destinatario de los 
						correos de notificación (actualmente Viabilidad, si las
						referencias de OC y Legalización se ven colmadas, éste
						es el espacio para agregar los desarrollos que 
						reemplacen las acciones de actualizaciones de campo)

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		05-02-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/
public with sharing class ObtencionDestinatarioCorreo_cls {
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
}