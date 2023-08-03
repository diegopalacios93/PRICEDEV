/**
* @Author:      Gustavo Torres <gtorres@labsxd.com>
* @Company:     LabsXD
* @Date:
* @Reviewer:    
* @Review Date: 
* @Description:
* -------------------------------------------------------------
*/



@isTest
public class etb_UtilitiesTest {

        @TestSetup

        static void makeData(){
                CreateDataTest.createData();
        }

    private static String INPUT_OBJECT_NAME                          = 'objectName';
    private static String INPUT_FIELD_NAME                   		 = 'fieldName';
    private static String INPUT_FIELD_VALUE_ID       				 = 'fieldValueID';
    private static String INPUT_PRODUCT2_ID           				 = 'product2ID';
    private static String INPUT_PRODUCTS            				 = 'products';
    private static String INPUT_ARGUMENTS           	             = 'arguments';
    private static String INPUT_JSON						 	     = 'HistoryList';


    @isTest
    private static void testSliceJSONListReturnTrueMethod() {

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
			
        	List<String> newListTest = new List<String>();
        	for(Integer i=0; i<12; i++){
                newListTest.add('Numero: '+i);
            }
        	input.put(INPUT_JSON,newListTest);
        			
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_SLICE_JSON_LIST, input, output, options);
            Test.stopTest();

        	List < Object > history = (List < Object >) output.get(INPUT_JSON);
         	Integer listSize = history.size();
            System.assertEquals(10,listSize);
            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testSliceJSONListReturnFalseMethod() {

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
			
        	List<String> newListTest = new List<String>();
        	for(Integer i=0; i<5; i++){
                newListTest.add('Numero: '+i);
            }
        	input.put(INPUT_JSON,newListTest);
        			
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_SLICE_JSON_LIST, input, output, options);
            Test.stopTest();

        	//List < Object > history = (List < Object >) output.get(INPUT_JSON);
         	//Integer listSize = history.size();
        	//System.debug('listSize'+listSize);
            //System.assertEquals(5,listSize);
            System.assertEquals(false, result);

    }
    
    @isTest
    private static void testGetFieldLabelMethod() {

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

        	List<Object> argumentos = new List<Object>();
            //newListTest.add('User');
            //newListTest.add('CargoAsesor__c');
            //newListTest.add('Contratista');
            argumentos.add('Order');
            argumentos.add('Status');
            argumentos.add('Draft');

        	input.put(INPUT_ARGUMENTS,argumentos);
        
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_FIELD_LABEL, input, output, options);
            Test.stopTest();

            //System.assertEquals('Contratista',output.get('fieldLabel'));
            System.assertEquals(true, result);

    }

    @isTest
    private static void testFail1() {

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Test.startTest();
            Object result = new etb_Utilities().invokeMethod('unknown method', input, output, options);
            Test.stopTest();

            System.assertEquals(false, result);
    }

    @isTest
    private static void testFail2() {

       
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            input.put(INPUT_OBJECT_NAME, 'UserUnknown');
            input.put(INPUT_FIELD_NAME, 'Countrycode');
            input.put(INPUT_FIELD_VALUE_ID, 'Ar');
                
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_FIELD_LABEL, null, output, options);
            Test.stopTest();
            //System.assertEquals(false, result);
       
    }

    @isTest
    private static void testFilterProductMethod() {

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            List < Map < String, Object >> productos = new List < Map < String, Object >> ();
            Map < String, Object > producto1 = new Map < String, Object > ();
            Map < String, Object > producto2 = new Map < String, Object > ();


            producto1.put('Product2Id', '01t78000000AnvDAAS');
            producto1.put('Name','HBO MAX');          

            producto2.put('Product2Id', '01t78000000AWE6AAO');
            producto2.put('Name','INTERNET Cobre');          

            productos.add(producto1);
            productos.add(producto2);


            input.put(INPUT_PRODUCT2_ID, '01t78000000AnvDAAS');
            input.put(INPUT_PRODUCTS, productos);


            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_FILTER_PRODUCT, input, output, options);
            Test.stopTest();

            System.assertEquals(true, result);
    }
    
    @isTest
    private static void testGetPicklistValueOrderStatus() {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Test.startTest();

            List < Object > argumentos = new List < Object> ();
            input.put(INPUT_ARGUMENTS,argumentos);

            Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consumer' Limit 1].Id;

            Account acct = new Account (Name='Test Account', Phone='324423419012345', RecordTypeId = recordTypeId);
            insert acct;
            Order ordr = new Order(Name='Test Order',Status='Draft',AccountId = acct.Id,EffectiveDate = date.today());
            insert ordr;

            argumentos.add('Order');
            argumentos.add('Status');
            argumentos.add(ordr.Id);

            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_PICKLIST_VALUE, input, output, options);
            Test.stopTest();
            
            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testGetPicklistValueOrderSubStatus() {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Test.startTest();

            List < Object > argumentos = new List < Object> ();
            input.put(INPUT_ARGUMENTS,argumentos);

            Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consumer' Limit 1].Id;

            Account acct = new Account (Name='Test Account', Phone='324423419012345',RecordTypeId = recordTypeId);
            insert acct;
            Order ordr = new Order(Name='Test Order',Status='Draft',AccountId = acct.Id,EffectiveDate = date.today());
            insert ordr;

            argumentos.add('Order');
            argumentos.add('Substatus__c');
            argumentos.add(ordr.Id);

            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_PICKLIST_VALUE, input, output, options);
            Test.stopTest();

            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testGetPicklistValueOrderType() {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Test.startTest();

            List < Object > argumentos = new List < Object> ();
            input.put(INPUT_ARGUMENTS,argumentos);

            Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consumer' Limit 1].Id;

            Account acct = new Account (Name='Test Account', Phone='324423419012345',RecordTypeId = recordTypeId);
            insert acct;
            Order ordr = new Order(Name='Test Order',Status='Draft',AccountId = acct.Id,EffectiveDate = date.today());
            insert ordr;

            argumentos.add('Order');
            argumentos.add('Type');
            argumentos.add(ordr.Id);

            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_PICKLIST_VALUE, input, output, options);
            Test.stopTest();

            System.assertEquals(true, result);
    }

    @isTest
    private static void testGetPicklistValueCaseStatus() {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Test.startTest();

            List < Object > argumentos = new List < Object> ();
            input.put(INPUT_ARGUMENTS,argumentos);

            Case cas = new Case(Subject='Bloqueo de IMEI',Status='New');
            insert cas;

            argumentos.add('Case');
            argumentos.add('Status');
            argumentos.add(cas.Id);

            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_PICKLIST_VALUE, input, output, options);
            Test.stopTest();

            System.assertEquals(true, result);
    }

    @isTest
    private static void testGetPicklistValueAccountStatus() {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            List < Object > argumentos = new List < Object> ();
            input.put(INPUT_ARGUMENTS,argumentos);

            Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consumer' Limit 1].Id;

            Account acct = new Account (Name='Test Account', Phone='324423419012345', RecordTypeId = recordTypeId,vlocity_cmt__Status__c = 'Active');
            insert acct;

            argumentos.add('Account');
            argumentos.add('vlocity_cmt__Status__c');
            argumentos.add(acct.Id);

            Test.startTest();
               Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_PICKLIST_VALUE, input, output, options);
            Test.stopTest();

            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testGetPicklistValueAccountStatusFail() {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            Test.startTest();

            List < Object > argumentos = new List < Object> ();
            input.put(INPUT_ARGUMENTS,argumentos);

            Id recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consumer' Limit 1].Id;

            Account acct = new Account (Name='Test Account', Phone='324423419012345', RecordTypeId = recordTypeId,vlocity_cmt__Status__c = 'Active');
            insert acct;

            argumentos.add('Account');
            argumentos.add('vlocity_cmt__Status__c');
            argumentos.add('126378162');

            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_PICKLIST_VALUE, input, output, options);
            Test.stopTest();

            System.assertEquals(false, result);

    }

    @IsTest
    static void testgetItemsIdsucess(){
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        OrderItem item = [Select Id From OrderItem LIMIT 1];

        Map<String,Object> Getid = new Map<String,Object>();
        Map<String,Object> Getvalue = new Map<String,Object>();
        Map<String,Object> Getrecors = new Map<String,Object>();
        Map<String,Object> GetCartsItem = new Map<String,Object>();
        List<Map<String,Object>> listmapid = new List<Map<String,Object>>();
        List<Map<String,Object>> listmaprecors = new List<Map<String,Object>>();
        Getvalue.put('value', item.Id);
        Getid.put('Id', Getvalue);
        listmapid.add(Getid);
        Getrecors.put('records', listmapid);
        GetCartsItem.put('GetCartsItem', Getrecors);


        System.debug('inputcart ' + GetCartsItem);
        Test.startTest();

        Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_ITEMID_JSON_LIST, GetCartsItem, output, options);
        Test.stopTest();
        System.debug('result ' + JSON.serializePretty(result));
        System.assertEquals(true, result);
    }

    @IsTest
    static void testgetItemsIdsucessmoreitems(){
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<OrderItem> item = [Select Id From OrderItem LIMIT 2];
        Map<String,Object> Getid = new Map<String,Object>();
        Map<String,Object> Getid2 = new Map<String,Object>();
        Map<String,Object> Getvalue = new Map<String,Object>();
        Map<String,Object> Getvalue2 = new Map<String,Object>();
        Map<String,Object> Getrecors = new Map<String,Object>();
        Map<String,Object> GetCartsItem = new Map<String,Object>();
        List<Map<String,Object>> listmapid = new List<Map<String,Object>>();
        List<Map<String,Object>> listmaprecors = new List<Map<String,Object>>();
        Getvalue.put('value', item[0].Id);
        Getid.put('Id', Getvalue);
        Getvalue2.put('value', item[1].Id);
        Getid2.put('Id', Getvalue2);
        listmapid.add(Getid);
        listmapid.add(Getid2);
        Getrecors.put('records', listmapid);
        GetCartsItem.put('GetCartsItem', Getrecors);


        System.debug('inputcart ' + GetCartsItem);
        Test.startTest();

        Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_ITEMID_JSON_LIST, GetCartsItem, output, options);
        Test.stopTest();
        System.debug('output -------> ' + JSON.serializePretty(result));
        System.assert(output.size() > 0);
    }

    @IsTest
    static void methodName(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Account acc = [Select Id From Account Where Type = 'Business' LIMIT 1];
        Contact con = [Select Id From Contact LIMIT 1];
        Lead lead = [Select Id From Lead Where RecordType.DeveloperName = 'Venta_Unificada' LIMIT 1];

        inputMap.put('AccountId', acc.Id);
        inputMap.put('ContactId', con.Id);
        inputMap.put('LeadId', lead.Id);
		
        try{
        Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_CONVERT_LEAD_TO_CLIENT, inputMap, outMap, options);
        	System.debug('output -------> ' + JSON.serializePretty(result));
			System.assert(result != null);            

        }catch(Exception ex){
            System.debug('Error -------> ' + ex.getMessage());
        }
        Test.stopTest();
    }

    /*
    @IsTest
    static void reliesOnOrderItemsUpdateTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Order masterOrder = [Select Id From Order Where Name = 'Master Order' LIMIT 1];
        inputMap.put('parentOrderId', masterOrder.Id);
        Test.startTest();
        Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_RELIES_ON_ORD_ITEMS , inputMap, outMap, options);
        Test.stopTest();
        System.debug('output -------> ' + JSON.serializePretty(result));
        System.assertEquals(true, result);
        }
        */
    
    @IsTest
    static void getUrlStaticResource(){

        StaticResource static_resource = [SELECT Id, Name, SystemModStamp
                                        FROM StaticResource 
                                        LIMIT 1];

        String url = etb_Utilities.getUrlStaticResource(static_resource.Name);
        System.assert(!String.isBlank(url));
    }


    @IsTest
    static void SendNotificationsTest(){
        
        List<QuoteLineItem> QLIList = [SELECT Id, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem ];
        
        Date today = Date.today();
        Viabilidad__c via1 = new Viabilidad__c();
        via1.EstadoViabilidad__c = 'En proceso';
        via1.Fecha_Final_Estado__c = today.addDays(3);
        via1.OwnerId = Userinfo.getUserId();
        via1.Quote_Line_Item__c = QLIList[0].Id;
        via1.Tiempo_Entrega_ETB_dias__c = 0;
        insert via1;
        
        Test.startTest();
        List<Viabilidad__c> viabilidad = [SELECT Id, Name, EstadoViabilidad__c, Fecha_Final_Estado__c, OwnerId, Quote_Line_Item__c, Tiempo_Entrega_ETB_dias__c  FROM Viabilidad__c WHERE EstadoViabilidad__c = 'En proceso' ];
        Set<String> recipientsIds = new Set<String>();
        recipientsIds.add((String)viabilidad[0].OwnerId);
        String targetId = viabilidad[0].Id; 
        String tittle = 'Vencimiento de viabilidad';
        String body = 'Una viabilidad se encuentra próxima a vencer: '+viabilidad[0].Name;
        Boolean result = etb_Utilities.sendNotification(recipientsIds, targetId, tittle, body);
        System.assert(result);
        Test.stopTest();
    }

    @IsTest
    static void SendEmailTest(){

        List<QuoteLineItem> QLIList = [SELECT Id, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem ];
        
        Date today = Date.today();
        Viabilidad__c via1 = new Viabilidad__c();
        via1.EstadoViabilidad__c = 'En proceso';
        via1.Fecha_Final_Estado__c = today.addDays(3);
        via1.OwnerId = Userinfo.getUserId();
        via1.Quote_Line_Item__c = QLIList[0].Id;
        via1.Tiempo_Entrega_ETB_dias__c = 0;
        insert via1;
        
        Test.startTest();
        List<Viabilidad__c> viabilidad = [SELECT Id, Name, EstadoViabilidad__c, Fecha_Final_Estado__c,
                                            OwnerId, Quote_Line_Item__c, Tiempo_Entrega_ETB_dias__c, 
                                            Nombredelcliente__c, Quote_Line_Item__r.Quote.Account.Name 
                                        FROM Viabilidad__c 
                                        WHERE EstadoViabilidad__c = 'En proceso' ];
        Boolean result = etb_Utilities.sendEmail(viabilidad[0]);
        System.assert(result);
        Test.stopTest();
    }

    @IsTest
    static void SendEmailAndNotificationsTest(){
        
        List<QuoteLineItem> QLIList = [SELECT Id, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem ];
        
        Date today = Date.today();

        Viabilidad__c via2 = new Viabilidad__c(); 
        via2.EstadoViabilidad__c = 'En proceso';
        via2.Fecha_Final_Estado__c = today.addDays(1);
        via2.OwnerId = Userinfo.getUserId();
        via2.Quote_Line_Item__c = QLIList[0].Id;
        via2.Tiempo_Entrega_ETB_dias__c = 3;
        insert via2;

        Viabilidad__c via1 = new Viabilidad__c();
        via1.EstadoViabilidad__c = 'En proceso';
        via1.Fecha_Final_Estado__c = today.addDays(-89);
        via1.OwnerId = Userinfo.getUserId();
        via1.Quote_Line_Item__c = QLIList[1].Id;
        via1.Tiempo_Entrega_ETB_dias__c = 3;
        insert via1;

        Viabilidad__c via3 = new Viabilidad__c();
        via3.EstadoViabilidad__c = 'En proceso';
        via3.Fecha_Final_Estado__c = today.addDays(2);        
        via3.OwnerId = Userinfo.getUserId();
        via3.Quote_Line_Item__c = QLIList[2].Id;
        via3.Tiempo_Entrega_ETB_dias__c = 3;
        insert via3;
        
        Viabilidad__c via4 = new Viabilidad__c(); 
        via2.EstadoViabilidad__c = 'En proceso';
        via2.Fecha_Final_Estado__c = today.addDays(2); 
        via2.OwnerId = Userinfo.getUserId();
        via2.Quote_Line_Item__c = QLIList[2].Id;
        via2.Tiempo_Entrega_ETB_dias__c = 3;
        insert via4;
        
        Test.startTest();
        etb_Utilities.sendEmailAndNotification();
        Test.stopTest();
    }
    
    @IsTest
    static void SendEmailAndNotificationsTest2(){
        
        List<QuoteLineItem> QLIList = [SELECT Id, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem ];
        
        Date today = Date.today();

        Viabilidad__c via2 = new Viabilidad__c(); 
        via2.EstadoViabilidad__c = 'En proceso';
        via2.Fecha_Final_Estado__c = today.addDays(1);
        via2.OwnerId = Userinfo.getUserId();
        via2.Quote_Line_Item__c = QLIList[0].Id;
        via2.Tiempo_Entrega_ETB_dias__c = 3;
        insert via2;

        Viabilidad__c via1 = new Viabilidad__c();
        via1.EstadoViabilidad__c = 'En proceso';
        via1.Fecha_Final_Estado__c = today;
        via1.OwnerId = Userinfo.getUserId();
        via1.Quote_Line_Item__c = QLIList[1].Id;
        via1.Tiempo_Entrega_ETB_dias__c = 3;
        insert via1;

        Viabilidad__c via3 = new Viabilidad__c();
        via3.EstadoViabilidad__c = 'En proceso';
        via3.Fecha_Final_Estado__c = today.addDays(2);        
        via3.OwnerId = Userinfo.getUserId();
        via3.Quote_Line_Item__c = QLIList[2].Id;
        via3.Tiempo_Entrega_ETB_dias__c = 3;
        insert via3;
        
        Viabilidad__c via4 = new Viabilidad__c(); 
        via2.EstadoViabilidad__c = 'En proceso';
        via2.Fecha_Final_Estado__c = today.addDays(2); 
        via2.OwnerId = Userinfo.getUserId();
        via2.Quote_Line_Item__c = QLIList[2].Id;
        via2.Tiempo_Entrega_ETB_dias__c = 3;
        insert via4;

        
        Test.startTest();
        etb_Utilities.sendEmailAndNotification();
        Test.stopTest();
    }

    @isTest
    static void reliesOnOrderItemsUpdateTest(){

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Order masterOrder = [SELECT Id FROM Order WHERE Name = 'Master Order'];
        Order subOrder = [SELECT Id FROM Order WHERE Name = 'Sub Order'];
        OrderItem orderItemParent = [SELECT Id, vlocity_cmt__AssetReferenceId__c FROM OrderItem WHERE vlocity_cmt__AssetReferenceId__c = '07a7d7e3-98fd-e0fe-35bc-3cdfe27203e8'];
        OrderItem orderItemChild = [SELECT Id, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__ReliesOnItemId__c FROM OrderItem WHERE vlocity_cmt__AssetReferenceId__c = '96a6d6e2-98fd-e0fe-35bc-3cdfe27203e8'];


        Map<String,Object> orderItemParentMap = new Map<String, Object>();
        orderItemParentMap.put('AssetReferenceId', orderItemParent.vlocity_cmt__AssetReferenceId__c);
        orderItemParentMap.put('Id', orderItemParent.Id);

        List<Map<String,Object>> relatedParent = new List<Map<String,Object>>();
        relatedParent.add(orderItemParentMap);

        inputMap.put('parentOrderId', masterOrder.Id);
        inputMap.put('ParentItems', relatedParent );

        try{
            Test.startTest();
                Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_RELIES_ON_ORD_ITEMS, inputMap, outMap, options);
                System.debug('output -------> ' + JSON.serializePretty(result));
                System.assert(result != null);            
    
            }catch(Exception ex){
                System.debug('Error -------> ' + ex.getMessage());
            }
            Test.stopTest();
    }
    
    @isTest
    private static void testgetOriginalTotalPriceMethodCaso1() {
        
           Quote Q = [Select Id from Quote Where Name = 'Enterprise Quote Descount' LIMIT 1];
           List<QuoteLineItem> listQLI = [Select Id from QuoteLineItem where QuoteId =: Q.Id LIMIT 5];

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

        	List<Object> argumentos = new List<Object>();
  
            argumentos.add(listQLI[0].Id);
           
        	input.put(INPUT_ARGUMENTS,argumentos);
        
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_ORIGINAL_TOTAL_PRICE, input, output, options);
            Test.stopTest();

            //System.assertEquals('Contratista',output.get('fieldLabel'));
            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testgetOriginalTotalPriceMethodCaso2() {
        
           Quote Q = [Select Id from Quote Where Name = 'Enterprise Quote Descount' LIMIT 1];
           List<QuoteLineItem> listQLI = [Select Id from QuoteLineItem where QuoteId =: Q.Id LIMIT 5];

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

        	List<Object> argumentos = new List<Object>();
  
            argumentos.add(listQLI[1].Id);
           
        	input.put(INPUT_ARGUMENTS,argumentos);
        
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_ORIGINAL_TOTAL_PRICE, input, output, options);
            Test.stopTest();

            //System.assertEquals('Contratista',output.get('fieldLabel'));
            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testgetOriginalTotalPriceMethodCaso3() {
        
           Quote Q = [Select Id from Quote Where Name = 'Enterprise Quote Descount' LIMIT 1];
           List<QuoteLineItem> listQLI = [Select Id from QuoteLineItem where QuoteId =: Q.Id LIMIT 5];

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

        	List<Object> argumentos = new List<Object>();
  
            argumentos.add(listQLI[2].Id);
           
        	input.put(INPUT_ARGUMENTS,argumentos);
        
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_ORIGINAL_TOTAL_PRICE, input, output, options);
            Test.stopTest();

            //System.assertEquals('Contratista',output.get('fieldLabel'));
            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testgetOriginalTotalPriceMethodCaso4() {
        
           Quote Q = [Select Id from Quote Where Name = 'Enterprise Quote Descount' LIMIT 1];
           List<QuoteLineItem> listQLI = [Select Id from QuoteLineItem where QuoteId =: Q.Id LIMIT 5];

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

        	List<Object> argumentos = new List<Object>();
  
            argumentos.add(listQLI[3].Id);
           
        	input.put(INPUT_ARGUMENTS,argumentos);
        
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_ORIGINAL_TOTAL_PRICE, input, output, options);
            Test.stopTest();

            //System.assertEquals('Contratista',output.get('fieldLabel'));
            System.assertEquals(true, result);

    }
    
    @isTest
    private static void testgetOriginalTotalPriceMethodCaso5() {
        
           Quote Q = [Select Id from Quote Where Name = 'Enterprise Quote Descount' LIMIT 1];
           List<QuoteLineItem> listQLI = [Select Id from QuoteLineItem where QuoteId =: Q.Id LIMIT 5];

            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

        	List<Object> argumentos = new List<Object>();
  
            argumentos.add(listQLI[4].Id);
           
        	input.put(INPUT_ARGUMENTS,argumentos);
        
            Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_GET_ORIGINAL_TOTAL_PRICE, input, output, options);
            Test.stopTest();

            //System.assertEquals('Contratista',output.get('fieldLabel'));
            System.assertEquals(true, result);

    }
    @isTest
    private static void transformJson(){
        
        // string inputString   = '{ATT_CantidadEnlaces=2, ATT_CantidadSesionesSIP=null}';

        String jsonq='{"ATT_CantidadEnlaces":2, "ATT_CantidadSesionesSIP":null}';
        Map<String, Object> item = (Map<String, Object>) JSON.deserializeUntyped(jsonq);
        
        
        List<Object> argumentos = new List<Object>();
        argumentos.add(item);    
        
        System.debug('ARGS == Param Map');
        System.debug(argumentos);
        
       		Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
    
        input.put(INPUT_ARGUMENTS,argumentos);
        
       		Test.startTest();
            Object result = new etb_Utilities().invokeMethod(etb_Utilities.METHOD_TRANSFORM_JSON, input, output, options);
        	System.debug('output');
       		System.debug(output);
            Test.stopTest();
        	
            System.assertEquals(true, result);
        
        
        
        
    }

}