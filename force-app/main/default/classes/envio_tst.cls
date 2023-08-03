@isTest
public class envio_tst {
        static testMethod void ConsultaCun() {
    	
    	List<sObject> ls = Test.loadData(CUN_Center_Abajo__c.sObjectType, 'ConfCUN');
    	List<sObject> ls2 = Test.loadData(ServiciosWeb__c.sObjectType, 'ServiciosWeb');
    	    	
    	GeneraData_cls.generarData();
    	
    	Legalizacion__c Legalizacion=GeneraData_cls.generarLegalizacion2();
    	
		Legalizacion__c Legalizacion2=GeneraData_cls.generarLegalizacion2();
    	Legalizacion2.CodigouniconumericoCUN__c='0123456789012345';
    	
    	Legalizacion__c Legalizacion3=GeneraData_cls.generarLegalizacion2();
    	Legalizacion3.CodigouniconumericoCUN__c='0123456789012345';
    	Legalizacion3.Estado__c='Gestionado';
    	
    	insert new list<Legalizacion__c>{Legalizacion,Legalizacion2,Legalizacion3};
    	
    	PageReference pageRef0 = Page.ConsultaCun_pag;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', Legalizacion.id);
        
        ConsultaCun_ctr Cun = new ConsultaCun_ctr();
        Cun.ObtenerConf();
        Cun.tipo='manual';
        Cun.ConsultarCun();
        Cun.cunManual='1234567890123456';
        Cun.ConsultarManual();
        
        //Guarda cola nuevo
        Cun.cunFallido(true);
        Cola_CUN__c laCola=[select id from Cola_CUN__c limit 1];
        laCola.Reenviar_Correo__c=true;
        update laCola;
            
        envio_cls.enviar();
        
        

            
        }

}