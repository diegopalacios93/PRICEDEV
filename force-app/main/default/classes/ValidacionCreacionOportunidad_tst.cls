/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
private class ValidacionCreacionOportunidad_tst {
    
    static testMethod void propietario() {
        // TO DO: implement unit test
        Id usuarioid = GeneraData_cls.generarUsuario();
        //system.runAs(GeneraData_cls.us){
        GeneraData_cls.generarData();
        
        //}
        
    }
    
    
    static testMethod void nocolaborado() {
        // TO DO: implement unit test
        Id usuarioid = GeneraData_cls.generarUsuario();
        Account cuenta = null;
        //system.runAs(GeneraData_cls.us){
        GeneraData_cls.generarData();
        cuenta = GeneraData_cls.acc;
        //}
        //crear otro usuario 
        Profile pro = [select id from Profile where name='Asesor Externos' limit 1];
        system.debug('==>Entrada generarUsuario()');
        User usu = new User();
        usu.LastName = 'testttetwss';
        usu.Alias = 'tteyst09';
        usu.Email = 'tester@email.com';
        string userRandom=Math.random()*1000+'userEtb@etb.com';
        usu.Username = userRandom;
        usu.CommunityNickname = 'tercintest';
        usu.TimeZoneSidKey = 'America/Bogota';
        usu.LocaleSidKey = 'es_CO';
        usu.EmailEncodingKey = 'ISO-8859-1';
        usu.ProfileId = pro.Id;
        usu.LanguageLocaleKey = 'es';
        usu.EsAsesor__c = true;
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert usu;
        }
        
        test.startTest();
        system.runAs(usu){
            
            try{
                Opportunity opp = new Opportunity();
                opp.AccountId=cuenta.Id;
                opp.Name = 'opptestestest';
                opp.CloseDate = System.today()+1;
                opp.StageName = 'En Estudio';
                //opp.OwnerId = Userinfo.getUserId();
                opp.Valor_unica_vez_ETB__c = 1;
                insert opp;
            }
            catch(system.Exception e)
            {
                system.debug('');
            }
        }
        
        test.stopTest();
        
    }
}