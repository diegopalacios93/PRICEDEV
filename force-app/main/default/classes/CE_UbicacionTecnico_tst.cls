/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luis Carlos Oviedo Talaigua
Proyecto: ETB DE Experiencia        
Descripción: Clase test para la clase CE_UbicacionTecnico_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     25/04/2022      Luis Carlos Oviedo Talaigua  
***************************************************************************************************/
@isTest
private class CE_UbicacionTecnico_tst {

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
   * @description prueba de consulta del servicio que trae la ubicación del técnico
   */
   @isTest 
   static void ubicacionTecnocoTest() 
   {
      Test.startTest();
      Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_LegacySystemIdInput__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
      ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];

      CE_UbicacionTecnico_cls.ParametrosEntrada ParametrosEntrada = new CE_UbicacionTecnico_cls.ParametrosEntrada();
      ParametrosEntrada.caseId = agendamiento.CE_ScheduleCase__c;   
      ParametrosEntrada.IdIncidente = agendamiento.CE_LegacySystemIdInput__c;
      ParametrosEntrada.actionWS = objServiciosWeb.Action__c;
      ParametrosEntrada.endPointWS = objServiciosWeb.EndPoint__c;
      
      List<CE_UbicacionTecnico_cls.ParametrosRespuesta> resultado = new List<CE_UbicacionTecnico_cls.ParametrosRespuesta>();
      
      String body = '<?xml version="1.0" encoding="UTF-8"?>'
      +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
      +'<SOAP-ENV:Body>'
         +'<ns0:CreateScheduleRemedyOutput xmlns:ns0="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP">'
            +'<ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
               +'<ns1:System>'
                  +'<ns1:name>TIBCO</ns1:name>'
                     +'<ns1:correlationID>INC000004699221</ns1:correlationID>'
                     +'<ns1:processingServer>TIBCO</ns1:processingServer>'
                     +'</ns1:System>'
                  +'<ns2:Service xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP">'
                  +'<ns2:status>PASS</ns2:status>'
                     +'<ns2:responseDate>2022-04-22T15:17:24.119-05:00</ns2:responseDate>'
                     +'</ns2:Service>'
                  +'</ns1:WSResponseHeader2>'
               +'<ns2:response xmlns:ns2="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyMsg" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP">'
               +'<CreacionAgendaRemedyResponse xmlns="http://tempuri.org/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">'
                  +'<Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
                     +'<a:Encabezado>'
                        +'<a:Servicio>'
                           +'<a:Codigo>O01</a:Codigo>'
                           +'<a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado>'
                           +'<a:Estado>OK</a:Estado>'
                           +'</a:Servicio>'
                           +'</a:Encabezado>'
                        +'<a:SoportesIngreso>"http://portalinstalacionqa.portallteqa.p.azurewebsites.net/AutoGestion/Index/?Encpyt=1VN9czem5ynOqpLRGceDRw="</a:SoportesIngreso>'
                        +'</Resultado>'
                     +'</CreacionAgendaRemedyResponse>'
                  +'</ns2:response>'
               +'</ns0:CreateScheduleRemedyOutput>'
         +'</SOAP-ENV:Body>'
      +'</SOAP-ENV:Envelope>';

      Integer code = 200;
      Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
      resultado = CE_UbicacionTecnico_cls.consultarUbicacionTecnico(new List<CE_UbicacionTecnico_cls.ParametrosEntrada>{ParametrosEntrada});
      Test.stopTest();
      System.assert(resultado[0].operacionExitosa);
   }

   /**
   * @description prueba de consulta del servicio que trae la ubicación del técnico sin un incidente asociado
   */
   @isTest 
   static void ubicacionTecnocoSinIncidenciaTest() 
   {
      Test.startTest();
      Ce_Schedule__c agendamiento = [SELECT Id, CE_ScheduleCase__c, CE_LegacySystemIdInput__c, CE_TaskId__c FROM Ce_Schedule__c Limit 1];
      ServiciosWeb__c objServiciosWeb = [SELECT ID, Action__c, EndPoint__c FROM ServiciosWeb__c Limit 1];

      CE_UbicacionTecnico_cls.ParametrosEntrada ParametrosEntrada = new CE_UbicacionTecnico_cls.ParametrosEntrada();
      ParametrosEntrada.caseId = agendamiento.CE_ScheduleCase__c;   
      ParametrosEntrada.IdIncidente = '';
      ParametrosEntrada.actionWS = objServiciosWeb.Action__c;
      ParametrosEntrada.endPointWS = objServiciosWeb.EndPoint__c;
      
      List<CE_UbicacionTecnico_cls.ParametrosRespuesta> resultado = new List<CE_UbicacionTecnico_cls.ParametrosRespuesta>();
      
      String body = '<?xml version="1.0" encoding="UTF-8"?>'
      +'<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'
      +'<SOAP-ENV:Body>'
         +'<ns0:CreateScheduleRemedyOutput xmlns:ns0="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP">'
            +'<ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0">'
               +'<ns1:System>'
                  +'<ns1:name>TIBCO</ns1:name>'
                     +'<ns1:correlationID>INC000004699221</ns1:correlationID>'
                     +'<ns1:processingServer>TIBCO</ns1:processingServer>'
                     +'</ns1:System>'
                  +'<ns2:Service xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP">'
                  +'<ns2:status>PASS</ns2:status>'
                     +'<ns2:responseDate>2022-04-22T15:17:24.119-05:00</ns2:responseDate>'
                     +'</ns2:Service>'
                  +'</ns1:WSResponseHeader2>'
               +'<ns2:response xmlns:ns2="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyMsg" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.tibco.com/schemas/ETB.MDM.Integration.MDM/ETB.MDM.Integration.MDM.Core/CreateScheduleRemedyOP">'
               +'<CreacionAgendaRemedyResponse xmlns="http://tempuri.org/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">'
                  +'<Resultado xmlns:a="http://www.etb.com.co/orquestador" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
                     +'<a:Encabezado>'
                        +'<a:Servicio>'
                           +'<a:Codigo>O01</a:Codigo>'
                           +'<a:DetalleEstado>Proceso realizado exitosamente</a:DetalleEstado>'
                           +'<a:Estado>OK</a:Estado>'
                           +'</a:Servicio>'
                           +'</a:Encabezado>'
                        +'<a:SoportesIngreso>"http://portalinstalacionqa.portallteqa.p.azurewebsites.net/AutoGestion/Index/?Encpyt=1VN9czem5ynOqpLRGceDRw="</a:SoportesIngreso>'
                        +'</Resultado>'
                     +'</CreacionAgendaRemedyResponse>'
                  +'</ns2:response>'
               +'</ns0:CreateScheduleRemedyOutput>'
         +'</SOAP-ENV:Body>'
      +'</SOAP-ENV:Envelope>';

      Integer code = 200;
      Test.setMock(HttpCalloutMock.class, new CE_ETACalloutMock_tst(code, body));
      try{
         resultado = CE_UbicacionTecnico_cls.consultarUbicacionTecnico(new List<CE_UbicacionTecnico_cls.ParametrosEntrada>{ParametrosEntrada});
      }
      catch(Exception exc)
      {
         System.debug(exc.getMessage());
      }
      Test.stopTest();
      //System.assert(resultado[0].operacionExitosa);
   }
}