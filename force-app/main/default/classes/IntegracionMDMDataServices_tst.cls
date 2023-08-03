/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Samuel Rodríguez
Proyecto:           INI26058 - C.D. Ajuste Proceso Batch Cargue de Activos Salesforce - MDM
Descripción:        Clase de test para la integración online de creación y actualización de Clientes y Contactos desde 
					Salesforce a MDM.
Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2020-11-05      Samuel Rodríguez (SR)       Creación de la clase.
***********************************************************************************************************************/
@isTest
global class IntegracionMDMDataServices_tst {
    
	public static Account oAccount  {get;set;}
    public static Account oAccount1  {get;set;}
    public static Contact oContact  {get;set;}
    public static Poblacion__c oPoblacion  {get;set;}
    
    public static void createData(){
        
        list<sobject> vg = new list<sobject>();
        vg.add(new ServiciosWeb__c(Name='Set_Customer',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='Set_Customer_Contact',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='Get_Customer',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        
        insert vg;
        
        oPoblacion = new Poblacion__c(); 
        
        oPoblacion.Name 		  = 'Bogotá';
        oPoblacion.EsMunicipio__c = true;
		insert oPoblacion;
        
       	oAccount = new Account();
        oAccount.Name   			= 'Cuenta Cliente Prueba';           
        oAccount.Direccion__c		= 'KR 64 CL89.76';
        oAccount.Ciudad__c          = oPoblacion.Id;
        oAccount.Phone              = '39087474';
        oAccount.Description  		= 'Cuenta utilizada para las clases de prueba';
        oAccount.RecordTypeId 		 = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('Sucursales').getRecordTypeId();
        oAccount.Telefonodecontacto1__c = '39087474';
        oAccount.OtroTelefonodecontacto2__c = '39087474';
        oAccount.Autoriza_Tratamiento_de_Datos_Personales__c = 'No';
        		
        oAccount1 = new Account();
        oAccount1.AccountNumber 	= '1234567'; 
        oAccount1.Tipodedocumento__c = 'NIT';
        oAccount1.Name   			= 'Cuenta Cliente Prueba';           
        oAccount1.Direccion__c		= 'KR 64 CL89.76';
        oAccount1.Ciudad__c          = oPoblacion.Id;
        oAccount1.Phone              = '39087474';
        oAccount1.Description  		= 'Cuenta utilizada para las clases de prueba';
        oAccount1.RecordTypeId 		 = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('Sucursales').getRecordTypeId();
        oAccount1.Telefonodecontacto1__c = '39087474';
        oAccount1.OtroTelefonodecontacto2__c = '39087474';
        oAccount1.Autoriza_Tratamiento_de_Datos_Personales__c = 'No';
        
        insert oAccount;
        insert oAccount1;
        
        oAccount1.AccountNumber 	= '7654321'; 
        oAccount1.Tipodedocumento__c = 'Pasaporte';
        update oAccount1;
        
        oContact = new Contact();
        oContact.LastName     			   = 'Ramos';
        oContact.AccountId   	    	   = oAccount.Id;
        oContact.Ciudad__c 				   = oPoblacion.Id;
        oContact.NumerodeIdentificacion__c = '987354132765';
        oContact.Tipodedocumento__c        = 'Pasaporte';
        oContact.Cargo__c  				   = 'Analista';
        oContact.Area__c 				   = 'Dpto. Financiero';
        oContact.Direccion__c			   = 'KR 98B 76 F45';
        oContact.Phone           		   = '98876765';
        oContact.MobilePhone 			   = '3098268393';
        oContact.Email					   = 'test@test.com';
        oContact.Estado__c  			   = 'Activo';
        oContact.Rol__c 				   = 'Decisor';
        oContact.Genero__c  			   = 'Femenino';
        oContact.Autoriza_Tratamiento_de_Datos_Personales__c = 'No';
        oContact.OtherPhone                = '98876765';
    
        insert oContact;
       
    }
    
     global class MockResponseSetCustomer implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
           ServiciosWeb__c sw = ServiciosWeb__c.getValues('Set_Customer');
           String response = '<?xml version="1.0" encoding="utf-8"?>'
                                +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
                                    +'<soap:Body>'
                                        +'<Set_CustomerResponse xmlns="http://www.etb.com.co/Gateway/MDM_Data_Services">'
                                            +'<Set_CustomerResult>'
                                                +'<WSResponseHeader>'
                                                    +'<system>'
                                                        +'<name>MDM_Data_Services</name>'
                                                        +'<correlationId>900112233</correlationId>'
                                                        +'<processingServer>MDM</processingServer>'
                                                    +'</system>'
                                                    +'<service>'
                                                        +'<status>OK</status>'
                                                        +'<responseDate>2020-11-05 15:14:30</responseDate>'
                                                        +'<statusDetail/>'
                                                    +'</service>'
                                                    +'<property/>'
                                                +'</WSResponseHeader>'
                                                +'<WSResponseBody>'
                                                    +'<OperationResult>1</OperationResult>'
                                                    +'<OperationResultDesc>Operacion Exitosa</OperationResultDesc>'
                                                +'</WSResponseBody>'
                                            +'</Set_CustomerResult>'
                                        +'</Set_CustomerResponse>'
                                    +'</soap:Body>'
                                +'</soap:Envelope>';
            	            
           System.debug('Ingresa mock SetCustomer');
	       HttpResponse res = new HttpResponse();
	       res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	       res.setBody(response);
	       res.setStatusCode(200);
	       return res;
        }
    }
    
    global class MockResponseSetCustomerContact implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Set_Customer');
        	String response = '<?xml version="1.0" encoding="utf-8"?>'
                              +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
                                +'<soap:Body>'
                                    +'<Set_Customer_ContactResponse xmlns="http://www.etb.com.co/Gateway/MDM_Data_Services">'
                                        +'<Set_Customer_ContactResult>'
                                            +'<WSResponseHeader>'
                                                +'<system>'
                                                    +'<name>MDM_Data_Services</name>'
                                                    +'<correlationId>900112244</correlationId>'
                                                    +'<processingServer>MDM</processingServer>'
                                                +'</system>'
                                                +'<service>'
                                                    +'<status>OK</status>'
                                                    +'<responseDate>2020-11-05 15:18:28</responseDate>'
                                                    +'<statusDetail/>'
                                                +'</service>'
                                                +'<property/>'
                                            +'</WSResponseHeader>'
                                            +'<WSResponseBody>'
                                                +'<OperationResult>1</OperationResult>'
                                                +'<OperationResultDesc>Operacion Exitosa</OperationResultDesc>'
                                            +'</WSResponseBody>'
                                        +'</Set_Customer_ContactResult>'
                                    +'</Set_Customer_ContactResponse>'
                                +'</soap:Body>'
                            +'</soap:Envelope>';
            	            
           System.debug('Ingresa mock SetCustomerContact');
	       HttpResponse res = new HttpResponse();
	       res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	       res.setBody(response);
	       res.setStatusCode(200);
	       return res;
        }
    }
    
    
    global class MockResponseGetCustomer implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Set_Customer');
   			String response = '<?xml version="1.0" encoding="utf-8"?>'
                            +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
                                +'<soap:Body>'
                                  +'<Get_CustomerResponse xmlns="http://www.etb.com.co/Gateway/MDM_Data_Services">'
                                        +'<Get_CustomerResult>'
                                            +'<WSResponseHeader>'
                                                +'<system>'
                                                    +'<name>MDM_Data_Services</name>'
                                                    +'<correlationId>900112244</correlationId>'
                                                    +'<processingServer>MDM</processingServer>'
                                                +'</system>'
                                                +'<service>'
                                                    +'<status>OK</status>'
                                                    +'<responseDate>2020-11-05 15:16:19</responseDate>'
                                                    +'<statusDetail/>'
                                                +'</service>'
                                                +'<property/>'
                                            +'</WSResponseHeader>'
                                            +'<WSResponseBody>'
                                                +'<Id>5fa45cf2f46b160b14364c60</Id>'
                                                +'<Tipo_Documento>NIT</Tipo_Documento>'
                                                +'<Tipo_Cliente>Empresas</Tipo_Cliente>'
                                                +'<Numero_Identificacion>900112233</Numero_Identificacion>'
                                                +'<Nombre_Cliente>Prueba INI26058</Nombre_Cliente>'
                                                +'<Estado>Activo</Estado>'
                                                +'<Segmento>Grandes</Segmento>'
                                                +'<Segmento_UEN>Empresas</Segmento_UEN>'
                                                +'<Telefono_Fijo>2422390</Telefono_Fijo>'
                                                +'<Direccion>Carrera 8 # 20 00</Direccion>'
                                                +'<Pais>Colombia</Pais>'
                                                +'<Departamento>BOGOTA</Departamento>'
                                                +'<Ciudad>BOGOTA D.C.</Ciudad>'
                                                +'<Barrio>BOGOTÁ, D.C.</Barrio>'
                                                +'<Usuario_Creador>005f30000036ZMkAAM</Usuario_Creador>'
                                                +'<Usuario_Modificador>005f30000036ZMkAAM</Usuario_Modificador>'
                                                +'<Scoring>Ninguno</Scoring>'
                                                +'<Fecha_Actualizacion>2020-11-05T20:14:30.692Z</Fecha_Actualizacion>'
                                                +'<Sistema_Origen>'
                                                    +'<MDM_Sistema_Origen>'
                                                        +'<Sistema_Origen>Salesforce</Sistema_Origen>'
                                                    +'</MDM_Sistema_Origen>'
                                                +'</Sistema_Origen>'
                                                +'<Contacto>'
                                                    +'<MDM_Contacto_Cliente>'
                                                        +'<Id>5fa45d89f46b160b14364c62</Id>'
                                                        +'<Numero_Documento>900112244</Numero_Documento>'
                                                        +'<Nombre_Contacto/>'
                                                        +'<Telefono_Contacto>24223900</Telefono_Contacto>'
                                                        +'<Movil_Contacto>24223900</Movil_Contacto>'
                                                        +'<Email_Contacto>prueba@etb.com.co</Email_Contacto>'
                                                        +'<Tipo_Documento>Cédula de ciudadanía</Tipo_Documento>'
                                                        +'<Direccion_Asociada>Carrera 8 # 20 - 00</Direccion_Asociada>'
                                                        +'<Pais/>'
                                                        +'<Departamento/>'
                                                        +'<Ciudad/>'
                                                        +'<actualizacion_extractor>1</actualizacion_extractor>'
                                                        +'<Autorizado>false</Autorizado>'
                                                        +'<Nombre_Individual>Apellido CP</Nombre_Individual>'
                                                        +'<Primer_Apellido>Apellido CP</Primer_Apellido>'
                                                        +'<Segundo_Apellido/>'
                                                        +'<Estado>false</Estado>'
                                                        +'<Usuario_Modificador>005f30000036ZMkAAM</Usuario_Modificador>'
                                                        +'<Fecha_Modificacion>2020-11-05T20:16:09.865Z</Fecha_Modificacion>'
                                                        +'<FechaExpedicion xsi:nil="true"/>'
                                                        +'<FechaCumpleanos xsi:nil="true"/>'
                                                    +'</MDM_Contacto_Cliente>'
                                                +'</Contacto>'
                                                +'<actualizacion_extractor>1</actualizacion_extractor>'
                                                +'<Nombres>Prueba</Nombres>'
                                                +'<Primer_Apellido>INI26058</Primer_Apellido>'
                                                +'<Segundo_Apellido/>'
                                                +'<Fecha_Creacion>2020-11-05T20:13:38.344Z</Fecha_Creacion>'
                                                +'<Direcciones/>'
                                                +'<Fecha_Validacion_Identidad xsi:nil="true"/>'
                                                +'<ATDP>'
                                                    +'<HABEAS_DATA>false</HABEAS_DATA>'
                                                    +'<FECHA>2020-11-05T15:14:30Z</FECHA>'
                                                +'</ATDP>'
                                            +'</WSResponseBody>'
                                        +'</Get_CustomerResult>'
                                    +'</Get_CustomerResponse>'
                                +'</soap:Body>'
                            +'</soap:Envelope>';
            	            
           System.debug('Ingresa mock GetCustomer');
	       HttpResponse res = new HttpResponse();
	       res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	       res.setBody(response);
	       res.setStatusCode(200);
	       return res;
        }
    }
    
    static testMethod void InsertarDatosCuenta_Test() {
        
		createData();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockResponseSetCustomer());
        IntegracionMDMDataServices_cls mdmDataServices = new IntegracionMDMDataServices_cls();
        try {
           mdmDataServices.InsertarDatosCuenta(oAccount,'I');
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void ObtenerCliente_Test() {
        
		createData();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockResponseGetCustomer());
        IntegracionMDMDataServices_cls mdmDataServices = new IntegracionMDMDataServices_cls();
        try {
           mdmDataServices.ObtenerCliente(oAccount);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void InsertarDatosContacto_Test() {
        
		createData();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockResponseSetCustomer());
        IntegracionMDMDataServices_cls mdmDataServices = new IntegracionMDMDataServices_cls();
        try {
           mdmDataServices.InsertarDatosContacto(oContact,'I');
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void ObtenerClienteDesdeContacto_Test() {
        
		createData();
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockResponseGetCustomer());
        IntegracionMDMDataServices_cls mdmDataServices = new IntegracionMDMDataServices_cls();
        try {
           mdmDataServices.ObtenerClienteDesdeContacto(oContact);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void InsertarActualizarCuenta_Test() {
        
		createData();
        List<Account> ListaCuentas = new List<Account>();
        ListaCuentas = [Select Id, Name, Ciudad__r.CodigoDane__c,Identificador_Cuenta_Mongo__c From Account Limit 1];
        Contact ctc = [Select Id From Contact Limit 1];
        
       	Account objAccUpdate = new Account(Id=ListaCuentas[0].Id);
        objAccUpdate.Identificador_Cuenta_Mongo__c = '';
        BanderasEjecucion.unSetEjecucion('UpdateAccountMDM');
        BanderasEjecucion.unSetEjecucion('InsertAccountMDM');
        Update objAccUpdate;

        update ctc;
    
    }

    static testMethod void InsertarActualizarContact_Test() {
        
		createData();
        Contact ctc = [Select Id From Contact Limit 1];
        
        BanderasEjecucion.setEjecucion('InsertAccountMDM');
        BanderasEjecucion.setEjecucion('InsertAccountMDM');

        update ctc;
    
    }
    
}