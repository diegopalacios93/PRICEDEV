/*---------------------------------------------------------------------------------------------------------------
--- Company: LabsXD
--- Author: Victor Pacheco
--- Description: Genera data para las clases test
--- CreateDate:  29/11/2021
---------------------------------------------------------------------------------------------------------------*/

@isTest
public with sharing class CreateDataTest {
    
    @TestVisible
    private static final String STATUS_DRAFT  = 'Draft';

    @TestSetup
    public static void createData (){
        
        Id pricebookId = Test.getStandardPricebookId();
        
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
		
        Contact contact = new Contact();
        contact.Email = 'labsx@labsxd.com';
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Phone = '12345678';
        contact.AccountId = accountBusiness.Id;
        insert contact;
        
        accountBusiness.vlocity_cmt__PersonContactId__c = contact.Id;
        UPDATE accountBusiness;
        
        Product2 product2 = new Product2();
        product2.Family = 'Internet HFC';
        product2.ProductCode = 'OM_Internet_HFC';
        product2.Name = 'Internet 1';
        insert product2;
        
        Product2 productBase = new Product2();
        productBase.Family = 'CS/CD';
        productBase.ProductCode = 'OM_BASE';
        productBase.Name = 'Cambio';
        insert productBase;

        Product2 product2Dispositivo = new Product2();
        product2Dispositivo.Family = 'Dispositivo';
        product2Dispositivo.Name = 'Modem';
        product2Dispositivo.vlocity_cmt__Type__c = 'Modem';
        insert product2Dispositivo;
        
        Product2 product2Installation = new Product2();
        product2Installation.Family = 'Costo';
        product2Installation.Name = 'Modem';
        product2Installation.ProductCode = 'costoInstalacion01';
        insert product2Installation;
        
        
                
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;       
        
        PricebookEntry priceDispositivo = new PricebookEntry();
        priceDispositivo.UnitPrice = 0.0;
        priceDispositivo.Pricebook2Id = pricebookId;
        priceDispositivo.Product2Id = product2Dispositivo.Id;
        priceDispositivo.isActive = true;
        insert priceDispositivo;
        
        PricebookEntry priceInstallation = new PricebookEntry();
        priceInstallation.UnitPrice = 0.0;
        priceInstallation.Pricebook2Id = pricebookId;
        priceInstallation.Product2Id = product2Installation.Id;
        priceInstallation.isActive = true;
        insert priceInstallation; 
        
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
        

        Asset assetPlan = new Asset();
        assetPlan.Status = 'Active';
        assetPlan.Name = 'Plan 1';
        assetPlan.AccountId = accountBusiness.Id;
        assetPlan.ContactId = contact.Id;
        assetPlan.Product2Id = product2.Id;
		assetPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        assetPlan.vlocity_cmt__OrderId__c = order.Id;
        insert assetPlan;      

        Asset assetDispositivo = new Asset();
        assetDispositivo.Status = 'Active';
        assetDispositivo.Name = 'Plan 1';
        assetDispositivo.AccountId = accountBusiness.Id;
        assetDispositivo.ContactId = contact.Id;
        assetDispositivo.vlocity_cmt__ParentItemId__c = assetPlan.id;
		assetDispositivo.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        assetDispositivo.vlocity_cmt__OrderId__c = order.Id;
        insert assetDispositivo;
        
        Asset assetInstallation = new Asset();
        assetInstallation.Status = 'Active';
        assetInstallation.Name = 'Plan 1';
        assetInstallation.AccountId = accountBusiness.Id;
        assetInstallation.ContactId = contact.Id;
        assetInstallation.vlocity_cmt__ParentItemId__c = assetPlan.id;
        assetInstallation.vlocity_cmt__OrderId__c = order.Id;
        insert assetInstallation;

        Asset assetPlan2 = new Asset();
        assetPlan2.Status = 'Active';
        assetPlan2.Name = 'Plan 2';
        assetPlan2.AccountId = accountBusiness.Id;
        assetPlan2.ContactId = contact.Id;
        assetPlan2.vlocity_cmt__OrderId__c = order.Id;
        insert assetPlan2;
        
        Asset assetPlan3 = new Asset();
        assetPlan3.Status = 'Active';
        assetPlan3.Name = 'Plan 3';
        assetPlan3.AccountId = accountBusiness.Id;
        assetPlan3.ContactId = contact.Id;
        assetPlan3.vlocity_cmt__OrderId__c = order.Id;
        insert assetPlan3;
        
        Asset assetPlan4 = new Asset();
        assetPlan4.Status = 'Suspended';
        assetPlan4.Name = 'Plan 4';
        assetPlan4.AccountId = accountBusiness.Id;
        assetPlan4.ContactId = contact.Id;
        assetPlan4.vlocity_cmt__OrderId__c = order.Id;
        insert assetPlan4;

        Asset assetPlan5 = new Asset();
        assetPlan5.Status = 'Disconnected';
        assetPlan5.Name = 'Plan 5';
        assetPlan5.AccountId = accountBusiness.Id;
        assetPlan5.ContactId = contact.Id;
        assetPlan5.vlocity_cmt__OrderId__c = order.Id;
        insert assetPlan5;
        
        Asset assetPlan6 = new Asset();
        assetPlan6.Status = 'Active';
        assetPlan6.Name = 'Plan 1';
        assetPlan6.AccountId = accountBusiness.Id;
        assetPlan6.ContactId = contact.Id;
        assetPlan6.Product2Id = product2.Id;
        assetPlan6.vlocity_cmt__OrderId__c = order.Id;
        insert assetPlan6;      

        OrderItem orderItemPlan = new OrderItem();
        orderItemPlan.OrderId = order.Id;
        orderItemPlan.UnitPrice = 0.0;
        orderItemPlan.Quantity = 1;
        orderItemPlan.PricebookEntryId = price.Id;
        orderItemPlan.vlocity_cmt__Action__c = 'Add';
		orderItemPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan;

        OrderItem orderItemPlanOld = new OrderItem();
        orderItemPlanOld.OrderId = order.Id;
        orderItemPlanOld.UnitPrice = 0.0;
        orderItemPlanOld.Quantity = 1;
        orderItemPlanOld.PricebookEntryId = price.Id;
        orderItemPlanOld.vlocity_cmt__AssetId__c = assetPlan.Id;
        orderItemPlanOld.vlocity_cmt__Action__c = 'Existing';		
		orderItemPlanOld.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlanOld.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlanOld;
        
        assetPlan.vlocity_cmt__OrderProductId__c = orderItemPlan.Id;
        update assetPlan;
        
        OrderItem orderItemDispositivo = new OrderItem();
        orderItemDispositivo.OrderId = order.Id;
        orderItemDispositivo.UnitPrice = 0.0;
        orderItemDispositivo.Quantity = 1;
        orderItemDispositivo.PricebookEntryId = priceDispositivo.Id;
        orderItemDispositivo.vlocity_cmt__AssetId__c = assetDispositivo.Id;
        orderItemDispositivo.vlocity_cmt__ParentItemId__c = orderItemPlan.id;
        insert orderItemDispositivo;
        
        assetDispositivo.vlocity_cmt__OrderProductId__c = orderItemDispositivo.Id;
        update assetDispositivo;
        
        OrderItem orderItemInstallation = new OrderItem();
        orderItemInstallation.OrderId = order.Id;
        orderItemInstallation.UnitPrice = 0.0;
        orderItemInstallation.Quantity = 1;
        orderItemInstallation.PricebookEntryId = priceInstallation.Id;
        orderItemInstallation.vlocity_cmt__AssetId__c = assetInstallation.Id;
        orderItemInstallation.vlocity_cmt__ParentItemId__c = orderItemPlan.id;
        orderItemInstallation.vlocity_cmt__OneTimeCharge__c = 0.0;
        orderItemInstallation.Product2Id = product2Installation.Id;
        orderItemInstallation.vlocity_cmt__EffectiveOneTimeTotal__c = 0.0;
        insert orderItemInstallation;
        
        assetInstallation.vlocity_cmt__OrderProductId__c = orderItemInstallation.Id;
        update assetInstallation;
        
        Lead ld1 = new Lead();
        ld1.FirstName = 'Test';
        ld1.LastName = 'Test';
        ld1.Status = 'New';
        ld1.Phone = '12345678';
        ld1.Email = 'test1@test.com';
        ld1.Company = 'LabsXD';
        insert ld1;

        Lead ld2 = new Lead();
        ld2.FirstName = 'Test';
        ld2.LastName = 'Test';
        ld2.Status = 'New';
        ld2.Email = 'test2@test.com';
        ld2.DocumentNumber__c = '454545455';
        ld2.Phone = '12345678';
        ld2.Company = 'LabsXD';
        insert ld2;

        Lead ld3 = new Lead();
        ld3.FirstName = 'Test3';
        ld3.LastName = 'Test3';
        ld3.Status = 'New';
        ld3.Email = 'test3@test.com';
        ld3.DocumentNumber__c = '454545456';
        ld3.Phone = '12345679';
        ld3.Company = 'LabsXD2';
        ld3.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();       
        insert ld3;

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
        System.debug('ventaunidicada');
                
        /*Pricebook2 pricebook2 = new Pricebook2(
        Name = 'Estándar Lista de precios',
        IsActive = true,
        vlocity_cmt__IsDefault__c = false,
        vlocity_cmt__IsOpportunityDefault__c = false,
        vlocity_cmt__IsOrderDefault__c = false,
        vlocity_cmt__isQuoteDefault__c = false);
		insert pricebook2;
        System.debug('pricebook');*/

        Quote enterpriseQuote = new Quote();
        enterpriseQuote.OwnerId = Userinfo.getUserId();
        enterpriseQuote.Name = 'Enterprise Quote';
        enterpriseQuote.Pricebook2Id = pricebookId;
        enterpriseQuote.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote;
        System.debug('entreprice');
        
        Quote enterpriseQuote1 = new Quote();
        enterpriseQuote1.OwnerId = Userinfo.getUserId();
        enterpriseQuote1.Name = 'Enterprise Quote Descount';
        enterpriseQuote1.Pricebook2Id = pricebookId;
        enterpriseQuote1.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote1.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote1;
        System.debug('entreprice2');
        
        Product2 parentProductSubOrder = new Product2();
        parentProductSubOrder.Name = 'Parent Product';
        insert parentProductSubOrder;
        Product2 childProductSubOrder = new Product2();
        childProductSubOrder.Name = 'Child Product';
        insert childProductSubOrder;
        System.debug('product');
        
        PricebookEntry pricebookentry = new PricebookEntry(
        UnitPrice = 0.0,
        IsActive = true,
        Pricebook2Id = pricebookId,
        Product2Id = parentProductSubOrder.Id,
        UseStandardPrice = false,
        vlocity_cmt__RecurringPrice__c = 0.0,
        vlocity_cmt__RecurringUOM__c = 'Monthly');
        insert pricebookentry;
        System.debug('pricebookentry');
        
        Viabilidad__c viabilidadCerradaNoViable = new Viabilidad__c(
        RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId(),
        Oportunidad__c = ventaUnificadaOpp.Id,
        EstadoViabilidad__c = 'Cerrada',
        ViabilidadNoViable__c = false,
        Fecha_Final_Estado__c = System.today(),
        Crear_VIA_de_Lineas_LTE__c = false,
        Respuestadeviabilidad__c = 'No Viable',
        Control_Respuestas__c = false,
        Estado_Gestor__c = 'Por Asignar',
        Fase_Gestor__c = 'Inicial');
        insert viabilidadCerradaNoViable;
        System.debug('viabilidadCerradaNoViable');

        Viabilidad__c viabilidadCerradaViable = new Viabilidad__c(
            RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId(),
            Oportunidad__c = ventaUnificadaOpp.Id,
            EstadoViabilidad__c = 'Cerrada',
            ViabilidadNoViable__c = false,
            Fecha_Final_Estado__c = Date.newInstance(2022, 05, 30),
            Crear_VIA_de_Lineas_LTE__c = false,
            Respuestadeviabilidad__c = 'Viable',
            Control_Respuestas__c = false,
            Estado_Gestor__c = 'Por Asignar',
            Fase_Gestor__c = 'Inicial');
            insert viabilidadCerradaViable;
            System.debug('viabilidadCerradaViable');
        
        TOPP__c topp = new TOPP__c(
            Name = 'Venta-',
            TipodeOperacionporplan__c = 'Venta',
            Afecta_Ingresos__c = false,
            Activo__c = true,
            AplicaPreventa__c = true,
            ANS_Factibilidad__c = 'na',
            Facturable__c = false,
            ANS__c = 1.0,
            Producto__c = childProductSubOrder.Id);
        insert topp;
        System.debug('topp');
        
          QuoteLineItem quotelineitem = new QuoteLineItem(
        QuoteId = enterpriseQuote.Id,
        Quantity = 1.0,
        UnitPrice = 0.0,
        PricebookEntryId = pricebookentry.Id,
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
        Product2Id = childProductSubOrder.Id,
        vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
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
        
        QuoteLineItem quotelineitem1 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = pricebookentry.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = childProductSubOrder.Id,
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            Viabilidad__c = viabilidadCerradaNoViable.Id);
        insert quotelineitem1;
        
        QuoteLineItem quotelineitem2 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote1.Id,
            PricebookEntryId = pricebookentry.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = childProductSubOrder.Id,
            vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (37010.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (0.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (0.0000) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":67700.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":67700.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":67700.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":67700.00,"AdjustmentType":"None","LogSequence":0},{"LogSequence":1,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T16:54:30.000Z","AppliedBy":"Fernando valdez","DisplayText":"Discount applied by Fernando valdez","PricingAdjustmentId":"a8C78000000Gq9vEAC","Source":"Agent","AdjustmentType":"Discount","Amount":0.00,"AdjustmentValue":-100.00,"AdjustmentMethod":"Percent","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_PCT","EndValue":0.0000,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":67700.00,"LogType":"ADJUSTMENT"}],"OT_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}],"REC_MNTH_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":37010.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":37010.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":37010.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":37010.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":0.00,"REC_MNTH_STD_PRC_TOTAL":0.00,"REC_MNTH_STD_PRC_CALC":0.00,"REC_MNTH_STD_PRC":0.0000,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":-100.00,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":37010.00,"REC_MNTH_STD_CST_TOTAL":37010.00,"REC_MNTH_STD_CST":37010.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":67700.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":37010.00,"OT_STD_CST":null},"LogVersion":"3.0","PriceAsOfDateTime":"2022-06-24T16:54:31.194Z","LastPricingTime":"2022-06-24T16:54:31.194Z","ExternalPrices":{"REC_MNTH_STD_PRC":67700.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":37010.00,"OT_STD_CST":null},"SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            Viabilidad__c = viabilidadCerradaNoViable.Id);
        insert quotelineitem2;
        
        QuoteLineItem quotelineitem3 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote1.Id,
            PricebookEntryId = pricebookentry.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = childProductSubOrder.Id,
            vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (0.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (250000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (250000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00000) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"LogSequence":0,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T17:16:08.000Z","AppliedBy":"Rebeca Vazquez","DisplayText":"Override applied by Rebeca Vazquez","PricingAdjustmentId":"a8C78000000GqA0EAK","Source":"Agent","AdjustmentType":"Override","Amount":300000.00,"AdjustmentValue":0.00,"AdjustmentMethod":"Absolute","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_ABS","EndValue":300000.00,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":0.00,"LogType":"OVERRIDE"},{"LogSequence":1,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T17:16:27.000Z","AppliedBy":"Rebeca Vazquez","DisplayText":"Override applied by Rebeca Vazquez","PricingAdjustmentId":"a8C78000000GqA5EAK","Source":"Agent","AdjustmentType":"Override","Amount":250000.00,"AdjustmentValue":0.00,"AdjustmentMethod":"Absolute","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_ABS","EndValue":250000.00,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":300000.00,"LogType":"OVERRIDE"}],"OT_STD_PRC":[{"LogSequence":0,"IsEffective":true,"EndDate":null,"StartDate":null,"AdjustmentType":"None","LoyaltyCode":"PTS","CurrencyCode":"COP","CurrencyType":"Currency","Amount":0.00000,"AdjustmentValue":0.00,"AdjustmentMethod":null,"BaseValue":0.00000,"BaseAdjustment":null,"PriceListId":"a7b780000008ONeAAM","OfferId":null,"PromotionId":null,"PricingElementId":"a7e78000000GnPnAAK","PricingVariableCode":"OT_STD_PRC","DisplayText":"0.00","EndValue":0.00000,"ChargeTiming":"One-time","Frequency":null,"SubType":"Standard","StartValue":0.00000,"PricingElementGlobalKey":"5893f713-f0a7-ac5e-6d04-e9c4a149c5b1","LogType":"PRICE","PriceListEntryId":"a7a78000000Gp7sAAC"}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00000,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":250000.00,"REC_MNTH_STD_PRC_TOTAL":250000.00,"REC_MNTH_STD_PRC_CALC":250000.00,"REC_MNTH_STD_PRC":250000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00000,"REC_MNTH_MARGIN":100.00,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST":0.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"OT_STD_PRC":0.00000},"LogVersion":"3.0","PriceAsOfDateTime":"2022-06-24T17:16:28.517Z","LastPricingTime":"2022-06-24T17:16:28.517Z","SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            Viabilidad__c = viabilidadCerradaNoViable.Id);
        insert quotelineitem3;

        QuoteLineItem quotelineitem4 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote1.Id,
            PricebookEntryId = pricebookentry.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (0.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (0.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (0.00000) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"LogSequence":0,"IsEffective":true,"EndDate":null,"StartDate":null,"AdjustmentType":"None","LoyaltyCode":"PTS","CurrencyCode":"COP","CurrencyType":"Currency","Amount":0.00000,"AdjustmentValue":0.00,"AdjustmentMethod":null,"BaseValue":0.00000,"BaseAdjustment":null,"PriceListId":"a7b780000008ONeAAM","OfferId":null,"PromotionId":null,"PricingElementId":"a7e78000000GnPoAAK","PricingVariableCode":"REC_MNTH_STD_PRC","DisplayText":"0.00","EndValue":0.00000,"ChargeTiming":"Recurring","Frequency":"Monthly","SubType":"Standard","StartValue":0.00000,"PricingElementGlobalKey":"b026cb49-8e18-4602-e97f-30b2322eb49b","LogType":"PRICE","PriceListEntryId":"a7a78000000Gp8CAAS"}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":0.00,"REC_MNTH_STD_PRC_TOTAL":0.00,"REC_MNTH_STD_PRC_CALC":0.00,"REC_MNTH_STD_PRC":0.00000,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":0.00,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST":0.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":0.00000},"LogVersion":"3.0","PriceAsOfDateTime":"2022-06-24T16:54:31.194Z","LastPricingTime":"2022-06-24T16:54:31.194Z","SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = childProductSubOrder.Id,
            vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            Viabilidad__c = viabilidadCerradaViable.Id);
        insert quotelineitem4;
        
        QuoteLineItem quotelineitem5 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote1.Id,
            PricebookEntryId = pricebookentry.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = childProductSubOrder.Id,
            vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (0.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (450000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (450000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"LogSequence":0,"IsEffective":true,"EndDate":null,"StartDate":null,"AdjustmentType":"None","LoyaltyCode":"PTS","CurrencyCode":"COP","CurrencyType":"Currency","Amount":0.00000,"AdjustmentValue":0.00,"AdjustmentMethod":null,"BaseValue":0.00000,"BaseAdjustment":null,"PriceListId":"a7b780000008ONeAAM","OfferId":null,"PromotionId":null,"PricingElementId":"a7e78000000GnPoAAK","PricingVariableCode":"REC_MNTH_STD_PRC","DisplayText":"0.00","EndValue":0.00000,"ChargeTiming":"Recurring","Frequency":"Monthly","SubType":"Standard","StartValue":0.00000,"PricingElementGlobalKey":"b026cb49-8e18-4602-e97f-30b2322eb49b","LogType":"PRICE","PriceListEntryId":"a7a78000000Gp7cAAC"},{"LogSequence":1,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T15:42:36.000Z","AppliedBy":"Rebeca Vazquez","DisplayText":"Override applied by Rebeca Vazquez","PricingAdjustmentId":"a8C78000000Gq8zEAC","Source":"Agent","AdjustmentType":"Override","Amount":450000.00,"AdjustmentValue":0.00,"AdjustmentMethod":"Absolute","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_ABS","EndValue":450000.00,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":0.00000,"LogType":"OVERRIDE"},{"LogSequence":2,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T15:42:36.000Z","AppliedBy":"Rebeca Vazquez","DisplayText":"Override applied by Rebeca Vazquez","PricingAdjustmentId":"a8C78000000Gq8xEAC","Source":"Agent","AdjustmentType":"Override","Amount":400000.00,"AdjustmentValue":0.00,"AdjustmentMethod":"Absolute","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_ABS","EndValue":400000.00,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":450000.00,"LogType":"OVERRIDE"},{"LogSequence":3,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T15:42:36.000Z","AppliedBy":"Rebeca Vazquez","DisplayText":"Override applied by Rebeca Vazquez","PricingAdjustmentId":"a8C78000000Gq8yEAC","Source":"Agent","AdjustmentType":"Override","Amount":45.00,"AdjustmentValue":0.00,"AdjustmentMethod":"Absolute","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_ABS","EndValue":45.00,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":400000.00,"LogType":"OVERRIDE"},{"LogSequence":4,"IsEffective":true,"EndDate":null,"StartDate":null,"DateApplied":"2022-06-24T15:42:36.000Z","AppliedBy":"Rebeca Vazquez","DisplayText":"Override applied by Rebeca Vazquez","PricingAdjustmentId":"a8C78000000Gq90EAC","Source":"Agent","AdjustmentType":"Override","Amount":450000.00,"AdjustmentValue":0.00,"AdjustmentMethod":"Absolute","PricingVariableCode":"REC_MNTH_STD_PRC_ADJ_ABS","EndValue":450000.00,"ChargeTiming":"Adjustment","Frequency":"Monthly","SubType":"Standard","StartValue":45.00,"LogType":"OVERRIDE"}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":450000.00,"REC_MNTH_STD_PRC_TOTAL":450000.00,"REC_MNTH_STD_PRC_CALC":450000.00,"REC_MNTH_STD_PRC":450000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":100.00,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST":0.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":0.00000},"LogVersion":"3.0","PriceAsOfDateTime":"2022-06-24T16:54:31.194Z","LastPricingTime":"2022-06-24T16:54:31.194Z","SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            Viabilidad__c = viabilidadCerradaNoViable.Id);
        insert quotelineitem5;
        
        QuoteLineItem quotelineitem6 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote1.Id,
            PricebookEntryId = pricebookentry.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = childProductSubOrder.Id,
            vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (0.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (0.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (0.00000) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"LogSequence":0,"IsEffective":true,"EndDate":null,"StartDate":null,"AdjustmentType":"None","LoyaltyCode":"PTS","CurrencyCode":"COP","CurrencyType":"Currency","Amount":0.00000,"AdjustmentValue":0.00,"AdjustmentMethod":null,"BaseValue":0.00000,"BaseAdjustment":null,"PriceListId":"a7b780000008ONeAAM","OfferId":null,"PromotionId":null,"PricingElementId":"a7e78000000GnPoAAK","PricingVariableCode":"REC_MNTH_STD_PRC","DisplayText":"0.00","EndValue":0.00000,"ChargeTiming":"Recurring","Frequency":"Monthly","SubType":"Standard","StartValue":0.00000,"PricingElementGlobalKey":"b026cb49-8e18-4602-e97f-30b2322eb49b","LogType":"PRICE","PriceListEntryId":"a7a78000000GoBrAAK"}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":0.00,"REC_MNTH_STD_PRC_TOTAL":0.00,"REC_MNTH_STD_PRC_CALC":0.00,"REC_MNTH_STD_PRC":0.00000,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":0.00,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST_TOTAL":0.00,"REC_MNTH_STD_CST":0.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":0.00000},"LogVersion":"3.0","PriceAsOfDateTime":"2022-06-24T16:54:31.194Z","LastPricingTime":"2022-06-24T16:54:31.194Z","SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = childProductSubOrder.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            Viabilidad__c = viabilidadCerradaNoViable.Id);
        insert quotelineitem6;

        Order masterOrder = new Order ();
        masterOrder.Name = 'Master Order';
        masterOrder.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MasterOrder').getRecordTypeId();
        masterOrder.AccountId = accountBusiness.Id;
        masterOrder.Status = STATUS_DRAFT;
        masterOrder.EffectiveDate = Date.today();
        masterOrder.Pricebook2Id = pricebookId;
        insert masterOrder; 

        Order subOrder = new Order ();
        subOrder.Name = 'Sub Order';
        subOrder.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('SubOrder').getRecordTypeId();
        subOrder.AccountId = accountBusiness.Id;
        subOrder.Status = STATUS_DRAFT;
        subOrder.EffectiveDate = Date.today();
        subOrder.Pricebook2Id = pricebookId;
        subOrder.vlocity_cmt__ParentOrderId__c = masterOrder.Id;
        insert subOrder;

        OrderItem orderItemSubOrder1 = new OrderItem();
        orderItemSubOrder1.OrderId = subOrder.Id;
        orderItemSubOrder1.Quantity = 1;
        orderItemSubOrder1.UnitPrice = 0.0;
        orderItemSubOrder1.PricebookEntryId = price.Id;
        orderItemSubOrder1.vlocity_cmt__Action__c = 'Add';
        orderItemSubOrder1.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemSubOrder1.vlocity_cmt__ServiceAccountId__c = accountService.id;
        orderItemSubOrder1.vlocity_cmt__AssetReferenceId__c = '07a7d7e3-98fd-e0fe-35bc-3cdfe27203e8';
        insert orderItemSubOrder1;

        OrderItem orderItemSubOrder2 = new OrderItem();
        orderItemSubOrder2.OrderId = subOrder.Id;
        orderItemSubOrder2.Quantity = 1;
        orderItemSubOrder2.UnitPrice = 0.0;
        orderItemSubOrder2.PricebookEntryId = price.Id;
        orderItemSubOrder2.vlocity_cmt__Action__c = 'Add';
        orderItemSubOrder2.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemSubOrder2.vlocity_cmt__ServiceAccountId__c = accountService.id;
        orderItemSubOrder2.vlocity_cmt__AssetReferenceId__c = '96a6d6e2-98fd-e0fe-35bc-3cdfe27203e8';
        orderItemSubOrder2.vlocity_cmt__ReliesOnItemId__c = '07a7d7e3-98fd-e0fe-35bc-3cdfe27203e8';
        insert orderItemSubOrder2;

        OrderItem orderItemSubOrder3 = new OrderItem();
        orderItemSubOrder3.OrderId = subOrder.Id;
        orderItemSubOrder3.Quantity = 1;
        orderItemSubOrder3.UnitPrice = 0.0;
        orderItemSubOrder3.PricebookEntryId = price.Id;
        orderItemSubOrder3.vlocity_cmt__Action__c = 'Add';
        orderItemSubOrder3.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemSubOrder3.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemSubOrder3;

        vlocity_cmt__ProductRelationship__c productoRelacionado = new vlocity_cmt__ProductRelationship__c();
        productoRelacionado.vlocity_cmt__Product2Id__c = parentProductSubOrder.Id;
        productoRelacionado.vlocity_cmt__RelatedProductId__c = childProductSubOrder.Id;
        productoRelacionado.vlocity_cmt__RelationshipType__c = 'ReliesOn';
        productoRelacionado.vlocity_cmt__MaxQuantity__c = 1 ;
        productoRelacionado.vlocity_cmt__MinQuantity__c = 1 ;
        insert productoRelacionado;      
        
        Contract contract01 = new Contract();
        contract01.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();  
        contract01.AccountID = accountBilling.Id;
        contract01.Status = 'Borrador';
        insert contract01;
        
        Contract contract02 = new Contract();
        contract02.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();  
        contract02.AccountID = accountBilling.Id;
        contract02.Status = 'Borrador';
        insert contract02;
        
        Contract contract03 = new Contract();
        contract03.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();  
        contract03.AccountID = accountBilling.Id;
        contract03.Status = 'Borrador';
        insert contract03;
        
        vlocity_cmt__ContractLineItem__c contractlineitem = new vlocity_cmt__ContractLineItem__c(
            Name = 'Licencia Cisco 800',
            vlocity_cmt__ContractId__c = contract01.Id,
            vlocity_cmt__AssetReferenceId__c = 'd9175dd7-9771-808b-bc60-c549fd1ce138',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Unidad_de_equipo":"Licencia","ATT_Tipo_de_equipo":"PARTES_CISCO","Modelo de Equipo":"SL-880-AIS=","ATT_EsPropietario":false,"ATT_Comodato":true,"ATT_TiempoContratoDias":10,"ATT_TiempoContratoMeses":2,"ATT_Tipo_de_contrato":"Nuevo UM Propia","ATT_RequiereViabilidad":true,"ATT_Requiere_visita_Instalacion":true}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            vlocity_cmt__LineNumber__c = '0003',
            vlocity_cmt__LineStatus__c = 'Active',
            vlocity_cmt__OneTimeCalculatedPrice__c = 0.0,
            vlocity_cmt__OneTimeCharge__c = 0.0,
            vlocity_cmt__OneTimeManualDiscount__c = 0.0,
            vlocity_cmt__OneTimeTotal__c = 0.0,
            vlocity_cmt__PricebookEntryId__c = pricebookentry.Id,
            vlocity_cmt__Product2Id__c = product2Dispositivo.Id,
            vlocity_cmt__Quantity__c = 1.0,
            vlocity_cmt__RecurringCalculatedPrice__c = 1000.0,
            vlocity_cmt__RecurringCharge__c = 1000.0,
            vlocity_cmt__RecurringManualDiscount__c = 0.0,
            vlocity_cmt__RecurringTotal__c = 1000.0,
            vlocity_cmt__RecurringUOM__c = 'Monthly',
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__Status__c = 'Active',
            vlocity_cmt__UnitPrice__c = 0.0,
            Monto_ejecutado__c = 2333.3333333333335);
        insert contractlineitem;
        
        vlocity_cmt__ContractLineItem__c contractlineitem1 = new vlocity_cmt__ContractLineItem__c(
            Name = 'Licencia Cisco 800',
            vlocity_cmt__ContractId__c = contract02.Id,
            vlocity_cmt__AssetReferenceId__c = 'd9175dd7-9771-808b-bc60-c549fd1ce138',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Unidad_de_equipo":"Licencia","ATT_Tipo_de_equipo":"PARTES_CISCO","Modelo de Equipo":"SL-880-AIS=","ATT_EsPropietario":false,"ATT_Comodato":true,"ATT_TiempoContratoDias":10,"ATT_TiempoContratoMeses":2,"ATT_Tipo_de_contrato":"Nuevo UM Propia","ATT_RequiereViabilidad":true,"ATT_Requiere_visita_Instalacion":true}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            vlocity_cmt__LineNumber__c = '0003',
            vlocity_cmt__LineStatus__c = 'Active',
            vlocity_cmt__OneTimeCalculatedPrice__c = 0.0,
            vlocity_cmt__OneTimeCharge__c = 0.0,
            vlocity_cmt__OneTimeManualDiscount__c = 0.0,
            vlocity_cmt__OneTimeTotal__c = 0.0,
            vlocity_cmt__PricebookEntryId__c = pricebookentry.Id,
            vlocity_cmt__Product2Id__c = product2Dispositivo.Id,
            vlocity_cmt__Quantity__c = 1.0,
            vlocity_cmt__RecurringCalculatedPrice__c = 1000.0,
            vlocity_cmt__RecurringCharge__c = 1000.0,
            vlocity_cmt__RecurringManualDiscount__c = 0.0,
            vlocity_cmt__RecurringTotal__c = 1000.0,
            vlocity_cmt__RecurringUOM__c = 'Monthly',
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__Status__c = 'Active',
            vlocity_cmt__UnitPrice__c = 0.0,
            Monto_ejecutado__c = 2333.3333333333335);
        insert contractlineitem1;
    }  
    
    

    /*
    public static void createAccountAndContacts(Integer numAccts, Integer numContactsPerAcct) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];           
            // For each account just inserted, add contacts
            for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     AccountId=acct.Id));
            }
        }
        // Insert all contacts for all accounts
        insert cons;
    }    */
}