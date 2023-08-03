@isTest
private class PS_EnvioAPVS_Individual_tst{
    static testMethod void EnvioAPVSIndividualTest() {
        GeneraData_cls.generarData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        Insert vGlobal;
        GeneraData_cls.oc3.Integrar_con_gestor__c = true;
        update GeneraData_cls.oc3;
        PS_EnvioAPVS_Individual_ctr cls = new PS_EnvioAPVS_Individual_ctr();
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        test.startTest();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.oc3.id);
        ApexPages.currentPage().getParameters().put('status',GeneraData_cls.oc3.Estado__c);
        cls.AnalizaAccion();
        cls.GenerarIntegracion();
        cls.Cancelar();
        test.stopTest();
    }
    static testMethod void EnvioAPVSIndividualTest_2() {
        GeneraData_cls.generarData();
        GeneraData_cls.topp.AplicaPreventa__c = false;
        update GeneraData_cls.topp;
        
        PS_EnvioAPVS_Individual_ctr cls = new PS_EnvioAPVS_Individual_ctr();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.oc.id);
        ApexPages.currentPage().getParameters().put('status',GeneraData_cls.oc.Estado__c);
        cls.AnalizaAccion();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.oc2.id);
        ApexPages.currentPage().getParameters().put('status',GeneraData_cls.oc2.Estado__c);
        cls.AnalizaAccion();
      //  cls.GenerarIntegracion();
        cls.Cancelar();
    }
    
    public class PS_MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        
        public PS_MockHttpResponse(Integer statusCode){
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            String strResponse = '';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(this.statusCode);
            return res;
        }
    }
}