/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para Controlador de la página OperacionesComercialesLegalizar_pag encargada de seleccionar
                        las operaciones comerciales a legalizar 

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-10-2013  Daniel Guana (DGUANA)       Creación de la clase. (87% cobertura)
*******************************************************************************/

@isTest
private class OperacionesComercialesLegalizar_tst {
    static testMethod void myUnitTest() {
        GeneraData_cls.generarData();
        String id = GeneraData_cls.generarContrato();
        
        OperacionesComercialesLegalizar_ctr cls = new OperacionesComercialesLegalizar_ctr();
        ApexPages.currentPage().getParameters().put('id',id);
        cls.Iniciar();
        
        List<OperacionesComercialesLegalizar_ctr.wrpResultados> lstWRP = new List<OperacionesComercialesLegalizar_ctr.wrpResultados>();
       	OperacionesComercialesLegalizar_ctr.wrpResultados wrp = new OperacionesComercialesLegalizar_ctr.wrpResultados();
       	wrp.blnSel = true;
       	lstWRP.add(wrp);
       	cls.lstResult = lstWRP;
        
        cls.AnalizaAccion();
        cls.Crear();
        cls.MostrarError();
        cls.Cancelar();
        cls.DoNothing();
    }
}