public class NuevoACO_ctr {
    @AuraEnabled
    public static String getAccountId(String oppId){
        Opportunity opp = [SELECT AccountId FROM Opportunity WHERE Id =: oppId LIMIT 1];
        return opp.AccountId;
    }
}