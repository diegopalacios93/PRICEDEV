/**
 * @description       : 
 * @author            : Pablo Arrieta
 * @group             : 
 * @last modified on  : 05-25-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   05-25-2021   Pablo Arrieta   Initial Version
**/
public with sharing class DEG_DatePicker_ctr {
    
    

    public class RequestInput {
        @AuraEnabled public String dateini {get;set;}
        @AuraEnabled public String dateend {get;set;}
        @AuraEnabled public String days {get;set;}
        @AuraEnabled public String dateVisita {get;set;}
        @AuraEnabled public String sessionId {get;set;}
        @AuraEnabled public String tokenWhatson  {get;set;}
    }

    @AuraEnabled
    public static String sendDateRange( RequestInput requestInput ) {
    system.debug('DEG_DatePicker_ctr-entro sendDateRange');
        
        String sResponse =  '{ '+
                            '"idResponse":"SuspencionConfirmada",'+
                            '"data":{'+
                            '"dataini":"'+requestInput.dateini +'",'+
                            '"dataend":"'+requestInput.dateend +'",'+
                            '"message":"'+requestInput.days + '"'+
                            '},'+
            				'"idConversacion":"'+requestInput.sessionID+'"'+
                            '}';
                
        DEG_ResponseFrames_ws.createFrameResponse(sResponse, '', RequestInput.tokenWhatson );
        System.debug(requestInput); 
        return sResponse;
    }
    @AuraEnabled
    public static String sendDate(RequestInput requestInput ) {
    system.debug('DEG_DatePicker_ctr-entro sendDate');

        String sResponse =  '{ '+
                            '"login": false ,'+
                            '"idResponse":"visita tecnica",'+
                            '"data":{'+
                            '"menssage":"'+requestInput.dateVisita +'"'+
                            '},'+
            				'"idConversacion":"'+requestInput.sessionID+'"'+
                            '}';
                
        DEG_ResponseFrames_ws.createFrameResponse(sResponse, '', RequestInput.tokenWhatson );
        System.debug(sResponse);    
        System.debug(requestInput); 
        return sResponse;
        /*
        .ajax({
        url: pratech.parly.urlMessage + 'api/send-message',
        dataType: 'json',
        type: 'POST',
        data: {
          idConversacion: pratech.parly.userBot.id,
          data: {
            login: false,
            menssage: Date,
          },
          palabraClave: 'visita tecnica',
          botId: pratech.parly.botName,
        },
      })
        */
    }

    @AuraEnabled
    public static String cancelDateRange(RequestInput requestInput ) {
    system.debug('DEG_DatePicker_ctr-entro cancelDateRange');

        String sResponse =  '{ '+
                            '"idResponse": "SuspensionCancelada",'+
                            '"login": false ,'+
                            '"menssage":"suspencion cancelada",'+
            				'"idConversacion":"'+requestInput.sessionID+'"'+
                            '}';
                
        
        DEG_ResponseFrames_ws.createFrameResponse(sResponse, '', RequestInput.tokenWhatson );
        System.debug(sResponse);
        System.debug(requestInput); 
        return sResponse;
        /*
        
        const tokenConversation = await this.tokenSendMessage(idConversation);
        const body = {
            "token": tokenConversation.data.respuesta.data,
            "context": {
                "response": {
                    "idResponse": "SuspensionCancelada",
                    "login": false,
                    "menssage": "suspencion cancelada"
                    
                }
            }
        };
        
        uri: 
        URL_SEND_MESSAGE=https://etb-bot.us-south.cf.appdomain.cloud/etb/api/external-notification
        POSTFIJO_BOT_ID=messages/send
        BOT_ID=etb_max_qa
        
        url: `${process.env.URL_SEND_MESSAGE}/${process.env.BOT_ID}/${process.env.POSTFIJO_BOT_ID}`,
         
        method: 'post',
        TOKEN_SEND_MESSAGE=ODJjMWRjMTYxODAyNGYzYzllMGQ4MTIyMDNmZjM3NDA6REJRUE1LWDRHNERYalE5emFTdnV1a3ZqcXEyUE1ObHZrTDhsN3RoVlhyQndVRGtIT3ZZdW5yT21Ba2t1WFlFRFNXdFU4UDZ3ODdsMElaZnAyaDAxbkVWOE1RSXpDT0E2aExHYw==

        headers: { 'Authorization': `Basic ${process.env.TOKEN_SEND_MESSAGE}`, 'Content-Type': 'application/json' },
            method: 'post',
            data: JSON.stringify(body)
        

        public async tokenSendMessage(idConversation) {

        const body = {
            "data": {
                "bot_session": idConversation,
                "bot_id": Endpoint.BOT_ID
            }
        };

        const configuracion = {
            url: `${process.env.URL_ENCRYPT_ID}`,
            headers: { 'Content-Type': 'application/json' },
            method: 'post',
            data: body
        };

        return await this.ejecutorLlamadoHttp.invocarPeticion(configuracion);
    }


        
        */
    
    }
    @AuraEnabled
    public static String cancelDate(RequestInput requestInput ) {
    system.debug('DEG_DatePicker_ctr-entro cancelDate');

        String sResponse =  '{ '+
                            '"login": false ,'+
                            '"menssage":"Cancelo visita tecnica",'+
          					'"idConversacion":"'+requestInput.sessionID+'"'+
                            '}';
                
        
        DEG_ResponseFrames_ws.createFrameResponse(sResponse, '', RequestInput.tokenWhatson );
        System.debug(sResponse);
        System.debug(requestInput); 
        return sResponse;
    /*
        https://Pratech-Etb-Auth-View-Qa.us-east.mybluemix.net/etbauth/
        url: pratech.parly.urlMessage + 'api/send-message',
        dataType: 'json',
        type: 'POST',
        data: {
          idConversacion: pratech.parly.userBot.id,
          data: {
            login: false,
            menssage: 'Cancelo visita tecnica',
          },
          palabraClave: 'visita tecnica',
          botId: pratech.parly.botName,
        },
      }
    
    */
    }

}