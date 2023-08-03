/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Trigger para disparar la creacion de las OCs para tramites
						 
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     12-08-2015   Sergio Ortiz                	Creación de la clase.
**************************************************************************************/
trigger Tramites_tgr on Tramites__c (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete) {

		//Bloque Before
		if (Trigger.isBefore) {
	    	OperacionesTramites_cls cls = new OperacionesTramites_cls();
	    	//Bloque BeforeInsert
	    	if (trigger.isInsert){
	            //enviar los registros de tramites para la creacion de las OCs.
	            cls.CrarOperacionesComercialesTramites(trigger.new);
	        }
	        /*
	        else if(trigger.isUpdate){
	            
	        }
	        else if(trigger.isDelete){
	            
	        }
	       */ 	    	    
		} 
		/*
		//Bloque After		 
		else if (Trigger.isAfter) {
	    	
	        //Bloque AfterInsert
	        if (trigger.isInsert){          
	        }        
	        
	        //Bloque AfterUpdate
	        else if (trigger.isUpdate){
	            
	        }
	        //bloque afterDelete        
	        else if(trigger.isDelete)
	        {
	            
	        }	        	   
		}
		*/ 
}