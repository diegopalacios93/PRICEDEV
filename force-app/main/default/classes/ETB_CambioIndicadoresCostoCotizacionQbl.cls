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

public with sharing class ETB_CambioIndicadoresCostoCotizacionQbl extends QueueableWrapper implements Database.AllowsCallouts {
    Map<String,Object> mapValoresEntrada = new Map<String,Object>();
            
    /**
     * @description constructor del metodo encolable
     * @param mapValoresEntrada     
     */
    public ETB_CambioIndicadoresCostoCotizacionQbl(Map<String,Object>mapValoresEntrada) {
        super('ETB_CambioIndicadoresCostoCotizacionQbl');
        this.mapValoresEntrada = mapValoresEntrada;
    }

    /**
     * @description ejecucion encolable
     */
    public void work(){
        List<Object> partidasPresupuesto;        
        try {
            partidasPresupuesto = (List<Object>) this.mapValoresEntrada.get('listaPartidasPresupuesto');
            
            Integer largoArreglo = partidasPresupuesto.size();
            Integer contador = 1;
            Boolean ultimoElemento = false;
            for(Object partidaPresupuestoItem : partidasPresupuesto ) {
                Map<String,Object> partidaPresupuesto = (Map<String,Object>)partidaPresupuestoItem;
                ultimoElemento = contador==largoArreglo;
                                
                Map<String, Object> mapElemento = this.mapValoresEntrada.clone();
                mapElemento.put('ultimoElemento', ultimoElemento);
                mapElemento.put('partidaPresupuesto',partidaPresupuesto);

                QueueableWrapper.enqueueJob(new ETB_ActualizarCostosCotizacionQbl(mapElemento));
                contador+=1;                
            }           
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_CambioIndicadoresCostoCotizacionQbl -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());
        }
    }
}