@isTest
private class PS_IntegracionSalidaGestor_tst{
    @testSetup 
    static void setup() {
        List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>();
        LTE_APN__c nLTEAPN = new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        
        nLTEAPN = new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable');
        lstLTEAPN.add(nLTEAPN);
        insert lstLTEAPN;
    }
    
    static testMethod void IntegracionSalidaGestorTest() {
        DateTime dts = DateTime.now();
        GeneraData_cls.generarData();
        Test.startTest();
        PS_IntegracionSalidaGestor_cls.integracionAprovisionamiento(GeneraData_cls.oc3.id, GeneraData_cls.oc3.Name,null, null, null, null);
        PS_IntegracionSalidaGestor_cls.integracionActualizacionServicio(GeneraData_cls.oc3.id, GeneraData_cls.oc3.Name);
        PS_IntegracionSalidaGestor_cls.integracionViabilidad(GeneraData_cls.oc3.id, GeneraData_cls.oc3.Name, 'OperacionComercial', null, null, null);
        PS_IntegracionSalidaGestor_cls.integracionViabilidad(GeneraData_cls.opp.id, GeneraData_cls.opp.Name, 'Oportunidad', null, null, null);
        PS_IntegracionSalidaGestor_cls.FormatearFecha(dts);
		Test.stopTest();
    }
    
    static testMethod void IntegracionSalidaGestorDinamicaAprovTest(){
        GeneraData_cls.generarData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        Linea__c objLinea = new Linea__c(Name = '3057000501',Codigo_de_linea__c = '3057000501');
        insert objLinea;
        Lineas_OC__c objLineaOC = new Lineas_OC__c(Operacion_Comercial__c=GeneraData_cls.oc3.Id,Linea__c=objLinea.Id,Tipo_relacion__c = 'Producto Ppal Voz',Accion__c='Adicionar',Estado__c='Activa');
        insert objLineaOC;
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        Test.startTest();
        PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
        Set<Id> tmpId = new Set<Id>();
        tmpId.add(GeneraData_cls.oc3.id);
        Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(tmpId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO);
        pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO);
		Test.stopTest();
    }
    
    static testMethod void IntegracionSalidaGestorAliado(){
        GeneraData_cls.generarData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Aliado_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='OrchAliado',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        Linea__c objLinea = new Linea__c(Name = '3057000501',Codigo_de_linea__c = '3057000501');
        insert objLinea;
        Lineas_OC__c objLineaOC = new Lineas_OC__c(Operacion_Comercial__c=GeneraData_cls.oc3.Id,Linea__c=objLinea.Id,Tipo_relacion__c = 'Producto Ppal Voz',Accion__c='Adicionar',Estado__c='Activa');
        insert objLineaOC;
        LTE_Servicios_adicionales__c sglSVA = new LTE_Servicios_adicionales__c();
        sglSVA.Name= 'SVA';
        sglSVA.LTE_OC_Tramite__c = GeneraData_cls.oc3.id;
        insert sglSVA;
        LTE_SpecificationGroupXA__c sglXA = new LTE_SpecificationGroupXA__c();
        sglXA.Name= 'Parametro';
        sglXA.LTE_ServiciosAdicionales__c = sglSVA.Id;
        insert sglXA;
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        Test.startTest();
        PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
        Set<Id> tmpId = new Set<Id>();
        tmpId.add(GeneraData_cls.oc3.id);
        Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(tmpId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO);
        pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO);
		Test.stopTest();
    }
    
    static testMethod void IntegracionSalidaGestorDinamicaViaTest(){
        GeneraData_cls.generarData();
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadEspecifica_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        Test.startTest();
        PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
        Set<Id> tmpId = new Set<Id>();
        tmpId.add(GeneraData_cls.via3.id);
        Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(tmpId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
        pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
		Test.stopTest();
    }
    
    static testMethod void test_method_two() 
    {
        GeneraData_cls.generarData();
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        Test.startTest();
		BatchGenerico_bch bch = new BatchGenerico_bch();
        Set<Id> lstId = new Set<Id>();
        lstId.add(GeneraData_cls.oc3.id);
		bch.idImediato = lstId;
        bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO;
        ID batchprocessid = Database.executeBatch(bch,1);
		Test.stopTest();
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