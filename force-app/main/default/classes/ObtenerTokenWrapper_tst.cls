@isTest
private class ObtenerTokenWrapper_tst {
    
      @isTest
    static void TestAudit() {
        
       ObtenerTokenWrapper.Audit Audit = new ObtenerTokenWrapper.Audit();
        
        Test.startTest();
        Audit.Canal = 'TCanal';
        Audit.Id_Device = 'TIdDevice';
        Audit.Facebook_User ='TFacebookUser';
        Audit.SO = 'TSo';
        Audit.IP_Address = 'TIpAddress';
        Audit.IP_Latitude = 'TIpLatitude';
        Audit.IP_Longitude = 'TIpLongitude';
        Audit.WhatsApp_Phone_Number = 'TWhatsAppPhoneNumber';
        Audit.Twitter_User = 'TTwitterUser';
        Audit.Facebook_User = 'TFacebook_User';
        Test.stopTest();
                
    }
    
    
    @isTest
    static void TestSystem1() {

        ObtenerTokenWrapper.System1 System1 = new ObtenerTokenWrapper.System1();
        
        Test.startTest();
        System1.name ='Tname' ;
        System1.correlationID = 'TcorrelationID';
        System1.processingServer ='TprocessingServer';
        Test.stopTest(); 
        
       
    }
    
    
    @isTest
     static void TestWSRequestHeader() {
         ObtenerTokenWrapper.System1 System1 = new ObtenerTokenWrapper.System1();
         ObtenerTokenWrapper.Property Property = new ObtenerTokenWrapper.Property();
         ObtenerTokenWrapper.WSRequestHeader WSRequestHeader = new  ObtenerTokenWrapper.WSRequestHeader();
         
         System1.name ='Tname' ;
         System1.correlationID = 'TcorrelationID';
         System1.processingServer ='TprocessingServer';
         
         Property.name ='Tpname';
         Property.value= 'TPvalue';
         
         Test.startTest();
         WSRequestHeader.Property = Property;
         WSRequestHeader.System1 = System1;
         Test.stopTest();
          
     }
    
    
     @isTest
     static void TestWSRequestBody() {
        ObtenerTokenWrapper.Audit Audit = new ObtenerTokenWrapper.Audit();
        ObtenerTokenWrapper.WSRequestBody WSRequestBody = new ObtenerTokenWrapper.WSRequestBody();
        
        Audit.Canal = 'TCanal';
        Audit.Id_Device = 'TIdDevice';
        Audit.Facebook_User ='TFacebookUser';
        Audit.SO = 'TSo';
        Audit.IP_Address = 'TIpAddress';
        Audit.IP_Latitude = 'TIpLatitude';
        Audit.IP_Longitude = 'TIpLongitude';
        Audit.WhatsApp_Phone_Number = 'TWhatsAppPhoneNumber';
        Audit.Twitter_User = 'TTwitterUser';
        Audit.Facebook_User = 'TFacebook_User';
        
        Test.startTest();
        WSRequestBody.Audit = Audit;
        WSRequestBody.Username = 'TUsername';
        WSRequestBody.Password = 'TPassword';      
        Test.stopTest();      
 
    }
    
    
  

}