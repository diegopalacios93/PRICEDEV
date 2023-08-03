global class etb_ViabilityCreationByQuoteLineItem implements vlocity_cmt.VlocityOpenInterface2 {
    @TestVisible
    private static final String METHOD_VIABILITY_CREATION          = 'viabilityCreating';
    @TestVisible
    private static final String METHOD_VIABLE_QUOTE_LINE_ITEMS          = 'viableQuoteLineItems';
    
    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
             /*if (METHOD_VIABILITY_CREATION.equalsIgnoreCase(methodName)) {
                return viabilityCreating(inputMap, outMap, options);
            } else*/ if (METHOD_VIABLE_QUOTE_LINE_ITEMS.equalsIgnoreCase(methodName)) {
                return viableQuoteLineItems(inputMap, outMap, options);
            }
            else {
                return false;
            }
        }
        catch (Exception thrownException) {
            return false;
        }
    }
    /*
    private boolean viabilityCreating(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        
        List<Object> items = (List<Object>)inputMap.get('itemList');
        Id recordType = (Id)inputMap.get('recordItem');
        Id quoteId = (Id)inputMap.get('quoteId');
        Map<String, Object> Obj = new Map<String,Object>();
        
        
        Viabilidad__c viabilidad = new Viabilidad__c();
        QuoteLineItem QLI = new QuoteLineItem();
        List<QuoteLineItem> ListQLI = new List<QuoteLineItem>();
        
        try{
            
            for(Object LineItem : items){
                System.debug('obj REbeca' + JSON.serializePretty(LineItem));
                Obj = (Map<String, Object>) LineItem;    
                viabilidad = new Viabilidad__c();
                
                if(Obj.get('requireViabilidad') == true){
                   
                        viabilidad.EstadoViabilidad__c = 'En proceso';
                        viabilidad.RecordTypeId = recordType;
                        viabilidad.Id = (Id)Obj.get('viabilidad');
                        upsert viabilidad;
                        
                        
                        QLI.Id = (Id)Obj.get('Id');
                        QLI.PricebookEntryId = (Id)Obj.get('priceboock');
                    	QLI.QuoteId = (Id)Obj.get('IdRaiz');
                    	QLI.Product2Id = (Id)Obj.get('producto');
                        QLI.Quantity =(double) Obj.get('Quantity');
                        QLI.Viabilidad__c = viabilidad.Id;
                        QLI.UnitPrice = 12;
                        Upsert QLI;
                        ListQLI.add(QLI);
                          
                }      
            }
        }catch(exception e){
            System.debug('mensaje ' + e.getMessage());
            System.debug('linea ' + e.getLineNumber());
        }
        System.debug('Lista ' + ListQLI);
        //Upsert ListQLI;
        
        outMap.put('resultado', ListQLI);
        return true;
    }
	*/
    
    
    
    private boolean viableQuoteLineItems(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        
        Id quoteId = (Id)inputMap.get('quoteId');
        Id recordType = (Id)inputMap.get('recordItem');
        Date todayDate = Date.today();
        String VIABLE = 'Viable';
        String NO_VIABLE = 'No Viable';
        String CERRADA = 'Cerrada';
        String PENDIENTE = 'Pendiente';

        List<Viabilidad__c> viabilidadesList = new List<Viabilidad__c>();
        Viabilidad__c viabilidad = new Viabilidad__c();
        List<QuoteLineItem> ListQLI = new List<QuoteLineItem>();
        List<Id> qliIds = new List<Id>();
        List<Id> idsProducts = new List<Id>();
        try{
            
           List<QuoteLineItem> LQLM =[SELECT id,quoteid,viabilidad__r.respuestadeviabilidad__c,viabilidad__c,viabilidad__r.estadoviabilidad__c,
                                       viabilidad__r.viabilidadnoviable__c,viabilidad__r.fecha_final_estado__c,vlocity_cmt__product2id__c,
                                       vlocity_cmt__product2id__r.name,quote.opportunity.account.name,vlocity_cmt__serviceaccountid__c,
                                       vlocity_cmt__billingaccountid__c,vlocity_cmt__billingaccountid__r.name,vlocity_cmt__serviceaccountid__r.name,
                                       lineitemcontact__c,product2.productcode,product2.family,pricebookentryid,quantity,UnitPrice,Product2Id  
                                       FROM QuoteLineItem 
                                       WHERE QuoteId =: quoteId];
            System.debug('LQLM ' + LQLM);
            System.debug('LQLM ' + LQLM.size());
           
            for(QuoteLineItem qli: LQLM){
                qliIds.add(qli.Product2Id);
            }
            System.debug('id lqlm ' + qliIds);
            
			List<TOPP__c> topps = [select Id, Producto__c, AplicaPreventa__c,Producto__r.ProductCode 
                                   from TOPP__c 
                                   WHERE TipodeOperacionporplan__c = 'Venta' AND AplicaPreventa__c = true AND Producto__c IN :qliIds];
            System.debug('TOPP ' + topps);
            
            for(TOPP__c obj: topps){
                idsProducts.add(obj.Producto__c);
            }
            System.debug('ids topp ' + idsproducts);
            
           List<QuoteLineItem> LQLI =[SELECT id,Quote.OpportunityId,quoteid,viabilidad__r.respuestadeviabilidad__c,viabilidad__c,viabilidad__r.estadoviabilidad__c,
                                       viabilidad__r.viabilidadnoviable__c,viabilidad__r.fecha_final_estado__c,vlocity_cmt__product2id__c,
                                       vlocity_cmt__product2id__r.name,quote.opportunity.account.name,vlocity_cmt__serviceaccountid__c,
                                       vlocity_cmt__billingaccountid__c,vlocity_cmt__billingaccountid__r.name,vlocity_cmt__serviceaccountid__r.name,
                                       lineitemcontact__c,product2.productcode,product2.family,pricebookentryid,quantity,UnitPrice,Product2Id, 
                                       vlocity_cmt__AttributeSelectedValues__c  
                                       FROM QuoteLineItem 
                                       WHERE QuoteId =: quoteId AND Product2Id IN: idsProducts AND (Viabilidad__c ='' OR (Viabilidad__r.EstadoViabilidad__c =: CERRADA   
                                                                                                AND Viabilidad__r.ViabilidadNoViable__c = false ))];
            System.debug('porductos viables ' + LQLI);
            System.debug('Lista QLI; ' + LQLI.size());
            
            etb_ProcesoViabilidad__mdt PV = [SELECT Id,umbralDeVencimiento__c FROM etb_ProcesoViabilidad__mdt];
            System.debug('Metadata; ' + PV);
            
            
            for(QuoteLineItem QLI:LQLI){
                //System.debug('Obj QLI ' + JSON.serializePretty(QLI));
                
                viabilidad = new Viabilidad__c();
                Integer difDays =0;
                Integer vigenciaViabilidadDias = 90;

                if(QLI.Viabilidad__c == null){
                    System.debug('viabilidad vacia');
                    viabilidad.EstadoViabilidad__c = PENDIENTE;
                    viabilidad.RecordTypeId = recordType;
                    viabilidad.Quote_Line_Item__c = QLI.Id;
                    viabilidad.Oportunidad__c = QLI.Quote.OpportunityId;

                    
                    System.debug('Viavilidad new sin previo registro ' + viabilidad);

                    viabilidadesList.add(viabilidad);
                    System.debug('viabilidadesList TEMP: ' + viabilidadesList );
                    // QLI.Viabilidad__c =viabilidad.Id;
                    ListQLI.add(QLI);
                    //System.debug('ListQLI TEMP: ' + ListQLI );
                    
                }else{
                    System.debug('viabilidad llena');
                    Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(QLI.vlocity_cmt__AttributeSelectedValues__c);
                    System.debug('dS: ' + deserialized);
                    Integer vvd = Integer.valueOf(deserialized.get('ATT_Vigencia_Viabilidad_Dias'));
                    System.debug('vvd: ' + vvd);
                    if(vvd != null){
                        vigenciaViabilidadDias = vvd;
                    }

                    if(QLI.viabilidad__r.respuestadeviabilidad__c == VIABLE){
                        System.debug('viabilidad viable');
                        if(QLI.Viabilidad__r.fecha_final_estado__c !=null){
                            System.debug('viabilidad viable con ffe llena');
                            System.debug('fecha final estado: ' + QLI.viabilidad__r.fecha_final_estado__c);
                            System.debug('fecha comparacion: ' + QLI.viabilidad__r.fecha_final_estado__c.addDays(vigenciaViabilidadDias));
                            difDays = todayDate.daysBetween(QLI.viabilidad__r.fecha_final_estado__c.addDays(vigenciaViabilidadDias));
                        }else{
                            System.debug('viabilidad viable con ffe vacia. No se creea Viabilidad');
                        }               
                        System.debug('dias diff ' + difDays);
                        System.debug('Id viabilidad ' + QLI.Viabilidad__c);
                        if(difDays < 0){
                            System.debug('viabilidad viable con fecha vencida');
                            
                            viabilidad.EstadoViabilidad__c = PENDIENTE;
                            viabilidad.RecordTypeId = recordType;
                            viabilidad.Quote_Line_Item__c = QLI.Id;
                            viabilidad.Oportunidad__c = QLI.Quote.OpportunityId;
                        
                            System.debug('Viavilidad new  viable vencida' + viabilidad);

                            viabilidadesList.add(viabilidad);
                            System.debug('viabilidadesList TEMP: ' + viabilidadesList );

                            // QLI.Viabilidad__c =viabilidad.Id;
                            ListQLI.add(QLI);
                            // System.debug('ListQLI TEMP: ' + ListQLI );

                        } else{
                            System.debug('viabilidad viable con fecha vigente');
                        }
                    }else if(QLI.viabilidad__r.respuestadeviabilidad__c == NO_VIABLE){
                        System.debug('viabilidad no viable');

                        viabilidad.EstadoViabilidad__c = PENDIENTE;
                        viabilidad.RecordTypeId = recordType;
                        viabilidad.Quote_Line_Item__c = QLI.Id;
                        viabilidad.Oportunidad__c = QLI.Quote.OpportunityId;
                    
                        System.debug('Viavilidad new no viable ' + viabilidad);

                        viabilidadesList.add(viabilidad);
                        System.debug('viabilidadesList TEMP: ' + viabilidadesList );

                        // QLI.Viabilidad__c =viabilidad.Id;
                        ListQLI.add(QLI);
                        // System.debug('ListQLI TEMP: ' + ListQLI );
                    }
                }
                
            }
            System.debug('viabilidadesList FINAL: ' + viabilidadesList );
            System.debug('ListQLI before assign Viability: ' + ListQLI );
            
            insert viabilidadesList;

            for( Integer i = 0; i < ListQLI.size(); i++){
                ListQLI[i].viabilidad__c = viabilidadesList[i].Id;
            }
            System.debug('ListQLI after assign Viability:: ' + ListQLI );


            Update ListQLI;
            outMap.put('items',ListQLI);
        }catch(exception e){
            System.debug('mensaje ' + e.getMessage());
            System.debug('linea ' + e.getLineNumber());
        }
        
        
        return true;
    }

}