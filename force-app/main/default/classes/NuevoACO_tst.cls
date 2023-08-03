@isTest
public class NuevoACO_tst {
    @IsTest
    static void testGetAccountId(){

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

        Account acc2 = new Account();
        acc2.Name = 'cuentacuentacuenta12';
        acc2.recordTypeId = clientePrincipalRecordTypeId;
        acc2.Type = 'Prospecto';
        acc2.AccountNumber='240321';
        acc2.Segmento__c='Empresas';
        acc2.SubSegmento__c='Grandes';
        acc2.Tipodedocumento__c='NIT';
        acc2.Estado_Cuenta__c='Activo';
        acc2.Phone='3054658973';
        insert acc2;

        Id opEspecialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oportunidad Especial').getRecordTypeId();

        Opportunity opp = new Opportunity();
        opp.recordTypeId = opEspecialRecordTypeId;
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
        
        ACO__c aco = new ACO__c();
        aco.Actividad__c = 'Entrega Soportes por Preventa';
        aco.Estado_Actividad__c = 'Pendiente';
        aco.Nombre_del_Cliente__c = acc.Id;
        aco.Identificador_Oferta_OP__c = oferta.Id;
        aco.Nombre_de_la_Oportunidad__c = opp.Id;

        insert aco;
        
        Test.startTest();
        String result = NuevoACO_ctr.getAccountId(opp.Id);
        Test.stopTest();

        System.assertEquals(acc.Id, result, '[!] No coincide el Id del Account');
        
    }
}