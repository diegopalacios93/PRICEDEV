trigger IP_tgr on IP__c (after update, after insert, after delete) {
	if (trigger.isAfter) {
        if (trigger.isDelete) {
            ProcesosAPN_cls.APNCantidadIP(trigger.oldMap.values());
        }else if(trigger.isInsert) {
            ProcesosAPN_cls.APNCantidadIP(trigger.new);
        }else {
            List <IP__c> lstIP = new List <IP__c>();
            for(IP__c sglIP:trigger.new){
                if(sglIP.APN__c != null){
                    lstIP.add(sglIP);
                }
                if(trigger.oldMap.get(sglIP.Id).APN__c != null && sglIP.APN__c != Trigger.oldMap.get(sglIP.Id).APN__c){
                    lstIP.add(trigger.oldMap.get(sglIP.Id));
                }
            }
            ProcesosAPN_cls.APNCantidadIP(lstIP);
        }
    }
}