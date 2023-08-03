@isTest
public class IntegracionCoberturaCandidatos_tst {
    public static List<ServiciosWeb__c> oServicioWeb;

    @TestSetup
    static void makeData(){
        
        String strCampos = 'Id,Street,Poblacion__r.CodigoDane__c,Poblacion__r.Padre__r.CodigoDane__c,Descripcion_Cobertura__c';

        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Candidato Cobertura', Mensaje__c=strCampos));
        vg.add(new Mensaje_Integracion__c(Name='ConsultarCoberturaCandidato', Mensaje__c='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:ConsultarCoberturaMixta><tem:numeroOrden>dd</tem:numeroOrden><tem:direccion>{@Street}</tem:direccion><tem:codigoDepartamento>SUBSTRING({@Poblacion__r.Padre__r.CodigoDane__c},'+'0'+','+'2'+')</tem:codigoDepartamento><tem:codigoMunicipio>{@Poblacion_r.CodigoDane__c}</tem:codigoMunicipio></tem:ConsultarCoberturaMixta></soapenv:Body></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='SumaConsultarCobertura',EndPoint__c='http://procesossuma.app.etb.co/Servicios/Infraestructura/svcInfraestructura.svc',Action__c='http://tempuri.org/IsvcInfraestructura/ConsultarCoberturaMixta'));
       
        insert vg;

        oServicioWeb = LTE_DataGenerator_cls.confServicioWeb(true);

        Poblacion__c objPoblacion = new Poblacion__c();
        objPoblacion.Name = 'Bogota';
        objPoblacion.CodigoDane__c = '11000';
        objPoblacion.EsDepartamento__c = true;
        insert objPoblacion;

        Poblacion__c objPoblacion1 = new Poblacion__c();
        objPoblacion1.Name = 'Bogota';
        objPoblacion1.CodigoDane__c = '11001';
        objPoblacion1.EsMunicipio__c = true;
        objPoblacion1.Padre__c = objPoblacion.Id;
        insert objPoblacion1;

        Lead objLead = new Lead();
        objLead.FirstName ='Test ';
        objLead.LastName = 'Name';
        objLead.City= 'Bogota';
        objLead.Street = 'CL 49 No 13 - 33 OF. 1303';
        objLead.Poblacion__c = objPoblacion1.Id;
        objLead.Descripcion_Cobertura__c='';
        objLead.Company = 'Prueba';
        objLead.Status = 'Abrir';
        objLead.LeadSource = 'Anillo';
        System.debug(objLead);
        insert objLead;
    }

    @IsTest
    static void testCorrectIntegration(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Lead> candidatos = [SELECT Id,Street,Poblacion__r.CodigoDane__c,Poblacion__r.Padre__r.CodigoDane__c,Descripcion_Cobertura__c FROM Lead];
        List<Poblacion__c> poblacion = [SELECT Name, CodigoDane__c, EsMunicipio__c, Padre__c, EsDepartamento__c FROM Poblacion__c];
        
        Test.setMock(HttpCalloutMock.class, new IC_MockHttpResponse(200));
        Test.startTest();
        IntegracionCoberturaCandidatos_cls integracion = new IntegracionCoberturaCandidatos_cls();
        Map<Id,Map<String,Object>> result = integracion.GenerarDatamap(candidatos, '');
        String res = integracion.EnvioSuma(candidatos, result);
        Test.stopTest();
        
        Lead candidato = [SELECT Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c FROM Lead WHERE Id =:candidatos[0].Id];
		system.debug('*************************************');
		System.debug(candidato);
        System.assertEquals('', res, '[!] La respuesta de integracion genero un error y no debia');
        System.assertNotEquals('', candidato.Descripcion_Cobertura__c, '[!] Las descripciones de cobertura coinciden');
        System.assertNotEquals('', candidato.Tipo_de_Distancia__c, '[!] Los tipos de distancia coinciden');
        System.assertNotEquals('', candidato.Tecnologia__c, '[!] Las tecnologias coinciden');
    }

    @IsTest
    static void testFailedIntegration(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Lead> candidatos = [SELECT Id,Street,Poblacion__r.CodigoDane__c,Poblacion__r.Padre__r.CodigoDane__c,Descripcion_Cobertura__c FROM Lead];
        List<Poblacion__c> poblacion = [SELECT Name, CodigoDane__c, EsMunicipio__c, Padre__c, EsDepartamento__c FROM Poblacion__c];
        
        Test.setMock(HttpCalloutMock.class, new IC_MockHttpResponse(500));
        Test.startTest();
        IntegracionCoberturaCandidatos_cls integracion = new IntegracionCoberturaCandidatos_cls();
        Map<Id,Map<String,Object>> result = integracion.GenerarDatamap(candidatos, '');
        String res = integracion.EnvioSuma(candidatos, result);
        Test.stopTest();
        
        System.assertEquals('Argument 1 cannot be null', res, '[!]Los mensajes de error no coinciden');
    }

    @IsTest
    static void testIntegracionCoberturaControllerGenerarIntegracion(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Lead> candidatos = [SELECT Id,Name,Street,Poblacion__r.CodigoDane__c,Poblacion__r.Padre__r.CodigoDane__c FROM Lead];
        Test.setMock(HttpCalloutMock.class, new IC_MockHttpResponse(200));
        Test.startTest();
        /*IntegracionCobertura_ctr integracionCoberturaVFPage = new IntegracionCobertura_ctr(new Apexpages.Standardcontroller(cuentas[0]));
        integracionCoberturaVFPage.acc=cuentas;
        integracionCoberturaVFPage.currentRecordId=cuentas[0].Id;
        integracionCoberturaVFPage.generarIntegracion();*/
        //IntegracionCobertura_ctr response = new IntegracionCobertura_ctr;
        /*response.acc=cuentas;
        response.lstAccount = cuentas;
        Account ac = response.Integracion();*/
        System.debug(candidatos + '********************************');
        List<Lead> lds = IntegracionCoberturaCandidatos_ctr.Integracion(candidatos);
        
        Test.stopTest();

        Lead candidato = [SELECT Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c FROM Lead WHERE Id =:candidatos[0].Id];
        System.assertNotEquals('', candidato.Descripcion_Cobertura__c, '[!] Las descripciones de cobertura coinciden');
        System.assertEquals('AE', candidato.Tipo_de_Distancia__c, '[!] Los tipos de distancia coinciden');
        System.assertEquals('COBRE', candidato.Tecnologia__c, '[!] Las tecnologias coinciden');
    }

    public class IC_MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        
        public IC_MockHttpResponse(Integer statusCode){
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {

            if(this.statusCode == 200){
                string response='<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">'
                                +'	<s:Body>'
                                +'		<ConsultarCoberturaMixtaResponse xmlns="http://tempuri.org/">'
                                +'			<ConsultarCoberturaMixtaResult>true</ConsultarCoberturaMixtaResult>'
                                +'			<coberturasDisponible xmlns:a="http://schemas.datacontract.org/2004/07/PortalFibra.Modelo.ModeloCliente" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
                                +'				<a:Cobertura>'
                                +'				<a:_x003C_Codigo_Lote_x003E_k__BackingField>34</a:_x003C_Codigo_Lote_x003E_k__BackingField>'
                                +'				<a:_x003C_Direccion_GIS_x003E_k__BackingField>612802304578620057</a:_x003C_Direccion_GIS_x003E_k__BackingField>'
                                +'				<a:_x003C_Distrito_x003E_k__BackingField>07090</a:_x003C_Distrito_x003E_k__BackingField>'
                                +'				<a:_x003C_Estrato_x003E_k__BackingField>6</a:_x003C_Estrato_x003E_k__BackingField>'
                                +'				<a:_x003C_Latitud_x003E_k__BackingField>4.674838808</a:_x003C_Latitud_x003E_k__BackingField>'
                                +'				<a:_x003C_Localidad_x003E_k__BackingField>09</a:_x003C_Localidad_x003E_k__BackingField>'
                                +'				<a:_x003C_Longitud_x003E_k__BackingField>-74.14797334</a:_x003C_Longitud_x003E_k__BackingField>'
                                +'				<a:_x003C_Molecula_x003E_k__BackingField>07090</a:_x003C_Molecula_x003E_k__BackingField>'
                                +'				<a:_x003C_NombreCobertura_x003E_k__BackingField>07090</a:_x003C_NombreCobertura_x003E_k__BackingField>'
                                +'				<a:_x003C_Proposito_x003E_k__BackingField>21</a:_x003C_Proposito_x003E_k__BackingField>'
                                +'				<a:_x003C_Tecnologia_x003E_k__BackingField>COBRE</a:_x003C_Tecnologia_x003E_k__BackingField>'
                                +'				<a:_x003C_TipoDistancia2_x003E_k__BackingField>A 300 M</a:_x003C_TipoDistancia2_x003E_k__BackingField>'
                                +'				<a:_x003C_TipoDistancia_x003E_k__BackingField>AE</a:_x003C_TipoDistancia_x003E_k__BackingField>'
                                +'				<a:_x003C_Tipo_Cobertura_x003E_k__BackingField>DISTRITO</a:_x003C_Tipo_Cobertura_x003E_k__BackingField>'
                                +'				<a:_x003C_Viable_x003E_k__BackingField>false</a:_x003C_Viable_x003E_k__BackingField>'
                                +'				<a:_x003C_Zona_x003E_k__BackingField>BOGO03</a:_x003C_Zona_x003E_k__BackingField>'
                                +'			    </a:Cobertura>'
                                +'		    </coberturasDisponible>'
                                +'		    <direccionNormalizada>CL 17 103B 37</direccionNormalizada>'
                                +'		<mensajeError/>'
                                +'	    </ConsultarCoberturaMixtaResponse>'
                                +'	</s:Body>'
                                +'</s:Envelope>';
                System.debug('Ingresa mock');

                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
                res.setBody(response);
                res.setStatusCode(this.statusCode);
                return res;
            }else{
                String strResponse = '';
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
                res.setBody(strResponse);
                res.setStatusCode(this.statusCode);
                return res;
            }
        }
    }
}