/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB EPC/CPQ Industries
    Description:    Metodos encolable principal

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         28-09-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase metodo encolable para calcular IP
 */
public with sharing class ETB_CambioPorcentajeAsignacionQbl extends QueueableWrapper implements Database.AllowsCallouts {
    List<Object> partidasPresupuesto;
    Decimal nuevoPorcentajeAsignacion;
    Id quoteId;
    
    /**
     * @description constructor del metodo encolable
     * @param listaPartidasPresupuesto
     * @param porcentajeAsignacion
     * @param quoteId
     */
    public ETB_CambioPorcentajeAsignacionQbl(List<Object> listaPartidasPresupuesto, Decimal porcentajeAsignacion, Id quoteId) {
        super('ETB_CambioPorcentajeAsignacionQbl');
        this.partidasPresupuesto = listaPartidasPresupuesto;
        this.nuevoPorcentajeAsignacion = porcentajeAsignacion;
        this.quoteId = quoteId;
    }

    /**
     * @description ejecucion encolable
     */
    public void work(){
        try {
            //vlocity_cmt.JSONResult result;
            Integer largoArreglo = this.partidasPresupuesto.size();
            Integer contador = 1;
            Boolean ultimoElemento = false;
            for(Object partidaPresupuestoItem : this.partidasPresupuesto ) {
                Map<String,Object> partidaPresupuesto = (Map<String,Object>)partidaPresupuestoItem;
                ultimoElemento = contador==largoArreglo;               
                QueueableWrapper.enqueueJob(new ETB_ActualizarCostosCambioAsignacionQbl(partidaPresupuesto , this.nuevoPorcentajeAsignacion, ultimoElemento));
                contador+=1;                
            }
            //ETB_PricingHandlerCls.callGetCartLineItemPrices(this.quoteId, result);
            //generar notificacion
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_CambioPorcentajeAsignacionQbl -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());
        }
    }
}