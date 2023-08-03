@isTest
private class PS_EnvioViabilidadOportunidad_tst{
    static testMethod void ViabilidadOportunidadTest() {
        GeneraData_cls.generarData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Oportunidad Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadConsultiva_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        test.startTest();
        PS_EnvioViabilidadOportunidad_ctr cls = new PS_EnvioViabilidadOportunidad_ctr();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.opp.id);                
        cls.Cancelar();
        cls.Iniciar();
        cls.Crear();        
        cls.GenerarIntegracion();
        cls.Cancelar();
        test.stopTest();
    }
}