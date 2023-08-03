public with sharing class LTE_ConversionDemoAVenta_ctr {
	
	private Apexpages.Standardcontroller stdController;        
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
    public LTE_ConversionDemoAVenta_ctr(ApexPages.StandardController stdController){       
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
   		
   		this.lstActivos = [SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,
   			NumeroConexion__c,Plan__r.NombredelProducto__r.Name, Plan__r.TipodePlan__c, Contrato__c, Plan__r.LTE_MetodoDePago__c, 
   			Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, IMEI_del_Equipo__c, LTE_ICCID__c,Activo_Relacionado__c,
   			(SELECT name,Estado__c,TOPP__r.TipodeOperacionporplan__c, Categoria__c  FROM Operaciones_Comerciales__r WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento'))
   		FROM ActivoETB__c 
   		WHERE NombredelaCuenta__c = :this.idAccount and Plan__r.NombredelProducto__r.Name = :producto AND /*Plan__r.TipodePlan__c != 'Troncal SIP' AND*/ NumeroConexion__c IN :numerosConexionSeparados AND Estado__c = 'Activo' AND Plan__r.LTE_MetodoDePago__c != 'PREPAGO' AND Demo__c = true Order By Name /*limit 100*/];
   		
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
		set<Id> setIdOcs = new set<Id>();
		OperacionComercial__c objOC;		
		Integer intCicloFacturacion;
		Date fechaCorte;
		
		Savepoint sp = Database.setSavepoint();    		
		verificarSeleccionados();
		
		if(selectedRecordIds.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe seleccionar al menos un servicio para realizar la reducción de bolsa compartida.'));
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
				try{
					intCicloFacturacion = Integer.valueOf(objActivo.CuentaFacturacion__r.LTE_CicloFacturacion__c);
				} catch(Exception e){
					intCicloFacturacion = -1;
					System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
					e.setMessage(Label.LTE_Servicio_Sin_Cuenta_Facturacion);
					throw e;
				}								

				objOC = new OperacionComercial__c();
	    		objOC.CuentaCliente__c 					= this.idAccount;
	    		objOC.Activo__c 						= objActivo.Id;
	    		objOC.NumeroConexion__c 				= objActivo.NumeroConexion__c;   		
	    		objOC.Plan__c 							= objActivo.Plan__c;
	    		objOC.TOPP__c 							= this.idTOPP;	    		
	    		objOC.Estado__c 						= 'Pendiente';
	    		objOC.RecordTypeId 						= lstRecordType.get(0).Id;
	    		objOC.Caso__c 							= this.idCase;	    		
	    		objOC.CuentaFacturacion__c  			= objActivo.CuentaFacturacion__c;	    		
                objOC.FechaSolicitud__c					= date.today();                
                objOC.IMEI_del_Equipo__c				= objActivo.IMEI_del_Equipo__c;
                objOC.LTE_ICCID__c						= objActivo.LTE_ICCID__c;
	    		lstOC.add(objOC);	    		
			}			
			insert lstOC;
            
            Case caso = new Case(Id = this.idCase);
	    	caso.Aprobaciones__c = 'Oferta Realizada';
	    	update caso;	    	
	    	
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