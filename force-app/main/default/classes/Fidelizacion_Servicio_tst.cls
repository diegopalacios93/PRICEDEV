/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Fidelizacion
Descripción:			Clase de prueba Fidelizacion_Servicio

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		05-12-2014	Hector Bayona(HB)		Creación de la clase
*******************************************************************************/

@isTest
private class Fidelizacion_Servicio_tst {
	
	static testMethod void fidelizacion() {
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		
        objPruebas_tst obj =new objPruebas_tst();
        
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	insert cliente;

        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
    	
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

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        topp.TipodeOperacionporplan__c='Descuento';
        insert topp;
        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        insert servicio;
        
        Fidelizacion__c fidel =new Fidelizacion__c(Cuenta__c = cliente.Id,Fecha_de_fidelizacion__c=Date.today());
        insert fidel;
        
        Fidelizacion_Servicio__c fs=new Fidelizacion_Servicio__c(
        				Fidelizacion__c=fidel.id,
        				Tipo_Operacion_por_Plan_cambio_de_plan__c=topp.id,
        				TOPP__c =topp.id,
        				Servicio_ETB__c=servicio.id			
        				);
        insert fs;
	}
	
	static testMethod void fidelizacionProveedorUMInsert() {
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Alarma Retencion',Mensaje__c='Id,Name,FechadeActivacion__c'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Alarma_Retencion',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudesAlarmaRetencion',Action__c='/action/GestorAlarma',EndPoint__c='https://salesforce.com/GestorAlarma'));
        insert vg;
        
        objPruebas_tst obj =new objPruebas_tst();
        
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	insert cliente;

        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
    	
    	Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
    	Account sucursal=obj.ObjAccount();
    	sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
    	insert sucursal;

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Catalogo__c = 'Portafolio Superior';
        insert Catalogo;

        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        insert plan;

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        topp.TipodeOperacionporplan__c='Descuento';
        insert topp;
        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        servicio.ProveedorUM__c = 'Proveedor';
        insert servicio;
        
        OperacionComercial__c oc = new OperacionComercial__c();
        oc.Estado__c = 'Pendiente';
        oc.FechadeActivacion__c=System.today();
        oc.Activo__c = servicio.Id;
        oc.EstadoAprovisionamiento__c = 'En Aprovisionamiento';
        oc.TOPP__c = topp.Id;
        oc.Plan__c = plan.Id;
        oc.CuentaCliente__c = cliente.Id;
        oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc;
        
        Fidelizacion__c fidel =new Fidelizacion__c(Cuenta__c = cliente.Id,Fecha_de_fidelizacion__c=Date.today());
        insert fidel;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        Test.startTest();
        
        Fidelizacion_Servicio__c fs=new Fidelizacion_Servicio__c(
        				Fidelizacion__c=fidel.id,
        				Tipo_Operacion_por_Plan_cambio_de_plan__c=topp.id,
        				TOPP__c =topp.id,
        				Servicio_ETB__c=servicio.id,
            			Estado_de_cierre__c = 'En curso con aliado'
        				);
        insert fs;
        
        oc.Fidelizacion__c = fs.Id;
        update oc;
        Test.stopTest();
	}
	
	static testMethod void fidelizacionProveedorUMupdate() {
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
		list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Alarma Retencion',Mensaje__c='Id,Name,FechadeActivacion__c'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Alarma_Retencion',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='GestorSolicitudesAlarmaRetencion',Action__c='/action/GestorAlarma',EndPoint__c='https://salesforce.com/GestorAlarma'));
        insert vg;
        
        objPruebas_tst obj =new objPruebas_tst();
        
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	insert cliente;

        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
    	
    	Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
    	Account sucursal=obj.ObjAccount();
    	sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
    	insert sucursal;

        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Catalogo__c = 'Portafolio Superior';
        insert Catalogo;

        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        insert plan;

        TOPP__c topp= obj.objTopp();
        topp.Plan__c=plan.id;
        topp.TipodeOperacionporplan__c='Descuento';
        insert topp;
        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        servicio.ProveedorUM__c = 'Proveedor';
        insert servicio;
        
        OperacionComercial__c oc = new OperacionComercial__c();
        oc.Estado__c = 'Pendiente';
        oc.FechadeActivacion__c=System.today();
        oc.Activo__c = servicio.Id;
        oc.EstadoAprovisionamiento__c = 'En Aprovisionamiento';
        oc.TOPP__c = topp.Id;
        oc.Plan__c = plan.Id;
        oc.CuentaCliente__c = cliente.Id;
        oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert oc;
        
        Fidelizacion__c fidel =new Fidelizacion__c(Cuenta__c = cliente.Id,Fecha_de_fidelizacion__c=Date.today());
        insert fidel;
        
        Fidelizacion_Servicio__c fs=new Fidelizacion_Servicio__c(
        				Fidelizacion__c=fidel.id,
        				Tipo_Operacion_por_Plan_cambio_de_plan__c=topp.id,
        				TOPP__c =topp.id,
        				Servicio_ETB__c=servicio.id,
            			Estado_de_cierre__c = 'En curso con aliado'
        				);
        insert fs;
        
        oc.Fidelizacion__c = fs.Id;
        update oc;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(500));
        Test.startTest();
        
        fs.Estado_de_cierre__c = 'No exitosa';
        fs.Valor_Facturacion__c = 1000;
        fs.valor_facturaci_n_nuevo__c = 1000;
        fs.Confirmaci_n_de_Monto_Relacionado__c = true;
        update fs;
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