@isTest
public class LookupCompControllerTest {

    @TestSetup
    static void makeData(){
        
        Id clientePrincipalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();

        Account acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.recordTypeId = clientePrincipalRecordTypeId;
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3054658978';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oferta Comercial').getRecordTypeId();
        opp.Name = 'Test';
        opp.AccountId = acc.Id;
        opp.StageName = 'Negociación Cerrada';
        opp.PDC__c = '80% - Probabilidad de Éxito';
        opp.CloseDate = Date.today()+5;

        insert opp;

        Oferta_Op__c oferta = new Oferta_Op__c();
        oferta.RecordTypeId = Schema.SObjectType.Oferta_Op__c.getRecordTypeInfosByName().get('Gestionado').getRecordTypeId();
        oferta.Nombre_de_la_cuenta__c = 'Donec risus';
        oferta.Oportunidad__c = opp.Id;
        oferta.Concepto__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
        oferta.Fecha_Presentacion_Oferta__c = Date.today();
        oferta.Estado_Oferta__c = 'En Proceso';

        insert oferta;
    }

    @IsTest
    static void testLookupCompController_forOfertaOp(){

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Oferta_Op__c ofop = [SELECT Id FROM Oferta_Op__c LIMIT 1];

        List<String> clause = new List<String>();
        clause.add('Oportunidad__c='+'\''+opp.Id+'\'');
        List<String> extrafields = new List<String>();
        List<Id> asd = new List<Id>();
        asd.add(opp.Id);
        
        Test.startTest();
        String result = LookupCompController.search('Oferta_Op__c', 'OF-', clause, extrafields);
        List<SObject> result2 = LookupCompController.getRecentlyViewed('Oferta_Op__c', asd,'OF-', 'Name', clause, extrafields);
        Test.stopTest();

        System.assertEquals(ofop.Id, result2[0].Id, '[!] Los Id no coinciden');
        
    }
}