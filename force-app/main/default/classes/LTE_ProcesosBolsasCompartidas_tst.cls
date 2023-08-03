@isTest(SeeAllData=true)
public class LTE_ProcesosBolsasCompartidas_tst {
	public static Account objAccount;    
    public static CuentaFacturacion__c objCtaFact;    
    public static Opportunity objOportunidad;    
    public static CatalogoProductos__c objProducto;
    public static TOPP__c objTOPP;
    public static TOPP__c objTOPP2;
    public static Planes__c objPlan;
    public static ActivoETB__c objServicioPadre;
    public static ActivoETB__c objServicioHijo1;       
    public static OperacionComercial__c objOCPadre;
    public static OperacionComercial__c objOCHija1;                                  
    
    public static void CreateData(){
     
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

      objCtaFact = new CuentaFacturacion__c();
      objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
      objCtaFact.Cliente__c = objAccount.Id;
      objCtaFact.Facturable__c = true;
      objCtaFact.LTE_MetodoEnvio__c = 'Email';
      objCtaFact.LTE_CicloFacturacion__c = '5';
      objCtaFact.LTE_Email__c = 'test@test.com';      
      objCtaFact.DirCorresp__c = 'Direccion test';      
      objCtaFact.LTE_CuentaFacturacionLTE__c = true;
      objCtaFact.Fue_creada_en_revchain__c = true;
      objCtaFact.DirCorresp__c = 'Test DirCorresp';
      insert objCtaFact;

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
      objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
      objTOPP.TipodeOperacionporplan__c = 'Venta';
      objTOPP.Tipoderegistro__c = 'Venta_LTE';
      objTOPP.DisponibleVentainicial__c = true;
      objTOPP.Facturable__c = true;
      objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP;
       
      objTOPP2 = new TOPP__c();
      objTOPP2.Name = 'Adición bolsa compartida- TELEFONIA MOVIL (LTE)';
      objTOPP2.TipodeOperacionporplan__c = 'Adición bolsa compartida';
      objTOPP2.Tipoderegistro__c = 'Adicion_bolsa_compartida';
      objTOPP2.DisponibleVentainicial__c = true;
      objTOPP2.Facturable__c = true;
      objTOPP2.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP2;
      
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
     
      objServicioPadre = new ActivoETB__c();
      objServicioPadre.Oportunidad__c = objOportunidad.Id;
      objServicioPadre.NombredelaCuenta__c = objAccount.Id;
      objServicioPadre.Plan__c = objPlan.Id;
      objServicioPadre.Estado__c = 'Activo';
      objServicioPadre.IMEI_del_Equipo__c = '980684862113805';
      objServicioPadre.LTE_ICCID__c = '8957187113000000506';
      objServicioPadre.NumeroConexion__c = '3057000501';
      objServicioPadre.Fecha_Activacion__c = system.now();
      objServicioPadre.Tipo_linea_bolsa_compartida__c = 'Padre';
      insert objServicioPadre;
       
      objOportunidad.Servicio_Bolsa_Compartida_Padre__c = objServicioPadre.Id;
      update objOportunidad;

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
      objOCPadre.Estado__c = 'Exitoso M6';      
      objOCPadre.FechadeActivacion__c = system.today();
      objOCPadre.NumeroConexion__c = '3057000501';
      objOCPadre.FechadeActivacion__c = system.today();      
      objOCPadre.Tipo_linea_bolsa_compartida__c = 'Padre';
      objOCPadre.SDP__c = '2';
      objOCPadre.IMEI_del_Equipo__c = '988844184859301';
      objOCPadre.LTE_ICCID__c = '8957187113000000498';
      objOCPadre.LTE_IMSI__c = '732187100000498';
      insert objOCPadre; 
        
      objOCHija1 = new OperacionComercial__c();
      objOCHija1.CuentaCliente__c = objAccount.Id;
      objOCHija1.Activo__c = objServicioHijo1.Id;
      objOCHija1.Plan__c = objPlan.Id;
      objOCHija1.TOPP__c = objTOPP.Id;
      objOCHija1.Oportunidad__c = objOportunidad.Id;
      objOCHija1.CuentaFacturacion__c = objCtaFact.Id;
      objOCHija1.Estado__c = 'Activa';    
	  objOCHija1.EstadoAprovisionamiento__c = 'COMPLETE';
      objOCHija1.FechadeActivacion__c = system.today();
      objOCHija1.NumeroConexion__c = '3057000501';
      objOCHija1.FechadeActivacion__c = system.today();     
      objOCHija1.Tipo_linea_bolsa_compartida__c = 'Hija';
      objOCHija1.SDP__c = '2';
      objOCHija1.IMEI_del_Equipo__c = '988844184859301';
      objOCHija1.LTE_ICCID__c = '8957187113000000498';
      objOCHija1.LTE_IMSI__c = '732187100000498';   
      objOCHija1.Operacion_Comercial_Relacionada__c = objOCPadre.Id;
      insert objOCHija1;
    }
    @isTest static void test_method_one()
    {       
       Test.startTest();                       
       CreateData();        
       objOCPadre.Estado__c = 'Facturado';  
       update objOCPadre;
       Test.stopTest(); 
    } 
    @isTest static void test_method_two()
    {       
       Test.startTest();                       
       CreateData();       
       objOCHija1.Estado__c = 'Activa';  
       update objOCHija1;
       Test.stopTest(); 
    }
}