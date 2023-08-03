/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE   
Description:            Clase encargada de recolectar y manejar la información necesaria para el consumo del servicio de creación de cuentas de facturación.
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     10/08/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
public without sharing class LTE_SincronizacionCtasFact_Revchain_cls 
{
	public list<CuentaFacturacion__c> lstAllCuentaFact; 
	public list<CuentaFacturacion__c> lstCuentaFact;
	public map<String, Poblacion__c> mapPoblaciones = new map<String, Poblacion__c>();
	private map<string,string> valores = new map<string,string>();
	private map<string,string> mapCuentas = new map<string,string>();
	private list<CuentaFacturacion__c> lstCtasFactUpdate = new list<CuentaFacturacion__c>();
	private list<LogTransacciones__c> lstLogTransaccion = new list<LogTransacciones__c>();
	private list<CuentaFacturacion__c> lstCtasFactModifi = new list<CuentaFacturacion__c>();
	private list<LogTransacciones__c> lstLogCtasModifi = new list<LogTransacciones__c>(); 
	private String strResultCode = '';
	private String strResultDescription = '';
	private String strRequest = '';
	private String strResponse = '';
	private String strNombreCtaTemp = '';
	private String strIdCtaTemp = '';
    //[FS, Jerarquia de cuentas 2020-04-02]: Declaraciones para jerarquía de cuentas
    private map<string,string> 					mapRtaRMCA_MDM				= new map<string,string>();    
    private list<CuentaFacturacion__c> 			lstCtasFactUpdRtaRMCA_MDM 	= new list<CuentaFacturacion__c>();
    private String strResultCodeMDM											= '';
    private String strResultDescriptionMDM 									= '';
	//FIN [FS, Jerarquia de cuentas 2020-04-02]
	
	//Clase que contiene la información requerida para la creación de una cuenta de facturación padre y sus hijas si las tiene.  
	public class JerarquiaCtas
	{
		public String strCorrelationId = '';
		public String strMarketType = '';
		public String strGeoCode1 = '';
		public String strGeoCode2 = '';
		public String strOrderType = '';	
		public String strNumCta = '';
		public String strCurrCode = '';
		public String strInvDay = '';
		public String strConvInd = '';
		public String strBillParent = '';
		public String strBillable = '';
		public String strDoctype = '';
		public String strMonth = '';
		public String strDay = '';
		public String strYear = '';
		public String strSubscriberName = '';
		public String strBillBillingName = '';
		public String strPhoneNumber = '';
		public String strContactEmail = '';
		public String strNumDocument = '';
		public String strLineOne = '';
		public String strCityName = '';
		public String strStateCode = '';
		public String strDaneCode = '';
		public String strInvoiceDelivery = '';
		public String strOrderSubType = '';
		public String strInvoiceMethod = '';
        //[FS, Jerarquia de cuentas 2020-04-02]:Se incluyen los siguientes atributos para el nuevo servicio de jerarquía de cuentas
        public String strSegmento;
        public String strSubSegmento;
        public String strInvoiceType;
        public String strDepartamento;
        public String strIdCtaRevchain;
        public String strCreatorUser;   
        public String strPaymentPrd;
        // FIN [FS, Jerarquia de cuentas 2020-04-02]
		public list<DatosCtaFact> lstDatosCtasHijas;
	}

	//Clase que contiene todos los datos requeridos por el servicio web de creación de cuentas.
	public class DatosCtaFact
	{
		public String strCorrelationId = '';
		public String strMarketType = '';
		public String strGeoCode1 = '';
		public String strGeoCode2 = '';
		public String strOrderType = '';	
		public String strNumCta = '';
		public String strCurrCode = '';
		public String strInvDay = '';
		public String strConvInd = '';
		public String strBillParent = '';
		public String strBillable = '';
		public String strDoctype = '';
		public String strMonth = '';
		public String strDay = '';
		public String strYear = '';
		public String strSubscriberName = '';
		public String strBillBillingName = '';
		public String strPhoneNumber = '';
		public String strContactEmail = '';
		public String strNumDocument = '';
		public String strLineOne = '';
		public String strCityName = '';
		public String strStateCode = '';
		public String strDaneCode = '';
		public String strInvoiceDelivery = '';
		public String strOrderSubType = '';
		public String strInvoiceMethod = '';
        //[FS, Jerarquia de cuentas 2020-04-02]:Se incluyen los siguientes atributos para el nuevo servicio de jerarquía de cuentas
        public String strSegmento;
        public String strSubSegmento;
        public String strInvoiceType;
        public String strDepartamento;
        public String strIdCtaRevchain;
        public String strCreatorUser;   
        public String strPaymentPrd;
        // FIN [FS, Jerarquia de cuentas 2020-04-02]
	}

	public LTE_SincronizacionCtasFact_Revchain_cls()
	{
	}

	/**
    *   @Method: CrearCuentasFacturacion
    *   @param lstOpComerciales: lista de operaciones comerciales proveniente del batch LTE_CuentasFacturacion_bch.
    *   @description: Se encarga de manejar la logica principal para identificar las cuentas de facturación (padre o hija). 
    */
	public void CrearCuentasFacturacion(List<OperacionComercial__c> lstOpComerciales)
	{
		set<String> setIdCtasFacturacion	= new set<String>();
		set<String> setIdCtasFactModif		= new set<String>();
		set<String> setIdPoblacion			= new set<String>();
		LTE_ModificarCuentasFacturacion_cls objModicarCtas = new LTE_ModificarCuentasFacturacion_cls();		
		system.debug('CrearCuentasFacturacion----entra---tamano-->' + lstOpComerciales.size() +'\n' + lstOpComerciales);
		//Se almacenan las cuentas de facturación existentes en la lista de operaciones comerciales.
		for(OperacionComercial__c oc:lstOpComerciales)
		{
			setIdCtasFacturacion.add(oc.CuentaFacturacion__c);
			setIdCtasFacturacion.add(oc.Legalizacion__r.LTE_CuentaFacturacion__c);
		}
		
		//Se llama el metodo para traer la informacion requerida de todas la cuentas de facturación. 
		lstAllCuentaFact = getCuentasFacturacion_cls(setIdCtasFacturacion);
		system.debug('lstAllCuentaFact-size->'+lstAllCuentaFact.size());
		
		//Se almacenan las poblaciones existentes en la lista de cuentas de facturación en el campo Ciudad__c.
		for(CuentaFacturacion__c objCta:lstAllCuentaFact)
		{
			setIdPoblacion.add(objCta.Ciudad__c);
		}
		//Se llama el metodo para traer toda la información relacionada a las poblaciones de la cuenta de facturación (Estado, ciudad y codigos dane) 
		mapPoblaciones = consultarCodigoPoblacion(setIdPoblacion);

		for(CuentaFacturacion__c objCta:lstAllCuentaFact)
		{
			system.debug('objCta-->'+objCta);
			//Se identifica si la cuenta de facturación es padre y no se ha creado en revchain
			//
			/*[FS, Jerarquia de cuentas 2020-04-02]: Desactivación de generación de cuentas de facturación con antigua estructura
            if( objCta.LTE_CuentaFacturacionPadre__c == null && objCta.Fue_creada_en_revchain__c == false)
			{
				enviarCuentaRevchain(objCta,'P');
			} 
			//Se identifica si la cuenta de facturación es hija y no se ha creado en revchain mientras que su padre si.
			if( objCta.LTE_CuentaFacturacionPadre__c != null && objCta.LTE_CuentaFacturacionPadre__r.Fue_creada_en_revchain__c == true && objCta.Fue_creada_en_revchain__c == false)
			{
         		enviarCuentaRevchain(objCta,'H');
			} [FS, Jerarquia de cuentas 2020-04-02]: SE incluye invocación a los nuevos métodos para creación jerarquía de cuentas*/
            enviarCuenta_JerarquiaFacturacion(objCta);
            
			//Se identifica si la cuenta de facturación ya se creo en revchain y requiere actualización en el servicio web.
			if( objCta.Fue_creada_en_revchain__c == true && objCta.LTE_PendienteModificacion__c == true)
			{
				Poblacion__c objPoblacion = new Poblacion__c();
				LogTransacciones__c objLog = new LogTransacciones__c();
				if(mapPoblaciones.containsKey(objCta.Ciudad__c))
		    	{
		    		objPoblacion = mapPoblaciones.get(objCta.Ciudad__c);
		    	}
		    	//como la cuenta esta pendiente de actualización, se utiliza la clase LTE_ModificarCuentasFacturacion_cls para consumir el respectivo servicioWeb.
				LTE_ModificarCuentasFacturacion_cls objModificarCta = new LTE_ModificarCuentasFacturacion_cls();
				objLog = objModificarCta.modificarCuentaRevchain(objCta, objPoblacion);
				lstLogCtasModifi.add(objLog);
				
				//Si se actualizo el registro de manera exitosa se quita de la lista de pendientes para modificar.
				if(objLog.Estado__c == 'Exitoso')
				{
					objCta.LTE_PendienteModificacion__c = false;
					lstCtasFactModifi.add(objCta);				
				}
			}
        }

        system.debug('lstCtasFactUpdate-->'+lstCtasFactUpdate);
        system.debug('lstCtasFactUpdate-size->'+lstCtasFactUpdate.size());

        system.debug('lstLogTransaccion-->'+lstLogTransaccion);
        system.debug('lstLogTransaccion-size->'+lstLogTransaccion.size());
        
        //Actualizacion e insercion de los registros de cuenta de facturación y log de transacción para los servicios de creación y actualización de cuentas de facturación independientemente.
        if(!Test.isRunningTest()){
	        update lstCtasFactUpdate;
	        update lstCtasFactModifi;	
			insert lstLogTransaccion;
			insert lstLogCtasModifi; 
            
            if(lstCtasFactUpdRtaRMCA_MDM.size()>0)
            	update lstCtasFactUpdRtaRMCA_MDM;  
        }      
	}

	/**
    *   @Method: enviarCuentaRevchain
    *   @param objCta: Cuenta de facturación para procesar.      
    *   @param padreHIja: identificador si es cuenta de facturación padre o hija.
    *   @description: Se encarga de contruir el request para el servicio web e invocarlo. 
    */         
	public void enviarCuentaRevchain(CuentaFacturacion__c objCta,String padreHIja)
	{
		lstCuentaFact = new list<CuentaFacturacion__c>();
		JerarquiaCtas objJerarquiaCtas = new JerarquiaCtas();		
			
			//Si es una cuenta hija, llama el metodo para obtener toda la información necesaria de una hija.
			if(padreHIja.equals('H'))
			{				
				system.debug('Es una cuenta de facturación hija');
				objJerarquiaCtas = crearCuentaHija(objCta);

			}
			//Si es una cuenta padre, llama el metodo para obtener toda la información necesaria de un padre y sus hijas si las tiene.
			else
			{
				system.debug('Es una cuenta de facturación Padre');
				objJerarquiaCtas = crearCuentaPadreHijas(objCta.Id);
			}

			//Llamado de la clase para contruir el respectivo XML.
			strRequest = LTE_ConstruirXMLCtasFact_cls.CrearXMLJerarquiaCuentaFact(objJerarquiaCtas);
			strIdCtaTemp = objCta.Id;
			strNombreCtaTemp = objCta.Name;
			//Llamado del metodo para invocar el servicio web.
			invocarServicioCrearCuentaFact(strRequest, objCta.Id);		
	}
    //[FS, Jerarquia de cuentas 2020-04-02]: Método para orquestar la integración con el servicio de jerarquía de cuentas	
    public void enviarCuenta_JerarquiaFacturacion(CuentaFacturacion__c objCta)
	{
		lstCuentaFact = new list<CuentaFacturacion__c>();
		JerarquiaCtas objJerarquiaCtas = new JerarquiaCtas();					
		        
        objJerarquiaCtas = crearCuenta_JerarquiaFacturacion(objCta.Id);
			
        //Llamado de la clase para contruir el respectivo XML.			
        strRequest 			= ConstruirXMLCtasFact_cls.CrearXMLCreacionCuentaFact_SystemsAccounts(objJerarquiaCtas);
        system.debug('Jerarquia cuentas - Request: '+strRequest);
        strIdCtaTemp 		= objCta.Id;
        strNombreCtaTemp 	= objCta.Name;
        
        //Llamado del metodo para invocar el servicio web.
        invocarServicio_JerarquiaFacturacion(strRequest, objCta.Id);
	}
	//FIN [FS, Jerarquia de cuentas 2020-04-02]
	/**
    *   @Method: getCuentasFacturacion_cls
    *   @param setIdCtaFact: arreglo que contiene el Id de todas las cuentas de facturación que se desean crear o actualizar.      
    *   @return list<CuentaFacturacion__c>: lista con las cuentas de facturación y toda su información.
    *   @description: Se encarga de almacenar todas las cuentas de facturación que se desean crear o actualizar y toda su información. 
    */
	public list<CuentaFacturacion__c> getCuentasFacturacion_cls(set<String> setIdCtaFact)
	{

		set<String> setIdCtaFactpadre = new set<String>();
		//set<String> setIdCtaFact = new set<String>();
		set<String> setIdCtasSync = new set<String>();
		map<String,String> mapCtaHijaCtaPadre = new map<String,String>();		
		system.debug('IDS CTA FACT------------->' + setIdCtaFact);
		list<CuentaFacturacion__c> lstCtaFact = [SELECT Id,LTE_CuentaFacturacionPadre__c FROM    CuentaFacturacion__c 
                        WHERE   LTE_CuentaFacturacionLTE__c = true
                        AND     (Id =: setIdCtaFact OR (LTE_CuentaFacturacionPadre__c in: setIdCtaFact AND LTE_CuentaFacturacionPadre__c != null))
                        AND		((Fue_creada_en_revchain__c = false ) OR (Fue_creada_en_revchain__c = true AND LTE_PendienteModificacion__c = true))];
              
        system.debug('lstCtaFact------------->' + lstCtaFact);
        // mapa de todas las cuentas con sus cuentas padre        
        for(CuentaFacturacion__c objCta: lstCtaFact){
        	setIdCtaFactpadre.add(objCta.LTE_CuentaFacturacionPadre__c);
        }
        
        // Hacer conculsta de las cuentas padres que no se han enviado a RevChain
 		list<CuentaFacturacion__c> lstCtaFactPadreNoSyncRev = [SELECT Id   FROM    CuentaFacturacion__c 
                        WHERE   LTE_CuentaFacturacionLTE__c = true
                        AND     Id =: setIdCtaFactpadre
                        AND 	Fue_creada_en_revchain__c = false];
                        
  
          // mapa de todas las cuentas con sus cuentas padre        
        for(CuentaFacturacion__c objCta: lstCtaFactPadreNoSyncRev){
        	mapCtaHijaCtaPadre.put(objCta.id,'S');
        }
            
        // Incluir todas las cuentas padre que no han sido sincorizadas en la lista final  
        for(CuentaFacturacion__c objCta: lstCtaFactPadreNoSyncRev){
        	setIdCtasSync.add(objCta.id);
        }
       
        // Incluir todas las cuentas  que no han sido sincorizadas en la lista final, siempr ey cuando el padre no haya sido sincornizado
        for(CuentaFacturacion__c objCta: lstCtaFact){
        	//if(mapCtaHijaCtaPadre.get(objCta.LTE_CuentaFacturacionPadre__c)!=null){
        		setIdCtasSync.add(objCta.id);
        	//}
        }        
         
        system.debug('setIdCtasSync-->'+setIdCtasSync);               
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]      
		list<CuentaFacturacion__c> lstCtaFactNoSyncRev = [SELECT Id, Name, Cliente__c, LTE_CuentaFacturacionPadre__c, Facturable__c, LTE_MetodoEnvio__c,
                                LTE_CicloFacturacion__c, LTE_Email__c, DirCorresp__c, LTE_DireccionAlterna__c, 
                                LTE_DepartamentoFacturacion__c, Ciudad__c, LTE_DepartamentoAlterno__c, TaxPlan__c,  
                                LTE_CiudadAlterna__c, LTE_NombreCuentaFacturacion__c, LTE_CuentaFacturacionLTE__c, CodCicloFac__c,
                                Cliente__r.Name, Cliente__r.Tipodedocumento__c, Cliente__r.Phone, Cliente__r.AccountNumber,
                                Fue_creada_en_revchain__c, LTE_PendienteModificacion__c, LTE_CuentaFacturacionPadre__r.Name, 
                                LTE_CuentaFacturacionPadre__r.Fue_creada_en_revchain__c,Cliente__r.CreatedDate, Cliente__r.Segmento__c,
                                CreatedBy.Username, TipoFactura__c, Cliente__r.SubSegmento__c
                        FROM    CuentaFacturacion__c 
                        WHERE   LTE_CuentaFacturacionLTE__c = true
                        AND     Id =: setIdCtasSync
                        AND 	Fue_creada_en_revchain__c = false];
                      
         system.debug('lstCtaFactNoSyncRev-->'+lstCtaFactNoSyncRev);                 
         return lstCtaFactNoSyncRev;
	
	}
	
	/**
    *   @Method: crearCuentaHija
    *   @param objCtaFact: cuenta de facturación hija.      
    *   @return JerarquiaCtas: arreglo con toda la información necesaria para la construcción del XML request.
    *   @description: Se encarga de organizar información necesaria para la construcción del request. 
    */
	public JerarquiaCtas crearCuentaHija(CuentaFacturacion__c objCtaFact)
	{
		system.debug('crearCuentaHija----entra----->' + objCtaFact);
		//Se llama el metodo para obtener la información requerida para contruir el request.
		DatosCtaFact  objDatosCtaFact = llenarDatosCta(objCtaFact);		
		JerarquiaCtas objJerquiaCuentas = new JerarquiaCtas();
		objJerquiaCuentas.lstDatosCtasHijas = new list<DatosCtaFact>();

		//La cabecera del padre solamente lleva la informacion de la etiqueta <v11:BILL_PRNT_SUB_ID>.
		objJerquiaCuentas.strCorrelationId 	= objDatosCtaFact.strCorrelationId;
    	objJerquiaCuentas.strBillParent 	= objCtaFact.LTE_CuentaFacturacionPadre__r.Name;
    	//objJerquiaCuentas.strBillParent 		= '12050798585';
    	objJerquiaCuentas.lstDatosCtasHijas.add(objDatosCtaFact);
		system.debug('crearCuentaHija----sale----->' + objCtaFact);
		return objJerquiaCuentas;
	}

	/**
    *   @Method: crearCuentaPadreHijas
    *   @param strIdCtaFact: Id de la cuenta de facturación padre.      
    *   @return JerarquiaCtas: arreglo con toda la información necesaria para la construcción del XML request.
    *   @description: Se encarga de organizar información necesaria para la construcción del request. 
    */
	public JerarquiaCtas crearCuentaPadreHijas(String strIdCtaFact)
	{		
		system.debug('crearCuentaPadreHijas----entra----->' + strIdCtaFact);
		JerarquiaCtas objJerquiaCuentas = new JerarquiaCtas();
		objJerquiaCuentas.lstDatosCtasHijas = new list<DatosCtaFact>();

		for(CuentaFacturacion__c objCtaFactTemp : lstAllCuentaFact)
		{
			DatosCtaFact  objDatosCtaFact = new DatosCtaFact();
			//Se llama el metodo para obtener la información requerida para contruir el request.
			objDatosCtaFact = llenarDatosCta(objCtaFactTemp);
			//Se identifica la cuenta de facturación padre y se mapea su información.
			if(objCtaFactTemp.Id == strIdCtaFact)
			{
				objJerquiaCuentas.strCorrelationId 		= objDatosCtaFact.strCorrelationId;
				objJerquiaCuentas.strGeoCode2 			= objDatosCtaFact.strGeoCode2;
				objJerquiaCuentas.strOrderType 			= objDatosCtaFact.strOrderType;
				objJerquiaCuentas.strCurrCode 			= objDatosCtaFact.strCurrCode;
				objJerquiaCuentas.strConvInd 			= objDatosCtaFact.strConvInd;
				objJerquiaCuentas.strBillParent 		= '';
				objJerquiaCuentas.strMonth 				= objDatosCtaFact.strMonth;
				objJerquiaCuentas.strDay 				= objDatosCtaFact.strDay;
				objJerquiaCuentas.strYear 				= objDatosCtaFact.strYear;
				
				/*objJerquiaCuentas.strMonth 				= '2';
				objJerquiaCuentas.strDay 				= '1';
				objJerquiaCuentas.strYear 				= '3';*/	
							
				objJerquiaCuentas.strOrderSubType 		= objDatosCtaFact.strOrderSubType;
				objJerquiaCuentas.strInvoiceMethod 		= objDatosCtaFact.strInvoiceMethod;
				objJerquiaCuentas.strMarketType 		= objDatosCtaFact.strMarketType;
				objJerquiaCuentas.strGeoCode1 			= objDatosCtaFact.strGeoCode1;
				objJerquiaCuentas.strNumCta 			= objDatosCtaFact.strNumCta;
				objJerquiaCuentas.strInvDay 			= objDatosCtaFact.strInvDay;
				objJerquiaCuentas.strBillable 			= objDatosCtaFact.strBillable;
				objJerquiaCuentas.strDoctype 			= objDatosCtaFact.strDoctype;
				objJerquiaCuentas.strSubscriberName 	= objDatosCtaFact.strSubscriberName;
				objJerquiaCuentas.strBillBillingName 	= objDatosCtaFact.strBillBillingName;
				objJerquiaCuentas.strPhoneNumber 		= objDatosCtaFact.strPhoneNumber;
				objJerquiaCuentas.strContactEmail 		= objDatosCtaFact.strContactEmail;
				objJerquiaCuentas.strNumDocument 		= objDatosCtaFact.strNumDocument;			
				objJerquiaCuentas.strLineOne 			= objDatosCtaFact.strLineOne;
				objJerquiaCuentas.strCityName 			= objDatosCtaFact.strCityName;
				objJerquiaCuentas.strStateCode 			= objDatosCtaFact.strStateCode;
				objJerquiaCuentas.strDaneCode 			= objDatosCtaFact.strDaneCode;
				objJerquiaCuentas.strInvoiceDelivery 	= objDatosCtaFact.strInvoiceDelivery;
			}
			// se identifica si es una cuenta de facturación hija y se agrega a la lista del arreglo jerarquia.
			else if (objCtaFactTemp.LTE_CuentaFacturacionPadre__c == strIdCtaFact)
			{				
				objDatosCtaFact.strBillParent = '';				
				objJerquiaCuentas.lstDatosCtasHijas.add(objDatosCtaFact);
			}
		system.debug('ARREGLO--------->' + objJerquiaCuentas);
		}	
		system.debug('crearCuentaPadreHijas----sale----->' + strIdCtaFact);	
		return objJerquiaCuentas;
	}
    //[FS, Jerarquia de cuentas 2020-04-02]: Método para establecer valores que se incluirán en el XML del WS. 	
    public JerarquiaCtas crearCuenta_JerarquiaFacturacion(String strIdCtaFact)
	{		
		system.debug('crearCuenta_JerarquiaFacturacion----entra----->' + strIdCtaFact);
		JerarquiaCtas objJerquiaCuentas = new JerarquiaCtas();
		objJerquiaCuentas.lstDatosCtasHijas = new list<DatosCtaFact>();

		for(CuentaFacturacion__c objCtaFactTemp : lstAllCuentaFact)
		{
			DatosCtaFact  objDatosCtaFact = new DatosCtaFact();
			//Se llama el metodo para obtener la información requerida para contruir el request.
			objDatosCtaFact = llenarDatosCta(objCtaFactTemp);
			//Se identifica la cuenta de facturación padre y se mapea su información.
			if(objCtaFactTemp.Id == strIdCtaFact)
			{
				objJerquiaCuentas.strCorrelationId 		= objDatosCtaFact.strCorrelationId;
				objJerquiaCuentas.strGeoCode2 			= objDatosCtaFact.strGeoCode2;
				objJerquiaCuentas.strOrderType 			= objDatosCtaFact.strOrderType;
				objJerquiaCuentas.strCurrCode 			= objDatosCtaFact.strCurrCode;
				objJerquiaCuentas.strConvInd 			= objDatosCtaFact.strConvInd;
				objJerquiaCuentas.strBillParent 		= objDatosCtaFact.strBillParent;
				objJerquiaCuentas.strMonth 				= objDatosCtaFact.strMonth;
				objJerquiaCuentas.strDay 				= objDatosCtaFact.strDay;
				objJerquiaCuentas.strYear 				= objDatosCtaFact.strYear;
				
				/*objJerquiaCuentas.strMonth 				= '2';
				objJerquiaCuentas.strDay 				= '1';
				objJerquiaCuentas.strYear 				= '3';*/	
							
				objJerquiaCuentas.strOrderSubType 		= objDatosCtaFact.strOrderSubType;
				objJerquiaCuentas.strInvoiceMethod 		= objDatosCtaFact.strInvoiceMethod;
				objJerquiaCuentas.strMarketType 		= objDatosCtaFact.strMarketType;
				objJerquiaCuentas.strGeoCode1 			= objDatosCtaFact.strGeoCode1;
				objJerquiaCuentas.strNumCta 			= objDatosCtaFact.strNumCta;
				objJerquiaCuentas.strInvDay 			= objDatosCtaFact.strInvDay;
				objJerquiaCuentas.strBillable 			= objDatosCtaFact.strBillable;
				objJerquiaCuentas.strDoctype 			= objDatosCtaFact.strDoctype;
				objJerquiaCuentas.strSubscriberName 	= objDatosCtaFact.strSubscriberName;
				objJerquiaCuentas.strBillBillingName 	= objDatosCtaFact.strBillBillingName;
				objJerquiaCuentas.strPhoneNumber 		= objDatosCtaFact.strPhoneNumber;
				objJerquiaCuentas.strContactEmail 		= objDatosCtaFact.strContactEmail;
				objJerquiaCuentas.strNumDocument 		= objDatosCtaFact.strNumDocument;			
				objJerquiaCuentas.strLineOne 			= objDatosCtaFact.strLineOne;
				objJerquiaCuentas.strCityName 			= objDatosCtaFact.strCityName;
				objJerquiaCuentas.strStateCode 			= objDatosCtaFact.strStateCode;
				objJerquiaCuentas.strDaneCode 			= objDatosCtaFact.strDaneCode;
				objJerquiaCuentas.strInvoiceDelivery 	= objDatosCtaFact.strInvoiceDelivery;
                objJerquiaCuentas.strSegmento			= objDatosCtaFact.strSegmento; 
                objJerquiaCuentas.strSubSegmento		= objDatosCtaFact.strSubSegmento; 
                objJerquiaCuentas.strCreatorUser		= objDatosCtaFact.strCreatorUser; 
                objJerquiaCuentas.strDepartamento		= objDatosCtaFact.strDepartamento; 
                objJerquiaCuentas.strInvoiceType		= objDatosCtaFact.strInvoiceType; 
                objJerquiaCuentas.strIdCtaRevchain		= objDatosCtaFact.strIdCtaRevchain;                 
                objJerquiaCuentas.strPaymentPrd			= label.Param_Jerarquia_CF_PAYMENT_PRD;
			}
			// se identifica si es una cuenta de facturación hija y se agrega a la lista del arreglo jerarquia.
			else if (objCtaFactTemp.LTE_CuentaFacturacionPadre__c == strIdCtaFact)
			{				
				objDatosCtaFact.strBillParent = '';				
				objJerquiaCuentas.lstDatosCtasHijas.add(objDatosCtaFact);
			}
		system.debug('ARREGLO--------->' + objJerquiaCuentas);
		}	
		system.debug('crearCuentaPadreHijas----sale----->' + strIdCtaFact);	
		return objJerquiaCuentas;
	}
    //FIN [FS, Jerarquia de cuentas 2020-04-02]: Método para establecer valores que se incluirán en el XML del WS. 	
    /**
    *   @Method: llenarDatosCta
    *   @param objCtaFact: Cuenta de facturación.      
    *   @return DatosCtaFact: informacion requerida para la construcción del request.
    *   @description: Se encarga de obtener la información necesaria para la construcción del request.
    */
    public DatosCtaFact llenarDatosCta(CuentaFacturacion__c objCtaFact)
    {
    	system.debug('llenarDatosCta----entra----->' + objCtaFact);
    	DatosCtaFact objCta 		= new DatosCtaFact();
    	Poblacion__c objPoblacion	= new Poblacion__c();

    	//Se obtiene la información de población de la cuenta.
    	if(mapPoblaciones.containsKey(objCtaFact.Ciudad__c))
    	{
    		objPoblacion = mapPoblaciones.get(objCtaFact.Ciudad__c);
    	}
    	system.debug('objPoblacion------>' + objPoblacion);
    	Datetime datToday 			= system.now();

    	// se concatena el id de la cta de facturación con el dia, el mes, el año, la hora, los minutos y los segundos para que sea un identificador unico.
    	objCta.strCorrelationId 	= objCtaFact.Id + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) 
    								+ String.valueOf(datToday.hour()) + String.valueOf(datToday.minute()) + String.valueOf(datToday.second());
    	// asignación de contantes del XML.
		objCta.strGeoCode2 			= label.LTE_Uno;
		objCta.strOrderType 		= label.LTE_Venta;
		objCta.strCurrCode 			= label.LTE_COP;
		objCta.strConvInd 			= label.LTE_Uno;
		
		objCta.strMonth 			= String.valueOf(objCtaFact.Cliente__r.CreatedDate.month());
		objCta.strDay 				= String.valueOf(objCtaFact.Cliente__r.CreatedDate.day());
		objCta.strYear 				= String.valueOf(objCtaFact.Cliente__r.CreatedDate.year());

		/*objCta.strMonth 			= '2';
		objCta.strDay 				= '1';
		objCta.strYear 				= '3';*/
				
		objCta.strOrderSubType 		= label.LTE_VentaLTE;
		objCta.strInvoiceMethod 	= label.LTE_CuentasResumidas;

		//Se identifica si la cuenta pertenece a una persona juridica o una persona natural a partir del tipo de documento.
		if(objCtaFact.Cliente__r.Tipodedocumento__c == label.LTE_NIT || objCtaFact.Cliente__r.Tipodedocumento__c == 'Decreto')
			objCta.strMarketType 	= label.LTE_PersonaJuridica;
		else
			objCta.strMarketType 	= label.LTE_PersonaNatural;

		objCta.strGeoCode1 			= objPoblacion.CodigoDane__c;
		objCta.strNumCta 			= objCtaFact.Id;
		// Si el LTE_CicloFacturacion__c es diferente de null se consulta el metodo consultarDiaFacturacionRevchain de lo contrario se deja asignado '';
		objCta.strInvDay 			= objCtaFact.LTE_CicloFacturacion__c != null ? consultarDiaFacturacionRevchain(objCtaFact.LTE_CicloFacturacion__c) : objCta.strInvDay;
		objCta.strBillParent 		= objCtaFact.LTE_CuentaFacturacionPadre__r.Name;
		// Si Facturable__c es igual a TRUE se asigana el valor Y de lo contrario N.		
		objCta.strBillable 			= objCtaFact.Facturable__c == true ? label.LTE_OpcionListaSi : label.LTE_OpcionListaNo;
		objCta.strDoctype 			= HomologacionCampos__c.getValues(objCtaFact.Cliente__r.Tipodedocumento__c).Valor__c;
		objCta.strSubscriberName 	= objCtaFact.Cliente__r.Name;
		objCta.strBillBillingName 	= objCtaFact.LTE_NombreCuentaFacturacion__c;
		objCta.strPhoneNumber 		= objCtaFact.Cliente__r.Phone;
		objCta.strContactEmail 		= objCtaFact.LTE_Email__c != null ? objCtaFact.LTE_Email__c : objCta.strContactEmail;
		objCta.strNumDocument 		= objCtaFact.Cliente__r.AccountNumber;			
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]      
        objCta.strLineOne           = objCtaFact.DirCorresp__c != null ? objCtaFact.DirCorresp__c : objCta.strLineOne;
		objCta.strCityName 			= objPoblacion.Name;
		objCta.strStateCode 		= recortarDane(objPoblacion.Padre__r.CodigoDane__c);
		objCta.strDaneCode 			= objCta.strGeoCode1;
		objCta.strSegmento			= objCtaFact.Cliente__r.Segmento__c;
        objCta.strSubSegmento		= objCtaFact.Cliente__r.SubSegmento__c;
        objCta.strCreatorUser		= objCtaFact.CreatedBy.Username;
        objCta.strDepartamento		= objCtaFact.LTE_DepartamentoFacturacion__c;
        objCta.strInvoiceType		= objCtaFact.TipoFactura__c;
        objCta.strIdCtaRevchain		= objCtaFact.Name;        
        objCta.strBillParent		= (objCtaFact.LTE_CuentaFacturacionPadre__r.Name == null?'':objCtaFact.LTE_CuentaFacturacionPadre__r.Name);
		//Se identifica el metodo de envio y se asigna su equivalente en ingles como lo requiere el servicio web.
		if(objCtaFact.LTE_MetodoEnvio__c == label.LTE_ServicioPostal)
			objCta.strInvoiceDelivery = label.LTE_PostalService;
		if(objCtaFact.LTE_MetodoEnvio__c == label.LTE_Email)
			objCta.strInvoiceDelivery = label.LTE_Email;
		if(objCtaFact.LTE_MetodoEnvio__c == label.LTE_Serviciopostal_Email)
			objCta.strInvoiceDelivery = label.LTE_PostalService_Email;
		if(objCtaFact.LTE_MetodoEnvio__c == null)
			objCta.strInvoiceDelivery = objCta.strInvoiceDelivery;
		system.debug('llenarDatosCta----sale----->' + objCtaFact);
    	return objCta;
    }	

    /**
    *   @Method: consultarCodigoPoblacion
    *   @param setIdPoblacion: poblaciones existentes en la lista de cuentas de facturación en el campo Ciudad__c.      
    *   @return map<String, Poblacion__c>: mapa con el objeto población completo.
    *   @description: Se encarga de construir un mapa que contenga como llave el id de la ciudad de la cuenta de facturación y el objeto población para obtener toda la información requerida (ciudad, departamento y codigos dane). 
    */
	public map<String, Poblacion__c> consultarCodigoPoblacion(set<String> setIdPoblacion)
	{
		map<String, Poblacion__c> mapPoblaciones = new map<String, Poblacion__c>();

		//consulta con la información necesaria.
		list<Poblacion__c> lstPoblacion = [	SELECT	Id, Name, CodigoDane__c, EsMunicipio__c, Padre__c, Padre__r.Name, Padre__r.CodigoDane__c
											FROM	Poblacion__c 
											WHERE	Id =: setIdPoblacion];
		
		if(!lstPoblacion.isEmpty())
		{
			//Construcción del mapa.
			for(Poblacion__c objPoblacion : lstPoblacion)
			{
				mapPoblaciones.put(objPoblacion.Id, objPoblacion);
			}
		}

		return mapPoblaciones;
	}

	/**
    *   @Method: consultarDiaFacturacionRevchain
    *   @param strDiaSFDC: Ciclo de facturación de salesforce.      
    *   @return String: equivalente del ciclo de facturación para revchain.
    *   @description: Se encarga de encontrar el equivalente del ciclo de facturación de salesforce para revchain. 
    */
	public String consultarDiaFacturacionRevchain(String strDiaSFDC)
	{
		String strDiaFactRevchain = '';
		list <LTE_CiclosFacturacion__c> lstCiclosFact = LTE_CiclosFacturacion__c.getall().values();

		for(LTE_CiclosFacturacion__c objCiclosFact : lstCiclosFact)
		{
			if(objCiclosFact.LTE_DiaCorteOCS__c == Integer.valueOf(strDiaSFDC))
				strDiaFactRevchain = String.valueOf(Integer.valueOf(objCiclosFact.LTE_DiaCorteRevChain__c));
		}

		return strDiaFactRevchain;
	}

	/**
    *   @Method: recortarDane.
    *   @param strCod: Codigo dane a recortar.      
    *   @return String: codigo dane recortado.
    *   @description: Se encarga de recortar el codigo dane cuendo es necesario para el servicio web. 
    */
	public String recortarDane(String strCod)
	{
		String strCodigo='';
		if(strCod!=null){
			if(strCod.length()==5)
			{
				strCodigo=strCod.substring(0,2);
			}
			else if(strCod.length()==4)
			{
				strCodigo=strCod.substring(0,1);
			}
		}
		return strCodigo;
	}

	/**
    *   @Method: invocarServicioCrearCuentaFact.
    *   @param strRequest: XML request.
    *   @param strIdCtaFact: Id de la cuenta de facturación.
    *   @description: Se encarga de invocar el servicio web para la creación de cuentas de facturación. 
    */
	public void invocarServicioCrearCuentaFact(String strRequest, String strIdCtaFact)
	{
		//Obtiene la informacion del servicio web almacenado en la configuración personalizada ServiciosWeb__c.
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');
		//Consume el servicio y almacena el response.
		strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);
		System.debug('Response----------->' + strResponse);
		if(strResponse != null && strResponse != '')
		{	
			getMapXMLResponseFact(strResponse);
		}
	}
    //[FS, Jerarquia de cuentas 2020-04-02]: Método para invocar el servicio de jerarquía de cuentas de facturación
    public void invocarServicio_JerarquiaFacturacion(String strRequest, String strIdCtaFact)
	{
		//Obtiene la informacion del servicio web almacenado en la configuración personalizada ServiciosWeb__c.
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionJerarquiaCuentasFact');
		//Consume el servicio y almacena el response.
        if(!Test.isRunningTest()){            
			strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);			
        }else
            strResponse = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:CreateSystemsAccountsOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/CreateSystemsAccountsOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name/><ns1:correlationID/><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2020-03-27T14:15:44.018-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns1:CreateSystemsAccountsOutput xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/CreateSystemsAccountsMsgs"><ns2:ResponseData xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/ResponseData"><ns2:CreateBillingAccountResponse><ns2:Code>S</ns2:Code><ns2:Description>operation is successful</ns2:Description><ns3:response xmlns:ns3="InvokeEJBURevChainOutResponse" system="RevChain" operation="S" result="S"><ns3:faults><ns3:subscriber_id>15052846705</ns3:subscriber_id><ns3:account_id>a05m000000AYicYAAT</ns3:account_id><ns3:plan_impuestos><ns3:type_name>PLAN DE IMPUESTOS ETB LOCAL</ns3:type_name><ns3:tax_plan_vendor/></ns3:plan_impuestos><ns3:ciclo_facturacion>18</ns3:ciclo_facturacion><ns3:fault_detail error_description="operation is successful" error_code="0"/></ns3:faults></ns3:response></ns2:CreateBillingAccountResponse><ns2:CreateRMCAAccountResponse><ns2:Code>SUCCESS</ns2:Code><ns2:Description>SUCCESS</ns2:Description></ns2:CreateRMCAAccountResponse><ns2:CreateMDMAccountResponse><ns2:Code>1</ns2:Code><ns2:Description>Operacion Exitosa</ns2:Description></ns2:CreateMDMAccountResponse></ns2:ResponseData></ns1:CreateSystemsAccountsOutput></ns0:CreateSystemsAccountsOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
		
        System.debug('JerarquiaCF: Response----------->' + strResponse);
		
        if(strResponse != null && strResponse != '')
		{	
			getMapXMLResponseFact(strResponse);
		} 
	}
	//FIN [FS, Jerarquia de cuentas 2020-04-02]
	
	/**
    *   @Method: getMapXMLResponseFact
    *   @param strResponse: XML respuesta del servicio web.
    *   @description: Se encarga de convertir la respuesta del servicio web en dom. 
    */
	public void getMapXMLResponseFact(String strResponse)
	{		
		Dom.Document doc = new Dom.Document();
		doc.load(strResponse);
		Dom.XMLNode WS = doc.getRootElement();				
		iterarXmlResponseFact(WS);
        iterarXmlResponseRMCA_MDM(WS); //[FS, Jerarquia de cuentas 2020-04-02]
		//crearLogtransaccion();
		
        if(mapRtaRMCA_MDM.size() > 0)  //[FS, Jerarquia de cuentas 2020-04-02] 
			actualizarRtaRMCA_MDM(mapRtaRMCA_MDM);
	}
	
	/**
    *   @Method: iterarXmlResponseFact
    *   @param dataXml: XML respuesta del servicio web convertido en dom.
    *   @description: Se encarga de iterar el XML encontrando etiquetas necesarias. 
    */
	public void iterarXmlResponseFact(dom.XMLNode dataXml)
	{			
		List<dom.XMLNode> lstXmlValues = dataXml.getChildElements();
		if(lstXmlValues.size()>0)
		{
			for( dom.XMLNode dxm : lstXmlValues)
			{
				if(dataXml.getName()=='faults')
				{
					system.debug('ENCONTRO FAULTS-------->'+dxm);
					iterarXmlDatosCtaPadre(dxm);					
				}
				if(dataXml.getName()=='h_faults')
				{
					system.debug('ENCONTRO H_FAULTS-------->'+dxm);
					iterarXmlDatosCtaHija(dxm);
				}

				iterarXmlResponseFact(dxm);
			}
		}
		else
		{
			System.debug('\nMap valores'+dataXml.getName()+''+dataXml.getText());
			valores.put(dataXml.getName(),dataXml.getText());		
		}
	}
    
	public void iterarXmlResponseRMCA_MDM(dom.XMLNode dataXml)
    {	 
        String strIdCuentaFacturacion;		
        List<dom.XMLNode> lstXmlValues = dataXml.getChildElements();        
        if(lstXmlValues.size()>0){
            for( dom.XMLNode dxm : lstXmlValues){                                
                if(dataXml.getName()=='faults'){                    
                    if(dxm.getName()=='account_id'){
                        if(strIdCuentaFacturacion == null  && dxm.getText() != null)                        
                            strIdCuentaFacturacion = dxm.getText();
                        mapRtaRMCA_MDM.put('account_id',strIdCuentaFacturacion);
                    }
                }
                if(dataXml.getName()=='CreateRMCAAccountResponse')
                {                    
                    List<dom.XMLNode> lstXmlRespuestaRMCA = dataXml.getChildElements();
                    if(lstXmlRespuestaRMCA.size()>0)
                    {                        
                        for( dom.XMLNode dxmRespuestaRMCA : lstXmlRespuestaRMCA)
                        {
                            if(dxmRespuestaRMCA.getName()=='Code')
                            {                                
                                if(dxmRespuestaRMCA.getText() != ''){
                                    mapRtaRMCA_MDM.put('Code_RMCA',dxmRespuestaRMCA.getText());
                                    system.debug('JerarquiaCF: ENCONTRO CODE_RMCA-------->' + mapRtaRMCA_MDM);   
                                }                                
                            }
                            if(dxmRespuestaRMCA.getName()=='Description')
                            {
                                if(dxmRespuestaRMCA.getText() != ''){
                                    mapRtaRMCA_MDM.put('Description_RMCA',dxmRespuestaRMCA.getText());
                                    system.debug('JerarquiaCF: ENCONTRO DESCRIPTION_RMCA-------->' + mapRtaRMCA_MDM);
                                }
                            }
                        }
                    }
                }                
                if(dataXml.getName()=='CreateMDMAccountResponse')
                {                    
                    List<dom.XMLNode> lstXmlRespuestaMDM = dataXml.getChildElements();
                    if(lstXmlRespuestaMDM.size()>0)
                    {
                        for( dom.XMLNode dxmRespuestaMDM : lstXmlRespuestaMDM)
                        {
                            if(dxmRespuestaMDM.getName()=='Code')
                            {
                                mapRtaRMCA_MDM.put('Code_MDM',dxmRespuestaMDM.getText());
                                system.debug('JerarquiaCF: ENCONTRO CODE_MDM-------->' + mapRtaRMCA_MDM);
                            }
                            if(dxmRespuestaMDM.getName()=='Description')
                            {
                                mapRtaRMCA_MDM.put('Description_MDM',dxmRespuestaMDM.getText());
                                system.debug('JerarquiaCF: ENCONTRO DESCRIPTION_MDM-------->' + mapRtaRMCA_MDM);
                            }
                        }
                    }                    
                }                
                iterarXmlResponseRMCA_MDM(dxm);
            }
        }      
    }  
	/**
    *   @Method: iterarXmlDatosCtaPadre
    *   @param dxm: XML desglosado.
    *   @description: Se encarga de iterar el XML encontrando etiquetas con información de respuesta del padre util 
    */		
	public void iterarXmlDatosCtaPadre(dom.XMLNode dxm)
	{
		if(dxm.getName()=='subscriber_id')
		{
			mapCuentas.put('subscriber_id',dxm.getText());			
			strNombreCtaTemp = dxm.getText();
			system.debug('ENCONTRO SUBSCRIBER-------->' + mapCuentas);
		}
		if(dxm.getName()=='account_id')
		{
			mapCuentas.put('account_id',dxm.getText());
			strIdCtaTemp = dxm.getText();
			system.debug('ENCONTRO CUENTA-------->' + mapCuentas);
		}
		if(dxm.getName()=='plan_impuestos')
		{
			List<dom.XMLNode> lstXmlPlanImpuestos = dxm.getChildElements();
			if(lstXmlPlanImpuestos.size()>0)
			{
				for( dom.XMLNode dxmPlanImpuestos : lstXmlPlanImpuestos)
				{
					if(dxmPlanImpuestos.getName()=='type_name')
					{
						mapCuentas.put('type_name',dxmPlanImpuestos.getText());
						system.debug('ENCONTRO TAXPLAN-------->' + mapCuentas);						
					}
				}
			}
		}
		if(dxm.getName()=='ciclo_facturacion')
		{
			mapCuentas.put('ciclo_facturacion',dxm.getText());
			system.debug('ENCONTRO CICLO-------->' + mapCuentas);			
		}
		if(dxm.getName()=='fault_detail')
		{
			strResultCode			= dxm.getAttributeValue('error_code','');	
			strResultDescription	= dxm.getAttributeValue('error_description','');
			actualizarCtasFact(mapCuentas);
			crearLogtransaccion();		
		}	
	}

	/**
    *   @Method: iterarXmlDatosCtaHija
    *   @param dxm: XML desglosado.
    *   @description: Se encarga de iterar el XML encontrando etiquetas con información de respuesta de las ctas hijas util 
    */	
	public void iterarXmlDatosCtaHija(dom.XMLNode dxm)
	{
		if(dxm.getName()=='h_subscriber_id')
		{
			mapCuentas.put('subscriber_id',dxm.getText());
			strNombreCtaTemp = dxm.getText();
			system.debug('ENCONTRO SUBSCRIBER-------->' + mapCuentas);
		}
		if(dxm.getName()=='h_account_id')
		{
			mapCuentas.put('account_id',dxm.getText());
			strIdCtaTemp = dxm.getText();			
			system.debug('ENCONTRO CUENTA-------->' + mapCuentas);
		}
		if(dxm.getName()=='h_plan_impuestos')
		{
			List<dom.XMLNode> lstXmlPlanImpuestos = dxm.getChildElements();
			if(lstXmlPlanImpuestos.size()>0)
			{
				for( dom.XMLNode dxmPlanImpuestos : lstXmlPlanImpuestos)
				{
					if(dxmPlanImpuestos.getName()=='h_type_name')
					{
						mapCuentas.put('type_name',dxmPlanImpuestos.getText());
						system.debug('ENCONTRO TAXPLAN-------->' + mapCuentas);
					}
				}
			}		
		}
		if(dxm.getName()=='h_ciclo_facturacion')
		{
			mapCuentas.put('ciclo_facturacion',dxm.getText());
			system.debug('ENCONTRO CICLO-------->' + mapCuentas);			
		}
		if(dxm.getName()=='h_fault_detail')
		{
			strResultCode			= dxm.getAttributeValue('h_error_code','');	
			strResultDescription	= dxm.getAttributeValue('h_error_description','');
			actualizarCtasFact(mapCuentas);
			crearLogtransaccion();
		}
	}

	/**
    *   @Method: actualizarCtasFact
    *   @param mapCuentas: contiene las etiquetas y la informacíón relevante de las respuesta del servicio web.
    *   @description: Se encarga de hacer las actualizaciones pertinentes a las ctas de facturación una vez el servicio web ha dado su respuesta y se ha obtenido la información.
    */	
	public void actualizarCtasFact(map<string,string> mapCuentas)
	{
		system.debug('STATUS Y RESULTADO------>' +  valores.get('status') + strResultDescription );
		//Si la creación de la cuenta de facturación fue exitosa.
		if(valores.get('status')=='PASS' && strResultDescription == 'operation is successful')
		{
			String strIdCtaFact = mapCuentas.get('account_id');
			system.debug('ID ACT' + strIdCtaFact);
			String idCuenta ='';
			idCuenta =  mapCuentas.get('account_id');
			CuentaFacturacion__c objCtaFactUpdate 				= new CuentaFacturacion__c(id=idCuenta);
			//objCtaFactUpdate.Id 								= mapCuentas.get('account_id');
			objCtaFactUpdate.Name 								= mapCuentas.get('subscriber_id');
			objCtaFactUpdate.CodCicloFac__c						= mapCuentas.get('ciclo_facturacion');
			objCtaFactUpdate.TaxPlan__c							= mapCuentas.get('type_name');
            objCtaFactUpdate.Estado__c							= 'Activo';
            objCtaFactUpdate.Fecha_Creacion_cuenta_Revchain__c  = string.valueof(system.now());
			objCtaFactUpdate.Fue_creada_en_revchain__c			= true;

			mapCuentas.clear();
			lstCtasFactUpdate.add(objCtaFactUpdate);
		}
	}
	
    //[FS, Jerarquia de cuentas 2020-04-02]:	Se incluye método para actualizar información de RMCA y MDM generada por el servicio
    public void actualizarRtaRMCA_MDM(map<string,string> mapCuentas)
    {
        String strIdCtaFact;                  
        if( mapCuentas.size() > 0 ){                          
            if(mapCuentas.get('account_id') != null){ 
                Boolean cuentaFacturable = false;
                List<CuentaFacturacion__c> lstCtaFact = new List<CuentaFacturacion__c>([Select Facturable__c From CuentaFacturacion__c Where id=:mapCuentas.get('account_id')]);
                if(lstCtaFact.size() > 0)
                    cuentaFacturable = lstCtaFact[0].Facturable__c;
                
                CuentaFacturacion__c objCtaFactUpdate = new CuentaFacturacion__c(id=mapCuentas.get('account_id'));
                
                if(mapCuentas.get('Code_RMCA') == 'SUCCESS' && mapCuentas.get('Description_RMCA') == 'SUCCESS' && cuentaFacturable)
                    objCtaFactUpdate.Fue_creada_en_RMCA__c = true;
                
                if(mapCuentas.get('Code_MDM') == '1' && mapCuentas.get('Description_MDM') == 'Operacion Exitosa')
                    objCtaFactUpdate.Fue_creada_en_MDM__c = true;	
                
                objCtaFactUpdate.Fecha_Creacion_cuenta_Revchain__c = string.valueof(system.now());
                objCtaFactUpdate.Estado__c = 'Activo';
                mapCuentas.clear();
                lstCtasFactUpdRtaRMCA_MDM.add(objCtaFactUpdate);  
            }                              
        }     
    }
	/**
    *   @Method: crearLogtransaccion 
    *   @description: Se encarga de crear el log de transacción del consumo del servicio web.
    */	
	public void crearLogtransaccion()
	{
		LogTransacciones__c objLog = new LogTransacciones__c();
		if(valores.get('status') == 'PASS' && strResultDescription == 'operation is successful')
			objLog.Estado__c = 'Exitoso';
		else
			objLog.Estado__c = 'Fallido';

		system.debug('strIdCtaTemp-->' + strIdCtaTemp);
		system.debug('strResultCode-->' + strResultCode);
		objLog.Informacion_Enviada__c 		= strRequest;
		objLog.Informacion_Recibida__c 		= strResponse;
		objLog.LTE_CuentaFacturacionLTE__c	= strIdCtaTemp;
		objLog.Name 						= 'Creación cuenta en Revchain - RMCA - MDM ' + strNombreCtaTemp;
		objLog.CodigoRespuesta__c 			= strResultCode;

		strResultCode			= '';	
		strResultDescription	= '';
		strNombreCtaTemp		= '';
		strIdCtaTemp			= '';
		lstLogTransaccion.add(objLog);		
	}
}