/**
 * @description       : Clase de Web Service para consumir el Orquestador de Watson con el canal de WhatApp
 * @author            : Rodrigo de la Castilleja (RdC)
 * @group             : ETB
 * @last modified on  : 07-29-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-24-2021   Rodrigo de la Castilleja (RdC)   Initial Version
 * 1.1   01-11-2021   Accenture Ajuste caso Abondo   (JOL)
 * 1.2   25-11-2021   Accenture Ajuste Mipyme (JOL)
 * */
global class DEG_ConsumeOrquestadorAsyncWhatsApp_ws{
	global DEG_ConsumeOrquestadorAsyncWhatsApp_ws(){
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
		@InvocableVariable(required = true)
		public String whatsAppInfo;
	}
    public class Output{
		@InvocableVariable(required = true)
		public String allMessage = '';
		@InvocableVariable(required = true)
		public String whatsAppInfo = '';
	}
    @InvocableMethod(label = 'Get WhatsApps ASync')
	public static List<Output> makeGetCallout(List<Input> wspInputLst){
		System.debug('##DsyncWhatsApp.makeGetCallout wspInputLst: '+wspInputLst[0]);
		String resultado=casoAbandono(wspInputLst);
		wspInputLst[0].textClient=resultado;
		List<DEG_ConsumeOrquestadorAsyncWpp_ws.Output> outputLst=  DEG_ConsumeOrquestadorAsyncWpp_ws.makeGetCallout(wspToOrquest(wspInputLst));
        List<Output> wspOutLst = new List<Output>();
		wspOutLst.add(new Output());
		wspOutLst[0].allMessage = outputLst[0].allMessage;
		wspOutLst[0].whatsAppInfo = wspInputLst[0].whatsAppInfo ;
		System.debug('##return wspOutLst: '+wspOutLst[0]);
		System.debug(resultado);


		     return WspOutLst;
	}

	public static String casoAbandono (List<Input> wspInputLst) {
				Double rangoHora;
				String resultado;
          
			messagingSession objMessaging = [SELECT id,case.Status,DEG_HoraFinalizacionChat__c,MessagingEndUserId,DEG_SessionAbandonada__c,MessagingEndUser.MessagingPlatformKey 
                                     FROM  messagingSession WHERE id =: wspInputLst[0].conversationId  LIMIT 1];

			list <messagingSession> lsMessaging = [SELECT id,case.Status,DEG_HoraFinalizacionChat__c,MessagingEndUserId,DEG_SessionAbandonada__c
					FROM  messagingSession WHERE MessagingEndUser.MessagingPlatformKey =:objMessaging.MessagingEndUser.MessagingPlatformKey  and  id !=: wspInputLst[0].conversationId 
							and case.Status ='Abandono' and  DEG_HoraFinalizacionChat__c != null and DEG_SessionAbandonada__c = null order by CreatedDate desc LIMIT 1];

				if(!lsMessaging.isEmpty() && lsMessaging != null)
					{
						rangoHora = Math.Floor(((Double.valueOf(System.now().getTime()) - Double.valueOf(DateTime.valueOf(lsMessaging[0].DEG_HoraFinalizacionChat__c).getTime())) / (1000.0*60.0)) - 120);
									System.debug(System.now());
                        			System.debug(lsMessaging[0].DEG_HoraFinalizacionChat__c);
									System.debug(rangoHora);
									System.debug(System.now().getTime());
									System.debug(DateTime.valueOf(lsMessaging[0].DEG_HoraFinalizacionChat__c).getTime());

					}

				if (!lsMessaging.isEmpty() && lsMessaging != null  && rangoHora <= 120) 
				{
					messagingSession menordosHoras = new messagingSession(id=lsMessaging[0].id,DEG_SessionAbandonada__c='session_menor_2_horas_abandono');
					update menordosHoras;
					resultado='session_menor_2_horas_abandono'; 
					System.debug(resultado);
									
				}

				 if (!lsMessaging.isEmpty() && lsMessaging != null  && rangoHora > 120) 
				{
							
							messagingSession mayordosHoras = new messagingSession(id=lsMessaging[0].id,DEG_SessionAbandonada__c='session_mayor_2_horas_abandono');
							update mayordosHoras;
							resultado='session_mayor_2_horas_abandono';
							System.debug(resultado);
							
				}


		   list <messagingSession> lsMessagingRelacion = [SELECT id,case.Status,DEG_HoraFinalizacionChat__c,MessagingEndUserId,DEG_SessionAbandonada__c
				FROM  messagingSession WHERE MessagingEndUser.MessagingPlatformKey =:objMessaging.MessagingEndUser.MessagingPlatformKey  and  id !=: wspInputLst[0].conversationId 
						and case.Status ='Abandono' and  DEG_HoraFinalizacionChat__c != null  and DEG_SessionAbandonada__c='session_menor_2_horas_abandono' order by CreatedDate desc LIMIT 1];
				 
                System.debug(lsMessagingRelacion);
				System.debug(wspInputLst[0].textClient);

				if (!lsMessagingRelacion.isEmpty() && String.valueOf(lsMessagingRelacion[0].DEG_SessionAbandonada__c) == 'session_menor_2_horas_abandono' &&  wspInputLst[0].textClient =='Asesor' )
                         
				{ 
					Map<String,Object> variablesFlowMap = new Map<String,Object>();
					variablesFlowMap.put('ID_Caso', lsMessagingRelacion[0].MessagingEndUserId);
					Flow.Interview.CasosAbandono myFlowOutbound = new Flow.Interview.CasosAbandono(variablesFlowMap);
					myFlowOutbound.start();

				}

				
				if(lsMessaging.isEmpty()){
					
					resultado=wspInputLst[0].textClient;
				}

				return resultado;
			

	}

    /*---------------------------------------------------------------------------------------------
	 Autor: Rodrigo de la Castilleja (RdC)
	 Descripción: Method is invoked makeGetCallout to translaste the select option to a text in button list event
	 @params: List<OrquestWspInput> OrquestInLst
	 @return: List<DEG_ConsumeOquestador_ws.OrquestInput>
	 ----------------------------------------------------------------------------------------------*/	
	public static List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> wspToOrquest(List<Input> wspInputLst){
		List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input> inputLst = new List<DEG_ConsumeOrquestadorAsyncWpp_ws.Input>();
		
		inputLst.add( new DEG_ConsumeOrquestadorAsyncWpp_ws.Input());
		inputLst[0].sessionId = wspInputLst[0].sessionId;
		inputLst[0].textClient =  wspInputLst[0].textClient != null ? wspInputLst[0].textClient: '' ;
		inputLst[0].conversationId = wspInputLst[0].conversationId;
		inputLst[0].canalBot = wspInputLst[0].canalBot;
		System.debug('##wspToOrquest method: wspInputLst '+wspInputLst[0]);
		DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo wspAppInfo = new DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo();
		if(wspInputLst[0].whatsAppInfo != null && wspInputLst[0].whatsAppInfo != 'null'){
			wspAppInfo = (DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo)System.JSON.deserialize(wspInputLst[0].whatsAppInfo, DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo.class);
			//in case we have a button dictionary, translate the answer
			//System.debug('##respuestaCliente '+wspInputLst[0].textClient.trim());
			System.debug('##wspAppInfo '+wspAppInfo);
			System.debug('##wspAppInfo.buttonsMap '+wspAppInfo.buttonsMap);
			String respuestaCliente = wspInputLst[0].textClient.trim();
			if( wspAppInfo.buttonsMap != null && wspAppInfo.buttonsMap.containsKey(respuestaCliente)){
				inputLst[0].textClient = wspAppInfo.buttonsMap.get(respuestaCliente);
				System.debug('##inputLst buttonMap '+inputLst[0]);
			}
			if(wspAppInfo.state != null){
				String response = inputLst[0].textClient.trim();
				switch on wspAppInfo.state {
					when  'GetName' {
						wspAppInfo.name = response;
					}
					when  'GetLastName' {
						wspAppInfo.lastName = response;
					}
					when  'GetDoctype' {
						wspAppInfo.documentType = response;
					}
					when  'GetDocNumber' {
						wspAppInfo.documentNumber = response;
					}
					when  'GetEmail' {
						wspAppInfo.email = response;
					}
				}
			}
		}
		
		wspAppInfo.state = '';
		wspAppInfo.lastResponseDate = String.valueOf(DateTime.now().getTime());	
		wspInputLst[0].whatsAppInfo  =  JSON.serialize(wspAppInfo);
        system.debug('##return: '+inputLst[0]);
		return inputLst;
	}
		
    
}