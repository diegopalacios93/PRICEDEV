/**************************************************************************************************************
* Globant México
* @author           Edgar Miranda Francisco
* Project:          ETB
* Description:      Clase para prueba DEG_BorradoAutomatico_bch
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description     
*           -----   ----------      --------------------    ---------------   
* @version   1.0    19/Mayo/2020    Edgar Miranda           Clase Creada
**************************************************************************************************************/

global without sharing class DEG_BorradoAutomatico_bch implements database.batchable<sObject> ,Database.Stateful{
    global String  TypeProcess= '';     
    global class   MyException extends Exception {} 
    global DEG_BorradoAutomatico_bch(){}
    
    global DEG_BorradoAutomatico_bch(String TypeProcess){
        this.TypeProcess = TypeProcess;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        System.debug('Tipo de Proceso: ' + TypeProcess);
        
        Set<String> keys = new   Set<String>(); 
        list<Case> lstCase;
        list<MessagingSession> lstMessagingSession;
        list<LiveChatTranscript> lstLiveChatTranscript;
        
        
        DEG_ConfiguracionBorradoAutomatico__mdt config =	[SELECT Id, DeveloperName,DEG_Borrado_por_Max__c, DEG_Borrado_por_Agente__c,DEG_TiempoBorrado__c  
                                                             FROM DEG_ConfiguracionBorradoAutomatico__mdt WHERE DeveloperName='DEG_ConfigGral' LIMIT 1 ];
        
        
        DateTime CreatedDate = DateTime.Now().AddDays(Integer.valueOf((test.IsRunningTest() ? -1: config.DEG_TiempoBorrado__c )) * -1);
        
        System.debug('##CreatedDate: ' +  CreatedDate);
        
        if(config.DEG_Borrado_por_Agente__c)	keys.add('Agente');
        if(config.DEG_Borrado_por_Max__c) 		keys.add('Bot');
        
        
        String queryChat,queryMessaging,queryTranscript;
        try{     
            if(!config.DEG_Borrado_por_Agente__c && !config.DEG_Borrado_por_Max__c)
                queryChat		= 'SELECT	id FROM	Case WHERE CreatedDate < ' + CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND DEG_SentToIntegration__c = true ' ;
            else if(config.DEG_Borrado_por_Agente__c && config.DEG_Borrado_por_Max__c)
                queryChat		= 'SELECT	id FROM	Case WHERE CreatedDate < ' + CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND DEG_GestionadoPor__c in (\'Agente\',\'Bot\') AND DEG_SentToIntegration__c = true ' ;
            else if(config.DEG_Borrado_por_Agente__c && !config.DEG_Borrado_por_Max__c)
                queryChat		= 'SELECT	id FROM	Case WHERE CreatedDate < ' + CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND DEG_GestionadoPor__c in (\'Agente\') AND DEG_SentToIntegration__c = true ' ;
            else if(config.DEG_Borrado_por_Agente__c && config.DEG_Borrado_por_Max__c)
                queryChat		= 'SELECT	id FROM	Case WHERE CreatedDate < ' + CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND DEG_GestionadoPor__c in (\'Bot\') AND DEG_SentToIntegration__c = true ' ;
            
            queryMessaging	= 'SELECT	id FROM	MessagingSession WHERE CreatedDate < ' + CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND DEG_SentToIntegration__c = true ';
            
            queryTranscript	= 'SELECT	id FROM	LiveChatTranscript WHERE CreatedDate < ' + CreatedDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND DEG_SentToIntegration__c = true ';
            
            
            switch on TypeProcess {
                when 'Case'					{	return  Database.getQueryLocator(queryChat); 
                }	
                when 'MessagingSession'		{	return  Database.getQueryLocator(queryMessaging); 
                }
                when 'LiveChatTranscript'	{	return  Database.getQueryLocator(queryTranscript); 
                }
                when else 					{	throw new MyException('Error');
                }
            }
        }
        catch(Exception ex){
            System.debug('LineNumber: ' +  ex.getLineNumber());
            System.debug('Message: ' + ex.getMessage());
            return null;
        }
    }
    
    public void execute(Database.BatchableContext bc, List<Object> scope){
        System.debug('Execute Batch: ' + TypeProcess);
        Map<id,LiveChatTranscript>		mpTranscript	=	new  Map<id,LiveChatTranscript>();
        Map<id,MessagingSession>		mpMessaging 	=	new  Map<id,MessagingSession>();
        Map<id,Case>					mpCase 			=	new  Map<id,Case>();
        
        // Savepoint sp = Database.setSavepoint();
        
        for (Object o : scope){
            
            if (TypeProcess == 'LiveChatTranscript')	mpTranscript.put(((LiveChatTranscript)o).id,new LiveChatTranscript (id = ((LiveChatTranscript)o).id));
            
            if (TypeProcess == 'MessagingSession')		mpMessaging.put(((MessagingSession)o).id,new MessagingSession (id = ((MessagingSession)o).id));
            
            if (TypeProcess == 'Case')					mpCase.put(((case)o).id,new Case (id = ((case)o).id));
        }

        
        System.debug('mpTranscriptSize '+mpTranscript.size());
        System.debug('mpMessagingSize '+mpMessaging.size());
        System.debug('mpCaseSize '+mpCase.size());

        if(!mpTranscript.isEmpty()) delete mpTranscript.values();
        if(!mpMessaging.isEmpty()) delete mpMessaging.values();
        if(!mpCase.isEmpty()) delete mpCase.values();
        
           
        System.debug('Se Borro Mapa: ' + TypeProcess);
        
        //Borrar al final de las pruebas
        //Database.rollback(sp);
        
    }
    
    
    public void finish(Database.BatchableContext bc){
        System.debug('Finish Batch: ' + TypeProcess);
            if (TypeProcess == 'Case'){
                DEG_BorradoAutomatico_bch bch = new DEG_BorradoAutomatico_bch('MessagingSession');
                database.executeBatch(bch);
            }  
            if (TypeProcess == 'MessagingSession'){
                DEG_BorradoAutomatico_bch bch = new DEG_BorradoAutomatico_bch('LiveChatTranscript');
                database.executeBatch(bch);
            }
    }
}