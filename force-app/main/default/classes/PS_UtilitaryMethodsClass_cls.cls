/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR FASE II
Descripción:        Clase que implementa los métodos genéricos de integración con Revchain.

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-01-12   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
public class PS_UtilitaryMethodsClass_cls {
    
    /*
	* @Método: 		InvokeServiceRequestDOM
	* @Parámetros:	Dom.Document , Metodo y Endpont
	* @Descripción:	Método que realiza la invocación HTTP al servicio web externo.
	*/
    	
	public Dom.Document InvokeServiceRequestDOM(Dom.Document docInput,string metodo,string endpoint){
    	
        Dom.Document docOutput; 
        HttpResponse res;
        string errorCode = '001';
        string statusFail = 'FAIL';
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        req.setBodyDocument(docInput);
        req.setEndpoint(endpoint);

        try {                
           	res = h.send(req);
            system.debug('InvokeServiceRequest.res.getStatusCode()--->'+ res.getStatusCode());
            if(res.getStatusCode()<400){
              	docOutput = res.getBodyDocument();
                String xmlString_OK = docOutput.toXmlString();
                system.debug('InvokeServiceRequest.xmlString_OK--->'+ xmlString_OK);                    
            }else{
                DOM.Document docElse = new DOM.Document();
                dom.XmlNode Envelope = docElse.createRootElement('Envelope', null, null);
                dom.XmlNode Body= Envelope.addChildElement('Body', null, null);
                dom.XmlNode SchemaServiceOutput= Body.addChildElement('SchemaServiceOutput', null, null);
                dom.XmlNode WSResponseHeader2= SchemaServiceOutput.addChildElement('WSResponseHeader2', null, null);
                dom.XmlNode Service= WSResponseHeader2.addChildElement('Service', null, null);
                Service.addChildElement('status', null, null).addTextNode(statusFail);
                dom.XmlNode statusDetail= Service.addChildElement('statusDetail', null, null);
                statusDetail.addChildElement('errorCode', null, null).addTextNode(errorCode); 
                system.debug(res);
                statusDetail.addChildElement('errorMessage', null, null).addTextNode(String.valueOf(res.getStatus()));
                string xmlString = docElse.toXmlString();
                system.debug('InvokeServiceRequest.xmlstring_else--->'+ xmlString);
                docOutput=docElse;
             }
           }catch(System.CalloutException e) {  	   
	            DOM.Document docCatch = new DOM.Document();
                dom.XmlNode Envelope = docCatch.createRootElement('Envelope', null, null);
                dom.XmlNode Body= Envelope.addChildElement('Body', null, null);
                dom.XmlNode SchemaServiceOutput= Body.addChildElement('SchemaServiceOutput', null, null);
                dom.XmlNode WSResponseHeader2= SchemaServiceOutput.addChildElement('WSResponseHeader2', null, null);
                dom.XmlNode Service= WSResponseHeader2.addChildElement('Service', null, null);
                Service.addChildElement('status', null, null).addTextNode(statusFail);
                dom.XmlNode statusDetail= Service.addChildElement('statusDetail', null, null);
                statusDetail.addChildElement('errorCode', null, null).addTextNode(errorCode); 
                statusDetail.addChildElement('errorMessage', null, null).addTextNode(e.getMessage());  
                String xmlString = docCatch.toXmlString();
                system.debug('InvokeServiceRequest.xmlstring_catch--->'+ xmlString);
                docOutput=docCatch;
             }
           return docOutput;
       }
    
	public static Dom.XMLNode getNodeFromDomDocument(Dom.Document doc, String nodeName)
    {

        System.debug('getNodeFromDomDocument.nodeName--------->' + NodeName); 
        Dom.XMLNode responseNode;
        Dom.XMLNode rootNode;
        DOM.Document docDefault = new DOM.Document();
        dom.XmlNode defaultNode = docDefault.createRootElement('Vacio', null, null);
        string NodoEncontrado = 'false';
  
        rootNode = doc.getRootElement();
        //System.debug('RootNode.getName(): ' + RootNode.getName());
        
        if(rootNode.getName() == nodeName ){
        	responseNode =  RootNode; 
            NodoEncontrado = 'true';
        }else{
            if(NodoEncontrado == 'false'){
                for(Dom.XMLNode child: rootNode.getChildElements()) {
                //System.debug('child.getName(): ' + child.getName());
                    if(child.getName() == nodeName && NodoEncontrado == 'false'){
                        //System.debug('child.getName(): ' + child.getName() + ' nodeName: ' + nodeName);
                        responseNode = child;
                        NodoEncontrado = 'true';
                        //System.debug('child.getName(): ' + child.getName() + ' nodeName: ' + nodeName + ' NodoEncontrado: ' + NodoEncontrado);
                    }else{
                        if(NodoEncontrado == 'false'){
                            //System.debug('child.getAttributeCount() : ' + child.getAttributeCount());
                            for(Dom.XMLNode child1: child.getChildElements()) {
                                //System.debug('child1.getName(): ' + child1.getName());
                                    if(child1.getName() == nodeName && NodoEncontrado == 'false'){
                                        //System.debug('If child1.getName(): ' + child1.getName() + ' nodeName: ' + nodeName);
                                        responseNode = child1;
                                        NodoEncontrado = 'true';
                                        //System.debug('child1 responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                    }else{
                                        if(NodoEncontrado == 'false'){
                                            //System.debug('child1.getAttributeCount() : ' + child1.getAttributeCount());
                                            for(Dom.XMLNode child2: child1.getChildElements()) {
                                                //System.debug('child2.getName(): ' + child2.getName());
                                                if(child2.getName() == nodeName && NodoEncontrado == 'false'){
                                                    //System.debug('If child2.getName(): ' + child2.getName() + ' nodeName: ' + nodeName);
                                                    responseNode = child2;
                                                    NodoEncontrado = 'true';
                                                    //System.debug('child2 responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                                }else{
                                                    if(NodoEncontrado == 'false'){
                                                        //System.debug('child2.getAttributeCount() : ' + child1.getAttributeCount());
                                                        for(Dom.XMLNode child3: child2.getChildElements()) {
                                                            //System.debug('child3.getName(): ' + child3.getName());
                                                            if(child3.getName() == nodeName && NodoEncontrado == 'false'){
                                                                //System.debug('If child3.getName(): ' + child3.getName() + ' nodeName: ' + nodeName);
                                                                responseNode = child3;
                                                                NodoEncontrado = 'true';
                                                                //System.debug('child3 responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                                            }else{
                                                                if(NodoEncontrado == 'false'){
                                                                    responseNode = defaultNode;
                                                                    //System.debug('Default responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                   }
                }
            }
        }
        return responseNode;
    
    }
    
    /*
	* @Método: 		getNodeFromDomXMLNode
	* @Parámetros:	Dom.XMLNode , nodeName
	* @Descripción:	Método que devuelve el Dom.XMLNode dado por nodeName desde un Dom.XMLNode, el cual
    *               busca hasta tres niveles desde el nodo raíz en los nodos hijos del XMLNode.   
	*/
    
    public static Dom.XMLNode getNodeFromDomXMLNode(Dom.XMLNode rootNode, String nodeName)
    {
        System.debug('getNodeFromDomXMLNode.nodeName--------->' + NodeName); 
        Dom.XMLNode responseNode;
        DOM.Document docDefault = new DOM.Document();
        dom.XmlNode defaultNode = docDefault.createRootElement('Vacio', '', '');
        string NodoEncontrado = 'false';
  
        System.debug('RootNode.getName(): ' + rootNode.getName());
        
        if(rootNode.getName() == nodeName ){
        	responseNode =  RootNode; 
            NodoEncontrado = 'true';
        }else{
            if(NodoEncontrado == 'false'){
                for(Dom.XMLNode child: rootNode.getChildElements()) {
                System.debug('child.getName(): ' + child.getName());
                    if(child.getName() == nodeName && NodoEncontrado == 'false'){
                        //System.debug('child.getName(): ' + child.getName() + ' nodeName: ' + nodeName);
                        responseNode = child;
                        NodoEncontrado = 'true';
                        //System.debug('child.getName(): ' + child.getName() + ' nodeName: ' + nodeName + ' NodoEncontrado: ' + NodoEncontrado);
                    }else{
                        if(NodoEncontrado == 'false'){
                            //System.debug('child.getAttributeCount() : ' + child.getAttributeCount());
                            for(Dom.XMLNode child1: child.getChildElements()) {
                               //System.debug('child1.getName(): ' + child1.getName());
                                    if(child1.getName() == nodeName && NodoEncontrado == 'false'){
                                        //System.debug('If child1.getName(): ' + child1.getName() + ' nodeName: ' + nodeName);
                                        responseNode = child1;
                                        NodoEncontrado = 'true';
                                        //System.debug('child1 responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                    }else{
                                        if(NodoEncontrado == 'false'){
                                            //System.debug('child1.getAttributeCount() : ' + child1.getAttributeCount());
                                            for(Dom.XMLNode child2: child1.getChildElements()) {
                                                //System.debug('child2.getName(): ' + child2.getName());
                                                if(child2.getName() == nodeName && NodoEncontrado == 'false'){
                                                    //System.debug('If child2.getName(): ' + child2.getName() + ' nodeName: ' + nodeName);
                                                    responseNode = child2;
                                                    NodoEncontrado = 'true';
                                                    //System.debug('child2 responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                                }else{
                                                    if(NodoEncontrado == 'false'){
                                                        //System.debug('child2.getAttributeCount() : ' + child1.getAttributeCount());
                                                        for(Dom.XMLNode child3: child2.getChildElements()) {
                                                            //System.debug('child3.getName(): ' + child3.getName());
                                                            if(child3.getName() == nodeName && NodoEncontrado == 'false'){
                                                                //System.debug('If child3.getName(): ' + child3.getName() + ' nodeName: ' + nodeName);
                                                                responseNode = child3;
                                                                NodoEncontrado = 'true';
                                                                //System.debug('child3 responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                                            }else{
                                                                if(NodoEncontrado == 'false'){
                                                                    responseNode = defaultNode;
                                                                    //System.debug('Default responseNode.getName() : ' + responseNode.getName() + ' NodoEncontrado: ' + NodoEncontrado);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                   }
                }
            }
        }
        System.debug('getNodeFromDomXMLNode.responseNode.getName() : ' + responseNode);
        return responseNode;
    }
    
    
    /*
	* @Método: 		addNumbersToLineaObject
	* @Parámetros:	OperacionComercial__c , List<String>
	* @Descripción:	Método que adiciona los numeros devueltos por gestor a objetos de tipo Linea 
    *               y los relaciona a la OC enviada.   
	*/
     public static void addNumbersToLineaObject(OperacionComercial__c OC,  List<String> numbersArray)
     {
         
         String estado = 'Activa';
         
         for (String n : numbersArray) {
             Linea__c linea = new Linea__c();
             System.debug('numberArray: ' + n );
             linea.Name = n.substringBefore('|');
             linea.Codigo_de_linea__c = n.substringBefore('|');
             If(n.substringAfter('|') == 'SI'){
             	Linea.Tipo_Linea__c = 'Arranque';
             }else{
             	Linea.Tipo_Linea__c = '';
             }
             Linea.Estado_Aprovisionamiento__c = 'Activo';
             Linea.OperacionComercialTramite__c = OC.Id;
             insert linea;
             
         }

     }
    
    public static Date getStartDate(Date FechadeActivacion, Date FinDeConsumo)
    {
        Date dateOut;
        System.debug('FechadeActivacion: ' + FechadeActivacion);
        System.debug('FinDeConsumo : ' + FinDeConsumo);
        if(FinDeConsumo == null || FechadeActivacion == null){
            dateOut = FechadeActivacion;
        }else{
            if(FechadeActivacion > FinDeConsumo){
                dateOut = FechadeActivacion;
            }else{
                dateOut = FinDeConsumo.addDays(1);
            }
        }
        System.debug('dateOut : ' + dateOut);
        return dateOut;
    }
    

}