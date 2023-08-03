/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               Mejoras Experiencia MiPymes
Descripcion:            Clase test para el trigger de casos

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     2021-09-10  John Guevara (JG)			Clase test para el trigger de casos   
*******************************************************************************/
@isTest
public class Case_tst {

    public static List<VariablesGlobales__c> lstVariablesGlobales;
    public static List<Perfiles_Reglas_OC__c> lstPerfilesReglasOC;
    public static Account objAccount;
    public static Contract objContrato;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static Account objSucursal;
    public static CuentaFacturacion__c objCtaFact;
    public static Contact objContact;
    public static CatalogoProductos__c objProducto;
    public static ActivoETB__c objServicio;
    public static Planes__c objPlan;
    public static Case objCaso;
    
    public static void CreateData(){
        
        lstVariablesGlobales = new List<VariablesGlobales__c>();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        lstVariablesGlobales.add(vGlobal);
        
        lstPerfilesReglasOC = new List<Perfiles_Reglas_OC__c>();
        Perfiles_Reglas_OC__c vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario01';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zweAAA';
        vPerfil.Detalles__c = 'si la operación comercial no aplica para preventa y no tiene legalización';
        lstPerfilesReglasOC.add(vPerfil);
        vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario08';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zwYAAQ,00e400000014I5jAAE,00e400000013zwcAAA,00e40000001FZVvAAO,00e400000013zweAAA';
        vPerfil.Detalles__c = 'en estado activa o declinada';
        lstPerfilesReglasOC.add(vPerfil);
        insert lstPerfilesReglasOC;

        objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        ObjAccount.Phone = '3158181818';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        insert objAccount;

        objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;

        objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;

        objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
        insert objMunicipio;

        objSucursal = new Account();
        objSucursal.Name = 'Test Name Sucursal';
        objSucursal.Ciudad__c = objMunicipio.Id;
        objSucursal.Type = 'Prospecto';
        objSucursal.Cuenta__c = objAccount.Id;
        objSucursal.Estado_Cuenta__c='Activo';
        objSucursal.Direccion__c='Cr 8 20 00';
        objSucursal.Phone = '3158181818';
        objSucursal.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
        insert objSucursal;

        objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;

        objContact = new Contact(IsTEST__c = true);
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
        objContact.Ciudad__c = objMunicipio.Id;
        insert objContact;

        objProducto = new CatalogoProductos__c();
        objProducto.Name = 'TELEFONIA MOVIL (LTE)';
        objProducto.Familia__c = 'LTE';
        objProducto.LineaNegocio__c = 'Redes Móviles';
        objProducto.CodigoProducto__c = '7635736';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        objProducto.Crear_Linea__c=true;
        insert objProducto;
        
        objPlan = new Planes__c ();
        objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
        objPlan.NombredelProducto__c = objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 96000;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
        objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
        objPlan.LTE_PlanEstructurados__c = true;
        objPlan.LTE_TipoControl__c = 'Control';
        insert objPlan;
        
        objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;
        
        objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        //objCaso.AccountNumber__c = objAccount.AccountNumber;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan.Id;
        objCaso.Status = 'Abierto';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
        insert objCaso;
    }
    
    static testMethod void InsertCaseRelatedService(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();

        Profile p = [SELECT Id FROM Profile WHERE Name='Agentes / Analistas'];
        User u = new User(Alias = 'standt', Email='SegundoNivel@etb.com.co',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='SegundoNivel@etb.com.co.etbtest',Area__c = 'Escrita MiPymes');
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert u;
        }
        Test.startTest();
        
        objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.Operadores__c = 'ETB';
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CASO PQR').getRecordTypeId();
        objCaso.Origin = 'Teléfono';
        objCaso.Plan__c = objPlan.Id;
        objCaso.Status = 'Abierto';
        objCaso.Causal_Estado__c = 'Asignado';
        objCaso.Subject = 'Prueba cambio plan';
        objCaso.ContactId = objContact.id;
        objCaso.Aprobaciones__c = 'Inicial';
        objCaso.LTE_Servicio__c = objServicio.Id;
        objCaso.OwnerId = u.Id;
        insert objCaso;
        
        Test.stopTest();
    }

    static testMethod void InsertCaseForWhatsApp(){
        //Aca se crean los datos necesarios para la prueba
        CreateData();

        Profile p = [SELECT Id FROM Profile WHERE Name='Gerente De Segmento'];
        User testUser = [SELECT Id, username, profileId FROM User WHERE username LIKE 'autoproc%' LIMIT 1];
        Test.startTest();
         
        objCaso = new Case();
        objCaso.AccountId = objAccount.Id;
        objCaso.Fechaderadicacion__c = Date.today();
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        objCaso.Origin = 'Canal WhatsApp';
        objCaso.Status = 'Abierto';
        objCaso.ContactId = objContact.id;
        objCaso.OwnerId = testUser.Id;
        insert objCaso;
        objCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
        objCaso.Origin = 'Canal WhatsApp Empresas';
        objCaso.Status = 'Resuelto';
        update objCaso;
        Test.stopTest();
    }
    
    static testMethod void UpdateCaseOwner(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Agentes / Analistas'];
        User u = new User(Alias = 'standt', Email='SegundoNivel@etb.com.co',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='SegundoNivel@etb.com.co.etbtest',Area__c = 'Escrita MiPymes');
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert u;
        }
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        
        objCaso.OwnerId = u.Id;
        update objCaso;
        
        Test.stopTest();
    }
    
    static testMethod void UpdateCaseOwnerRetenciones(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Agentes / Analistas'];
        User u = new User(Alias = 'standt', Email='SegundoNivel@etb.com.co',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='SegundoNivel@etb.com.co.etbtest',Area__c = 'Retenciones MiPymes');
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert u;
        }
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        
        objCaso.OwnerId = u.Id;
        update objCaso;
        
        Test.stopTest();
    }
    
    static testMethod void UpdateCaseOwnerQueue(){
        
        Group g = new Group(Name='Cola Escrita MiPymes', type='Queue');
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert g;
            QueuesObject testQueue = new QueueSObject(QueueID = g.id, SobjectType = 'Case');
            insert testQueue;
        }
        //Aca se crean los datos necesarios para la prueba
        CreateData();
        Test.startTest();
        
        objCaso.OwnerId = g.Id;
        update objCaso;
        
        Test.stopTest();
    }
}