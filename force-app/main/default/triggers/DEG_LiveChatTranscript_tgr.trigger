/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 07-16-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   03-06-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
trigger DEG_LiveChatTranscript_tgr on LiveChatTranscript (after update, before update, after insert, before insert) {
    //Invocación de handler
    DEG_HandlerLiveChatTranscript_cls handler = new DEG_HandlerLiveChatTranscript_cls();
    if(DEG_HandlerLiveChatTranscript_cls.canIRun()){

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
}