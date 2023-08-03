/**
* @description       : Clase de Web Service AutenticarSegmentoCliente & getSegmento
* @author            : Felipe Saavedra
* Ver   Date         Author                               Modification
* 1.0   03-17-2021   Felipe Saavedra					   Initial Version
* 2.0   12-29-2021   Camilo Villegas                       
**/

global class DEG_GetCategory_ws {
    
    public class OrquestInput {
        @InvocableVariable(required=false)
        public String TipoDocumento;
        @InvocableVariable(required=true)
        public String canalBot;
        @InvocableVariable(required=false)
        public String numeroDocumento;
        @InvocableVariable(required=true)
        public String conversationId;
    }
    
    @InvocableMethod(label='Get Category')
    public static List<String> getCategory(List<OrquestInput> lstOrquestInput){ 
        List<String> lstMessage= new List<String>();
        try {
            getAsyncCategory(JSON.serialize(lstOrquestInput));        
        } catch (Exception e) {
            System.debug('ERROR: '+e.getMessage());
            System.debug('ERROR Line: '+e.getLineNumber()); 
            lstMessage.add(e.getMessage());
        }
        return lstMessage;
    }

     /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: Method for calling get category Async
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/

    @future(Callout = true)
	public static void getAsyncCategory(String JSONOrquestInLst){
        List<OrquestInput> lstOrquestInput = (List<OrquestInput>)System.JSON.deserialize(JSONOrquestInLst, List<OrquestInput>.class);
        OrquestInput auxInput= lstOrquestInput[0];
        System.debug('##auxInput '+auxInput);
        List<String> lstMessage= new List<String>();
        Map<String, DEG_CanalBot__mdt> mdtcanalBotMap = DEG_CanalBot__mdt.getAll();
		DEG_CanalBot__mdt mdtCanalWeb = mdtcanalBotMap.get('DEG_CanalWeb');
		DEG_CanalBot__mdt mdtCanalWpp = mdtcanalBotMap.get('DEG_CanalWhatsapp');
		DEG_CanalBot__mdt mdtCanalFB = mdtcanalBotMap.get('DEG_CanalFacebook');
        DEG_CanalBot__mdt mdtCanalWebMipymes = mdtcanalBotMap.get('DEG_Web_Mipymes');

        DEG_CanalBot__mdt mdtCanal = [SELECT DEG_NombreCanalBot__c, DEG_Sistema__c, DEG_CorrelationId__c, DEG_ClientSessionId__c
                                        FROM DEG_CanalBot__mdt
                                        WHERE DEG_NombreCanalBot__c = :lstOrquestInput[0].canalBot
                                        LIMIT 1];

        DEG_WrapperFrames_cls.wrapRequestToken wsRequest = DEG_GetCategory_ws.initRequest(auxInput.TipoDocumento, mdtCanal, auxInput.numeroDocumento, auxInput.conversationId);
        
        Map<string,string> mapHeaders = new Map<string,string>();
        mapHeaders.put('Content-Type','application/json');
        mapHeaders.put('Authorization', 'Bearer ' + DEG_TokenFrames_cls.getTokenFrame());
        DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
        request.setHttpHeaders(mapHeaders);
        String body = JSON.Serialize(wsRequest);
        String reqRta =  DEG_GetCategory_ws.getDeserializeBodyRequest(body);
        request.setTextRequest(reqRta);
        request.setUri('DEG_URL_Connection_Category');
        request.setNamedCredential('DEG_botdevPortallteqaAzurewebsites');
        request.init();
		request.setTimeOut(120000);
        System.debug(JSON.serialize(wsRequest.WSRequestHeader));
        System.debug(JSON.serialize(wsRequest.WSRequestBody));
        LiveChatTranscript chat;
        MessagingSession msgSession; 
        try {
            System.debug('##request: '+request);
            HttpResponse response = request.execute();
            String rptBody = response.getBody();
            System.debug('##bodyRpta: '+rptBody);            
            DEG_WrapperFrames_cls.wrapResponseToken respRta = getDeserializeBodyResponse(rptBody);
            DEG_WrapperFrames_cls.WSResponseHeader respHeaderRta = respRta.WSResponseHeader;
            DEG_WrapperFrames_cls.WSResponseBody   respBodyRta = respRta.WSResponseBody;
            String chatPrefix = LiveChatTranscript.sObjectType.getDescribe().getKeyPrefix();
            String messagingPrefix = MessagingSession.sObjectType.getDescribe().getKeyPrefix();
            System.debug('##auxInput.canalBot '+auxInput.canalBot);		
            if(auxInput.conversationId.startsWith(chatPrefix)){
                chat = [SELECT DEG_UEN__c, DEG_SegmentoUEN__c, DEG_CategoriaCliente__c, DEG_Segmento__c 
                        FROM LiveChatTranscript 
                        WHERE Id =:auxInput.conversationId LIMIT 1];
            }
            else if(auxInput.conversationId.startsWith(messagingPrefix)){
                msgSession =  [ SELECT Id,DEG_Segmento__c,DEG_SegmentoUEN__c ,DEG_UEN__c,DEG_CategoriaCliente__c
                                FROM MessagingSession 
                                WHERE Id =: auxInput.conversationId LIMIT 1 ];
            }
       
            if(respHeaderRta.Service.status == 'OK' && response.getStatusCode() == 200){
                if(chat != null){
                    chat.DEG_UEN__c = respBodyRta.UEN;
                    chat.DEG_SegmentoUEN__c = respBodyRta.Segment_UEN;
                    chat.DEG_CategoriaCliente__c = respBodyRta.Category;
                    chat.DEG_Segmento__c = respBodyRta.Segment;
                }
                else if(msgSession != null){
                    msgSession.DEG_UEN__c = respBodyRta.UEN;
                    msgSession.DEG_SegmentoUEN__c = respBodyRta.Segment_UEN;
                    msgSession.DEG_CategoriaCliente__c = respBodyRta.Category;
                    msgSession.DEG_Segmento__c = respBodyRta.Segment;
                }
                lstMessage.add(respHeaderRta.Service.statusDetail[0].errorDetailCode);
            }else{
                if(chat != null){
                    chat.DEG_UEN__c = System.Label.DEG_Texto_NA;
                    chat.DEG_SegmentoUEN__c = System.Label.DEG_Texto_NA;
                    chat.DEG_CategoriaCliente__c = System.Label.DEG_CategoriaCliente;
                    chat.DEG_Segmento__c = System.Label.DEG_Texto_NA;
                }
                else if(msgSession != null){
                    msgSession.DEG_UEN__c = System.Label.DEG_Texto_NA;
                    msgSession.DEG_SegmentoUEN__c = System.Label.DEG_Texto_NA;
                    msgSession.DEG_CategoriaCliente__c = System.Label.DEG_CategoriaCliente;
                    msgSession.DEG_Segmento__c = System.Label.DEG_Texto_NA;
                }

                lstMessage.add(respHeaderRta.Service.statusDetail[0].errorDetailCode);
            }
            if(chat != null ) update chat;
            else if(msgSession != null )  update msgSession;
            System.debug('##Chat: '+chat);
            System.debug('##msgSession: '+msgSession);

        } catch (Exception e) {
            System.debug('Error Message: '+e.getMessage());
            System.debug('Error Line: '+e.getLineNumber());
        }
	}

        
    public static DEG_WrapperFrames_cls.wrapRequestToken initRequest(String TipoDocumento, DEG_CanalBot__mdt mdtCanal, String numeroDocumento, String conversationId)
    {
        DEG_WrapperFrames_cls.wrapRequestToken wsRequest = new DEG_WrapperFrames_cls.wrapRequestToken();
        DEG_WrapperFrames_cls.WSRequestHeader oWSRequestHeader = new DEG_WrapperFrames_cls.WSRequestHeader();
        DEG_WrapperFrames_cls.Systema oSystema = new DEG_WrapperFrames_cls.Systema();
        List<DEG_WrapperFrames_cls.Property> lProperty = new List<DEG_WrapperFrames_cls.Property>();
        DEG_WrapperFrames_cls.WSRequestBody requestBody = new DEG_WrapperFrames_cls.WSRequestBody();
        DEG_WrapperFrames_cls.Audit oAudit = new DEG_WrapperFrames_cls.Audit();
        
        oSystema.name = 'DIGITAL';
        oSystema.correlationID = mdtCanal.DEG_CorrelationId__c + conversationId;

        oWSRequestHeader.Systema = oSystema;
        oWSRequestHeader.lProperty = lProperty;
        
        requestBody.Document_Type = TipoDocumento;
        requestBody.Document_Number = numeroDocumento;
        oAudit.Canal = '1';
        oAudit.Id_Device = '1';
        oAudit.SO = '1';
        oAudit.IP_Address = '1';
        oAudit.IP_Latitude = '1';
        oAudit.IP_Longitude = '1';
        oAudit.WhatsApp_Phone_Number = '1';
        oAudit.Facebook_User = '1';
        oAudit.Twitter_User = '1';
        
        requestBody.Audit = oAudit;
        wsRequest.WSRequestBody = requestBody;
        wsRequest.WSRequestHeader = oWSRequestHeader;
        
        return wsRequest;
    }
    
    
    /*---------------------------------------------------------------------------------------------
    Autor:Felipe Saavedra 
    Descripción: Method is for deserialize response AutenticarSefmentoCliente:: ETB Segmentación
    --------------------------------------------------------------------------------------------*/
    public static DEG_WrapperFrames_cls.wrapResponseToken getDeserializeBodyResponse(String rptBody){
        
        rptBody = rptBody.replaceAll('Id', 'Id_wpr'); 
        rptBody = rptBody.replaceAll('Date', 'Fecha'); 
        rptBody = rptBody.replaceAll('Type', 'Tipo');
        rptBody = rptBody.replaceAll('System','Systema'); 
        
        DEG_WrapperFrames_cls.wrapResponseToken bodyRptaMessage = (DEG_WrapperFrames_cls.wrapResponseToken) JSON.deserialize(rptBody, DEG_WrapperFrames_cls.wrapResponseToken.class);
        
        return bodyRptaMessage;
    }
    /*---------------------------------------------------------------------------------------------
    Autor:Felipe Saavedra 
    Descripción: Method is for deserialize response AutenticarSefmentoCliente: ETB Segmentación
    --------------------------------------------------------------------------------------------*/
    public static String getDeserializeBodyRequest(String rptBody){ 
        rptBody = rptBody.replaceAll('Systema','System'); 
        return rptBody;
    }
    
}