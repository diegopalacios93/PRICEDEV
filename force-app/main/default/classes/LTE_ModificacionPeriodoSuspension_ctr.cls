public class LTE_ModificacionPeriodoSuspension_ctr {
    
    public Boolean blnBuscar		 			{get; set;} //Indica si se muestra el boton de buscar
    public Boolean blnBotonContinuar 			{get; set;} //Indica si se muestra el boton de continuar
    public Boolean blnBloqueServicios 			{get; set;} //Indica si se muestra el bloque de servicios
    public Boolean blnBotonActualizar		    {get; set;} //Indica si se muestra el boton de actualizar
    public Boolean blnAllChecked				{get; set;} //Indica si se selecionaron todos los registros
    public Boolean blnOcultarTabla				{get; set;} //Indica si se oculta la tabla de servicios
    public Boolean blnMostrarResultados			{get; set;} //Indica si se muestra la tabla de resultados despues de "continuar"
    public Boolean blnBotonRegresar				{get; set;} //Indica si se muestra el boton de regresar
    public String numerosConexion	 			{get; set;} //Contiene los numeros de conexion ingresados desde la VF
    public String numeroCaso					{get; set;} //Muestra el numero del caso en la VF
    public Integer intCantidadReg				{get; set;} //Muestra la cantidad de registron en las tablas en las VF
     
    
    /*******************************
     * Parametros generales
     *******************************/
    private Id idCase;
    private Id idAccount;
    
    /** Variables para paginacion */
	public ApexPages.StandardSetController con				                	{get; set;}
    public List<ActivoSuspendidoETB_Wrapper> lstActivosSuspendidosWrapper		{get; set;}
    public List<ActivoSuspendidoETB_Wrapper> lstActivosSuspendidosSeleccionados	{get; set;}
    public Boolean blnmostrarPrimero						                	{get; set;}
    public Boolean blnmostrarUltimo			 				               		{get; set;}
	    
    
    public List<ActivoETB__c> lstActivosSuspendidos;
    public List<OperacionComercial__c> lstOperacionesComerciales;
    private Map<string,VariablesGlobales__c> vGlobal;
    public Set<Id> selectedRecordIds;
    public Map<String, ActivoSuspendidoETB_Wrapper> mapActivosSuspendidosSeleccionado;
    public Integer intParamNumeroRegistros; 
    public Date dtFechaHoy = System.today();
    public Set<Id> setOperacionesComercialesIds;
    public Map<Id, Date> mapOCsSeleccionado;
    
    /*************************************************
    	* Constructor de la clase
    ************************************************/
    public LTE_ModificacionPeriodoSuspension_ctr(ApexPages.StandardController stdController) {
        try{

		this.blnBuscar 				= true;
    	this.blnBotonContinuar		= false;
    	this.blnBloqueServicios		= false;
    	this.blnBotonActualizar		= false;
    	this.blnAllChecked 			= false;
    	this.blnOcultarTabla		= true;
    	this.blnMostrarResultados	= false;
    	this.blnBotonRegresar 		= false;
    	this.numerosConexion 		= '';
    	this.intCantidadReg 		= 0;
    	this.idCase 				= ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount 				= ApexPages.currentPage().getParameters().get('idAccount');
    	this.numeroCaso 			= ApexPages.currentPage().getParameters().get('caseNumber');
    	this.vGlobal 				= VariablesGlobales__c.getAll();
    	
    	//inicializacion de variables para paginacion
    	if(vGlobal.get('CambioPlanRegxPag').valor__c == null || vGlobal.get('CambioPlanRegxPag').valor__c.trim().length() == 0){
    		System.debug('=======> No se ha asignado el parámetro CambioPlanRegxPag en la configuración personalizada VariablesGlobales__c.');
    		return;
    	}
    	
    	this.intParamNumeroRegistros 			    = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
    	this.lstActivosSuspendidosWrapper	        = new List<ActivoSuspendidoETB_Wrapper>();
    	this.lstActivosSuspendidosSeleccionados	    = new List<ActivoSuspendidoETB_Wrapper>();
        this.setOperacionesComercialesIds           = new Set<Id>();
        this.mapOCsSeleccionado                     = new map<Id, Date>();
    	this.blnmostrarPrimero 			            = false;
    	this.blnmostrarUltimo 			            = false;
    	this.lstActivosSuspendidos 				    = new List<ActivoETB__c>();
    	this.con 						            = new ApexPages.StandardSetController(lstActivosSuspendidos);
	    this.selectedRecordIds 			            = new Set<Id>();
     	this.mapActivosSuspendidosSeleccionado   	= new map<String, ActivoSuspendidoETB_Wrapper>();
    	
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
         
        }catch(Exception e){
            System.debug('ERROR: ' + e.getStackTraceString());
            throw e;
        }
    	
    }
    
    /********************************************************************************************
    * Metodo encargado de buscar los servicios asociados a los números de conexión digitados.
    ********************************************************************************************/
    public void buscarSuspendidos() {
    	system.debug('=== buscarSuspendidos ===');
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
        
        this.lstActivosSuspendidos = 	[SELECT Id, Name, NombredelaCuenta__r.Name, NumeroConexion__c, Estado__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, 
										LTE_Fecha_Ultima_Suspension__c, LTE_Numero_veces_suspendido__c, LTE_Dias_suspendidos__c, LTE_Fecha_Ultima_Reconexion__c,
										Fecha_Activacion__c, LTE_Fecha_Final_Contrato__c, Plan__c,CuentaFacturacion__c,
											(SELECT Id, Name, FechaInicioReconexion__c
											FROM Operaciones_Comerciales__r 
											WHERE TOPP__r.TipodeOperacionporplan__c = 'Reconexión'
											AND TipoSuspension__c = 'Voluntaria'
											Order By createdDate desc Limit 1)
										FROM ActivoETB__c
										WHERE NombredelaCuenta__c = :this.idAccount
										AND Plan__r.NombredelProducto__r.Name = :strProducto 
										AND NumeroConexion__c IN :setNumerosConexion 
										AND Estado__c = 'Suspendido'
										AND Plan__r.LTE_TipoControl__c != 'Prepago'
										AND Plan__r.TipodePlan__c != 'Troncal SIP'];    
	                        
		system.debug('\n\n@@@@lstSuspendidos----------> ' + lstActivosSuspendidos + '\n\n');	                        
       
        if(this.lstActivosSuspendidos.isEmpty()) {
   			this.intCantidadReg 	= 0;
   			this.blnBotonContinuar 	= false;
	    	this.blnmostrarPrimero 	= false;
	    	this.blnmostrarUltimo 	= false;
	    	this.blnBloqueServicios = false;
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
   		} else { 
   			this.blnBotonContinuar 	= true;
   			this.intCantidadReg 	= lstActivosSuspendidos.size();
	    	this.blnmostrarPrimero 	= true;
	    	this.blnBloqueServicios = true;
	    	
	    	if(this.lstActivosSuspendidos.size() > intParamNumeroRegistros) { 
	    		this.blnmostrarUltimo = true;
	    	} else {
	    		this.blnmostrarUltimo = false;
	    	}
   		}
   		
   		this.con = new ApexPages.StandardSetController(this.lstActivosSuspendidos);
        this.con.setPageSize(intParamNumeroRegistros);
        obtenerSuspendidosLTE();
    }
    
    /****************************************************************
    * Metodo ecargado construir el listado de servicios seleccionados
    * junto con sus respectivas detalles de oferta
    ****************************************************************/
    
    public void continuar(){
        
        System.debug('=== continuar ===');
   		lstActivosSuspendidosSeleccionados = mapActivosSuspendidosSeleccionado.values();
   		system.debug('\n\n@@@lstActivosSeleccionados---------> ' + lstActivosSuspendidosSeleccionados + '\n\n');
   		
        if(!lstActivosSuspendidosSeleccionados.isEmpty()){
   			blnOcultarTabla 		= false;
   			blnBotonContinuar		= false;
            blnBotonRegresar        = true;
   			blnMostrarResultados	= true;
   			blnBloqueServicios		= false;
   			blnBotonActualizar		= true;
            blnBuscar               = false;
            
            for (ActivoSuspendidoETB_Wrapper asw : lstActivosSuspendidosSeleccionados){
            	ActivoETB__c actSus = asw.suspendido;    
                mapOCsSeleccionado.put(actSus.Operaciones_Comerciales__r[0].Id, Date.valueOf(asw.dtNuevaFechaReconexion));
            }
            
            setOperacionesComercialesIds = new Set<Id>(mapOCsSeleccionado.keySet());
        	system.debug('setOperacionesComercialesIds' + setOperacionesComercialesIds);
        	lstOperacionesComerciales = [SELECT Id, FechaInicioReconexion__c, Caso__c, Comentarios__c, caso__r.CaseNumber  
										FROM OperacionComercial__c 
                                        WHERE Id IN : setOperacionesComercialesIds ];
            
   		}else{
 			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe escoger por lo menos un registro'));
 			blnOcultarTabla 	= true;
   			blnBotonContinuar	= true;
   			blnBuscar			= false;			  			
   		}      
    }
    
    public void verificarSeleccionados(){
    	for (ActivoSuspendidoETB_Wrapper asw : lstActivosSuspendidosWrapper) {
        	if(selectedRecordIds.contains(asw.suspendido.Id)){
        		if (!asw.checked){
        			selectedRecordIds.remove(asw.suspendido.Id);
        		}
        	}else{
        		if (asw.checked){
        			selectedRecordIds.add(asw.suspendido.Id);
        		}
        	}
     	}
	} 
    
    /****************************************************************
    * Metodo encargado de guardar las operaciones comerciales
    ****************************************************************/
    public void actualizarOC(){
     	System.debug('=== actualizarOC ===');
        String comentarioModificacion = ' Se modifica la fecha de inicio de la OC, a través del caso: ' + this.numeroCaso+'.';        
        system.debug('lstOperacionesComerciales' + lstOperacionesComerciales);
        
        if(!lstOperacionesComerciales.isEmpty()){
        	for (OperacionComercial__c oc : lstOperacionesComerciales){
                
                if(oc.Comentarios__c == null){
                    oc.Comentarios__c = comentarioModificacion ;
                } else{
                    oc.Comentarios__c = oc.Comentarios__c + comentarioModificacion;
                }
                oc.FechaInicioReconexion__c = mapOCsSeleccionado.get(oc.Id);
                oc.Caso__c = this.idCase;
        	}
        	system.debug('lstOperacionesComerciales' + lstOperacionesComerciales);           
            update lstOperacionesComerciales;
            
        	
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'OC Actualizada con éxito'));
			blnBotonRegresar     =  true;
			blnBotonActualizar	 = false;
		}
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
    		for (ActivoSuspendidoETB_Wrapper asw : lstActivosSuspendidosWrapper) {
	    		if(!asw.desactivado){
	    			asw.checked = true;
	    			if(asw.checked == true){
	    				mapActivosSuspendidosSeleccionado.put(asw.suspendido.Id, asw);
	    			}else{
	    				mapActivosSuspendidosSeleccionado.remove(asw.suspendido.Id);
	    			}
	    		}
	    	}
    	}else{
    		for (ActivoSuspendidoETB_Wrapper asw : lstActivosSuspendidosWrapper){
	    		asw.checked = false;
	    	}
    	}
    	//verificarSeleccionados();
    }
    
    /***********************************************************************************
    							METODOS PARA LA PAGINACION
    ************************************************************************************/
    
    	public List<ActivoSuspendidoETB_Wrapper> obtenerSuspendidosLTE(){
    	System.debug('=== obtenerActivosLTE ===');
    	lstActivosSuspendidosWrapper   = new List<ActivoSuspendidoETB_Wrapper>();
        Integer noSeleccionados	= 0;
    	ActivoSuspendidoETB_Wrapper suspendidoWrapper;
        Date fecha;
        Boolean isValid;
        Boolean isValidDiasSuspendidos;
        Boolean isValidNumeroVeces;
        Boolean isValidFechaContrato;
        
        for(ActivoETB__c activo : (List<ActivoETB__c>)con.getRecords()){
        	if(selectedRecordIds.contains(activo.Id)){
        		system.debug('\n\n@@@Entra1----> \n\n');
            	suspendidoWrapper = createSuspendidoWrapper(activo, true);
                suspendidoWrapper.activar();
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.TOPP__r.TipodeOperacionporplan__c.equals('Suspensión')){
                        suspendidoWrapper.desactivar();    
                    }
            	}
            }else{
            	suspendidoWrapper = createSuspendidoWrapper(activo, false);
                noSeleccionados++;                
            }            
            suspendidoWrapper.dtNuevaFechaReconexion = dtFechaHoy.addDays(1);
            lstActivosSuspendidosWrapper.add(suspendidoWrapper);   
        }
        
        if(noSeleccionados > 0) {
        	this.blnAllChecked = false;
        } else {
        	this.blnAllChecked = true;
        }
		
        return lstActivosSuspendidosWrapper;
    }
    
    /***********************************************************************************
    * Validar la fecha selecionada
    **********************************************************************************/ 
    public void validarFecha(){
		Boolean errorFecha = false;
        
    	for(ActivoSuspendidoETB_Wrapper objWrpActivoSuspendido :lstActivosSuspendidosWrapper){
        	if (objWrpActivoSuspendido.dtNuevaFechaReconexion <= dtFechaHoy){
    			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'En el servicio: ' + objWrpActivoSuspendido.suspendido.Name + ', La fecha de reconexión tiene que ser mayor al dia de hoy.'));
                errorFecha	= true;
            }
            if (objWrpActivoSuspendido.dtNuevaFechaReconexion == null){
    		   	errorFecha	= true;
            }
    	}
        blnBotonContinuar = !errorFecha;
    }
    
    /***********************************************************************************
    * Metodo que se ejecuta cuando se selecciona un registro
    ***********************************************************************************/
    public void selectRecords(){
    	System.debug('=== selectRecords ===');
    	for(ActivoSuspendidoETB_Wrapper objWrpActivoSuspendido :lstActivosSuspendidosWrapper){
   			if(objWrpActivoSuspendido.checked){
   				mapActivosSuspendidosSeleccionado.put(objWrpActivoSuspendido.suspendido.Id, objWrpActivoSuspendido);  
                system.debug('objWrpActivoSuspendido' + objWrpActivoSuspendido );
   			}else{
   				mapActivosSuspendidosSeleccionado.remove(objWrpActivoSuspendido.suspendido.Id);
   			}
   		}
        system.debug('mapActivosSuspendidosSeleccionado' + mapActivosSuspendidosSeleccionado );
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
       obtenerSuspendidosLTE();
   	}

    // returns the last page of records
    public void last() {
    	verificarSeleccionados();
        con.last();
        obtenerSuspendidosLTE();
	}

    // returns the previous page of records
    public void previous(){
    	verificarSeleccionados();
    	con.previous();
        obtenerSuspendidosLTE();
    }

    // returns the next page of records
    public void next(){
        verificarSeleccionados();
        con.next();
        obtenerSuspendidosLTE();
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
    
    /**********************************************
    * Metodo encargado de crear un SuspendidoETB_Wrapper 
    * a partir de un SuspendidoETB
    **********************************************/
    private ActivoSuspendidoETB_Wrapper createSuspendidoWrapper(ActivoETB__c s, Boolean checked){
        ActivoSuspendidoETB_Wrapper asw = new ActivoSuspendidoETB_Wrapper(s, checked);

        for(OperacionComercial__c oc : s.Operaciones_Comerciales__r){        		
    		asw.dtFechaReconexion    = DateTime.newInstance(oc.FechaInicioReconexion__c.year(), oc.FechaInicioReconexion__c.month(), oc.FechaInicioReconexion__c.day());
            asw.strFechareconexion   =  asw.dtFechaReconexion.format('dd/MM/yyyy');
        }        
        return asw;
    }
    
    /****************************************************************************
    * Clase  usada para encapsular una Operacion Comercial y un Detalle de Oferta
    * para ser usadas en el proceso de generacion de detales de oferta en el cambio de plan.
    ****************************************************************************/
    
    public class ActivoSuspendidoETB_Wrapper 	
    {
		public Boolean checked 				       {get; set;}
	    public Boolean desactivado			       {get; set;}
	    public ActivoETB__c suspendido		       {get; set;}
	    public String strFechaReconexion	       {get; set;}
	    public DateTime dtFechaReconexion	       {get; set;}
        public Date dtNuevaFechaReconexion	       {get; set;}
	    
	    public ActivoSuspendidoETB_Wrapper(ActivoETB__c a, Boolean check){
	        suspendido  	= a;
	        checked 	= check;
	        desactivado = false;
	    }
	    
	    public void desactivar(){
	    	desactivado = true;
	    }
        
	    public void activar(){
	    	desactivado = false;
	    }
	}
}