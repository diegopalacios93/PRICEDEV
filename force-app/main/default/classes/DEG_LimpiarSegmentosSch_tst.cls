/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase test para la clase DEG_LimpiarSegmentos_sch

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     05/04/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
@isTest
private class DEG_LimpiarSegmentosSch_tst {

    /**
     * @description prueba de programación de la clase schedule
     */
    @isTest
    static void scheduleBatch(){
        Test.startTest();
        String CRON_EXP = '0 59 23 * * ?';
        Id schedulableId = System.schedule('ScheduledApexTest',
                                       		CRON_EXP,
                                       		new DEG_LimpiarSegmentos_sch());
        System.assert(schedulableId!=null);
        Test.stopTest();
    }
    
}