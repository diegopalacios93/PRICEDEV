/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarCierreTareaXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     06/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarCierreTareaXML_tst {

    /**
     * @description prueba para la generación del XML para la consulta del cierre de una tarea de agendamiento
     */
    @isTest 
    static void closingTaskXMLTest(){
        Test.startTest();
        String requestXML = CE_ConsultarCierreTareaXML_cls.crearXMLConsultaCierre('TAS000000098739');
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
        String requestXML;
        try{
			requestXML = CE_ConsultarCierreTareaXML_cls.crearXMLConsultaCierre('');
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML==Null);
    }    
}