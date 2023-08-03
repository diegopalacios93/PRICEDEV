/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan Gabriel Duarte Pacheco
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase controladora para la generacion de las Operaciones Comerciales y Servicios

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-08-09      Juan Gabriel Duarte P. (JGD)               Creación de la clase.
2.0		2015-08-14		Walter Rodríguez M.	(WR)                   Crear Servicios Adicionales
3.0     2015-08-31      Carlos A. Rodriguez B. [CR]                Validación detalles de oferta sin sucursal o con equipo traido y sin Imei.
***********************************************************************************************************************/

public with sharing class LTE_GenerarOC_ctr {
	//Definicion de variables globales
	private Apexpages.Standardcontroller stdController;
	public Opportunity objOportunidad                               {get; set;}
	public Boolean blnMostrarBoton                                  {get; set;}
	public List<LTE_DetalleOferta__c> lstDetallesOferta             {get; set;}

	//Metodo constructor de la clase
	public LTE_GenerarOC_ctr(ApexPages.StandardController stdController) {
		this.stdController = stdController;
        this.objOportunidad = (Opportunity)stdController.getRecord();
        blnMostrarBoton = true;
        lstDetallesOferta = new List<LTE_DetalleOferta__c>();

        //Consulta informacion de la oportunidad
        objOportunidad = [SELECT Id,AccountId,EstadodeAprobacionDescuentos__c,isClosed, 
                                 LTE_OfertaCustomizada__c,LTE_NumeroLinea__c,LTE_OportunidadBloqueada__c,
                                 LTE_ScoringMensual__c,LTE_FechaCreacionOC__c, Servicio_APN_Relacionado__c,
                          		 LTE_Bolsa_Compartida__c,Servicio_Bolsa_Compartida_Padre__r.Id, 
                                 (Select Id From Operaciones_Comerciales__r) 
                                 FROM Opportunity 
                                 WHERE Id =: objOportunidad.Id];
		
        if(objOportunidad.LTE_OportunidadBloqueada__c)
        {
            blnMostrarBoton = false;
             Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info,'La oportunidad tiene un proceso de aprobación en curso!'));
        }
        System.debug('LTE_OportunidadBloqueada__c'+objOportunidad.LTE_OportunidadBloqueada__c );
        System.debug('EstadodeAprobacionDescuentos__c'+objOportunidad.EstadodeAprobacionDescuentos__c );
        if(objOportunidad.LTE_OportunidadBloqueada__c && objOportunidad.EstadodeAprobacionDescuentos__c != null && !objOportunidad.EstadodeAprobacionDescuentos__c.equals('Aprobado'))
        {
            blnMostrarBoton = false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info,Label.LTE_OportunidadDescuento));
        }
        if(objOportunidad.isClosed)
        {
            blnMostrarBoton = false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info, Label.LTE_OportunidadCerrada));
        }
        if(!objOportunidad.Operaciones_Comerciales__r.isEmpty())
        {
            blnMostrarBoton = false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info,Label.LTE_OportunidadOC));
        }
        
        //Consulta informacion de los detalles de oferta
        lstDetallesOferta = obtenerDetalleOferta();
        //La oferta es menor a 30 lines muestra el detallen en la pagina vf
        if(lstDetallesOferta.isEmpty())
        {
            blnMostrarBoton = false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info,'Para generar las Operaciones Comerciales primero debe registrar los Detalles de Oferta!'));
        }

        //[CR] Validación detalles de oferta sin sucursal o con equipo traido y sin Imei. 
        Integer intImeiSucursal = validarImeiSucursal();
        if(intImeiSucursal>0)
        {
            blnMostrarBoton=false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Warning,'Debe primero ingresar la sucursal para los detalles de oferta y el Imei para los detalles de oferta que tengan equipos traidos!'));
        }

        //Realiza la validacion de listas negras
        Integer pendientes = validarListasNegras();
        if(pendientes>0)
        {
            blnMostrarBoton=false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Warning,'Debe primero gestionar '+pendientes+' detalle de oferta pendiente por Listas Negras!'));
        }

	}

    //Permite mostrar los mensajes desde el constructor
	public Pagereference mostrarMensaje()
  	{
    	return null;
   	}

    //Metodo para la generacion de las OCs y Servicio a partir de los Detalles de Oferta
   	public Pagereference crearOCs()
   	{
        List<DetalleOC> lstDetalleOC = new List<DetalleOC>();
   		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
   		List<ActivoETB__c> lstServicios = new List<ActivoETB__c>();
   		List<Id> lstIdOCs = new List<Id>();
   		List<Id> lstIdServicios = new List<Id>();
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        String strCatalogo = vGlobal.Valor__c;
        
        Id servicioLTE = Schema.SObjectType.ActivoETB__c.getRecordTypeInfosByName().get('Servicio LTE').getRecordTypeId();

        List<TOPP__c> lstToop = [SELECT Id FROM TOPP__c 
                                    WHERE Tipoderegistro__c = 'Venta_LTE' 
                                    AND LTE_Catalogo_de_Producto__r.Name =: strCatalogo 
                                    AND TipodeOperacionporplan__c = 'Venta'
                                    AND DisponibleVentainicial__c = true];

        //Obtiene los tipos de registros correspondientes al objeto OC
        Schema.DescribeSObjectResult R = OperacionComercial__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        String strRTVentaLTE = '';
        for(Schema.RecordTypeInfo objRT:RT)
        {
            if(objRT.getName().equals('Venta LTE'))
            {
                System.debug('RecordTypeId Venta LTE-> '+objRT.getRecordTypeId() );
                strRTVentaLTE = objRT.getRecordTypeId();
            }
        }
   		//Se recorren los detalles de oferta para crear los servicios y OCs
   		for(LTE_DetalleOferta__c objDetalle:lstDetallesOferta)
        {
        	objDetalle.LTE_Estado_Detalle_Oferta__c = 'Reservado';
            DetalleOC objClase = new DetalleOC();
        	//Informacion de la OC
        	OperacionComercial__c objOC = new OperacionComercial__c();
        	objOC.CuentaCliente__c = objOportunidad.AccountId;
        	objOC.Plan__c = objDetalle.Plan__c;
        	objOC.Oportunidad__c = objOportunidad.Id;
        	objOC.Portacion__c = objDetalle.LTE_RequierePortacion__c;
            objOC.Estado__c = 'Pendiente';
            objOC.RecordTypeId = strRTVentaLTE;
            objOC.LTE_Donante__c = objDetalle.LTE_Donante__c;
            objOC.NumeroConexion__c = objDetalle.LTE_NumeroLinea__c;
            objOC.LTE_Tipo_de_Servicio__c = objDetalle.LTE_Tipo_de_Servicio__c;
            objOc.IMEI_del_Equipo__c = objDetalle.LTE_IMEI__c;
            objOc.LTE_ICCID__c = objDetalle.LTE_ICCID__c;
            objOc.NumeroConexion__c = objDetalle.LTE_NumeroLinea__c;
            objOc.LTE_EquipoTraido__c = objDetalle.LTE_EquipoTraido__c;
            objOc.LTE_SolicitadoPorTercero__c = objDetalle.LTE_SolicitadoPorTercero__c;
            objOc.ValorTarifaPlan__c = objDetalle.LTE_Valor_Total_Plan__c;
            objOc.Valorunicavez__c = objDetalle.LTE_ValorDespuesImpuestoIVA__c;
            objOc.LTE_ReferenciaEquipo__c = objDetalle.LTE_ReferenciaEquipo__c;
            objOc.Portado_con_Cedula__c = objDetalle.Portado_con_Cedula__c;
            objOc.LTE_Estado_c_del__c = objDetalle.LTE_Estado__c;
            
            objOC.Contacto_Tecnico__c= objDetalle.LTE_ContactoEntrega__c;
            objOC.SucursalDestino__c = objDetalle.LTE_Sucursal__c;
           
            if(!lstToop.isEmpty())
            {
                objOC.TOPP__c = lstToop.get(0).Id;    
            }              
        	//Informacion del servicio
        	ActivoETB__c objServicio = new ActivoETB__c();
        	objServicio.LTE_DetalleOferta__c = objDetalle.Id;
        	objServicio.NombredelaCuenta__c = objOportunidad.AccountId;
        	objServicio.Plan__c = objDetalle.Plan__c;
        	objServicio.Oportunidad__c = objOportunidad.Id;
        	objServicio.SucursalDestino__c = objDetalle.LTE_Sucursal__c;
            objServicio.NombredelProducto__c = objDetalle.Plan__r.NombredelProducto__c;
            objServicio.recordTypeId=servicioLTE;
            
            //[FSARASTY, 2020/05/01]: Bolsas compartidas - Actualizar campo tipo de línea
            if(objOportunidad.LTE_Bolsa_Compartida__c){                
            	objOC.Tipo_linea_bolsa_compartida__c 	   = objDetalle.Tipo_linea_bolsa_compartida__c;
                objServicio.Tipo_linea_bolsa_compartida__c = objDetalle.Tipo_linea_bolsa_compartida__c;
            }
            //FIN [FSARASTY, 2020/05/01]
            objClase.OperacionComercial = objOC;
            objClase.DetalleOferta = objDetalle;
            objClase.Servicio = objServicio;
            lstDetalleOC.add(objClase);  

        	lstServicios.add(objServicio);
        }
        
        Savepoint sp = Database.setSavepoint();
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        BanderasEjecucion.setEjecucion('DesenCadenaFacFacturador');
        BanderasEjecucion.setEjecucion('DesenCadena_actualizarCamposOC');
        try{
            if(!lstServicios.isEmpty())
            {
                System.debug('lstServicios-> '+lstServicios);
                Database.SaveResult[] srListServicios = Database.insert(lstServicios, true);
                for (Database.SaveResult sr : srListServicios) {
	    			if (sr.isSuccess()) {
	        			lstIdServicios.add(sr.getId());
	    			}
	    		}
            }

            for(DetalleOC objClase: lstDetalleOC)
            {
                objClase.OperacionComercial.Activo__c = objClase.Servicio.Id;
                lstOC.add(objClase.OperacionComercial);
            }
            
            
            if(!lstOC.isEmpty())
            {
                System.debug('lstOC-> '+lstOC);
                Database.SaveResult[] srList_OCs = Database.insert(lstOC, true);
               	
               	for (Database.SaveResult sr : srList_OCs) {
	    			if (sr.isSuccess()) {
	        			lstIdOCs.add(sr.getId());
	    			}
	    		}
	    	}

            objOportunidad.LTE_FechaCreacionOC__c = System.today();

            list<sobject> so= new list<sobject>();
            list<sobject> so2= new list<sobject>();

            for(DetalleOC objClase: lstDetalleOC)
            {
                objClase.DetalleOferta.LTE_OperacionComercial__c = objClase.OperacionComercial.Id;
                objClase.DetalleOferta.LTE_Estado_Detalle_Oferta__c = 'Reservado';
                so.add(objClase.DetalleOferta);
                system.debug(objClase.DetalleOferta);
            }
            so.addAll(so2);

            BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            update so;
            update objOportunidad;
            BanderasEjecucion.unsetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            //update lstDetallesOferta;
            //Llama al metodo para crear los servicios adicionales luego de crear las OC. 
			crearServicioAdicional();
            CrearOCDesdeActivo();
            procesarBolsaCompartida();
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,'La generación de Operaciones Comerciales ha sido satisfactoria!'));
            blnMostrarBoton=false;
        }catch(exception e)
        {
        	Database.rollback(sp);
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Ocurrió el siguiente error generando las Operaciones Comerciales: '+e.getmessage()));
        }

        return null;
   	}
   	
    //Consulta los detalles de oferta a partir de la oportunidad
    List<LTE_DetalleOferta__c> obtenerDetalleOferta()
    {
        return [SELECT Id,LTE_EquipoTraido__c,LTE_IMEI__c,LTE_NumeroLinea__c,LTE_Estado_Detalle_Oferta__c,
                    LTE_Oferta_Economica__c,LTE_ReferenciaEquipo__c,LTE_RequierePortacion__c, LTE_Donante__c, LTE_Tipo_de_Servicio__c,
                    LTE_Sucursal__c,Plan__c, LTE_DatosNavegacion__c, LTE_DatosNavegacion__r.Name, LTE_MinutoVoz__c, LTE_MinutoVoz__r.Name,
                    LTE_BolsaRecurrenteVoz__r.Name, LTE_BolsaRecurrenteDatos__c, LTE_BolsaRecurrenteDatos__r.Name, LTE_SvaJSON__c,
                    LTE_DescuentoDatos__c, LTE_DescuentoVoz__c, LTE_DescuentoSobreBolsaRecurrenteVoz__c, LTE_DescuentoSobreBolsaRecurrenteDatos__c,
                    Plan__r.NombredelProducto__c, LTE_ContactoEntrega__c, Plan__r.Aplica_SVA_Redes_Sociales__c,
                	LTE_Valor_Total_Plan__c,LTE_ValorDespuesImpuestoIVA__c, Tipo_linea_bolsa_compartida__c,LTE_DescuentoSVAs__c,LTE_DescuentoSVAs_Voz__c, Portado_con_Cedula__c
                FROM LTE_DetalleOferta__c 
                WHERE LTE_Oferta_Economica__r.Oportunidad__c=:objOportunidad.Id 
                AND LTE_Estado__c != 'Declino'
                ORDER BY Plan__c];        
    }

    //Clase interna
    public class DetalleOC
    {
        public LTE_DetalleOferta__c DetalleOferta;
        public OperacionComercial__c OperacionComercial;
        public ActivoETB__c Servicio;
    }

    //Metodo que devuelve el numero de detalles pendientes por LN
    public Integer validarListasNegras()
    {
    	return [SELECT COUNT() FROM LTE_DetalleOferta__c 
    			WHERE (LTE_EquipoTraido__c = true OR LTE_ReferenciaEquipo__r.Name='Equipo Traido') AND LTE_IMEI__c != null
    			AND LTE_Estado__c NOT IN ('No reportado','Declino')   
    			AND LTE_Oferta_Economica__r.Oportunidad__c=:objOportunidad.Id];
    }

    /*
    * @Autor:       Carlos Rodríguez [CR]
    * @Metodo:      validarImeiSucursal
    * @Descripcion: Metodo que devuelve el numero de detalles de oferta sin Sucursal o con equipo traido sin Imei.
    */
    public Integer validarImeiSucursal()
    {
        //Cuenta el número de detalles de oferta que no tienen sucursal o los que son equipo traido y no tienen imei registrado. 
        return [SELECT COUNT() FROM LTE_DetalleOferta__c 
                WHERE (((LTE_EquipoTraido__c = true OR LTE_ReferenciaEquipo__r.Name='Equipo Traido') AND LTE_IMEI__c = null) 
                OR (LTE_Sucursal__c = null OR LTE_Sucursal__c = ''))   
                AND LTE_Oferta_Economica__r.Oportunidad__c=:objOportunidad.Id];
    }

	/*
	* @Autor:		Walter Rodríguez (WR)
	* @Metodo:		crearServicioAdicional
	* @Descripcion:	Metodo encargado de crear los servicios adicionales dependiendo de los detalles de la oferta.
	*/
	public void crearServicioAdicional()
	{
		system.debug('Entro al metodo');
		list<LTE_Servicios_adicionales__c> lstServicioAdicional = new list<LTE_Servicios_adicionales__c>();
		LTE_Servicios_adicionales__c objAdicional; 
		system.debug('lstDetallesOferta --> ' + lstDetallesOferta);
		//Se recorren los detalles de oferta para crear los servicios y OCs
		List<SubPlanFacturacion__c> lstProm_RedesSociales = [SELECT Id,Name FROM SubPlanFacturacion__c WHERE Name = 'SVA Bolsa Recurrente Redes Sociales 500MB'];
		for(LTE_DetalleOferta__c objDetalle : lstDetallesOferta)
		{
			if(objDetalle.LTE_DatosNavegacion__c != null)
			{
				objAdicional = new LTE_Servicios_adicionales__c();
				objAdicional.Name = objDetalle.LTE_DatosNavegacion__r.Name;
				objAdicional.LTE_SubPlaFacturacion__c = objDetalle.LTE_DatosNavegacion__c;
				objAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalle.Id;
				if(objDetalle.LTE_DescuentoDatos__c != null)
					objAdicional.LTE_NivelDescuento__c = objDetalle.LTE_DescuentoDatos__c;
				lstServicioAdicional.add(objAdicional);
			}
			if(objDetalle.LTE_MinutoVoz__c != null)
			{
				objAdicional = new LTE_Servicios_adicionales__c();
				objAdicional.Name = objDetalle.LTE_MinutoVoz__r.Name;
				objAdicional.LTE_SubPlaFacturacion__c = objDetalle.LTE_MinutoVoz__c;
				objAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalle.Id;
				if(objDetalle.LTE_DescuentoVoz__c != null)
					objAdicional.LTE_NivelDescuento__c = objDetalle.LTE_DescuentoVoz__c;
				lstServicioAdicional.add(objAdicional);
			}
			if(objDetalle.LTE_BolsaRecurrenteVoz__c != null)
			{
				objAdicional = new LTE_Servicios_adicionales__c();
				objAdicional.Name = objDetalle.LTE_BolsaRecurrenteVoz__r.Name;
				objAdicional.LTE_SubPlaFacturacion__c = objDetalle.LTE_BolsaRecurrenteVoz__c;
				objAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalle.Id;
				if(objDetalle.LTE_DescuentoSobreBolsaRecurrenteVoz__c != null)
					objAdicional.LTE_NivelDescuento__c = objDetalle.LTE_DescuentoSobreBolsaRecurrenteVoz__c;
				lstServicioAdicional.add(objAdicional);
			}
			if(objDetalle.LTE_BolsaRecurrenteDatos__c != null)
			{
				objAdicional = new LTE_Servicios_adicionales__c();
				objAdicional.Name = objDetalle.LTE_BolsaRecurrenteDatos__r.Name;
				objAdicional.LTE_SubPlaFacturacion__c = objDetalle.LTE_BolsaRecurrenteDatos__c;
				objAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalle.Id;
				if(objDetalle.LTE_DescuentoSobreBolsaRecurrenteDatos__c != null)
					objAdicional.LTE_NivelDescuento__c = objDetalle.LTE_DescuentoSobreBolsaRecurrenteDatos__c;
				lstServicioAdicional.add(objAdicional);
			}
            if(objDetalle.Plan__c != null){
                if(objDetalle.Plan__r.Aplica_SVA_Redes_Sociales__c && !lstProm_RedesSociales.isEmpty())
                {
                    objAdicional = new LTE_Servicios_adicionales__c();
                    objAdicional.Name = lstProm_RedesSociales[0].Name;
                    objAdicional.LTE_SubPlaFacturacion__c = lstProm_RedesSociales[0].Id;
                    objAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalle.Id;
                    lstServicioAdicional.add(objAdicional);
                }
            }
			
			list<string> IdsubPl=new list<string>();
			
            system.debug(objDetalle.LTE_SvaJSON__c);
			if(objDetalle.LTE_SvaJSON__c=='[]' || objDetalle.LTE_SvaJSON__c=='{}'){
				objDetalle.LTE_SvaJSON__c=null;		
			}
			
			if(objDetalle.LTE_SvaJSON__c != null){
                map<string,LTE_OfertaEnonomica_ctr.svaObj> svaMap=(map<string,LTE_OfertaEnonomica_ctr.svaObj>)JSON.deserialize(objDetalle.LTE_SvaJSON__c, map<string,LTE_OfertaEnonomica_ctr.svaObj>.class);
                
                system.debug(svaMap);

				for(String key:svaMap.keySet()){
                    LTE_OfertaEnonomica_ctr.svaObj svaObj=svaMap.get(key);
					objAdicional = new LTE_Servicios_adicionales__c();                    
					objAdicional.Name = svaObj.subPlan.Name;
					objAdicional.LTE_SubPlaFacturacion__c = svaObj.subPlan.Id;                    
					objAdicional.LTE_DetalleOfertaEReservadoRegContable__c = objDetalle.Id;
                    if(objDetalle.LTE_DescuentoSVAs__c != null && svaObj.subPlan.LTE_TipoSubplan__c == 'SVA-Bolsa Recurrente de datos')
						objAdicional.LTE_NivelDescuento__c = objDetalle.LTE_DescuentoSVAs__c;
                    if(objDetalle.LTE_DescuentoSVAs_Voz__c != null && svaObj.subPlan.LTE_TipoSubplan__c == 'SVA-Bolsa Recurrente de voz')
						objAdicional.LTE_NivelDescuento__c = objDetalle.LTE_DescuentoSVAs_Voz__c;
					lstServicioAdicional.add(objAdicional);

                    system.debug(svaObj);
                    system.debug(objAdicional);
				}
				
			}
		}
		database.insert(lstServicioAdicional,false);
	}
	
	public void CrearOCDesdeActivo(){
		List<OperacionComercial__c> newOpeCom;
        List<Id> IdActivos = new List<Id>();
        List<TOPP__c> lstTopp;
        String sRecordType = '';
        String sTOPAPN = '';
		List<RecordType> lstRecordType = new list<RecordType>();
        if(String.isNotBlank(objOportunidad.Servicio_APN_Relacionado__c)){
            IdActivos.add(objOportunidad.Servicio_APN_Relacionado__c);
        }
        ActualizarCamposActivo_cls clsUtility = new ActualizarCamposActivo_cls();
        newOpeCom = clsUtility.CrearOCDesdeActivo(IdActivos);
        if(newOpeCom.size()>0){
            newOpeCom[0].Activo__c=objOportunidad.Servicio_APN_Relacionado__c;
            newOpeCom[0].CuentaCliente__c = objOportunidad.AccountId;
            newOpeCom[0].Oportunidad__c = objOportunidad.Id;
            newOpeCom[0].Estado__c = 'Pendiente';
            
            sTOPAPN = 'Gestion APN/IP';//---
            lstTopp = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE Plan__c = :newOpeCom[0].Plan__c AND TipodeOperacionporplan__c = :sTOPAPN];
            lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            if(lstRecordType.isEmpty()){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
                return;
            }
            newOpeCom[0].TOPP__c=lstTopp.get(0).Id;
            newOpeCom[0].RecordTypeId = lstRecordType.get(0).Id;
            database.insert(newOpeCom,false);
        }
	}
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+objOportunidad.Id;        
		PageReference page = new PageReference(url);
		return page;
	}
    //[FSARASTY, 2020/05/01]: Bolsas compartidas - Relacionar OCs - ACs
    public void procesarBolsaCompartida()
   	{       
        if(objOportunidad.LTE_Bolsa_Compartida__c){            
            List<OperacionComercial__c> listOC = new List<OperacionComercial__c>([SELECT Id, Operacion_Comercial_Relacionada__c, Tipo_linea_bolsa_compartida__c, Activo__r.Id FROM OperacionComercial__c WHERE Oportunidad__r.Id =: objOportunidad.Id]);
        	List<ActivoETB__c> 			listAC = new List<ActivoETB__c>([SELECT Id, Activo_Relacionado__c, Tipo_linea_bolsa_compartida__c FROM ActivoETB__c WHERE Oportunidad__r.Id =: objOportunidad.Id]);
            String idOCPadre = '';
            String idACPadre = '';
            Boolean actualizarOC = false;
            Boolean actualizarAC = false;            
            if(objOportunidad.Servicio_Bolsa_Compartida_Padre__r.Id == null){                
                //Obtener ID AC, OC padre
                if(listOC.size() > 0){
                    for(OperacionComercial__c objOC: listOC){
                        if(objOC.Tipo_linea_bolsa_compartida__c == 'Padre'){
                            idOCPadre = objOC.Id;
                            idACPadre = objOC.Activo__r.Id;
                        }
                    }
                }
                        
                // Relacionar operaciones comerciales
                if(listOC.size() > 0){
                    for(OperacionComercial__c objOC: listOC){
                        if(objOC.Tipo_linea_bolsa_compartida__c == 'Hija' && idOCPadre != ''){
                            objOC.Operacion_Comercial_Relacionada__c = idOCPadre;
                            actualizarOC = true;
                        }
                    }
                }
            }else
                idACPadre = objOportunidad.Servicio_Bolsa_Compartida_Padre__r.Id;
                                   
            // Relacionar servicios
            if(listAC.size() > 0){                
                for(ActivoETB__c objAC: listAC){
                    if(objAC.Tipo_linea_bolsa_compartida__c == 'Hija' && idACPadre != ''){
                        objAC.Activo_Relacionado__c = idACPadre;
                        actualizarAC = true;
                    }
                }
            }            
            if(actualizarOC)
                update listOC;
            
            if(actualizarAC)
                update listAC;
        }        
    }
}