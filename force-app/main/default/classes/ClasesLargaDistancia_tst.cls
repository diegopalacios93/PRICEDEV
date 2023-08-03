/**
* Avanxo Colombia
* @author           Manuel Medina href=<mmedina@avanxo.com>
* Project:          ETB - Larga Distancia
* Description:      Clase de prueba para las clases que intervienen en el proceso de Larga Distancia.
*                   - FacturacionLargaDistancia_cls
*                   - TramitesLargaDistancia_cls
*                   - OperacionesLargaDistancia_cls
*
* Changes (Version)
* -------------------------------------
*           No.     Date                    Author                  Description
*------------------------------------------------------------------------------------------------------------
* @version  1.0     20/11/2015              Manuel Medina (MM)      Definicion inicial de la clase de prueba
*************************************************************************************************************/
@isTest
private class ClasesLargaDistancia_tst {
    
	public static void crearConfiguracion(){
        list<sobject> vg=new list<sobject>();
    	vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
    	vg.add(new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO'));
    	vg.add(new HomologacionSegmentos__c(Name='Defecto',Segmento__c='APN JURIDICO'));
        vg.add(new HomologacionCampos__c(Name='NIT',Valor__c='NIT'));
    	insert vg;
    }
    
    public static OperacionComercial__c crearOperacionComercial( String strTipoOperacionComercial, String strTipoConvenio ){
        
        crearConfiguracion();
        Map<String,List<String>> mapCodigoConvenioXTipoConvenio     = new Map<String,List<String>>{
                                                                        'C'     => new List<String>{ 'Conveniodecupo001', 'Plan Larga Distancia Convenio de Cupo', 'PlanLargaDistanciaCoveniodeCupo001', 'Convenio de cupo' },
                                                                        'V'     => new List<String>{ 'Conveniodevoz001', 'Plan Larga Distancia Covenio de Voz', 'PlanLargaDistanciaCoveniodeVoz001', 'Convenio de voz' }
                                                                    };
                                                                    
        Map<String,List<String>> mapTipoOperacionXCodigo            = new Map<String,List<String>>{
                                                                        'VC'    => new List<String>{ 'Venta- Plan Larga Distancia Convenio de Cupo', 'Venta', 'R1' },
                                                                        'AC'    => new List<String>{ 'Adición Lineas de LD- Plan Larga Distancia Covenio de Cupo', 'Adición Lineas de LD', 'R1' },
                                                                        'XC'    => new List<String>{ 'Exclusión Lineas de LD- Plan Larga Distancia Covenio de Cupo', 'Exclusión Lineas de LD', 'R16' },
                                                                        'CC'    => new List<String>{ 'Cambio de Plan- Plan Larga Distancia Convenio de Cupo', 'Cambio de Plan', 'CambiodePlan' },
                                                                        'RC'    => new List<String>{ 'Retiro- Plan Larga Distancia Convenio de Cupo', 'Retiro', 'Retiros' },
                                                                        'VV'    => new List<String>{ 'Venta- Plan Larga Distancia Covenio de Voz', 'Venta', 'R1' },
                                                                        'AV'    => new List<String>{ 'Adición Lineas de LD- Plan Larga Distancia Covenio de Voz', 'Adición Lineas de LD', 'R16' },
                                                                        'XV'    => new List<String>{ 'Exclusión Lineas de LD- Plan Larga Distancia Covenio de Voz', 'Exclusión Lineas de LD', 'R16' },
                                                                        'CV'    => new List<String>{ 'Cambio de Plan- Plan Larga Distancia Covenio de Voz', 'Cambio de Plan', 'CambiodePlan' },
                                                                        'RV'    => new List<String>{ 'Retiro- Plan Larga Distancia Covenio de Voz', 'Retiro', 'Retiros' }
                                                                        
                                                                    };
        
        /* BEGIN - Manuel Medina - Agregar tantos DeveloperName de tipo de registro como sean requeridos en el mapa - 20112015 */       
        Map<String,String> mapRecordTypeIdByDeveloperName           = new Map<String,String>{
                                                                        'Cliente_Principal'     => '',
                                                                        'Oferta_Comercial'      => '',
                                                                        'Sucursales'            => '',
                                                                        'R1'                    => '',
                                                                        'R16'                   => '',
                                                                        'CambiodePlan'          => '',
                                                                        'Retiros'               => '',
                                                                        'Cliente'               => ''
                                                                    };
        List<RecordType> lstRecordTypes                             = new List<RecordType>(
                                                                        [SELECT Id,
                                                                                Name, 
                                                                                DeveloperName
                                                                        FROM RecordType 
                                                                        WHERE DeveloperName IN: mapRecordTypeIdByDeveloperName.keySet()]
                                                                    );
        for( RecordType objRecordType : lstRecordTypes ){
            mapRecordTypeIdByDeveloperName.put( objRecordType.DeveloperName, objRecordType.Id );
        }
        /* END - Manuel Medina - Agregar tantos DeveloperName de tipo de registro como sean requeridos en el mapa - 20112015 */
        
        User objUser                                                = new User();
        objUser                                                     = [SELECT Id,
                                                                            Name,
                                                                            ProfileId,
                                                                            Profile.Name
                                                                        FROM User
                                                                        WHERE Profile.Name  = 'Soporte a Ventas'
                                                                        LIMIT 1
                                                                    ].get( 0 );

        List<sObject> cfgServiciosWeb = Test.loadData( ServiciosWeb__c.sObjectType, 'CFG_ServiciosWEB' );
        
        Poblacion__c objParentCity                                  = new Poblacion__c();
        objParentCity.Name                                          = 'BOGOTA D.C.';
        objParentCity.CodigoDane__c                                 = '11000';
        objParentCity.EsMunicipio__c                                = false;
        objParentCity.EsDepartamento__c                             = true;
        objParentCity.EsPais__c                                     = false;
        objParentCity.Indicativo__c                                 = 1;
        insert objParentCity;
        
        Poblacion__c objChildCity                                   = new Poblacion__c();
        objChildCity.Name                                           = 'BOGOTA D.C.';
        objChildCity.CodigoDane__c                                  = '11001';
        objChildCity.EsMunicipio__c                                 = true;
        objChildCity.EsDepartamento__c                              = false;
        objChildCity.EsPais__c                                      = false;
        objChildCity.Padre__c                                       = objParentCity.Id;
        insert objChildCity;

        Account objParentAccount                                    = new Account();
        objParentAccount.Name                                       = 'FINANDINA S.A.';
        objParentAccount.Type                                       = 'Cliente';
        objParentAccount.RecordTypeId                               = mapRecordTypeIdByDeveloperName.get( 'Cliente_Principal' );
        objParentAccount.Phone                                      = '12191919';
        objParentAccount.AccountNumber                              = '860060060';
        objParentAccount.Description                                = 'BANCO FINANDINA, CABEZA DE GRUPO DE EMPRESAS.';
        objParentAccount.Tipodedocumento__c                         = 'NIT';
        objParentAccount.AccionistaETB__c                           = false;
        objParentAccount.AutorizacionConsultaBDRiesgo__c            = false;
        objParentAccount.FechadeEscrituracion__c                    = System.today().addDays( -400 );
        objParentAccount.Segmento__c                                = 'Empresas';
        objParentAccount.SubSegmento__c                             = 'Grandes';
        objParentAccount.Ciudad__c                                  = objChildCity.Id;
        objParentAccount.Telefonodecontacto1__c                     = '6511919';
        objParentAccount.OtroTelefonodecontacto3__c                 = '6511920';
        objParentAccount.RazonSocial__c                             = 'BANCO FINANDINA';
        objParentAccount.AutorizacionManejodeDatosPersonales__c     = true;
        objParentAccount.Esmigrado__c                               = false;
        objParentAccount.Tienecertificaciones__c                    = false;
        objParentAccount.Direccion__c                               = 'CRA 20 CALLE 93';
        objParentAccount.DigitodeVerificacion__c                    = 6.0;
        //objParentAccount.Cuenta_Cliente_Unico__c                    = 'NIT860060060';
        objParentAccount.EstadoRestriccionVenta__c                  = false;
        objParentAccount.NumerodeSedes__c                           = '18';
        objParentAccount.FechaAniversarioEmpresa__c                 = '10213';
        objParentAccount.Tipo_Sucursal__c                           = 'Remota';
        //objParentAccount.Activo__c                                  = true;
        objParentAccount.Cliente_Pendiente_Entrega_a_Hogares__c     = false;
        //objParentAccount.ID_Direccion__c                            = '_a01f0000000QnQw_CRA 20 CALLE 93';
        insert objParentAccount;
        
        Account objChildAccount                                     = new Account();
        objChildAccount.Name                                        = 'FINANDINA';
        objChildAccount.Type                                        = 'Prospecto';
        objChildAccount.RecordTypeId                                = mapRecordTypeIdByDeveloperName.get( 'Sucursales' );
        objChildAccount.Phone                                       = '22191919';
        objChildAccount.Description                                 = 'SUCURSAL EL BANCO EN CALI';
        objChildAccount.AccionistaETB__c                            = false;
        objChildAccount.AutorizacionConsultaBDRiesgo__c             = false;
        objChildAccount.Ciudad__c                                   = objChildCity.Id;
        objChildAccount.RazonSocial__c                              = 'FINANDINA';
        objChildAccount.AutorizacionManejodeDatosPersonales__c      = false;
        objChildAccount.Esmigrado__c                                = false;
        objChildAccount.Tienecertificaciones__c                     = false;
        objChildAccount.Direccion__c                                = 'CRA 5 CALLE 10';
        objChildAccount.EstadoRestriccionVenta__c                   = false;
        objChildAccount.Cuenta__c                                   = objParentAccount.Id;
        objChildAccount.Tipo_Sucursal__c                            = 'Principal';
        //objChildAccount.Activo__c                                   = true;
        objChildAccount.Cliente_Pendiente_Entrega_a_Hogares__c      = false;
        insert objChildAccount;
        
        CuentaFacturacion__c objCuentaFacturacion                   = new CuentaFacturacion__c();
        objCuentaFacturacion.Name                                   = 'Fact';
        objCuentaFacturacion.Cliente__c                             = objParentAccount.Id;
        objCuentaFacturacion.ExclusionSusPago__c                    = false;
        objCuentaFacturacion.CodCicloFac__c                         = '18';
        objCuentaFacturacion.DirCorresp__c                          = 'Cll 20 # 6 -29';
        objCuentaFacturacion.Ciudad__c                              = objChildCity.Id;
        objCuentaFacturacion.Estado__c                              = 'Activo';
        objCuentaFacturacion.EsMigrado__c                           = false;
        objCuentaFacturacion.Nombre__c                              = 'FINANDINA S.A.';
        objCuentaFacturacion.Facturable__c                          = true;
        objCuentaFacturacion.Fue_creada_en_revchain__c              = false;
        objCuentaFacturacion.Tipo_Facturacion__c                    = 'Revchain';
        objCuentaFacturacion.TaxPlan__c                             = 'PLAN DE IMPUESTOS ETB LOCAL';
        insert objCuentaFacturacion;
        
        Opportunity objOpportunity                                  = new Opportunity();
        objOpportunity.AccountId                                    = objParentAccount.Id;
        objOpportunity.RecordTypeId                                 = mapRecordTypeIdByDeveloperName.get( 'Oferta_Comercial' );
        objOpportunity.Name                                         = 'VENTA';
        objOpportunity.StageName                                    = 'Negociación Cerrada';
        objOpportunity.CloseDate                                    = System.today();
        objOpportunity.Amount                                       = 12414.0;
        objOpportunity.Probability                                  = 95.0;
        objOpportunity.CausaldePerdida__c                           = '1. Oferta ETB con mejor precio';
        objOpportunity.BloqueoRegistro__c                           = false;
        objOpportunity.EsMigrado__c                                 = false;
        objOpportunity.Valor_unica_vez_ETB__c                       = 14214.0;
        objOpportunity.Valor_Recurrente_Aliado__c                   = 0.0;
        objOpportunity.Valor_unica_vez_Aliado__c                    = 0.0;
        objOpportunity.Checklist1__c                                = false;
        objOpportunity.Checklist2__c                                = false;
        objOpportunity.Checklist3__c                                = false;
        objOpportunity.Soportesdescuentoscomerciales__c             = false;
        objOpportunity.TieneServicioSolucionTI__c                   = false;
        //objOpportunity.OfertaAprobada__c                            = false;
        //objOpportunity.Oferta_Integral_Entregada__c                 = false;
        insert objOpportunity;
        
        CatalogoProductos__c objProducto                            = new CatalogoProductos__c();
        objProducto.Name                                            = mapCodigoConvenioXTipoConvenio.get( strTipoConvenio ).get( 3 );
        objProducto.Estado__c                                       = 'Activo';
        objProducto.Crear_Linea__c                                  = false;
        objProducto.EsMigrado__c                                    = true;
        objProducto.CodigoProducto__c                               = mapCodigoConvenioXTipoConvenio.get( strTipoConvenio ).get( 0 );
        objProducto.Familia__c                                      = 'LARGA DISTANCIA';
        objProducto.LineaNegocio__c                                 = 'LARGA DISTANCIA';
        objProducto.CodigoFacturacion__c                            = '5';
        objProducto.TTB__c                                          = false;
        insert objProducto;
        
        Planes__c objPlan                                           = new Planes__c();
        objPlan.Name                                                = mapCodigoConvenioXTipoConvenio.get( strTipoConvenio ).get( 1 );
        objPlan.NombredelProducto__c                                = objProducto.Id;
        objPlan.FechaInicio__c                                      = System.today().addDays( -30 );
        objPlan.Tarifa__c                                           = 0;
        objPlan.Esmigrado__c                                        = true;
        objPlan.Estado__c                                           = 'Activo';
        objPlan.Espromocion__c                                      = false;
        objPlan.ANSFactibilidad__c                                  = 1;
        objPlan.ANSAprovisionamiento__c                             = 1;
        objPlan.ANSAseguramiento__c                                 = 1;
        objPlan.TipodePlan__c                                       = 'Principal';
        objPlan.IdUnico__c                                          = mapCodigoConvenioXTipoConvenio.get( strTipoConvenio ).get( 2 );
        objPlan.EnvioFacturacion__c                                 = false;
        objPlan.Requiere_Aprobacion__c                              = false;
        //objPlan.Demo__c                                             = false;
        insert objPlan;
        
        PlanLD__c objPlanLD                                         = new PlanLD__c();
        objPlanLD.Name                                              = 'Valor Unico 1.000.000 Destinos';
        objPlanLD.PlanFacturacion__c                                = 'Valor Unico 1.000.000 Destinos - Cupo';
        objPlanLD.Plan__c                                           = objPlan.Id;
        objPlanLD.Producto__c                                       = 'Valor Unico - Asignacion de Cupo';
        objPlanLD.Servicio__c                                       = 'Corporativo FD';
        insert objPlanLD;
        
        PlanLD__c objPlanLDMundo                                    = new PlanLD__c();
        objPlanLDMundo.Name                                         = 'Plan Mundo';
        objPlanLDMundo.PlanFacturacion__c                           = '';
        objPlanLDMundo.Plan__c                                      = objPlan.Id;
        objPlanLDMundo.Producto__c                                  = 'Valor Unico - Asignacion de Cupo';
        objPlanLDMundo.Servicio__c                                  = 'Corporativo FD';
        insert objPlanLDMundo;
        
        SubPlanFacturacion__c subPlanMundo = new SubPlanFacturacion__c();
        subPlanMundo.Name = 'Valor Unico 20.000.000 CAJACOPI AyA - Chain';
        subPlanMundo.Codigo__c = '2030263';
        subPlanMundo.LTE_Precio__c = 0;
        subPlanMundo.Tipo__c = 'A y A';
        subPlanMundo.ProductoLD__c = 'Automaticos y Asistidos';
        subPlanMundo.PlanLD__c = objPlanLDMundo.Id;
        insert subPlanMundo;
        
        Contract objContract                                        = new Contract();
        objContract.AccountId                                       = objParentAccount.Id;
        objContract.OwnerExpirationNotice                           = '15';
        objContract.StartDate                                       = System.today();
        objContract.EndDate                                         = System.today().addDays( 30 );
        objContract.ContractTerm                                    = 12;
        objContract.Status                                          = 'Borrador';
        objContract.Description                                     = 'CONTRATO DE CONECTIVIDAD PARA LOS BACKUP DE FINANDINA';
        objContract.RecordTypeId                                    = mapRecordTypeIdByDeveloperName.get( 'Cliente' );
        objContract.Name                                            = 'FINANDINA S.A.-00000374';
        objContract.NumeroContratoSGC__c                            = '2013';
        objContract.TipodecontratoETB__c                            = 'Otrosí';
        objContract.MontoPrecioContrato__c                          = 5645645;
        objContract.AsesorComercial__c                              = System.UserInfo.getUserId();
        objContract.Duracion__c                                     = 36;
        objContract.EsMigrado__c                                    = false;
        objContract.Renovacion_Automatica__c                        = false;
        objContract.monto_ejecutado__c                              = 1352441;
        objContract.Afecta_Tiempo_Inicial__c                        = false;
        objContract.Clausula_Cobro_de_Equipos__c                    = false;
        objContract.Modelo_de_Negoc__c                              = false;
        objContract.Forma_de_Pago__c                                = 'No';
        objContract.Influye_fecha_de_finalizacion__c                = false;
        objContract.Monto_propietario_cuenta__c                     = 'test@tst.co';
        objContract.CuentaFacturacion__c                            = objCuentaFacturacion.Id;
        objContract.Finaliza_por_Agotamiento_de_Recursos__c         = false;
        objContract.PlazoPago__c                                    = '15';
        insert objContract;
        
        Legalizacion__c objLegalizacion                             = new Legalizacion__c();
        objLegalizacion.Contrato__c                                 = objContract.Id;
        objLegalizacion.AprobacionDocpendienteporelGerente__c       = false;
        objLegalizacion.ContratoCartaFirmadaoEmailcliente__c        = false;
        objLegalizacion.CertificadoCamaradecomercio__c              = false;
        objLegalizacion.Rut__c                                      = false;
        objLegalizacion.SuperintendenciaFinanciera__c               = false;
        objLegalizacion.CeduladeExtranjeria__c                      = false;
        objLegalizacion.CondicionesGralesPrestServNoDomicil__c      = false;
        objLegalizacion.ContratoNegociado__c                        = false;
        objLegalizacion.AutorizacionConsultaReportecentrales__c     = false;
        objLegalizacion.Clausuladepermanenciaminima__c              = false;
        objLegalizacion.Actadeentregadelservicio__c                 = false;
        objLegalizacion.LocucionFormatowawmenora20segundos__c       = false;
        objLegalizacion.FormatodeFactibilidad__c                    = false;
        objLegalizacion.CheckListFraude__c                          = false;
        objLegalizacion.Oferta__c                                   = false;
        objLegalizacion.Modelodenegocios__c                         = false;
        objLegalizacion.AnexoComercial__c                           = false;
        objLegalizacion.AnexoTecnico__c                             = false;
        objLegalizacion.Anexooautorizacionobrasciviles__c           = false;
        objLegalizacion.NovedaddeFacturacion__c                     = false;
        objLegalizacion.ConfiguradordeServicios__c                  = false;
        objLegalizacion.CartaAsignacionSupervisor__c                = false;
        objLegalizacion.ActadeInicio__c                             = false;
        objLegalizacion.Cartacomunicacionpreventivadefraude__c      = false;
        objLegalizacion.Parafiscales__c                             = false;
        objLegalizacion.CertresponsablesfiscalesContraloria__c      = false;
        objLegalizacion.Cert_Inhabilidadeseincompatibilidades__c    = false;
        objLegalizacion.FotocopiaCCRepresentanteLegal__c            = false;
        objLegalizacion.AntecedentesJudicialesRepresLegal__c        = false;
        objLegalizacion.GarantiadeSeriedad__c                       = false;
        objLegalizacion.RUP__c                                      = false;
        objLegalizacion.CertificacionBancaria__c                    = false;
        objLegalizacion.DeclaraciondeRenta__c                       = false;
        objLegalizacion.EstadosFinancieros__c                       = false;
        objLegalizacion.CertificacionesdeExperiencia__c             = false;
        objLegalizacion.AprobacionDescuentos__c                     = false;
        objLegalizacion.Estado__c                                   = 'Gestionado';
        objLegalizacion.Nombredelacuenta2__c                        = objParentAccount.Id;
        objLegalizacion.Destinatario_Notificacion_Cambio_Estados__c = 'test@tst.co';
        objLegalizacion.Causal_Estado__c                            = 'Resuelto';
        objLegalizacion.Fecha_Final_Estado__c                       = System.today().addDays( -5 );
        objLegalizacion.AnalistaSoporteVentas__c                    = objUser.Id;
        objLegalizacion.Fecha_de_solicitud_cliente__c               = System.today();
        insert objLegalizacion;
        
        Contact objContact                                          = new Contact(IsTEST__c = true);
        objContact.AccountId                                        = objParentAccount.Id;
        objContact.LastName                                         = 'Farias';
        objContact.FirstName                                        = 'Mauricio';
        objContact.Phone                                            = '7440550';
        objContact.MobilePhone                                      = '56780978';
        objContact.Email                                            = 'test@tst.co';
        objContact.LeadSource                                       = 'Socio';
        objContact.HasOptedOutOfEmail                               = false;
        objContact.HasOptedOutOfFax                                 = false;
        objContact.DoNotCall                                        = false;
        objContact.Contactoautorizadoparaopercciales__c             = false;
        objContact.Esmigrado__c                                     = false;
        objContact.Area__c                                          = 'Dpto. Tecnología / IT / Informática / Técnico';
        objContact.AutorizacionManejoDatosPersonales__c             = false;
        objContact.Genero__c                                        = 'Masculino';
        objContact.Ciudad__c                                        = objChildCity.Id;
        objContact.Tipodedocumento__c                               = 'Cédula de ciudadanía';
        objContact.NumerodeIdentificacion__c                        = '123';
        objContact.Direccion__c                                     = 'Calle 1';
        objContact.IdUnico__c                                       = '123';
        objContact.Rol__c                                           = 'Gestor';
        objContact.Autorizaci_n_Consulta_BD_Riesgo__c               = false;
        objContact.Es_Supervisor__c                                 = false;
        //objContact.Estado_contacto__c                               = true;
        objContact.contactos_autorizados_por_medio_de_firma__c      = false;
        //objContact.Contacto_Autorizado_LTE__c                       = false;
        insert objContact;
        
        TOPP__c objTOPP                                             = new TOPP__c();
        objTOPP.Name                                                = mapTipoOperacionXCodigo.get( strTipoOperacionComercial ).get( 0 );
        objTOPP.Plan__c                                             = objPlan.Id;
        objTOPP.Tipoderegistro__c                                   = mapTipoOperacionXCodigo.get( strTipoOperacionComercial ).get( 2 );
        objTOPP.AplicaPreventa__c                                   = false;
        objTOPP.AplicaGerenteProyecto__c                            = false;
        objTOPP.ValorTarifaPlan__c                                  = 0;
        objTOPP.Valorunicavez__c                                    = 0;
        objTOPP.RequiereAnchodeBanda__c                             = false;
        objTOPP.Esmigrado__c                                        = false;
        objTOPP.DisponibleVentainicial__c                           = false;
        objTOPP.TipodeOperacionporplan__c                           = mapTipoOperacionXCodigo.get( strTipoOperacionComercial ).get( 1 );
        objTOPP.Afecta_Ingresos__c                                  = false;
        objTOPP.Activo__c                                           = true;
        objTOPP.Facturable__c                                       = false;
        insert objTOPP;
        
        ActivoETB__c objServicioETB                                 = new ActivoETB__c();
        objServicioETB.NombredelProducto__c                         = objProducto.Id;
        objServicioETB.Oportunidad__c                               = objOpportunity.Id;
        objServicioETB.SucursalOrigen__c                            = objChildAccount.Id;
        objServicioETB.Esmigrado__c                                 = false;
        objServicioETB.NombredelaCuenta__c                          = objParentAccount.Id;
        objServicioETB.Plan__c                                      = objPlan.Id;
        objServicioETB.Estado__c                                    = 'Activo';
        objServicioETB.ActivoprincipalLD__c                         = false;
        objServicioETB.CuentaFacturacion__c                         = objCuentaFacturacion.Id;
        objServicioETB.Fecha_Activacion__c                          = System.now();
        objServicioETB.Plan_Larga_Distancia__c                      = 'Plan Mundo Automatico - Asistido';
        objServicioETB.PlanLD__c                                    = objPlanLD.Id;
        insert objServicioETB;
        
        OperacionComercial__c objOC                                 = new OperacionComercial__c();
        objOC.RecordTypeId                                          = mapRecordTypeIdByDeveloperName.get( mapTipoOperacionXCodigo.get( strTipoOperacionComercial ).get( 2 ) );
        objOC.Activo__c                                             = objServicioETB.Id;
        objOC.Legalizacion__c                                       = objLegalizacion.Id;
        objOC.Plan__c                                               = objPlan.Id;
        objOC.CuentaFacturacion__c                                  = objCuentaFacturacion.Id;
        objOC.TOPP__c                                               = objTOPP.Id;
        objOC.Estado__c                                             = 'Pendiente Facturacion';
        objOC.FechadeActivacion__c                                  = System.today();
        objOC.ValorTarifaPlan__c                                    = 12414;
        objOC.Valorunicavez__c                                      = 14214;
        objOC.SucursalOrigen__c                                     = objChildAccount.Id;
        objOC.Oportunidad__c                                        = objOpportunity.Id;
        objOC.Tarifa__c                                             = 0;
        objOC.Destinatario_Notificacion_Cambio_Estados__c           = 'test@tst.com';
        objOC.EnvioFacturacion__c                                   = true;
        objOC.Fraccionamiento__c                                    = false;
        objOC.Cabecera_1_PBX__c                                     = false;
        //objOC.Cabecera_1_MDE__c                                     = false;
        objOC.CuentaCliente__c                                      = objParentAccount.Id;
        objOC.Nombre_Cuenta__c                                      = 'FINANDINA S.A.';
        objOC.TipodeInternetSeguridadenlaNube__c                    = 'Internet +';
        objOC.Codigo_Secreto__c                                     = false;
        objOC.EsMigrado__c                                          = false;
        objOC.Margen_Soluciones_TI__c                               = 0;
        objOC.Incidencia_en_ingresos__c                             = 'Incremento';
        objOC.Contacto_Tecnico__c                                   = objContact.Id;
        objOC.Duracion_Dias__c                                      = 0;
        objOC.Duracion_Meses__c                                     = 0;
        objOC.TipoFacturacion__c                                    = 'Cobro Unico Recurrente';
        objOC.Requiere_Permiso_Visita__c                            = false;
        objOC.Fecha_Final_Estado__c                                 = System.today();
        objOC.Potencializacion_Multa__c                             = false;
        objOC.Envio_Red_Inteligente__c                              = false;
        objOC.Necesita_Escalamiento__c                              = false;
        objOC.Aplica_Migracion_de_Numero__c                         = false;
        objOC.Financiador__c                                        = false;
        objOC.FechaPendienteFacturacion__c                          = System.now();
        objOC.AprobadoMercadeoLTE__c                                = false;
        objOC.Envio_Operador_Logistico__c                           = false;
        objOC.Portacion__c                                          = false;
        objOC.PlanLD__c                                             = objPlanLD.Id;
        objOC.Revisado_Facturacion__c                               = true;
        insert objOC;
        
        SubPlanFacturacion__c subPlan = new SubPlanFacturacion__c();
        subPlan.Name = 'Valor Unico 10.000.000 CAJACOPI AyA - Chain';
        subPlan.Codigo__c = '2030262';
        subPlan.LTE_Precio__c = 0;
        subPlan.Tipo__c = 'A y A';
        subPlan.ProductoLD__c = 'Automaticos y Asistidos';
        subPlan.PlanLD__c = objOC.PlanLD__c;
        insert subPlan;
        
        Linea__C linea = new Linea__C();
        linea.Name = '12501480';
        linea.Operacion_Comercial_Actual__c = objOC.Id;
        linea.ExternalID__c = 'AC-607683';
        linea.ActivaServicioLD__c = true;
        linea.Linea_ETB__c = 'Si';
        linea.Activo__c = objOC.Activo__c;
        linea.CrearLSP__c = true;
        insert linea;
        
        return objOC;
    }

    static testMethod void testOCVentaCupo() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'VC', 'C' );
        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        FacturacionLargaDistancia_cls clsFact = new FacturacionLargaDistancia_cls();
        try{
            clsFact.validacionFacturacion(objOC);
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCRetiroCupo() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'RC', 'C' );
        
        Linea__C linea = [SELECT id,CrearLSP__c FROM Linea__C WHERE Name = '12501480' Limit 1];
        linea.CrearLSP__c = true;
        linea.CancelarCupo__c = true;
        update linea;
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCAdicionLineasCupo() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'AC', 'C' );
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCExclusionLineasCupo() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'XC', 'C' );
        
        Linea__C linea = [SELECT id,CrearLSP__c FROM Linea__C WHERE Name = '12501480' Limit 1];
        linea.CrearLSP__c = false;
        update linea;
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCVentaVoz() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'VV', 'V' );
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c,
                                                                       		(SELECT Id, ExternalID__c FROM Operacion_Comercial_Actual__r)
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCAdicionLineasVoz() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'AV', 'V' );
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCExclusionLineasVoz() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'XV', 'V' );
        
        Linea__C linea = [SELECT id,CrearLSP__c FROM Linea__C WHERE Name = '12501480' Limit 1];
        linea.CrearLSP__c = false;
        update linea;
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }

    static testMethod void testOCRetiroVoz() {
        OperacionComercial__c objOC                                 = crearOperacionComercial( 'RV', 'V' );
        
        Linea__C linea = [SELECT id,CrearLSP__c FROM Linea__C WHERE Name = '12501480' Limit 1];
        linea.CrearLSP__c = false;
        update linea;
        
        Test.startTest();
        list<OperacionComercial__c> lstOC                           = [SELECT id,
                                                                            CuentaFacturacion__c,
                                                                            CuentaFacturacion__r.Name, 
                                                                            planLD__c 
                                                                        FROM OperacionComercial__c 
                                                                        WHERE Id =: objOC.Id
                                                                    ];

        Test.setMock( HttpCalloutMock.class, new ServiciosLargaDistanciaMock_mws() );
        
        ConstruccionCanonico_cls objCanonico                        = new ConstruccionCanonico_cls();
        try{
            objCanonico.CrearFacturacion( lstOC );
        }catch( Exception E ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
        }
        Test.stopTest();
    }
}