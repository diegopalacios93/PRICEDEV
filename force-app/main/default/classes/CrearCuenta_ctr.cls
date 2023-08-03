/**
* Avanxo Colombia
* @author 			Manuel Medina
* Project:			ETB
* Description:		Clase controladora que controla las funcionalidades de la visualforce CrearCuenta.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		2016-08-19		Antonio Torres (AT)		Ajuste en la actualizacion de estados.
* @version	1.1		2016-08-22		Manuel Medina (MM)		Ajuste para generar log cuando se finaliza la creacion de la cuenta.
*************************************************************************************************************/
public with sharing class CrearCuenta_ctr {
	
	public string registro{set;get;}
	private map<string,string> recMap=new Map<string,string>();
	public Account cuenta{set;get;}
	public string RecordTypeData{set;get;}
	public boolean hasError{get;set;}
	public boolean blnDisplayPopup {get; set;}
	public String SitePrefix (){return Site.getBaseUrl();}
	
	/* BEGIN - Manuel Medina - Variables para almacenar resultado de la integracion de direcciones - 22082016 */
	public String strResponse;
	public String strRequest;
	public String strError;
	/* END - Manuel Medina - Variables para almacenar resultado de la integracion de direcciones - 22082016 */
	
	public CrearCuenta_ctr(ApexPages.StandardController stdController){
		hasError=false;
		cuenta=new Account();
		RecordTypeData = ApexPages.currentPage().getParameters().get('RecordType');
		cuenta.Cuenta__c = ApexPages.currentPage().getParameters().get('idSuc');
		
		registro=RecordTypeData;
	}
	
	/*
	*@Description: Cierra el popup
	*/
	public Pagereference closePopup() {        
		blnDisplayPopup = false; 
		return null;   
	}     
	
	/*
	*@Description: Muestra el popup
	*/
	public Pagereference showPopup() {                 
		blnDisplayPopup = true;  
		return null;  
	} 
	
	public List<SelectOption> getTiposDeRegistro(){
		List<SelectOption> options = new List<SelectOption>();
		Map<String,Schema.RecordTypeInfo> rType = Schema.SObjectType.Account.getRecordTypeInfosByName();
		
		for(string n:rType.keySet()){
			if(rType.get(n).isAvailable()){
				options.add(new SelectOption(n,n));
				recMap.put(n,rType.get(n).getRecordTypeId());
			}                                                       
		}
		return options;
	}
	
	public Pagereference Guardar(){
        if(registro=='Sucursales'){
            return null;
        }else{
            PageReference pagina= null;
            pagina=new PageReference('/001/e?RecordType='+recMap.get(registro)+'&ent=Account');                 
            pagina.setRedirect(true);
            return pagina;
        }
	}
	
	public Pagereference crearRegistro(){
		PageReference pagina= null;
		
		if(registro=='Sucursales'){
			// [CA] Validación de que el campo Contacto de entrega no este vacio
			system.debug('Valor de Contacto de entrega------> ' + cuenta.LTE_ContactoEntrega__c );
			//cuenta.LTE_ContactoEntrega__c=null;
			//if (cuenta.LTE_ContactoEntrega__c == null || cuenta.LTE_ContactoEntrega__c == '')
			//{
				//      system.debug('ENTRO AL ERROR------> ' );
				//      Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Contacto de entrega: Debe escribir un valor'));
				//      return pagina;
			//}
			//Fin [CA]
			return Sucursales();
		}else{
			pagina=new PageReference(Site.getBaseUrl() +'/001/e?RecordType='+recMap.get(registro)+'&ent=Account');                 
			pagina.setRedirect(true);
			return pagina;
		}
		
		return pagina;  
	}
	
	public Pagereference ClientePrincipal(){return null;}
	
	public Pagereference Sucursales(){              
		cuenta.RecordTypeId=recMap.get(registro);
		
		/* BEGIN - Manuel Medina - Validacion para requerir el campo Direccion Principal - 13092016 */
		if( String.isBlank( cuenta.Direccion__c ) ){
			ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.Error, 'Dirección Principal: Debe escribir un valor') );
			return null;
		}
		/* END - Manuel Medina - Validacion para requerir el campo Direccion Principal - 13092016 */
		
		return consultarDireccion();
	}
	
	public Pagereference redireccion(){
		insert cuenta;
		
		/* BEGIN - Manuel Medina - Llamado al metodo generarLogDirecciones - 22082016 */
		generarLogDirecciones();
		/* END - Manuel Medina - Llamado al metodo generarLogDirecciones - 22082016 */
		
		return new PageReference('/'+cuenta.id+'');
	}
	
	public Pagereference consultarDireccion() {
		EjecucionIntegracion__c integra = EjecucionIntegracion__c.getValues('Direcciones');
		
		/* BEGIN - Manuel Medina - Consulta del nombre de la ciudad para complementar nombre de la sucursal - 13092016 */
		List<Poblacion__c> lstPoblacion 		= new List<Poblacion__c>();
		lstPoblacion							= [SELECT Name
													FROM Poblacion__c
													WHERE Id =: cuenta.Ciudad__c
												];
		
		String strNombreCiudad					= '';
		
		for( Poblacion__c objPoblacion : lstPoblacion ){
			strNombreCiudad						= objPoblacion.Name;
		}
		/* END - Manuel Medina - Consulta del nombre de la ciudad para complementar nombre de la sucursal - 13092016 */
		
		if(integra!=null && integra.Ejecucion__c==false) {
			return redireccion();
			
		} else {
			tibcoXml_cls tXml=new tibcoXml_cls();
			map<string,string> values=new map<string,string>();
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('NormalizacionDireccion');
			values.put('direccion',cuenta.Direccion__c);
			values.put('correlationID', obtenerCorrelationId() );
			string request=tibcoXml_cls.normalizacionDireccion(values);
			system.debug('entrada:'+request);
			string response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
			system.debug(response);
			
			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
			
			values.putAll(proReq.getMap(response));
			
			/*if(values.get('direccionEstandarizada')==null){
				cuenta.Estado_Direccion__c='Pendiente';
				//cuenta.name='Sucursal '+cuenta.Direccion__c;
				
				if(!validarSucursal()){
					return null;        
				}
				return redireccion();
				//hasError=true;
				//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se pudo contactar el servicio'));
			}
			if(values.get('direccionEstandarizada').length()<48){
				hasError=true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'La direccion ingresada presenta errores por favor valide e intente de nuevo: '+ values.get('direccionEstandarizada')));
				cuenta.Estado_Direccion__c='Con Errores';
				//cuenta.name='Sucursal '+cuenta.Direccion__c;            
				return redireccion();
			}*/
			
			String direccion = values.get('direccionNormalizada');
			//direccion=direccion.substring(47);
			
			if(values.get('error') == 'true') {
				hasError = true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'La direccion ingresada presenta errores por favor valide e intente de nuevo: ' + direccion));
				
				if(direccion.contains('*')) {
					cuenta.Estado_Direccion__c = 'Con Errores';
					
				} else {
					cuenta.Estado_Direccion__c = 'No Normalizada';
				}
				
			} else {
				System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Validado' + '   <<<<<<<<<<\n-=#=-\n');
				
				hasError                    = false;
				cuenta.Estado_Direccion__c  = 'Validado';
				//cuenta.Direccion__c         = direccion;
				//cuenta.Name                 = 'Sucursal ' + cuenta.ciudad__r.Name + ' ' + direccion;
				cuenta.Name                 = 'Sucursal ' + strNombreCiudad + ' ' + cuenta.Direccion__c;
			}
			
			/* BEGIN - Manuel Medina - Asignacion variables para registro del log - 22082016 */
			strRequest						= request;
			strResponse						= response;
			strError						= '';
			/* END - Manuel Medina - Asignacion variables para registro del log - 22082016 */
			
			if(!validarSucursal()) {
				return null;
			}
			
			return redireccion();
		}
		
		return null;
	}   
	
	public boolean validarSucursal(){
		
		/* BEGIN - Manuel Medina - Ajuste del WHERE para eliminar espacios que dificultaban la busqueda de sucursales duplicadas - 14092016 */
		Map<Id,Account> cuentasSuc				=new Map<Id,Account>([
													Select Id,
														Name, 
														(
															select id,
																name 
															from Sucursales__r
															Where Direccion__c =: ( String.isNotBlank( cuenta.Direccion__c ) ? cuenta.Direccion__c.trim() : '' )
															and Ciudad__c =: Cuenta.Ciudad__c
														) 
													from Account 
													Where id =: cuenta.Cuenta__c
												]);
		/* END - Manuel Medina - Ajuste del WHERE para eliminar espacios que dificultaban la busqueda de sucursales duplicadas - 14092016 */
		
		List<Account> suc=new List<Account>();
		if(cuentasSuc.get(cuenta.Cuenta__c)!=null){
			suc=cuentasSuc.get(cuenta.Cuenta__c).Sucursales__r;
		}
		
		if(!suc.isEmpty()){
			
			hasError=true;
			string losDuplicados='';
			
			for(Account s:suc){
				losDuplicados+=s.name+', ';
				
			}
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'La direccion de la sucursal ingresada ya se encuentra por favor valide las sucursales '+losDuplicados));
			return false;
		}
		
		return true;
	} 
	/* -- Este metodo ya no es usado
	public void consultar(){
		tibcoXml_cls tXml=new tibcoXml_cls();
		map<string,string> values=new map<string,string>();
		
		HomologacionCampos__c hc = HomologacionCampos__c.getValues('DC'+cuenta.Tipodedocumento__c);
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('DataCredito');
		string docM=(hc!=null)?hc.valor__c : cuenta.Tipodedocumento__c;
		string estado='Exitoso';
		
		values.put('correlationID',''+dateTime.now().getTime());
		values.put('NumeroDocumento',cuenta.AccountNumber);
		values.put('PrimerApellido',cuenta.Name);
		values.put('TipoDocumento',docM);
		
		string request=tibcoXml_cls.ConsultaScoring(values);
		
		string response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c+'Scoring',sw.EndPoint__c);
		
		tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
		
		values.putAll(proReq.getMap(response));
		
		cuenta.DataCredito_Fecha_Scoring__c=Date.today();
		
		system.debug('Info:'+values.get('CodigoError'));
		if(values.get('CodigoError')==null){
			estado='Fallida';  
			
		}else{
			cuenta.name=validarCampos(cuenta.name,values,'Nombres');
			cuenta.Datacredito_clasificacion__c=validarCampos(cuenta.Datacredito_clasificacion__c,values,'clasificacion');
			cuenta.Datacredito_puntaje__c=validarCampos(cuenta.Datacredito_puntaje__c,values,'puntaje');
			cuenta.Datacredito_tipo__c=validarCampos(cuenta.Datacredito_tipo__c,values,'tipo');
			
		}
		
		string CodigoRespuesta=(values.get('CodigoRespuesta')==null)?values.get('DescripcionError'):values.get('CodigoRespuesta');
		//insert cuenta;
		generarLog(request,response,Estado,CodigoRespuesta);
	}
	
	public static string validarCampos(object campo,map<string,string> valores, string etiqueta){
		string valor=(valores.get(etiqueta)!=null && valores.get(etiqueta)!='' && valores.get(etiqueta)!='Sin Valor'? valores.get(etiqueta): string.valueOf(campo));
		
		if(etiqueta=='Nombres' && valores.get('TipoDocumento')=='1' && valores.get('Nombres')!=null){
			//validarCampos(campo,values,'PrimerApellido')+ +validarCampos(campo,values,'SegundoApellido');                 
		}
		
		return valor;   
	}
	
	public void generarLog(string request,string response, string estado, string CodigoRespuesta){
		LogTransacciones__c lt =new LogTransacciones__c(Account__c=cuenta.id,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name='Scoring DataCredito',CodigoRespuesta__c=CodigoRespuesta);
		insert lt;
	}*/
	
	/**
	*   @Method: getContacto       
	*   @return String: Filtro del campo busqueda.
	*   @description: Se encarga de traer solamente los contactos relacionados a la cuenta para mostrarlos como filtro el el campo contacto de entrega.
	*   @Autor: Carlos Rodriguez [CA] 27/08/2015
	*/
	public string getContacto()
	{
		String strIdCuenta = ApexPages.currentPage().getParameters().get('idSuc');
		Schema.DescribeSObjectResult r = Contact.sObjectType.getDescribe();
		return  Site.getBaseUrl()+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where AccountId =\''+ strIdCuenta +'\' ')+'&f='+filtro_cls.codificar(',Name,Tipodedocumento__c,NumerodeIdentificacion__c')+'&infoParam=Sucursal&nom='+filtro_cls.codificar('Nombre,Tipo de documento,Número de identificación');
	}
	// FIN [CA]
	
	/**
	* @Method:		generarLogDirecciones
	* @param:		NA
	* @Description:	Crea regirstro de log para las transacciones de estandarizacion de direcciones
	* @author		Manuel Medina - 22082016
	*/
	public void generarLogDirecciones(){
		LogTransacciones__c objLog		= new LogTransacciones__c(
											Account__c              = cuenta.id,
											Informacion_Enviada__c  = strRequest,
											Informacion_Recibida__c = strResponse,
											Estado__c               = cuenta.Estado_Direccion__c,
											Name                    = 'Estandarizar direcciones',
											CodigoRespuesta__c      = strError
										);
		
		insert objLog;
	}
	
	/**
	* @Method:		obtenerCorrelationId
	* @param:		NA
	* @Description:	Obtener id de correlacion para las transacciones.
	* @author		Manuel Medina - 05092016
	*/
	public String obtenerCorrelationId(){
		Datetime dttFechaHoraActual	= System.now();
		Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
		String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
		
		return strCorrelationId;
	}
}