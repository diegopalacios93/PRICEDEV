/**
 * Globant Colombia
 * @description       : Utilities Class
 * @author            : Carlos Suarez (CS) carlosalberto.suarez@globant.com
 * @group             : 
 * @last modified on  : 06-04-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   13-04-2021   Carlos Suarez (CS)   Initial Version
**/
public without sharing class DEG_ResponseUtilities_cls {

    /**
     * Get Canal Bot By Name
     * @param String canalName
     * @return DEG_CanalBot__mdt
     */
    public static DEG_CanalBot__mdt getCanalBotByName(String canalName){
        return [SELECT DEG_NombreCanalBot__c, DEG_Sistema__c, DEG_CorrelationId__c,DEG_ClientSessionId__c FROM DEG_CanalBot__mdt WHERE DEG_NombreCanalBot__c = :canalName LIMIT 1].get(0);
    }

    /**
     * Update Chat Object
     * @param List<DEG_ConsumeOrquestadorAsync_ws.Input> lstInput
     * @param String message
     * @param DEG_ConsumeOrquestadorHelper_cls.wrpAnalize analizeWrapper
     */
    public static Boolean updateChatObject(List<DEG_ConsumeOrquestadorAsync_ws.Input> lstInput, String message, 
                                        DEG_ConsumeOrquestadorHelper_cls.wrpAnalize analizeWrapper ){
        Boolean isResult = false;
        try{
            DEG_CanalBot__mdt canalBot = getCanalBotByName(lstInput[0].canalBot); 
            LiveChatTranscript lvChat = getLiveChatTrasncriptById(lstInput[0].conversationId);
                
            if(String.isNotBlank(lvChat.Id)){
                lvChat.DEG_ClientSessionWatsonId__c = canalBot.DEG_ClientSessionId__c + ' ' + lstInput[0].conversationId;
                lvChat.DEG_SessionIdWatson__c = lstInput[0].sessionId;
                lvChat.DEG_ManageBody__c = true;
                lvChat.DEG_LastResponse__c = message;
                lvChat.DEG_TransferToAgent__c = analizeWrapper.pasoAgente;
                lvChat.DEG_ChatResponseNumber__c = ( lvChat.DEG_ChatResponseNumber__c == null ) ? 0 + 1 : lvChat.DEG_ChatResponseNumber__c + 1;
                lvChat.DEG_Event__c = analizeWrapper.evento;
                update lvChat;
            }

            isResult = true;
        }catch(Exception e){
            System.debug('Error Update Chat Object: ' + e.getMessage());
			System.debug('Error Line: ' + e.getLineNumber());
        }
        System.debug('***getCpuTime() consume ***' + Limits.getCpuTime());
        return isResult;
    }

    /**
     * Update Chat Object
     * @param List<DEG_ConsumeOrquestadorAsync_ws.Input> lstInput
     * @param String message
     * @param DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize analizeWrapper
     */
    public static Boolean updateChatObjectWpp(List<DEG_ConsumeOrquestadorAsync_ws.Input> lstInput, String message, 
        DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize analizeWrapper ){
        Boolean isResult = false;
        try{
            DEG_CanalBot__mdt canalBot = getCanalBotByName(lstInput[0].canalBot);
                           
            MessagingSession msgSession = getMessagingSessionById(lstInput[0].conversationId);
            String cellNumber = DEG_ConsumeOrquestadorAsyncWpp_ws.getPhoneNumber(lstInput[0].conversationId);

            if(String.isNotBlank(msgSession.Id)){
                msgSession.DEG_ClientSessionWatsonId__c = canalBot.DEG_ClientSessionId__c + cellNumber;
                msgSession.DEG_SessionIdWatson__c = lstInput[0].sessionId;
                msgSession.DEG_LastResponse__c = message;
                msgSession.DEG_TransferToAgent__c = analizeWrapper.pasoAgente;
                msgSession.DEG_Event__c = analizeWrapper.evento;
                update msgSession;
            }
            isResult = true;
        }catch(Exception e){
            System.debug('Error Update Chat Object: ' + e.getMessage());
			System.debug('Error Line: ' + e.getLineNumber());
        }
        System.debug('***getCpuTime() consume ***' + Limits.getCpuTime());
        return isResult;
    }

    /**
     * Get MessageSession by Id
     * @param String id
     * @return MessagingSession
     */
    public static MessagingSession getMessagingSessionById(String id){
        return [SELECT Id, DEG_ClientSessionWatsonId__c,DEG_SessionIdWatson__c,DEG_TokenWatson__c FROM MessagingSession  WHERE Id =: id LIMIT 1].get(0);
    }

    /**
     * Get LiveChatTranscript by Id
     * @param String id
     * @return LiveChatTranscript
     */
    public static LiveChatTranscript getLiveChatTrasncriptById(String id){
        return [SELECT Id, DEG_ClientSessionWatsonId__c,DEG_SessionIdWatson__c,DEG_TokenWatson__c,DEG_ManageBody__c,DEG_ChatResponseNumber__c  FROM LiveChatTranscript  WHERE Id =: id LIMIT 1].get(0);
    }

    /**
     * Return Map Object
     * @param String json
     * @return Map<String, Object>
     */
    public static Map<String, Object> toMap(String json){
        return (Map<String, Object>) System.JSON.deserializeUntyped(json);
    }

    /**
     * Get List Input
     * @param String sResponse
     * @param String conversationId
     * @return List<DEG_ConsumeOrquestadorAsync_ws.Input>
     */
    public static List<DEG_ConsumeOrquestadorAsync_ws.Input> getInputByConversationId(String strResponse, String conversationId){
        List<DEG_ConsumeOrquestadorAsync_ws.Input> lstOrquest = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
        DEG_ConsumeOrquestadorAsync_ws.Input objOrquestInput = new DEG_ConsumeOrquestadorAsync_ws.Input();

        List<LiveChatTranscript> lLiveChatTranscript;
        List<MessagingSession> msgSessionLst;
        String prefixClient = '';
        String cellNumber = '';
        try{
            if(String.isNotBlank(conversationId)){
                if(conversationId.contains('Etb')){
                    prefixClient = DEG_ResponseFrames_ws.searchPrefixClientSession('WEB');
                    lLiveChatTranscript = DEG_HelperLiveChatTranscript_cls.getLiveChatTranscript(conversationId);
                    
                    if( lLiveChatTranscript != null ){
                        objOrquestInput.canalBot = 'WEB';
                        objOrquestInput.sessionId = lLiveChatTranscript[0].DEG_SessionIdWatson__c;  
                        //objOrquestInput.token =  lLiveChatTranscript[0].DEG_TokenWatson__c;
                        objOrquestInput.conversationId = String.valueOf( lLiveChatTranscript[0].DEG_ClientSessionWatsonId__c.remove(prefixClient) ).trim();
                    }
                }else{
                    prefixClient = DEG_ResponseFrames_ws.searchPrefixClientSession('WPP');
                    msgSessionLst = DEG_HelperLiveChatTranscript_cls.getMessagingSession(conversationId);
                    if( msgSessionLst != null ){
                        objOrquestInput.canalBot = 'WPP';
                        objOrquestInput.sessionId = msgSessionLst[0].DEG_SessionIdWatson__c;  
                        //objOrquestInput.token =  msgSessionLst[0].DEG_TokenWatson__c;
                        cellNumber =  msgSessionLst[0].DEG_ClientSessionWatsonId__c.remove(prefixClient); 
                        //put .Id because method return messagingSession record 28-05-21 (HCH)
                        objOrquestInput.conversationId = getMessagingSessionId(cellNumber);
                    }
                }

                if(objOrquestInput.sessionId != null){
                    objOrquestInput.textClient = '';
                    //objOrquestInput.context = strResponse;
                    lstOrquest.add(objOrquestInput);
                }
            }
        }catch( Exception e ){
            System.debug('##Error Input Conversation: '+ e.getMessage());
            System.debug('##Error LineNumber: '+ e.getLineNumber());
        }

        return lstOrquest;
    }

    /**
    * @definition:
    * @param: 
    */ 
    public static String getMessagingSessionId(String phoneNumber){
        phoneNumber = 'whatsapp:+' +phoneNumber;
		String IdMessagingSession = [SELECT Id
			                     FROM MessagingSession
			                     WHERE MessagingEndUser.Name = :phoneNumber order by CreatedDate desc limit 1].Id;  
		System.debug('##IdMessagingSession '+IdMessagingSession);
		return IdMessagingSession;
	}

}