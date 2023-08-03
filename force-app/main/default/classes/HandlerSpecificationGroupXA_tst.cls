@isTest
public class HandlerSpecificationGroupXA_tst {
    @TestSetup
    static void setup(){

    }

    @isTest
    static void testSuccess(){
        Test.startTest();
            
            VariablesGlobales__c vGlobal = new VariablesGlobales__c();
            vGlobal.Name = 'NombreComercialLTE';
            vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
            insert vGlobal;
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
    
        
            LTE_Servicios_adicionales__c SA = new LTE_Servicios_adicionales__c();
            SA.Name = 'Servicio Adicional CSC - '+ Datetime.now();
            SA.LTE_ServicioETB__c = servicio.Id;
            SA.LTE_Operacion_Comercial_SVA__c = oc.Id;
            insert SA;
        
            LTE_SpecificationGroupXA__c xaNew = new LTE_SpecificationGroupXA__c();
            xaNew.LTE_Value__c = '30';
            xaNew.ApiName__c = 'Duracion_Meses__c';
            xaNew.LTE_ServiciosAdicionales__c = SA.Id;
            insert xaNew;
        Test.stopTest();
    }

}