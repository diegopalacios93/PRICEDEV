/**
 * @description       : Clase de Web Service para consumir el Orquestador de Watson
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : ETB
 * @last modified on  : 05-24-2022
 * @last modified by  : j.martinez.mercado@accenture.com
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   01-08-2021   Harlinsson Chavarro (HCH)         Initial Version
 * 2.0   05-04-2021   Rodrigo de la Castilleja (RDC)    Async Version
 * 3.0   22-02-2022   Brisleydi Calderon                Corrección campo MotivoContacto
 * 4.0   27-04-2022	  Alejandro Peña T					Mejora Encuestas Bot                 
 **/
global without sharing class DEG_ConsumeOrquestadorAsync_ws{

	public class Output{
		@InvocableVariable(required = true)
		public String allMessage = '';
	}
	public class Input{
		@InvocableVariable(required = true)
		public String sessionId;
		@InvocableVariable(required = false)
		public String textClient;
		@InvocableVariable(required = true)
		public String conversationId;
		@InvocableVariable(required = true)
		public String canalBot;
		@InvocableVariable(required = false)
		public String isEmpresas = 'false';
	}
	/*---------------------------------------------------------------------------------------------
	 Autor: Javier Tibamoza (JATC)
	 Descripción: Method is invoke since WS Frames Response for consuming rest service with IBM Watson
	 @params: List<Input> OrquestInLst ; sResponse :: JSON, response frames
	 @return: List<Output>
	 ----------------------------------------------------------------------------------------------*/
	public static void makeGetCallout(List<Input> OrquestInLst, String sResponse){
		makeGetCallout(JSON.serialize(OrquestInLst),sResponse);
	}
	@future(Callout = true)
	public static void makeGetCallout(String JSONOrquestInLst,String sResponse){
		System.debug('JSONOrquestInLst-->'+JSONOrquestInLst);
		List<Input> OrquestInLst = (List<Input>)System.JSON.deserialize(JSONOrquestInLst, List<Input>.class);
		System.debug('List OrquestInLst-->'+OrquestInLst);
		getCallout(OrquestInLst, '2', sResponse);
	}

	// @future(Callout = false)
    // public static void getCalloutOfEndChatAsync(String JSONOrquestInLst){
    //     List<Input> OrquestInLst = (List<Input>)System.JSON.deserialize(JSONOrquestInLst, List<Input>.class);
    //     List<Output> responseLst = getCallout(OrquestInLst, '3', '');
	// 	System.debug(responseLst);
    // }
	/*---------------------------------------------------------------------------------------------
	 Autor: Harlinsson Chavarro (HCH)
	 Descripción: Method is invoke since bot einstein for consuming rest service with IBM Watson
	 @params: List<Input> OrquestInLst: It is a list because bot understand so.
	 @return: -----
	 ----------------------------------------------------------------------------------------------*/
	@InvocableMethod(label = 'Get Integration Async')
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
        List<Output>  responseLst= getCallout(OrquestInLst,'1', '');
    }
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
		DEG_ConsumeOrquestadorHelper_cls.wrpAnalize objAnalize = new DEG_ConsumeOrquestadorHelper_cls.wrpAnalize();
		String sAllMessage = '';
		String sHumanFriendy = '';
		Object objetoContext;
		String jsonS = '';
		String cellNumber;
		DEG_CanalBot__mdt mdtCanal =  [SELECT DEG_NombreCanalBot__c, DEG_Sistema__c,DEG_CorrelationId__c,DEG_ClientSessionId__c
										FROM DEG_CanalBot__mdt
										WHERE DEG_NombreCanalBot__c = :OrquestInLst[0].canalBot
										LIMIT 1];

		List<LiveChatTranscript> caseTranscript = 	[SELECT CaseId, Case.CaseNumber
											FROM LiveChatTranscript
											WHERE Id =: OrquestInLst[0].conversationId //idC
											LIMIT 1];

		List<LiveChatTranscript> chatLst = 	[SELECT DEG_ClientSessionWatsonId__c, Owner.Name, DEG_SessionIdWatson__c,DEG_TokenWatson__c,DEG_ManageBody__c,DEG_ChatResponseNumber__c,DEG_MotivoAgente__c,DEG_MotivoContacto__c,
											DEG_Event__c,DEG_LastResponse__c,DEG_LastResponseHuman__c,DEG_TipoDocCliente__c,DEG_NumeroDocCliente__c,CaseId,DEG_NombredelaCola__c, Case.DEG_Celular__c
											FROM LiveChatTranscript
											WHERE Id =: OrquestInLst[0].conversationId //idC
											LIMIT 1];

		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeStringField('sistema', mdtCanal.DEG_Sistema__c);
		gen.writeStringField('correlation_id', mdtCanal.DEG_CorrelationId__c + OrquestInLst[0].conversationId);
		gen.writeStringField('client_session_id', mdtCanal.DEG_ClientSessionId__c + OrquestInLst[0].conversationId);
		//CallOut Watson desde Einstein
		if (sOpc == '1'){
			gen.writeObjectField('context', contexto);
			gen.writeStringField('text', OrquestInLst[0].textClient);

			// Enviroment wrapper with casenumber included
			enviroment.case_number = caseTranscript[0].Case.CaseNumber;
			gen.writeObjectField('enviroment', enviroment);
		}
		//CallOut Watson desde WS Respuesta Frames
		if (sOpc == '2'){
			System.debug('##sResponseFrames out: '+sResponseFrames);
			Object respoFrameObj = (Object)JSON.deserializeUntyped(sResponseFrames);
			System.debug('##respoFrameObjt'+respoFrameObj);
			gen.writeObjectField('context', respoFrameObj);
			gen.writeStringField('text', '');
		}
		//Callout at the end of a conversation
		// if (sOpc == '3'){
		// 	gen.writeObjectField('context', contexto);
		// 	gen.writeStringField('text', OrquestInLst[0].textClient);

		// 	// Enviroment wrapper with casenumber included
		// 	enviroment.case_number = caseTranscript[0].Case.CaseNumber;
		// 	enviroment.canal = OrquestInLst[0].canalBot;
		// 	enviroment.agente = chatLst[0].Owner.Name;
		// 	enviroment.motivo_contacto  = chatLst[0].DEG_MotivoContacto__c;
		// 	enviroment.numero_whatsapp  = chatLst[0].Case.DEG_Celular__c;
		// 	enviroment.tipo_documento =  chatLst[0].DEG_TipoDocCliente__c;
		// 	enviroment.numero_documento = chatLst[0].DEG_NumeroDocCliente__c;
		// 	gen.writeObjectField('enviroment', enviroment);
		// }
		gen.writeStringField('watson_session_id', OrquestInLst[0].sessionId);
		gen.writeEndObject();
		jsonS = gen.getAsString();
		System.debug('##jsonMaterials' + jsonS);

		mapHeaders.put('Content-Type', 'application/json');

		if (Cache.Org.contains('tokenWatson')) {
            tokenWatson = (String)Cache.Org.get('tokenWatson');
        }
        else {
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
			HttpResponse response = request.execute();
			System.debug('##response' + response);

			//repuesta de watson
			String rptBody = response.getBody();
			System.debug('##rptBody' + rptBody);
			if (response.getStatusCode() == 200 || response.getStatusCode() == 202 ){
				bodyRptaMessage = getDeserializeBody(rptBody, bodyRptaMessage);
				objAnalize = DEG_ConsumeOrquestadorHelper_cls.manageDeserealizeBody(bodyRptaMessage, OrquestInLst[0].sessionId,  tokenWatson, OrquestInLst[0].conversationId);
				sHumanFriendy = objAnalize.strHumanFriendly;
				sAllMessage = objAnalize.strJson;
				System.debug('##objAnalize' + objAnalize);
			}
			else if ( response.getStatusCode() == 403){
				System.debug('response:: '+response);
				DEG_GetTokenWatson_ws.callTokenWatson();
				return getCallout(OrquestInLst, sOpc, sResponseFrames);
			}

			else{
				sAllMessage = 'Error: ' + response.getBody();
				System.debug('##sAllMessage: ' + sAllMessage);

			}
		} catch (Exception e){
			System.debug('Error Message: ' + e.getMessage());
			System.debug('Error Line: ' + e.getLineNumber());
			sAllMessage = 'Error: ' + e.getMessage();
			objAnalize.pasoAgente = true;
		}
		System.debug('OrquestInLst[0].conversationId :"'+OrquestInLst[0].conversationId+'"');

		System.debug('## chatLst: ' + chatLst);
		if(chatLst.Size() > 0){
			System.debug('Entro ChatList');
			if (objAnalize.isFueradeHorario){
				chatLst[0].DEG_IsFueraHorario__c = true;
			}
			chatLst[0].DEG_ClientSessionWatsonId__c = mdtCanal.DEG_ClientSessionId__c + OrquestInLst[0].conversationId; //13-04-2021 actualizada, se estaba agregando un espacio de más OrquestInLst[0].conversationId;
			chatLst[0].DEG_SessionIdWatson__c = OrquestInLst[0].sessionId;
			chatLst[0].DEG_ManageBody__c = true;
			chatLst[0].DEG_TransferToAgent__c = objAnalize.pasoAgente;
			chatLst[0].DEG_ChatResponseNumber__c = ( chatLst[0].DEG_ChatResponseNumber__c == null ) ? 0 + 1 : chatLst[0].DEG_ChatResponseNumber__c + 1;
			chatLst[0].DEG_Event__c = objAnalize.evento;
			chatLst[0].DEG_LastResponse__c = sAllMessage;
			chatLst[0].DEG_LastResponseHuman__c = sHumanFriendy;
			//new
			// if(objAnalize.colaUsuario != ''){
			// 	chatLst[0].DEG_Cola_Mensajeria__c = objAnalize.colaUsuario;
			// }
            //--
			if(OrquestInLst[0].isEmpresas  != null && OrquestInLst[0].isEmpresas.equalsIgnoreCase('true')){
				String regex = '(?<=(CE|NIT|CC) sea el correcto )(.*)(?=\\?)';
				Pattern regexPattern = Pattern.compile(regex);
				Matcher regexMatcher = regexPattern.matcher(sAllMessage);
				if(regexMatcher.find()){
					String tipoDocCLiente = regexMatcher.group(1);
					String numeroDocCliente = regexMatcher.group(2);

					System.debug('## tipoDocCLiente:' + tipoDocCLiente);
					System.debug('## numeroDocCliente:' + numeroDocCliente);
					chatLst[0].DEG_TipoDocCliente__c = tipoDocCLiente;
					chatLst[0].DEG_NumeroDocCliente__c = numeroDocCliente;

					//SOSL
					/*List<Account> accLst = [SELECT Id, AccountNumber FROM Account WHERE AccountNumber  = :numeroDocCliente and Tipodedocumento__c = :tipoDocCLiente  LIMIT 1];
					if (!accLst.isEmpty()) {
						List<Case> caseLst = [SELECT AccountId FROM Case WHERE Id  =:chatLst[0].CaseId LIMIT 1];
						if (!caseLst.isEmpty()) {
							caseLst[0].AccountId = accLst[0].Id;
							update caseLst;
							System.debug('##caseLst[0]:' +caseLst[0]);
						}
					}*/
				}
			}
			if (!(objAnalize.motivoContacto == null || objAnalize.motivoContacto =='')){
				chatLst[0].DEG_MotivoContacto__c = objAnalize.motivoContacto;
			}
			if (chatLst[0].DEG_TransferToAgent__c){
				chatLst[0].DEG_MotivoAgente__c = objAnalize.motivo;

                if (objAnalize.palabraClaveMotivoAgente != ''){
					System.debug('objAnalize.palabraClaveMotivoAgente:: '+objAnalize.palabraClaveMotivoAgente);
					chatLst[0].DEG_MotivoAgente__c = objAnalize.palabraClaveMotivoAgente;
				} else{
					chatLst[0].DEG_MotivoAgente__c = objAnalize.motivo;
				}
				List<String> stRegionales = label.DEG_Hogares_Regionales.split(',');
				String regMeta = stRegionales.get(0);
				String regCucuta = stRegionales.get(1);
				if(objAnalize.motivo == system.label.DEG_Hogares_Retenciones){
					chatLst[0].DEG_NombredelaCola__c ='Retención Masivos';
				}else if(objAnalize.motivo == system.label.DEG_Hogares_Soporte_Tecnico){
					chatLst[0].DEG_NombredelaCola__c ='Soporte Técnico Masivos';
				}else if(objAnalize.motivo == system.label.DEG_Mipymes_PQRs){
					chatLst[0].DEG_NombredelaCola__c ='PQRs Mipymes';
				}else if(objAnalize.motivo == system.label.DEG_Mipymes_Retenciones){
					chatLst[0].DEG_NombredelaCola__c ='Retención Mipymes';
				}else if(objAnalize.motivo == system.label.DEG_Mipymes_Soporte_Tecnico){
					chatLst[0].DEG_NombredelaCola__c ='Soporte Técnico Mipymes';
				}else if(objAnalize.motivo == system.label.DEG_Empresas_Servicio_al_Cliente){
                    chatLst[0].DEG_NombredelaCola__c ='Servicio al Cliente Empresas';
                }else if(objAnalize.motivo == regMeta || objAnalize.motivo == regCucuta){
					chatLst[0].DEG_NombredelaCola__c ='Regionales';
				}else if(objAnalize.motivo != NULL || objAnalize.motivo != ''){
                  chatLst[0].DEG_NombredelaCola__c ='Servicio al Cliente';
              	}
			}
			system.debug('objAnalize------->------> '+objAnalize);

			update chatLst;

		}
		System.debug(chatLst);
		oAllMessage.allMessage = sAllMessage;
		system.debug('***getCpuTime() consume ***' + Limits.getCpuTime());
		System.debug('##oAllMessage: ' + oAllMessage);
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
		System.debug('Body Respuesta -->'+rptBody);
		bodyRptaMessage = (DEG_WrapperJSONBot_cls.responseMessage)JSON.deserialize(rptBody, DEG_WrapperJSONBot_cls.responseMessage.class);
		return bodyRptaMessage;
	}
}