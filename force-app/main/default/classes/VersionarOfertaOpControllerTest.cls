@IsTest
public class VersionarOfertaOpControllerTest {

    @TestSetup
    static void makeData(){

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Integraciones'];

        User u = new User();
        u.Alias = 'intusr';
        u.Email='intusr@testorg.com'; 
		u.EmailEncodingKey='UTF-8';
        u.LastName='Testing';
        u.LanguageLocaleKey='en_US'; 
		u.LocaleSidKey='en_US'; 
        u.ProfileId = p.Id;
		u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='intusr@testorg.com';
        u.IsActive = true;
        //u.Es_ingeniero__c = true;

        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();

        Account cuenta = new Account();
        cuenta.Name = 'Test Account';
        cuenta.RecordTypeId = accrecordTypeId;
        cuenta.Phone = '12345678';
        cuenta.Tipodedocumento__c = 'NIT';
        cuenta.AccountNumber = '860000751';

        insert cuenta;

        Id conrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contacto Clave Comercial').getRecordTypeId();
        Contact contacto = new Contact();
        contacto.LastName = 'Test Contact';
        contacto.RecordTypeId = conrecordTypeId;
        contacto.AccountId = cuenta.Id;
        contacto.Phone = '12345698';
        contacto.Estado__c = 'Activo';

        insert contacto;

        Opportunity objOportunidad = new Opportunity();
        objOportunidad.Name = 'Test name';
        objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
        objOportunidad.AccountId = cuenta.Id;
        objOportunidad.StageName = 'Análisis de necesidades';
        objOportunidad.CloseDate = system.today();
        objOportunidad.Amount = 1000;
        objOportunidad.Valor_unica_vez_ETB__c = 150;
        objOportunidad.LTE_Scoring__c = 9000000;
        objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
        objOportunidad.LTE_NumeroLinea__c = 2;

        insert objOportunidad;

        Oferta_Op__c oferta = new Oferta_Op__c();
        oferta.RecordTypeId = Schema.SObjectType.Oferta_Op__c.getRecordTypeInfosByName().get('Gestionado').getRecordTypeId();
        oferta.Causal_de_Rechazo__c = '';
        oferta.Concepto__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
        oferta.Configurador_vs_Viabilidad_Preventa__c = false;
        oferta.Configurador_vigente__c = false;
        oferta.Contacto__c = contacto.Id;
        oferta.Costo_Recurrente_Reventa__c = 123000;
        oferta.Costo_Unica_Vez_Reventa__c = 180000;
        oferta.Cronograma__c = false;
        oferta.Duracion_en_Dias__c = 120;
        oferta.Duracion_en_Meses__c = 3;
        oferta.Elaboracion_Modelo_de_Negocio__c = u.Id;
        oferta.Estado_Oferta__c = 'Aprobada Control Gestión';
        oferta.Fecha_de_Validacion__c = Date.today();
        oferta.Fecha_Envio_Flujo_de_Aprobacion__c = Datetime.now();
        oferta.Fecha_Presentacion_Oferta__c = Date.today();
        oferta.Fecha_Validacion_Oferta__c = Datetime.now();
        oferta.Fecha_Vigencia_Oferta__c = Date.today().addDays(15) ;
        oferta.Forma_de_Pago_Alineado__c = false;
        oferta.Imprevistos_Soluciones_TI__c = 1000;
        oferta.Margen_adicional_Tarifa_Piso__c = 10;
        oferta.Margen_Soluciones_TI__c = 10;
        oferta.Modelo_Financiero__c = false;
        oferta.Nombre_de_la_cuenta__c = 'Donec risus';
        oferta.Oferta_con_condiciones_vigentes__c = true;
        oferta.Operaciones_Comerciales_OF__c = 'sapien, maximus eu viverra non, facilisis at est';
        oferta.Oportunidad__c = objOportunidad.Id;
        oferta.Soportes_descuentos_comerciales__c = false;
        oferta.Tipo_de_contrato__c = 'Adición';
        oferta.Tipo_de_Validacion__c = 'Oportuna';
        oferta.Valor_Recurrente_Aliado__c = 20000;
        oferta.Valor_Recurrente_ETB__c = 15000;
        oferta.Valor_Recurrente_ETB_Pp__c = 123000;
        oferta.Valor_Recurrente_ETB_STI__c = 57800;
        oferta.Valor_sin_destinacion_especifica__c = 1000;
        oferta.Valor_Total_Oferta_Con_IVA__c = 15789000;
        oferta.Valor_Total_Producto_Propio__c = 5461200;
        oferta.Valor_Total_Soluciones_TI__c = 564612000;
        oferta.Valor_nica_vez_Aliado__c = 1454621;
        oferta.Valor_nica_vez_ETB__c = 584612;
        oferta.Valor_unica_vez_ETB_Pp__c = 87652; 
        oferta.Valor_unica_vez_ETB_STI__c = 848512;
        oferta.Version__c = 1;
        oferta.Vias_y_o_tareas_cerradas__c = false;

        insert oferta;
      
    }

    @IsTest
    static void testVersionarOferta(){

        Oferta_Op__c oferta = [SELECT Id, Name, Version__c FROM Oferta_Op__c LIMIT 1];    

        Oferta_Op__c objOff = new Oferta_Op__c();
        objOff.Motivo_de_versionamiento__c = 'Nuevo alcance Técnico';
        objOff.Comentarios__c = 'asd';
        
        Test.startTest();
        try{
            VersionarOfertaOpController.createOffer(objOff, oferta.Id);
        }
        catch(exception e){}        
        Test.stopTest();

        Oferta_Op__c ofe = [
            SELECT Id, Version__c, Motivo_de_versionamiento__c, Comentarios__c, VersionIndex__c 
            FROM Oferta_Op__c 
            WHERE Id <>: oferta.Id 
            LIMIT 1
        ]; 

        Oferta_Op__c ofertaFinal = [SELECT RecordTypeId FROM Oferta_Op__c WHERE Id =: oferta.Id]; 

        Id versionadoRecordTypeId = Schema.SObjectType.Oferta_Op__c.getRecordTypeInfosByName().get('Versionado').getRecordTypeId();

        String versionHijo = oferta.Name+'-2';

        System.assertNotEquals(oferta.Id, ofe.Id);
        System.assertEquals(oferta.Version__c+1, ofe.Version__c, '[!] No se aumento correctamente el versionamiento');
        System.assertEquals(objOff.Motivo_de_versionamiento__c, ofe.Motivo_de_versionamiento__c, '[!] El motivo de versionamiento no coincide');
        System.assertEquals(objOff.Comentarios__c, ofe.Comentarios__c, '[!] El comentario no coincide');
        System.assertEquals(versionadoRecordTypeId, ofertaFinal.RecordTypeId, '[!] El comentario no coincide');
        System.assertEquals(versionHijo, ofe.VersionIndex__c, '[!] La version no coincide');
    }

    @IsTest
    static void testGetMotivo(){
        Test.startTest();
        Map<String, String> motivos = VersionarOfertaOpController.getMotivo();
        Test.stopTest();

        System.assertEquals('Cambio de costo', motivos.get('Cambio de costo'), '[!] Los motivos no coinciden');
    }
}