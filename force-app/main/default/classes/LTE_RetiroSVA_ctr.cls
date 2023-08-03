/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de retiro de SVA's

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-02-11      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_RetiroSVA_ctr {
	
	private Apexpages.Standardcontroller stdController;
    public Boolean blnBuscar		 							{get; set;}
    public Boolean blnBotonRegresar	 							{get; set;}
    public Boolean blnBloqueServicios 							{get; set;}
    public Boolean blnBotonGuardar								{get; set;}
    public Boolean blnBotonCerrar								{get; set;}
    public String numerosConexion	 							{get; set;}
    public String numeroCaso									{get; set;}
    public String tipoTramite									{get; set;}
    public Integer intCantidadReg								{get; set;}
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
    
    Set<Id> selectedSVAs;
    public List<ActivoETB__c> lstActivos;
    Integer numeroRegistros;
    /***************************/
    
    private Map<string,VariablesGlobales__c> vGlobal;
    
    /**
    * Constructor del controlador
    */
    public LTE_RetiroSVA_ctr(ApexPages.StandardController stdController){
    	this.stdController = stdController;
    	this.blnBuscar = true;
    	this.blnBotonRegresar = false;
    	this.blnBloqueServicios = false;
    	this.blnBotonGuardar = false;
    	this.blnBotonCerrar = false;
    	this.numerosConexion = '';
    	this.intCantidadReg = 0;
    	this.idCase = ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact = ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
    	this.tipoTramite = ApexPages.currentPage().getParameters().get('tipoTramite');
    	this.vGlobal = VariablesGlobales__c.getAll();
    	this.mapSVA = LTE_SVA__c.getAll();
    	
    	this.numeroRegistros = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
    	this.lstActivosWrapper = new List<LTE_ActivoETB_Wrapper>();
    	this.blnHayDatos = false;
    	this.blnmostrarPrimero = false;
    	this.blnmostrarUltimo = false;
    	this.lstActivos = new List<ActivoETB__c>();
    	this.con = new ApexPages.StandardSetController(lstActivos);
	    this.selectedSVAs = new Set<Id>();
    	
    	if(this.idCase == null){
    		System.debug('=======> El parametro LTERetiroSVA.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.idAccount == null){
    		System.debug('=======> El parametro LTERetiroSVA.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
    		System.debug('=======> El parametro LTERetiroSVA.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	List<Contact> lstContactos = new  List<Contact>();
    	lstContactos = [SELECT Id, LTE_RolLTE__c FROM Contact WHERE Id = :this.idContact];
    	
    	if(lstContactos.isEmpty()){
    		System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
    		parametroInvalido(Label.LTE_Caso_Sin_Contacto);
    		return;
    	}
    	
    	if(!validaRolRetiroSVA(lstContactos.get(0).LTE_RolLTE__c)){
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTERetiroSVA').valor__c+' en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
    	
		lstTipoSubPlan = new List<String>();
		for(LTE_SVA__c sva : mapSVA.values()){
			if(sva.LTE_Familia__c == this.tipoTramite){
				lstTipoSubPlan.add(sva.Name);
			}
		}
		system.debug('*****************************************');
		system.debug(lstTipoSubPlan);
		system.debug('*****************************************');
		
    }
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolRetiroSVA(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
   		
   		rolesLTE = vGlobal.get('RolLTERetiroSVA').valor__c;
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
   		
   		this.lstActivos = [SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,
   			NumeroConexion__c,Plan__r.NombredelProducto__r.Name, Plan__r.TipodePlan__c, Contrato__c, Plan__r.LTE_MetodoDePago__c, 
   			Contrato__r.ContractNumber, Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, 
   			(SELECT Id,name,Estado__c,TOPP__r.TipodeOperacionporplan__c, Categoria__c  FROM Operaciones_Comerciales__r WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento')), 
   			(SELECT Id, Name, LTE_OC_Tramite__c FROM Servicios_adicionales__r WHERE LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c IN :lstTipoSubPlan AND LTE_ServiceActionCode__c NOT IN ('ELIMINADO', 'DELETE'))
   		FROM ActivoETB__c 
   		WHERE NombredelaCuenta__c = :this.idAccount and Plan__r.NombredelProducto__r.Name = :producto AND Plan__r.TipodePlan__c != 'Troncal SIP' AND NumeroConexion__c IN :numerosConexionSeparados AND Estado__c = 'Activo' AND Plan__r.LTE_MetodoDePago__c != 'PREPAGO' Order By Name /*limit 100*/];
   		
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
		List<RecordType> lstRecordType = new list<RecordType>();
		List<ActivoETB__c> lstActivosSeleccionados = new List<ActivoETB__c>();
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		List<LTE_Servicios_adicionales__c> lstSA = new List<LTE_Servicios_adicionales__c>();
		List<LTE_Servicios_adicionales__c> lstSAUpdate = new List<LTE_Servicios_adicionales__c>();
		set<Id> setIdOcs = new set<Id>();
		OperacionComercial__c objOC;
		Integer intCicloFacturacion;
		Date fechaCorte;
		String estado;
		
		Savepoint sp = Database.setSavepoint();
		
		verificarSeleccionados();
		
		if(selectedSVAs.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Seleccionar_SVA_Retiro));
			return null;
		}
		
		lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Id = :this.idTOPP];
		lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            
        if(lstRecordType.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
			return null;
		}            
		
		lstActivosSeleccionados = obtenerActivosSeleccionados();
		
		try{
			for(ActivoETB__c objActivo : lstActivosSeleccionados){
				
				if(this.tipoTramite == 'Bolsa Recurrente'){
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
				} else if(this.tipoTramite == 'Seguro de terminales' || this.tipoTramite == 'Roaming'){
					fechaCorte = Date.today();
				} else{
					Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Tramite_Retiro_Invalido));
					return null;
				}
				
				if(this.tipoTramite == 'Seguro de terminales'){
					estado = 'Pendiente Facturacion'; 
				} else{
					estado = 'En Curso';
				}
			
				objOC = new OperacionComercial__c();
	    		objOC.CuentaCliente__c = this.idAccount;
	    		objOC.Activo__c = objActivo.Id;
	    		objOC.NumeroConexion__c = objActivo.NumeroConexion__c;   		
	    		objOC.Plan__c = objActivo.Plan__c;
	    		objOC.TOPP__c = this.idTOPP;
	    		objOC.Estado__c = estado;
	    		objOC.RecordTypeId = lstRecordType.get(0).Id;
	    		objOC.Caso__c = this.idCase;
	    		objOC.CuentaFacturacion__c = objActivo.CuentaFacturacion__c;
	    		objOC.FechaInicioReconexion__c = fechaCorte;
	    		objOC.Categoria__c = this.tipoTramite;
	    		lstOC.add(objOC);
			}
			
			insert lstOC;
			
			for(OperacionComercial__c objOCAux : lstOC){
				lstSA = obtenerListaSA(objOCAux.Activo__c);
				if(!lstSA.isEmpty()){
					for(LTE_Servicios_adicionales__c sa : lstSA){
						if(selectedSVAs.contains(sa.Id)){
							sa.LTE_OC_Tramite__c = objOCAux.Id;
							lstSAUpdate.add(sa);
						}
					}
				}
				
				setIdOcs.add(objOCAux.Id);
			}
			
			update lstSAUpdate;
			
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.LTE_Proceso_Exitoso));
			this.blnBotonGuardar = false;
			this.blnBuscar = false;
			this.blnBotonCerrar = true;
			return null;
		} catch(Exception e){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
    		Database.rollback(sp);
    		System.Debug('====================== EXCEPCION ======================');
    		System.debug( e.getMessage() + ' ' + e.getStackTraceString());
    		System.Debug('=======================================================');
    		return null;
    	}
    	
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
    
    /**
    * Metodo encargado de obtener todos los Activos pertenecientes a los
    * Servicios Adicionales seleccionados.
    */
    public List<ActivoETB__c> obtenerActivosSeleccionados(){
    	List<ActivoETB__c> lstActivosSeleccionados = new List<ActivoETB__c>();

		for(ActivoETB__c ac : this.lstActivos){
			for(LTE_Servicios_adicionales__c sa : ac.Servicios_adicionales__r){
				if(selectedSVAs.contains(sa.Id)){
					lstActivosSeleccionados.add(ac);
					break;
				}
			}
		}

    	return lstActivosSeleccionados;
    }
    
    /**
    * Metodo encargdo de obtener un activo a partir del su Id
    */
    public List<LTE_Servicios_adicionales__c> obtenerListaSA(Id idActivo){
		for(ActivoETB__c ac : this.lstActivos){
			if(ac.Id == idActivo){
				return ac.Servicios_adicionales__r;
			}
    	}
    	return null;
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
        	activoWrapper = new LTE_ActivoETB_Wrapper(activo, selectedSVAs);
        	lstActivosWrapper.add(activoWrapper);
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
        	for(LTE_SA_Wrapper saW : aw.lstSAW){
        		if(selectedSVAs.contains(saW.idSA)){
        			if (!saW.check){
	        			selectedSVAs.remove(saW.idSA);
	        		}
	        	} else{
	        		if (saW.check){
	        			selectedSVAs.add(saW.idSA);
	        		}
	        	}
        	}
         }
     }
    
    /***********************************************************************************/
    

	public class LTE_ActivoETB_Wrapper {
	
	    public Boolean checked 					{get;set;}
	    public Boolean desactivado				{get;set;}
	    public ActivoETB__c activo 				{get;set;}
	    public LTE_AC_Wrapper ac 				{get;set;}
	    public list<LTE_OC_Wrapper> lstOCW		{get;set;}
	    public list<LTE_SA_Wrapper> lstSAW		{get;set;}
	
	    public LTE_ActivoETB_Wrapper(ActivoETB__c a, Set<Id> selectedSVAs){
	        activo = a;
	        checked = false;
	        desactivado = false;
	        ac = new LTE_AC_Wrapper();
	        lstOCW = new list<LTE_OC_Wrapper>();
	        lstSAW = new list<LTE_SA_Wrapper>();
	        
	        asignarValores(a, selectedSVAs);
	    }
	    
	    public LTE_ActivoETB_Wrapper(ActivoETB__c a, Boolean check, Set<Id> selectedSVAs){
	        activo = a;
	        checked = check;
	        desactivado = false;
	        ac = new LTE_AC_Wrapper();
	        lstOCW = new list<LTE_OC_Wrapper>();
	        lstSAW = new list<LTE_SA_Wrapper>();
	        
	        asignarValores(a, selectedSVAs);
	    }
	    
	    public void desactivar(){
	    	desactivado = true;
	    }
	    
	    private void asignarValores(ActivoETB__c a, Set<Id> selectedSVAs){
	    	ac.idActivo = a.Id;
			ac.nombreActivo = a.Name;
			ac.numeroConexion = a.NumeroConexion__c;
			ac.numeroContrato = a.Contrato__r.ContractNumber;
			ac.contratoNegociado = a.Contrato__r.LTE_Contrato_negociado__c;
	        
	        LTE_OC_Wrapper ocW;
	        if(!a.Operaciones_Comerciales__r.isEmpty()){
	        	for(OperacionComercial__c oc : a.Operaciones_Comerciales__r){
	        		ocW = new LTE_OC_Wrapper();
	        		ocW.idOC = oc.Id;
	        		ocW.nombreOC = oc.Name;
	        		ocW.estadoOC = oc.Estado__c;
	        		ocW.nombreTOPP = oc.TOPP__r.TipodeOperacionporplan__c;
	        		ocW.categoria = oc.Categoria__c;
	        		lstOCW.add(ocW);
	        	}
	        }
	        
	        LTE_SA_Wrapper saW;
	        if(!a.Servicios_adicionales__r.isEmpty()){
	        	for(LTE_Servicios_adicionales__c sa : a.Servicios_adicionales__r){
	        		saW = new LTE_SA_Wrapper();
	        		saW.idSA = sa.Id;
	        		saW.nombreSA = sa.Name;
	        		saW.desactivado = false;
	        		
	        		if(selectedSVAs.contains(sa.Id)){
	        			saW.check = true;
	        		} else{
	        			saW.check = false;
	        		}
	        		
	        		if(sa.LTE_OC_Tramite__c != null){
	        			System.Debug('\n\nVa a inactivar el SA: ' + sa.LTE_OC_Tramite__c + '\n\n');
	        			saW.check = false;
	        			saW.desactivado = true;
	        		}
	        		
	        		lstSAW.add(saW);
	        	}
	        }
	    }
	}
	
	public class LTE_AC_Wrapper{
		public Id idActivo							{get;set;}
		public String nombreActivo					{get;set;}
		public String numeroConexion				{get;set;}
		public String numeroContrato				{get;set;}
		public String contratoNegociado				{get;set;}
	}
	
	public class LTE_OC_Wrapper{
		public Id idOC							{get;set;}
		public String nombreOC	 				{get;set;}
		public String estadoOC	 				{get;set;}
		public String nombreTOPP 				{get;set;}
		public String categoria 				{get;set;}
	}
	
	public class LTE_SA_Wrapper{
		public Id idSA							{get;set;}
		public String nombreSA	 				{get;set;}
		public String estado 					{get;set;}
		public Boolean check 					{get;set;}
		public Boolean desactivado				{get;set;}
	}
	
}