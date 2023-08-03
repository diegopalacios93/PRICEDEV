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
public with sharing class ETB_ActualizarCostosCotizacionQbl extends QueueableWrapper implements Database.AllowsCallouts {
    String  APINAME_NOTIFICACION = 'etb_CambioPorcentajeAsignacion';
    Map<String,Object> mapValoresEntrada = new Map<String,Object>();
            
    /**
     * @description constructor del metodo encolable
     * @param mapValoresEntrada     
     */
    public ETB_ActualizarCostosCotizacionQbl(Map<String,Object>mapValoresEntrada) {
        super('ETB_ActualizarCostosCotizacionQbl');
        this.mapValoresEntrada = mapValoresEntrada;
    }

    /**
     * @description ejecucion encolable para calcular nuevo valor
     */
    public void work(){
        System.debug(LoggingLevel.DEBUG, JSON.serialize(this.mapValoresEntrada));
        Map<String,Object> partidaPresupuesto;
        Decimal porcentajeAsignacion;
        Decimal impuestosRegionalesAdicionales;
        Boolean ultimoElemento;
        try {
            partidaPresupuesto = (Map<String,Object>)this.mapValoresEntrada.get('partidaPresupuesto');
            porcentajeAsignacion = (Decimal)this.mapValoresEntrada.get('porcentajeAsignacion');
            impuestosRegionalesAdicionales = (Decimal) this.mapValoresEntrada.get('impuestosRegionalesAdicionales');
            ultimoElemento = (Boolean) this.mapValoresEntrada.get('ultimoElemento');

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
                mapValoresAtributos.put('PorcentajeAsignacion', porcentajeAsignacion);
                mapValoresAtributos.put('Impuestos_regionales_adicionales', impuestosRegionalesAdicionales);
                mapValoresAtributos.put('ProductCode', codigoProducto);
                             
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
            if (ultimoElemento) {
                vlocity_cmt.JSONResult result;
                ETB_PricingHandlerCls.callGetCartLineItemPrices((Id)partidaPresupuesto.get('QuoteId'), result);
                //generar notificacion
                CustomNotificationType tipoNotificacion = ETB_CrearNotificacionCls.getNotificationType(this.APINAME_NOTIFICACION);
                String userId = UserInfo.getUserId();
                Set<String> recipientsIds = new Set<String>();
                recipientsIds.add(userId); 
                String targetId = (String)partidaPresupuesto.get('QuoteId');
                String title='Actualización costos de cotización finalizado';
                String body = 'Se ha finalizado el proceso de actualización de costos';
                ETB_CrearNotificacionCls.notifyUsers(recipientsIds, targetId, title, body, tipoNotificacion);                
                //generar notificacion
            }                        
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_ActualizarCostosCotizacionQbl -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());
        }
    }
}