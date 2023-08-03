global with sharing class etb_CalculateExecutedAmount implements vlocity_cmt.VlocityOpenInterface
{
global etb_CalculateExecutedAmount() { }

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try{
            if (methodName.equals('calculateExecutedAmount')){
                system.debug('Entro a calcular monto ejecutado');
                calculateExecutedAmount(inputMap,outMap,options);
                return true;
            }else{
            	return false;
            }    
        }catch(Exception e){
            System.debug('invokeMethod -> exception: '+e);
            return false;
        }    
    }
    
      void calculateExecutedAmount(Map<String, Object> inputMap, Map<String, Object> outMap,Map<String,Object> options)
      {
          List<vlocity_cmt__ContractLineItem__c> contractLineItemsToUpdate = new List<vlocity_cmt__ContractLineItem__c>();
          String contractId = (String)options.get('ContractId');
          system.debug('id ' + contractId);
          List<vlocity_cmt__ContractLineItem__c> contractLineItems = [SELECT Id, Name, vlocity_cmt__AttributeSelectedValues__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__OneTimeTotal__c 
                                                                      FROM vlocity_cmt__ContractLineItem__c 
                                                                      WHERE vlocity_cmt__ContractId__c =: contractId];
          system.debug('longitud ' + contractLineItems);
          for(vlocity_cmt__ContractLineItem__c clItem: contractLineItems){
              Double resultado = 0.0;
              Map<String, Object> attSelected = new Map<String, Object>();
              attSelected = (Map<String, Object>)JSON.deserializeUntyped(clItem.vlocity_cmt__AttributeSelectedValues__c);
              if(attSelected.get('ATT_TiempoContratoDias') != null && attSelected.get('ATT_TiempoContratoMeses') != null){
                  Integer attCantDias = (Integer)attSelected.get('ATT_TiempoContratoDias');
                  Integer attCantMeses = (Integer)attSelected.get('ATT_TiempoContratoMeses');
                  resultado = (clItem.vlocity_cmt__RecurringTotal__c * attCantMeses) + ((clItem.vlocity_cmt__RecurringTotal__c / 30) * attCantDias) + clItem.vlocity_cmt__OneTimeTotal__c;
              	  clItem.Monto_ejecutado__c = resultado;
                  contractLineItemsToUpdate.add(clItem);
              }
              if(attSelected.get('ATT_TiempoContratoDias') == null && attSelected.get('ATT_TiempoContratoMeses') != null){
                  Integer attCantMeses = (Integer)attSelected.get('ATT_TiempoContratoMeses');
                  resultado = (clItem.vlocity_cmt__RecurringTotal__c * attCantMeses) + clItem.vlocity_cmt__OneTimeTotal__c;
              	  clItem.Monto_ejecutado__c = resultado;
                  contractLineItemsToUpdate.add(clItem);
              }
          }
          if(contractLineItemsToUpdate.size() > 0){
                Update contractLineItemsToUpdate;
                outMap.put( 'ListContractLineItemUpdated', contractLineItemsToUpdate);
                outMap.put('success', true);
          }else{
          		outMap.put('message', 'No hay contract line items que actualizar');
              	outMap.put('success', true);
          }
      }

        
}