@isTest
global class EncuestaSatisfaccion_tst  {
   
    @TestSetup
    static void makeData(){
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'MiPymes';
        ObjAccount.Phone = '3158181818';
        objAccount.SubSegmento__c = 'Mediana';   
        insert objAccount;

        Contact objContact = new Contact(IsTEST__c = true);
        objContact.FirstName = 'Andres';
        objContact.LastName = 'Lopez';
        objContact.AccountId = objAccount.Id;
        objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
        objContact.NumerodeIdentificacion__c = '345678904';
        objContact.Estado__c = 'Activo';
        objContact.Cargo__c = 'Ingeniero';
        objContact.Area__c = 'Dpto. Financiero';
        objContact.Rol__c = 'Administrativo';
        objContact.LTE_RolLTE__c = 'Total-';
        objContact.Genero__c = 'Masculino';
        objContact.Direccion__c = 'Calle 12 # 34 - 53';
        objContact.Phone = '32432432';
        objContact.MobilePhone = '3105667655';
        objContact.Email = 'scampos@avanxo.com';
        insert objContact;

        Case objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
       // objCaso.Plan__c = objPlan2.Id;
        objCaso.Status = 'En Proceso';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
        insert objCaso;
        
        Case objCaso2 = new Case();
        objCaso2.AccountId = objAccount.Id;
        objCaso2.Fechaderadicacion__c = Date.today();
        objCaso2.Operadores__c = 'ETB';
        objCaso2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso2.Origin = 'Teléfono';
        objCaso2.Status = 'Cerrado';
        objCaso2.Causal_Estado__c = 'Asignado';
        objCaso2.Subject = 'Prueba cambio plan';
        objCaso2.ContactId = objContact.id;
        objCaso2.Aprobaciones__c = 'Inicial';
        objCaso2.NoIntentosEncuesta__c = 1;
        insert objCaso2;
        
        ServiciosWeb__c swAutenticacion = new ServiciosWeb__c();
        swAutenticacion.Name = 'EncuestaSatisCasoCerradoAutenticacion';
        swAutenticacion.Endpoint__c = 'testAutenticacionEndpoint';
        swAutenticacion.Action__c = 'testActionAutenticacion';
        insert swAutenticacion;
         
        ServiciosWeb__c swSolicitudEncuesta = new ServiciosWeb__c();
        swSolicitudEncuesta.Name = 'EncuestaSatisCasoCerradoSolicitud';
        swSolicitudEncuesta.Endpoint__c = 'testSolicitarEncuestaEndpoint';
        swSolicitudEncuesta.Action__c = 'testSolicitarencuestaAction';
        insert swSolicitudEncuesta;
    }
    
      @isTest static void testRequestAuthenticationTokenResponseSuccess() {
        List<Case> caso = New List<Case>([SELECT Id FROM Case WHERE Status = 'En Proceso' ]);
        caso[0].Status = 'Cerrado';
        Test.setMock(HttpCalloutMock.class, new EncuestaSatisfaccionToken_callout('WithToken'));
        //EncuestaSatisfaccion_ws job = new EncuestaSatisfaccion_ws(casos.KeySet()); 
        Test.startTest();
          //ID jobID = System.enqueueJob(job);
          update caso[0];
        Test.stopTest();
    }

    @isTest static void BatchTest() {
        Test.setMock(HttpCalloutMock.class, new EncuestaSatisfaccionToken_callout('WithToken'));
        Test.startTest();
    	  	Database.executeBatch(new EncuestaSatisfaccion_bch(),100);
        Test.stopTest();
    }

    
    @isTest static void ScheduleBatchTest() {
        Test.setMock(HttpCalloutMock.class, new EncuestaSatisfaccionToken_callout('WithToken'));
        Test.startTest();
          String jobId = System.schedule('EncuestaSatisfaccion_bch','0 0 0 * * ? *',new EncuestaSatisfaccion_sch());
        Test.stopTest();
    }
    
	
    @isTest static void testRequestAuthenticationTokenResponseFailed() {
        List<Case> caso = New List<Case>([SELECT Id FROM Case WHERE Status = 'En Proceso' ]);
        caso[0].Status = 'Cerrado';
         Test.setMock(HttpCalloutMock.class, new EncuestaSatisfaccionToken_callout('WithoutToken')); 
         Test.startTest();
          update caso[0];
         Test.stopTest();
    }

   /*
    @isTest static void testRequestSatisfactionSurvey(){
        Map<Id, Case> casos = new Map<Id, Case>([SELECT Id FROM Case]);
        Test.setMock(HttpCalloutMock.class, new EncuestaSatisfaccionSolicitud_Callout()); 
        String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IktPTkVDVEEiLCJuYmYiOjE2Mzk2NjcyNTMsImV4cCI6MTYzOTc1MzY1MywiaWF0IjoxNjM5NjY3MjUzLCJpc3MiOiJodHRwOi8vYm90ZGV2LnBvcnRhbGx0ZXFhLnAuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJodHRwOi8vYm90ZGV2LnBvcnRhbGx0ZXFhLnAuYXp1cmV3ZWJzaXRlcy5uZXQifQ.OHafd0uLBmsogQJSdTO-RfIXfl0VgazvXzfJ8Goeemc';
        EncuestaSatisfaccion_ws.requestSatisfactionSurvey(token, casos.keySet());
    }
	*/
}