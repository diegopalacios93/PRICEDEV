/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Andrés Oliva (AO)                                                                            ***
*** Proyecto:               ETB - LTE                                                                                    ***
*** Descripcion:            Clase de prueba d ela clase LTE_DeclinarOC_bch                                               ***
***                          
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2015-06-26      Andrés Oliva (AO)      Class created                                             ***
***************************************************************************************************************************/
@isTest
private class LTE_Remedy_tst
{
    public static List<ServiciosWeb__c> oServicioWeb;

    public static void CreateData()
    {
        String strCampos = 'Id,CaseNumber,Id_Sistema_Legado__c,CreatedDate,Status,Description,Subject,Priority,Origin,';
        strCampos += 'Proceso__c,Agrupacion__c,Tipologia__c,FechaInicioAfectacion__c,AccountId,Account.Name,';
        strCampos += 'Account.Tipodedocumento__c,Account.AccountNumber,Account.Direccion__c,';
        strCampos += 'Account.Ciudad__r.CodigoDane__c,Account.Ciudad__r.Padre__r.CodigoDane__c,';
        strCampos += 'LTE_Servicio__r.SucursalOrigen__c,LTE_Servicio__r.SucursalOrigen__r.Ciudad__r.CodigoDane__c,';
        strCampos += 'LTE_Servicio__r.SucursalOrigen__r.Ciudad__r.Padre__r.CodigoDane__c,';
        strCampos += 'LTE_Servicio__r.SucursalOrigen__r.Direccion__c,LTE_Servicio__r.Plan__c,';
        strCampos += 'LTE_Servicio__r.Plan__r.TipodePlan__c,CodigouniconumericoCUN__c,Nivel_1__c,';
        strCampos += 'LTE_Garantia__c,Nivel_2__c,Nivel_3__c,Account.Phone,Account.TipodeAtencion__c,Contact.Name,';
        strCampos += 'Contact.Email,Contact.Phone,LTE_Servicio__c,LTE_Servicio__r.SucursalDestino__r.Direccion__c,';
        strCampos += 'LTE_IntentosSistemaLegado__c,LTE_EstEnvioSistLegado__c,LTE_Servicio__r.NombredelProducto__r.Name,';
        strCampos += 'LTE_Servicio__r.NombredelProducto__r.Catalogo__c,LTE_Servicio__r.IDservicio__c,';
        strCampos += 'LTE_Servicio__r.SucursalOrigen__r.Ciudad__r.Tipo_Ciudad__c,Contact.FirstName,TipoCaso__c,';
        strCampos += 'Contact.LastName,Contact.MobilePhone,Causal_Estado__c,Parent.Id_Sistema_Legado__c,Estimado_Afectados__c,';
        strCampos += 'Fuente_Reportada_Legado__c,Categoria_legado__c,Grupo_Aseguramiento__r.ID_externo__c,Grupo_Aseguramiento__r.Nivel3__c,';
        strCampos += 'SubCausal_Estado__c,EstadoSistemaLegado__c,ID_sistema_externo__c,';
        strCampos += 'Responsable_Legado__c,SubResponsable_Legado__c,FechaTipificacion__c,Integrar_con_gestor__c,';
        strCampos += 'Plan__r.NombredelProducto__r.Name,Plan__r.TipodePlan__c,Plan__r.NombredelProducto__r.Catalogo__c';
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos Caso Remedy PS',Mensaje__c=strCampos));
        vg.add(new Mensaje_Integracion__c(Name='Gestor_Aprovisionamiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='Remedy_ActualizarIncidente_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='Remedy_CrearIncidente_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='Remedy_CreaNota_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='Remedy_CrearRequerimiento_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='Remedy_ConsultarTareas_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='Remedy_CreaTarea_PS',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new ServiciosWeb__c(Name='Remedy_UpdateStatusOp_PS',EndPoint__c='http://201.245.171.237:7010/Service/Remedy.interface.serviceagent/Remedy.interfaceEndpoint',Action__c='/Service/Remedy.interface.serviceagent//UpdateEntIncidentStatusOp'));
        vg.add(new ServiciosWeb__c(Name='Remedy_CreateIncident_PS',EndPoint__c='http://201.245.171.237:7010/Service/Remedy.interface.serviceagent/Remedy.interfaceEndpoint',Action__c='/Service/Remedy.interface.serviceagent//UpdateEntIncidentStatusOp'));
        vg.add(new ServiciosWeb__c(Name='Remedy_ConsultTaskArrayOP_PS',EndPoint__c='http://201.245.171.237:7010/Service/Remedy.interface.serviceagent/Remedy.interfaceEndpoint',Action__c='/Service/Remedy.interface.serviceagent//UpdateEntIncidentStatusOp'));
        vg.add(new ServiciosWeb__c(Name='Remedy_CreateNewTaskOP_PS',EndPoint__c='http://201.245.171.237:7010/Service/Remedy.interface.serviceagent/Remedy.interfaceEndpoint',Action__c='/Service/Remedy.interface.serviceagent//UpdateEntIncidentStatusOp'));
        vg.add(new ServiciosWeb__c(Name='Remedy_CreateNewNoteOP_PS',EndPoint__c='http://201.245.171.237:7010/Service/Remedy.interface.serviceagent/Remedy.interfaceEndpoint',Action__c='/Service/Remedy.interface.serviceagent//UpdateEntIncidentStatusOp'));
        vg.add(new ServiciosWeb__c(Name='OrchAliadoCasos',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        insert vg;
        oServicioWeb = LTE_DataGenerator_cls.confServicioWeb(true);
    }
    
	static testMethod void EnvioRemedyLTE() {
        CreateData();
        Case oCase        = LTE_DataGenerator_cls.createCase(true);
        oCase.NumeroConexion__c='0000';
        
        Test.setMock(HttpCalloutMock.class, new LTE_MockServiciosWebLTE_cls.MockHttpResponseRemedy());
        Test.startTest();
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.invocarServicioRemedy('<?xml version="1.0" encoding="UTF-8"?>');
        Test.stopTest();
    }

    public static testMethod void EnvioCreacionRemedyPS()
    {
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        update oCase;
        
        Test.setMock(HttpCalloutMock.class, new LTE_Remedy_tst.PS_MockHttpResponse(200,'EnvioCreacionRemedy'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.getFuenteIncidente();
        remedy.guardar();
        
        Test.stopTest();
    }

    public static testMethod void EnvioCreacionAliado()
    {
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        CatalogoProductos__c sglProd = GeneraData_cls.objProducto2;
        sglProd.Catalogo__c = 'Aliado';
        update sglProd;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        update oCase;
        
        Test.setMock(HttpCalloutMock.class, new LTE_Remedy_tst.PS_MockHttpResponse(200,'EnvioCreacionRemedy'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.getFuenteIncidente();
        remedy.guardar();
        
        Test.stopTest();
    }

    public static testMethod void EnvioCreacionSinServicioRemedyPS()
    {
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        oCase.LTE_Servicio__c = null;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        update oCase;
        
        Test.setMock(HttpCalloutMock.class, new LTE_Remedy_tst.PS_MockHttpResponse(200,'EnvioCreacionRemedy'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.getFuenteIncidente();
        remedy.guardar();
        
        Test.stopTest();
    }

    public static testMethod void EnvioActualizacionRemedyPS()
    {
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        oCase.Id_Sistema_Legado__c = 'Remedy001';
        oCase.EstadoSistemaLegado__c = 'POR CONFIRMAR';
        update oCase;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(200,'EnvioActualizacion'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.validacionInicial();
        remedy.getFuenteIncidente();
        remedy.strResponsable = 'ALIADO';
        remedy.CargarSubResponsable();
        remedy.objCase.Causal_Estado__c = 'Asignado';
        remedy.blnActualizarEstado = true;
        remedy.Actualizar();
        
        Test.stopTest();
    }

    public static testMethod void EnvioNotaRemedyPS()
    {
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        oCase.Id_Sistema_Legado__c = 'Remedy001';
        oCase.EstadoSistemaLegado__c = 'ASIGNADO';
        oCase.Causal_Estado__c = 'Asignado';
        update oCase;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(200,'EnvioNotaRemedy'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.validacionInicial();
        remedy.getFuenteIncidente();
        remedy.strNota = 'Notas';
        remedy.Actualizar();
        
        Test.stopTest();
    }

    public static testMethod void ConsultaTareaRemedyPS()
    {
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        oCase.Id_Sistema_Legado__c = 'Remedy001';
        oCase.EstadoSistemaLegado__c = 'ASIGNADO';
        oCase.Causal_Estado__c = 'Asignado';
        update oCase;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(200,'ConsultaTareaRemedy'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.validacionInicial();
        remedy.ConsultarTareasRemedy();
        
        Test.stopTest();
    }

    public static testMethod void IntegrarTareaRemedyPS()
    {
        CreateData();
        GeneraData_cls.generarData();
        Case oCase        = GeneraData_cls.caso2;
        oCase.FechaInicioAfectacion__c = system.today();
        oCase.FechaTipificacion__c = system.today();
        oCase.Id_Sistema_Legado__c = 'Remedy001';
        oCase.EstadoSistemaLegado__c = 'ASIGNADO';
        oCase.Causal_Estado__c = 'Asignado';
        update oCase;
        
        Task sglTask = new Task(Subject='Asunto',Description='Descripcion',Grupo_Aseguramiento__c=GeneraData_cls.grupoAseg.Id);
        insert sglTask;
        
        Test.setMock(HttpCalloutMock.class, new PS_MockHttpResponse(200,'IntegrarTareaRemedy'));
        Test.startTest();
        
        PageReference pageRef0 = Page.LTE_Remedy_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', oCase.id);
        
        LTE_Remedy_ctr remedy=new LTE_Remedy_ctr();
        remedy.validacionInicial();
        remedy.lstTareasSalesforce = new List<LTE_Remedy_ctr.Tareas_Salesforce>();
        
        LTE_Remedy_ctr.Tareas_Salesforce sglTareaSF = new LTE_Remedy_ctr.Tareas_Salesforce();
        sglTareaSF.IntegrarLegado = true;
        sglTareaSF.objTarea = sglTask;
        remedy.lstTareasSalesforce.add(sglTareaSF);
        
        remedy.IntegrarTareasRemedy();
        
        Test.stopTest();
    }
    
    public class PS_MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String sType;
        
        public PS_MockHttpResponse(Integer statusCode, string sType){
            this.statusCode = statusCode;
            this.sType = sType;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            String strResponse = '';
            if(this.sType == 'EnvioCreacionRemedy')
            	strResponse = '<?xml version="1.0" encoding="UTF-8"?><Envelope><Body><Service><status>PASS</status></Service><CreateResponse><Aknowledge>Exitoso</Aknowledge><OUT_Incident_ID>Exitoso</OUT_Incident_ID></CreateResponse></Body></Envelope>';
            if(this.sType == 'EnvioActualizacion')
            	strResponse = '<?xml version="1.0" encoding="UTF-8"?><Body><Service><status>PASS</status></Service><OUT_AKNOWLEDGE>OK</OUT_AKNOWLEDGE></Body>';
            if(this.stype == 'EnvioNotaRemedy')
            	strResponse = '<?xml version="1.0" encoding="UTF-8"?><Body><Service><status>PASS</status></Service><Create_Note_HPDResponse>Exitoso</Create_Note_HPDResponse><OUT_Incident_ID>Exitoso</OUT_Incident_ID></Body>';
            if(this.stype == 'IntegrarTareaRemedy')
            	strResponse = '<?xml version="1.0" encoding="UTF-8"?><Envelope><Body><Service><status>PASS</status></Service><CreateResponse><OUT_Aknowledge>OK</OUT_Aknowledge><OUT_ID_Task>Remedy002</OUT_ID_Task></CreateResponse></Body></Envelope>';
            
            if(this.stype == 'ConsultaTareaRemedy')
            	strResponse = '<?xml version="1.0" encoding="UTF-8"?><Body><Service><status>PASS</status></Service><ConsultaResponse><getListOperation><TaskID>121</TaskID><NombreTask>NombreTask</NombreTask><Estado_SF>Estado_SF</Estado_SF><Estado_RMD>Estado_RMD</Estado_RMD><ID_Tarea_SF></ID_Tarea_SF></getListOperation></ConsultaResponse><OUT_Incident_ID>Exitoso</OUT_Incident_ID></Body>';
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            res.setBody(strResponse);
            res.setStatusCode(this.statusCode);
            res.setBody(strResponse);
            return res;
        }
    }
}