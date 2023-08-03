/**
 * @description       : 
 * @author            : j.martinez.mercado
 * @group             : 
 * @last modified on  : 05-05-2022
 * @last modified by  : j.martinez.mercado@accenture.com
**/
@isTest
public with sharing class DE_DataFactoryReports {
    public static Account createClientAccount(){
        Account cuenta = new Account(Name='Cliente', Phone='12345679');
        insert cuenta;
        return cuenta;
    }
    public static Contact createClientContact(Id accountId){
      Contact contacto = new Contact(AccountId=accountId, FirstName = 'dead', LastName='mau5',
                                     NumerodeIdentificacion__c='1000123123', MobilePhone='12345678', Direccion__c='test',
                                     IsTEST__c=True, Tipodedocumento__c='Cédula de ciudadanía', Estado__c='Activo');
      insert contacto;
      return contacto;
    }
    public static Account getAccount(String name, Boolean doInsert){
      Account a = new Account(name = name);
      if(doInsert){
        insert a;
      }
      return a;
    }
    public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
      Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId, Phone = '71951455');
      if(doInsert){
        insert c;
      }
      return c;
    }

    public static MessagingEndUser getClientUser(){
      Account clientAcc = createClientAccount();
      Contact clientCont = createClientContact(clientAcc.Id);
      MessagingEndUser objMsgUser = new MessagingEndUser();
      objMsgUser.ContactId = clientCont.Id;
      objMsgUser.MessagingChannelId = [SELECT Id FROM MessagingChannel WHERE MessageType LIKE 'W%' LIMIT 1].Id;
      objMsgUser.MessagingConsentStatus = 'ImplicitlyOptedIn';
      objMsgUser.MessageType = 'Text';//For SMS Channel
      /*The phone number or Facebook page ID associated with this Messaging end user.*/
      objMsgUser.MessagingPlatformKey = '+573229307878';
      objMsgUser.Name = 'Will';
      insert objMsgUser;
      return objMsgUser;
    }
    public static List<Contact> generateAccountWithContacts(Integer numContacts){
      Account a = getAccount('default account ltd', true);
      List<Contact> contacts = new List<Contact>();
      for(Integer i = 0; i < numContacts; i++){
        String contactName = 'contact' + i;
        contacts.add(getContact(a.id, contactName, contactName, false));
      }
      insert contacts;
      return contacts;
    }
      public static List<User> getUsers(Integer num){
        List<User> users = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Agentes / Analistas']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UserTestSss@acc.com');
        users.add(u);
        for (Integer i = 0; i <= num; i++) {
          u = new User(Alias = 'standt'+ i, Email='standarduser@testorg.com'+i, 
            EmailEncodingKey='UTF-8', LastName='Testing'+i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UsuarioTest'+i+'@acc.com');
        users.add(u);
        }
        insert users;
        return users;
      }

      public static List<Group> getGroups(Integer num){
        List<Group> uu = new List<Group>();
        Integer i = 1;
        while (uu.size() < num+1) {
          Group u = new Group(Name = 'Proveedor '+i, DeveloperName = 'DEG_Proveedor'+i);      
          uu.add(u);
          i += 1;
        }
        insert(uu);
        return uu;
      }
      public static List<GroupMember> getGroupMembers(List<User> users, List<Group> groups){
        List<GroupMember> gms = new List<GroupMember>();
        Integer lSize = users.Size();
        Integer gIndex = groups.size()-1; 
        Integer g = 0;
        for(Integer i = 0; i < lSize; i++){
          if(g == gIndex){
            g = 0;
          }
          GroupMember gm = new GroupMember(GroupId = groups[g].Id, UserOrGroupId = users[i].Id);
          gms.add(gm);
          g += 1;
        }
        insert gms;
        return gms;
      }

      public static List<Case> getCases(List<User> users){
        Id MasivoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        List<Case> cases = new List<Case>();
        Case caseObj = new Case();
        Integer lSize = users.size();
        for(Integer i= 0; i < lSize; i++){
          caseObj = new Case(
            RecordTypeId = MasivoRTId,
            OwnerId = users[i].Id,
            Status = 'Abandono',
            Origin = 'Canal WhatsApp Hogares',
            DEG_Segmento__c= 'Masivo');
            cases.add(caseObj);
          caseObj = new Case(
            RecordTypeId = MasivoRTId,
            OwnerId = users[i].Id,
            Status = 'Abandono',
            Origin = 'Canal Web Chat',
            DEG_Segmento__c= 'Masivo');
          cases.add(caseObj);
          caseObj = new Case(
            RecordTypeId = MasivoRTId,
            OwnerId = users[i].Id,
            Status = 'Resuelto',
            Origin = 'Canal WhatsApp Hogares',
            DEG_Segmento__c= 'Masivo');
            cases.add(caseObj);
          caseObj = new Case(
            RecordTypeId = MasivoRTId,
            OwnerId = users[i].Id,
            Status = 'Resuelto',
            Origin = 'Canal Web Chat',
            DEG_Segmento__c= 'Masivo');
          cases.add(caseObj);
        }
        System.debug('Casos: ' + cases);
        try {
          insert cases;
          System.debug('Casos insertados.');  
        } catch (Exception e) {
          System.debug('Error cases: '+ e);
        }
        return cases;
      }

      public static void generateData(List<User> users){
        objPruebas_tst obj =new objPruebas_tst();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Principal').getRecordTypeId();
        //Id contactRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('DEG_ContactosMasivos').getRecordTypeId();
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        System.debug(devRecordTypeId);
        insert cliente;
        
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.id;
        //contacto.RecordTypeId=contactRecordTypeId;
        insert contacto;
        
        Id devRecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        List<Case> casosLst = new List<Case>();
        
        for(Integer i=0;i<users.size();i++) {
            Case caso1=obj.objCase();
            caso1.AccountId=cliente.id;
            //caso1.ContactId=contacto.id;
            caso1.RecordTypeId=devRecordTypeIdCase;
            caso1.DEG_SentToIntegration__c = true;
            caso1.DEG_GestionadoPor__c = 'Bot';
            casosLst.add(caso1);
        }
        for(Integer i=0;i<users.size();i++) {
            Case caso1=obj.objCase();
            caso1.AccountId=cliente.id;
            //caso1.ContactId=contacto.id;
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
        Integer iti = 0;
        for(User u : users) {
            LiveChatTranscript chat = new LiveChatTranscript(
                                        OwnerId = u.Id,
                                        Body = 'Hello World',
                                        DEG_AceptaTerminosCondiciones__c = true,
                                        DEG_ApellidoCliente__c = 'ETB',
                                        DEG_NombreCliente__c = 'ETB',
                                        DEG_NumeroDocCliente__c = '123456789'+String.valueOf(iti),
                                        DEG_TelefonoCliente__c = '3333333333',
                                        DEG_TipoDocCliente__c = 'test',
                                        DEG_EmailCliente__c = 'test@test.com'+String.valueOf(iti),
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

                                        
                                        
        for(Integer i=0;i<users.size();i++) {
            MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+57312512'+String.valueOf(i) ,
                                                                MessagingPlatformKey = 'whatsapp:+57312512'+String.valueOf(i),
                                                                MessagingChannelId= msgChannel.Id,
                                                                MessageType = 'WhatsApp'  );
                                                           
            messagingUserMap.put(i,msgEndUser);
        }
        insert messagingUserMap.values();
        iti = 0;
        for(User u : users) {
            MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
            MessagingEndUserId = messagingUserMap.get(iti).Id,
            Status = 'Active',
            OwnerId = u.Id );
            messagingLst.add(msgSession);
            iti+= 1;
        }
        insert messagingLst;
      }
}