/**
 * @description       : 
 * @author            : Pablo Arrieta
 * @group             : 
 * @last modified on  : 08-25-2021
 * @last modified by  : Pablo Arrieta
**/
/**
 * @description       : 
 * @author            : Mary Florio
 * @group             : 
 * @last modified on  : 01-12-2021
 * @last modified by  : Mary Florio
**/
@isTest
private class DEG_ConsultaLandingWpp_tst {

    @TestSetup
  static void makeData(){
        
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
        
    MessagingEndUser msgEndUser= new MessagingEndUser(Name = 'whatsapp:+573205672603' ,
                              MessagingPlatformKey = 'whatsapp:+573205672603',
                              MessagingChannelId= msgChannel.Id,
                              MessageType = 'WhatsApp');
    insert msgEndUser;
    
    MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
                              MessagingEndUserId = msgEndUser.Id,
                                                            DEG_TelefonoCliente__c = '3205672603',
                              Status = 'Active');
        
        insert msgSession;
        
  }
   
   @isTest
    static void getQueueReinjection(){
        String tipoRegistroCuenta = Schema.sObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        Account cuenta = new Account(Name='Digital Engagement NO BORRAR', Phone='12345678', RecordTypeId=tipoRegistroCuenta);
        Insert cuenta;
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        Contact contacto = new Contact(FirstName='pedro12', LastName='romero2', DEG_Numero_Celular__c='23344435',
                                       NumerodeIdentificacion__c='312121222',Tipodedocumento__c='Cédula de ciudadanía', 
                                       RecordTypeId=idrec, AccountId=cuenta.id, DEG_groupReinjection__c='DEG_Ventasreinyecion1');
        insert contacto;
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                       FROM MessagingChannel
                                       WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
        MessagingEndUser msgEndUserRein= new MessagingEndUser(Name = 'whatsapp:+57111111111' ,
                                                              MessagingPlatformKey = 'whatsapp:+57111111111',
                                                              MessagingChannelId= msgChannel.Id,
                                                              MessageType = 'WhatsApp',
                                                              ContactId = contacto.Id);
        insert msgEndUserRein;
        MessagingSession msgSessionRein = new MessagingSession( MessagingChannelId= msgChannel.Id,
                                                               MessagingEndUserId = msgEndUserRein.Id,
                                                               DEG_TelefonoCliente__c = '111111111',
                                                               Status = 'Active');
        insert msgSessionRein;
        DEG_ConsultaLandingWpp_cls.Input input = new DEG_ConsultaLandingWpp_cls.Input();
        input.idMessaging = msgSessionRein.Id;
        input.usuarioFinal = msgEndUserRein.Id;
        Test.startTest();
        List<DEG_ConsultaLandingWpp_cls.Output> outputLst = DEG_ConsultaLandingWpp_cls.getQueue(new List<DEG_ConsultaLandingWpp_cls.Input>{input});
        contacto.DEG_CumpleReinyeccion__c = 'NO';
        update contacto;
        outputLst = DEG_ConsultaLandingWpp_cls.getQueue(new List<DEG_ConsultaLandingWpp_cls.Input>{input});
        Test.stopTest();
    }
    
    @isTest
    static void getQueueWithCaseTest() {

        String idMsg = [SELECT Id FROM MessagingSession LIMIT 1].Id;

        List<DEG_ConsultaLandingWpp_cls.Input> inputLst = new List<DEG_ConsultaLandingWpp_cls.Input>();
        DEG_ConsultaLandingWpp_cls.Input input = new DEG_ConsultaLandingWpp_cls.Input();
        input.textClient = '1';
        input.idMessaging = idMsg;
        input.usuarioFinal = [SELECT Id FROM MessagingEndUser LIMIT 1].Id;
        inputLst.add(input);

        List<DEG_OpcionLanding__mdt> landingMDT = [SELECT Id, DEG_Opcion__c, DeveloperName, DEG_Cola__c
                                                    FROM DEG_OpcionLanding__mdt 
                                                    WHERE DEG_Opcion__c = '1' LIMIT 1];
        List<Group> cola = [SELECT Id, Name  FROM Group 
                                WHERE Type = 'Queue' AND DeveloperName =: landingMDT[0].DEG_Cola__c LIMIT 1];
        
        
         
       

        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
        
        Case parentCase = new Case();
        
        parentCase.RecordTypeId = ventasRTId;
        parentCase.DEG_OrigendelaVenta__c = 'Ventas_Hogares';
        parentCase.DEG_Celular__c = '3205672603';
        parentCase.DEG_IDdeBacklanding__c = 'Test_id_back';
        parentCase.DEG_Campana__c = 'Campaña_ventas_1';
        parentCase.DEG_Fuente__c = 'fuentes_ventas_1';
        parentCase.DEG_Medio__c = 'medio_prueba';
        parentCase.DEG_Oferta__c = 'Oferta prueba';
        parentCase.DEG_EmailCliente__c = 'pablo@prueba.com';
        parentCase.DEG_FechaRegistroLead__c = '12/08/2021';
        parentCase.DEG_HoraRegistroLead__c = '3:10 PM';
        parentCase.Origin = 'Canal WhatsApp Ventas';
        parentCase.Status = 'Contactar Prospecto';
        parentCase.DEG_Atencion_Cliente_Ventas__c = true;
        parentCase.SourceId = idMsg;
        parentCase.DEG_IdCola__c = landingMDT[0].DeveloperName;
        parentCase.DEG_PendienteOutbound__c = true;
        parentCase.DEG_Cliente_Genera_Interaccion_WhatsApp__c = 'SI';
        parentCase.ParentId = NULL;
        insert parentCase;

            
        Test.startTest();
        List<DEG_ConsultaLandingWpp_cls.Output> outputLst = DEG_ConsultaLandingWpp_cls.getQueue(inputLst);
        Test.stopTest();
        
    }
    
    
    
    @isTest
     static void casoExistente () {


        String idMsg = [SELECT Id FROM MessagingSession LIMIT 1].Id;


        MessagingChannel msgChannel = [SELECT Id, DeveloperName
        FROM MessagingChannel
        WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];

        

        MessagingEndUser msgUser = new MessagingEndUser(Name = 'whatsapp:+573133739527' ,
                              MessagingPlatformKey = 'whatsapp:+57573133739527',
                              MessagingChannelId= msgChannel.Id,
                                                            DEG_ExistUser__c = true,
                              MessageType = 'WhatsApp');

          insert msgUser;



        List<DEG_ConsultaLandingWpp_cls.Input> inputLst = new List<DEG_ConsultaLandingWpp_cls.Input>();
        DEG_ConsultaLandingWpp_cls.Input input = new DEG_ConsultaLandingWpp_cls.Input();
        input.textClient = '1';
        input.idMessaging = idMsg;
        input.usuarioFinal = msgUser.Id;
        inputLst.add(input);

        List<DEG_OpcionLanding__mdt> landingMDT = [SELECT Id, DEG_Opcion__c, DeveloperName, DEG_Cola__c
                                                    FROM DEG_OpcionLanding__mdt 
                                                    WHERE DEG_Opcion__c = '1' LIMIT 1];
        List<Group> cola = [SELECT Id, Name  FROM Group 
                                WHERE Type = 'Queue' AND DeveloperName =: landingMDT[0].DEG_Cola__c LIMIT 1];


        Case parentCase = new Case();
        
        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();

        parentCase.RecordTypeId = ventasRTId;
        parentCase.DEG_OrigendelaVenta__c = 'Ventas_Hogares';
        parentCase.DEG_Celular__c = '573133739527';
        parentCase.DEG_IDdeBacklanding__c = 'Test_id_back';
        parentCase.DEG_Campana__c = 'Campaña_ventas_1';
        parentCase.DEG_Fuente__c = 'fuentes_ventas_1';
        parentCase.DEG_Medio__c = 'medio_prueba';
        parentCase.DEG_Oferta__c = 'Oferta prueba';
        parentCase.DEG_EmailCliente__c = 'pablo@prueba.com';
        parentCase.DEG_FechaRegistroLead__c = '12/08/2021';
        parentCase.DEG_HoraRegistroLead__c = '3:10 PM';
        parentCase.Origin = 'Canal WhatsApp Ventas';
        parentCase.Status = 'Contactar Prospecto';
        parentCase.SourceId = idMsg;
        parentCase.DEG_IdCola__c = landingMDT[0].DeveloperName;
        parentCase.DEG_PendienteOutbound__c = true;
        parentCase.ParentId = Null; 
        insert parentCase;

Test.startTest();
List<DEG_ConsultaLandingWpp_cls.Output> outputLst = DEG_ConsultaLandingWpp_cls.getQueue(inputLst);
Test.stopTest();
     }


    
    
   @isTest
     static void casoResuelto () {


        String idMsg = [SELECT Id FROM MessagingSession LIMIT 1].Id;


        MessagingChannel msgChannel = [SELECT Id, DeveloperName
        FROM MessagingChannel
        WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];

        

        MessagingEndUser msgUser = new MessagingEndUser(Name = 'whatsapp:+573133739527' ,
                              MessagingPlatformKey = 'whatsapp:+57573133739527',
                              MessagingChannelId= msgChannel.Id,
                                                            DEG_ExistUser__c = true,
                              MessageType = 'WhatsApp');

          insert msgUser;



        List<DEG_ConsultaLandingWpp_cls.Input> inputLst = new List<DEG_ConsultaLandingWpp_cls.Input>();
        DEG_ConsultaLandingWpp_cls.Input input = new DEG_ConsultaLandingWpp_cls.Input();
        input.textClient = '1';
        input.idMessaging = idMsg;
        input.usuarioFinal = msgUser.Id;
        inputLst.add(input);

        List<DEG_OpcionLanding__mdt> landingMDT = [SELECT Id, DEG_Opcion__c, DeveloperName, DEG_Cola__c
                                                    FROM DEG_OpcionLanding__mdt 
                                                    WHERE DEG_Opcion__c = '1' LIMIT 1];
        List<Group> cola = [SELECT Id, Name  FROM Group 
                                WHERE Type = 'Queue' AND DeveloperName =: landingMDT[0].DEG_Cola__c LIMIT 1];

         
  

        Case parentCase = new Case();
        
        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();

        parentCase.RecordTypeId = ventasRTId;
        parentCase.DEG_OrigendelaVenta__c = 'Ventas_Hogares';
        parentCase.DEG_Celular__c = '573133739527';
        parentCase.DEG_IDdeBacklanding__c = 'Test_id_back';
        parentCase.DEG_Campana__c = 'Campaña_ventas_1';
        parentCase.DEG_Fuente__c = 'fuentes_ventas_1';
        parentCase.DEG_Medio__c = 'medio_prueba';
        parentCase.DEG_Oferta__c = 'Oferta prueba';
        parentCase.DEG_EmailCliente__c = 'pablo@prueba.com';
        parentCase.DEG_FechaRegistroLead__c = '12/08/2021';
        parentCase.DEG_HoraRegistroLead__c = '3:10 PM';
        parentCase.Origin = 'Canal WhatsApp Ventas';
        parentCase.Status = 'Resuelto';
        parentCase.SourceId = idMsg;
        parentCase.DEG_IdCola__c = landingMDT[0].DeveloperName;
        parentCase.DEG_PendienteOutbound__c = true;
        parentCase.ParentId = NULL;
       
        insert parentCase;
                                                
         

Test.startTest();
List<DEG_ConsultaLandingWpp_cls.Output> outputLst = DEG_ConsultaLandingWpp_cls.getQueue(inputLst);
Test.stopTest();
     }
  
    
     @isTest
    static void getQueueWithCaseTxtTest() {

        
    MessagingChannel msgChannel1 = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
        
    MessagingEndUser msgEndUser1= new MessagingEndUser(Name = 'whatsapp:+573001234567' ,
                              MessagingPlatformKey = 'whatsapp:+573001234567',
                              MessagingChannelId= msgChannel1.Id,
                              MessageType = 'WhatsApp');
    insert msgEndUser1;
    
    MessagingSession msgSession1 = new MessagingSession( MessagingChannelId= msgChannel1.Id,
                              MessagingEndUserId = msgEndUser1.Id,
                                                           DEG_TelefonoCliente__c = '3001234567',
                              Status = 'Active');
        
        insert msgSession1;
        
        
        String idMsg = msgSession1.Id;

        List<DEG_ConsultaLandingWpp_cls.Input> inputLst = new List<DEG_ConsultaLandingWpp_cls.Input>();
        DEG_ConsultaLandingWpp_cls.Input input = new DEG_ConsultaLandingWpp_cls.Input();
        input.textClient = 'Hola';
        input.idMessaging = msgSession1.Id;
        input.usuarioFinal = msgEndUser1.Id;//[SELECT Id FROM MessagingEndUser LIMIT 1].Id;
        inputLst.add(input);

       List<Group> colaLanding = [SELECT Id, Name, DeveloperName  FROM Group 
                                WHERE Type = 'Queue' AND DeveloperName =: 'DEG_VentasHogaresWhatsApp' LIMIT 1];
 

        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
        
        Case parentCase = new Case();
        
        parentCase.RecordTypeId = ventasRTId;
        parentCase.DEG_OrigendelaVenta__c = 'Ventas_Hogares';
        parentCase.DEG_Celular__c = '3001234567';
        parentCase.DEG_IDdeBacklanding__c = 'Test_id_back';
        parentCase.DEG_Campana__c = 'Campaña_ventas_1';
        parentCase.DEG_Fuente__c = 'fuentes_ventas_1';
        parentCase.DEG_Medio__c = 'medio_prueba';
        parentCase.DEG_Oferta__c = 'Oferta prueba';
        parentCase.DEG_EmailCliente__c = 'Mary@prueba.com';
        parentCase.DEG_FechaRegistroLead__c = '14/02/2021';
        parentCase.DEG_HoraRegistroLead__c = '7:10 PM';
        parentCase.Origin = 'Canal WhatsApp Ventas';
        parentCase.DEG_InteraciondelUsuario__c = 'SI';
        parentCase.DEG_Atencion_Cliente_Ventas__c = true;
        parentCase.Status = 'Contactar Prospecto';
        parentCase.SourceId = idMsg;
        parentCase.DEG_IdCola__c = colaLanding[0].DeveloperName;
        parentCase.DEG_PendienteOutbound__c = true;
        parentCase.DEG_InteraciondelUsuario__c = 'SI';
        parentCase.ParentId = NULL;
        insert parentCase;
            
        Test.startTest();
        List<DEG_ConsultaLandingWpp_cls.Output> outputLst = DEG_ConsultaLandingWpp_cls.getQueue(inputLst);
        Test.stopTest();
        
    }
   
      @isTest
    static void getQueueWithCaseLandingnullTest() {

        String idMsg = [SELECT Id FROM MessagingSession LIMIT 1].Id;

        List<DEG_ConsultaLandingWpp_cls.Input> inputLst = new List<DEG_ConsultaLandingWpp_cls.Input>();
        DEG_ConsultaLandingWpp_cls.Input input = new DEG_ConsultaLandingWpp_cls.Input();
        input.textClient = '10';
        input.idMessaging = idMsg;
        input.usuarioFinal = [SELECT Id FROM MessagingEndUser LIMIT 1].Id;
        inputLst.add(input);

        
        
        List<Group> colaLanding = [SELECT Id, Name, DeveloperName  FROM Group 
                                WHERE Type = 'Queue' AND DeveloperName =: 'DEG_VentasHogaresWhatsApp' LIMIT 1];
 
       

        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
        
        Case parentCase = new Case();
        
        parentCase.RecordTypeId = ventasRTId;
        parentCase.DEG_OrigendelaVenta__c = 'Ventas_Hogares';
        parentCase.DEG_Celular__c = '3133739527';
        parentCase.DEG_IDdeBacklanding__c = 'Test_id_back';
        parentCase.DEG_Campana__c = 'Campaña_ventas_1';
        parentCase.DEG_Fuente__c = 'fuentes_ventas_1';
        parentCase.DEG_Medio__c = 'medio_prueba';
        parentCase.DEG_Oferta__c = 'Oferta prueba';
        parentCase.DEG_EmailCliente__c = 'Mary@prueba.com';
        parentCase.DEG_FechaRegistroLead__c = '14/02/2021';
        parentCase.DEG_HoraRegistroLead__c = '7:10 PM';
        parentCase.Origin = 'Canal WhatsApp Ventas';
        parentCase.DEG_InteraciondelUsuario__c = 'NO';
        parentCase.DEG_Cliente_Genera_Interaccion_WhatsApp__c ='NO';
        parentCase.Status = 'Contactar Prospecto';
        parentCase.SourceId = idMsg;
        parentCase.DEG_IdCola__c = colaLanding[0].DeveloperName;
        parentCase.DEG_PendienteOutbound__c = true;
        parentCase.DEG_Atencion_Cliente_Ventas__c = true;
        //parentCase.ParentId = '5002900000DO2XoAAL';
        insert parentCase;
       
            
        Test.startTest();
        List<DEG_ConsultaLandingWpp_cls.Output> outputLst = DEG_ConsultaLandingWpp_cls.getQueue(inputLst);
        Test.stopTest();
        
    }
   
  

}