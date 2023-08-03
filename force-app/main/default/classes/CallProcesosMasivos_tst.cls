@isTest
public class CallProcesosMasivos_tst {
    public static Account objAccount;
    public static Procesos_Masivos__c p;
    @isTest
    static void testUnit1(){
        CallProcesosMasivos call;	 
        Test.startTest();
        	p = new Procesos_Masivos__c();
            p.Proceso_a_ejecutar__c = 'Suspender';
            p.Fecha_de_inicio__c = Date.today();
            p.Fecha_inicio_suspension__c = Date.today()+10;
            p.Fecha_inicio_reconexion__c = Date.today()+40;
            p.Estado_del_proceso__c = 'Pendiente';
            insert p;	
            PageReference pageRef = Page.CallProcesosMasivosVF;
            Test.setCurrentPage(pageRef);
       		ApexPages.currentPage().getParameters().put('id', p.Id);
        	call = new CallProcesosMasivos(new Apexpages.Standardcontroller(p));
        	
       		call.runBatch();
        
        Test.stopTest();
    }
}