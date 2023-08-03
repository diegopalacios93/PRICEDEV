global with sharing  class PricingCalculationPreProcess implements vlocity_cmt.VlocityOpenInterface {
    
	global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        try{
            if(methodName == 'calculate') {             
                 calculate(input, output, options);  
                 return true;
            }else{
                return false;
            }
          }catch(Exception e){
                    system.debug(e);
                    return false;
         }      
    }
    global static void calculate(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
      	list<Object> inputData = (list<Object>) input.get('inputData');
        for(Object obj : inputData)
        {
           Map<String, Object> entradas = (Map<String, Object>) obj;
            Id quoteLineItemId = (Id)entradas.get('ID');
            List<Costos_Avanzados__c> costos = [SELECT Id, Quote_Line_Item__c, Tarifa_Unitaria_con_Descuento__c, CC_TarifaPisoUnitariaSinIVA__c
                                            FROM Costos_Avanzados__c WHERE Quote_Line_Item__c =: quoteLineItemId];
            for ( Costos_Avanzados__c costo : costos){
            	entradas.put('GetPriceFromCotizador', costo.Tarifa_Unitaria_con_Descuento__c);
                entradas.put('GetCostFromCotizador', costo.CC_TarifaPisoUnitariaSinIVA__c);
                
        	}
        }
    }
}