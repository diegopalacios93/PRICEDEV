/**
* @Author:      Rebeca Vazquez <rvazquez@labsxd.com>
* @Company:     LabsXD
* @Date:        06/04/2022
* @Reviewer:    
* @Review Date: 
* @Description: 
* -------------------------------------------------------------
*/

@isTest
public class etb_RedirectQuoteToESMTest {
    public class CustomException extends exception{}
    
    private static testMethod void testcreateQuote() {
       
           PageReference pageRef = new PageReference('/apex/vlocity_cmt__B2BCmexConfigureEnterpriseQuote');
                
                Account accountBusiness = new Account();
                    accountBusiness.Name = 'Account Billing';
                    accountBusiness.Type = 'Business';
                    accountBusiness.Phone = '12345678';
                    accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
                insert accountBusiness; 
                
                Opportunity opportunity = new Opportunity(
                    AccountId = accountBusiness.Id,
                    RecordTypeId = '01233000000IfwMAAS',
                    IsPrivate = false,
                    Name = 'Account for Testing',
                    StageName = 'Prospecting',
                    CloseDate = Date.newInstance(2022,04,30),
                    Amount = 100000.0,
                    Valor_unica_vez_ETB__c = 100.0,
                    Probability = 0.0,
                    ForecastCategoryName = 'En Construcción',
                    IsExcludedFromTerritory2Filter = false,
                    PDC__c = '20% - Probabilidad de Éxito',
                    Tipo_de_Operacion__c = 'Venta',
                    Tipo_de_Oportunidad__c = 'LTE'
                    );
                insert opportunity;
           
          test.startTest();
           Test.setCurrentPage(pageRef);
           pageRef.getParameters().put('Id',opportunity.Id);
           ApexPages.StandardController sc = new ApexPages.standardController(opportunity);
           ETB_RedirectQuoteToESM  controller = new ETB_RedirectQuoteToESM(sc);
           System.assertNotEquals(null,controller.createQuote());
           test.stopTest();
	}
    
}