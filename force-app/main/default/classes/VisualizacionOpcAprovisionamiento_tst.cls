/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase de prueba para el controlador de visualización de las opciones de aprovisionamiento 

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2018-04-15   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
@isTest
private class VisualizacionOpcAprovisionamiento_tst {
    
	static testMethod void VisualAprovTest() {
    	IntegracionGestor_tst.crearData();
        List<Viabilidad__c> via = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad VisualAprovTest:' + via);
        List<OperacionComercial__c> OC = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2 VisualAprovTest:' + OC);
        ApexPages.currentPage().getParameters().put('id',via[0].id);
        VisualizacionOpcAprovisionamiento_ctr cls = new VisualizacionOpcAprovisionamiento_ctr();
        Id id = ApexPages.currentPage().getParameters().get('id');
        System.debug('Id pagina: ' + ApexPages.currentPage().getParameters().get('id'));
        Component.Apex.PageBlock pageBlock = new Component.Apex.PageBlock();
       	cls.Inicializacion();
        pageBlock = cls.getDynamicComp();
        cls.seleccionarOpcion();
        cls.getOpcion();
        //cls.setOpcion(opcion);
        cls.getOpcionesDisponibles();
        cls.regresar();
    }
}