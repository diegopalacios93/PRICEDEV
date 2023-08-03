/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para Controlador de la página CrearTipificacion_pag encargada de seleccionar
                        la correcta tipificación para iniciar el caso.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     29-10-2013  Daniel Guana (DGUANA)       Creación de la clase.
*******************************************************************************/
@isTest
private class CrearTipificacion_tst {
	static testMethod void TipificarSoporteTecnicoTest() {
		GeneraData_cls.generarData();
		Id IdMat = GeneraData_cls.generarMatrizTipificacion();
        system.debug('IdMat: '+IdMat);
        Test.startTest();
		
        PageReference pageRef0 = Page.CrearTipificacion_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('newid',GeneraData_cls.caso2.Id);
		
		CrearTipificacion_ctr cls = new CrearTipificacion_ctr(new ApexPages.StandardController(new Case()));
		cls.AnalizaAccion();
		cls.Guardar();
		cls.Cancelar();
        
        Test.stopTest();
	}
    
	static testMethod void TipificarCasoPQRTest() {
		GeneraData_cls.generarData();
		GeneraData_cls.generarMatrizTipificacion2();
        Test.startTest();
        RecordType objRT 	   = [select id, developername from RecordType where Developername='CASO_PQR'];
        case oCaso = GeneraData_cls.caso2;
        oCaso.RecordTypeId = objRT.Id;
        oCaso.LTE_Servicio__c = null;
        update oCaso;
		
        PageReference pageRef0 = Page.CrearTipificacion_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('newid',GeneraData_cls.caso2.Id);
		
		CrearTipificacion_ctr cls = new CrearTipificacion_ctr(new ApexPages.StandardController(new Case()));
		cls.AnalizaAccion();
		cls.Guardar();
		cls.Cancelar();
        
        Test.stopTest();
	}
}