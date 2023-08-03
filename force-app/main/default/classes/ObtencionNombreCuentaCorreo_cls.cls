/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Clase para el manejo de la obtención de los nombres de Cuenta para las notificaciones de correo de
					cambio de estado de Operación Comercial, Viabilidad y Legalización

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-03-31		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/

public with sharing class ObtencionNombreCuentaCorreo_cls {
	public static void ObtenerNombreCuentaOC (map<Id, OperacionComercial__c> mapNew, map<Id, OperacionComercial__c> mapOld) {
		if ( mapNew != null && !mapNew.isEmpty() ) {
			list<Id> lstIdOC = new list<Id>();
			for (OperacionComercial__c oc : mapNew.values()) {
				if (oc.Estado__c != mapOld.get(oc.Id).Estado__c) {
					lstIdOC.add(oc.Id);
				}
			}
			if (!lstIdOC.isEmpty()) {
				list<OperacionComercial__c> lstOC = [Select Id, Activo__r.NombredelaCuenta__r.Name from OperacionComercial__c Where Id in :lstIdOC ];
				for (OperacionComercial__c oc : lstOC) {
					mapNew.get(oc.Id).Nombre_cuenta__c = oc.Activo__r.NombredelaCuenta__r.Name;
				}
			}
		}
	}
}