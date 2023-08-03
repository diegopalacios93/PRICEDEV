/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB_PricingHandlerCls
    Description:    Metodos para el calculo del precio custom con metadata e IP

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         28-09-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase con metodos para el calculo del precio
 */
public with sharing class ETB_PricingHandlerCls { 
    /**
     * @description constructor
     */
    //public ETB_PricingHandlerCls() {

    //}

    /**
     * @description metodo para obtener la metadata segun el codigo del producto
     * @param codigoProducto            Codigo del producto
     * @return ETB_GL_ConfPricing__mdt  metadata
     */
    public static ETB_GL_ConfPricing__mdt getMetadata(String codigoProducto){
        ETB_GL_ConfPricing__mdt mtdProducto = ETB_GL_ConfPricing__mdt.getInstance(codigoProducto);
        System.debug('mtdProducto' + mtdProducto);
        return mtdProducto;
    }
    
   /**     
     * @description metodo para obtener el tipo de pricing de la Quote
     * @param quotedId            Id de la Quote
   */ 
    /*public static void  ValidateTipoPricing (Id quotedId){
        Quote result = [SELECT id, Tipo_de_pricing__c FROM Quote WHERE Id=:quotedId LIMIT 1];
         //String result = [SELECT id, Tipo_de_pricing__c FROM Quote WHERE Id=:quotedId LIMIT 1];
        System.debug('result' + result);
        return result;
    } */
    
    public static List<Quote> ValidateTipoPricing(Id quotedId){
        System.debug('entrando1');
        List<Quote> result = [SELECT id, Tipo_de_pricing__c FROM Quote WHERE Id=:quotedId LIMIT 1];
        System.debug('entrando');
		return result;
    }
  
    

    /**
    * @description                  Método para calcular el precio segun arreglo parametros
    * @param metadata               ETB_GL_ConfPricing__mdt metadata del producto
    * @param mapValoresAtributos    Map<String, Object> arreglo de atributos
    * @return iOutput                Map<String, Object> arreglo de salida    
    */
    public static Map<String,Object> calculatePricing(ETB_GL_ConfPricing__mdt metadata, Map<String, Object> mapValoresAtributos){
        Map<String, Object> iOutput = new Map<String,Object>();
            
        try {  
            List<Quote> result = [SELECT id, Tipo_de_pricing__c FROM Quote LIMIT 1];
			System.debug('result' + result);
       		//string TipoPricing = String.valueOf(result.get(0).Tipo_de_pricing__c);
			//System.debug('TipoPricing' + TipoPricing ); 
			
            //if (TipoPricing.contains('Automatico')){
            String path=metadata.ETB_GL_NombreIP__c;
            System.debug('JFRC: Path de la metadata' + path);
            Map<String,Object> iOptions = new Map<String,Object>();
            List <String> valoresObligatorios = metadata.ETB_GL_ListaAtributos__c!=null?metadata.ETB_GL_ListaAtributos__c.split(';'):new List<String>();
            System.debug('Valores obligatorios valoresObligatorios:' + valoresObligatorios);
            Set <String> valoresAtributosSet = mapValoresAtributos.keySet();
            System.debug('antes del if de los valores obligatorios' + valoresAtributosSet);
            if (valoresAtributosSet.containsAll(valoresObligatorios)){               
                System.debug('Dentro del if para ejecutar el procedimiento');
                iOutput = (Map <String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, mapValoresAtributos, iOptions);                
            	//} 
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls calculatePricing -->Exception: ' + e.getMessage());
        }
        return iOutput;
    }

    /**
     * @description Metodo para leer los atributos del QuoteLineItem y transformarlo en un arreglo
     * @param quoteLineItem         QuoteLineItem
     * @param mapValoresAtributos   Map<String,Object> arreglo de salida
     */
    public static void readAttributesFromQLI(QuoteLineItem quoteLineItem,Map<String,Object> mapValoresAtributos){
        try {    
            if (quoteLineItem.get('vlocity_cmt__AttributeSelectedValues__c')!=null) {
                String jsonAttributes = (String)quoteLineItem.get('vlocity_cmt__AttributeSelectedValues__c');
                mapValoresAtributos = (Map<String,Object>)JSON.deserializeUntyped(jsonAttributes);
            }                               
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls readAttributesFromQLI -->Exception: ' + e);
        }
    }

    /**
     * @description Metodo para leer los atributos del QLI a través del ID
     * @param quoteId               Id
     * @param mapValoresAtributos   Map<String,Object> arreglo de salida
     * @param jsonAtributos         String json
     */
    public static void readAttributesFromId(Id quoteId,Map<String,Object> mapValoresAtributos,String jsonAtributos){
        try {
            if (QuoteLineItem.SObjectType.getDescribe().isAccessible()){
                QuoteLineItem quoteLineItem = [SELECT Id, Quantity, Product2.ProductCode, Product2.Id,vlocity_cmt__ParentItemId__c, 
                                        vlocity_cmt__AttributeSelectedValues__c, vlocity_cmt__AttributeMetadataChanges__c, 
                                        vlocity_cmt__RootItemId__c 
                                        FROM QuoteLineItem 
                                        WHERE Id = :quoteId];
                if (quoteLineItem.get('vlocity_cmt__AttributeSelectedValues__c')!=null) {
                    jsonAtributos = (String)quoteLineItem.get('vlocity_cmt__AttributeSelectedValues__c');
                    mapValoresAtributos = (Map<String,Object>)JSON.deserializeUntyped(jsonAtributos);
                }                             
            }                                              
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls readAttributesFromParentId -->Exception: ' + e);
        }
    }

    /**
     * @description Metodo para leer los atributos del JSON que recibe el hook y transformarlo en un arreglo
     * @param arregloHook           Map<String,Object>
     * @param mapValoresAtributos   List<Object> lista de salida
     */
    public static void readAttributesFromHook(Map<String,Object> arregloHook,List<Object> mapValoresAtributos){
        try {    
            if(arregloHook.containsKey('attributeCategories')){
                Map<String,Object> mapAttributeCategories = (Map<String,Object>)arregloHook.get('attributeCategories');
                List<Object> listAttributeCategories = (List<Object>) mapAttributeCategories.get('records');
                for (Object attItem : listAttributeCategories) {
                    Map<String,Object> attCategoria = (Map<String,Object>)attItem;
                    Map<String,Object> attProduct = (Map<String,Object>) attCategoria.get('productAttributes');
                    List<Object> attValores = (List<Object>) attProduct.get('records');
                    
                    mapValoresAtributos.addAll(attValores);                                                              
                }
            }                              
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls readAttributesFromHook -->Exception: ' + e);
        }
    }

    /**
     * @description Metodo para generar el arreglo de atributos en un map
     * @param listaAtributosPrincipal       List<Object> lista principal, si es producto secundario va la lista de los hijos
     * @param listaAtributosSecundaria      List<Object> lista secundaria, si es producto secundario va la lista del principal, si es principal va null
     * @param mapValoresAtributos           Map<String,Object> arreglo de salida       
     */
    public static void transformListToMapAttributes(List<Object> listaAtributosPrincipal,List<Object> listaAtributosSecundaria,Map<String,Object> mapValoresAtributos){
        try {
            for (Object attValor : listaAtributosPrincipal) {
                Map<String,Object> valorAtributo = (Map<String,Object>)attValor;
                
                for(Object attrValorP : listaAtributosSecundaria) {
                    Map<String, Object> valorAtributoPadre = (Map<String, Object>) attrValorP;
                    if ((String) valorAtributoPadre.get('code') == (String) valorAtributo.get('code')) {
                        if (valorAtributoPadre.get('userValues')!=null){
                            valorAtributo.put('userValues', valorAtributoPadre.get('userValues'));
                        }
                    }                        
                }
                if (valorAtributo.get('userValues')!=null){
                    mapValoresAtributos.put((String)valorAtributo.get('code'), valorAtributo.get('userValues'));                    
                }                    
            }                                             
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls transformListToMapAttributes -->Exception: ' + e.getLineNumber()+'-'+e.getMessage());
        }
    }

    /**
     * @description Metodo para hacer llamado al getcartlineitemprices
     * @param cartId        Id quoteId
     * @param result        vlocity_cmt.JSONResult resultado
     */
    public static void callGetCartLineItemPrices(Id cartId,vlocity_cmt.JSONResult result){
        try {
            vlocity_cmt.CpqAppHandler cpqAppHandlerService = new vlocity_cmt.CpqAppHandler();
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outputMap = new Map<String,Object>();
            Map<String,Object> optionsMap = new Map<String,Object>();
       
            inputMap.put('cartId', cartId);
            inputMap.put('price', true);
            inputMap.put('validate', true);
                
            cpqAppHandlerService.invokeMethod('getCartLineItemPrices', inputMap, outputMap, optionsMap);
            result = ( vlocity_cmt.JSONResult) outputMap.get('result');
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls callGetCartLineItemPrices -->Exception: ' + e);
        }
    }

    /**
     * @description Metodo para quitar los valores nulos de un map
     * @param mapValoresAtributos            Map<String,Object> arreglo de salida      
     * @return mapValoresAtributos           Map<String,Object> arreglo de salida       
     */
    public static  Map<String,Object> cleanMapAttributes(Map<String,Object> mapValoresAtributos){
        Map<String,Object> result = new Map<String,Object>();
        try {
            Set <String> valoresAtributosSet = mapValoresAtributos.keySet();
            for (String att : valoresAtributosSet) {
                if (mapValoresAtributos.get(att)!=null) {
                    result.put(att, mapValoresAtributos.get(att));
                }
            }                                                        
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_PricingHandlerCls cleanMapAttributes -->Exception: ' + e.getLineNumber()+'-'+e.getMessage());
        }
        return result;
    }
    
    
    /**
     * @description Metodo para obtener las variables de asignación e impuestos adicionales de la quote/order
     * @param idItem                String id del Item    
     * @return mapValores           Map<String,Object> arreglo de salida       
     */
    public static Map<String,Object> getGeneralIndicators(String idItem){
        Map<String,Object> mapValores = new Map<String,Object>();
        Decimal porcentajeAsignacion;
        Decimal impuestosAdicionales;
        List<QuoteLineItem> quoteLineItemTempList =[Select Quote.Impuestos_Adicionales__c, Quote.ETB_GL_PorcentajeAsignacion__c from QuoteLineItem where Id = :idItem LIMIT 1];
        if (quoteLineItemTempList.size() == 0) {            
            List<OrderItem> orderItemTempList = [Select Order.Impuestos_Adicionales__c, Order.ETB_GL_PorcentajeAsignacion__c from OrderItem where Id = :idItem LIMIT 1];               
            if(orderItemTempList.size()>0){
                OrderItem orderItemTemp = orderItemTempList.get(0);
                porcentajeAsignacion =(Decimal) (orderItemTemp.Order.ETB_GL_PorcentajeAsignacion__c==null?100:orderItemTemp.Order.ETB_GL_PorcentajeAsignacion__c);
                impuestosAdicionales =(Decimal) (orderItemTemp.Order.Impuestos_Adicionales__c==null?0:orderItemTemp.Order.Impuestos_Adicionales__c);              
            }else{
                porcentajeAsignacion = 100;
                impuestosAdicionales = 0;
            }                  
        }else{
            QuoteLineItem quoteLineItemTemp =  quoteLineItemTempList.get(0);         
            porcentajeAsignacion =(Decimal) (quoteLineItemTemp.Quote.ETB_GL_PorcentajeAsignacion__c==null?100:quoteLineItemTemp.Quote.ETB_GL_PorcentajeAsignacion__c);
            impuestosAdicionales =(Decimal) (quoteLineItemTemp.Quote.Impuestos_Adicionales__c==null?0:quoteLineItemTemp.Quote.Impuestos_Adicionales__c);            
        }                
        mapValores.put('porcentajeAsignacion', porcentajeAsignacion);
        mapValores.put('impuestosAdicionales', impuestosAdicionales);
        return mapValores;
    }
    
}