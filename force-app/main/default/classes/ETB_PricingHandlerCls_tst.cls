/****************************************************************************************************
    Autor:          edwin.bohorquez@globant.com
    Project:        Vlocity - ETB
    Description:    Clase de prueba para creacion de notificaciones de la clase ETB_CrearNotificacionCls

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         3-11-2022         Adrian Bohorquez            Creación de Clase
*****************************************************************************************************/
@isTest
public class ETB_PricingHandlerCls_tst {

    @TestVisible
    private static final String STATUS_DRAFT  = 'Draft';
    
   	@TestSetup
    public static void createData (){
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product2 = new Product2();
        product2.Family = 'Internet HFC';
        product2.ProductCode = 'PR_INTERNET_DEDICADO';
        product2.Name = 'Internet Dedicado';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness; 
        
        Account accountService = new Account();
        accountService.Name = 'Account Service';
        accountService.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        accountService.Type = 'Service';
        accountService.Phone = '12345678';
        accountService.ParentId = accountBusiness.Id;
        insert accountService; 
        
        Account accountBilling = new Account();
        accountBilling.Name = 'Account Billing';
        accountBilling.Type = 'Billing';
        accountBilling.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
        accountBilling.ParentId = accountBusiness.id;
        accountBilling.Phone = '12345678';
        insert accountBilling; 
        
        Order order = new Order ();
        order.Name = 'Venta Internet';
        order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('StandardOrder').getRecordTypeId();
        order.AccountId = accountBusiness.Id;
        order.Status = STATUS_DRAFT;
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        order.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        order.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        insert order;
        
        OrderItem orderItemPlan = new OrderItem();
        orderItemPlan.OrderId = order.Id;
        orderItemPlan.UnitPrice = 0.0;
        orderItemPlan.Quantity = 1;
        orderItemPlan.PricebookEntryId = price.Id;
        orderItemPlan.vlocity_cmt__Action__c = 'Add';
		orderItemPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan;
        
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
        
        Quote enterpriseQuote = new Quote();
        enterpriseQuote.OwnerId = Userinfo.getUserId();
        enterpriseQuote.Name = 'Enterprise Quote';
        enterpriseQuote.Pricebook2Id = pricebookId;
        enterpriseQuote.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote;
        
        QuoteLineItem quotelineitem = new QuoteLineItem(
        QuoteId = enterpriseQuote.Id,
        Quantity = 1.0,
        UnitPrice = 0.0,
        PricebookEntryId = price.Id,
        vlocity_cmt__Action__c = 'Add',
        vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
        vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":2,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
        vlocity_cmt__BillingAccountId__c = accountBilling.Id,
        vlocity_cmt__CurrencyPaymentMode__c = 'Currency',
        vlocity_cmt__EffectiveOneTimeCostTotal__c = 0.0,
        vlocity_cmt__EffectiveOneTimeTotal__c = 0.0,
        vlocity_cmt__EffectiveQuantity__c = 1.0,
        vlocity_cmt__EffectiveRecurringCostTotal__c = 41010.0,
        vlocity_cmt__EffectiveRecurringTotal__c = 75000.0,
        vlocity_cmt__LineNumber__c = '0001',
        vlocity_cmt__OneTimeCalculatedPrice__c = 0.0,
        vlocity_cmt__OneTimeCharge__c = 0.0,
        vlocity_cmt__OneTimeCostTotal__c = 0.0,
        vlocity_cmt__OneTimeCost__c = 0.0,
        vlocity_cmt__OneTimeManualDiscount__c = 0.0,
        vlocity_cmt__OneTimeMargin__c = 0.0,
        vlocity_cmt__OneTimeTotal__c = 0.0,
        vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (41010.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (75000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (75000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":75000.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":75000.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":75000.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":75000.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}],"REC_MNTH_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":41010.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":41010.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":41010.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":41010.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_CALC":75000.00,"REC_MNTH_STD_PRC":75000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":82.88,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST":41010.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"LogVersion":"3.0","PriceAsOfDateTime":"2022-05-04T16:36:02.576Z","LastPricingTime":"2022-05-04T16:36:02.576Z","ExternalPrices":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}',
        Product2Id = product2.Id,
        vlocity_cmt__Product2Id__c = product2.Id,
        vlocity_cmt__ProductHierarchyGroupKeyPath__c = 'd74f9058-70b2-6370-0243-361d7f43829f',
        vlocity_cmt__ProvisioningStatus__c = 'New',
        vlocity_cmt__RecurringCalculatedPrice__c = 75000.0,
        vlocity_cmt__RecurringCharge__c = 75000.0,
        vlocity_cmt__RecurringCostTotal__c = 41010.0,
        vlocity_cmt__RecurringCost__c = 41010.0,
        vlocity_cmt__RecurringManualDiscount__c = 0.0,
        vlocity_cmt__RecurringMargin__c = 82.88,
        vlocity_cmt__RecurringTotal__c = 75000.0,
        vlocity_cmt__RecurringUOM__c = 'Monthly',
        vlocity_cmt__Recurring_UOM__c = 'Monthly',
        vlocity_cmt__RelationshipType__c = 'Child',
        vlocity_cmt__RootItemId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de',
        vlocity_cmt__SequenceNumber__c = 1.0,
        vlocity_cmt__ServiceAccountId__c = accountService.Id,
        vlocity_cmt__UsageQuantity__c = 1.0);
        insert quotelineitem;
    }
    
    @isTest
  	static void getMetadatatest (){

       	Test.startTest();
        ETB_PricingHandlerCls.getMetadata('PR_INTERNET_DEDICADO');
        Test.stopTest();

    }
     

    @isTest
    static void calculatePricingTest (){

        Test.startTest();
        ETB_GL_ConfPricing__mdt cfgtest = new ETB_GL_ConfPricing__mdt();
        cfgtest.DeveloperName = 'PR_INTERNET_DEDICADO';
        cfgtest.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  

        Map<String, Object> map1 = new Map<String, Object>();
        map1.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest);

        ETB_PricingHandlerCls.calculatePricing(cfgtest, map1);
        Test.stopTest();
    }
    
  @isTest
    static void readAttributesFromQLItest (){

        ETB_BW__c bandwidth = new ETB_BW__C(BW_Mbps__c = 0.0625);
        insert bandwidth;
        Product2 prod5 = new Product2 (Name='HD TV', ProductCode = 'VLO-TV-0008');
        insert prod5;
        Product2 prod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'VLO-BUN-0001');
        insert prod1;
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
        insert testPricebook;
        PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pricebookId,
                Product2Id = prod5.Id, UnitPrice = 10, vlocity_cmt__RecurringPrice__c = 5, IsActive = true);
        insert pbe11;
        Account accountBusiness = new Account();
            accountBusiness.Name = 'Account Billing';
            accountBusiness.Type = 'Business';
            accountBusiness.Phone = '12345678';
            accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        Opportunity ventaUnificadaOpp = new Opportunity();
            ventaUnificadaOpp.CloseDate = System.today()+1;
            ventaUnificadaOpp.Amount = 200000.0;
            ventaUnificadaOpp.CausaldePerdida__c ='Otro';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
        insert ventaUnificadaOpp;
        Quote cotizacion = new Quote(
            Name = 'testQuote',
            OpportunityId = ventaUnificadaOpp.Id,
            Pricebook2Id = pricebookId
        );
        insert cotizacion;

        QuoteLineItem lineItem = new QuoteLineItem(
            QuoteId = cotizacion.Id,
            PricebookEntryId = pbe11.Id,
            Quantity = 1,
            UnitPrice = 0,
            Product2Id = prod5.Id
            //lineItem.vlocity_cmt__AttributeSelectedValues__c='',
        );
        lineItem.vlocity_cmt__AttributeSelectedValues__c ='{"ATT_SF_Nemonico":"GD","ATT_SF_TiempoContratoMeses":null,"ATT_SF_TiempoContratoDias":12,"ATT_SF_Comentarios":null}'; 
        insert lineItem;

        Test.startTest();
        ETB_GL_ConfPricing__mdt cfgtest2 = new ETB_GL_ConfPricing__mdt();
        cfgtest2.DeveloperName = 'PR_INTERNET_DEDICADO';
        cfgtest2.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';

        Map<String, Object> map2 = new Map<String, Object>();
        map2.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest2);        

        ETB_PricingHandlerCls.readAttributesFromQLI(lineItem,map2);
        Test.stopTest();
    }

    
    @isTest
    static void readAttributesFromIdTest (){
       
        ETB_BW__c bandwidth = new ETB_BW__C(BW_Mbps__c = 0.0625);
        insert bandwidth;
        Product2 prod5 = new Product2 (Name='HD TV', ProductCode = 'VLO-TV-0008');
        insert prod5;
        Product2 prod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'VLO-BUN-0001');
        insert prod1;
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
        insert testPricebook;
        PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pricebookId,
                Product2Id = prod5.Id, UnitPrice = 10, vlocity_cmt__RecurringPrice__c = 5, IsActive = true);
        insert pbe11;
        Account accountBusiness = new Account();
            accountBusiness.Name = 'Account Billing';
            accountBusiness.Type = 'Business';
            accountBusiness.Phone = '12345678';
            accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        Opportunity ventaUnificadaOpp = new Opportunity();
            ventaUnificadaOpp.CloseDate = System.today()+1;
            ventaUnificadaOpp.Amount = 200000.0;
            ventaUnificadaOpp.CausaldePerdida__c ='Otro';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
        insert ventaUnificadaOpp;

        Quote cotizacion = new Quote(
            Name = 'testQuote',
            OpportunityId = ventaUnificadaOpp.Id,
            Pricebook2Id = pricebookId
        );
        insert cotizacion;

         QuoteLineItem lineItem = new QuoteLineItem(
            QuoteId = cotizacion.Id,
            PricebookEntryId = pbe11.Id,
            Quantity = 1,
            UnitPrice = 0,
            Product2Id = prod5.Id,
            vlocity_cmt__AttributeSelectedValues__c ='{"ATT_Comentarios":null,"ATT_Extension":null,"ATT_Tipo_de_contrato":"Renovación","ATT_Tipo_de_catalogo":"Portafolio Superior"}'
            );
            insert lineItem;

        Test.startTest();
        System.debug('JFRC:Linea Cotización Insertada--' + lineItem.Id  + '  -cotizacion:' + lineItem.QuoteId);    
        String jsonAtributos ='';
        Map<String, Object> mapValoresAtributos = new Map<String, Object>();
        ETB_PricingHandlerCls.readAttributesFromId(lineItem.Id,mapValoresAtributos, jsonAtributos);
        Test.stopTest();
    }

    @isTest
    static void readAttributesFromIdTestException (){
       
        ETB_BW__c bandwidth = new ETB_BW__C(BW_Mbps__c = 0.0625);
        insert bandwidth;
        Product2 prod5 = new Product2 (Name='HD TV', ProductCode = 'VLO-TV-0008');
        insert prod5;
        Product2 prod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'VLO-BUN-0001');
        insert prod1;
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
        insert testPricebook;
        PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pricebookId,
                Product2Id = prod5.Id, UnitPrice = 10, vlocity_cmt__RecurringPrice__c = 5, IsActive = true);
        insert pbe11;
        Account accountBusiness = new Account();
            accountBusiness.Name = 'Account Billing';
            accountBusiness.Type = 'Business';
            accountBusiness.Phone = '12345678';
            accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        Opportunity ventaUnificadaOpp = new Opportunity();
            ventaUnificadaOpp.CloseDate = System.today()+1;
            ventaUnificadaOpp.Amount = 200000.0;
            ventaUnificadaOpp.CausaldePerdida__c ='Otro';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
        insert ventaUnificadaOpp;

        Quote cotizacion = new Quote(
            Name = 'testQuote',
            OpportunityId = ventaUnificadaOpp.Id,
            Pricebook2Id = pricebookId
        );
        insert cotizacion;

         QuoteLineItem lineItem = new QuoteLineItem(
            QuoteId = cotizacion.Id,
            PricebookEntryId = pbe11.Id,
            Quantity = 1,
            UnitPrice = 0,
            Product2Id = prod5.Id,
            vlocity_cmt__AttributeSelectedValues__c ='{"ATT_Comentarios":null,"ATT_Extension":null,"ATT_Tipo_de_contrato":"Renovación","ATT_Tipo_de_catalogo":"Portafolio Superior"}'
            );
            insert lineItem;

        Test.startTest();
        System.debug('JFRC:Linea Cotización Insertada--' + lineItem.Id  + '  -cotizacion:' + lineItem.QuoteId);    
        String jsonAtributos ='';
        Map<String, Object> mapValoresAtributos = new Map<String, Object>();
        ETB_PricingHandlerCls.readAttributesFromId(lineItem.QuoteId,mapValoresAtributos, jsonAtributos);
        Test.stopTest();
    }

    @isTest
    static void readAttributesFromHookTest (){

        Test.startTest();
        
        List<vlocity_cmt__AttributeCategory__c> listAtributos = new List<vlocity_cmt__AttributeCategory__c>(); // Define a new list
        vlocity_cmt__AttributeCategory__c listAtributosCategory = new vlocity_cmt__AttributeCategory__c (Name='Características Avanzadas', vlocity_cmt__DisplaySequence__c=30);
        insert listAtributosCategory;
        listAtributos.add(listAtributosCategory);

        Map<String, Object> mapObj = new Map<String, Object>();
        mapObj.put('attributeCategories', listAtributosCategory);
       // listAtributos.add('attributeCategories', listAtributosCategory)

        //Map<String, Object> mapObj2 = new Map<String, Object>();
        //mapObj2.put('attributeCategories', listAtributosCategory);

        ETB_PricingHandlerCls.readAttributesFromHook(mapObj,listAtributos);
        Test.stopTest();
    }

    @isTest
    static void callGetCartLineItemPricesTest (){
        ETB_BW__c bandwidth = new ETB_BW__C(BW_Mbps__c = 0.0625);
        insert bandwidth;
        Product2 prod5 = new Product2 (Name='HD TV', ProductCode = 'VLO-TV-0008');
        insert prod5;
        Product2 prod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'VLO-BUN-0001');
        insert prod1;
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
        insert testPricebook;
        PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pricebookId,
                Product2Id = prod5.Id, UnitPrice = 10, vlocity_cmt__RecurringPrice__c = 5, IsActive = true);
        insert pbe11;
        Account accountBusiness = new Account();
            accountBusiness.Name = 'Account Billing';
            accountBusiness.Type = 'Business';
            accountBusiness.Phone = '12345678';
            accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        Opportunity ventaUnificadaOpp = new Opportunity();
            ventaUnificadaOpp.CloseDate = System.today()+1;
            ventaUnificadaOpp.Amount = 200000.0;
            ventaUnificadaOpp.CausaldePerdida__c ='Otro';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
        insert ventaUnificadaOpp;

        Quote cotizacion = new Quote(
            Name = 'testQuote',
            OpportunityId = ventaUnificadaOpp.Id,
            Pricebook2Id = pricebookId
        );
        insert cotizacion;

         QuoteLineItem lineItem = new QuoteLineItem(
            QuoteId = cotizacion.Id,
            PricebookEntryId = pbe11.Id,
            Quantity = 1,
            UnitPrice = 0,
            Product2Id = prod5.Id,
            vlocity_cmt__AttributeSelectedValues__c ='{"ATT_Comentarios":null,"ATT_Extension":null,"ATT_Tipo_de_contrato":"Renovación","ATT_Tipo_de_catalogo":"Portafolio Superior"}'
            );
            insert lineItem;

        Test.startTest();
        vlocity_cmt.JSONResult result;
        ETB_PricingHandlerCls.callGetCartLineItemPrices(lineItem.Id, result);
        Test.stopTest();
    }

    @isTest
    static void transformListToMapAttributestest (){

        Test.startTest();
        Map<String,Object> mapa = new Map<String,Object>();
        Map<String,Object> mapasec = new Map<String,Object>();
        ETB_GL_ConfPricing__mdt cfgtest6 = new ETB_GL_ConfPricing__mdt();
        cfgtest6.DeveloperName = 'PR_INTERNET_DEDICADO';
        cfgtest6.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  

        Map<String, Object> map6 = new Map<String, Object>();
        map6.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest6);

        Product2 listaAtributosPrincipal1 = new Product2 (Name='Internet + Empresarial', 
                                                          ProductCode = 'PR_INTERNET_MAS_EMPRESARIAL', 
                                                          vlocity_cmt__AttributeMetadata__c ='{"totalSize" : 2, "messages" : [ ],"records" : [ {"messages" : [ ],"displaySequence" : 30,"Code__c" : "ATTCAT_Caracteristicas_Avanzadas","Name" : "Características Avanzadas","id" : "a4V8F0000008dw7UAA","productAttributes" : {"totalSize" : 2,"messages" : [ ],"records" : [ {"messages" : [ ],"code" : "ATT_SF_Nemonico","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : true,"disabled" : true,"filterable" : false,"attributeId" : "a4W8F000000CtMWUA0","label" : "Nemonico","displaySequence" : 20,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false,"values" : [ {"readonly" : true,"disabled" : true} ],"userValues" : null}, {"messages" : [ ],"code" : "ATT_SF_Descripcion","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : true,"disabled" : true,"filterable" : false,"attributeId" : "a4W8F000000CtMKUA0","label" : "Descripción","displaySequence" : 420,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false,"values" : [ {"readonly" : true,"disabled" : true} ],"userValues" : null} ]}}, {"messages" : [ ],"displaySequence" : 20,"Code__c" : "ATTCAT_Características_Generales","Name" : "Características Generales","id" : a4V8F0000008dwCUAQ",  "productAttributes" : {"totalSize" : 1,"messages" : [ ],"records" : [ {"messages" : [ ],"code" : "ATT_SF_Comentarios","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : false,"disabled" : false,"filterable" : false,"attributeId" : "a4W8F000000CtNKUA0","label" : "Comentarios","displaySequence" : 1200,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false, "values" : [ {"readonly" : false,"disabled" : false} ],"userValues" : null} ]}} ]}' );
        insert listaAtributosPrincipal1;
    
        List<Product2> listAtribSec = new List<Product2>(); // Define a new list
        Product2 latrbsec1 = new Product2 (Name='Router JUNIPER Serie SRX', 
                                                           ProductCode = 'PR_ROUTER_JUNIPER_SERIE_SRX', 
                                                           vlocity_cmt__AttributeMetadata__c ='{"totalSize" : 2, "messages" : [ ],"records" : [ {"messages" : [ ],"displaySequence" : 30,"Code__c" : "ATTCAT_Caracteristicas_Avanzadas","Name" : "Características Avanzadas","id" : "a4V8F0000008dw7UAA","productAttributes" : {"totalSize" : 2,"messages" : [ ],"records" : [ {"messages" : [ ],"code" : "ATT_SF_Nemonico","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : true,"disabled" : true,"filterable" : false,"attributeId" : "a4W8F000000CtMWUA0","label" : "Nemonico","displaySequence" : 20,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false,"values" : [ {"readonly" : true,"disabled" : true} ],"userValues" : null}, {"messages" : [ ],"code" : "ATT_SF_Descripcion","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : true,"disabled" : true,"filterable" : false,"attributeId" : "a4W8F000000CtMKUA0","label" : "Descripción","displaySequence" : 420,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false,"values" : [ {"readonly" : true,"disabled" : true} ],"userValues" : null} ]}}, {"messages" : [ ],"displaySequence" : 20,"Code__c" : "ATTCAT_Características_Generales","Name" : "Características Generales","id" : a4V8F0000008dwCUAQ",  "productAttributes" : {"totalSize" : 1,"messages" : [ ],"records" : [ {"messages" : [ ],"code" : "ATT_SF_Comentarios","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : false,"disabled" : false,"filterable" : false,"attributeId" : "a4W8F000000CtNKUA0","label" : "Comentarios","displaySequence" : 1200,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false, "values" : [ {"readonly" : false,"disabled" : false} ],"userValues" : null} ]}} ]}'
                                                           );
        insert latrbsec1;
        Product2 latrbsec2 = new Product2 (Name='Router CISCO', 
                                                           ProductCode = 'PR_ROUTER_CISCO', 
                                                           vlocity_cmt__AttributeMetadata__c ='{"totalSize" : 2, "messages" : [ ],"records" : [ {"messages" : [ ],"displaySequence" : 30,"Code__c" : "ATTCAT_Caracteristicas_Avanzadas","Name" : "Características Avanzadas","id" : "a4V8F0000008dw7UAA","productAttributes" : {"totalSize" : 2,"messages" : [ ],"records" : [ {"messages" : [ ],"code" : "ATT_SF_Nemonico","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : true,"disabled" : true,"filterable" : false,"attributeId" : "a4W8F000000CtMWUA0","label" : "Nemonico","displaySequence" : 20,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false,"values" : [ {"readonly" : true,"disabled" : true} ],"userValues" : null}, {"messages" : [ ],"code" : "ATT_SF_Descripcion","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : true,"disabled" : true,"filterable" : false,"attributeId" : "a4W8F000000CtMKUA0","label" : "Descripción","displaySequence" : 420,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false,"values" : [ {"readonly" : true,"disabled" : true} ],"userValues" : null} ]}}, {"messages" : [ ],"displaySequence" : 20,"Code__c" : "ATTCAT_Características_Generales","Name" : "Características Generales","id" : a4V8F0000008dwCUAQ",  "productAttributes" : {"totalSize" : 1,"messages" : [ ],"records" : [ {"messages" : [ ],"code" : "ATT_SF_Comentarios","dataType" : "text","inputType" : "text","multiselect" : false,"required" : false,"readonly" : false,"disabled" : false,"filterable" : false,"attributeId" : "a4W8F000000CtNKUA0","label" : "Comentarios","displaySequence" : 1200,"hasRules" : false,"hidden" : false,"cloneable" : true,"isNotTranslatable" : false,"isNotAssetizable" : false, "values" : [ {"readonly" : false,"disabled" : false} ],"userValues" : null} ]}} ]}'
                                                           );
        insert latrbsec2;

        mapa.put('userValues',listaAtributosPrincipal1);
        mapasec.put('items',latrbsec1);
 
        Map<String,Object> mapValoresAtributos = new Map<String,Object>();
        List<Object> attValoresPadre = new List<Object>();
        List<Object> attValoresHijo = new List<Object>();
        attValoresPadre.add(mapa);
        attValoresHijo.add(mapasec);
       
        ETB_PricingHandlerCls.transformListToMapAttributes(attValoresPadre, attValoresHijo,mapValoresAtributos);
        Test.stopTest();
    }

    @isTest
    static void cleanMapAttributesTest (){

        Test.startTest();
        ETB_GL_ConfPricing__mdt cfgtest4 = new ETB_GL_ConfPricing__mdt();
        cfgtest4.DeveloperName = 'PR_INTERNET_DEDICADO';
        cfgtest4.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  

        Map<String, Object> map4 = new Map<String, Object>();
        map4.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest4);
        ETB_PricingHandlerCls.cleanMapAttributes(map4);
        Test.stopTest();
    }
    
     @isTest
       static void cleanMapAttributesTestExcep (){
       Test.startTest();
        Map<String, Object> map4 = new Map<String, Object>();
        ETB_PricingHandlerCls.cleanMapAttributes(map4);
        Test.stopTest();
    }
    
    @isTest
    static void getGeneralIndicatorsTst(){
        QuoteLineItem itemId = [Select Id from QuoteLineItem limit 1];
        Map<String,Object> mapResultado = new Map<String,Object>();
        Test.startTest();        
        mapResultado=ETB_PricingHandlerCls.getGeneralIndicators(itemId.Id);
        Test.stopTest();
        Assert.areEqual(100,(Decimal) mapResultado.get('porcentajeAsignacion'));    
        Assert.areEqual(0,(Decimal) mapResultado.get('impuestosAdicionales'));    
    }
    @isTest
    static void getGeneralIndicatorsTst2(){        
        QuoteLineItem itemId = [Select Id, QuoteId from QuoteLineItem limit 1];
        Quote quoteTemp = [Select Id,ETB_GL_PorcentajeAsignacion__c,Impuestos_Adicionales__c from Quote where Id =: itemId.QuoteId Limit 1 ];
        quoteTemp.Impuestos_Adicionales__c = 20;
        quoteTemp.ETB_GL_PorcentajeAsignacion__c = 50;
        update quoteTemp;
        Map<String,Object> mapResultado = new Map<String,Object>();
        Test.startTest();        
        mapResultado=ETB_PricingHandlerCls.getGeneralIndicators(itemId.Id);
        Test.stopTest();
        Assert.areEqual(100,(Decimal) mapResultado.get('porcentajeAsignacion'));    
        Assert.areEqual(0,(Decimal) mapResultado.get('impuestosAdicionales'));    
    }
    @isTest
    static void getGeneralIndicatorsTst3(){
        OrderItem itemId = [Select Id from OrderItem limit 1];
        Map<String,Object> mapResultado = new Map<String,Object>();
        Test.startTest();        
        mapResultado=ETB_PricingHandlerCls.getGeneralIndicators(itemId.Id);
        Test.stopTest();
        Assert.areEqual(100,(Decimal) mapResultado.get('porcentajeAsignacion'));    
        Assert.areEqual(0,(Decimal) mapResultado.get('impuestosAdicionales'));    
    }
    @isTest
    static void getGeneralIndicatorsTst4(){        
        OrderItem itemId = [Select Id, OrderId from OrderItem limit 1];
        Order orderTemp = [Select Id,ETB_GL_PorcentajeAsignacion__c,Impuestos_Adicionales__c from Order where Id =: itemId.OrderId Limit 1 ];
        orderTemp.Impuestos_Adicionales__c = 20;
        orderTemp.ETB_GL_PorcentajeAsignacion__c = 50;
        update orderTemp;
        Map<String,Object> mapResultado = new Map<String,Object>();
        Test.startTest();        
        mapResultado=ETB_PricingHandlerCls.getGeneralIndicators(itemId.Id);
        Test.stopTest();
        Assert.areEqual(50,(Decimal) mapResultado.get('porcentajeAsignacion'));    
        Assert.areEqual(20,(Decimal) mapResultado.get('impuestosAdicionales'));    
    }
    @isTest
    static void getGeneralIndicatorsTst5(){
        String itemId='dfafdafd';
        Map<String,Object> mapResultado = new Map<String,Object>();
        Test.startTest();        
        mapResultado=ETB_PricingHandlerCls.getGeneralIndicators(itemId);
        Test.stopTest();
        Assert.areEqual(100,(Decimal) mapResultado.get('porcentajeAsignacion'));    
        Assert.areEqual(0,(Decimal) mapResultado.get('impuestosAdicionales'));    
    }
  
}