/****************************************************************************************************
    Autor:          nasser.abdala@globant.com
    Project:        Vlocity - ETB
    Description:    Clase para extraer los valores y setearlos en las variables de precio

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         12-08-2022        Nasser Abdala               Creación de Clase
*****************************************************************************************************/
/**
 * @description Clase para extraer los valores y setearlos en las variables de precio
 */
global with sharing class ETB_SetPricingVariablesCls implements vlocity_cmt.VlocityOpenInterface {
    /**
     * @description metodo para ser llamado desde el calculation procedure
     * @param methodName    String
     * @param input         Map<String, Object>
     * @param output        Map<String, Object>
     * @param options       Map<String, Object>
     * @return result       Boolean
     */
    public Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        Boolean result = true;
        try{
            if(methodName == 'calculate') {             
                 calculate(input, output, options);  
            }else{
                result= false;
            } 
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR,'ETB_SetPricingVariablesCls invokeMethod -> exception: ' + e.getLineNumber()+'-'+e.getMessage());
            result=false;
        }
        return result;      
    }
    /**
     * @description     metodo calculate
     * @param input     Map<String, Object>
     * @param outMap    Map<String, Object>
     * @param options   Map<String, Object>    
     */
    public static void calculate(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){                
        
        List<Id> listIdQuote = new List<Id>();
        list<Object> inputData = (list<Object>) input.get('inputData');
        
        Double tarifaListaMensualSinIVA = 0;
        Double tarifaListaOneTimeSinIVA = 0;
        Double tarifaPisoMensual = 0;
        Double tarifaPisoOneTime = 0;
        Double tarifaListaMensualConIVA = 0;
        Double tarifaListaOneTimeConIVA = 0;
        try {
            System.debug('NKA::ENTRO');

            for(Object obj : inputData)
            {
                Map<String, Object> entradas = (Map<String, Object>) obj;
                Id quoteLineItemId = (Id)entradas.get('ID');
                listIdQuote.add(quoteLineItemId);                        
            }
            Map<Id,QuoteLineItem> mapQuotetemp =new Map<Id,QuoteLineItem>([select id,QuoteId,ETB_GL_JsonPricing__c,vlocity_cmt__RecurringCharge__c,
                                                                        vlocity_cmt__RecurringCost__c,RecurringChargeWithTax__c,vlocity_cmt__OneTimeCharge__c,
                                                                        One_Time_Standard_Price_With_Tax__c,vlocity_cmt__OneTimeCost__c
                                                                        from QuoteLineItem where Id IN :listIdQuote FOR UPDATE]);
                        
            Map<Id,OrderItem> mapOrderTemp = new Map<Id,OrderITem>([select id,ETB_GL_JsonPricing__c,vlocity_cmt__RecurringCharge__c,
                                                                    vlocity_cmt__RecurringCost__c,RecurringChargeWithTax__c,vlocity_cmt__OneTimeCharge__c,
                                                                    One_Time_Standard_Price_With_Tax__c,vlocity_cmt__OneTimeCost__c
                                                                    from OrderItem where Id IN :listIdQuote FOR UPDATE]);

            for(Object obj : inputData)
            {
                Map<String, Object> entradas = (Map<String, Object>) obj;
                Id quoteLineItemId = (Id)entradas.get('ID');
                if (mapQuotetemp.containsKey(quoteLineItemId)) {
                    QuoteLineItem quoteTemp = mapQuotetemp.get(quoteLineItemId);                    
                    if(quotetemp.get('ETB_GL_JsonPricing__c')!=null){
                        String jsoninput = quotetemp.ETB_GL_JsonPricing__c;
                        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsoninput);
                        
                        System.debug('JFRC:::'+ m);
                        
                        tarifaListaMensualSinIVA= (Double) (m.containsKey('TarifaListaMensualSinIVA')&&m.get('TarifaListaMensualSinIVA')!=''?((Map<String, Object>)m.get('TarifaListaMensualSinIVA')).get('Valor'):0);
                        tarifaListaOneTimeSinIVA=(Double) (m.containsKey('TarifaListaOneTimeSinIVA')&&m.get('TarifaListaOneTimeSinIVA')!=''?((Map<String, Object>)m.get('TarifaListaOneTimeSinIVA')).get('Valor'):0);
                        tarifaPisoMensual=(Double) (m.containsKey('TarifaPisoMensual')&&m.get('TarifaPisoMensual')!=''?((Map<String, Object>)m.get('TarifaPisoMensual')).get('Valor'):0);
                        tarifaPisoOneTime=(Double) (m.containsKey('TarifaPisoOneTime')&&m.get('TarifaPisoOneTime')!=''?((Map<String, Object>)m.get('TarifaPisoOneTime')).get('Valor'):0);
                        tarifaListaMensualConIVA=(Double) (m.containsKey('TarifaListaMensualConIVA')&&m.get('TarifaListaMensualConIVA')!=''?((Map<String, Object>)m.get('TarifaListaMensualConIVA')).get('Valor'):0);
                        tarifaListaOneTimeConIVA=(Double) (m.containsKey('TarifaListaOneTimeConIVA')&&m.get('TarifaListaOneTimeConIVA')!=''?((Map<String, Object>)m.get('TarifaListaOneTimeConIVA')).get('Valor'):0);                    
                    }else{
                        tarifaListaMensualSinIVA =(Double) (quoteTemp.get('vlocity_cmt__RecurringCharge__c')!=null?quoteTemp.get('vlocity_cmt__RecurringCharge__c'):0);
                        tarifaListaOneTimeSinIVA =(Double) (quoteTemp.get('vlocity_cmt__OneTimeCharge__c')!=null?quoteTemp.get('vlocity_cmt__OneTimeCharge__c'):0);
                        tarifaPisoMensual =(Double) (quoteTemp.get('vlocity_cmt__RecurringCost__c')!=null?quoteTemp.get('vlocity_cmt__RecurringCost__c'):0);
                        tarifaPisoOneTime =(Double) (quoteTemp.get('vlocity_cmt__OneTimeCost__c')!=null?quoteTemp.get('vlocity_cmt__OneTimeCost__c'):0);
                        tarifaListaMensualConIVA =(Double) (quoteTemp.get('RecurringChargeWithTax__c')!=null?quoteTemp.get('RecurringChargeWithTax__c'):0);
                        tarifaListaOneTimeConIVA =(Double) (quoteTemp.get('One_Time_Standard_Price_With_Tax__c')!=null?quoteTemp.get('One_Time_Standard_Price_With_Tax__c'):0);
                    }
                }if (mapOrderTemp.containsKey(quoteLineItemId)) {
                    System.debug('NKA::ENTRO2');
                    OrderItem quoteTemp = mapOrderTemp.get(quoteLineItemId);                    
                    if(quotetemp.get('ETB_GL_JsonPricing__c')!=null){
                        String jsoninput = quotetemp.ETB_GL_JsonPricing__c;
                        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(jsoninput);
                                                
                        tarifaListaMensualSinIVA= (Double) (m.containsKey('TarifaListaMensualSinIVA')&&m.get('TarifaListaMensualSinIVA')!=''?((Map<String, Object>)m.get('TarifaListaMensualSinIVA')).get('Valor'):0);
                        tarifaListaOneTimeSinIVA=(Double) (m.containsKey('TarifaListaOneTimeSinIVA')&&m.get('TarifaListaOneTimeSinIVA')!=''?((Map<String, Object>)m.get('TarifaListaOneTimeSinIVA')).get('Valor'):0);
                        tarifaPisoMensual=(Double) (m.containsKey('TarifaPisoMensual')&&m.get('TarifaPisoMensual')!=''?((Map<String, Object>)m.get('TarifaPisoMensual')).get('Valor'):0);
                        tarifaPisoOneTime=(Double) (m.containsKey('TarifaPisoOneTime')&&m.get('TarifaPisoOneTime')!=''?((Map<String, Object>)m.get('TarifaPisoOneTime')).get('Valor'):0);
                        tarifaListaMensualConIVA=(Double) (m.containsKey('TarifaListaMensualConIVA')&&m.get('TarifaListaMensualConIVA')!=''?((Map<String, Object>)m.get('TarifaListaMensualConIVA')).get('Valor'):0);
                        tarifaListaOneTimeConIVA=(Double) (m.containsKey('TarifaListaOneTimeConIVA')&&m.get('TarifaListaOneTimeConIVA')!=''?((Map<String, Object>)m.get('TarifaListaOneTimeConIVA')).get('Valor'):0);                    
                    }else{
                        tarifaListaMensualSinIVA =(Double) (quoteTemp.get('vlocity_cmt__RecurringCharge__c')!=null?quoteTemp.get('vlocity_cmt__RecurringCharge__c'):0);
                        tarifaListaOneTimeSinIVA =(Double) (quoteTemp.get('vlocity_cmt__OneTimeCharge__c')!=null?quoteTemp.get('vlocity_cmt__OneTimeCharge__c'):0);
                        tarifaPisoMensual =(Double) (quoteTemp.get('vlocity_cmt__RecurringCost__c')!=null?quoteTemp.get('vlocity_cmt__RecurringCost__c'):0);
                        tarifaPisoOneTime =(Double) (quoteTemp.get('vlocity_cmt__OneTimeCost__c')!=null?quoteTemp.get('vlocity_cmt__OneTimeCost__c'):0);
                        tarifaListaMensualConIVA =(Double) (quoteTemp.get('RecurringChargeWithTax__c')!=null?quoteTemp.get('RecurringChargeWithTax__c'):0);
                        tarifaListaOneTimeConIVA =(Double) (quoteTemp.get('One_Time_Standard_Price_With_Tax__c')!=null?quoteTemp.get('One_Time_Standard_Price_With_Tax__c'):0);
                    }
                }              
                entradas.put('TarifaListaMensualSinIVA',tarifaListaMensualSinIVA);
                entradas.put('TarifaListaOneTimeSinIVA',tarifaListaOneTimeSinIVA);
                entradas.put('TarifaPisoMensual',tarifaPisoMensual);
                entradas.put('TarifaPisoOneTime',tarifaPisoOneTime);
                entradas.put('TarifaListaMensualConIVA',tarifaListaMensualConIVA);
                entradas.put('TarifaListaOneTimeConIVA',tarifaListaOneTimeConIVA);                               
            }                        
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'ETB_SetPricingVariablesCls calculate -> exception: ' + e.getLineNumber()+'-'+e.getMessage());    
        }                    
    }
}