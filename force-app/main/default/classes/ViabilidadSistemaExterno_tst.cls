@isTest
public class ViabilidadSistemaExterno_tst {
    @TestSetup
    static void setup(){
        objPruebas_tst obj =new objPruebas_tst();
        
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
            list<sobject> vg=new list<sobject>();
            vg.add(new Mensaje_Integracion__c(Name='Campos Ordenes Gestor PS',Mensaje__c='Id,Name'));
            vg.add(new Mensaje_Integracion__c(Name='Gestor_ViabilidadEspecifica_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
            vg.add(new ServiciosWeb__c(Name='GestorSolicitudes',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
            insert vg;
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
            plan.Name = 'testplannplanaplan';
        	plan.DisponibleSistemaExterno__c = true;
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
        
            OperacionComercial__c oc =obj.objOc();
            oc.CuentaCliente__c=cliente.id;
            oc.Activo__c=servicio.id;
            oc.Plan__c=plan.id;
            oc.SucursalDestino__c=sucursal.id;
            oc.SucursalOrigen__c=sucursal.id;
            oc.Oportunidad__c=opt.id;
            oc.TOPP__c=topp.id;
            oc.Legalizacion__c=leg.id;
            //oc.CompensacionDatos__c = objCompensacion.Id;
            insert oc;
    }

    @isTest
    public static void success(){
        Test.startTest();
        ViabilidadSistemaExterno_sch apcocs = new ViabilidadSistemaExterno_sch();
        SchedulableContext sc = null;
        apcocs.execute(sc);
        Test.stopTest();
    }
}