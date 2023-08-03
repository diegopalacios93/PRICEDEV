/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase encargada de ejecutar proceso batch de actualización de cuentas

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     10-10-2013  Daniel Guana (AAC)       	Creación de la clase..
*******************************************************************************/
global with sharing class BatchActualizaCuentasExec implements Schedulable{
	global BatchActualizaCuentasExec(){		 
	}		
	global void execute(SchedulableContext sc){
		Database.executeBatch( new BatchActualizaCuentas(),100);						        
	}

}