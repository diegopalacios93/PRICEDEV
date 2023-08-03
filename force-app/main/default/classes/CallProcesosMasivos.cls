public class CallProcesosMasivos {
    public Id recordId {get;set;}  
    public CallProcesosMasivos(ApexPages.StandardController controller) {
        recordId  = ApexPages.currentPage().getParameters().get('id');       
    } 

    public pageReference runBatch() {
        Procesos_Masivos__c pm = new Procesos_Masivos__c();
        pm.Id = recordId;
        pm.Estado_del_proceso__c = 'En Ejecución';
        update pm;
        String id = String.valueOf(recordId);
        
        Database.executeBatch(new ProcesosMasivos_bch(id), 100);
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Proceso masivo ejecutado!'));
        PageReference pg = new PageReference('/'+ recordId);  
        system.debug('aqui entro' + pg);
        pg.setRedirect(true);
        return pg;
    }

}