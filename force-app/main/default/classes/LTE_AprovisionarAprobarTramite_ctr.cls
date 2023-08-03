/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Luis Rafael Peñaranda
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de selección del Trámite 

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-12-09		Luis Rafael Peñaranda(LRP)				 Creación de la clase.
1.1     2016-01-13		Andrés Garrido(AG)				 Se comentan las variables no usadas para aumentar cobertura.
***********************************************************************************************************************/
public with sharing class LTE_AprovisionarAprobarTramite_ctr {
	
    //public Account objCuenta                               	{get; set;} AG 2016-01-13
    public Case objCaso                                 		{get; set;}
    //public List<TOPP__c> lstTipoOperacion                     {get; set;} AG 2016-01-13
    public Boolean blnBotonAproDcto 							{get; set;}
    public Boolean blnBotonEnvAprov 							{get; set;}
    //public String tipoOperacion								{get; set;} AG 2016-01-13
    
    public list<OperacionComercial__c>  listaOc;
    public map<String,LTE_DetalleOferta__c> mapDetOfertaXOc;
    
    private Map<string,VariablesGlobales__c> vGlobal;
    private Map<Id,TOPP__c> mapTipoOperacion;
    
    /** 
    * Constructor del controlador encargado de inicializar las variables
    * y hacer unas validaciones iniciales.
    */
    public LTE_AprovisionarAprobarTramite_ctr(){
    	
        String idCaso;
        if(Apexpages.currentPage().getParameters().get('idCaso')!=null)
        {
            idCaso =Apexpages.currentPage().getParameters().get('idCaso');
        }
        this.objCaso = this.obtenerCaso(idCaso);  	

// Obtener las Oc's relacionadas al caso
		this.listaOc = this.OperacionesComerciales(this.objCaso.id);
		    	
		// Obtener detalles de oferta de la lista de OC
		mapDetOfertaXOc= this.ConsultaDetalleOferta(this.listaOc);
		
		// si algunas de las OC's tiene descuento, se activa el boton de enviar aprobacion descuento
		boolean hayDcto = this.identificarHaydescuento(this.listaOc);
		system.debug('##hayDcto-->'+hayDcto);

		blnBotonAproDcto=false;
		blnBotonEnvAprov=false;		
		
		if(this.objCaso.Aprobaciones__c == 'Oferta Realizada'){
			if(hayDcto){
					blnBotonAproDcto=true;
			}else{
					blnBotonEnvAprov=true;			
			}			
		}else if(this.objCaso.Aprobaciones__c == 'Aprobado'){
				blnBotonEnvAprov=true;				
		}
    	
    	system.debug('##blnBotonAproDcto-->'+blnBotonAproDcto);
    	system.debug('##blnBotonEnvAprov-->'+blnBotonEnvAprov);    	
    }

    /**
    * Metodo ecargado de Enviar a aprobación de descuentos
    */
    public PageReference enviarAprobacionDescuento()
   	{
			LTE_AprobacionCasos_cls clasOper = new LTE_AprobacionCasos_cls();
			boolean result = clasOper.EnviarProcesoAprovacionOpp(this.objCaso);
			if(result == true){
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.Mensaje_Sol_Aprob_Dcto));
			}else{
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El usuario no tiene asignado un aprobador LTE'));
			}
   		   	return null;	
    }
    
    /**
    * Metodo ecargado de redireccionar hacia otra pagina.
    */
    public PageReference enviarAprovisionamiento()
   	{
		LTE_AprobacionCasos_cls clasOper = new LTE_AprobacionCasos_cls();
		LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
		map<String, date>  mapIdOpComXFechaCorte= null;
		set<Id> setIdOcs = new set<Id>();

		Savepoint sp = Database.setSavepoint();
		
		// Obtener la fecha de corde para cada Oc
		 mapIdOpComXFechaCorte = clasOper.calcularFechaCorteOpCom(this.listaOc);
		
		for(OperacionComercial__c oc:this.listaOc){			
			if(mapIdOpComXFechaCorte.get(oc.id) != null){ 					// si pudo calcular una fehca de corte para la OC
				oc.FechaInicioReconexion__c = mapIdOpComXFechaCorte.get(oc.id); // Asignar fecha de corte
				oc.Estado__c			= 'En curso'; 						// Poner Oc's en estado En Curso
				setIdOcs.add(oc.id);
			}			
		}
		
		try{
			
			// Actualizar lista Oc's con fecha de corte y estado En curso
			update listaOc;			
			
			// Parametrizar Servicios adicionales y  generar XA's
			LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcs,'OC');
			
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
	    for(OperacionComercial__c oc:this.listaOc){
	    	setidOperacionComercial.add(oc.id);
	    } 
		
		if(setidOperacionComercial.size()>0){ 
			LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
			batchA.idImediato=setidOperacionComercial;
			if( !Test.isRunningTest() )
			{
				//ID batchprocessid = Database.executeBatch(batchA, 1);	
				this.objCaso.Aprobaciones__c = 'Enviado aprovisionamiento';
				update this.objCaso;
			}
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.Mensaje_Aprovisionamiento_Exitoso));		
		}else{
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Mensaje_No_Hay_Planes_Aprovisionar));
		}
			
		// Generaa Servicios Adicionales por planes y bolsas
   		return null;
   		
    } 

    
    //Metodo ecargado de obtener la lista de operaciones comerciales de cambio de plan asociadas al caso        
    public list<OperacionComercial__c> OperacionesComerciales(string idCaso)
	{
    	list<OperacionComercial__c> listOC =[Select id,CuentaFacturacion__r.LTE_CicloFacturacion__c,Activo__r.PlanReferenciaAnterior__c,Plan__r.Name  
    										from OperacionComercial__c
    	                                     where 	Estado__c	=	'Pendiente'
    	                                     and 	Caso__c 	=:	idCaso
    	                                     and TOPP__r.TipodeOperacionporplan__c = 'Cambio de Plan'];
    	return listOC;
	}	

    //Metodo ecargado de identificar si la lista de operaciones comerciales, contiene al menos una con descuentos        
    public boolean identificarHaydescuento(list<OperacionComercial__c> listaOc)
	{
		boolean existeDcto = false;
		LTE_DetalleOferta__c detOf;
    	for(OperacionComercial__c oc: listaOc){
    		detOf = mapDetOfertaXOc.get(oc.id);
    		if(detOf.LTE_DescuentoPlan__c != null || detOf.LTE_DescuentoVoz__c != null || detOf.LTE_DescuentoDatos__c != null){
    			existeDcto=true;
    		}
    	}
    	 
		return existeDcto;
	}	

	// Leer los registro de detalles de oferta relacionados con las OC's
	public map<String,LTE_DetalleOferta__c> ConsultaDetalleOferta(list<OperacionComercial__c> listaOc)
	{
		    set<String> setidOperacionComercial = new set<String>();
		    for(OperacionComercial__c oc:listaOc){
		    	setidOperacionComercial.add(oc.id);
		    }  
		    system.debug('idOperacionComercial-->'+setidOperacionComercial);	    
			map<String,LTE_DetalleOferta__c> mapDetalleOferta = new map<String,LTE_DetalleOferta__c>();
			list<LTE_DetalleOferta__c> lstDetOferta = [Select l.Plan__c, l.Name, 	l.LTE_DescuentoPlan__c,l.LTE_DescuentoVoz__c, l.LTE_DescuentoDatos__c,LTE_OperacionComercial__c
													   From LTE_DetalleOferta__c l
														Where l.LTE_OperacionComercial__c =:setidOperacionComercial];
			
			for(LTE_DetalleOferta__c objDetOderta:lstDetOferta){
				mapDetalleOferta.put(objDetOderta.LTE_OperacionComercial__c,objDetOderta);
			}
		return mapDetalleOferta;
	}

   // Leer caso de la BD
   public case obtenerCaso(String idCaso){
   	 list<case> lstCaso = [select id,CaseNumber,Account.Name,Aprobaciones__c,Status,Subject	  from case where id=:idCaso];
   	 if(!lstCaso.isEmpty()){
   	 	return lstCaso.get(0);
   	 }else{
   	 	return null;
   	 }
   }	       
}