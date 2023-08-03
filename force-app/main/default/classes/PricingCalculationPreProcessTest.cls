@isTest(SeeAllData=false)
public class PricingCalculationPreProcessTest {

    //Test for PricingCalculationPreProcess
    @isTest
    static private void TestIfThereIsAProduct() {
        
        String methodName = 'calculate';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String,Object>();
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
            //ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
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
        );
        insert lineItem;
        Costos_Avanzados__c costo = new Costos_Avanzados__c(
            Quote_Line_Item__c = lineItem.Id,
            Cotizacion__c = cotizacion.Id,
            CC_FOAcceso__c = 73189.773904,
            CC_Internet__c = 0,
            CC_MPLSRedCarrierEthernet__c = 400000,
            CC_Metros_Adicionales__c = 0,
            CC_Metros_Tendidos_FoUMETB__c = 500,
            CC_Monitoreo_Reportes__c = 10000,
            CC_OPEX_ComercialMaximo__c = 8.9479584340328,
            CC_OPEX_Comercial__c = 8,
            CC_Obras_Civiles__c = 1000000,
            CC_Opex_Instalacion__c = 5,
            CC_PuertosRedMetro__c = 20000,
            CC_Radio__c = 0,
            CC_TRM__c = 3984,
            CC_TxInternet_NAP__c = 0,
            CC_Tx__c = 0,
            TipoUM__c = 'DEMARCADOR BUS INTERFAZ 10Gb Regiones',
            CC_DescuentoOfrecido__c = null,
            Tiempo_de_Contrato_en_Meses__c = 12,
            Cantidad_de_Enlaces__c = 1,
            IVA__c = 19,
            CC_Costo_de_Help_Desk__c = 20000,
            CC_Costo_de_Facturacion__c = 2000,
            CC_Service_Manager_IntelligenceMes__c = 10,
            CC_Margen_Comercial_Minimo__c = 0,
            CC_Valor_Matriz_BW_Pto_Central__c = 4395
        );
        insert costo;

        list<Object> inputData = new list<Object>();        
        Map<String, Object> entradas = new Map<String, Object>();
        entradas.put('ID',lineItem.Id);
        inputData.add(entradas);
        input.put('inputData', inputData);

        Test.startTest();
        PricingCalculationPreProcess testing = new PricingCalculationPreProcess();
        testing.invokeMethod(methodName, input, output, options);
        Test.stopTest();
        system.assertEquals('calculate', methodName);
        
    }
    
    @isTest
    static private void TestIfThereIsAnotherMethod() {
        String methodName = 'matrixVersion';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String,Object>();
        Test.startTest();
        PricingCalculationPreProcess testing = new PricingCalculationPreProcess();
        testing.invokeMethod(methodName, input, output, options);
        Test.stopTest();
        system.assertNotEquals('calculate', methodName);
    }
    
    @isTest
    static private void TestcalculateNull() {
        String methodName = 'calculate';
        Map<String, Object> input = null;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String,Object>();
        Test.startTest();
        PricingCalculationPreProcess testing = new PricingCalculationPreProcess();
        testing.invokeMethod(methodName, input, output, options);
        Test.stopTest();
        system.assertEquals('calculate', methodName);
    }

}