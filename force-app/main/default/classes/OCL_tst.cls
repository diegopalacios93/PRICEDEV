/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Clase de prueba para el controlador OCL_pag

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-06-16		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/

@isTest
private class OCL_tst {
	
	//	Prueba de controlador cuando no se tiene ID
	@isTest static void TestNoId() {
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
		Test.setCurrentPage(Page.OCL_pag);
		OCL_ctr controlador = new OCL_ctr();
		System.debug(Controlador.subtitulo);
		//	Verificación del mensaje de error
		System.assertEquals(1, Apexpages.getMessages().size());
		System.assertEquals(Label.OCL_ctr_NoIdContratoActual, Apexpages.getMessages()[0].getDetail());
		controlador.Main();
	}
	
	//	Prueba de controlador cuando el ID no corresponde a un ID Válido
	@isTest static void TestIdMalformado() {
		//	Creación de data de prueba
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
		String strIdInvalido = '1234567890';
		//	Inicio prueba
		Test.setCurrentPage(Page.OCL_pag);
		Apexpages.currentPage().getParameters().put('id', strIdInvalido);
		OCL_ctr controlador = new OCL_ctr();
		//	Verificación del mensaje de error
		System.assertEquals(1, Apexpages.getMessages().size());
		System.assertEquals('Invalid id: ' + '1234567890', Apexpages.getMessages()[0].getDetail());
	}
	
	//	Prueba de controlador cuando el ID no corresponde a un contrato
	@isTest static void TestIdNoContrato() {
		//Creación de data de prueba
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        ReglasDesarrollos__c vReglasD = new ReglasDesarrollos__c(Name='OC1',Activo__c=true);
        insert vReglasD;
		Account a = new Account(Name = 'Cuenta Test',Phone='12343434');
		insert a;
		//	Inicio prueba
		Test.setCurrentPage(Page.OCL_pag);
		Apexpages.currentPage().getParameters().put('id', a.id);
		OCL_ctr controlador = new OCL_ctr();
		//	Verificación del mensaje de error
		System.assertEquals(1, Apexpages.getMessages().size());
		System.assertEquals(Label.OCL_ctr_NoContratoActual, Apexpages.getMessages()[0].getDetail());
	}
	
	//	Prueba de controlador cuando el contrato no tiene OC asociadas
	@isTest static void TestNoOC() {
		//Creación de data de prueba
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        vGlobal = new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO');
        insert vGlobal;
        ReglasDesarrollos__c vReglasD = new ReglasDesarrollos__c(Name='OC1',Activo__c=true);
        insert vReglasD;
		Account a = new Account(Name = 'Cuenta Test',Phone='12343434');
		insert a;
		Contract c = new Contract(AccountId = a.Id);
		insert c;
		//	Inicio prueba
		Test.setCurrentPage(Page.OCL_pag);
		Apexpages.currentPage().getParameters().put('id', c.id);
		OCL_ctr controlador = new OCL_ctr();
		//	Verificación del mensaje de error
		System.assertEquals(1, Apexpages.getMessages().size());
		System.assertEquals(Label.OpComLegalizar_NoHayOP, Apexpages.getMessages()[0].getDetail());
	}
	
	//Prueba de controlador con una OC simple
	@isTest static void TestSimpleOC() {
		//Creación de data de prueba
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        vGlobal = new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO');
        insert vGlobal;
        ReglasDesarrollos__c vReglasD = new ReglasDesarrollos__c(Name='OC1',Activo__c=true);
        insert vReglasD;
    	List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        insert lstLTEAPN;
        
		TOPP__c t = new TOPP__c(AplicaPreventa__c = false);
		insert t;
		Account a = new Account(Name = 'Cuenta Test',Type='Cliente',Phone='12343434');
		insert a;
        OperacionComercial__c oc = new OperacionComercial__c(CuentaCliente__c=a.Id,TOPP__c = t.id, Estado__c='Pendiente',EnvSopVen__c=date.today());
		insert oc;
		Contract c = new Contract(AccountId = a.id);
		insert c;
		c = [Select ContractNumber, AccountId from Contract Where Id =: c.id];
		oc.CuentaCliente__c = a.id;
		update oc;
		Viabilidad__c viabilidad = new Viabilidad__c(OperacionComercial__c=oc.id,Respuestadeviabilidad__c='Viable',Observaciones__c='test', EstadoViabilidad__c='Cerrada');
		insert viabilidad;
		oc = [Select RecordType.Name from OperacionComercial__c Where Id =: oc.id];
		Campos_Obligatorios_OC__c co = new Campos_Obligatorios_OC__c(Name = 'Campos Obligatorios Test', Tipo_de_Registro__c = oc.RecordType.Name, Nombre_API__c = 'IdUnico__c');
		insert co;
		//	Inicio Prueba
		Test.startTest();
		Test.setCurrentPage(Page.OCL_pag);
		Apexpages.currentPage().getParameters().put('id', c.id);
		OCL_ctr controlador = new OCL_ctr();
		//	Verificación de getters en la página
		System.assertEquals( Label.OpComLegalizar_Titulo, controlador.titulo);
		System.assertEquals('Contrato ' + c.ContractNumber, controlador.subtitulo);
		System.assertEquals(true, controlador.RenderBotonCrear);
		//	Llamado a la acción de la VF
		controlador.Main();
		//	Llenado de datos simulando interacción del usuario
		controlador.lstWrOpp[0].lstOC[0].check = true;
		controlador.CrearLegalizacion();
		//	"Retardo" necesario para la comparación de fechas de creación y modificación
		for (Integer i = 1; i < 15; i++)
			controlador.CrearLegalizacion();
		//	Modificación, más no diligenciado total de la operación comercial
		oc.EsMigrado__c = true;
		update oc;
		controlador.CrearLegalizacion();
		//	Diligenciado total de la operación comercial
		oc.IdUnico__c = 'IdUnicoftw!';
		update oc;
		controlador.CrearLegalizacion();
		//	Verificación de la creación de la Legalización
		oc = [Select Legalizacion__c from OperacionComercial__c where Id =: oc.Id];
		if (oc.Legalizacion__c != null) {
			Legalizacion__c l = [Select Contrato__c, Nombredelacuenta2__c from Legalizacion__c where Id =: oc.Legalizacion__c];
			System.assertEquals(c.id, l.Contrato__c);
			System.assertEquals(c.AccountId, l.Nombredelacuenta2__c);
		}
        Test.stopTest();
	}
	
	//	Prueba de controlador con Excepción al momento de crear legalización 
	@isTest static void TestSimpleOCExcepcion() {
		//Creación de data de prueba
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        vGlobal = new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO');
        insert vGlobal;
        ReglasDesarrollos__c vReglasD = new ReglasDesarrollos__c(Name='OC1',Activo__c=true);
        insert vReglasD;
        list<sobject> vg=new list<sobject>();
        vg.add(new Perfiles_Acciones__c(Name='ValidacionesOC',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
        vg.add(new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable'));
        insert vg;
        
		TOPP__c t = new TOPP__c(AplicaPreventa__c = false);
		insert t;
		Account a = new Account(Name = 'Cuenta Test',Type='Cliente',Phone='12343434');
		insert a;
		OperacionComercial__c oc = new OperacionComercial__c(CuentaCliente__c=a.Id,TOPP__c = t.id, Estado__c='Pendiente',EnvSopVen__c=date.today());
		insert oc;
		Contract c = new Contract(AccountId = a.id);
		insert c;
		c = [Select ContractNumber, AccountId from Contract Where Id =: c.id];
		oc.CuentaCliente__c = a.id;
		update oc;
		Viabilidad__c viabilidad = new Viabilidad__c(OperacionComercial__c=oc.id,Respuestadeviabilidad__c='Viable',Observaciones__c='test',EstadoViabilidad__c='Cerrada');
		insert viabilidad;
		oc = [Select RecordType.Name from OperacionComercial__c Where Id =: oc.id];
		Campos_Obligatorios_OC__c co = new Campos_Obligatorios_OC__c(Name = 'Campos Obligatorios Test', Tipo_de_Registro__c = oc.RecordType.Name, Nombre_API__c = 'IdUnico__c');
		insert co;
		//	Inicio prueba
		Test.startTest();
		Test.setCurrentPage(Page.OCL_pag);
		Apexpages.currentPage().getParameters().put('id', c.id);
		OCL_ctr controlador = new OCL_ctr();
		controlador.Main();
		//	Llamado a la acción de la VF
		controlador.lstWrOpp[0].lstOC[0].check = true;
		controlador.CrearLegalizacion();
		//	"Retardo" necesario para la comparación de fechas de creación y modificación
		for (Integer i = 1; i < 25; i++)
			controlador.CrearLegalizacion();
		//	Diligenciado total de la operación comercial
		oc.IdUnico__c = 'IdUnicoftw!';
        oc.Estado__c='En Curso';
		update oc;
		//	Disparo de la Excepción
		LibreriaUtilitaria_cls.ErrorExcepcionTest = true;
		controlador.CrearLegalizacion();
		//	Validación del mensaje de error
		System.debug('Apexpages.getMessages():' + Apexpages.getMessages());
		System.assertEquals(2, Apexpages.getMessages().size());
		System.assertEquals('Attempt to de-reference a null object', Apexpages.getMessages()[1].getDetail());
	}
	
	//Prueba de controlador con una OC simple creando lineas
	@isTest static void TestSimpleOCLinea() {
		//Creación de data de prueba
		List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        vGlobal = new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO');
        insert vGlobal;
        ReglasDesarrollos__c vReglasD = new ReglasDesarrollos__c(Name='OC1',Activo__c=true);
        insert vReglasD;
    	List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        insert lstLTEAPN;
        
        CatalogoProductos__c objProducto = new CatalogoProductos__c();
        objProducto.Name = 'Convenio de cupo';
        objProducto.Estado__c = 'Activo';
        objProducto.CodigoProducto__c='Conveniodecupo001';
        objProducto.Crear_Linea__c = true;
        insert objProducto;
        
        planes__c plan =new planes__c();
        plan.NombredelProducto__c=objProducto.id;
        plan.Name='Plan Larga Distancia '+objProducto.Name;
        plan.IdUnico__c='PlanLargaDistancia';
        insert plan;
      
        TOPP__c t = new TOPP__c();
        t.AplicaPreventa__c = false;
        t.LTE_Catalogo_de_Producto__c = objProducto.Id;
        t.Plan__c=plan.id;
        t.TipodeOperacionporplan__c='Venta';
        insert t;
        
		Account a = new Account(Name = 'Cuenta Test',Type='Cliente',Phone='12343434');
		insert a;
        OperacionComercial__c oc = new OperacionComercial__c(CuentaCliente__c=a.Id,TOPP__c = t.id, Estado__c='Pendiente',EnvSopVen__c=date.today(), NumeroConexion__c = '16735421');
		insert oc;
		Contract c = new Contract(AccountId = a.id);
		insert c;
		c = [Select ContractNumber, AccountId from Contract Where Id =: c.id];
		oc.CuentaCliente__c = a.id;
		update oc;
		Viabilidad__c viabilidad = new Viabilidad__c(OperacionComercial__c=oc.id,Respuestadeviabilidad__c='Viable',Observaciones__c='test',EstadoViabilidad__c='Cerrada');
		insert viabilidad;
		oc = [Select RecordType.Name from OperacionComercial__c Where Id =: oc.id];
		Campos_Obligatorios_OC__c co = new Campos_Obligatorios_OC__c(Name = 'Campos Obligatorios Test', Tipo_de_Registro__c = oc.RecordType.Name, Nombre_API__c = 'IdUnico__c');
		insert co;
		//	Inicio Prueba
		Test.startTest();
		Test.setCurrentPage(Page.OCL_pag);
		Apexpages.currentPage().getParameters().put('id', c.id);
		OCL_ctr controlador = new OCL_ctr();
		//	Llamado a la acción de la VF
		controlador.Main();
		//	Llenado de datos simulando interacción del usuario
		controlador.lstWrOpp[0].lstOC[0].check = true;
		controlador.CrearLegalizacion();
        controlador.validarCampoARPUenOCs(oc);
		oc.EsMigrado__c = true;
        oc.Estado__c = 'Activa';
		update oc;
	}
	
}