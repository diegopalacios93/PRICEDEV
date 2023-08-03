/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripcion:            Desencadenador sobre el objeto ACO 

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     10-06-2021  Luisina Platino (LP)    Creacion de la clase. 
                                            La clase de test es ACO_procesos_tst
*******************************************************************************/

trigger ACO_tgr on ACO__c (before update) {

    if(Trigger.isBefore){

        if(Trigger.isUpdate){
            ACO_procesos notificar = new ACO_procesos(); 
            
            List<ACO_Actividad_y_Estado_Actividad__mdt> lst_ACOmdt = [
                SELECT  Actividad__c, Actividad_Final__c, Estado_Actividad_Inicial__c, Estado_Actividad_Final__c
                FROM ACO_Actividad_y_Estado_Actividad__mdt
            ];
            
            Map<String, ACO_Actividad_y_Estado_Actividad__mdt> mapMdt = new Map<String,ACO_Actividad_y_Estado_Actividad__mdt>();
            
            for(ACO_Actividad_y_Estado_Actividad__mdt ACOmdt : lst_ACOmdt){
                mapMdt.put(ACOmdt.Estado_Actividad_Inicial__c, ACOmdt);
            }

            ACO_Actividad_y_Estado_Actividad__mdt aco = new ACO_Actividad_y_Estado_Actividad__mdt();
            Set<String> idrecipient = new Set<String>();
            Map<Id,ACO__c> mapACO = new Map<Id,ACO__c> ();
            Set<Id> setOF = new Set<Id>();

            for(ACO__c newAco : Trigger.New){
                
                if(mapMdt.containsKey(newAco.Estado_Actividad__c)){
                    aco = mapMdt.get(newAco.Estado_Actividad__c);
                    
                    if(newAco.Estado_Actividad__c == 'Oferta actualizada' && newAco.Estado_Actividad__c != Trigger.oldMap.get(newAco.Id).Estado_Actividad__c){
                        idrecipient.add(newAco.OwnerId);
                        notificar.sendBellNotification(newAco, idrecipient);
                    }

                    if(newAco.Estado_Actividad__c == aco.Estado_Actividad_Inicial__c){
                        newAco.Actividad__c = aco.Actividad_Final__c;
                        newAco.Estado_Actividad__c = aco.Estado_Actividad_Final__c;
                    }
                }

                if(newAco.Estado_Actividad__c == 'Devuelto' && newAco.Actividad__c == 'Entrega Soportes por Preventa' && newAco.Observaciones__c != ''){
                    mapACO.put(newAco.Identificador_Oferta_OP__c, newAco);
                    setOF.add(newAco.Identificador_Oferta_OP__c);
                }

            }
            
            List<Oferta_Op_Viabilidad__c> lstOfV = [SELECT Viabilidad__r.Correo_Ing_Factibilidad__c, Oferta_Op__c FROM Oferta_Op_Viabilidad__c WHERE Oferta_Op__c IN: setOF];
            
            if(!lstOfV.isEmpty()){
                notificar.sendMailToEngineer(mapACO, lstOfV);
            }
        }

    }
    if(Trigger.isAfter){

        if(Trigger.isUpdate || Trigger.isInsert){

        }
    }

}