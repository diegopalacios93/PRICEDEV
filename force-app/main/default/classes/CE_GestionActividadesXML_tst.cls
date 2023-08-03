/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_GestionActividadesXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     06/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_GestionActividadesXML_tst {

    /**
     * @description prueba para la generación del XML para la consulta del cierre de una tarea de agendamiento
     */
    @isTest 
    static void closingTaskXMLTest(){
        Test.startTest();
        CE_GestionActividadesRemedy_cls.ParametrosActividad parametroActividad = new CE_GestionActividadesRemedy_cls.ParametrosActividad();
        parametroActividad.taskId = 'TAS000000098739';
        parametroActividad.resumen = 'Resumen';
        parametroActividad.usuario = 'pruebasETB@etb.com.co';
        parametroActividad.estadoActividad = 'Pendiente';
        parametroActividad.subEstado = 'Pendiente Recurso';
        String requestXML = CE_GestionActividadesXML_cls.crearXMLCrearActividad(parametroActividad);
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
    
    /**
     * @description prueba para la generación del XML para la consulta del cierre de una tarea de agendamiento cuando 
     * 				falta información obligatoria para el XML
     */
    @isTest 
    static void missingFieldsTest(){
        Test.startTest();
        CE_GestionActividadesRemedy_cls.ParametrosActividad parametroActividad = new CE_GestionActividadesRemedy_cls.ParametrosActividad();
        parametroActividad.taskId = '';
        parametroActividad.resumen = 'Resumen';
        parametroActividad.usuario = 'pruebasETB@etb.com.co';
        parametroActividad.estadoActividad = 'Pendiente';
        parametroActividad.subEstado = 'Pendiente Recurso';
        String requestXML = '';
        try{
			requestXML = CE_GestionActividadesXML_cls.crearXMLCrearActividad(parametroActividad);
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML=='');
    }    
}