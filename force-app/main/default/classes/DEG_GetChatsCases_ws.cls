/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 07-07-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log
 * Ver   Date         Author                                   Modification
 * 1.0   05-19-2021   Harlinsson Chavarro (HCH)               Initial Version
 * 1.1   28-05-2021   Edgar Miranda Francisco (EMF)           Ultra Pro Version
 * 1.1   29-06-2021   Harlinsson Chavarro (HCH)               Better performance for getting records
 **/
@RestResource(urlMapping = 
'/ChatsOperations/*')
global without sharing class DEG_GetChatsCases_ws{
	/**
	 * @definition: get all records (MessagingSession and LiveChatTrascript) created between two datetime
	 * @Param: 
	 */
	@HttpGet
	global static responseService getChats(){

		List<AggregateResult> listaAggregateResult;
		List<String> statusChatLst = new List<String>{'Missed', 'Completed'};
		responseService response = new responseService();
		Integer limitRecords = 1000;
		RestRequest request = RestContext.request;
		Boolean limitRequest = false;
		Map<String, String> paramsMap = new Map<String, String>();

		if (test.isRunningTest()){
			paramsMap.put('date1', '01-01-2021 12:00:00');
			paramsMap.put('date2', '01-01-2031 12:00:00');
		} else{
			paramsMap = request.params;
		}

		try{
			System.debug('##paramsMap: ' + paramsMap);
			Integer countRecords;
			String myDate = paramsMap.get('date1');
			String stringDate = myDate.substring(6, 10)+'-' + myDate.substring(3, 5)+'-' + myDate.substring(0, 2)+' ' + myDate.substring(11, 19);
			DateTime dt = datetime.valueOf(stringDate);
			System.debug('date1: ' + String.valueOf(dt));
			String myDate2 = paramsMap.get('date2');
			String stringDate2 = myDate2.substring(6, 10)+'-' + myDate2.substring(3, 5)+'-' + myDate2.substring(0, 2)+' ' + myDate2.substring(11, 19);
			DateTime dt2 = datetime.valueOf(stringDate2);
			System.debug('date2: ' + String.valueOf(dt2));

			List<LiveChatTranscript> chat = [SELECT Id, Name, CreatedDate, LastModifiedDate, Body, CaseId, AccountId, LiveChatDeploymentId, LiveChatButtonId, SkillId,
                                             IpAddress, Location, UserAgent, Browser, Platform, BrowserLanguage, ScreenResolution, ReferrerUri, Status, RequestTime, StartTime, EndTime, EndedBy, AverageResponseTimeVisitor, AverageResponseTimeOperator, OperatorMessageCount, VisitorMessageCount, MaxResponseTimeOperator, ChatKey, SupervisorTranscriptBody, MaxResponseTimeVisitor, VisitorNetwork, ChatDuration, WaitTime, Abandoned, IsChatbotSession, DEG_CanalBot__c, DEG_NombreCliente__c, DEG_ApellidoCliente__c, DEG_TipoDocCliente__c, DEG_NumeroDocCliente__c, DEG_EmailCliente__c, DEG_AsuntoCaso__c, DEG_TelefonoCliente__c, DEG_AceptaenvioConversacionporCorreo__c, DEG_AceptaTerminosCondiciones__c, DEG_SentToIntegration__c, DEG_MotivoAgente__c, DEG_CategoriaCliente__c, DEG_UEN__c, DEG_SegmentoUEN__c, DEG_Segmento__c, DEG_SessionIdWatson__c, DEG_ClientSessionWatsonId__c, DEG_ManageBody__c, DEG_TransferToAgent__c, DEG_ChatResponseNumber__c, DEG_Event__c, Owner.Profile.Name, Owner.Name, Owner.UserRole.Name, Case.CaseNumber, Case.SourceId, Case.CodigouniconumericoCUN__c, Case.SuppliedEmail, Case.SuppliedPhone, Case.Type, Case.RecordTypeId, Case.Status, Case.Reason, Case.Origin, Case.Subject, Case.Priority, Case.Description, Case.IsClosed, Case.ClosedDate, Case.IsEscalated, Case.OwnerId, Case.IsClosedOnCreate, Case.CreatedDate, Case.CreatedById, Case.LastModifiedDate, Case.ContactPhone, Case.ContactMobile, Case.ContactEmail, Case.Comments, Case.DEG_Segmento__c, Case.DEG_Tecnologia__c, Case.DEG_ValorCliente__c, Case.DEG_Categoria__c, Case.DEG_Sub_Categoria__c, Case.DEG_AceptaenvioConversacionCorreo__c, Case.DEG_AutorizaTratamientoDatosPersonales__c, Case.DEG_Nombre__c, Case.DEG_Apellido__c, Case.DEG_TipodeDocumento__c, Case.DEG_NumerodeIdentificacion__c, Case.DEG_Celular__c, Case.DEG_Producto__c, Case.DEG_Proceso__c, Case.DEG_GestionadoPor__c, Case.DEG_SentToIntegration__c, Case.Owner.Profile.Name, Case.Owner.Name, Case.Owner.UserRole.Name
			                                 FROM LiveChatTranscript
			                                 WHERE CreatedDate >= :dt AND CreatedDate <= :dt2 and DEG_SentToIntegration__c = false AND Status IN :statusChatLst
			                                 LIMIT :limitRecords];


			Map<Id, MessagingSession> msgMap = new Map<Id, MessagingSession>();
			for (MessagingSession msj : [SELECT Id, Name, CreatedDate, CreatedById, LastModifiedDate, MessagingChannelId, MessagingEndUserId, Status, CaseId, AcceptTime,
                                         StartTime, EndTime, Origin, AgentType, SessionKey, TargetUserId, ChannelGroup, ChannelIntent, ChannelLocale, EndUserAccountId, EndUserContactId, ChannelType, ChannelName, ChannelKey, PreviewDetails, ChannelEndUserFormula, EndUserMessageCount, AgentMessageCount, DEG_Segmento__c, DEG_SegmentoUEN__c, DEG_UEN__c, DEG_CategoriaCliente__c, DEG_ClientSessionWatsonId__c, DEG_SessionIdWatson__c, DEG_AceptaTerminosCondiciones__c, DEG_TelefonoCliente__c, DEG_NombreCliente__c, DEG_EmailCliente__c, DEG_ApellidoCliente__c, DEG_TipoDocCliente__c, DEG_NumeroDocCliente__c, DEG_TokenWatson__c, DEG_TransferToAgent__c, DEG_Event__c, DEG_MotivoAgente__c, DEG_SentToIntegration__c, Owner.Profile.Name, Owner.Name, Owner.UserRole.Name, DEG_Body__c,Case.CaseNumber, Case.SourceId, Case.CodigouniconumericoCUN__c, Case.SuppliedEmail, Case.SuppliedPhone, Case.Type, Case.RecordTypeId, Case.Status, Case.Reason, Case.Origin, Case.Subject, Case.Priority, Case.Description, Case.IsClosed, Case.ClosedDate, Case.IsEscalated, Case.OwnerId, Case.IsClosedOnCreate, Case.CreatedDate, Case.CreatedById, Case.LastModifiedDate, Case.ContactPhone, Case.ContactMobile, Case.ContactEmail, Case.Comments, Case.DEG_Segmento__c, Case.DEG_Tecnologia__c, Case.DEG_ValorCliente__c, Case.DEG_Categoria__c, Case.DEG_Sub_Categoria__c, Case.DEG_AceptaenvioConversacionCorreo__c, Case.DEG_AutorizaTratamientoDatosPersonales__c, Case.DEG_Nombre__c, Case.DEG_Apellido__c, Case.DEG_TipodeDocumento__c, Case.DEG_NumerodeIdentificacion__c, Case.DEG_Celular__c, Case.DEG_Producto__c, Case.DEG_Proceso__c, Case.DEG_GestionadoPor__c, Case.DEG_SentToIntegration__c, Case.Owner.Profile.Name, Case.Owner.Name, Case.Owner.UserRole.Name
			                             FROM MessagingSession
			                             WHERE CreatedDate >= :dt AND CreatedDate <= :dt2 and DEG_SentToIntegration__c = false AND Status = 'Ended'
			                             LIMIT :limitRecords])
            {
				msj.DEG_Body__c = '';
				msgMap.put(msj.Id, msj);
			}
			for (ConversationEntry conversMsj : [SELECT ConversationId, Message
			                                     FROM ConversationEntry
			                                     WHERE ConversationId IN :msgMap.keySet()
			                                     ORDER BY CreatedDate ASC]){
				if (msgMap.containsKey(conversMsj.ConversationId)){
					if (conversMsj.Message != ' ' && conversMsj.Message != null && conversMsj.Message != 'null'){
						msgMap.get(conversMsj.ConversationId).DEG_Body__c = msgMap.get(conversMsj.ConversationId).DEG_Body__c + ' <br> ' + conversMsj.Message; //+ ' <br> ';
					}
				}
			}

			limitRequest = chat.size() >= limitRecords || msgMap.size() >= limitRecords ? true : false;
			response.statusCode = 200;
			response.message = 'OK';
			System.debug('chat.size() ' + chat.size());
			System.debug('msgMap.size() ' + msgMap.size());
			response.lstTranscript = chat;
			response.lstMessaging = msgMap.values();
			response.blPendingRecords = limitRequest;
			return response;
		} catch (Exception ex){
            System.debug('Error: '+ex.getMessage());
            System.debug('Error Line: '+ex.getLineNumber());
			response.statusCode = 500;
			response.message = ex.getMessage();
			return response;
		}
	}

    /**
	 * @definition: update record where all these already were getting in getchats (see above)
	 * @Param: 
	 */
	@HttpPost
	global static responseBase sentToIntegration(List<String> ids){

		Map<id, LiveChatTranscript> mpTranscript = new Map<id, LiveChatTranscript>();
		Map<id, MessagingSession> mpMessaging = new Map<id, MessagingSession>();
		Map<id, Case> mpCase = new Map<id, Case>();
		responseBase response = new responseBase();
		id sId;
		String oTypeName;
		Set<String> chatIdSet = new Set<String>();
		Set<String> messagingIdSet = new Set<String>();
		Set<String> caseIdSet = new Set<String>();
		try{

			for (String id : ids){
				sId = id;
				oTypeName = sId.getSObjectType().getDescribe().getName();
				if (oTypeName == 'LiveChatTranscript'){
					chatIdSet.add(id);
				}
				if (oTypeName == 'MessagingSession'){
					messagingIdSet.add(id);	
				}
				if (oTypeName == 'Case'){
					caseIdSet.add(id);	
				}
			}
	
			for (LiveChatTranscript chat : [SELECT DEG_SentToIntegration__c
			                                FROM LiveChatTranscript
			                                WHERE Id IN :chatIdSet AND DEG_SentToIntegration__c = false])
      {
        mpTranscript.put(chat.Id, new LiveChatTranscript(Id = chat.Id, DEG_SentToIntegration__c = true));

			}
			for (MessagingSession messaging : [SELECT DEG_SentToIntegration__c
			                                  FROM MessagingSession
			                                  WHERE Id IN :messagingIdSet AND DEG_SentToIntegration__c = false])
      {
				mpMessaging.put(messaging.Id, new MessagingSession(Id = messaging.Id, DEG_SentToIntegration__c = true));
			}
			for (Case caso : [SELECT DEG_SentToIntegration__c
			                  FROM Case
			                  WHERE Id IN :caseIdSet AND DEG_SentToIntegration__c = false])
      {
				mpCase.put(caso.Id, new Case(Id = caso.Id, DEG_SentToIntegration__c = true));
			}

			System.debug('##mpTranscript.values() ' + mpTranscript.values());
			update mpTranscript.values();
			update mpMessaging.values();
			update mpCase.values();
			response.statusCode = 200;
			response.message = 'OK';
			return response;
		} catch (Exception ex){
			response.statusCode = ex.getLineNumber();
			response.message = ex.getMessage();
			return response;
		}
	}

	global virtual class responseBase{
		global Integer statusCode;
		global String message;
	}

	global class responseService extends responseBase{
		global Boolean blPendingRecords = false;
		global list<LiveChatTranscript> lstTranscript;
		global list<MessagingSession> lstMessaging;

		global responseService(){
			this.message = '';
			this.statusCode = 0;
			this.blPendingRecords = false;
		}

		global responseService(String strMsn, Integer intCode, list<LiveChatTranscript> lst_Transcript, list<MessagingSession> lst_Messaging){
			this.message = strMsn;
			this.statusCode = intCode;
			this.lstTranscript = lst_Transcript;
			this.lstMessaging = lst_Messaging;
		}
	}
}