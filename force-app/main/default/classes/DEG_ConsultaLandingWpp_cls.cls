/**
 * @description       :
 * @author            : Pablo Arrieta
 * @group             :
 * @last modified on  : 08-30-2021
 * @last modified by  : Pablo Arrieta
**/
/**
 * @description       :
 * @author            : Johan Olarte
 * @group             :
 * @last modified on  : 29-09-2021
 * @last modified by  : Johan Olarte
**/
/**
 * @description       :
 * @author            : Mary Florio
 * @group             :
 * @last modified on  : 01-12-2021
 * @last modified by  : Mary Florio
**/
/**
 * @description       :
 * @author            : Mary Florio
 * @group             :
 * @last modified on  : 10-02-2022
 * @last modified by  : Mary Florio
**/
global class DEG_ConsultaLandingWpp_cls {

    public class Input{
        @InvocableVariable(required = false)
        public String textClient;
        @InvocableVariable(required = false)
        public String idMessaging;
        @InvocableVariable(required = false)
        public String usuarioFinal;
    }

    public class Output{
        @InvocableVariable(required = false)
        public String idCola = '';
        @InvocableVariable(required = false)
        public Boolean isLanding = true;
        @InvocableVariable(required = false)
        public String message = '';
    }

    @InvocableMethod(label = 'Get Id Queue')
    public static List<Output> getQueue(List<Input> inputLst) {
        System.debug('##inputLst '+inputLst);
        List<Output> outputLst = new List<Output>();
        Output output = new Output();
       // List<Case> casoOtherAegmentLst = new List<Case>();
        List<DEG_OpcionLanding__mdt> landingMDT = new List<DEG_OpcionLanding__mdt>();
        system.debug('Lista ini landingMDT '+landingMDT);
        List<Group> cola = new List<Group>();
        List<Group> colaLanding = new List<Group>();
        List<MessagingSession> messagingLst = new List<MessagingSession>();
        system.debug('Lista ini messagingLst '+messagingLst);
      	List<MessagingEndUser> userEndLst = [SELECT Name,ContactId, Contact.DEG_groupReinjection__c,  
                                             DEG_ExistUser__c, MessagingPlatformKey,DEG_IDdeBacklanding__c,
                                             Contact.DEG_CumpleReinyeccion__c
                                             FROM MessagingEndUser WHERE Id =:inputLst[0].usuarioFinal LIMIT 1];
        //system.debug('Lista ini userEndLst '+userEndLst); 
        //List<MessagingEndUser> userEndLst = [SELECT Name,ContactId,  DEG_ExistUser__c, MessagingPlatformKey,DEG_IDdeBacklanding__c FROM MessagingEndUser WHERE Id =:inputLst[0].usuarioFinal LIMIT 1];
         
        String cellNumber = userEndLst[0].MessagingPlatformKey.substringAfter('+57');
        system.debug('Lista ini cellNumber '+cellNumber); 
        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
        system.debug('Lista ini ventasRTId '+ventasRTId);
        //Id colaId = Schema.SObjectType.Group.getRecordTypeInfosByDeveloperName().get('DEG_VentasHogaresWhatsApp').getRecordTypeId();
        //system.debug('Lista ini colaId '+colaId);
        MessagingChannel msgChannel = [SELECT Id, DeveloperName FROM MessagingChannel WHERE DeveloperName = 'WhatsAppVentasETB' LIMIT 1];
        system.debug('Lista ini msgChannel '+msgChannel); 
        messagingLst = [SELECT Id, CaseId, DEG_TelefonoCliente__c, DEG_GeneraInteraccionReinyeccion__c 
                        FROM MessagingSession 
                        WHERE Id =:inputLst[0].idMessaging AND MessagingChannelId =:msgChannel.Id LIMIT 1];
        system.debug('Lista ini messagingLst '+messagingLst); 
        Boolean entraReinyeccion = false;                   
        if(userEndLst.get(0).ContactId != null && userEndLst.get(0).Contact.DEG_groupReinjection__c != null){
            cola = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName =: userEndLst.get(0).Contact.DEG_groupReinjection__c LIMIT 1];
            system.debug('#cola -> '+cola);
            if (userEndLst.get(0).Contact.DEG_CumpleReinyeccion__c =='NO'){
                userEndLst.get(0).Contact.DEG_CumpleReinyeccion__c = 'SI';
            	update userEndLst.get(0).Contact;
                if(!messagingLst.get(0).DEG_GeneraInteraccionReinyeccion__c){
                	messagingLst.get(0).DEG_GeneraInteraccionReinyeccion__c = true;
                	update messagingLst.get(0);
            	}
            } else {
                messagingLst.get(0).DEG_EsReinyeccion__c = false;
                update messagingLst.get(0);
            }
            output.idCola=cola.get(0).Id;
            output.isLanding = true;
            //output.message = System.Label.DEG_OpcionValida;
            entraReinyeccion = true;
        }
        if(!entraReinyeccion){   
            if (userEndLst.get(0).DEG_ExistUser__c == true) {
                List<Case> lstCase = [SELECT Id, DEG_IdCola__c, Status,DEG_OrigendelaVenta__c,DEG_InteraciondelUsuario__c,DEG_Atencion_Cliente_Ventas__c,DEG_Cliente_Genera_Interaccion_WhatsApp__c FROM Case WHERE DEG_Celular__c =: cellNumber AND RecordTypeId =: ventasRTId AND Status NOT IN ( 'Resuelto','Resuelto Automatico')  LIMIT 1];
                system.debug('#lstCase DEG_ExistUser__c == true-> '+lstCase);
                
                 if(lstCase.size() > 0 && lstCase.get(0).DEG_IdCola__c != null ) {
                    landingMDT = [SELECT Id, DEG_Cola__c FROM DEG_OpcionLanding__mdt WHERE DeveloperName =: lstCase.get(0).DEG_IdCola__c LIMIT 1];
                    system.debug('#landingMDT DEG_ExistUser__c == true-> '+landingMDT);
                   
                    cola = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName =: landingMDT.get(0).DEG_Cola__c LIMIT 1];
                    system.debug('#cola DEG_ExistUser__c == true-> '+cola);
    
                    output.idCola = cola.get(0).Id;
                    output.isLanding = true;
                    
                    lstCase.get(0).Status = 'En Proceso';
                    lstCase[0].DEG_InteraciondelUsuario__c ='SI';
                    update lstCase;
                    system.debug('#lstCase Update lstCase == true-> '+lstCase);
    
                    if (messagingLst.size() > 0) {
                        messagingLst.get(0).DEG_TelefonoCliente__c = cellNumber;
                        messagingLst.get(0).CaseId = lstCase.get(0).Id;
                        messagingLst[0].DEG_Atencion_Cliente_Ventas__c = true;
    
                        update messagingLst;
                        system.debug('#messagingLst Upadate messagingLst == true-> '+messagingLst);
                    }
                 }else{
                      output.isLanding = false;
                     }
                     System.debug('#CasoExiste');
            }else{         
                  System.debug('#Caso');
                  Boolean isNumber = inputLst[0].textClient.isNumeric();
                  System.debug('ventasRTId:: '+ventasRTId);
                  System.debug('isNumber:: '+isNumber);
                
                  if(inputLst[0].textclient == '1' || inputLst[0].textclient == '2' || inputLst[0].textclient == '3') {
                     landingMDT = [SELECT Id, DEG_Opcion__c, DEG_Cola__c, DeveloperName FROM DEG_OpcionLanding__mdt WHERE DEG_Opcion__c =: inputLst[0].textClient LIMIT 1];
                     cola = [SELECT Id, Name  FROM Group WHERE Type = 'Queue' AND DeveloperName =: landingMDT[0].DEG_Cola__c LIMIT 1];
                           
                     System.debug('#metadata -> '+landingMDT);
                     List<Case> casoLst = [SELECT Id,Status,DEG_OrigendelaVenta__c,DEG_Atencion_Cliente_Ventas__c,DEG_Cliente_Genera_Interaccion_WhatsApp__c,DEG_InteraciondelUsuario__c
                                                  FROM Case WHERE DEG_Celular__c =:cellNumber
                                                  AND DEG_IdCola__c =:landingMDT[0].DeveloperName
                                                  AND CreatedDate = TODAY
                                                  AND Status = 'Contactar Prospecto'
                                                  AND ParentId = NULL
                                                  AND RecordTypeId=:ventasRTId ORDER BY CreatedDate ASC];
                        System.debug('##casoLst '+casoLst);
                        System.debug('Acc messagingLst'+messagingLst);
                     
                       if(!casoLst.isEmpty()) {
                             casoLst[0].Status = 'En Proceso';
                             casoLst[0].DEG_Cliente_Genera_Interaccion_WhatsApp__c = 'SI';
    
                             update casoLst;
                             System.debug('Cliente Genera Interación: '+casoLst);
                             messagingLst[0].DEG_TelefonoCliente__c = cellNumber;
                             messagingLst[0].DEG_Atencion_Cliente_Ventas__c = true;
                             messagingLst.get(0).CaseId = CasoLst.get(0).Id;
                             update messagingLst;
                             output.idCola = cola[0].Id;
                             output.isLanding = true;
                             userEndLst.get(0).DEG_ExistUser__c = true;
                             update userEndLst;
                            }else{
                                    //Landing Hogares pero ingresa un valor de moviles o empresa viceversa
                                    System.debug('### casoLst Vacio != 1,2,3');
                                    List<Case> Lstcaso = [SELECT Id,Status,DEG_LandingPage__c,DEG_OrigendelaVenta__c,DEG_InteraciondelUsuario__c,DEG_Atencion_Cliente_Ventas__c,DEG_Cliente_Genera_Interaccion_WhatsApp__c FROM Case WHERE DEG_Celular__c =:cellNumber AND RecordTypeId=:ventasRTId ORDER BY CreatedDate ASC];
                                    colaLanding = [SELECT Id, Name, DeveloperName  FROM Group WHERE Type = 'Queue' AND DeveloperName =: 'DEG_VentasHogaresWhatsApp' LIMIT 1];
                        
                                    System.debug('Lista ini Lstcaso '+Lstcaso);
                    
                                    if(!Lstcaso.isEmpty()){
                                        Lstcaso[0].DEG_InteraciondelUsuario__c ='SI';
                                        Lstcaso[0].Status = 'En Proceso';
                                    update Lstcaso;
                    
                                    System.debug('DEG_InteraciondelUsuario__c = 1 2 3'+Lstcaso);
                                    userEndLst.get(0).DEG_ExistUser__c = true;
                                    update userEndLst;
                                    output.idCola = colaLanding.get(0).Id;
                                    output.isLanding = true;   
                                 //   messagingLst[0].DEG_TelefonoCliente__c = cellNumber;
                                 //   messagingLst[0].DEG_Atencion_Cliente_Ventas__c = true;
                                 //   update messagingLst;
                                   } 
                                      
                                } 
                         
                    }else{
                            System.debug('### else != 1,2,3');
                            List<Case> Lstcaso = [SELECT Id,Status,DEG_LandingPage__c,DEG_OrigendelaVenta__c,DEG_InteraciondelUsuario__c,DEG_Atencion_Cliente_Ventas__c,DEG_Cliente_Genera_Interaccion_WhatsApp__c FROM Case WHERE DEG_Celular__c =:cellNumber AND RecordTypeId=:ventasRTId ORDER BY CreatedDate ASC];
                            colaLanding = [SELECT Id, Name, DeveloperName  FROM Group WHERE Type = 'Queue' AND DeveloperName =: 'DEG_VentasHogaresWhatsApp' LIMIT 1];
                
                            System.debug('Lista ini Lstcaso '+Lstcaso);
            
                            if(!Lstcaso.isEmpty()){
                                Lstcaso[0].DEG_InteraciondelUsuario__c ='SI';
                                Lstcaso[0].Status = 'En Proceso';
                            } 
                           
                            update Lstcaso;
                            
                            userEndLst.get(0).DEG_ExistUser__c = true;
                            update userEndLst;
                            output.idCola = colaLanding.get(0).Id;
                            output.isLanding = true;            
                            System.debug('DEG_InteraciondelUsuario__c # 1 2 3'+Lstcaso);
                         //    messagingLst[0].DEG_TelefonoCliente__c = cellNumber;
                          //   messagingLst[0].DEG_Atencion_Cliente_Ventas__c = true;
                           //  messagingLst.get(0).CaseId = Lstcaso.get(0).Id;
                            // update messagingLst;
                             
                             
                        
                       
                    }
             }
        }
        outputLst.add(output);
        System.debug('##outputLst '+outputLst);
        return outputLst;
    }
}