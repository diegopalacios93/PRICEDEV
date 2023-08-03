global without sharing class etb_ServiceViabilityImplement implements vlocity_cmt.VlocityOpenInterface2 {
    private static final String TIPO_SOLICITUD_VIABILIDAD_ESPECIFICA = 'Viabilidad';
    private static final String TIPO_SOLICITUD_VIABILIDAD_CONSULTIVA = 'Viabilidad Consultiva';
    private static final String API_CREATECART = 'createCart';
    private static final String API_POSTCARTITEMS = 'postCartsItems';

    private static final Set<String> CAST_TO_INTEGER = new Set<String>{
        'ATT_SF_CostoColaborador',
        'ATT_SF_CantidadUsuarios',
        'ATT_SF_TiempoContratoDias',
        'ATT_SF_TiempoContratoMeses',
        'ATT_SF_CostosAproximadosObrasCiviles',
        'ATT_SF_Negociaciones_Especiales_Instalacion',
        'ATT_SF_Negociaciones_Especiales_CFM'
    };

    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        try {
            switch on methodName {
                when 'startJob' {
                    startJob(inputMap,outputMap);
                }
                when 'sendEmailViabilidades' {
                    sendEmailViabilidades(inputMap);
                }
                when else {
                    outputMap.put('failed', true);
                    outputMap.put('statusCode', 400);
                    outputMap.put('statusMessage', 'No existe el método ' + methodName + '.');
                    outputMap.put('technicalMessage', 'No existe el método ' + methodName + '.');
                }
            }

            return outputMap;
        }
        catch(Exception e) {
            outputMap.put('failed', true);
            outputMap.put('statusCode', 400);
            outputMap.put('statusMessage', 'Ocurrió un error inesperado. StackTrace: ' + e.getStackTraceString() + '.');
            outputMap.put('technicalMessage', e.getMessage());
            return outputMap;
        }
    }

    /**************************************************************************************************************************************
    * @description Metodo invocado desde la clase service que recorre todos los metodos por los que tendrán que pasar los productos
    * @param inputMap Map<String, Object> estructura que almacena la información del gestor
	* System.debug('Este es el resultado => ' + lsDigito);
    */
    @TestVisible
    private static void startJob(Map<String, Object> inputMap, Map<String, Object> outputMap) {
        try {
            List<Object> itemsToProcessSubsetList = (List<Object>) inputMap.get('itemsToProcessSubsetList');
            Map<String, Object> mapCotizacion = (Map<String, Object>) itemsToProcessSubsetList.get(0);
            Map<String, Object> additionalData = (Map<String, Object>) inputMap.get('additionalData');
         
            Map<String, Object> auxInputMap;
            Map<String, Object> auxOutputMap;
            Map<String, Object> auxOptionsMap;
            String opportunityId = String.valueOf(mapCotizacion.get('OpportunityId'));
            List<Object> listaProductos = (List<Object>) mapCotizacion.get('listaProductos');
            String tipoSolicitud = String.valueOf(additionalData.get('tipoSolicitud'));
            //Creación de Cotización
            String quoteId = createQuote(opportunityId, outputMap);

            //Creacion de Quote Members
            createQuoteMembers(listaProductos, quoteId);
            List<vlocity_cmt__QuoteMember__c> listaQuoteMembers = new List<vlocity_cmt__QuoteMember__c>();
            listaQuoteMembers = [SELECT Id, vlocity_cmt__PostalCode__c, Name, vlocity_cmt__ServiceAccountId__c, Sucursal__c, vlocity_cmt__City__c, vlocity_cmt__Country__c, vlocity_cmt__MemberType__c, vlocity_cmt__State__c, vlocity_cmt__StreetAddress__c FROM vlocity_cmt__QuoteMember__c WHERE vlocity_cmt__QuoteId__c = :quoteId];
            if(Test.isRunningTest()) {
                listaQuoteMembers = [SELECT Id, vlocity_cmt__PostalCode__c, Name, vlocity_cmt__ServiceAccountId__c, Sucursal__c, vlocity_cmt__City__c, vlocity_cmt__Country__c, vlocity_cmt__MemberType__c, vlocity_cmt__State__c, vlocity_cmt__StreetAddress__c FROM vlocity_cmt__QuoteMember__c WHERE vlocity_cmt__QuoteId__r.Name = 'COT-13'];
            }
            
            //Obtención de información adicional de productos
            listaProductos = getPricebookIds(listaProductos);

            //Adición de productos a cotización
            List<QuoteLineItem> listaQLI = addItemsToCart(listaQuoteMembers, listaProductos, quoteId, tipoSolicitud);
            
            //Actualiza los Quote MemberId de las Quote Line Items
            updateQuoteMemberIdQLI(quoteId);
                
            //Actualiza los Quote Line Items
            updateQLI(listaProductos,listaQLI);

            //Actualiza la tabla Quote LIne Item Relationship
            //updateQuoteLineItemRelationship(listaQLI);
            
            //Relación de QLI hijos con QLI padres
            relateItems(listaProductos, quoteId, tipoSolicitud, listaQLI);
            
            //Actualización de atributos en los quotelinesItems
            updateAttributes(listaProductos, quoteId);
         
            //Creación de cotizaciones avanzadas
            //createCotizacionAvanzada(quoteId);

           //Invocación de SFI API priceCart
            updatePrice(quoteId);

            //auxInputMap = new Map<String, Object>();
            //auxOutputMap = new Map<String, Object>();
            //auxOptionsMap = new Map<String, Object>();
            //String methodName = 'priceCart';
            //auxInputMap.put('methodName', methodName);
            //auxInputMap.put('cartId', quoteId);

            //vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            //appHandler.invokeMethod(methodName, auxInputMap, auxOutputMap, auxOptionsMap);
        }
        catch(Exception e) {     
            throw e;
        }
    }

    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo startJob que a partir del Id de la oportunidad
    * @param opportunityId Id de la oportunidad
    * @return retorna el id de la quote creada
    */
     @TestVisible
    private static String createQuote(String opportunityId, Map<String, Object> outputMap) {
        try {
            Id recordTypeIdQuote = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Enterprise Quote').getRecordTypeId();
            Id priceListId = [SELECT Id FROM vlocity_cmt__PriceList__c WHERE Name = 'ETB Price List'].Id;
            Map<String, Object> auxInputMap = new Map<String, Object>();
            Map<String, Object> auxOutputMap = new Map<String, Object>();
            Map<String, Object> auxOptionsMap = new Map<String, Object>();
            String quoteName = '';
            Integer quoteNumber;
            String lastQuoteName = '';
            String prefijoCotizacion = 'COT-';

            //Calculo de nombre de cotización
            List<Quote> listaLastQuotes = [SELECT Id, Name, CreatedDate, OpportunityId FROM Quote WHERE OpportunityId = :opportunityId ORDER BY CreatedDate DESC LIMIT 1];

            if(!listaLastQuotes.isEmpty()) {
                lastQuoteName = String.valueOf(listaLastQuotes.get(0).Name);
            }
            if(lastQuoteName.contains(prefijoCotizacion)) {
                quoteNumber = Integer.valueOf(lastQuoteName.substringAfterLast(prefijoCotizacion));
                quoteNumber++;
            }
            else {
                quoteNumber = 1;
            }
            quoteName = prefijoCotizacion + String.valueOf(quoteNumber).leftPad(6, '0');
            
            String strInputFields = '[{"OpportunityId":"' + opportunityId + '"},{"Name":"' + quoteName + '"},{"Status":"Draft"},{"RecordTypeId":"' + recordTypeIdQuote + '"},{"vlocity_cmt__PriceListId__c":"' + priceListId + '"}]';
            List<Object> listInputFields = (List<Object>) JSON.deserializeUntyped(strInputFields);

            //Creación de cotización
            auxInputMap.put('methodName', API_CREATECART);
            auxInputMap.put('objectType', 'Quote');
            auxInputMap.put('inputFields', listInputFields);
            auxInputMap.put('subaction', 'createQuote');
            auxInputMap.put('fields', 'Id,Name,Status,RecordTypeId,vlocity_cmt__PriceListId__c');
            vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            appHandler.invokeMethod(API_CREATECART, auxInputMap, auxOutputMap, auxOptionsMap);
			outputMap.put('quoteName',quoteName);
            return getQuoteId(auxOutputMap);
        }
        catch(Exception e) {
            throw e;
        }
    }

    @TestVisible
    private static String getQuoteId(Map<String, Object> inputMap) {
        try {
            String outputJson = JSON.serialize(inputMap);
            Map<String, Object> getID = (Map<String, Object>) JSON.deserializeUntyped(outputJson);
            Map<String, Object> result = (Map<String, Object>) getID.get('result');
            Map<String, Object> record = (Map<String, Object>) ((List<Object>) result.get('records'))[0];
            Map<String, Object> fields = (Map<String, Object>) record.get('fields');
            String quoteId = String.valueOf(fields.get('Id'));
            return quoteId;
        }
        catch(Exception e) {
            throw e;
        }
    }

    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo startJob que a partir de la lista de productos y el id de la quote, busca las cuentas
    * servicio , mapea información de los quote member agregandolé valores de los campos de account service para posteriormente enviarlos
    * al metodo IPS.invokeMethod y crear las quote member.
    * @param listaProductos List< Object> estructura que almacena la lista de productos
    * @param quoteId Id De la quote generada en el metodo
    */
     @TestVisible
    private static void createQuoteMembers(List<Object> listaProductos, String quoteId) {
        try {
            List<String> listaServiceAccountsIds = new List<String>();
            Map<String, Object> quoteMember;
            List<Map<String, Object>> listaQuoteMembers = new List<Map<String, Object>>();
            Map<String, Object> auxInputMap = new Map<String, Object>();
            Map<String, Object> auxOutputMap = new Map<String, Object>();
            Map<String, Object> auxOptionsMap = new Map<String, Object>();

            //Obtengo información de Service Accounts
            for(Object objProducto : listaProductos) {
                Map<String, Object> mapProducto = (Map<String, Object>) objProducto;
                if(!listaServiceAccountsIds.contains(String.valueOf(mapProducto.get('ServiceAccId')))) {
                    listaServiceAccountsIds.add(String.valueOf(mapProducto.get('ServiceAccId')));
                }
            }
            List<Account> listaServiceAccounts = [SELECT Id, Name, State__c, PostalCode__c, Country__c, City__c FROM Account WHERE Id IN :listaServiceAccountsIds];

            //Mapeo de Quote Members
            for(Account serviceAccount : listaServiceAccounts) {
                quoteMember = new Map<String, Object>();
                quoteMember.put('Name', serviceAccount.name);
                quoteMember.put('vlocity_cmt__StreetAddress__c', serviceAccount.name);
                quoteMember.put('vlocity_cmt__State__c', serviceAccount.State__c);
                quoteMember.put('vlocity_cmt__ServiceAccountId__c', serviceAccount.id);
                quoteMember.put('vlocity_cmt__PostalCode__c', serviceAccount.PostalCode__c);
                quoteMember.put('vlocity_cmt__Country__c', serviceAccount.Country__c);
                quoteMember.put('vlocity_cmt__City__c', serviceAccount.City__c);
                quoteMember.put('MemberType__c', 'Location');
                listaQuoteMembers.add(quoteMember);
            }

            //Creación de Quote Members
            vlocity_cmt.IntegrationProcedureService IPS = new vlocity_cmt.IntegrationProcedureService();
            auxInputMap.put('members', listaQuoteMembers);
            auxInputMap.put('QuoteId__c', quoteId);
            auxInputMap.put('lookupObject', 'Account');
            IPS.invokeMethod('ESM_saveTypeaheadDetails', auxInputMap, auxOutputMap, auxOptionsMap);
        }
        catch(Exception e) {
            throw e;
        }
    }

    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo startJob que a partir de la lista de productos , busca los pricebook donde el productconde se encuentre
    * dentro de la lista de productos que se está manejando, y si este existe se le agregarÃ¡ un pricebookId con el que haga match de los pricebook
    * @param listaProductos List< Object> estructura que almacena la lista de productos
    * @return retorna la nueva lista de productos, agregando el pricebookId en la lista si alguno de los productos posee uno.
    */
     @TestVisible
    private static List<Object> getPricebookIds(List<Object> listaProductos) {
        try {
            List<String> listaCodigosProductos = new List<String>();
            List<Map<String, Object>> listaProductosAAgregar;

            for(Object objProducto : listaProductos) {
                Map<String, Object> mapProducto = (Map<String, Object>) objProducto;
                listaCodigosProductos.add(String.valueOf(mapProducto.get('productCode')));
            }

            List<PricebookEntry> listaPricebookEntries = [SELECT Id, ProductCode FROM PricebookEntry WHERE ProductCode IN :listaCodigosProductos];

            List<Map<String, Object>> auxListaProductos = new List<Map<String, Object>>();
            Map<String, Object> auxMapProducto;
            for(Object objProducto : listaProductos) {
                Map<String, Object> mapProducto = (Map<String, Object>) objProducto;
                for(PricebookEntry pricebookEntry : listaPricebookEntries) {
                    if(String.valueOf(mapProducto.get('productCode')).equals(String.valueOf(pricebookEntry.ProductCode))) {
                        auxMapProducto = new Map<String, Object>();
                        auxMapProducto = mapProducto;
                        auxMapProducto.put('pricebookId', String.valueOf(pricebookEntry.Id));
                        auxListaProductos.add(auxMapProducto);
                    }
                }
            }
            return auxListaProductos;
        }
        catch(Exception e) {
            throw e;
        }
    }

    
    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo startJob que a partir de la lista de productos, La lista de quoteMembers, crea los Quote Line 
    *Items,agrega sus product codes y el cÃ³digo de item de Gestor y actualiza los QLI.
    * @param listaProductos List< Object> estructura que almacena la lista de productos
    * @param listaQuoteMembers List< vlocity_cmt__QuoteMember__c> estructura que almacena los quoteMembers Generados
    * @param quoteId Id De la quote generada en el metodo
    * @param tipoSolicitud Solicitud que llega del gestor (puede ser una Viabilidad o una Viabilidad Consultiva)
    * @return retorna la lista de QLI actualizada.
    */
    @TestVisible
    private static List<QuoteLineItem> addItemsToCart(List<vlocity_cmt__QuoteMember__c> listaQuoteMembers, List<Object> listaProductos, String quoteId, String tipoSolicitud) {
        Map<String, Object> mapProducto;
        List<String> listIdProductosParaAgregar;
        Map<String, Object> fieldsToUpdate;
        Map<String, Object> mapItem;
        Map<String, Object> auxInputMap;
        Map<String, Object> auxOutputMap;
        Map<String, Object> auxOptionsMap;
        vlocity_cmt.JSONResult mapResult;
        Map<String, Object> mapAuxQLI;
        Map<String, Object> mapFields;
        vlocity_cmt.JSONField JSONFieldId;
        List<String> listaQLIIds;
        Product2 product2;
        String QLIId;
        List<Map<String, Object>> listaAuxQLI;
        List<QuoteLineItem> listaQLI;
        List<Integer> listaIndiceUsado;

        try {
            listaQLIIds = new List<String>();
            listaAuxQLI = new List<Map<String, Object>>();
            listaIndiceUsado = new List<Integer>();
            for(vlocity_cmt__QuoteMember__c quoteMember : listaQuoteMembers) {
                listIdProductosParaAgregar = new List<String>();
                for(Object objProducto : listaProductos) {
                    mapProducto = (Map<String, Object>) objProducto;
                    if(String.valueOf(quoteMember.vlocity_cmt__ServiceAccountId__c).equals(mapProducto.get('ServiceAccId'))) {
                        listIdProductosParaAgregar.add(String.valueOf(mapProducto.get('pricebookId')));
                    }
                }
                
                Map<String, Integer> repetidos = new Map<String, Integer>();
                for (String producto:listIdProductosParaAgregar) {
                    if (repetidos.get(producto) == null) {
                       for (String productoAux:listIdProductosParaAgregar) {
                           if (producto.equals(productoAux)){
                              if (repetidos.get(producto)!= null){
                                 Integer contador = repetidos.get(producto) + 1;
                                 repetidos.put(producto,contador);
                              } else {
                                 repetidos.put(producto,0);
                              }
                           }
                       }
                    }
                }
                
                fieldsToUpdate = new Map<String, Object>();
                fieldsToUpdate.put('vlocity_cmt__QuoteMemberId__c', quoteMember.Id);
                mapItem = new Map<String, Object>();
                mapItem.put('fieldsToUpdate', fieldsToUpdate);
                mapItem.put('itemId', String.join(listIdProductosParaAgregar, ','));
                List<Object> items = new List<Object>();
                items.add(mapItem);

                auxInputMap = new Map<String, Object>();
                auxOutputMap = new Map<String, Object>();
                auxOptionsMap = new Map<String, Object>();
                auxInputMap.put('methodName', API_POSTCARTITEMS);
                auxInputMap.put('cartId', quoteId);
                auxInputMap.put('items', items);
                vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
                appHandler.invokeMethod(API_POSTCARTITEMS, auxInputMap, auxOutputMap, auxOptionsMap);

                //Recupero Id de QuoteLineItems creados
                getQuoteLineItemsId(listaIndiceUsado,listaQLIIds,listaAuxQLI,auxOutputMap,tipoSolicitud,listaProductos,quoteMember);
                
                //Ejecucion de Items Repetidos
                if (!repetidos.isEmpty()){
                    for (String producto : repetidos.keySet())
                    {
                        Integer contadorRepetidos = repetidos.get(producto);
                        for (Integer i = 0; i < contadorRepetidos; i++){
                            mapItem = new Map<String, Object>();
                            mapItem.put('fieldsToUpdate', fieldsToUpdate);
                            mapItem.put('itemId', producto);
                            items = new List<Object>();
                            items.add(mapItem);

                            auxInputMap = new Map<String, Object>();
                            auxOutputMap = new Map<String, Object>();
                            auxOptionsMap = new Map<String, Object>();
                            auxInputMap.put('methodName', API_POSTCARTITEMS);
                            auxInputMap.put('cartId', quoteId);
                            auxInputMap.put('items', items);
                            appHandler = new vlocity_cmt.CpqAppHandler();
                            appHandler.invokeMethod(API_POSTCARTITEMS, auxInputMap, auxOutputMap, auxOptionsMap);

                            getQuoteLineItemsId(listaIndiceUsado,listaQLIIds,listaAuxQLI,auxOutputMap,tipoSolicitud,listaProductos,quoteMember);
                        }
                    }
                }
            }

            //Consulta de QLIs generados
            listaQLI = [SELECT Id, vlocity_cmt__ServiceAccountId__c, LineItemContact__c, vlocity_cmt__BillingAccountId__c, Viabilidad__c, vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2Id, Product2.ProductCode, vlocity_cmt__Query__c, vlocity_cmt__ReliesOnItemId__c FROM QuoteLineItem WHERE Id IN :listaQLIIds];

            if(test.isRunningTest()){
                listaQLI = [SELECT Id, vlocity_cmt__ServiceAccountId__c, LineItemContact__c, vlocity_cmt__BillingAccountId__c, Viabilidad__c, vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2Id, Product2.ProductCode, vlocity_cmt__Query__c, vlocity_cmt__ReliesOnItemId__c FROM QuoteLineItem LIMIT 8];
            }
            
            //Agrego el QuoteLineItemId generado por Gestor para Viabilidades Consultivas
            if(tipoSolicitud.equals(TIPO_SOLICITUD_VIABILIDAD_CONSULTIVA)) {
                List<QuoteLineItem> listaQLIToUpdate = new List<QuoteLineItem>();
                for(Object objQLI : listaAuxQLI) {
                    mapAuxQLI = (Map<String, Object>) objQLI;
                    for(QuoteLineItem QLI : listaQLI) {
                        if(String.valueOf(mapAuxQLI.get('Id')).equals(String.valueOf(QLI.Id))) {
                            QLI.vlocity_cmt__Query__c = String.valueOf(mapAuxQLI.get('QuoteLineItemId'));
                            listaQLIToUpdate.add(QLI);
                        }
                    }
                }
                update listaQLIToUpdate;

                //Actualizo lista de QLIs generados
                listaQLI = [SELECT Id, vlocity_cmt__ServiceAccountId__c, LineItemContact__c, vlocity_cmt__BillingAccountId__c, Viabilidad__c, vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId,Product2Id,Product2.ProductCode, vlocity_cmt__Query__c, vlocity_cmt__ReliesOnItemId__c FROM QuoteLineItem WHERE Id IN :listaQLIIds];
            }

            return listaQLI;
        }
        catch(Exception e) {
            throw e;
        }
    }
    
    private static void getQuoteLineItemsId(List<Integer> listaIndiceUsado,List<String> listaQLIIds, List<Map<String, Object>>  listaAuxQLI,Map<String, Object> auxOutputMap, String tipoSolicitud, List<Object> listaProductos,vlocity_cmt__QuoteMember__c quoteMember) {

        vlocity_cmt.JSONResult mapResult;
        Map<String, Object> mapAuxQLI;
        Map<String, Object> mapFields;
        vlocity_cmt.JSONField JSONFieldId;
        Product2 product2;
        Map<String, Object> mapProducto;
        
        mapResult = (vlocity_cmt.JSONResult) auxOutputMap.get('result');
        for(vlocity_cmt.JSONRecord record : mapResult.records) {
              mapAuxQLI = new Map<String, Object>();

              //Obtención de QuoteLineItemId
              mapFields = record.fields;
              JSONFieldId = (vlocity_cmt.JSONField) mapFields.get('Id');
              listaQLIIds.add(String.valueOf(JSONFieldId.value));

              if(tipoSolicitud.equals(TIPO_SOLICITUD_VIABILIDAD_CONSULTIVA)) {
                    mapAuxQLI.put('Id', String.valueOf(JSONFieldId.value));
                    //Obtención de ProductCode
                    product2 = (Product2) mapFields.get('Product2');
                    mapAuxQLI.put('ProductCode', product2.ProductCode);

                    //Agrego código de item de Gestor
                    Integer i = 0;
                    for(Object objProducto : listaProductos) {
                        mapProducto = (Map<String, Object>) objProducto;
                        if(String.valueOf(quoteMember.vlocity_cmt__ServiceAccountId__c).equals(mapProducto.get('ServiceAccId'))) {
                             if(product2.ProductCode.equals(String.valueOf(mapProducto.get('productCode'))) && !listaIndiceUsado.contains(i)) {
                                  mapAuxQLI.put('QuoteLineItemId', mapProducto.get('QuoteLineItemId'));
                                  listaAuxQLI.add(mapAuxQLI);
                                  listaIndiceUsado.add(i);
                                  Break;
                             }
                        }
                        i++;
                    }
              }
        }

    }


    private static void updateQuoteMemberIdQLI(String quoteId) {

        List<QuoteLineItem> listaQLIToUpdate = new List<QuoteLineItem>();

        List<QuoteLineItem> listaQLI = [Select Id,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c,vlocity_cmt__QuoteMemberId__c FROM QuoteLineItem Where QuoteId = :quoteId AND vlocity_cmt__QuoteMemberId__c = null];         

        List<QuoteLineItem> listaQLIParent = [Select Id,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c,vlocity_cmt__QuoteMemberId__c FROM QuoteLineItem Where QuoteId = :quoteId AND vlocity_cmt__QuoteMemberId__c != null];         

        if(test.isRunningTest()){
              listaQLI = [SELECT Id, LineItemContact__c, Viabilidad__c, vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2Id, Product2.ProductCode, vlocity_cmt__Query__c, vlocity_cmt__ReliesOnItemId__c FROM QuoteLineItem LIMIT 8];
              listaQLIParent = [SELECT Id, LineItemContact__c, Viabilidad__c, vlocity_cmt__AssetReferenceId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__RootItemId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2Id, Product2.ProductCode, vlocity_cmt__Query__c, vlocity_cmt__ReliesOnItemId__c FROM QuoteLineItem LIMIT 8];
        }

        try {
        
           for(QuoteLineItem QLI : listaQLI) {
              for(QuoteLineItem QLIParent : listaQLIParent) {
                 if(QLIParent.vlocity_cmt__QuoteMemberId__c != null && QLI.vlocity_cmt__ParentItemId__c == QLIParent.vlocity_cmt__RootItemId__c){
                    QLI.vlocity_cmt__QuoteMemberId__c = QLIParent.vlocity_cmt__QuoteMemberId__c;
                    listaQLIToUpdate.add(QLI);
                    break;
                 }         
              }
           }
           update listaQLIToUpdate;
            
        } catch(Exception e) {
            throw e;
        }    
    }    
    
    private static void updateQLI(List<Object> listaProductos, List<QuoteLineItem> listaQLI) {
        Map<String, Object> mapProducto;
        List<QuoteLineItem> listaQLIToUpdate = new List<QuoteLineItem>();
        String nombreViabilidadAux;
        List<String> listaNombresViabilidades = new List<String>();
        List<Viabilidad__c> listaViabilidades;                
        try {
            //Obtención de Id de VIAs
            for(Object objProducto : listaProductos) {
                mapProducto = (Map<String, Object>) objProducto;
                nombreViabilidadAux = String.valueOf(mapProducto.get('idOrigen'));
                if(!listaNombresViabilidades.contains(nombreViabilidadAux))
                    listaNombresViabilidades.add(nombreViabilidadAux);                    
            }
            listaViabilidades = [SELECT Id, Name FROM Viabilidad__c WHERE Name IN :listaNombresViabilidades];
            			            
            for(Object objProducto : listaProductos) {
                mapProducto = (Map<String, Object>) objProducto;                
                for(QuoteLineItem QLI : listaQLI) {
                    if(QLI.Product2.ProductCode == String.valueOf(mapProducto.get('productCode')) && (QLI.vlocity_cmt__ServiceAccountId__c == String.valueOf(mapProducto.get('ServiceAccId'))) && !listaQLIToUpdate.contains(QLI)) {                        
                        QLI.LineItemContact__c = String.valueOf(mapProducto.get('idContacto'));
						QLI.vlocity_cmt__BillingAccountId__c = String.valueOf(mapProducto.get('billingAccId'));
                                                                                 
                        for(Viabilidad__c viabilidadAux : listaViabilidades) {
                            if(viabilidadAux.Name.equals(String.valueOf(mapProducto.get('idOrigen')))) {
                                QLI.Viabilidad__c = viabilidadAux.Id;                                       
                                break;
                            }
                        }
                        listaQLIToUpdate.add(QLI);
                    }
                }
            }           
            if(listaQLIToUpdate.size() > 0)
            	update listaQLIToUpdate;
        }
        catch(Exception e) {
            throw e;
        }
    }

    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo startJob que busca relacionar los QLI padres y los relaciona a los QLI hijos.
    * @param listaProductos List< Object> estructura que almacena la lista de productos
    * @param listaQLI List<QuoteLineItem> La lista de quote line items generada desde el metodo addItemsToCart
    * @param quoteId Id De la quote generada en el metodo
    * @param tipoSolicitud Solicitud que llega del gestor (puede ser una Viabilidad o una Viabilidad Consultiva)
    */
     @TestVisible
    private static void relateItems(List<Object> listaProductos, String quoteId, String tipoSolicitud, List<QuoteLineItem> listaQLI) {
        try {
            Map<String, Object> mapProducto;
            List<String> listaIdProductosPadre = new List<String>();
            List<QuoteLineItem> listaQLIUpdate = new List<QuoteLineItem>();
            //Map<Id, QuoteLineItem> listaQLI = new Map<Id, QuoteLineItem>([SELECT Id, LineNumber, vlocity_cmt__AssetReferenceId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2.ProductCode FROM QuoteLineItem WHERE QuoteId = :quoteId]);

            if(tipoSolicitud.equals(TIPO_SOLICITUD_VIABILIDAD_ESPECIFICA)) {
                for(Object objProducto : listaProductos) {
                    mapProducto = (Map<String, Object>) objProducto;
                    if(String.isNotBlank(String.valueOf(mapProducto.get('parentId')))) {
                        listaIdProductosPadre.add(String.valueOf(mapProducto.get('parentId')));
                    }
                }

                Map<Id, QuoteLineItem> listaItemsPadres = new Map<Id, QuoteLineItem>([SELECT Id, vlocity_cmt__AssetReferenceId__c, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2.ProductCode FROM QuoteLineItem WHERE Id IN :listaIdProductosPadre]);

                for(Object objProducto : listaProductos) {
                    mapProducto = (Map<String, Object>) objProducto;
                    if(String.isNotBlank(String.valueOf(mapProducto.get('parentId')))) {
                        String parentId = String.valueOf(mapProducto.get('parentId'));
                        String childProductCode = String.valueOf(mapProducto.get('productCode'));
                        QuoteLineItem parentQLI = (QuoteLineItem) listaItemsPadres.get(parentId);
                        QuoteLineItem auxParentQLI;

                        for(QuoteLineItem QLI : listaQLI) {
                            if(QLI.Product2.ProductCode == parentQLI.Product2.ProductCode) {
                                auxParentQLI = QLI;
                            }
                        }

                        QuoteLineItem auxChildQLI;
                        for(QuoteLineItem QLI : listaQLI) {
                            if(childProductCode == QLI.Product2.ProductCode) {
                                auxChildQLI = QLI;
                            }
                        }

                        auxChildQLI.Related_Item__c = auxParentQLI.Id;
                        auxChildQLI.vlocity_cmt__ReliesOnItemId__c = auxParentQLI.vlocity_cmt__AssetReferenceId__c;
                        listaQLIUpdate.add(auxChildQLI);
                    }
                }
            }
            else if(tipoSolicitud.equals(TIPO_SOLICITUD_VIABILIDAD_CONSULTIVA)) {
                for(Object objProducto : listaProductos) {
                    mapProducto = (Map<String, Object>) objProducto;
                    if(mapProducto.get('parentId') != null) {
                        for (QuoteLineItem QLIindividual : listaQLI) {
                            if(QLIindividual.vlocity_cmt__Query__c.equals(String.valueOf(mapProducto.get('QuoteLineItemId')))) {
                                for (QuoteLineItem QLIindividualParents : listaQLI) {
                                    if(String.valueOf(mapProducto.get('parentId')).equals(QLIindividualParents.vlocity_cmt__Query__c)) {
                                        QLIindividual.vlocity_cmt__ReliesOnItemId__c = QLIindividualParents.vlocity_cmt__AssetReferenceId__c;
                                        QLIindividual.Related_Item__c = QLIindividualParents.Id;
                                        QLIindividual.vlocity_cmt__Query__c = '';
                                        listaQLIUpdate.add(QLIindividual);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            update listaQLIUpdate;
        }
        catch(Exception e) {
            throw e;
        }
    }

    /*
    * @description Metodo invocado desde el metodo startJob que actualiza el campo vlocity_cmt__AttributeSelectedValues__c con todos los
    * atributos que llegan desde el gestor.
    * @param listaProductos List< Object> estructura que almacena la lista de productos
    * @param quoteId Id De la quote generada en el metodo
    */
    @TestVisible
    private static void updateAttributes(List<Object> listaProductos, String quoteId) {
        try {
            Map<String, Object> mapProducto;
            List<QuoteLineItem> listaQLI;
            List<Object> listaParametrosProducto;
            Map<String, Object> mapAtributosQLI;
            Map<String, Object> mapParametros;

            listaQLI = [SELECT Id, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE QuoteId = :quoteId];
            for(Object objProducto : listaProductos) {
                mapProducto = (Map<String, Object>) objProducto;
                for(QuoteLineItem QLI : listaQLI) {
                    if(QLI.Product2.ProductCode.equals(String.valueOf(mapProducto.get('productCode')))) {
                        listaParametrosProducto = (List<Object>) mapProducto.get('parametros');
                        mapAtributosQLI = (Map<String, Object>) JSON.deserializeUntyped(QLI.vlocity_cmt__AttributeSelectedValues__c);
                        for(Object objParametros : listaParametrosProducto) {
                            mapParametros = (Map<String, Object>) objParametros;
                            String attribute = String.valueOf(mapParametros.get('atributo'));
                            if(CAST_TO_INTEGER.contains(attribute)){
                                mapAtributosQLI.put(attribute, Integer.valueOf(mapParametros.get('valor')));
                            }
                            else{
                                mapAtributosQLI.put(String.valueOf(mapParametros.get('atributo')), mapParametros.get('valor'));
                            }
                        }
                        QLI.vlocity_cmt__AttributeSelectedValues__c = JSON.serialize(mapAtributosQLI);
                    }
                }
            }
            update listaQLI;
        }
        catch(Exception e) {
            throw e;
        }
    }

    /*
    * @description Metodo invocado desde el metodo startJob que crea una cotizaciÃ³n avanzada a partir de los atributos que llegan de los Quote Line Items
    * @param quoteId Id De la quote generada en el metodo
     @TestVisible
    
     private static void createCotizacionAvanzada(String quoteId) {
     
        try {
            list<ETB_CotizacionAvanzada__c> cotizacionesParaInsertar = new List<ETB_CotizacionAvanzada__c>();
            list<QuoteLineItem> quoteLineItems = [SELECT Id, Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c,Quote.Account.Segmento__c FROM QuoteLineItem WHERE QuoteId=:quoteId];
       
            List<String> productCodes = new List<String>();
            for(QuoteLineItem quoteLineItemIndividual : quoteLineItems) {
                productCodes.add(quoteLineItemIndividual.Product2.ProductCode);
            }

            list<etb_CotizacionAvanzadaConfig__mdt> configproducts = [SELECT Id,ProductCode__c,RecordTypeName__c,TipoDeServicio__c
                                                                        FROM etb_CotizacionAvanzadaConfig__mdt 
                                                                        WHERE ProductCode__c IN :productCodes
                                                                        AND Active__c = true];
          
            List<Recordtype> RTcotizacion = [SELECT Id,name,SobjectType FROM recordtype WHERE SobjectType ='ETB_CotizacionAvanzada__c'];
            if(test.isRunningTest()){
                etb_CotizacionAvanzadaConfig__mdt mtd = new etb_CotizacionAvanzadaConfig__mdt();
                mtd.ProductCode__c = 'PR_Navegacion_segura_Avanzada';
                mtd.RecordTypeName__c  = 'Conectividad';
                mtd.TipoDeServicio__c = 'CAIP';
                configproducts.add(mtd);
            }
            for(QuoteLineItem individualQuote : quoteLineItems) {
                for(etb_CotizacionAvanzadaConfig__mdt individualProducts : configproducts) {
                    if(individualQuote.Product2.ProductCode == individualProducts.ProductCode__c) {
                        Map<String, Object> AttributeSelectedValues = (Map<String, Object>)JSON.deserializeUntyped(individualQuote.vlocity_cmt__AttributeSelectedValues__c);
                        ETB_CotizacionAvanzada__c cot = new ETB_CotizacionAvanzada__c ();
                        for(Recordtype individualRecordType : RTcotizacion) {
                            if(individualRecordType.name == individualProducts.RecordTypeName__c) {
                                cot.RecordTypeId=individualRecordType.id;
                            }
                        }
                      
                        cot.Quote_Line_Item__c = individualQuote.id;
                        cot.Cotizacion__c = quoteId;
                        cot.TCM__c = Integer.valueOf(AttributeSelectedValues.get('ATT_SF_TiempoContratoMeses'));
                        cot.AnchoBandaTerceros__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_AnchoBanda'));
                        cot.Tipo_de_Contrato__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_TipoContrato'));
                        cot.Gestion_Unificada__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_GestionUnificada'));
                        cot.CiudadDestino__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_CiudadNodoDestino'));
                        cot.Categoria_de_Enlace__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_CategoriaEnlace'));
                        cot.UMOtroOperador_ETBSatelital__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_UMOtroOperadorETBSatelital'));
                        cot.TipoUM__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_TipoUltimaMilla'));
                        cot.CiudadOrigen__c = String.valueOf(AttributeSelectedValues.get('ATT_SF_CiudadNodoOrigen'));
                        cot.Segmento__c = individualQuote.Quote.Account.Segmento__c;
                        cot.Tipo_de_Servicio__c = individualProducts.TipoDeServicio__c;
                        cot.Obras_Civiles__c = AttributeSelectedValues.get('ATT_SF_CostosAproximadosObrasCiviles') == null ? 0 : Integer.valueOf(AttributeSelectedValues.get('ATT_SF_CostosAproximadosObrasCiviles'));
                        cot.Metros_Tendidos_Fo_UM_ETB__c = AttributeSelectedValues.get('ATT_SF_MetrosTendidoFoUM') == null ? 0 : Integer.valueOf(AttributeSelectedValues.get('ATT_SF_MetrosTendidoFoUM'));
                        if(String.valueOf(AttributeSelectedValues.get('ATT_SF_ClausulaTerminacionAnticipada')).equals('Sí Acepta')){
                            cot.Clausula_de_Permanencia__c = true;
                        }
                        else {
                            cot.Clausula_de_Permanencia__c = false;
                        }

                        if(test.isRunningTest()){  
                            cot.AnchoBandaTerceros__c='420Mbps';
                            cot.Calculado__c=false;
                            cot.Categoria_de_Enlace__c='Pto. Central';
                            cot.CiudadDestino__c='Bogotá';
                            cot.CiudadOrigen__c='Barichara';
                            cot.Clausula_de_Permanencia__c=false;
                            cot.Gestion_Unificada__c='Servicio Basico';
                            cot.Metros_Tendidos_Fo_UM_ETB__c=1500;
                            cot.Obras_Civiles__c=25000000999.00;
                            cot.Segmento__c='Empresas';
                            cot.TCM__c=12;
                            cot.Tipo_de_Contrato__c='Nuevo';
                            cot.Tipo_de_Servicio__c='CAIP';
                            cot.TipoUM__c='AXESAT';
                        }
                        cotizacionesParaInsertar.add(cot);
                    }
                }
            }
            if(cotizacionesParaInsertar.size() > 0) {
                insert cotizacionesParaInsertar;
            }
        }
        catch(Exception e) {
            throw e;
        }
    }
    */

    @TestVisible
    private static void sendEmailViabilidades(Map<String, Object> InputMap) {
        try {
            List<String> listaNombresViabilidades = new List<String>();
            Map<String, Object> mapItemsProcessed = (Map<String, Object>) InputMap.get('itemsProcessed');
            List<Object> listaSuccessfullyProcessedItems = (List<Object>) mapItemsProcessed.get('successfully');
            List<Object> listaFailedProcessedItems = (List<Object>) mapItemsProcessed.get('failed');

            for(Object objSuccessfullyProcessedItem : listaSuccessfullyProcessedItems) {
                Map<String, Object> mapSuccessfullyProcessedItem = (Map<String, Object>) objSuccessfullyProcessedItem;
                listaNombresViabilidades.add(String.valueOf(mapSuccessfullyProcessedItem.get('viabilidad')));
            }

            List<Viabilidad__c> listaViabilidadProcesadas = [SELECT Id, Name, Nombredelcliente__c, EstadoViabilidad__c, Oportunidad__r.Owner.Email, LastModifiedDate FROM Viabilidad__c WHERE Name IN :listaNombresViabilidades];

            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [SELECT Id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'NotificacionCambioEstadoViabilidad'];

            for(Viabilidad__c viabilidad : listaViabilidadProcesadas) {
                String htmlBody = et?.HtmlValue;
                String subjectEmail = et?.subject;

                htmlBody = htmlBody.replace('{!Viabilidad__c.Name}', String.valueOf(viabilidad.Name));
                htmlBody = htmlBody.replace('{!Viabilidad__c.Nombredelcliente__c}', String.valueOf(viabilidad.Nombredelcliente__c));
                htmlBody = htmlBody.replace('{!Viabilidad__c.EstadoViabilidad__c}', String.valueOf(viabilidad.EstadoViabilidad__c));
                htmlBody = htmlBody.replace('{!Viabilidad__c.LastModifiedDate}', String.valueOf(viabilidad.LastModifiedDate));
                htmlBody = htmlBody.replace('{!Viabilidad__c.Link}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + viabilidad.Id);
                subjectEmail = subjectEmail.replace('{!Viabilidad__c.Name}', String.valueOf(viabilidad.name));
                subjectEmail = subjectEmail.replace('{!Viabilidad__c.Nombredelcliente__c}', String.valueOf(viabilidad.Nombredelcliente__c));
                subjectEmail = subjectEmail.replace('{!Viabilidad__c.EstadoViabilidad__c}', String.valueOf(viabilidad.EstadoViabilidad__c));
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String to = viabilidad.Oportunidad__r.Owner.Email;
                email.setToAddresses(new String[] {to});
                email.setHtmlBody(htmlBody);
                email.setSubject(subjectEmail);
                allMails.add(email);
            }
            Messaging.sendEmail(allMails);
        }
        catch(Exception e) {
            throw e;
        }
    }
    
    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo startJob que busca insertar los registros correspondientes en vlocity_cmt__QuoteLineItemRelationship__c.
    * @param listaQLI List<QuoteLineItem> La lista de quote line items generada desde el metodo addItemsToCart
    *
    @TestVisible
    private static void updateQuoteLineItemRelationship(List<QuoteLineItem> listaQLI) {
        try {
           List<String> listProductId = new List<String>();
           
           for (QuoteLineItem qli:listaQLI){
                listProductId.add(String.valueOf(qli.Product2Id));
           }
            
           List<vlocity_cmt__ProductRelationship__c> prsList = [SELECT Id,Name,vlocity_cmt__GlobalKey__c,vlocity_cmt__Product2Id__c,vlocity_cmt__RelatedProductId__c,vlocity_cmt__RelationshipType__c FROM vlocity_cmt__ProductRelationship__c WHERE vlocity_cmt__Product2Id__c IN:listProductId AND vlocity_cmt__RelatedProductId__c IN:listProductId AND vlocity_cmt__RelationshipType__c = 'ReliesOn'];

           List<vlocity_cmt__QuoteLineItemRelationship__c> qlirsList = new List<vlocity_cmt__QuoteLineItemRelationship__c>();

           for (vlocity_cmt__ProductRelationship__c prsItem:prsList){
               integer encontrado = 0;
               QuoteLineItem auxQLI = null;
               for(QuoteLineItem qli : listaQLI) {
                   if(qli.Product2Id == prsItem.vlocity_cmt__Product2Id__c) {
                       auxQLI = qli;
                       encontrado++;
                       break;
                   }
               }

               QuoteLineItem auxRelatedQLI = null;
               for(QuoteLineItem qli : listaQLI) {
                   if(qli.Product2Id == prsItem.vlocity_cmt__RelatedProductId__c) {
                       auxRelatedQLI = qli;
                       encontrado++;
                       break;  
                   }
               }

               if(encontrado == 2){
                   vlocity_cmt__QuoteLineItemRelationship__c qlirs = new vlocity_cmt__QuoteLineItemRelationship__c();
                   qlirs.vlocity_cmt__ProductRelationshipIdentifier__c = prsItem.vlocity_cmt__GlobalKey__c;
                   qlirs.vlocity_cmt__QuoteId__c = auxQLI.QuoteId;
                   qlirs.vlocity_cmt__QuoteLineItemId__c = auxQLI.Id;
                   qlirs.vlocity_cmt__RelatedAssetReferenceId__c = auxRelatedQLI.vlocity_cmt__AssetReferenceId__c;
                   qlirs.vlocity_cmt__RelatedQuoteLineItemId__c = auxRelatedQLI.Id;
                   qlirs.vlocity_cmt__RelationshipType__c = prsItem.vlocity_cmt__RelationshipType__c;
                   qlirsList.add(qlirs);
               }
           }
           insert qlirsList;
        }
        catch(Exception e) {
            throw e;
        }
    }
    */
    
       @TestVisible
    public static void updatePrice(String quoteId){
        try {           
            QueueableWrapper.enqueueJob(new ETB_CalculoPrecioQbl(quoteId));                
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,' updatePrice -->Exception: ' + e.getLineNumber()+'-'+e.getMessage());
        }
        
    }
    
    @TestVisible
    public static void updatePrice2(String quoteId){
        try {           					  
              List<QuoteLineItem> listaQLI;
	  
              if (QuoteLineItem.SObjectType.getDescribe().isAccessible()) {
                  listaQLI = [SELECT Id, Quantity, vlocity_cmt__QuoteMemberId__c, QuoteId, Product2.ProductCode, vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem WHERE QuoteId = :quoteId];
              }
              Integer largoArreglo = listaQLI.size();
              Integer contador = 1;
              Boolean ultimoElemento = false;
              for(QuoteLineItem partidaPresupuesto :listaQLI ) {
                  ultimoElemento = contador==largoArreglo;               
                  
                  Map<String,Object> mapValoresAtributos;
                  Map<String,Object> mapValoresAtributosOriginal;
                  Map<String,Object> iOutput;
                  String codigoProducto = (String)partidaPresupuesto.Product2.get('ProductCode');
                  Id quoteLineItemId = (Id)partidaPresupuesto.get('Id');
                  System.debug('Buscar metadata');
                  ETB_GL_ConfPricing__mdt metadataProducto = ETB_PricingHandlerCls.getMetadata(codigoProducto);
                  System.debug('metadata: '+ metadataProducto);
                  if (metadataProducto!=null) {
                      System.debug('entro al if');
                      String jsonAttributes = (String)partidaPresupuesto.get('vlocity_cmt__AttributeSelectedValues__c');
                      mapValoresAtributosOriginal = (Map<String,Object>)JSON.deserializeUntyped(jsonAttributes);
                      mapValoresAtributos = ETB_PricingHandlerCls.cleanMapAttributes(mapValoresAtributosOriginal);
                      mapValoresAtributos.put('PorcentajeAsignacion', 100);
																										
																		 
                      mapValoresAtributos.put('ProductCode', codigoProducto);
                      System.debug(LoggingLevel.DEBUG, JSON.serialize(mapValoresAtributos));               
                      iOutput=ETB_PricingHandlerCls.calculatePricing(metadataProducto, mapValoresAtributos);    
                      System.debug('IP resultado '+iOutput);           
                      if( iOutput.get('SetItem') != '' && iOutput.get('SetItem') != null){
                          Map<String,Object> nuevosCostos = (Map<String,Object>)iOutput.get('SetItem');
                          String jsonNuevosCostos = JSON.serialize(nuevosCostos);
                          QuoteLineItem partidaPresupuestoActualizada = new QuoteLineItem(Id=quoteLineItemId,etb_gl_jsonpricing__c=jsonNuevosCostos);
                          if (QuoteLineItem.SObjectType.getDescribe().isUpdateable()) {
                              update partidaPresupuestoActualizada;
                          }                                        
                      }               
                  }
                  
                  contador+=1;                
              }           
          } catch (Exception e) {
              System.debug(LoggingLevel.ERROR,' updatePrice -->Exception: ' + e.getLineNumber()+'-'+e.getMessage());
          }
          
      }

    @TestVisible 
    public static void updateDynamicFields(String quoteId, List<Object> listaParametrosSolicitud){ 
        Map<String, Object> mapObj; 
        Map<Id, SObject> mapToUpdate = new Map<Id, SObject>(); 
        Boolean pricingManualFlg = false; 
        try { 
            List<QuoteLineItem> listaQLI = [Select Id, Viabilidad__r.Name From QuoteLineItem Where QuoteId=:quoteId]; 
            for (Object obj : listaParametrosSolicitud) { 
                mapObj = (Map<String, Object>) obj; 
                String nombreObjeto = (String) mapObj.get('codigo'); 
                String nombreCampo = (String) mapObj.get('nombre'); 
                String valorCampo = (String) mapObj.get('valor'); 
                String numeroVia = (String) mapObj.get('idOrigen'); 
                if(Schema.getGlobalDescribe().containsKey(nombreObjeto)) { 
                    SObjectType objectType = Schema.getGlobalDescribe().get(nombreObjeto); 
                    DescribeSObjectResult objectDescribe = objectType.getDescribe(); 
                    if (objectDescribe.fields.getMap().containsKey(nombreCampo)) { 
                        if (nombreObjeto.equals('QuoteLineItem')) { 
                            for(QuoteLineItem qli : listaQLI) { 
                                if (qli.Viabilidad__r.Name.equals(numeroVia)) { 
                                    if(!mapToUpdate.containsKey(qli.Id)) mapToUpdate.put(qli.Id, new QuoteLineItem(Id = qli.Id)); mapToUpdate.get(qli.Id).put(nombreCampo, valorCampo); 
                                } 
                            } 
                        } else if (nombreObjeto.equals('Quote')) {
                             // verificar parámetro 'Tipo de pricing' 
                            if(nombreCampo.equals('Tipo_de_pricing__c') && (valorCampo.equals('Manual') || pricingManualFlg)){
                                valorCampo = 'Manual'; 
                                pricingManualFlg = true; 
                            } 
                            
                            if(!mapToUpdate.containsKey(quoteId)) mapToUpdate.put(quoteId, new Quote(Id = quoteId)); 
                            mapToUpdate.get(quoteId).put(nombreCampo, valorCampo); 
                        } 
                    } 
                } 
            } 
            if(!mapToUpdate.isEmpty()) update mapToUpdate.values(); 
        } 
        catch (Exception e) { 
            System.debug(LoggingLevel.ERROR,' updateDynamicFields -->Exception: ' +e.getMessage()); 
        } 
    }
    
}