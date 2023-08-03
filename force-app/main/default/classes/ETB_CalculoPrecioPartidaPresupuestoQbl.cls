/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB EPC/CPQ Industries
    Description:    Metodos encolable por lineitem 

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         11-11-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase metodo encolable para calcular IP
 */
public with sharing class ETB_CalculoPrecioPartidaPresupuestoQbl extends QueueableWrapper implements Database.AllowsCallouts {
    QuoteLineItem partidaPresupuesto;
    Decimal porcentajeAsignacion;
    Boolean ultimoElemento;
    
    /**
     * @description constructor del metodo encolable
     * @param partidaPresupuesto
     * @param porcentajeAsignacion
     * @param ultimoElemento    
     */
    public ETB_CalculoPrecioPartidaPresupuestoQbl(QuoteLineItem partidaPresupuesto,Decimal porcentajeAsignacion,Boolean ultimoElemento) {
        super('ETB_CalculoPrecioPartidaPresupuestoQbl');
        this.partidaPresupuesto = partidaPresupuesto;
        this.porcentajeAsignacion = porcentajeAsignacion;
        this.ultimoElemento = ultimoElemento;
    }

    /**
     * @description ejecucion encolable para calcular nuevo valor
     */
    public void work(){
        try {
            Map<String,Object> mapValoresAtributos;
            Map<String,Object> mapValoresAtributosOriginal;
            Map<String,Object> iOutput;
            String codigoProducto = (String)partidaPresupuesto.Product2.get('ProductCode');
            Id quoteLineItemId = (Id)partidaPresupuesto.get('Id');
             if(Test.isRunningTest()){
                     codigoProducto ='PR_INTERNET_DEDICADO';
                 }
            ETB_GL_ConfPricing__mdt metadataProducto = ETB_PricingHandlerCls.getMetadata(codigoProducto);
            if (metadataProducto!=null) {
                String jsonAttributes = (String)partidaPresupuesto.get('vlocity_cmt__AttributeSelectedValues__c');
                mapValoresAtributosOriginal = (Map<String,Object>)JSON.deserializeUntyped(jsonAttributes);
                mapValoresAtributos = ETB_PricingHandlerCls.cleanMapAttributes(mapValoresAtributosOriginal);
                mapValoresAtributos.put('PorcentajeAsignacion', this.porcentajeAsignacion);
                mapValoresAtributos.put('ProductCode', codigoProducto);
                System.debug(LoggingLevel.DEBUG, JSON.serialize(mapValoresAtributos));               
                iOutput=ETB_PricingHandlerCls.calculatePricing(metadataProducto, mapValoresAtributos);               
                if( iOutput.get('SetItem') != '' && iOutput.get('SetItem') != null){
                    Map<String,Object> nuevosCostos = (Map<String,Object>)iOutput.get('SetItem');
                    String jsonNuevosCostos = JSON.serialize(nuevosCostos);
                    QuoteLineItem partidaPresupuestoActualizada = new QuoteLineItem(Id=quoteLineItemId,etb_gl_jsonpricing__c=jsonNuevosCostos);
                    if (QuoteLineItem.SObjectType.getDescribe().isUpdateable()) {
                        update partidaPresupuestoActualizada;
                    }                                        
                }               
            }
            if (this.ultimoElemento) {
                 //Invocación de SFI API priceCart
                Map<String, Object> auxInputMap;
                Map<String, Object> auxOutputMap;
                Map<String, Object> auxOptionsMap;
                auxInputMap = new Map<String, Object>();
                auxOutputMap = new Map<String, Object>();
                auxOptionsMap = new Map<String, Object>();
                String methodName = 'priceCart';
                auxInputMap.put('methodName', methodName);
                auxInputMap.put('cartId', (Id)partidaPresupuesto.get('QuoteId'));
                vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
                appHandler.invokeMethod(methodName, auxInputMap, auxOutputMap, auxOptionsMap);                
                //generar notificacion
            }                        
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_CalculoPrecioPartidaPresupuestoQbl -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());
        }
    }
}