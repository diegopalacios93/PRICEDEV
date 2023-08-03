@isTest
public class etb_ViabilityCreationByQuoteLineItemTest {
    @TestSetup

        static void makeData(){
                CreateDataTest.createData();
        }

    
    /*@isTest
    private static void callOMProvisioning() {
        String methodName = 'ProvisioningReq';
        Map<String, Object>inputMap = new Map<String, Object>();
        Map<String, Object>outMap = new Map<String, Object>(); 
        Map<String, Object>options = new Map<String, Object>();
        String Respuesta = '{'+
         '"Input": {'+
        '"itemList": ['+
        '{'+
        '"umbral": 5,'+
        '"Id": "0QL78000000GxVWGA0",'+
        '"AccountName": "Fernando Valdez",'+
        '"requireViabilidad": false,'+
        '"EstadoViabilidad": "Pendiente",'+
        '"viabilidad": "a0C780000003VxZEAU",'+
        '"name": "MDE Adicionales",'+
        '"ProductId": "01t78000000bG2WAAU"'+
      '},'+
      '{'+
        '"umbral": 5,'+
        '"Id": "0QL78000000GxVTGA0",'+
        '"AccountName": "Fernando Valdez",'+
        '"requireViabilidad": true,'+
        '"FechaUmbral": -1,'+
        '"FechaValidez": "2022-05-01",'+
        '"EstadoViabilidad": "Pendiente",'+
        '"viabilidad": "a0C780000003VhvEAE",'+
        '"name": "Troncales SIP Fija",'+
        '"ProductId": "01t78000000bG3KAAU"'+
      '},'+ 
    '],'+
    '"recordItem": "012f3000000lBYYAA2"'+
   ' }';
        inputMap.put('request',Respuesta);
         inputMap.put('request',Respuesta);
        etb_ProvisioningRequest provi = new etb_ProvisioningRequest();
        provi.invokeMethod(methodName, inputMap, outMap, options);
    }*/
    
    @isTest
    private static void viableQuoteLineItemsTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Quote> q = [Select Id From Quote Limit 2];
        
        inputMap.put('quoteId', q[1].Id);
        inputMap.put('recordItem',Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId() );
        
        try{
         	Test.startTest();
            Object result = new etb_ViabilityCreationByQuoteLineItem().invokeMethod(etb_ViabilityCreationByQuoteLineItem.METHOD_VIABLE_QUOTE_LINE_ITEMS, inputMap, outMap, options);
        	System.debug('output -------> ' + JSON.serializePretty(result));
			System.assert(result != null);            

        }catch(Exception ex){
            System.debug('Error -------> ' + ex.getMessage());
        }
        	Test.stopTest();
        
    }
}