@isTest
public class CrearOC_tst {
    @TestSetup
    static void setup(){
        
        objPruebas_tst obj =new objPruebas_tst();
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='Convenio de cupo';
        Catalogo.CodigoProducto__c='Conveniodecupo001';

        
        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.Name='Comunicaciones Unificadas Eservice';
        plan.IdUnico__c='PlanLargaDistancia';
        insert plan;

        CatalogoProductos__c Catalogo2 =obj.objCatalogo();
        Catalogo2.Name='Convenio de cupo';
        Catalogo2.CodigoProducto__c='Conveniodecupo001';

        
        planes__c plan2 =obj.objPlan();
        plan2.NombredelProducto__c=Catalogo2.id;
        plan2.Name='E1';
        plan2.IdUnico__c='E1';
        insert plan2;

        TOPP__c topp = new TOPP__c();
        topp.Plan__c = plan2.Id;
        topp.Tipoderegistro__c = 'Venta_Enlaces_de_Voz';
        topp.TipodeOperacionporplan__c = 'Venta';
        insert topp;
        
        Account cuenta = obj.objAccount();
        insert cuenta;
        Contact contactoA = obj.objContact();
        contactoA.AccountId = cuenta.Id;
        insert contactoA;

        Id idSuc = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sucursales').getRecordTypeId();
        Account sucursal = obj.objAccount();
        sucursal.Cuenta__c = cuenta.Id;
        sucursal.RecordTypeId = idSuc;
        insert sucursal;
    }

    @isTest
    static void testSuccess(){
        Planes__c plan = [SELECT Id FROM Planes__c WHERE Name = 'Comunicaciones Unificadas Eservice'LIMIT 1];
        Account cuenta = [SELECT Id FROM Account WHERE RecordType.DeveloperName != 'Sucursales' LIMIT 1];
        Account sucursal = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Sucursales' LIMIT 1];
        Contact contacto = [SELECT Id FROM Contact LIMIT 1];
        List<CrearOCWrapper.XA> XAs = new List<CrearOCWrapper.XA>();
        Test.startTest();
            CrearOC_ws.doPost(String.valueOf(plan.Id), String.valueOf(cuenta.Id),2,String.valueOf(contacto.Id), String.valueOf(contacto.Id), String.valueOf(sucursal.Id), 50000, '2 Autoattendant', 12, XAs);
        Test.stopTest();
    }

    @isTest
    static void testSuccess2(){
        Planes__c plan = [SELECT Id FROM Planes__c WHERE Name = 'E1' LIMIT 1];
        Account cuenta = [SELECT Id FROM Account WHERE RecordType.DeveloperName != 'Sucursales' LIMIT 1];
        Account sucursal = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Sucursales' LIMIT 1];
        Contact contacto = [SELECT Id FROM Contact LIMIT 1];
        List<CrearOCWrapper.XA> XAs = new List<CrearOCWrapper.XA>();
        Test.startTest();
            CrearOC_ws.doPost(String.valueOf(plan.Id), String.valueOf(cuenta.Id),2, String.valueOf(contacto.Id), String.valueOf(contacto.Id), String.valueOf(sucursal.Id), 50000, '2 Autoattendant', 12, XAs);
        Test.stopTest();
    }
    
    @isTest
    static void testError(){
        
        List<CrearOCWrapper.XA> XAs = new List<CrearOCWrapper.XA>();
        Test.startTest();
            CrearOC_ws.doPost('', '',null, '', '', '', 50000, '2 Autoattendant', 12, XAs);
        Test.stopTest();
    }
}