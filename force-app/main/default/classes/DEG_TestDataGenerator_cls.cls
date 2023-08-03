/**
 * @description       : Class to create data for test class in the org
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 14-10-2021
 * @last modified by  : Brisleydi Calderon
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   03-29-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
@isTest
public with sharing class DEG_TestDataGenerator_cls {
public DEG_TestDataGenerator_cls() {}
/*---------------------------------------------------------------------------------------------
Autor: Harlinsson Chavarro (HCH)
Descripción: Genera usuarios segun lista de perfiles
@params: List<String> perfiles ,Boolean save (Insertar o no registro)
@return: List Usuarios
----------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------
Autor: Harlinsson Chavarro (HCH)
Descripción: Genera un string random
@params: Integer len (Longitud del String)
@return: String (String aleatorio)
----------------------------------------------------------------------------------------------*/
public static String generateRandomString(Integer len) {
    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    String randStr = '';
    while (randStr.length() < len) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
        randStr += chars.substring(idx, idx+1);
    }
    return randStr; 
}

/*---------------------------------------------------------------------------------------------
Autor: Harlinsson Chavarro (HCH)
Descripción: Genera un numero random
@params: Integer len (Longitud del String)
@return: String (String de numeros aleatorio)
----------------------------------------------------------------------------------------------*/
public static String generateRandomNumber(Integer len) {
    final String chars = '0123456789012345678901234567890123456789';
    String randStr = '';
    while (randStr.length() < len) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
        randStr += chars.substring(idx, idx+1);
    }
    return randStr; 
}

/*---------------------------------------------------------------------------------------------
Autor: Harlinsson Chavarro (HCH)
Descripción: Crea un chat
@params: String visitorId,  Boolean save (Indica si se guarda o no)
@return: Lead
----------------------------------------------------------------------------------------------*/
public static LiveChatTranscript createChat(String visitorId , Boolean save){
    LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                        FROM LiveChatButton 
                                        WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo' LIMIT 1];
    LiveChatTranscript chat = new LiveChatTranscript(
        Body = 'Hello World',
        DEG_AceptaTerminosCondiciones__c = true,
        DEG_ApellidoCliente__c = 'ETB',
        DEG_NombreCliente__c = 'ETB',
        DEG_NumeroDocCliente__c = '123456789',
        DEG_TelefonoCliente__c = '3333333333',
        DEG_TipoDocCliente__c = 'test',
        DEG_EmailCliente__c = 'test@test.com',
        LiveChatVisitorId = visitorId,
        DEG_SessionIdWatson__c = '2bbbb85f-c678-4db3-a3cd-4c1c87e1284e',
        DEG_ClientSessionWatsonId__c = 'Etb 12298791-1122211',
        LiveChatButtonId = liveChatButton.Id
    );
    if (save){
        insert chat;
    }
    return chat;
}

/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de un usuario
* ------------------------------------------------------------------------------------------------
* @author Brisleydi Calderon - b.calderon.seijas@accenture.com
* @date 2021-10-12
* @param Integer numUser
* @return List<User>
* ------------------------------------------------------------------------------------------------
*/
public static User createUser(){
    Id idProfile = [SELECT Id FROM Profile WHERE Name IN ('Standard User', 'Usuario estándar') LIMIT 1].Id;
    String strRandom = EncodingUtil.base64encode(crypto.generateAesKey(192)).substring(0, 8);
    User userObj = new User();
    userObj.ProfileId = idProfile;
    userObj.LastName = 'Prueba';
    userObj.Alias = strRandom;
    userObj.Email = strRandom + '@testprueba.com';
    userObj.UserName = strRandom + '@testetestpruebamail.com';
    userObj.EmailEncodingKey = 'UTF-8';
    userObj.LocaleSidKey = 'en_US';
    userObj.LanguageLocaleKey = 'en_US';
    userObj.TimeZoneSidKey = 'America/Los_Angeles';
    return userObj;
}

/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de un caso
* ------------------------------------------------------------------------------------------------
* @author Brisleydi Calderon - b.caldron.seijas@accenture.com
* @date 2021-10-12
* @param Id ownerId
* @param Integer numCase
* @return List<Case>
* ------------------------------------------------------------------------------------------------
*/
public static List<Case> createCase(Id ownerId, Integer numCase) {

    List<Case> lstCase = new List<Case>();
    if(numCase > 0) {
        for(Integer i=0;i<numCase;i++) {
            Case caseObj = new Case();
            caseObj.Origin = 'Canal Web Chat';
            caseObj.Status = 'En Proceso';
            caseObj.DEG_Segmento__c = 'Masivo';
            caseObj.OwnerId= ownerId;
            caseObj.Subject = 'Prueba';
            lstCase.add(caseObj);
        }
    }
    return lstCase;
}

    /**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de un caso de ventas
* ------------------------------------------------------------------------------------------------
* @author Nolvis Sanchez - n.sanchez.velasco@accenture.com
* @date 2022-01-20
* @param Id ownerId
* @param Integer numCase
* @return List<Case>
* ------------------------------------------------------------------------------------------------
*/
public static List<Case> createCaseVentas(Integer numCase) {

    Id recordTypeVentas =[SELECT id FROM RecordType WHERE developerName ='DEG_VENTAS'].Id;

    List<Case> lstCase = new List<Case>();
    if(numCase > 0) {
        for(Integer i=0;i<numCase;i++) {
            Case caseObj = new Case();
            caseObj.RecordTypeId =  recordTypeVentas;
            caseObj.Origin = 'Canal Web Ventas';
            caseObj.Status = 'Resuelto';
            caseObj.DEG_Pedido__c  = '087654';
            caseObj.DEG_Segmento__c = 'Masivo';
            caseObj.Subject = 'Prueba';
            caseObj.DEG_Nivel1__c = 'Venta Hogares';
            caseObj.DEG_Nivel2__c = 'FTTH';
            caseObj.DEG_Celular__c ='3123111111';
            caseObj.DEG_IDdeBacklanding__c ='4128';
            lstCase.add(caseObj);
        }
    }
    return lstCase;
}

/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de un registro para el objeto de ServiciosWeb__b
* ------------------------------------------------------------------------------------------------
* @author Nolvis Sanchez - n.sanchez.velasco@accenture.com
* @date 2022-01-20
* @param Id ownerId
* @param Integer numCase
* @return List<Case>
* ------------------------------------------------------------------------------------------------
*/

public static ServiciosWeb__c createEndpoint () {
        
            ServiciosWeb__c servicioWeb = new ServiciosWeb__c();
            servicioWeb.name = 'ActualizaLeads';
            servicioWeb.usuario__c ='vacio';
            servicioWeb.contrasena__c='vacio';
            servicioWeb.endPoint__c='vacio';
            servicioWeb.action__c='vacio';
            return servicioWeb;

    }
/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de una transcripción del chat
* ------------------------------------------------------------------------------------------------
* @author Brisleydi Calderon - b.caldron.seijas@accenture.com
* @date 2021-10-12
* @param Id caseId
* @param String visitorId
* @return List<LiveChatTranscript>
* ------------------------------------------------------------------------------------------------
*/
public static List<LiveChatTranscript> createLiveChatTranscrip(String visitorId, String caseId, Integer numChat){
    LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                        FROM LiveChatButton 
                                        WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo' LIMIT 1];

    List<LiveChatTranscript> lstLiveChatTransc = new List<LiveChatTranscript>();

    if(numChat > 0) {
        for(Integer i=0;i<numChat;i++) {
            LiveChatTranscript objLiveChatTransc = new LiveChatTranscript();
            objLiveChatTransc.Body = 'Hello World';
            objLiveChatTransc.DEG_AceptaTerminosCondiciones__c = true;
            objLiveChatTransc.DEG_ApellidoCliente__c = 'ETB';
            objLiveChatTransc.DEG_NombreCliente__c = 'ETB';
            objLiveChatTransc.DEG_NumeroDocCliente__c = '123456789';
            objLiveChatTransc.DEG_TelefonoCliente__c = '3333333333';
            objLiveChatTransc.DEG_TipoDocCliente__c = 'CC';
            objLiveChatTransc.DEG_EmailCliente__c = 'test@test.com';
            objLiveChatTransc.DEG_SessionIdWatson__c = '2bbbb85f-c678-4db3-a3cd-4c1c87e1284e';
            objLiveChatTransc.DEG_ClientSessionWatsonId__c = 'Etb 12298791-1122211';
            objLiveChatTransc.LiveChatButtonId = liveChatButton.Id;
            objLiveChatTransc.LiveChatVisitorId = visitorId;
            lstLiveChatTransc.add(objLiveChatTransc);
        }
    }                                 
    return lstLiveChatTransc;
}
/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de un usuario final de mensajería
* ------------------------------------------------------------------------------------------------
* @author Brisleydi Calderon - b.calderon.seijas@accenture.com
* @date 2021-10-12
* @return MessagingEndUser
* ------------------------------------------------------------------------------------------------
*/
public static MessagingEndUser createMessagingUser(){
    MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                    FROM MessagingChannel
                                    WHERE DeveloperName = 'DEG_LineadenegocioMasivoETB' LIMIT 1];
    
    MessagingEndUser msgEndUser = new MessagingEndUser();
    msgEndUser.Name = 'whatsapp:+573010000000';
    msgEndUser.MessagingPlatformKey = 'whatsapp:+573010000000';
    msgEndUser.MessagingChannelId =msgChannel.Id;
    msgEndUser.MessageType = 'WhatsApp';
    return msgEndUser;
}
/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de una sesión de mensajería
* ------------------------------------------------------------------------------------------------
* @author Brisleydi Calderon - b.calderon.seijas@accenture.com
* @date 2021-10-12
* @return MessagingSession
* ------------------------------------------------------------------------------------------------
*/
public static List<MessagingSession> createMessagingSession(Id msgEndUserId, Id caseId, Integer numChat){
    MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                    FROM MessagingChannel
                                    WHERE DeveloperName = 'DEG_LineadenegocioMasivoETB' LIMIT 1];
    List<MessagingSession> lstMsgSession = new List<MessagingSession>();
    if(numChat > 0) {        
        for(Integer i=0;i<numChat;i++) {           
            MessagingSession msgSession = new MessagingSession();
            msgSession.MessagingChannelId = msgChannel.Id;
            msgSession.MessagingEndUserId = msgEndUserId;
            msgSession.CaseId = caseId;
            msgSession.Status ='Active';
            lstMsgSession.add(msgSession);
        }
    }
    return lstMsgSession;
} 

    /**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de una messagig session sin caso
* ------------------------------------------------------------------------------------------------
* @author Nolvis Sanchez - n.sanchez.velasco@accenture.com
* @date 2022-01-07
* @param Id ownerId
* @param Integer numSrv
* @return List<Case>
* ------------------------------------------------------------------------------------------------
*/
public static List<MessagingSession> createMessagingSessionWithoutCase(Id msgEndUserId, Integer numChat){
    MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                    FROM MessagingChannel
                                    WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];
    List<MessagingSession> lstMsgSession = new List<MessagingSession>();
    if(numChat > 0) {        
        for(Integer i=0;i<numChat;i++) {           
            MessagingSession msgSession = new MessagingSession();
            msgSession.MessagingChannelId = msgChannel.Id;
            msgSession.MessagingEndUserId = msgEndUserId;
            msgSession.Status ='Active';
            lstMsgSession.add(msgSession);
        }
    }
    return lstMsgSession;
} 

/**
* ------------------------------------------------------------------------------------------------
* @description Método que simula la creación de un caso
* ------------------------------------------------------------------------------------------------
* @author Brisleydi Calderon - b.caldron.seijas@accenture.com
* @date 2021-10-12
* @param Id ownerId
* @param Integer numSrv
* @return List<Case>
* ------------------------------------------------------------------------------------------------
*/
/*public static List<DEG_CustomerSurvey__c> createSurveyCustomer(Id caseId, Integer numSrv) {

    List<DEG_CustomerSurvey__c> lstCustSrv = new List<DEG_CustomerSurvey__c>();
    if(numSrv > 0) {
        for(Integer i=0;i<numSrv;i++) {
            DEG_CustomerSurvey__c srvObj = new DEG_CustomerSurvey__c();
            srvObj.DEG_Channel__c = 'Masivo';
            srvObj.DEG_QuestionNumber__c = '1';
            srvObj.DEG_SubChannel__c = 'Canal Web Cha';
            srvObj.DEG_SurveyQuestion__c= '1. ¿Es la primera vez que nos contactas por chat para dar solución a tu requerimiento?';
            srvObj.DEG_SurveyAnswer__c = '1';
            srvObj.DEG_Case__c = caseId;
            lstCustSrv.add(srvObj);
        }
    }
    return lstCustSrv;
}*/
}