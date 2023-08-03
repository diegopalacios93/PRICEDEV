public class CotizacionAvanzadaTriggerHandler {
    
    public static void beforeInsert(List<ETB_CotizacionAvanzada__c> lPIDnew) {
        CotizacionAvanzadaTriggerService.getBW(lPIDnew);
    }
    public static void beforeUpdate(List<ETB_CotizacionAvanzada__c> lPIDnew) {
        CotizacionAvanzadaTriggerService.updateCostosConectividad(lPIDnew);
    }
}