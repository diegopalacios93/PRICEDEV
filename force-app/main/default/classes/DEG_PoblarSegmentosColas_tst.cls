/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase test para la clase DEG_PoblarSegmentosColas_bch

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     17/03/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
@isTest
private class DEG_PoblarSegmentosColas_tst {
    
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
        DEG_PoblarSegmentosColas_bch poblarSegmentos = new DEG_PoblarSegmentosColas_bch();
		Id batchCola = Database.executeBatch(poblarSegmentos);
        System.assert(batchCola!=null);
        Test.stopTest();
    }
}