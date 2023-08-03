@isTest
private class DEG_WrapperFrames_tst {

    @isTest
    static void TestServices() {
        
        DEG_WrapperFrames_cls.Services Services = new DEG_WrapperFrames_cls.Services();

        Test.startTest();
        Services.BillingAccount = 'TBillingAccount';
        Services.Line_Type = 'TLine_Type';
        Services.Phone = 'TPhone';
        Services.Principal_State = 'TPrincipal_State';
        Services.Product = 'TProduct';
        Services.Technology = 'TTechnology';
        Services.Tipo = 'TTipo';
        Test.stopTest();

        System.assertEquals(Services.BillingAccount, 'TBillingAccount');
        System.assertEquals(Services.Line_Type, 'TLine_Type');
        System.assertEquals(Services.Phone, 'TPhone');
        System.assertEquals(Services.Principal_State, 'TPrincipal_State');
        System.assertEquals(Services.Product, 'TProduct');
        System.assertEquals(Services.Technology, 'TTechnology');
        System.assertEquals(Services.Tipo, 'TTipo');
        
    }

    @isTest
    static void TestScore_FTTx() {
        
        DEG_WrapperFrames_cls.Score_FTTx Score_FTTx = new DEG_WrapperFrames_cls.Score_FTTx();

        Test.startTest();
        Score_FTTx.Fecha = 'TDate';
        Score_FTTx.Score = 1;
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestHabeas_Data() {
        
        DEG_WrapperFrames_cls.Habeas_Data Habeas_Data = new DEG_WrapperFrames_cls.Habeas_Data();

        Test.startTest();
        Habeas_Data.Canal = 'TCanal';
        Habeas_Data.Decision = 'TDecision';
        Habeas_Data.Decision_Date = 'TDecisionDate';
        Habeas_Data.Id_PQR = 'TId_PQR';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestContacts() {
        
        DEG_WrapperFrames_cls.Habeas_Data Habeas_Data = new DEG_WrapperFrames_cls.Habeas_Data();

        Habeas_Data.Canal = 'TCanal';
        Habeas_Data.Decision = 'TDecision';
        Habeas_Data.Decision_Date = 'TDecisionDate';
        Habeas_Data.Id_PQR = 'TId_PQR';

        DEG_WrapperFrames_cls.Contacts Contacts = new DEG_WrapperFrames_cls.Contacts();
        
        Test.startTest();
        Contacts.Address = 'TAddress';
        Contacts.Authorized = true;
        Contacts.dataHabeas = Habeas_Data;
        Contacts.Document_Number = 'TDocumentNumber';
        Contacts.Document_Type = 'TDocumentType';
        Contacts.Email = 'TEmail';
        Contacts.Name = 'TName';
        Contacts.Second_Surname = 'TSecondSurname';
        Contacts.Surname = 'TSurname';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestAddresses() {
        
        DEG_WrapperFrames_cls.Addresses Addresses = new DEG_WrapperFrames_cls.Addresses();
        
        Test.startTest();
        Addresses.Address = 'TAddress';
        Addresses.Address_Type = 'TAddressType';
        Addresses.Departament = 'TDepartament';
        Addresses.Id_wpr = 1;
        Addresses.Name = 'TName';
        Addresses.Selected = true;
        Addresses.State = 'TState';
        Addresses.Town = 'TTown';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestAudit() {
        
        DEG_WrapperFrames_cls.Audit Audit = new DEG_WrapperFrames_cls.Audit();
        
        Test.startTest();
        Audit.Canal = 'TCanal';
        Audit.Facebook_User ='TFacebookUser';
        Audit.Id_Device = 'TIdDevice';
        Audit.IP_Address = 'TIpAddress';
        Audit.IP_Latitude = 'TIpLatitude';
        Audit.IP_Longitude = 'TIpLongitude';
        Audit.SO = 'TSo';
        Audit.Twitter_User = 'TTwitterUser';
        Audit.WhatsApp_Phone_Number = 'TWhatsAppPhoneNumber';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }
    
    @isTest
    static void TestStatusDetail() {
        
        DEG_WrapperFrames_cls.StatusDetail StatusDetail = new DEG_WrapperFrames_cls.StatusDetail();
        
        Test.startTest();
        StatusDetail.errorCode = 'TErrorCode';
        StatusDetail.errorDetailCode = 'TErrorDetailCode';
        StatusDetail.errorMessage = 'TErrorMessage';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestWSRequestBody() {

        DEG_WrapperFrames_cls.Audit Audit = new DEG_WrapperFrames_cls.Audit();
        DEG_WrapperFrames_cls.WSRequestBody WSRequestBody = new DEG_WrapperFrames_cls.WSRequestBody();
        
        Audit.Canal = 'TCanal';
        Audit.Facebook_User ='TFacebookUser';
        Audit.Id_Device = 'TIdDevice';
        Audit.IP_Address = 'TIpAddress';
        Audit.IP_Latitude = 'TIpLatitude';
        Audit.IP_Longitude = 'TIpLongitude';
        Audit.SO = 'TSo';
        Audit.Twitter_User = 'TTwitterUser';
        Audit.WhatsApp_Phone_Number = 'TWhatsAppPhoneNumber';
        
        Test.startTest();
        WSRequestBody.Audit = Audit;
        WSRequestBody.Document_Number = 'TDocumentNumber';
        WSRequestBody.Document_Type = 'TDocumentType';
        WSRequestBody.Mail = 'TMail';
        WSRequestBody.Password = 'TPassword';
        WSRequestBody.Type = 'TType';
        WSRequestBody.Username = 'TUsername';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestService() {

        DEG_WrapperFrames_cls.StatusDetail StatusDetail = new DEG_WrapperFrames_cls.StatusDetail();
        DEG_WrapperFrames_cls.StatusDetail[] StatusDetailLst = new DEG_WrapperFrames_cls.StatusDetail[]{};
        DEG_WrapperFrames_cls.Service Service = new DEG_WrapperFrames_cls.Service();
        
        StatusDetail.errorCode = 'TErrorCode';
        StatusDetail.errorDetailCode = 'TErrorDetailCode';
        StatusDetail.errorMessage = 'TErrorMessage';

        StatusDetailLst.add(StatusDetail);
        
        Test.startTest();
        Service.processingServer = 'TProcessingServer';
        Service.responseDate = 'TResponseDate';
        Service.status = 'TStatus';
        Service.statusDetail = StatusDetailLst;
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestSystema() {

        DEG_WrapperFrames_cls.Systema Systema = new DEG_WrapperFrames_cls.Systema();
        
        Test.startTest();
        Systema.correlationID = 'TCorrelationId';
        Systema.name = 'TName';
        Systema.processingServer = 'TProcessingServer';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestWSRequestHeader() {

        DEG_WrapperFrames_cls.Property[] Property = new DEG_WrapperFrames_cls.Property[]{};
        DEG_WrapperFrames_cls.Systema Systema = new DEG_WrapperFrames_cls.Systema();
        DEG_WrapperFrames_cls.WSRequestHeader WSRequestHeader = new DEG_WrapperFrames_cls.WSRequestHeader();
        
        Systema.correlationID = 'TCorrelationId';
        Systema.name = 'TName';
        Systema.processingServer = 'TProcessingServer';

        Test.startTest();
        WSRequestHeader.lProperty = Property;
        WSRequestHeader.Systema = Systema;
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

    @isTest
    static void TestWrapRequestToken() {

        DEG_WrapperFrames_cls.Property[] Property = new DEG_WrapperFrames_cls.Property[]{};
        DEG_WrapperFrames_cls.Systema Systema = new DEG_WrapperFrames_cls.Systema();
        DEG_WrapperFrames_cls.WSRequestHeader WSRequestHeader = new DEG_WrapperFrames_cls.WSRequestHeader();
        DEG_WrapperFrames_cls.Audit Audit = new DEG_WrapperFrames_cls.Audit();
        DEG_WrapperFrames_cls.WSRequestBody WSRequestBody = new DEG_WrapperFrames_cls.WSRequestBody();
        DEG_WrapperFrames_cls.WrapRequestToken WrapRequestToken = new DEG_WrapperFrames_cls.WrapRequestToken();
        
        Systema.correlationID = 'TCorrelationId';
        Systema.name = 'TName';
        Systema.processingServer = 'TProcessingServer';

        WSRequestHeader.lProperty = Property;
        WSRequestHeader.Systema = Systema;

        Audit.Canal = 'TCanal';
        Audit.Facebook_User ='TFacebookUser';
        Audit.Id_Device = 'TIdDevice';
        Audit.IP_Address = 'TIpAddress';
        Audit.IP_Latitude = 'TIpLatitude';
        Audit.IP_Longitude = 'TIpLongitude';
        Audit.SO = 'TSo';
        Audit.Twitter_User = 'TTwitterUser';
        Audit.WhatsApp_Phone_Number = 'TWhatsAppPhoneNumber';
                
        WSRequestBody.Audit = Audit;
        WSRequestBody.Document_Number = 'TDocumentNumber';
        WSRequestBody.Document_Type = 'TDocumentType';
        WSRequestBody.Mail = 'TMail';
        WSRequestBody.Password = 'TPassword';
        WSRequestBody.Type = 'TType';
        WSRequestBody.Username = 'TUsername';

        Test.startTest();
        WrapRequestToken.WSRequestBody = WSRequestBody;
        WrapRequestToken.WSRequestHeader = WSRequestHeader;
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');

    }

    @isTest
    static void TestWSResponseBody() {

        DEG_WrapperFrames_cls.WSResponseBody WSResponseBody = new DEG_WrapperFrames_cls.WSResponseBody();
        DEG_WrapperFrames_cls.Addresses Addresses = new DEG_WrapperFrames_cls.Addresses();
        DEG_WrapperFrames_cls.Addresses[] AddressesLst = new DEG_WrapperFrames_cls.Addresses[]{};
        DEG_WrapperFrames_cls.Habeas_Data Habeas_Data = new DEG_WrapperFrames_cls.Habeas_Data();
        DEG_WrapperFrames_cls.Contacts Contacts = new DEG_WrapperFrames_cls.Contacts();
        DEG_WrapperFrames_cls.Services Services = new DEG_WrapperFrames_cls.Services();
        DEG_WrapperFrames_cls.Contacts[] ContactsLst = new DEG_WrapperFrames_cls.Contacts[]{};
        DEG_WrapperFrames_cls.Services[] ServicesLst = new DEG_WrapperFrames_cls.Services[]{};
        DEG_WrapperFrames_cls.Score_FTTx Score_FTTx = new DEG_WrapperFrames_cls.Score_FTTx();
        DEG_WrapperFrames_cls.ScoreLTE Score_LTE = new DEG_WrapperFrames_cls.ScoreLTE();
        DEG_WrapperFrames_cls.DocumentIssuance DocumentIssuance = new DEG_WrapperFrames_cls.DocumentIssuance();
		
        Score_LTE.Fecha = 'TDate';
        Score_LTE.Score = 'TScore';
        
        Score_FTTx.Fecha = 'TDate';
        Score_FTTx.Score = 1;
		
        DocumentIssuance.City = 'TCity';
        DocumentIssuance.City_Dane = 'TCityDane';
        DocumentIssuance.Fecha = 'TFecha';
        DocumentIssuance.Departament = 'TDepartament';
        DocumentIssuance.Departament_DANE = 'TDepartamentDane';
        
        Services.BillingAccount = 'TBillingAccount';
        Services.Line_Type = 'TLine_Type';
        Services.Phone = 'TPhone';
        Services.Principal_State = 'TPrincipal_State';
        Services.Product = 'TProduct';
        Services.Technology = 'TTechnology';
        Services.Tipo = 'TTipo';

        Habeas_Data.Canal = 'TCanal';
        Habeas_Data.Decision = 'TDecision';
        Habeas_Data.Decision_Date = 'TDecisionDate';
        Habeas_Data.Id_PQR = 'TId_PQR';

        Contacts.Address = 'TAddress';
        Contacts.Authorized = true;
        Contacts.dataHabeas = Habeas_Data;
        Contacts.Document_Number = 'TDocumentNumber';
        Contacts.Document_Type = 'TDocumentType';
        Contacts.Email = 'TEmail';
        Contacts.Name = 'TName';
        Contacts.Second_Surname = 'TSecondSurname';
        Contacts.Surname = 'TSurname';
        
        Addresses.Address = 'TAddress';
        Addresses.Address_Type = 'TAddressType';
        Addresses.Departament = 'TDepartament';
        Addresses.Id_wpr = 1;
        Addresses.Name = 'TName';
        Addresses.Selected = true;
        Addresses.State = 'TState';
        Addresses.Town = 'TTown';

        AddressesLst.add(Addresses);
        ContactsLst.add(Contacts);
        ServicesLst.add(Services);

        Test.startTest();
        WSResponseBody.Document_Type = 'TDocumentType';
        WSResponseBody.Email = 'TEmail';
        WSResponseBody.Landline = 'TLandline';
        WSResponseBody.Location = 'TLocation';
        WSResponseBody.MinutesExpire = 'TMinutesExpire';
        WSResponseBody.Mobile_Phone = 'TMobilePhone';
        WSResponseBody.Name = 'TName';
        WSResponseBody.Names = 'Names';
        WSResponseBody.Score_LTE = Score_LTE;
        WSResponseBody.Second_Surname = 'TSecondSurname';
        WSResponseBody.SecurityToken = 'TSecurityToken';
        WSResponseBody.Segment = 'TSegment';
        WSResponseBody.Segment_UEN = 'TSegmentUen';
        WSResponseBody.State = 'TState';
        WSResponseBody.Surname = 'TSurname';
        WSResponseBody.UEN = 'TUen';
        WSResponseBody.Value = 'TValue';
        WSResponseBody.Address = 'TAddress';
        WSResponseBody.Addresses = AddressesLst;
        WSResponseBody.Birthday = 'TBirthday';
        WSResponseBody.Business = 'TBusiness';
        WSResponseBody.Category = 'TCategory';
        WSResponseBody.City = 'TCity';
        WSResponseBody.City_DANE = 'TCityDane';
        WSResponseBody.City_Mongo = 'TCityMongo';
        WSResponseBody.Civil_Status = 'TCivilStatus';
        WSResponseBody.Company_Short_Name = 'TCompanyShortName';
        WSResponseBody.Customer_Type = 'TCustomerType';
        WSResponseBody.dataContacts = ContactsLst;
        WSResponseBody.Datacredit_Authorization = 'TDataCreditAuthortization';
        WSResponseBody.dataHabeas = Habeas_Data;
        WSResponseBody.dataScore = Score_FTTx;
        WSResponseBody.dataServices = ServicesLst;
        WSResponseBody.Departament = 'TDepartament';
        WSResponseBody.Departament_DANE = 'TDepartamentDane';
        WSResponseBody.Departament_Mongo = 'TMongo';
        WSResponseBody.District = 'TDistrict';
        WSResponseBody.Document_Issuance = DocumentIssuance;
        WSResponseBody.Document_Number = 'TDocumentNumber'; 
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');

    }

    @isTest
    static void TestWSResponseHeader() {

        DEG_WrapperFrames_cls.Property[] Property = new DEG_WrapperFrames_cls.Property[]{};
        DEG_WrapperFrames_cls.Systema Systema = new DEG_WrapperFrames_cls.Systema();
        DEG_WrapperFrames_cls.Service Service = new DEG_WrapperFrames_cls.Service();
        DEG_WrapperFrames_cls.WSResponseHeader WSResponseHeader = new DEG_WrapperFrames_cls.WSResponseHeader();
        DEG_WrapperFrames_cls.StatusDetail StatusDetail = new DEG_WrapperFrames_cls.StatusDetail();
        DEG_WrapperFrames_cls.StatusDetail[] StatusDetailLst = new DEG_WrapperFrames_cls.StatusDetail[]{};
        
        StatusDetail.errorCode = 'TErrorCode';
        StatusDetail.errorDetailCode = 'TErrorDetailCode';
        StatusDetail.errorMessage = 'TErrorMessage';

        StatusDetailLst.add(StatusDetail);
        
        Service.processingServer = 'TProcessingServer';
        Service.responseDate = 'TResponseDate';
        Service.status = 'TStatus';
        Service.statusDetail = StatusDetailLst;
        
        Systema.correlationID = 'TCorrelationId';
        Systema.name = 'TName';
        Systema.processingServer = 'TProcessingServer';

        Test.startTest();
        WSResponseHeader.lProperty = Property;
        WSResponseHeader.Service = Service;
        WSResponseHeader.Systema = Systema;
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');

    }

    @isTest
    static void TestwrapResponseToken() {

        DEG_WrapperFrames_cls.Property[] Property = new DEG_WrapperFrames_cls.Property[]{};
        DEG_WrapperFrames_cls.Systema Systema = new DEG_WrapperFrames_cls.Systema();
        DEG_WrapperFrames_cls.Service Service = new DEG_WrapperFrames_cls.Service();
        DEG_WrapperFrames_cls.WSResponseHeader WSResponseHeader = new DEG_WrapperFrames_cls.WSResponseHeader();
        DEG_WrapperFrames_cls.StatusDetail StatusDetail = new DEG_WrapperFrames_cls.StatusDetail();
        DEG_WrapperFrames_cls.StatusDetail[] StatusDetailLst = new DEG_WrapperFrames_cls.StatusDetail[]{};
        DEG_WrapperFrames_cls.WSResponseBody WSResponseBody = new DEG_WrapperFrames_cls.WSResponseBody();
        DEG_WrapperFrames_cls.Addresses Addresses = new DEG_WrapperFrames_cls.Addresses();
        DEG_WrapperFrames_cls.Addresses[] AddressesLst = new DEG_WrapperFrames_cls.Addresses[]{};
        DEG_WrapperFrames_cls.Habeas_Data Habeas_Data = new DEG_WrapperFrames_cls.Habeas_Data();
        DEG_WrapperFrames_cls.Contacts Contacts = new DEG_WrapperFrames_cls.Contacts();
        DEG_WrapperFrames_cls.Services Services = new DEG_WrapperFrames_cls.Services();
        DEG_WrapperFrames_cls.Contacts[] ContactsLst = new DEG_WrapperFrames_cls.Contacts[]{};
        DEG_WrapperFrames_cls.Services[] ServicesLst = new DEG_WrapperFrames_cls.Services[]{};
        DEG_WrapperFrames_cls.Score_FTTx Score_FTTx = new DEG_WrapperFrames_cls.Score_FTTx();
        DEG_WrapperFrames_cls.wrapResponseToken wrapResponseToken = new DEG_WrapperFrames_cls.wrapResponseToken();
        DEG_WrapperFrames_cls.ScoreLTE Score_LTE = new DEG_WrapperFrames_cls.ScoreLTE();
        DEG_WrapperFrames_cls.DocumentIssuance DocumentIssuance = new DEG_WrapperFrames_cls.DocumentIssuance();
		
        Score_LTE.Fecha = 'TDate';
        Score_LTE.Score = 'TScore';
		
        DocumentIssuance.City = 'TCity';
        DocumentIssuance.City_Dane = 'TCityDane';
        DocumentIssuance.Fecha = 'TFecha';
        DocumentIssuance.Departament = 'TDepartament';
        DocumentIssuance.Departament_DANE = 'TDepartamentDane';

        Score_FTTx.Fecha = 'TDate';
        Score_FTTx.Score = 1;

        Services.BillingAccount = 'TBillingAccount';
        Services.Line_Type = 'TLine_Type';
        Services.Phone = 'TPhone';
        Services.Principal_State = 'TPrincipal_State';
        Services.Product = 'TProduct';
        Services.Technology = 'TTechnology';
        Services.Tipo = 'TTipo';

        Habeas_Data.Canal = 'TCanal';
        Habeas_Data.Decision = 'TDecision';
        Habeas_Data.Decision_Date = 'TDecisionDate';
        Habeas_Data.Id_PQR = 'TId_PQR';

        Contacts.Address = 'TAddress';
        Contacts.Authorized = true;
        Contacts.dataHabeas = Habeas_Data;
        Contacts.Document_Number = 'TDocumentNumber';
        Contacts.Document_Type = 'TDocumentType';
        Contacts.Email = 'TEmail';
        Contacts.Name = 'TName';
        Contacts.Second_Surname = 'TSecondSurname';
        Contacts.Surname = 'TSurname';
        
        Addresses.Address = 'TAddress';
        Addresses.Address_Type = 'TAddressType';
        Addresses.Departament = 'TDepartament';
        Addresses.Id_wpr = 1;
        Addresses.Name = 'TName';
        Addresses.Selected = true;
        Addresses.State = 'TState';
        Addresses.Town = 'TTown';

        AddressesLst.add(Addresses);
        ContactsLst.add(Contacts);
        ServicesLst.add(Services);
        
        StatusDetail.errorCode = 'TErrorCode';
        StatusDetail.errorDetailCode = 'TErrorDetailCode';
        StatusDetail.errorMessage = 'TErrorMessage';

        StatusDetailLst.add(StatusDetail);
        
        Service.processingServer = 'TProcessingServer';
        Service.responseDate = 'TResponseDate';
        Service.status = 'TStatus';
        Service.statusDetail = StatusDetailLst;
        
        Systema.correlationID = 'TCorrelationId';
        Systema.name = 'TName';
        Systema.processingServer = 'TProcessingServer';

        WSResponseHeader.lProperty = Property;
        WSResponseHeader.Service = Service;
        WSResponseHeader.Systema = Systema;
        
        Score_FTTx.Fecha = 'TDate';
        Score_FTTx.Score = 1;

        Services.BillingAccount = 'TBillingAccount';
        Services.Line_Type = 'TLine_Type';
        Services.Phone = 'TPhone';
        Services.Principal_State = 'TPrincipal_State';
        Services.Product = 'TProduct';
        Services.Technology = 'TTechnology';
        Services.Tipo = 'TTipo';

        Habeas_Data.Canal = 'TCanal';
        Habeas_Data.Decision = 'TDecision';
        Habeas_Data.Decision_Date = 'TDecisionDate';
        Habeas_Data.Id_PQR = 'TId_PQR';

        Contacts.Address = 'TAddress';
        Contacts.Authorized = true;
        Contacts.dataHabeas = Habeas_Data;
        Contacts.Document_Number = 'TDocumentNumber';
        Contacts.Document_Type = 'TDocumentType';
        Contacts.Email = 'TEmail';
        Contacts.Name = 'TName';
        Contacts.Second_Surname = 'TSecondSurname';
        Contacts.Surname = 'TSurname';
        
        Addresses.Address = 'TAddress';
        Addresses.Address_Type = 'TAddressType';
        Addresses.Departament = 'TDepartament';
        Addresses.Id_wpr = 1;
        Addresses.Name = 'TName';
        Addresses.Selected = true;
        Addresses.State = 'TState';
        Addresses.Town = 'TTown';

        AddressesLst.add(Addresses);
        ContactsLst.add(Contacts);
        ServicesLst.add(Services);

        WSResponseBody.Document_Type = 'TDocumentType';
        WSResponseBody.Email = 'TEmail';
        WSResponseBody.Landline = 'TLandline';
        WSResponseBody.Location = 'TLocation';
        WSResponseBody.MinutesExpire = 'TMinutesExpire';
        WSResponseBody.Mobile_Phone = 'TMobilePhone';
        WSResponseBody.Name = 'TName';
        WSResponseBody.Names = 'Names';
        WSResponseBody.Score_LTE = Score_LTE;
        WSResponseBody.Second_Surname = 'TSecondSurname';
        WSResponseBody.SecurityToken = 'TSecurityToken';
        WSResponseBody.Segment = 'TSegment';
        WSResponseBody.Segment_UEN = 'TSegmentUen';
        WSResponseBody.State = 'TState';
        WSResponseBody.Surname = 'TSurname';
        WSResponseBody.UEN = 'TUen';
        WSResponseBody.Value = 'TValue';
        WSResponseBody.Address = 'TAddress';
        WSResponseBody.Addresses = AddressesLst;
        WSResponseBody.Birthday = 'TBirthday';
        WSResponseBody.Business = 'TBusiness';
        WSResponseBody.Category = 'TCategory';
        WSResponseBody.City = 'TCity';
        WSResponseBody.City_DANE = 'TCityDane';
        WSResponseBody.City_Mongo = 'TCityMongo';
        WSResponseBody.Civil_Status = 'TCivilStatus';
        WSResponseBody.Company_Short_Name = 'TCompanyShortName';
        WSResponseBody.Customer_Type = 'TCustomerType';
        WSResponseBody.dataContacts = ContactsLst;
        WSResponseBody.Datacredit_Authorization = 'TDataCreditAuthortization';
        WSResponseBody.dataHabeas = Habeas_Data;
        WSResponseBody.dataScore = Score_FTTx;
        WSResponseBody.dataServices = ServicesLst;
        WSResponseBody.Departament = 'TDepartament';
        WSResponseBody.Departament_DANE = 'TDepartamentDane';
        WSResponseBody.Departament_Mongo = 'TMongo';
        WSResponseBody.District = 'TDistrict';
        WSResponseBody.Document_Issuance = DocumentIssuance;
        WSResponseBody.Document_Number = 'TDocumentNumber';

        Test.startTest();
        wrapResponseToken.WSResponseBody = WSResponseBody;
        wrapResponseToken.WSResponseHeader = WSResponseHeader;
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');

    }

    @isTest
    static void TestWrapRequestFrame() {
        
        DEG_WrapperFrames_cls.wrapRequestFrame wrapRequestFrame = new DEG_WrapperFrames_cls.wrapRequestFrame();
        DEG_WrapperFrames_cls.data data = new DEG_WrapperFrames_cls.data();

        Test.startTest();
        wrapRequestFrame.accion = 'TAccion';
        wrapRequestFrame.botId = 'TBotId';
        wrapRequestFrame.data = data;
        wrapRequestFrame.idConversacion = 'TIdConversacion';
        wrapRequestFrame.palabraClave = 'TPalabraClave';
        Test.stopTest();

        //System.assertEquals(Services.BillingAccount.getDescribe().getType(), 'String');
        
    }

}