/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR FASE II
Descripción:        Clase de prueba PS_TOPP_Billing_cls.
Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-04-02   John Guevara (ETB)		  Creación de la clase.
***********************************************************************************************************************/
@isTest
public class PS_TOPP_Billing_tst {
    
    public static void createData(){
        
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new HomologacionCampos__c(Name='NIT',Valor__c='NIT'));
        vg.add(new HomologacionCampos__c(Name='Cédula de ciudadanía',Valor__c='CC'));
        vg.add(new ServiciosWeb__c(Name='CreacionCuentasFact',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='InvocacionServiceProvisioning',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='ModificacionPerfilFacturacion',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='Set_Customer',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new ServiciosWeb__c(Name='Set_Customer_Contact',Action__c='/action/RevChain',EndPoint__c='https://salesforce.com/RevChain'));
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
        vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='DisponibilidadM6',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='Facturacion',Ejecucion__c=true));
        vg.add(new EjecucionIntegracion__c(Name='RevChain',Ejecucion__c=true));
        vg.add(new LTE_TramitesSuspenda__c(Name='Suspensión, Fraude',LTE_Estado__c = 'Suspendido',LTE_Causal__c = 'Fraude'));
        vg.add(new LTE_TramitesSuspenda__c(Name='Suspensión, Fraude, Otro',LTE_Estado__c = 'Suspendido',LTE_Causal__c = 'Fraude'));
        vg.add(new LTE_TramitesSuspenda__c(Name='Retiro, Portabilidad Saliente',LTE_Estado__c = 'Activa',LTE_Causal__c = 'Portabilidad Saliente'));
        vg.add(new Mensaje_Integracion__c(Name='Campos Facturacion PS',Mensaje__c='Id,Name,FechadeActivacion__c,Detalle_del_tramite__c,Plan__c,CuentaFacturacion__c '));
        vg.add(new Mensaje_Integracion__c(Name='Campos Facturacion Lineas PS',Mensaje__c='Id,Name,Operacion_Comercial__r.Plan__c,Operacion_Comercial__r.CuentaFacturacion__c'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Facturacion_Venta',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Facturacion_Lineas',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Facturacion_modificacion_estandar_x',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Mensaje_Integracion__c(Name='PS_Facturacion_cambio_datos_cliente_o_cuenta',Mensaje__c='<soapenv:Envelope  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Header/><soapenv:Body/></soapenv:Envelope>'));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        insert vg;
		
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456';
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '12941234';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Fact-00154658';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = false;
        objCtaFact.Fue_creada_en_revchain__c = false;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Test';
        objContact.AccountId = objAccount.Id;
        objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
        objContact.NumerodeIdentificacion__c = '1029837456';
        objContact.Estado__c = 'Activo';
        objContact.Cargo__c = 'Ingeniero';
        objContact.Area__c = 'Dpto. Financiero';
        objContact.Rol__c = 'Administrativo';
        objContact.LTE_RolLTE__c = 'Total';
        objContact.Genero__c = 'Masculino';
        objContact.Direccion__c = 'Kr 8 20 00';
        objContact.Phone = '12941234';
        objContact.MobilePhone = '3103216547';
        objContact.Email = 'no_responder@etb.com.co';
        objContact.Ciudad__c = objMunicipio.Id;
        insert objContact;
        
        Opportunity objOportunidad = new Opportunity();
        objOportunidad.Name = 'Test name';
        objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
        objOportunidad.AccountId = objAccount.Id;
        objOportunidad.StageName = 'Negociación Cerrada';
        objOportunidad.CloseDate = system.today();
        objOportunidad.Amount = 1000;
        objOportunidad.Valor_unica_vez_ETB__c = 150;
        objOportunidad.LTE_Scoring__c = 9000000;
        objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
        objOportunidad.LTE_NumeroLinea__c = 2;
        insert objOportunidad;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.Estado__c = 'No Gestionado';
        insert objLegalizacion;

		CatalogoProductos__c objProducto = new CatalogoProductos__c();
		objProducto.Name = 'Enlaces de Voz E1';
		objProducto.Familia__c = 'ENLACES DE VOZ';
		objProducto.LineaNegocio__c = 'LOCAL';
		objProducto.CodigoProducto__c = 'EnlacesdeVozE1001';
		objProducto.Estado__c = 'Activo';
		objProducto.Descripcion__c = 'Teste';
		objProducto.AtributosEstandar__c = 'Teste';
		insert objProducto;
        
        CatalogoProductosFacturacion__c objProductoFacturacion = new CatalogoProductosFacturacion__c();
        objProductoFacturacion.Name = 'Cargo Fijo E1 RDSI';
        objProductoFacturacion.CatalogoProductos__c = objProducto.Id;
        objProductoFacturacion.ConnectionID__c = 'Test';
        objProductoFacturacion.ConnectionTypeID__c = 'Test';
        objProductoFacturacion.Servicio__c = 'E1 Enlace Voz';
        objProductoFacturacion.Codigo__c = 0;
        insert objProductoFacturacion;
        
        CatalogoProductosFacturacion__c objProductoFacturacion2 = new CatalogoProductosFacturacion__c();
        objProductoFacturacion2.Name = 'Automaticos y Asistidos';
        objProductoFacturacion2.CatalogoProductos__c = objProducto.Id;
        objProductoFacturacion2.ConnectionID__c = 'Test';
        objProductoFacturacion2.ConnectionTypeID__c = 'Test';
        objProductoFacturacion2.Servicio__c = 'E1 Enlace Voz';
        objProductoFacturacion2.Codigo__c = 0;
        insert objProductoFacturacion2;

		Planes__c objPlan = new Planes__c ();
		objPlan.Name = 'Plan Básico Enlaces  E1';
		objPlan.NombredelProducto__c = objProducto.Id;
		objPlan.TipodePlan__c = 'Principal';
		objPlan.Tarifa__c = 96000;
		objPlan.Estado__c = 'Activo';
		insert objPlan;
		
		PlanFacturacion__c objPlanFacturacion = new PlanFacturacion__c();
		objPlanFacturacion.CatalogoProductosFacturacion__c = objProductoFacturacion.Id;
		objPlanFacturacion.Plan__c = objPlan.Id;
		objPlanFacturacion.Name = 'Local Cargo Fijo E1 Enlace Voz';
		insert objPlanFacturacion;
        
        ParametroFacturacion__c objParametro = new ParametroFacturacion__c();
        objParametro.Name = 'CargoDS';
        objParametro.PlanFacturacion__c = objPlanFacturacion.Id;
        objParametro.Campo__c = 'ValorTarifaPlan__c';
        objParametro.Formato__c = 'NUMBERPAD(#.####)';
        insert objParametro;
        
        SubPlanFacturacion__c objSubPlanFacturacion = new SubPlanFacturacion__c();
        objSubPlanFacturacion.Name = 'Mundo Automaticos y Asistidos- Chain';
        objSubPlanFacturacion.PS_Tipo__c = 'Basico';
        objSubPlanFacturacion.Codigo__c = '0';
        objSubPlanFacturacion.PlanFacturacion__c = objPlanFacturacion.Id;
        objSubPlanFacturacion.CatalogoProductosFacturacion__c = objProductoFacturacion2.Id;
        insert objSubPlanFacturacion;
        
        ParametroFacturacion__c objParametro2 = new ParametroFacturacion__c();
        objParametro2.Name = 'Destinos';
        objParametro2.SubPlanFacturacion__c = objSubPlanFacturacion.Id;
        insert objParametro2;

		TOPP__c objTOPP = new TOPP__c();
		objTOPP.Name = 'Venta- Plan Básico Enlaces E1';
		objTOPP.TipodeOperacionporplan__c = 'Venta';
		objTOPP.Tipoderegistro__c = 'Venta_Enlaces_de_Voz';
        objTOPP.Plan__c = objPlan.Id;
		objTOPP.DisponibleVentainicial__c = true;
		objTOPP.Facturable__c = true;
        objTOPP.AplicaFacturacion__c = true;
		insert objTOPP;

		TOPP__c objTOPP2 = new TOPP__c();
		objTOPP2.Name = 'Modificación Estándar- Plan Básico Enlaces E1';
		objTOPP2.TipodeOperacionporplan__c = 'Modificación Estándar';
		objTOPP2.Tipoderegistro__c = 'Modificacion_Estandar';
        objTOPP2.Plan__c = objPlan.Id;
		objTOPP2.DisponibleVentainicial__c = true;
		objTOPP2.Facturable__c = true;
        objTOPP2.AplicaFacturacion__c = true;
		insert objTOPP2;

		TOPP__c objTOPP3 = new TOPP__c();
		objTOPP3.Name = 'Cambio Datos Cliente o Cuenta - Plan Básico Enlaces E1';
		objTOPP3.TipodeOperacionporplan__c = 'Cambio Datos Cliente o Cuenta';
		objTOPP3.Tipoderegistro__c = 'M5';
        objTOPP3.Plan__c = objPlan.Id;
		objTOPP3.DisponibleVentainicial__c = true;
		objTOPP3.Facturable__c = true;
        objTOPP3.AplicaFacturacion__c = true;
		insert objTOPP3;
        
        List<ActivoETB__c> lstServicio = new List<ActivoETB__c>();
        List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
        List<Linea__c> lstLinea = new List<Linea__c>();
        List<Lineas_OC__c> lstLineaOC = new List<Lineas_OC__c>();
        
        for(Integer i =0;i<100;i++){
            ActivoETB__c objServicio = new ActivoETB__c();
            objServicio.Oportunidad__c = objOportunidad.Id;
            objServicio.NombredelaCuenta__c = objAccount.Id;
            //objServicio.Plan__c = objPlan.Id;
            objServicio.Estado__c = 'Activo';
            objServicio.Fecha_Activacion__c = system.now();
            objServicio.CuentaFacturacion__c =  objCtaFact.Id;
            objServicio.ExternalServiceID__c = 'AC-000000';
            lstServicio.add(objServicio);
        }
        insert lstServicio; 
         
        for(ActivoETB__c sglServicio: lstServicio){
            OperacionComercial__c objOpComercial = new OperacionComercial__c();
            objOpComercial.CuentaCliente__c = objAccount.Id;
            objOpComercial.Activo__c = sglServicio.Id;
            objOpComercial.Plan__c = objTOPP.Plan__c;
            objOpComercial.TOPP__c = objTOPP.Id;
            objOpComercial.Oportunidad__c = objOportunidad.Id;
            objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
            objOpComercial.Estado__c = 'Activa';
            objOpComercial.EnvioFacturacion__c = true;
            objOpComercial.FechadeActivacion__c = system.today();
            objOpComercial.Legalizacion__c = objLegalizacion.Id;
            objOpComercial.NumeroConexion__c = '13387760';
            objOpComercial.ValorObraCivil__c=100;
            lstOC.add(objOpComercial);
        }
        insert lstOC;
        
        
        for(OperacionComercial__c sglOC: lstOC){
         Linea__c objLinea = new Linea__c();
         objLinea.Name = '13795636';
         objLinea.OperacionComercialTramite__c = sglOC.Id;
         lstLinea.add(objLinea);
        }
        insert lstLinea;
        
        for(Linea__c objLinea: lstLinea){
            Lineas_OC__c objLineaOC = new Lineas_OC__c();
            objLineaOC.Operacion_Comercial__c = objLinea.OperacionComercialTramite__c;
            objLineaOC.Linea__c = objLinea.Id;
            objLineaOC.Accion__c = 'Adicionar';
            objLineaOC.Estado__c = 'Activa';
            lstLineaOC.add(objLineaOC);
        }
        insert lstLineaOC;
    }

    static testMethod void ServiceProvisioningOKTest() {
        
    	createData();
    	Map<Id,OperacionComercial__c> sOC = new Map<Id,OperacionComercial__c>([SELECT Id,Name,Detalle_del_tramite__c,FechadeActivacion__c,CuentaFacturacion__r.Name,Activo__r.ExternalServiceID__c,Plan__r.Name,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,NumeroArranqueAnterior__c,NumeroArranqueNuevo__c,ValorObraCivil__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,Plan__r.LTE_MetodoDePago__c,TipoSuspension__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, CuentaFacturacion__r.DirCorresp__c, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Name, CuentaFacturacion__r.LTE_Email__c, CuentaFacturacion__r.MedioFacturacion__c FROM OperacionComercial__c]);
	    test.startTest();
        BanderasEjecucion.setEjecucion('PS_Excepcion_Controlada');
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningOK());
        PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
        Map<Id,Map<String,Object>> mapDatos = sd.LoadMap(sOC.keyset());
        sd.TOPPDispatcher(mapDatos);
        BanderasEjecucion.unSetEjecucion('PS_Excepcion_Controlada');
        test.stopTest();
   	}

    static testMethod void ServiceProvisioningModificacionServicioOKTest() {
        
    	createData();
    	List<OperacionComercial__c> sOC = [SELECT Id,Name,Detalle_del_tramite__c,FechadeActivacion__c,CuentaFacturacion__r.Name,Activo__r.ExternalServiceID__c,Plan__r.Name,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,NumeroArranqueAnterior__c,NumeroArranqueNuevo__c,ValorObraCivil__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,Plan__r.LTE_MetodoDePago__c,TipoSuspension__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, CuentaFacturacion__r.DirCorresp__c, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Name, CuentaFacturacion__r.LTE_Email__c, CuentaFacturacion__r.MedioFacturacion__c FROM OperacionComercial__c];
        TOPP__c sglTOPP =[SELECT Id FROM TOPP__c WHERE TipodeOperacionporplan__c = 'Modificación Estándar'];
        sOC[0].TOPP__c = sglTOPP.Id;
        sOC[0].Detalle_del_tramite__c = 'x';
        update sOC;
        Map<Id,OperacionComercial__c> sOC1 = new Map<Id,OperacionComercial__c>([SELECT Id,Name,Detalle_del_tramite__c,FechadeActivacion__c,CuentaFacturacion__r.Name,Activo__r.ExternalServiceID__c,Plan__r.Name,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,NumeroArranqueAnterior__c,NumeroArranqueNuevo__c,ValorObraCivil__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,Plan__r.LTE_MetodoDePago__c,TipoSuspension__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, CuentaFacturacion__r.DirCorresp__c, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Name, CuentaFacturacion__r.LTE_Email__c, CuentaFacturacion__r.MedioFacturacion__c
                                            FROM OperacionComercial__c WHERE TOPP__r.TipodeOperacionporplan__c = 'Modificación Estándar']);
	    test.startTest();
        BanderasEjecucion.setEjecucion('PS_Excepcion_Controlada');
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningOK());
        PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
        Map<Id,Map<String,Object>> mapDatos = sd.LoadMap(sOC1.keyset());
        sd.TOPPDispatcher(mapDatos);
        BanderasEjecucion.unSetEjecucion('PS_Excepcion_Controlada');
        test.stopTest();
   	}

    static testMethod void ServiceProvisioningCambioCuentaOKTest() {
        
    	createData();
    	List<OperacionComercial__c> sOC = [SELECT Id,Name,Detalle_del_tramite__c,FechadeActivacion__c,CuentaFacturacion__r.Name,Activo__r.ExternalServiceID__c,Plan__r.Name,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,NumeroArranqueAnterior__c,NumeroArranqueNuevo__c,ValorObraCivil__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,Plan__r.LTE_MetodoDePago__c,TipoSuspension__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, CuentaFacturacion__r.DirCorresp__c, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Name, CuentaFacturacion__r.LTE_Email__c, CuentaFacturacion__r.MedioFacturacion__c FROM OperacionComercial__c];
        TOPP__c sglTOPP =[SELECT Id FROM TOPP__c WHERE TipodeOperacionporplan__c = 'Cambio Datos Cliente o Cuenta'];
        sOC[0].TOPP__c = sglTOPP.Id;
        update sOC;
        Map<Id,OperacionComercial__c> sOC1 = new Map<Id,OperacionComercial__c>([SELECT Id,Name,Detalle_del_tramite__c,FechadeActivacion__c,CuentaFacturacion__r.Name,Activo__r.ExternalServiceID__c,Plan__r.Name,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,NumeroArranqueAnterior__c,NumeroArranqueNuevo__c,ValorObraCivil__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,Plan__r.LTE_MetodoDePago__c,TipoSuspension__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, CuentaFacturacion__r.DirCorresp__c, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Name, CuentaFacturacion__r.LTE_Email__c, CuentaFacturacion__r.MedioFacturacion__c
                                            FROM OperacionComercial__c WHERE TOPP__r.TipodeOperacionporplan__c = 'Cambio Datos Cliente o Cuenta']);
	    test.startTest();
        BanderasEjecucion.setEjecucion('PS_Excepcion_Controlada');
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningOK());
        PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
        Map<Id,Map<String,Object>> mapDatos = sd.LoadMap(sOC1.keyset());
        sd.TOPPDispatcher(mapDatos);
        BanderasEjecucion.unSetEjecucion('PS_Excepcion_Controlada');
        test.stopTest();
   	}

    static testMethod void ServiceProvisioningLineaOKTest() {
        
    	createData();
    	Map<Id,Lineas_OC__c> sOC = new Map<Id,Lineas_OC__c>([SELECT Id,Name,Operacion_Comercial__r.Plan__c,Operacion_Comercial__r.CuentaFacturacion__c FROM Lineas_OC__c]);
        List<OperacionComercial__c> lstOC = [SELECT Id FROM OperacionComercial__c];
        for(OperacionComercial__c sglOC:lstOC){
            sglOC.FechaFacturacion__c = system.today();
        }
        update lstOC;
	    test.startTest();
        BanderasEjecucion.setEjecucion('PS_Excepcion_Controlada');
        Test.setMock(HttpCalloutMock.class, new PS_MockServiceProvisioningRev_tst.MockResponseServiceProvisioningOK());
        PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
        Map<Id,Map<String,Object>> mapDatos = sd.LoadMapLinea(sOC.keyset());
        sd.IntegracionLinea(mapDatos);
        BanderasEjecucion.unSetEjecucion('PS_Excepcion_Controlada');
        test.stopTest();
   	}
}