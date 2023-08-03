/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Marwin H. Pineda Garzón
Proyecto:           LTE Fase II
Descripción:        Controlador de la Visualforce Suspensión Voluntaria

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2015-12-10      Marwin H. Pineda Garzón. (MHPG)               Creación de la clase.
1.1     2016-03-02      Manuel Cortes (MACP)                    - 
1.2		2017-11-20		Mauricio Farias Arias (MF)						se ajusta la linea 335 para incluir los codigos de respuesta 4 y 5
1.30	2018-01-22		Fernando Sarasty						- Se incluye la línea 605 para generar un valor predeterminado para el tag "Mensaje Respuesta Suspenda"
																- Se incluye el código entre la línea 620 a 626, para controlar el CodigoFlujo en cero(0) y presentar en la view el tag "DescripcionRespuest"
***********************************************************************************************************************/
public with sharing class LTE_ReconexionVoluntaria_ctr {
	
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
    public Boolean blnHayDatos			 					{get; set;}
    
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
    private String strTipo;
    
    public Integer intCicloFacturacion;
    public Date fechaCorteFinal;
    public Integer aniocorteInicial;
    public Integer mesCorteInicial;
    public Integer diaCorteInicial;
    public Date fechaCorteInicial;
    public Integer intNumDias;
	public String strFechaCorte;
	public Date dtFechaHoy = system.today();
    
	public Map<String, ActivoETB_Wrapper> mapActivoSeleccionado;
    public Set<Id> selectedRecordIds;
    public List<ActivoETB__c> lstActivos;
    
    /***************************/
    
    private Map<string,VariablesGlobales__c> vGlobal;
    
    public Map<String, date> mapOCXFechaCorte = new map<String, date>();
    
    /*******************************
     * Parametros generales
     *******************************/
    public Integer intParamNumeroVeces; 	
    public Integer intParamNumeroDias;
    public Integer intParamDiasPreviosSusp;
    public Integer intParamNumeroRegistros;
    
    public LTE_ReconexionVoluntaria_ctr(ApexPages.StandardController stdController){
    	
    	this.blnBuscar 				= true;
    	this.blnBotonContinuar		= false;
    	this.blnBloqueServicios		= false;
    	this.blnBotonGuardar 		= false;
    	this.blnAllChecked 			= false;
    	this.blnOcultarTabla		= true;
    	this.blnMostrarResultados	= false;
    	this.blnBotonRegresar		= false;
    	this.numerosConexion 		= '';
    	this.intCantidadReg 		= 0;
    	this.idCase 				= ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount 				= ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact 				= ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso 			= ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP 				= ApexPages.currentPage().getParameters().get('idTOPP');
    	this.strTipo 				= ApexPages.currentPage().getParameters().get('strTipo');
    	
    	this.vGlobal 				= VariablesGlobales__c.getAll();
    	
    	this.mapActivoSeleccionado	= new map<String, ActivoETB_Wrapper>();
     	
    	
    	//inicializacion de variables para paginacion
    	if(vGlobal.get('CambioPlanRegxPag').valor__c == null || vGlobal.get('CambioPlanRegxPag').valor__c.trim().length() == 0)
    	{
    		System.debug('=======> No se ha asignado el parámetro CambioPlanRegxPag en la configuración personalizada VariablesGlobales__c.');
    		parametroInvalido(Label.LTE_Mensaje_No_Paginacion);
    		return;
    	}
    	
    	
    	this.lstActivosWrapper 			= new List<ActivoETB_Wrapper>();
    	this.lstActivosSeleccionados	= new List<ActivoETB_Wrapper>();
    	this.blnHayDatos 				= false;
    	this.blnmostrarPrimero 			= false;
    	this.blnmostrarUltimo 			= false;
    	this.lstActivos 				= new List<ActivoETB__c>();
    	this.con 						= new ApexPages.StandardSetController(lstActivos);
	    this.selectedRecordIds 			= new Set<Id>();
    	
    	if(this.idCase == null)
    	{
    		System.debug('=======> El parametro LTECambioPlan.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.idAccount == null)
    	{
    		System.debug('=======> El parametro LTECambioPlan.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0)
    	{
    		System.debug('=======> El parametro LTECambioPlan.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	List<Contact> lstContactos 	= new  List<Contact>();
    	lstContactos 				= [SELECT 
    										Id, 
    										LTE_RolLTE__c 
    									FROM 
    										Contact 
    									WHERE 
    										Id = :this.idContact];
    	
    	if(lstContactos.isEmpty())
    	{
    		System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
    		parametroInvalido(Label.LTE_Caso_Sin_Contacto);
    		return;
    	}
    	
    	if(!validaRolReconexionVoluntaria(lstContactos.get(0).LTE_RolLTE__c))
    	{
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel Total en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
        
        this.intParamNumeroRegistros = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
    }
    
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolReconexionVoluntaria(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
        
   		rolesLTE = vGlobal.get('RolLTEReconexionVoluntaria').valor__c;
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
	public void buscarActivos(){
    	system.debug('=== buscarActivos ===');
   		if(numerosConexion == null || numerosConexion.trim().length() == 0 ){
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
   		
   		this.lstActivos =	[SELECT Id, Name, NombredelaCuenta__r.Name, NumeroConexion__c, Estado__c, LTE_Fecha_Ultima_Suspension__c, 
                            	CuentaFacturacion__r.LTE_CicloFacturacion__c, Plan__c, CuentaFacturacion__c,
                            	(SELECT Id, Name, Estado__c, TOPP__r.TipodeOperacionporplan__c  
                            	FROM Operaciones_Comerciales__r 
                            	WHERE Estado__c = 'En Curso')
                        	FROM ActivoETB__c
                        	WHERE NombredelaCuenta__c = :idAccount
                        	AND Plan__r.NombredelProducto__r.Name = :strProducto 
                        	AND NumeroConexion__c IN :setNumerosConexion
                        	AND Estado__c = 'Suspendido'
                        	AND LTE_Causal__c = 'Voluntaria'];
	                        
		system.debug('\n\n@@@@lstActivos----------> ' + lstActivos + '\n\n');
        
        establecerFechaSuspension();
        
        if(this.lstActivos.isEmpty()){
   			this.intCantidadReg 	= 0;
   			this.blnBotonContinuar 	= false;
	    	this.blnmostrarPrimero 	= false;
	    	this.blnmostrarUltimo 	= false;
	    	this.blnBloqueServicios = false;
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
   		}else{
   			this.blnBotonContinuar 	= true;
   			this.intCantidadReg 	= lstActivos.size();
	    	this.blnmostrarPrimero 	= true;
	    	this.blnBloqueServicios = true;
	    	if(this.lstActivos.size() > intParamNumeroRegistros){
	    		this.blnmostrarUltimo = true;
	    	}else{
	    		this.blnmostrarUltimo = false;
	    	}
	    	
   		}
   		
   		this.con = new ApexPages.StandardSetController(this.lstActivos);
        this.con.setPageSize(intParamNumeroRegistros);
        obtenerActivosLTE();
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
        		if(intCicloFacturacion != null){
	        		fechaCorteFinal 	= null;			
					fechaCorteInicial	= Date.newInstance(dtFechaHoy.year(),  dtFechaHoy.month(), intCicloFacturacion);
					
                    if(dtFechaHoy <= fechaCorteInicial){
	        			fechaCorteFinal = fechaCorteInicial;
	        			
	        			if(dtFechaHoy.daysBetween(fechaCorteFinal) < intParamDiasPreviosSusp){
	        				fechaCorteFinal = fechaCorteFinal.addMonths(1);	        				
	        			}	        			
					}else{
						fechaCorteFinal = fechaCorteInicial.addMonths(1);
						Datetime dt 	= fechaCorteFinal;
						strFechaCorte 	= dt.format('dd/MM/yyyy');
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
    
    
    /** 
    * Metodo encargado de consultar el boton guardar
    */
    /*public PageReference ocultarBotonGuardar()
    {
    	this.blnBotonGuardar = false;
    	return null;
    }*/
    
   /****************************************************************
    * Metodo ecargado construir el listado de servicios seleccionados
    * junto con sus respectivas detalles de oferta
    ****************************************************************/
    public void continuar(){
   		lstActivosSeleccionados = mapActivoSeleccionado.values();
   		String strTipoTramite;
   		
   		system.debug('\n\n@@@continuar---------> ' + '\n' + 
   			'@@@lstActivosSeleccionados-------> ' + lstActivosSeleccionados + '\n\n');
   		
   		if(!lstActivosSeleccionados.isEmpty()){
   			blnOcultarTabla 			= false;
   			blnBotonContinuar			= false;
   			blnMostrarResultados		= true;
            blnBotonRegresar        = true;
   			numerosConexion				= '';
   			blnBloqueServicios			= false;
   			blnBotonGuardar				= true;
   			strTipoTramite 				= cadenaTipoTramite(strTipo);
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
   		}
   		else{
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
       
    /*****************************************************************************
    * Metodo encargado de regresar a la pagina de seleccion de tramines para el
    * proceso de cambio de plan.
    *****************************************************************************/
    public PageReference regresar(){
		PageReference returnPage = Page.LTE_SeleccionTramiteCambioPlan_pag;
		returnPage.getParameters().put('scontrolCaching', '1');
		returnPage.getParameters().put('id', this.idCase);
		returnPage.setRedirect(true);
		return returnPage;    	
    }
    
    /***********************************************************************************
    * Metodo encargado de no mostrar y ocultar los botones necesario en caso
    *  que halla uno parametro nulo, adicionalmente muestra un mensaje indicando
    *  que ocurrio un error.
    ***********************************************************************************/
    private void parametroInvalido(String mensaje){
    	this.blnBuscar 			= false;
		this.blnBloqueServicios = false;
		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, mensaje));
    }
    
    /***********************************************************************************
    * Metodo encargado de seleccionar todos los checkbox de la lista Activos cuando se
    * clic en la casilla de la cabecera de los checkbox
    ***********************************************************************************/
    public PageReference seleccionarTodos(){
    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Seleccionar Todo'));
    	if(this.blnAllChecked){
	    	for (ActivoETB_Wrapper aw : lstActivosWrapper){
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
    	return null;
    }
    
	public PageReference selectRecords(){
    	for(ActivoETB_Wrapper objWrpActivo :lstActivosWrapper){
   			if(objWrpActivo.checked){
   				mapActivoSeleccionado.put(objWrpActivo.activo.Id, objWrpActivo);				   								
   			}else{
   				mapActivoSeleccionado.remove(objWrpActivo.activo.Id);
   			}  			
   		}
   		return null;
    }
    
    
    /***********************************************************************************
    							METODOS PARA LA PAGINACION
    ************************************************************************************/
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<ActivoETB_Wrapper> obtenerActivosLTE() {
    	system.debug('\n\n@@@@Entra a obtenerActivosLTE--------> \n\n');
        lstActivosWrapper = new List<ActivoETB_Wrapper>();
        ActivoETB_Wrapper activoWrapper;
        Integer noSeleccionados = 0;
        Datetime fechaDT;
        Datetime dtFechaReconexion;
        Date fecha;
        Date FechaReconexion;
        
        for (ActivoETB__c activo : (List<ActivoETB__c>)con.getRecords()){
        	fecha 				= mapOCXFechaCorte.get(activo.Id);
        	fechaDT 			= datetime.newInstance(fecha.year(), fecha.month(), fecha.day());
        	
        	FechaReconexion		= system.today().addDays(1);
        	dtFechaReconexion 	= datetime.newInstance(FechaReconexion.year(), FechaReconexion.month(), FechaReconexion.day());
        	
        	system.debug('\n\n@@@activo.Id-----> ' + activo.Id + '\n\n');
        	system.debug('\n\n@@@-----> ' + selectedRecordIds + '\n\n');
        	
            if(selectedRecordIds.contains(activo.Id)){
            	system.debug('\n\n@@@Entra selectedRecordIds----> \n\n');
            	activoWrapper = new ActivoETB_Wrapper(activo, true);
            	
            	activoWrapper.activar();
            	
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.TOPP__r.TipodeOperacionporplan__c.equals('Reconexión')){
            			activoWrapper.activar();
            		}
            	}
            	activoWrapper.strFechaCiclo 		= fechaDT.format('dd/MM/yyyy');
            	activoWrapper.strFechaReconexion 	= dtFechaReconexion.format('dd/MM/yyyy');
            	lstActivosWrapper.add(activoWrapper);
            }else{
            	activoWrapper = new ActivoETB_Wrapper(activo);
            	
            	if(activo.Operaciones_Comerciales__r.isEmpty()){
              		activoWrapper.activar();
              	}
            	
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.TOPP__r.TipodeOperacionporplan__c.equals('Reconexión')){
            			activoWrapper.activar();
            		}
            	}
            	activoWrapper.strFechaCiclo 		= fechaDT.format('dd/MM/yyyy');
            	activoWrapper.strFechaReconexion 	= dtFechaReconexion.format('dd/MM/yyyy');
            	lstActivosWrapper.add(activoWrapper);
            	noSeleccionados++;
            }
        }
        
        if(noSeleccionados > 0){
        	this.blnAllChecked = false;
        }else{
        	this.blnAllChecked = true;
        }

        return lstActivosWrapper;
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext{
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
   	}

    // returns the last page of records
    public void last(){
    	verificarSeleccionados();
        con.last();
        obtenerActivosLTE();
	}

    // returns the previous page of records
    public void previous(){
     	verificarSeleccionados();
    	con.previous();
        obtenerActivosLTE();
    }

    // returns the next page of records
    public void next(){
     	verificarSeleccionados();
        con.next();
        obtenerActivosLTE();
    } 
    
	//Metodo encargado de mantener los objetos seleccionados
    public void verificarSeleccionados(){
    	System.debug('=== verificarSeleccionados ===');
    	
    	for (ActivoETB_Wrapper aw : lstActivosWrapper){
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
    

    
    /****************************************************************************
    * Metodo encargado de generar y almacenar todos los datos para procesar la 
    * transaccion de cambio de plan.
    ****************************************************************************/
    public void guardarOC(){
    	System.debug('=== guardarOC ===');
    	OperacionComercial__c ocNueva = null;
    	OperacionComercial__c ocDeclinada = null;
    	OperacionComercial__c ocVacia = null;
    	ActivoETB_Wrapper objWrapper;
    	List<OperacionComercial__c> lstElementsToInsert = new List<OperacionComercial__c>();
        List<OperacionComercial__c> lstElementsToUpdate = new List<OperacionComercial__c>();
        List<OperacionComercial__c> lstOC = null;
        Set<String> setOCs = new set<String>();
    	
        List<TOPP__c> lstTOPPRec	= [SELECT Id, Tipoderegistro__c, TipodeOperacionporplan__c FROM TOPP__c WHERE Name = 'Reconexión- TELEFONIA MOVIL (LTE)'];
   		String strTOPPRec			= lstTOPPRec.get(0).Tipoderegistro__c;
   		Id idTOPPRec				= lstTOPPRec.get(0).Id;
   		Id recordTypeIdRec			= [SELECT Id FROM RecordType WHERE DeveloperName = :strTOPPRec].Id;
   		
   		//asignarFechaReconexion();
   		
   		system.debug('\n\n@@lstActivosSeleccionados---> ' + lstActivosSeleccionados + '\n\n');
   		
   		for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
            if(obj.validadoSuspenda){	
                for(ActivoETB__c objActivoRec :lstActivos){
                    system.debug('\n\n@@@objActivoRec.Id--------> ' + objActivoRec.Id + '\n' + 
                        '@@@obj.activo.Id----------> ' + obj.activo.Id + '\n\n');
                    
                    if(objActivoRec.Id == obj.activo.Id){
                        system.debug('\n\nEntra 1-------> ' + objActivoRec.Operaciones_Comerciales__r.size() + '\n\n');
                        
                        if(!objActivoRec.Operaciones_Comerciales__r.isEmpty()){
                            system.debug('\n\nEntra 2-------> \n\n');
                            for(OperacionComercial__c objOC : objActivoRec.Operaciones_Comerciales__r){
                                system.debug('\n\n@@@Val1-----> ' + objOC.TOPP__r.TipodeOperacionporplan__c.equals('Reconexión') + '\n' + 
                                    '@@@Val2-----> ' + objOC.Estado__c.equals('En Curso') + '\n\n');
                                if((objOC.TOPP__r.TipodeOperacionporplan__c.equals('Reconexión')) && (objOC.Estado__c.equals('En Curso'))){
                                    system.debug('\n\nEntra 3-------> \n\n');
                                    setOCs.add(objOC.Id);
                                }
                            }
                        }else{
                            system.debug('\n\nEntra 4-------> \n\n');
                            ocVacia 							= new OperacionComercial__c();
                            ocVacia.CuentaCliente__c 			= this.idAccount;
                            ocVacia.TOPP__c 					= idTOPPRec;
                            ocVacia.RecordTypeId				= recordTypeIdRec;
                            ocVacia.TipoSuspension__c			= strTipo;
                            ocVacia.Activo__c					= obj.activo.Id;
                            ocVacia.Plan__c						= obj.activo.Plan__c;
                            ocVacia.FechaInicioReconexion__c	= System.today().addDays(1);//objOpCom.dtFechaReconexion;
                            ocVacia.CuentaFacturacion__c		= obj.activo.CuentaFacturacion__c;
                            ocVacia.Caso__c						= this.idCase;
                            ocVacia.Estado__c					= 'En Curso';
                            
                            lstElementsToInsert.add(ocVacia);
                        }
                    }
                }
        	}
    	}
    	
    	lstOC = [SELECT Id, Name, Activo__c, Activo__r.Plan__c, Activo__r.CuentaFacturacion__c 
    				FROM OperacionComercial__c WHERE Id IN :setOCs];

		system.debug('\n\n@@@lst----------> ' + lstOC + '\n\n');

    	for(OperacionComercial__c objOpCom :lstOC){
	 		ocDeclinada 			= new OperacionComercial__c();
		    ocDeclinada.Estado__c	= 'Declinada';
		    ocDeclinada.Id			= objOpCom.Id;
		    
		    ocNueva 							= new OperacionComercial__c();
			ocNueva.CuentaCliente__c 			= this.idAccount;
			ocNueva.TOPP__c 					= idTOPPRec;
		    ocNueva.RecordTypeId				= recordTypeIdRec;
		    ocNueva.TipoSuspension__c			= strTipo;
		    ocNueva.Activo__c					= objOpCom.Activo__c;
		    ocNueva.Plan__c						= objOpCom.Activo__r.Plan__c;
		    ocNueva.FechaInicioReconexion__c	= System.today().addDays(1);	//objOpCom.dtFechaReconexion;
		    ocNueva.CuentaFacturacion__c		= objOpCom.Activo__r.CuentaFacturacion__c;
		    ocNueva.Caso__c						= this.idCase;
		    ocNueva.Estado__c					= 'En Curso';
	
			lstElementsToUpdate.add(ocDeclinada);
            lstElementsToInsert.add(ocNueva);
    	}
    	
		insert lstElementsToInsert;
        update lstElementsToUpdate;
        
        /*
        //Se mandan a registrar las OC con codigo de respuesta 2
        Set<String> setIdToRegistrarSuspenda = new Set<String>();
        Set<Id> setIdToUpdateServicio = new Set<Id>();
        
        for(OperacionComercial__c ocTmp :lstElementsToInsert){
            for(ActivoETB_Wrapper obj :lstActivosSeleccionados){
                if(obj.activo.id.equals(ocTmp.Activo__c) && '2'.equals(obj.codigoRespuestaSuspenda)){
                	setIdToRegistrarSuspenda.add(ocTmp.Id);
                }
                if(obj.activo.id.equals(ocTmp.Activo__c) && '1'.equals(obj.codigoRespuestaSuspenda)){
                	setIdToUpdateServicio.add(obj.activo.id);
                }
            }
        }
        
        //setIdToUpdateServicio contiene todas las OC que el codigo de respuesta de suspenda fue = 1, 
        //por ende se actualiza el estado del servicio a Activo
        System.debug('ESTOS SON LOS ActivoETB__c QUE SE DEBEN ACTIVAR: ' + setIdToUpdateServicio);
        List<ActivoETB__c> lstActivosETB = [SELECT Id, Estado__c FROM ActivoETB__c WHERE Id in :setIdToUpdateServicio];
        for(ActivoETB__c a : lstActivosETB){
            a.Estado__c =  'Activo';
        }
        
        if(lstActivosETB.size() > 0){
            System.debug('Se actualizan los sigueintes activos: ' + lstActivosETB);
            update lstActivosETB;
        }
        
        
        if(setIdToRegistrarSuspenda.size() > 0){
        	LTE_CreacionOperacionesComerciales_ctr.registrarSuspenda(setIdToRegistrarSuspenda);
        }
        */
        
        //Se valida con alguna de las listas para mostrar un mensaje diferente
        if(lstElementsToInsert.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No registraron cambios en las OC'));
			blnBotonRegresar = true;
			blnBotonGuardar  = false;
        }else{
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Proceso realizado con éxito'));
			blnBotonRegresar = true;
			blnBotonGuardar  = false;    
        }
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
    
    /****************************************************************************
    * Metodo encargado asignar la fecha de reconexion.
    ****************************************************************************/
    /*public void asignarFechaReconexion(){
   		String[] lstTmp;
   		for(ActivoETB_Wrapper objW : lstActivosSeleccionados){
   			//strFecha 				= objW.strFechaReconexion;//.get((Integer.valueOf(objW.strFechaReconexion)-1)).getLabel();
   			lstTmp 			= objW.strFechaReconexion.split('/');
			objW.dtFechaReconexion	= Date.newInstance(Integer.valueOf(lstTmp[2]), Integer.valueOf(lstTmp[1]), Integer.valueOf(lstTmp[0]));
   			
   		}
	}*()
    
    /****************************************************************************************
    * Clase usada para encapsular una un ActivoETB__c
    ****************************************************************************************/    
    public class ActivoETB_Wrapper {
        public Boolean checked 				{get; set;}
	    public Boolean desactivado			{get; set;}
	    public ActivoETB__c activo 			{get; set;}
	    public String strFechaCiclo			{get; set;}
	    public String strFechaReconexion	{get; set;}
	    public Boolean blnDisabled			{get; set;}
	    public String strMensaje	 		{get; set;}
        public Boolean validadoSuspenda		{get; set;}
        public String strRespuestaSuspenda	{get; set;}
        public String codigoRespuestaSuspenda{get; set;}
        public String strMensajeRespuestaSuspenda{get; set;} //[FSARASTY, 22/01/2018]: Se incluye variabla para contener el mensaje descriptivo de la integración con suspenda
        
        public Date dtFechaReconexion		{
            get{
                if(this.strFechaReconexion != null){
                	String[] lstTmp = this.strFechaReconexion.split('/');
             		return Date.newInstance(Integer.valueOf(lstTmp[2]), Integer.valueOf(lstTmp[1]), Integer.valueOf(lstTmp[0]));    
                }else{
                    return null;
                } 
        	}
            set;
        }
	
	    public ActivoETB_Wrapper(){
	    	activo 			= new ActivoETB__c();
	        checked 		= false;
	        desactivado 	= false;
	        blnDisabled		= true;
	    }
	
	    public ActivoETB_Wrapper(ActivoETB__c a){
	        activo 		= a;
	        checked 	= false;
	        desactivado = false;
	    }
	    
	    public ActivoETB_Wrapper(ActivoETB__c a, Boolean check){
	        activo  	= a;
	        checked 	= check;
	        desactivado = false;	        
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
    
    
    /****************************************************************************************
    * Clase  usada para encapsular una Operacion Comercial y un Detalle de Oferta
    * para ser usadas en el proceso de generacion de detales de oferta en el cambio de plan.
    ****************************************************************************************/
    public class WrapperOCxDO
    {
    	public OperacionComercial__c objWOC;
    	public OperacionComercial__c objWOCNueva;
    	public OperacionComercial__c objWOCVacia;    	
    } 
    
    
}