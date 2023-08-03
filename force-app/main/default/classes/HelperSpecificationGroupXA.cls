public with sharing class HelperSpecificationGroupXA {
    public HelperSpecificationGroupXA() {

    }

    public void ActualizarOC (List<LTE_SpecificationGroupXA__c> SGExternal){
        Map<Id,OperacionComercial__c> OCsToUpdate = new Map<Id,OperacionComercial__c>();
       	Map<String, Schema.SObjectField> M;
        M = Schema.SObjectType.OperacionComercial__c.fields.getMap();        
        for(LTE_SpecificationGroupXA__c SGXA : SGExternal){
            Schema.SObjectField field = M.get(SGXA.ApiName__c);
            Schema.DisplayType FldType = field.getDescribe().getType();
            String fieldtypeS = String.valueOf(FldType);
            Id OCId = SGXA.LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__c;
            OperacionComercial__c oc = new OperacionComercial__c();
            if(!OCsToUpdate.containsKey(OCId)){
                oc.Id = OCId;
                OCsToUpdate.put(OCId,SetOC(oc,fieldtypeS,SGXA));
            }else{
                oc = OCsToUpdate.get(OCId);
                OCsToUpdate.put(OCId,SetOC(oc,fieldtypeS,SGXA));
            }
        }    
        System.debug('Ocs--->'+OCsToUpdate);
        update OCsToUpdate.values();
    }
    
    public OperacionComercial__c SetOC(OperacionComercial__c OC,String fieldType,LTE_SpecificationGroupXA__c SGXA){
        System.debug('Field Type---->'+fieldType);
    	if(fieldType == 'Double'){
        	OC.put(SGXA.ApiName__c,Decimal.ValueOf(SGXA.LTE_Value__c));
        }else if(fieldType == 'CURRENCY'){
            OC.put(SGXA.ApiName__c,Decimal.ValueOf(SGXA.LTE_Value__c));
        }else{
            OC.put(SGXA.ApiName__c,SGXA.LTE_Value__c);
        }
        System.debug('OC--->'+OC);
        return OC;
    }
}