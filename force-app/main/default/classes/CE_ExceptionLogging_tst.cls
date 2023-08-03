/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para las clase CE_ExceptionLogging_tgr

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     23/11/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ExceptionLogging_tst 
{
    /**
     * @description inserción de registros de prueba para los métodos test
     */
    @testSetup static void setup() 
    {
        Account cuenta;
        Contact contacto;
        Grupo_Aseguramiento__c grupoAseguramiento;
        CatalogoProductos__c producto;
        ActivoETB__c servicio;
        Case caso;
        ServiciosWeb__c objServiciosWeb;
        cuenta = CE_TestDataFactory_cls.createAccount();
        insert cuenta;
        contacto = CE_TestDataFactory_cls.createContact(cuenta.Id);
        insert contacto;
        grupoAseguramiento = CE_TestDataFactory_cls.createInsuranceGroup();
        insert grupoAseguramiento;
        producto = CE_TestDataFactory_cls.createProduct();
        insert producto;
		servicio = CE_TestDataFactory_cls.createService(producto.Id, cuenta.Id);
        insert servicio;
        caso = CE_TestDataFactory_cls.createCase(contacto.Id, cuenta.Id, servicio.Id, grupoAseguramiento.Id);
        insert caso;
        objServiciosWeb = CE_TestDataFactory_cls.createWebService();
        insert objServiciosWeb;
    }
    
    /**
     * @description envío de un agendamiento correcto con un response exitoso
     */
    @isTest 
    static void createScheduleTest() 
    {
        Test.startTest();
        Case caso = [SELECT Id FROM Case Limit 1];
        Map<String, Object> scheduleForm = new Map<String, Object>();
        scheduleForm.put('date',Date.today()+1);
        scheduleForm.put('timeSlot', '08AM-9AM');
        scheduleForm.put('timeFormat','08:00:00');
        scheduleForm.put('resourceId', 'ASEG_RE_BOGOTA'); 
        scheduleForm.put('XA_request_type','inmediata');
        scheduleForm.put('XA_Zone','ASEG_RE_BOGOTA');
        scheduleForm.put('aworkzone','BOGOTÁ');
        scheduleForm.put('WorkSkill', 'ASEGEMPCU');
        scheduleForm.put('XA_Action_Type', 'ASEGEMP (CU)');
        scheduleForm.put('XA_Description', 'OK');
        Map<String, String> scheduleResult = new Map<String, String>();
        String body = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"> <SOAP-ENV:Body> <ns0:CreateScheduleRemedyOutput xmlns:ns0="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP"> <ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"> <ns1:System> <ns1:name>TIBCO</ns1:name> <ns1:correlationID>INC000004699221</ns1:correlationID> <ns1:processingServer>TIBCO</ns1:processingServer> </ns1:System> <ns2:Service xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP" xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"> <ns2:status>PASS</ns2:status> <ns2:responseDate>2021-11-18T15:59:50.16-05:00</ns2:responseDate> </ns2:Service> </ns1:WSResponseHeader2> <ns2:response xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP" xmlns:ns2="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyMsg"> <CreacionAgendaRemedyResponse xmlns="http://tempuri.org/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"> <Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"> <a:Encabezado> <a:Servicio> <a:Codigo>O01</a:Codigo> <a:DetalleEstado>AGENDAMIENTO EXITOSO</a:DetalleEstado> <a:Estado>OK</a:Estado> </a:Servicio> </a:Encabezado> <a:CedulasTecnicos/> <a:Estado>Pendiente</a:Estado> <a:EstadoProcesadoAgendamiento>Exitoso</a:EstadoProcesadoAgendamiento> <a:FechaHoraAgendaConfirmada>2021-11-18 09:00:00</a:FechaHoraAgendaConfirmada> <a:GrupoAsignado>ASEGURAMIENTO BOGOTA SDH METRO</a:GrupoAsignado> <a:IdAgenda>8736531</a:IdAgenda> <a:IdTareaCreadaRemedy>TAS000000098739</a:IdTareaCreadaRemedy> <a:SoportesIngreso/> <a:SubEstado>Pendiente Recurso</a:SubEstado> <a:TecnicosAsignados/> <a:TipoSolicitud>inmediata</a:TipoSolicitud> </Resultado> </CreacionAgendaRemedyResponse> </ns2:response> </ns0:CreateScheduleRemedyOutput> </SOAP-ENV:Body></SOAP-ENV:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
		scheduleResult = CE_ConstruirCanonicoScheduleRemedy_cls.orquestarIntegracion(scheduleForm, caso.Id);
        Test.stopTest();
        System.assertNotEquals(null, scheduleResult, 'Se realizó el agendamiento');
    }
}