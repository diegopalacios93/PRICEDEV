/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase de prueba para el Controlador de la página 
						SeleccionarActivoExistente_pag

Cambios (Versiones)
-------------------------------------
No.		Fecha		Autor						Descripción
------  ----------  --------------------        ---------------
1.0		27-01-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/
@isTest
private class SeleccionarActivoExistente_tst
{
	@isTest static void TestActivoExistente()
	{
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
	    vGlobal.Name = 'NombreComercialLTE';
	    vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
	    insert vGlobal;
		//	Preparación del Test
		Account a = new Account(Name = 'Test Account');
		a.Tipodedocumento__c = 'NIT';
		a.AccountNumber = '123454321';
		a.Segmento__c = 'Empresas';
		a.SubSegmento__c = 'Mediana';
		insert a;
		Opportunity opp = new Opportunity( AccountId = a.id, Name = 'Test Opp', StageName ='En Estudio', CloseDate = System.today() + 7);
		insert opp;
		List<ActivoETB__c> lstAct = new List<ActivoETB__c>();
		for (Integer i = 0; i < 21; i++) {
			ActivoETB__c act = new ActivoETB__c(Nombredelacuenta__c = a.id, Estado__c = 'Activo');
			lstAct.add(act);
		}
		insert lstAct;
		Test.startTest();
		//  Llamado de funciones y atributos
		PageReference pageRef = Page.SeleccionarActivoExistente_pag;
		pageRef.getParameters().put('id', opp.id);
		Test.setCurrentPage(pageRef);
		SeleccionarActivoExistente_ctr ctrTest = new SeleccionarActivoExistente_ctr();
		System.debug(ctrTest.lstActivos);
		ctrTest.TraerActivos();
		System.debug(ctrTest.lstActivos);
		System.debug(ctrTest.blnActivos);
		System.debug(ctrTest.blnAnterior);
		System.debug(ctrTest.blnOportunidad);
		System.debug(ctrTest.blnSiguiente);
		System.debug(ctrTest.intFinPagina);
		System.debug(ctrTest.intInicioPagina);
		System.debug(ctrTest.intTotalActivos);
		ctrTest.IrAnteriorPagina();
		ctrTest.IrPrimeraPagina();
		ctrTest.IrSiguientePagina();
		ctrTest.IrUltimaPagina();
		ctrTest.ElegirActivo();
		ctrTest.idActivo = lstAct[0].id;
		ctrTest.ElegirActivo();
		Test.stopTest();
	}
	
	@isTest static void TestActivoExistente_noOpp()
	{
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
	    vGlobal.Name = 'NombreComercialLTE';
	    vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
	    insert vGlobal;
		//	Preparación del Test
		GeneraData_cls.generarData();
		GeneraData_cls.generarOpportunity();
		Test.startTest();
		//	Llamado de funciones y atributos
		PageReference pageRef = Page.SeleccionarActivoExistente_pag;
		Test.setCurrentPage(pageRef);
		SeleccionarActivoExistente_ctr ctrTest = new SeleccionarActivoExistente_ctr();
		System.debug(ctrTest.ExtrarIdCuenta());
		Test.stopTest();
	}

	@isTest static void TestActivoNoExistente() {
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
	    vGlobal.Name = 'NombreComercialLTE';
	    vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
	    insert vGlobal;
		Account a = new Account(Name = 'Test Account');
		a.Tipodedocumento__c = 'NIT';
		a.AccountNumber = '123454321';
		a.Segmento__c = 'Empresas';
		a.SubSegmento__c = 'Mediana';
		insert a;
		Opportunity opp = new Opportunity( AccountId = a.id, Name = 'Test Opp', StageName ='En Estudio', CloseDate = System.today() + 7);
		insert opp;
		ActivoETB__c act = new ActivoETB__c(Nombredelacuenta__c = a.id, Estado__c = 'Pendiente');
		insert act;
		Test.startTest();
		//  Llamado de funciones y atributos
		PageReference pageRef = Page.SeleccionarActivoExistente_pag;
		pageRef.getParameters().put('id', opp.id);
		Test.setCurrentPage(pageRef);
		SeleccionarActivoExistente_ctr ctrTest = new SeleccionarActivoExistente_ctr();
		ctrTest.TraerActivos();
		Test.stopTest();
	}

	@isTest static void TestFiltrarActivos(){
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
	    vGlobal.Name = 'NombreComercialLTE';
	    vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
	    insert vGlobal;
		//	Preparación del Test
		Account a = new Account(Name = 'Test Account');
		a.Tipodedocumento__c = 'NIT';
		a.AccountNumber = '123454321';
		a.Segmento__c = 'Empresas';
		a.SubSegmento__c = 'Mediana';
		insert a;
		Opportunity opp = new Opportunity( AccountId = a.id, Name = 'Test Opp', StageName ='En Estudio', CloseDate = System.today() + 7);
		insert opp;
		ActivoETB__c act = new ActivoETB__c(Nombredelacuenta__c = a.id, Estado__c = 'Activo', NumeroConexion__c = '1234567890'); 
		insert act;
		Test.startTest();
		//  Llamado de funciones y atributos
		PageReference pageRef = Page.SeleccionarActivoExistente_pag;
		pageRef.getParameters().put('id', opp.id);
		Test.setCurrentPage(pageRef);
		SeleccionarActivoExistente_ctr ctrTest = new SeleccionarActivoExistente_ctr();
		ctrTest.TraerActivos();
		System.debug(ctrTest.intFinPagina);
		ctrTest.FiltrarActivos();
		ctrTest.strParametro = '1234567890';
		ctrTest.FiltrarActivos();
		ctrTest.idActivo = act.id;
		ctrTest.ElegirActivo();
		Test.stopTest();
	}
}