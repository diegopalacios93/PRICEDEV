/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        ETB_RemoteActionFromQuoteCls
    Description:    Metodos llamado remoto desde quote

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         28-09-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/

/**
 * @description clase con metodos para llamados remotos desde la quote con herramientas de omnistudio
 */
global with sharing class ETB_RemoteActionFromQuoteCls implements vlocity_cmt.VlocityOpenInterface { 
 
    /**
     * @description metodo para obtener la metadata segun el codigo del producto
     * @param methodName    String
     * @param inputMap      Map<String, Object>
     * @param outMap        Map<String, Object>
     * @param options       Map<String, Object>
     * @return result       Boolean
     */
    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;        
        try {
            switch on methodName
            {
                when 'cambioIndicadoresCostoCotizacion' {                    
                    cambioIndicadoresCostoCotizacion(inputMap, outMap, options);
                }                
                when else {
                    result = false;
                }
            }
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_RemoteActionFromQuoteCls invokeMethod -> exception: ' + e.getLineNumber()+'-'+e.getMessage());
            result=false;
        }
        return result;
    }

    /**
     * @description metodo encolar el proceso de cambio de asignacion 
     * @param inputMap      Map<String, Object>
     * @param outMap        Map<String, Object>
     * @param options       Map<String, Object>    
     */
    public static void cambioIndicadoresCostoCotizacion(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        try {
            Map<String,Object> mapValoresEntrada = new Map<String,Object>();
            Id quoteId = (Id)inputMap.get('quoteId');
            Decimal porcentajeAsignacion = (Decimal) inputMap.get('porcentajeAsignacion') ;
            Decimal impuestosRegionalesAdicionales = (Decimal) inputMap.get('impuestosRegionalesAdicionales') ;            
            List<Object> listaPartidasPresupuesto = (List<Object>) inputMap.get('listQuoteLineItem');  
            
            mapValoresEntrada.put('quoteId', quoteId);
            mapValoresEntrada.put('porcentajeAsignacion', porcentajeAsignacion);
            mapValoresEntrada.put('impuestosRegionalesAdicionales', impuestosRegionalesAdicionales);
            mapValoresEntrada.put('listaPartidasPresupuesto', listaPartidasPresupuesto);

            QueueableWrapper.enqueueJob(new ETB_CambioIndicadoresCostoCotizacionQbl(mapValoresEntrada));                
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_RemoteActionFromQuoteCls cambioIndicadoresCostoCotizacion -->Exception: ' + e.getLineNumber()+'-'+e.getMessage());
        }

    }
}