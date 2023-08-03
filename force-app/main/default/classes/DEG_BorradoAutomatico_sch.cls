/**************************************************************************************************************
* Globant México
* @author           Edgar Miranda Francisco
* Project:          ETB
* Description:      Clase Scheduler para Borrado Automatico
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description     
*           -----   ----------      --------------------    ---------------   
* @version   1.0    19/Mayo/2020    Edgar Miranda           Clase Creada
**************************************************************************************************************/

global without sharing class DEG_BorradoAutomatico_sch implements Schedulable {

    global void execute(SchedulableContext sc){
        Database.executeBatch(new DEG_BorradoAutomatico_bch('Case'),200);
    }

}