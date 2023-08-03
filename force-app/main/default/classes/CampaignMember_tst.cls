@isTest
private class CampaignMember_tst {
    
    static testMethod void CampaignMember() {
    	
    	objPruebas_tst obj =new objPruebas_tst();
    	map<String,Schema.RecordTypeInfo> rt= Schema.SObjectType.Account.getRecordTypeInfosByName();
    	//.get('Cliente Principal').getRecordTypeId();
    	
    	
    	//Sucursales
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =rt.get('Cliente Principal').getRecordTypeId();
    	insert cliente;

    	Contact contacto=obj.objContact();
    	contacto.AccountId=cliente.id;
    	insert contacto;

    	Campaign Campana=new Campaign(name='nueva');
    	insert Campana;

    	CampaignMember miembroCampana=new CampaignMember ();
    	miembroCampana.CampaignId=Campana.id;
    	miembroCampana.ContactId=contacto.id;
    	insert miembroCampana;

    	update miembroCampana;


    }
}