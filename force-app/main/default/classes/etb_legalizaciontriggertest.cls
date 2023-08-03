@isTest
public  class etb_legalizaciontriggertest {

    @isTest
    static void legalizacionTestSuccess(){
        Account cuent = new Account(Name = 'CuentaTestAccount');
        insert cuent;
        Contract cnt = new Contract(AccountId = cuent.id);
        insert cnt;
        User u = new User(ProfileId = '00e400000013zwhAAA', Username = 'johjkgkj@acme.com', LastName = 'jjjjjj', Email = 'johhyhuh@acme.com', Alias = 'jj', TimeZoneSidKey = 'America/Bogota', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'es', LocaleSidKey = 'es');
        Legalizacion__c lg = new Legalizacion__c(Contrato__c = cnt.id, Estado__c = 'Gestionado');
        insert lg;
        Order ord1 = new Order(Name = 'ordr1',Status = 'Ready to provision', AccountId = cuent.id, Legalizaci_n__c = lg.Id, EffectiveDate = Date.today(), ContractId = cnt.Id);
        insert ord1;

        Test.startTest();
        List<Legalizacion__c> legalist = new List<Legalizacion__c>();
        legalist.add(lg);
        etb_legalizacionHelper.legalizacionHelperMethod(legalist);
        Test.stopTest();

        Order newOrder = [SELECT id, Status FROM Order WHERE id = :ord1.id];
        System.assertEquals('En Aprovisionamiento', newOrder.Status);
    }

    @isTest
    static void legalizacionTestFailure(){
        Account cuent = new Account(Name = 'CuentaTestAccount');
        insert cuent;
        Contract cnt = new Contract(AccountId = cuent.id);
        insert cnt;
        User u = new User(ProfileId = '00e400000013zwhAAA', Username = 'johjkgkj@acme.com', LastName = 'jjjjjj', Email = 'johhyhuh@acme.com', Alias = 'jj', TimeZoneSidKey = 'America/Bogota', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'es', LocaleSidKey = 'es');
        Legalizacion__c lg = new Legalizacion__c(Contrato__c = cnt.id, Estado__c = 'Gestionado');
        insert lg;
        Order ord1 = new Order(Name = 'ordr1', Status = 'Ready to provision', AccountId = cuent.id, EffectiveDate = Date.today(), ContractId = cnt.Id);
        insert ord1;

        Test.startTest();
        List<Legalizacion__c> legalist = new List<Legalizacion__c>();
        legalist.add(lg);
        etb_legalizacionHelper.legalizacionHelperMethod(legalist);
        Test.stopTest();

        Order newOrder = [SELECT id, Status FROM Order WHERE id = :ord1.id];
        System.assertEquals('Ready to provision', newOrder.Status);
    }
}