/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase test para la clase DEG_LimpiarSegmentos_bch

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     05/04/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
@isTest
private class DEG_LimpiarSegmentosBch_tst {

    /**
     * @description inserción de registros de prueba para los métodos test
     */
    @testSetup
    static void setup() {
        
    }
    
    /**
     * @description prueba de llamado del batch
     */
    @isTest
    static void scheduleBatchTest() {
        Test.startTest();
        DEG_LimpiarSegmentos_bch limpiarSegmentos = new DEG_LimpiarSegmentos_bch();
		Id batchId = Database.executeBatch(limpiarSegmentos);
        System.assert(batchId!=null);
        Test.stopTest();
    }
}