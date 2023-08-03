public class IntegracionCobertura_ctr {
    public String currentRecordId {get;set;}
    public List<Account> acc {get;set;}

    public IntegracionCobertura_ctr(ApexPages.StandardController stdController){
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');        
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Cuenta Cobertura'];
        String sParamFields = lstMensajes.Mensaje__c;
        String selectParametersQuery = 'SELECT ' + sParamFields + ' FROM Account where Id = :currentRecordId';
        List<Account> lstCaso = Database.query(selectParametersQuery);
        acc=lstCaso;     
    }
	
    public void generarIntegracion() {
        IntegracionCobertura_cls claseIntCob = new IntegracionCobertura_cls();
        Map<Id,Map<String,Object>> mapDatos = claseIntCob.GenerarDatamap(acc, 'Homologacion_Cobertura__mdt');
        String res = claseIntCob.EnvioSuma(acc, mapDatos);
        Account accActualizada = [SELECT Descripcion_cobertura__c,Tipo_de_Distancia__c,Tecnologia__c FROM Account where Id =:currentRecordId];
    }

    public PageReference Save() {
        PageReference pg = new PageReference('/'+acc[0].Id);
        pg.setRedirect(true);
        return pg;
    }
    @Invocablemethod(label='Integracion Cobertura')
    public static List<Account> Integracion(List<Account> lstAccount) {
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Cuenta Cobertura'];
        String sParamFields = lstMensajes.Mensaje__c;
        String accid = lstAccount[0].Id;
        String selectParametersQuery = 'SELECT ' + sParamFields + ' FROM Account where Id =:accid';
        List<Account> lstAccountWithData = Database.query(selectParametersQuery);

        IntegracionCobertura_cls claseIntCob = new IntegracionCobertura_cls();
        Map<Id,Map<String,Object>> mapDatos = claseIntCob.GenerarDatamap(lstAccountWithData, 'Homologacion_Cobertura__mdt');
        String res = claseIntCob.EnvioSuma(lstAccountWithData, mapDatos);
        return lstAccountWithData;
    }
}