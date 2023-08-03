/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarTareasXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     06/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarTareasXML_tst {

    /**
     * @description prueba para la generación del XML para la obtención de tareas de agendamiento asociadas a un 
     * 				incidente
     */
    @isTest 
    static void getTasksXMLTest(){
        Test.startTest();
        String requestXML = CE_ConsultarTareasXML_cls.crearXMLConsultaTareas('INC000004699221', '5002900000CqJzvAAF');
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
    
    /**
     * @description prueba para la generación del XML para la obtención de tareas de agendamiento asociadas a un 
     * 				incidente cuando falta información obligatoria para el XML
     */
    @isTest 
    static void missingFieldsTest(){
        Test.startTest();
        String requestXML;
        try{
			requestXML = CE_ConsultarTareasXML_cls.crearXMLConsultaTareas('', '5002900000CqJzvAAF');   
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML==Null);
    }
    
    /**
     * @description prueba para la generación del XML para la actualización de una tarea de agendamiento
     */
    @isTest 
    static void updateTasksXMLTest(){
        Test.startTest();
        String requestXML = CE_ConsultarTareasXML_cls.crearXMLConsultaDetalle('TAS000000098739');
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
    
    /**
     * @description prueba para la generación del XML para la actualización de una tarea de agendamiento cuando falta 
     * 				información obligatoria para el XML
     */
    @isTest 
    static void missingFieldsTest2(){
        Test.startTest();
        String requestXML;
        try{
			requestXML = CE_ConsultarTareasXML_cls.crearXMLConsultaDetalle('');   
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML==Null);
    }
}