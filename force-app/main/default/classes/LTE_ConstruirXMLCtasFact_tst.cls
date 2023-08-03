/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE     
Description:            Clase de prueba de la clase encargada de crear los xml para el consumo de los servicios web de creación y edición cuentas de facturación y jerarquia de cuentas.                         
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     04/09/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
@isTest
private class LTE_ConstruirXMLCtasFact_tst
{
	public static LTE_SincronizacionCtasFact_Revchain_cls.DatosCtaFact objDatosCtaFact;
	public static list<LTE_SincronizacionCtasFact_Revchain_cls.DatosCtaFact> lstDatosCtaFact;
	public static LTE_SincronizacionCtasFact_Revchain_cls.JerarquiaCtas objJerarquiaCtas;
	public static LTE_ModificarCuentasFacturacion_cls.EdicionCuentas objEdicionCta;

	public static void CreateData()
    {
    	objDatosCtaFact = new LTE_SincronizacionCtasFact_Revchain_cls.DatosCtaFact();
    	objDatosCtaFact.strCorrelationId = 'a05560000003lS9AAI392015111475';
		objDatosCtaFact.strMarketType = 'JURIDICO';
		objDatosCtaFact.strGeoCode1 = '11001';
		objDatosCtaFact.strGeoCode2 = '1';
		objDatosCtaFact.strOrderType = 'VENTA';
		objDatosCtaFact.strNumCta = 'a05560000003lS9JJI';
		objDatosCtaFact.strCurrCode = 'COP';
		objDatosCtaFact.strInvDay = '4';
		objDatosCtaFact.strConvInd = '1';
		objDatosCtaFact.strBillParent = '12050799232';
		objDatosCtaFact.strBillable = 'F';
		objDatosCtaFact.strDoctype = 'NIT';
		objDatosCtaFact.strMonth = '9';
		objDatosCtaFact.strDay = '4';
		objDatosCtaFact.strYear = '2015';
		objDatosCtaFact.strSubscriberName = 'SAMSUNG CP09 01.09.2015';
		objDatosCtaFact.strBillBillingName = 'Prueba';
		objDatosCtaFact.strPhoneNumber = '43265224';
		objDatosCtaFact.strContactEmail = 'solcef@hotmail.com';
		objDatosCtaFact.strNumDocument = '9480274384';
		objDatosCtaFact.strLineOne = 'Calle 120 # 23 - 56';
		objDatosCtaFact.strCityName = 'BOGOTA D.C.';
		objDatosCtaFact.strStateCode = '11';
		objDatosCtaFact.strDaneCode = '11001';
		objDatosCtaFact.strInvoiceDelivery = 'Email';
		objDatosCtaFact.strOrderSubType = 'VENTA LTE';
		objDatosCtaFact.strInvoiceMethod = 'Cuentas LTE Resumida';

		lstDatosCtaFact = new list<LTE_SincronizacionCtasFact_Revchain_cls.DatosCtaFact>();
		lstDatosCtaFact.add(objDatosCtaFact);

		objJerarquiaCtas = new LTE_SincronizacionCtasFact_Revchain_cls.JerarquiaCtas();
		objJerarquiaCtas.strCorrelationId = 'a05560000003lS9AAI392015111449';
		objJerarquiaCtas.strMarketType = 'JURIDICO';
		objJerarquiaCtas.strGeoCode1 = '11001';
		objJerarquiaCtas.strGeoCode2 = '1';
		objJerarquiaCtas.strOrderType = 'VENTA';
		objJerarquiaCtas.strNumCta = 'a05560000003lS9AAI';
		objJerarquiaCtas.strCurrCode = 'COP';
		objJerarquiaCtas.strInvDay = '4';
		objJerarquiaCtas.strConvInd = '1';
		objJerarquiaCtas.strBillParent = '';
		objJerarquiaCtas.strBillable = 'T';
		objJerarquiaCtas.strDoctype = 'NIT';
		objJerarquiaCtas.strMonth = '9';
		objJerarquiaCtas.strDay = '4';
		objJerarquiaCtas.strYear = '2015';
		objJerarquiaCtas.strSubscriberName = 'SAMSUNG CP09 01.09.2015';
		objJerarquiaCtas.strBillBillingName = 'Prueba';
		objJerarquiaCtas.strPhoneNumber = '43263224';
		objJerarquiaCtas.strContactEmail = 'solcef@hotmail.com';
		objJerarquiaCtas.strNumDocument = '9482374384';
		objJerarquiaCtas.strLineOne = 'Calle 120 # 23 - 56';
		objJerarquiaCtas.strCityName = 'BOGOTA D.C.';
		objJerarquiaCtas.strStateCode = '11';
		objJerarquiaCtas.strDaneCode = '11001';
		objJerarquiaCtas.strInvoiceDelivery = 'Email';
		objJerarquiaCtas.strOrderSubType = 'VENTA LTE';
		objJerarquiaCtas.strInvoiceMethod = 'Cuentas LTE Resumida';
		objJerarquiaCtas.lstDatosCtasHijas = lstDatosCtaFact;

		objEdicionCta = new LTE_ModificarCuentasFacturacion_cls.EdicionCuentas();
		objEdicionCta.strCorrelationId = 'a05560000003l97AAA2082015105214';
		objEdicionCta.strSubscriberId = '12050932521';
		objEdicionCta.strAddress = 'Carrera 13';
		objEdicionCta.strCity = 'BOGOTA D.C.';
		objEdicionCta.strCityCode = '11001';
		objEdicionCta.strCountryCode = '1';
		objEdicionCta.strStateCode = '11';
		objEdicionCta.strDeliveryType = 'Email';
		objEdicionCta.strEmail = 'gfd@gtfds.co';
		objEdicionCta.strMethodName = 'Cuentas LTE Resumida';
	}

	@isTest static void test_method_one() 
	{
		CreateData();        
        Test.startTest();
		LTE_ConstruirXMLCtasFact_cls.CrearXMLJerarquiaCuentaFact(objJerarquiaCtas);        
        Test.stopTest();
	}
	
	@isTest static void test_method_two() 
	{
		CreateData();        
        Test.startTest();
		LTE_ConstruirXMLCtasFact_cls.XMLActualizarCuentaFact(objEdicionCta);        
        Test.stopTest();
	}
	
}