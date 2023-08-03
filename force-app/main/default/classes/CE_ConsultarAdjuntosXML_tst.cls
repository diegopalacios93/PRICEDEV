/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarAdjuntosXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     19/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarAdjuntosXML_tst {

    /**
     * @description prueba para la generación del XML para la obtención de archivos adjuntos asociados a una 
     *              actividad de seguimiento
     */
    @isTest 
    static void getAttachmentsXMLTest(){
        Test.startTest();
        String requestXML = CE_ConsultarAdjuntosXML_cls.crearXMLConsultaAdjuntos('AGYAA5V0FGDKOARC4TSNRB5RPYURMM');
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
    
    /**
     * @description prueba para la generación del XML para la obtención de archivos adjuntos asociados a una 
     *              actividad de seguimiento cuando falta información obligatoria para el XML
     */
    @isTest 
    static void missingFieldsTest(){
        Test.startTest();
        String requestXML;
        try{
            requestXML = CE_ConsultarAdjuntosXML_cls.crearXMLConsultaAdjuntos('');
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(requestXML==Null);
    }    
}