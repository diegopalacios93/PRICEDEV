public with sharing class LTE_AdicionBolsaCompartida_ctr {
	
	private Apexpages.Standardcontroller stdController;    
    public infoLupas iLupas										{get; set;}
    public Boolean blnBuscar		 							{get; set;}
    public Boolean blnBotonRegresar	 							{get; set;}
    public Boolean blnBloqueServicios 							{get; set;}
    public Boolean blnBotonGuardar								{get; set;}
    public Boolean blnBotonCerrar								{get; set;}
    public Boolean blnAllChecked								{get; set;}    
    public String numerosConexion	 							{get; set;}
    public String numeroCaso									{get; set;}
    public String strNivelId                                    {get; set;}
    public String strNivel                                      {get; set;}
    public String strInfoParam	                                {get; set;}
    public Integer intCantidadReg								{get; set;}
	private Map<Id, Planes__c> mpValoresPlanes                  {get; set;}
	private Map<Id, SubPlanFacturacion__c> mpValoresSubPlanes   {get; set;}   
	private Map<Id, LTE_DetalleOferta__c> mpDetalleOferta; 
	private List<PlanFacturacion__c> lstPlanFacturacion			{get; set;}
    private Map<string, LTE_SVA__c> mapSVA;
    private List<String> lstTipoSubPlan;
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
        
    
    /** Variables para paginacion */
	public ApexPages.StandardSetController con					{get;set;}
    public List<LTE_ActivoETB_Wrapper> lstActivosWrapper		{get;set;}
    public Boolean blnHayDatos			 						{get;set;}
    public Boolean blnmostrarPrimero							{get;set;}
    public Boolean blnmostrarUltimo			 					{get;set;}
    
    Set<Id> selectedRecordIds;
    public List<ActivoETB__c> lstActivos;
    Integer numeroRegistros;
    /***************************/
    
    private Map<string,VariablesGlobales__c> vGlobal;
    
    /**
    * Constructor del controlador
    */
    public LTE_AdicionBolsaCompartida_ctr(ApexPages.StandardController stdController){
        iLupas = new infoLupas();
    	this.stdController = stdController;
    	this.blnBuscar = true;
    	this.blnBotonRegresar = false;
    	this.blnBloqueServicios = false;
    	this.blnBotonGuardar = false;
    	this.blnBotonCerrar = false;
    	this.blnAllChecked = false;    	
    	this.numerosConexion = '';
    	this.strNivelId = '';
        this.strNivel = '';
    	this.intCantidadReg = 0;
    	this.idCase = ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact = ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
    	this.vGlobal = VariablesGlobales__c.getAll();
    	this.mapSVA = LTE_SVA__c.getAll();
    	
    	this.numeroRegistros = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
    	this.lstActivosWrapper = new List<LTE_ActivoETB_Wrapper>();
    	this.blnHayDatos = false;
    	this.blnmostrarPrimero = false;
    	this.blnmostrarUltimo = false;
    	this.lstActivos = new List<ActivoETB__c>();
    	this.con = new ApexPages.StandardSetController(lstActivos);
	    this.selectedRecordIds = new Set<Id>();
    	
    	if(this.idCase == null){
    		System.debug('=======> El parametro LTEAdicionSVA_BolsaRecurrente.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.idAccount == null){
    		System.debug('=======> El parametro LTEAdicionSVA_BolsaRecurrente.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
    		System.debug('=======> El parametro LTEAdicionSVA_BolsaRecurrente.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	List<Contact> lstContactos = new  List<Contact>();
    	lstContactos = [SELECT Id, LTE_RolLTE__c FROM Contact WHERE Id = :this.idContact];
    	System.debug('=======> ' + lstContactos);
    	if(lstContactos.isEmpty()){
    		System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
    		parametroInvalido(Label.LTE_Caso_Sin_Contacto);

    	}    	
    	if(!validaRolBolsaCompartida(lstContactos.get(0).LTE_RolLTE__c)){
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTEBolsasCompartidas').valor__c+' en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
		
		lstTipoSubPlan = new List<String>();
		for(LTE_SVA__c sva : mapSVA.values()){
			if(sva.LTE_Familia__c == 'Bolsa Recurrente'){
				lstTipoSubPlan.add(sva.Name);
			}
		}		
		mpValoresPlanes = new map<Id, Planes__c>([SELECT Id,Tarifa__c,Name,LTE_PlanEstructurados__c,LTE_TipoControl__c,TipodePlan__c FROM Planes__c WHERE Estado__c = 'Activo']);
		mpValoresSubPlanes = new map<Id, SubPlanFacturacion__c>([SELECT Id, LTE_Precio__c, Name FROM SubPlanFacturacion__c ]);
		lstPlanFacturacion = [SELECT Id, Name, Plan__c FROM PlanFacturacion__c];
	}
    public class infoLupas{        
        public string servicioPadre		{get;set;}
        public string servicioPadreId	{get;set;}          
    } 
    public class wrapperOCxDO{
		public OperacionComercial__c objWOC;
    	public LTE_DetalleOferta__c objWDO;
	}
	public class wrapperOCxOC{
		public OperacionComercial__c objWOCA;
    	public OperacionComercial__c objWOCC;
	}
    public string getServicioPadreInfo(){	                
        Schema.DescribeSObjectResult r = ActivoETB__c.sObjectType.getDescribe();
        return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where NombredelaCuenta__c =\''+this.idAccount+'\' AND Estado__c = \'Activo\' AND Tipo_linea_bolsa_compartida__c = \'Padre\'')+'&f='+filtro_cls.codificar(',Name,NombredelProducto__r.Name,Plan__r.Name,Estado__c,IDservicio__c,NumeroConexion__c,NombredelaCuenta__r.Name')+'&infoParam=ActivoETB&nom='+filtro_cls.codificar('Servicio ETB,Nombre del Producto,Plan,Estado,ID servicio,Número de conexión,Nombre de la cuenta');
	}
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en la configuracion personalizada.
    */
    public Boolean validaRolBolsaCompartida(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
   		
   		rolesLTE = vGlobal.get('RolLTEBolsasCompartidas').valor__c;
   		rolesLTESeparados = rolesLTE.split(',');
   		lstRolesLTE = new list<String>(rolesLTESeparados);
   		
   		for(String rol : lstRolesLTE){
   			if(rolContacto.trim() == rol.trim()){
   				return true;
   			}
   		}    	
    	return false;
    }    
    
    /**
    * Metodo ecargado de buscar los servicios asociados a los numeros de conexion digitados.
    */
    public PageReference buscar()
   	{
   		String[] numerosConexionSeparados;
   		
   		if(numerosConexion == null || numerosConexion.trim().length() == 0 ){
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Digitar_Numero_Conexion));
   			return null;
   		}
   		
   		this.blnBloqueServicios = true;
   		
   		//Se eliminan los espacios de la cadena
   		numerosConexion = numerosConexion.deleteWhiteSpace();
   		numerosConexionSeparados = numerosConexion.split(',');
   		Set<String> setNumerosConexion = new Set<String>(numerosConexionSeparados);
   		
    	String producto = vGlobal.get('NombreComercialLTE').valor__c;
   		
   		if(this.con == null) {
   			this.con = new ApexPages.StandardSetController(lstActivos);
   		}
   		
   		this.lstActivos = [SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,LTE_DetalleOferta__c,
   			NumeroConexion__c,Plan__r.NombredelProducto__r.Name, Plan__r.TipodePlan__c, Contrato__c, Plan__r.LTE_MetodoDePago__c, Plan__r.Name,
   			Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, IMEI_del_Equipo__c, LTE_ICCID__c,
   			(SELECT name,Estado__c,TOPP__r.TipodeOperacionporplan__c, Categoria__c  FROM Operaciones_Comerciales__r WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento'))
   			//(SELECT Id, Name FROM Servicios_adicionales__r WHERE LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c IN :lstTipoSubPlan AND LTE_ServiceActionCode__c NOT IN ('ELIMINADO', 'DELETE'))
   		FROM ActivoETB__c 
   		WHERE NombredelaCuenta__c = :this.idAccount and Plan__r.NombredelProducto__r.Name = :producto AND Plan__r.TipodePlan__c != 'Troncal SIP' AND NumeroConexion__c IN :numerosConexionSeparados AND Estado__c = 'Activo' AND Plan__r.LTE_MetodoDePago__c != 'PREPAGO' AND (Tipo_linea_bolsa_compartida__c != 'Padre' AND Tipo_linea_bolsa_compartida__c != 'Hija') Order By Name /*limit 100*/];
   		
   		if(this.lstActivos.isEmpty()){
   			this.intCantidadReg = 0;
	    	this.blnmostrarPrimero = false;
	    	this.blnmostrarUltimo = false;
	    	this.blnBloqueServicios = false;
	    	this.blnBotonGuardar = false;
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
   		} else{
   			this.intCantidadReg = lstActivos.size();
	    	this.blnmostrarPrimero = true;
	    	this.blnBloqueServicios = true;
	    	this.blnBotonGuardar = true;
	    	if(this.lstActivos.size() > numeroRegistros){
	    		this.blnmostrarUltimo = true;
	    	} else{
	    		this.blnmostrarUltimo = false;
	    	}
   		}
   		
   		this.con = new ApexPages.StandardSetController(this.lstActivos);
        this.con.setPageSize(numeroRegistros);
        obtenerActivosLTE();
   		
		return null;
    }    
    
    /**
    * Metodo encargado de generar y almacenar todos los datos para procesar la 
    * transaccion de cambio de plan.
    */
    public PageReference guardar(){
		List<TOPP__c> lstTOPP = new List<TOPP__c>();
        //List<TOPP__c> lstTOPPRetiro = new List<TOPP__c>();
		List<TOPP__c> lstTOPPCambio = new List<TOPP__c>();
		List<RecordType> lstRecordType = new list<RecordType>();
		List<Equipo__c> lstEquipos = new List<Equipo__c>();
        //List<RecordType> lstRecordTypeRetiro = new list<RecordType>();
		List<RecordType> lstRecordTypeCambio = new list<RecordType>();
		List<WrapperOCxDO> lstWrapperOCxDO = new List<WrapperOCxDO>();
		List<WrapperOCxOC> lstWrapperOCxOC = new List<WrapperOCxOC>();
		List<ActivoETB__c> lstActivosSeleccionados = new List<ActivoETB__c>();
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();		
		List<LTE_DetalleOferta__c> lstDO = new List<LTE_DetalleOferta__c>();
        //List<OperacionComercial__c> lstOCRetiro = new List<OperacionComercial__c>();
		List<OperacionComercial__c> lstOCCambioPlan = new List<OperacionComercial__c>();
        List<OperacionComercial__c> lstOCUpdate = new List<OperacionComercial__c>();
		List<LTE_Servicios_adicionales__c> lstSA = new List<LTE_Servicios_adicionales__c>();
		set<Id> setIdOcs = new set<Id>();
		Set<Id> setIdPlanes = new set<Id>();
		OperacionComercial__c objOC;
		OperacionComercial__c oc;
		WrapperOCxDO objWrapperOCxDO;
		WrapperOCxOC objWrapperOCxOC;
		LTE_Servicios_adicionales__c objSAPlan;
		LTE_Servicios_adicionales__c objSADatos;	
		Reserva__c  objRes;
		Planes__c objPlanTmp = null;
		LTE_DetalleOferta__c doo;
        //OperacionComercial__c objOCRetiro;
		OperacionComercial__c objOCCambio;
        Planes__c objPlan = [Select Id from Planes__c Where Name =:Label.Param_BolsaCompartida_PlanDefault Limit 1];
		LTE_Servicios_adicionales__c objSAVoz;
		//LTE_Servicios_adicionales__c objSADatos;
		Integer intCicloFacturacion;
		Decimal dcmValorPlanes = 0;
        Decimal dcmValorSubPlanes = 0;
        Decimal dcmValorTotal = 0;
		Date fechaCorte;
		
		

		Savepoint sp = Database.setSavepoint();
		
			
        if(iLupas.servicioPadreId == ''){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'El campo "Activo (AC) padre" es requerido.' ));
            return null;
        }  		
		verificarSeleccionados();
		
		if(selectedRecordIds.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe seleccionar al menos un servicio para realizar la adición a la bolsa compartida.'));
			return null;
		}
		
		lstTOPP 			= [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Id = :this.idTOPP];
        //lstTOPPRetiro		= [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Name =: Label.ToppRetiroLTE];
		lstTOPPCambio		= [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Name =: Label.ToppCambioLTE];
		lstRecordType 		= [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
        //lstRecordTypeRetiro = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPPRetiro.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
		lstRecordTypeCambio = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPPCambio.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            
        if(lstRecordType.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
			return null;
		}            
		
		lstActivosSeleccionados = obtenerActivosSeleccionados();
		
		try{

		Set<Id> idsDetalleOferta = new Set<Id>();
	
   		for(ActivoETB__c activoSeleccionado : lstActivosSeleccionados){
   			idsDetalleOferta.add(activoSeleccionado.LTE_DetalleOferta__c);
   		}
			mpDetalleOferta = new Map<Id, LTE_DetalleOferta__c>([SELECT Id, LTE_DatosNavegacion__c, LTE_DescuentoDatos__c, LTE_DescuentoPlan__c, LTE_DescuentoVoz__c, LTE_Estado__c, LTE_MinutoVoz__c, LTE_Valor_Total_Plan__c, Plan__c, Plan__r.Name, Plan__r.LTE_TipoControl__c FROM LTE_DetalleOferta__c WHERE Id IN :idsDetalleOferta]);

			for(ActivoETB__c objActivo : lstActivosSeleccionados){
				try{
					intCicloFacturacion = Integer.valueOf(objActivo.CuentaFacturacion__r.LTE_CicloFacturacion__c);
				} catch(Exception e){
					intCicloFacturacion = -1;
					System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
					e.setMessage(Label.LTE_Servicio_Sin_Cuenta_Facturacion);
					throw e;
				}
				
				fechaCorte = obtenerFechaCorte(intCicloFacturacion);				
				if(fechaCorte == null){
					Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Fecha_Corte_No_Calculada));
					return null;
				}			
				objOC = new OperacionComercial__c();
				objWrapperOCxOC = new WrapperOCxOC();
	    		objOC.CuentaCliente__c 					= this.idAccount;
	    		objOC.Activo__c 						= objActivo.Id;
	    		objOC.NumeroConexion__c 				= objActivo.NumeroConexion__c;   		
	    		objOC.Plan__c 							= objPlan.Id;
	    		objOC.TOPP__c 							= this.idTOPP;	    		
	    		objOC.Estado__c 						= 'En Curso';
	    		objOC.RecordTypeId 						= lstRecordType.get(0).Id;
	    		objOC.Caso__c 							= this.idCase;	    		
	    		objOC.CuentaFacturacion__c  			= objActivo.CuentaFacturacion__c;
	    		objOC.FechaInicioReconexion__c  		= fechaCorte;
                objOC.FechaSolicitud__c					= date.today();
                objOC.Activo_Relacionado__c  			= iLupas.servicioPadreId;
                objOC.IMEI_del_Equipo__c				= objActivo.IMEI_del_Equipo__c;
                objOC.LTE_ICCID__c						= objActivo.LTE_ICCID__c;  
                objOC.PlanAnterior__c					= objActivo.Plan__r.Name;
	    		objOC.Tipo_linea_bolsa_compartida__c	= 'Hija';
				objWrapperOCxOC.objWOCA = objOC;
                //Crear OC retiro
				/*
                objOCRetiro = new OperacionComercial__c();
	    		objOCRetiro.CuentaCliente__c 					= this.idAccount;
	    		objOCRetiro.Activo__c 							= objActivo.Id;
	    		objOCRetiro.NumeroConexion__c 					= objActivo.NumeroConexion__c;   		
	    		objOCRetiro.Plan__c 							= objActivo.Plan__c;
	    		objOCRetiro.TOPP__c 							= lstTOPPRetiro[0].Id;	    		
	    		objOCRetiro.Estado__c 							= 'Pendiente';
	    		objOCRetiro.RecordTypeId 						= lstRecordTypeRetiro.get(0).Id;
	    		objOCRetiro.Caso__c 							= this.idCase;	    		
	    		objOCRetiro.CuentaFacturacion__c  				= objActivo.CuentaFacturacion__c;	    		
                objOCRetiro.FechaRetiro__c						= fechaCorte;
                objOCRetiro.FechadeActivacion__c				= fechaCorte;
                objOCRetiro.FechaSolicitud__c					= date.today();
                objOCRetiro.CausalRetiro__c						= 'Cambio de Producto o Plan';
	    		lstOCRetiro.add(objOCRetiro);
				*/

				// Crear actuailización de plan

				lstEquipos = [SELECT Id FROM Equipo__c WHERE name = 'Equipo Traido'];
			
				if(lstEquipos.isEmpty()){
					Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontró el equipo'));
					return null;
				}
				
				objRes = new Reserva__c();
				objRes.Equipo__c = lstEquipos.get(0).id;
				insert objRes;

				doo = new LTE_DetalleOferta__c();
				doo.LTE_Oferta_Economica__c = objRes.Id;
				doo.LTE_Cliente__c = this.idAccount;
				doo.LTE_NumeroLinea__c = objActivo.NumeroConexion__c;
				doo.LTE_EquipoTraido__c = true;	
				doo.Plan__c = objPlan.Id;
				dcmValorPlanes = 0;
	    		dcmValorSubPlanes = 0;
	    		dcmValorTotal = 0;
	    		System.debug('map--->'+mpValoresPlanes);
	    		dcmValorPlanes = mpValoresPlanes.get(objActivo.Plan__c).Tarifa__c;
	        	//Suma el valor de las bolsas
	            if(mpDetalleOferta.get(objActivo.LTE_DetalleOferta__c).LTE_MinutoVoz__c != null)
	            {
	                dcmValorSubPlanes += (mpValoresSubPlanes.get(mpDetalleOferta.get(objActivo.LTE_DetalleOferta__c).LTE_MinutoVoz__c).LTE_Precio__c);
	            }
	            if(mpDetalleOferta.get(objActivo.LTE_DetalleOferta__c).LTE_DatosNavegacion__c != null)
	            {
	                dcmValorSubPlanes += (mpValoresSubPlanes.get(mpDetalleOferta.get(objActivo.LTE_DetalleOferta__c).LTE_DatosNavegacion__c).LTE_Precio__c);    
	            }
	    		dcmValorTotal = dcmValorPlanes + dcmValorSubPlanes;

				objWrapperOCxDO = new WrapperOCxDO();
				oc = new OperacionComercial__c	();
	    		oc.CuentaCliente__c = this.idAccount;
	    		oc.Activo__c = objActivo.Id;
	    		oc.NumeroConexion__c = objActivo.NumeroConexion__c; //LRPA 06-01-2016	    		
	    		oc.Plan__c = objPlan.Id;
	    		oc.TOPP__c = lstTOPPCambio[0].Id;
	    		oc.PlanAnterior__c = objActivo.Plan__r.Name;
	    		oc.Estado__c = 'Pendiente';
	    		//oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Cambio de Plan LTE').getRecordTypeId();
	    		oc.RecordTypeId = lstRecordTypeCambio[0].Id;
	    		oc.Caso__c = this.idCase;
	    		oc.Valor_Recurrente_ETB_Anterior__c = mpDetalleOferta.get(objActivo.LTE_DetalleOferta__c).LTE_Valor_Total_Plan__c;
	    		oc.ValorTarifaPlan__c = dcmValorTotal;
				oc.CuentaFacturacion__c =objActivo.CuentaFacturacion__c;
				oc.CuentaFacturacion__r =objActivo.CuentaFacturacion__r;
				doo.LTE_Valor_Total_Plan__c = dcmValorTotal;
				setIdPlanes.add(objPlan.Id);
				setIdPlanes.add(objActivo.Plan__c);
				objWrapperOCxDO.objWOC = oc;
				objWrapperOCxDO.objWDO = doo;
				objWrapperOCxOC.objWOCC = oc;
				lstWrapperOCxOC.add(objWrapperOCxOC);
				lstOCCambioPlan.add(oc);
				lstWrapperOCxDO.add(objWrapperOCxDO);
			}			
			//insert lstOC;
            //insert lstOCRetiro;
			insert lstOCCambioPlan;

			for (wrapperOCxOC objW : lstWrapperOCxOC){
				objW.objWOCA.Operacion_Comercial_Relacionada__c = objW.objWOCC.Id;
				lstOC.add(objW.objWOCA);
			}
			insert lstOC;
			for(WrapperOCxDO objW : lstWrapperOCxDO){
	    		objW.objWDO.LTE_OperacionComercial__c = objW.objWOC.Id;
	    		lstDO.add(objW.objWDO);
	    	}
			insert lstDO;
            
			Map<Id, Planes__c> mapPlanes = new Map<Id, Planes__c>([SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id IN :setIdPlanes]);

			lstDO = getLstDetalleOferta(lstDO);

			System.debug(lstDO+'---- lista');
			for(LTE_DetalleOferta__c objDetalleOferta : lstDO){
	    		objSAPlan = new LTE_Servicios_adicionales__c();
	    		objSAPlan.Name = mpValoresPlanes.get(objDetalleOferta.Plan__c).Name;
	    		objSAPlan.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
	    		objSAPlan.LTE_PlanFacturacion__c = obtenerPlanFacturacionId(objDetalleOferta.Plan__c);
	    		objSAPlan.LTE_NivelDescuento__c = objDetalleOferta.LTE_DescuentoPlan__c;
	    		lstSA.add(objSAPlan);
                
                /* BEGIN - Manuel Medina - Se ajusta la referencia a consultar en el mapa debido a que se estaba consultando el id no almacenado - 11082016 */
                //[MC] Se consulta la información del plan seleccionado
                //objPlanTmp = mapPlanes.get(Id.valueOf(objCambioPlan.detalleOferta_old.Plan__c));
                objPlanTmp = mapPlanes.get(Id.valueOf(doo.Plan__c));
                /* END - Manuel Medina - Se ajusta la referencia a consultar en el mapa debido a que se estaba consultando el id no almacenado - 11082016 */
                
	    		if(objDetalleOferta.Plan__c != null && objPlanTmp.LTE_Es_Plan_Compuesto__c){
	    			//Plan a la medida
	    			if(!String.isEmpty(objDetalleOferta.LTE_MinutoVoz__c)){
	    				objSAVoz = new LTE_Servicios_adicionales__c();
	    				objSAVoz.Name = mpValoresSubPlanes.get(objDetalleOferta.LTE_MinutoVoz__c).Name;
	    				objSAVoz.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
	    				objSAVoz.LTE_SubPlaFacturacion__c = objDetalleOferta.LTE_MinutoVoz__c;
	    				objSAVoz.LTE_NivelDescuento__c = objDetalleOferta.LTE_DescuentoVoz__c;
	    				lstSA.add(objSAVoz);
	    			}
	    			
	    			if(!String.isEmpty(objDetalleOferta.LTE_DatosNavegacion__c)){
	    				objSADatos = new LTE_Servicios_adicionales__c();
	    				objSADatos.Name = mpValoresSubPlanes.get(objDetalleOferta.LTE_DatosNavegacion__c).Name;
	    				objSADatos.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
	    				objSADatos.LTE_SubPlaFacturacion__c = objDetalleOferta.LTE_DatosNavegacion__c;
	    				objSADatos.LTE_NivelDescuento__c = objDetalleOferta.LTE_DescuentoDatos__c;
	    				lstSA.add(objSADatos);
	    			}
	    		} 
	    	}

			if(!lstSA.isEmpty()){
	    		insert lstSA;
	    	} else{
	    		//Mensaje error diciendo que no se pudo crear ningun servicio adicional para los planes seleccionados
	    		Database.rollback(sp);
	    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_No_Creo_SA));
	    		System.debug('======> No se pudo crear ningún servicio adicional para los planes seleccionados.');
	    		return null;
	    	}
            // relacionar operaciones comerciales
            /*for(OperacionComercial__c objAuxOCAdicion : lstOC){
                for(OperacionComercial__c objAuxOCRetiro : lstOCRetiro){
                    if(objAuxOCAdicion.NumeroConexion__c == objAuxOCRetiro.NumeroConexion__c){
                        objAuxOCAdicion.Operacion_Comercial_Relacionada__c = objAuxOCRetiro.Id;
                        lstOCUpdate.add(objAuxOCAdicion);
                        break;
                    }
            	}
            } */           
            if(!Test.isRunningTest()){
            	if(lstOCUpdate.size() > 0)
            		update lstOCUpdate;
            }
            
            Case caso = new Case(Id = this.idCase);
	    	caso.Aprobaciones__c = 'Oferta Realizada';
	    	update caso;	    	
	    	

			
		} catch(Exception e){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
    		Database.rollback(sp);
    		System.Debug('====================== EXCEPCION ======================');
    		System.debug( e.getMessage() + ' ' + e.getStackTraceString());
    		System.Debug('=======================================================');
    		return null;
    	}    
        LTE_AprobacionCasos_cls clasOper = new LTE_AprobacionCasos_cls();
			LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
			map<String, date>  mapIdOpComXFechaCorte= null;
			set<Id> setIdOcss = new set<Id>();

			
			// Obtener la fecha de corde para cada Oc
			mapIdOpComXFechaCorte = clasOper.calcularFechaCorteOpCom(lstOCCambioPlan);
			
			for(OperacionComercial__c ocs:lstOCCambioPlan){			
				if(mapIdOpComXFechaCorte.get(ocs.id) != null){ 					// si pudo calcular una fehca de corte para la OCs
					ocs.FechaInicioReconexion__c = mapIdOpComXFechaCorte.get(ocs.id); // Asignar fecha de corte
					ocs.Estado__c			= 'En curso'; 						// Poner Ocs's en estado En Curso
					setIdOcss.add(ocs.id);
				}			
			}
			
			try{
				
				// Actualizar lista Oc's con fecha de corte y estado En curso
				update lstOCCambioPlan;			
				
				// Parametrizar Servicios adicionales y  generar XA's
				LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcss,'OC');
				
				// Actualizar servicios adicionales
				update wrData.servAD; 	
				//system.debug('##wrData.servAD-->'+wrData.servAD.get(0));
				
				// Insertar XA's
				insert wrData.SpgXA;
	//			system.debug('##wrData.SpgXA-->'+wrData.SpgXA.get(0));    			
			}catch(exception e){
				system.debug('##Se hizo rollback-->');   
				system.debug(e.getMessage());
				Database.rollback( sp ); // Rollback en caso de error
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Mensaje_Error_Aprovisionamiento+'-->'+e.getMessage()));
				return null;
			}

			// Lanzar proceso de aprovisionamiento
			set<ID> setidOperacionComercial = new set<ID>();
			for(OperacionComercial__c ocCC:lstOCCambioPlan){
				setidOperacionComercial.add(ocCC.id);
			} 
			
			if(setidOperacionComercial.size()>0){ 
				LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
				batchA.idImediato=setidOperacionComercial;
				if( !Test.isRunningTest() )
				{
					//ID batchprocessid = Database.executeBatch(batchA, 1);	
					Case casoC = new Case(Id = this.idCase);
					casoC.Aprobaciones__c = 'Enviado aprovisionamiento';
					update casoC;
				}
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.Mensaje_Aprovisionamiento_Exitoso));		
			}
        this.blnBotonCerrar = true;
		this.blnBotonGuardar = false;
		return null;	
    }
    
    /**
    * Metodo encargado de regresar a la pagina de seleccion de tramines para el
    * proceso de cambio de plan.
    */
    public PageReference regresar(){
		PageReference returnPage = Page.LTE_SeleccionTramiteCambioPlan_pag;
		returnPage.getParameters().put('scontrolCaching', '1');
		returnPage.getParameters().put('id', this.idCase);
		returnPage.setRedirect(true);
		return returnPage;    	
    }
    public list<LTE_DetalleOferta__c> getLstDetalleOferta(list<LTE_DetalleOferta__c>  lstDO)  {
		list<LTE_DetalleOferta__c> lstDetOferta;
		set<String> setIdDetalleOferta = new  set<String>();
		for(LTE_DetalleOferta__c objDO:  lstDO){
			setIdDetalleOferta.add(objDO.id);
		}
		lstDetOferta = [select id,LTE_DescuentoPlan__c,LTE_OperacionComercial__r.Activo__c,
							   Plan__c,LTE_MinutoVoz__c,LTE_DescuentoVoz__c,LTE_DatosNavegacion__c, LTE_DescuentoDatos__c
							   from LTE_DetalleOferta__c where id in:setIdDetalleOferta];
		System.debug(lstDetOferta+ '<---lista detalle');
		return lstDetOferta;
	}
    /**
    * Metodo encargado de no mostrar y ocultar los botones necesario en caso
    *  que halla uno parametro nulo, adicionalmente muestra un mensaje indicando
    *  que ocurrio un error.
    */
    private void parametroInvalido(String mensaje){
    	this.blnBotonRegresar = true;
		this.blnBuscar = false;
    	this.blnBloqueServicios = false;
		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, mensaje));
    }    
	
	private Id obtenerPlanFacturacionId(Id planId){
    	if(!lstPlanFacturacion.isEmpty()){
    		for(PlanFacturacion__c objPlanFacturacion : lstPlanFacturacion){
    			if(objPlanFacturacion.Plan__c == planId){
    				return objPlanFacturacion.Id;
    			}
    		}
    		return null;
    	} else{
    		return null;
    	}
    }
    public PageReference seleccionarTodos(){
    	if(this.blnAllChecked){
	    	for (LTE_ActivoETB_Wrapper aw : lstActivosWrapper) {
	    		if(!aw.desactivado){
	    			aw.checked = true;
	    		}
	    	}
    	} else{
    		for (LTE_ActivoETB_Wrapper aw : lstActivosWrapper) {
	    		aw.checked = false;
	    	}
    	}
    	verificarSeleccionados();
    	return null;
    }
    
    /**
    * Metodo encargado de obtener los activos que fueron seleccionados.
    */
    public List<ActivoETB__c> obtenerActivosSeleccionados(){
    	List<ActivoETB__c> lstActivosSeleccionados = new List<ActivoETB__c>();
    	for(Id idActivo : selectedRecordIds){
    		for(ActivoETB__c ac : this.lstActivos){
    			if(ac.Id == idActivo){
    				lstActivosSeleccionados.add(ac);
    			}
    		}
    	}
    	return lstActivosSeleccionados;
    }    
    
    /**
    * Metodo encargado de calcular la fecha de corte a partir del ciclo de facturacion.
    */
    public Date obtenerFechaCorte(Integer intCicloFacturacion){
    	Date fechaCorteFinal;
    	Date fechaCorteInicial;
    	Date fechaHoy = system.today();
    	if(intCicloFacturacion == -1){
    		return null;
    	} else{
			if(intCicloFacturacion != null){
				fechaCorteFinal=null;
				
				// Fecha de corte incial
				Integer aniocorteInicial 	= 	fechaHoy.year();
				Integer mesCorteInicial 	= 	fechaHoy.month();
				Integer diaCorteInicial 	= 	intCicloFacturacion;				
				fechaCorteInicial 			= 	Date.newInstance(aniocorteInicial, mesCorteInicial, diaCorteInicial);
				
				if(fechaHoy  < fechaCorteInicial){
					fechaCorteFinal= fechaCorteInicial;
				}else{
					fechaCorteFinal = fechaCorteInicial.addMonths(1);
				}
			}else{
				fechaCorteFinal=null;
			}
			
			return fechaCorteFinal;
    	}
    }
    
    /***********************************************************************************
    							METODOS PARA LA PAGINACION
    ************************************************************************************/
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<LTE_ActivoETB_Wrapper> obtenerActivosLTE() {
        lstActivosWrapper = new List<LTE_ActivoETB_Wrapper>();
        LTE_ActivoETB_Wrapper activoWrapper;
        Integer noSeleccionados = 0;
        
        for (ActivoETB__c activo : (List<ActivoETB__c>)con.getRecords()){
            if(selectedRecordIds.contains(activo.Id)){
            	activoWrapper = new LTE_ActivoETB_Wrapper(activo, true);
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.Categoria__c == 'Bolsa Recurrente'){
            			activoWrapper.desactivar();
            		}
            	}
            	
            	lstActivosWrapper.add(activoWrapper);
            }
            else{
            	activoWrapper = new LTE_ActivoETB_Wrapper(activo);
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.Categoria__c == 'Bolsa Recurrente'){
            			activoWrapper.desactivar();
            		}
            	}
            	
            	lstActivosWrapper.add(activoWrapper);
            	noSeleccionados++;
            }
        }
        
        if(noSeleccionados > 0){
        	this.blnAllChecked = false;
        } else{
        	this.blnAllChecked = true;
        }

        return lstActivosWrapper;
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
        	if(con.getHasNext())
        		this.blnmostrarUltimo = true;
        	else
        		this.blnmostrarUltimo = false;
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
        	if(con.getHasPrevious())
        		this.blnmostrarPrimero = true;
        	else
        		this.blnmostrarPrimero = false;
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
     	verificarSeleccionados();
         con.first();
         obtenerActivosLTE();
     }

     // returns the last page of records
     public void last() {
     	verificarSeleccionados();
         con.last();
         obtenerActivosLTE();
     }

     // returns the previous page of records
     public void previous() {
     	verificarSeleccionados();
         con.previous();
         obtenerActivosLTE();
     }

     // returns the next page of records
     public void next() {
     	verificarSeleccionados();
         con.next();
         obtenerActivosLTE();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
     
	 //Metodo encargado de mantener los objetos seleccionados
     public void verificarSeleccionados(){
        for (LTE_ActivoETB_Wrapper aw : lstActivosWrapper) {
        	if(selectedRecordIds.contains(aw.activo.Id)){
        		if (!aw.checked){
        			selectedRecordIds.remove(aw.activo.Id);
        		}
        	} else{
        		if (aw.checked){
        			selectedRecordIds.add(aw.activo.Id);
        		}
        	}
         }
     }
    
    /***********************************************************************************/
    

	public class LTE_ActivoETB_Wrapper {
	
	    public Boolean checked 				{get;set;}
	    public Boolean desactivado			{get;set;}
	    public ActivoETB__c activo 			{get;set;}
	
	    public LTE_ActivoETB_Wrapper(ActivoETB__c a){
	        activo = a;
	        checked = false;
	        desactivado = false;
	    }
	    
	    public LTE_ActivoETB_Wrapper(ActivoETB__c a, Boolean check){
	        activo = a;
	        checked = check;
	        desactivado = false;
	    }
	    
	    public void desactivar(){
	    	desactivado = true;
	    }	
	}	
}