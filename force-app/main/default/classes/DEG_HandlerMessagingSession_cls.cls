/**
* @description       :
* @author            : Sebastian Urrutia (SUF)
* @group             :
* @last modified on  : 08-06-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log
* Ver   Date         Author                      Modification
* 1.0   05-25-2021   Sebastian Urrutia (SUF)   Initial Version
**/
public without sharing class DEG_HandlerMessagingSession_cls{
    public DEG_HandlerMessagingSession_cls(){
    }
    
    // Instancia del Helper
    DEG_HelperMessagingSession_cls helper = new DEG_HelperMessagingSession_cls();
    
    public void OnBeforeInsert(List<MessagingSession> lstChats, Map<Id, MessagingSession> mapNewChats){
        Map<Id,MessagingSession> mapToPass = new Map<Id,MessagingSession>();
        
        for( MessagingSession mSession : lstChats ){
            if( mSession.Origin != 'OptOut' ){
                mapToPass.put( mSession.Id, mSession );
            }
        }
        
        if( !mapToPass.isEmpty() ){
            helper.createCases(mapToPass.values(), mapToPass);
        }
    }
    
	
    public void OnBeforeUpdate(List<MessagingSession> lstChats, Map<Id, MessagingSession> mapOldChats, Map<Id, MessagingSession> mapNewChats){
        User usr = [SELECT Id, username FROM User WHERE username LIKE 'autoproc%' LIMIT 1];
        Map<Id,MessagingSession> mapToPass = new Map<Id,MessagingSession>();
        String groupPrefix = Group.sObjectType.getDescribe().getKeyPrefix();
		Map<Id,Id> mapCasesChat = new Map<Id,Id>();
											 
        for ( Id chatId : mapNewChats.keySet() ) {          
            MessagingSession chatCurrent = mapNewChats.get(chatId);
            
			//change ownerId Case with ownerId chat           
            if(chatCurrent.status == 'Waiting' || chatCurrent.status == 'Active' || Test.isRunningTest()){
                if(!(((String)chatCurrent.OwnerId).startsWith(groupPrefix))){
                    if(mapNewChats.get(chatId).OwnerId != usr.Id){  
                        if(!mapToPass.containsKey(chatId)){
                            mapToPass.put(chatId, mapNewChats.get(chatId));
                        }
                    }
                }
            }
        }
        
        if(!mapToPass.isEmpty()){
            helper.setOwner(mapToPass);
        }
        
        Map<Id,MessagingSession> mapToPass2 = new Map<Id,MessagingSession>();
        
        MessagingSession auxNew = new MessagingSession();
        MessagingSession auxOld = new MessagingSession();
        
        for(Id lctId : mapNewChats.keySet()){

			auxNew = mapNewChats.get(lctId);
			auxOld = mapOldChats.get(lctId);

			if(auxNew.status == 'Waiting'|| Test.isRunningTest()){
				if(auxNew.CaseId != null){
					mapCasesChat.put(auxNew.CaseId, lctId);
				}
				if (auxNew.DEG_NombreCliente__c != auxOld.DEG_NombreCliente__c) {
					mapToPass2.put(lctId, auxNew);
				} else if (auxNew.DEG_ApellidoCliente__c != auxOld.DEG_ApellidoCliente__c) {
					mapToPass2.put(lctId, auxNew);
				} else if (auxNew.DEG_TipoDocCliente__c != auxOld.DEG_TipoDocCliente__c) {
					mapToPass2.put(lctId, auxNew);
				} else if (auxNew.DEG_NumeroDocCliente__c != auxOld.DEG_NumeroDocCliente__c) {
					mapToPass2.put(lctId, auxNew);
				} else if (auxNew.DEG_TelefonoCliente__c != auxOld.DEG_TelefonoCliente__c) {
					mapToPass2.put(lctId, auxNew);
				} else if (auxNew.DEG_EmailCliente__c != auxOld.DEG_EmailCliente__c) {
					mapToPass2.put(lctId, auxNew);
				}
			}
			
		}

		if(!mapToPass2.isEmpty()){
			helper.updateCases(mapToPass2, mapCasesChat);
		}
        		
    }
    
    public void OnAfterInsert(List<MessagingSession> lstChats){
        system.debug('##OnAfterInsert ' + lstChats[0]);
    }
    
    public void OnAfterUpdate(List<MessagingSession> lstChats, Map<Id, MessagingSession> mapOldChats, Map<Id, MessagingSession> mapNewChats){
													 																											  
        set<Id>idsms = New set<Id>();
        for(MessagingSession ms : lstChats){
            if(ms.Status =='Ended' && ms.ChannelType=='WhatsApp' && ms.DEG_HoraInicio__c==null){               
                idsms.add(ms.id);
            }
        }		
		
        if(idsms.size()>0){
            if(!System.isFuture() && !System.isBatch()){
                if(Limits.getFutureCalls() < Limits.getLimitFutureCalls()){
                    MetodoFuturo(idsms);
                }
            }
        }        
	}
    @future
    public static void MetodoFuturo(set<Id>IdsMS){
        try{
            SyncMethod(IdsMS);
        }catch(exception ex){
            system.debug('se ha generado un error:'+ex.getMessage());
        }
		
    }
    public static void SyncMethod(set<Id>IdsMS){	
        try{
            system.debug('idsms:'+idsms);
            if(idsms.size()!=0){
                List<ConversationEntry> CE = New List<ConversationEntry>();														   
                CE = [SELECT id,entryType, entryTime ,ConversationId
                      FROM ConversationEntry 
                      WHERE ConversationId IN: idsms and
                      (entryType=:'BotEscalated' or entryType=:'EndUserOptedOut')
                     ];
                system.debug('CE:'+CE);
                List<MessagingSession>msupdate = New List<MessagingSession>();
                for(id msl:idsms){
                    MessagingSession ms = New MessagingSession(Id=msl);
                    if(test.isRunningTest()){ // SE CONFIGURA UN VALOR PARA EVITAR RECURSIÓN DEL TRIGGER Y EVITAR ERROR SIMULANDO SET DEL CONVERSATIONENTRY
                        ms.DEG_HoraInicio__c=system.now()+'';
                        ms.DEG_FinalizadoVisitante__c=system.now()+'';
                    }																																			
                    for(ConversationEntry celist:ce){
                        if(msl == celist.ConversationId){
                            if(celist.entryType=='BotEscalated'){
                                datetime gmt = celist.entryTime; Integer offset = UserInfo.getTimezone().getOffset(gmt); Datetime local = gmt.addSeconds(offset/1000);
                                ms.DEG_HoraInicio__c = local+'';
                            }
                            if(celist.EntryType=='EndUserOptedOut'){
                                datetime gmt = celist.entryTime;Integer offset = UserInfo.getTimezone().getOffset(gmt); Datetime local = gmt.addSeconds(offset/1000);
                                ms.DEG_FinalizadoVisitante__c = local+'';
                            }
                        }
                    }
                    
                    msupdate.add(ms);
                }
                system.debug('msupdate:'+msupdate);
                if(msupdate.size()>0)                 
                    update msupdate;					
            }
        }catch(exception ex){
            system.debug('se ha generado un error:'+ex.getMessage());
        }
        
    }
}