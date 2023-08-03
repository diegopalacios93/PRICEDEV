/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-04-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   02-02-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
public with sharing class DEG_GetPrechat_cls {

    public class prechatOutput {
        @InvocableVariable(required=true)
        public String concatenateStr;
        @InvocableVariable(required=true)
        public String documentType;
        @InvocableVariable(required=true)
        public String numberDocument;
       
    }
    
    public class prechatInput {
        @InvocableVariable(required=true)
        public Id routableID;
        @InvocableVariable(required=true)
        public String botName;
    }
 
    @InvocableMethod(label='Get Prechat Data')
    public static List<prechatOutput> getPrechat(List<prechatInput> prechatLst) {
        prechatOutput salidaPrechat = new prechatOutput(); 
        List<prechatOutput> salidaPrechatLst = new List<prechatOutput>(); 
        String concatenateFields='';  
		Map<String,String> mCampoValor = new Map<String,String>();
        LiveChatTranscript transcriptRecord;
        for (prechatInput transcript : prechatLst) {
            
            transcriptRecord  = [SELECT Id, DEG_NombreCliente__c, DEG_NumeroDocCliente__c,
                		        DEG_AceptaenvioConversacionporCorreo__c, DEG_ApellidoCliente__c,
                                DEG_CanalBot__c, DEG_EmailCliente__c , DEG_TelefonoCliente__c, DEG_TipoDocCliente__c 
				                FROM LiveChatTranscript 
                                WHERE Id =:transcript.routableID LIMIT 1];
            
            if( transcriptRecord.DEG_NombreCliente__c != null ){
            	mCampoValor.put('DEG_NombreCliente__c',transcriptRecord.DEG_NombreCliente__c);    
            }
            if( transcriptRecord.DEG_ApellidoCliente__c != null ){
            	mCampoValor.put('DEG_ApellidoCliente__c',transcriptRecord.DEG_ApellidoCliente__c);    
            }
            if( transcriptRecord.DEG_NumeroDocCliente__c != null ){
                mCampoValor.put('DEG_NumeroDocCliente__c',transcriptRecord.DEG_NumeroDocCliente__c);
            }
            if( transcriptRecord.DEG_TelefonoCliente__c != null ){
            	mCampoValor.put('DEG_TelefonoCliente__c',transcriptRecord.DEG_TelefonoCliente__c);    
            }
            if( transcriptRecord.DEG_TipoDocCliente__c != null ){
            	mCampoValor.put('DEG_TipoDocCliente__c',transcriptRecord.DEG_TipoDocCliente__c);    
            }
            if( transcriptRecord.DEG_EmailCliente__c != null ){
            	mCampoValor.put('DEG_EmailCliente__c',transcriptRecord.DEG_EmailCliente__c);    
            }
            if( transcriptRecord.Id != null ){
            	mCampoValor.put('Id',transcriptRecord.Id);    
            }
        }
        
        if( !mCampoValor.isEmpty() ){
            concatenateFields  = prechatLst[0].botName+
                mCampoValor.get('DEG_NombreCliente__c')+'::'+
                mCampoValor.get('DEG_ApellidoCliente__c')+'::'+
                mCampoValor.get('DEG_NumeroDocCliente__c')+'::'+
                mCampoValor.get('DEG_TelefonoCliente__c')+'::'+
                'true'+'::'+
                mCampoValor.get('DEG_TipoDocCliente__c')+'::'+
                mCampoValor.get('DEG_EmailCliente__c');
                /*+'::'+
                mCampoValor.get('Id');*/
            // concatenateFields  = 'Hola::etbHogares::'+chatLst[0].DEG_NombreCliente__c+'::'+chatLst[0].DEG_ApellidoCliente__c+'::'+chatLst[0].DEG_NumeroDocCliente__c+'::'+chatLst[0].DEG_TelefonoCliente__c+'::'+chatLst[0].DEG_TipoDocCliente__c+'::'+chatLst[0].DEG_EmailCliente__c+'::'+chatLst[0].Id;
            
            salidaPrechat.concatenateStr = concatenateFields;
            salidaPrechat.documentType = transcriptRecord.DEG_TipoDocCliente__c;
            salidaPrechat.numberDocument = transcriptRecord.DEG_NumeroDocCliente__c;
            salidaPrechatLst.add(salidaPrechat);
            System.debug('salidaPrechatLst '+salidaPrechatLst[0]);

        }		
        return salidaPrechatLst;
    }

}