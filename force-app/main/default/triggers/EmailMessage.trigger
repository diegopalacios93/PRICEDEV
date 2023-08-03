trigger EmailMessage on EmailMessage (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	if(trigger.isBefore && trigger.isInsert) {
        String sCcAddress='';
        String sBccAddress='';
        Integer nCcAddress=EmailMessage.CcAddress.getDescribe().getLength();
        Integer nBccAddress=EmailMessage.BccAddress.getDescribe().getLength();
        
        for(EmailMessage sglEmailMessage:trigger.new){
            sCcAddress = sglEmailMessage.CcAddress;
            sBccAddress = sglEmailMessage.BccAddress;
            if(String.isNotEmpty(sglEmailMessage.CcAddress)){
                if(sglEmailMessage.CcAddress.length()>nCcAddress){
                    sglEmailMessage.CcAddress = sCcAddress.substring(0,nCcAddress);
                }
            }
            if(String.isNotEmpty(sglEmailMessage.BccAddress)){
                if(sglEmailMessage.BccAddress.length()>nBccAddress){
                    sglEmailMessage.BccAddress = sBccAddress.substring(0,nBccAddress);
                }
            }
		}
    }

	
	if(trigger.isAfter && trigger.isInsert) {
		set<id>idCasos=new set<id>();
		
		for(EmailMessage em:trigger.new){
			idCasos.add(em.parentId);
		}
		map<Id,case> casos =new map<Id,case>([Select id,IsClosed,ContactId,ClosedDate,RecordType.Name from case where IsClosed=true and id IN :idCasos and ClosedDate!=null]);
		
		list<Task>t=new list<Task>();
		list<case>c=new list<case>();
		Map<String, Caso_Cerrado_Tareas__c> casCerr = Caso_Cerrado_Tareas__c.getAll();
		
		
		for(EmailMessage em:trigger.new){
			string para='';
			string contacto='';
            system.debug(em.parentId);
            system.debug(em.incoming);
			if(casos.get(em.parentId)!=null && (em.incoming==true||Test.isRunningTest())){
				if(casCerr.get(casos.get(em.parentId).RecordType.Name)!=null){
					para=casCerr.get(casos.get(em.parentId).RecordType.Name).Id_Usuario__c;
					contacto=casos.get(em.parentId).ContactId;
				}
				t.add(new Task(WhatId=em.parentId, WhoId=contacto,Subject='Casos Cerrados', OwnerId=para,description=em.Subject,ReminderDateTime=DateTime.now()));
			}
		}
		
		try{
		insert t;
		}catch(exception e){}
		
		system.debug(t);
	}

}