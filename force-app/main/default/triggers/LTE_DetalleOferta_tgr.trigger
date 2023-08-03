trigger LTE_DetalleOferta_tgr on LTE_DetalleOferta__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    LTE_EnviarInfoFactEquipos_cls lteEnvEquipos = new LTE_EnviarInfoFactEquipos_cls();
        
    
    //copiar valores en oc
    //LTE_LibreriaUtilitaria_cls.checkImei(objDetalle.LTE_IMEI__c);
        if (trigger.isBefore) 
        {
            List<LTE_DetalleOferta__c> lstDetalles = new List<LTE_DetalleOferta__c>();
            Set<Id> idsDO = new Set<Id>();
            for(LTE_DetalleOferta__c sglDetalle:trigger.new){
                idsDO.add(sglDetalle.Id);
            }
			System.debug('ids--->'+idsDo);
            System.debug('datos--->'+trigger.new);
            
            List<LTE_DetalleOferta__c> doDatos = [SELECT Id,LTE_ReferenciaEquipo__c,LTE_ReferenciaEquipo__r.Name,LTE_OperacionComercial__c,ReferenciaEquipoAliado__c,
                                                        LTE_OperacionComercial__r.Plan__r.NombredelProducto__r.Name,LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c,
                                                        LTE_OperacionComercial__r.CuentaFacturacion__c,LTE_OperacionComercial__r.CuentaFacturacion__r.IMEISCF__c,
                                                        LTE_OperacionComercial__r.CuentaFacturacion__r.Name,LTE_IMEI__c,IMEIProcesado__c FROM LTE_DetalleOferta__c WHERE Id IN: idsDO];
            System.debug('Lista--->'+doDatos);
            for (LTE_DetalleOferta__c det: doDatos){
                if( ((det.LTE_ReferenciaEquipo__c != null && det.LTE_ReferenciaEquipo__r.Name != 'Equipo Traido' && det.LTE_OperacionComercial__c != null &&
                    det.LTE_OperacionComercial__r.Plan__r.NombredelProducto__r.Name == 'TELEFONIA MOVIL (LTE)' &&
                    det.LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c == 'Venta') || (det.ReferenciaEquipoAliado__c != null && det.LTE_OperacionComercial__c != null &&
                    det.LTE_OperacionComercial__r.Plan__r.NombredelProducto__r.Name == 'Soluciones TI' &&
                    det.LTE_OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c == 'Venta')) && det.IMEIProcesado__c == false){
                    lstDetalles.add(det);
                }
            }

            
            if(!lstDetalles.isEmpty()){
                LTE_DetalleOferta_cls.actualizarIMEISCuentaFacturacion(lstDetalles);
            }
			
            if (trigger.isInsert) {
                
                //Migrado desde el ProcessBuilder - Proceso para Creacion de SVA adicionales LTE
                Set<Id> lstSubPlan = new Set<Id>();
                for(LTE_DetalleOferta__c sglDetalle:trigger.new){
                    if(sglDetalle.LTE_DatosNavegacion__c != null){
                        if(!lstSubPlan.contains(sglDetalle.LTE_DatosNavegacion__c)){
                            lstSubPlan.add(sglDetalle.LTE_DatosNavegacion__c);
                        }
                    }
                    if(sglDetalle.LTE_MinutoVoz__c != null){
                        if(!lstSubPlan.contains(sglDetalle.LTE_MinutoVoz__c)){
                            lstSubPlan.add(sglDetalle.LTE_MinutoVoz__c);
                        }
                    }
                }
                Map<Id,SubPlanFacturacion__c> MapSubPlanactual = new Map<Id,SubPlanFacturacion__c>([SELECT Id,SVA_Voz_Relacionados__c,SVA_Voz_Relacionados__r.Name, LTE_Precio__c FROM SubPlanFacturacion__c WHERE Aplica_SVA_Voz_Relacionados__c = true AND Id IN :lstSubPlan ]);
                if(!MapSubPlanactual.isEmpty()){
                    for(LTE_DetalleOferta__c sglDetalle:trigger.new){
                        if(sglDetalle.LTE_DatosNavegacion__c != null && MapSubPlanactual.containskey(sglDetalle.LTE_DatosNavegacion__c)){
                            sglDetalle.Valor_SVA_de_Datos__c = MapSubPlanactual.get(sglDetalle.LTE_DatosNavegacion__c).LTE_Precio__c;
                        }
                        if(sglDetalle.LTE_MinutoVoz__c != null && MapSubPlanactual.containskey(sglDetalle.LTE_MinutoVoz__c)){
                            sglDetalle.Valor_SVA_de_Voz__c = MapSubPlanactual.get(sglDetalle.LTE_MinutoVoz__c).LTE_Precio__c;
                        }
                    }
                }
            }

            if (trigger.isUpdate){
                LTE_DetalleOferta_cls.cambioEstadoListasNegras(trigger.old,trigger.newMap);      
            }

            if (trigger.isDelete) {
            }

            for(LTE_DetalleOferta__c sglDetalle:trigger.new){
                if(sglDetalle.Id != null)
                sglDetalle.IMEIProcesado__c = true;
            }
        }
    
    if (trigger.isAfter) 
    {   
		
     
        if (trigger.isInsert) {

        	BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        	LTE_DetalleOferta_cls.actualizarCamposOC(trigger.oldMap,trigger.newMap);
        	BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
           
            //Migrado desde el ProcessBuilder - Proceso para Creacion de SVA adicionales LTE
            Map<Id,Set<Id>> mapSubPlan = new Map<Id,Set<Id>>();
            for(LTE_DetalleOferta__c sglDetalle:trigger.new){
               
                system.debug(sglDetalle.LTE_DatosNavegacion__c+'-'+sglDetalle.LTE_Oferta_Economica__c);
                if(sglDetalle.LTE_DatosNavegacion__c != null && sglDetalle.LTE_Oferta_Economica__c != null){
                    if(mapSubPlan.containsKey(sglDetalle.LTE_DatosNavegacion__c)){
                        mapSubPlan.get(sglDetalle.LTE_DatosNavegacion__c).add(sglDetalle.Id);
                    }else{
                        Set<Id> tmpId = new Set<Id>();
                        tmpId.add(sglDetalle.Id);
                        mapSubPlan.put(sglDetalle.LTE_DatosNavegacion__c,tmpId);
                    }
                }
                if(sglDetalle.LTE_MinutoVoz__c != null && sglDetalle.LTE_Oferta_Economica__c != null){
                    if(mapSubPlan.containsKey(sglDetalle.LTE_MinutoVoz__c)){
                        mapSubPlan.get(sglDetalle.LTE_MinutoVoz__c).add(sglDetalle.Id);
                    }else{
                        Set<Id> tmpId = new Set<Id>();
                        tmpId.add(sglDetalle.Id);
                        mapSubPlan.put(sglDetalle.LTE_MinutoVoz__c,tmpId);
                    }
                }
            }
            
            List<LTE_Servicios_adicionales__c> lstServAdic = new List<LTE_Servicios_adicionales__c>();
            Map<Id,SubPlanFacturacion__c> MapSubPlanactual = new Map<Id,SubPlanFacturacion__c>([SELECT Id,SVA_Voz_Relacionados__c,SVA_Voz_Relacionados__r.Name FROM SubPlanFacturacion__c WHERE Aplica_SVA_Voz_Relacionados__c = true AND Id IN :mapSubPlan.keySet() ]);
            system.debug(MapSubPlanactual);
            for(Id iterSubPlan:mapSubPlan.keyset() ){
                if(MapSubPlanactual.containskey(iterSubPlan)){
                    for(Id iterDetalleId:mapSubPlan.get(iterSubPlan)){
                        LTE_Servicios_adicionales__c sglServAdic = new LTE_Servicios_adicionales__c(
                            LTE_DetalleOfertaEReservadoRegContable__c = iterDetalleId, LTE_SubPlaFacturacion__c = MapSubPlanactual.get(iterSubPlan).SVA_Voz_Relacionados__c,Name = MapSubPlanactual.get(iterSubPlan).SVA_Voz_Relacionados__r.Name, LTE_Estado__c = 'Pendiente',LTE_ServiceActionCode__c = 'ADD'
                        );//
                        lstServAdic.add(sglServAdic);
                    }
                }
            }
            if(!lstServAdic.isEmpty())
                insert lstServAdic;
        }
        
        if (trigger.isUpdate && !BanderasEjecucion.ValidarEjecucion('DesenCadena_actualizarCamposOC')) {
        	BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        	LTE_DetalleOferta_cls.actualizarCamposOC(trigger.oldMap,trigger.newMap);
        	BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        }
        
		system.debug(BanderasEjecucion.ValidarEjecucion('DesenCadenaFacFacturador'));
        if (trigger.isUpdate && !BanderasEjecucion.ValidarEjecucion('DesenCadenaFacFacturador')) {
            LTE_DetalleOferta_cls.actualizarOC(trigger.oldMap,trigger.newMap);  
            lteEnvEquipos.enviarInfoFactEquiposPosVentaPrimeraFactura(trigger.new,trigger.oldMap);
            BanderasEjecucion.setEjecucion('DesenCadenaFacFacturador');
        }

        if (trigger.isDelete) {
            
        }

        if (trigger.isUndelete) {

        }
    }
}