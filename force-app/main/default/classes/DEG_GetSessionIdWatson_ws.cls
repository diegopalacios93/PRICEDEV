/**************************************************************************************************
Desarrollado por:   Globant
Autor:              Harlinsson Chavarro (HCH)
Proyecto:           ETB S.A.
Descripción:        Clase para obtener el permiso de la integración con el orquestador (get SesionId or Token)

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    ---------------------------------------------------
1.0     2021-01-15      Harlinsson Chavarro     Creacion
2.0     2021-12-27      J.Camilo Villegas       Modificación
***************************************************************************************************/
public with sharing class DEG_GetSessionIdWatson_ws {
    // public DEG_GetSessionIdWatson_ws() {}

    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: inner class para obtener la rpta del orquestador y entregarla al Einstein Bot
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public class OrquestOutput {
        @InvocableVariable(required=false)
        public String sessionId;
        @InvocableVariable(required=false)
        public String textMessage='';
        @InvocableVariable(required=false)
        public String saludoBotEmpresas='';
        @InvocableVariable(required=false)
        public String saludoBotMipyme='';
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: 
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    public class OrquestInput {

        @InvocableVariable(required=true)
        public String transcriptId;
        @InvocableVariable(required=false)
        public String canalBot;
        @InvocableVariable(required=false)
        public String textClient;
    }
    /*---------------------------------------------------------------------------------------------
    Autor: Harlinsson Chavarro (HCH)
    Descripción: Test para probar losvalores iniciales
    @params: -----
    @return: -----
    ----------------------------------------------------------------------------------------------*/
    @InvocableMethod(label='Get Session Id')
    public static List<OrquestOutput> getSessionId(List<OrquestInput> inputLst) {
        DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
        Map<string,string> mapHeaders = new Map<string,string>();
        List<OrquestOutput> sessionIdOutLst = new List<OrquestOutput>();
        OrquestOutput sessionIdOutput = new OrquestOutput();
        String tokenWatson = '';

        DEG_CanalBot__mdt mdtCanal = [SELECT DEG_NombreCanalBot__c, DEG_Sistema__c, DEG_CorrelationId__c, DEG_ClientSessionId__c
		                              FROM DEG_CanalBot__mdt
		                              WHERE DEG_NombreCanalBot__c = :inputLst[0].canalBot
		                              LIMIT 1];

        if (inputLst[0].canalBot != null && inputLst[0].canalBot == 'WEBE') {
            sessionIdOutput.textMessage = System.label.DEG_Chat_Empresas;
            sessionIdOutput.saludoBotEmpresas = system.label.DEG_Chat_Empresas;
        }
        else if(inputLst[0].canalBot != null && inputLst[0].canalBot == 'WEBMP') {
            sessionIdOutput.textMessage = System.label.DEG_Chat_Mipymes;
            sessionIdOutput.saludoBotMipyme = system.label.DEG_Chat_Mipymes;
        }


        DEG_WrapperJSONBot_cls.responseSessionId bodyRptaSession = new DEG_WrapperJSONBot_cls.responseSessionId();
        //Start Create JSON and RequesT REST
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('sistema', mdtCanal.DEG_Sistema__c);
        gen.writeStringField('correlation_id', mdtCanal.DEG_CorrelationId__c + inputLst[0].transcriptId);
        gen.writeEndObject();    
        String jsonS = gen.getAsString();
        request.setNamedCredential('DEG_Bot_Transfer');
        request.setUri('DEG_EndpointSessionId');
        mapHeaders.put('Content-Type','application/json');
        
        if (Cache.Org.contains('tokenWatson')) {
            tokenWatson = (String)Cache.Org.get('tokenWatson');
        }
        else {
            System.debug('##No hay token');
            tokenWatson = DEG_GetTokenWatson_ws.callTokenWatson();
        }
        mapHeaders.put('token',tokenWatson);
        request.setHttpHeaders(mapHeaders);
        request.setTextRequest(jsonS); 
        request.init();
        System.debug('##request' + request);

        //End Create JSON and RequesT REST
        HttpResponse response = request.execute();
        //Deseralize rpta REST
        String rptBody = response.getBody();
        System.debug('##rptBody' + rptBody);
        if ( response.getStatusCode() == 200){
            bodyRptaSession = (DEG_WrapperJSONBot_cls.responseSessionId )JSON.deserialize(rptBody, DEG_WrapperJSONBot_cls.responseSessionId.class); 
            sessionIdOutput.sessionId = bodyRptaSession.data.session_id;
            sessionIdOutLst.add(sessionIdOutput);
            System.debug('##sessionIdOutLst' + sessionIdOutLst);
            return sessionIdOutLst;
        }
        if ( response.getStatusCode() == 403){
            DEG_GetTokenWatson_ws.callTokenWatson();
            return getSessionId(inputLst) ;
        }
        return null;
    }

}