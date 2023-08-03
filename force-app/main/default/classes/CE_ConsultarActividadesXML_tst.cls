/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarActividadesXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     07/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarActividadesXML_tst {
    
    /**
     * @description prueba para la generación del XML para la obtención de actividades de seguimiento asociadas a una 
     * 				tarea de agendamiento
     */
    @isTest 
    static void getActivitiesXMLTest(){
        Test.startTest();
        String requestXML = CE_ConsultarActividadesXML_cls.crearXMLConsultaActividades('TAS000000098739');
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
    
    /**
     * @description prueba para la generación del XML para la obtención de actividades de seguimiento asociadas a una 
     * 				tarea de agendamiento cuando falta información obligatoria para el XML
     */
    @isTest 
    static void missingFieldsTest(){
        Test.startTest();
        String requestXML;
        try{
			requestXML = CE_ConsultarActividadesXML_cls.crearXMLConsultaActividades('');
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML==Null);
    }
}