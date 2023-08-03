/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB EPC/CPQ Industries
    Description:    Metodos encolable por lineitem 

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         28-09-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase metodo encolable para calcular IP
 */
public with sharing class ETB_ActualizarCostosCambioAsignacionQbl extends QueueableWrapper implements Database.AllowsCallouts{
    Map<String,Object> partidaPresupuesto;
    Decimal porcentajeAsignacion;
    Boolean ultimoElemento;
    String  APINAME_NOTIFICACION = 'etb_CambioPorcentajeAsignacion';
    
    /**
     * @description constructor del metodo encolable
     * @param partidaPresupuesto
     * @param porcentajeAsignacion
     * @param ultimoElemento    
     */
    public ETB_ActualizarCostosCambioAsignacionQbl(Map<String,Object> partidaPresupuesto,Decimal porcentajeAsignacion,Boolean ultimoElemento) {
        super('ETB_ActualizarCostosCambioAsignacionQbl');
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
            String codigoProducto = (String)partidaPresupuesto.get('ProductCode');
            Id quoteLineItemId = (Id)partidaPresupuesto.get('Id');
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
                    String costosReferencia = (String) partidaPresupuesto.get('ETB_GL_JsonPricingReferencia__c');
                    Map<String,Object> mapCostosReferencia = (Map<String,Object>)JSON.deserializeUntyped(costosReferencia);
                    //nuevosCostos.put('TarifaListaMensualSinIVA', mapCostosReferencia.get('TarifaListaMensualSinIVA'));
                    //nuevosCostos.put('Tarifa_piso_Referencia', mapCostosReferencia.get('Tarifa_piso_Referencia'));
                    //nuevosCostos.put('TarifaListaMensualConIVA', mapCostosReferencia.get('TarifaListaMensualConIVA'));
                    String jsonNuevosCostos = JSON.serialize(nuevosCostos);
                    QuoteLineItem partidaPresupuestoActualizada = new QuoteLineItem(Id=quoteLineItemId,etb_gl_jsonpricing__c=jsonNuevosCostos);
                    if (QuoteLineItem.SObjectType.getDescribe().isUpdateable()) {
                        update partidaPresupuestoActualizada;
                    }                                        
                }               
            }
            if (this.ultimoElemento) {
                vlocity_cmt.JSONResult result;
                ETB_PricingHandlerCls.callGetCartLineItemPrices((Id)partidaPresupuesto.get('QuoteId'), result);
                //generar notificacion
                CustomNotificationType tipoNotificacion = ETB_CrearNotificacionCls.getNotificationType(this.APINAME_NOTIFICACION);
                String userId = UserInfo.getUserId();
                Set<String> recipientsIds = new Set<String>();
                recipientsIds.add(userId); 
                String targetId = (String)partidaPresupuesto.get('QuoteId');
                String title='Cambio porcentaje asignación finalizado';
                String body = 'Se ha finalizado el proceso de cambio de asignación';
                ETB_CrearNotificacionCls.notifyUsers(recipientsIds, targetId, title, body, tipoNotificacion);                
                //generar notificacion
            }                        
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_CambioPorcentajeAsignacionQbl -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());
        }
    }
}