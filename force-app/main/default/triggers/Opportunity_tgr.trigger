/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Desencadenador sobre el objeto Opportunity                        

Cambios (Versiones)
-------------------------------------------------
No.     Fecha       Autor                               Descripción
------  ----------  -----------------------------       ---------------
1.0     03-10-2013  Andrés Cubillos (AAC)               Creación de la clase.
1.1     06-08-2015  Juan Gabriel Duarte P. (JGD)        Envio proceso de aprobacion.
1.2     16-06-2021  Luisina Platino                     CustomNotifications para owner de ACO. 
                                                        Unificacion de metodos en una unica clase
1.3     05-01-2022  Mary Boyacá                         Actualización de la campania o promoción de las OC cuando
														se actualiza la oportunidad.
*******************************************************************************/
trigger Opportunity_tgr on Opportunity (after insert, after update, before insert, 
before update) {
	Opportunity_cls triggerHelper = new Opportunity_cls();

	if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
		triggerHelper.Actualizar(trigger.new); 
	}
	
	  if (trigger.isBefore) {
        //Bloque BeforeInsert
        if (trigger.isInsert){
        	triggerHelper.ValidarOportunidad(trigger.new);
            Id oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Licitacion').getRecordTypeId();
            for(Opportunity oportunidad :trigger.new)
            {
                if(oportunidad.RecordTypeID==oppRecTypeId)
                    oportunidad.Integrar_con_gestor__c = true;
            }
        }
        //Bloque BeforeUpdate
        else if(trigger.isUpdate){
            Set<String> idrecipient = new Set<String>();
            Map<String, String> mapAco = new Map<String,String>();
            List<ACO__c> lstAco = [SELECT OwnerId, Nombre_de_la_Oportunidad__r.Id FROM ACO__c WHERE Nombre_de_la_Oportunidad__c IN: Trigger.new];
            List<OperacionComercial__c> listOC = [SELECT Id,ComponenteCampana__c FROM OperacionComercial__c WHERE Oportunidad__c IN : Trigger.new];
           
            for(ACO__c aco : lstAco){
                if(!mapAco.containsKey(aco.OwnerId) || mapAco.isEmpty()){
                    mapAco.put(aco.Nombre_de_la_Oportunidad__r.Id, aco.OwnerId);
                }
            }
            String strId;
            for(Opportunity opp : Trigger.new){
                if(opp.PDC__c == '90% - Probabilidad de Éxito' && mapAco.containsKey(opp.Id) && opp.PDC__c != Trigger.oldMap.get(opp.Id).PDC__c){
                    idrecipient.add(mapAco.get(opp.Id));
                    triggerHelper.sendBellNotification(opp, idrecipient);
                }
                
                if(opp.ComponenteDeLaPromocion__c != Trigger.oldMap.get(opp.Id).ComponenteDeLaPromocion__c){
                    triggerHelper.actualizarPromocionOC(opp, listOC);
                }
            }
        }  
    }

    //Lanza el proceso de aprobacion para descuentos en oportunidades LTE
    if(Trigger.isAfter){
        triggerHelper.EnviarProcesosAprovacionOpp(trigger.newMap);    
    }

}