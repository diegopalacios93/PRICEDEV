/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase de prueba para el Controlador de la página DetallesTecnicosViabilidad_pag

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		23-01-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/

@isTest
private class DetallesTecnicosViabilidad_tst {

    @isTest static void TestDetallesTecnicos() {
    	
    	// Preparación del test
    	
    	GeneraData_cls.generarData();
        GeneraData_cls.generarViabilidad();
        
        test.startTest();
        
        PageReference pageRef = Page.DetallesTecnicosViabilidad_pag;
        pageRef.getParameters().put('id', GeneraData_cls.via.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController ctrVia = new ApexPages.StandardController(GeneraData_cls.via);
    	DetallesTecnicosViabilidad_ctr ctrTest = new DetallesTecnicosViabilidad_ctr(ctrVia);
    	ctrTest.getActivo();
    	ctrTest.getExistenDetalles();
    }
}