/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para Controlador de la página EntregaGestionProyecto_pag encargada de guardar masivamente
                        el campo de envío gerente proyecto ó envío soporte ventas desde la Legalización.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-10-2013  Daniel Guana (DGUANA)       Creación de la clase. (78%) 
*******************************************************************************/

@isTest
private class EntregaGestionProyecto_tst {
    static testMethod void myUnitTest() {
        GeneraData_cls.generarData();
        String id = GeneraData_cls.generarLegalizacion();
        
        EntregaGestionProyecto_ctr cls = new EntregaGestionProyecto_ctr();
        
        ApexPages.currentPage().getParameters().put('id', id);
        
        cls.CargarLabels();
        cls.Iniciar();
        cls.Enviar();
        cls.Cancelar();
        cls.AnalizaAccion();
        cls.VerificarEnvioGerenteP();
    }
}