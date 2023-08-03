/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de adicion de SVA's de Roaming

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-02-17      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_AdicionSVA_Roaming_ctr {
        
    private Apexpages.Standardcontroller stdController;
    public Boolean blnBuscar                                    {get; set;}
    public Boolean blnBotonRegresar                             {get; set;}
    public Boolean blnBloqueServicios                           {get; set;}
    public Boolean blnBotonGuardar                              {get; set;}
    public Boolean blnBotonCerrar                               {get; set;}
    public Boolean blnAllChecked                                {get; set;}
    public Boolean blnPlanHomogeneo                             {get; set;}
    public String numerosConexion                               {get; set;}
    public String numeroCaso                                    {get; set;}
    public String strNivelId                                    {get; set;}
    public String strNivel                                      {get; set;}
    public String strInfoParam                                  {get; set;}
    public Integer intCantidadReg                               {get; set;}
    public Integer intIndex                                     {get; set;}
    public Boolean isChecked                                    {get; set;}
    public Boolean isAllChecked                                 {get; set;}
    public LTE_RoamingWrapper objRoaming                        {get; set;}
    private Map<Id, SubPlanFacturacion__c> mpSubPlanes;
    private Map<string, LTE_SVA__c> mapSVA;
    private List<String> lstTipoSubPlan;
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
    
    
    /** Variables para paginacion */
    public ApexPages.StandardSetController con                    {get;set;}
    public List<LTE_ActivoETB_Wrapper> lstActivosWrapper          {get;set;}
    public Boolean blnHayDatos                                    {get;set;}
    public Boolean blnmostrarPrimero                              {get;set;}
    public Boolean blnmostrarUltimo                               {get;set;}
    
    Set<Id> selectedRecordIds;
    map<Id, LTE_FechasRoamingWrapper> mpFechas;
    public List<ActivoETB__c> lstActivos;
    Integer numeroRegistros;
    /***************************/
    
    private Map<string,VariablesGlobales__c> vGlobal;
    
    /**
    * Constructor del controlador
    */
    public LTE_AdicionSVA_Roaming_ctr(ApexPages.StandardController stdController){
        this.stdController = stdController;
        this.blnBuscar = true;
        this.blnBotonRegresar = false;
        this.blnBloqueServicios = false;
        this.blnBotonGuardar = false;
        this.blnBotonCerrar = false;
        this.blnAllChecked = false;
        this.blnPlanHomogeneo = true;
        this.isChecked = false;
        this.isAllChecked = false;
        this.numerosConexion = '';
        this.strNivelId = '';
        this.strNivel = '';
        this.strInfoParam = '';
        this.intCantidadReg = 0;
        this.intIndex = -1;
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
            this.mpFechas = new map<Id, LTE_FechasRoamingWrapper>();
            this.objRoaming = new LTE_RoamingWrapper();
        
        if(this.idCase == null){
			System.debug('=======> El parametro LTEAdicionSVA_Roaming.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
			parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
			return;
        }
        
        if(this.idAccount == null){
			System.debug('=======> El parametro LTEAdicionSVA_Roaming.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
			parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
			return;
        }
        
        if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
			System.debug('=======> El parametro LTEAdicionSVA_Roaming.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
			parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
			return;
        }
        
        List<Contact> lstContactos = new  List<Contact>();
        lstContactos = [SELECT Id, LTE_RolLTE__c FROM Contact WHERE Id = :this.idContact];
        System.debug('=======> ' + lstContactos);
        if(lstContactos.isEmpty()){
			System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
			parametroInvalido(Label.LTE_Caso_Sin_Contacto);
			return;
        }
        
        if(!validaRolRoaming(lstContactos.get(0).LTE_RolLTE__c)){
			System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTEAddRoaming').valor__c+' en el Rol LTE.');
			parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
			return;
        }
        
		mpSubPlanes = new map<Id, SubPlanFacturacion__c>([SELECT Id, LTE_Precio__c, Name FROM SubPlanFacturacion__c ]);
		
		lstTipoSubPlan = new List<String>();
		for(LTE_SVA__c sva : mapSVA.values()){
			if(sva.LTE_Familia__c == 'Roaming'){
				lstTipoSubPlan.add(sva.Name);
			}
		}
		
		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.LTE_Msj_Add_Roaming));
                
    }
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolRoaming(String rolContacto){
        String rolesLTE;
		String[] rolesLTESeparados;
		list<String> lstRolesLTE;
		
		if(String.isEmpty(rolContacto)){
			return false;
		}
		
		rolesLTE = vGlobal.get('RolLTEAddRoaming').valor__c;
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
    * Metodo usado para abrir y obtener el subplan de Roaming.
    */
        public string getURLRoaming(){
        Schema.DescribeSObjectResult r = SubPlanFacturacion__c.sObjectType.getDescribe();
        return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where LTE_TipoSubplan__c =\'SVA-Roaming\' ')+'&f='+filtro_cls.codificar(',Name,LTE_TipoSubplan__c')+'&nom='+filtro_cls.codificar('SVA,Tipo SVA')+'&infoParam=Roaming';  
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
				Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, 
				(SELECT name,Estado__c,TOPP__r.TipodeOperacionporplan__c, Categoria__c  FROM Operaciones_Comerciales__r WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento')), 
				(SELECT Id, Name FROM Servicios_adicionales__r WHERE LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c IN :lstTipoSubPlan AND LTE_ServiceActionCode__c NOT IN ('ELIMINADO', 'DELETE'))
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
		set<Id> setIdOcs = new set<Id>();
		map<Id, OperacionComercial__c> mpOC;
		OperacionComercial__c objOC;
		LTE_Servicios_adicionales__c objSARoaming;
		LTE_FechasRoamingWrapper objFechasRoaming;
		
		Savepoint sp = Database.setSavepoint();
		
		if(this.objRoaming.IdRoaming == null){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Seleccione_Roaming));
			return null;
		}
		
		if(!verificarSeleccionados()){
			return null;
		}
		
		if(selectedRecordIds.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Seleccionar_Activo_SVA));
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
			objFechasRoaming = new LTE_FechasRoamingWrapper();
			for(ActivoETB__c objActivo : lstActivosSeleccionados){
				objFechasRoaming = this.mpFechas.get(objActivo.Id);
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
				objOC.FechaInicioReconexion__c = Date.today();
				objOC.Categoria__c = 'Roaming';
                if(objFechasRoaming.fechaFin != null){
                    objOC.FechaFinSuspencion__c = objFechasRoaming.fechaFin;
                }
				lstOC.add(objOC);
				//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjOC = \'' + objOC.Id + '\';'));
			}
			
			insert lstOC;
			
			mpOC = new map<Id, OperacionComercial__c>();
			for(OperacionComercial__c objOCAux : lstOC){

				objSARoaming = new LTE_Servicios_adicionales__c();
				objSARoaming.Name = mpSubPlanes.get(this.objRoaming.IdRoaming).Name;
				objSARoaming.LTE_Operacion_Comercial_SVA__c = objOCAux.Id;
				objSARoaming.LTE_SubPlaFacturacion__c = this.objRoaming.IdRoaming;
				lstSA.add(objSARoaming);
				
				mpOC.put(objOCAux.Id, objOCAux);
				setIdOcs.add(objOCAux.Id);
			}
			
			insert lstSA;
			
			Case caso = new Case(Id = this.idCase);
			caso.Aprobaciones__c = 'Oferta Realizada';
			update caso;
		
			LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
				
			// Parametrizar Servicios adicionales y  generar XA's
			LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcs,'OCSVA');
			
			objFechasRoaming = new LTE_FechasRoamingWrapper();
			for(LTE_Servicios_adicionales__c objSA : lstSA){
				objOC = new OperacionComercial__c();
				objOC = mpOC.get(objSA.LTE_Operacion_Comercial_SVA__c);
				objFechasRoaming = this.mpFechas.get(objOC.Activo__c);
				for(LTE_SpecificationGroupXA__c objSGXA : wrData.SpgXA){
					if(objSA.Id == objSGXA.LTE_ServiciosAdicionales__c && objSGXA.Name == 'FECHA INICIAL ROAMING'){
						objSGXA.LTE_Value__c = dateToString(objFechasRoaming.fechaInicio);
					}
					
					if(objFechasRoaming.fechaFin != null && objSA.Id == objSGXA.LTE_ServiciosAdicionales__c && objSGXA.Name == 'FECHA FINAL ROAMING'){
						objSGXA.LTE_Value__c = dateToString(objFechasRoaming.fechaFin);
					}
				}
			}
			
			// Actualizar servicios adicionales
			update wrData.servAD;   
			
			// Insertar XA's
			insert wrData.SpgXA;
			
			envioInmediato(setIdOcs);
	
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
    * Metodo encargado de enviar el aprovisionamiento en-linea
    */
    public void envioInmediato(set<id> setIdOcs){
        LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
		batchA.idImediato = setIdOcs;
        ID batchprocessid = Database.executeBatch(batchA, 1);
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
    * Metodo encargado de seleccionar todos los checkbox de la lista Activos cuando se
    * clic en la casilla de la cabecera de los checkbox
    */
    public PageReference seleccionarTodos(){
        blnAllChecked = isAllChecked;
        for (LTE_ActivoETB_Wrapper aw : lstActivosWrapper) {
            if(!aw.desactivado){
                aw.checked = this.isAllChecked;
                aw.requeridoFechaInicio = this.isAllChecked;
            }
        }               
                
        verificarSeleccionados();
        return null;
    }
    
    public PageReference seleccionarUno(){
        for (LTE_ActivoETB_Wrapper aw : lstActivosWrapper) {
			if(aw.Index == intIndex){
				aw.requeridoFechaInicio = isChecked;
				aw.checked = isChecked;
			}
        }
        return null;
    }
    
    /**
        * Metodo encargado de asignar el valor del subplan de Roaming seleccionado
        */
    public PageReference actualizarRoaming(){
		this.objRoaming.IdRoaming = strNivelId;
		this.objRoaming.NameRoaming = strNivel;
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
    * Metodo encargado de convertir una fecha en Date a String
    */
    public String dateToString(Date fecha){
        if(fecha != null){
			Datetime dt = datetime.newInstance(fecha.year(), fecha.month(), fecha.day());
			return dt.format('dd/MM/yyyy');
        }
        return null;
    }
    
    /***********************************************************************************
                                                        METODOS PARA LA PAGINACION
    ************************************************************************************/
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<LTE_ActivoETB_Wrapper> obtenerActivosLTE() {
        lstActivosWrapper = new List<LTE_ActivoETB_Wrapper>();
        LTE_ActivoETB_Wrapper activoWrapper;
        LTE_FechasRoamingWrapper fechaW;
        Integer noSeleccionados = 0;
        Integer index = 0;
        
        for (ActivoETB__c activo : (List<ActivoETB__c>)con.getRecords()){
			index++;
            if(selectedRecordIds.contains(activo.Id)){
                activoWrapper = new LTE_ActivoETB_Wrapper(activo, true);
                if(!activo.Servicios_adicionales__r.isEmpty()){
                        activoWrapper.desactivar();
                }
                /*for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
					if(oc.Categoria__c == 'Roaming'){
						activoWrapper.desactivar();
					}
                }*/
                
				if(mpFechas.containsKey(activo.Id)){
					fechaW = mpFechas.get(activo.Id);
					activoWrapper.objOpComercial.FechaInicioSuspencion__c = fechaW.fechaInicio;
					activoWrapper.objOpComercial.FechaFinSuspencion__c = fechaW.fechafin;
				}
                activoWrapper.index = index;
                lstActivosWrapper.add(activoWrapper);
            }
            else{
                activoWrapper = new LTE_ActivoETB_Wrapper(activo);
                if(!activo.Servicios_adicionales__r.isEmpty()){
					activoWrapper.desactivar();
                }
                /*for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
					if(oc.Categoria__c == 'Roaming'){
						activoWrapper.desactivar();
					}
                }*/
                if(mpFechas.containsKey(activo.Id)){
					fechaW = mpFechas.get(activo.Id);
						activoWrapper.objOpComercial.FechaInicioSuspencion__c = fechaW.fechaInicio;
						activoWrapper.objOpComercial.FechaFinSuspencion__c = fechaW.fechafin;
					}
                activoWrapper.index = index;
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
         if(verificarSeleccionados()){
			 con.first();
			 obtenerActivosLTE();
         }
    }

     // returns the last page of records
     public void last() {
        if(verificarSeleccionados()){
			con.last();
			obtenerActivosLTE();
        }
    }

     // returns the previous page of records
     public void previous() {
        if(verificarSeleccionados()){
			con.previous();
			obtenerActivosLTE();
        }
    }

     // returns the next page of records
     public void next() {
        if(verificarSeleccionados()){
			con.next();
			obtenerActivosLTE();
        }
    }

    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
     
	 //Metodo encargado de mantener los objetos seleccionados
    public boolean verificarSeleccionados(){
        LTE_FechasRoamingWrapper fechaw;
        for (LTE_ActivoETB_Wrapper aw : lstActivosWrapper) {
			if(aw.checked && aw.objOpComercial.FechaInicioSuspencion__c == null){
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Por favor seleccione almenos la fecha de inicio del Roaming para la linea ' + aw.activo.NumeroConexion__c));
				return false;
			}
			
			if(selectedRecordIds.contains(aw.activo.Id)){
				if (!aw.checked){
					selectedRecordIds.remove(aw.activo.Id);
					mpFechas.remove(aw.activo.Id);
				} else{
					mpFechas.remove(aw.activo.Id);
					fechaw = new LTE_FechasRoamingWrapper();
					fechaw.idActivo = aw.activo.Id;
					fechaw.fechaInicio = aw.objOpComercial.FechaInicioSuspencion__c;
					fechaw.fechafin = aw.objOpComercial.FechaFinSuspencion__c;
					mpFechas.put(aw.activo.Id, fechaw);
				}
			} else{
				if (aw.checked){
					selectedRecordIds.add(aw.activo.Id);
					fechaw = new LTE_FechasRoamingWrapper();
					fechaw.idActivo = aw.activo.Id;
					fechaw.fechaInicio = aw.objOpComercial.FechaInicioSuspencion__c;
					fechaw.fechafin = aw.objOpComercial.FechaFinSuspencion__c;
					mpFechas.put(aw.activo.Id, fechaw);
				}
			}
         }
         
         return true;
    }
    
    /***********************************************************************************/
    

	public class LTE_ActivoETB_Wrapper {
	
		public Boolean checked                              {get;set;}
		public Boolean desactivado                          {get;set;}
		public Boolean requeridoFechaInicio                 {get;set;}
		public Integer index                                {get;set;}
		public ActivoETB__c activo                          {get;set;}
		public OperacionComercial__c objOpComercial         {get;set;}
		public String mensajeError                          {get;set;}
	
		public LTE_ActivoETB_Wrapper(ActivoETB__c a){
			activo = a;
			checked = false;
			desactivado = false;
			requeridoFechaInicio = false;
			objOpComercial = new OperacionComercial__c();
		}
		
		public LTE_ActivoETB_Wrapper(ActivoETB__c a, Boolean check){
			activo = a;
			checked = check;
			desactivado = false;
			requeridoFechaInicio = check;
			objOpComercial = new OperacionComercial__c();
		}
		
		public void desactivar(){
			desactivado = true;
			mensajeError = Label.LTE_Msj_Roaming_Existente;
			requeridoFechaInicio = false;
		}
	
	}
	
	/**
	* Clase para almacenar las fechas seleccionadas en la adicion de Roaming
	*/
	public class LTE_FechasRoamingWrapper{
		public Id idActivo                      {get;set;}
		public Date fechaInicio                 {get;set;}
		public Date fechafin                    {get;set;}
	}
	
	/**
	* Clase para almacenar los datos del roaming seleccionado
	*/
	public class LTE_RoamingWrapper {
		public Id IdRoaming                     {get;set;}
		public String NameRoaming               {get;set;}
	}
        
        
}