trigger CostosAvanzadosTrigger on Costos_Avanzados__c (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            List<Costos_Avanzados__c> costos = new List<Costos_Avanzados__c>();
            List<Costos_Avanzados__c> formulas = new List<Costos_Avanzados__c>();
            for ( Costos_Avanzados__c costoAvanzado : Trigger.new ) {
                if(costoAvanzado.CC_Tarifa_Lista_Unitaria_sin_IVA__c != costoAvanzado.Quote_Line_Item__r.vlocity_cmt__RecurringCharge__c ) {
                    costos.add(costoAvanzado);
                    }
                if(costoAvanzado.CC_Instalacion_y_Obras_Civiles__c == null || costoAvanzado.CC_Instalacion_y_Obras_Civiles__c == 0){
                    formulas.add(costoAvanzado);
                }
            }
            try{
                if(!costos.isEmpty()) {
                    CostosAvanzadosUpdateCart updateCostos = new CostosAvanzadosUpdateCart(costos);
                    Database.executeBatch(updateCostos, 1);
                }
                if(!formulas.isEmpty()) {
                    CostosAvanzadosUpdateFormulaFields.updateFormulaFields(formulas);
                }
            }catch (System.NullPointerException e){
                system.debug('Error :: ' + e.getMessage());
            }
        }
        if(Trigger.isUpdate){
            List<Costos_Avanzados__c> costos = new List<Costos_Avanzados__c>();
            List<Costos_Avanzados__c> formulas = new List<Costos_Avanzados__c>();
            for ( Costos_Avanzados__c costoAvanzado : Trigger.new ) {
                Costos_Avanzados__c costoAvanzadoOldValue = Trigger.oldMap.get(costoAvanzado.Id);
                if(costoAvanzado.CC_Tarifa_Lista_Unitaria_sin_IVA__c != costoAvanzado.Quote_Line_Item__r.vlocity_cmt__RecurringCharge__c || costoAvanzado.CC_Tarifa_Lista_Unitaria_sin_IVA__c != costoAvanzadoOldValue.Quote_Line_Item__r.vlocity_cmt__RecurringCharge__c) {
                       costos.add(costoAvanzado);
            	}
                Boolean TipoUM = (costoAvanzado.TipoUM__c != costoAvanzadoOldValue.TipoUM__c);
                Boolean InstalacionObrasCiviles = (costoAvanzado.CC_Instalacion_y_Obras_Civiles__c != costoAvanzadoOldValue.CC_Instalacion_y_Obras_Civiles__c);
                Boolean TipoDeContrato = (costoAvanzado.CC_Tipo_de_Contrato__c != costoAvanzadoOldValue.CC_Tipo_de_Contrato__c);
                Boolean ValorMatrizAmpliacion = (costoAvanzado.CC_Valor_Matriz_Ampliacion__c != costoAvanzadoOldValue.CC_Valor_Matriz_Ampliacion__c);
                Boolean FactorPMTDoce = (costoAvanzado.CC_Factor_PMT_doce__c != costoAvanzadoOldValue.CC_Factor_PMT_doce__c);
                Boolean ValorMatrizDesinstalacion = (costoAvanzado.CC_Valor_Matriz_Desinstalacion__c != costoAvanzadoOldValue.CC_Valor_Matriz_Desinstalacion__c);
                Boolean FactorPMTVeintinueve = (costoAvanzado.CC_Factor_PMT_Veintinueve__c != costoAvanzadoOldValue.CC_Factor_PMT_Veintinueve__c);
                Boolean ObrasCiviles = (costoAvanzado.CC_Obras_Civiles__c != costoAvanzadoOldValue.CC_Obras_Civiles__c);
                Boolean ValorMatrizCostoDeInstalacionEquipos = (costoAvanzado.CC_Valor_Matriz_Costo_de_Instalacion_Equ__c != costoAvanzadoOldValue.CC_Valor_Matriz_Costo_de_Instalacion_Equ__c);
                Boolean TotalConexionOCUnitario = (costoAvanzado.CC_TotalConexion_OCUnitario__c != costoAvanzadoOldValue.CC_TotalConexion_OCUnitario__c);
                Boolean ValorMatrizObrasCiviles = (costoAvanzado.CC_Valor_Matriz_Obras_Civiles__c != costoAvanzadoOldValue.CC_Valor_Matriz_Obras_Civiles__c);
                Boolean ServiceActivator = (costoAvanzado.CC_Service_Activator__c != costoAvanzadoOldValue.CC_Service_Activator__c);
                Boolean ServiceManager = (costoAvanzado.CC_Service_Manager__c != costoAvanzadoOldValue.CC_Service_Manager__c);
                if(TipoUM || InstalacionObrasCiviles || TipoDeContrato || ValorMatrizAmpliacion || FactorPMTDoce || ValorMatrizDesinstalacion || FactorPMTVeintinueve || ObrasCiviles || ValorMatrizCostoDeInstalacionEquipos || TotalConexionOCUnitario || ValorMatrizObrasCiviles || ServiceActivator || ServiceManager) {
                    formulas.add(costoAvanzado);
                }
            }
            try {
                if(!costos.isEmpty()) {
                    CostosAvanzadosUpdateCart updateCostos = new CostosAvanzadosUpdateCart(costos);
                    Database.executeBatch(updateCostos, 1);
                }   
                if(!formulas.isEmpty()) {
                    CostosAvanzadosUpdateFormulaFields.updateFormulaFields(formulas);
                }  
            }catch (System.NullPointerException e){
                system.debug('Error :: ' + e.getMessage());
            }
        }
    }
}