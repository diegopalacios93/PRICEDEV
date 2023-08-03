/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        Vlocity - ETB
    Description:    Clase para hacer calculo de precio con el ajuste de los costos

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         07-09-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/
/**
 * @description clase para hacer ajuste de costos
 */
global with sharing class ETB_AjusteCostosCls implements vlocity_cmt.VlocityOpenInterface {
    
    /**
     * @description metodo invoke del remoteaction
     * @param methodName    String
     * @param input      Map<String, Object>
     * @param output        Map<String, Object>
     * @param options       Map<String, Object>
     * @return result       Boolean
     */
    public Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        Boolean result = true;
        try{
            if(methodName == 'calcular') {             
                calcular(input, output, options);                   
            }else{
                result = false;
            }
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR,'ETB_AjusteCostosCls invokeMethod -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());         
            result = false;
         }
        return result;       
    }

    /**
     * @description metodo calcular nuevos costos
     * @param input      Map<String, Object>
     * @param output        Map<String, Object>
     * @param options       Map<String, Object>    
     */
    public static void calcular(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
        try {           
            Map<String,Object> mapAtributos =(Map<String,Object>) JSON.deserializeUntyped((String)input.get('JsonParameters'));
            Map<String,Object> mapCostos = (Map<String,Object>) (input.get('NuevosValoresCostos')==''?new Map<String,Object>():input.get('NuevosValoresCostos'));
            
            System.debug('---input---' + input);
            System.debug('-mapAtributos-'+ mapAtributos);
            System.debug('-mapCostos-'+ mapCostos);
            
            Decimal asignacion=(Decimal) (input.get('PorcentajeAsignacion')==''?100:input.get('PorcentajeAsignacion'));
            
            Map<String,Object> mapValoresAtributos = new Map<String,Object>();                        
            mapValoresAtributos.put('path',(String)input.get('path'));
            mapValoresAtributos.put('calculoBundle',(Boolean) input.get('calculoBundle'));
            mapValoresAtributos.put('ProductCode', (String)input.get('ProductCode'));
            mapValoresAtributos.put('Quantity', (Integer)input.get('Quantity'));
            mapValoresAtributos.put('quoteLineItem',(String) input.get('QuoteLineItemId'));
            mapValoresAtributos.put('PorcentajeAsignacion', asignacion);
            mapValoresAtributos.putAll(mapAtributos);
            mapValoresAtributos.putAll(mapCostos);
            String path=(String) input.get('NombreIntegrationProcedure');

            System.debug(LoggingLevel.DEBUG,'MAPATRIBUTOS:: '+JSON.serialize(mapValoresAtributos));

            Map<String,Object> iOptions = new Map<String,Object>(); 
            Map<String, Object> iOutput = (Map <String, Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(path, mapValoresAtributos, iOptions);
            
            output.put('JSONNuevosCostos', JSON.serialize(iOutput.get('SetItem')));
            output.put('NuevosCostos', iOutput.get('SetItem'));       
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_AjusteCostosCls calcular -> exception: ' + e.getLineNumber() + ' - '+e.getMessage());    
        }
    }
}