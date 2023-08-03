/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB EPC/CPQ Industries
    Description:    Metodos encolable calculo precio

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         11-11-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase metodo encolable para calcular IP
 */
public with sharing class ETB_CalculoPrecioQbl extends QueueableWrapper implements Database.AllowsCallouts {
    String quoteId;
    /**
     * @description constructor del metodo encolable
     * @param quoteId
     */
    public ETB_CalculoPrecioQbl(String quoteId) {
        super('ETB_CalculoPrecioQbl');
        this.quoteId = quoteId;
    }
    /**
     * @description ejecucion encolable
     */
    public void work(){
        try {
            List<QuoteLineItem> listaQLI;
            if (QuoteLineItem.SObjectType.getDescribe().isAccessible()) {
                listaQLI = [SELECT Id, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE QuoteId = :this.quoteId];
            }
            Integer largoArreglo = listaQLI.size();
            Integer contador = 1;
            Boolean ultimoElemento = false;
            for(QuoteLineItem partidaPresupuesto :listaQLI ) {
                ultimoElemento = contador==largoArreglo;               
                QueueableWrapper.enqueueJob(new ETB_CalculoPrecioPartidaPresupuestoQbl(partidaPresupuesto , 100, ultimoElemento));
                contador+=1;                
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_CalculoPrecioQbl -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());
        }
    }
}