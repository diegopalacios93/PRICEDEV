trigger CotizacionAvanzadaTrigger on ETB_CotizacionAvanzada__c (before insert, before update) {
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            CotizacionAvanzadaTriggerHandler.beforeInsert(trigger.new);
        }
        if(Trigger.isUpdate) {
            List<ETB_CotizacionAvanzada__c> cotizacionesUpdate = new List<ETB_CotizacionAvanzada__c>();
            for( ETB_CotizacionAvanzada__c cotizacion : Trigger.new) {
                    cotizacionesUpdate.add(cotizacion);
            }if(!cotizacionesUpdate.isEmpty()){
            	CotizacionAvanzadaTriggerHandler.beforeUpdate(cotizacionesUpdate);
            }
        }
    }
}