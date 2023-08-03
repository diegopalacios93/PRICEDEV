/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_CancelarTareaXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     06/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_CancelarTareaXML_tst {

    /**
     * @description prueba para la generación del XML para la cancelación de una tarea de agendamiento
     */
    @isTest 
    static void closingTaskXMLTest(){
        Test.startTest();
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.estadoAgendamiento = 'Pendiente';
        parametroCancelacion.scheduleId = '8736531';
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        String requestXML = CE_CancelarTareaXML_cls.crearXMLCancelarTarea(parametroCancelacion);
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
    
    /**
     * @description prueba para la generación del XML para la cancelación de una tarea de agendamiento cuando 
     * 				falta información obligatoria para el XML
     */
    @isTest 
    static void missingFieldsTest(){
        Test.startTest();
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.estadoAgendamiento = 'Pendiente';
        parametroCancelacion.scheduleId = '';
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        String requestXML = '';
        try{
			requestXML = CE_CancelarTareaXML_cls.crearXMLCancelarTarea(parametroCancelacion);
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML=='');
    }    
}