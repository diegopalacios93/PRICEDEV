/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarTareasRemedy_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     05/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarTareasRemedy_tst {
    
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
     * @description obtención de tareas de agendamiento asociadas a un incidente
     */
    @isTest 
    static void getTasksTest() 
    {
        Test.startTest();
        Case caso = [SELECT Id, Id_Sistema_Legado__c FROM Case Limit 1];
        List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask> listadoTareas = new List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"TaskID":"TAS000000098739","GrupoAsignado":"ASEGURAMIENTO BOGOTA SDH-METRO","Estado":"CERRADO"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
		listadoTareas = CE_ConsultarTareasRemedy_cls.obtenerTareas(caso.Id_Sistema_Legado__c, caso.Id);
        Test.stopTest();
        System.assert(listadoTareas.size()>0);
    }
    
    /**
     * @description prueba para un caso sin sistema legado asociado
     */
    @isTest 
    static void noLegacySystem() 
    {
        Test.startTest();
        Case caso = [SELECT Id, Id_Sistema_Legado__c FROM Case Limit 1];
        caso.Id_Sistema_Legado__c = '';
        List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask> listadoTareas = new List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"TaskID":"TAS000000098739","GrupoAsignado":"ASEGURAMIENTO BOGOTA SDH-METRO","Estado":"CERRADO"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try
        {
            listadoTareas = CE_ConsultarTareasRemedy_cls.obtenerTareas(caso.Id_Sistema_Legado__c, caso.Id);
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage() + ' tamaño resultado: '+listadoTareas.size());
        }
        Test.stopTest();
        System.assert(listadoTareas.size()==0);
    }
    
    /**
     * @description prueba de obtención de tareas de agendamiento cuando no hay información para la conexión con el
     * 				servicio web asociado
     */
    @isTest 
    static void noWSTest() 
    {
        Test.startTest();
        Case caso = [SELECT ID, Id_Sistema_Legado__c FROM Case Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID FROM ServiciosWeb__c Limit 1];
        delete objServiciosWeb;
        List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask> listadoTareas = new List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"TaskID":"TAS000000098739","GrupoAsignado":"ASEGURAMIENTO BOGOTA SDH-METRO","Estado":"CERRADO"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try
        {
            listadoTareas = CE_ConsultarTareasRemedy_cls.obtenerTareas(caso.Id_Sistema_Legado__c, caso.Id);
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage() + ' tamaño resultado: '+listadoTareas.size());
        }
        Test.stopTest();
        System.assert(listadoTareas.size()==0);
    }
    
    /**
     * @description prueba de obtención de tareas de agendamiento cuando hay una excepción con el JSON de respuesta
     */
    @isTest 
    static void jsonExceptionTest() 
    {
        Test.startTest();
        Case caso = [SELECT ID, Id_Sistema_Legado__c FROM Case Limit 1];
        List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask> listadoTareas = new List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"TaskID":"TAS000000098739","GrupoAsignado":"ASEGURAMIENTO \r -METRO","Estado":"CERRADO"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try
        {
            listadoTareas = CE_ConsultarTareasRemedy_cls.obtenerTareas(caso.Id_Sistema_Legado__c, caso.Id);
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage() + ' tamaño resultado: '+listadoTareas.size());
        }
        Test.stopTest();
        System.assert(listadoTareas.size()==0);
    }
    
    /**
     * @description obtención de tareas de agendamiento asociadas a un incidente que no tiene tareas de agendamiento
     * 				en Remedy
     */
    @isTest 
    static void noTasksTest() 
    {
        Test.startTest();
        Case caso = [SELECT Id, Id_Sistema_Legado__c FROM Case Limit 1];
        List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask> listadoTareas = new List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
		try
        {
            listadoTareas = CE_ConsultarTareasRemedy_cls.obtenerTareas(caso.Id_Sistema_Legado__c, caso.Id);
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage() + ' tamaño resultado: '+listadoTareas.size());
        }
        Test.stopTest();
        System.assert(listadoTareas.size()==0);
    }
    
    /**
     * @description obtención de tareas de agendamiento asociadas a un incidente con respuesta fallida
     */
    @isTest 
    static void getTasksFailedTest() 
    {
        Test.startTest();
        Case caso = [SELECT Id, Id_Sistema_Legado__c FROM Case Limit 1];
        List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask> listadoTareas = new List<CE_ConsultarTareasRemedy_cls.WrapperScheduleTask>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>F01</a:Codigo><a:DetalleEstado>Proceso Fallido</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
		try
        {
            listadoTareas = CE_ConsultarTareasRemedy_cls.obtenerTareas(caso.Id_Sistema_Legado__c, caso.Id);
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage() + ' tamaño resultado: '+listadoTareas.size());
        }
        Test.stopTest();
        System.assert(listadoTareas.size()==0);
    }
    
    /**
     * @description prueba del wrapper para las tareas de agendamiento
     */
    @isTest 
    static void WrapperScheduleTaskTest() 
    {
        Test.startTest();
        CE_ConsultarTareasRemedy_cls.WrapperScheduleTask scheduleTask = new CE_ConsultarTareasRemedy_cls.WrapperScheduleTask();
        scheduleTask.TaskID = 'TAS000000098739';
        scheduleTask.GrupoAsignado = 'ASEGURAMIENTO BOGOTA SDH-METRO';
        scheduleTask.Estado = 'CERRADO';
        Test.stopTest();
        System.assert(scheduleTask!=null);
    }
    
    /**
     * @description actualización de una tarea de agendamiento
     */
    @isTest 
    static void updateTaskTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
		CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento parametrosAgendamiento = new CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento();
		parametrosAgendamiento.taskId = agendamiento.CE_TaskId__c;
        parametrosAgendamiento.caseId = agendamiento.CE_ScheduleCase__c;
        List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento> resultadoAgendamiento = new List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos/><a:Estado>CERRADO</a:Estado><a:EstadoProcesadoAgendamiento>Tarea inmediata N-8740769 de Agendamiento Técnico en Terreno a través de ETA</a:EstadoProcesadoAgendamiento><a:FechaHoraAgendaConfirmada>2021-12-31 05:03:37</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>ASEGURAMIENTO BOGOTA SDH-METRO</a:GrupoAsignado><a:IdAgenda>8736531</a:IdAgenda><a:IdTareaCreadaRemedy>prueba cancel 12-31 2</a:IdTareaCreadaRemedy><a:SoportesIngreso>2021-12-31 05:03:37</a:SoportesIngreso><a:SubEstado/><a:TecnicosAsignados/><a:TipoSolicitud>inmediata</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        resultadoAgendamiento = CE_ConsultarTareasRemedy_cls.actualizarAgendaFlujo(new List<CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento>{parametrosAgendamiento});
        System.assert(resultadoAgendamiento[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba de actualización de una tarea de agendamiento sin un Id Tarea asociado
     */
    @isTest 
    static void noTaskId() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];        
        CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento parametrosAgendamiento = new CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento();
		parametrosAgendamiento.taskId = '';
        parametrosAgendamiento.caseId = agendamiento.CE_ScheduleCase__c;
        List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento> resultadoAgendamiento = new List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos/><a:Estado>CERRADO</a:Estado><a:EstadoProcesadoAgendamiento>Tarea inmediata N-8740769 de Agendamiento Técnico en Terreno a través de ETA</a:EstadoProcesadoAgendamiento><a:FechaHoraAgendaConfirmada>2021-12-31 05:03:37</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>ASEGURAMIENTO BOGOTA SDH-METRO</a:GrupoAsignado><a:IdAgenda>8736531</a:IdAgenda><a:IdTareaCreadaRemedy>prueba cancel 12-31 2</a:IdTareaCreadaRemedy><a:SoportesIngreso>2021-12-31 05:03:37</a:SoportesIngreso><a:SubEstado/><a:TecnicosAsignados/><a:TipoSolicitud>inmediata</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoAgendamiento = CE_ConsultarTareasRemedy_cls.actualizarAgendaFlujo(new List<CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento>{parametrosAgendamiento});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        System.assert(!resultadoAgendamiento[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba de actualización de una tarea de agendamiento cuando no hay información para la conexión 
     				con el servicio web asociado
     */
    @isTest 
    static void noWSTest2() 
    {
        Test.startTest();
        ServiciosWeb__c objServiciosWeb = [SELECT ID FROM ServiciosWeb__c Limit 1];
        delete objServiciosWeb;
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento parametrosAgendamiento = new CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento();
		parametrosAgendamiento.taskId = agendamiento.CE_TaskId__c;
        parametrosAgendamiento.caseId = agendamiento.CE_ScheduleCase__c;
        List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento> resultadoAgendamiento = new List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos/><a:Estado>CERRADO</a:Estado><a:EstadoProcesadoAgendamiento>Tarea inmediata N-8740769 de Agendamiento Técnico en Terreno a través de ETA</a:EstadoProcesadoAgendamiento><a:FechaHoraAgendaConfirmada>2021-12-31 05:03:37</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>ASEGURAMIENTO BOGOTA SDH-METRO</a:GrupoAsignado><a:IdAgenda>8736531</a:IdAgenda><a:IdTareaCreadaRemedy>prueba cancel 12-31 2</a:IdTareaCreadaRemedy><a:SoportesIngreso>2021-12-31 05:03:37</a:SoportesIngreso><a:SubEstado/><a:TecnicosAsignados/><a:TipoSolicitud>inmediata</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
			resultadoAgendamiento = CE_ConsultarTareasRemedy_cls.actualizarAgendaFlujo(new List<CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento>{parametrosAgendamiento});
        }
        catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        System.assert(!resultadoAgendamiento[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description actualización de una tarea de agendamiento con respuesta fallida
     */
    @isTest 
    static void updateTaskFailedTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];        
        CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento parametrosAgendamiento = new CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento();
		parametrosAgendamiento.taskId = agendamiento.CE_TaskId__c;
        parametrosAgendamiento.caseId = agendamiento.CE_ScheduleCase__c;
        List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento> resultadoAgendamiento = new List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>F01</a:Codigo><a:DetalleEstado>Proceso Fallido</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
            resultadoAgendamiento = CE_ConsultarTareasRemedy_cls.actualizarAgendaFlujo(new List<CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento>{parametrosAgendamiento});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        System.assert(!resultadoAgendamiento[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description actualización de una tarea de agendamiento con error en el upsert
     */
    @isTest 
    static void upsertErrorTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];        
        CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento parametrosAgendamiento = new CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento();
		parametrosAgendamiento.taskId = agendamiento.CE_TaskId__c;
        parametrosAgendamiento.caseId = agendamiento.CE_ScheduleCase__c;
        List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento> resultadoAgendamiento = new List<CE_ConsultarTareasRemedy_cls.ResultadoAgendamiento>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:CedulasTecnicos/><a:Estado>CERRADO</a:Estado><a:EstadoProcesadoAgendamiento>Tarea inmediata N-8740769 de Agendamiento Técnico en Terreno a través de ETA</a:EstadoProcesadoAgendamiento><a:FechaHoraAgendaConfirmada>2021-12-31 05:03:37</a:FechaHoraAgendaConfirmada><a:GrupoAsignado>ASEGURAMIENTO BOGOTA SDH-METRO</a:GrupoAsignado><a:IdAgenda>8736538736538736538736538736538736538736538736531</a:IdAgenda><a:IdTareaCreadaRemedy>prueba cancel 12-31 2</a:IdTareaCreadaRemedy><a:SoportesIngreso>2021-12-31 05:03:37</a:SoportesIngreso><a:SubEstado/><a:TecnicosAsignados/><a:TipoSolicitud>inmediata</a:TipoSolicitud></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
            resultadoAgendamiento = CE_ConsultarTareasRemedy_cls.actualizarAgendaFlujo(new List<CE_ConsultarTareasRemedy_cls.ParametrosAgendamiento>{parametrosAgendamiento});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
        System.assert(!resultadoAgendamiento[0].operacionExitosa);
        Test.stopTest();
    }
}