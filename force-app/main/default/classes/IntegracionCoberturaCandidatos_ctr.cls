public class IntegracionCoberturaCandidatos_ctr {
    @Invocablemethod(label='Integracion Candidato Cobertura')
    public static List<Lead> Integracion(List<Lead> lstLead) {
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Candidato Cobertura'];
        String sParamFields = lstMensajes.Mensaje__c;
        String leadId = lstLead[0].Id;
        String selectParametersQuery = 'SELECT ' + sParamFields + ' FROM Lead where Id =:leadId';
        List<Lead> lstLeadWithData = Database.query(selectParametersQuery);

        IntegracionCoberturaCandidatos_cls intCobCand = new IntegracionCoberturaCandidatos_cls();
        Map<Id,Map<String,Object>> mapDatos = intCobCand.GenerarDatamap(lstLeadWithData, 'Homologacion_Cobertura__mdt');
        String res = intCobCand.EnvioSuma(lstLeadWithData, mapDatos);
        return lstLeadWithData;
}
}