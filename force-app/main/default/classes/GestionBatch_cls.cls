/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Manuel Cortes
Proyecto:           LTE Evolutivos
Descripción:        Clase generica relacionada con los batch

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     19-07-2016  Manuel Cortes (MC)        Creación de la clase.
***********************************************************************************************************************/
public with sharing class GestionBatch_cls {
	
	/*********************************************************
	* Metodo encargado de retornar el tiempo de ejecución configurado
	* en la configuraon personalizada Tiempo_Ejecucion_Batch__c
	*********************************************************/
	public static Integer getTime(Type clazz, Integer intDefaultTime){
		List<Tiempo_Ejecucion_Batch__c> lstConfig = [SELECT Name, Tiempo_Ejecucion__c FROM Tiempo_Ejecucion_Batch__c WHERE Name = :clazz.getName()];
		if(lstConfig.size() > 0){
			return Integer.valueOf(lstConfig[0].Tiempo_Ejecucion__c);
		}else{
			return intDefaultTime;
		}
		
	}
    
}