/**
 * @description       : Clase de Web Service para consumir el Orquestador de Watson para whatsapp NUEVA
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : ETB
 * @last modified on  : 05-24-2022
 * @last modified by  : j.martinez.mercado@accenture.com
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   01-08-2021   Harlinsson Chavarro (HCH)         Initial Version
 * 2.0   22-02-2022   Brisleydi Calderon                Corrección campo MotivoContacto
 * 3.0   27-04-2022	  Alejandro Peña T					Mejora Encuestas Bot                  
 **/
global without sharing class DEG_ConsumeOrquestadorAsyncWpp_ws{


	public class Output{
	  @InvocableVariable(required = true)
	  public String allMessage = '';
	}
  
	public class Input{
	  @InvocableVariable(required = true)
	  public String sessionId;
	  @InvocableVariable(required = true)
	  public String textClient;
	  @InvocableVariable(required = true)
	  public String conversationId;
	  @InvocableVariable(required = true)
	  public String canalBot;
	}
  
	/*---------------------------------------------------------------------------------------------
	 Autor: Javier Tibamoza (JATC)
	 Descripción: Method is invoke since WS Frames Response for consuming rest service with IBM Watson
	 @params: List<Input> OrquestInLst ; sResponse :: JSON, response frames
	 @return: List<Output>
	 ----------------------------------------------------------------------------------------------*/
	public static void makeGetCallout(List<Input> OrquestInLst, String sResponse){
	  makeGetCallout(JSON.serialize(OrquestInLst), sResponse);
	}
  
	@future(Callout = true)
	public static void makeGetCallout(String JSONOrquestInLst, String sResponse){
	  System.debug('JSONOrquestInLst-->' + JSONOrquestInLst);
	  List<Input> OrquestInLst = (List<Input>)System.JSON.deserialize(JSONOrquestInLst, List<Input>.class);
	  System.debug('List OrquestInLst-->' + OrquestInLst);
	  getCallout(OrquestInLst, '2', sResponse);
	}
  
	/*---------------------------------------------------------------------------------------------
	 Autor: Harlinsson Chavarro (HCH)
	 Descripción: Method is invoke since bot einstein for consuming rest service with IBM Watson
	 @params: List<Input> OrquestInLst: It is a list because bot understand so.
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	@InvocableMethod(label = 
	'Get Integration Async') // En ambiente dev la etiqueta era 'Get Integration Async wpp' 
	public static List<Output> makeGetCallout(List<Input> OrquestInLst){
	  System.debug('textList ' + OrquestInLst);
	  getCalloutAsync(JSON.serialize(OrquestInLst));
	  List<Output> lAllMessage = new List<Output>();
	  lAllMessage.add(new Output());
	  lAllMessage[0].allMessage = ':'; //response ':' to notice to lwcchatpack to find the response in the DB.
	  return lAllMessage;
	}
  
	@future(Callout = true)
	public static void getCalloutAsync(String JSONOrquestInLst){
	  List<Input> OrquestInLst = (List<Input>)System.JSON.deserialize(JSONOrquestInLst, List<Input>.class);
	  List<Output> responseLst = getCallout(OrquestInLst, '1', '');
	}
	//new
	// @future(Callout = true)
	// public static void getCalloutOfEndChatAsync(String JSONOrquestInLst){
	// 	List<Input> OrquestInLst = (List<Input>)System.JSON.deserialize(JSONOrquestInLst, List<Input>.class);
	// 	List<Output> responseLst = getCallout(OrquestInLst, '3', '');
	// 	System.debug(responseLst);
	// }
	//---
	/*---------------------------------------------------------------------------------------------
	 Autor: Javier Tibamoza (JATC)
	 Descripción: Generic Method to Call from Einstein or WS Response Frames
	 @params: List<Input> ; sOpc :: 1 -> Call from Einstein or 2 -> Call from WS Response Frames ; sResponseFrames :: JSON response frames
	 @return:
		Modifications Log
	  Ver   Date         Author                      Modification
	 1.1   07-01-2022   Julian Dario Velasco      Se identifica la cola por la cual se esta ingresando,
							 esto por medio de etiquetas personalizadas las cuales 
							tienen el valor asociado al ingreso de cada cola (Masivos/Mipymes)
							  y son comparadas con el valor que se obtiene desde el orquestador.
	 ----------------------------------------------------------------------------------------------*/
	public static List<Output> getCallout(List<Input> OrquestInLst, String sOpc, String sResponseFrames){
	  System.debug('##OrquestInLst  ' + OrquestInLst[0]);
	  System.debug('##OrquestInLst conversationId ' + OrquestInLst[0].conversationId);
	  DEG_RequestManagement_cls request = new DEG_RequestManagement_cls();
	  Map<string, string> mapHeaders = new Map<string, string>();
	  DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage = new DEG_WrapperJSONBot_cls.responseMessage();
	  DEG_WrapperJSONBot_cls.context contexto = new DEG_WrapperJSONBot_cls.context();
	  DEG_WrapperJSONBot_cls.enviroment enviroment = new DEG_WrapperJSONBot_cls.enviroment();
	  List<Output> lAllMessage = new List<Output>();
	  Output oAllMessage = new Output();
	  String tokenWatson = '';
	  DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize objAnalize = new DEG_ConsumeOrquestadorHelperWhatsapp_cls.wrpAnalize();
	  String sAllMessage = '';
	  String sHumanFriendy = '';
	  String jsonS = '';
	  String cellNumber = '';
	  String mensaje = '';
	  String botonFrame = '';
	  List<String> botonesLst = new List<String>();
	  Boolean isNumber = false;
	  
	  List<MessagingSession> lstMessagingOutbound;
	  DEG_CanalBot__mdt mdtCanal = [SELECT DEG_NombreCanalBot__c, DEG_Sistema__c, DEG_CorrelationId__c, DEG_ClientSessionId__c
									FROM DEG_CanalBot__mdt
									WHERE DEG_NombreCanalBot__c = :OrquestInLst[0].canalBot
									LIMIT 1];
  
	   List<MessagingSession> lstMessagingOriginal = [SELECT DEG_ClientSessionWatsonId__c, DEG_SessionIdWatson__c, DEG_TokenWatson__c, DEG_MotivoAgente__c, 
				   DEG_MotivoContacto__c, DEG_ResponseiFrames__c, DEG_Event__c, CaseId,DEG_NombredelaCola__c,/*MessagingEndUser.Numero_de_telefono__c,*/ Owner.Name,
				   DEG_NumeroDocCliente__c, DEG_TipoDocCliente__c,
				  MessagingChannelId, MessagingEndUserId,DEG_LastResponse__c,DEG_LastResponseBefore__c,DEG_ComeInFrame__c, Case.CaseNumber
				  FROM MessagingSession
				  WHERE Id = :OrquestInLst[0].conversationId
				  LIMIT 1];
	  
	  System.debug('lista lstMessagingOriginal:: '+lstMessagingOriginal);
	  JSONGenerator gen = JSON.createGenerator(true);
	  gen.writeStartObject();
	  gen.writeStringField('sistema', mdtCanal.DEG_Sistema__c);
	  gen.writeStringField('correlation_id', mdtCanal.DEG_CorrelationId__c + OrquestInLst[0].conversationId);
	  cellNumber = getPhoneNumber(OrquestInLst[0].conversationId);
	  gen.writeStringField('client_session_id', mdtCanal.DEG_ClientSessionId__c + cellNumber);
	  isNumber = OrquestInLst[0].textClient.isNumeric() && OrquestInLst[0].textClient.length() < 3 ? true : false;
	  lstMessagingOriginal[0].DEG_ComeInFrame__c = isNumber;
  
	  //CallOut Watson desde Einstein
	  if (sOpc == '1'){
		gen.writeObjectField('context', contexto);
		if (isNumber){//cuando llega número desde DEG_ConsumeOrquestadorAsyncWhatsApp_ws por que no encuentra nada en buttonsMaps
		  System.debug('##Es Número '+ OrquestInLst[0].textClient);
		  Integer i = 1;
		  Map<Integer, String> buttonMap = new Map<Integer, String>();
		  System.debug('##lstMessagingOriginal[0].DEG_ResponseiFrames__c '+lstMessagingOriginal[0].DEG_ResponseiFrames__c);
		  if (lstMessagingOriginal[0].DEG_ResponseiFrames__c != null && lstMessagingOriginal[0].DEG_ResponseiFrames__c != '' && lstMessagingOriginal[0].DEG_ResponseiFrames__c.contains(',')){
			for (String opcionBtn : lstMessagingOriginal[0].DEG_ResponseiFrames__c.split(',')){
			  opcionBtn = opcionBtn.replaceAll('[()]', '');
			  buttonMap.put(i,opcionBtn);
			  i++;
			}
			gen.writeStringField('text', (buttonMap.get(Integer.valueOf(OrquestInLst[0].textClient))).trim());
			lstMessagingOriginal[0].DEG_ResponseiFrames__c = null;
		  } else if(lstMessagingOriginal[0].DEG_ResponseiFrames__c != null && lstMessagingOriginal[0].DEG_ResponseiFrames__c != '') {
			gen.writeStringField('text', (lstMessagingOriginal[0].DEG_ResponseiFrames__c).replaceAll('[()]', '').trim());
			lstMessagingOriginal[0].DEG_ResponseiFrames__c = null;
		  }
		  else {//25/06 Harry
  
			lstMessagingOutbound = [SELECT Id, DEG_SessionIdWatson__c,DEG_ResponseiFrames__c,DEG_LastResponse__c,DEG_LastResponseBefore__c,DEG_ClientSessionWatsonId__c,
					MessagingChannelId, MessagingEndUserId,DEG_ComeInFrame__c
					FROM MessagingSession
					WHERE DEG_SessionIdWatson__c =: OrquestInLst[0].sessionId AND Id !=: OrquestInLst[0].conversationId
					ORDER BY CreatedDate DESC NULLS FIRST 
					LIMIT 1];
					
			if(!lstMessagingOutbound.isEmpty()){
			  System.debug('##lstMessagingOutbound[0] '+lstMessagingOutbound[0]);
			  if (lstMessagingOutbound[0].DEG_ResponseiFrames__c != null && lstMessagingOutbound[0].DEG_ResponseiFrames__c != '' && lstMessagingOutbound[0].DEG_ResponseiFrames__c.contains(','))
			  {
				for (String opcionBtn : lstMessagingOutbound[0].DEG_ResponseiFrames__c.split(',')){
				  opcionBtn = opcionBtn.replaceAll('[()]', '');
				  buttonMap.put(i,opcionBtn);
				  i++;
				}
				gen.writeStringField('text', (buttonMap.get(Integer.valueOf(OrquestInLst[0].textClient))).trim());
			  } else if(lstMessagingOutbound[0].DEG_ResponseiFrames__c != null && lstMessagingOutbound[0].DEG_ResponseiFrames__c != '') {
				gen.writeStringField('text', (lstMessagingOutbound[0].DEG_ResponseiFrames__c).replaceAll('[()]', '').trim());
			  } else {
				gen.writeStringField('text', OrquestInLst[0].textClient);
			  }
			  lstMessagingOriginal[0].DEG_ResponseiFrames__c = lstMessagingOutbound[0].DEG_ResponseiFrames__c;  
			} else {
			  gen.writeStringField('text', OrquestInLst[0].textClient);
			}
		  }
		} else{
		  //opcion cuando es texto directo del cliente
		  System.debug('##No es Número '+ OrquestInLst[0].textClient);
		  gen.writeStringField('text', OrquestInLst[0].textClient);
		}

		// Enviroment wrapper with casenumber included
		enviroment.case_number = lstMessagingOriginal[0].Case.CaseNumber;
		gen.writeObjectField('enviroment', enviroment);
	  }
	  //CallOut Watson desde WS Respuesta Frames
      if (sOpc == '2'){
			System.debug('##sResponseFrames out: ' + sResponseFrames);
			Object respoFrameObj = (Object)JSON.deserializeUntyped(sResponseFrames);
			gen.writeObjectField('context', respoFrameObj);
			gen.writeStringField('text', '');
	  }
	  //Callout at the end of a conversation
	//   if (sOpc == '3'){
    //  	gen.writeObjectField('context', contexto);
	// 	gen.writeStringField('text', OrquestInLst[0].textClient);
	// 	// Enviroment wrapper with elements for the survey
	// 	enviroment.case_number = lstMessagingOriginal[0].Case.CaseNumber;
	// 	enviroment.canal = OrquestInLst[0].canalBot;
	// 	enviroment.agente = lstMessagingOriginal[0].Owner.Name;
	// 	enviroment.motivo_contacto  = lstMessagingOriginal[0].DEG_MotivoContacto__c;
	// 	enviroment.numero_whatsapp  = lstMessagingOriginal[0].MessagingEndUser.Numero_de_telefono__c;
	// 	enviroment.tipo_documento =  lstMessagingOriginal[0].DEG_TipoDocCliente__c;
	// 	enviroment.numero_documento = lstMessagingOriginal[0].DEG_NumeroDocCliente__c;
	// 	gen.writeObjectField('enviroment', enviroment);
	//   }
	  gen.writeStringField('watson_session_id', OrquestInLst[0].sessionId);
	  gen.writeEndObject();
	  jsonS = gen.getAsString();
	  System.debug('##jsonMaterials' + jsonS);

	  mapHeaders.put('Content-Type', 'application/json');
  
	  if (Cache.Org.contains('tokenWatson')){
		tokenWatson = (String)Cache.Org.get('tokenWatson');
	  } else{
		tokenWatson = DEG_GetTokenWatson_ws.callTokenWatson();
	  }
	  mapHeaders.put('token', tokenWatson);
  
	  request.setHttpHeaders(mapHeaders);
	  request.setNamedCredential('DEG_Bot_Transfer');
	  request.setUri('DEG_MessageRequest');
	  request.setTextRequest(jsonS);
	  request.init();
	  request.setTimeOut(120000);
	  try{
		DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo wspAppInfo = new DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo();
		HttpResponse response = request.execute();
		System.debug('##response' + response);
		//repuesta de watson
		String rptBody = response.getBody();
		System.debug('##rptBody' + rptBody);
		rptBody = rptBody.replaceAll('time', 'tiempo');
		if (response.getStatusCode() == 200 || response.getStatusCode() == 202){
		  bodyRptaMessage = getDeserializeBody(rptBody, bodyRptaMessage);
		  objAnalize = DEG_ConsumeOrquestadorHelperWhatsapp_cls.manageDeserealizeBody(bodyRptaMessage, OrquestInLst[0].sessionId, tokenWatson, OrquestInLst[0].conversationId);
		  sHumanFriendy = objAnalize.strHumanFriendly;
		  sAllMessage = objAnalize.strJson;
		  if (sOpc == '2'){
			 //test for not showing rpta when aswer watsn frames
			sAllMessage = '';
			//try get message for frame
			for (DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapMensaje wrapMensaje : objAnalize.messageLst){
			  //buscar logica en lwc para los otros casos!
			  if (wrapMensaje.esMsn != null && wrapMensaje.esMsn){
				mensaje = (mensaje != '' ? mensaje + '\n \n' : '')+wrapMensaje.mensaje;
			  }
			  if (wrapMensaje.esBtn != null && wrapMensaje.esBtn){
				Integer i = 1;
				for (DEG_ConsumeOrquestadorHelperWhatsapp_cls.WrapBoton wrapBoton : wrapMensaje.lBotones){
				  botonFrame = DEG_ConsumeOrquestadorDBWhatsApp_cls.normalizeText(wrapBoton.texto);
				  botonesLst.add(botonFrame);
				  wspAppInfo.buttonsMap.put(i + '', botonFrame);
				  mensaje = mensaje + '\n' + i + '- ' + wrapBoton.texto;
				  i++;
				}
			  }
			}
		  }
		  System.debug('##sAllMessage' + sAllMessage);
		} else if (response.getStatusCode() == 403){
		  DEG_GetTokenWatson_ws.callTokenWatson();
		  return getCallout(OrquestInLst, sOpc, sResponseFrames);
		} else{
		  sAllMessage = 'Error: ' + response.getBody();
		}
		if ( !(objAnalize.motivoContacto ==null || objAnalize.motivoContacto =='')){
			lstMessagingOriginal[0].DEG_MotivoContacto__c = objAnalize.motivoContacto;
		}
		System.debug('##lstMessagingOriginal ' + lstMessagingOriginal);
		if (lstMessagingOriginal.Size() > 0){
		  // lstMessagingOriginal[0].DEG_ComeInFrame__c = false;
		  if (sOpc == '2'){
			//Indicate that messagingSession ComeInFrame 24/06
			lstMessagingOriginal[0].DEG_ComeInFrame__c = true;
			String templateRpta = 'DEG_RespuestaiFrame1';
			List<MessagingChannel> messagingChannelLst = [SELECT DeveloperName
									FROM MessagingChannel
									WHERE Id = :lstMessagingOriginal[0].MessagingChannelId
									LIMIT 1];
			System.debug('##messagingChannelLst ' + messagingChannelLst);
	
			Contact contacto = new Contact();
			contacto.FirstName = 'Contacto Frame';
			contacto.LastName = 'Frame LastName';//lstMessagingOriginal[0].DEG_SessionIdWatson__c;
			contacto.DEG_SessionIdWatson__c = lstMessagingOriginal[0].DEG_SessionIdWatson__c;
			contacto.DEG_ResponseFrame__c = mensaje;
			contacto.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'DEG_OutboundMessage'].Id;
			contacto.AccountId = [SELECT Id FROM Account WHERE Name =: system.label.DEG_NombreCuentaOutbound].Id;
			insert contacto;
			System.debug('##contacto ' + contacto);
			//Variables that are setting in the flow
			Map<String, Object> variablesFlowMap = new Map<String, Object>();
			variablesFlowMap.put('DEG_ChannelWhatsApp', messagingChannelLst[0].DeveloperName);
			variablesFlowMap.put('DEG_Template', templateRpta);
			variablesFlowMap.put('DEG_MessagingUserId', lstMessagingOriginal[0].MessagingEndUserId);
			if (contacto.Id != null){
			  variablesFlowMap.put('DEG_ContextId', contacto.Id);
			}
			//Instantiating and launching the flow with the parameters
			Flow.Interview.DEG_SendMessageOutbound myFlowOutbound = new Flow.Interview.DEG_SendMessageOutbound(variablesFlowMap);
			myFlowOutbound.start();
			if (contacto.Id != null) Delete contacto;
		  }
		  if (objAnalize.isFueradeHorario){
            lstMessagingOriginal[0].DEG_IsFueraHorario__c = true;
          }
		  lstMessagingOriginal[0].DEG_ClientSessionWatsonId__c = mdtCanal.DEG_ClientSessionId__c + cellNumber;
		  lstMessagingOriginal[0].DEG_SessionIdWatson__c = OrquestInLst[0].sessionId;
		  lstMessagingOriginal[0].DEG_LastResponse__c = sAllMessage;
		  lstMessagingOriginal[0].DEG_LastResponseBefore__c = sAllMessage;
		  lstMessagingOriginal[0].DEG_TransferToAgent__c = objAnalize.pasoAgente;
		  lstMessagingOriginal[0].DEG_Event__c = objAnalize.evento;
		  if (!botonesLst.isEmpty())
			lstMessagingOriginal[0].DEG_ResponseiFrames__c = botonesLst.toString();
		  if (lstMessagingOriginal[0].DEG_TransferToAgent__c){
			if (objAnalize.palabraClaveMotivoAgente != ''){
				System.debug('objAnalize.palabraClaveMotivoAgente:: '+objAnalize.palabraClaveMotivoAgente);
				lstMessagingOriginal[0].DEG_MotivoAgente__c = objAnalize.palabraClaveMotivoAgente;
				wspAppInfo.reasonAgent = objAnalize.motivo;
				System.debug('wspAppInfo.reasonAgent:: '+wspAppInfo.reasonAgent);
			} else{
				lstMessagingOriginal[0].DEG_MotivoAgente__c = objAnalize.motivo;
			}
			List<String> stRegionales = label.DEG_Hogares_Regionales.split(',');
			String regMeta = stRegionales.get(0);
			String regCucuta = stRegionales.get(1);
			if(objAnalize.motivo == system.label.DEG_Hogares_Retenciones){
			  lstMessagingOriginal[0].DEG_NombredelaCola__c ='Retención Masivos';
			}else if(objAnalize.motivo == system.label.DEG_Hogares_Soporte_Tecnico){
			  lstMessagingOriginal[0].DEG_NombredelaCola__c ='Soporte Técnico Masivos';
			}else if(objAnalize.motivo == system.label.DEG_Mipymes_PQRs){
			  lstMessagingOriginal[0].DEG_NombredelaCola__c ='PQRs Mipymes';
			}else if(objAnalize.motivo == system.label.DEG_Mipymes_Retenciones){
			  lstMessagingOriginal[0].DEG_NombredelaCola__c ='Retención Mipymes';
			}else if(objAnalize.motivo == system.label.DEG_Mipymes_Soporte_Tecnico){
			  lstMessagingOriginal[0].DEG_NombredelaCola__c ='Soporte Técnico Mipymes';
			}else if(objAnalize.motivo == system.label.DEG_Empresas_Servicio_al_Cliente){
				lstMessagingOriginal[0].DEG_NombredelaCola__c ='Servicio al Cliente Empresas';
			}else if(objAnalize.motivo == regMeta || objAnalize.motivo == regCucuta) {
				lstMessagingOriginal[0].DEG_NombredelaCola__c ='Regionales';
			}else if(objAnalize.motivo != NULL || objAnalize.motivo != ''){
				lstMessagingOriginal[0].DEG_NombredelaCola__c ='Servicio al Cliente';
			}
		  }
		  system.debug('objAnalize------->------> '+objAnalize);
		  
		  system.debug('##lstMessagingOriginal '+lstMessagingOriginal);
  
		  update lstMessagingOriginal;
		  system.debug('##msgSessionLstFAFTER '+lstMessagingOriginal);
		  system.debug('##msgSessionLstFAFTER Outbound'+lstMessagingOutbound);
		  //elimina outboun messageluego de enviarlos al original
		  if(lstMessagingOutbound != null && !lstMessagingOutbound.isEmpty()) delete lstMessagingOutbound;
  
		}
	  } 
	  catch (Exception e){
		System.debug('Error Message: ' + e.getMessage());
		System.debug('Error Line: ' + e.getLineNumber());
		sAllMessage = 'Error: ' + e.getMessage();
		objAnalize.pasoAgente = true;
	  }
	  oAllMessage.allMessage = sAllMessage;
	  lAllMessage.add(oAllMessage);
	  return lAllMessage;
	}
	
	/*---------------------------------------------------------------------------------------------
	 Autor:Harlinsson Chavarro (HCH)
	 Descripción: Method is for deserialize answer of rest service watson
	 @params: String rptBody : body answer of watson
	 DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage : class for save the answer deserializa of watson
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static DEG_WrapperJSONBot_cls.responseMessage getDeserializeBody(String rptBody, DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage){
	  rptBody = rptBody.replaceAll('Date', 'fecha');
	  rptBody = rptBody.replaceAll('\r\n|\n|\r', ' ');
	  // rptBody = rptBody.replaceAll('\"INFOUSUARIO_', 'INFOUSUARIO_');
	  System.debug('Body Respuesta -->' + rptBody);
	  bodyRptaMessage = (DEG_WrapperJSONBot_cls.responseMessage)JSON.deserialize(rptBody, DEG_WrapperJSONBot_cls.responseMessage.class);
	  return bodyRptaMessage;
	}
	/*---------------------------------------------------------------------------------------------
	 Autor:Harlinsson Chavarro (HCH)
	 Descripción: Method is for getting phoneNumber
	 @params: String rptBody : body answer of watson
	 DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage : class for save the answer deserializa of watson
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	public static String getPhoneNumber(String conversationId){
	  String cellNumber = [SELECT MessagingEndUser.Name
						   FROM MessagingSession
						   WHERE Id = :conversationId].MessagingEndUser.Name; //MessagingEndUser.Name  whatsapp:+573125127626
  
	  cellNumber = cellNumber.replace('+56', '+573'); //para pruebas desde chile
	  cellNumber = cellNumber.replace('+598', '+57'); //para pruebas desde chile
	  cellNumber = cellNumber.substringAfter('+');
	  System.debug('##cellNumber ' + cellNumber);
	  return cellNumber;
	}
  }