/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Clase de prueba para la clase LTE_GenXmlPortabilidadEntrante_cls

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-01-13      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
@isTest
public with sharing class LTE_GenXmlPortabilidadEntrante_tst {
    
    static testMethod void myUnitTest(){
    	Test.startTest();
    		map<string,string> mapValues = new map<string,string>(); 
    		list<string> lstNumerosPortar = new list<string>();
    		
    		mapValues.put('strIdentificador','xxxx');
			mapValues.put('strIdentificador','xxxx');
			mapValues.put('strObservaciones','xxxx');
			mapValues.put('strNombreRazonSocial','xxxx');
			mapValues.put('strDireccionAbonado','xxxx');
			mapValues.put('strIdentificacion','xxxx');
			mapValues.put('strDonante','xxxx');
			mapValues.put('strTipoUsuario','xxxx');
			mapValues.put('strTipoServicio','xxxx');
			mapValues.put('strVentanaAmpl','xxxx');
			mapValues.put('strSolTercero','xxxx');
			mapValues.put('decNRN','xxxx');
			mapValues.put('DocumentoID','xxxx');
			mapValues.put('strTypeDocID','xxxx');
			mapValues.put('DocumentoAT','xxxx');
			mapValues.put('strTypeDocAT','xxxx');
			mapValues.put('DocumentoCC','xxxx');
			mapValues.put('strTypeDocCC','xxxx');
			
			lstNumerosPortar.add('wwwwwwwwww');
			lstNumerosPortar.add('xxxxxxxxxx');
			lstNumerosPortar.add('yyyyyyyyyy');
			lstNumerosPortar.add('zzzzzzzzzz');
			
    		LTE_GenXmlPortabilidadEntrante_cls genXmlPortabilidadEntrnante  = new LTE_GenXmlPortabilidadEntrante_cls(mapValues, lstNumerosPortar);
    		LTE_GenXmlPortabilidadEntrante_cls.generarXmlSolicitudPortabilidad(mapValues, lstNumerosPortar);
    		LTE_GenXmlPortabilidadEntrante_cls.generarXmlFechaProgramacion( '2016/01/13', '0000000000000000', 'Observaciones' );
    	Test.stopTest();
    }
}