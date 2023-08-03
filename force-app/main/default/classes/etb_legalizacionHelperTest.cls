@isTest
public class etb_legalizacionHelperTest {
	@TestSetup
    public static void makeData(){
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        
        Legalizacion__c legalizacion = new Legalizacion__c(
            RecordTypeId = Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByDeveloperName().get('Legalizacion').getRecordTypeId(),
            //Contrato__c = '800780000008MwEAAU',
            DeclaraciondeRenta__c = false,
            Estado__c = 'No Gestionado',
            SuperintendenciaFinanciera__c = false,
            //Nombredelacuenta2__c = '00178000009WOmwAAG',
            Destinatario_Notificacion_Cambio_Estados__c = 'joliveira@labsxd.com',
            Fecha_Final_Estado__c = Date.newInstance(2022,07,21),
            Cuotas__c = 0.0,
            LTE_FacturaEnviada__c = 'No enviado',
            LTE_PagoRealizado__c = false,
            Portacion__c = 'No',
            TieneEquiposAdquiridosETB__c = false,
            Aplica_APN__c = false,
            Portado_con_Cedula_c__c = false,
            Legalizacion_servicios_Demo__c = false);
        insert legalizacion;
        System.debug('legalizacion');

        Legalizacion__c legalizacion1 = new Legalizacion__c(
            RecordTypeId = Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByDeveloperName().get('Legalizacion').getRecordTypeId(),
            //Contrato__c = '800780000008MwEAAU',
            DeclaraciondeRenta__c = false,
            Estado__c = 'No Gestionado',
            SuperintendenciaFinanciera__c = false,
            //Nombredelacuenta2__c = '00178000009WOmwAAG',
            Destinatario_Notificacion_Cambio_Estados__c = 'testingerrorcase@labsxd.com',
            Fecha_Final_Estado__c = Date.newInstance(2022,07,21),
            Cuotas__c = 0.0,
            LTE_FacturaEnviada__c = 'No enviado',
            LTE_PagoRealizado__c = false,
            Portacion__c = 'Si',
            TieneEquiposAdquiridosETB__c = false,
            Aplica_APN__c = false,
            Portado_con_Cedula_c__c = false,
            Legalizacion_servicios_Demo__c = false);
        insert legalizacion1;
        System.debug('legalizacion1');
        
        Order order = new Order(
            //ContractId = '800780000008MwEAAU',
            AccountId = accountBusiness.Id,
            Pricebook2Id = '01s40000000NGTqAAO',
            RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('SubOrder').getRecordTypeId(),
            EffectiveDate = Date.newInstance(2022,07,12),
            Status = 'Ready to Provision',
            Type = 'Venta',
            vlocity_cmt__CreatedByAPI__c = false,
            //vlocity_cmt__DefaultBillingAccountId__c = '00178000009ixlpAAA',
            vlocity_cmt__DefaultCurrencyPaymentMode__c = 'Currency',
            //vlocity_cmt__DefaultServiceAccountId__c = '00178000009ixlaAAA',
            vlocity_cmt__JeopardySafetyIntervalUnit__c = 'Seconds',
            vlocity_cmt__OneTimeLoyaltyTotal__c = 0.0,
            vlocity_cmt__OneTimeMarginTotal__c = 0.0,
            vlocity_cmt__OneTimeTotal2__c = 0.0,
            vlocity_cmt__OrderMarginTotal__c = 50.42,
            vlocity_cmt__OrderStatus__c = 'Ready To Submit',
            //vlocity_cmt__ParentOrderId__c = '80178000000Ub64AAC',
            //vlocity_cmt__PriceListId__c = 'a7b780000008ONeAAM',
            //vlocity_cmt__QuoteId__c = '0Q078000000HIGVCA4',
            vlocity_cmt__RecurringMarginTotal__c = 50.42,
            vlocity_cmt__RecurringTotal2__c = 0.0,
            vlocity_cmt__UsageMarginTotal__c = 0.0,
            vlocity_cmt__ForceSupplementals__c = false,
            Legalizaci_n__c = legalizacion.Id);
        insert order;
        System.debug('order');

    }
    
    @IsTest
    static void flowLegalization(){
        
        List<Legalizacion__c> legalist = [Select Id,Estado__c FROM Legalizacion__c LIMIT 2];
        System.debug('lista ' + legalist);
        
        Test.startTest();      
        for (Legalizacion__c Leg : legalist) {      
            Leg.Estado__c = 'Gestionado';
        }
        try{
            Update legalist;
            
        }catch(Exception ex){
            System.debug('Error Catched');
            Test.stopTest();   
        }
    }
}