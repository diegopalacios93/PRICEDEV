/***************************************************************************************************************************
*** Desarrollado por:     Avanxo Colombia                                                                                ***
*** Autor:                Andrés Oliva (AO)                                                                              ***
*** Proyecto:             ETB - LTE                                                                                      ***
*** Descripcion:          Clase Schedulable para ejecutar el Batch que declina las operaciones comerciales que no se     ***
***                       encuentren legalizadas despues de los siguientes  siete días de su creación.                   ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***  
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***            No.      Fecha              Autor         Descripción                                                     ***  
***           -----    ----------    --------------------  ---------------                                               ***
*** @version   1.0     2015-08-12    Andrés Oliva (AO)      Class created                                                ***
***************************************************************************************************************************/

global class LTE_DeclinarOC_sch implements Schedulable {
	global void execute(SchedulableContext sc) 
	{   
				

		LTE_DeclinarOC_bch objDeclinar = new LTE_DeclinarOC_bch();
		database.executebatch(objDeclinar,30);

	}

}