/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase con la logica para actualizar en ls OCs el campo 
						 Compensación de Datos.                      
						 
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     13-10-2015   Sergio Ortiz                	Creación de la clase.
**************************************************************************************/
public with sharing class ActualizarCompensacionesXPlan_cls {
	
	public void ActualizarCompensacionesXPlan(List<OperacionComercial__c> lstOCs) {
		//Mapa con los valores cargados en la configuracion personalizada AsignarCompensacion
		Map<string, AsignarCompensacion__c> mapCompensaciones = AsignarCompensacion__c.getAll();
		//configuracion personalizada para excluir servicios LTE	
		VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
		//Crear un Set con los Ids de las Operaciones Comerciales		

		Set<String> setIdOperacionComercial = new Set<String>();		
		for(OperacionComercial__c objOC: lstOCs) 
			setIdOperacionComercial.add(objOC.Id);

		//Crear un mapa con los Planes de las operaciones comerciales a actualizar
		Map<Id, OperacionComercial__c> mapOCs = new Map<Id, OperacionComercial__c>([SELECT Id,Name,Plan__c,Plan__r.Name,Plan__r.NombredelProducto__r.Name 
																				   FROM OperacionComercial__c 
																				   WHERE Id IN: setIdOperacionComercial
																				   AND Plan__r.NombredelProducto__r.Name !=: vGlobal.Valor__c]);

		if(!mapOCs.isEmpty()){
			for(OperacionComercial__c objOC: lstOCs) {
				if(mapOCs.get(objOC.Id).Plan__r.Name != null  && mapOCs.get(objOC.Id).Plan__r.NombredelProducto__r.Name != vGlobal.Valor__c) {
					String strNombrePlanOC = mapOCs.get(objOC.Id).Plan__r.Name;
					System.debug('@@-strNombrePlanOC ->'+strNombrePlanOC );
					if(mapCompensaciones.containsKey(strNombrePlanOC) && objOC.CompensacionDatos__c == null){
						objOC.CompensacionDatos__c = mapCompensaciones.get(strNombrePlanOC).IdCompensacion__c;
					}
				}
			}
		}
	}
}