/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
@isTest
public class DetalleClienteHelper_tst {
    
	public static Contact 		objContact;
    public static Account 		objAccount;
    public static Poblacion__c  objPoblacion;
    public static Contract 		objContract;
    public static Dato_Contacto_Cliente__c objDatoContactoCliente;
    public static CatalogoProductos__c objCatalogoProducto;
	public static Planes__c objPlan;
    public static OperacionComercial__c objOperacionComercial;
    public static ActivoETB__c objActivoETB;
    public static Opportunity objOportunity;
    public static TOPP__c objTopp;
    public static CuentaFacturacion__c objCuentaFacturacion;
    public static AnchodeBanda__c objAnchoBanda;
    public static Legalizacion__c objLegalizacion;

    public static void CreateData(){
        generarPoblacion();
        generarCuenta();  
        generarContacto();
		generarContrato();
        generarContratoCompetencia();
        generarDatoContactoCliente();
        generarCatalogoProducto();
        generarPlan();
        generarTopp();
        generarOpportunity();
        generarOportunidad();
        generarActivoETB();
        generarCuentaFacturacion();
        generarLegalizacion();
        generarAnchoBanda();
        generarOperacionComercial();
    }
    
    @isTest
    static void traerListaContratoETB_tst(){
        CreateData();
        Contract ctr = [SELECT Id, Modalidad_de_contratacion__c, Status  FROM Contract LIMIT 1];
        ctr.Status ='Activo';
        ctr.Modalidad_de_contratacion__c = 'Licitación pública';
        Id contratoId = ctr.Id;
        update ctr;
            
        test.startTest();
        list<Contract> lstContrato = DetalleClienteHelper.traerListaContratoETB(objAccount.Id);
        test.stopTest();

        System.assertEquals(contratoId, lstContrato[0].Id); 
    }
    @isTest
    static void traerListaContratoCompetencia_tst(){
 		CreateData();
        Contratos_Vigentes_Competencia__c cvc= [SELECT Id, Modalidad_de_contratacion__c  FROM Contratos_Vigentes_Competencia__c LIMIT 1];
        cvc.Modalidad_de_contratacion__c = 'Mínima cuantía';
        Id contratoId = cvc.Id;
        update cvc;
            
        test.startTest();
        list<Contratos_Vigentes_Competencia__c> lstContratoVigenteCompetencia = DetalleClienteHelper.traerListaContratoCompetencia(objAccount.Id);
        test.stopTest();

        System.assertEquals(contratoId, lstContratoVigenteCompetencia[0].Id); 
    }    
    @isTest
    static void traerListaOportunidades_tst(){
        CreateData();
        Opportunity opp= [SELECT Id, StageName  FROM Opportunity LIMIT 1];
        opp.StageName ='Análisis de necesidades';
		Id idOpp = opp.Id;
   		update opp;
            
        test.startTest();
        list<Opportunity> lstOportunidades = DetalleClienteHelper.traerListaOportunidades(objAccount.Id);
        list<Opportunity> lstOportunidades1 = DetalleClienteHelper.LstOportunidadesBanderaRoja(objAccount.Id);
        test.stopTest();

        System.assertEquals(idOpp,lstOportunidades[0].Id); 
    }  
    @isTest
    static void getTreeData_tst(){
         CreateData();
        Dato_Contacto_Cliente__c dcc=  [Select Id, Nombre_de_la_cuenta__c, Contacto_del_cliente__c from Dato_Contacto_Cliente__c ];
        dcc.Nombre_de_la_cuenta__c = objAccount.Id;
        dcc.Contacto_del_cliente__c = objContact.Id;
        update dcc;
            
        test.startTest();
        list<DetalleClienteHelper.datoContactoClientetWrapper> lstdatoContactoClientetWrapper = DetalleClienteHelper.getTreeData(objAccount.Id);
        test.stopTest();

        System.assertEquals(dcc.Id,lstdatoContactoClientetWrapper[0].Name); 
    }  
    @isTest    
    static void traerListaLineaNegocioXContrato_tst(){
         CreateData();
        Contract contrato = [SELECT Id, Status, Modalidad_de_contratacion__c FROM Contract LIMIT 1];
        contrato.Status = 'Activo';
        contrato.Modalidad_de_contratacion__c = 'Selección directa';
        update contrato;
        
        test.startTest();
        list<DetalleClienteHelper.LineaNegocio> ListaLineaNegocioXContrato = DetalleClienteHelper.traerListaLineaNegocioXContrato(objAccount.Id);
        test.stopTest();

        System.assertEquals('INTERNET', ListaLineaNegocioXContrato[0].LineaNegocio); 
    }
        @isTest    
    static void traerListaLineaNegocioXOportunidad_tst(){
         CreateData();
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        opp.StageName = 'Diseño de la solución';
      
        update opp;
        
        test.startTest();
        list<DetalleClienteHelper.LineaNegocio> ListaLineaNegocioXOportunidad = DetalleClienteHelper.traerListaLineaNegocioXOportunidad(objAccount.Id);
        test.stopTest();

        System.assertEquals('INTERNET', ListaLineaNegocioXOportunidad[0].LineaNegocio); 
    }
    
    public static Id generarCatalogoProducto(){
        objCatalogoProducto = new CatalogoProductos__c();
        objCatalogoProducto.Name = 'cattesteste';
        objCatalogoProducto.LineaNegocio__c = 'INTERNET';
        insert objCatalogoProducto;
        
        return objCatalogoProducto.Id;
    }
    
    public static Id generarPlan(){
        objPlan = new Planes__c();
        objPlan.Name = 'testplannplanaplan';
        objPlan.NombredelProducto__c = objCatalogoProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Estado__c = 'Activa';
        insert objPlan;
        
        return objPlan.Id;
    } 
    
    public static id generarTopp(){    
        objTopp = new TOPP__c();
        objTopp.Name = 'Venta- Plan Conectividad Avanzada IP';
        objTopp.TipodeOperacionporplan__c = 'Venta';
        objTopp.Tipoderegistro__c = 'C1';
        objTopp.Facturable__c = true;
        objTopp.LTE_Parte_caso__c = true;
        objTopp.LTE_Catalogo_de_Producto__c = objCatalogoProducto.id;
		objTopp.AplicaGerenteProyecto__c = true;    
        insert objTopp;
        return objTopp.Id;
    }
    
    public static Id generarOpportunity(){
        objOportunity = new Opportunity();
        objOportunity.AccountId = objAccount.Id;
        objOportunity.Name = 'Opportunity Test Case';
        objOportunity.CloseDate = System.today()+1;
        objOportunity.CausaldePerdida__c = 'Otro';
        objOportunity.ForecastCategoryName = 'Negociacion';
        objOportunity.StageName = 'En Estudio';
        objOportunity.OwnerId = Userinfo.getUserId();
        objOportunity.Tipo_de_Operacion__c = 'Modificacion';
        objOportunity.Amount = 1000000;
        objOportunity.Valor_unica_vez_ETB__c = 1;   
        objOportunity.PDC__c = '80% - Probabilidad de Éxito';
        objOportunity.Plan__r = objPlan;
        objOportunity.Plan__c = objPlan.Id;
        objOportunity.ANS__c = 10;
        objOportunity.Plan__r.Tipo_Operaci_n_por_Plan__r = objTopp;
        objOportunity.Plan__r.Tipo_Operaci_n_por_Plan__c = objTopp.Id;     
        insert objOportunity;    
        return objOportunity.Id;
    }
    
    public static Id generarOportunidad(){
        Opportunity objOportunidad = new Opportunity();
        objOportunidad.Name = 'TEB oportunidad';
        objOportunidad.AccountId = objAccount.Id;
        objOportunidad.Tipo_de_Operacion__c = 'Modificacion';
        objOportunidad.StageName ='Cerrada perdida';
        objOportunidad.CloseDate = system.today();
        objOportunidad.CausaldePerdida__c = 'Otro';
        objOportunidad.ForecastCategoryName = 'Negociacion';
        objOportunidad.Amount = 1000000;
        objOportunidad.Valor_unica_vez_ETB__c = 100000;
        objOportunidad.PDC__c = '80% - Probabilidad de Éxito';
        objOportunidad.Motivo_de_la_perdida__c = 'Viabilidad Negativa';
        insert objOportunidad;
        return objOportunidad.Id;
    }
    
    public static Id generarActivoETB(){
        objActivoETB = new ActivoETB__c();	
        objActivoETB.Oportunidad__c = objOportunity.Id;
        objActivoETB.Estado__c = 'Activo';  
        objActivoETB.NombredelProducto__c = objCatalogoProducto.Id;
        objActivoETB.NombredelaCuenta__c = objAccount.Id;
        insert objActivoETB;  
        
        return objActivoETB.Id;  
    }
    
    public static Id generarCuentaFacturacion(){  
        objCuentaFacturacion = new CuentaFacturacion__c();
        objCuentaFacturacion.Ciudad__c = objPoblacion.Id;
        objCuentaFacturacion.Cliente__c = objAccount.Id;
        objCuentaFacturacion.Estado__c='Activo';
        objCuentaFacturacion.DirCorresp__c = 'Test direccion';
        objCuentaFacturacion.LTE_CicloFacturacion__c = '97';
        insert objCuentaFacturacion;
        
        return objCuentaFacturacion.Id;
    }
    
    public static Id generarLegalizacion(){  
        objLegalizacion = new Legalizacion__c();
        objLegalizacion.Contrato__c = objContract.Id;
        objLegalizacion.Estado__c = Label.EntregaGestionProy_EstGestionado;
        objLegalizacion.AnalistaSoporteVentas__c=generarUsuarioSAV();
        objLegalizacion.Fecha_de_solicitud_cliente__c=system.today();
        insert objLegalizacion;
        
        return objLegalizacion.Id;
    }
    
    public static Id generarUsuarioSAV(){
        
        
        Profile pro = [select id from Profile where name='Soporte a Ventas' limit 1];
        system.debug('==>Entrada generarUsuario()');
        string userRandom=Math.random()*1000+'userEtb@etb.com';
        system.debug(userRandom);
        
        User u2 = new User(Alias = 'ETbUser', Email=userRandom, 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = pro.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName=userRandom);
        //us.EsAsesor__c = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert u2;
        }
        return u2.Id; 
    }
    
    public static Id generarAnchoBanda(){
        objAnchoBanda = new AnchodeBanda__c();
        objAnchoBanda.Name = 'testabtestanchobanda';
        objAnchoBanda.Numero__c = '1';
        objAnchoBanda.Descripcion__c = 'desc';
        objAnchoBanda.Unidaddemedida__c = 'kbps';
        insert objAnchoBanda;
        
        return objAnchoBanda.Id;
    }
    
    public static Id generarOperacionComercial(){
        objOperacionComercial = new OperacionComercial__c();
        objOperacionComercial.Estado__c = 'Pendiente';
        objOperacionComercial.FechadeActivacion__c=System.today();
        objOperacionComercial.Activo__c = objActivoETB.Id;
        objOperacionComercial.AnchoBanda__c = objAnchoBanda.Id;
        objOperacionComercial.Oportunidad__c = objOportunity.Id;
        objOperacionComercial.ContratoAliado__c = objContract.Id;
        objOperacionComercial.Legalizacion__c = objLegalizacion.Id;
        objOperacionComercial.TOPP__c = objTopp.Id;
        objOperacionComercial.Plan__c = objPlan.Id;
        objOperacionComercial.CuentaFacturacion__c = objCuentaFacturacion.Id;
        objOperacionComercial.CuentaCliente__c = objAccount.Id;
        objOperacionComercial.Comentarios__c = 'OC2';
        objOperacionComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('F22').getRecordTypeId();
        insert objOperacionComercial;
        
        return objOperacionComercial.Id;
    }
    
    public static Id generarContacto(){  
        objContact = new Contact(IsTEST__c = true);
        objContact.LastName = 'contactoconconconcontest';
        objContact.AccountId = objAccount.Id;
        objContact.Phone = '00000000';
        objContact.MobilePhone = '1234567890';
        objContact.Email = 'abc@gmail.com';
        objContact.Cargo__c = 'Presidente';
        objContact.Estado__c = 'Activo';
        insert objContact;    
        return objContact.Id;
    }
    
    public static Id generarCuenta(){
        objAccount = new Account();
        objAccount.Name = 'cuentacuentacuenta123';
        objAccount.Ciudad__c = objPoblacion.Id;
        objAccount.Type = 'Prospecto';
        objAccount.AccountNumber='240324';
        objAccount.Segmento__c='Empresas';
        objAccount.SubSegmento__c='Grandes';
        objAccount.Tipodedocumento__c='NIT';
        objAccount.Estado_Cuenta__c='Activo';
        objAccount.Phone='3133698521';
        insert objAccount;    
        return objAccount.Id;
    }
    
  	public static Id generarPoblacion(){
        objPoblacion = new Poblacion__c();
        objPoblacion.CodigoDane__c = '1100001';
        objPoblacion.EsMunicipio__c = true;
        objPoblacion.name = 'Bogotá';
        objPoblacion.Tipo_de_instalacion__c = 'Bogotá';
        insert objPoblacion;
        return objPoblacion.Id;
    }
 
    public static Id generarContrato(){
        objContract = new Contract();
        objContract.AccountId = objAccount.Id;
        objContract.Contacto__c = objContact.Id;
        objContract.Anexo__c = 'ACEPTACION DE OFERTA AL objContractATO PARA LA PRESTACION DE LOS SERVICIOS DE TELECOMUNICACIONES';
        objContract.Fecha_de_suscripcion__c = System.today();
        objContract.Fecha_de_inicio__c =   System.today();
        objContract.Fecha_de_terminacion__c =   System.today();
        objContract.Fecha_de_Venta__c = system.today();
        objContract.Tiempo_de_liquidacion__c = 3;
        objContract.Status = 'Ejecución';
        objContract.Valor_sin_IVA__c = 20000000;
        objContract.porcentaje_IVA__c = '19';
        objContract.Valor_adiciones__c = 1000000;
        objContract.Valor_adiciones_sin_iva__c = 1000000;
        objContract.Numero_de_adiciones__c = 2;
        objContract.Ejecutado__c = 200000;
        objContract.Valor_ejecutado_calculado_escritura__c = 200000;
        objContract.Facturado__c = 100000;
        objContract.Conciliado__c = 300000;
        objContract.Valor_mes__c = 50000;
        objContract.Valor_fijo_o_variable__c = 'Fijo';
        objContract.StartDate = System.today();     
		objContract.Param_Anexo_IVA__c = '19';
        objContract.Param_Anexo_Reteica__c = 0.00966;
        objContract.Param_Anexo_Retefuente__c = 4;	
        insert objContract;    
        return objContract.Id;
  	}
    
    Public static Id generarContratoCompetencia(){
        Contratos_Vigentes_Competencia__c objContratoVigenteCompetencia = new Contratos_Vigentes_Competencia__c();
         objContratoVigenteCompetencia.Account__c = objAccount.Id;
        objContratoVigenteCompetencia.Proveedor__c ='ETB';
        objContratoVigenteCompetencia.Productos_y_servicios__c ='miPymes';
        objContratoVigenteCompetencia.Fecha_Inicio_contrato__c =System.today();
        objContratoVigenteCompetencia.Fecha_final_contrato__c =System.today();
        objContratoVigenteCompetencia.Valor__c =1000000;
        insert objContratoVigenteCompetencia;    
        return objContratoVigenteCompetencia.Id;
    }
    
    Public static Id generarDatoContactoCliente(){
        Dato_Contacto_Cliente__c objDatoContactoCliente = new Dato_Contacto_Cliente__c();
        objDatoContactoCliente.Nombre_empleado_ETB__c = 'Erik';
        objDatoContactoCliente.Cargo_empleado_ETB__c = 'Gerente';
        objDatoContactoCliente.Contacto_del_cliente__c = objContact.Id;
        objDatoContactoCliente.Nombre_de_la_cuenta__c = objAccount.Id;
        insert objDatoContactoCliente;
        return objDatoContactoCliente.Id;
    }

    @isTest    
    static void ObtenerPotencialIngresosOperacionales_tst(){
        CreateData();
        List<Account> acc = [SELECT Id, Name FROM Account LIMIT 1];  

        test.startTest();
        DetalleClienteHelper.ObtenerPotencialIngresosOperacionales(acc[0].Id);
        test.stopTest();      
        
    }
}