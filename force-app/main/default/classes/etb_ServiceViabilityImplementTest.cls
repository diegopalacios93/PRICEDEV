@isTest
public class etb_ServiceViabilityImplementTest {
    @TestSetup
    static void makeData() {
        vlocity_cmt__PriceList__c vlct_pricelist = new vlocity_cmt__PriceList__c(Name = 'ETB Price List', vlocity_cmt__Code__c = 'PL-ETB');
        insert vlct_pricelist;

        Id pricebookId = Test.getStandardPricebookId();

        Account accountBusiness = new Account();
        accountBusiness.Name = 'Cafe';
        accountBusiness.State__c = 'AMAZONAS';
        accountBusiness.Type = 'Cliente Activo';
        accountBusiness.Phone = '12345678';
        accountBusiness.PostalCode__c = '123456';
        accountBusiness.Country__c = 'COLOMBIA';
        accountBusiness.City__c = 'LETICIA';
        accountBusiness.Estado_Cuenta__c = 'Activo';
        accountBusiness.vlocity_cmt__Status__c = 'Active';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness; 

        Opportunity opp1 = new Opportunity();
        opp1.AccountId = accountBusiness.Id;
        opp1.Name = 'Opportunity Test Case';
        opp1.CloseDate = System.today()+1;
        opp1.CausaldePerdida__c = 'Otro';
        opp1.Duracion_Meses__c = 5;
        opp1.ForecastCategoryName = 'Negociacion';
        opp1.StageName = 'En Estudio';
        opp1.OwnerId = Userinfo.getUserId();
        opp1.Tipo_de_Operacion__c = 'Modificacion';
        opp1.Amount = 1000000;
        opp1.Valor_unica_vez_ETB__c = 1;   
        opp1.PDC__c = '80% - Probabilidad de Éxito';
        opp1.ANS__c = 10;
        insert opp1;

        Opportunity opp2 = new Opportunity();
        opp2.AccountId = accountBusiness.Id;
        opp2.Name = 'Opportunity Test Case 23';
        opp2.CloseDate = System.today()+1;
        opp2.CausaldePerdida__c = 'Otro';
        opp2.Duracion_Meses__c = 5;
        opp2.ForecastCategoryName = 'Negociacion';
        opp2.StageName = 'En Estudio';
        opp2.OwnerId = Userinfo.getUserId();
        opp2.Tipo_de_Operacion__c = 'Modificacion';
        opp2.Amount = 1000000;
        opp2.Valor_unica_vez_ETB__c = 1;   
        opp2.PDC__c = '80% - Probabilidad de Éxito';
        opp2.ANS__c = 10;
        insert opp2;

        Opportunity ventaUnificadaOpp = new Opportunity();
            ventaUnificadaOpp.CloseDate = System.today()+1;
            ventaUnificadaOpp.Amount = 200000.0;
            ventaUnificadaOpp.CausaldePerdida__c ='Otro';
            //ventaUnificadaOpp.Linea_de_Negocio_Principal__c = 'ventaUnificadaOpp';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
            ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;

        Quote qq1 = new Quote(Name = 'COT-13', OpportunityId = opp1.Id, RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Enterprise Quote').getRecordTypeId(), Pricebook2Id = pricebookId);
        Quote qq2 = new Quote(Name = 'COT-2', OpportunityId = opp2.Id,RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Enterprise Quote').getRecordTypeId(), Pricebook2Id = pricebookId);
        Quote qq3 = new Quote(Name = '3', OpportunityId = opp2.Id,RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Enterprise Quote').getRecordTypeId(), Pricebook2Id = pricebookId);
        Quote qq4 = new Quote(Name = 'COT-14', OpportunityId = opp1.Id, RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Enterprise Quote').getRecordTypeId(), Pricebook2Id = pricebookId);
        List<Quote> quoteBulk = new List<Quote>{qq1, qq2, qq3,qq4};
        insert quoteBulk;

        Product2 prod = new Product2();
        prod.Name = 'Navegacion Segura product';
        prod.ProductCode = 'PR_Navegacion_segura_Avanzada';
        prod.vlocity_cmt__Type__c = 'Costo';
        prod.Family = 'Dispositivo';
        insert prod;

        Product2 prod2 = new Product2();
        prod2.Name = 'Router Cisco serie ISRI000';
        prod2.ProductCode = 'PR_ROUTER_CISCO_SERIE_ISR1000';
        prod2.vlocity_cmt__Type__c = 'Modem';
        insert prod2;

        Product2 prod3 = new Product2();
        prod3.Name = 'Navegacion Segura product';
        prod3.ProductCode = 'PR_Navegacion_segura_Avanzada';
        prod3.vlocity_cmt__Type__c = 'Modem';
        insert prod3;
        
        Product2 prod4 = new Product2();
        prod4.Name = 'Navegacion Segura product';
        prod4.ProductCode = 'PR_ROUTER_CISCO_SERIE_ISR1000';
        prod4.vlocity_cmt__Type__c = 'Modem';
        insert prod4;

        Product2 prod5 = new Product2();
        prod5.Name = 'Licencia ISR Serie 1000';
        prod5.ProductCode = 'PR_LICENCIA_ISR_SERIE_1000';
        prod5.vlocity_cmt__Type__c = 'Avanzado';
        insert prod5;        

        Product2 prod6 = new Product2();
        prod6.Name = 'Internet Dedicado';
        prod6.ProductCode = 'PR_INTERNET_DEDICADO';
        prod6.vlocity_cmt__Type__c = 'Avanzado';
        insert prod6;

        vlocity_cmt__ProductRelationship__c prship = new vlocity_cmt__ProductRelationship__c();
        prship.Name	= 'Internet Dedicado Relies On Licencia ISR Serie 1000';
        prship.vlocity_cmt__AddMode__c = 'asSibling';
        prship.vlocity_cmt__DefaultQuantity__c = 1.0;
        prship.vlocity_cmt__GlobalKey__c = 'fa132214-a171-fe17-d2a2-ea96ba36c4d7';
        prship.vlocity_cmt__IsConditional__c = true;
        prship.vlocity_cmt__MaxQuantity__c = 1.0;
        prship.vlocity_cmt__MinQuantity__c = 1.0;
        prship.vlocity_cmt__Product2Id__c = prod6.Id;
        // prship.vlocity_cmt__ProductGroupKey__c = 'd1b02d9c-285a-f712-3ae2-ae8f42534c38';
        // prship.vlocity_cmt__RelatedProductGroupKey__c = '3874b3e9-f29b-59bd-b20f-484d5956578b0';
        prship.vlocity_cmt__RelatedProductId__c = prod5.Id;
        prship.vlocity_cmt__RelationshipType__c = 'ReliesOn';
        insert prship;
                
        PricebookEntry pbE = new PricebookEntry();
        pbE.UnitPrice = 0.0;
        pbE.isActive = true;
        pbE.Pricebook2Id = pricebookId;
        pbE.Product2Id = prod.Id;
        insert pbE;

        PricebookEntry pbE2 = new PricebookEntry();
        pbE2.UnitPrice = 0.0;
        pbE2.isActive = true;
        pbE2.Pricebook2Id = pricebookId;
        pbE2.Product2Id = prod2.Id;
        insert pbE2;

        PricebookEntry pbE3 = new PricebookEntry();
        pbE3.UnitPrice = 0.0;
        pbE3.isActive = true;
        pbE3.Pricebook2Id = pricebookId;
        pbE3.Product2Id = prod3.Id;
        insert pbE3;

        PricebookEntry pbE4 = new PricebookEntry();
        pbE4.UnitPrice = 0.0;
        pbE4.isActive = true;
        pbE4.Pricebook2Id = pricebookId;
        pbE4.Product2Id = prod4.Id;
        insert pbE4;

        PricebookEntry pbE5 = new PricebookEntry();
        pbE5.UnitPrice = 0.0;
        pbE5.isActive = true;
        pbE5.Pricebook2Id = pricebookId;
        pbE5.Product2Id = prod5.Id;
        insert pbE5;

        PricebookEntry pbE6 = new PricebookEntry();
        pbE6.UnitPrice = 0.0;
        pbE6.isActive = true;
        pbE6.Pricebook2Id = pricebookId;
        pbE6.Product2Id = prod6.Id;
        insert pbE6;
                
        QuoteLineItem quotelineitem1 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = qq1.Id,
            Product2 = prod,
            PricebookEntryId = pbE.Id,
            UnitPrice = 0.0,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000HCBXGA0',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE", "ATT_SF_ClausulaTerminacionAnticipada":"Sí Acepta"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id);
            
        insert quotelineitem1;

        System.debug('producto que se le asigna a quote line item 5 ->'+prod4);
        QuoteLineItem quotelineitem5 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = qq4.Id,
            Product2 = prod4,
            PricebookEntryId = pbE.Id,
            UnitPrice = 0.0,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000HCBXGA1',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id,
            vlocity_cmt__Query__c = 'Gestor-0000002');
            
        insert quotelineitem5;

        QuoteLineItem quotelineitem6 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = qq4.Id,
            Product2 = prod2,
            PricebookEntryId = pbE.Id,
            UnitPrice = 0.0,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000HCBXGA1',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id,
            vlocity_cmt__Query__c = 'Gestor-0000003');
        insert quotelineitem6;

        QuoteLineItem quotelineitem7 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = qq4.Id,
            Product2 = prod5,
            PricebookEntryId = pbE5.Id,
            UnitPrice = 0.0,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000HCBXGA1',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id,
            vlocity_cmt__Query__c = 'Gestor-0000003');
        insert quotelineitem7;

        QuoteLineItem quotelineitem8 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = qq4.Id,
            Product2 = prod6,
            PricebookEntryId = pbE6.Id,
            UnitPrice = 0.0,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000HCBXGA1',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id,
            vlocity_cmt__Query__c = 'Gestor-0000003');
        insert quotelineitem8;

        
        System.debug('QLI6 con el producto ya asignado ->'+quotelineitem6.Product2);
        // QuoteLineItem quotelineitem5 = new QuoteLineItem(
        //     Quantity = 1.0,
        //     QuoteId	 = qq1.Id,
        //     Product2 = prod,
        //     PricebookEntryId = pbE.Id,
        //     UnitPrice = 0.0,
        //     vlocity_cmt__ReliesOnItemId__c = '0QL78000000HCBXGA0',
        //     vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
        //     vlocity_cmt__Action__c = 'Add',
        //     vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
        //     vlocity_cmt__BillingAccountId__c = accountBusiness.Id);
        // insert quotelineitem1;

        QuoteLineItem quotelineitem2 = new QuoteLineItem(
            Quantity = 2.0,
            QuoteId	 = qq2.Id,
            Product2 = prod2,
            PricebookEntryId = pbE2.Id,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000H0BXCA0',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id);
            
        insert quotelineitem2;

        QuoteLineItem quotelineitem3 = new QuoteLineItem(
            Quantity = 3.0,
            QuoteId	 = qq2.Id,
            Product2 = prod3,
            PricebookEntryId = pbE3.Id,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000H0BXGA0',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id);
        insert quotelineitem3;

        QuoteLineItem quotelineitem4 = new QuoteLineItem(
            Quantity = 4.0,
            QuoteId	 = qq3.Id,
            Product2 = prod4,
            PricebookEntryId = pbE4.Id,
            vlocity_cmt__ReliesOnItemId__c = '0QL78000000H0BXXA0',
            vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}',
            vlocity_cmt__BillingAccountId__c = accountBusiness.Id);
        insert quotelineitem4;

        vlocity_cmt__QuoteMember__c vltQM = new vlocity_cmt__QuoteMember__c();
        vltQM.vlocity_cmt__MemberType__c = 'Location';
        vltQM.name = 'Cafe';
        vltQM.vlocity_cmt__City__c = 'LETICIA';
        vltQM.vlocity_cmt__Country__c = 'COLOMBIA';
        vltQM.vlocity_cmt__PostalCode__c = '123456';
        vltQM.vlocity_cmt__ServiceAccountId__c = accountBusiness.Id;
        vltQM.vlocity_cmt__QuoteId__c = qq1.id;
        vltQM.vlocity_cmt__State__c = 'AMAZONAS';
        vltQM.vlocity_cmt__StreetAddress__c = 'Cafe';
        insert vltQM;

        Viabilidad__c viabilidadSF1 = new Viabilidad__c(
            Estado_Gestor__c = 'Por Asignar',
            Oportunidad__c = ventaUnificadaOpp.Id,
            EstadoViabilidad__c = 'Pendiente',
            Fase_Gestor__c = 'Inicial',
            Fecha_Final_Estado__c = System.today(),
            Ing_Factibilidad__c = 'Ingeniero',
            Respuestadeviabilidad__c = 'Viable',
            Respuesta_Gestor__c = 'OK',
            Tipo_de_Viabilidad__c = 'Por cobertura',
            RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId(),
            ViabilidadNoViable__c = false,
            Crear_VIA_de_Lineas_LTE__c = false,
            Control_Respuestas__c = false);
        insert viabilidadSF1;

        Viabilidad__c viabilidadSF2 = new Viabilidad__c(
            Estado_Gestor__c = 'Por Asignar',
            Oportunidad__c = ventaUnificadaOpp.Id,
            EstadoViabilidad__c = 'Pendiente',
            Fase_Gestor__c = 'Inicial',
            Fecha_Final_Estado__c = System.today(),
            Ing_Factibilidad__c = 'Ingeniero',
            Respuestadeviabilidad__c = 'Viable',
            Respuesta_Gestor__c = 'OK',
            Tipo_de_Viabilidad__c = 'Por cobertura',
            RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId(),
            ViabilidadNoViable__c = false,
            Crear_VIA_de_Lineas_LTE__c = false,
            Control_Respuestas__c = false);
        insert viabilidadSF2;
    }

    @isTest
    static void invokeMethod_startJob_Viabilidad_Success() {
        Map<String, Object> inputMap = new Map<String, Object>();
        List<Object> itemsToProcessSubsetList = new List<Object>();
        Map<String, Object> mapCotizacion = new Map<String, Object>();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Opportunity Test Case' LIMIT 1];
        mapCotizacion.put('OpportunityId', opportunity.Id);
        List<Object> listaProductos = new List<Object>();

        Map<String, Object> itemProduct = new Map<String, Object>();
        itemProduct.put('Operacion', 'Actualizar');
        QuoteLineItem quoteLineItem = [SELECT Id, Product2.ProductCode, Quantity FROM QuoteLineItem WHERE Quantity = 1.0 LIMIT 1];
        itemProduct.put('QuoteLineItemId', quoteLineItem.Id);
        itemProduct.put('productCode', quoteLineItem.Product2.ProductCode);
        itemProduct.put('parentId', null);
        Viabilidad__c viabilidad = [SELECT Id, Name FROM Viabilidad__c LIMIT 1];
        itemProduct.put('idOrigen', viabilidad.Name);
        Account serviceAccount = [SELECT Id FROM Account WHERE Estado_Cuenta__c = 'Activo' LIMIT 1];
        itemProduct.put('ServiceAccId', serviceAccount.Id);
        List<Map<String, Object>> listaConfiguraciones = new List<Map<String, Object>>();
        Map<String, Object> mapConfiguracion = new Map<String, Object>();
        mapConfiguracion.put('Quantity', quoteLineItem.Quantity);
        List<Map<String, Object>> listaParametros = new List<Map<String, Object>>();
        Map<String, Object> mapParametro = new Map<String, Object>();
        mapParametro.put('atributo', 'ATT_Inspección_direccionamientoIP');
        mapParametro.put('valor', 'TEST_01');
        listaParametros.add(mapParametro);
        mapConfiguracion.put('parametros', listaParametros);
        listaConfiguraciones.add(mapConfiguracion);
        itemProduct.put('listaConfiguraciones', listaConfiguraciones);
        listaProductos.add(itemProduct);

        
        Map<String, Object> itemProduct2 = new Map<String, Object>();
        itemProduct2.put('Operacion', 'Actualizar');
        QuoteLineItem quoteLineItem2 = [SELECT Id, Product2.ProductCode, Quantity FROM QuoteLineItem WHERE Quantity = 2.0 LIMIT 1];
        itemProduct2.put('QuoteLineItemId', 'Gestor-0001');
        itemProduct2.put('productCode', quoteLineItem2.Product2.ProductCode);
        itemProduct2.put('parentId', quoteLineItem.Id);
        itemProduct2.put('ServiceAccId', serviceAccount.Id);
        List<Map<String, Object>> listaConfiguraciones2 = new List<Map<String, Object>>();
        Map<String, Object> mapConfiguracion2 = new Map<String, Object>();
        mapConfiguracion2.put('Quantity', quoteLineItem2.Quantity);
        List<Map<String, Object>> listaParametros2 = new List<Map<String, Object>>();
        Map<String, Object> mapParametro2 = new Map<String, Object>();
        mapParametro2.put('atributo', 'ATT_Inspección_direccionamientoIP');
        mapParametro2.put('valor', 'TEST_01');
        listaParametros2.add(mapParametro2);
        mapConfiguracion2.put('parametros', listaParametros);
        listaConfiguraciones2.add(mapConfiguracion);
        itemProduct2.put('listaConfiguraciones', listaConfiguraciones2);
        listaProductos.add(itemProduct2);

        mapCotizacion.put('listaProductos', listaProductos);
        itemsToProcessSubsetList.add(mapCotizacion);
        Map<String, Object> additionalData = new Map<String, Object>();
        additionalData.put('tipoSolicitud','Viabilidad');
        inputMap.put('additionalData',additionalData);
        inputMap.put('itemsToProcessSubsetList', itemsToProcessSubsetList);

        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        String methodName = 'startJob';

        Test.startTest();
            etb_ServiceViabilityImplement serviceViabilityImplement = new etb_ServiceViabilityImplement();
            Object response = serviceViabilityImplement.invokeMethod(methodName, inputMap, outputMap, optionsMap);
        Test.stopTest();
    }


    @isTest
    static void invokeMethod_startJob_Viabilidad_Consultiva_Success() {
        Map<String, Object> inputMap = new Map<String, Object>();
        List<Object> itemsToProcessSubsetList = new List<Object>();
        Map<String, Object> mapCotizacion = new Map<String, Object>();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Opportunity Test Case' LIMIT 1];
        mapCotizacion.put('OpportunityId', opportunity.Id);
        List<Object> listaProductos = new List<Object>();

        Map<String, Object> itemProduct = new Map<String, Object>();
        itemProduct.put('Operacion', 'Actualizar');
        QuoteLineItem quoteLineItem = [SELECT Id, Product2.ProductCode, Quantity FROM QuoteLineItem WHERE Quantity = 1.0 LIMIT 1];
        itemProduct.put('QuoteLineItemId', quoteLineItem.Id);
        itemProduct.put('productCode', quoteLineItem.Product2.ProductCode);
        Viabilidad__c viabilidad = [SELECT Id, Name FROM Viabilidad__c LIMIT 1];
        itemProduct.put('idOrigen', viabilidad.Name);
        itemProduct.put('parentId', null);
        Account serviceAccount = [SELECT Id FROM Account WHERE Estado_Cuenta__c = 'Activo' LIMIT 1];
        itemProduct.put('ServiceAccId', serviceAccount.Id);
        List<Map<String, Object>> listaConfiguraciones = new List<Map<String, Object>>();
        Map<String, Object> mapConfiguracion = new Map<String, Object>();
        mapConfiguracion.put('Quantity', quoteLineItem.Quantity);
        List<Map<String, Object>> listaParametros = new List<Map<String, Object>>();
        Map<String, Object> mapParametro = new Map<String, Object>();
        mapParametro.put('atributo', 'ATT_Inspección_direccionamientoIP');
        mapParametro.put('valor', 'TEST_01');
        listaParametros.add(mapParametro);
        mapConfiguracion.put('parametros', listaParametros);
        listaConfiguraciones.add(mapConfiguracion);
        itemProduct.put('listaConfiguraciones', listaConfiguraciones);
        listaProductos.add(itemProduct);

        
        Map<String, Object> itemProduct2 = new Map<String, Object>();
        itemProduct2.put('Operacion', 'Actualizar');
        QuoteLineItem quoteLineItem2 = [SELECT Id, Product2.ProductCode, Quantity FROM QuoteLineItem WHERE Quantity = 2.0 LIMIT 1];
        itemProduct2.put('QuoteLineItemId', quoteLineItem2.Id);
        itemProduct2.put('productCode', quoteLineItem2.Product2.ProductCode);
        itemProduct2.put('parentId', quoteLineItem.Id);
        itemProduct2.put('ServiceAccId', serviceAccount.Id);
        List<Map<String, Object>> listaConfiguraciones2 = new List<Map<String, Object>>();
        Map<String, Object> mapConfiguracion2 = new Map<String, Object>();
        mapConfiguracion2.put('Quantity', quoteLineItem2.Quantity);
        List<Map<String, Object>> listaParametros2 = new List<Map<String, Object>>();
        Map<String, Object> mapParametro2 = new Map<String, Object>();
        mapParametro2.put('atributo', 'ATT_Inspección_direccionamientoIP');
        mapParametro2.put('valor', 'TEST_01');
        listaParametros2.add(mapParametro2);
        mapConfiguracion2.put('parametros', listaParametros);
        listaConfiguraciones2.add(mapConfiguracion);
        itemProduct2.put('listaConfiguraciones', listaConfiguraciones2);
        listaProductos.add(itemProduct2);

        mapCotizacion.put('listaProductos', listaProductos);
        itemsToProcessSubsetList.add(mapCotizacion);
        Map<String, Object> additionalData = new Map<String, Object>();
        additionalData.put('tipoSolicitud','Viabilidad Consultiva');
        inputMap.put('additionalData',additionalData);
        inputMap.put('itemsToProcessSubsetList', itemsToProcessSubsetList);

        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        String methodName = 'startJob';

        Test.startTest();
            etb_ServiceViabilityImplement serviceViabilityImplement = new etb_ServiceViabilityImplement();
            Object response = serviceViabilityImplement.invokeMethod(methodName, inputMap, outputMap, optionsMap);
        Test.stopTest();
    }




    @isTest
    static void invokeMethod_startJob_Fail() {
        Map<String, Object> inputMap = new Map<String, Object>();
        List<Object> itemsToProcessSubsetList = new List<Object>();
        Map<String, Object> mapCotizacion = new Map<String, Object>();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Opportunity Test Case' LIMIT 1];
        mapCotizacion.put('OpportunityId', opportunity.Id);
        List<Object> listaProductos = new List<Object>();

        Map<String, Object> itemProduct = new Map<String, Object>();
        itemProduct.put('Operacion', 'Actualizar');
        QuoteLineItem quoteLineItem = [SELECT Id, Product2.ProductCode, Quantity FROM QuoteLineItem WHERE Quantity = 1.0 LIMIT 1];
        itemProduct.put('QuoteLineItemId', quoteLineItem.Id);
        itemProduct.put('productCode', quoteLineItem.Product2.ProductCode);
        itemProduct.put('parentId', null);
        Account serviceAccount = [SELECT Id FROM Account WHERE Estado_Cuenta__c = 'Activo' LIMIT 1];
        itemProduct.put('ServiceAccId', serviceAccount.Id);
        List<Map<String, Object>> listaConfiguraciones = new List<Map<String, Object>>();
        Map<String, Object> mapConfiguracion = new Map<String, Object>();
        mapConfiguracion.put('Quantity', quoteLineItem.Quantity);
        List<Map<String, Object>> listaParametros = new List<Map<String, Object>>();
        Map<String, Object> mapParametro = new Map<String, Object>();
        mapParametro.put('atributo', 'ATT_Inspección_direccionamientoIP');
        mapParametro.put('valor', 'TEST_01');
        listaParametros.add(mapParametro);
        mapConfiguracion.put('parametros', listaParametros);
        listaConfiguraciones.add(mapConfiguracion);
        itemProduct.put('listaConfiguraciones', listaConfiguraciones);
        listaProductos.add(itemProduct);

        
        Map<String, Object> itemProduct2 = new Map<String, Object>();
        itemProduct2.put('Operacion', 'Actualizar');
        QuoteLineItem quoteLineItem2 = [SELECT Id, Product2.ProductCode, Quantity FROM QuoteLineItem WHERE Quantity = 2.0 LIMIT 1];
        itemProduct2.put('QuoteLineItemId', quoteLineItem2.Id);
        itemProduct2.put('productCode', quoteLineItem2.Product2.ProductCode);
        itemProduct2.put('parentId', quoteLineItem.Id);
        itemProduct2.put('ServiceAccId', serviceAccount.Id);
        List<Map<String, Object>> listaConfiguraciones2 = new List<Map<String, Object>>();
        Map<String, Object> mapConfiguracion2 = new Map<String, Object>();
        mapConfiguracion2.put('Quantity', quoteLineItem2.Quantity);
        List<Map<String, Object>> listaParametros2 = new List<Map<String, Object>>();
        Map<String, Object> mapParametro2 = new Map<String, Object>();
        mapParametro2.put('atributo', 'ATT_Inspección_direccionamientoIP');
        mapParametro2.put('valor', 'TEST_01');
        listaParametros2.add(mapParametro2);
        mapConfiguracion2.put('parametros', listaParametros);
        listaConfiguraciones2.add(mapConfiguracion);
        itemProduct2.put('listaConfiguraciones', listaConfiguraciones2);
        listaProductos.add(itemProduct2);

        mapCotizacion.put('listaProductos', listaProductos);
        itemsToProcessSubsetList.add(mapCotizacion);
        inputMap.put('itemsToProcessSubsetList', itemsToProcessSubsetList);

        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        String methodName = 'endJob';

        Test.startTest();
            etb_ServiceViabilityImplement serviceViabilityImplement = new etb_ServiceViabilityImplement();
            Object response = serviceViabilityImplement.invokeMethod(methodName, inputMap, outputMap, optionsMap);
        Test.stopTest();
        System.assertEquals(true,JSON.serialize(response).contains('400'));
        
    }

    // @isTest
    // static void relateItemsSuccess(){

    //     String quoteId = [SELECT id 
    //                         FROM Quote 
    //                         WHERE Name = 'COT-14' LIMIT 1].id;
    //     list<QuoteLineItem> QLIPre= [SELECT id,Quantity,Product2.ProductCode,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__Query__c
    //                                  FROM QuoteLineItem 
    //                                  WHERE QuoteId =: quoteId];
    //     list<product2> products = [SELECT Id,ProductCode 
    //                                 FROM Product2 
    //                                 WHERE ProductCode = 'PR_ROUTER_CISCO_SERIE_ISR1000'];
    //     String input='[ { "pricebookId":"01u7800000110aUAAQ", "parametros":[ { "atributo":"ATT_Inspección_direccionamientoIP", "valor":"TEST_01" }, { "atributo":"ATT_Porcentaje_crecimiento_12_meses", "valor":7 }, { "atributo":"ATT_Se_requiereTráfico_Cifrado", "valor":false }, { "atributo":"ATT_TiempoContratoDias", "valor":0 }, { "atributo":"ATT_TiempoContratoMeses", "valor":12 }, { "atributo":"ATT_Número_de_usuarios_sede", "valor":5 }, { "atributo":"ATT_Clausula_de_Terminacion_Anticipada", "valor":"Sí Acepta" }, { "atributo":"ATT_Ancho_Banda", "valor":"Hasta 50 Mbps" } ], "Quantity":9, "ServiceAccId":"00178000009UxCAAA0", "parentId":"'+QLIPre[1].id+'", "productCode":"PR_Navegacion_segura_Avanzada", "QuoteLineItemId":"0QL78000000H16IGAS", "Operacion":"Actualizar" } ]';
    //     List<Object> listaproductos = (List<Object>)JSON.deserializeUntyped(input);
    //     Test.startTest();
    //     etb_ServiceViabilityImplement.relateItems(listaproductos, quoteId,'Viabilidad',QLIPre);
    //     Test.stopTest();
    // }

    @isTest
    static void updateAttributesSuccess(){
        String quoteId = [SELECT id FROM Quote WHERE Name = 'COT-13' LIMIT 1].id;
        QuoteLineItem QLIPre= [SELECT id,Quantity FROM QuoteLineItem WHERE QuoteId =: quoteId LIMIT 1];
        String input='[ { "pricebookId":"01u7800000110aUAAQ", "parametros":[ { "atributo":"ATT_Inspección_direccionamientoIP", "valor":"TEST_01" }, { "atributo":"ATT_Porcentaje_crecimiento_12_meses", "valor":7 }, { "atributo":"ATT_Se_requiereTráfico_Cifrado", "valor":false }, { "atributo":"ATT_TiempoContratoDias", "valor":0 }, { "atributo":"ATT_TiempoContratoMeses", "valor":12 }, { "atributo":"ATT_Número_de_usuarios_sede", "valor":5 }, { "atributo":"ATT_Clausula_de_Terminacion_Anticipada", "valor":"Sí Acepta" }, { "atributo":"ATT_Ancho_Banda", "valor":"Hasta 50 Mbps" } ], "Quantity":9, "ServiceAccId":"00178000009UxCAAA0", "parentId":"'+QLIPre.id+'", "productCode":"PR_Navegacion_segura_Avanzada", "QuoteLineItemId":"0QL78000000H16IGAS", "Operacion":"Actualizar" } ]';
        List<Object> listaproductos = (List<Object>)JSON.deserializeUntyped(input);
        Test.startTest();
        etb_ServiceViabilityImplement.updateAttributes(listaproductos, quoteId);
        Test.stopTest();
        QuoteLineItem QLIPost =[SELECT Id,vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE QuoteId = :quoteId LIMIT 1];
        Map<String, Object> AttributeSelectedValues = (Map<String, Object>)JSON.deserializeUntyped(QLIPost.vlocity_cmt__AttributeSelectedValues__c);
        System.assertEquals('TEST_01', String.valueOf(AttributeSelectedValues.get('ATT_Inspección_direccionamientoIP')));
    }

    /*@isTest 
    static void createCotizacionAvanzadaSuccess(){
        String quoteId = [SELECT id FROM Quote WHERE Name = 'COT-13' LIMIT 1].id;
       Test.startTest();
        etb_ServiceViabilityImplement.createCotizacionAvanzada(quoteId);
        Test.stopTest();
        List<ETB_CotizacionAvanzada__c> listCACreadas= [SELECT Id FROM ETB_CotizacionAvanzada__c LIMIT 100];
        System.assertNotEquals(0,listCACreadas.Size());
    }*/


//{"itemsProcessed": [{"successfully":[{"viabilidad":"VIA-000001"}]}]}


@isTest
    static void sendEmailViabilidadesSuccess(){
        List<Viabilidad__c> Viabilidades =(List<Viabilidad__c>)[SELECT Name FROM Viabilidad__c ORDER BY Name DESC LIMIT 2];
        List<String> nombresViabilidades = New List<String>();
        for (Viabilidad__c viaAux : Viabilidades) {
            nombresViabilidades.add(viaAux.name);
        }
        System.debug('Viabilidades->_>'+Viabilidades);
        //  String input= '{"itemsProcessed": [{"successfully":[{"viabilidad":"VIA-000001"},{"viabilidad":"VIA-000002"}]}]}]';
        String input= '{"itemsProcessed": {"successfully":[{"viabilidad":"'+nombresViabilidades.get(0)+'"},{"viabilidad":"'+nombresViabilidades.get(1)+'"}]}}';
         Map<String,Object> inputdata = (Map<String,Object>)JSON.deserializeUntyped(input);
        Test.startTest();
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        etb_ServiceViabilityImplement.sendEmailViabilidades(inputdata);
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
        Test.stopTest();
    }

}