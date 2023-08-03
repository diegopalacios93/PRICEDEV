/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase que es llamada desde el trigger OperacionComercial_tgr, encargada de actualizar la 
					fecha en la cual un equipo fue adquirido, esa fecha esta en el ActivoETB__c

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-02-05      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_ActualizarEquipoTraido_cls {
	
	/**
	* Metodo encargado de validar que las OC tengan estado Equipo entregado y si es asi
	* se encarga de llamar el metodo que actualiza la fecha del equipo en el Activo
	*/
	public void actualizarEquipoEntregado(map<id,OperacionComercial__c> OCnews,map<Id,OperacionComercial__c> OCold){
		list<Id> lstIdOC = new list<Id>();
		for(id OCid :OCnews.keyset()){
			if(OCnews.get(OCid).Estado__c != OCold.get(OCid).Estado__c && OCnews.get(OCid).Estado__c == 'Equipo entregado'){
				lstIdOC.add(OCid);
			}
		}
		
		if(!lstIdOC.isEmpty()){
			actualizarEquipoEntregadoFuturo(lstIdOC);
		} 
	}
	
	/**
	* Metodo encargado de obtener los registros que cumplan las condiciones
	* para realizar la actualizacion del campo LTE_Fecha_equipo_adquirido__c
	*/
	@future
	public static void actualizarEquipoEntregadoFuturo(list<Id> lstIdOC){
		
		
		list<LTE_DetalleOferta__c> lstDO = new list<LTE_DetalleOferta__c>();
		list<LTE_DetalleOferta__c> lstDOAux = new list<LTE_DetalleOferta__c>();
		list<ActivoETB__c> lstActivoETB;
		Map<string,VariablesGlobales__c> vGlobal;
		
		vGlobal = VariablesGlobales__c.getAll();
		String producto = vGlobal.get('NombreComercialLTE').valor__c;
		
		lstDO = [SELECT Id, LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c, LTE_OperacionComercial__r.LTE_TipoTransaccion__c FROM LTE_DetalleOferta__c WHERE LTE_OperacionComercial__c IN :lstIdOC AND LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c IN ('Venta', 'Renovación', 'Reposición') AND LTE_OperacionComercial__r.TOPP__r.LTE_Catalogo_de_Producto__r.Name = :producto AND LTE_ReferenciaEquipo__r.Name != :Label.LTE_EquipoTraido];
		
		if(!lstDO.isEmpty()){
			for(LTE_DetalleOferta__c objDO : lstDO){
				if(objDO.LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c == 'Renovación' || objDO.LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c == 'Reposición'){
					if(objDO.LTE_OperacionComercial__r.LTE_TipoTransaccion__c == 'Equipo' || objDO.LTE_OperacionComercial__r.LTE_TipoTransaccion__c == 'Equipo más SIM'){
						lstDOAux.add(objDO);
					}
				} else{
					lstDOAux.add(objDO);
				}
			}
			
			if(!lstDOAux.isEmpty()){
				lstActivoETB = new list<ActivoETB__c>();
				lstActivoETB = [SELECT Id, LTE_Fecha_equipo_adquirido__c FROM ActivoETB__c WHERE LTE_DetalleOferta__c IN :lstDOAux];
				if(!lstActivoETB.isEmpty()){
					for(Integer i = 0; i<lstActivoETB.size(); i++){
						lstActivoETB[i].LTE_Fecha_equipo_adquirido__c = Date.today();
					}
					update lstActivoETB;	
				} 
			}
		} 
	}
    
}