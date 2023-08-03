/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase con la logica para actualizar en ls OCs el campo 
						 Tipo Venta, segun el campo Tipo de Aliado en la Viabilidad.                         
						 
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     12-10-2015   Sergio Ortiz                	Creación de la clase.
**************************************************************************************/
public with sharing class ActualizarTipoVentaOC_cls {
	
	//Metodo para actualizar en la Operacion comercial el campo Tipo Venta
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