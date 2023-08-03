/**
 * @description       : Clase para consumir la respuesta de Watson desde la DB para el canal WhatApp
 * @author            : Rodrigo de la Castilleja (RdC)
 * @group             : ETB
 * @last modified on  : 08-25-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-24-2021   Rodrigo de la Castilleja (RdC)   Initial Version
 **/
global class DEG_ConsumeOrquestadorDBWhatsApp_cls{
	global DEG_ConsumeOrquestadorDBWhatsApp_cls(){
	}

    public class Output{
		@InvocableVariable(required = true)
		public Boolean withResponse = false;
		@InvocableVariable(required = true)
		public Boolean pasoAgente = false;
		@InvocableVariable(required = true)
		public String motivoAgente = '';
		@InvocableVariable(required = true)
		public String motivoContacto = '';
		@InvocableVariable(required = true)
		public String allMessage = '';
		@InvocableVariable(required = true)
		public String whatsAppInfo = '';
		@InvocableVariable(required = false)
		public String documentType = '';
		@InvocableVariable(required = false)
		public String documentNumber = '';
		@InvocableVariable(required = false)
		public String name = '';
		@InvocableVariable(required = false)
		public String lastName = '';
		@InvocableVariable(required = false)
		public String email = '';
		@InvocableVariable(required = true)
		public Boolean whatsAppTimeOut = false;
		@InvocableVariable(required = true)
		public Boolean isFueradeHorario = false;
	}

	public class Input{
		@InvocableVariable(required = true)
		public String conversationId;
		@InvocableVariable(required = true)
		public String whatsAppInfo;
	}
    @InvocableMethod(label = 'Get WhatsApps From DB')
	public static List<Output> makeGetCallout(List<Input> inputLst){
        //String allMessage;
		String mensaje = '';
		WhatsAppInfo wspAppInfo = new WhatsAppInfo();
        List<Output> outputLst = new List<Output>();
        outputLst.add(new Output());
		String sessionId = '';
		Boolean vieneFrame =false;

        MessagingSession messagingOriginal =  [SELECT DEG_LastResponse__c,DEG_TransferToAgent__c,LastModifiedDate,MessagingEndUser.Name,
										DEG_NumeroDocCliente__c, DEG_NombreCliente__c, DEG_TipoDocCliente__c, DEG_ApellidoCliente__c,DEG_EmailCliente__c, 
										DEG_MotivoAgente__c,DEG_MotivoContacto__c,DEG_LastResponseBefore__c,DEG_ComeInFrame__c,DEG_SessionIdWatson__c, DEG_NombredelaCola__c, DEG_IsFueraHorario__c
                                        FROM MessagingSession 
                                        WHERE Id =:inputLst[0].conversationId 
                                        LIMIT 1];
		sessionId = messagingOriginal.DEG_SessionIdWatson__c; //cambio
		Decimal timeBotWpp = [SELECT DEG_TimeBot__c
							FROM DEG_ConfigGenerales__mdt
							LIMIT 1].DEG_TimeBot__c;

		vieneFrame = messagingOriginal.DEG_ComeInFrame__c; //cambio
        System.debug('##messagingOriginal: '+ messagingOriginal);
        System.debug('##messagingOriginal.DEG_LastResponse__c: '+ messagingOriginal.DEG_LastResponse__c);
        System.debug('##messagingOriginal.DEG_LastResponseBefore__c: '+ messagingOriginal.DEG_LastResponseBefore__c);
        System.debug('##messagingOriginal.DEG_SessionIdWatson__c: '+ messagingOriginal.DEG_SessionIdWatson__c);
        System.debug('##messagingOriginal.Id: '+ messagingOriginal.Id);
	
		//get whatsApp info from text sended by the user, (document type selected)
		if( inputLst[0].whatsAppInfo != null && inputLst[0].whatsAppInfo != 'null'){
			wspAppInfo = (WhatsAppInfo)System.JSON.deserialize(inputLst[0].whatsAppInfo, WhatsAppInfo.class);
		}
        if(messagingOriginal != null){
			outputLst[0].motivoContacto = messagingOriginal.DEG_MotivoContacto__c;
			outputLst[0].isFueradeHorario = messagingOriginal.DEG_IsFueraHorario__c;
            if(messagingOriginal.DEG_TransferToAgent__c){
                outputLst[0].allMessage = messagingOriginal.DEG_LastResponse__c;
                outputLst[0].withResponse = true;
                outputLst[0].pasoAgente = true;
				System.debug('Nombre de la cola:: '+messagingOriginal.DEG_NombredelaCola__c);
				if (messagingOriginal.DEG_NombredelaCola__c == System.Label.DEG_SoporteTecnicoMasivos) {
					outputLst[0].motivoAgente = System.Label.DEG_Hogares_Soporte_Tecnico;
				} else {
                	outputLst[0].motivoAgente = messagingOriginal.DEG_MotivoAgente__c;
				}
            }
            else{
				if (wspAppInfo.name != null && wspAppInfo.name != '') {
					messagingOriginal.DEG_NombreCliente__c = wspAppInfo.name;
				}
				if (wspAppInfo.lastName != null && wspAppInfo.lastName != '') {
					messagingOriginal.DEG_ApellidoCliente__c = wspAppInfo.lastName;
				}
				if (wspAppInfo.email != null && wspAppInfo.email != '') {
					messagingOriginal.DEG_EmailCliente__c = wspAppInfo.email;
				}
				if (wspAppInfo.documentType != null && wspAppInfo.documentType != '') {
					messagingOriginal.DEG_TipoDocCliente__c = wspAppInfo.documentType;
				}
				if (wspAppInfo.documentNumber != null && wspAppInfo.documentNumber != '') {
					messagingOriginal.DEG_NumeroDocCliente__c = wspAppInfo.documentNumber;
				}
				System.debug('##messagingOriginal antesIF '+messagingOriginal);
                if(messagingOriginal.DEG_LastResponse__c  != null && messagingOriginal.DEG_LastResponse__c != ''){
					//delay(4); //New For testing 13/07/21
                    System.debug('##DEG_LastResponse__c MESSAGING '+messagingOriginal.DEG_LastResponse__c);
					// messagingOriginal.DEG_LastResponseBefore__c = messagingOriginal.DEG_LastResponse__c;
					outputLst[0].allMessage = messagingOriginal.DEG_LastResponse__c; //messagingOriginal.DEG_LastResponse__c;
					messagingOriginal.DEG_LastResponse__c = '';
                    update messagingOriginal;
                    outputLst[0].withResponse = true;
                }
                else{
                    outputLst[0].whatsAppInfo = InputLst[0].whatsAppInfo;
					/* We use 17 seconds for timeout for whatsapp, channel expires over 25 seconds, so 17s + delay 3 seconds + bot proccessing time < 25 seg  */
					System.debug('##wspAppInfo.lastResponseDate '+wspAppInfo.lastResponseDate);
					if(wspAppInfo.lastResponseDate != null && wspAppInfo.lastResponseDate != ''){
						outputLst[0].whatsAppTimeOut = DateTime.now() > DateTime.newInstance(Long.valueOf(wspAppInfo.lastResponseDate)).addSeconds(Integer.valueOf(timeBotWpp)); 
						System.debug('##outputLst[0].whatsAppTimeOut '+outputLst[0].whatsAppTimeOut);
						if(vieneFrame) delay(4);
							// MessagingSession msgSesion =  [SELECT DEG_LastResponse__c,DEG_TransferToAgent__c,LastModifiedDate,MessagingEndUser.Name,
							// 			DEG_NumeroDocCliente__c, DEG_NombreCliente__c, DEG_TipoDocCliente__c, DEG_ApellidoCliente__c,
							// 			DEG_EmailCliente__c, DEG_MotivoAgente__c,DEG_LastResponseBefore__c,DEG_ComeInFrame__c
                            //             FROM MessagingSession 
                            //             WHERE DEG_SessionIdWatson__c =:sessionId
							// 			ORDER BY CreatedDate ASC /*desc estaba*/ NULLS FIRST  
                            //             LIMIT 1];
							// messagingOriginal.DEG_LastResponse__c = msgSesion.DEG_LastResponse__c;
							// update messagingOriginal;
							// System.debug('##msgSesion frame: '+messagingOriginal);
							// System.debug('##msgSesion.DEG_LastResponse__c frame: '+ messagingOriginal.DEG_LastResponse__c);
							// System.debug('##msgSesion.DEG_LastResponseBefore__c frame: '+ messagingOriginal.DEG_LastResponseBefore__c);
							// System.debug('##msgSesion.DEG_SessionIdWatson__c frame: '+ messagingOriginal.DEG_SessionIdWatson__c);
							// System.debug('##msgSesion.Id frame: '+ messagingOriginal.Id);

							// System.debug('##messagingOriginal original: '+ messagingOriginal);

							// outputLst[0].whatsAppTimeOut = true;
							// if(msgSesion.DEG_LastResponse__c  != null && msgSesion.DEG_LastResponse__c != ''){
							// 	outputLst[0].allMessage = msgSesion.DEG_LastResponse__c ;
							// 	outputLst[0].withResponse = true;
							// } 
								
							//fin cambio
						// }
					}
					if(outputLst[0].whatsAppTimeOut){ 
						wspAppInfo.lastResponseDate = String.valueOf(DateTime.now().getTime());
						// System.debug('##wspAppInfo.lastResponseDate new '+outputLst[0].whatsAppTimeOut);
						outputLst[0].whatsAppInfo  = JSON.serialize(wspAppInfo);
					}
					else{
						if(!vieneFrame) delay(6);
					}
					return outputLst; 
				}
            }   
			//update messagingOriginal;
        }
  	
		List<DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapMensaje> wrapMensajes;


		try{
			wrapMensajes = (List<DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapMensaje>)System.JSON.deserialize(outputLst[0].allMessage, List<DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapMensaje>.class);
			
		}
		catch(Exception e){
			System.debug(logginglevel.INFO,'Se esperaba un objeto se recibio: ' + outputLst[0].allMessage);
		}

		if(wrapMensajes != null){
			System.debug('##wrapMensajes: '+wrapMensajes);
			wspAppInfo.buttonsMap.clear();
			for (DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapMensaje wrapMensaje : wrapMensajes){
				//buscar logica en lwc para los otros casos!
				if (wrapMensaje.esMsn != null && wrapMensaje.esMsn){
					mensaje = (mensaje != '' ? mensaje+'\n \n':'') +wrapMensaje.mensaje ;
					analyzeMessage(wspAppInfo,wrapMensaje.mensaje);
				}
				if (wrapMensaje.esBtn != null && wrapMensaje.esBtn){
					Integer i = 1;
					for(DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapBoton wrapBoton:wrapMensaje.lBotones){
						wspAppInfo.buttonsMap.put(i+'',normalizeText(wrapBoton.texto));
						mensaje = mensaje +'\n'+ i +'- '+ wrapBoton.texto;
						i++;
					}
					
				}
			}
		}
		
		outputLst[0].documentType 	= wspAppInfo.documentType;
		outputLst[0].documentNumber = wspAppInfo.documentNumber;
		outputLst[0].name			= wspAppInfo.name;
		outputLst[0].lastName  		= wspAppInfo.lastName;
		outputLst[0].email 			= wspAppInfo.email;		
	
		if(wspAppInfo.state == 'ready'){
			wspAppInfo.state = '';
		}

		mensaje = (mensaje != null && mensaje.trim() != '' ? mensaje :'Tenemos un problema en procesar tu solicitud 😥 \n ¿deseas volver a intentar?'  );

		outputLst[0].allMessage 	= mensaje;
		System.debug('##outputLst[0].allMessage ' + outputLst[0].allMessage);
		outputLst[0].whatsAppInfo  = JSON.serialize(wspAppInfo);
        System.debug('##outputLst return' + outputLst[0]);
		return outputLst;
	
	}
	/*---------------------------------------------------------------------------------------------
	 Autor: Rodrigo de la Castilleja (RdC)
	 Descripción: Method for analize and store response from watson
	 @params: List<OrquestWspInput> WhatsAppInfo , String message
	 @return: void
	 ----------------------------------------------------------------------------------------------*/
    private static void analyzeMessage(WhatsAppInfo wspAppInfo,String message){

		Map<String, DEG_WhatsAppDataCapture__mdt>  mdtRgExpresions=  DEG_WhatsAppDataCapture__mdt.getAll();
		DEG_WhatsAppDataCapture__mdt mdtRgExpresion = mdtRgExpresions.get('DEG_WhatsAppDataCapture');
		system.debug(logginglevel.INFO,mdtRgExpresion);

		Pattern p;
		Matcher pm;
		
		
		//message from watson to request Name
		// .*Por favor escribe tu primer nombre.*
		p = Pattern.compile(mdtRgExpresion.DEG_Name__c); 
		pm = p.matcher(message);

		if( pm.matches() ){
			wspAppInfo.state = 'GetName';
		}

		//message from watson to request last Name
		// .*tu apellido.*
		p = Pattern.compile(mdtRgExpresion.DEG_LastName__c); 
		pm = p.matcher(message);

		if( pm.matches() ){
			wspAppInfo.state = 'GetLastName';
		}

		//message from watson to request document type
		// (.*Selecciona tu tipo de documento.*)|(.*ind.queme el tipo de documento.*)
		p = Pattern.compile(mdtRgExpresion.DEG_TipoDoc__c); 
		pm = p.matcher(message);

		if( pm.matches() ){
			wspAppInfo.state = 'GetDoctype';
		}

		//message from watson to request document number
		// (.*n.mero de documento.*)|(.*me informa el n.mero de.*)
		p = Pattern.compile(mdtRgExpresion.DEG_NumDoc__c); 
		pm = p.matcher(message);
		if( pm.matches() ){
			wspAppInfo.state = 'GetDocNumber';
		}

		//message from watson to request email
		// .*tu correo electr.nico.*
		p = Pattern.compile(mdtRgExpresion.DEG_Email__c); 
		pm = p.matcher(message);

		if( pm.matches() ){
			wspAppInfo.state = 'GetEmail';
		}

		//message for data confirmation from watson
		// (.*Estoy listo para ayudarte con.*)|(.*Para orientar mejor la atención que le vamos a brindar.*)|(Validando la informaci.*)
		p = Pattern.compile(mdtRgExpresion.DEG_DataConfirmation__c); 
		pm = p.matcher(message);
		if( pm.matches() ){
			wspAppInfo.state = 'ready';
		}
	}

    public class WhatsAppInfo{
		public String state = '';
		public String documentType = '';
		public String documentNumber = '';
		public String name = '';
		public String lastName = '';
		public String email = '';
		public String lastResponseDate = ''; 
		public String reasonAgent = '';
		public Map<String,String> buttonsMap = new Map<String,String>();
	}

	public static string normalizeText(string text){
		text = text.replaceAll('[àâãäå]', 'a');
		text = text.replaceAll('[èêë]', 'e');
		text = text.replaceAll('[ìîï]', 'i');
		text = text.replaceAll('[òôõö]', 'o');
		text = text.replaceAll('[ùûü]', 'u');
		text = text.replaceAll('[æ]', 'ae');
		text = text.replaceAll('[ç]', 'c');
		text = text.replaceAll('[ýÿ]', 'y');
		text = text.replaceAll('[ÀÂÃÄÅ]', 'A');
		text = text.replaceAll('[ÈÊË]', 'E');
		text = text.replaceAll('[ÌÎÏ]', 'I');
		text = text.replaceAll('[ÒÔÕÖ]', 'O');
		text = text.replaceAll('[ÙÛÜ]', 'U');
		text = text.replaceAll('[Æ]', 'AE');
		text = text.replaceAll('[Ç]', 'C');
		text = text.replaceAll('[ÝŸ]', 'Y');
		text = text.replaceAll('[^(a-záéíóúA-ZÁÉÍÓÚ0-9\\+\\s\\.\\,\\:\\/\\-)]', '');
		return text;
	}
	 /*Delay for gain time*/
	 public static void delay(Integer seconds){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.DEG_IPReservada);
        request.setMethod('GET');
        request.setTimeout(seconds*1000);
        try{
            HttpResponse response = http.send(request);
        }
        catch(Exception e){
            
        }
    }
}