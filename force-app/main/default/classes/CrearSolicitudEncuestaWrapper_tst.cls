@isTest
private class CrearSolicitudEncuestaWrapper_tst {
    
    @isTest
    static void TestSystem1() {
        CrearSolicitudEncuestaWrapper.System1 System1 = new CrearSolicitudEncuestaWrapper.System1();
        Test.startTest();
        System1.name ='Tname' ;
        System1.correlationID = 'TcorrelationID';
        Test.stopTest(); 
    }
    
    
    @isTest
     static void TestWSRequestHeader() {
         CrearSolicitudEncuestaWrapper.System1 System1 = new CrearSolicitudEncuestaWrapper.System1();
         CrearSolicitudEncuestaWrapper.WSRequestHeader WSRequestHeader = new  CrearSolicitudEncuestaWrapper.WSRequestHeader();
         
         System1.name ='Tname' ;
         System1.correlationID = 'TcorrelationID';
         
         Test.startTest();
         WSRequestHeader.System1 = System1;
         Test.stopTest();
          
     }
    
    
     @isTest
     static void TestWSRequestBody() {
        CrearSolicitudEncuestaWrapper.Audit Audit = new CrearSolicitudEncuestaWrapper.Audit();
        CrearSolicitudEncuestaWrapper.WSRequestBody WSRequestBody = new CrearSolicitudEncuestaWrapper.WSRequestBody();
        
        Audit.Canal = 'TCanal';
        
        Test.startTest();
        WSRequestBody.Audit = Audit; 
        WSRequestBody.Document_Number = '12345';
        WSRequestBody.Document_Type = 'CC';
        WSRequestBody.Id = 'ASDF123';
        WSRequestBody.Email_Notify = 'test@gmail.com';
        WSRequestBody.Name = 'TEST NAME';
        WSRequestBody.Phone_Notify = '123344';
        WSRequestBody.Type_Notify = 'Encuesta Salesforce';    
        Test.stopTest();      
 
    }

    @isTest
    static void TestAudit() {
       CrearSolicitudEncuestaWrapper.Audit Audit = new CrearSolicitudEncuestaWrapper.Audit();
        Test.startTest();
        Audit.Canal = 'TCanal';
        Test.stopTest();
    }
    
}