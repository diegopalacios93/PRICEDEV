public class Article_Rating_Controller {
	@AuraEnabled
    public static void CreaRegistro (Historial_de_articulos__c SObj,String vnav,String dnav,String nnav,String disp){
        system.debug('CreaRegistro');
        system.debug('correo electronico: '+SObj.Correo_Electronico__c);
        system.debug('comentarios: '+SObj.Comentario__c);
        system.debug('calificación: '+SObj.Calificaci_n__c);
        system.debug('articulo id: '+SObj.Articulo_de_base_de_conocimiento__c);
        system.debug('Versión de navegador:'+vnav);
        system.debug('Descripción de navegador:'+dnav);
        system.debug('Nombre del navegador:'+nnav);
        system.debug('Dispositivo:'+disp);
        
        Historial_de_articulos__c ha = New Historial_de_articulos__c();
        ha.Correo_Electronico__c = SObj.Correo_Electronico__c;
        ha.Comentario__c = SObj.Comentario__c;
        ha.Calificaci_n__c = SObj.Calificaci_n__c;
        ha.Articulo_de_base_de_conocimiento__c = SObj.Articulo_de_base_de_conocimiento__c;
        ha.Version_de_navegador__c = vnav;
        ha.Descripci_n_de_navegador__c = dnav;
        ha.Nombre_de_navegador__c = nnav;
        ha.Dispositivo__c = disp;
        insert ha; 
    }
    
}