public class cancelarCun_ctr{

	public string id{get;set;}
	public string tipologia{get;set;}

	public cancelarCun_ctr(){

	}

	public List<SelectOption> getItems() {
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Tipología Exenta','Tipología Exenta'));
        options.add(new SelectOption('Falla de Software','Falla de Software'));
        return options;
    }

	public void guardar(){

		id = ApexPages.currentPage().getParameters().get('id');

		system.debug(id);

		list<case> caso=new list<case>([SELECT Tipologia__c,CaseNumber,CreatedDate,Id,CodigouniconumericoCUN__c,Account.Tipodedocumento__c,Account.AccountNumber FROM Case where id=:id]);

		if(caso[0].CodigouniconumericoCUN__c==null){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El caso seleccionado no contiene CUN'));
			return;
		}

		cancelarCun__c cc =new cancelarCun__c(NumOrden__c=caso[0].CaseNumber,FechaPQR__c=caso[0].CreatedDate,
		Tipologia__c=tipologia,UsuCreador__c=UserInfo.getUserId(),NumCun__c=caso[0].CodigouniconumericoCUN__c, idS__c=caso[0].id,
		Estado_Envio__c='Pendiente',
		TipoIdentificacionCI__c=caso[0].Account.Tipodedocumento__c,
		IdentificacionCI__c=caso[0].Account.AccountNumber);

		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Se ha enviado la anulacion'));

		upsert cc idS__c;
	}


}