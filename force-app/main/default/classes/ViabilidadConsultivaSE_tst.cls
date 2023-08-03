@isTest
public  class ViabilidadConsultivaSE_tst {
    @TestSetup
    static void setup(){
        objPruebas_tst obj =new objPruebas_tst();
        
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
            Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Licitacion').getRecordTypeId();
            list<sobject> vg=new list<sobject>();
            vg.add(new Mensaje_Integracion__c(Name='Campos Oportunidad Gestor PS',Mensaje__c='Id,Name'));
            vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadConsultiva_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
            vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
            insert vg;
            Account cliente=obj.ObjAccount();
            cliente.RecordTypeId =devRecordTypeId;
            System.debug(devRecordTypeId);
            insert cliente;
    

    
            CatalogoProductos__c Catalogo =obj.objCatalogo();
            insert Catalogo;
    
            planes__c plan =obj.objPlan();
            plan.NombredelProducto__c=Catalogo.id;
            plan.Name = 'testplannplanaplan';
        	plan.DisponibleSistemaExterno__c = true;
            insert plan;

            
            Opportunity opt=obj.objOpt();
            opt.AccountId=cliente.id;
            opt.RecordTypeId = oppRecordTypeId;
            opt.Plan__c = plan.Id;
            insert opt;
        
    }

    @isTest
    public static void success(){
        Test.startTest();
        ViabilidadConsultivaSE_sch apcocs = new ViabilidadConsultivaSE_sch();
        SchedulableContext sc = null;
        apcocs.execute(sc);
        Test.stopTest();
    }
}