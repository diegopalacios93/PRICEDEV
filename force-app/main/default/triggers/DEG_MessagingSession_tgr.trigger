trigger DEG_MessagingSession_tgr on MessagingSession (after update, before update, after insert, before insert) {
    //Invocación de handler
    DEG_HandlerMessagingSession_cls handler = new DEG_HandlerMessagingSession_cls(); 

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.OnBeforeInsert(Trigger.new, Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            handler.OnBeforeUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.OnAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            handler.OnAfterUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
}