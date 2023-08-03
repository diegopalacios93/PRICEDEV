/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase con la logica para actualizar en ls OCs el campo 
						 Tipo Facturacion a variable si el contrato tiene facturacion
						 especial.
						 
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     14-10-2015  Sergio Ortiz                	Creación de la clase.
2.0		24-11-2015	Manuel Medina					Definicion del metodo @future actualizarOperacionesComerciales().
**************************************************************************************/
public with sharing class ActualizarTipoFacturacionVariable_cls {
	
	public void ActualizarTipoFacturacionVariable(List<Contract> lstContratos) {

		//configuracion personalizada para excluir servicios LTE	
		VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
		Set<String> setIdContratos = new Set<String>();
		//Crear un Set con los Ids de los contratos
		for(Contract objContrato: lstContratos) {
			if(objContrato.Forma_de_Pago__c == 'Si')
				setIdContratos.add(objContrato.Id);
		}
		System.debug('@@-setIdContratos->'+setIdContratos);
		
		
		/* BEGIN - Manuel Medina - Se traslada el codigo al metodo @future actualizarOperacionesComerciales - 24112015 */
		if( !System.isFuture() ){
			actualizarOperacionesComerciales( setIdContratos, vGlobal.Valor__c );
		}
		/*
		//Crear una lista con las OCs relacionadas a los contratos con facturacion especial
		List<OperacionComercial__c> lstOCs = new List<OperacionComercial__c>([SELECT Id,TipoFacturacion__c,Legalizacion__r.Contrato__c,Plan__r.NombredelProducto__r.Name 
																			  FROM OperacionComercial__c 
																			  WHERE Legalizacion__r.Contrato__c IN: setIdContratos
																			  AND Plan__r.NombredelProducto__r.Name !=: vGlobal.Valor__c]);
		System.debug('@@-lstOCs->'+lstOCs);
		//Recorrer la lista  Actualizando las OCs
		if(!lstOCs.isEmpty()) {
			for(OperacionComercial__c objOC: lstOCs) { 
				objOC.TipoFacturacion__c = Label.CobroVariable;
			}
			//Actualiazar las OCs
			update lstOCs;
		}
		*/
		/* END - Manuel Medina - Se traslada el codigo al metodo @future actualizarOperacionesComerciales - 24112015 */
	}
	
	 /**
	* @Method: 		actualizarOperacionesComerciales
	* @param: 		Set<String> setIdContratos
	* @param: 		String strVariableGlobal
	* @Description: Metodo @future encargado de actualizar las Operaciones Comerciales relacionadas con los Contratos desencadenantes del trigger Contract_tgr.
	* @author 		Manuel Medina - 24112015
	*/
    @future
    public static void actualizarOperacionesComerciales( Set<String> setIdContratos, String strVariableGlobal ){
    	//Crear una lista con las OCs relacionadas a los contratos con facturacion especial
		List<OperacionComercial__c> lstOCs = new List<OperacionComercial__c>([SELECT Id,TipoFacturacion__c,Legalizacion__r.Contrato__c,Plan__r.NombredelProducto__r.Name 
																			  FROM OperacionComercial__c 
																			  WHERE Legalizacion__r.Contrato__c IN: setIdContratos
																			  AND Plan__r.NombredelProducto__r.Name !=: strVariableGlobal]);
		System.debug('@@-lstOCs->'+lstOCs);
		//Recorrer la lista  Actualizando las OCs
		if(!lstOCs.isEmpty()) {
			for(OperacionComercial__c objOC: lstOCs) { 
				objOC.TipoFacturacion__c = Label.CobroVariable;
			}
			//Actualiazar las OCs
			update lstOCs;
		}
    }
}