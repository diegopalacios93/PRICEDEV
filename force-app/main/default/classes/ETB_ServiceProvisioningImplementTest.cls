@isTest
public class ETB_ServiceProvisioningImplementTest {
    private static final String PROVISIONED_STATUS_ORDERITEM = 'Aprovisionado';
    private static final String PROVISIONED_STATUS_ORDER = 'Provisioned';

    @isTest
    private static void updateAccountsBilling() {

        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing Test';
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
        accountBilling.Name = 'Account Billing Test';
        accountBilling.Type = 'Billing';
        accountBilling.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
        accountBilling.ParentId = accountBusiness.id;
        accountBilling.Phone = '12345678';
        accountBilling.BillingAccountNumber__c = '000000';
        insert accountBilling;
        
        String jsonq='{'+
          '"Id": "'+accountBilling.Id+'",'+
          '"numberBillingAccount": "000001",'+
          '"ciclodeFacturacion": "Ciclo 5"'+
        '}';
        Map<String, Object> item = (Map<String, Object>) JSON.deserializeUntyped(jsonq);
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        List<Object> lista = new List<Object>();
        lista.add(item);
        input.put('itemsToProcessSubsetList',lista);

        Test.startTest();
        ETB_ServiceProvisioningImplement etbServiceProv = new ETB_ServiceProvisioningImplement();
        etbServiceProv.invokeMethod('updateBillingAccounts',input,output,options);     
        Test.stopTest();
        
        Account acc = [Select BillingAccountNumber__c FROM Account WHERE Id=: accountBilling.Id ];
        
        System.assertEquals('000001',acc.BillingAccountNumber__c);    
    }
    
    @isTest
    private static void updateAccountsBillingInputNull() {
        
        String jsonq='{'+
          '"Id": "001780000048n8NAAQ",'+
          '"numberBillingAccount": "000001",'+
          '"ciclodeFacturacion": "Ciclo 5"'+
        '}';
        Map<String, Object> item = (Map<String, Object>) JSON.deserializeUntyped(jsonq);
        Map<String, Object> input = null;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        ETB_ServiceProvisioningImplement etbServiceProv = new ETB_ServiceProvisioningImplement();
        etbServiceProv.invokeMethod('updateBillingAccounts',input,output,options);     
        Test.stopTest();
        
    }

        @isTest
    private static void orderManagementParcialTest() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

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
        
        Product2 product2 = new Product2();
        product2.Family = 'Internet HFC';
        product2.ProductCode = 'OM_Internet_HFC';
        product2.Name = 'Internet 1';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;

        Order orderMaestra = new Order ();
        orderMaestra.Name = 'Venta Internet Maestra';
        orderMaestra.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MasterOrder').getRecordTypeId();
        orderMaestra.AccountId = accountBusiness.Id;
        orderMaestra.Status = 'Draft';
        orderMaestra.EffectiveDate = Date.today();
        orderMaestra.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        orderMaestra.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        orderMaestra.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        orderMaestra.OwnerId = Userinfo.getUserId();
        orderMaestra.vlocity_cmt__OpportunityId__c = ventaUnificadaOpp.Id;
        insert orderMaestra;
        
        OrderItem orderItemMaestraPlan = new OrderItem();
        orderItemMaestraPlan.OrderId = orderMaestra.Id;
        orderItemMaestraPlan.UnitPrice = 0.0;
        orderItemMaestraPlan.Quantity = 1;
        orderItemMaestraPlan.PricebookEntryId = price.Id;
        orderItemMaestraPlan.vlocity_cmt__Action__c = 'Add';
		orderItemMaestraPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemMaestraPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemMaestraPlan;
        
        Order order = new Order ();
        order.Name = 'Venta Internet';
        order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('SubOrder').getRecordTypeId();
        order.AccountId = accountBusiness.Id;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        order.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        order.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        order.vlocity_cmt__ParentOrderId__c = orderMaestra.Id;
        order.OwnerId = Userinfo.getUserId();
        order.vlocity_cmt__OpportunityId__c = ventaUnificadaOpp.Id;
        insert order;     

        OrderItem orderItemPlan = new OrderItem();
        orderItemPlan.OrderId = order.Id;
        orderItemPlan.UnitPrice = 10.0;
        orderItemPlan.Quantity = 1;
        orderItemPlan.PricebookEntryId = price.Id;
        orderItemPlan.vlocity_cmt__Action__c = 'Add';
		orderItemPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan;

        OrderItem orderItemPlan2 = new OrderItem();
        orderItemPlan2.OrderId = order.Id;
        orderItemPlan2.UnitPrice = 190.0;
        orderItemPlan2.Quantity = 1;
        orderItemPlan2.PricebookEntryId = price.Id;
        orderItemPlan2.vlocity_cmt__Action__c = 'Add';
		orderItemPlan2.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan2.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan2;

        OrderItem orderItemPlan3 = new OrderItem();
        orderItemPlan3.OrderId = order.Id;
        orderItemPlan3.UnitPrice = 1000.0;
        orderItemPlan3.Quantity = 1;
        orderItemPlan3.PricebookEntryId = price.Id;
        orderItemPlan3.vlocity_cmt__Action__c = 'Add';
		orderItemPlan3.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan3.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan3;
        
        //Codigo para avanzar en las pruebas----------------------------
        Asset assetPlan = new Asset();
        assetPlan.Status = 'Active';
        assetPlan.Name = 'Plan 1';
        assetPlan.AccountId = accountBusiness.Id;
        // assetPlan.ContactId = contact.Id;
        assetPlan.Product2Id = product2.Id;
		assetPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        assetPlan.vlocity_cmt__OrderId__c = order.Id;
        assetPlan.vlocity_cmt__OrderProductId__c = orderItemPlan.Id;
        insert assetPlan;      

    String jsonEntrada = '{'+
	'"accounts": {'+
		   '"idBussines": "001780000068LREAA2",'+
		   '"billingAccounts": [{'+
				'"Id": "'+accountBilling.Id+'",'+
				'"numberBillingAccount": "Revchain-000001",'+
				'"ciclodeFacturacion": "Ciclo 5"'+
			'}'+
		']'+
	'},'+
	'"items": [{'+
			'"idItem": "'+orderItemPlan.Id+'",'+
			'"parentId": null,'+
			'"engineer": "Sandra Milena",'+
			'"groupAssigment": "Conectividad Avanzada",'+
			'"statusProvisioning": "En Aprovisionamiento",'+
			'"comments": "Aprovisionado exitoso",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": "2022-06-01",'+
            '"idService":"Ser-00333",'+
            '"agendamiento": null,'+
			'"billingStartDate": null,'+
			'"listaConfiguraciones": {'+
				'"quantity": "1",'+
				'"parametros": [{'+
                    '"atributo": "ATT_Ancho de Banda",'+
                    '"valor": "15MB"'+
                  '}'+
				']'+
			'}'+
		'},'+
		'{'+
			'"idItem": "'+orderItemPlan2.Id+'",'+
			'"parentId": "8023K000001uDimQAE",'+
			'"engineer": "ELIANA MARCELA RICO VARGAS",'+
			'"groupAssigment": "Equipo Avanzado",'+
			'"statusProvisioning": "Aprovisionado",'+
			'"comments": "Se acuerda agendamiento",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": null,'+
            '"idService":null,'+
            '"agendamiento":{'+
                '"agendaDate": "2022-06-03",'+
                '"agendaStrip": "Tarde",'+
                '"agendastatus": "Agendado"'+
            '},'+
			'"billingStartDate": null,'+
			'"listaConfiguraciones": null'+
		'},'+
		'{'+
			'"idItem": "'+orderItemPlan3.Id+'",'+
			'"parentId": null,'+
			'"engineer": "JORGE LUIS LOZANO LARIOS",'+
			'"groupAssigment": "Conectividad Avanzada",'+
			'"statusProvisioning": "Aprovisionado",'+
			'"comments": "Se inicia facturacion",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": "2022-05-31",'+
            '"idService":"Ser-00322",'+
            '"agendamiento":null,'+
			'"billingStartDate": "2022-06-01",'+
			'"listaConfiguraciones": null'+
		'}'+
	']'+
'}';
        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(jsonEntrada);
        List<Object> listaItems = (List<Object>) requestBody.get('items');
        input.put('itemsToProcessSubsetList',listaItems);
        
        Test.startTest();
        ETB_ServiceProvisioningImplement etbServiceProv = new ETB_ServiceProvisioningImplement();
        etbServiceProv.invokeMethod('orderManagement',input,output,options);     
        Test.stopTest();

    }
    
    @isTest
    private static void orderManagementTest() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

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
        
        Product2 product2 = new Product2();
        product2.Family = 'Internet HFC';
        product2.ProductCode = 'OM_Internet_HFC';
        product2.Name = 'Internet 1';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;

        Order orderMaestra = new Order ();
        orderMaestra.Name = 'Venta Internet Maestra';
        orderMaestra.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MasterOrder').getRecordTypeId();
        orderMaestra.AccountId = accountBusiness.Id;
        orderMaestra.Status = 'Draft';
        orderMaestra.EffectiveDate = Date.today();
        orderMaestra.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        orderMaestra.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        orderMaestra.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        orderMaestra.OwnerId = Userinfo.getUserId();
        orderMaestra.vlocity_cmt__OpportunityId__c = ventaUnificadaOpp.Id;
        insert orderMaestra;
        
        OrderItem orderItemMaestraPlan = new OrderItem();
        orderItemMaestraPlan.OrderId = orderMaestra.Id;
        orderItemMaestraPlan.UnitPrice = 0.0;
        orderItemMaestraPlan.Quantity = 1;
        orderItemMaestraPlan.PricebookEntryId = price.Id;
        orderItemMaestraPlan.vlocity_cmt__Action__c = 'Add';
		orderItemMaestraPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemMaestraPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemMaestraPlan;
        
        Order order = new Order ();
        order.Name = 'Venta Internet';
        order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('SubOrder').getRecordTypeId();
        order.AccountId = accountBusiness.Id;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        order.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        order.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        order.vlocity_cmt__ParentOrderId__c = orderMaestra.Id;
        order.OwnerId = Userinfo.getUserId();
        order.vlocity_cmt__OpportunityId__c = ventaUnificadaOpp.Id;
        insert order;     

        OrderItem orderItemPlan = new OrderItem();
        orderItemPlan.OrderId = order.Id;
        orderItemPlan.UnitPrice = 10.0;
        orderItemPlan.Quantity = 1;
        orderItemPlan.PricebookEntryId = price.Id;
        orderItemPlan.vlocity_cmt__Action__c = 'Add';
		orderItemPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan;

        OrderItem orderItemPlan2 = new OrderItem();
        orderItemPlan2.OrderId = order.Id;
        orderItemPlan2.UnitPrice = 190.0;
        orderItemPlan2.Quantity = 1;
        orderItemPlan2.PricebookEntryId = price.Id;
        orderItemPlan2.vlocity_cmt__Action__c = 'Add';
		orderItemPlan2.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan2.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan2;

        OrderItem orderItemPlan3 = new OrderItem();
        orderItemPlan3.OrderId = order.Id;
        orderItemPlan3.UnitPrice = 1000.0;
        orderItemPlan3.Quantity = 1;
        orderItemPlan3.PricebookEntryId = price.Id;
        orderItemPlan3.vlocity_cmt__Action__c = 'Add';
		orderItemPlan3.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan3.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan3;
        
        //Codigo para avanzar en las pruebas----------------------------
        Asset assetPlan = new Asset();
        assetPlan.Status = 'Active';
        assetPlan.Name = 'Plan 1';
        assetPlan.AccountId = accountBusiness.Id;
        // assetPlan.ContactId = contact.Id;
        assetPlan.Product2Id = product2.Id;
		assetPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        assetPlan.vlocity_cmt__OrderId__c = order.Id;
        assetPlan.vlocity_cmt__OrderProductId__c = orderItemPlan.Id;
        insert assetPlan;      

    String jsonEntrada = '{'+
	'"accounts": {'+
		   '"idBussines": "001780000068LREAA2",'+
		   '"billingAccounts": [{'+
				'"Id": "'+accountBilling.Id+'",'+
				'"numberBillingAccount": "Revchain-000001",'+
				'"ciclodeFacturacion": "Ciclo 5"'+
			'}'+
		']'+
	'},'+
	'"items": [{'+
			'"idItem": "'+orderItemPlan.Id+'",'+
			'"parentId": null,'+
			'"engineer": "Sandra Milena",'+
			'"groupAssigment": "Conectividad Avanzada",'+
			'"statusProvisioning": "Aprovisionado",'+
			'"comments": "Aprovisionado exitoso",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": "2022-06-01",'+
            '"idService":"Ser-00333",'+
            '"agendamiento": null,'+
			'"billingStartDate": null,'+
			'"listaConfiguraciones": {'+
				'"quantity": "1",'+
				'"parametros": [{'+
                    '"atributo": "ATT_Ancho de Banda",'+
                    '"valor": "15MB"'+
                  '}'+
				']'+
			'}'+
		'},'+
		'{'+
			'"idItem": "'+orderItemPlan2.Id+'",'+
			'"parentId": "8023K000001uDimQAE",'+
			'"engineer": "ELIANA MARCELA RICO VARGAS",'+
			'"groupAssigment": "Equipo Avanzado",'+
			'"statusProvisioning": "Aprovisionado",'+
			'"comments": "Se acuerda agendamiento",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": null,'+
            '"idService":null,'+
            '"agendamiento":{'+
                '"agendaDate": "2022-06-03",'+
                '"agendaStrip": "Tarde",'+
                '"agendastatus": "Agendado"'+
            '},'+
			'"billingStartDate": null,'+
			'"listaConfiguraciones": null'+
		'},'+
		'{'+
			'"idItem": "'+orderItemPlan3.Id+'",'+
			'"parentId": null,'+
			'"engineer": "JORGE LUIS LOZANO LARIOS",'+
			'"groupAssigment": "Conectividad Avanzada",'+
			'"statusProvisioning": "Aprovisionado",'+
			'"comments": "Se inicia facturacion",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": "2022-05-31",'+
            '"idService":"Ser-00322",'+
            '"agendamiento":null,'+
			'"billingStartDate": "2022-06-01",'+
			'"listaConfiguraciones": null'+
		'}'+
	']'+
'}';
        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(jsonEntrada);
        List<Object> listaItems = (List<Object>) requestBody.get('items');
        input.put('itemsToProcessSubsetList',listaItems);
        
        Test.startTest();
        ETB_ServiceProvisioningImplement etbServiceProv = new ETB_ServiceProvisioningImplement();
        etbServiceProv.invokeMethod('orderManagement',input,output,options);     
        Test.stopTest();
        
        Order orderMaster = [SELECT Id, Status FROM Order WHERE Id = : orderMaestra.Id];
        //System.assertEquals(PROVISIONED_STATUS_ORDER,orderMaster.Status);   
    }
    
    @isTest
    private static void sendMail() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

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
        
        Product2 product2 = new Product2();
        product2.Family = 'Internet HFC';
        product2.ProductCode = 'OM_Internet_HFC';
        product2.Name = 'Internet 1';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;

        Order orderMaestra = new Order ();
        orderMaestra.Name = 'Venta Internet Maestra';
        orderMaestra.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MasterOrder').getRecordTypeId();
        orderMaestra.AccountId = accountBusiness.Id;
        orderMaestra.Status = 'Draft';
        orderMaestra.EffectiveDate = Date.today();
        orderMaestra.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        orderMaestra.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        orderMaestra.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        orderMaestra.OwnerId = Userinfo.getUserId();
        orderMaestra.vlocity_cmt__OpportunityId__c = ventaUnificadaOpp.Id;
        insert orderMaestra;
        
        OrderItem orderItemMaestraPlan = new OrderItem();
        orderItemMaestraPlan.OrderId = orderMaestra.Id;
        orderItemMaestraPlan.UnitPrice = 0.0;
        orderItemMaestraPlan.Quantity = 1;
        orderItemMaestraPlan.PricebookEntryId = price.Id;
        orderItemMaestraPlan.vlocity_cmt__Action__c = 'Add';
		orderItemMaestraPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemMaestraPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemMaestraPlan;
        
        Order order = new Order ();
        order.Name = 'Venta Internet';
        order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('SubOrder').getRecordTypeId();
        order.AccountId = accountBusiness.Id;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = pricebookId;
        //order.OrderReason__c = 'Travel';
        order.vlocity_cmt__DefaultServiceAccountId__c = accountService.id;
        order.vlocity_cmt__DefaultBillingAccountId__c = accountBilling.id;
        order.vlocity_cmt__ParentOrderId__c = orderMaestra.Id;
        order.OwnerId = Userinfo.getUserId();
        order.vlocity_cmt__OpportunityId__c = ventaUnificadaOpp.Id;
        insert order;     

        OrderItem orderItemPlan = new OrderItem();
        orderItemPlan.OrderId = order.Id;
        orderItemPlan.UnitPrice = 10.0;
        orderItemPlan.Quantity = 1;
        orderItemPlan.PricebookEntryId = price.Id;
        orderItemPlan.vlocity_cmt__Action__c = 'Add';
		orderItemPlan.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        orderItemPlan.vlocity_cmt__ServiceAccountId__c = accountService.id;
        insert orderItemPlan;
        
        String jsonEntrada = '{"failed":[],"successfully":[{"idItem":"'+orderItemPlan.Id+'"}]}';
        Map<String, Object> listaMap = (Map<String, Object>) JSON.deserializeUntyped(jsonEntrada);

        input.put('itemsProcessed',listaMap);
        
        Test.startTest();
        ETB_ServiceProvisioningImplement etbServiceProv = new ETB_ServiceProvisioningImplement();
        etbServiceProv.invokeMethod('sendEmail',input,output,options);     
        Test.stopTest();

    }
    
}