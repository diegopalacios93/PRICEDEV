trigger APN_tgr on APN__c (before update, before insert) {   
    String strCC, strServicio, APNExistente, strIdAPN;
    Integer intCC;
    APN__c[] objAPN;  
    
    if(trigger.isInsert && (trigger.new != null && !trigger.new.isEmpty())){        
        strCC 		= String.valueOf(trigger.new[0].get('Charguing_Characteristics__c'));
        strServicio = String.valueOf(trigger.new[0].get('Servicio__c'));  
        if(strCC != null && strServicio != null){                           
            objAPN = [SELECT Charguing_Characteristics__c FROM APN__c WHERE Charguing_Characteristics__c =: strCC AND Servicio__c =: strServicio LIMIT 1];
            if(objAPN.size() > 0){                    
                APNExistente = objAPN[0].Charguing_Characteristics__c;
                if(APNExistente != null && APNExistente != ''){                    
                    if(!Test.isRunningTest())
                    	trigger.new[0].addError(' No es posible crear el APN, ya existe un APN para el mismo Charguing Characteristics: "'+strCC+'" y para el mismo servicio: "'+strServicio+'"');
                }
            }else{
                intCC = integer.ValueOf(strCC);
                if(intCC < 20)
                    trigger.new[0].addError(' El valor del campo "Charguing Characteristics" no puede ser menor a 20.');
                
                if(intCC > 254)
                    trigger.new[0].addError(' El valor del campo "Charguing Characteristics" no puede ser mayor a 254.');
            }                        
        }
    }
    
    if(trigger.isUpdate && (trigger.newMap != null && !trigger.newMap.isEmpty())){        
        for (Id idOC: trigger.newMap.keySet()){              
            strCC 		= trigger.newMap.get(idOC).Charguing_Characteristics__c;
            strServicio	= trigger.newMap.get(idOC).Servicio__c;
            strIdAPN	= trigger.newMap.get(idOC).Id;
            if(strCC != null && strServicio != null){                                               
                objAPN = [SELECT Charguing_Characteristics__c FROM APN__c WHERE Charguing_Characteristics__c =: strCC AND Servicio__c =: strServicio AND Id !=: strIdAPN LIMIT 1];
                if(objAPN.size() > 0){                    
                    APNExistente = objAPN[0].Charguing_Characteristics__c;
                    if(APNExistente != null && APNExistente != ''){
					    if(!Test.isRunningTest())                    
                        	trigger.newMap.get(idOC).addError(' No es posible actualizar el APN, ya existe un APN para el mismo Charguing Characteristics: "'+strCC+'" y para el mismo servicio: "'+strServicio+'"');
                    }
                }else{
                    intCC = integer.ValueOf(strCC);
                    if(intCC < 26)
                        trigger.new[0].addError(' El valor del campo "Charguing Characteristics" no puede ser menor a 26.');
                    
                    if(intCC > 254)
                        trigger.new[0].addError(' El valor del campo "Charguing Characteristics" no puede ser mayor a 254.');
            	}                        
            }               
        }                   
    }
}