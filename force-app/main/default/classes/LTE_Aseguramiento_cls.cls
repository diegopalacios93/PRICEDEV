/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Andres Oliva, Carlos Rodriguez. 
Project:                ETB-LTE   
Description:            Clase encargada de armar los xml para el consumo de los servicios web de plib y remedy.                         
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     31/07/2015  Andres Oliva, Carlos Rodriguez. Class creation.
1.1     07/07/2016  CArlos Gonzalez					Adición Campo Remedy.
*******************************************************************************/

public class LTE_Aseguramiento_cls 
{
	public LTE_Aseguramiento_cls() 
	{		
	}

	/**
    *   @Method: Plib
    *   @param objCase: caso que se va a registrar en el servicio web.      
    *   @param objDatosPlib: objeto que contiene los datos requeridos por el servicio web de plib y que necesitaron algun tratamiento.
    *   @return String: XML de request.
    *   @description: Se encarga de crear el string que contiene el XML para el consumo del servicio web de plib. 
    */
	public static String Plib(Case objCase, LTE_Plib_ctr.DatosPlib objDatosPlib)
	{
		String strXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/DeviceManagement/CreateServiceOrder/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/LogisticsOperator/InputCreateServiceOrder">'
						+'   <soapenv:Header/>'
						+'   <soapenv:Body>'
						+'      <ns:WSInputCreateServiceOrder>'
						+'         <v1:WSRequestHeader>'
						+'            <v1:System correlationID="' + objDatosPlib.strCorrelationId + '" processingServer=""></v1:System>'
						+'            <v1:Property name="" value=""></v1:Property>'
						+'         </v1:WSRequestHeader>'
						+'         <inp:InputCreateServiceOrder>'
						+'            <inp:orderId>' + objCase.CaseNumber + '</inp:orderId>'
						+'            <inp:brand>' + objCase.LTE_Marca__c + '</inp:brand>'
						+'            <inp:model>' + objCase.LTE_ModeloComercial__c + '</inp:model>'
						+'            <inp:imei>' + objCase.LTE_IMEI__c + '</inp:imei>'
						+'            <inp:businessLine>' + objDatosPlib.strGarantia + '</inp:businessLine>'
						+'            <inp:origin>' + objCase.LTE_Origen__c + '</inp:origin>'
						+'            <inp:fault>' + objDatosPlib.strFalla + '</inp:fault>'
						+'            <inp:telephone>' + objCase.NumeroConexion__c + '</inp:telephone>'
						+'            <inp:coments>' + objCase.LTE_Comentarios__c + '</inp:coments>'
						+'            <inp:loanerBrand>' + label.LTE_PlibLoanerBrand + '</inp:loanerBrand>'
						+'            <inp:loanerModel>' + label.LTE_PlibLoanerModel + '</inp:loanerModel>'
						+'            <inp:LoanerImei>' + label.LTE_PlibLoanerImei + '</inp:LoanerImei>'
						+'            <inp:purchaseDate>' + objDatosPlib.strFechaCompra + '</inp:purchaseDate>'
						+'            <inp:clientName>' + objCase.Account.Name + '</inp:clientName>'
						+'            <inp:contactPhone>' + objCase.Contact.Phone + '</inp:contactPhone>'
						+'            <inp:contactPhone2></inp:contactPhone2>'
						+'            <inp:clientePlan>' + 'POSPAGO' + '</inp:clientePlan>'
						+'         </inp:InputCreateServiceOrder>'
						+'      </ns:WSInputCreateServiceOrder>'
						+'   </soapenv:Body>'
						+'</soapenv:Envelope>';
		return strXml;
	}

	/**
    *   @Method: remedy
    *   @param objCase: caso que se va a registrar en el servicio web.      
    *   @param 
    *   @return String: XML de request.
    *   @description: Se encarga de crear el string que contiene el XML para el consumo del servicio web de remedy. 
    */
	public static string remedy(Case objCases, String strCorrelationId, String strFechaIncidente,String strFuenteIncidente) 	{
		      String strXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/BillingCorporate/CreateIncident/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/BillingCorporate/InputCreateIncident">'
						+'   <soapenv:Header/>'
						+'   <soapenv:Body>'
						+'      <ns:WSInputCreateIncident>'
						+'         <v1:WSRequestHeader>'
						+'            <v1:System correlationID="' + strCorrelationId + '" processingServer="?">?</v1:System>'
						+'            <!--Zero or more repetitions:-->'
						+'            <v1:Property name="?" value="?">?</v1:Property>'
						+'         </v1:WSRequestHeader>'
						+'         <inp:InputCreateIncident>'
						+'            <inp:incident>'
						+'               <inp:notes>' + (String.isBlank(objcases.Description)?objcases.Description:objcases.Description.replaceAll('<[^>]*>', '')) + '</inp:notes>'
						+'               <inp:operationalCategoryLevel1>' + objcases.Agrupacion__c + '</inp:operationalCategoryLevel1>'
						+'               <inp:operationalCategoryLevel2>' + objcases.Proceso__c + '</inp:operationalCategoryLevel2>'
						+'               <inp:operationalCategoryLevel3>' + objcases.Tipologia__c + '</inp:operationalCategoryLevel3>'
						+'               <inp:impact></inp:impact>'
						+'               <inp:priority></inp:priority>'
						+'               <inp:registeredSource>'+ strFuenteIncidente + '</inp:registeredSource>'
						+'               <inp:orderID>' + objcases.CaseNumber + '</inp:orderID>'
					    +'               <inp:CUN>' + objcases.CodigouniconumericoCUN__c + '</inp:CUN>'
						+'               <inp:moleculaID></inp:moleculaID>'
						+'               <inp:issueDate>' + strFechaIncidente + '</inp:issueDate>'
						+'               <inp:lteMobileNumber></inp:lteMobileNumber>'
					    +'               <inp:IN_Tecnologia>LTE</inp:IN_Tecnologia>' // [CG] - Adicion del campo IN_Tecnologia
						+'               <inp:customer>'
						+'                  <inp:accountID>' + objcases.Account.AccountNumber + '</inp:accountID>'
						+'                  <inp:name>' + objcases.Account.Name + '</inp:name>'
						+'                  <inp:lastName>' + objcases.Account.Name + '</inp:lastName>'
						+'                  <inp:phoneNumber>' + objcases.Account.Phone + '</inp:phoneNumber>'
						+'                  <inp:email></inp:email>'
						+'                  <inp:normalizedAddress>' + objcases.Account.Direccion__c + '</inp:normalizedAddress>'
						+'                  <inp:noNormalizedAddress>' + objcases.Account.Direccion__c + '</inp:noNormalizedAddress>'
						+'                  <inp:accountName>' + objcases.Account.Name + '</inp:accountName>'
						+'                  <inp:identificationType>' + objcases.Account.Tipodedocumento__c + '</inp:identificationType>'
						+'                  <inp:identificationNumber>' + objcases.Account.AccountNumber + '</inp:identificationNumber>'
						+'                  <inp:zone></inp:zone>'
						+'                  <inp:countryCode></inp:countryCode>'
						+'                  <inp:stateCode></inp:stateCode>'
						+'                  <inp:cityCode></inp:cityCode>'
						+'               </inp:customer>'
						+'               <inp:contact>'
						+'                  <inp:name>' + objcases.Contact.Name + '</inp:name>'
						+'                  <inp:lastName></inp:lastName>'
						+'                  <inp:email>' + objcases.Contact.Email + '</inp:email>'
						+'                  <inp:phoneNumber>' + objcases.Contact.Phone + '</inp:phoneNumber>'
						+'               </inp:contact>'
						+'               <inp:service>'
						+'                  <inp:serviceID>' + objcases.LTE_Servicio__r.Id + '</inp:serviceID>'
						+'                  <inp:accountID></inp:accountID>'
						+'                  <inp:gisAddressID></inp:gisAddressID>'
						+'                  <inp:address>' + objcases.LTE_Servicio__r.SucursalDestino__r.Direccion__c + '</inp:address>'
						+'                  <inp:zone></inp:zone>'
						+'                  <inp:addressLatitude></inp:addressLatitude>'
						+'                  <inp:addressLength></inp:addressLength>'
						+'                  <inp:noNormalizedAddress></inp:noNormalizedAddress>'
						+'                  <inp:countryCode></inp:countryCode>'
						+'                  <inp:stateCode></inp:stateCode>'
						+'                  <inp:cityCode></inp:cityCode>'
						+'               </inp:service>'
						+'            </inp:incident>'
						+'         </inp:InputCreateIncident>'
						+'      </ns:WSInputCreateIncident>'
						+'   </soapenv:Body>'
						+'</soapenv:Envelope>';
		return strXml;		
	}

	
}