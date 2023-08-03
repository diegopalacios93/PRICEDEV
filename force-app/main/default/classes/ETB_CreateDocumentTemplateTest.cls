@isTest
public class ETB_CreateDocumentTemplateTest {
	@TestSetup
	static void makeData(){
        
        Id pricebookId = Test.getStandardPricebookId();

      
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
    
        Order order = new Order ();
        order.Name = 'Master Order';
        order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('MasterOrder').getRecordTypeId();
        order.AccountId = accountBusiness.Id;
        order.Status = 'Draft';
        order.EffectiveDate = Date.today();
        order.Pricebook2Id = pricebookId;
        insert order;    
        
        Contract contractTest = new Contract();
		contractTest.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Cliente').getRecordTypeId();
        contractTest.AccountId = accountBusiness.Id;
        contractTest.Status = 'Borrador';
        
        Insert contractTest;        
        
        
        vlocity_cmt__ContractVersion__c contractVer = new vlocity_cmt__ContractVersion__c();
        contractVer.Name = 'Test';
        contractVer.vlocity_cmt__ContractId__c = contractTest.Id;
        Insert contractVer;
	}

    @isTest
    private static void createTemplateTest() {
        
        System.debug('Create');
    
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
       	Order order = [Select Id From Order LIMIT 1];
    
        options.put('RecordId', order.Id);
        
        Contract testContract = [Select Id from Contract LIMIT 1];
        input.put('TestContractId', testContract.Id);
    
        Test.startTest();
        Object result = new ETB_CreateDocumentTemplate().invokeMethod('createTemplate', input, output, options);
        Test.stopTest();

        System.assertEquals(true, result);
    }

    @isTest
    private static void createContractTest() {
    
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [Select Id From Order LIMIT 1];
        Contract testContract = [Select Id from Contract LIMIT 1];
        input.put('TestContractId', testContract.Id);
    
        options.put('RecordId', order.Id);
        options.put('Startdate', '2022-02-21');
        options.put('frame', false);
        options.put('Term', '6');
    
        Test.startTest();
        Object result = new ETB_CreateDocumentTemplate().invokeMethod('createContract', input, output, options);
        Test.stopTest();

        System.assertEquals(true, result);
    }
    
        @isTest
    private static void createContractTestInvoke() {
    
        Map<String, Object> input = null;
        Map<String, Object> output = null;
        Map<String, Object> options = null;
        
        /*Order order = [Select Id From Order LIMIT 1];
        Contract testContract = [Select Id from Contract LIMIT 1];
        input.put('TestContractId', testContract.Id);
    
        options.put('RecordId', order.Id);
        options.put('Startdate', '2022-02-21');
        options.put('frame', false);
        options.put('Term', '6');*/
    
        Test.startTest();
        Object result = new ETB_CreateDocumentTemplate().invokeMethod('createContract', input, output, options);
        Test.stopTest();

        //System.assertEquals(true, result);
    }
    
     @isTest
    private static void createContractTestInvoke2() {
    
        Map<String, Object> input = null;
        Map<String, Object> output = null;
        Map<String, Object> options = null;
        
        /*Order order = [Select Id From Order LIMIT 1];
        Contract testContract = [Select Id from Contract LIMIT 1];
        input.put('TestContractId', testContract.Id);
    
        options.put('RecordId', order.Id);
        options.put('Startdate', '2022-02-21');
        options.put('frame', false);
        options.put('Term', '6');*/
    
        Test.startTest();
        Object result = new ETB_CreateDocumentTemplate().invokeMethod('createContractFails', input, output, options);
        Test.stopTest();

        //System.assertEquals(true, result);
    }
}