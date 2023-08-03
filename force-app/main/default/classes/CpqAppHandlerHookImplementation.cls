/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        Vlocity - ETB
    Description:    Hook CPQ AppHandler.

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         12-08-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/
/**
 * @description clase hook para calculo del precio
 */
global with sharing class CpqAppHandlerHookImplementation implements vlocity_cmt.VlocityOpenInterface
{
    /**
     * @description metodo para obtener la metadata segun el codigo del producto
     * @param methodName    String
     * @param input      Map<String, Object>
     * @param output        Map<String, Object>
     * @param options       Map<String, Object>
     * @return result       Boolean
     */
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)
    {

        try
        {           
            if (methodName == 'postCartsItems.PreInvoke')
            {               
                prePostCalculatePrice(input, output, options);
            }
            if (methodName == 'deleteCartsItems.PreInvoke'){
                preDeleteCalculatePrice(input,output,options); 
            }
            if (methodName == 'cloneItems.PreInvoke') {
                preCloneCalculatePrice(input,output,options);
            }            
            if (methodName == 'putCartsItems.PreInvoke')
            {                
                prePutCalculatePrice(input, output, options);                
            }                                  
            return true;
        }
        catch (Exception ex)
        {
            System.debug(LoggingLevel.ERROR,'--- Exception: ' + ex.getMessage());
            System.debug(LoggingLevel.ERROR,'--- Stack Trace: ' + ex.getStackTraceString());
            return false;
        }
    }

    /**
     * @description     metodo PrePost
     * @param input     Map<String, Object>
     * @param outMap    Map<String, Object>
     * @param options   Map<String, Object>    
     */
    public void prePostCalculatePrice(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){ 
    	//Map<String,Object> InputDes =  (Map<String, Object>) JSON.deserialize(input);
        //System.debug('@@-InputDes->'+InputDes);
		System.debug('@@-input->'+input);
		
        //CVV_DTOValidacionSubsidio_cls objDTOEstadoSubsidio = new CVV_DTOValidacionSubsidio_cls();
    	//prePostCalculatePrice.input objDTOresponse = ( CVV_DTOConsultaTipoCupoBolsillo_cls.Response ) JSON.deserialize(response.getBody(), prePostCalculatePrice.input.class);

        try{
            PricebookEntry productoNuevo;
            Map<String,Object> elemento = new Map<String,Object>();
            String elementoId;
            String elementoPadreId;            
            elemento = (Map<String,Object>)((List<Object>)input.get('items')).get(0);
            elementoId = (String)elemento.get('itemId');
           
            Map<String,Object> mapAtributosPadre = new Map<String,Object>();
            String atributosPadre;
            elementoPadreId =  elemento.containsKey('parentId')?(String)elemento.get('parentId'):null;

            if (PricebookEntry.getSObjectType().getDescribe().isAccessible()) {
                productoNuevo = [SELECT id,ProductCode from PricebookEntry WHERE Id = :elementoId];    
            }

            String codigoProducto =(String) productoNuevo.get('ProductCode');
            Double cantidad = 1;
            if (codigoProducto.length()>40) {
                codigoProducto = codigoProducto.substring(0, 40);            
            }
            codigoProducto = codigoProducto.removeEnd('_');
            ETB_GL_ConfPricing__mdt mtdProducto = ETB_PricingHandlerCls.getMetadata(codigoProducto);
                                                                                                                  
            if (mtdProducto!=null) {
                Map<String,Object> mapValoresAtributos = new Map<String,Object>();
                mapValoresAtributos.put('ProductCode', codigoProducto);
                mapValoresAtributos.put('Quantity', cantidad);
                if (elementoPadreId!=null) {                   
                    ETB_PricingHandlerCls.readAttributesFromId(elementoPadreId, mapAtributosPadre,atributosPadre);
                    mapValoresAtributos.putAll(mapAtributosPadre);   
                }
                Map<String, Object> iOutput = new Map<String,Object>();
                iOutput=ETB_PricingHandlerCls.calculatePricing(mtdProducto, mapValoresAtributos );

                Map<String,Object> fieldsToUpdate = new Map<String,Object>();
                fieldsToUpdate.put('ETB_GL_JsonPricing__c', JSON.serialize(iOutput.get('SetItem')));
                fieldsToUpdate.put('ETB_GL_JsonPricingReferencia__c', JSON.serialize(iOutput.get('SetItem')));
                if (atributosPadre!=null) {
                    fieldsToUpdate.put('vlocity_cmt__AttributeSelectedValues__c',atributosPadre);
                }                
                elemento.put('fieldsToUpdate', fieldsToUpdate);
            }             
        }     
        catch(Exception ex) {
            System.debug(LoggingLevel.ERROR,'CpqAppHandlerHookImplementation prePostCalculatePrice ->Exception: ' + ex.getLineNumber() + '-'+ex.getMessage());            
        }
    }

    /**
     * @description     metodo PrePut
     * @param input     Map<String, Object>
     * @param outMap    Map<String, Object>
     * @param options   Map<String, Object>    
     */
    public void prePutCalculatePrice(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){  
        try{
            input.put('price',true);
            input.put('validate',true);                      
            
            Map<String,Object> elementoPadre = new Map<String,Object>();
            String elementoPadreId;
            Double cantidadPadre;
            Map<String,Object> elementoHijo = new Map<String,Object>();
            String elementoHijoId;
            Double cantidadHijo;
            elementoPadre = (Map<String,Object>)((List<Object>)((Map<String,Object>)input.get('items')).get('records')).get(0);
            elementoPadreId = (String)((Map<String,Object>) elementoPadre.get('Id')).get('value');  
            
            if (elementoPadre.containsKey('Quantity')){
                cantidadPadre = (Double)((Map<String,Object>) elementoPadre.get('Quantity')).get('value');
            }else{
                cantidadPadre=1;
            }
           
            if (elementoPadre.containsKey('lineItems')) {                                                  
                elementoHijo = (Map<String,Object>)((List<Object>) ((Map<String,Object>)elementoPadre.get('lineItems')).get('records')).get(0);
                elementoHijoId = (String)((Map<String,Object>) elementoHijo.get('Id')).get('value'); 
                cantidadHijo = (Double)((Map<String,Object>) elementoHijo.get('Quantity')).get('value');                                       
            }                 

            String codigoProducto = !elementoHijo.isEmpty()? (String)elementoHijo.get('ProductCode'):(String)elementoPadre.get('ProductCode');           
            Map<String,Object> elementoProducto = !elementoHijo.isEmpty()?elementoHijo:elementoPadre;             
            String idProducto = elementoHijoId!=null?elementoHijoId:elementoPadreId;                  
            Double cantidad = cantidadHijo!=null?cantidadHijo:cantidadPadre;                  
           
            ETB_GL_ConfPricing__mdt mtdProducto = ETB_PricingHandlerCls.getMetadata(codigoProducto) ;           
            
          
          
            if (mtdProducto!=null) {
                Map<String,Object> mapIndicadoresGenerales = new Map<String,Object>();                
                List<Object> listMapAtributoValor = new List<Object>();
                Map<String,Object> mapValoresAtributos = new Map<String,Object>();
                List<Object> attValoresPadre = new List<Object>();
                List<Object> attValoresHijo = new List<Object>();
                
                ETB_PricingHandlerCls.readAttributesFromHook(elementoPadre, attValoresPadre);
                if (!elementoHijo.isEmpty()) {
                    ETB_PricingHandlerCls.readAttributesFromHook(elementoHijo, attValoresHijo);
                    ETB_PricingHandlerCls.transformListToMapAttributes(attValoresHijo, attValoresPadre, mapValoresAtributos);
                }else{
                    ETB_PricingHandlerCls.transformListToMapAttributes(attValoresPadre, attValoresHijo, mapValoresAtributos);    
                }
                mapIndicadoresGenerales = ETB_PricingHandlerCls.getGeneralIndicators(idProducto);                              
                mapValoresAtributos.put('quoteLineItem',idProducto);
                mapValoresAtributos.put('quoteLineItemParent',elementoPadreId);
                mapValoresAtributos.put('quoteLineItemChild',elementoHijoId);
                mapValoresAtributos.put('path',mtdProducto.ETB_GL_Path__c);
                mapValoresAtributos.put('calculoBundle',mtdProducto.ETB_GL_CalculoBundle__c);
                mapValoresAtributos.put('ProductCode', codigoProducto);
                mapValoresAtributos.put('Quantity',cantidad);
                mapValoresAtributos.put('PorcentajeAsignacion', (Decimal) mapIndicadoresGenerales.get('porcentajeAsignacion'));
                mapValoresAtributos.put('Impuestos_regionales_adicionales', (Decimal) mapIndicadoresGenerales.get('impuestosAdicionales'));
                mapValoresAtributos.put('tipoPricing', (String) mapIndicadoresGenerales.get('tipoPricing'));
                mapValoresAtributos.put('ESM', true);

                Map<String, Object> iOutput = new Map<String,Object>();
               
                iOutput = ETB_PricingHandlerCls.calculatePricing(mtdProducto, mapValoresAtributos);                                           
                
                if(!iOutput.isEmpty()){
                    if( iOutput.get('SetItem') != '' && iOutput.get('SetItem') != null){
                        elementoProducto.put('ETB_GL_JsonPricing__c', JSON.serialize(iOutput.get('SetItem')));
                        elementoProducto.put('ETB_GL_JsonPricingReferencia__c', JSON.serialize(iOutput.get('SetItem')));
                    }
                }else{
                    System.debug(LoggingLevel.DEBUG,'Aún faltan parametros necesarios para el calculo');
                }
                
               
                if (mtdProducto.ETB_GL_Path__c!= null) { 
               
                    elementoPadre.put('ETB_GL_JsonPricing__c', JSON.serialize(iOutput.get('SetItemParent')));
                    QuoteLineItem lineItemPadre = new QuoteLineItem (
                        Id=elementoPadreId,
                        ETB_GL_JsonPricing__c=JSON.serialize(iOutput.get('SetItemParent')),
                        ETB_GL_JsonPricingReferencia__c=JSON.serialize(iOutput.get('SetItemParent')));
                    if (QuoteLineItem.SObjectType.getDescribe().isUpdateable()) {
                        update lineItemPadre;  
                    }                                                                                      
                }else if(mtdProducto.ETB_GL_CalculoBundle__c){ 
                    List<Object> listaBundle = (List<Object>)iOutput.get('SetListItem');                        
                    List<QuoteLineItem> listaActualizarBundle = new List<QuoteLineItem>();
                    for (Object elemento : listaBundle) {
                        Map<String,Object> quoteLineItem = (Map<String,Object>) elemento;
                        QuoteLineItem elementoAdicionar = new QuoteLineItem(Id=(Id)quoteLineItem.get('Id'),ETB_GL_JsonPricing__c=(String)quoteLineItem.get('JSONPricing'));
                        listaActualizarBundle.add(elementoAdicionar);
                    }
                    if (QuoteLineItem.SObjectType.getDescribe().isUpdateable()) {
                        update listaActualizarBundle;
                    }                       
                }                                                                               
            }                                                                          
        }        
        catch(Exception ex) {
            System.debug(LoggingLevel.ERROR,'CpqAppHandlerHookImplementation prePutCalculatePrice ->Exception: ' + ex.getLineNumber() + '-'+ex.getMessage());            
        }
    }    

    /**
     * @description     metodo PreDelete
     * @param input     Map<String, Object>
     * @param outMap    Map<String, Object>
     * @param options   Map<String, Object>    
     */
    public void preDeleteCalculatePrice(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Id idElementoEliminado = (Id) input.get('id');
        QuoteLineItem deleteQuoteLineItem = [SELECT Id,Product2Id,Product2.ProductCode,vlocity_cmt__LineNumber__c,QuoteId  FROM QuoteLineItem WHERE Id = :idElementoEliminado LIMIT 1];

        String lineNumber = (String)deleteQuoteLineItem.get('vlocity_cmt__LineNumber__c');
        String lineNumberPadre = lineNumber.substringBeforeLast('.');
        String lineNumberQuery = lineNumberPadre+'%';
        Id quoteId = (Id)deleteQuoteLineItem.get('QuoteId');
        String codigoProducto = String.valueOf(deleteQuoteLineItem.getSObject('Product2').get('ProductCode'));
        ETB_GL_ConfPricing__mdt mtdProducto = ETB_GL_ConfPricing__mdt.getInstance(codigoProducto);

        if (mtdProducto!=null && mtdProducto.ETB_GL_Path__c!=null) {                        
            String codigoPath = mtdProducto.ETB_GL_Path__c;
            ETB_GL_ConfPricing__mdt mtdProductoPath = ETB_GL_ConfPricing__mdt.getInstance(codigoPath);
            if (mtdProductoPath!=null) {
                Map<String,Object> mapValoresAtributos = new Map<String,Object>();
                //obtener Id padre
                QuoteLineItem padreQuoteLineItem = [SELECT Id,Product2Id,Product2.ProductCode,vlocity_cmt__LineNumber__c,QuoteId,vlocity_cmt__AttributeSelectedValues__c  FROM QuoteLineItem WHERE vlocity_cmt__LineNumber__c =:lineNumberPadre AND QuoteId =:quoteId LIMIT 1];
                Id elementoPadreId = (Id)padreQuoteLineItem.get('Id');
                String atributosPadre = (String)padreQuoteLineItem.get('vlocity_cmt__AttributeSelectedValues__c');
                Map<String,Object> mapAtributosPadre =  (Map<String, Object>) JSON.deserializeUntyped(atributosPadre);
                //obtener valores json hijos
                List<QuoteLineItem> elementosHijos = [SELECT Id,Product2Id,Product2.ProductCode,vlocity_cmt__LineNumber__c,QuoteId,ETB_GL_JsonPricing__c  FROM QuoteLineItem WHERE vlocity_cmt__LineNumber__c like :lineNumberQuery AND QuoteId =:quoteId AND Id!=:idElementoEliminado];
                List<Map<String,Object>> listaCostos = new List<Map<String,Object>>();
                for (QuoteLineItem elemento : elementosHijos) {
                    if (elemento.get('ETB_GL_JsonPricing__c')!=null) {
                        String jsonCosto = (String) elemento.get('ETB_GL_JsonPricing__c');
                        Map<String,Object> costo =  (Map<String, Object>) JSON.deserializeUntyped(jsonCosto);
                        listaCostos.add(costo);   
                    }                     
                }
                mapValoresAtributos.put('quoteLineItemParent',elementoPadreId);
                //mapValoresAtributos.put('quoteLineItemChild',elementoHijoId);
                mapValoresAtributos.put('path',mtdProductoPath.ETB_GL_Path__c);               
                mapValoresAtributos.put('ProductCode', codigoPath);
                mapValoresAtributos.put('listaCostos', listaCostos);
                mapValoresAtributos.put('calculoBundle',false);
                mapValoresAtributos.putAll(mapAtributosPadre);
                //System.debug(JSON.serialize(mapValoresAtributos));
                //System.debug(mtdProductoPath.ETB_GL_NombreIP__c);
                Map<String,Object> iOptions = new Map<String,Object>();
                Map<String, Object> iOutputPadre = (Map <String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(mtdProductoPath.ETB_GL_NombreIP__c, mapValoresAtributos, iOptions);                            
                //elementoPadre.put('ETB_GL_JsonPricing__c', JSON.serialize(iOutputPadre.get('SetItem')));
                QuoteLineItem lineItemPadre = new QuoteLineItem (Id=elementoPadreId,ETB_GL_JsonPricing__c=JSON.serialize(iOutputPadre.get('SetItem')));
                update lineItemPadre;
            }                        
        }
    }

    /**
     * @description     metodo PreClone
     * @param input     Map<String, Object>
     * @param outMap    Map<String, Object>
     * @param options   Map<String, Object>    
     */
    public void preCloneCalculatePrice(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){       

      
        Id idElementoClonado = (Id) input.get('id');
        QuoteLineItem cloneQuoteLineItem = [SELECT Id,Product2Id,Product2.ProductCode,vlocity_cmt__LineNumber__c,QuoteId  FROM QuoteLineItem WHERE Id = :idElementoClonado LIMIT 1];

        String lineNumber = (String)cloneQuoteLineItem.get('vlocity_cmt__LineNumber__c');
        String lineNumberPadre = lineNumber.substringBeforeLast('.');
        String lineNumberQuery = lineNumberPadre+'%';
        Id quoteId = (Id)cloneQuoteLineItem.get('QuoteId');
        String codigoProducto = String.valueOf(cloneQuoteLineItem.getSObject('Product2').get('ProductCode'));
        ETB_GL_ConfPricing__mdt mtdProducto = ETB_GL_ConfPricing__mdt.getInstance(codigoProducto);

        if (mtdProducto!=null && mtdProducto.ETB_GL_Path__c!=null) {                        
            String codigoPath = mtdProducto.ETB_GL_Path__c;
            ETB_GL_ConfPricing__mdt mtdProductoPath = ETB_GL_ConfPricing__mdt.getInstance(codigoPath);
            if (mtdProductoPath!=null) {
                Map<String,Object> mapValoresAtributos = new Map<String,Object>();
                //obtener Id padre
                QuoteLineItem padreQuoteLineItem = [SELECT Id,Product2Id,Product2.ProductCode,vlocity_cmt__LineNumber__c,QuoteId,vlocity_cmt__AttributeSelectedValues__c  FROM QuoteLineItem WHERE vlocity_cmt__LineNumber__c =:lineNumberPadre AND QuoteId =:quoteId LIMIT 1];
                Id elementoPadreId = (Id)padreQuoteLineItem.get('Id');
                String atributosPadre = (String)padreQuoteLineItem.get('vlocity_cmt__AttributeSelectedValues__c');
                Map<String,Object> mapAtributosPadre =  (Map<String, Object>) JSON.deserializeUntyped(atributosPadre);
                //obtener valores json hijos
                List<QuoteLineItem> elementosHijos = [SELECT Id,Product2Id,Product2.ProductCode,vlocity_cmt__LineNumber__c,QuoteId,ETB_GL_JsonPricing__c  FROM QuoteLineItem WHERE vlocity_cmt__LineNumber__c like :lineNumberQuery AND QuoteId =:quoteId];
                List<Map<String,Object>> listaCostos = new List<Map<String,Object>>();
                for (QuoteLineItem elemento : elementosHijos) {
                    if (elemento.get('ETB_GL_JsonPricing__c')!=null) {
                        String jsonCosto = (String) elemento.get('ETB_GL_JsonPricing__c');
                        Map<String,Object> costo =  (Map<String, Object>) JSON.deserializeUntyped(jsonCosto);
                        listaCostos.add(costo);   
                    }
                     
                }

                mapValoresAtributos.put('quoteLineItemParent',elementoPadreId);
                //mapValoresAtributos.put('quoteLineItemChild',elementoHijoId);
                mapValoresAtributos.put('path',mtdProductoPath.ETB_GL_Path__c);               
                mapValoresAtributos.put('ProductCode', codigoPath);
                mapValoresAtributos.put('listaCostos', listaCostos);
                mapValoresAtributos.put('calculoBundle',false);
                mapValoresAtributos.putAll(mapAtributosPadre);
                //System.debug(JSON.serialize(mapValoresAtributos));
                //System.debug(mtdProductoPath.ETB_GL_NombreIP__c);
                Map<String,Object> iOptions = new Map<String,Object>();
                Map<String, Object> iOutputPadre = (Map <String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(mtdProductoPath.ETB_GL_NombreIP__c, mapValoresAtributos, iOptions);                            
                //elementoPadre.put('ETB_GL_JsonPricing__c', JSON.serialize(iOutputPadre.get('SetItem')));
                QuoteLineItem lineItemPadre = new QuoteLineItem (Id=elementoPadreId,ETB_GL_JsonPricing__c=JSON.serialize(iOutputPadre.get('SetItem')));
                update lineItemPadre;
            }                        
        }
    }
}