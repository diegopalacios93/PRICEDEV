/**
 * @description       : clase controladora para saber si hay respuesta de watson
 * @author            : Rodrigo de la Castilleja (RdC)
 * @group             : ETB
 * @last modified on  : 13-04-2021
 * @last modified by  : Rodrigo de la Castilleja (RdC)
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   13-04-2021   Rodrigo de la Castilleja (RdC)        Initial Version
 **/
public without sharing class DEG_MessageChecker_ctr {
    @AuraEnabled
    public static String getMessageJSON(String chatKey ) {
        
        List<LiveChatTranscript> ChatLst = [SELECT DEG_ChatResponseNumber__c,DEG_LastResponse__c,ChatKey,DEG_ClientSessionWatsonId__c
                                            FROM LiveChatTranscript
                                            WHERE ChatKey=: chatKey
                                            LIMIT 1];
        if( ChatLst.size()>0 ){
            return '{ "number" : "'+ChatLst[0].DEG_ChatResponseNumber__c+'",'+
                    ' "lastResponse" : '+ChatLst[0].DEG_LastResponse__c + ','+
                    ' "sessionIdWatson" : "'+ChatLst[0].DEG_ClientSessionWatsonId__c+'" }';
        }
        return '{ "number" : "0" }';
    }
}