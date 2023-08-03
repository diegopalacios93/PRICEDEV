/**
* @Author:      Fernando Valdez <fvaldez@labsxd.com>
* @Company:     LabsXD
* @Date:		21/7/2022
* @Reviewer:    
* @Review Date: 
* @Description:
* -------------------------------------------------------------
*/
@isTest
public class etb_SendNotificationAsyncEngineTest {
    
    private static string bodySO = '{"ContractId": "1234","UserId": "1234","TittleMsg": "Proceso de creación de ordenes","BodyMsg": "El proceso de creación de ordenes ha finalizado correctamente.","CustomNotificationName": "etb_CreatedOrdersSuccess"}';
    private static string bodySOFail = '{"TittleMsg": "Proceso de creación de ordenes","BodyMsg": "El proceso de creación de ordenes ha finalizado correctamente.","CustomNotificationName": "etb_CreatedOrdersSuccess"}';
    private static string bodyLeg = '{"legalizationId": "1234","UserId": "1234","TittleMsg": "Proceso de actualización de ordenes","BodyMsg": "El proceso de actualización de ordenes ha finalizado correctamente.","BodyFailMsg": "El proceso de actualización de ordenes ha finalizado con algunos errores.","CustomNotificationName": "etb_CreatedOrdersSuccess"}';
    private static string failedList = '{"failed": [{"OrderId":"123"},{"OrderId":"234"}]}';
    private static string failedListEmpty = '{"failed": []}';
    
    @isTest
    static void sendNotificationLegalizationSinErrorTest(){
  		Map<String, Object> jsonBodyLeg = (Map<String, Object>)JSON.deserializeUntyped(bodyLeg);
  		Map<String, Object> jsonBodyFailedList = (Map<String, Object>)JSON.deserializeUntyped(failedListEmpty);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationLegalization';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',jsonBodyLeg);
        inputMap.put('itemsProcessed',jsonBodyFailedList);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNLeg = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNLeg.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }  
    
    @isTest
    static void sendNotificationLegalizationConErrorTest(){
  		Map<String, Object> jsonBodyLeg = (Map<String, Object>)JSON.deserializeUntyped(bodyLeg);
  		Map<String, Object> jsonBodyFailedList = (Map<String, Object>)JSON.deserializeUntyped(failedList);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationLegalization';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',jsonBodyLeg);
        inputMap.put('itemsProcessed',jsonBodyFailedList);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNLeg = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNLeg.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    }
    
    @isTest
    static void sendNotificationSalesOrderSinErrorTest(){
  		Map<String, Object> jsonBody2 = (Map<String, Object>)JSON.deserializeUntyped(bodySO);
  		Map<String, Object> jsonBodyFailedList = (Map<String, Object>)JSON.deserializeUntyped(failedListEmpty);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationSalesOrder';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',jsonBody2);
        inputMap.put('itemsProcessed',jsonBodyFailedList);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNOrder = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNOrder.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    } 
    
        @isTest
    static void sendNotificationSalesOrderConErrorTest(){
  		Map<String, Object> jsonBody2 = (Map<String, Object>)JSON.deserializeUntyped(bodySO);
        Map<String, Object> jsonBodyFailedList = (Map<String, Object>)JSON.deserializeUntyped(failedList);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationSalesOrder';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',jsonBody2);
        inputMap.put('itemsProcessed',jsonBodyFailedList);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNOrder = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNOrder.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    } 
    
    @isTest
    static void sendNotificationSalesOrderFailTest(){
  		Map<String, Object> jsonBody2 = (Map<String, Object>)JSON.deserializeUntyped(bodySOFail);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationSalesOrder';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',jsonBody2);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNOrder = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNOrder.invokeMethod(methodName,null,outMap,options);
        Test.stopTest();
    } 
    
        @isTest
    static void sendNotificationSalesOrderFailTest2(){
  		Map<String, Object> jsonBody2 = (Map<String, Object>)JSON.deserializeUntyped(bodySOFail);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationSalesOrder';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',null);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNOrder = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNOrder.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    } 
    
    @isTest
    static void sendNotificationInvokeFailedTest(){
  		Map<String, Object> jsonBody2 = (Map<String, Object>)JSON.deserializeUntyped(bodySOFail);	
        Map<String, Object>additionalMap = new Map<String, Object>();    
        String methodName = 'sendNotificationSalesOrderFailed';
        Map<String, Object>inputMap = new Map<String, Object>();
        inputMap.put('additionalData',jsonBody2);
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        etb_SendNotificationAsyncEngine SNOrder = new etb_SendNotificationAsyncEngine();
        Test.startTest();
        SNOrder.invokeMethod(methodName,inputMap,outMap,options);
        Test.stopTest();
    } 

}