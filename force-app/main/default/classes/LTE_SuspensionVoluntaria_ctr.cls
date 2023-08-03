/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Marwin H. Pineda Garzón
Proyecto:           LTE Fase II
Descripción:        Controlador de la Visualforce Suspensión Voluntaria

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2015-12-10      Marwin H. Pineda Garzón. (MHPG)               Creación de la clase.
1.1     2016-03-02      Manuel Cortes (MACP)                    - Se corrige error al dar doble clic en "buscar"
																- Se comentan los metodos y miembros de la clase
																- Se eliminan variables no usadas
																- Se corrige calculo de fechas de suspensón
1.2		2017-11-14		Mauricio Farias Arias					- Se ajusta la linea 610 para incluir los codigos de respuesta 4 y 5
1.30	2018-01-22		Fernando Sarasty						- Se incluye la línea 605 para generar un valor predeterminado para el tag "Mensaje Respuesta Suspenda"
																- Se incluye el código entre la línea 620 a 626, para controlar el CodigoFlujo en cero(0) y presentar en la view el tag "DescripcionRespuest"
***********************************************************************************************************************/
public with sharing class LTE_SuspensionVoluntaria_ctr {
	
	public Boolean blnBuscar		 			{get; set;} //Indica si se muestra el boton de buscar
    public Boolean blnBotonContinuar 			{get; set;} //Indica si se muestra el boton de continuar
    public Boolean blnBloqueServicios 			{get; set;} //Indica si se muestra el bloque de servicios
    public Boolean blnBotonGuardar				{get; set;} //Indica si se muestra el boton de guardar
    public Boolean blnAllChecked				{get; set;} //Indica si se selecionaron todos los registros
    public Boolean blnOcultarTabla				{get; set;} //Indica si se oculta la tabla de servicios
    public Boolean blnMostrarResultados			{get; set;} //Indica si se muestra la tabla de resultados despues de "continuar"
    public Boolean blnBotonRegresar				{get; set;} //Indica si se muestra el boton de regresar
    public String numerosConexion	 			{get; set;} //Contiene los numeros de conexion ingresados desde la VF
    public String numeroCaso					{get; set;} //Muestra el numero del caso en la VF
    public Integer intCantidadReg				{get; set;} //Muestra la cantidad de registron en las tablas en las VF
    public String strActivoId					{get; set;} //Variable que almacena el parametro cuando se invoca el metodo "cargarFecha"
    
    
    /** Variables para paginacion */
	public ApexPages.StandardSetController con				{get; set;}
    public List<ActivoETB_Wrapper> lstActivosWrapper		{get; set;}
    public List<ActivoETB_Wrapper> lstActivosSeleccionados	{get; set;}
    public Boolean blnmostrarPrimero						{get; set;}
    public Boolean blnmostrarUltimo			 				{get; set;}
    
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
    private String strTipo;
    
    public Set<Id> selectedRecordIds;
    public Date dtFechaHoy = System.today();
    public Map<String, date> mapOCXFechaCorte = new map<String, date>();
	public Map<Id, String> mapFechaSeleccionada;
    public Map<String, ActivoETB_Wrapper> mapActivoSeleccionado;
    private Map<string,VariablesGlobales__c> vGlobal;
    public List<ActivoETB__c> lstActivosETB;
    public List<ActivoETB__c> lstActivos;
    /*******************************
     * Parametros generales
     *******************************/
    public Integer intParamNumeroVeces; 	
    public Integer intParamNumeroDias;
    public Integer intParamDiasPreviosSusp;
    public Integer intParamNumeroRegistros; 
    
    /*************************************************
     * Constructor de la clase
     ************************************************/
    public LTE_SuspensionVoluntaria_ctr(ApexPages.StandardController stdController) {
        try{            
		this.blnBuscar 				= true;
    	this.blnBotonContinuar		= false;
    	this.blnBloqueServicios		= false;
    	this.blnBotonGuardar 		= false;
    	this.blnAllChecked 			= false;
    	this.blnOcultarTabla		= true;
    	this.blnMostrarResultados	= false;
    	this.blnBotonRegresar 		= false;
    	this.numerosConexion 		= '';
    	this.strActivoId			= '';
    	this.intCantidadReg 		= 0;
    	this.idCase 				= ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount 				= ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact 				= ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso 			= ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP 				= ApexPages.currentPage().getParameters().get('idTOPP');
    	this.strTipo				= ApexPages.currentPage().getParameters().get('strTipo');
    	this.vGlobal 				= VariablesGlobales__c.getAll();
    	
    	//inicializacion de variables para paginacion
    	if(vGlobal.get('CambioPlanRegxPag').valor__c == null || vGlobal.get('CambioPlanRegxPag').valor__c.trim().length() == 0){
    		System.debug('=======> No se ha asignado el parámetro CambioPlanRegxPag en la configuración personalizada VariablesGlobales__c.');
    		parametroInvalido(Label.LTE_Mensaje_No_Paginacion);
    		return;
    	}
    	
    	this.intParamNumeroRegistros 			= Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
    	this.lstActivosWrapper 			= new List<ActivoETB_Wrapper>();
    	this.lstActivosSeleccionados	= new List<ActivoETB_Wrapper>();
    	this.blnmostrarPrimero 			= false;
    	this.blnmostrarUltimo 			= false;
    	this.lstActivos 				= new List<ActivoETB__c>();
    	this.con 						= new ApexPages.StandardSetController(lstActivos);
	    this.selectedRecordIds 			= new Set<Id>();
     	this.mapFechaSeleccionada		= new map<Id, String>();
     	this.mapActivoSeleccionado		= new map<String, ActivoETB_Wrapper>();
     	this.lstActivosETB 				= new list<ActivoETB__c>();
    	
    	if(this.idCase == null) {
    		System.debug('=======> El parametro LTECambioPlan.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.idAccount == null) {
    		System.debug('=======> El parametro LTECambioPlan.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0) {
    		System.debug('=======> El parametro LTECambioPlan.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	List<Contact> lstContactos 	= new  List<Contact>();
    	lstContactos 				=	[SELECT Id, LTE_RolLTE__c 
    									FROM Contact 
    									WHERE Id = :this.idContact
    									AND AccountId = :idAccount];
    	
    	if(lstContactos.isEmpty()){
    		System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
    		parametroInvalido(Label.LTE_Caso_Sin_Contacto);
    		return; 
    	}
       	System.debug('lstContactos.get(0): ' + lstContactos.get(0));
            System.debug('lstContactos.get(0).LTE_RolLTE__c: ' + lstContactos.get(0).LTE_RolLTE__c);
    	
    	if(!validaRolSuspensionVoluntaria(lstContactos.get(0).LTE_RolLTE__c)){
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel Total en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
        
        intParamNumeroVeces			= Integer.ValueOf(vGlobal.get('NumVecesSuspension').valor__c);
    	intParamNumeroDias			= Integer.ValueOf(vGlobal.get('TotalDiasSuspension').valor__c);
        intParamDiasPreviosSusp 	= Integer.valueOf(vGlobal.get('DiasPreviosSuspension').valor__c);            
        }catch(Exception e){
            System.debug('ERROR: ' + e.getStackTraceString());
            throw e;
        }
    	
    }
    
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolSuspensionVoluntaria(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
        
   		rolesLTE = vGlobal.get('RolLTESuspensionVoluntaria').valor__c;
   		rolesLTESeparados = rolesLTE.split(',');
   		lstRolesLTE = new list<String>(rolesLTESeparados);
   		
   		for(String rol : lstRolesLTE){
   			if(rolContacto.trim() == rol.trim()){
   				return true;
   			}
   		}
    	
    	return false;
    }
    
    /********************************************************************************************
    * Metodo encargado de buscar los servicios asociados a los números de conexión digitados.
    ********************************************************************************************/
    public void buscarActivos() {
    	system.debug('=== buscarActivos ===');
    	if(numerosConexion == null || numerosConexion.trim().length() == 0) {
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Digitar_Numero_Conexion));
   			return;
   		}
   		this.blnBloqueServicios = true;
   		this.blnBotonContinuar 	= true;
   		
   		Set<String> setNumerosConexion 	= new Set<String>(numerosConexion.deleteWhiteSpace().split(','));
    	String strProducto 				= vGlobal.get('NombreComercialLTE').valor__c;
    	
    	system.debug('\n\n@@@strProducto-------> '  + strProducto + '\n' + 
    		'@@@setNumerosConexion--------> ' + setNumerosConexion + '\n' +
    		'@@@idAccount------> ' + idAccount + '\n\n'); 
    	
   		this.lstActivos = 	[SELECT Id, Name, NombredelaCuenta__r.Name, NumeroConexion__c, Estado__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, 
                            	LTE_Fecha_Ultima_Suspension__c, LTE_Numero_veces_suspendido__c, LTE_Dias_suspendidos__c, LTE_Fecha_Ultima_Reconexion__c,
                            	Fecha_Activacion__c, LTE_Fecha_Final_Contrato__c, Plan__c,CuentaFacturacion__c,
                            	(SELECT Id, Name, Estado__c, TOPP__r.TipodeOperacionporplan__c, FechaFacturacion__c//, ActivoETB__c
                            	FROM Operaciones_Comerciales__r 
                            	WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado'))
                        	FROM ActivoETB__c
                        	WHERE NombredelaCuenta__c = :this.idAccount
	                        AND Plan__r.NombredelProducto__r.Name = :strProducto 
	                        AND NumeroConexion__c IN :setNumerosConexion 
	                        AND Estado__c = 'Activo'
	                        AND Plan__r.LTE_TipoControl__c != 'Prepago'
	                        AND Plan__r.TipodePlan__c != 'Troncal SIP'];
	                        
		system.debug('\n\n@@@@lstActivos----------> ' + lstActivos + '\n\n');	                        
                            
            establecerFechaSuspension();
       
        if(this.lstActivos.isEmpty()) {
   			this.intCantidadReg 	= 0;
   			this.blnBotonContinuar 	= false;
	    	this.blnmostrarPrimero 	= false;
	    	this.blnmostrarUltimo 	= false;
	    	this.blnBloqueServicios = false;
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
   		} else { 
   			this.blnBotonContinuar 	= true;
   			this.intCantidadReg 	= lstActivos.size();
	    	this.blnmostrarPrimero 	= true;
	    	this.blnBloqueServicios = true;
	    	
	    	if(this.lstActivos.size() > intParamNumeroRegistros) { 
	    		this.blnmostrarUltimo = true;
	    	} else {
	    		this.blnmostrarUltimo = false;
	    	}
   		}
   		
   		this.con = new ApexPages.StandardSetController(this.lstActivos);
        this.con.setPageSize(intParamNumeroRegistros);
        obtenerActivosLTE();
        establecerFechaReconexion();
   		
    }
    
    /*************************************************************
     * Establece las fecha de suspensión
     * **********************************************************/
    public void establecerFechaSuspension(){
        System.debug('=== establecerFechaSuspension ===');
        Integer intCicloFacturacion;
        Date fechaCorteFinal = null;
        Date fechaCorteInicial = null;
        mapOCXFechaCorte = new Map<String, Date>();
    	for(ActivoETB__c objActivoETB :lstActivos){
            fechaCorteFinal = null;
        	if(objActivoETB.CuentaFacturacion__c != null){
        		intCicloFacturacion = Integer.valueOf(objActivoETB.CuentaFacturacion__r.LTE_CicloFacturacion__c);
        		if(intCicloFacturacion != null) {
	        		fechaCorteFinal 	= null;	
					fechaCorteInicial	= Date.newInstance(dtFechaHoy.year(), dtFechaHoy.month(), intCicloFacturacion);
					
	        		if(dtFechaHoy <= fechaCorteInicial){
	        			fechaCorteFinal = fechaCorteInicial;
	        			
	        			if( dtFechaHoy.daysBetween(fechaCorteFinal) < intParamDiasPreviosSusp){
	        				fechaCorteFinal = fechaCorteFinal.addMonths(1);	        				
	        			}	        			
					}else{
						fechaCorteFinal = fechaCorteInicial.addMonths(1);					
					}
	        	}else{
	        		fechaCorteFinal = null;
	        	}
        	}else{
        		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Servicio sin cuenta de facturación asociada ' + objActivoETB.Name));
        	}
        	mapOCXFechaCorte.put(objActivoETB.id,fechaCorteFinal);
        }
    }
    
    public void establecerFechaReconexion(){
        System.debug('=== establecerFechaReconexion ===');
    	for (ActivoETB_Wrapper activoWrapper : lstActivosWrapper){
        	activoWrapper.lstFechas = obtenerlstFechas(activoWrapper);
        }
    }
    
    /**
    * Metodo encargado de regresar a la pagina de seleccion de tramines para el
    * proceso de cambio de plan.
    */
    
    public PageReference regresar()
    {
		PageReference returnPage = Page.LTE_SeleccionTramiteCambioPlan_pag;
		returnPage.getParameters().put('scontrolCaching', '1');
		returnPage.getParameters().put('id', this.idCase);
		returnPage.setRedirect(true);
		return returnPage;    	
    }
    
    /******************************************************************
    * Metodo encargado de no mostrar y ocultar los botones necesario en caso
    *  que halla uno parametro nulo, adicionalmente muestra un mensaje indicando
    *  que ocurrio un error.
    ******************************************************************/
    public void parametroInvalido(String mensaje){
    	this.blnBotonRegresar 	= true;
    	this.blnBloqueServicios = false;
        this.blnBuscar 			= false;
		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, mensaje));
    }
    
    /***********************************************************************************
    * Metodo encargado de seleccionar todos los checkbox de la lista Activos cuando se
    * clic en la casilla de la cabecera de los checkbox
    ***********************************************************************************/
    public void seleccionarTodos(){
        System.debug('=== seleccionarTodos ===');
    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Seleccionar Todo'));
    	
    	system.debug('\n\n@@@blnAllChecked--------> ' + blnAllChecked + '\n\n');
    	
    	if(this.blnAllChecked){
    		for (ActivoETB_Wrapper aw : lstActivosWrapper) {
	    		if(!aw.desactivado){
	    			aw.checked = true;
	    			if(aw.checked == true){
	    				mapActivoSeleccionado.put(aw.activo.Id, aw);
	    			}else{
	    				mapActivoSeleccionado.remove(aw.activo.Id);
	    			}
	    		}
	    	}
    	}else{
    		for (ActivoETB_Wrapper aw : lstActivosWrapper){
	    		aw.checked = false;
	    	}
    	}
    	verificarSeleccionados();
    }
    
    /***********************************************************************************
    * Metodo que se ejecuta cuando se selecciona un registro
    ***********************************************************************************/
    public void selectRecords(){
    	System.debug('=== selectRecords ===');
    	for(ActivoETB_Wrapper objWrpActivo :lstActivosWrapper){
   			if(objWrpActivo.checked){
   				mapActivoSeleccionado.put(objWrpActivo.activo.Id, objWrpActivo);                  
   			}else{
   				mapActivoSeleccionado.remove(objWrpActivo.activo.Id);
   			}
   		}       
    }
    
    /****************************************************************
     * Obtiene la lista de fechas para los activos
     ***************************************************************/
    public List<Selectoption> obtenerlstFechas(ActivoETB_Wrapper activoWrapper){
        System.debug('=== obtenerlstFechas ===');
        System.debug('activoWrapper: ' + activoWrapper);
    	List<Selectoption> options 	= new list<Selectoption>(); 
    	Date dtFechaReconexion;
	    Datetime dtFechaRec; 
	    String strFechaRec;
	    Integer intValor;
	    
	    if(mapFechaSeleccionada.containsKey(activoWrapper.activo.Id)){
	    	activoWrapper.strFechaSeleccionada = mapFechaSeleccionada.get(activoWrapper.activo.Id); 
	    }
        if(activoWrapper.intCantPeriodos == 0){
			activoWrapper.desactivar();
			//activoWrapper.strMensaje = activoWrapper.strMensaje + ' - Cantidad de periodos es igual a 0.';            
        }
	    for(intValor = 1; intValor <= activoWrapper.intCantPeriodos; intValor++){
        	//dtFechaReconexion	= fechaCorteFinal.addMonths(intValor);
            dtFechaReconexion	= activoWrapper.dtFechaCiclo;
            if(dtFechaReconexion != null){
                dtFechaReconexion = dtFechaReconexion.addMonths(intValor);	
                dtFechaRec			= datetime.newInstance(dtFechaReconexion.year(), dtFechaReconexion.month(), dtFechaReconexion.day());
				strFechaRec			= dtFechaRec.format('dd/MM/yyyy');
				options.add(new SelectOption(String.valueOf(intValor), strFechaRec));
            }
		}	       	
       	return options;
    }
    
    /***********************************************************************************
    							METODOS PARA LA PAGINACION
    ************************************************************************************/
    public List<ActivoETB_Wrapper> obtenerActivosLTE(){
    	System.debug('=== obtenerActivosLTE ===');
    	lstActivosWrapper 		= new List<ActivoETB_Wrapper>();
        Integer noSeleccionados	= 0;
    	ActivoETB_Wrapper activoWrapper;
        Date fecha;
        Boolean isValid;
        Boolean isValidDiasSuspendidos;
        Boolean isValidNumeroVeces;
        Boolean isValidFechaContrato;
        
        for(ActivoETB__c activo : (List<ActivoETB__c>)con.getRecords()){
        	if(selectedRecordIds.contains(activo.Id)){
        		system.debug('\n\n@@@Entra1----> \n\n');
            	activoWrapper = createActivoWrapper(activo, true);
                activoWrapper.activar();
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.TOPP__r.TipodeOperacionporplan__c.equals('Suspensión')){
    					activoWrapper.desactivar();            			
            		}
            	}
            }else{
            	activoWrapper = createActivoWrapper(activo, false);
                isValidDiasSuspendidos = ( ((activo.LTE_Dias_suspendidos__c == null)?0:activo.LTE_Dias_suspendidos__c) <= intParamNumeroDias);
         		isValidNumeroVeces = ( ((activo.LTE_Numero_veces_suspendido__c == null)?0:activo.LTE_Numero_veces_suspendido__c) < intParamNumeroVeces );
        		isValidFechaContrato = ( (activo.LTE_Fecha_Final_Contrato__c == null)?true:(dtFechaHoy <= activo.LTE_Fecha_Final_Contrato__c));
                
                //Llegado el caso que la fecha de hoy no se encuentre en otro
                if(isValidFechaContrato){
                    //isValid = isValidDiasSuspendidos && isValidNumeroVeces && isValidFechaContrato;
                    isValid = true; // 20210826: Se inactiva validación de cantidad de veces suspendida la línea, para que se pueda suspender la línea la cantidad de veces que se requiera.
                }else{
                    //Se pone en true ya que la fecha de hoy es superior al periodo que se esta validando
                    //por ende se salta la validación
                    isValid = true;
                    activoWrapper.intCantPeriodos = 2;
                }
                
                system.debug('\n\n@@@LTE_Dias_suspendidos__c----> ' + activo.LTE_Dias_suspendidos__c + '\n' +
            			'@@@intParamNumeroDias-------> ' + intParamNumeroDias + '\n' + 
            			'@@@LTE_Numero_veces_suspendido__c-------> ' + activo.LTE_Numero_veces_suspendido__c + '\n' + 
            			'@@@intParamNumeroVeces--------> ' + intParamNumeroVeces + '\n' + 
            			'@@@dtFechaHoy--------> ' + dtFechaHoy + '\n' + 
            			'@@@LTE_Fecha_Final_Contrato__c-------> ' + activo.LTE_Fecha_Final_Contrato__c + '\n' + 
                        '@@@(activo.LTE_Dias_suspendidos__c < intParamNumeroDias): '+isValidDiasSuspendidos+'\n' +
                        '@@@  (activo.LTE_Numero_veces_suspendido__c < intParamNumeroVeces) ): '+  isValidNumeroVeces+'\n' +
                        '@@@dtFechaHoy < activo.LTE_Fecha_Final_Contrato__c: '+isValidFechaContrato+'\n' +
                        '@@@isValid: '+isValid+'\n\n');
                
                if(isValid){
                    activoWrapper.activar();
                    for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
                        if(oc.TOPP__r.TipodeOperacionporplan__c.equals('Suspensión')){
                            activoWrapper.desactivar();
                        }
                    }
                }else{
                    activoWrapper.desactivar();
                              
                }
            	noSeleccionados++;
                
            }
            
            fecha 	= mapOCXFechaCorte.get(activo.Id);
            System.debug('+++++++++++++++++++++++++ ' + fecha + '  ++++ ' + activo.Id	);
            if(fecha == null){
                activoWrapper.desactivar();
            }else{ 
                activoWrapper.dtFechaCiclo = Date.newInstance(fecha.year(), fecha.month(), fecha.day());
                //activoWrapper.strFechaCiclo = activoWrapper.dtFechaCiclo.format('dd/MM/yyyy');
                activoWrapper.strFechaCiclo = activoWrapper.dtFechaCiclo.format();
                activoWrapper.dtFechaSuspensionManual = dtFechaHoy.addDays(1);
            }
            lstActivosWrapper.add(activoWrapper);
            
        }
        
        if(noSeleccionados > 0) {
        	this.blnAllChecked = false;
        } else {
        	this.blnAllChecked = true;
        }
		
        return lstActivosWrapper;
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get{
        	if(con.getHasNext())
        		this.blnmostrarUltimo = true;
        	else
        		this.blnmostrarUltimo = false;
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious{
        get{
        	if(con.getHasPrevious())
        		this.blnmostrarPrimero = true;
        	else
        		this.blnmostrarPrimero = false;
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber{
        get{
            return con.getPageNumber();
        }
        set;
    }
   
	// returns the first page of records
	public void first(){
    	verificarSeleccionados();
        con.first();
        obtenerActivosLTE();
        establecerFechaReconexion();
   	}

    // returns the last page of records
    public void last() {
    	verificarSeleccionados();
        con.last();
        obtenerActivosLTE();
        establecerFechaReconexion();
	}

    // returns the previous page of records
    public void previous(){
    	verificarSeleccionados();
    	con.previous();
        obtenerActivosLTE();
        establecerFechaReconexion();
    }

    // returns the next page of records
    public void next(){
        verificarSeleccionados();
        con.next();
        obtenerActivosLTE();
        establecerFechaReconexion();
    }
 
    //Metodo encargado de mantener los objetos seleccionados
    public void verificarSeleccionados(){
    	for (ActivoETB_Wrapper aw : lstActivosWrapper) {
        	if(selectedRecordIds.contains(aw.activo.Id)){
        		if (!aw.checked){
        			selectedRecordIds.remove(aw.activo.Id);
        		}
        	}else{
        		if (aw.checked){
        			selectedRecordIds.add(aw.activo.Id);
        		}
        	}
     	}
	} 
    
    /***********************************************************************************
     * Almacena la fecha selecionada
     **********************************************************************************/ 
    public void cargarFecha(){
    	System.debug('=== cargarFecha ===');        
    	for(ActivoETB_Wrapper objWrpActivo :lstActivosWrapper){
    		if(objWrpActivo.activo.Id == strActivoId){
    			mapFechaSeleccionada.put(objWrpActivo.activo.Id, objWrpActivo.strFechaSeleccionada);
    		}
    	}
    }
    
    /***********************************************************************************
     * Validar la fecha selecionada
     **********************************************************************************/ 
    public void validarFecha(){
    	System.debug('strActivoId' + strActivoId );
		Boolean errorFecha = false;
        
    	for(ActivoETB_Wrapper objWrpActivo :lstActivosWrapper){
            if(objWrpActivo.fechaPersonalizada){
             	if (objWrpActivo.dtFechaSuspensionManual <= dtFechaHoy){
    				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'En el servicio: ' + objWrpActivo.activo.Name + ', La fecha de suspensión tiene que ser mayor al dia de hoy.'));
                   	errorFecha	= true;
               	}
               	if (objWrpActivo.dtFechaReconexionManual <= objWrpActivo.dtFechaSuspensionManual){
    				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'En el servicio: ' + objWrpActivo.activo.Name +  ', La fecha de reconexión no debe ser menor ó igual a la fecha de suspensión.'));
                   	errorFecha	= true;
            	}
                if (objWrpActivo.dtFechaReconexionManual == null){
    		       	errorFecha	= true;
            	}
    		}else{
                objWrpActivo.dtFechaSuspensionManual = dtFechaHoy.addDays(1);
                objWrpActivo.dtFechaReconexionManual = null;
           	}
    	}
        blnBotonContinuar = !errorFecha;
    }
    
	/****************************************************************
    * Metodo ecargado construir el listado de servicios seleccionados
    * junto con sus respectivas detalles de oferta
    ****************************************************************/
    public void continuar(){
        System.debug('=== continuar ===');
   		lstActivosSeleccionados = mapActivoSeleccionado.values();
   		String strTipoTramite;
   		
   		system.debug('\n\n@@@lstActivosSeleccionados---------> ' + lstActivosSeleccionados + '\n\n');
   		
   		if(!lstActivosSeleccionados.isEmpty()){
   			system.debug('\n\n@@@Entra continuar 1----->\n\n');
   			blnOcultarTabla 		= false;
   			blnBotonContinuar		= false;
            blnBotonRegresar        = true;
   			blnMostrarResultados	= true;
   			numerosConexion			= '';
   			blnBloqueServicios		= false;
   			blnBotonGuardar			= true;
   			strTipoTramite 			= cadenaTipoTramite(strTipo);
   			Set<String> setIdServicios = new set<String>(mapActivoSeleccionado.keySet());
   			LTE_OperacionesSFDCSuspenda_cls objOperacionesSFDCSuspenda = new LTE_OperacionesSFDCSuspenda_cls();
            System.debug('=== LTE_OperacionesSFDCSuspenda_cls.consultarSuspensionSevicios  ===');
            System.debug('1. setIdServicios: ' + setIdServicios);
            System.debug('2. strTipoTramite: ' + strTipoTramite);
            System.debug('3. true: ');
            System.debug('4. null: ');
   			Map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRespuestaWS = objOperacionesSFDCSuspenda.consultarSuspensionSevicios(setIdServicios, strTipoTramite, true, null);
            LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda elementTmp = null;
            
            for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
                obj.validadoSuspenda = false;                    
              	obj.strRespuestaSuspenda = 'Sin respuesta de suspenda.';  
                obj.strMensajeRespuestaSuspenda = 'Sin mensaje de respuesta de suspenda.'; //[FSARASTY, 22/01/2018]: Se incluye respuesta para el tag "Mensaje Respuesta Suspenda".
                
                for(String keyMap : mapRespuestaWS.keyset() ){                    
                    elementTmp = mapRespuestaWS.get(keyMap);                    
               		System.debug('('+keyMap+') = ' + elementTmp);
                    
                    if(elementTmp.numeroConexion.equals(obj.activo.NumeroConexion__c)){
                        obj.codigoRespuestaSuspenda = elementTmp.CodigoFlujo;                        
                        obj.strRespuestaSuspenda = '(Código Flujo: '+elementTmp.CodigoFlujo+') ' + elementTmp.DescripcionFlujo;
                        if(elementTmp.CodigoFlujo.equals('2') || elementTmp.CodigoFlujo.equals('1') || elementTmp.CodigoFlujo.equals('4') || elementTmp.CodigoFlujo.equals('5')){
                            obj.validadoSuspenda = true;
                        }
                        if(elementTmp.CodigoFlujo.equals('3')){
                           obj.validadoSuspenda = false;
                           obj.strRespuestaSuspenda = '(Código Flujo: '+elementTmp.CodigoFlujo+') ' + elementTmp.DescripcionFlujo;
                        }
                        //[FSARASTY, 22/01/2018]: Se incluye código para determinar si el código de flujo es igual a "0" generando la respuesta "ValidadoSuspenda = false"
						if(elementTmp.CodigoFlujo.equals('0')){
                           obj.validadoSuspenda 		   = false;
                           obj.strRespuestaSuspenda 	   = '(Código Flujo: '+elementTmp.CodigoFlujo+') ' + elementTmp.DescripcionFlujo;
						   obj.strMensajeRespuestaSuspenda = elementTmp.DescripcionRespuesta;
                        }
						//FIN [FSARASTY, 22/01/2018]
                    }
                }
            }
            
   			blnBuscar = false;
   		}else{
 			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe escoger por lo menos un registro'));
 			blnOcultarTabla 	= true;
   			blnBotonContinuar	= true;
   			blnBuscar			= false;			  			
   		}
   	}

    /****************************************************************
    * Metodo encargado de retornar la cadena de tipo de tramite
    ****************************************************************/
    public String cadenaTipoTramite(String tipo){
   		System.debug('=== cadenaTipoTramite ===');
        TOPP__c topp 	= [SELECT Id, Name FROM TOPP__c WHERE Id = :idTOPP];    
        return topp.Name.split('-')[0] + ' ' + tipo;	    
   	}
   	
    /****************************************************************
    * Metodo encargado de guardar las operaciones comerciales
    ****************************************************************/
    public void guardarOC(){
   		System.debug('=== guardarOC ===');
   		
   		OperacionComercial__c oc;
    	OperacionComercial__c ocRec;
    	List<OperacionComercial__c> lstOC 		= new List<OperacionComercial__c>();
    	List<OperacionComercial__c> lstOCRec	= new List<OperacionComercial__c>();
        String comentario = 'La OC de reconexión fue generada a través del caso: ' + this.numeroCaso+'. ' ;
    	
    	list<TOPP__c> lstTOPP 	= [SELECT Tipoderegistro__c FROM TOPP__c WHERE Id = :idTOPP];
   		String strTipoRegistro 	= lstTOPP.get(0).Tipoderegistro__c;
   		Id recordTypeId 		= [SELECT Id FROM RecordType WHERE DeveloperName = :strTipoRegistro].Id;
   		
   		list<TOPP__c> lstTOPPRec	= [SELECT Id, Tipoderegistro__c, TipodeOperacionporplan__c FROM TOPP__c WHERE Name = 'Reconexión- TELEFONIA MOVIL (LTE)'];
   		String strTOPPRec			= lstTOPPRec.get(0).Tipoderegistro__c;
   		Id idTOPPRec				= lstTOPPRec.get(0).Id;
   		Id recordTypeIdRec			= [SELECT Id FROM RecordType WHERE DeveloperName = :strTOPPRec].Id;
   		
   		asignarFechaReconexion();   		
    	for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
            if(obj.validadoSuspenda){
                oc 							= new OperacionComercial__c();
                oc.CuentaCliente__c 		= this.idAccount;
                oc.TOPP__c 					= this.idTOPP;
                oc.RecordTypeId				= recordTypeId;
                oc.TipoSuspension__c		= strTipo; 
                oc.Activo__c				= obj.activo.Id;
                oc.Plan__c					= obj.Activo.Plan__c;
                if(obj.fechaPersonalizada){
                     oc.FechaInicioReconexion__c = obj.dtFechaSuspensionManual;
                }else{
                	oc.FechaInicioReconexion__c	 = obj.dtFechaCiclo;
                }
                oc.CuentaFacturacion__c		= obj.activo.CuentaFacturacion__c;
                oc.Caso__c					= this.idCase;
                oc.Estado__c				= 'En Curso';
                oc.NumeroConexion__c		= obj.activo.NumeroConexion__c;
        
                ocRec 							= new OperacionComercial__c();
                ocRec.CuentaCliente__c 			= this.idAccount;
                ocRec.TOPP__c 					= idTOPPRec;
                ocRec.RecordTypeId				= recordTypeIdRec;
                ocRec.TipoSuspension__c			= strTipo;
                ocRec.Activo__c					= obj.activo.Id;
                ocRec.Plan__c					= obj.Activo.Plan__c;
                if(obj.fechaPersonalizada){
                     ocRec.FechaInicioReconexion__c	= obj.dtFechaReconexionManual;
                }else{
                    ocRec.FechaInicioReconexion__c	= obj.dtFechaReconexion;
                }                
                ocRec.CuentaFacturacion__c		= obj.activo.CuentaFacturacion__c;
                ocRec.Caso__c					= this.idCase;
                ocRec.Estado__c					= 'En Curso';
                ocRec.NumeroConexion__c			= obj.activo.NumeroConexion__c;
                ocRec.Comentarios__c            = comentario; 
                
                lstOC.add(oc);
                lstOCRec.add(ocRec);
            }
		}
    	System.debug('SE VAN A INSERTAR OC DE SUSPEN: ' + lstOC.size());
        System.debug('SE VAN A INSERTAR OC DE REC: ' + lstOCRec.size());
	 	if(!lstOC.isEmpty()){
			insert lstOC;
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'OC Regitrada con éxito'));
			blnBotonRegresar =  true;
			blnBotonGuardar	 = false;
		}
		
		if(!lstOCRec.isEmpty()){
			insert lstOCRec;
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'OC Regitrada con éxito'));
			blnBotonRegresar =  true;
			blnBotonGuardar	 = false;
		}
		
        //Se valida con alguna de las listas para mostrar un mensaje diferente
        if(lstOC.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No registraron cambios en las OC'));
			blnBotonRegresar = true;
			blnBotonGuardar  = false;
        }else{
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Proceso realizado con éxito'));
			blnBotonRegresar = true;
			blnBotonGuardar  = false;    
        }
        /*
        //Se mandan a registrar las OC con codigo de respuesta 2
        Set<String> setIdToRegistrarSuspenda = new Set<String>();
        for(OperacionComercial__c ocTmp :lstOC){
            for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
                if(obj.activo.id.equals(ocTmp.Activo__c) && '2'.equals(obj.codigoRespuestaSuspenda)){
                	setIdToRegistrarSuspenda.add(ocTmp.Id);
                }
            }
        }
        
        System.debug('Estos son los que suspenda respondió 2 ' + setIdToRegistrarSuspenda);
        if(setIdToRegistrarSuspenda.size() > 0){
        	LTE_CreacionOperacionesComerciales_ctr.registrarSuspenda(setIdToRegistrarSuspenda);
        }
        
		*/        
        
   	}
    
     /**********************************************
     * Metodo encargado de registrar en SUSPENDA
     **********************************************/
	/*@Future(callout=true)
	static void registrarSuspenda(Set<String> setIdOCs) {
        System.debug('=== registrarSuspenda ===');
    	Map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRespuestaWS = null;
        LTE_OperacionesSFDCSuspenda_cls objOperacionesSFDCSuspenda = null;
        System.debug('Cantidad de OC para registrar en SUSPENDA ('+setIdOCs.size()+') = ' + setIdOCs  );
        //Se envia a registrar a suspenda
        objOperacionesSFDCSuspenda = new LTE_OperacionesSFDCSuspenda_cls();
        mapRespuestaWS = objOperacionesSFDCSuspenda.registrarSuspensionSevicios(setIdOCs);
        OperacionComercial__c ocTmp = null;
        LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda wrpTmp = null;
        List<OperacionComercial__c> lstOCtoUpdate = new List<OperacionComercial__c>();
        Map<Id, OperacionComercial__c> mapOCs = new Map<Id, OperacionComercial__c>([SELECT Id, LTE_URLFallos__c FROM OperacionComercial__c WHERE Id in :setIdOCs]);
        for(String keyMap : mapRespuestaWS.keyset() ){
            wrpTmp = mapRespuestaWS.get(keyMap);
            ocTmp = mapOCs.get(Id.valueOf(keyMap));
            if(ocTmp != null){
            	ocTmp.LTE_URLFallos__c = 'SUSPENDA - (Código Respuesta: '+wrpTmp.CodigoRespuesta+') ' + wrpTmp.DescripcionRespuesta;
                lstOCtoUpdate.add(ocTmp);
            }
        }
        
        if(lstOCtoUpdate.size() > 0 ){
            update lstOCtoUpdate;
        }
            
  	}
*/
   	
    /**********************************************
     * Metodo encargado de asignar las fechas de reconexión
     **********************************************/
   	public void asignarFechaReconexion(){
        System.debug('=== asignarFechaReconexion ===');
   		String strFecha;
   		String[] lstTmp;
   		for(ActivoETB_Wrapper objW : lstActivosSeleccionados){
            System.debug('objW.strFechaSeleccionada: ' + objW.strFechaSeleccionada);
   			strFecha 		= objW.lstFechas.get((Integer.valueOf(objW.strFechaSeleccionada)-1)).getLabel();
   			System.debug('\n\n@@@@strFecha--------> ' + strFecha + '\n\n');
   			lstTmp 	= strFecha.split('/');
				
			objW.dtFechaReconexion = Date.newInstance(Integer.valueOf(lstTmp[2]), Integer.valueOf(lstTmp[1]), Integer.valueOf(lstTmp[0]));
   			
   		}
	}
    
    
    /**********************************************
     * Metodo encargado de crear un ActivoETB_Wrapper 
     * a partir de un ActivoETB
     **********************************************/
    private ActivoETB_Wrapper createActivoWrapper(ActivoETB__c a, Boolean checked){
        ActivoETB_Wrapper aw = new ActivoETB_Wrapper(a, checked);
        
        aw.intCantPeriodos = (intParamNumeroDias - asInteger(aw.activo.LTE_Dias_suspendidos__c)) / 30;
        
        return aw;
    }
    
    
     /**********************************************
     * Retorna el valor en entero
     **********************************************/
    private Integer asInteger (Decimal o){
        if(o == null){
            return 0;
        }else{
          	return o.intValue();
        }
    }
    
    
    /****************************************************************************
    * Clase  usada para encapsular una Operacion Comercial y un Detalle de Oferta
    * para ser usadas en el proceso de generacion de detales de oferta en el cambio de plan.
    ****************************************************************************/
    public class WrapperOCxDO{
    	public OperacionComercial__c objWOC;
    	public OperacionComercial__c objWOCRec;    	
    }  
    
    
    public class ActivoETB_Wrapper 	
    {
		public Boolean checked 				{get; set;}
	    public Boolean desactivado			{get; set;}
	    public ActivoETB__c activo 			{get; set;}
	    public String strFechaCiclo			{get; set;}
	    public List<Selectoption> lstFechas	{get; set;}
	    public String strFechaSeleccionada	{get; set;}
	    public String strMensaje			{get; set;}
	    public Date dtFechaReconexion		{get; set;}
        public Date dtFechaCiclo			{get; set;}
        public Date dtFechaSuspensionManual	{get; set;}
        public Date dtFechaReconexionManual	{get; set;}
        public Boolean validadoSuspenda		{get; set;}
        public Boolean fechaPersonalizada   {get; set;}
        public String strRespuestaSuspenda	{get; set;}
        public String codigoRespuestaSuspenda{get; set;}
        public String strMensajeRespuestaSuspenda{get; set;} //[FSARASTY, 22/01/2018]: Se incluye variabla para contener el mensaje descriptivo de la integración con suspenda
        
        //Cantidad de periodos
        public Integer intCantPeriodos      {get; set;}
        
        public ActivoETB_Wrapper(){
            activo = new ActivoETB__c();
            lstFechas	= new List<Selectoption>();
       }
    
	    public ActivoETB_Wrapper(ActivoETB__c a){
	        activo 		= a;
	        checked 	= false;
	        desactivado = false;	        
	        lstFechas	= new List<Selectoption>();
	    }
	    
	    public ActivoETB_Wrapper(ActivoETB__c a, Boolean check){
	        activo  	= a;
	        checked 	= check;
	        desactivado = false;
	        lstFechas	= new List<Selectoption>(); 
	    }
	    
	    public void desactivar(){
	    	desactivado = true;
	    	strMensaje	= 'No cumple con las condiciones';
	    }
        
	    public void activar(){
	    	desactivado = false;
	    	strMensaje	= 'Correcto';
	    }
	}
	
}