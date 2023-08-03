public class VersionarOfertaOpController {

    @AuraEnabled
    public static String createOffer(Oferta_Op__c objOferta, String offerId){

        try{

            Oferta_Op__c oferta = [
                SELECT Name, Nombre_de_la_cuenta__c, Estado_Oferta__c, Oportunidad__c, Contacto__c, Consecutivo_Oportunidades__c,
                        Fecha_Presentacion_Oferta__c, Tipo_de_contrato__c, Fecha_Vigencia_Oferta__c, Concepto__c,Contract__c, Numero_del_Contrato_MGC__c,
                        Elaboracion_Modelo_de_Negocio__c, Fecha_Envio_Flujo_de_Aprobacion__c, Fecha_Validacion_Oferta__c, Version__c, Oferta_Anterior__c,
                        Valor_Total_Oferta_Sin_IVA_form__c, Margen_Soluciones_TI__c, Valor_Total_Oferta_Con_IVA__c, Margen_adicional_Tarifa_Piso__c, Valor_Total_Soluciones_TI__c, 
                        Duracion_en_Meses__c, Valor_Total_Producto_Propio__c, Duracion_en_Dias__c, Valor_Recurrente_ETB_STI__c, Valor_sin_destinacion_especifica__c, 
                        Valor_unica_vez_ETB_STI__c, Imprevistos_Soluciones_TI__c, Valor_Recurrente_ETB_Pp__c, Valor_unica_vez_ETB_Pp__c, Valor_Recurrente_ETB__c, 
                        Valor_nica_vez_ETB__c, Oferta_con_condiciones_vigentes__c, Configurador_vs_Viabilidad_Preventa__c, Configurador_vigente__c, 
                        Soportes_descuentos_comerciales__c, Modelo_Financiero__c, Cronograma__c, Forma_de_Pago_Alineado__c, Vias_y_o_tareas_cerradas__c, 
                        Fecha_de_Validacion__c, Causal_de_Rechazo__c, Tipo_de_Validacion__c, VersionIndex__c
                FROM Oferta_Op__c 
                WHERE Id =: offerId
            ];

            objOferta.Nombre_de_la_cuenta__c = oferta.Nombre_de_la_cuenta__c;
            objOferta.Estado_Oferta__c = oferta.Estado_Oferta__c;
            objOferta.Oportunidad__c = oferta.Oportunidad__c;
            objOferta.Contacto__c = oferta.Contacto__c;
            objOferta.Fecha_Presentacion_Oferta__c = oferta.Fecha_Presentacion_Oferta__c;
            objOferta.Tipo_de_contrato__c = oferta.Tipo_de_contrato__c;
            objOferta.Fecha_Vigencia_Oferta__c = oferta.Fecha_Vigencia_Oferta__c;
            objOferta.Concepto__c = oferta.Concepto__c;
            objOferta.Contract__c = oferta.Contract__c;
            objOferta.Elaboracion_Modelo_de_Negocio__c = oferta.Elaboracion_Modelo_de_Negocio__c;
            objOferta.Fecha_Envio_Flujo_de_Aprobacion__c = oferta.Fecha_Envio_Flujo_de_Aprobacion__c;
            objOferta.Fecha_Validacion_Oferta__c = oferta.Fecha_Validacion_Oferta__c;
            objOferta.Oferta_Anterior__c = oferta.Id;
            objOferta.Margen_Soluciones_TI__c = oferta.Margen_Soluciones_TI__c;
            objOferta.Valor_Total_Oferta_Con_IVA__c = oferta.Valor_Total_Oferta_Con_IVA__c;
            objOferta.Margen_adicional_Tarifa_Piso__c = oferta.Margen_adicional_Tarifa_Piso__c;
            objOferta.Valor_Total_Soluciones_TI__c = oferta.Valor_Total_Soluciones_TI__c;
            objOferta.Duracion_en_Meses__c = oferta.Duracion_en_Meses__c;
            objOferta.Valor_Total_Producto_Propio__c = oferta.Valor_Total_Producto_Propio__c;
            objOferta.Duracion_en_Dias__c = oferta.Duracion_en_Dias__c;
            objOferta.Valor_Recurrente_ETB_STI__c = oferta.Valor_Recurrente_ETB_STI__c;
            objOferta.Valor_sin_destinacion_especifica__c = oferta.Valor_sin_destinacion_especifica__c;
            objOferta.Valor_unica_vez_ETB_STI__c = oferta.Valor_unica_vez_ETB_STI__c;
            objOferta.Imprevistos_Soluciones_TI__c = oferta.Imprevistos_Soluciones_TI__c;
            objOferta.Valor_Recurrente_ETB_Pp__c = oferta.Valor_Recurrente_ETB_Pp__c;
            objOferta.Valor_unica_vez_ETB_Pp__c = oferta.Valor_unica_vez_ETB_Pp__c;
            objOferta.Valor_Recurrente_ETB__c = oferta.Valor_Recurrente_ETB__c;
            objOferta.Valor_nica_vez_ETB__c = oferta.Valor_nica_vez_ETB__c;
            objOferta.Oferta_con_condiciones_vigentes__c = oferta.Oferta_con_condiciones_vigentes__c;
            objOferta.Configurador_vs_Viabilidad_Preventa__c = oferta.Configurador_vs_Viabilidad_Preventa__c;
            objOferta.Configurador_vigente__c = oferta.Configurador_vigente__c;
            objOferta.Soportes_descuentos_comerciales__c = oferta.Soportes_descuentos_comerciales__c;
            objOferta.Modelo_Financiero__c = oferta.Modelo_Financiero__c;
            objOferta.Cronograma__c = oferta.Cronograma__c;
            objOferta.Forma_de_Pago_Alineado__c = oferta.Forma_de_Pago_Alineado__c;
            objOferta.Vias_y_o_tareas_cerradas__c = oferta.Vias_y_o_tareas_cerradas__c;
            objOferta.Fecha_de_Validacion__c = oferta.Fecha_de_Validacion__c;
            objOferta.Causal_de_Rechazo__c = oferta.Causal_de_Rechazo__c;
            objOferta.Tipo_de_Validacion__c = oferta.Tipo_de_Validacion__c;
            objOferta.Version__c = oferta.Version__c+1;

            String sString = oferta.VersionIndex__c;
            String[] splitted = sString.split('\\-');
            
            if(splitted.size() > 1){
                objOferta.VersionIndex__c = splitted[0]+'-'+splitted[1]+'-'+String.valueOf(objOferta.Version__c);
            }
    
            insert objOferta; 
            
            Id versionadoRecordTypeId = Schema.SObjectType.Oferta_Op__c.getRecordTypeInfosByName().get('Versionado').getRecordTypeId();
            
            oferta.RecordTypeId = versionadoRecordTypeId;
            update oferta;
            
            return objOferta.Id;
             
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
     
    @AuraEnabled 
    public static Map<String, String> getMotivo(){
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Oferta_Op__c.Motivo_de_versionamiento__c.getDescribe();
        
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
}