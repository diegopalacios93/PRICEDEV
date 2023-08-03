/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR FASE II
Descripción:        Clase de prueba para los métodos genericos de integración con Revchain.

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-01-12   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
@isTest
public class PS_UtilitaryMethodsClass_tst {
  
        public static Dom.Document docXML = new Dom.Document();
        public static String metodo = '/Service/EnterpriseCatalogRevchain.serviceagent//InvokeServiceProvisioningOp';
        public static String endpoint = 'http://201.245.171.239:5020/Service/EnterpriseCatalogRevchain.serviceagent/EnterpriseCatalogRevchainEndpoint	';
        public static Dom.XMLNode rootNode;
        public static String nodeName = 'Service';
        public static List<String> numbers = new list<String>{ '13795633|SI' , '13795634|NO' , '13795635|NO'};
   		public static Map<string,string> valoreGlobalesTest =new Map<string,string>();
    
     	public static String xml = '<?xml version="1.0" encoding="UTF-8"?>'
                                        +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
                                            +'<SOAP-ENV:Body>'
                                                +'<ns1:InvokeServiceProvisioningOutput xmlns:ns1="http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0">'
                                                    +'<ns2:WSResponseHeader2 xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
                                                        +'<ns2:System>'
                                                            +'<ns2:name>Tibco</ns2:name>'
                                                            +'<ns2:correlationID>a09m0000003QkR5AAK</ns2:correlationID>'
                                                            +'<ns2:processingServer>Tibco</ns2:processingServer>'
                                                        +'</ns2:System>'
                                                        +'<ns2:Service>'
                                                            +'<ns2:status>PASS</ns2:status>'
                                                            +'<ns2:responseDate>2019-02-28T16:38:22.957-05:00</ns2:responseDate>'
                                                        +'</ns2:Service>'
                                                    +'</ns2:WSResponseHeader2>'
                                                    +'<ns1:BodyResponse>'
                                                        +'<ns2:response system="RevChain" operation="P" result="E" xmlns:ns2="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/RVCResponse">'
                                                            +'<ns2:faults>'
                                                                +'<ns2:subscriber_id>12052842234</ns2:subscriber_id>'
                                                                +'<ns2:fault_detail error_description="[RevChainServiceConnectionException: 2019-02-28 16:37:26.931 newtibco 10014 ConnectionConnectionNumberRules.validateConnectionNumber(bundle) Connection Number is not currently available for assignment. Connection Number = 13795634. ]" error_code="10014"/>'
                                                                +'<ns2:fault_detail error_description="[RevChainServiceConnectionException: 2019-02-28 16:37:26.932 newtibco 10014 ConnectionConnectionNumberRules.validateConnectionNumber(bundle) Connection Number is not currently available for assignment. Connection Number = 13795635. ]" error_code="10014"/>'
                                                            +'</ns2:faults>'
                                                        +'</ns2:response>'
                                                    +'</ns1:BodyResponse>'
                                                +'</ns1:InvokeServiceProvisioningOutput>'
                                            +'</SOAP-ENV:Body>'
                                        +'</SOAP-ENV:Envelope>';
    
    
      public static void createData(){
          
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
        ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');

        
        objPruebas_tst obj =new objPruebas_tst();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        
        Account cliente=obj.ObjAccount();
        cliente.RecordTypeId =devRecordTypeId;
        System.debug(devRecordTypeId);
        insert cliente;

        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        insert leg;
            
        Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
        Account sucursal=obj.ObjAccount();
        sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
        insert sucursal;

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        insert Catalogo;

        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        insert plan;


        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = plan.Id;
        insert objCompensacion;

        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion; 

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        insert topp;

        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;

        insert servicio;

        Id ocRecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('R1').getRecordTypeId();

        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.RecordTypeId=ocRecordTypeId;
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        insert oc;
 
    }
    
    static testMethod void InvokeServiceRequestDOM_OK_Test() {
        
		docXML.load(xml);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningOK());
        PS_UtilitaryMethodsClass_cls umc = new PS_UtilitaryMethodsClass_cls();
        try {
           umc.InvokeServiceRequestDOM(docXML, metodo, endpoint);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void InvokeServiceRequestDOM_NOK_Test() {
        
		docXML.load(xml);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningNOK());
        PS_UtilitaryMethodsClass_cls umc = new PS_UtilitaryMethodsClass_cls();
        try {
           umc.InvokeServiceRequestDOM(docXML, metodo, endpoint);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void InvokeServiceRequestDOM_CATCH_Test() {
        
		docXML.load(xml);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningCatch());
        PS_UtilitaryMethodsClass_cls umc = new PS_UtilitaryMethodsClass_cls();
        try {
           umc.InvokeServiceRequestDOM(docXML, metodo, endpoint);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        test.stopTest();
        
    }
    
    static testMethod void getNodeFromDomXMLNodeTest() {
        
        docXML.load(xml);
        rootNode = docXML.getRootElement();
        PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(rootNode, nodeName);
        
    }
    
    static testMethod void getNodeFromDomDocumentTest() {
        
        docXML.load(xml);
        PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docXML, nodeName);
        
	}
    
    static testMethod void addNumbersToLineaObjectTest() {
        
        createData();
        List<OperacionComercial__c> OC = [SELECT Id, name FROM OperacionComercial__c];
		PS_UtilitaryMethodsClass_cls.addNumbersToLineaObject(OC[0], numbers);
        
	}
      
}