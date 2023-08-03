/**************************************************************************************************************
* Globant M?xico
* @author           Edgar Miranda Francisco
* Project:          ETB
* Description:      Clase para prueba DEG_BorradoAutomatico_bch
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                      Description     
*           -----   ----------      --------------------        ---------------   
* @version   1.0    19/Mayo/2021     Edgar Miranda               Clase Creada 
* @version   1.1    09/Julio/2021    Harlinsson Chavarro(HCH)    Clase modifcadas para trabajo masivo 
**************************************************************************************************************/

@IsTest
public class DEG_GetChatsCases_tst {
    @TestSetup    
    static void createData(){
        
        objPruebas_tst obj =new objPruebas_tst();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Principal').getRecordTypeId();
        // Id contactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('DEG_ContactosMasivos').getRecordTypeId();

        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        insert cliente;
        
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.id;
        // contacto.RecordTypeId=contactRecordTypeId;
        insert contacto;
        
        Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
        List<Case> casosLst = new List<Case>();
        
        for(Integer i=0;i<1000;i++) {
            Case caso1=obj.objCase();
            caso1.AccountId=cliente.id;
            caso1.ContactId=contacto.id;
            caso1.RecordTypeId=devRecordTypeIdCase;
            caso1.DEG_SentToIntegration__c = true;
            casosLst.add(caso1);
        }
        insert casosLst;


        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                        FROM LiveChatButton 
                                        WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo' LIMIT 1];

        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
        insert liveChatVisitor;


        List<LiveChatTranscript> chatLst = new List<LiveChatTranscript>();
        
        for(Integer i=0;i<1000;i++) {
            LiveChatTranscript chat = new LiveChatTranscript(
                                        Body = 'Hello World',
                                        DEG_AceptaTerminosCondiciones__c = true,
                                        DEG_ApellidoCliente__c = 'ETB',
                                        DEG_NombreCliente__c = 'ETB',
                                        DEG_NumeroDocCliente__c = '123456789'+String.valueOf(i),
                                        DEG_TelefonoCliente__c = '3333333333',
                                        DEG_TipoDocCliente__c = 'test',
                                        DEG_EmailCliente__c = 'test@test.com'+String.valueOf(i),
                                        LiveChatVisitorId = liveChatVisitor.Id,
                                        DEG_SessionIdWatson__c = '2bbbb85f-c678-4db3-a3cd-4c1c87e1284e',
                                        DEG_ClientSessionWatsonId__c = 'Etb 12298791-1122211',
                                        LiveChatButtonId = liveChatButton.Id);
            chatLst.add(chat);
        }
        insert chatLst;
        List<MessagingSession> messagingLst = new List<MessagingSession>();
        Map<Integer,MessagingEndUser> messagingUserMap = new Map<Integer,MessagingEndUser>();
        
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];

                                        
                                        
        for(Integer i=0;i<1000;i++) {
            MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+57312512'+String.valueOf(i) ,
                                                                MessagingPlatformKey = 'whatsapp:+57312512'+String.valueOf(i),
                                                                MessagingChannelId= msgChannel.Id,
                                                                MessageType = 'WhatsApp'  );
                                                           
            messagingUserMap.put(i,msgEndUser);
        }
        insert messagingUserMap.values();

        for(Integer i=0;i<1000;i++) {
           
            MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
            MessagingEndUserId = messagingUserMap.get(i).Id,
            Status = 'Active' );
            messagingLst.add(msgSession);
        }
        insert messagingLst;
        
    }
    
    @IsTest
    public static void test_sentToIntegration(){
      
        List<String> ids = new List<String>();
        
        for(Case s : [SELECT Id FROM Case]){
            ids.add(s.id);
        }
        for(MessagingSession m : [SELECT Id FROM MessagingSession]){
            ids.add(m.id);
        }
        for(LiveChatTranscript c : [SELECT Id FROM LiveChatTranscript]){
            ids.add(c.id);
        }
        Test.startTest();
        DEG_GetChatsCases_ws.sentToIntegration(ids);
        Test.stopTest();

        
    }
    
    @IsTest
    public static void test_getChats(){ 
        DEG_GetChatsCases_ws.responseService clsTest = new DEG_GetChatsCases_ws.responseService('OK', 0, null,null);
        Test.startTest();
        DEG_GetChatsCases_ws.getChats();
        Test.stopTest();       
    }
}