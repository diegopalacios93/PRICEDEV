/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR FASE II
Descripción:        Clase que implementa los métodos para invocar los servicios InvokeServiceProvisioningOp,
					InvokeSubscriberProvisioningOp y ModifyBillingProfileOp de Tibco.
Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-01-12   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
public class PS_InvokeServicesProvisioningRev_cls {
    
      /*
	* @Método: 		InvokeServiceProvisioning
	* @Parámetros:	correlationID, OCId y docServices
	* @Descripción:	Método que realiza la invocación HTTP al servicio web InvokeServiceProvisioning de Tibco.
	*/
    
    public Dom.Document InvokeServiceProvisioning(String correlationID, String OCId, DOM.Document docServices)
    {
	
    	DOM.Document docRequest;
        DOM.Document docResponse;
        
        //Datos del servicio
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
        String endpoint = sw.EndPoint__c;
        String method = sw.Action__c;
        String soapenvPrefix = 'soapenv';
        String soapenvNamespace = 'http://schemas.xmlsoap.org/soap/envelope/';
        String requestHeaderPrefix = 'v1'; 
        String requestHeaderNamespace = 'http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0';
        String operationPrefix = 'inv'; 
        String operationNamespace = 'http://www.tibco.com/schemas/Services.Core/InvokeServiceProvisioningOp';
        String servicePrefix = 'ser';
        String serviceNamespace = 'www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/ServiceProvisioning';
        String schemaServiceInput= 'InvokeServiceProvisioningInput';
        
        System.debug('InvokeServiceProvisioning.endpoint--------->' + endpoint);
        System.debug('InvokeServiceProvisioning.metodo----------->' + method); 
       
        

        ///Creación documento para petición al servicio
        //Creación del encabezado y raiz del cuerpo
        docRequest = new DOM.Document();
        dom.XmlNode envelopeNode = docRequest.createRootElement('Envelope', soapenvNamespace, soapenvPrefix);
        dom.XmlNode headerNode = envelopeNode.addChildElement('Header', soapenvNamespace, soapenvPrefix);
        dom.XmlNode bodyNode = envelopeNode.addChildElement('Body', soapenvNamespace, soapenvPrefix);
        dom.XmlNode schemaServiceInputNode = bodyNode.addChildElement(schemaServiceInput, operationNamespace, operationPrefix);
        dom.XmlNode wsRequestHeader2Node = schemaServiceInputNode.addChildElement('WSRequestHeader2', requestHeaderNamespace, requestHeaderPrefix);
        dom.XmlNode systemNode= wsRequestHeader2Node.addChildElement('System', requestHeaderNamespace, requestHeaderPrefix);
        systemNode.addChildElement('name', requestHeaderNamespace, requestHeaderPrefix).addTextNode('Salesforce');
        systemNode.addChildElement('correlationID', requestHeaderNamespace, requestHeaderPrefix).addTextNode(correlationID);
        systemNode.addChildElement('processingServer', requestHeaderNamespace, requestHeaderPrefix).addTextNode('Tibco');
        dom.XmlNode bodyRequestNode= schemaServiceInputNode.addChildElement('BodyRequest', operationNamespace, operationPrefix);
        
        //Insertar Nodo de servicios
        
        dom.XmlNode servicesNode = docServices.getRootElement();
        dom.XmlNode servicesTempNode= bodyRequestNode.addChildElement('servicesTem', serviceNamespace, servicePrefix);
        bodyRequestNode.insertBefore(servicesNode, servicesTempNode);
        bodyRequestNode.removeChild(servicesTempNode);

        system.debug('InvokeServiceProvisioning.docRequest.toXmlString()--->'+ docRequest.toXmlString());
        
        //Invocar servicio  
             
        PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
        docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docRequest, method, endpoint);
        System.debug('InvokeServiceProvisioning.docResponse---------->' + docResponse.toXmlString()); 
        
        //Insertar log de envio de facturación
        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.AC_CorrelationID_Random__c = OCId;
        logServicio.LTE_Operacion_Comercial__c = OCId;
        logServicio.Informacion_Enviada__c = String.valueOf(docRequest.toXmlString()).length()>100000?String.valueOf(docRequest.toXmlString()).substring(0, 100000):String.valueOf(docRequest.toXmlString());
        logServicio.Name = 'Envio Facturación';
        logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString()).length()>100000?String.valueOf(docResponse.toXmlString()).substring(0, 100000):String.valueOf(docResponse.toXmlString());
        insert logServicio;
        
        return docResponse;

	}
    
    /*
	* @Método: 		ModifyBillingProfile
	* @Parámetros:	correlationID, OCId y docSubscribers
	* @Descripción:	Método que realiza la invocación HTTP al servicio web ModifyBillingProfile de Tibco.
	*/
    
     public Dom.Document ModifyBillingProfile(String correlationID, String OCId, DOM.Document docSubscribers)
    {
	
    	DOM.Document docRequest;
        DOM.Document docResponse;
        
        //Datos del servicio
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('ModificacionPerfilFacturacion');
        String endpoint = sw.EndPoint__c;
        String method = sw.Action__c;
        String soapenvPrefix = 'soapenv';
        String soapenvNamespace = 'http://schemas.xmlsoap.org/soap/envelope/';
        String requestHeaderPrefix = 'v1'; 
        String requestHeaderNamespace = 'http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0';
        String operationPrefix = 'mod'; 
        String operationNamespace = 'http://www.tibco.com/schemas/Services.Core/ModifyBillingProfileOp';
        String servicePrefix = 'sub';
        String serviceNamespace = 'www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/ModifyBillingProfile/SubscriberBillProfile';
        String schemaServiceInput= 'ModifyBillingProfileInput';
        
        System.debug('ModifyBillingProfile.endpoint--------->' + endpoint);
        System.debug('ModifyBillingProfile.metodo----------->' + method); 
       
        ///Creación documento para petición al servicio
        //Creación del encabezado y raiz del cuerpo
        docRequest = new DOM.Document();
        dom.XmlNode envelopeNode = docRequest.createRootElement('Envelope', soapenvNamespace, soapenvPrefix);
        dom.XmlNode headerNode = envelopeNode.addChildElement('Header', soapenvNamespace, soapenvPrefix);
        dom.XmlNode bodyNode = envelopeNode.addChildElement('Body', soapenvNamespace, soapenvPrefix);
        dom.XmlNode schemaServiceInputNode = bodyNode.addChildElement(schemaServiceInput, operationNamespace, operationPrefix);
        dom.XmlNode wsRequestHeader2Node = schemaServiceInputNode.addChildElement('WSRequestHeader2', requestHeaderNamespace, requestHeaderPrefix);
        dom.XmlNode systemNode= wsRequestHeader2Node.addChildElement('System', requestHeaderNamespace, requestHeaderPrefix);
        systemNode.addChildElement('name', requestHeaderNamespace, requestHeaderPrefix).addTextNode('Salesforce');
        systemNode.addChildElement('correlationID', requestHeaderNamespace, requestHeaderPrefix).addTextNode(correlationID);
        systemNode.addChildElement('processingServer', requestHeaderNamespace, requestHeaderPrefix).addTextNode('Tibco');
        dom.XmlNode bodyRequestNode= schemaServiceInputNode.addChildElement('BodyRequest', operationNamespace, operationPrefix);
        
        //Insertar Nodo de subscriptores
        
        dom.XmlNode subscribersNode = docSubscribers.getRootElement();
        dom.XmlNode subscribersTempNode= bodyRequestNode.addChildElement('servicesTem', serviceNamespace, servicePrefix);
        bodyRequestNode.insertBefore(subscribersNode, subscribersTempNode);
        bodyRequestNode.removeChild(subscribersTempNode);

        system.debug('ModifyBillingProfile.docRequest.toXmlString()--->'+ docRequest.toXmlString());
        
        //Invocar servicio  
             
        PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
        docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docRequest, method, endpoint);
        System.debug('InvokeServiceProvisioning.docResponse---------->' + docResponse.toXmlString()); 
        
        //Insertar log de envio de facturación
        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.AC_CorrelationID_Random__c = OCId;
        logServicio.LTE_Operacion_Comercial__c = OCId;
        logServicio.Informacion_Enviada__c = String.valueOf(docRequest.toXmlString());
        logServicio.Name = 'Envio Facturación';
        logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
        insert logServicio;
        
        return docResponse;

	}

}