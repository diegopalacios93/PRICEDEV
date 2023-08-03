public without sharing class HandlerSpecificationGroupXA {
    public HandlerSpecificationGroupXA() {

    }

    // Instancia del Helper
	HelperSpecificationGroupXA helper = new HelperSpecificationGroupXA();

	public void OnBeforeInsert(List<LTE_SpecificationGroupXA__c> listSG){
	}

	public void OnBeforeUpdate(List<LTE_SpecificationGroupXA__c> listSG, Map<Id, LTE_SpecificationGroupXA__c> mapOldSG){

	}


	public void OnAfterInsert(List<LTE_SpecificationGroupXA__c> listSG){
       	Set<Id> IdSGs = new Set<Id>();
        for (LTE_SpecificationGroupXA__c SGXA : listSG){
            IdSGs.add(SGXA.Id);
        }
        listSG = [SELECT LTE_ServiciosAdicionales__c,ApiName__c,LTE_Value__c,LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__c,
                         LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__r.Plan__c,
                         LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__r.Plan__r.DisponibleSistemaExterno__c
                         FROM LTE_SpecificationGroupXA__c WHERE Id IN :IdSGs];
        List<LTE_SpecificationGroupXA__c> SGExternal = new List<LTE_SpecificationGroupXA__c>();

        for (LTE_SpecificationGroupXA__c SGXA : listSG){
            //Validar que los lookup existan para evitar exepciones
            
            if(SGXA.LTE_Serviciosadicionales__c != null &&  SGXA.LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__c != null && 
            SGXA.LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__r.Plan__c != null){
                if(SGXA.LTE_Serviciosadicionales__r.LTE_Operacion_Comercial_SVA__r.Plan__r.DisponibleSistemaExterno__c == true){
                    SGExternal.add(SGXA);
                }
            }
        }

        helper.ActualizarOC(SGExternal);
	}


	public void OnAfterUpdate(List<LTE_SpecificationGroupXA__c> listSG, Map<Id, LTE_SpecificationGroupXA__c> mapOldSG){
	}
}