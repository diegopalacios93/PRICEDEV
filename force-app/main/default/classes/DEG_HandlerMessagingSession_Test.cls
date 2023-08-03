/**
 * @description       : 
 * @author            : j.martinez.mercado
 * @group             : 
 * @last modified on  : 12-08-2021
 * @last modified by  : j.martinez.mercado
**/
@isTest
public class DEG_HandlerMessagingSession_Test {
	
    //MessagingSession masivos/Hogares
    @isTest
    static void getMessagingSessionMasivosTst(){
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsApp_CO_whatsapp_573057800000' LIMIT 1];

		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+573125127626' ,
															MessagingPlatformKey = 'whatsapp:+573125127626',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp'  );
		insert msgEndUser;
		
		MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Ended' );
		insert msgSession;
        
        Test.startTest();
        msgSession.DEG_NombreCliente__c='tst';
        update msgSession;
        Test.stopTest();
    }
   
    //MessagingSession ventas
    @isTest
    static void getMessagingSessionVentasTst(){
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
		Test.startTest();
		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+573125127626' ,
															MessagingPlatformKey = 'whatsapp:+573125127626',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp'  );
		insert msgEndUser;
		
		MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Ended' );
		insert msgSession;
        
        
        
        Test.stopTest();
    }
    
    //MessagingSession ventas reinyecciones
    @isTest
    static void getMessagingSessionVentasReinTst(){
        Test.startTest();
        String tipoRegistroCuenta = Schema.sObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        Account cuenta = new Account(Name='Digital Engagement NO BORRAR', Phone='12345678', RecordTypeId=tipoRegistroCuenta);
        Insert cuenta;
        id idrec =[select id,name,developername from recordtype where developername='DEG_MensajeriaHSM'].id;
        Contact contacto = new Contact(FirstName='pedro12', LastName='romero2', DEG_Numero_Celular__c='3125127626',
                                       NumerodeIdentificacion__c='312121222',Tipodedocumento__c='Cédula de ciudadanía', 
                                       RecordTypeId=idrec, AccountId=cuenta.id, DEG_groupReinjection__c='DEG_Ventasreinyecion1');
        insert contacto;
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                       FROM MessagingChannel
                                       WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
        MessagingEndUser msgEndUser= new MessagingEndUser(Name = 'whatsapp:+573125127626' ,
                                                          MessagingPlatformKey = 'whatsapp:+573125127626',
                                                          MessagingChannelId= msgChannel.Id,
                                                          MessageType = 'WhatsApp',
                                                          ContactId = contacto.Id);
        insert msgEndUser;
        MessagingSession primerMensaje = new MessagingSession( MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = msgEndUser.Id,
                                                           Status = 'Ended',
                                                           DEG_TelefonoCliente__c = msgEndUser.MessagingPlatformKey.substringAfter('whatsapp:+57'));
        insert primerMensaje;
        /*MessagingSession segundoMensaje = new MessagingSession( MessagingChannelId= msgChannel.Id,
                                                           MessagingEndUserId = msgEndUser.Id,
                                                           Status = 'Active',
                                                           DEG_TelefonoCliente__c = msgEndUser.MessagingPlatformKey.substringAfter('whatsapp:+57'));
        insert segundoMensaje;*/
        Test.stopTest();
    }
    
    //MessagingSession empresas
    @isTest
    static void getMessagingSessionEmpresasTst(){
        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName =: Label.DEG_MsgChannelNameEmpresas LIMIT 1];

		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+573125127626' ,
															MessagingPlatformKey = 'whatsapp:+573125127626',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp'  );
		insert msgEndUser;
		
		MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Ended' );
		insert msgSession;
        
        Test.startTest();
        msgSession.DEG_NombreCliente__c='tst';
        msgSession.DEG_NumeroDocCliente__c = '23456765';
        msgSession.DEG_TipoDocCliente__c = 'CC';
        update msgSession;
        Test.stopTest();
    }

    //MessagingSession Negocios/MiPymes
    @isTest
    static void getMessagingSessionNegociosTst(){
        MessagingChannel msgChannel = [SELECT Id,MasterLabel, DeveloperName
                                      FROM MessagingChannel
                                     WHERE DeveloperName =: Label.DEG_MsgChannelNameNegocio LIMIT 1];

		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'whatsapp:+573125127626' ,
															MessagingPlatformKey = 'whatsapp:+573125127626',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'WhatsApp');
		insert msgEndUser;
		
		MessagingSession msgSession = new MessagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Ended' );
		insert msgSession;
        
        Test.startTest();
        msgSession.DEG_NombreCliente__c='tst';
        update msgSession;
        Test.stopTest();
    }
    
}