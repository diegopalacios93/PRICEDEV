public with sharing class CostosAvanzadosUpdateFormulaFields {
	
    public static void updateFormulaFields(List<Costos_Avanzados__c> costos) {
        List<Costos_Avanzados__c> costsToUpdate = new List<Costos_Avanzados__c>();
        for ( Costos_Avanzados__c c : costos ) {
            Costos_Avanzados__c cost = new Costos_Avanzados__c(Id = c.Id);
            if (c.CC_Tipo_de_Contrato__c == 'Modificacion' || c.CC_Tipo_de_Contrato__c == 'Ampliacion') {
                cost.CC_Instalacion_y_Obras_Civiles__c = (c.CC_Valor_Matriz_Ampliacion__c * c.CC_Factor_PMT_doce__c) + (c.CC_Valor_Matriz_Desinstalacion__c * c.CC_Factor_PMT_Veintinueve__c) + (c.CC_Obras_Civiles__c * c.CC_Factor_PMT_doce__c);
            }else if (c.CC_Tipo_de_Contrato__c == 'Renovacion') {
                cost.CC_Instalacion_y_Obras_Civiles__c = (c.CC_Valor_Matriz_Desinstalacion__c * c.CC_Factor_PMT_Veintinueve__c) + (c.CC_Obras_Civiles__c * c.CC_Factor_PMT_doce__c);
            }else {
                cost.CC_Instalacion_y_Obras_Civiles__c = (c.CC_Valor_Matriz_Costo_de_Instalacion_Equ__c + c.CC_TotalConexion_OCUnitario__c + c.CC_Valor_Matriz_Obras_Civiles__c + c.CC_Service_Activator__c + c.CC_Service_Manager__c) * c.CC_Factor_PMT_doce__c + (c.CC_Valor_Matriz_Desinstalacion__c * c.CC_Factor_PMT_Veintinueve__c);
            }
            costsToUpdate.add(cost);
            }
        update costsToUpdate;
    }
}