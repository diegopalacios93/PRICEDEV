/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_CancelarTarea_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     06/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_CancelarTarea_tst {
    
    /**
     * @description inserción de registros de prueba para los métodos test
     */
    @testSetup 
    static void setup() 
    {
        Account cuenta;
        Contact contacto;
        Grupo_Aseguramiento__c grupoAseguramiento;
        CatalogoProductos__c producto;
        ActivoETB__c servicio;
        Case caso;
        ServiciosWeb__c objServiciosWeb;
        CE_Schedule__c agendamiento;
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
        agendamiento = CE_TestDataFactory_cls.createSchedule(caso.Id);
        insert agendamiento;
    }
    
    /**
     * @description prueba de cancelación de una tarea de agendamiento
     */
    @isTest 
    static void cancelTaskTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_StatusOutput__c, CE_ScheduleIdOutput__c 
                                       FROM Ce_Schedule__c Limit 1];
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCancelacion.estadoAgendamiento = agendamiento.CE_StatusOutput__c;
        parametroCancelacion.scheduleId = agendamiento.CE_ScheduleIdOutput__c;
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        List<CE_CancelarTarea_cls.ResultadoCancelacion> resultadoCancelacion = new List<CE_CancelarTarea_cls.ResultadoCancelacion>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>AGENDA CANCELADA EXITOSAMENTE</a:DetalleEstado><a:Estado>OK</a:Estado><a:FechaRespuesta>1/5/2022 3:29:13 PM</a:FechaRespuesta></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        resultadoCancelacion = CE_CancelarTarea_cls.cancelarTareaRemedy(new List<CE_CancelarTarea_cls.ParametrosCancelacion>{parametroCancelacion});
        Test.stopTest();
        System.assert(resultadoCancelacion[0].operacionExitosa);
    }
    
    /**
     * @description prueba de cancelación de una tarea de agendamiento sin un Id Agenda asociado
     */
    @isTest 
    static void noScheduleId() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_StatusOutput__c, CE_ScheduleIdOutput__c 
                                       FROM Ce_Schedule__c Limit 1];
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCancelacion.estadoAgendamiento = agendamiento.CE_StatusOutput__c;
        parametroCancelacion.scheduleId = '';
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        List<CE_CancelarTarea_cls.ResultadoCancelacion> resultadoCancelacion = new List<CE_CancelarTarea_cls.ResultadoCancelacion>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>AGENDA CANCELADA EXITOSAMENTE</a:DetalleEstado><a:Estado>OK</a:Estado><a:FechaRespuesta>1/5/2022 3:29:13 PM</a:FechaRespuesta></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoCancelacion = CE_CancelarTarea_cls.cancelarTareaRemedy(new List<CE_CancelarTarea_cls.ParametrosCancelacion>{parametroCancelacion});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCancelacion[0].operacionExitosa);
    }
    
    /**
     * @description prueba de cancelación de una tarea de agendamiento cuando no hay información para la conexión con 
     * 				el servicio web asociado
     */
    @isTest 
    static void noWSTest() 
    {
        Test.startTest();
        ServiciosWeb__c objServiciosWeb = [SELECT ID FROM ServiciosWeb__c Limit 1];
        delete objServiciosWeb;
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_StatusOutput__c, CE_ScheduleIdOutput__c 
                                       FROM Ce_Schedule__c Limit 1];
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCancelacion.estadoAgendamiento = agendamiento.CE_StatusOutput__c;
        parametroCancelacion.scheduleId = agendamiento.CE_ScheduleIdOutput__c;
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        List<CE_CancelarTarea_cls.ResultadoCancelacion> resultadoCancelacion = new List<CE_CancelarTarea_cls.ResultadoCancelacion>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>AGENDA CANCELADA EXITOSAMENTE</a:DetalleEstado><a:Estado>OK</a:Estado><a:FechaRespuesta>1/5/2022 3:29:13 PM</a:FechaRespuesta></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoCancelacion = CE_CancelarTarea_cls.cancelarTareaRemedy(new List<CE_CancelarTarea_cls.ParametrosCancelacion>{parametroCancelacion});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCancelacion[0].operacionExitosa);
    }
    
    /**
     * @description prueba de cancelación de una tarea de agendamiento con respuesta fallida
     */
    @isTest 
    static void cancelTaskFailedTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_StatusOutput__c, CE_ScheduleIdOutput__c 
                                       FROM Ce_Schedule__c Limit 1];
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCancelacion.estadoAgendamiento = agendamiento.CE_StatusOutput__c;
        parametroCancelacion.scheduleId = agendamiento.CE_ScheduleIdOutput__c;
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        List<CE_CancelarTarea_cls.ResultadoCancelacion> resultadoCancelacion = new List<CE_CancelarTarea_cls.ResultadoCancelacion>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>F01</a:Codigo><a:DetalleEstado>FALLO AL CANCELAR AGENDA</a:DetalleEstado><a:Estado>OK</a:Estado><a:FechaRespuesta>1/5/2022 3:29:13 PM</a:FechaRespuesta></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoCancelacion = CE_CancelarTarea_cls.cancelarTareaRemedy(new List<CE_CancelarTarea_cls.ParametrosCancelacion>{parametroCancelacion});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCancelacion[0].operacionExitosa);
    }
    
    /**
     * @description prueba de cancelación de una tarea de agendamiento con falla en el servicio web
     */
    @isTest 
    static void failedWSTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_StatusOutput__c, CE_ScheduleIdOutput__c 
                                       FROM Ce_Schedule__c Limit 1];
        CE_CancelarTarea_cls.ParametrosCancelacion parametroCancelacion = new CE_CancelarTarea_cls.ParametrosCancelacion();
        parametroCancelacion.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCancelacion.estadoAgendamiento = agendamiento.CE_StatusOutput__c;
        parametroCancelacion.scheduleId = agendamiento.CE_ScheduleIdOutput__c;
        parametroCancelacion.notas = 'Notas';
		parametroCancelacion.motivoCancelacion = 'Motivos';
        List<CE_CancelarTarea_cls.ResultadoCancelacion> resultadoCancelacion = new List<CE_CancelarTarea_cls.ResultadoCancelacion>();
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutExceptionMock_tst());
        try{
			resultadoCancelacion = CE_CancelarTarea_cls.cancelarTareaRemedy(new List<CE_CancelarTarea_cls.ParametrosCancelacion>{parametroCancelacion});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCancelacion[0].operacionExitosa);
    }
}