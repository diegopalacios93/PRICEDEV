public with sharing class CotizacionAvanzadaTriggerService {

    // getBW obtiene el registro de ancho de banda lo relaciona al registro de pricing
    public static void getBW(List<ETB_CotizacionAvanzada__c> lPID) {
        Set<String> setBW = new Set<String>();
        for(ETB_CotizacionAvanzada__c pid : lPID) {
            setBW.add(pid.AnchoBandaTerceros__c);
        }
        
        Map<String,String> mapBWId = new Map<String,String>();
        for(ETB_BW__c bw : [SELECT Id,BW__c FROM ETB_BW__c WHERE BW__c IN : setBW]) {
            mapBWId.put(bw.BW__c, bw.Id);
        }
        
        for(ETB_CotizacionAvanzada__c pid : lPID) {
            if(String.isNotBlank(pid.AnchoBandaTerceros__c)) {
                if(mapBWId.containsKey(pid.AnchoBandaTerceros__c)) {
                   pid.Ancho_de_Banda__c = mapBWId.get(pid.AnchoBandaTerceros__c); 
                }
            }
        }
    }
    
    public static void updateCostosConectividad(List<ETB_CotizacionAvanzada__c> lPID) {
        Set<Id> setIdPricing = new set<Id>();
        for(ETB_CotizacionAvanzada__c pid : lPID) {
            setIdPricing.add(pid.id);
        }

        Map<Id, Id> mapPricingCosto = new Map<Id, Id>();
        for(Costos_Avanzados__c cost : [SELECT Id, Cotizador__c FROM Costos_Avanzados__c WHERE Cotizador__c IN : setIdPricing FOR UPDATE]) {
            mapPricingCosto.put(cost.Cotizador__c, cost.Id);
        }
        List<Costos_Avanzados__c> cc = new List<Costos_Avanzados__c>();
        for(ETB_CotizacionAvanzada__c pid : lPID) {
            if(pid.Calculado__c == True) { 
               Costos_Avanzados__c cost = new Costos_Avanzados__c();
               cost.TipoUM__c=pid.TipoUM__c;
               cost.Cotizador__c=pid.Id;
               cost.Cotizacion__c=pid.Cotizacion__c;
               cost.Quote_Line_Item__c=pid.Quote_Line_Item__c;
               cost.CC_Obras_Civiles__c=pid.Obras_Civiles__c;
               cost.CC_CFM_Unitario__c=pid.CFM_Unitario__c;
               cost.CC_Costo_EquipoUM__c=pid.Costo_Equipo_UM__c;
               cost.CC_AnilloAcceso__c=pid.Anillo_de_Acceso__c;
               cost.CC_Conexion_Unitario__c=pid.Conexion_Unitario__c;
               cost.CC_FOAcceso__c=pid.FO_Acceso__c;
               cost.CC_Radio__c=pid.Radio__c;
               cost.CC_PuertosRedMetro__c=pid.Puertos_Red_Metro__c;
               cost.CC_MPLSRedCarrierEthernet__c=pid.MPLS_y_Red_Carrier_Ethernet__c;
               cost.CC_Tx__c=pid.Tx__c;
               cost.CC_TxInternet_NAP__c=pid.Tx_Internet_o_NAP__c;
               cost.CC_Metros_Adicionales__c=pid.Metros_Adicionales__c;
               cost.CC_Metros_Tendidos_FoUMETB__c=pid.Metros_Tendidos_Fo_UM_ETB__c;
               cost.CC_Monitoreo_Reportes__c=pid.Monitoreo_Reportes__c;
               cost.CC_CostoEnlace_OPEXComercial__c=pid.Costo_Enlace_OPEX_Comercial__c;
               cost.CC_CostoEnlaceOPEXComercial_Maximo__c=pid.Costo_Enlace_OPEX_Comercial_Maximo__c;
               cost.CC_EnlaceLocal__c=pid.Enlace_Local__c;
               cost.CC_EnlaceNacional__c=pid.Enlace_Nacional__c;
               cost.CC_Internet__c=pid.Internet__c;
               cost.CC_TRM__c=pid.TRM__c;
               cost.CC_OPEX_Comercial__c=pid.OpexComercial__c;
               cost.CC_OPEX_ComercialMaximo__c=pid.OPEX_MAX_Impuestos_Adicionales__c;    
               cost.CC_Opex_Instalacion__c=pid.Opex_Instalacion__c;
               cost.Tiempo_de_Contrato_en_Meses__c=pid.Formula_Tiempo_de_Contrato_en_Meses__c;
               cost.IVA__c=pid.IVA__c;
               cost.CC_Ancho_de_Banda__c=pid.Ancho_de_Banda__c;
               cost.CC_Valor_Matriz_Ampliacion__c=pid.Valor_Matriz_Ampliaci_n__c;
               cost.CC_Factor_PMT_doce__c=pid.Factor_PMT_doce__c;
               cost.CC_Valor_Matriz_Desinstalacion__c=pid.Valor_Matriz_Desinstalacion__c;
               cost.CC_Factor_PMT_Veintinueve__c=pid.Factor_PMT_Veintinueve__c;
               cost.CC_Valor_Matriz_Costo_de_Instalacion_Equ__c=pid.Valor_Matriz_Costo_de_Instalaci_n_Equipo__c;
               cost.CC_Valor_Matriz_Obras_Civiles__c=pid.Valor_Matriz_Obras_Civiles__c;
               cost.CC_Tipo_de_Contrato__c=pid.Tipo_de_Contrato__c;
               cost.CC_Service_Activator__c=pid.Service_Activator__c;
               cost.CC_Service_Manager__c=pid.Service_Manager__c;
               cost.CC_Margen_Comercial_Maximo__c=pid.Margen_Comercial_Maximo__c;
               cost.CC_Tarifa_Actual_Pagada__c=pid.Tarifa_Actual_Pagada__c;
               cost.CC_Costo_de_Facturacion__c=pid.Costo_de_Facturacion__c;
               cost.CC_Service_Manager_IntelligenceMes__c=pid.Service_Manager_IntelligenceMes__c;
               cost.CC_Costo_de_Help_Desk__c=pid.Costo_de_Help_Desk__c;
               cost.CC_Combinacion_Ciudad_Origen_Destino__c=pid.Combinacion_Ciudad_Origen_Destino__c;
               cost.CC_Categoria_de_Enlace__c=pid.Categoria_de_Enlace__c;
               cost.CC_Tipo_de_Servicio__c=pid.Tipo_de_Servicio__c;
               cost.CC_Valor_Matriz_BW_Pto_Central__c=pid.Valor_Matriz_BW_Pto_Central__c;
               if(mapPricingCosto.containsKey(pid.Id)) {
                   cost.Id = mapPricingCosto.get(pid.Id);
               }
               cc.add(cost);
            }
        }
        if(!cc.isEmpty()) {
            List<Costos_Avanzados__c> costosAUpdatear = new List<Costos_Avanzados__c>();
            for(Costos_Avanzados__c costos : cc) {
                if(String.isNotBlank(costos.Id)) {
                    costosAUpdatear.add(costos);
                }
            update costosAUpdatear;

            List<QuoteLineItem> lQLI = new List<QuoteLineItem>();
            for(Costos_Avanzados__c c : cc) {
                if(String.isNotBlank(c.Id) && String.isNotBlank(c.Quote_Line_Item__c)) {
                    QuoteLineItem qli = new QuoteLineItem();
                    qli.Id = c.Quote_Line_Item__c;
                    qli.ETB_CostosConectividad__c = c.Id;
                    lQLI.add(qli);
                }
            }
            if(!lQLI.isEmpty()) {
                update lQLI;
                }
            }
        }
    }
}