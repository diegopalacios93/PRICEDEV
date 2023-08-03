@isTest
public class etb_CalculateExecutedAmountTest {
    @TestSetup

        static void makeData(){
                CreateDataTest.createData();
        }
    @isTest
    private static void calculateamount(){
        String methodName = 'calculateExecutedAmount';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        List<Contract> cont = [Select Id From Contract LIMIT 2];
        options.put('ContractId',cont[0].Id);
        etb_CalculateExecutedAmount CEA = new etb_CalculateExecutedAmount();
        Test.startTest();
        CEA.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }
    
    @isTest
    private static void calculateamount2(){
        String methodName = 'calculateExecutedAmount';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        List<Contract> cont = [Select Id From Contract LIMIT 2];
        options.put('ContractId',cont[1].Id);
        etb_CalculateExecutedAmount CEA = new etb_CalculateExecutedAmount();
        Test.startTest();
        CEA.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }
    
    @isTest
    private static void calculateamount3(){
        String methodName = 'calculateExecutedAmount';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        List<Contract> cont = [Select Id From Contract LIMIT 2];
        options.put('ContractId',cont[1].Id);
        etb_CalculateExecutedAmount CEA = new etb_CalculateExecutedAmount();
        Test.startTest();
        CEA.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }
    
        @isTest
    private static void calculateamount4(){
        String methodName = 'Pepe';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        List<Contract> cont = [Select Id From Contract LIMIT 2];
        options.put('ContractId',cont[1].Id);
        etb_CalculateExecutedAmount CEA = new etb_CalculateExecutedAmount();
        Test.startTest();
        CEA.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }
    
            @isTest
    private static void calculateamount5(){
        String methodName = 'calculateExecutedAmount';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        List<Contract> cont = [Select Id From Contract LIMIT 3];
        options.put('ContractId',cont[2].Id);
        etb_CalculateExecutedAmount CEA = new etb_CalculateExecutedAmount();
        Test.startTest();
        CEA.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }
    
                @isTest
    private static void calculateamount6(){
        String methodName = 'calculateExecutedAmount';
        Map<String, Object>inputMap = null;
        Map<String, Object>outMap = null; 
        Map<String, Object>options = null;
        List<Contract> cont = new List<Contract>();
        //options.put('ContractId',cont[1].Id);
        etb_CalculateExecutedAmount CEA = new etb_CalculateExecutedAmount();
        Test.startTest();
        CEA.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }

}