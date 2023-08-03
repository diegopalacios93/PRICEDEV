trigger SpecificationGroupXA_tgr on LTE_SpecificationGroupXA__c (after update, before update, after insert, before insert) {
    HandlerSpecificationGroupXA handler = new HandlerSpecificationGroupXA(); 

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.OnBeforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.OnAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }    
}