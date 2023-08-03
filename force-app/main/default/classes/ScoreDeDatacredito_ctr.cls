/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Integración DATACREDITO
Descripción:            Clase encargada de soportar el servicio Web de consulta CUN.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     10-10-2014  Hector Bayona (HB)       Creación de la clase.
*******************************************************************************/
public with sharing class ScoreDeDatacredito_ctr {
	
	public id idc{get;set;}
	public  Account cuenta;
	private  LogTransacciones__c lt;
	private  Generico__c gen=new Generico__c();
	private string estado='';
	
	
	public ScoreDeDatacredito_ctr(){
		
		idc=(id)ApexPages.currentPage().getParameters().get('id');
		cuenta=[Select id,DataCredito_Fecha_Scoring__c,Tipodedocumento__c,AccountNumber,OwnerId,name from Account where id=:idc];
		system.debug(idc);

	}

	public pagereference inicio(){
		
		Perfiles_Acciones__c myCS1 = Perfiles_Acciones__c.getValues('DataCreditoScore');
		set<string> perfiles=new set<string>(myCS1.Usuarios__c.split(','));
		
		
		
		if(cuenta.OwnerId!=Userinfo.getUserId() && !perfiles.contains(UserInfo.getProfileId())){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Solo el propietario de la cuenta puede solicitar el scoring de Data Credito'));		
		}
		else if(validacionFecha()){
			consultar();
			if(estado=='Fallida'){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se pudo contactar el servicio por favor, comuniquese con el Administrador'));
				return null;
			}
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Puntaje: ' + gen.Datacredito_puntaje__c +' Tipo:'+gen.Datacredito_tipo__c+' Clasificacion:'+gen.Datacredito_clasificacion__c));
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DataCreditoErrorFechaConsulta));
			return null;
		}



		return null;
	}
	
	public Boolean validacionFecha(){
		
		integer generico=[select count() from Generico__c where NO_Ids__c=:idc];
		
		system.debug('generico::'+generico);
		if(cuenta.DataCredito_Fecha_Scoring__c==null && generico==0){
			return true;		
		}
		
		else if(cuenta.DataCredito_Fecha_Scoring__c!=null){
			Date ultima=Date.valueOf(cuenta.DataCredito_Fecha_Scoring__c);
			
			//integer dias=Date.today().daysBetween(ultima);
			integer dias=ultima.daysBetween(Date.today());
			system.debug('dias:::'+dias);
			if(dias>=30){
				return true;		
			}
		}
		
		return false;
	}
	
	public void consultar(){



		tibcoXml_cls tXml=new tibcoXml_cls();
		map<string,string> values=new map<string,string>();
		
		HomologacionCampos__c hc = HomologacionCampos__c.getValues('DC'+cuenta.Tipodedocumento__c);
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('DataCredito');
		string docM=(hc!=null)?hc.valor__c : cuenta.Tipodedocumento__c;
		estado='Exitoso';
		
		
		
			values.put('correlationID',cuenta.id);
			values.put('NumeroDocumento',cuenta.AccountNumber);
			values.put('PrimerApellido',cuenta.Name);
			values.put('TipoDocumento',docM);

			string request=tibcoXml_cls.ConsultaScoring(values);
			
			string response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c+'Scoring',sw.EndPoint__c);
			system.debug(response);

			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();


			values.putAll(proReq.getMap(response));
			
			system.debug(values);
			
			system.debug(values.get('CodigoRespuesta')+'\n'+values.get('CodigoError'));
			gen.DataCredito_Fecha_Scoring__c=Datetime.now();
			gen.NO_Ids__c=Cuenta.Id;
			gen.NO_Estado__c='Pendiente';
			
			if(values.get('CodigoError')==null){
				estado='Fallida';		
			}else{
				if(values.get('CodigoError')=='13' || values.get('CodigoError')=='14'){
					gen.Datacredito_clasificacion__c=values.get('clasificacion');
					gen.Datacredito_puntaje__c=values.get('puntaje');
					gen.Datacredito_tipo__c=values.get('tipo');
				}else{
					gen.Datacredito_clasificacion__c='No se encontro';
					gen.Datacredito_puntaje__c='No se encontro';
					gen.Datacredito_tipo__c='No se encontro';				
				}
			}
			upsert gen NO_Ids__c;
			
			string CodigoRespuesta=(values.get('CodigoRespuesta')==null)?values.get('DescripcionError'):values.get('CodigoRespuesta');
			
			if(values.get('CodigoError')!=null && values.get('CodigoError')!='09'){
				gen.NO_Ids__c=Cuenta.Id;
				upsert gen NO_Ids__c;		
			}
			
			
			generarLog(request,response,Estado,CodigoRespuesta);
			//CodigoRespuesta
			//CodigoError
			

	}
	
	public void generarLog(string request,string response, string estado, string CodigoRespuesta){
		
		lt =new LogTransacciones__c(Account__c=idc,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name='Scoring DataCredito',CodigoRespuesta__c=CodigoRespuesta);
		
		insert lt;
	
	
	}
	
	
	
	
	

}