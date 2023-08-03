/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarCierreTarea_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     06/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarCierreTarea_tst {

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
     * @description prueba de consulta del cierre de una tarea de agendamiento
     */
    @isTest 
    static void getClosingTaskTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        CE_ConsultarCierreTarea_cls.ParametrosCierre parametroCierre = new CE_ConsultarCierreTarea_cls.ParametrosCierre();
        parametroCierre.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCierre.taskId = agendamiento.CE_TaskId__c;
        List<CE_ConsultarCierreTarea_cls.ResultadoCierre> resultadoCierre = new List<CE_ConsultarCierreTarea_cls.ResultadoCierre>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos>VEHICULO SIN ACCESO</a:CedulasTecnicos><a:Estado>CERRADO</a:Estado><a:FechaHoraAgendaConfirmada>INFORMATIVO</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>VISITA FALLIDA</a:GrupoAsignado><a:SoportesIngreso>VEHICULO SIN ACCESO</a:SoportesIngreso><a:SubEstado>FUERZA MAYOR</a:SubEstado><a:TecnicosAsignados>SIN ACCESO</a:TecnicosAsignados><a:TipoSolicitud>FUERZA MAYOR-VISITA FALLIDA-SIN ACCESO-VEHICULO SIN ACCESO-VEHICULO SIN ACCESOPruebas ddddddddd</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        resultadoCierre = CE_ConsultarCierreTarea_cls.consultarCierreRemedy(new List<CE_ConsultarCierreTarea_cls.ParametrosCierre>{parametroCierre});
        Test.stopTest();
        System.assert(resultadoCierre[0].operacionExitosa);
    }
    
    /**
     * @description prueba de consulta del cierre de una tarea de agendamiento sin un Id Tarea asociado
     */
    @isTest 
    static void noTaskId() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        CE_ConsultarCierreTarea_cls.ParametrosCierre parametroCierre = new CE_ConsultarCierreTarea_cls.ParametrosCierre();
        parametroCierre.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCierre.taskId = '';
        List<CE_ConsultarCierreTarea_cls.ResultadoCierre> resultadoCierre = new List<CE_ConsultarCierreTarea_cls.ResultadoCierre>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos>VEHICULO SIN ACCESO</a:CedulasTecnicos><a:Estado>CERRADO</a:Estado><a:FechaHoraAgendaConfirmada>INFORMATIVO</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>VISITA FALLIDA</a:GrupoAsignado><a:SoportesIngreso>VEHICULO SIN ACCESO</a:SoportesIngreso><a:SubEstado>FUERZA MAYOR</a:SubEstado><a:TecnicosAsignados>SIN ACCESO</a:TecnicosAsignados><a:TipoSolicitud>FUERZA MAYOR-VISITA FALLIDA-SIN ACCESO-VEHICULO SIN ACCESO-VEHICULO SIN ACCESOPruebas ddddddddd</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoCierre = CE_ConsultarCierreTarea_cls.consultarCierreRemedy(new List<CE_ConsultarCierreTarea_cls.ParametrosCierre>{parametroCierre});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCierre[0].operacionExitosa);
    }
    
    /**
     * @description prueba de consulta de cierre de una tarea de agendamiento cuando no hay información para la 
     * 				conexión con el servicio web asociado
     */
    @isTest 
    static void noWSTest() 
    {
        Test.startTest();
        ServiciosWeb__c objServiciosWeb = [SELECT ID FROM ServiciosWeb__c Limit 1];
        delete objServiciosWeb;
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        CE_ConsultarCierreTarea_cls.ParametrosCierre parametroCierre = new CE_ConsultarCierreTarea_cls.ParametrosCierre();
        parametroCierre.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCierre.taskId = agendamiento.CE_TaskId__c;
        List<CE_ConsultarCierreTarea_cls.ResultadoCierre> resultadoCierre = new List<CE_ConsultarCierreTarea_cls.ResultadoCierre>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos>VEHICULO SIN ACCESO</a:CedulasTecnicos><a:Estado>CERRADO</a:Estado><a:FechaHoraAgendaConfirmada>INFORMATIVO</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>VISITA FALLIDA</a:GrupoAsignado><a:SoportesIngreso>VEHICULO SIN ACCESO</a:SoportesIngreso><a:SubEstado>FUERZA MAYOR</a:SubEstado><a:TecnicosAsignados>SIN ACCESO</a:TecnicosAsignados><a:TipoSolicitud>FUERZA MAYOR-VISITA FALLIDA-SIN ACCESO-VEHICULO SIN ACCESO-VEHICULO SIN ACCESOPruebas ddddddddd</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoCierre = CE_ConsultarCierreTarea_cls.consultarCierreRemedy(new List<CE_ConsultarCierreTarea_cls.ParametrosCierre>{parametroCierre});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCierre[0].operacionExitosa);
    }
    
    /**
     * @description prueba de consulta de cierre de una tarea de agendamiento con respuesta fallida
     */
    @isTest 
    static void getClosingTaskFailedTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        CE_ConsultarCierreTarea_cls.ParametrosCierre parametroCierre = new CE_ConsultarCierreTarea_cls.ParametrosCierre();
        parametroCierre.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCierre.taskId = agendamiento.CE_TaskId__c;
        List<CE_ConsultarCierreTarea_cls.ResultadoCierre> resultadoCierre = new List<CE_ConsultarCierreTarea_cls.ResultadoCierre>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>F01</a:Codigo><a:DetalleEstado>Proceso Fallido</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoCierre = CE_ConsultarCierreTarea_cls.consultarCierreRemedy(new List<CE_ConsultarCierreTarea_cls.ParametrosCierre>{parametroCierre});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCierre[0].operacionExitosa);
    }
    
    /**
     * @description prueba de consulta de cierre de una tarea de agendamiento con falla en el servicio web
     */
    @isTest 
    static void failedWSTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        CE_ConsultarCierreTarea_cls.ParametrosCierre parametroCierre = new CE_ConsultarCierreTarea_cls.ParametrosCierre();
        parametroCierre.caseId = agendamiento.CE_ScheduleCase__c;
        parametroCierre.taskId = agendamiento.CE_TaskId__c;
        List<CE_ConsultarCierreTarea_cls.ResultadoCierre> resultadoCierre = new List<CE_ConsultarCierreTarea_cls.ResultadoCierre>();
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutExceptionMock_tst());
        try{
			resultadoCierre = CE_ConsultarCierreTarea_cls.consultarCierreRemedy(new List<CE_ConsultarCierreTarea_cls.ParametrosCierre>{parametroCierre});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        Test.stopTest();
        System.assert(!resultadoCierre[0].operacionExitosa);
    }
}