/**************************************************************************************************
Desarrollado por:   Accenture
Autor:              Lucas Cano
Proyecto:           ETB S.A.
Descripción:        Clase Apex Test para consultar los productos avanzados y basicos Mipymes 

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    ---------------------------------------------------
1.0     2021-11-30      Lucas Cano              Creacion
1.1     2021-11-30      Lucas Cano              Desarrollo
1.2     2021-12-09      Julian Velasco          Desarrollo
1.3     2022-01-18      Julian Velasco          Modificacion
***************************************************************************************************/
@IsTest
public with sharing class DEG_GetProduct_Advanced_basic_ws_tst {
    @TestSetup
    static void createData(){

        Poblacion__c pob = new Poblacion__c();
        pob.CodigoDane__c = '1100001';
        pob.EsMunicipio__c = true;
        pob.name = 'testland';
        pob.Tipo_de_instalacion__c = 'Bogotá';
        insert pob;

        Account aliado = new Account();
        aliado.Name = 'cuentacuentacuenta123';
        aliado.Ciudad__c = pob.Id;
        aliado.Type = 'Prospecto';
        aliado.Segmento__c='MiPyme';
        aliado.SubSegmento__c='Mediana';
        aliado.Tipodedocumento__c='NIT';
        aliado.AccountNumber='830046657';
        aliado.Estado_Cuenta__c='Activo';
        aliado.Phone='30546589';
        aliado.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Aliado').getRecordTypeId();
        insert aliado;

        Account aliado2 = new Account();
        aliado2.Name = 'Aliado Test';
        aliado2.Ciudad__c = pob.Id;
        aliado2.Type = 'Prospecto';
        aliado2.Segmento__c='MiPyme';
        aliado2.SubSegmento__c='Mediana';
        aliado2.Tipodedocumento__c='NIT';
        aliado2.AccountNumber='123123123';
        aliado2.Estado_Cuenta__c='Activo';
        aliado2.Phone='30546588';
        aliado2.recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Aliado').getRecordTypeId();
        insert aliado2;

        CatalogoProductos__c objCatalogoProductoActivo = new CatalogoProductos__c();
        objCatalogoProductoActivo.Aliado__c = aliado.Id;
        objCatalogoProductoActivo.Name = 'TELEFONIA MOVIL (LTE)';
        objCatalogoProductoActivo.LineaNegocio__c = 'INTERNET';
        objCatalogoProductoActivo.Estado__c = 'Activo';
        objCatalogoProductoActivo.Tipo_de_Producto__c = 'Avanzado';

        insert objCatalogoProductoActivo;

        CatalogoProductos__c objCatalogoProductoInactivo = new CatalogoProductos__c();
        objCatalogoProductoInactivo.Aliado__c = aliado2.Id;
        objCatalogoProductoInactivo.Name = 'TELEFONIA MOVIL (LTE) Test';
        objCatalogoProductoInactivo.LineaNegocio__c = 'INTERNET Test';
        objCatalogoProductoInactivo.Estado__c = 'Inactivo';
        objCatalogoProductoInactivo.Tipo_de_Producto__c = 'Avanzado';

        insert objCatalogoProductoInactivo;


    }
    
    @isTest 
    static void getAdvancedActivoTst(){

        Account nit = [SELECT AccountNumber FROM Account WHERE AccountNumber = '830046657'];
        System.debug('nit actual: ' +nit); 
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('sfdcBaseURL = ' + sfdcBaseURL); 

        RestRequest request = new RestRequest();
        request.requestUri = sfdcBaseURL+'/services/apexrest/CatalogoProductos__c/';
        request.httpMethod = 'GET';
        request.params.put('documento', nit.AccountNumber);
        RestContext.request = request;
        System.debug('request '+request);
        Test.startTest(); 
        DEG_GetProduct_Advanced_basic_ws.ResponseService objetoResponse = new DEG_GetProduct_Advanced_basic_ws.ResponseService();
        objetoResponse = DEG_GetProduct_Advanced_basic_ws.getAdvanced();
        System.debug('response --> '+objetoResponse);
        System.debug('estado --> '+objetoResponse.statusCode);
        Test.stopTest(); 
        System.assertEquals(200,objetoResponse.statusCode);
    }

    @isTest 
    static void getAdvancedInactivoTst(){

        Account nit = [SELECT AccountNumber FROM Account WHERE AccountNumber = '123123123'];
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

        RestRequest request = new RestRequest();
        request.requestUri = sfdcBaseURL+'/services/apexrest/CatalogoProductos__c/';
        request.httpMethod = 'GET';
        request.params.put('documento', nit.AccountNumber);
        RestContext.request = request;
        Test.startTest(); 
        DEG_GetProduct_Advanced_basic_ws.ResponseService objetoResponse = new DEG_GetProduct_Advanced_basic_ws.ResponseService();
        objetoResponse = DEG_GetProduct_Advanced_basic_ws.getAdvanced();
        Test.stopTest(); 
        System.assertEquals(200,objetoResponse.statusCode);
    }

     @isTest 
     static void getAdvancedErrorTextTst(){

        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

        RestRequest request = new RestRequest();
        request.requestUri = sfdcBaseURL+'/services/apexrest/CatalogoProductos__c/';
        request.httpMethod = 'GET';
        request.params.put('documento', 'texto');
        RestContext.request = request;
        Test.startTest(); 
        DEG_GetProduct_Advanced_basic_ws.ResponseService objetoResponse = new DEG_GetProduct_Advanced_basic_ws.ResponseService();
        objetoResponse = DEG_GetProduct_Advanced_basic_ws.getAdvanced();
        Test.stopTest();
        System.debug(objetoResponse.statusCode);
        System.assertEquals(500,objetoResponse.statusCode,'Error al ingresar texto');
        
    } 

    @isTest 
     static void getAdvancedErrorDocTst(){

        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();

        RestRequest request = new RestRequest();
        request.requestUri = sfdcBaseURL+'/services/apexrest/CatalogoProductos__c/';
        request.httpMethod = 'GET';
        request.params.put('documento', '1');
        RestContext.request = request;
        Test.startTest(); 
        DEG_GetProduct_Advanced_basic_ws.ResponseService objetoResponse = new DEG_GetProduct_Advanced_basic_ws.ResponseService();
        objetoResponse = DEG_GetProduct_Advanced_basic_ws.getAdvanced();
        Test.stopTest();
        System.debug(objetoResponse.statusCode);
        System.assertEquals(500,objetoResponse.statusCode,'Error al no encontrar documento');
        
    } 

}