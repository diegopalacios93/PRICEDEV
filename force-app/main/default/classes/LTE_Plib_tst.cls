/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase controladora encargada de la información y el consumo del sistema legado Plib.                          
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     04/09/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
@isTest
private class LTE_Plib_tst
{
	public static Account objAccount;
	public static Poblacion__c objDepto;
	public static Poblacion__c objMunicipio;
	public static Contact objContact;
	public static CatalogoProductos__c objProducto;
	public static Planes__c objPlan;
	public static Case objCaso;
	public static LTE_FallasPlib__c objFallas;
	public static ServiciosWeb__c objSW;
	public static ActivoETB__c objServicio;
	public static LTE_Servicios_adicionales__c objServAdicional;
	public static LTE_SpecificationGroupXA__c objSpecification;
	public static LTE_SpecificationGroupXA__c objSpecification2;

	public static void CreateData()
    {
    	objAccount = new Account();
		objAccount.Name = 'Test Name';
    	objAccount.RazonSocial__c = 'Test razon social';
    	objAccount.Tipodedocumento__c = 'NIT';
    	objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456';  	
    	insert objAccount;

    	objDepto = new Poblacion__c();
    	objDepto.Name = 'BOGOTA D.C.';
    	objDepto.CodigoDane__c = '11000';
    	objDepto.EsDepartamento__c = true;
    	insert objDepto;

		objMunicipio = new Poblacion__c();
    	objMunicipio.Name = 'BOGOTA D.C.';
    	objMunicipio.CodigoDane__c = '11001';
    	objMunicipio.EsMunicipio__c = true;
    	objMunicipio.Padre__c = objDepto.Id;
    	insert objMunicipio;

    	objContact = new Contact(IsTEST__c = true);
    	objContact.FirstName = 'Andres';
    	objContact.LastName = 'Lopez';
    	objContact.AccountId = objAccount.Id;
    	objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
    	objContact.NumerodeIdentificacion__c = '345678904';
    	objContact.Estado__c = 'Activo';
    	objContact.Cargo__c = 'Ingeniero';
    	objContact.Area__c = 'Dpto. Financiero';
    	objContact.Rol__c = 'Administrativo';
    	objContact.LTE_RolLTE__c = 'Total';
    	objContact.Genero__c = 'Masculino';
    	objContact.Direccion__c = 'Calle 12 # 34 - 53';
    	objContact.Phone = '432432432';
    	objContact.MobilePhone = '3105667655';
    	objContact.Email = 'scampos@avanxo.com';
    	objContact.Ciudad__c = objMunicipio.Id;
    	insert objContact;

    	objProducto = new CatalogoProductos__c();
    	objProducto.Name = 'TELEFONIA MOVIL (LTE)';
    	objProducto.Familia__c = 'LTE';
    	objProducto.LineaNegocio__c = 'Redes Móviles';
    	objProducto.CodigoProducto__c = '7635736';
    	objProducto.Estado__c = 'Activo';
    	objProducto.Descripcion__c = 'Teste';
    	objProducto.AtributosEstandar__c = 'Teste';
    	insert objProducto;

    	objPlan = new Planes__c ();
    	objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
    	objPlan.NombredelProducto__c = objProducto.Id;
    	objPlan.TipodePlan__c = 'Principal';
    	objPlan.Tarifa__c = 96000;
    	objPlan.Estado__c = 'Activo';
    	objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
    	objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
    	insert objPlan;

    	objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '357215066799274';
        objServicio.NumeroConexion__c = '3133222311';
        objServicio.Fecha_Activacion__c = system.now();

        insert objServicio;

        objServAdicional = new LTE_Servicios_adicionales__c();
        objServAdicional.Name = 'EQUIPO PROPIEDAD CLIENTE';
        objServAdicional.LTE_Estado__c = 'Pendiente';
        objServAdicional.LTE_ServicioETB__c = objServicio.Id;
        insert objServAdicional;

        objSpecification = new LTE_SpecificationGroupXA__c();
        objSpecification.Name = 'MARCA';
        objSpecification.LTE_ActionCode__c = 'ADD';
        objSpecification.LTE_Value__c = 'Samsung';
        objSpecification.LTE_ServiciosAdicionales__c = objServAdicional.Id;
        insert objSpecification;

        objSpecification2 = new LTE_SpecificationGroupXA__c();
        objSpecification2.Name = 'MODELO';
        objSpecification2.LTE_ActionCode__c = 'ADD';
        objSpecification2.LTE_Value__c = 'Galaxy S6';
        objSpecification2.LTE_ServiciosAdicionales__c = objServAdicional.Id;
        insert objSpecification2;

    	objCaso = new Case();
    	objCaso.Fechaderadicacion__c = system.today();
    	objCaso.Origin = 'Correo electrónico';
    	objCaso.Status = 'En Proceso';
    	objCaso.Causal_Estado__c = 'Asignado';
    	objCaso.Plan__c = objPlan.Id;
    	objCaso.Subject = 'teste';
    	objCaso.ContactId = objContact.Id;
    	objCaso.Tipologia__c = 'FALLA ELECTRICA';
    	objCaso.LTE_Garantia__c = 'En Garantia';
    	objCaso.LTE_Servicio__c = objServicio.Id;
    	insert objCaso;

    	objFallas = new LTE_FallasPlib__c();
    	objFallas.Name = 'FALLA ELECTRICA';
    	objFallas.LTE_Codigo__c = 'FAIL#7';
    	insert objFallas;

    	objSW = new ServiciosWeb__c();
        objSW.Name = 'Plib';
        objSW.EndPoint__c = 'http://201.245.171.239:7071/Service/DeviceManagement/Endpoint';
        objSW.Action__c = '/Service/DeviceManagement.serviceagent//CreateServiceOrderOp';
        insert objSW;        
    }

	@isTest static void test_method_one()
	{
		CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','PASS');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('errorCode','0');
		Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponsePlib());
        
        Test.startTest();
        system.currentPageReference().getParameters().put('Id', objCaso.Id);
        LTE_Plib_ctr ctr = new LTE_Plib_ctr();
        list<SelectOption> lstOpcionesGarantia 	= ctr.lstOpcionesGarantia;
        ctr.guardar();
        ctr.actualizarInfoEquipo();
        Test.stopTest();
	}

    @isTest static void test_method_two()
    {
        CreateData();
        objCaso.LTE_Garantia__c = '';
        update objCaso;
        
        Test.startTest();
        system.currentPageReference().getParameters().put('Id', objCaso.Id);
        LTE_Plib_ctr ctr = new LTE_Plib_ctr();
        list<SelectOption> lstOpcionesGarantia  = ctr.lstOpcionesGarantia;
        ctr.guardar();
        Test.stopTest();
    }

    @isTest static void test_method_three()
    {
        CreateData();
        LTE_MockServiciosWebLTE_cls.variablesMock.put('status','FAIL');
        LTE_MockServiciosWebLTE_cls.variablesMock.put('errorCode','45');
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponsePlib());
        
        Test.startTest();
        system.currentPageReference().getParameters().put('Id', objCaso.Id);
        LTE_Plib_ctr ctr = new LTE_Plib_ctr();
        list<SelectOption> lstOpcionesGarantia  = ctr.lstOpcionesGarantia;
        ctr.guardar();
        Test.stopTest();
    }
}