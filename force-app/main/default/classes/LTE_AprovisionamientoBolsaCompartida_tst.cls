/*******************************************************************************
Develope by:            ETB
Author:                 Fernando Sarasty
Project:                Bolsas compartidas
Description:            Clase de prueba del proceso de aprovisionamiento de bolsas compartidas LTE.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     14/05/2020  Fernando Sarasty		         Class creation.
*******************************************************************************/
@isTest (SeeAllData=false)
public class LTE_AprovisionamientoBolsaCompartida_tst {
    public static Account objAccount;
    public static Contract objContrato;
    public static Poblacion__c objDepto;
    public static Poblacion__c objMunicipio;
    public static CuentaFacturacion__c objCtaFact;
    public static Contact objContact;
    public static Opportunity objOportunidad;
    public static Legalizacion__c objLegalizacion;
    public static CatalogoProductos__c objProducto;
    public static TOPP__c objTOPP;
    public static TOPP__c objTOPP5;                        
    public static Equipo__c objEquipo;
    public static Planes__c objPlan;
    public static ActivoETB__c objServicioPadre;
    public static ActivoETB__c objServicioHijo1;           
    public static LTE_Servicios_adicionales__c objServAdicional2;
    public static LTE_Servicios_adicionales__c objServAdicional3;
    public static LTE_Servicios_adicionales__c objServAdicional4;
    public static LTE_Servicios_adicionales__c objServAdicional5;    
    public static LTE_SpecificationGroupXA__c objSpecification3;
    public static LTE_SpecificationGroupXA__c objSpecification4;
    public static LTE_SpecificationGroupXA__c objSpecification5;
    public static LTE_SpecificationGroupXA__c objSpecification6;
    public static OperacionComercial__c objOCPadreAprovisionada;
    public static OperacionComercial__c objOCPadre;
    public static OperacionComercial__c objOCHija1;    
    public static Reserva__c objOferta;
    public static LTE_DetalleOferta__c objDetalleOferta;
    public static LTE_DetalleOferta__c objDetalleOferta2;
    public static VariablesGlobales__c objVariables;                    
    
    public static void CreateData(){
      objVariables = new VariablesGlobales__c();
      objVariables.Name = 'NombreComercialLTE';
      objVariables.Valor__c = 'TELEFONIA MOVIL (LTE)';
      insert objVariables;
        
      objAccount = new Account();
   	  objAccount.Name = 'Test Name';
      objAccount.RazonSocial__c = 'Test razon social';
      objAccount.Tipodedocumento__c = 'NIT';
      objAccount.Estado_Cuenta__c = 'Activo';
      objAccount.AccountNumber = '1029837456'; 
      objAccount.Phone= '1029837456';
      objAccount.Segmento__c = 'Gobierno Distrital';
      objAccount.SubSegmento__c = 'Mediana';   
      insert objAccount;

      objContrato = new Contract();
      objContrato.Name = 'Test name contrato';
      objContrato.AccountId = objAccount.Id;
      objContrato.Status = 'Borrador';
      insert objContrato;

      objDepto = new Poblacion__c();
      objDepto.Name = 'BOGOTA D.C.';
      objDepto.CodigoDane__c = '11000';
      objDepto.EsDepartamento__c = true;
      insert objDepto;

      objMunicipio = new Poblacion__c();
      objMunicipio.Name = 'BOGOTA D.C.';
      objMunicipio.CodigoDane__c = '11001';
      objMunicipio.EsMunicipio__c = true;
      objMunicipio.Padre__c = objDepto.Id;
      insert objMunicipio;

      objCtaFact = new CuentaFacturacion__c();
      objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
      objCtaFact.Cliente__c = objAccount.Id;
      objCtaFact.Facturable__c = true;
      objCtaFact.LTE_MetodoEnvio__c = 'Email';
      objCtaFact.LTE_CicloFacturacion__c = '5';
      objCtaFact.LTE_Email__c = 'test@test.com';      
      objCtaFact.DirCorresp__c = 'Direccion test';
      objCtaFact.Ciudad__c = objMunicipio.Id;
      objCtaFact.LTE_CuentaFacturacionLTE__c = true;
      objCtaFact.Fue_creada_en_revchain__c = true;
      objCtaFact.DirCorresp__c = 'Test DirCorresp';
      insert objCtaFact;

      objContact = new Contact(IsTEST__c = true);
      objContact.FirstName = 'Andres';
      objContact.LastName = 'Lopez';
      objContact.AccountId = objAccount.Id;
      objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
      objContact.NumerodeIdentificacion__c = '345678904';
      objContact.Estado__c = 'Activo';
      objContact.Cargo__c = 'Ingeniero';
      objContact.Area__c = 'Dpto. Financiero';
      objContact.Rol__c = 'Administrativo';
      objContact.LTE_RolLTE__c = 'Total';
      objContact.Genero__c = 'Masculino';
      objContact.Direccion__c = 'Calle 12 # 34 - 53';
      objContact.Phone = '432432432';
      objContact.MobilePhone = '3105667655';
      objContact.Email = 'scampos@avanxo.com';
      objContact.Ciudad__c = objMunicipio.Id;
      insert objContact;

      objOportunidad = new Opportunity();
      objOportunidad.Name = 'Test name';
      objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
      objOportunidad.AccountId = objAccount.Id;
      objOportunidad.StageName = 'Análisis de necesidades';
      objOportunidad.CloseDate = system.today();
      objOportunidad.Amount = 1000;
      objOportunidad.Valor_unica_vez_ETB__c = 150;
      objOportunidad.LTE_Scoring__c = 9000000;
      objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
      objOportunidad.LTE_NumeroLinea__c = 2;
      insert objOportunidad;

      objLegalizacion = new Legalizacion__c();
      objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
      objLegalizacion.Contrato__c = objContrato.Id;
      objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
      objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
      objLegalizacion.LTE_FechaGestion__c = system.today();
      objLegalizacion.Estado__c = 'Gestionado';
      objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
      objLegalizacion.Cuotas__c = 2;
      insert objLegalizacion;

      objProducto = new CatalogoProductos__c();
      objProducto.Name = 'TELEFONIA MOVIL (LTE)';
      objProducto.Familia__c = 'LTE';
      objProducto.LineaNegocio__c = 'Redes Móviles';
      objProducto.CodigoProducto__c = '7635736';
      objProducto.Estado__c = 'Activo';
      objProducto.Descripcion__c = 'Teste';
      objProducto.AtributosEstandar__c = 'Teste';
      insert objProducto;

      objTOPP = new TOPP__c();
      objTOPP.Name = 'Adición bolsa compartida';
      objTOPP.TipodeOperacionporplan__c = 'Adición bolsa compartida';
      objTOPP.Tipoderegistro__c = 'Venta_LTE';
      objTOPP.DisponibleVentainicial__c = true;
      objTOPP.Facturable__c = true;
      objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP;

      objTOPP5 = new TOPP__c();
      objTOPP5.Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)';
      objTOPP5.TipodeOperacionporplan__c = 'Cambio de Plan';
      objTOPP5.Tipoderegistro__c = 'CambioPlan_LTE';
      objTOPP5.Facturable__c = true;
      objTOPP5.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP5;

      objEquipo = new Equipo__c();
      objEquipo.Name = 'Ascend G6 Negro';
      objEquipo.LTE_PartNumber__c = '129456789987654';
      objEquipo.LTE_Marca__c = 'Huawei';
      objEquipo.LTE_Color__c = 'Negro';
      objEquipo.LTE_Activo__c = true;
      objEquipo.Valor_del_Equipo__c = 395689;
      objEquipo.LTE_IVA__c = 63310;
      objEquipo.LTE_PrecioConIVA__c = 459000;
      insert objEquipo;        
        
      objPlan = new Planes__c ();
      objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
      objPlan.NombredelProducto__c = objProducto.Id;
      objPlan.TipodePlan__c = 'Principal';
      objPlan.Tarifa__c = 96000;
      objPlan.Estado__c = 'Activo';
      objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan.LTE_PlanEstructurados__c = true;
      objPlan.LTE_TipoControl__c = 'Abierto';
      insert objPlan;
        
      objOferta = new Reserva__c();
      objOferta.Oportunidad__c = objOportunidad.Id;
      objOferta.Estado__c = 'Pendiente';
      objOferta.Equipo__c = objEquipo.Id;
      objOferta.LTE_Plan__c = objPlan.Id;
      insert  objOferta;
        
      objServicioPadre = new ActivoETB__c();
      objServicioPadre.Oportunidad__c = objOportunidad.Id;
      objServicioPadre.NombredelaCuenta__c = objAccount.Id;
      objServicioPadre.Plan__c = objPlan.Id;
      objServicioPadre.Estado__c = 'Pendiente';
      objServicioPadre.IMEI_del_Equipo__c = '980684862113805';
      objServicioPadre.LTE_ICCID__c = '8957187113000000506';
      objServicioPadre.NumeroConexion__c = '3057000501';
      objServicioPadre.Fecha_Activacion__c = system.now();
      objServicioPadre.Tipo_linea_bolsa_compartida__c = 'Padre';
      insert objServicioPadre;

      objServicioHijo1 = new ActivoETB__c();
      objServicioHijo1.Oportunidad__c = objOportunidad.Id;
      objServicioHijo1.NombredelaCuenta__c = objAccount.Id;
      objServicioHijo1.Plan__c = objPlan.Id;
      objServicioHijo1.Estado__c = 'Pendiente';
      objServicioHijo1.IMEI_del_Equipo__c = '980684862113805';
      objServicioHijo1.LTE_ICCID__c = '8957187113000000506';
      objServicioHijo1.NumeroConexion__c = '3057000501';
      objServicioHijo1.Fecha_Activacion__c = system.now();
      objServicioHijo1.Tipo_linea_bolsa_compartida__c = 'Hija';
      objServicioHijo1.Activo_Relacionado__c = objServicioPadre.Id;
      insert objServicioHijo1;

      objOCPadre = new OperacionComercial__c();
      objOCPadre.CuentaCliente__c = objAccount.Id;
      objOCPadre.Activo__c = objServicioPadre.Id;
      objOCPadre.Plan__c = objPlan.Id;
      objOCPadre.TOPP__c = objTOPP.Id;
      objOCPadre.Oportunidad__c = objOportunidad.Id;
      objOCPadre.CuentaFacturacion__c = objCtaFact.Id;
      objOCPadre.Estado__c = 'En Curso';      
      objOCPadre.FechadeActivacion__c = system.today();
      objOCPadre.NumeroConexion__c = '3057000501';
      objOCPadre.FechadeActivacion__c = system.today();
      objOCPadre.Legalizacion__c = objLegalizacion.Id;
      objOCPadre.Tipo_linea_bolsa_compartida__c = 'Padre';
      objOCPadre.SDP__c = '2';
      objOCPadre.IMEI_del_Equipo__c = '988844184859301';
      objOCPadre.LTE_ICCID__c = '8957187113000000498';
      objOCPadre.LTE_IMSI__c = '732187100000498';
      insert objOCPadre;
        
      objOCPadreAprovisionada = new OperacionComercial__c();
      objOCPadreAprovisionada.CuentaCliente__c = objAccount.Id;
      objOCPadreAprovisionada.Activo__c = objServicioPadre.Id;
      objOCPadreAprovisionada.Plan__c = objPlan.Id;
      objOCPadreAprovisionada.TOPP__c = objTOPP.Id;
      objOCPadreAprovisionada.Oportunidad__c = objOportunidad.Id;
      objOCPadreAprovisionada.CuentaFacturacion__c = objCtaFact.Id;
      objOCPadreAprovisionada.Estado__c = 'Facturado';   
      objOCPadreAprovisionada.FechadeActivacion__c = system.today();
      objOCPadreAprovisionada.NumeroConexion__c = '3057000501';
      objOCPadreAprovisionada.FechadeActivacion__c = system.today();
      objOCPadreAprovisionada.Legalizacion__c = objLegalizacion.Id;
      objOCPadreAprovisionada.Tipo_linea_bolsa_compartida__c = 'Padre';
      objOCPadreAprovisionada.SDP__c = '2';
      objOCPadreAprovisionada.IMEI_del_Equipo__c = '988844184859301';
      objOCPadreAprovisionada.LTE_ICCID__c = '8957187113000000498';
      objOCPadreAprovisionada.LTE_IMSI__c = '732187100000498';
      objOCPadreAprovisionada.EstadoAprovisionamiento__c = 'COMPLETE';
      insert objOCPadreAprovisionada;
        
      objOCHija1 = new OperacionComercial__c();
      objOCHija1.CuentaCliente__c = objAccount.Id;
      objOCHija1.Activo__c = objServicioHijo1.Id;
      objOCHija1.Plan__c = objPlan.Id;
      objOCHija1.TOPP__c = objTOPP.Id;
      objOCHija1.Oportunidad__c = objOportunidad.Id;
      objOCHija1.CuentaFacturacion__c = objCtaFact.Id;
      objOCHija1.Estado__c = 'En Curso';      
      objOCHija1.FechadeActivacion__c = system.today();
      objOCHija1.NumeroConexion__c = '3057000501';
      objOCHija1.FechadeActivacion__c = system.today();
      objOCHija1.Legalizacion__c = objLegalizacion.Id;
      objOCHija1.Tipo_linea_bolsa_compartida__c = 'Hija';
      objOCHija1.SDP__c = '2';
      objOCHija1.IMEI_del_Equipo__c = '988844184859301';
      objOCHija1.LTE_ICCID__c = '8957187113000000498';
      objOCHija1.LTE_IMSI__c = '732187100000498';
      objOCHija1.Operacion_Comercial_Relacionada__c = objOCPadreAprovisionada.Id;
      objOCHija1.FechaInicioReconexion__c = system.today();
      insert objOCHija1;

        
      objDetalleOferta = new LTE_DetalleOferta__c();
      objDetalleOferta.LTE_OperacionComercial__c = objOCPadre.Id;
      objDetalleOferta.LTE_Cliente__c = objAccount.Id;
      objDetalleOferta.LTE_Oferta_Economica__c = objOferta.Id;
      objDetalleOferta.LTE_Estado__c = 'Pendiente';
      objDetalleOferta.LTE_Estado_Detalle_Oferta__c = 'Reservado';
      objDetalleOferta.LTE_ReferenciaEquipo__c = objEquipo.Id;
      objDetalleOferta.LTE_IMEI__c = '980684862113805';
      objDetalleOferta.LTE_ICCID__c = '8957187113000000506';
      objDetalleOferta.LTEValorEquipoDescuento__c = 458999;
      objDetalleOferta.Plan__c = objPlan.Id;
      insert objDetalleOferta;
        
      objDetalleOferta2 = new LTE_DetalleOferta__c();
      objDetalleOferta2.LTE_OperacionComercial__c = objOCHija1.Id;
      objDetalleOferta2.LTE_Cliente__c = objAccount.Id;
      objDetalleOferta2.LTE_Oferta_Economica__c = objOferta.Id;
      objDetalleOferta2.LTE_Estado__c = 'Pendiente';
      objDetalleOferta2.LTE_Estado_Detalle_Oferta__c = 'Reservado';
      objDetalleOferta2.LTE_ReferenciaEquipo__c = objEquipo.Id;
      objDetalleOferta2.LTE_IMEI__c = '980684862113805';
      objDetalleOferta2.LTE_ICCID__c = '8957187113000000506';
      objDetalleOferta2.LTEValorEquipoDescuento__c = 458999;
      objDetalleOferta2.Plan__c = objPlan.Id;
      insert objDetalleOferta2;

      objServAdicional2 = new LTE_Servicios_adicionales__c();
      objServAdicional2.Name = 'OTRO NOMBRE';
      objServAdicional2.LTE_Estado__c = 'Pendiente';
      objServAdicional2.LTE_ServicioETB__c = objServicioPadre.Id;
      objServAdicional2.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
      objServAdicional2.LTE_PrimaryClassificationCode__c = 'CLASE FINANCIAMIENTO LTE';
      insert objServAdicional2;
        
      objServAdicional3 = new LTE_Servicios_adicionales__c();
      objServAdicional3.Name = 'OTRO NOMBRE';
      objServAdicional3.LTE_Estado__c = 'Pendiente';
      objServAdicional3.LTE_ServicioETB__c = objServicioHijo1.Id;
      objServAdicional3.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta2.Id;
      objServAdicional3.LTE_PrimaryClassificationCode__c = 'CLASE FINANCIAMIENTO LTE';
      insert objServAdicional3;
                
      objSpecification3 = new LTE_SpecificationGroupXA__c();
      objSpecification3.Name = 'SERVICE CLASSE OCS';
      objSpecification3.LTE_ActionCode__c = 'ADD';
      objSpecification3.LTE_Value__c = 'CONTR0003687410';
      objSpecification3.LTE_ServiciosAdicionales__c = objServAdicional2.Id;
      insert objSpecification3;
        
      objSpecification4 = new LTE_SpecificationGroupXA__c();
      objSpecification4.Name = 'PAM_CLASS_ID';
      objSpecification4.LTE_ActionCode__c = 'ADD';
      objSpecification4.LTE_Value__c = '0';
      objSpecification4.LTE_ServiciosAdicionales__c = objServAdicional2.Id;
      insert objSpecification4;
        
      objSpecification5 = new LTE_SpecificationGroupXA__c();
      objSpecification5.Name = 'SERVICE CLASSE OCS';
      objSpecification5.LTE_ActionCode__c = 'ADD';
      objSpecification5.LTE_Value__c = 'CONTR0003687410';
      objSpecification5.LTE_ServiciosAdicionales__c = objServAdicional3.Id;
      insert objSpecification5;
        
      objSpecification6 = new LTE_SpecificationGroupXA__c();
      objSpecification6.Name = 'PAM_CLASS_ID';
      objSpecification6.LTE_ActionCode__c = 'ADD';
      objSpecification6.LTE_Value__c = '0';
      objSpecification6.LTE_ServiciosAdicionales__c = objServAdicional3.Id;
      insert objSpecification6;
    }
  
    @isTest static void test_method_one()
    {       
       Test.startTest();   
       list<sobject> vg=new list<sobject>();       
       vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));       
       insert vg;             
       CreateData();
       
	   set<id> fidImediato=new set<id>{objOCPadre.Id};              
       SchedulableContext sc;        
	   LTE_AprovisionamientoBolsaCompartida_bch sch = new LTE_AprovisionamientoBolsaCompartida_bch();
	   sch.limitQ = true;
	   sch.limiteTotal=1;
       sch.idImediato = fidImediato;
       ID batchprocessid = Database.executeBatch(sch,1);
       Test.stopTest(); 
    }
    
    @isTest static void test_method_two()
    {
       Test.startTest(); 
       list<sobject> vg=new list<sobject>();       
       vg.add(new EjecucionIntegracion__c(Name='Aprovisionamiento',Ejecucion__c=true));       
       insert vg;  
       CreateData();       
	   set<id> fidImediato=new set<id>{objOCHija1.Id};	          
       SchedulableContext sc;        
	   LTE_AprovisionamientoBolsaCompartida_bch sch = new LTE_AprovisionamientoBolsaCompartida_bch();
	   sch.limitQ = true;
	   sch.limiteTotal=1;
       sch.idImediato = fidImediato;
       ID batchprocessid = Database.executeBatch(sch,1);       
       Test.stopTest();          
    }/*
    @isTest static void test_method_three()
    {
       Test.startTest();
       CreateData();      
       objOCHija1.Estado__c = 'Activa'; 
       objOCHija1.EstadoAprovisionamiento__c = 'COMPLETE';
       update objOCHija1;                
       objOCPadre.Estado__c = 'Facturado';
       update objOCPadre; 	   
       Test.stopTest();
    }*/     
}