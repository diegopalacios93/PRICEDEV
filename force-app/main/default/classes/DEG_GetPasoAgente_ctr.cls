/**
* @description       :
* @author            : Nolvis Sanchez
* @group             :
* @last modified on  : 04-01-2022
* @last modified by  : Nolvis Sanchez
* Modifications Log
* Ver   Date         Author                        Modification
* 1.0   
**/

public with sharing class DEG_GetPasoAgente_ctr {
    
    
    public class OrquestOutput {
      
       @InvocableVariable(required=false)
        public String sessionId;

        
    }
    
    public class OrquestInput {
        
        @InvocableVariable(required=false)
        public String transcriptId;

        
    }
    
    
    @InvocableMethod(label='Get Paso Agente Obligatorio')
    public static List<OrquestOutput> validarPasoAgente (List<OrquestInput> inputLst){    
      List<MessagingSession> ms =[SELECT id, Name,DEG_MotivoAgente__c FROM MessagingSession 
      WHERE id =: inputLst[0].transcriptId LIMIT 1] ;
      
      if (!ms.isEmpty()) {
        ms[0].DEG_MotivoAgente__c = 'Solicitud ayuda ecommerce';
        update ms;
        } else {
        System.debug('La lista está vacia');
        }
        
      return null;
    }
}