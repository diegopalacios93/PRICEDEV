/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraciones Clientes CUN
Descripción:			Clase generica que permite la asignacion del cun.
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		11-03-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/

public with sharing class ConsultaCun_ctr {
	
	public boolean manual{get;set;}
	public boolean paso1{get;set;}
	public boolean heredBot{get;set;}
	//Campo para la validacion manual en Cun Center
	public boolean blnProblemConexion{get;set;}
	public boolean blnAceptaValidacionManual{get;set;}
	
	public string cunManual{get;set;} 
	public string tipo{get;set;}
	public id id{get;set;}
	public id idc=null;
	private Schema.sObjectType obj;
	public sobject objData{get;set;}
	
	private string idCuenta='';
	private string Tipodedocumento='';
	private string NumOrden='';
	private string TipoPQR='';
	private string response='';
	private string CodErrorCun='';
	private string idT='';
	public string strSistemaLegado {get;set;}
	
	private DateTime FechaPQR;
	private string cun='';
	private CUN_Center_Abajo__c cunInfo;
	private string hCun='';
	
	public list<wrapperSelect> ws{get;set;}

	
	public ConsultaCun_ctr(){
		paso1=true;
		manual=false;
		heredBot=true;
		blnProblemConexion=false;
		blnAceptaValidacionManual=false;
	}
	
	public void ObtenerConf(){
		
		/*OBTIENE LOS DATOS EN BASE AL CONTRATO
		idc = ApexPages.currentPage().getParameters().get('idc');
		

		//Si es legalizacion creamos
		if(idc!=null){
			if(string.valueOf(idc.getSObjectType())=='Contract'){
				Legalizacion__c l =new Legalizacion__c(Contrato__c=idc);
				insert l;
				id=l.id;			
			}
		}else{}
		*/
			
		id = ApexPages.currentPage().getParameters().get('id');
		
		obj =id.getSObjectType();
		//Obtenemos la configuracion personalizada para saber si es manual y todo el mapeo del objeto
		cunInfo = CUN_Center_Abajo__c.getValues(string.valueof(id.getSObjectType()));

		if(cunInfo!=null){
			manual=cunInfo.Esta_Abajo__c;
			obtenerObj();
		}
	
	
	}
	
	//Obtiene la informacion del registro
	public void obtenerObj(){
		
		
		//Construimos la consulta en base a la conf. personalizada
		string query='Select CreatedDate,id, CodigouniconumericoCUN__c,'+cunInfo.Campo__c+', '+cunInfo.NumOrden__c+','+cunInfo.TipoIdentificacion__c; 
		
		//Si esta definido el campo que corresponde a tipo Pqr se consulta
		if(cunInfo.TipoPQR__c!=null){
			query+=','+cunInfo.TipoPQR__c+',ContactId,Account.Name,LTE_SistemaLegado__c';	
		}

		query+=' From '+cunInfo.Name+' Where id=:id';
		
		
		system.debug(query); 
		objData=Database.query(query);
		
		FechaPQR=dateTime.valueOf(objData.get('CreatedDate'));
		
		if(cunInfo.Name=='Case'){
			strSistemaLegado=string.valueOf(objData.get('LTE_SistemaLegado__c'));
		}

        
		idT=(String)objData.get('Id');
		system.debug('\n\n\n\n\n\n\n\n\n'+idT);
		
		list<string> campos=cunInfo.Campo__c.split('\\x2E');
		
		NumOrden=string.valueOf(objData.get(cunInfo.NumOrden__c));
		
		//Si esta definido el campo que corresponde a tipo Pqr se asigna si no deja ventas por defecto
		if(cunInfo.TipoPQR__c!=null){
			TipoPQR=string.valueOf(objData.get(cunInfo.TipoPQR__c));
		}else{
			TipoPQR='Ventas';
		}
		
		//Limpia caracteres especiales
		TipoPQR=LibreriaUtilitaria_cls.quitarCaracteresEsp(TipoPQR);
		
		//Objeto para iterar dinamicamente en las relaciones.
		sobject sobj=objData;
		
		system.debug(campos);
		//Obtiene el nuemero de cuenta en base la informacion de la Conf personalizada
		for(Integer i=0;campos.size()>i;i++){

			if(i==(campos.size()-1)){
				system.debug(campos[i]);
				system.debug(sobj);
				idCuenta=string.valueOf(sobj.get(campos[i]));
				Tipodedocumento=string.valueOf(sobj.get('Tipodedocumento__c'));
			}else{
				sobj=sobj.getSObject(campos[i]);
			}
		
		}
		
		if(Tipodedocumento=='Cédula de ciudadanía'){
			Tipodedocumento='CC';		
		}
		
	}
	public Pagereference Cancelar(){
		PageReference paginaInicio= new PageReference('/'+objData.Id);
		paginaInicio.setRedirect(true);
		return paginaInicio;		
	}
	
	public PageReference ConsultarCun(){
		paso1=false;
		ws =new list<wrapperSelect>();
		
		if(tipo=='nuevo'){
			return getCunNuevo();
		}
	
		return null;
	}
	
	public void rastroCun(string selCun){
	
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('CodigoCun');
		map<string,string> values=new map<string,string>();
		values.put('TipoPQR',TipoPQR);
		values.put('FechaPQR',FechaPQR.format('dd/MM/yyyy HH:mm:ss'));
		values.put('NumOrden',NumOrden);
		values.put('TipoIdentificacion',Tipodedocumento);
		values.put('Identificacion',idCuenta);
		values.put('NumConexion','0');
		values.put('NumCun',selCun);
		values.put('correlationID',idT);
		
		
		string request=tibcoXml_cls.ConsultarRastroCun(values);
		
			response=LibreriaUtilitariaJobs_cls.consultarServicio(request,'/Service/SisExt.serviceagent/Endpoint/ConsultarRastroCun',sw.EndPoint__c);
			system.debug(response);
			
			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
			
			values.putAll(proReq.getMap(response));
			
			set<string> validos=new set<string>{'5013','5014','5015'};
			CodErrorCun=values.get('CodError');

			if(validos.contains(CodErrorCun)){
			
			}else{
				cunFallido(true);
			}

	
	}
	
	public Pagereference getCunNuevo(){
		
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('CodigoCun');
		map<string,string> values=new map<string,string>();
		values.put('TipoPQR',TipoPQR);
		values.put('FechaPQR',FechaPQR.format('MM/dd/yyyy HH:mm:ss'));
		values.put('NumOrden',NumOrden);
		values.put('TipoIdentificacion',Tipodedocumento);
		values.put('Identificacion',idCuenta);
		values.put('NumConexion','0');
		values.put('correlationID',idT);
		
		try{
			string request=tibcoXml_cls.AsignarCUN(values); 
			response=LibreriaUtilitariaJobs_cls.consultarServicio(request,'/Service/SisExt.serviceagent/Endpoint/AsignarCun',sw.EndPoint__c);
			//                                                            '/Service/SisExt.serviceagent/Endpoint/AsignarCun'
			//															   /Service/ManagePQR.serviceagent/PortTypeEndpoint1
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.FalloServicio));
		}

		tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
		
		values.putAll(proReq.getMap(response));
			
		set<string> validos=new set<string>{'5013','5014','5015'};
		CodErrorCun=values.get('CodError');

		if(validos.contains(CodErrorCun)){
			
			string labelm=Schema.getGlobalDescribe().get(id.getSObjectType()+'').getDescribe().fields.getMap().get('CodigouniconumericoCUN__c').getDescribe().getLabel()+': '+values.get('NumCun');
			
			objData.put('CodigouniconumericoCUN__c',values.get('NumCun'));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, labelm));
			update objData;
			
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se pudo contactar el CUN center, su solicitud será procesada brevemente'));
			cunFallido(false);
		}
		



		return null;
		
	}
	
	public PageReference continuar(){
		system.debug('\n Sistema legado\n'+strSistemaLegado );
		//string a = 'Plib';
		
	     if (strSistemaLegado=='Remedy'||strSistemaLegado=='REMEDY')
	    {
	    	PageReference pageRef = new PageReference('/apex/LTE_Remedy_pag?ID='+objData.Id);
            return pageRef;
	    }
	     else if (strSistemaLegado=='Plib' || strSistemaLegado=='PLIB')
	    {
	    	PageReference pageRef = new PageReference('/apex/LTE_Plib_pag?ID='+objData.Id);
            return pageRef;
	    }
	    else
	    {
	    PageReference paginaInicio= new PageReference('/'+objData.Id);//+'/e?retURL=%2F'+objData.Id);
		paginaInicio.setRedirect(true);
		return paginaInicio;
	    }
	
	
	}
	
	
	//Asigna el id que se ingreso de forma manual.
	public PageReference ConsultarManual(){
		
		if(cunManual.length()!=16){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La longitud del CUN ingresado no es de 16'));
			return null;		
		}
		
		objData.put('CodigouniconumericoCUN__c',cunManual);
		
		update objData;
		
		PageReference paginaInicio= new PageReference('/'+objData.Id);
		paginaInicio.setRedirect(true);
		return paginaInicio;
	}
	
	//Actualiza el cun en base a uno existente
	public PageReference guardarHeredado(){
		
		string selCun;
		
		/*
		for(wrapperSelect w1:ws){
			if(w1.opt){
				selCun=w1.cun;
				break;
			}
		}
		if(selCun==null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.seleccioneUnCun));
			return null;
		}
		*/
		
		try{
		//	Función para poder controlar Excepciones en la clase de pruebas
		LibreriaUtilitaria_cls.GenerarExcepcionTest();
		
		rastroCun(hCun);
		
		objData.put('CodigouniconumericoCUN__c',hCun);
		update objData;
		
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
			return null;		
		}
		
		
		PageReference paginaInicio= new PageReference('/'+objData.Id);
		paginaInicio.setRedirect(true);
		return paginaInicio;
	}
	
	//Trae la relacion en base al cun ingresado y al identificador del cliente
	public void buscar(){
		ws =new list<wrapperSelect>();		
		
		/*
		string query='Select CodigouniconumericoCUN__c From '+cunInfo.Name+' Where '+cunInfo.Campo__c+'=:idCuenta and CodigouniconumericoCUN__c!=null and CodigouniconumericoCUN__c like \''+cunManual+'%\' Group by CodigouniconumericoCUN__c';
		system.debug(query); 
		
		list<sobject>heredados=Database.query(query);
		*/

		ServiciosWeb__c sw = ServiciosWeb__c.getValues('CodigoCun');
		map<string,string> values=new map<string,string>();
		values.put('NumCun',cunManual);
		values.put('TipoIdentificacion',Tipodedocumento);
		values.put('Identificacion',idCuenta);
        values.put('correlationID',idT);
		
		
		string request=tibcoXml_cls.HistorialCUN(values);
		
		response=LibreriaUtilitariaJobs_cls.consultarServicio(request,'/Service/SisExt.serviceagent/Endpoint/ConsultarHistoricoCun',sw.EndPoint__c);
		System.debug('\n\n\n\n'+response);

		tibcoXml_cls.xmlMapConsulta proReq=new tibcoXml_cls.xmlMapConsulta();
			
		set<string> datac =proReq.getMap(response);


		if(datac.contains(cunManual)){
			hCun=cunManual;
			heredBot=false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Cun Valido'));
		}else{
			if(datac.contains('PASS')){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Se encontro coincidencia'));
				heredBot=true;
				hCun='';
			}else{
				blnProblemConexion=true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Problemas de comunicación'));
				//objData.put('CodigouniconumericoCUN__c',cunManual);
				hCun = cunManual;
			}

		}
			

		/*for(sobject s:heredados){
			ws.add(new wrapperSelect(false,s.get('CodigouniconumericoCUN__c')));
		}*/
	}

	//Permite continuar con el ingreso del codigo Cun cuando se presentan problemas en la conexión
	//mediante previa validacion manual ante el Cun-Center en forma manual.
	public pagereference aceptaValidarCunManual()
	{
		System.debug('@@-blnAceptaValidacionManual->'+blnAceptaValidacionManual);
		try
		{
			if (blnAceptaValidacionManual) {
				System.debug('@@-blnAceptaValidacionManual-Condicional->'+blnAceptaValidacionManual);				
				hCun=cunManual;
				heredBot=false;	
				objData.put('AceptaValidarCUNmanual__c',blnAceptaValidacionManual);
				update objData;
									    
			}else{
				heredBot=true;
				hCun='';
				objData.put('AceptaValidarCUNmanual__c',blnAceptaValidacionManual);
				update objData;
			}
		}
		catch(Exception e){ e.getMessage(); }
		return null; 
	}





	
	//En caso de que la consulta de Cun guardamos un registro de cola
	public void cunFallido(boolean esRastrocun){
		
		Cola_CUN__c cCun=new Cola_CUN__c();
		cCun.Estado_Envio__c='Pendiente';
		cCun.Cod_Error_Cun__c=CodErrorCun;
		cCun.Identificacion__c=idCuenta;
		cCun.TipoIdentificacion__c=Tipodedocumento;
		cCun.NumOrden__c=NumOrden;
		cCun.FechaPQR__c=FechaPQR;
		cCun.TipoPQR__c=TipoPQR;
		cCun.Objeto__c=cunInfo.Name;
		cCun.Id_Registro__c=id;
		cCun.response__c=response;
		cCun.esRastrocun__c=esRastrocun;
		//cCun.NumCun__c=(string)objData.get('CodigouniconumericoCUN__c');
		cCun.NumCun__c=hCun;
		if(TipoPQR!='Ventas'){
			
			if(objData.get('TipoCaso__c')=='CASO PQR'){
				cCun.Remitente__c='grandes_clientes@etb.com.co';
			}else{
				cCun.Remitente__c='helpdesketb@etb.com.co';
			}


		cCun.Contacto__c=(string)objData.get('ContactId');
			if(objData.getSObject('Account')!=null){
				cCun.Cliente__c=(string)objData.getSObject('Account').get('Name');
			}
		}

		
		upsert cCun Id_Registro__c;
	}

	
	//Calse para almacenar los cun para heredar
	public class wrapperSelect{
		
		public boolean opt{get;set;}
		public string cun{get;set;}

		
		public wrapperSelect(Boolean opt,object cun){
			this.opt=opt;
			this.cun=string.valueOf(cun);
		
		}
	}
	/*
	public void test(){
		wwwEtbComCoNplayConsultacunRequest.inputAsignaCUN_element reqObj=new wwwEtbComCoNplayConsultacunRequest.inputAsignaCUN_element();
		reqObj.TipoPQR='Ventas';
		reqObj.FechaPQR=String.ValueOf(Datetime.now());
		reqObj.NumOrden='L-000717';
		reqObj.TipoIdentificacion='NIT';
		reqObj.Identificacion='900830531';
		reqObj.NumConexion='12334567';
		
		xmlnsExampleCom1391803107156.intfwsParseAssignCUNEndpoint servicio=new xmlnsExampleCom1391803107156.intfwsParseAssignCUNEndpoint();
		servicio.timeout_x=60000;
		wwwEtbComCoNplayConsultacunRequest.ResponseCUN_element servObj=servicio.ParseAssignCUNOp(reqObj.TipoPQR,reqObj.FechaPQR,reqObj.NumOrden,reqObj.TipoIdentificacion,reqObj.Identificacion,reqObj.NumConexion);
	}*/
	
}