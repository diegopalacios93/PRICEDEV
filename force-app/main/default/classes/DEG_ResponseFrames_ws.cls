/**
* Globant Colombia
* @author           Javier Tibamoza
* Proyect:          ETB
* Description:      Clase REST para recibir la respuesta de los iFrames
* Changes (Version)
* -------------------------------------
*            No.    Fecha           Autor                           Descripción        
*            ----   ----------      ---------------------------     -------------    
* @version   1.0    02-03-2021      Javier Tibamoza                 Class created
*************************************************************************************/
@RestResource(urlMapping='/response_frames/*')
global without sharing class DEG_ResponseFrames_ws {
    /** 
    * @definition:
    * @Param:
    */
     global static response createFrameResponse( String sResponse, String sessionWatsonId, String tokenWhatson ) {
         system.debug('sResponse: JohanEntrada');
         return getCallout( sResponse, sessionWatsonId, tokenWhatson );
     }
    /** 
    * @definition:
    * @Param: sResponse: JSON; sessionWatsonId
    */
    @HttpPost
    global static response createFrameResponse() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String sResponse = body.toString().trim();
        system.debug('sResponseAcc'+ sResponse);
        return getCallout( sResponse, '', '');
    }
    /** 
    * @definition: Generic Call Out
    * @Param: sResponse: JSON; sessionWatsonId; tokenWatson
    */
    global static response getCallout( String sResponse, String sessionWatsonId, String tokenWhatson ) {
         System.debug('##getCallout sResponse: '+sResponse+' sessionWatsonId: '+sessionWatsonId+' tokenWhatson: '+tokenWhatson);
         response oRes = new response();
         Map<String, Object> owrapRequestFrameMap;
         String token = '';
         String idConversation = '';
         String cellNumber = '';
         String idConversationInit = '';
         String MessagingChannelId = '';
         List<LiveChatTranscript> lLiveChatTranscript;
         List<MessagingSession> msgSessionLst;
         String idMessaging = '';
         String prefixClient = '';
         String canalBot = '';   
         try{
             //LLAMAR AL ORQUESTADOR
             if( sessionWatsonId == '' ){
                 owrapRequestFrameMap = (Map<String, Object>)JSON.deserializeUntyped(sResponse);
                 System.debug('##owrapRequestFrameMap '+owrapRequestFrameMap);   
                 idConversation = String.valueOf(owrapRequestFrameMap.get('idConversacion'));
                 idConversationInit = idConversation;
                 System.debug('##idConversation '+idConversation);   
                 
                 if(idConversation.contains('Etb')){
                     prefixClient = searchPrefixClientSession('WEB');
                     lLiveChatTranscript = DEG_HelperLiveChatTranscript_cls.getLiveChatTranscript(idConversation);
                     if( lLiveChatTranscript != null ){
                         List<DEG_ConsumeOrquestadorAsync_ws.Input> OrquestInLst = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
                         DEG_ConsumeOrquestadorAsync_ws.Input OrquestIn = new DEG_ConsumeOrquestadorAsync_ws.Input();
                         OrquestIn.canalBot = 'WEB';
                         canalBot = 'WEB';
                         sessionWatsonId = lLiveChatTranscript[0].DEG_SessionIdWatson__c;
                         idConversation = String.valueOf( lLiveChatTranscript[0].DEG_ClientSessionWatsonId__c.remove(prefixClient) ).trim(); //edit 31/03
                         OrquestIn.sessionId = sessionWatsonId;
                         OrquestIn.textClient = '';
                         OrquestIn.conversationId = idConversation;
                         OrquestInLst.add( OrquestIn );
                         System.debug('##OrquestInLst response frame out '+OrquestInLst);
                         DEG_ConsumeOrquestadorAsync_ws.makeGetCallout(OrquestInLst, sResponse);
                        }
                    }
                    else{
                        List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> OrquestInWppLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
                        DEG_ConsumeOrquestadorAsyncWpp_ws.Input OrquestWppIn = new DEG_ConsumeOrquestadorAsyncWpp_ws.Input();
                        List<String> lstIdMessaging = String.valueOf(owrapRequestFrameMap.get('idMessaging')).split('-');
                        idMessaging = lstIdMessaging[2];
                        // String templateRpta = 'DEG_ResponseFrame';
                        System.debug('##Es wpp');
                        if(idConversation.contains('whatsApp_empresas')){
                            prefixClient = searchPrefixClientSession('WPPE');
                            OrquestWppIn.canalBot = 'WPPE';
                            canalBot = 'WPPE';
                        }
                        else if(idConversation.contains('whatsapp_')){
                            prefixClient = searchPrefixClientSession('WPP');
                            OrquestWppIn.canalBot = 'WPP';
                            canalBot = 'WPP';
                            
                        }
                        System.debug('##prefixClient '+prefixClient);  
                        msgSessionLst = getMessagingSession(idMessaging);
                        System.debug('##else msgSessionLst '+msgSessionLst);
                        if( !msgSessionLst.isEmpty() ){
                      
                         
                            cellNumber  =  msgSessionLst[0].DEG_ClientSessionWatsonId__c.remove(prefixClient); //edit 31/03WPP WHATS_312
                           
                            System.debug('## getMessagingSessionId idConversation '+idConversation);
                            
                            OrquestWppIn.sessionId = msgSessionLst[0].DEG_SessionIdWatson__c;
                            OrquestWppIn.textClient = '';
                            OrquestWppIn.conversationId = msgSessionLst[0].Id;
                            OrquestInWppLst.add( OrquestWppIn );
                            System.debug('##OrquestInWppLst response frame out '+OrquestInWppLst);
                            DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(OrquestInWppLst, sResponse);
                    }
                    
                 }
            }
             oRes = new response( 'OK', true, 200 );
             System.debug('##oRes: '+oRes);
         }catch( Exception ex ){
             oRes = new response( ex.getMessage(), false, 500 );
             System.debug('##Error oRes: '+oRes);
             System.debug('##Error LineNumber: '+ex.getLineNumber());
        }
        return oRes;
    
    }
    
    /**
    * @definition: 
    * @param: 
    */ 
 

    public static List<MessagingSession> getMessagingSession(String idMessaging) {
        List<MessagingSession> lstMessagingSession = [
            SELECT Id, DEG_SessionIdWatson__c, DEG_ClientSessionWatsonId__c,DEG_TokenWatson__c
            FROM MessagingSession
            WHERE Id =: idMessaging 
        	ORDER BY CreatedDate ASC NULLS FIRST 
            LIMIT 1];

        return lstMessagingSession;
    }

    /**
    * @definition: 
    * @param: 
    */ 
    public static String searchPrefixClientSession( String canalBot ){
        String prefixClient =  [SELECT DEG_ClientSessionId__c
										FROM DEG_CanalBot__mdt
										WHERE DEG_NombreCanalBot__c = :canalBot
										LIMIT 1].DEG_ClientSessionId__c;

        
        return prefixClient;
    }
    /** 
    * @definition:
    */
    global class response {

        global String sMsn;
        global Boolean blResponse;
        global Integer iCode;

        global response(){
            this.sMsn = '';
            this.blResponse = false;
            this.iCode = 0;
        }

        global response(String strMsn, Boolean blRes, Integer intCode){
            this.sMsn = strMsn;
            this.blResponse = blRes;
            this.iCode = intCode;
        }
    }
}