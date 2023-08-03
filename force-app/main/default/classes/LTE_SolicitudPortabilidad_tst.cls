/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases: LTE_SolicitudPortabilidad_cls

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-28      Walter Rodríguez (WR)    Creación de la clase.
***********************************************************************************************************************/
@isTest/*(SeeAllData=true)*/
private class LTE_SolicitudPortabilidad_tst
{
    static testMethod void myUnitTest() 
    {
        Date datFechaPortacion = system.today();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '13880088';
        objAccount.RecordtypeId = devRecordTypeId;
        insert objAccount;
        
        List<Attachment> lstAttachment = new List<Attachment>(); 
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();  
        attachment.ParentId = objAccount.Id;  
        attachment.Name = 'DocumentoAT.jpg';
        attachment.Body = b;
        attachment.ContentType = 'image/jpeg';
        lstAttachment.add(attachment);
        
        Blob b2 = Blob.valueOf('Test Data 2');
        Attachment attachment2 = new Attachment();  
        attachment2.ParentId = objAccount.Id;  
        attachment2.Name = 'DocumentoID.jpg';
        attachment2.Body = b2;
        attachment2.ContentType = 'image/jpeg';
        lstAttachment.add(attachment2);
        
        Blob b3 = Blob.valueOf('Test Data 3');
        Attachment attachment3 = new Attachment();  
        attachment3.ParentId = objAccount.Id;  
        attachment3.Name = 'DocumentoCC.jpg';
        attachment3.Body = b3;
        attachment3.ContentType = 'image/jpeg';
        lstAttachment.add(attachment3);
        
        insert lstAttachment;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '09374';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '63945';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.LTE_DocumentoCC__c = 'sfdf.E12334';
        objLegalizacion.LTE_DocumentoAT__c = 'sdfdsf.E53242';
        objLegalizacion.LTE_DocumentoID__c = 'sdsf.E35436';
        insert objLegalizacion;
        
        Legalizacion__c objLegalizacion1 = new Legalizacion__c();
        objLegalizacion1.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion1.Contrato__c = objContrato.Id;
        objLegalizacion1.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion1.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion1.LTE_FechaGestion__c = system.today();
        objLegalizacion1.Estado__c = 'Gestionado';
        objLegalizacion1.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion1.Cuotas__c = 2;
        
        insert objLegalizacion1;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        insert objServicio;
        
        OperacionComercial__c objOpComercial = new OperacionComercial__c();
        objOpComercial.CuentaCliente__c = objAccount.Id;
        objOpComercial.Portacion__c = true;
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'Pendiente';
        objOpComercial.NumeroConexion__c = '3057000501';
        objOpComercial.FechadeActivacion__c = system.today();
        objOpComercial.Legalizacion__c = objLegalizacion.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        objOpComercial.LTE_Tipo_de_Servicio__c = 'Pospago';
        objOpComercial.LTE_SolicitadoPorTercero__c = true;
        insert objOpComercial;
        
        LTE_Lote__c obLote = new LTE_Lote__c();
        obLote.LTE_Observaciones__c = 'Test';
        obLote.LTE_Legalizacion__c = objLegalizacion.Id;
        insert obLote;
        
        LTE_DetalleLote__c objDetalleLote = new LTE_DetalleLote__c();
        objDetalleLote.LTE_NumeroLinea__c = '3057000501';
        objDetalleLote.LTE_Lote__c = obLote.Id;
        objDetalleLote.LTE_ActivoETB__c = objServicio.Id;
        insert objDetalleLote;
        
        LTE_SolicitudPortabilidad_cls.solicitudPortabilidad(objLegalizacion.Id, datFechaPortacion);
        LTE_SolicitudPortabilidad_cls.solicitudPortabilidad(objLegalizacion1.Id, datFechaPortacion);
    }
    
    static testMethod void myUnitTest2() 
    {
        Date datFechaPortacion = system.today();
        
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='CambioPlanRegxPag',Valor__c='5'));
        vg.add(new VariablesGlobales__c(Name='ViabilidadTroncalesSIP_LTE_CambioPlan',Valor__c='Enlaces de Voz'));
        vg.add(new VariablesGlobales__c(Name='RolLTEModificacionEstandar',Valor__c='Total'));
        vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        insert vg;
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '13880088';
        objAccount.RecordtypeId = devRecordTypeId;
        insert objAccount;
        
        List<Attachment> lstAttachment = new List<Attachment>(); 
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();  
        attachment.ParentId = objAccount.Id;  
        attachment.Name = 'DocumentoAT.jpg';
        attachment.Body = b;
        attachment.ContentType = 'image/jpeg';
        lstAttachment.add(attachment);
        
        Blob b2 = Blob.valueOf('Test Data 2');
        Attachment attachment2 = new Attachment();  
        attachment2.ParentId = objAccount.Id;  
        attachment2.Name = 'DocumentoID.jpg';
        attachment2.Body = b2;
        attachment2.ContentType = 'image/jpeg';
        lstAttachment.add(attachment2);
        
        Blob b3 = Blob.valueOf('Test Data 3');
        Attachment attachment3 = new Attachment();  
        attachment3.ParentId = objAccount.Id;  
        attachment3.Name = 'DocumentoCC.jpg';
        attachment3.Body = b3;
        attachment3.ContentType = 'image/jpeg';
        lstAttachment.add(attachment3);
        
        insert lstAttachment;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '09374';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '63945';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.LTE_DocumentoCC__c = 'sfdf.E12334';
        objLegalizacion.LTE_DocumentoAT__c = 'sdfdsf.E53242';
        objLegalizacion.LTE_DocumentoID__c = 'sdsf.E35436';
        insert objLegalizacion;
        
        Legalizacion__c objLegalizacion1 = new Legalizacion__c();
        objLegalizacion1.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion1.Contrato__c = objContrato.Id;
        objLegalizacion1.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion1.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion1.LTE_FechaGestion__c = system.today();
        objLegalizacion1.Estado__c = 'Gestionado';
        objLegalizacion1.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion1.Cuotas__c = 2;
        
        insert objLegalizacion1;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        insert objServicio;

        CatalogoProductos__c objProducto = new CatalogoProductos__c();
        objProducto.Name = 'Venta- TELEFONIA MOVIL (LTE)';
        objProducto.Familia__c = 'LTE';
        objProducto.LineaNegocio__c = 'Redes Móviles';
        objProducto.CodigoProducto__c = '7635736';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        objProducto.Crear_Linea__c=true;
        insert objProducto;
        
        Planes__c objPlan = new Planes__c ();
        objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
        objPlan.NombredelProducto__c = objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 96000;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
        objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
        objPlan.LTE_PlanEstructurados__c = true;
        objPlan.LTE_TipoControl__c = 'Control';
        insert objPlan;
        
        TOPP__c objTOPP = new TOPP__c();
        objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
        objTOPP.TipodeOperacionporplan__c = 'Venta';
        objTOPP.Tipoderegistro__c = 'Venta_LTE';
        objTOPP.AplicaPreventa__c=true;
        objTOPP.DisponibleVentainicial__c = true;
        objTOPP.Facturable__c = true;
        objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.AccountId = objAccount.Id;
        opp.CloseDate = System.today()+1;
        opp.StageName = 'En Estudio';
        opp.OwnerId = Userinfo.getUserId();
        opp.Valor_unica_vez_ETB__c = 1;    
        opp.Plan__r = objPlan;
        opp.Plan__c = objPlan.Id;
        opp.ANS__c = 10;
        opp.Plan__r.Tipo_Operaci_n_por_Plan__r = objTOPP;
        opp.Plan__r.Tipo_Operaci_n_por_Plan__c = objTOPP.Id;
        insert opp;
        
        AnchodeBanda__c ab = new AnchodeBanda__c();
        ab.Name = 'testabtestanchobanda';
        ab.Numero__c = '1';
        ab.Descripcion__c = 'desc';
        ab.Unidaddemedida__c = 'kbps';
        insert ab;
        
        OperacionComercial__c objOpComercial = new OperacionComercial__c();
        objOpComercial.CuentaCliente__c = objAccount.Id;
        objOpComercial.Portacion__c = true;
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'Pendiente';
        objOpComercial.NumeroConexion__c = '3057000501';
        objOpComercial.FechadeActivacion__c = system.today();
        objOpComercial.Legalizacion__c = objLegalizacion.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        objOpComercial.LTE_Tipo_de_Servicio__c = 'Pospago';
        objOpComercial.LTE_SolicitadoPorTercero__c = true;
        objOpComercial.Plan__c = objPlan.Id;
        objOpComercial.TOPP__c = objTOPP.Id;
        objOpComercial.AnchoBanda__c = ab.Id;
        objOpComercial.Oportunidad__c = opp.Id;
        insert objOpComercial;
        
        /*GeneraData_cls.generarData();
        OperacionComercial__c objOpComercial = GeneraData_cls.oc2;
        insert objOpComercial;
        
        objOpComercial.NumeroConexion__c = '3057000501';
        objOpComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        objOpComercial.LTE_SolicitadoPorTercero__c = true;
        objOpComercial.LTE_Tipo_de_Servicio__c = 'Pospago';

		update objOpComercial*/
        
        LTE_SolicitudPortabilidad_cls.solicitudNIP(String.valueOf(objOpComercial.Id));
        LTE_SolicitudPortabilidad_cls.reenvioSolicitudNIP(String.valueOf(objOpComercial.Id));
    }
    
    static testMethod void myUnitTest3() 
    {
        Date datFechaPortacion = system.today();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='CambioPlanRegxPag',Valor__c='5'));
        vg.add(new VariablesGlobales__c(Name='ViabilidadTroncalesSIP_LTE_CambioPlan',Valor__c='Enlaces de Voz'));
        vg.add(new VariablesGlobales__c(Name='RolLTEModificacionEstandar',Valor__c='Total'));
        vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Desactivar__c = true,esCreador__c = false,Detalles__c = 'en estado activa o declinada',esPropietario__c = false,Perfiles__c=userinfo.getProfileId()));
        insert vg;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '13880088';
        objAccount.RecordtypeId = devRecordTypeId;
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '09374';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '63945';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.LTE_DocumentoCC__c = 'sfdf.E12334';
        objLegalizacion.LTE_DocumentoAT__c = 'sdfdsf.E53242';
        objLegalizacion.LTE_DocumentoID__c = 'sdsf.E35436';
        insert objLegalizacion;
        
        Legalizacion__c objLegalizacion1 = new Legalizacion__c();
        objLegalizacion1.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion1.Contrato__c = objContrato.Id;
        objLegalizacion1.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion1.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion1.LTE_FechaGestion__c = system.today();
        objLegalizacion1.Estado__c = 'Gestionado';
        objLegalizacion1.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion1.Cuotas__c = 2;
        insert objLegalizacion1;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        insert objServicio;
        
        OperacionComercial__c objOpComercial = new OperacionComercial__c();
        objOpComercial.CuentaCliente__c = objAccount.Id;
        objOpComercial.Portacion__c = true;
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'Pendiente';
        objOpComercial.NumeroConexion__c = '3057000501';
        objOpComercial.FechadeActivacion__c = system.today();
        objOpComercial.Legalizacion__c = objLegalizacion.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        objOpComercial.LTE_Tipo_de_Servicio__c = 'Pospago';
        objOpComercial.LTE_SolicitadoPorTercero__c = true;
        insert objOpComercial;
        
        Linea__c objLinea = new Linea__c();
        objLinea.Name = '13795636';
        objLinea.Linea_ETB__c = 'Portada Movil';
        insert objLinea;
        
        Lineas_OC__c objLineaOC = new Lineas_OC__c();
        objLineaOC.Operacion_Comercial__c = objOpComercial.Id;
        objLineaOC.Linea__c = objLinea.Id;
        objLineaOC.Accion__c = 'Adicionar';
        objLineaOC.Estado__c = 'Pendiente';
        insert objLineaOC;
        
        LTE_SolicitudPortabilidad_cls.solicitudPortabilidadLinea(objOpComercial.Id, datFechaPortacion);
    }
}