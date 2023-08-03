/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Implementación de la matriz de homologación para la integración con SIEBEL

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-05-08		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/

public class ContingenciaIntegracionSIEBEL_cls  {

	public static void DeterminarHomologacion (map<Id, OperacionComercial__c> mapNew, map<Id, OperacionComercial__c> mapOld) {
		//	Condición de entrada
		if (!mapNew.isEmpty() && mapNew != null) {
			//	Segregación de registros
			list<Id> lstIdOp = new list<Id>();
			for (OperacionComercial__c oc : mapNew.values()) {
				if (oc.Estado_SIEBEL__c != null && oc.Estado_SIEBEL__c != mapOld.get(oc.id).Estado_SIEBEL__c) {
					lstIdOp.add(oc.id);
				}
			}
			if (lstIdOp.size() > 0) {
				//	Procesamiento de Homologación
				for (id i : lstIdOp) {
					system.debug(mapNew.get(i).FechadeActivacion__c);
					//	Estado SIEBEL: Cancelado
					if ( mapNew.get(i).Estado_SIEBEL__c == 'Cancelado') {
						mapNew.get(i).EstadoAprovisionamiento__c = 'Cerrado';
						mapNew.get(i).Estado__c = 'Declinada';
						mapNew.get(i).FechadeActivacion__c = mapOld.get(i).FechadeActivacion__c;
						mapNew.get(i).NumeroConexion__c = mapOld.get(i).NumeroConexion__c;
					}
					//	Estado SIEBEL: Completo
					else if (mapNew.get(i).Estado_SIEBEL__c == 'Completo') {
						mapNew.get(i).EstadoAprovisionamiento__c = 'Cerrado';
						mapNew.get(i).Estado__c = 'Activa';
					}
					//	Estado diferente a los especificados en la matriz de homologación
					else {
						//mapNew.get(i).NumerodePedido__c = mapOld.get(i).NumerodePedido__c;
						//mapNew.get(i).Solicitud_SIEBEL__c = mapOld.get(i).Solicitud_SIEBEL__c;
						mapNew.get(i).Estado_SIEBEL__c = mapOld.get(i).Estado_SIEBEL__c;
						//mapNew.get(i).NumeroConexion__c = mapOld.get(i).NumeroConexion__c;
						mapNew.get(i).FechadeActivacion__c = mapOld.get(i).FechadeActivacion__c;
					}
				}
			}
		}
		
	}

}