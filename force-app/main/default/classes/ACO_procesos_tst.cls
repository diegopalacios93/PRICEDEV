/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripcion:            Clase de test de todos los metodos necesarios para 
                        asegurar el proceso de los ACO

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     14-06-2021  Luisina Platino (LP)    Creacion de la clase.
*******************************************************************************/

@IsTest
public class ACO_procesos_tst {

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
        opp.StageName = 'Propuesta de valor';
        opp.PDC__c = '80% - Probabilidad de Éxito';
        opp.Tipo_de_Operacion__c = 'Venta';
        opp.Amount = 100000;
        opp.ForecastCategoryName = 'En Construcción';
        opp.Valor_unica_vez_ETB__c = 12000;
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
        aco.RecordTypeId = Schema.SObjectType.ACO__c.getRecordTypeInfosByName().get('ACO').getRecordTypeId();
        aco.Actividad__c = 'Entrega Soportes por Preventa';
        aco.Estado_Actividad__c = 'Pendiente';
        aco.Nombre_de_la_Oportunidad__c = opp.Id;
        aco.Identificador_Oferta_OP__c = oferta.Id;
        aco.Nombre_del_Cliente__c = acc.Id;

        insert aco;

        Id viaEspecificaRecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByName().get('Viabilidad Específica').getRecordTypeId();

        Viabilidad__c via = new Viabilidad__c();
        via.recordTypeId = viaEspecificaRecordTypeId;
        via.EstadoViabilidad__c = 'Pendiente';
        via.Respuestadeviabilidad__c = 'Viable';
        via.Observaciones__c = 'viable';
        via.Correo_Ing_Factibilidad__c = 'asd@gmail.com';

        insert via;

        Oferta_Op_Viabilidad__c ofopv = new Oferta_Op_Viabilidad__c();
        ofopv.Viabilidad__c = via.Id;
        ofopv.Oferta_Op__c = oferta.Id;
        
        insert ofopv;
    }
    
    @IsTest
    static void testSiPrimerActividadFinaliza_CambiaASegundaActividad(){

        ACO__c aco = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        aco.Estado_Actividad__c = 'Finalizado';
        
        Test.startTest();
        update aco;
        Test.stopTest();

        ACO__c result = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        System.assertEquals('Pendiente', result.Estado_Actividad__c, '[!] Los Estado Actividad no coinciden');
        System.assertEquals('Reunión de entendimiento', result.Actividad__c, '[!] Las Actividad no coinciden');
    }

    @IsTest
    static void testSiQuintaActividadFinaliza_CambiaASextaActividadYEnviaNotificacion(){

        ACO__c aco = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        aco.Actividad__c = 'Verificación OF';
        aco.Estado_Actividad__c = 'Oferta actualizada';
        
        Test.startTest();
        update aco;
        Test.stopTest();

        ACO__c result = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        System.assertEquals('Pendiente', result.Estado_Actividad__c, '[!] Los Estado Actividad no coinciden');
        System.assertEquals('Memorando Negociación y Configuradores', result.Actividad__c, '[!] Las Actividad no coinciden');
    }

    @IsTest
    static void testSiEsEtapaIntermedia_NoModifica(){

        ACO__c aco = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        aco.Estado_Actividad__c = 'En revisión';
        
        Test.startTest();
        update aco;
        Test.stopTest();

        ACO__c result = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        System.assertEquals('En revisión', result.Estado_Actividad__c, '[!] Los Estado Actividad no coinciden');
        System.assertEquals('Entrega Soportes por Preventa', result.Actividad__c, '[!] Las Actividad no coinciden');
    }

    @IsTest
    static void testSiACODevueltoConObservaciones_EnviaMail(){

        ACO__c aco = [SELECT Observaciones__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        aco.Estado_Actividad__c = 'Devuelto';
        aco.Observaciones__c = 'adsadsadsadsaddsadadada';
        
        Test.startTest();
        update aco;
        System.assertEquals(1, Limits.getEmailInvocations(), '[!] No se envió mail');
        Test.stopTest();

        ACO__c result = [SELECT Actividad__c, Estado_Actividad__c FROM ACO__c LIMIT 1];

        System.assertEquals('Devuelto', result.Estado_Actividad__c, '[!] Los Estado Actividad no coinciden');
    }


}