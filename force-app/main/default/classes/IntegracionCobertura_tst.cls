@isTest
public class IntegracionCobertura_tst {
    public static List<ServiciosWeb__c> oServicioWeb;

    @TestSetup
    static void makeData(){
        
        String strCampos = 'Id,Direccion__c,Ciudad__r.CodigoDane__c,Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Padre__c,Descripcion_Cobertura__c';

        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Cuenta Cobertura', Mensaje__c=strCampos));
        vg.add(new Mensaje_Integracion__c(Name='ConsultarCobertura', Mensaje__c='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"><soapenv:Header/><soapenv:Body><tem:ConsultarCoberturaMixta><tem:numeroOrden>dd</tem:numeroOrden><tem:direccion>{@Direccion__c}</tem:direccion><tem:codigoDepartamento>SUBSTRING({@Ciudad__r.Padre__r.CodigoDane__c},'+'0'+','+'2'+')</tem:codigoDepartamento><tem:codigoMunicipio>{@Ciudad__r.CodigoDane__c}</tem:codigoMunicipio></tem:ConsultarCoberturaMixta></soapenv:Body></soapenv:Envelope>'));
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

        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        ObjAccount.Phone = '3158181818';
        objAccount.SubSegmento__c = 'Mediana';  
        objAccount.Direccion__c = 'CL 17 103B 37';
        objAccount.Ciudad__c = objPoblacion1.Id;
        objAccount.Descripcion_Cobertura__c='';
        insert objAccount;
    }

    @IsTest
    static void testCorrectIntegration(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Account> cuentas = [SELECT Id,Name,Direccion__c,Ciudad__r.CodigoDane__c,Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Padre__c,Descripcion_Cobertura__c FROM Account];
        List<Poblacion__c> poblacion = [SELECT Name, CodigoDane__c, EsMunicipio__c, Padre__c, EsDepartamento__c FROM Poblacion__c];
        
        Test.setMock(HttpCalloutMock.class, new IC_MockHttpResponse(200));
        Test.startTest();
        IntegracionCobertura_cls integracion = new IntegracionCobertura_cls();
        Map<Id,Map<String,Object>> result = integracion.GenerarDatamap(cuentas, '');
        String res = integracion.EnvioSuma(cuentas, result);
        Test.stopTest();

        Account cuenta = [SELECT Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c,Proposito__c FROM Account WHERE Id =:cuentas[0].Id];
        System.assertEquals('', res, '[!] La respuesta de integracion genero un error y no debia');
        System.assertNotEquals('', cuenta.Descripcion_Cobertura__c, '[!] Las descripciones de cobertura coinciden');
        System.assertNotEquals('', cuenta.Tipo_de_Distancia__c, '[!] Los tipos de distancia coinciden');
        System.assertNotEquals('', cuenta.Tecnologia__c, '[!] Las tecnologias coinciden');
        System.assertNotEquals('', cuenta.Proposito__c, '[!] Las tecnologias coinciden');
    }

    @IsTest
    static void testFailedIntegration(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Account> cuentas = [SELECT Id,Name,Direccion__c,Ciudad__r.CodigoDane__c,Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Padre__c,Descripcion_Cobertura__c FROM Account];
        List<Poblacion__c> poblacion = [SELECT Name, CodigoDane__c, EsMunicipio__c, Padre__c, EsDepartamento__c FROM Poblacion__c];
        
        Test.setMock(HttpCalloutMock.class, new IC_MockHttpResponse(500));
        Test.startTest();
        IntegracionCobertura_cls integracion = new IntegracionCobertura_cls();
        Map<Id,Map<String,Object>> result = integracion.GenerarDatamap(cuentas, '');
        String res = integracion.EnvioSuma(cuentas, result);
        Test.stopTest();
        
        System.assertEquals('Argument 1 cannot be null', res, '[!]Los mensajes de error no coinciden');
    }

    @IsTest
    static void testIntegracionCoberturaControllerGenerarIntegracion(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Account> cuentas = [SELECT Id,Name,Direccion__c,Ciudad__r.CodigoDane__c,Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Padre__c,Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c FROM Account];
        List<Poblacion__c> poblacion = [SELECT Name, CodigoDane__c, EsMunicipio__c, Padre__c, EsDepartamento__c FROM Poblacion__c];
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
        List<Account> acs = IntegracionCobertura_ctr.Integracion(cuentas);
        Test.stopTest();

        Account cuenta = [SELECT Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c,Proposito__c FROM Account WHERE Id =:cuentas[0].Id];
        System.assertNotEquals('', cuenta.Descripcion_Cobertura__c, '[!] Las descripciones de cobertura coinciden');
        System.assertEquals('AE', cuenta.Tipo_de_Distancia__c, '[!] Los tipos de distancia coinciden');
        System.assertEquals('COBRE', cuenta.Tecnologia__c, '[!] Las tecnologias coinciden');
        System.assertEquals('21', cuenta.Proposito__c, '[!] Las propositos coinciden');
    }

    @IsTest
    static void testIntegracionCoberturaControllerGenerarIntegracion2(){

        List<Mensaje_Integracion__c> mensajeInt = [SELECT Name, Mensaje__c FROM Mensaje_Integracion__c];
        ServiciosWeb__c sw = [SELECT Name, Endpoint__c, Action__c FROM ServiciosWeb__c LIMIT 1];

        List<Account> cuentas = [SELECT Id,Name,Direccion__c,Ciudad__r.CodigoDane__c,Ciudad__r.Padre__r.CodigoDane__c,Ciudad__r.Padre__c,Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c FROM Account];
        List<Poblacion__c> poblacion = [SELECT Name, CodigoDane__c, EsMunicipio__c, Padre__c, EsDepartamento__c FROM Poblacion__c];
        Test.setMock(HttpCalloutMock.class, new IC_MockHttpResponse(200));
        Test.startTest();
        IntegracionCobertura_ctr integracionCoberturaVFPage = new IntegracionCobertura_ctr(new Apexpages.Standardcontroller(cuentas[0]));
        integracionCoberturaVFPage.acc=cuentas;
        integracionCoberturaVFPage.currentRecordId=cuentas[0].Id;
        integracionCoberturaVFPage.generarIntegracion();
        //IntegracionCobertura_ctr response = new IntegracionCobertura_ctr();
        //response.acc=cuentas;
        //response.lstAccount = cuentas;
        //Account ac = response.Integracion();
        Test.stopTest();

        Account cuenta = [SELECT Descripcion_Cobertura__c,Tipo_de_Distancia__c,Tecnologia__c,Proposito__c FROM Account WHERE Id =:cuentas[0].Id];
        System.assertNotEquals('', cuenta.Descripcion_Cobertura__c, '[!] Las descripciones de cobertura coinciden');
        System.assertEquals('AE', cuenta.Tipo_de_Distancia__c, '[!] Los tipos de distancia coinciden');
        System.assertEquals('COBRE', cuenta.Tecnologia__c, '[!] Las tecnologias coinciden');
        System.assertEquals('21', cuenta.Proposito__c, '[!] Las propositos coinciden');
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