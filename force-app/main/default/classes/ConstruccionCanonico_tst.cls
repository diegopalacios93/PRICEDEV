@isTest
public with sharing class ConstruccionCanonico_tst {
    
    static testMethod void canonico01() {

        MockServiciosWeb.variablesMock.put('billingResponse','Y');

        objPruebas_tst.confPersonalizadas();
        Map<String,sObject> objx=objPruebas_tst.general();


        Map<string,string> escenarios=new Map<string,string>();
        escenarios.put('objPlanFacturacion.Name','Compensacion');
        escenarios.put('objPlanFacturacion.Codigo__c','2468');
        objPruebas_tst.revchain(objx, escenarios);

        
        list<OperacionComercial__c> listOC = new list<OperacionComercial__c>();
        listOC.add((OperacionComercial__c)objx.get('oc'));

        MockServiciosWeb.variablesMock.put('billingResponse','Y');
        MockServiciosWeb.variablesMock.put('status','PASS');
        MockServiciosWeb.variablesMock.put('SuscriberId','1234567890');


        
        test.startTest();
        system.debug('Aqui mirar');
        Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseRevchainOK());
        
        //ConstruccionCanonico_cls can = new ConstruccionCanonico_cls();
        //can.CrearFacturacion(listOC);
        String jobId = System.schedule('Facturacion_bch','0 0 0 * * ? *',new Facturacion_sch());
        String jobIdLD = System.schedule('FacturacionLD_bch','0 0 0 * * ? *',new FacturacionLD_sch());


        test.stopTest();
        
        
    
    }



    static testMethod void canonico02() {


        objPruebas_tst.valoreGlobalesTest.put('OCmoneda__c','Dolares');
        
        objPruebas_tst.confPersonalizadas();
        Map<String,sObject> objx=objPruebas_tst.general();


        Map<string,string> escenarios=new Map<string,string>();
        escenarios.put('campoDependiente','Capacidad__c');
        objPruebas_tst.revchain(objx, escenarios);
        objPruebas_tst.revchainSolTI(objx, escenarios);
        objPruebas_tst.revchainSolTI2(objx, escenarios);
        objPruebas_tst.revchainSolTI3(objx, escenarios);
        
        
        list<OperacionComercial__c> listOC = new list<OperacionComercial__c>();
        listOC.add((OperacionComercial__c)objx.get('oc'));

        MockServiciosWeb.variablesMock.put('billingResponse','N');
        MockServiciosWeb.variablesMock.put('status','FAIL');
        MockServiciosWeb.variablesMock.put('SuscriberId','1234567890');

        PlanFacturacion__c plan = [select id from PlanFacturacion__c limit 1];
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseRevchainOK());
        ConstruccionCanonico_cls can = new ConstruccionCanonico_cls();
        can.CrearFacturacion(listOC);

        test.stopTest();
        
    
    }
    
    
    static testMethod void canonico03SolTI() {


        objPruebas_tst.valoreGlobalesTest.put('OCmoneda__c','Dolares');
        
        objPruebas_tst.confPersonalizadas();
        Map<String,sObject> objx=objPruebas_tst.general();


        Map<string,string> escenarios=new Map<string,string>();
        escenarios.put('campoDependiente','Capacidad__c');
        objPruebas_tst.revchainSolTI(objx, escenarios);
        objPruebas_tst.revchainSolTI2(objx, escenarios);
        objPruebas_tst.revchainSolTI3(objx, escenarios);
        objPruebas_tst.revchainSolTI4(objx, escenarios);
        objPruebas_tst.revchainSolTI5(objx, escenarios);

        
        list<OperacionComercial__c> listOC = new list<OperacionComercial__c>();
        listOC.add((OperacionComercial__c)objx.get('oc2'));
        listOC.add((OperacionComercial__c)objx.get('oc3'));
        listOC.add((OperacionComercial__c)objx.get('oc4'));
        listOC.add((OperacionComercial__c)objx.get('oc5'));
        listOC.add((OperacionComercial__c)objx.get('oc6'));

        MockServiciosWeb.variablesMock.put('billingResponse','Y');
        MockServiciosWeb.variablesMock.put('status','PASS');
        MockServiciosWeb.variablesMock.put('SuscriberId','1234567890');
        MockServiciosWeb.variablesMock.put('SolucionTI','[lista=(ParametroFacturacion__c:{PlanSolucionTI__c=a0zf00000012Qo4AAE, Id=a0if0000001ISo1AAG, Name=Participacion Aliado DS, Campo__c=Valor_unica_Vez_Aliado__c, Comillas__c=false, Obligatorio__c=false, Financiador__c=false}, ParametroFacturacion__c:{PlanSolucionTI__c=a0zf00000012Qo4AAE, Id=a0if0000001ISoBAAW, Name=Participacion ETB DS, Campo__c=Valorunicavez__c, Comillas__c=false, Obligatorio__c=false, Financiador__c=false}), plan=Alianza NETDATA Colaborador CNR, producto=Cargo No Recurrente DS, servicio=Routing, Switching y Wireless]');

        test.startTest();
        system.debug(label.ProductosEspeciales.split(','));
        Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseRevchainOK());
        ConstruccionCanonico_cls can = new ConstruccionCanonico_cls();
        try {
            can.CrearFacturacion(listOC);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        
        test.stopTest();
        
    
    }

    static testMethod void validacion() {

        //PRODUCTO, PLAN, TOPP, PLAN FACTURACION,PRODUCTO FACTURACION,SUBPLAN FACTURACION,PARAMETRO FACTURACION,
        //EjecucionIntegracion__c,Homologacion Campos,HomologacionSegmentos,HomologacionSegmentos2

        objPruebas_tst.confPersonalizadas();
        Map<String,sObject> objx=objPruebas_tst.general();
        OperacionComercial__c sglOP =(OperacionComercial__c)objx.get('oc');
        
        sglOP.estado__c = 'Activa';
        Map<Id,OperacionComercial__c> listOC = new Map<Id,OperacionComercial__c>();
        listOC.put(sglOP.id,sglOP);
        
        
        OperacionComercial__c nesglOP = [SELECT Planes_Convenio_Cupo__c, Valorunicavez__c, Tarifa__c, Margen_Soluciones_TI__c, Duracion_Meses__c, Duracion_Dias__c, EnvSopVen__c, FechadeActivacion__c, Fecha_Final_Estado__c, EnvGteProy__c, ValorTarifaPlan__c, Estado__c, Destinatario_Notificacion_Cambio_Estados__c, Incidencia_en_ingresos__c, TipodeInternetSeguridadenlaNube__c, Categoria__c, EnvioFacturacion__c, Tipo_de_Conectividad__c, Moneda__c, RangosDisponibilidad__c, CuentaCliente__c, Activo__c, Plan__c, SucursalDestino__c, SucursalOrigen__c, Oportunidad__c, IDServicio__c, RecordTypeId, TOPP__c, Legalizacion__c, CuentaFacturacion__c, Id FROM OperacionComercial__c WHERE Id=:sglOP.id];
        nesglOP.estado__c = 'Pendiente';
        Map<Id,OperacionComercial__c> nlistOC = new Map<Id,OperacionComercial__c>();
        nlistOC.put(nesglOP.id,nesglOP);
        
        test.startTest();

        ConstruccionCanonico_cls fac = new ConstruccionCanonico_cls();
        fac.llamadoFacturacion(listOC,nlistOC);

        test.stopTest();
        
    
    }


}