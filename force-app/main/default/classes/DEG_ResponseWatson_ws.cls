@RestResource(urlMapping='/response_watson/*')
global without sharing class DEG_ResponseWatson_ws {

    /** 
    * EndPoint
    * @param RestContext.request
    * @return void
    */
    @HttpPost
    global static void createWatsonResponse() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            Blob body = req.requestBody;
            String sRequest = body.toString();
            DEG_ResultObject_cls result = getWatsonCallout( sRequest );
            res.statusCode = result.Status;
            res.responseBody = Blob.valueOf(JSON.serialize(result.getMapResult()));
        }catch(Exception ex) {
        	res.statusCode = 500;
            res.responseBody = Blob.valueOf(ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause());
        }
    }

    /** 
    * Retorna resultado
    * @param String sRequest
    * @return DEG_ResultObject_cls
    */
    public static DEG_ResultObject_cls getWatsonCallout( String sRequest ) {
        DEG_ResultObject_cls result;
        DEG_WrapperJSONBot_cls.responseMessage rptaMessage = new DEG_WrapperJSONBot_cls.responseMessage();
        Map<String, Object> objRequest = DEG_ResponseUtilities_cls.toMap(sRequest);
        
        String conversationId = String.valueOf(objRequest.get('client_session_id'));
        String sAllMessage = '';
        
        if(String.isNotBlank(conversationId)){
            rptaMessage = DEG_ConsumeOrquestadorAsync_ws.getDeserializeBody(sRequest, rptaMessage);
            
            List<DEG_ConsumeOrquestadorAsync_ws.Input> lstOrquestInput = DEG_ResponseUtilities_cls.getInputByConversationId(sRequest, conversationId);
            if(!lstOrquestInput.isEmpty()){
                if(lstOrquestInput[0].canalBot.contains('WEB')) {
                    DEG_ConsumeOrquestadorHelper_cls.wrpAnalize analizeWrapper = DEG_ConsumeOrquestadorHelper_cls.manageDeserealizeBody(rptaMessage, lstOrquestInput[0].sessionId, '', lstOrquestInput[0].conversationId);
                    sAllMessage = analizeWrapper.strJson;
                    Boolean vUpdate = DEG_ResponseUtilities_cls.updateChatObject(lstOrquestInput, sAllMessage, analizeWrapper);
                    if(vUpdate){ result = new DEG_ResultObject_cls(200, 'success', 'ok'); }
                } else if(lstOrquestInput[0].canalBot.contains('WPP')) {
                    DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize analizeWrapper = DEG_ConsumeOrquestadorHelperWhatsapp_cls.manageDeserealizeBody(rptaMessage, lstOrquestInput[0].sessionId, '', lstOrquestInput[0].conversationId);
                    sAllMessage = analizeWrapper.strJson;
                    Boolean vUpdate = DEG_ResponseUtilities_cls.updateChatObjectWpp(lstOrquestInput, sAllMessage, analizeWrapper);
                    if(vUpdate){ result = new DEG_ResultObject_cls(200, 'success', 'ok'); }
                }
            }else{ result = new DEG_ResultObject_cls(404, 'Conversation Not Content'); }
            
        }else{ result = new DEG_ResultObject_cls(500, 'Error'); }
        
        return result;
    }
}