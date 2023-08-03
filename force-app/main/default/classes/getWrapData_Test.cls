@isTest
public class getWrapData_Test {
    @istest
    public static void test1(){
        Knowledge__kav kav = New knowledge__kav();
        kav.Question__c = '¿Pregunta de prueba?';
        kav.Answer__c = 'Respuesta prueba';
        kav.Title = 'Titulo de prueba';
        kav.Subtitulo__c='Subtitulo prueba';
        kav.UrlName='Titulo-de-prueba';
        kav.ValidationStatus='Nuevo';
        kav.IsVisibleInCsp=true;
        kav.IsVisibleInPrm=true;
        insert kav;
        test.startTest();
        List<Id>idsApprovers = New List<Id>();
        idsApprovers.add(id.valueof(userinfo.getUserId()));
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
		app.setObjectId(kav.id);
        app.setNextApproverIds(idsApprovers);
		Approval.ProcessResult result = Approval.process(app);
		List<getWrapData.wrapperClass>ListaWP = New List<getWrapData.wrapperClass>();
        ListaWP=getWrapData.WrapList();
        test.stopTest();
        
    }
}