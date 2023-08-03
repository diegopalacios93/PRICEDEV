/*
* @Author:      Victor Pacheco
* @Company:     LabsXD
* @Date:
* @Reviewer:    
* @Review Date: 
* @Description:
* -------------------------------------------------------------
*/
@isTest
public class etb_UpdateAssetTest {
	@TestSetup
    static void makeData(){
        CreateDataTest.createData();
    }

    @isTest
    private static void testUpdateAssetDataSuccess() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();

        Order order = [SELECT Id FROM Order LIMIT 1];

        List < Object > argumentos = new List < Object> ();
        input.put('OrderId',order.Id);

        Object result = new etb_UpdateAsset().invokeMethod(etb_UpdateAsset.METHOD_UPDATE_ASSET_DATA_LABEL, input, output, options);
        Test.stopTest();
	
        Asset ass = [SELECT Id, Status FROM Asset LIMIT 1];
        system.debug('Asset ' + ass.status);
        
        System.assertEquals(ass.status, 'Active', 'Ejecucion exitosa');

    }
    
    @isTest
    private static void testUpdateAssetDataFail() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();

        Order order = [SELECT Id FROM Order LIMIT 1];

        List < Object > argumentos = new List < Object> ();
        input.put('OrderId',order.Id);

        Object result = new etb_UpdateAsset().invokeMethod('TestMethod', input, output, options);
        Test.stopTest();

        system.debug('result ' + JSON.serializePretty(result));
        
        System.assertEquals(result, false, 'Ejecucion exitosa');

    }
    
@isTest
    private static void testUpdateAssetDataException() {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();

        Order order = [SELECT Id FROM Order LIMIT 1];

        List < Object > argumentos = new List < Object> ();
        input.put('OrderId',order.Id);

        Object result = new etb_UpdateAsset().invokeMethod(etb_UpdateAsset.METHOD_FAIL_LABEL, input, output, options);
        Test.stopTest();

        system.debug('result ' + JSON.serializePretty(result));
        
        System.assertEquals(result, false, 'Ejecucion exitosa');

    }
}