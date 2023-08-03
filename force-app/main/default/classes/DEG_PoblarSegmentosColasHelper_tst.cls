/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase test para la clase DEG_PoblarSegmentosColasHelper_bch

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     17/03/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
@isTest
private class DEG_PoblarSegmentosColasHelper_tst {

    /**
     * @description inserción de registros de prueba para los métodos test
     */
    @testSetup
    static void setup() {
        Profile perfilTest = [SELECT Id FROM Profile WHERE Name='Administrador del sistema']; 
        User usuario = new User(Alias = 'standt', Email='usuarioPruebaSegmentos@etb.com.co', 
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = perfilTest.Id, 
		TimeZoneSidKey='America/Los_Angeles', UserName='usuarioPruebaSegmentos@etb.com.co');
        insert usuario;
    }
    
    /**
     * @description prueba de llamado del batch
     */
    @isTest
    static void scheduleBatchTest() {
        Test.startTest();
		User usuario = [SELECT Id FROM User WHERE Email='usuarioPruebaSegmentos@etb.com.co' LIMIT 1];
        Map<ID, String> mapaTest = new Map<ID, String>();
        mapaTest.put(usuario.id,'Ventas');
        DEG_PoblarSegmentosColasHelper_bch poblarSegmentos = new DEG_PoblarSegmentosColasHelper_bch(mapaTest);
		Id batchCola = Database.executeBatch(poblarSegmentos);
        System.assert(batchCola!=null);
        Test.stopTest();
    }   
}