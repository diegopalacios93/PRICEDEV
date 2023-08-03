@isTest
public class ETB_ServiceProvisioningTest {
    
    @isTest
    private static void serviceProvisioningTest() {
        
        String jsonEntrada = '{'+
	'"accounts": {'+
		'"idBussines": "001780000068LREAA2",'+
		'"billingAccounts": [{'+
			//	'"Id": "'+accountBilling.Id+'",'+
				'"numberBillingAccount": "Revchain-000001",'+
				'"ciclodeFacturacion": "Ciclo 5"'+
			'}'+
		']'+
	'},'+
	'"items": [{'+
			//'"idItem": "'+orderItemPlan.Id+'",'+
			'"parentId": null,'+
			'"engineer": "Sandra Milena",'+
			'"groupAssigment": "Conectividad Avanzada",'+
			'"statusProvisioning": "provisioned",'+
			'"comments": "Aprovisionado exitoso",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": "2022-06-01",'+
            '"idService":"Ser-00333",'+
            '"agendamiento": null,'+
			'"billingStartDate": null,'+
			'"listaConfiguraciones": {'+
				'"quantity": "1",'+
				'"parametros": [{'+
                    '"atributo": "ATT_Ancho de Banda",'+
                    '"valor": "15MB"'+
                  '}'+
				']'+
			'}'+
		'},'+
		'{'+
			//'"idItem": "'+orderItemPlan2.Id+'",'+
			'"parentId": "8023K000001uDimQAE",'+
			'"engineer": "ELIANA MARCELA RICO VARGAS",'+
			'"groupAssigment": "Equipo Avanzado",'+
			'"statusProvisioning": "En Aprovisionamiento",'+
			'"comments": "Se acuerda agendamiento",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": null,'+
            '"idService":null,'+
            '"agendamiento":{'+
                '"agendaDate": "2022-06-03",'+
                '"agendaStrip": "Tarde",'+
                '"agendastatus": "Agendado"'+
            '},'+
			'"billingStartDate": null,'+
			'"listaConfiguraciones": null'+
		'},'+
		'{'+
		//	'"idItem": "'+orderItemPlan3.Id+'",'+
			'"parentId": null,'+
			'"engineer": "JORGE LUIS LOZANO LARIOS",'+
			'"groupAssigment": "Conectividad Avanzada",'+
			'"statusProvisioning": "Facturando",'+
			'"comments": "Se inicia facturacion",'+
			'"statusGestor": null,'+
			'"causalDecline": null,'+
			'"provisioningDate": "2022-05-31",'+
            '"idService":"Ser-00322",'+
            '"agendamiento":null,'+
			'"billingStartDate": "2022-06-01",'+
			'"listaConfiguraciones": null'+
		'}'+
	']'+
'}';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Cases/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(jsonEntrada); 
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        ETB_ServiceProvisioning.ServiceProvisioning() ;     
        Test.stopTest();
        
        System.assertEquals(true,String.isNotBlank(String.valueof(response.statusCode)));
        System.assertEquals(200,response.statusCode);        
    }   

       
}