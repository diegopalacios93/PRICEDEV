/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               ETB - Portafolio Superior fase II
Descripción:            Clase de prueba para Controlador de la página CrearTipificacionCierre_pag encargada de seleccionar
                        la correcta tipificación para cerrar el caso.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     01-12-2019  John Guevara (JG)	       Creación de la clase.
*******************************************************************************/
@isTest
private class CrearTipificacionCierre_tst {

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
        strCampos += 'Plan__r.NombredelProducto__r.Name,Plan__r.TipodePlan__c,Plan__r.NombredelProducto__r.Catalogo__c,Account.Id,';
        strCampos += 'LTE_Servicio__r.Id,Ciudad_Instalacion__r.CodigoDane__c,Ciudad_Instalacion__r.Padre__r.CodigoDane__c,Ciudad_Instalacion__r.Tipo_Ciudad__c,';
        strCampos += 'IDServicio__c,Direccion_Instalacion__c,Plan__r.Plan_Troncales_Sip_Movil__c,LTE_Servicio__r.Plan__r.Plan_Troncales_Sip_Movil__c,';
        strCampos += 'TOA_Fecha__c,TOA_TimeSlot__c,TOA_Tipo_Actividad__c,TOA_Zona__c,Ciudad_Instalacion__r.Name,Recordtype.Name,';
        strCampos += 'Plan__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c,LTE_Servicio__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c,';
        strCampos += 'Valorreclamadoporelcliente__c,DescripcionSolucion__c,Arearesponsable__c,CausaImputabilidad__c,Ajuste__c,';
        strCampos += 'FechaFinAfectacion__c,Pertinencia_Horas__c,Pertinencia_Minutos__c,Pertinencia_Segundos__c,SolucionSistemaLegado__c,FechaResolucionSistemaLegado__c,Codigo_Cierre__c,';
        strCampos += 'CategoriaResolucionN1__c,CategoriaResolucionN2__c,CategoriaResolucionN3__c,CategoriaResolucionN4__c,CategoriaResolucionN5__c';
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
        insert vg;
    }
    
	static testMethod void TipificarSoporteTecnicoTest() {
		GeneraData_cls.generarData();
        GeneraData_cls.generarMatrizTipificacion3();
        CreateData();
        Test.startTest();
		
        PageReference pageRef0 = Page.CrearTipificacionCierre_pag;
        Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('newid',GeneraData_cls.caso2.Id);
		
		CrearTipificacionCierre_ctr cls = new CrearTipificacionCierre_ctr(new ApexPages.StandardController(new Case()));
        cls.Guardar();
        cls.CaseInfo.Pertinencia_Horas__c=0;
        cls.Guardar();
        cls.CaseInfo.Pertinencia_Minutos__c=0;
        cls.Guardar();
        cls.CaseInfo.Pertinencia_Segundos__c=0;
        cls.Guardar();
        cls.CaseInfo.SolucionSistemaLegado__c='0';
        cls.Guardar();
        cls.CaseInfo.DescripcionSolucion__c='0';
        cls.Guardar();
        cls.CaseInfo.Arearesponsable__c='0';
        cls.Guardar();
        cls.Guardar();
        
        Test.stopTest();
    }

}