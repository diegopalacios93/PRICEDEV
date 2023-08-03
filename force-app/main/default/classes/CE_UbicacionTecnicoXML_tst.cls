/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luis Carlos Oviedo Talaigua
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_UbicacionTecnicoXML_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     25/04/2022      Luis Carlos Oviedo Talaigua   
***************************************************************************************************/
@isTest
private class CE_UbicacionTecnicoXML_tst {
    /**
    * @description prueba para la generación del XML para la consulta de la ubicación del técnico
    */
    @isTest 
    static void ubicacionTecnocoXMLTest(){
        Test.startTest();
        String requestXML = CE_UbicacionTecnicoXML_cls.crearXMLUbicacionTecnico('INC000004699221');
        Test.stopTest();
        System.assert(requestXML!=Null);
    }
}