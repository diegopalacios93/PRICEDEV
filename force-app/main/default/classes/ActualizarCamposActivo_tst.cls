/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                 	Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para encargada de la actualización de los campos del activo desde la operación comercial

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     29-10-2013  Daniel Guana (DGUANA)       Creación de la clase..
1.1     11-07-2016  Carlos Gonzalez (CG)        Nuevo método de Test.
*******************************************************************************/

@isTest
private class ActualizarCamposActivo_tst {
    static testMethod void myUnitTest() {
        GeneraData_cls.generarData();
        OperacionComercial__c oc = GeneraData_cls.oc;
        oc.Estado__c = 'Pendiente Facturacion';
        
        ActualizarCamposActivo_cls cls = new ActualizarCamposActivo_cls();
        cls.Actualizar(oc);
        
        List<Id> IdActivos = new List<Id>();
        IdActivos.add(oc.Activo__c);
        List<OperacionComercial__c> newoc = cls.CrearOCDesdeActivo(IdActivos);
    }
    
   	/*
    *@Description: Prueba el Método que actualiza la cuenta de facturación relacionada a la OC.
    */    
    static testMethod void unitTest2() {
        GeneraData_cls.generarData();
        OperacionComercial__c oc = GeneraData_cls.oc;

        test.startTest();
        oc.Estado__c = 'Activa';
        TOPP__c objTOPP = GeneraData_cls.topp;
        objTOPP.Tipoderegistro__c =  'Retiros';
        
        update objTOPP;
        
        OperacionComercial__c ocTemp = new OperacionComercial__c();
	    ocTemp.Estado__c = 'Activa';
	    ocTemp.FechadeActivacion__c=oc.FechadeActivacion__c;
	    ocTemp.Activo__c = oc.Activo__c;
	    ocTemp.AnchoBanda__c = oc.AnchoBanda__c;
	    ocTemp.Oportunidad__c = oc.Oportunidad__c;
	    ocTemp.ContratoAliado__c = oc.ContratoAliado__c;
	    ocTemp.Legalizacion__c = oc.Legalizacion__c;
	    ocTemp.TOPP__c = objTOPP.Id;
	    ocTemp.Plan__c = oc.Plan__c;
	    ocTemp.AnchoBanda__c = oc.AnchoBanda__c;
	    ocTemp.CuentaFacturacion__c = oc.CuentaFacturacion__c;
	    ocTemp.CuentaCliente__c = oc.CuentaCliente__c;       
        
		insert ocTemp;
        
        
        ActualizarCamposActivo_cls cls = new ActualizarCamposActivo_cls();
        cls.actualizarCtaFacturacion(ocTemp);
        
        test.stopTest();
    }      
}