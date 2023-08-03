@isTest
public class Vista_Cliente_tst {
	
	static testMethod void Vista_Cliente(){
		
		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
		
		Perfiles_Acciones__c pa=new Perfiles_Acciones__c(name='accesoVistaCliente',Usuarios__c=UserInfo.getProfileId());
		insert pa;
		
		objPruebas_tst obj =new objPruebas_tst();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;
    	
    	Manejo_de_ofertas__c mO=New Manejo_de_ofertas__c(
    		Numero_de_Identificacion__c=cliente.AccountNumber
    		);
    	insert mO;
    	
    	PageReference pageRef0 = Page.Vista_Cliente_detalle;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', cliente.AccountNumber);
        
        Test.startTest();
        
        Vista_Cliente_ctr vc=new Vista_Cliente_ctr();
        vc.Guardar();
        vc.Aceptar();
        vc.Ver();
        
        Test.stopTest();
    	
    	
	
	}

}