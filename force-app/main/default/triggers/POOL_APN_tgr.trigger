trigger POOL_APN_tgr on POOL_APN__c (before update) {
    if (trigger.isAfter) {
        /*Implementar en caso de necesitarse*/
    }
    if (trigger.isBefore) {
        //  Bloque de ejecución After Update
        if (trigger.isUpdate) {
            //Bloque para actualizar la cuenta del pool y el APN de las IPs
            List<APN__c> lstIP = new List<APN__c>();
            Map <Id,POOL_APN__c> lstIdPool = new Map <Id,POOL_APN__c>();
            for(POOL_APN__c sglPool:trigger.new){
                if(sglPool.APN__c != Trigger.oldMap.get(sglPool.Id).APN__c){
                    sglPool.Cuenta_Cliente__c = sglPool.Cta_Cliente_Calc__c;
                    lstIdPool.put(sglPool.Id, sglPool);
                }
            }
			ProcesosAPN_cls.PoolCambioAPN(lstIdPool);
        }
    }
}