/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de servicios de cambio de plan para troncales SIP

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-01-27      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_ServiciosCambioPlanSIP_ctr {
	
	private Apexpages.Standardcontroller stdController;
	public Reserva__c objOfertaEconomica                    {get; set;}
	public OperacionComercial__c objOC						{get; set;}
	public Boolean blnBotonContinuar						{get; set;}
	public Boolean blnBloqueServicios						{get; set;}
	public Boolean blnBloquePlan							{get; set;}
	public Boolean blnBotonRegresar							{get; set;}
	public Boolean blnBuscar								{get; set;}
    public Boolean planActualAbierto						{get; set;}
    public Boolean planSeleccionadoAbierto 					{get; set;}
	public String numeroCaso								{get; set;}
	public String numerosConexion							{get; set;}
	public String estadoAprobacion							{get; set;}
	public String planActual								{get; set;}
	public Boolean blnIntegrarGestor						{get; set;}
	public String subPlanActual								{get; set;}
    public String tarifaMinutoAdicionalActual				{get; set;}
	public List<ActivoETB__c> lstActivos					{get; set;}
	
	private Map<Id, Planes__c> mpPlanes;
    private Map<Id, SubPlanFacturacion__c> mpSubPlanes;
    private Map<string,VariablesGlobales__c> vGlobal;
    private List<PlanFacturacion__c> lstPlanFacturacion;
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
	
	/**
	* Constructor de la clase.
	*/
	public LTE_ServiciosCambioPlanSIP_ctr(ApexPages.StandardController stdController){
        List<Opportunity> lstOportunidad;
		
		this.stdController = stdController;
		this.objOfertaEconomica = new Reserva__c();
		//Se pone este valor al tipo de plan para que el filtro del subplan funcione
		this.objOfertaEconomica.LTE_TipodePlan__c = 'Troncal SIP'; 
		this.objOC = new OperacionComercial__c();
		this.vGlobal = VariablesGlobales__c.getAll();
		this.blnBotonContinuar = false;
		this.blnBloqueServicios = false;
		this.blnBloquePlan = false;
		this.blnBotonRegresar = false;
		this.blnBuscar = true;
        this.planActualAbierto = false;
        this.planSeleccionadoAbierto = false;
		this.numerosConexion = '';
		this.lstActivos = new List<ActivoETB__c>();
        this.blnIntegrarGestor = true;
		
		this.idCase = ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact = ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
    	this.estadoAprobacion = ApexPages.currentPage().getParameters().get('estadoAprobacion');
    	
    	if(this.idCase == null){
    		System.debug('=======> El parametro LTECambioPlanSIP.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan SIP.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.idAccount == null){
    		System.debug('=======> El parametro LTECambioPlanSIP.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan SIP.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
    		System.debug('=======> El parametro LTECambioPlanSIP.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan SIP.');
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
    	
    	if(!validaRolCambioPlanSIP(lstContactos.get(0).LTE_RolLTE__c)){
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTECambioPlanSIP').valor__c+' en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
		
		mpPlanes = new map<Id, Planes__c>([SELECT Id,Tarifa__c,Name,LTE_PlanEstructurados__c,LTE_TipoControl__c,TipodePlan__c FROM Planes__c WHERE Estado__c = 'Activo']);
		mpSubPlanes = new map<Id, SubPlanFacturacion__c>([SELECT Id, LTE_Precio__c, Name, LTE_TipoSubplan__c FROM SubPlanFacturacion__c ]);
		lstPlanFacturacion = [SELECT Id, Name, Plan__c FROM PlanFacturacion__c];
	}
	
	/**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolCambioPlanSIP(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
   		
   		rolesLTE = vGlobal.get('RolLTECambioPlanSIP').valor__c;
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
    * Metodo ecargado de buscar los servicios asociados al numero de conexion digitado.
    */
    public PageReference buscar()
   	{
   		Boolean ocEnVuelo = false;
   		
   		if(numerosConexion == null || numerosConexion.trim().length() == 0 ){
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Digitar_Numero_Conexion_Cambio_Numero));
   			return null;
   		}
   		
   		this.blnBloqueServicios = true;
   		
    	String producto = vGlobal.get('NombreComercialLTE').valor__c;
   		
   		this.lstActivos = [SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,NumeroConexion__c,
   			Plan__r.NombredelProducto__r.Name, Plan__r.TipodePlan__c, Contrato__c, Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, 
   			CuentaFacturacion__r.LTE_CicloFacturacion__c, IMEI_del_Equipo__c, LTE_ICCID__c, LTE_DetalleOferta__c, LTE_DetalleOferta__r.Plan__c, 
   			LTE_DetalleOferta__r.Plan__r.Name, LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c, LTE_DetalleOferta__r.LTE_DatosNavegacion__r.Name, 
            LTE_DetalleOferta__r.Tarifa_Minuto_Adicional__c, LTE_DetalleOferta__r.Tarifa_Minuto_Adicional__r.Name, IDServicio__c,
   			(SELECT name,Estado__c,TOPP__r.TipodeOperacionporplan__c  FROM Operaciones_Comerciales__r WHERE Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento')) 
   		FROM ActivoETB__c 
   		WHERE NombredelaCuenta__c = :this.idAccount and Plan__r.NombredelProducto__r.Name = :producto AND ( Plan__r.TipodePlan__c = 'Troncal SIP' OR Plan__r.TipodePlan__c = 'Obsoletos') AND NumeroConexion__c = :numerosConexion AND Estado__c = 'Activo' Order By Name limit 1];
   		
   		if(this.lstActivos.isEmpty()){
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
	    	this.blnBotonContinuar = false;
	    	this.planActual = '';
			this.subPlanActual = '';
            this.tarifaMinutoAdicionalActual = '';
   		} else{
   			this.planActual = lstActivos.get(0).LTE_DetalleOferta__r.Plan__r.Name;
            this.planActualAbierto = this.planActual != null ? this.planActual.toLowerCase().contains('abierto') : false;
			this.subPlanActual = lstActivos.get(0).LTE_DetalleOferta__r.LTE_DatosNavegacion__r.Name;
            this.tarifaMinutoAdicionalActual = lstActivos.get(0).LTE_DetalleOferta__r.Tarifa_Minuto_Adicional__r.Name;
			
			/*List<LTE_Servicios_adicionales__c> lstSA = new List<LTE_Servicios_adicionales__c>();
			lstSA = [SELECT Id, Name, LTE_SubPlaFacturacion__c, LTE_SubPlaFacturacion__r.Name FROM LTE_Servicios_adicionales__c WHERE LTE_DetalleOfertaEReservadoRegContable__c = :lstActivos.get(0).LTE_DetalleOferta__c];
			if(!lstSA.isEmpty()){
				//this.subPlanActual = lstSA.get(0).LTE_SubPlaFacturacion__r.Name;
				
			} else{
				this.subPlanActual = 'No hay SubPlan';
			}*/
			
   			for(OperacionComercial__c oc : lstActivos.get(0).Operaciones_Comerciales__r){
        		if(oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio de Plan'){
        			ocEnVuelo = true;
        			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LTE_OC_Cambio_Numero_En_Vuelo + ' ' + numerosConexion));
        			break;
        		}
        	}
        	if(ocEnVuelo){
        		this.blnBloquePlan = false;
        	} else{
   				this.blnBloquePlan = true;
   				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.LTE_Msj_Troncal_SIP));
        	}
   		}
   		
		return null;
    }
	
	/**
	* Metodo encargado de validar si el plan seleccionado es de tipo 'Troncal SIP'
	*/
	public PageReference cambioPlan(){
		if(!String.isEmpty(this.objOfertaEconomica.LTE_Plan__c)){
            Planes__c planSeleccionado = this.mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c);
            
			if(planSeleccionado.TipodePlan__c != 'Troncal SIP') {
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Selelccionar_Plan_Troncal_SIP));
				this.blnBotonContinuar = false;
            } else {
                this.planSeleccionadoAbierto = planSeleccionado.Name.toLowerCase().contains('abierto');
                
                if(String.isEmpty(this.objOfertaEconomica.LTE_DatosNavegacion__c)) {
                    this.blnBotonContinuar = false;
                } else if(planSeleccionado.Name.toLowerCase().contains('abierto')
                	&& String.isEmpty(this.objOfertaEconomica.Tarifa_minuto_adicional__c)
                ) {
                    this.blnBotonContinuar = false;
                } else {
                    this.blnBotonContinuar = true;
                }
            }
        } else {
			this.blnBotonContinuar = false;
		}
		return null;
	}
	
	/**
	* Metodo encargado de generar la Data para el cambio de plan de troncal SIP.
	*/	
	public PageReference continuar(){
        List<Equipo__c> lstEquipos = new List<Equipo__c>();
		List<TOPP__c> lstTOPP = new List<TOPP__c>();
		List<RecordType> lstRecordType = new list<RecordType>();
		LTE_DetalleOferta__c objDetalleOferta;
		LTE_Servicios_adicionales__c objSAPlan;
		LTE_Servicios_adicionales__c objSADatos;
		Viabilidad__c objViabilidad;
		Decimal dcmValorTotal = 0;
		Integer intCicloFacturacion;
		Date fechaCorte;
        
		Savepoint sp = Database.setSavepoint();
		
		if(String.isEmpty(objOfertaEconomica.LTE_Plan__c)){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_Plan));
			return null;
		}
		
		if(String.isEmpty(objOfertaEconomica.LTE_DatosNavegacion__c)){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_SubPlan));
			return null;
		}

        Planes__c planSeleccionado = this.mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c);        
        if(planSeleccionado.Name.toLowerCase().contains('abierto')
        	&& String.isEmpty(objOfertaEconomica.Tarifa_minuto_adicional__c)
         ) {
         	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_Tarifa_Minuto_Adicional));
			return null;
         }
		
		lstEquipos = [SELECT Id FROM Equipo__c WHERE name = 'Equipo Traido'];
		
		if(lstEquipos.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Equipo_No_Encontrado));
			return null;
		}
		
		lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Id = :this.idTOPP];
		lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            
        if(lstRecordType.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
			return null;
		}            
		
		try{
			intCicloFacturacion = Integer.valueOf(lstActivos.get(0).CuentaFacturacion__r.LTE_CicloFacturacion__c);
		} catch(Exception e){
			intCicloFacturacion = -1;
			System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Servicio_Sin_Cuenta_Facturacion));
			return null;
		}
		
		fechaCorte = obtenerFechaCorte(intCicloFacturacion);
		
		if(fechaCorte == null){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Fecha_Corte_No_Calculada));
			return null;
		}
		
		dcmValorTotal = mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c).Tarifa__c + mpSubPlanes.get(this.objOfertaEconomica.LTE_DatosNavegacion__c).LTE_Precio__c;
		
		try{
			this.objOfertaEconomica.Equipo__c = lstEquipos.get(0).id;
			insert this.objOfertaEconomica;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjOfertaEconomica = \'' + this.objOfertaEconomica.Id + '\';'));
			
			objOC = new OperacionComercial__c();
    		objOC.CuentaCliente__c = this.idAccount;
    		objOC.Activo__c = lstActivos.get(0).Id;
    		objOC.NumeroConexion__c = lstActivos.get(0).NumeroConexion__c;
            objOC.IDServicio__c = lstActivos.get(0).IDServicio__c;
    		objOC.Plan__c = this.objOfertaEconomica.LTE_Plan__c;
    		objOC.TOPP__c = this.idTOPP;
    		objOC.PlanAnterior__c = this.planActual;
    		objOC.Estado__c = 'Pendiente';
    		objOC.RecordTypeId = lstRecordType.get(0).Id;
    		objOC.Caso__c = this.idCase;
    		objOC.Valor_Recurrente_ETB_Anterior__c = lstActivos.get(0).LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c;
    		objOC.ValorTarifaPlan__c = dcmValorTotal;
    		objOC.CuentaFacturacion__c = lstActivos.get(0).CuentaFacturacion__c;
    		objOC.FechaInicioReconexion__c = fechaCorte;
            if(blnIntegrarGestor){
                objOC.Integrar_con_gestor__c = blnIntegrarGestor;
            }
    		insert objOC;
    		//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjOC = \'' + objOC.Id + '\';'));
    		
    		objDetalleOferta = new LTE_DetalleOferta__c();
    		objDetalleOferta.LTE_OperacionComercial__c = objOC.Id;
    		objDetalleOferta.Plan__c = this.objOfertaEconomica.LTE_Plan__c;
    		objDetalleOferta.LTE_TipodePlan__c = 'Troncal SIP'; 
			objDetalleOferta.LTE_DatosNavegacion__c = this.objOfertaEconomica.LTE_DatosNavegacion__c;
            objDetalleOferta.Tarifa_minuto_adicional__c = this.objOfertaEconomica.Tarifa_minuto_adicional__c;
			objDetalleOferta.LTE_Oferta_Economica__c = this.objOfertaEconomica.id;
			objDetalleOferta.LTE_Cliente__c = this.idAccount;
			objDetalleOferta.LTE_NumeroLinea__c = lstActivos.get(0).NumeroConexion__c;
			objDetalleOferta.LTE_EquipoTraido__c = true;
			objDetalleOferta.LTE_Valor_Total_Plan__c = dcmValorTotal;
			insert objDetalleOferta;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjDetalleOferta = \'' + objDetalleOferta.Id + '\';'));
    		
    		objSAPlan = new LTE_Servicios_adicionales__c();
    		objSAPlan.Name = mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c).Name;
    		objSAPlan.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
    		objSAPlan.LTE_PlanFacturacion__c = obtenerPlanFacturacionId(objDetalleOferta.Plan__c);
			insert objSAPlan;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjSAPlan = \'' + objSAPlan.Id + '\';'));
			
			objSADatos = new LTE_Servicios_adicionales__c();
			objSADatos.Name = mpSubPlanes.get(this.objOfertaEconomica.LTE_DatosNavegacion__c).Name;
			objSADatos.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
			objSADatos.LTE_SubPlaFacturacion__c = this.objOfertaEconomica.LTE_DatosNavegacion__c;
			insert objSADatos;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjSADatos = \'' + objSADatos.Id + '\';'));
			
			objViabilidad = new Viabilidad__c();
			objViabilidad.OperacionComercial__c = this.objOC.Id;
			objViabilidad.RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByName().get(vGlobal.get('ViabilidadTroncalesSIP_LTE_CambioPlan').valor__c).getRecordTypeId();
			objViabilidad.EstadoViabilidad__c = 'Pendiente';
            if(!blnIntegrarGestor){
                insert objViabilidad;
            }
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Id idObjViabilidad = \'' + objViabilidad.Id + '\';'));
			
			Case caso = new Case(Id = this.idCase);
	    	caso.Aprobaciones__c = 'Oferta Realizada';
	    	update caso;
	    	
	    	LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
			set<Id> setIdOcs = new set<Id>();
			
			setIdOcs.add(objOC.Id);
			
			// Parametrizar Servicios adicionales y  generar XA's
			LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcs,'OC');
			
			// Actualizar servicios adicionales
			update wrData.servAD; 	
			
			// Insertar XA's
			insert wrData.SpgXA;
	    	
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.LTE_Proceso_Exitoso));
			this.blnBotonContinuar = false;
		} catch(Exception e){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
    		Database.rollback(sp);
    		System.Debug('====================== EXCEPCION ======================');
    		System.debug( e.getMessage() + ' ' + e.getStackTraceString());
    		System.Debug('=======================================================');
    		return null;
    	}
		
		return null;
	}
	
	/**
    * Metodo encargado de obtener el Id de un plan de facturacion a partir
    * del Id de un plan.
    */
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
	   
}