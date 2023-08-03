/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Jorge Grimaldos
Proyecto:           ETB Evolutivos
Descripción:        Clase de Prueba para la clase ObtencionDestinatarioCorreo

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2014-04-10      Jorge Grimaldos (JG)        Creación de la clase.
***********************************************************************************************************************/

@isTest
private class ObtencionDestinatarioCorreo_tst {
	
	@isTest static void ObtenerObtencionDestinatarioCorreoViabilidad() {
		//	Preparación del Test

		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;

		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		List<sObject> lstSobjetos = new List<sObject>();
		Account a = new Account(Name = 'Cuenta Test');

		objPruebas_tst obj =new objPruebas_tst();

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        insert Catalogo;

        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        insert plan;

        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;

        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion; 

		OperacionComercial__c oc = new OperacionComercial__c();
		Viabilidad__c v = new Viabilidad__c();
		lstSobjetos.add(a);
		lstSobjetos.add(oc);
		lstSobjetos.add(v);
		insert lstSobjetos;
		oc.CuentaCliente__c = a.id; 
		v.OperacionComercial__c = oc.id;
		update lstSobjetos;
		Test.startTest();
		v.EstadoViabilidad__c = 'Estado Nuevo';
		update v;
		Test.stopTest();
		v = [Select Destinatario_Notificacion_Cambio_Estados__c from Viabilidad__c Where Id = :v.id];
		//System.assertEquals(UserInfo.getUserEmail(), v.Destinatario_Notificacion_Cambio_Estados__c);
	}
}