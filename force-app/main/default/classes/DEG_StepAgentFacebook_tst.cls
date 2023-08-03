/**
 * @description       : 
 * @author            : Johan Andres Olarte Ladino
 * @group             : 
 * @last modified on  : 19-01-2021
 * @last modified by  : Johan Andres Olarte Ladino 
**/
@isTest
public  class DEG_StepAgentFacebook_tst {


    @testSetup
    static void setup() {

        MessagingChannel msgChannel = [SELECT Id, DeveloperName
                                      FROM MessagingChannel
                                      WHERE DeveloperName = 'Facebook_US_234370136617753' LIMIT 1];
        
        
        

		MessagingEndUser msgEndUser= new MessagingEndUser(	Name = 'Johan Olarte' ,
															MessagingPlatformKey = '6927924453946798',
															 MessagingChannelId= msgChannel.Id,
															 MessageType = 'Facebook'  );
		insert msgEndUser;
        

        case mscase = new case  (Status='Abierto',
                                 Origin='Canal Facebook');
        insert mscase;

		messagingSession msgSession = new messagingSession( MessagingChannelId= msgChannel.Id,
															MessagingEndUserId = msgEndUser.Id,
															Status = 'Ended' ,
                                                            DEG_MotivoAgente__c='Cliente Redes Sociales' ,
                                                            DEG_MotivoContacto__c='No Aplica',
                                                            DEG_HoraFinalizacionChat__c='2022-01-19 12:30:13',
                                                            DEG_Facebook_CasoAbando__c='Caso_abandono_Facebook',
                                                            caseid=mscase.id);
		insert msgSession;

    }
	
	@isTest
    static void getClientTextTst() {
        double rangoHora = 120;
        List<DEG_StepAgentFacebook.Input> inputLst = insfacebook();
        list <messagingSession> lsMessaging = [SELECT id,DEG_MotivoAgente__c,DEG_MotivoContacto__c  FROM  messagingSession];
        Test.startTest();
        DEG_StepAgentFacebook.getClientText(inputLst);
        Test.stopTest();
    }
    private static List<DEG_StepAgentFacebook.Input> insfacebook (){
        List<DEG_StepAgentFacebook.Input> inputLst = new List<DEG_StepAgentFacebook.Input>();
        
        inputLst.add(new DEG_StepAgentFacebook.Input());
        inputLst.get(0).texClient = 'HOLA';
        inputLst.get(0).idConversation = [SELECT ID FROM messagingSession LIMIT 1].Id;
        return inputLst;
    } 
    
}