/****************************************************************************************************
    Autor:          edwin.bohorquez@globant.com
    Project:        Vlocity - ETB
    Description:    Clase de prueba para metodos encolables ETB_CambioPorcentajeAsignacionQbl

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         9-11-2022         Adrian Bohorquez            Creación de Clase
*****************************************************************************************************/
@isTest
public class ETB_CambioIndicadoresCostoCotizacion_tst {
    @TestVisible
    private static final String STATUS_DRAFT  = 'Draft';
    
 	private static String namespace = 'vlocity_cmt__';
    public static vlocity_cmt__CalculationMatrixVersion__c version;
    public static vlocity_cmt__CalculationMatrix__c parent;
    public static List<vlocity_cmt__CalculationMatrixRow__c> lineItems;
    private static Id orderId;
    private static boolean flag;
   
    @TestSetup   
    static void makeData(){	
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
    private static void cambioPorcentajeAsignacionTest1(){
        //caso:actualiza valores
       	Map<String, Object> input = new Map<String, Object>();
       	Map<String, Object> output = new Map<String, Object>();
       	Map<String, Object> options = new Map<String,Object>();
       
       	String jsinInputData = '';
       	String glPricing = '{"Comisiones_por_venta_y_facturacion":{"SoloLectura":false,"Valor":1.0},"Impuestos_regionales_adicionales":{"SoloLectura":false,"Valor":0},"Polizas_y_publicacion":{"SoloLectura":false,"Valor":1.0},"Publicidad":{"SoloLectura":false,"Valor":1.0},"Mintic":{"SoloLectura":false,"Valor":1.0},"ICA_avisos_y_tableros":{"SoloLectura":false,"Valor":1.0},"Contribucion_CRC":{"SoloLectura":false,"Valor":1.0},"4x1000":{"SoloLectura":false,"Valor":1.0},"Provision_de_cartera":{"SoloLectura":false,"Valor":1.0},"ValorTIO":{"SoloLectura":false,"Valor":1.5309},"Capacidad_GB":{"SoloLectura":false,"Valor":40000.0000},"LUN":{"SoloLectura":false,"Valor":400000.0000},"Colocacion":{"SoloLectura":false,"Valor":80000.0000},"CostoInstalacion":{"SoloLectura":false,"Valor":200000.00},"Instalacion":{"SoloLectura":false,"Valor":18371.3108},"CostoAlmacenamiento":{"SoloLectura":true,"Valor":538371.3108},"TarifaPisoMensual":{"SoloLectura":true,"Valor":650210.0000},"TarifaListaMensualSinIVA":{"SoloLectura":true,"Valor":812800.0000},"TarifaListaMensualConIVA":{"SoloLectura":true,"Valor":967232.000000}}'; 
       	list<Object> currentQuote = New list<Object>(); 
       	List<QuoteLineItem> QLIList = [SELECT Id,QuoteId,vlocity_cmt__LineNumber__c,vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem limit 1]; 
      
       	QLIList[0].ETB_GL_JsonPricing__c = glPricing; 
       	update  QLIList;
        
        Map<String,Object> partidaPresupuesto = new Map<String,Object>();
       	partidaPresupuesto.put('ProductCode', 'PR_INTERNET_DEDICADO');  
       	partidaPresupuesto.put('Id', QLIList[0].Id);  
       	partidaPresupuesto.put('vlocity_cmt__AttributeSelectedValues__c', QLIList[0].vlocity_cmt__AttributeSelectedValues__c);  
       	partidaPresupuesto.put('ETB_GL_JsonPricingReferencia__c', QLIList[0].ETB_GL_JsonPricing__c);
        List<Object> listItems = new List<Object>();
        listItems.add(partidaPresupuesto);
        
		Map<String,Object> mapValoresEntrada = new Map<String,Object>();
       	mapValoresEntrada.put('quoteId', QLIList[0].QuoteId);
        mapValoresEntrada.put('porcentajeAsignacion', 100);
        mapValoresEntrada.put('impuestosRegionalesAdicionales', 0);
        mapValoresEntrada.put('listaPartidasPresupuesto', listItems); 
        
       	Test.startTest();     
       	System.enqueueJob(new ETB_CambioIndicadoresCostoCotizacionQbl(mapValoresEntrada));  
       	Test.stopTest();
    } 
}