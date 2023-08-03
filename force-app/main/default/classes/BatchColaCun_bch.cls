/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraciones Clientes CUN
Descripci�n:			Batch Para procesar los CUN que estan pendientes de ser generados
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci�n
------  ----------  --------------------        ---------------
1.0		11-03-2014	Hector Bayona (HB)		Creaci�n de la clase
*******************************************************************************/
global class BatchColaCun_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{

    global Database.Querylocator start(Database.Batchablecontext bc)
	{
		String query = 'SELECT Contacto__c,Contacto__r.Email,Remitente__c,Cod_Error_Cun__c,CreatedById,CreatedDate,Estado_Envio__c,FechaPQR__c,Id,Identificacion__c,Id_Registro__c,Intentos__c,IsDeleted,LastModifiedById,LastModifiedDate,Mensaje_DML__c,Name,NumOrden__c,Objeto__c,OwnerId,SystemModstamp,TipoIdentificacion__c,TipoPQR__c,esRastrocun__c,NumCun__c FROM Cola_CUN__c WHERE Estado_Envio__c = \'Pendiente\'';
		system.debug('\nConsultaBatch: '+query);
		return Database.getQueryLocator(query);
	}
    
	global void execute(Database.BatchableContext bc, List<Cola_CUN__c> scope){
		
		//Realiza el llamdo
		list<consultaServ> con=new list<consultaServ>();
		
		//Consulta el servicio
		for(Cola_CUN__c col: scope){
			con.add(new consultaServ(col));
		}
		
		//Guarda la cola y actualiza el sobject caso/Legalizacion
		for(consultaServ col: con){
			col.guardar();
		}
		
	
	}
	
	global void finish(Database.BatchableContext bc){
		
		BatchColaCun_sch.ProgramarJob();
		system.debug('!!!EXITO');
	}
	
	global class consultaServ{
		
		public Cola_CUN__c col;
		private id idSobj;
		private String sobjType;
		private String Cun;
		private string CodErrorCun;
		private string response;
			
		public consultaServ(Cola_CUN__c col){
			this.col=col;
			this.idSobj=col.Id_Registro__c;
			system.debug(this.idSobj);
			this.sobjType=String.valueOf(this.idSobj.getSObjectType());
			consultar();
		}
		//Consume el servicio web
		public void consultar(){
			
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('CodigoCun');
			map<string,string> values=new map<string,string>();
			values.put('TipoPQR',col.TipoPQR__c);
			//values.put('FechaPQR',col.FechaPQR__C.format('MM/dd/yyyy HH:mm:ss'));//'dd/MM/yyyy HH:mm:ss'
			values.put('NumOrden',col.NumOrden__c);
			values.put('TipoIdentificacion',col.TipoIdentificacion__c);
			values.put('Identificacion',col.Identificacion__c);
			values.put('NumConexion','0');
			values.put('correlationID',col.Id_Registro__c);
			
			string request='';
			string serv='';
			
			if(col.esRastrocun__c){
				values.put('FechaPQR',col.FechaPQR__C.format('dd/MM/yyyy HH:mm:ss')); 
				values.put('NumCun',col.NumCun__c);
				serv='/Service/SisExt.serviceagent/Endpoint/ConsultarRastroCun';
				request=tibcoXml_cls.ConsultarRastroCun(values);
			}else{
				values.put('FechaPQR',col.FechaPQR__C.format('MM/dd/yyyy HH:mm:ss'));
				request=tibcoXml_cls.AsignarCUN(values);
				serv='/Service/SisExt.serviceagent/Endpoint/AsignarCun';
			}

			
			response=LibreriaUtilitariaJobs_cls.consultarServicio(request,serv,sw.EndPoint__c);
			
			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
			
			values=proReq.getMap(response);
						
			CodErrorCun=values.get('CodError');
			set<string> validos=new set<string>{'5013','5014','5015'};
			
			if(validos.contains(CodErrorCun)){
				//Rastro cun solo actualiza la cola no el cun
				if(col.esRastrocun__c){
					col.Estado_Envio__c='Exitoso';
					col.Mensaje_DML__c='Exitoso';
				//actualiza el cun y la cola
				}else{
					cun=values.get('NumCun');
					col.NumCun__c=cun;
				}
			}
			
		}
		//Guarda la cola y actualiza el sobject caso/Legalizacion
		public void guardar(){
			system.debug('obj'+sobjType+' id'+idSobj);
			string sQuery='Select id,CodigouniconumericoCUN__c From '+sobjType+' Where Id=:idSobj';
			Sobject so=Database.query(sQuery);
			so.put('CodigouniconumericoCUN__c',Cun);
			
			if(cun!=null){
				//Insercion sin fallos
				Database.SaveResult dr=Database.update(so,false);
				
				//Si fallo por algun motivo caso/legalizacion guardamos traza
				if(dr.isSuccess()){
					col.Mensaje_DML__c='Exitoso';
					col.Estado_Envio__c='Exitoso';
					col.NumCun__c=Cun;
					//enviarCorreo(col);
				}else{
					col.Mensaje_DML__c=String.valueOf(dr.getErrors());
					col.Estado_Envio__c='Actualizaci�n Fallida';
				}
				system.debug('Actualizo Cun: '+so);
			}
			//Actualizamos el registro de la cola.

			
			col.Cod_Error_Cun__c=CodErrorCun;
			col.Intentos__c=col.Intentos__c+1;
			col.response__c=response;

			//Guarda para que el valor del cun se encuentre en bd y la plantilla encuentre los valores 
			Database.update(col,false);
			
			if(col.Mensaje_DML__c=='Exitoso'){
				enviarCorreo(col);
				//Guarda el resultado del envio de correo
				Database.update(col,false);
			}



			system.debug(col);
		
		}

		public void enviarCorreo(Cola_CUN__c colMail){

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSenderDisplayName(colMail.Remitente__c);
			mail.setReplyTo(colMail.Remitente__c);
            mail.setReferences(colMail.Remitente__c);
			mail.setTargetObjectId(colMail.Contacto__c);
			mail.setTemplateId('00X40000001qu46EAA');
            					//00X40000001qu46EAA
            
			mail.setWhatId(colMail.id);
			mail.setToAddresses(new String[]{colMail.Contacto__r.Email});
            //mail.setBccAddresses(new list<string>{'hector_bayona@hotmail.com','luz.romeroc@etb.com.co'});//'luz.romeroc@etb.com.co' 
			//mail.saveAsActivity = true;

			try{
				Messaging.SendEmailResult[] repuesta=Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
					if(repuesta[0].isSuccess()){
						colMail.Envio_Correo__c='Envio Exitoso';
                        colMail.Reenviar_Correo__c=false;
					}else{
						colMail.Envio_Correo__c='Envio Fallido';
                        colMail.Reenviar_Correo__c=true;
					}
				}
			catch(exception e){
				colMail.Envio_Correo__c=e.getMessage();
                colMail.Reenviar_Correo__c=true;

			}

		}
	
	}
    


}