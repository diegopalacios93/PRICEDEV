/**
 * @description       : Clase de Web Service para consumir el Orquestador de Watson con el canal de WhatApp
 * @author            : Rodrigo de la Castilleja (RdC)
 * @group             : ETB
 * @last modified on  : 06-22-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-24-2021   Rodrigo de la Castilleja (RdC)   Initial Version
 **/
global class DEG_WaitResponseFrame_cls{
	global DEG_WaitResponseFrame_cls(){
	}
    public class Input{
		@InvocableVariable(required = true)
		public String conversationId;
		@InvocableVariable(required = false)
		public String whatsAppInfo = '';
	}
    public class Output{
		@InvocableVariable(required = false)
		public Boolean passTime = false;
		@InvocableVariable(required = false)
		public String whatsAppInfo;
	}
    @InvocableMethod(label = 'Wait some Seconds')
	public static List<Output> doWaiting(List<Input> wspInputLst){
		Decimal timeWaitWpp = [SELECT DEG_TimeWaitMessage__c
							FROM DEG_ConfigGenerales__mdt
							LIMIT 1].DEG_TimeWaitMessage__c;
		
		List<Output> outputLst = new List<Output>();
		DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo wspAppInfo;
		outputLst.add(new Output());
		if(wspInputLst[0].whatsAppInfo != null && wspInputLst[0].whatsAppInfo != 'null'){
			wspAppInfo = (DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo)System.JSON.deserialize(wspInputLst[0].whatsAppInfo, DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo.class);
			wspAppInfo.lastResponseDate = String.valueOf(DateTime.now().getTime());
		}
		DEG_ConsumeOrquestadorDBWhatsApp_cls.delay(Integer.valueOf(timeWaitWpp));
		outputLst[0].passTime = true;
		outputLst[0].whatsAppInfo =  JSON.serialize(wspAppInfo);
        return outputLst;
	}
    
}