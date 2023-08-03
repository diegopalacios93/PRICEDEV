/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Evita la eliminacion de adjuntos
Descripción:			Test Evita la eliminacion de adjuntos
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		15-04-2015	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/

@isTest
private class Attachment_tst {
	
	static testMethod void AttachDelete() {

		objPruebas_tst obj =new objPruebas_tst();

		string admin =UserInfo.getProfileId();

        objPruebas_tst.confPersonalizadas();

        Profile p = [SELECT Id FROM Profile WHERE Name='Soporte a Ventas'];
        
        string userRandom=Math.random()*1000+'userEtb@etb.com';
        system.debug(userRandom);
        
        User u2 = new User(Alias = 'ETbUser', Email=userRandom, 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName=userRandom);
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            insert u2;
        }
        List<SObject> inConf=new List<SObject>();
        string pString=p.Id;
        inConf.add(new ConfPerfilesOportunidad__c(Name=pString.substring(0,15)));
        insert inConf;



    	Account cliente=obj.ObjAccount();
    	cliente.AccountNumber='1234567890';
    	cliente.Tipodedocumento__c='Cédula de ciudadanía';
    	cliente.OwnerId=u2.id;
    	insert cliente;

        Opportunity objOpt=obj.objOpt();
        objOpt.AccountId=cliente.id;
        objOpt.StageName='Cerrada perdida';
        objOpt.CausaldePerdida__c='it happens';
        objOpt.OwnerId=u2.id;
        insert objOpt;

        Legalizacion__c objLeg=obj.objLeg();
        objLeg.Estado__c='Gestionado';
        objLeg.Fecha_de_solicitud_cliente__c=date.today();
        insert objLeg;

		Attachment adjunto =new Attachment();
        adjunto.Body=blob.valueOf('PRUEBA');
        adjunto.Name='test_file.txt';
        adjunto.ParentId=objOpt.id;
        adjunto.OwnerId=u2.id;


        Attachment adjunto2 =new Attachment();
        adjunto2.Body=blob.valueOf('PRUEBA');
        adjunto2.Name='test_file.txt';
        adjunto2.ParentId=objLeg.id;
        adjunto2.OwnerId=u2.id;

        update cliente;

        insert new list<Attachment>{adjunto2,adjunto};
        
       Test.startTest();
       System.runAs(u2){
        list<Attachment> a=new list<Attachment>([select id from Attachment]);
        Database.DeleteResult[] DR_Dels = Database.delete(a, false);

       }
        
        Test.stopTest();
		
	}

}