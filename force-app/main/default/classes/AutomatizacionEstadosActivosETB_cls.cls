/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase que maneja la automatización de estados de los 
						activos a partir de los cambios en sus operaciones 
						comerciales correspondientes
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		29-01-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/
public with sharing class AutomatizacionEstadosActivosETB_cls {
	
	public map<String, Automatizacion_Estados_OC__c> mapConfiguracionEstados = Automatizacion_Estados_OC__c.getAll();
	
	public void ActualizarActivos(map<Id, OperacionComercial__c> mapNew, map<Id, OperacionComercial__c> mapOld) {
		//	Condición de entrada
		if ( mapNew != null && mapOld != null && !mapNew.isEmpty() && !mapOld.isEmpty()) {
			//	Análisis de registros para determinar qué registros consultar
			list<Id> lstIdActivos = new list<Id>();
			list<Id> lstIdOC = new list<Id>();
			for (Id idOC: mapNew.keySet()) {
				if (mapNew.get(idOC).Estado__c != mapOld.get(idOC).Estado__c) {
					lstIdActivos.add(mapNew.get(idOC).Activo__c);
					lstIdOC.add(idOC);
				}
			}
			//	Consulta de registros
			if (!lstIdOC.isEmpty() && !lstIdActivos.isEmpty()) {
				map<Id, ActivoETB__c> mapActivos = new map<Id, ActivoETB__c>([select Id, Estado__c from ActivoETB__c where id in :lstIdActivos]);
				map<Id, OperacionComercial__c> mapOC = new map<Id, OperacionComercial__c>([select Id, TOPP__r.TipodeOperacionporplan__c, Activo__c, Activo__r.Estado__c from OperacionComercial__c where id in :lstIdOC]);
				if (!mapActivos.isEmpty() && !mapOC.isEmpty()) {
					list<ActivoETB__c> lstActivosActualizar = new list<ActivoETB__c>();
					for (OperacionComercial__c oc : mapOC.values()) {
						//	Verificación y asignación de estados a partir de la configuración personalizada
						String strLlaveConfig = oc.TOPP__r.TipodeOperacionporplan__c + ' ' + mapNew.get(oc.Id).Estado__c;
						if (mapConfiguracionEstados.containsKey(strLlaveConfig)) {
							if (mapConfiguracionEstados.get(strLlaveConfig).Estado_Activo_ETB__c != mapActivos.get(oc.Activo__c).Estado__c) {
								mapActivos.get(oc.Activo__c).Estado__c = mapConfiguracionEstados.get(strLlaveConfig).Estado_Activo_ETB__c;
								lstActivosActualizar.add(mapActivos.get(oc.Activo__c));
							}
						}
					}
					if (!lstActivosActualizar.isEmpty()) {
						update lstActivosActualizar;
					}
				}
			}
		}
	}
}