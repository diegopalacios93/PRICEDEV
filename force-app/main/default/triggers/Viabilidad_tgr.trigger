/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Grimaldos
Proyecto:               ETB - CRM Evolutivos
Descripción:            Trigger para objeto Viabilidad 

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     05-02-2014  Jorge Grimaldos (JG)       Creación de la clase.
*******************************************************************************/
trigger Viabilidad_tgr on Viabilidad__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    Viabilidad_cls triggerHelper = new Viabilidad_cls();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            
        }
        if (Trigger.isUpdate) {
            triggerHelper.ObtenerDestinatarioViabilidad(Trigger.newMap, Trigger.oldMap);

            List<Viabilidad__c> lstVia = new List<Viabilidad__c>();
            for(Viabilidad__c via : Trigger.new){
                if(via.EstadoViabilidad__c == 'Cerrada' && via.EstadoViabilidad__c != Trigger.oldMap.get(via.Id).EstadoViabilidad__c){
                    lstVia.add(via);
                }
            }
            if(!lstVia.isEmpty()){
                List<Oferta_Op_Viabilidad__c> lstOfV = [SELECT Oferta_Op__c FROM Oferta_Op_Viabilidad__c WHERE Viabilidad__c IN: lstVia];
                List<String> lstId = new List<String>();

                for(Oferta_Op_Viabilidad__c via : lstOfV){
                    lstId.add(via.Oferta_Op__c);
                }
                
                List<ACO__c> lstAco = [SELECT Name, OwnerId FROM ACO__c WHERE Identificador_Oferta_OP__c IN: lstId];
                Set<String> idrecipient = new Set<String>();
                
                for(ACO__c aco : lstAco){
                    idrecipient.add(aco.OwnerId);
                    triggerHelper.sendBellNotification(aco, idrecipient);
                }
            }
        }
        if (Trigger.isDelete) {
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
            //-SAO- Si en las viabilidades se modifinca el campo tipo de aliado actualizar las OCs
            List<Viabilidad__c> lstViabilidades = new List<Viabilidad__c>();
            Map <Id, Id> lstOCAPN = new Map <Id, Id>();
            String sError = '';
            
            
            Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
        	String strEstadoAPN = vGlobalAPN.get('EstadosViaAPN').valor__c;
        	Set<String> lstEstadoAPN = new Set<String>(strEstadoAPN.split(','));
            
            
            for(Integer i=0; i<trigger.new.size(); i++){
                if(trigger.new[i].Tipo_de_Aliado__c != null && trigger.new[i].EstadoViabilidad__c == 'Cerrada' 
                && Trigger.oldMap.get(trigger.new[i].Id).EstadoViabilidad__c != trigger.new[i].EstadoViabilidad__c){
                    lstViabilidades.add(trigger.new[i]);
                }
                
                if(trigger.new[i].APN__c != null && trigger.new[i].Crear_VIA_de_Lineas_LTE__c && trigger.new[i].Respuestadeviabilidad__c == 'Viable' && lstEstadoAPN.contains(trigger.new[i].EstadoViabilidad__c) && (Trigger.oldMap.get(trigger.new[i].Id).Respuestadeviabilidad__c != trigger.new[i].Respuestadeviabilidad__c || Trigger.oldMap.get(trigger.new[i].Id).EstadoViabilidad__c != trigger.new[i].EstadoViabilidad__c || !Trigger.oldMap.get(trigger.new[i].Id).Crear_VIA_de_Lineas_LTE__c)){
                        lstOCAPN.put(trigger.new[i].OperacionComercial__c, trigger.new[i].APN__c);
                }
                        
                
                // Actualizar el campo viabilidad adicional en la oportunidad.
                if(trigger.new[i].Viabilidad_Adicional__c != trigger.old[i].Viabilidad_Adicional__c){
                    Opportunity objOpportunity = new Opportunity();
                    if(!Test.isRunningTest()){
                        objOpportunity = [SELECT Id FROM Opportunity WHERE Id = :trigger.new[i].Oportunidad__c];
                        objOpportunity.Viabilidad_Adicional__c = trigger.new[i].Viabilidad_Adicional__c;
                        Update  objOpportunity;
                    }
                }
            }
            
            if(!lstViabilidades.isEmpty()) triggerHelper.ActualizarTipoVentaOC(lstViabilidades);

            if(!lstOCAPN.isEmpty()) sError = ProcesosAPN_cls.OCAsociaIPPool(lstOCAPN);

            if(String.isNotBlank(sError)) trigger.new[0].addError(sError);
            
        }
        if (Trigger.isDelete) {
        }
        if (Trigger.isUnDelete) {
        }
    }
}