/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase llamada por el trigger sobre el obj Operación Comercial, encargada de 
						llenar algunos campos sobre operación comercial.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------	---------------
1.0     22-10-2013  Daniel Guana (AAC)		Creación de la clase. (88%)
1.1		18-02-2013	Jorge Grimaldos (JG)	Bug asignación de Sucursales. 
*******************************************************************************/ 

@isTest (SeeAllData=true)
private class LlenarCamposOC_tst {
    static testMethod void myUnitTest() {
        GeneraData_cls.generarData();
        String id = GeneraData_cls.generarOperacionComercial();
        
        //OperacionComercial__c oc = new OperacionComercial__c(Id = id);
        
        List<OperacionComercial__c> lstOc = new list<OperacionComercial__c>();
        lstOc.add(GeneraData_cls.oc);
        
        LlenarCamposOC_cls cls = new LlenarCamposOC_cls();
        cls.LlenarCuenta(lstOc);
        
        GeneraData_cls.oc.Oportunidad__c=null;
        cls.LlenarCuenta(lstOc);
    }
    
    /**
    *	1.1
    *	Método de prueba para Activos sin opp
    **/
    @istest static void TestNoOpp() {
    	
    	GeneraData_cls.generarPoblacion();
    	ActivoETB__c act = new ActivoETB__c();
    	act.Nombredelacuenta__c = GeneraData_cls.generarCuenta();
    	act.NombredelProducto__c = GeneraData_cls.generarCatalogoProductos();
    	insert act;
    	
    	OperacionComercial__c oc = new OperacionComercial__c();
		oc.Estado__c = 'Activa';
		oc.FechadeActivacion__c=System.today();
		oc.Activo__c = act.Id;
		insert oc;
		
		System.assertEquals(act.Nombredelacuenta__c,[Select CuentaCliente__c from OperacionComercial__c where id = :oc.id limit 1][0].CuentaCliente__c);
    }
}