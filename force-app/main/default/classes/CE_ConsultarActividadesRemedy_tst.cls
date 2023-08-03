/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_ConsultarActividadesRemedy_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     07/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
@isTest
private class CE_ConsultarActividadesRemedy_tst {

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
     * @description obtención de actividades de seguimiento asociadas a una tarea de agendamiento
     */
    @isTest
    static void getActivitiesTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];
        CE_ConsultarActividadesRemedy_cls.ParametrosActividad parametrosActividad = new CE_ConsultarActividadesRemedy_cls.ParametrosActividad();
        parametrosActividad.taskId = agendamiento.CE_TaskId__c;
        parametrosActividad.caseId = agendamiento.CE_ScheduleCase__c;
        parametrosActividad.actionWS = objServiciosWeb.Action__c;
        parametrosActividad.endPointWS = objServiciosWeb.EndPoint__c;
        List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad> resultadoActividad = new List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"ActividadID":"AGGAA5V0FGDKOARC4TSNRB5RPYURMM","TipoInformacion":"Seguimiento","FechaAvance":"2021-11-11 05:00:00","Resumen":"Parafiscales","Notas":"Se adjuntan parafiscales, pureba Covid y certificado de alturas","UsuarioActualiza":"INT_TOA"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        resultadoActividad = CE_ConsultarActividadesRemedy_cls.flujoActividadesRemedy(new List<CE_ConsultarActividadesRemedy_cls.ParametrosActividad>{parametrosActividad});
        System.assert(resultadoActividad[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba de fallo en una operación de upsert para una actividad de seguimiento
     */
    @isTest
    static void upsertFailedTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];
        CE_ConsultarActividadesRemedy_cls.ParametrosActividad parametrosActividad = new CE_ConsultarActividadesRemedy_cls.ParametrosActividad();
        parametrosActividad.taskId = agendamiento.CE_TaskId__c;
        parametrosActividad.caseId = agendamiento.CE_ScheduleCase__c;
        parametrosActividad.actionWS = objServiciosWeb.Action__c;
        parametrosActividad.endPointWS = objServiciosWeb.EndPoint__c;
        List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad> resultadoActividad = new List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"ActividadID":"AGGAA5V0FGDKOARC4TSNRB5RPYURMM","TipoInformacion":"SeguimientoSeguimientoSeguimientoSeguimientoSeguimientoSeguimientoSeguimientoSeguimientoSeguimientoSeguimiento","FechaAvance":"2021-11-11 05:00:00","Resumen":"Parafiscales","Notas":"Se adjuntan parafiscales, pureba Covid y certificado de alturas","UsuarioActualiza":"INT_TOA"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
            resultadoActividad = CE_ConsultarActividadesRemedy_cls.flujoActividadesRemedy(new List<CE_ConsultarActividadesRemedy_cls.ParametrosActividad>{parametrosActividad});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
		System.assert(resultadoActividad[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba de obtención de actividades de seguimiento cuando hay una excepción con el JSON de respuesta
     */
    @isTest 
    static void jsonExceptionTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];
        CE_ConsultarActividadesRemedy_cls.ParametrosActividad parametrosActividad = new CE_ConsultarActividadesRemedy_cls.ParametrosActividad();
        parametrosActividad.taskId = agendamiento.CE_TaskId__c;
        parametrosActividad.caseId = agendamiento.CE_ScheduleCase__c;
        parametrosActividad.actionWS = objServiciosWeb.Action__c;
        parametrosActividad.endPointWS = objServiciosWeb.EndPoint__c;
        List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad> resultadoActividad = new List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[{"ActividadID":"AGGAA5V0FGDKOARC4TSNRB5RPYURMM","TipoInformacion":"Seguimiento","FechaAvance":"2021-11-11T13:36:05-05:00","Resumen":"Parafiscales \r 2","Notas":"Se adjuntan parafiscales, pureba Covid y certificado de alturas","UsuarioActualiza":"INT_TOA"}]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
            resultadoActividad = CE_ConsultarActividadesRemedy_cls.flujoActividadesRemedy(new List<CE_ConsultarActividadesRemedy_cls.ParametrosActividad>{parametrosActividad});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
		System.assert(!resultadoActividad[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description obtención de actividades de seguimiento asociadas a una tarea de agendamiento que no tiene 
     * 				actividades de seguimiento en Remedy
     */
    @isTest 
    static void noActivitiesTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];
        CE_ConsultarActividadesRemedy_cls.ParametrosActividad parametrosActividad = new CE_ConsultarActividadesRemedy_cls.ParametrosActividad();
        parametrosActividad.taskId = agendamiento.CE_TaskId__c;
        parametrosActividad.caseId = agendamiento.CE_ScheduleCase__c;
        parametrosActividad.actionWS = objServiciosWeb.Action__c;
        parametrosActividad.endPointWS = objServiciosWeb.EndPoint__c;
        List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad> resultadoActividad = new List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>O01</a:Codigo><a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado><a:SoportesIngreso>[]</a:SoportesIngreso></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
            resultadoActividad = CE_ConsultarActividadesRemedy_cls.flujoActividadesRemedy(new List<CE_ConsultarActividadesRemedy_cls.ParametrosActividad>{parametrosActividad});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
		System.assert(!resultadoActividad[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description obtención de actividades de seguimiento asociadas a una tarea de agendamiento con respuesta fallida
     */
    @isTest 
    static void getActivitiesFailedTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];
        CE_ConsultarActividadesRemedy_cls.ParametrosActividad parametrosActividad = new CE_ConsultarActividadesRemedy_cls.ParametrosActividad();
        parametrosActividad.taskId = agendamiento.CE_TaskId__c;
        parametrosActividad.caseId = agendamiento.CE_ScheduleCase__c;
        parametrosActividad.actionWS = objServiciosWeb.Action__c;
        parametrosActividad.endPointWS = objServiciosWeb.EndPoint__c;
        List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad> resultadoActividad = new List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad>();
        String body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CreacionAgendaRemedyResponse xmlns="http://tempuri.org/"><Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:Encabezado><a:Servicio><a:Codigo>F01</a:Codigo><a:DetalleEstado>Proceso Fallido</a:DetalleEstado><a:Estado>OK</a:Estado></a:Servicio></a:Encabezado></Resultado></CreacionAgendaRemedyResponse></s:Body></s:Envelope>';
        Integer code = 200;
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
        try{
            resultadoActividad = CE_ConsultarActividadesRemedy_cls.flujoActividadesRemedy(new List<CE_ConsultarActividadesRemedy_cls.ParametrosActividad>{parametrosActividad});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
		System.assert(!resultadoActividad[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba de consulta de actividades de seguimiento con falla en el servicio web
     */
    @isTest 
    static void failedWSTest() 
    {
        Test.startTest();
        Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
        ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];
        CE_ConsultarActividadesRemedy_cls.ParametrosActividad parametrosActividad = new CE_ConsultarActividadesRemedy_cls.ParametrosActividad();
        parametrosActividad.taskId = agendamiento.CE_TaskId__c;
        parametrosActividad.caseId = agendamiento.CE_ScheduleCase__c;
        parametrosActividad.actionWS = objServiciosWeb.Action__c;
        parametrosActividad.endPointWS = objServiciosWeb.EndPoint__c;
        List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad> resultadoActividad = new List<CE_ConsultarActividadesRemedy_cls.ResultadoActividad>();
        Test.setMock(HttpCalloutMock.class, new CE_ETACalloutExceptionMock_tst());
        try{
            resultadoActividad = CE_ConsultarActividadesRemedy_cls.flujoActividadesRemedy(new List<CE_ConsultarActividadesRemedy_cls.ParametrosActividad>{parametrosActividad});
        }catch(Exception exc)
        {
            System.debug(exc.getMessage());
        }
		System.assert(!resultadoActividad[0].operacionExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba del wrapper para las actividades de seguimiento
     */
    @isTest 
    static void WrapperActivityTest() 
    {
        Test.startTest();
        CE_ConsultarActividadesRemedy_cls.WrapperActivity actividad = new CE_ConsultarActividadesRemedy_cls.WrapperActivity();
        actividad.ActividadID = '';
        actividad.FechaAvance = '';
        actividad.Notas = '';
        actividad.Resumen = '';
        actividad.TipoInformacion = '';
        actividad.UsuarioActualiza = '';
        Test.stopTest();
        System.assert(actividad!=null);
    } 
}