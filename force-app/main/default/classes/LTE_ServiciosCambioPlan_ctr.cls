/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de selección de servicios en cambio de plan

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2015-11-30      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_ServiciosCambioPlan_ctr {
	
	private Apexpages.Standardcontroller stdController;
    public ActivoETB__c objActivoETB                       		{get; set;}
    public Reserva__c objReservaHomogeneo                       {get; set;}
    public Boolean blnBotonContinuar 							{get; set;}
    public Boolean blnBuscar		 							{get; set;}
    public Boolean blnBotonRegresar	 							{get; set;}
    public Boolean blnPlanesHomogeneos 							{get; set;}
    public Boolean blnDctosHomogeneos 							{get; set;}
    public Boolean blnBloqueServicios 							{get; set;}
    public Boolean blnBloqueHomogeneos 							{get; set;}
    public Boolean blnBloquePlanesDescuentos					{get; set;}
    public Boolean blnMostrarDetalles							{get; set;}
    public Boolean blnBotonGuardar								{get; set;}
    public Boolean blnBotonNuevoValorRecurrente					{get; set;}
    public Boolean blnAllChecked								{get; set;}
    public Boolean blnPlanHomogeneo								{get; set;}
    public Boolean blnDesactivaCheckHomogeneo					{get; set;}
    public Boolean blnOfertaRealizada							{get; set;}
    public Boolean blnPrepago_Postpago							{get; set;}
    public Boolean blnEsPrepagoHomogeneo						{get; set;}
    public String numerosConexion	 							{get; set;}
    public String numeroCaso									{get; set;}
    public String strDescuentoId								{get; set;}
    public String strDescuentoName								{get; set;}
    public String strDescuentoType								{get; set;}
    public String strlabelDescuentoPlanHomogeneo				{get; set;}
    public String strDctoBorrar									{get; set;}
    public String strNivelId                                    {get; set;}
    public String strNivel                                      {get; set;}
    public String strType                                       {get; set;}
    public String estadoAprobacion                              {get; set;}
    public Integer intCantidadReg								{get; set;}
    public Integer intIndexBorrarDcto							{get; set;}
    public Integer intRow                                       {get; set;}
    public Decimal dcmNuevoValorRecurrente                      {get; set;}
    public LTE_DetalleOfertaCambioPlan_cls objCambioPlan		{get; set;}
    public List<LTE_DetalleOfertaCambioPlan_cls> lstCambioPlan	{get; set;}
    private List<PlanFacturacion__c> lstPlanFacturacion			{get; set;}
    private Map<Id, Planes__c> mpValoresPlanes                  {get; set;}
    private Map<Id, SubPlanFacturacion__c> mpValoresSubPlanes   {get; set;}
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
    
    /** Variables Detalle de oFerta */
	private Map<Id, LTE_DetalleOferta__c> mpDetalleOferta;
    /********************************/
    
    private Map<string,VariablesGlobales__c> vGlobal;
    private Map<Integer,LTE_NivelesDescuento__c> mapNivelesDescuento;
    private LTE_NivelesDescuento__c objNivelDescuento;
    
    private String etiquetaBotonAgregar = 'Agregar';
    private String etiquetaBotonCambiar = 'Cambiar';
    
    /**
    * Constructor del controlador
    */
    public LTE_ServiciosCambioPlan_ctr(ApexPages.StandardController stdController){
    	this.stdController = stdController;
    	this.blnBotonContinuar = false;
    	this.blnBuscar = true;
    	this.blnBotonRegresar = false;
    	this.blnPlanesHomogeneos = false;
    	this.blnDctosHomogeneos = false;
    	this.blnBloqueServicios = false;
    	this.blnBloqueHomogeneos = false;
    	this.blnBloquePlanesDescuentos = false;
    	this.blnMostrarDetalles = false;
    	this.blnBotonGuardar = false;
    	this.blnBotonNuevoValorRecurrente = false;
    	this.blnAllChecked = false;
    	this.blnPlanHomogeneo = true;
    	this.blnDesactivaCheckHomogeneo = false;
    	this.blnPrepago_Postpago = false;
    	this.blnEsPrepagoHomogeneo = false;
    	this.objActivoETB = new ActivoETB__c();
    	this.objReservaHomogeneo = new Reserva__c();
    	this.objCambioPlan = new LTE_DetalleOfertaCambioPlan_cls();
    	this.lstCambioPlan = new List<LTE_DetalleOfertaCambioPlan_cls>();
    	this.numerosConexion = '';
    	this.strDescuentoId = '';
    	this.strDescuentoName = '';
    	this.strDescuentoType = '';
    	this.strNivelId = '';
        this.strNivel = '';
        this.strType = '';
    	this.strlabelDescuentoPlanHomogeneo = Label.LTE_Descuentos_Cambio_Plan;
    	this.intCantidadReg = 0;
    	this.intRow = 0;
    	this.dcmNuevoValorRecurrente = 0;
    	this.idCase = ApexPages.currentPage().getParameters().get('idCase');
    	this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
    	this.idContact = ApexPages.currentPage().getParameters().get('idContact');
    	this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
    	this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
    	this.estadoAprobacion = ApexPages.currentPage().getParameters().get('estadoAprobacion');
    	this.vGlobal = VariablesGlobales__c.getAll();
    	
    	if(String.isEmpty(this.estadoAprobacion)){
			this.estadoAprobacion = 'Inicial';
		}
    	
    	if(this.estadoAprobacion == 'Oferta Realizada'){
    		this.blnOfertaRealizada = true;
    	} else{
    		this.blnOfertaRealizada = false;
    	}
    	
    	this.numeroRegistros = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
    	this.lstActivosWrapper = new List<LTE_ActivoETB_Wrapper>();
    	this.blnHayDatos = false;
    	this.blnmostrarPrimero = false;
    	this.blnmostrarUltimo = false;
    	this.lstActivos = new List<ActivoETB__c>();
    	this.con = new ApexPages.StandardSetController(lstActivos);
	    this.selectedRecordIds = new Set<Id>();
    	
    	if(this.idCase == null){
    		System.debug('=======> El parametro LTECambioPlan.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.idAccount == null){
    		System.debug('=======> El parametro LTECambioPlan.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
    		parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
    		return;
    	}
    	
    	if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
    		System.debug('=======> El parametro LTECambioPlan.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de plan.');
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
    	
    	if(!validaRolAdicionSVA(lstContactos.get(0).LTE_RolLTE__c)){
    		System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTECambioPlan').valor__c+' en el Rol LTE.');
    		parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
    		return;
    	}
    	
        mpValoresPlanes = new map<Id, Planes__c>([SELECT Id,Tarifa__c,Name,LTE_PlanEstructurados__c,LTE_TipoControl__c,TipodePlan__c FROM Planes__c WHERE Estado__c = 'Activo']);
		mpValoresSubPlanes = new map<Id, SubPlanFacturacion__c>([SELECT Id, LTE_Precio__c, Name FROM SubPlanFacturacion__c ]);
		lstPlanFacturacion = [SELECT Id, Name, Plan__c FROM PlanFacturacion__c];
		system.debug(mpValoresPlanes);
    }
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolAdicionSVA(String rolContacto){
    	String rolesLTE;
   		String[] rolesLTESeparados;
   		list<String> lstRolesLTE;
   		
   		if(String.isEmpty(rolContacto)){
   			return false;
   		}
   		
   		rolesLTE = vGlobal.get('RolLTECambioPlan').valor__c;
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
    * Metodo usado para abrir y obtener la cuenta de facturacion.
    */
	public string getCuentaFact(){
    	Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();
    	return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+this.idAccount+'\' and Facturable__c=true and LTE_CuentaFacturacionLTE__c=true ')+'&f='+filtro_cls.codificar(',Name,Cliente__r.Name')+'&nom='+filtro_cls.codificar('Nombre,Cliente')+'&infoParam=';
    }
    
    /**
    * Metodo ecargado construir el listado de servicios seleccionados
    * junto con sus respectivas detalles de oferta
    */
    public PageReference continuar()
   	{
   		Integer intCicloFacturacion;
   		verificarSeleccionados();
   		
   		if(this.selectedRecordIds.isEmpty()){
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_No_Seleccion_Numero_Cambio_Plan));
   			return null;
   		}
   		
   		if(blnPlanesHomogeneos){
   			if(String.isEmpty(this.objReservaHomogeneo.LTE_Plan__c)){
   				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_No_Seleccion_Plan_Cambio_Plan));
   				return null;
   			}
   			
   			if(this.objReservaHomogeneo.LTE_PlanMedida__c){
   				if(String.isEmpty(this.objReservaHomogeneo.LTE_MinutoVoz__c) && String.isEmpty(this.objReservaHomogeneo.LTE_DatosNavegacion__c)){
	   				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_No_Seleccion_Voz_Cambio_Plan));
	   				return null;
	   			}
   			}
   		}
   		
   		this.blnMostrarDetalles = true;
   		this.blnBloquePlanesDescuentos = true;
   		
   		Set<Id> idsDetalleOferta = new Set<Id>();
   		
   		List<ActivoETB__c> lstActivosSeleccionados = new List<ActivoETB__c>();
   		lstActivosSeleccionados = [SELECT Estado__c, Id, Name, LTE_DetalleOferta__c, LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c, Plan__c, NumeroConexion__c, Contrato__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c 
   									FROM ActivoETB__c WHERE Id IN :this.selectedRecordIds];
   		
   		for(ActivoETB__c activoSeleccionado : lstActivosSeleccionados){
   			idsDetalleOferta.add(activoSeleccionado.LTE_DetalleOferta__c);
   		}
   		
   		mpDetalleOferta = new Map<Id, LTE_DetalleOferta__c>([SELECT Id, LTE_DatosNavegacion__c, LTE_DescuentoDatos__c, LTE_DescuentoPlan__c, LTE_DescuentoVoz__c, LTE_Estado__c, LTE_MinutoVoz__c, LTE_Valor_Total_Plan__c, Plan__c, Plan__r.Name, Plan__r.LTE_TipoControl__c FROM LTE_DetalleOferta__c WHERE Id IN :idsDetalleOferta]);
   		
   		LTE_DetalleOferta__c objDetalleOferta;
   		Integer i = 0;
   		this.lstCambioPlan = new List<LTE_DetalleOfertaCambioPlan_cls>();
   		for(ActivoETB__c activoSeleccionado : lstActivosSeleccionados){
   			objCambioPlan = new LTE_DetalleOfertaCambioPlan_cls();
   			objCambioPlan.activoETB = activoSeleccionado;
			
			//Se obtiene los datos del detalle de la oferta anterior
   			objCambioPlan.detalleOferta_old = mpDetalleOferta.get(activoSeleccionado.LTE_DetalleOferta__c);
   			
			objCambioPlan.LTE_PlanMedida = this.objReservaHomogeneo.LTE_PlanMedida__c;
			//Se genera el nuevo detalle de la oferta
			objDetalleOferta = new LTE_DetalleOferta__c();
			if(this.blnPlanesHomogeneos){
				objDetalleOferta.Plan__c = this.objReservaHomogeneo.LTE_Plan__c;
				
				if(objCambioPlan.detalleOferta_old.Plan__r.LTE_TipoControl__c == 'Prepago' && mpValoresPlanes.get(this.objReservaHomogeneo.LTE_Plan__c).LTE_TipoControl__c != 'Prepago'){
					objCambioPlan.prepago_postpago = true;
					this.blnPrepago_Postpago = true;
					objCambioPlan.postpago_prepago = false;
					objCambioPlan.prepago_prepago = false;
					objCambioPlan.postpago_postpago = false;
				} else if(objCambioPlan.detalleOferta_old.Plan__r.LTE_TipoControl__c != 'Prepago' && mpValoresPlanes.get(this.objReservaHomogeneo.LTE_Plan__c).LTE_TipoControl__c == 'Prepago'){
					objCambioPlan.prepago_postpago = false;
					this.blnPrepago_Postpago = false;
					objCambioPlan.postpago_prepago = true;
					objCambioPlan.prepago_prepago = false;
					objCambioPlan.postpago_postpago = false;
				} else if(objCambioPlan.detalleOferta_old.Plan__r.LTE_TipoControl__c == 'Prepago' && mpValoresPlanes.get(this.objReservaHomogeneo.LTE_Plan__c).LTE_TipoControl__c == 'Prepago'){
					objCambioPlan.prepago_postpago = false;
					this.blnPrepago_Postpago = false;
					objCambioPlan.postpago_prepago = false;
					objCambioPlan.prepago_prepago = true;
					objCambioPlan.postpago_postpago = false;
				}else{
					objCambioPlan.prepago_postpago = false;
					this.blnPrepago_Postpago = false;
					objCambioPlan.postpago_prepago = false;
					objCambioPlan.prepago_prepago = false;
					objCambioPlan.postpago_postpago = true;
				}
				
				if(this.objReservaHomogeneo.LTE_PlanMedida__c){
					objDetalleOferta.LTE_MinutoVoz__c = this.objReservaHomogeneo.LTE_MinutoVoz__c;
					objDetalleOferta.LTE_DatosNavegacion__c = this.objReservaHomogeneo.LTE_DatosNavegacion__c;
				} 
				
				try{
					intCicloFacturacion = Integer.valueOf(objCambioPlan.activoETB.CuentaFacturacion__r.LTE_CicloFacturacion__c);
				} catch(Exception e){
					intCicloFacturacion = -1;
					System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
				}
				
				
				if(intCicloFacturacion == -1)
					objCambioPlan.cicloFacturacion = '';
				else
					objCambioPlan.cicloFacturacion = intCicloFacturacion + ' ';
				
				if(objCambioPlan.prepago_postpago){
					objCambioPlan.fechaProximoCiclo = '';
					objCambioPlan.cicloFacturacion = '';
				} else if(objCambioPlan.postpago_postpago){
					objCambioPlan.fechaProximoCiclo = obtenerFechaCorte(intCicloFacturacion, false);
				} else{
					objCambioPlan.fechaProximoCiclo = obtenerFechaCorte(0, true);
				}
				
				objCambioPlan.nuevoValorRecurrentePlan = 0;
				if(this.objReservaHomogeneo.LTE_PlanMedida__c){
					try{
						if(this.objReservaHomogeneo.LTE_DatosNavegacion__c != null)
			            {
			                objCambioPlan.nuevoValorRecurrentePlan += (mpValoresSubPlanes.get(this.objReservaHomogeneo.LTE_MinutoVoz__c).LTE_Precio__c);
			            }
			            if(this.objReservaHomogeneo.LTE_DatosNavegacion__c != null)
			            {
			                objCambioPlan.nuevoValorRecurrentePlan += (mpValoresSubPlanes.get(this.objReservaHomogeneo.LTE_DatosNavegacion__c).LTE_Precio__c);    
			            }
					} catch(Exception e){
						objCambioPlan.nuevoValorRecurrentePlan = 0;
						System.Debug('=========> ERROR OBTENIENDO TARIFA DEL PLAN A LA MEDIDA: ' + e.getMessage());
					}
				} else{
					try{
						objCambioPlan.nuevoValorRecurrentePlan = mpValoresPlanes.get(this.objReservaHomogeneo.LTE_Plan__c).Tarifa__c;
					} catch(Exception e){
						objCambioPlan.nuevoValorRecurrentePlan = 0;
						System.Debug('=========> ERROR OBTENIENDO TARIFA DEL PLAN: ' + e.getMessage());
					}
				}
				
				if(this.blnDctosHomogeneos){
					if(this.objReservaHomogeneo.LTE_PlanMedida__c){
						objDetalleOferta.LTE_DescuentoVoz__c = this.objReservaHomogeneo.LTE_DescuentoVoz__c;
						objCambioPlan.nombreDescuentoVoz = this.objReservaHomogeneo.LTE_DescuentoVozAux__c;
						objDetalleOferta.LTE_DescuentoDatos__c = this.objReservaHomogeneo.LTE_DescuentoDatos__c;
						objCambioPlan.nombreDescuentoDatos = this.objReservaHomogeneo.LTE_DescuentoDatosAux__c;
						
						if(this.objReservaHomogeneo.LTE_DescuentoVoz__c != null){
							objCambioPlan.etiquetaAgregarCambiarDtoVoz = etiquetaBotonCambiar;
							objCambioPlan.blnBtnBorrarDtoVoz = true;
						} else{
							objCambioPlan.etiquetaAgregarCambiarDtoVoz = etiquetaBotonAgregar;
							objCambioPlan.blnBtnBorrarDtoVoz = false;
						}
						
						if(this.objReservaHomogeneo.LTE_DescuentoDatos__c != null){
							objCambioPlan.etiquetaAgregarCambiarDtoDatos = etiquetaBotonCambiar;
							objCambioPlan.blnBtnBorrarDtoDatos = true;
						} else{
							objCambioPlan.etiquetaAgregarCambiarDtoDatos = etiquetaBotonAgregar;
							objCambioPlan.blnBtnBorrarDtoDatos = false;
						}
					} else{
						objDetalleOferta.LTE_DescuentoPlan__c = this.objReservaHomogeneo.LTE_DescuentoPlan__c;
						objCambioPlan.nombreDescuentoPlan = this.objReservaHomogeneo.LTE_DescuentoPlanAux__c;
						
						if(this.objReservaHomogeneo.LTE_DescuentoPlan__c != null){
							objCambioPlan.etiquetaAgregarCambiarDtoPlan = etiquetaBotonCambiar;
							objCambioPlan.blnBtnBorrarDtoPlan = true;
						} else{
							objCambioPlan.etiquetaAgregarCambiarDtoPlan = etiquetaBotonAgregar;
							objCambioPlan.blnBtnBorrarDtoPlan = false;
						}
					}
					
					if(objCambioPlan.prepago_prepago){
						if(objDetalleOferta.LTE_DescuentoPlan__c != null){
							objDetalleOferta.LTE_DescuentoPlan__c = null;
							objCambioPlan.nombreDescuentoPlan = null;
							objCambioPlan.blnBtnBorrarDtoPlan = false;
						}
					}
				}
			} else if(this.blnDctosHomogeneos){
				objCambioPlan.blnBtnBorrarDtoPlan = false;
				objCambioPlan.blnBtnBorrarDtoVoz = false;
				objCambioPlan.blnBtnBorrarDtoDatos = false;
			}
			objCambioPlan.detalleOferta_new = objDetalleOferta;
   			objCambioPlan.index = i;
   			this.lstCambioPlan.add(objCambioPlan);
   			i++;
   		}
   		if(!this.lstCambioPlan.isEmpty()){
   			this.blnBotonContinuar = false;
   			this.blnBloqueServicios = false;
   			this.blnBuscar = false;
   			this.blnBotonGuardar = false;
    		this.blnBotonNuevoValorRecurrente = true;
    		this.blnPlanHomogeneo = false;
    		this.blnDesactivaCheckHomogeneo = true;
   		}
   		
		return null;
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
   		this.blnBloqueHomogeneos = true;
   		this.blnBotonContinuar = true;
   		
   		//Se eliminan los espacios de la cadena
   		numerosConexion = numerosConexion.deleteWhiteSpace();
   		numerosConexionSeparados = numerosConexion.split(',');
   		Set<String> setNumerosConexion = new Set<String>(numerosConexionSeparados);
   		
    	String producto = vGlobal.get('NombreComercialLTE').valor__c;
   		
   		if(this.con == null) {
   			this.con = new ApexPages.StandardSetController(lstActivos);
   		}
   		
   		this.lstActivos = [SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,NumeroConexion__c,Plan__r.NombredelProducto__r.Name, Plan__r.TipodePlan__c, Contrato__c, Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, (select name,Estado__c,TOPP__r.TipodeOperacionporplan__c  from Operaciones_Comerciales__r where Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento')) 
   		FROM ActivoETB__c 
   		WHERE NombredelaCuenta__c = :this.idAccount and Plan__r.NombredelProducto__r.Name = :producto AND Plan__r.TipodePlan__c != 'Troncal SIP' AND Tipo_linea_bolsa_compartida__c != 'Hija' AND NumeroConexion__c IN :numerosConexionSeparados AND Estado__c = 'Activo' AND Demo__c != true Order By Name /*limit 100*/];
   		
   		if(this.lstActivos.isEmpty()){
   			this.intCantidadReg = 0;
	    	this.blnmostrarPrimero = false;
	    	this.blnmostrarUltimo = false;
	    	this.blnBotonContinuar = false;
	    	this.blnBloqueServicios = false;
	    	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
   		} else{
   			this.intCantidadReg = lstActivos.size();
	    	this.blnmostrarPrimero = true;
	    	this.blnBotonContinuar = true;
	    	this.blnBloqueServicios = true;
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
    * Metodo encargado de quitar un descuento asociado a un servicio
    * en la lista de servicios seleccionados
    */
    public PageReference borrarDescuentoCambioPlan(){
    	for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
    		if(objCambioPlan.index == this.intIndexBorrarDcto){
    			if(this.strDctoBorrar == 'DtoPlan'){
			    	objCambioPlan.nombreDescuentoPlan = null;
			        objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c = null;
			        objCambioPlan.etiquetaAgregarCambiarDtoPlan = etiquetaBotonAgregar;
			        objCambioPlan.blnBtnBorrarDtoPlan = false;
		    	}
		    	if(this.strDctoBorrar == 'DtoVoz'){
		            objCambioPlan.nombreDescuentoVoz = null;
			        objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c = null; 
			        objCambioPlan.etiquetaAgregarCambiarDtoVoz = etiquetaBotonAgregar;
			        objCambioPlan.blnBtnBorrarDtoVoz = false;
		        }
		        if(this.strDctoBorrar == 'DtoDato'){
		            objCambioPlan.nombreDescuentoDatos = null;
			        objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c = null; 
			        objCambioPlan.etiquetaAgregarCambiarDtoDatos = etiquetaBotonAgregar;
			        objCambioPlan.blnBtnBorrarDtoDatos = false;
		        }
    		}
    	}
    	return null;
    }
    
    /**
    * Metodo encargado de mostrar u ocultar las casillas de seleccion de bolsas
    * de acuerdo al plan seleccionado en la seccion de seleccion de plan si se 
    * selecciono la casilla de Planes Homogeneos
    */
    public PageReference ocultarDescuentoPlanHomogeneo()
    {
        list<String> lstIdDescuentos = new list<String>();
        system.debug(this.mpValoresPlanes);
        system.debug(this.objReservaHomogeneo.LTE_Plan__c);
        if(this.objReservaHomogeneo.LTE_Plan__c != null){
            if(this.mpValoresPlanes.get(this.objReservaHomogeneo.LTE_Plan__c).TipodePlan__c != 'Principal'){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LTE_Seleccione_Plan_Valido));
                return null;
            }
        }

        //[MC] Se consulta la información del plan seleccionado
        /* BEGIN - Manuel Medina - Inicializacion de la variable objPlanSeleccionado antes de asignacion de SOQL para evitar excepcion List has no rows for assigment to SObject - 11082016 */
        //Planes__c objPlanSeleccionado = [SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id = :this.objReservaHomogeneo.LTE_Plan__c];
        Planes__c objPlanSeleccionado = new Planes__c();
        objPlanSeleccionado = [SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id = :this.objReservaHomogeneo.LTE_Plan__c];
        /* END - Manuel Medina - Inicializacion de la variable objPlanSeleccionado antes de asignacion de SOQL para evitar excepcion List has no rows for assigment to SObject - 11082016 */
        PlanCompuestoWrapper planCompuestoWp = null;
        objReservaHomogeneo.LTE_Plan__c = objPlanSeleccionado.Id;
        objReservaHomogeneo.LTE_Plan__r = objPlanSeleccionado;
        
        if(this.objReservaHomogeneo.LTE_Plan__c != null && objPlanSeleccionado.LTE_Es_Plan_Compuesto__c)
        {
         	objReservaHomogeneo.LTE_MinutosVozConfigurado__c = false;
			objReservaHomogeneo.LTE_DatosNavegacionConfigurado__c = false;
            planCompuestoWp = getConfiguracionPlanIlimitados(objPlanSeleccionado);
            System.debug('planCompuestoWp ' + planCompuestoWp);
            if(planCompuestoWp != null){
                
                if(planCompuestoWp.minutosVoz != null){
                    objReservaHomogeneo.LTE_MinutoVoz__c = planCompuestoWp.minutosVoz.Id;
                    objReservaHomogeneo.LTE_MinutosVozConfigurado__c = true;
                }
                
                if(planCompuestoWp.datosNavegacion != null){
                    objReservaHomogeneo.LTE_DatosNavegacion__c = planCompuestoWp.datosNavegacion.Id;
                    objReservaHomogeneo.LTE_DatosNavegacionConfigurado__c = true;
                }
                
            }
            
            
            this.objReservaHomogeneo.LTE_PlanMedida__c = true;
            this.strlabelDescuentoPlanHomogeneo = '';
            this.blnEsPrepagoHomogeneo = false;
            if(this.objReservaHomogeneo.LTE_DescuentoPlan__c != null)
            {
                this.objReservaHomogeneo.LTE_DescuentoPlanAux__c = '';
                lstIdDescuentos.add(this.objReservaHomogeneo.LTE_DescuentoPlan__c);
                this.objReservaHomogeneo.LTE_DescuentoPlan__c = null;
            }
        }
        else
        {
            this.objReservaHomogeneo.LTE_PlanMedida__c = false;
            this.strlabelDescuentoPlanHomogeneo = Label.LTE_Descuentos_Cambio_Plan;
            this.objReservaHomogeneo.LTE_MinutoVoz__c = null;
            this.objReservaHomogeneo.LTE_DatosNavegacion__c = null;
            this.blnEsPrepagoHomogeneo = false;
            if(this.objReservaHomogeneo.LTE_DescuentoDatos__c != null )
            {
                this.objReservaHomogeneo.LTE_DescuentoDatosAux__c = '';
                lstIdDescuentos.add(this.objReservaHomogeneo.LTE_DescuentoDatos__c);
                this.objReservaHomogeneo.LTE_DescuentoDatos__c = null;
            }
            if(this.objReservaHomogeneo.LTE_DescuentoVoz__c != null)
            {
                this.objReservaHomogeneo.LTE_DescuentoVozAux__c = '';
                lstIdDescuentos.add(this.objReservaHomogeneo.LTE_DescuentoVoz__c);
                this.objReservaHomogeneo.LTE_DescuentoVoz__c = null;
            }
            
            if(mpValoresPlanes.get(this.objReservaHomogeneo.LTE_Plan__c).LTE_TipoControl__c == 'Prepago'){
            	this.blnEsPrepagoHomogeneo = true;
            	if(this.objReservaHomogeneo.LTE_DescuentoPlan__c != null){
            		this.objReservaHomogeneo.LTE_DescuentoPlanAux__c = '';
	                lstIdDescuentos.add(this.objReservaHomogeneo.LTE_DescuentoPlan__c);
	                this.objReservaHomogeneo.LTE_DescuentoPlan__c = null;
            	}
            }
        }

        if(!lstIdDescuentos.isEmpty())
            borrarDescuentos(lstIdDescuentos);
        return null;
    }
    
    /********************************************************************
     * Obtiene todos los planes compuestos, estos planes estan en una configuracion 
     * personalizada (MC)
     *******************************************************************/ 
    private PlanCompuestoWrapper getConfiguracionPlanIlimitados(Planes__c plan){
        PlanCompuestoWrapper wrapper = null;
        List<SubPlanFacturacion__c> lstSubPlan = null;
        if(plan != null && plan.Name != null ){
            for(LTE_Planes_Compuestos__c objPla : LTE_Planes_Compuestos__c.getall().values()){
                if(plan.Name.equals(objPla.Name)){
                    wrapper = new PlanCompuestoWrapper();
                    //No hay problmea que se haga el select dentro de este for ya que al primer
                    //valor que concuerde sale del método
                    lstSubPlan = [SELECT Id, Name FROM SubPlanFacturacion__c WHERE Name = :objPla.MinutosVoz__c];
                    if(lstSubPlan.size() > 0){
                        wrapper.minutosVoz = lstSubPlan[0];
                    }
                    lstSubPlan = [SELECT Id, Name FROM SubPlanFacturacion__c WHERE Name = :objPla.DatosNavegacion__c];
                    if(lstSubPlan.size() > 0){
                        wrapper.datosNavegacion = lstSubPlan[0];
                    }
                    return wrapper;
                }
            } 
        }
        
        return wrapper;
    }
    
    /*******************************************************
     * Clase Wrapper para agrupar los subplanes de un plan de factuacion
     ******************************************************/ 
    public class PlanCompuestoWrapper{
        SubPlanFacturacion__c minutosVoz;
        SubPlanFacturacion__c datosNavegacion;
    }

    
    /**
    * Metodo encargado de mostrar u ocultar las casillas de seleccion de bolsas
    * de acuerdo al plan seleccionado en la seccion de seleccion de plan en el 
    * listado de servicios seleccionados.
    */
    public PageReference ocultarDescuentoPlan()
    {
        Integer intCicloFacturacion;
        list<String> lstIdDescuentos = new list<String>();
		this.blnBotonGuardar = false;
        
        Set<Id> setIdPlanes = new Set<Id>();
        Planes__c objPlanTmp = null;
        PlanCompuestoWrapper planCompuestoWp = null;
		//Se obtienen el listado de ID de los planes seleccionados.
        for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
            if(objCambioPlan.detalleOferta_new.Plan__c != null){
            	setIdPlanes.add(Id.valueof(objCambioPlan.detalleOferta_new.Plan__c));
            }
        }
        
        Map<Id, Planes__c> mapPlanes = new Map<Id, Planes__c>([SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id IN :setIdPlanes]); 
        
		for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
			//Se valida que tipo de control tienen los planes
			if(objCambioPlan.detalleOferta_new.Plan__c != null){
	            if(objCambioPlan.detalleOferta_old.Plan__r.LTE_TipoControl__c == 'Prepago' && mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).LTE_TipoControl__c != 'Prepago'){
					objCambioPlan.prepago_postpago = true;
					this.blnPrepago_Postpago = true;
					objCambioPlan.postpago_prepago = false;
					objCambioPlan.prepago_prepago = false;
					objCambioPlan.postpago_postpago = false;
				} else if(objCambioPlan.detalleOferta_old.Plan__r.LTE_TipoControl__c != 'Prepago' && mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).LTE_TipoControl__c == 'Prepago'){
					objCambioPlan.prepago_postpago = false;
					this.blnPrepago_Postpago = false;
					objCambioPlan.postpago_prepago = true;
					objCambioPlan.prepago_prepago = false;
					objCambioPlan.postpago_postpago = false;
					//Quito los descuentos
					objCambioPlan.blnBtnBorrarDtoPlan = false;
					if(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c != null)
	                {
	                    //Antes de agregar el id del descuento a la lista para eliminar, verificamos
	                    //que ese Id no sea el del descuento homogeneo que aplica a todos, ya que ese no se
	                    //debe eliminar
						if(this.objReservaHomogeneo.LTE_DescuentoPlan__c != null){
							if(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c != this.objReservaHomogeneo.LTE_DescuentoPlan__c){
								lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c);
							}
						} else{
							lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c);
						}
	                    objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c = null;
	                    objCambioPlan.nombreDescuentoPlan = null;
	                }
				} else if(objCambioPlan.detalleOferta_old.Plan__r.LTE_TipoControl__c == 'Prepago' && mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).LTE_TipoControl__c == 'Prepago'){
					objCambioPlan.prepago_postpago = false;
					this.blnPrepago_Postpago = false;
					objCambioPlan.postpago_prepago = false;
					objCambioPlan.prepago_prepago = true;
					objCambioPlan.postpago_postpago = false;
				}else{
					objCambioPlan.prepago_postpago = false;
					this.blnPrepago_Postpago = false;
					objCambioPlan.postpago_prepago = false;
					objCambioPlan.prepago_prepago = false;
					objCambioPlan.postpago_postpago = true;
				}
			}
			
			if( objCambioPlan.index == intRow ){
				//Se valida que sea un tipo de plan valido, que no valla a ser por ejemplo Troncal SIP
				if(objCambioPlan.detalleOferta_new.Plan__c != null && this.mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).TipodePlan__c != 'Principal'){
		        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LTE_Seleccione_Plan_Valido));
		        	return null;
		        }
				System.debug('===== objCambioPlan.detalleOferta_new.Plan__c ' +  objCambioPlan.detalleOferta_new.Plan__c);
                System.debug('===== objCambioPlan.detalleOferta_new.Plan__r ' +  objCambioPlan.detalleOferta_new.Plan__r.LTE_Es_Plan_Compuesto__c);
                
                //[MC] Se consulta la información del plan seleccionado
                objPlanTmp = mapPlanes.get(Id.valueOf(objCambioPlan.detalleOferta_new.Plan__c));
            
            	system.debug('objCambioPlan.detalleOferta_new.Plan__c ---> ' + objCambioPlan.detalleOferta_new.Plan__c);
            	system.debug('objPlanTmp ---> ' + objPlanTmp);
                objCambioPlan.detalleOferta_new.Plan__c = objPlanTmp.Id;
                objCambioPlan.detalleOferta_new.Plan__r = objPlanTmp;    
                
	            if(objCambioPlan.detalleOferta_new.Plan__c != null && objPlanTmp.LTE_Es_Plan_Compuesto__c)
	            {	
                    objCambioPlan.LTE_PlanMedida = true;
	                objCambioPlan.blnBtnBorrarDtoPlan = false;
                    objCambioPlan.LTE_MinutosVozConfigurado = false;
                    objCambioPlan.LTE_DatosNavegacionConfigurado = false;
                    planCompuestoWp = getConfiguracionPlanIlimitados(objPlanTmp);
                    System.debug('planCompuestoWp ' + planCompuestoWp);
                    if(planCompuestoWp != null){
                        
                        if(planCompuestoWp.minutosVoz != null){
                           objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c = planCompuestoWp.minutosVoz.Id;
                            objCambioPlan.LTE_MinutosVozConfigurado = true;
                        }
                        
                        if(planCompuestoWp.datosNavegacion != null){
                            objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c = planCompuestoWp.datosNavegacion.Id;
                            objCambioPlan.LTE_DatosNavegacionConfigurado = true;
                        }
                        
                    }

	                
	                if(!String.isEmpty(objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c)){
	            		objCambioPlan.etiquetaAgregarCambiarDtoVoz = etiquetaBotonCambiar;
	            		objCambioPlan.blnBtnBorrarDtoVoz = true;
	            	} else{
	            		objCambioPlan.etiquetaAgregarCambiarDtoVoz = etiquetaBotonAgregar;
	            		objCambioPlan.blnBtnBorrarDtoVoz = false;
	            	}
	                
	                if(!String.isEmpty(objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c)){
	                	objCambioPlan.etiquetaAgregarCambiarDtoDatos = etiquetaBotonCambiar;
	                	objCambioPlan.blnBtnBorrarDtoDatos = true;
	            	} else{
	            		objCambioPlan.etiquetaAgregarCambiarDtoDatos = etiquetaBotonAgregar;
	            		objCambioPlan.blnBtnBorrarDtoDatos = false;
	            	}
	            
	                if(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c != null)
	                {
	                    //Antes de agregar el id del descuento a la lista para eliminar, verificamos
	                    //que ese Id no sea el del descuento homogeneo que aplica a todos, ya que ese no se
	                    //debe eliminar
						if(this.objReservaHomogeneo.LTE_DescuentoPlan__c != null){
							if(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c != this.objReservaHomogeneo.LTE_DescuentoPlan__c){
								lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c);
							}
						} else{
							lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c);
						}
	                    objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c = null;
	                    objCambioPlan.nombreDescuentoPlan = null;
	                }
	            }
	            else
	            {
	                objCambioPlan.LTE_PlanMedida = false;
	                objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c = null;
	                objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c = null;
	                
	                objCambioPlan.blnBtnBorrarDtoVoz = false;
	                objCambioPlan.blnBtnBorrarDtoDatos = false;
	                
	                if(!String.isEmpty(objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c)){
	                	objCambioPlan.etiquetaAgregarCambiarDtoPlan = etiquetaBotonCambiar;
	                	objCambioPlan.blnBtnBorrarDtoPlan = true;
	                } else{
	                	objCambioPlan.etiquetaAgregarCambiarDtoPlan = etiquetaBotonAgregar;
	                	objCambioPlan.blnBtnBorrarDtoPlan = false;
	                }
	                
	                if(objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c != null )
	                {
	                    //Antes de agregar el id del descuento a la lista para eliminar, verificamos
	                    //que ese Id no sea el del descuento homogeneo que aplica a todos, ya que ese no se
	                    //debe eliminar
						if(this.objReservaHomogeneo.LTE_DescuentoVoz__c != null ){
							if(objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c != this.objReservaHomogeneo.LTE_DescuentoVoz__c){
								lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c);
							}
						} else{
							lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c);
						}
	                    objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c = null;
	                    objCambioPlan.nombreDescuentoVoz = null;
	                }
	                if(objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c != null)
	                {
	                    //Antes de agregar el id del descuento a la lista para eliminar, verificamos
	                    //que ese Id no sea el del descuento homogeneo que aplica a todos, ya que ese no se
	                    //debe eliminar
						if(this.objReservaHomogeneo.LTE_DescuentoDatos__c != null){
							if(objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c != this.objReservaHomogeneo.LTE_DescuentoDatos__c){
								lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c);
							}
						} else{
							lstIdDescuentos.add(objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c);
						}
	                    objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c = null;
	                    objCambioPlan.nombreDescuentoDatos = null;
	                }
	            }
	            
	            if(objCambioPlan.detalleOferta_new.Plan__c != null){
					
					try{
						intCicloFacturacion = Integer.valueOf(objCambioPlan.activoETB.CuentaFacturacion__r.LTE_CicloFacturacion__c);
					} catch(Exception e){
						intCicloFacturacion = -1;
						System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
					}
					
					if(intCicloFacturacion == -1)
						objCambioPlan.cicloFacturacion = '';
					else
						objCambioPlan.cicloFacturacion = intCicloFacturacion + ' ';
					
					if(objCambioPlan.postpago_postpago){
						objCambioPlan.fechaProximoCiclo = obtenerFechaCorte(intCicloFacturacion, false);
					} else if(objCambioPlan.prepago_postpago){
						if(String.isEmpty(objCambioPlan.idCuentaFacturacion)){
							objCambioPlan.fechaProximoCiclo = '';
							objCambioPlan.cicloFacturacion = '';
						} else{
							List<CuentaFacturacion__c> lstCuentaFacturacion = new List<CuentaFacturacion__c>();
							lstCuentaFacturacion = [SELECT id, Name, LTE_CicloFacturacion__c FROM CuentaFacturacion__c WHERE Id = :objCambioPlan.idCuentaFacturacion];
							objCambioPlan.cicloFacturacion = lstCuentaFacturacion.get(0).LTE_CicloFacturacion__c;
							try{
								intCicloFacturacion = Integer.valueOf(lstCuentaFacturacion.get(0).LTE_CicloFacturacion__c);
							} catch(Exception e){
								intCicloFacturacion = -1;
								System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
							}
							objCambioPlan.fechaProximoCiclo = obtenerFechaCorte(intCicloFacturacion, false);
						}
					} else{
						objCambioPlan.fechaProximoCiclo = obtenerFechaCorte(0, true);
					}
					
					if(!objCambioPlan.LTE_PlanMedida){
						try{
							objCambioPlan.nuevoValorRecurrentePlan = mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).Tarifa__c;
						} catch(Exception e){
							objCambioPlan.nuevoValorRecurrentePlan = 0;
							System.Debug('=========> ERROR OBTENIENDO TARIFA DEL PLAN: ' + e.getMessage());
						}
					} else{
						objCambioPlan.nuevoValorRecurrentePlan = 0;
						try{
							if(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c != null)
				            {
				                objCambioPlan.nuevoValorRecurrentePlan += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c).LTE_Precio__c);
				            }
				            if(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c != null)
				            {
				                objCambioPlan.nuevoValorRecurrentePlan += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c).LTE_Precio__c);    
				            }
						} catch(Exception e){
							objCambioPlan.nuevoValorRecurrentePlan = 0;
							System.Debug('=========> ERROR OBTENIENDO TARIFA DEL PLAN A LA MEDIDA: ' + e.getMessage());
						}
					}
				}
			} 
        }
        if(!lstIdDescuentos.isEmpty())
            borrarDescuentos(lstIdDescuentos);
        return null;
    }
    
    /** 
    * Metodo encargado de consultar el boton guardar
    */
    public PageReference ocultarBotonGuardar(){
    	this.blnBotonGuardar = false;
    	
    	for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
    		if(objCambioPlan.LTE_PlanMedida){
    			objCambioPlan.nuevoValorRecurrentePlan = 0;
				try{
					if(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c != null)
		            {
		                objCambioPlan.nuevoValorRecurrentePlan += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c).LTE_Precio__c);
		            }
		            if(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c != null)
		            {
		                objCambioPlan.nuevoValorRecurrentePlan += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c).LTE_Precio__c);    
		            }
				} catch(Exception e){
					objCambioPlan.nuevoValorRecurrentePlan = 0;
					System.Debug('=========> ERROR OBTENIENDO TARIFA DEL PLAN A LA MEDIDA: ' + e.getMessage());
				}
			}
    	}
    	
    	return null;
    }
    
    /** 
    * Metodo encargado de borrar un descuento que fue asociado a un plan o bolsa
    * pero dicho plan o bolsa ya no va a ser seleccionado
    */
    public void borrarDescuentos (List<String> lstIdDescuentos)
    {
        list<LTE_NivelesDescuento__c> lstDescuentosBorrar = new list<LTE_NivelesDescuento__c>();
         
        for (String strIdDescuento : lstIdDescuentos)
        {
            LTE_NivelesDescuento__c objDescuentoBorrar = new LTE_NivelesDescuento__c(Id = strIdDescuento);
            lstDescuentosBorrar.add(objDescuentoBorrar); 
        }
        Delete lstDescuentosBorrar;
    }
    
    /**
    * Metodo encargado de generar y almacenar todos los datos para procesar la 
    * transaccion de cambio de plan.
    */
    public PageReference guardar(){
    	List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
    	List<WrapperOCxDO> lstWrapperOCxDO = new List<WrapperOCxDO>();
    	List<LTE_DetalleOferta__c> lstDO = new List<LTE_DetalleOferta__c>();
    	List<LTE_Servicios_adicionales__c> lstSA = new List<LTE_Servicios_adicionales__c>();
    	List<Id> lstPlanes = new List<Id>();
        List<Id> lstSubPlanes = new List<Id>();
        List<Equipo__c> lstEquipos = new List<Equipo__c>();
        List<TOPP__c> lstTOPP = new List<TOPP__c>();
		List<RecordType> lstRecordType = new list<RecordType>();
    	OperacionComercial__c oc;
    	Equipo__c objEq;
    	Reserva__c  objRes;
    	ActivoETB__c objActivoETB;
    	WrapperOCxDO objWrapperOCxDO;
    	LTE_Servicios_adicionales__c objSAPlan;
    	LTE_Servicios_adicionales__c objSAVoz;
    	LTE_Servicios_adicionales__c objSADatos;
    	Decimal dcmValorPlanes = 0;
        Decimal dcmValorSubPlanes = 0;
        Decimal dcmValorTotal = 0;
        String nombrePlanAnterior = '';
        Set<Id> setIdPlanes = new Set<Id>();
        Planes__c objPlanTmp = null;
        PlanCompuestoWrapper planCompuestoWp = null;
		//Se obtienen el listado de ID de los planes seleccionados.
        for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
            setIdPlanes.add(Id.valueof(objCambioPlan.detalleOferta_new.Plan__c));
        }
        
        Map<Id, Planes__c> mapPlanes = new Map<Id, Planes__c>([SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id IN :setIdPlanes]); 
        
    	
    	Savepoint sp = Database.setSavepoint();
    	
    	//try{
    		lstEquipos = [SELECT Id FROM Equipo__c WHERE name = 'Equipo Traido'];
			
			if(lstEquipos.isEmpty()){
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontró el equipo'));
				return null;
			}
			
			objRes = new Reserva__c();
			objRes.Equipo__c = lstEquipos.get(0).id;
			insert objRes;
			
			/* BEGIN - Manuel Medina - Se comentarea debido a que el la consulta no es utilizada - 18082016 */
			//Consultamos los planes a la medida para que sean identificados mas adelante
	    	/* BEGIN - Manuel Medina - Inicializacion de la variable objPlanSeleccionado antes de asignacion de SOQL para evitar excepcion List has no rows for assigment to SObject - 11082016 */
	    	//Planes__c objPlanSeleccionado = [SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id = :this.objReservaHomogeneo.LTE_Plan__c];
	    	//Planes__c objPlanSeleccionado = new Planes__c();
	    	//objPlanSeleccionado = [SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id = :this.objReservaHomogeneo.LTE_Plan__c];
	    	/* END - Manuel Medina - Inicializacion de la variable objPlanSeleccionado antes de asignacion de SOQL para evitar excepcion List has no rows for assigment to SObject - 11082016 */
	    	/* END - Manuel Medina - Se comentarea debido a que el la consulta no es utilizada - 18082016 */
	        
	        //Obtenemos el tipo de registro asociado al tipo de operacion por plan	        
	        lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Id = :this.idTOPP];
			lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
	            
	        if(lstRecordType.isEmpty()){
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
				return null;
			}
	        
    		//Se crean las Operaciones Comerciales para cada Detalle de la oferta
	    	for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
	    		objCambioPlan.detalleOferta_new.LTE_Oferta_Economica__c = objRes.id;
				objCambioPlan.detalleOferta_new.LTE_Cliente__c = this.idAccount;
				objCambioPlan.detalleOferta_new.LTE_NumeroLinea__c = objCambioPlan.activoETB.NumeroConexion__c;
				objCambioPlan.detalleOferta_new.LTE_EquipoTraido__c = true;
				
				//Se calcula el valor total del plan con sus bolsas
	    		dcmValorPlanes = 0;
	    		dcmValorSubPlanes = 0;
	    		dcmValorTotal = 0;
	    		
	    		dcmValorPlanes = mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).Tarifa__c;
	        	//Suma el valor de las bolsas
	            if(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c != null)
	            {
	                dcmValorSubPlanes += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c).LTE_Precio__c);
	            }
	            if(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c != null)
	            {
	                dcmValorSubPlanes += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c).LTE_Precio__c);    
	            }
	    		dcmValorTotal = dcmValorPlanes + dcmValorSubPlanes;
	    		
	    		nombrePlanAnterior = objCambioPlan.detalleOferta_old.Plan__r.Name;
                
                system.debug('\n\n@@-->objCambioPlan ---> ' + objCambioPlan + '\n\n');
                system.debug('\n\n@@-->objCambioPlan.detalleOferta_old ---> ' + objCambioPlan.detalleOferta_old + '\n\n');
                system.debug('\n\n@@-->objCambioPlan.detalleOferta_old.Plan__c ---> ' + objCambioPlan.detalleOferta_old.Plan__c + '\n\n');
                system.debug('\n\n@@-->mapPlanes ---> ' + mapPlanes + '\n\n');
                
                /* BEGIN - Manuel Medina - Se ajusta la referencia a consultar en el mapa debido a que se estaba consultando el id no almacenado - 11082016 */
                //[MC] Se consulta la información del plan seleccionado
                //objPlanTmp = mapPlanes.get(Id.valueOf(objCambioPlan.detalleOferta_old.Plan__c));
                objPlanTmp = mapPlanes.get(Id.valueOf(objCambioPlan.detalleOferta_new.Plan__c));
                /* END - Manuel Medina - Se ajusta la referencia a consultar en el mapa debido a que se estaba consultando el id no almacenado - 11082016 */
            
            	system.debug('objCambioPlan.detalleOferta_old.Plan__c ---> ' + objCambioPlan.detalleOferta_old.Plan__c);
            	system.debug('objPlanTmp ---> ' + objPlanTmp);
                //objCambioPlan.detalleOferta_new.Plan__c = objPlanTmp.Id;
                //objCambioPlan.detalleOferta_new.Plan__r = objPlanTmp;    
                
                
	    		if(objCambioPlan.detalleOferta_old.Plan__c != null && objPlanTmp.LTE_Es_Plan_Compuesto__c){
	    			//Plan a la medida
	    			if(!String.isEmpty(objCambioPlan.detalleOferta_old.LTE_MinutoVoz__c)){
	    				nombrePlanAnterior += '||' + mpValoresSubPlanes.get(objCambioPlan.detalleOferta_old.LTE_MinutoVoz__c).Name;
	    			}
	    			
	    			if(!String.isEmpty(objCambioPlan.detalleOferta_old.LTE_DatosNavegacion__c)){
	    				nombrePlanAnterior += '||' + mpValoresSubPlanes.get(objCambioPlan.detalleOferta_old.LTE_DatosNavegacion__c).Name;
	    			}
	    		}
	    		if(nombrePlanAnterior != null && nombrePlanAnterior.length() > 255){
	    			nombrePlanAnterior = nombrePlanAnterior.substring(0,255);
	    		}
	    		System.debug('*************************************************************************');
	    		System.debug(', detalleOferta_old.Plan__c: ' + objCambioPlan.detalleOferta_old.Plan__c);
	    		System.debug('detalleOferta_old.LTE_MinutoVoz__c: ' + objCambioPlan.detalleOferta_old.LTE_MinutoVoz__c + 'detalleOferta_old.LTE_DatosNavegacion__c: ' + objCambioPlan.detalleOferta_old.LTE_DatosNavegacion__c);
	    		System.debug('nombrePlanAnterior: ' + nombrePlanAnterior );
	    		System.debug('*************************************************************************');
	    		
	    		objWrapperOCxDO = new WrapperOCxDO();
	    		oc = new OperacionComercial__c();
	    		oc.CuentaCliente__c = this.idAccount;
	    		oc.Activo__c = objCambioPlan.activoETB.Id;
	    		oc.NumeroConexion__c = objCambioPlan.activoETB.NumeroConexion__c; //LRPA 06-01-2016	    		
	    		oc.Plan__c = objCambioPlan.detalleOferta_new.Plan__c;
	    		oc.TOPP__c = this.idTOPP;
	    		oc.PlanAnterior__c = nombrePlanAnterior;
	    		oc.Estado__c = 'Pendiente';
	    		//oc.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Cambio de Plan LTE').getRecordTypeId();
	    		oc.RecordTypeId = lstRecordType.get(0).Id;
	    		oc.Caso__c = this.idCase;
	    		oc.Valor_Recurrente_ETB_Anterior__c = objCambioPlan.detalleOferta_old.LTE_Valor_Total_Plan__c;
	    		oc.ValorTarifaPlan__c = dcmValorTotal;
	    		if(objCambioPlan.postpago_postpago || objCambioPlan.postpago_prepago){
	    			oc.CuentaFacturacion__c = objCambioPlan.activoETB.CuentaFacturacion__c;
	    		} else{
	    			oc.CuentaFacturacion__c = objCambioPlan.idCuentaFacturacion;
	    		}
	    		objWrapperOCxDO.objWOC = oc;
	    		
	    		objCambioPlan.detalleOferta_new.LTE_Valor_Total_Plan__c = dcmValorTotal;
	    		objWrapperOCxDO.objWDO = objCambioPlan.detalleOferta_new;
	    		lstWrapperOCxDO.add(objWrapperOCxDO);
	    		
	    	}
	    	
	    	//Generamos la lista de Operaciones Comerciales para posteriormente insertarlas
	    	for(WrapperOCxDO objW : lstWrapperOCxDO){
	    		lstOC.add(objW.objWOC);
	    	}
	    	
	    	if(!lstOC.isEmpty()){
	    		insert lstOC;
	    	} else{
	    		//Mensaje error de que no hay ninguna Oc para guardar debido a que no selecciono ningun cambio de plan
	    		Database.rollback(sp);
	    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_No_Creo_OC));
	    		System.debug('======> No se creó la (las) Operación Comercial debido a que no selecciono ningún cambio de plan.');
	    		return null;
	    	}
	    	
	    	//Generamos la lista de Detalles de Oferta para posteriormente insertarlas
	    	for(WrapperOCxDO objW : lstWrapperOCxDO){
	    		objW.objWDO.LTE_OperacionComercial__c = objW.objWOC.Id;
	    		lstDO.add(objW.objWDO);
	    	}
	    	
	    	if(!lstDO.isEmpty()){
	    		insert lstDO;
	    	} else{
	    		//Mensaje error de que no hay ningun DO para guardar debido a que no selecciono ningun cambio de plan
	    		Database.rollback(sp);
	    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_No_Creo_DO));
	    		System.debug('======> No se pudo crear el (los) Detalle de Oferta debido a que no selecciono ningún cambio de plan.');
	    		return null;
	    	}
	    	
	        lstDO = getLstDetalleOferta(lstDO); // Reeleer la lista para tener acceso a los campos relacioandos //LRPA 06-01-2016
	        
	        // Se generan los servicios adicionales para los planes seleccionados
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
                objPlanTmp = mapPlanes.get(Id.valueOf(objCambioPlan.detalleOferta_new.Plan__c));
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
	    	
	    	Case caso = new Case(Id = this.idCase);
	    	caso.Aprobaciones__c = 'Oferta Realizada';
	    	update caso;
	    	
	    	PageReference prAprovisionarAprobar = Page.LTE_AprovisionarAprobarTramite_pag;
	    	prAprovisionarAprobar.getParameters().put('idCaso', this.idCase);
	    	return prAprovisionarAprobar;
    	/*} catch(Exception e){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
    		Database.rollback(sp);
    		return null;
    	} */
    	
    }
  
 
    /**
    * Metodo encargado de leer los detalles de oferta recien insertados
    * LRPA 06-01-2016
    */ 
	  public list<LTE_DetalleOferta__c> getLstDetalleOferta(list<LTE_DetalleOferta__c>  lstDO)  {
	  	list<LTE_DetalleOferta__c> lstDetOferta;
	  	set<String> setIdDetalleOferta = new  set<String>();
	  	for(LTE_DetalleOferta__c objDO:  lstDO){
	  		setIdDetalleOferta.add(objDO.id);
	  	}
	  	lstDetOferta = [select id,LTE_DescuentoPlan__c,LTE_OperacionComercial__r.Activo__c,
	  	                       Plan__c,LTE_MinutoVoz__c,LTE_DescuentoVoz__c,LTE_DatosNavegacion__c, LTE_DescuentoDatos__c
	  	                       from LTE_DetalleOferta__c where id in:setIdDetalleOferta];
	  	return lstDetOferta;
	  }

	    		
	    		
    /**
    * Metodo encargado de calcular el nuevo valor recurrente
    * de acuerdo a los planes seleccionados.
    */
    public PageReference calcularNuevoValorRecurrente(){
    	
    	List<Id> lstPlanes = new List<Id>();
        List<Id> lstSubPlanes = new List<Id>();
        Decimal dcmValorPlanes = 0;
        Decimal dcmValorSubPlanes = 0;
        Boolean error = false;
    	
    	ocultarDescuentoPlan();
        
        for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
        	if(!objCambioPlan.LTE_PlanMedida && objCambioPlan.detalleOferta_new.Plan__c == null){
        		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe seleccionar un Plan para la línea ' + objCambioPlan.activoETB.NumeroConexion__c + ' en el índice ' + (objCambioPlan.index+1)));
        		error = true;
        	}
        	
        	if(objCambioPlan.LTE_PlanMedida && objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c == null && objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c == null){
        		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe seleccionar un Subplan de voz o datos para el plan ' + mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).Name + ' de la línea ' + objCambioPlan.activoETB.NumeroConexion__c + ' en el índice ' + (objCambioPlan.index+1)));
        		error = true;
        	}
        	
            if(objCambioPlan.prepago_postpago && String.isEmpty(objCambioPlan.idCuentaFacturacion)){
            	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Debe seleccionar una cuenta de facturación para el plan ' + mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).Name + ' de la línea ' + objCambioPlan.activoETB.NumeroConexion__c + ' en el índice ' + (objCambioPlan.index+1)));
            	error = true;
            }
            
            if(objCambioPlan.detalleOferta_new.Plan__c != null && this.mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).TipodePlan__c != 'Principal'){
	        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'El nuevo plan ' + mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).Name + ' para la línea ' + objCambioPlan.activoETB.NumeroConexion__c + ' no es valido, por favor seleccione otro.' ));
	        	error = true;
	        }
            
            if(error){
            	return null;
            }
        	
        	dcmValorPlanes += (mpValoresPlanes.get(objCambioPlan.detalleOferta_new.Plan__c).Tarifa__c);
        	//Suma el valor de las bolsas
            if(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c != null)
            {
                dcmValorSubPlanes += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_MinutoVoz__c).LTE_Precio__c);
            }
            if(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c != null)
            {
                dcmValorSubPlanes += (mpValoresSubPlanes.get(objCambioPlan.detalleOferta_new.LTE_DatosNavegacion__c).LTE_Precio__c);    
            }
        }
        this.dcmNuevoValorRecurrente = dcmValorPlanes + dcmValorSubPlanes;
        this.blnBotonGuardar = true;
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
		this.blnPlanesHomogeneos = false;
    	this.blnBloqueServicios = false;
    	this.blnBloqueHomogeneos = false;
		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, mensaje));
    }
    
    /**
    * Metodo encargado de mostrar el descuento guardado en el popup, en el campo de Descuento
    */
    public PageReference mostrarDescuento(){
    	if(strDescuentoType == 'DtoPlan' && strDescuentoId != ''){
	    	this.objReservaHomogeneo.LTE_DescuentoPlan__c = strDescuentoId;
	        this.objReservaHomogeneo.LTE_DescuentoPlanAux__c = strDescuentoName;
    	}
    	if(strDescuentoType == 'DtoVoz' && strDescuentoId != ''){
            this.objReservaHomogeneo.LTE_DescuentoVoz__c = strDescuentoId;
            this.objReservaHomogeneo.LTE_DescuentoVozAux__c = strDescuentoName;  
        }
        if(strDescuentoType == 'DtoDato' && strDescuentoId != ''){
            this.objReservaHomogeneo.LTE_DescuentoDatos__c = strDescuentoId;
            this.objReservaHomogeneo.LTE_DescuentoDatosAux__c = strDescuentoName;  
        }
        return null;
    }
    
    //Metodo que actualiza los valores de los descuentos
    public PageReference actualizarTablaDescuentos()
    {
        for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
            if( objCambioPlan.index == intRow )
            {
                if(strType == 'DtoPlan' && strNivelId != '')
                {
                    objCambioPlan.detalleOferta_new.LTE_DescuentoPlan__c = strNivelId;
					objCambioPlan.nombreDescuentoPlan = strNivel;
					objCambioPlan.etiquetaAgregarCambiarDtoPlan = etiquetaBotonCambiar;
					objCambioPlan.blnBtnBorrarDtoPlan = true;
                } 
                if(strType == 'DtoVoz' && strNivelId != '')
                {
                    objCambioPlan.detalleOferta_new.LTE_DescuentoVoz__c = strNivelId;
					objCambioPlan.nombreDescuentoVoz = strNivel;
                	objCambioPlan.etiquetaAgregarCambiarDtoVoz = etiquetaBotonCambiar;
                	objCambioPlan.blnBtnBorrarDtoVoz = true;
                } 
                if(strType == 'DtoDato' && strNivelId != '')
                {
                    objCambioPlan.detalleOferta_new.LTE_DescuentoDatos__c = strNivelId;
					objCambioPlan.nombreDescuentoDatos = strNivel;
                	objCambioPlan.etiquetaAgregarCambiarDtoDatos = etiquetaBotonCambiar;
                	objCambioPlan.blnBtnBorrarDtoDatos = true;
                } 
            }
        }
        return null;
    }
    
     /**
     * Metodo encargado de mostrar cuando se selecciona una cuenta de facturacion para un cambio de plan.
     */
    public PageReference actualizarCtaFacturacion(){
    	Integer intCicloFacturacion;
        for(LTE_DetalleOfertaCambioPlan_cls objCambioPlan : this.lstCambioPlan){
            if( objCambioPlan.index == intRow )
            {
                objCambioPlan.idCuentaFacturacion = strNivelId;
				objCambioPlan.nombreCuentaFacturacion = strNivel;
				
				try{
					intCicloFacturacion = Integer.valueOf(objCambioPlan.activoETB.CuentaFacturacion__r.LTE_CicloFacturacion__c);
				} catch(Exception e){
					intCicloFacturacion = -1;
					System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
				}
				
				if(intCicloFacturacion == -1)
					objCambioPlan.cicloFacturacion = '';
				else
					objCambioPlan.cicloFacturacion = intCicloFacturacion + ' ';
				
				objCambioPlan.fechaProximoCiclo = obtenerFechaCorte(intCicloFacturacion, false);
            }
        }
        return null;
    }
    
    /**
    * Metodo encargado de seleccionar todos los checkbox de la lista Activos cuando se
    * clic en la casilla de la cabecera de los checkbox
    *
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
    * Metodo encargado de redireccionar hacia la pagina de aprovisionamiento.
    */
    public PageReference continuarAprovisionamiento(){
    	PageReference prAprovisionarAprobar = Page.LTE_AprovisionarAprobarTramite_pag;
    	prAprovisionarAprobar.getParameters().put('idCaso', this.idCase);
    	prAprovisionarAprobar.setRedirect(true);
    	return prAprovisionarAprobar;
    }
    
    public PageReference mostrarPlanHomogeneo(){
    	if(blnPlanesHomogeneos){
    		blnBloqueHomogeneos = true;
    		blnPlanHomogeneo = true;
    	} else{
    		blnBloqueHomogeneos = false;
    		blnPlanHomogeneo = false;
    	}
    	return null;
    }
    
    public PageReference mostrarDctoHomogeneo(){
    	return null;
    }
    
    /**
    * Metodo encargado de calcular la fecha de corte a partir del ciclo de facturacion.
    */
    public String obtenerFechaCorte(Integer intCicloFacturacion, boolean blnEsPrepago){
    	Date fechaCorteFinal;
    	Date fechaCorteInicial;
    	Date fechaHoy = system.today();
    	if(intCicloFacturacion == -1){
    		return 'Sin Corte';
    	} else{
	    	if(blnEsPrepago){
	    		fechaCorteFinal=fechaHoy.addDays(1);
	    	} else{
	    		if(intCicloFacturacion != null)
					{
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
	    	}
	    	
	    	if(fechaCorteFinal == null){
	    		return '';
	    	} else{
	    		Datetime dt = datetime.newInstance(fechaCorteFinal.year(), fechaCorteFinal.month(), fechaCorteFinal.day());
	    		return  dt.format('dd/MM/yyyy');
	    	}
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
            		if(oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio de Plan'){
            			activoWrapper.desactivar();
            		}
            	}
            	
            	lstActivosWrapper.add(activoWrapper);
            }
            else{
            	activoWrapper = new LTE_ActivoETB_Wrapper(activo);
            	for(OperacionComercial__c oc : activo.Operaciones_Comerciales__r){
            		if(oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio de Plan'){
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
    
    /**
    * Clase  usada para encapsular una Operacion Comercial y un Detalle de Oferta
    * para ser usadas en el proceso de generacion de detales de oferta en el cambio de plan.
    */
    public class WrapperOCxDO{
    	public OperacionComercial__c objWOC;
    	public LTE_DetalleOferta__c objWDO;
    }
    
    
    
	/***********************************************************************************************************************
	Desarrollado por:   Avanxo Colombia
	Autor:              Juan David uribe Ruiz
	Proyecto:           LTE Fase II
	Descripción:        Clase DTO para encapsular los datos de los Detalles de la oferta en los cambios de plan
	
	Cambios (Versiones)
	-----------------------------------------------------
	No.     Fecha           Autor                                      Descripción
	----    ----------      -----------------------------              ---------------
	1.0     2015-12-07      Juan David Uribe R. (JDUR)               Creación de la clase.
	***********************************************************************************************************************/
	public class LTE_DetalleOfertaCambioPlan_cls {
		
		public Integer index 									{get; set;}
		public Boolean LTE_PlanMedida							{get; set;}
		public Boolean prepago_postpago							{get; set;}
		public Boolean postpago_prepago							{get; set;}
		public Boolean prepago_prepago							{get; set;}
		public Boolean postpago_postpago						{get; set;}
		public ActivoETB__c activoETB			  				{get; set;}
		public LTE_DetalleOferta__c detalleOferta_new			{get; set;}
		public LTE_DetalleOferta__c detalleOferta_old			{get; set;}
		public String nombreDescuentoPlan						{get; set;}
		public String nombreDescuentoVoz						{get; set;}
		public String nombreDescuentoDatos						{get; set;}
		public String nombreCuentaFacturacion					{get; set;}
		public Id idCuentaFacturacion							{get; set;}
		public String cicloFacturacion							{get; set;}
		public String fechaProximoCiclo							{get; set;}
		public Decimal nuevoValorRecurrentePlan					{get; set;}
		
		/* Variables para botones */
		public String etiquetaAgregarCambiarDtoPlan				{get; set;}
		public Boolean blnBtnBorrarDtoPlan						{get; set;}
		
		public String etiquetaAgregarCambiarDtoVoz				{get; set;}
		public Boolean blnBtnBorrarDtoVoz						{get; set;}
		
		public String etiquetaAgregarCambiarDtoDatos			{get; set;}
		public Boolean blnBtnBorrarDtoDatos						{get; set;}
        public Boolean LTE_DatosNavegacionConfigurado    		{get; set;}
        public Boolean LTE_MinutosVozConfigurado     		    {get; set;}
            
		
		public LTE_DetalleOfertaCambioPlan_cls(){
			activoETB = new ActivoETB__c();
			detalleOferta_new = new LTE_DetalleOferta__c();
			detalleOferta_old = new LTE_DetalleOferta__c();
			prepago_postpago = false;
			postpago_prepago = false;
			prepago_prepago = false;
			postpago_postpago = false;
			nombreDescuentoPlan = '';
			nombreDescuentoVoz = '';
			nombreDescuentoDatos = '';
			nombreCuentaFacturacion = '';
			cicloFacturacion = '';
			fechaProximoCiclo = '';
			nuevoValorRecurrentePlan = 0;
			
			etiquetaAgregarCambiarDtoPlan = 'Agregar';
			blnBtnBorrarDtoPlan = true;
			
			etiquetaAgregarCambiarDtoVoz = 'Agregar';
			blnBtnBorrarDtoVoz = true;
			
			etiquetaAgregarCambiarDtoDatos = 'Agregar';
			blnBtnBorrarDtoDatos = true;
		}
	    
	}
    

	/***********************************************************************************************************************
	Desarrollado por:   Avanxo Colombia
	Autor:              Juan David uribe Ruiz
	Proyecto:           LTE Fase II
	Descripción:        Clase Wrapper para encapsular los datos de los ActivoETB seleccionados en las operaciones de cambio de plan
	
	Cambios (Versiones)
	-----------------------------------------------------
	No.     Fecha           Autor                                      Descripción
	----    ----------      -----------------------------              ---------------
	1.0     2015-12-07      Juan David Uribe R. (JDUR)               Creación de la clase.
	***********************************************************************************************************************/
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