public without sharing class DEG_TranscriptConversation_cls {

    public class TranscriptOutput{
        public String result;
        public String errorMessage;
    }

    public class TranscripInput{
        public String liveChatTranscriptId;
    }

    /**
     * Return number of conversations to be format
     * @param Id valid
     * @return Integer
     */
    @AuraEnabled(cacheable=true)
    public static Integer activeTranscriptBody(Id valid){
        Integer vCount = 0;
        List<LiveChatTranscript> lstChats;
        if(
            LiveChatTranscript.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.LiveChatTranscript.fields.Id.isAccessible() &&
            Schema.SObjectType.LiveChatTranscript.fields.Body.isAccessible()
        ){
            lstChats  = [SELECT Id, Body, DEG_LastResponse__c FROM LiveChatTranscript WHERE Id = :valId LIMIT 1];
        }
        if(!lstChats.isEmpty()){
            if( isTranscript(lstChats[0].Body) ){ vCount = lstChats.size();}
        }
        return vCount;
    }

    /**
     * Method call on the LWC to format conversation
     * @param String valLiveChatTranscriptId
     * @return Map<String,Object>
     */
    @AuraEnabled
    public static Map<String, Object> transcriptConversation(String valLiveChatTranscriptId) {
        TranscripInput vParams = new TranscripInput();
        vParams.liveChatTranscriptId = valLiveChatTranscriptId;
        TranscriptOutput vResult = transcriptLiveChatConversation(new TranscripInput[]{vParams})[0];
        return new Map<String, Object> {
            'message' => vResult.errorMessage,
            'error' => vResult.result == null,
            'record' => vResult.result
        };
    }
    
    /**
     * Format Body
     * @param List<TranscripInput> transcriptInputs
     * @return List<TranscriptOutput>
     */
    public static List<TranscriptOutput> transcriptLiveChatConversation(List<TranscripInput> transcriptInputs) {
        Set<Id> vTranscriptIds = new Set<Id>();
        List<TranscriptOutput> vResult = new List<TranscriptOutput>();
        for(TranscripInput vTranscriptInput : transcriptInputs) { vTranscriptIds.add(vTranscriptInput.liveChatTranscriptId); }
        Savepoint vSavePoint = Database.setSavepoint();
        try {

            Map<Id, LiveChatTranscript> vMapLiveChatTranscripts = new Map<Id, LiveChatTranscript>([SELECT Id, Body, DEG_LastResponse__c FROM LiveChatTranscript WHERE Id IN :vTranscriptIds]);
            LiveChatTranscript[] lstLiveChatTranscript = new LiveChatTranscript[0];
            for(TranscripInput vTranscriptInput : transcriptInputs) {  
                LiveChatTranscript vLiveChatTranscript = vMapLiveChatTranscripts.get(vTranscriptInput.liveChatTranscriptId);
                //if( isTranscript(vLiveChatTranscript.Body) ){ vLiveChatTranscript.Body = vLiveChatTranscript.DEG_LastResponse__c;}
                lstLiveChatTranscript.add(vLiveChatTranscript);
            }

            Database.SaveResult[] vSaveResults = Database.update(lstLiveChatTranscript);


            for(Database.SaveResult vSaveResult: vSaveResults) {  
                TranscriptOutput vTranscriptOutput = new TranscriptOutput();
                vTranscriptOutput.errorMessage = vSaveResult.success ? '' : JSON.serialize(vSaveResult.errors);
                vTranscriptOutput.result = vSaveResult.success ? vSaveResult.id : null;
                vResult.add(vTranscriptOutput);
            }

        } catch(Exception e) {
            Database.rollback(vSavePoint);
            vResult = new TranscriptOutput[0];
            TranscriptOutput outTrancriptConv = new TranscriptOutput();
            outTrancriptConv.result = null;
            outTrancriptConv.errorMessage = e.getMessage();
            vResult.add(outTrancriptConv);
        }

        return vResult;
    }

    /**
     * Method to check if body needs to be format
     * @param String body
     * @return Boolean
     */
    public static Boolean isTranscript(String body){
        Boolean isTranscript = false;
        if(body != null && body.contains('[{')){
            isTranscript = true;
        }
        return isTranscript;
    }
}