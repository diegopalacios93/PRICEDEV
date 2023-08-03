@isTest
public class Article_Rating_Controller_Test {
	@istest
    Public static void metodoTst(){
        Historial_de_articulos__c hda = New Historial_de_articulos__c();
        hda.Calificaci_n__c = 'like';
        hda.Comentario__c = 'Comentario de prueba articulo';
        test.startTest();
        Article_Rating_Controller.CreaRegistro(hda,'92.0.4515.131','Chrome 92.0.4515.131 on Windows 10 64-bit','Chrome','DESKTOP');
        test.stopTest();
    }
}