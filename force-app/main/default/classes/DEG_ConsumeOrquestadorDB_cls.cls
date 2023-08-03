/**
 * @description       : Clase para consumir la respuesta de Watson desde la DB para el canal WhatApp
 * @author            : Rodrigo de la Castilleja (RdC)
 * @group             : ETB
 * @last modified on  : 02-03-2022
 * @last modified by  : j.martinez.mercado
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-24-2021   Rodrigo de la Castilleja (RdC)   Initial Version
 **/
global class DEG_ConsumeOrquestadorDB_cls{
	global DEG_ConsumeOrquestadorDB_cls(){
	}
    public class Output{
		@InvocableVariable(required = true)
		public Boolean transferToAgent = false;
		@InvocableVariable(required = true)
		public String allMessage = '';
        @InvocableVariable(required = false)
		public Boolean evento = false;
        @InvocableVariable(required = true)
		public String motivoPaso;
        @InvocableVariable(required = true)
		public String motivoContacto;
        @InvocableVariable(required = true)
		public Boolean isFueradeHorario = false;
        //new
        // @InvocableVariable(required = false)
		// public String colaATransferir;
        //--
 	}

	public class Input{
		@InvocableVariable(required = true)
		public String conversationId;
	}

    @InvocableMethod(label = 'Get Response From DB')
    public static List<Output> makeGetCallout(List<Input> inputLst){

        List<Output> outputLst = new List<Output>();
        outputLst.add(new Output());
        outputLst[0].allMessage = '';

        LiveChatTranscript chat = [ SELECT DEG_LastResponse__c,DEG_TransferToAgent__c  ,DEG_Event__c,DEG_LastResponseHuman__c,DEG_MotivoAgente__c, DEG_MotivoContacto__c, DEG_NombredelaCola__c, DEG_IsFueraHorario__c
                                    FROM LiveChatTranscript 
                                    WHERE Id =:inputLst[0].conversationId 
                                    LIMIT 1];
        System.debug(logginglevel.INFO, chat);
        if(chat != null){
            outputLst[0].isFueradeHorario = chat.DEG_IsFueraHorario__c;   
            if(chat.DEG_TransferToAgent__c) {
                //new
                // outputLst[0].colaATransferir = chat.DEG_Cola_Mensajeria__c;
                //--
                outputLst[0].allMessage = System.label.DEG_MensajePasoAgente;//'Tranferencia a agente.'; //usually chat.DEG_LastResponseHuman__c is empty
                outputLst[0].TransferToAgent = true;
                System.debug('Nombre de la cola:: '+chat.DEG_NombredelaCola__c);
                if (chat.DEG_NombredelaCola__c == System.Label.DEG_SoporteTecnicoMasivos) {
                    outputLst[0].motivoPaso = System.Label.DEG_Hogares_Soporte_Tecnico;
                } else {
                    outputLst[0].motivoPaso = chat.DEG_MotivoAgente__c;
                }
                return outputLst;
            }
            if(chat.DEG_LastResponse__c  != null && chat.DEG_LastResponse__c != ''){
                outputLst[0].allMessage = chat.DEG_LastResponseHuman__c;
                outputLst[0].evento = chat.DEG_Event__c;
                outputLst[0].motivoContacto = chat.DEG_MotivoContacto__c;
                chat.DEG_LastResponse__c = 'Hola';
                update chat;
            }
        }
        return outputLst;
    }
   
}