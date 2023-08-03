trigger KnowledgeKavTrigger on Knowledge__kav (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        for(Knowledge__kav kav: trigger.new){
            if(kav.PublishStatus=='Draft'){
                kav.ValidationStatus='Nuevo';
            }
        }
    }
    
}