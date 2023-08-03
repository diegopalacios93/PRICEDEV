/***********************************************************************************************************************
Desarrollado por:   SQDM
Autor:              John Guevara
Proyecto:           Proyecto LTE
Descripción:        Controlador para la Ventana de retiro de un APN y sus Lineas

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-10-05      John Guevara. (SQDM) 		               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_TramitesAPN_RetiroAPN_ctr {
	
	private Apexpages.Standardcontroller stdController;
    /** Variables de entrada */
    public String numeroCaso									{get; set;}
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
    private String strTipo;
    /** Variables de control de visibilidad para los elementos de la pagina */
    public Boolean blnBuscar									{get; set;}
    public Boolean blnBotonRegresar								{get; set;}
    public Boolean blnBloqueServicios							{get; set;}
    public Boolean blnBotonGuardar								{get; set;}
    public Boolean blnBotonCerrar								{get; set;}
    public Boolean blnAllChecked								{get; set;}
    public Boolean blnHayDatos			 						{get; set;}
    public Boolean blnmostrarPrimero							{get; set;}
    public Boolean blnmostrarUltimo			 					{get; set;}
    
    public String numerosAPN		 							{get; set;}
    public Integer intCantidadReg								{get; set;}
    private Map<string,VariablesGlobales__c> vGlobal;
    Integer numeroRegistros;
    public List<LTE_ActivoETB_Wrapper> lstActivosWrapper		{get; set;}
    public List<ActivoETB__c> lstActivos;
    Set<Id> selectedRecordIds;
    
    /** Variables para paginacion */
	public ApexPages.StandardSetController con					{get; set;}
    
    /**
    * Constructor del controlador
    */
    public LTE_TramitesAPN_RetiroAPN_ctr(ApexPages.StandardController stdController){
        this.stdController = stdController;
        
    	this.blnBuscar = true;
    	this.blnBotonRegresar = false;
    	this.blnBloqueServicios = false;
    	this.blnBotonGuardar = false;
    	this.blnBotonCerrar = false;
    	this.blnAllChecked = false;
    	this.blnHayDatos = false;
    	this.blnmostrarPrimero = false;
    	this.blnmostrarUltimo = false;
        
    	this.idCase = ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact = ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
        this.strTipo = ApexPages.currentPage().getParameters().get('strTipo');
    	this.vGlobal = VariablesGlobales__c.getAll();
        
    	this.numerosAPN = '';
    	this.intCantidadReg = 0;
    	this.numeroRegistros = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
		
        this.lstActivosWrapper = new List<LTE_ActivoETB_Wrapper>();
    	this.lstActivos = new List<ActivoETB__c>();
    	this.con = new ApexPages.StandardSetController(lstActivos);
	    this.selectedRecordIds = new Set<Id>();
    	
    	if(String.isEmpty(this.idCase)){
    		System.debug('=======> El parametro LTE_TramitesAPN_conectarAPN_ctr.idCase llego nulo o vacio a la pantalla de seleccion de servicios de modificacion de APN.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(String.isEmpty(this.idAccount)){
    		System.debug('=======> El parametro LTE_TramitesAPN_conectarAPN_ctr.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de modificacion de APN.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(String.isEmpty(this.idContact)){
    		System.debug('=======> El parametro LTE_TramitesAPN_conectarAPN_ctr.idContact llego nulo o vacio a la pantalla de seleccion de servicios de modificacion de APN.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	List<Contact> lstContactos = [SELECT Id, LTE_RolLTE__c FROM Contact WHERE Id = :this.idContact];
    	if(lstContactos.isEmpty()){
    		System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
    		parametroInvalido(Label.LTE_Caso_Sin_Contacto);
    		return;
    	}
    	
    	if(!validaRolAPN(lstContactos.get(0).LTE_RolLTE__c)){
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
    }
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolAPN(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
   		
   		rolesLTE = vGlobal.get('RolLTERetiroAPN').valor__c;
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
   		String[] numerosAPNSeparados;
   		
   		if(numerosAPN == null || numerosAPN.trim().length() == 0 ){
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Digitar_Numero_Conexion));
   			return null;
   		}
   		this.blnBloqueServicios = true;
   		
   		//Se eliminan los espacios de la cadena
   		numerosAPN = numerosAPN.deleteWhiteSpace();
   		numerosAPNSeparados = numerosAPN.split(',');
   		Set<String> setNumerosAPN = new Set<String>(numerosAPNSeparados);
        String sProductoAPN = vGlobal.get('NombreComercialAPN').valor__c;
   		
   		this.lstActivos = [SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,
   			NumeroConexion__c,Plan__r.NombredelProducto__r.Name, CuentaFacturacion__c, 
   			APN__c, IP__c, POOL_de_APN__c, Pool_de_APN_Chico__c, Pool_de_APN_Autopista__c, Tipo_de_APN__c,
   			(SELECT name,Estado__c,TOPP__r.TipodeOperacionporplan__c, Categoria__c  FROM Operaciones_Comerciales__r WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento'))
   		FROM ActivoETB__c 
   		WHERE NombredelaCuenta__c = :this.idAccount AND Name IN :setNumerosAPN AND Estado__c = 'Activo'  and Plan__r.NombredelProducto__r.Name = :sProductoAPN Order By Name /*limit 100*/];
   		System.debug('Pendient');
        system.debug(this.idAccount);
        system.debug(setNumerosAPN);
   		if(this.lstActivos.isEmpty()){
   			this.intCantidadReg = 0;
	    	this.blnBloqueServicios = false;
	    	this.blnBotonGuardar = false;
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
   		} else{
   			this.intCantidadReg = lstActivos.size();
	    	this.blnBloqueServicios = true;
	    	this.blnBotonGuardar = true;
   		}
   		
   		this.con = new ApexPages.StandardSetController(this.lstActivos);
        this.con.setPageSize(numeroRegistros);
        obtenerActivosLTE();
   		
		return null;
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
    * Metodo encargado de generar y almacenar todos los datos para procesar la 
    * transaccion de cambio de plan.
    */
    public PageReference guardar(){
		List<TOPP__c> lstTOPP = new List<TOPP__c>();
		List<RecordType> lstRecordType = new list<RecordType>();
		List<ActivoETB__c> lstActivosSeleccionados = new List<ActivoETB__c>();
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		set<Id> setAPN = new set<Id>();
		List<Id> lstAPN = new List<Id>();
		OperacionComercial__c objOC;
        String sTOPAPN = '';
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
		
		Savepoint sp = Database.setSavepoint();
		
		verificarSeleccionados();
		
		if(selectedRecordIds.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Seleccionar_Activo_APN));
			return null;
		}
		
		lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Id = :this.idTOPP];
		lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            
        if(lstRecordType.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado + this.idTOPP));
			return null;
		}            
		
		lstActivosSeleccionados = obtenerActivosSeleccionados();
		
		try{
            for(ActivoETB__c objslctActivo : lstActivosSeleccionados){
                setAPN.add(objslctActivo.APN__c);
                lstAPN.add(objslctActivo.Id);
            }
			for(ActivoETB__c objActivo : [SELECT Id,NumeroConexion__c,Plan__c,CuentaFacturacion__c FROM ActivoETB__c WHERE NombredelaCuenta__c = :this.idAccount and APN__c = :setAPN  AND Estado__c = 'Activo' AND Plan__r.NombredelProducto__r.Name = :productoLTE]){
				objOC = new OperacionComercial__c();
	    		objOC.CuentaCliente__c = this.idAccount;
	    		objOC.Activo__c = objActivo.Id;
	    		objOC.NumeroConexion__c = objActivo.NumeroConexion__c;
	    		objOC.Plan__c = objActivo.Plan__c;
	    		objOC.TOPP__c = this.idTOPP;
	    		objOC.Estado__c = 'En Curso';
	    		objOC.RecordTypeId = lstRecordType.get(0).Id;
	    		objOC.Caso__c = this.idCase;
	    		objOC.CuentaFacturacion__c = objActivo.CuentaFacturacion__c;
	    		//objOC.FechaInicioReconexion__c = fechaCorte;
	    		//objOC.Categoria__c = 'Bolsa Recurrente';
                objOC.IP__c = null;
                objOC.POOL_de_APN__c = null;
                objOC.APN__c = null;
                objOC.Pool_de_APN_Autopista__c = null;
                objOC.Pool_de_APN_Chico__c = null;
                objOc.Tipo_Operacion_APN__c = 'Retiro';
	    		lstOC.add(objOC);
			}
			
			insert lstOC;
			
            ProcesosAPN_cls.SVA_APN(lstOC);
			List<OperacionComercial__c> newOpeCom;
            ActualizarCamposActivo_cls clsUtility = new ActualizarCamposActivo_cls();
            system.debug('Retiro APN');
            system.debug(lstAPN);
        	newOpeCom = clsUtility.CrearOCDesdeActivo(lstAPN);
            for(OperacionComercial__c sglOpeCom:newOpeCom){
                sTOPAPN = 'Retiro';//---
                lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Plan__c = :sglOpeCom.Plan__c AND TipodeOperacionporplan__c = :sTOPAPN];
                lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
                if(lstRecordType.isEmpty()){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado + this.idTOPP));
                    return null;
                }
                sglOpeCom.CuentaCliente__c = this.idAccount;
                sglOpeCom.Caso__c = this.idCase;
                sglOpeCom.Estado__c = 'En Curso';
	    		sglOpeCom.TOPP__c = lstTOPP.get(0).Id;
	    		sglOpeCom.RecordTypeId = lstRecordType.get(0).Id;
            }
			
            insert newOpeCom;
	    	
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
    * Metodo encargado de seleccionar todos los checkbox de la lista Activos cuando se
    * clic en la casilla de la cabecera de los checkbox
    */
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
            	lstActivosWrapper.add(activoWrapper);
            }else{
            	activoWrapper = new LTE_ActivoETB_Wrapper(activo);
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