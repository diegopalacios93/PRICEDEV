/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Jorge Grimaldos
Proyecto:           ETB Evolutivos
Descripción:        Clase de Prueba para el servicio expuesto por ConsultaCun_cls

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2014-03-17      Jorge Grimaldos (JG)        Creación de la clase.
***********************************************************************************************************************/

@isTest
private class ConsultaCunExpuesto_tst {

	//	Cargar la Configuración Personalizada de Respuestas a Códigos del WebService
	static void CargarEstadosRespuestasWebService() {	
		List<Estados_Respuestas_Webservice__c> lstEstados = new List<Estados_Respuestas_Webservice__c>();
		lstEstados.add(new Estados_Respuestas_Webservice__c(name = String.valueOf(ConsultaCunAux_cls.ESTADO_OK), Mensaje__c = String.valueOf(ConsultaCunAux_cls.ESTADO_OK)));
		lstEstados.add(new Estados_Respuestas_Webservice__c(name = String.valueOf(ConsultaCunAux_cls.ESTADO_ERROR_INTERNO), Mensaje__c = String.valueOf(ConsultaCunAux_cls.ESTADO_ERROR_INTERNO)));
		lstEstados.add(new Estados_Respuestas_Webservice__c(name = String.valueOf(ConsultaCunAux_cls.ESTADO_MAL_DATO), Mensaje__c = String.valueOf(ConsultaCunAux_cls.ESTADO_MAL_DATO)));
		lstEstados.add(new Estados_Respuestas_Webservice__c(name = String.valueOf(ConsultaCunAux_cls.ESTADO_MAL_NO_DATA), Mensaje__c = String.valueOf(ConsultaCunAux_cls.ESTADO_MAL_NO_DATA)));
		lstEstados.add(new Estados_Respuestas_Webservice__c(name = String.valueOf(ConsultaCunAux_cls.ESTADO_NO_ENCONTRADO), Mensaje__c = String.valueOf(ConsultaCunAux_cls.ESTADO_NO_ENCONTRADO)));
		insert lstEstados;
	}
	
	//	Prueba para el método de pruebas estructurales usado por CUN Center
	@isTest static void TestConsultaCunDummy() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		WebRequest.CUN = '1234567890123456';
		WebRequest.Telefono = '1234567890';
		WebRequest.Documento = '1234567890';
		Test.stopTest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCunDummy(WebRequest);
	}
	
	//	Prueba Consulta Cun con Parámetros Vacíos
	@isTest static void TestConsultaCunErrorNoData() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		Test.stopTest();
		System.assertEquals(ConsultaCunAux_cls.ESTADO_MAL_NO_DATA, WebResponse.Codigo);
	}

	//	Prueba Consulta Cun con Mal dato
	@isTest static void TestConsultaCunErrorMalDato() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		WebRequest.CUN = 'CUN';
		WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		Test.stopTest();
		System.assertEquals(ConsultaCunAux_cls.ESTADO_MAL_DATO, WebResponse.Codigo);
	}

	//	Prueba Consulta Cun Manejo Error Interno
	@isTest static void TestConsultaCunErrorErrorInterno() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		LibreriaUtilitaria_cls.ErrorExcepcionTest = true;
		WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		Test.stopTest();
		System.assertEquals(ConsultaCunAux_cls.ESTADO_ERROR_INTERNO, WebResponse.Codigo);
	}

	//	Prueba Consulta Cun con Dato No Encontrado
	@isTest static void TestConsultaCunErrorNoEncontrado() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		WebRequest.CUN = '9999999999999999';
		WebRequest.Documento = '9999999999999999';
		WebRequest.Telefono = '9999999999999999';
		Test.stopTest();
		WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		System.assertEquals(ConsultaCunAux_cls.ESTADO_NO_ENCONTRADO, WebResponse.Codigo);
	}
	
	@isTest static void TestConsultaCunCasos() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
        
        objPruebas_tst obj =new objPruebas_tst();
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;
    	
		Case caso = new	Case(accountId=cliente.id, CodigouniconumericoCUN__c = '1234567890123456',NumeroConexion__c='29872942482497');
		insert caso;
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		WebRequest.CUN = '1234567890123456';
		Test.stopTest();
		WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		System.assertEquals(ConsultaCunAux_cls.ESTADO_OK, WebResponse.Codigo);
		System.assertEquals(1,WebResponse.EstadoCun.size());
	}

	@isTest static void TestConsultaCunLegalizacion() {
		//	Cargar Datos Previos
		CargarEstadosRespuestasWebService();
		Legalizacion__c legalizacion = new Legalizacion__c( CodigouniconumericoCUN__c = '1234567890123456');
		insert legalizacion;
		Test.startTest();
		ConsultaCun_cls.WebRequest WebRequest = new ConsultaCun_cls.WebRequest();
		ConsultaCun_cls.WebResponse WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		WebRequest.CUN = '1234567890123456';
		Test.stopTest();
		WebResponse = ConsultaCun_cls.ConsultarEstadoCun(WebRequest);
		System.assertEquals(ConsultaCunAux_cls.ESTADO_OK, WebResponse.Codigo);
		System.assertEquals(1,WebResponse.EstadoCun.size());
		System.debug('WebResponse:' + WebResponse.EstadoCun);
	}
}