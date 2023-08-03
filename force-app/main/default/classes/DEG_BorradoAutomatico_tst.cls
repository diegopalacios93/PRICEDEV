/**************************************************************************************************************
* Globant M?xico
* @author           Edgar Miranda Francisco
* Project:          ETB
* Description:      Clase para prueba DEG_BorradoAutomatico_bch
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description     
*           -----   ----------      --------------------    ---------------   
* @version   1.0    19/Mayo/2020    Edgar Miranda           Clase Creada 
**************************************************************************************************************/

@IsTest
public class DEG_BorradoAutomatico_tst {
    @TestSetup    
    static void createData(){
        
        objPruebas_tst obj =new objPruebas_tst();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Principal').getRecordTypeId();
        // Id contactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('DEG_ContactosMasivos').getRecordTypeId();
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        System.debug(devRecordTypeId);
        insert cliente;
        
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.id;
        // contacto.RecordTypeId=contactRecordTypeId;
        insert contacto;
        
        Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        List<Case> casosLst = new List<Case>();
        
        for(Integer i=0;i<100;i++) {
            Case caso1=obj.objCase();
            caso1.AccountId=cliente.id;
            caso1.ContactId=contacto.id;
            caso1.RecordTypeId=devRecordTypeIdCase;
            caso1.DEG_SentToIntegration__c = true;
            caso1.DEG_GestionadoPor__c = 'Bot';
            casosLst.add(caso1);
        }
        for(Integer i=0;i<100;i++) {
            Case caso1=obj.objCase();
            caso1.AccountId=cliente.id;
            caso1.ContactId=contacto.id;
            caso1.RecordTypeId=devRecordTypeIdCase;
            caso1.DEG_SentToIntegration__c = true;
            caso1.DEG_GestionadoPor__c = 'Agente';
            casosLst.add(caso1);
        }
        insert casosLst;


        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
                                        FROM LiveChatButton 
                                        WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo' LIMIT 1];

        LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
        insert liveChatVisitor;


        List<LiveChatTranscript> chatLst = new List<LiveChatTranscript>();
        
        for(Integer i=0;i<500;i++) {
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
        
        MessagingChannel msgChannel = [ SELECT Id  
										FROM MessagingChannel 
										LIMIT 1];

                                        
                                        
        for(Integer i=0;i<500;i++) {
            MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+57312512'+String.valueOf(i) ,
                                                                MessagingPlatformKey = 'whatsapp:+57312512'+String.valueOf(i),
                                                                MessagingChannelId= msgChannel.Id,
                                                                MessageType = 'WhatsApp'  );
                                                           
            messagingUserMap.put(i,msgEndUser);
        }
        insert messagingUserMap.values();

        for(Integer i=0;i<500;i++) {
           
            MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
            MessagingEndUserId = messagingUserMap.get(i).Id,
            Status = 'Active' );
            messagingLst.add(msgSession);
        }
        insert messagingLst;
        
    }
    
    @IsTest
    public static void testBatchCase(){

        DEG_BorradoAutomatico_bch testBatch1 = new DEG_BorradoAutomatico_bch('Case');
        Test.startTest();
        Database.executeBatch(testBatch1);
        Test.stopTest();
        
    }
 
    @IsTest
    public static void testBatchMessaging(){
        DEG_BorradoAutomatico_bch testBatch2 = new DEG_BorradoAutomatico_bch('MessagingSession');
        Test.startTest();
        Database.executeBatch(testBatch2);
        Test.stopTest();

    }
    @IsTest
    public static void testBatchChat(){
        DEG_BorradoAutomatico_bch testBatch3 = new DEG_BorradoAutomatico_bch('LiveChatTranscript');
        Test.startTest();
        Database.executeBatch(testBatch3);
        Test.stopTest();
    }
    
    
    @IsTest
    public static void testSchedulable(){
        Test.startTest();
        System.schedule( 'Teste AnalisePlanoMKT', '0 30 0 * * ?', new DEG_BorradoAutomatico_sch());
        Test.stopTest();
    }
}