/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 08-31-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   03-06-2021   Harlinsson Chavarro (HCH)   Initial Version
 * 1.1   05-03-2021   Sebastian Urrutia (SUF)     Set Owner
 **/
public without sharing class DEG_HandlerLiveChatTranscript_cls{
    public DEG_HandlerLiveChatTranscript_cls(){}

     //HCH: Se agregan variables para impedir re-ejecucion del trigger
	public static boolean blnAllow = true;
    
    public static void stopTrigger(){
        blnAllow = false;
    }
    
    public static boolean canIRun(){
        return blnAllow;
    }
    
    public static void startTrigger(){
        blnAllow = true;
    }
    //FIN HCH
    // Instancia del Helper
    DEG_HelperLiveChatTranscript_cls helper = new DEG_HelperLiveChatTranscript_cls();
    /*---------------------------------------------------------------------------------------------
     Autor: Harlinsson Chavarro (HCH)
     Descripción: Pasa los PlanCrecimiento Nuevos al helper para su procesamiento si cumplen con las condiciones
     @params: lstAccountNew (List<LiveChatTranscript> Lista de nuevos Prospectos creados)
     @return: ------
     ----------------------------------------------------------------------------------------------*/
    public void OnBeforeInsert(List<LiveChatTranscript> lstChats, Map<Id, LiveChatTranscript> mapNewChats){
        // system.debug('##OnBeforeInsert ' + lstChats[0]);
        helper.createCases(lstChats, mapNewChats);
    }

    /*---------------------------------------------------------------------------------------------
     Autor: Harlinsson Chavarro (HCH)
     Descripción: funcion que se ejecuta Antes de Update
     @params: List<LiveChatTranscript> lstChats (Lista de las nuevas versiones de los chat actualizados)
     Map<Id,LiveChatTranscript> mapOldChats (Lista de las anteriores versiones de los chats actualizados)
     @return: -----
     ----------------------------------------------------------------------------------------------*/
    public void OnBeforeUpdate(List<LiveChatTranscript> lstChats, Map<Id, LiveChatTranscript> mapOldChats, Map<Id, LiveChatTranscript> mapNewChats){
        List<LiveChatTranscript> lstChatsInteg = new List<LiveChatTranscript>();
        List<String> statusChatLst = new List<String>{'Missed', 'Completed'};
        User usr = [SELECT Id, username FROM User WHERE username LIKE 'autoproc%' LIMIT 1];
        Map<Id,LiveChatTranscript> mapToPass = new Map<Id,LiveChatTranscript>();
        Map<Id,Id> mapCasesChat = new Map<Id,Id>();

        //prefix for group
        String groupPrefix = Group.sObjectType.getDescribe().getKeyPrefix();

        for ( Id chatId : mapNewChats.keySet() ) {
            LiveChatTranscript chatCurrent = mapNewChats.get(chatId);
            if((chatCurrent.DEG_SentToIntegration__c == false && statusChatLst.contains(chatCurrent.status)) || Test.isRunningTest()){
                lstChatsInteg.add(chatCurrent); 
            }
            //change ownerId Case with ownerId chat
            if(chatCurrent.status == 'Waiting' || chatCurrent.status == 'InProgress' || Test.isRunningTest()){
                if(!(((String)chatCurrent.OwnerId).startsWith(groupPrefix))){
                    if(chatCurrent.OwnerId != usr.Id){
                        if(!mapToPass.containsKey(chatId)){
                            mapToPass.put(chatId, chatCurrent);
                            mapCasesChat.put(chatCurrent.CaseId, chatId);
                        }
                     
                    }
                }
            }
        }
        if(!mapToPass.isEmpty()){
            helper.setOwner(mapToPass,mapCasesChat);

            System.debug(mapCasesChat);
        }
        if(!lstChatsInteg.isEmpty()){
            helper.manageBody(lstChatsInteg);
        }
        
    }
    
    /*---------------------------------------------------------------------------------------------
     Autor: Harlinsson Chavarro (HCH)
     Descripción: Pasa los Prospectos Nuevos al helper para su procesamiento si cumplen con las condiciones
     @params: lstChats (List<LiveChatTranscript> Lista de nuevos chats creados)
     @return: ------
     ----------------------------------------------------------------------------------------------*/
    public void OnAfterInsert(List<LiveChatTranscript> lstChats){
        // system.debug('##OnAfterInsert ' + lstChats[0]);
    }

    /*---------------------------------------------------------------------------------------------
     Autor: Harlinsson Chavarro (HCH)
     Descripción: Pasa los Prospectos actualizados al helper para su procesamiento si cumplen con
     las condiciones
     @params: List<LiveChatTranscript> lstChats (Lista de las nuevas versiones de los chat actualizados)
     Map<Id,LiveChatTranscript> mapOldChats (Lista de las anteriores versiones de los chats actualizados)
     @return: ------
     ----------------------------------------------------------------------------------------------*/
    public void OnAfterUpdate(List<LiveChatTranscript> lstChats, Map<Id, LiveChatTranscript> mapOldChats, Map<Id, LiveChatTranscript> mapNewChats){
        Map<Id,LiveChatTranscript> mapToPass = new Map<Id,LiveChatTranscript>();
        Map<Id,Id> mapCasesChat = new Map<Id,Id>();
    
        LiveChatTranscript auxNew = new LiveChatTranscript();
        LiveChatTranscript auxOld = new LiveChatTranscript();
        List<Id> idsCompleted = new List<Id>();
        DEG_HandlerLiveChatTranscript_cls.stopTrigger();
        List<LiveChatButton> lstLiveButtons = [SELECT Id FROM LiveChatButton WHERE DeveloperName = 'DEG_ETBServicioClienteEmpresas' LIMIT 1];
        DEG_HandlerLiveChatTranscript_cls.startTrigger(); 

        for(Id lctId : mapNewChats.keySet()){
            auxNew = mapNewChats.get(lctId);
            auxOld = mapOldChats.get(lctId);
            
            if((auxNew.status == 'Waiting' && !auxNew.DEG_TransferToAgent__c) || Test.isRunningTest()){
                if (auxNew.LiveChatButtonId == lstLiveButtons[0].Id){
                    if(auxNew.CaseId != null){
                        mapCasesChat.put(auxNew.CaseId, lctId);
                    }
                    if (auxNew.DEG_NombreCliente__c != auxOld.DEG_NombreCliente__c) {
                        mapToPass.put(lctId, auxNew);
                    } else if (auxNew.DEG_ApellidoCliente__c != auxOld.DEG_ApellidoCliente__c) {
                        mapToPass.put(lctId, auxNew);
                    } else if (auxNew.DEG_TipoDocCliente__c != auxOld.DEG_TipoDocCliente__c) {
                        mapToPass.put(lctId, auxNew);
                    } else if (auxNew.DEG_NumeroDocCliente__c != auxOld.DEG_NumeroDocCliente__c) {
                        mapToPass.put(lctId, auxNew);
                    } else if (auxNew.DEG_TelefonoCliente__c != auxOld.DEG_TelefonoCliente__c) {
                        mapToPass.put(lctId, auxNew);
                    } else if (auxNew.DEG_EmailCliente__c != auxOld.DEG_EmailCliente__c) {
                        mapToPass.put(lctId, auxNew);
                    }
                }
            } else if(auxNew.status == 'Completed') {
                idsCompleted.add(auxNew.CaseId);
            }        
        }

        if(!idsCompleted.isEmpty()) {
            helper.setStatusResuelto(idsCompleted);
        }

        if(!mapToPass.isEmpty()){
            helper.updateCases(mapToPass,mapCasesChat);
        }
    }
}