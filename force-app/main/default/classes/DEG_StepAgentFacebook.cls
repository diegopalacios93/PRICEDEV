/*
* Desarrollado por: Accenture
* Autor:            Johan  Andres  Olarte  L
* Proyecto:         ETB - DEG
* Descripción:      Clase para validar el valor que ingresa el cliente dentro del canal de Facebook.
* Clase:            DEG_StepAgentFacebook
* Cambios (Versiones)
* -----------------------------------------------------------------------------------
* No.  Fecha       	Autor                   			Descripción
* ---- ----------- 	----- ------------------ 			------------------------------------------
* 1.0  17-Ene-2022  	Johan  Andres  Olarte. (JAOL)   	Creación de la clase
**/
public with sharing class DEG_StepAgentFacebook {
    

    public class Input{
        @InvocableVariable(required = false)
        public String idConversation;
        @InvocableVariable(required = false)
        public String texClient;
    }

    public class Output{
		@InvocableVariable(required = false)
		public String allpasoAgente;
	}
   /*---------------------------------------------------------------------------------------------
Autor:Johan Andres Olarte (JAOL)
Descripción: Método encargado de optener el valor del cliente para saber el paso agente 
@params: inputLst:Lista de  input 
@return: OutputLst:Lista de  Output
----------------------------------------------------------------------------------------------*/
    @InvocableMethod(label = 'Validate Facebook Step')
    public static list<Output> getClientText(List<Input> wspInputLst){

        List<Output> wspOutLst = new List<Output>();
        double rangoHora;
        String resultado;
        Output wspOutLstfa = new Output();
        

        list <messagingSession> lsMessaging = [SELECT id,DEG_MotivoAgente__c,DEG_MotivoContacto__c  FROM  messagingSession WHERE id =: wspInputLst[0].idConversation  LIMIT 1];
       if (!lsMessaging.isEmpty()) {
                lsMessaging.get(0).DEG_MotivoAgente__c = label.Facebook_Redes_Sociales;
                lsMessaging.get(0).DEG_MotivoContacto__c = label.Facebook_MotivoContacto;
                update lsMessaging;
                wspOutLstfa.allpasoAgente = 'Cliente Redes Sociales';
                System.debug(lsMessaging+ 'Entro Redes Sociales');
       }
        list <messagingSession> lstMessaging = [SELECT id, CaseId,case.Status,DEG_HoraFinalizacionChat__c,DEG_Facebook_CasoAbando__c 
                                                    FROM  MessagingSession 
                                                        WHERE /*case.Status ='Abandono' 
                                                        AND  case.Origin ='Canal Facebook' 
                                                        AND  */DEG_HoraFinalizacionChat__c !=null  
                                                        AND  DEG_Facebook_CasoAbando__c = null  
                                                        AND  id!=: wspInputLst[0].idConversation LIMIT 1];

        if(!lstMessaging.isEmpty() && lstMessaging!=null && wspInputLst.get(0).texClient !=null){
            
            rangoHora = Math.Floor(((Double.valueOf(System.now().getTime()) - Double.valueOf(DateTime.valueOf(lstMessaging[0].DEG_HoraFinalizacionChat__c).getTime())) / (1000.0*60.0)) - 720);
                        
                
        }
         /*if(!lstMessaging.isEmpty() && lstMessaging != null  && rangoHora <=120){

            messagingSession casoAbandoFacebook = new messagingSession(id=lstMessaging.get(0).id,DEG_Facebook_CasoAbando__c='Caso_abandono_Facebook');
                       update casoAbandoFacebook;
                       resultado='Caso_abandono_Facebook'; 

          }*/

          list <messagingSession> lstMessagingFacebook = [SELECT id,MessagingEndUserId, case.Origin,case.Status,case.RecordType.Name,DEG_HoraFinalizacionChat__c,DEG_Facebook_CasoAbando__c
                                                          FROM  MessagingSession 
                                                          WHERE /*case.Status ='Abandono' 
                                                          AND case.Origin ='Canal Facebook' 
                                                          AND */DEG_HoraFinalizacionChat__c !=null  
          												  AND DEG_Facebook_CasoAbando__c = 'Caso_abandono_Facebook' 
                                                          AND id!=: wspInputLst.get(0).idConversation  LIMIT 1];

          /*if (!lstMessagingFacebook.isEmpty() &&  String.valueOf(lstMessagingFacebook.get(0).DEG_Facebook_CasoAbando__c) == 'Caso_abandono_Facebook' &&  wspInputLst.get(0).texClient !=null )
          {
              wspOutLstfa.allpasoAgente = 'Clientes con Abandono';
                  Map<String,Object> variablesFlowMap = new Map<String,Object>();
                  variablesFlowMap.put('Id_Facebook', lstMessagingFacebook.get(0).MessagingEndUserId);
                  Flow.Interview.DEG_Caso_Abandono_Facebook myFlowOutbound = new Flow.Interview.DEG_Caso_Abandono_Facebook(variablesFlowMap);
                  myFlowOutbound.start();

          }*/
           
          wspOutLst.add(wspOutLstfa);
       return wspOutLst;
    }
}