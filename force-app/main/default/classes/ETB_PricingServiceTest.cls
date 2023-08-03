@isTest(SeeAllData=false)
public class ETB_PricingServiceTest {
    
    //Test for ETB_PricingService && UpdatePricing
    @testSetup 
    static void makeData() {
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

        ETB_CotizacionAvanzada__c cotAvanzada = new ETB_CotizacionAvanzada__c(TipoUM__c = 'COBRE ETB G.SHDSL',
                                                                            Tipo_de_Servicio__c = 'CAIP',
                                                                            Categoria_de_Enlace__c = 'Pto. Remoto',
                                                                            TCM__c = 12,
                                                                            Tipo_de_Contrato__c = 'Nuevo',
                                                                            Gestion_Unificada__c = 'Servicio Basico',
                                                                            Segmento__c = 'Empresas',
            																AnchoBandaTerceros__c = '64Kbps',
                                                                            Metros_Tendidos_Fo_UM_ETB__c = 2255,
                                                                            Obras_Civiles__c = 1293871823,
                                                                            CiudadOrigen__c = 'Bogotá',
                                                                            CiudadDestino__c = 'Bogotá',
                                                                            Cotizacion__c = cotizacion.Id,
                                                                            Quote_Line_Item__c = lineItem.Id,
                                                                            RecordTypeId = Schema.SObjectType.ETB_CotizacionAvanzada__c.getRecordTypeInfosByName().get('Conectividad').getRecordTypeId(),
                                                                            Calculado__c = False
                                                                            );
        insert cotAvanzada;
    }
    
    @isTest
    static private void TestInvokeBatch() {
        
        List<Quote> quote = [SELECT Id FROM Quote];
        pageReference pager = page.setPriceForConectividadProducts;
        Test.setCurrentPage(pager);
        pager.getParameters().put('Id',quote[0].id);
        ApexPages.StandardController stc = new ApexPages.StandardController(quote[0]);
		
        Test.startTest();
        ETB_PricingService testing = new ETB_PricingService(stc);
        pageReference paginaDelBatch = testing.invokeBatch();
        Test.stopTest();
        system.assertNotEquals(null, paginaDelBatch, 'No se recibe un PageReference de retorno');
    }
}