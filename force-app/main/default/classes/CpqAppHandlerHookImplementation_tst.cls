/****************************************************************************************************
    Autor:          edwin.bohorquez@globant.com
    Project:        Vlocity - ETB
    Description:    Clase para hacer la clase CpqAppHandlerHookImplementation

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         1-11-2022         Adrian Bohorquez            Creación de Clase
*****************************************************************************************************/

@isTest
public with sharing class CpqAppHandlerHookImplementation_tst {
    
    @IsTest
    static void putCartItems(){

        String methodName = 'putCartsItems.PreInvoke';
        String jsonInput = '{"validate":true,"query":null,"price":true,"pagesize":10,"lastRecordId":null,"includeAttachment":false,"hierarchy":-1,"fields":"vlocity_cmt__BillingAccountId__c,vlocity_cmt__ServiceAccountId__c,Quantity,vlocity_cmt__RecurringTotal__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__OneTimeCharge__c,ListPrice,vlocity_cmt__ParentItemId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__PremisesId__r.Name,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__EffectiveQuantity__c","cartId":"0Q0040000005UQ0CAM","id":"0QL040000005FBCGA2","itemId":"0QL040000005FBCGA2","filters":null,"items":{"records":[{"attributeCategories":{"records":[{"productAttributes":{"records":[{"userValues":12,"values":[{"disabled":false,"readonly":false}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":true,"displaySequence":10,"label":"Tiempo de Contrato en Meses","attributeId":"a493K000000NW4CQAW","filterable":true,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"number","dataType":"number","code":"ATT_TiempoContratoMeses","messages":[]},{"userValues":null,"values":[{"disabled":false,"readonly":false}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":true,"displaySequence":20,"label":"Tiempo de Contrato en días","attributeId":"a493K000000NW4BQAW","filterable":true,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"number","dataType":"number","code":"ATT_TiempoContratoDias","messages":[]},{"userValues":null,"values":[{"disabled":false,"readonly":false}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":1200,"label":"Comentarios","attributeId":"a493K000000NWV6QAO","filterable":false,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"text","dataType":"text","code":"ATT_Comentarios","messages":[]}],"messages":[],"totalSize":3},"id":"a483K0000003ruwQAA","Name":"Características Generales","Code__c":"ATTCAT_Características_Generales","displaySequence":20,"messages":[]},{"productAttributes":{"records":[{"userValues":"ETB","values":[{"disabled":true,"readonly":true}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":1,"label":"Operador UM","attributeId":"a4904000001pkmlAAA","filterable":false,"disabled":true,"readonly":true,"required":false,"multiselect":false,"inputType":"text","dataType":"text","code":"ATT_OperadorUMInternetMas","messages":[]},{"userValues":"Nuevo","values":[{"displaySequence":10,"value":"Nuevo","disabled":false,"readonly":false,"label":"Nuevo","id":"9a03bdd8-5224-a2db-ccf9-ec50a51fc757"},{"displaySequence":20,"value":"Renovacion","disabled":false,"readonly":false,"label":"Renovación","id":"d7780c6b-d262-2d54-bf8d-819f8f9f1ecc"},{"displaySequence":30,"value":"Ampliacion sobre equipos existentes","disabled":false,"readonly":false,"label":"Ampliación sobre equipos existentes","id":"e36eced3-be33-131c-e837-7a9cf7354e46"},{"displaySequence":40,"value":"Ampliacion con cambio de router","disabled":false,"readonly":false,"label":"Ampliación con cambio de router","id":"5e482858-0adf-d667-3078-0cf6c4bbb2f5"}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":1,"label":"Tipo de contrato","attributeId":"a4904000001pkmWAAQ","filterable":false,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"dropdown","dataType":"text","code":"ATT_TipoContratoInternetMas","messages":[]},{"userValues":"Demarcador","values":[{"displaySequence":10,"value":"Demarcador","disabled":false,"readonly":false,"label":"Demarcador","id":"113efe66-cc18-acb6-b519-e7779ff69055"},{"displaySequence":20,"value":"Equipo existente","disabled":false,"readonly":false,"label":"Equipo existente","id":"bc58511a-373d-2c7f-fdde-6c0a8cbc3c36"}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":1,"label":"Tipo de ultima milla","attributeId":"a4904000001pkmbAAA","filterable":false,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"dropdown","dataType":"text","code":"ATT_TipoUltimaMillaInternetMas","messages":[]},{"userValues":"Regiones con cobertura fibra","values":[{"displaySequence":10,"value":"Regiones con cobertura fibra","disabled":false,"readonly":false,"label":"Regiones con cobertura fibra","id":"c098c800-5f72-ad50-ae78-81987a06481a"},{"displaySequence":20,"value":"Bogota y Cundinamarca","disabled":false,"readonly":false,"label":"Bogotá y Cundinamarca","id":"65429bb8-3240-a716-6231-9d9b6fa6e7b7"}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":1,"label":"Cobertura","attributeId":"a4904000001pkmgAAA","filterable":false,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"dropdown","dataType":"text","code":"ATT_CoberturaInternetMas","messages":[]},{"userValues":null,"values":[{"disabled":false,"readonly":false}],"isNotTranslatable":false,"cloneable":true,"hidden":true,"hasRules":false,"displaySequence":20,"label":"Nemonico","attributeId":"a493K000000NW4EQAW","filterable":false,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"text","dataType":"text","code":"ATT_Nemonico","messages":[]},{"userValues":null,"values":[{"disabled":false,"readonly":false}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":390,"label":"Obras Civiles","attributeId":"a493K000000NXJwQAO","filterable":false,"disabled":false,"readonly":false,"required":true,"multiselect":false,"inputType":"number","dataType":"currency","code":"ATT_Obras_Civiles","messages":[]},{"userValues":"5Mbps","values":[{"displaySequence":10,"value":"5Mbps","disabled":false,"readonly":false,"label":"5 Mbps","id":"569233cf-c65d-b90c-5b28-c19e3c1b5107"},{"displaySequence":20,"value":"6Mbps","disabled":false,"readonly":false,"label":"6 Mbps","id":"81583816-3891-928f-53ea-abedadb8dcbb"},{"displaySequence":30,"value":"7Mbps","disabled":false,"readonly":false,"label":"7 Mbps","id":"ba2ee0a2-df71-39de-3714-bd5aca94cef0"},{"displaySequence":40,"value":"8Mbps","disabled":false,"readonly":false,"label":"8 Mbps","id":"571c52e8-5451-a84b-5057-5d13064ecfd5"},{"displaySequence":50,"value":"9Mbps","disabled":false,"readonly":false,"label":"9 Mbps","id":"554ba254-c0b2-c83d-a3f2-1e176156fdd6"},{"displaySequence":60,"value":"10Mbps","disabled":false,"readonly":false,"label":"10 Mbps","id":"9b5f5b7b-2104-21d6-674b-248fc50a0314"},{"displaySequence":70,"value":"12Mbps","disabled":false,"readonly":false,"label":"12 Mbps","id":"c868dfe0-021a-dcf0-dfc6-68081e9475bb"},{"displaySequence":80,"value":"15Mbps","disabled":false,"readonly":false,"label":"15 Mbps","id":"1124109a-bebd-10cf-0b38-a1f61ede49cb"},{"displaySequence":90,"value":"20Mbps","disabled":false,"readonly":false,"label":"20 Mbps","id":"27d8e38a-201e-9923-5c23-4389d5fd9606"},{"displaySequence":100,"value":"25Mbps","disabled":false,"readonly":false,"label":"25 Mbps","id":"8ae60e92-d96c-e9cb-52c9-a1d7bea09386"},{"displaySequence":110,"value":"30Mbps","disabled":false,"readonly":false,"label":"30 Mbps","id":"8efe40a5-f865-4099-982d-da77d9798ded"},{"displaySequence":120,"value":"40Mbps","disabled":false,"readonly":false,"label":"40 Mbps","id":"9ba3d437-17dd-f212-e502-631876c98ec5"},{"displaySequence":130,"value":"50Mbps","disabled":false,"readonly":false,"label":"50 Mbps","id":"361faf39-b662-f4eb-b9aa-dbee4535d939"},{"displaySequence":140,"value":"60Mbps","disabled":false,"readonly":false,"label":"60 Mbps","id":"39045003-ed36-0c31-f5d1-9f2cbaf250fa"},{"displaySequence":150,"value":"70Mbps","disabled":false,"readonly":false,"label":"70 Mbps","id":"f98309e2-14c4-4225-2d2b-0fde934fc052"},{"displaySequence":160,"value":"80Mbps","disabled":false,"readonly":false,"label":"80 Mbps","id":"ba04a60d-b76d-109f-658c-c8a987240db5"},{"displaySequence":170,"value":"90Mbps","disabled":false,"readonly":false,"label":"90 Mbps","id":"e8542f44-d41c-c2b9-c836-733a04e83fa2"},{"displaySequence":180,"value":"100Mbps","disabled":false,"readonly":false,"label":"100 Mbps","id":"ed4fda28-4cde-ea65-1bb0-2b3da50ed0d2"},{"displaySequence":190,"value":"110Mbps","disabled":false,"readonly":false,"label":"110 Mbps","id":"10c4304c-aba4-2677-6e45-0a9c2bf89166"}],"isNotTranslatable":false,"cloneable":true,"hidden":false,"hasRules":false,"displaySequence":2000,"label":"Ancho de Banda","attributeId":"a4904000001pkhZAAQ","filterable":false,"disabled":false,"readonly":false,"required":false,"multiselect":false,"inputType":"dropdown","dataType":"text","code":"ATT_AnchoBandaInternetMas","messages":[]}],"messages":[],"totalSize":7},"id":"a483K0000003tlZQAQ","Name":"Características Avanzadas","Code__c":"ATTCAT_Caracteristicas_Avanzadas","displaySequence":30,"messages":[]}],"messages":[],"totalSize":2},"ETB_GL_JsonPricing__c":"","productCategories":{"messages":[],"totalSize":0},"vlocity_cmt__ServicePointId__c":{"actions":{"availablesites":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getAvailableSites","lookupField":"vlocity_cmt__servicepointid__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"REFERENCE","editable":true,"fieldName":"vlocity_cmt__ServicePointId__c","hidden":false,"label":"Service Point","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__QuoteGroupId__c":{"actions":{"availablesites":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getAvailableSites","lookupField":"vlocity_cmt__quotegroupid__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"REFERENCE","editable":true,"fieldName":"vlocity_cmt__QuoteGroupId__c","hidden":false,"label":"Quote Group","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__CpqPricingMessage__c":{"actions":{},"alternateValues":null,"dataType":"TEXTAREA","editable":true,"fieldName":"vlocity_cmt__CpqPricingMessage__c","hidden":false,"label":"Cpq Pricing Message","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__CpqCardinalityMessage__c":{"actions":{},"alternateValues":null,"dataType":"TEXTAREA","editable":true,"fieldName":"vlocity_cmt__CpqCardinalityMessage__c","hidden":false,"label":"Cpq Cardinality Message","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__ItemName__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":true,"fieldName":"vlocity_cmt__ItemName__c","hidden":false,"label":"Item Name","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__CpqMessageData__c":{"actions":{},"alternateValues":null,"dataType":"TEXTAREA","editable":true,"fieldName":"vlocity_cmt__CpqMessageData__c","hidden":true,"label":"Cpq Message Data","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__RecurringDiscountPrice__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__RecurringDiscountPrice__c","hidden":true,"label":"Recurring Discount Price","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__ParentItemId__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":false,"fieldName":"vlocity_cmt__ParentItemId__c","hidden":true,"label":"ParentItemId","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__SubAction__c":{"actions":{},"alternateValues":null,"dataType":"PICKLIST","editable":true,"fieldName":"vlocity_cmt__SubAction__c","hidden":false,"label":"Sub Action","messages":[],"originalValue":null,"previousValue":null,"value":null},"vlocity_cmt__ServiceAccountId__r":{"Name":"Café Madrid","Id":"0013K00000oZNaOQAW","attributes":{"type":"Account","url":"/services/data/v56.0/sobjects/Account/0013K00000oZNaOQAW"}},"vlocity_cmt__BillingAccountId__r":{"Name":"Café Madrid","Id":"0013K00000oZNaOQAW","attributes":{"type":"Account","url":"/services/data/v56.0/sobjects/Account/0013K00000oZNaOQAW"}},"vlocity_cmt__RootItemId__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":false,"fieldName":"vlocity_cmt__RootItemId__c","hidden":true,"label":"RootItemId","messages":[],"originalValue":null,"previousValue":null,"value":"63d71e91-6fd8-26df-65ed-3d34da826494"},"vlocity_cmt__RecurringTotal__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getListsOfValues","PricingVariableCode":"REC_MNTH_STD_PRC_TOTAL","fields":"vlocity_cmt__RecurringTotal__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM","listkeys":"AdjustmentCodes"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getPriceDetail","fields":"vlocity_cmt__RecurringTotal__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__RecurringTotal__c","hidden":false,"label":"Recurring Total","messages":[],"originalValue":null,"previousValue":null,"value":1232700},"vlocity_cmt__RecurringMargin__c":{"actions":{},"alternateValues":null,"dataType":"PERCENT","editable":true,"fieldName":"vlocity_cmt__RecurringMargin__c","hidden":false,"label":"Recurring Margin","messages":[],"originalValue":null,"previousValue":null,"value":-9.37},"vlocity_cmt__RecurringManualDiscount__c":{"actions":{},"alternateValues":null,"dataType":"PERCENT","editable":true,"fieldName":"vlocity_cmt__RecurringManualDiscount__c","hidden":false,"label":"Recurring Manual Discount","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__RecurringCostTotal__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__RecurringCostTotal__c","hidden":false,"label":"Recurring Cost Total","messages":[],"originalValue":null,"previousValue":null,"value":1360200},"vlocity_cmt__RecurringCost__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__RecurringCost__c","hidden":false,"label":"Recurring Cost","messages":[],"originalValue":null,"previousValue":null,"value":1232700},"vlocity_cmt__RecurringCharge__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getListsOfValues","PricingVariableCode":"REC_MNTH_STD_PRC","fields":"vlocity_cmt__RecurringCharge__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM","listkeys":"AdjustmentCodes"}},"rest":{"link":null,"method":null,"params":{}}},"timelists":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getListsOfValues","listkeys":"TimePlans,TimePolicies"}},"rest":{"link":null,"method":null,"params":{}}},"applyadjustment":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"applyAdjustment","adjustments":[{"PricingVariableCode":"REC_MNTH_STD_PRC","AdjustmentCode":"","AdjustmentValue":0,"AdjustmentMethod":"Percent","DetailType":"ADJUSTMENT","Field":"vlocity_cmt__RecurringCharge__c"}],"id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getPriceDetail","fields":"vlocity_cmt__RecurringCharge__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__RecurringCharge__c","hidden":true,"label":"Recurring Charge","messages":[],"originalValue":null,"previousValue":null,"value":1232700},"vlocity_cmt__RecurringCalculatedPrice__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getListsOfValues","PricingVariableCode":"REC_MNTH_STD_PRC_CALC","fields":"vlocity_cmt__RecurringCalculatedPrice__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM","listkeys":"AdjustmentCodes"}},"rest":{"link":null,"method":null,"params":{}}},"applyadjustment":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"applyAdjustment","adjustments":[{"PricingVariableCode":"REC_MNTH_STD_PRC_CALC","AdjustmentCode":"","AdjustmentValue":0,"AdjustmentMethod":"Percent","DetailType":"ADJUSTMENT","Field":"vlocity_cmt__RecurringCalculatedPrice__c"}],"id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getPriceDetail","fields":"vlocity_cmt__RecurringCalculatedPrice__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__RecurringCalculatedPrice__c","hidden":true,"label":"Recurring Calculated Price","messages":[],"originalValue":null,"previousValue":null,"value":1232700},"vlocity_cmt__ServiceAccountId__c":{"actions":{"availablesites":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getAvailableSites","lookupField":"vlocity_cmt__serviceaccountid__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"REFERENCE","editable":true,"fieldName":"vlocity_cmt__ServiceAccountId__c","hidden":false,"label":"Service Account","messages":[],"originalValue":null,"previousValue":null,"value":"0013K00000oZNaOQAW"},"vlocity_cmt__ProvisioningStatus__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":false,"fieldName":"vlocity_cmt__ProvisioningStatus__c","hidden":true,"label":"Provisioning Status","messages":[],"originalValue":null,"previousValue":null,"value":"New"},"vlocity_cmt__ProductHierarchyPath__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":false,"fieldName":"vlocity_cmt__ProductHierarchyPath__c","hidden":true,"label":"Product Hierarchy Path","messages":[],"originalValue":null,"previousValue":null,"value":"01t04000000wX5GAAU"},"vlocity_cmt__ProductHierarchyGroupKeyPath__c":{"actions":{},"alternateValues":null,"dataType":"TEXTAREA","editable":true,"fieldName":"vlocity_cmt__ProductHierarchyGroupKeyPath__c","hidden":false,"label":"Product Hierarchy Group Key Path","messages":[],"originalValue":null,"previousValue":null,"value":"9c6de7d6-3012-8340-ceb6-83ed722cda3b"},"vlocity_cmt__ProductGroupKey__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":false,"fieldName":"vlocity_cmt__ProductGroupKey__c","hidden":false,"label":"Product Group Key","messages":[],"originalValue":null,"previousValue":null,"value":"9c6de7d6-3012-8340-ceb6-83ed722cda3b"},"vlocity_cmt__Product2Id__c":{"actions":{"availablesites":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getAvailableSites","lookupField":"vlocity_cmt__product2id__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"REFERENCE","editable":true,"fieldName":"vlocity_cmt__Product2Id__c","hidden":false,"label":"Product","messages":[],"originalValue":null,"previousValue":null,"value":"01t04000000wX5GAAU"},"vlocity_cmt__OneTimeTotal__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"listkeys":"AdjustmentCodes","cartId":"0Q0040000005UQ0CAM","id":"0QL040000005FBCGA2","fields":"vlocity_cmt__OneTimeTotal__c","PricingVariableCode":"OT_STD_PRC_TOTAL","methodName":"getListsOfValues"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"cartId":"0Q0040000005UQ0CAM","id":"0QL040000005FBCGA2","fields":"vlocity_cmt__OneTimeTotal__c","methodName":"getPriceDetail"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__OneTimeTotal__c","hidden":false,"label":"One Time Total","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__OneTimeMargin__c":{"actions":{},"alternateValues":null,"dataType":"PERCENT","editable":true,"fieldName":"vlocity_cmt__OneTimeMargin__c","hidden":false,"label":"One Time Margin","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__OneTimeManualDiscount__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getListsOfValues","PricingVariableCode":"OT_STD_PRC_DISC_PCT_MAN","fields":"vlocity_cmt__OneTimeManualDiscount__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM","listkeys":"AdjustmentCodes"}},"rest":{"link":null,"method":null,"params":{}}},"applyadjustment":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"applyAdjustment","adjustments":[{"PricingVariableCode":"OT_STD_PRC_DISC_PCT_MAN","AdjustmentCode":"","AdjustmentValue":0,"AdjustmentMethod":"Percent","DetailType":"ADJUSTMENT","Field":"vlocity_cmt__OneTimeManualDiscount__c"}],"id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getPriceDetail","fields":"vlocity_cmt__OneTimeManualDiscount__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"PERCENT","editable":true,"fieldName":"vlocity_cmt__OneTimeManualDiscount__c","hidden":false,"label":"One Time Manual Discount","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__OneTimeCost__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__OneTimeCost__c","hidden":false,"label":"One Time Cost","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__OneTimeCostTotal__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__OneTimeCostTotal__c","hidden":false,"label":"One Time Cost Total","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__OneTimeCharge__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"listkeys":"AdjustmentCodes","cartId":"0Q0040000005UQ0CAM","id":"0QL040000005FBCGA2","fields":"vlocity_cmt__OneTimeCharge__c","PricingVariableCode":"OT_STD_PRC","methodName":"getListsOfValues"}},"rest":{"link":null,"method":null,"params":{}}},"applyadjustment":{"client":{"params":{},"records":[]},"remote":{"params":{"cartId":"0Q0040000005UQ0CAM","id":"0QL040000005FBCGA2","adjustments":[{"Field":"vlocity_cmt__OneTimeCharge__c","DetailType":"ADJUSTMENT","AdjustmentMethod":"Percent","AdjustmentValue":0,"AdjustmentCode":"","PricingVariableCode":"OT_STD_PRC"}],"methodName":"applyAdjustment"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"cartId":"0Q0040000005UQ0CAM","id":"0QL040000005FBCGA2","fields":"vlocity_cmt__OneTimeCharge__c","methodName":"getPriceDetail"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__OneTimeCharge__c","hidden":true,"label":"One Time Charge","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__OneTimeCalculatedPrice__c":{"actions":{"adjustmentcodes":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getListsOfValues","PricingVariableCode":"OT_STD_PRC_CALC","fields":"vlocity_cmt__OneTimeCalculatedPrice__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM","listkeys":"AdjustmentCodes"}},"rest":{"link":null,"method":null,"params":{}}},"applyadjustment":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"applyAdjustment","adjustments":[{"PricingVariableCode":"OT_STD_PRC_CALC","AdjustmentCode":"","AdjustmentValue":0,"AdjustmentMethod":"Percent","DetailType":"ADJUSTMENT","Field":"vlocity_cmt__OneTimeCalculatedPrice__c"}],"id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}},"pricedetail":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getPriceDetail","fields":"vlocity_cmt__OneTimeCalculatedPrice__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"vlocity_cmt__OneTimeCalculatedPrice__c","hidden":true,"label":"One Time Calculated Price","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__LineNumber__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":false,"fieldName":"vlocity_cmt__LineNumber__c","hidden":true,"label":"Line Number","messages":[],"originalValue":null,"previousValue":null,"value":"0002"},"vlocity_cmt__InCartQuantityMap__c":{"actions":{},"alternateValues":null,"dataType":"TEXTAREA","editable":false,"fieldName":"vlocity_cmt__InCartQuantityMap__c","hidden":true,"label":"InCartQuantityMap","messages":[],"originalValue":null,"previousValue":null,"value":{"01t3K0000020FGZQA2":1}},"vlocity_cmt__EffectiveRecurringTotal__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__EffectiveRecurringTotal__c","hidden":false,"label":"Effective Recurring Total","messages":[],"originalValue":null,"previousValue":null,"value":1232700},"vlocity_cmt__EffectiveRecurringCostTotal__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__EffectiveRecurringCostTotal__c","hidden":false,"label":"Effective Recurring Cost Total","messages":[],"originalValue":null,"previousValue":null,"value":1360200},"vlocity_cmt__EffectiveQuantity__c":{"actions":{},"alternateValues":null,"dataType":"DOUBLE","editable":true,"fieldName":"vlocity_cmt__EffectiveQuantity__c","hidden":false,"label":"Effective Quantity","messages":[],"originalValue":null,"previousValue":null,"value":1},"vlocity_cmt__EffectiveOneTimeTotal__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__EffectiveOneTimeTotal__c","hidden":false,"label":"Effective One Time Total","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__EffectiveOneTimeCostTotal__c":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":true,"fieldName":"vlocity_cmt__EffectiveOneTimeCostTotal__c","hidden":false,"label":"Effective One Time Cost Total","messages":[],"originalValue":null,"previousValue":null,"value":0},"vlocity_cmt__CurrencyPaymentMode__c":{"actions":{},"alternateValues":null,"dataType":"PICKLIST","editable":true,"fieldName":"vlocity_cmt__CurrencyPaymentMode__c","hidden":true,"label":"Currency Payment Mode","messages":[],"originalValue":null,"previousValue":null,"value":"Currency"},"vlocity_cmt__CatalogItemReferenceDateTime__c":{"actions":{},"alternateValues":null,"dataType":"DATETIME","editable":true,"fieldName":"vlocity_cmt__CatalogItemReferenceDateTime__c","hidden":false,"label":"Reference Time","messages":[],"originalValue":null,"previousValue":null,"value":"2022-09-15T19:53:45.000Z"},"vlocity_cmt__BillingAccountId__c":{"actions":{"availablesites":{"client":{"params":{},"records":[]},"remote":{"params":{"methodName":"getAvailableSites","lookupField":"vlocity_cmt__billingaccountid__c","id":"0QL040000005FBCGA2","cartId":"0Q0040000005UQ0CAM"}},"rest":{"link":null,"method":null,"params":{}}}},"alternateValues":null,"dataType":"REFERENCE","editable":true,"fieldName":"vlocity_cmt__BillingAccountId__c","hidden":false,"label":"Billing Account","messages":[],"originalValue":null,"previousValue":null,"value":"0013K00000oZNaOQAW"},"vlocity_cmt__AssetReferenceId__c":{"actions":{},"alternateValues":null,"dataType":"STRING","editable":true,"fieldName":"vlocity_cmt__AssetReferenceId__c","hidden":true,"label":"Asset Reference Id","messages":[],"originalValue":null,"previousValue":null,"value":"63d71e91-6fd8-26df-65ed-3d34da826494"},"vlocity_cmt__Action__c":{"actions":{},"alternateValues":null,"dataType":"PICKLIST","editable":true,"fieldName":"vlocity_cmt__Action__c","hidden":false,"label":"Action","messages":[],"originalValue":null,"previousValue":null,"value":"Add"},"QuoteId":{"actions":{},"alternateValues":null,"dataType":"REFERENCE","editable":false,"fieldName":"QuoteId","hidden":false,"label":"Quote ID","messages":[],"originalValue":null,"previousValue":null,"value":"0Q0040000005UQ0CAM"},"Quantity":{"actions":{},"alternateValues":null,"dataType":"DOUBLE","editable":true,"fieldName":"Quantity","hidden":false,"label":"Quantity","messages":[],"originalValue":null,"previousValue":null,"value":1},"PricebookEntryId":{"actions":{},"alternateValues":null,"dataType":"REFERENCE","editable":false,"fieldName":"PricebookEntryId","hidden":false,"label":"Price Book Entry ID","messages":[],"originalValue":null,"previousValue":null,"value":"01u04000003I4sOAAS"},"ListPrice":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"ListPrice","hidden":true,"label":"List Price","messages":[],"originalValue":null,"previousValue":null,"value":0},"SellingPeriod":"Present","action":"Add","itemType":"lineItem","parentRecordTypeDevName":"WorkingCart","orderActive":false,"hasChildren":true,"isVirtualItem":false,"name":"Internet + Empresarial","productHierarchyPath":"01t04000000wX5GAAU","productChildItemDefinition":{"vlocity_cmt__Quantity__c":1,"vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v56.0/sobjects/Product2/01t04000000wX5GAAU"},"vlocity_cmt__SellingStartDate__c":"2022-08-08T05:00:00.000+0000","vlocity_cmt__GlobalGroupKey__c":"9c6de7d6-3012-8340-ceb6-83ed722cda3b","Name":"Internet + Empresarial","Id":"01t04000000wX5GAAU"},"vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t04000000wX5GAAU","vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__ChildLineNumber__c":"1","Id":"a7l04000000OPnWAAW","Name":"Root PCI","vlocity_cmt__MinQuantity__c":0,"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v56.0/sobjects/vlocity_cmt__ProductChildItem__c/a7l04000000OPnWAAW"}},"productChildItemId":"a7l04000000OPnWAAW","sequenceNumber":1,"groupMaxQuantity":99999,"groupMinQuantity":0,"maxQuantity":99999,"minQuantity":0,"defaultQuantity":1,"productId":"01t04000000wX5GAAU","PricebookEntry":{"Product2":{"attributes":{"type":"Product2","url":"/services/data/v56.0/sobjects/Product2/01t04000000wX5GAAU"},"Id":"01t04000000wX5GAAU","Name":"Internet + Empresarial","ProductCode":"PR_COLOCACIONETB","vlocity_cmt__AttributeDefaultValues__c":"","vlocity_cmt__AttributeMetadata__c":"","vlocity_cmt__GlobalGroupKey__c":"9c6de7d6-3012-8340-ceb6-83ed722cda3b","vlocity_cmt__IsConfigurable__c":true,"vlocity_cmt__Type__c":"Avanzado"},"Id":"01u04000003I4sOAAS","Product2Id":"01t04000000wX5GAAU","Pricebook2Id":"01s40000000NGTqAAO","attributes":{"type":"PricebookEntry","url":"/services/data/v56.0/sobjects/PricebookEntry/01u04000003I4sOAAS"}},"Pricebook2Id":"01s40000000NGTqAAO","vlocity_cmt__RecurringPrice__c":0,"ProductCode":"PR_COLOCACIONETB","IsActive":true,"Product2Id":"01t04000000wX5GAAU","Id":{"actions":{},"alternateValues":null,"dataType":"ID","editable":false,"fieldName":"Id","hidden":false,"label":"Quote Line Item ID","messages":[],"originalValue":null,"previousValue":null,"value":"0QL040000005FBCGA2"},"Name":"Internet + Empresarial","Product2":{"vlocity_cmt__SpecificationType__c":"Product","vlocity_cmt__SubType__c":"Principal","ProductCode":"PR_COLOCACIONETB","vlocity_cmt__Type__c":"Avanzado","vlocity_cmt__IsConfigurable__c":true,"IsActive":true,"Id":"01t04000000wX5GAAU","Name":"Internet + Empresarial","vlocity_cmt__GlobalGroupKey__c":"9c6de7d6-3012-8340-ceb6-83ed722cda3b","vlocity_cmt__SellingStartDate__c":"2022-08-08T05:00:00.000+0000","attributes":{"type":"Product2","url":"/services/data/v56.0/sobjects/Product2/01t04000000wX5GAAU"}},"UnitPrice":{"actions":{},"alternateValues":null,"dataType":"CURRENCY","editable":false,"fieldName":"UnitPrice","hidden":true,"label":"Sales Price","messages":[],"originalValue":null,"previousValue":null,"value":0},"displaySequence":-1}]},"methodName":"putCartsItems"}';
        String jsonOutput = '{"errorCode":"INVOKE-200","error":"OK"}';
        String jsonOptions = '{}';

        Map<String,Object> input = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);        
        Map<String,Object> output = (Map<String,Object>)JSON.deserializeUntyped(jsonOutput);
        Map<String,Object> options = (Map<String,Object>)JSON.deserializeUntyped(jsonOptions);

        CpqAppHandlerHookImplementation test = new CpqAppHandlerHookImplementation();
        test.invokeMethod(methodName, input, output, options);
    }

    @IsTest
    static void postCartItems(){

        Id pricebookId = Test.getStandardPricebookId();
		Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_COLOCACIONETB';
        product2.Name = 'Colocacion ETB';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;
        
        String methodName = 'postCartsItems.PreInvoke';
        String jsonInput = '{"cartId":"0Q0040000005UQ0CAM","items":[{"itemId":"'+price.Id+'"}],"noResponseNeeded":true,"price":true,"validate":true}';
        String jsonOutput = '{"errorCode":"INVOKE-200","error":"OK"}';
        String jsonOptions = '{"isExpressionSet":false}';

        Map<String,Object> input = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);
        Map<String,Object> output = (Map<String,Object>)JSON.deserializeUntyped(jsonOutput);
        Map<String,Object> options = (Map<String,Object>)JSON.deserializeUntyped(jsonOptions);

        CpqAppHandlerHookImplementation test = new CpqAppHandlerHookImplementation();
        test.invokeMethod(methodName, input, output, options);
    }


    /*@IsTest
    static void cloneCartItems(){
        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_INTERNET_DEDICADO';
        product2.Name = 'PR_INTERNET_DEDICADO';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;
             
        Product2 product2Hijo = new Product2();
        product2Hijo.Family = 'Data Center';
        product2Hijo.ProductCode = 'PR_COLOCACIONETB';
        product2Hijo.Name = 'Colocacion ETB';
        insert product2Hijo;
        
        PricebookEntry priceHijo = new PricebookEntry();
        priceHijo.UnitPrice = 0.0;
        priceHijo.Pricebook2Id = pricebookId;
        priceHijo.Product2Id = product2Hijo.Id;
        priceHijo.isActive = true;
        insert priceHijo;
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        
        Account accountService = new Account();
        accountService.Name = 'Account Service';
        accountService.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        accountService.Type = 'Service';
        accountService.Phone = '12345678';
        accountService.ParentId = accountBusiness.Id;
        insert accountService; 
        
        Account accountBilling = new Account();
        accountBilling.Name = 'Account Billing';
        accountBilling.Type = 'Billing';
        accountBilling.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
        accountBilling.ParentId = accountBusiness.id;
        accountBilling.Phone = '12345678';
        insert accountBilling; 
		
        Contact contact = new Contact();
        contact.Email = 'labsx@labsxd.com';
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Phone = '12345678';
        contact.AccountId = accountBusiness.Id;
        insert contact;
        
        accountBusiness.vlocity_cmt__PersonContactId__c = contact.Id;
        UPDATE accountBusiness;
        
        Opportunity ventaUnificadaOpp = new Opportunity();
        ventaUnificadaOpp.CloseDate = System.today()+1;
        ventaUnificadaOpp.Amount = 200000.0;
        ventaUnificadaOpp.CausaldePerdida__c ='Otro';
        //ventaUnificadaOpp.Linea_de_Negocio_Principal__c = 'ventaUnificadaOpp';
        ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
        ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
        ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
        ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
        ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
        ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
        ventaUnificadaOpp.StageName = 'En Estudio';
        ventaUnificadaOpp.Duracion_Dias__c = 10;
        ventaUnificadaOpp.AccountId = accountBusiness.Id;
        ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;
        
        Quote enterpriseQuote = new Quote();
        enterpriseQuote.OwnerId = Userinfo.getUserId();
        enterpriseQuote.Name = 'Enterprise Quote';
        enterpriseQuote.Pricebook2Id = pricebookId;
        enterpriseQuote.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote;
        
        QuoteLineItem quotelineitem = new QuoteLineItem();
        quotelineitem.QuoteId = enterpriseQuote.Id;
        quotelineitem.Quantity = 1.0;
        quotelineitem.UnitPrice = 0.0;
        quotelineitem.PricebookEntryId = price.Id;
        quotelineitem.vlocity_cmt__Action__c = 'Add';
        quotelineitem.vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}';
        quotelineitem.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        quotelineitem.vlocity_cmt__CurrencyPaymentMode__c = 'Currency';
        quotelineitem.vlocity_cmt__EffectiveOneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveOneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveQuantity__c = 1.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__LineNumber__c = '0001';
        quotelineitem.vlocity_cmt__OneTimeCalculatedPrice__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCharge__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCost__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeMargin__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (41010.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (75000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (75000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":75000.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":75000.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":75000.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":75000.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}],"REC_MNTH_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":41010.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":41010.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":41010.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":41010.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_CALC":75000.00,"REC_MNTH_STD_PRC":75000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":82.88,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST":41010.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"LogVersion":"3.0","PriceAsOfDateTime":"2022-05-04T16:36:02.576Z","LastPricingTime":"2022-05-04T16:36:02.576Z","ExternalPrices":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}';
        quotelineitem.Product2Id = product2.Id;
        quotelineitem.vlocity_cmt__Product2Id__c = product2.Id;
        quotelineitem.vlocity_cmt__ProductHierarchyGroupKeyPath__c = 'd74f9058-70b2-6370-0243-361d7f43829f';
        quotelineitem.vlocity_cmt__ProvisioningStatus__c = 'New';
        quotelineitem.vlocity_cmt__RecurringCalculatedPrice__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCharge__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringCost__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__RecurringMargin__c = 82.88;
        quotelineitem.vlocity_cmt__RecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringUOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__Recurring_UOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__RelationshipType__c = 'Child';
        quotelineitem.vlocity_cmt__RootItemId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__SequenceNumber__c = 1.0;
        quotelineitem.vlocity_cmt__ServiceAccountId__c = accountService.Id;
        quotelineitem.vlocity_cmt__UsageQuantity__c = 1.0;
        insert quotelineitem;
        
        QuoteLineItem quotelineitem1 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaNoViable.Id
            vlocity_cmt__LineNumber__c = '0001.0001');
        insert quotelineitem1;

        QuoteLineItem quotelineitem2 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaViable.Id
            vlocity_cmt__LineNumber__c = '0001.0002');
        insert quotelineitem2;
        
        String methodName = 'cloneItems.PreInvoke';
        String jsonInput = '{"cartId":"'+enterpriseQuote.Id+'","id":"'+quotelineitem.Id+'","items":[{"itemId":"'+quotelineitem.Id+'"}],"methodName":"cloneItems"}';
        String jsonOutput = '{"errorCode":"INVOKE-200","error":"OK"}';
        String jsonOptions = '{}';

        ETB_GL_ConfPricing__mdt cfgtest = new ETB_GL_ConfPricing__mdt(); //ADN
        cfgtest.DeveloperName = 'PR_COLOCACIONETB';
        cfgtest.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  
        cfgtest.ETB_GL_Path__c='etb_InternetDedicado';

        string codigoPath = cfgtest.ETB_GL_Path__c;

        Map<String, Object> map1 = new Map<String, Object>();
        map1.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest);

        string codigoProducto ='PR_COLOCACIONETB';
        ETB_PricingHandlerCls.getMetadata(codigoProducto);


        Map<String,Object> input = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);
        Map<String,Object> output = (Map<String,Object>)JSON.deserializeUntyped(jsonOutput);
        Map<String,Object> options = (Map<String,Object>)JSON.deserializeUntyped(jsonOptions);

        CpqAppHandlerHookImplementation test = new CpqAppHandlerHookImplementation();
        test.invokeMethod(methodName, input, output, options);

    } 

    @IsTest
    static void deleteCartItems(){
        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_INTERNET_DEDICADO';
        product2.Name = 'INTERNET';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;
             
        Product2 product2Hijo = new Product2();
        product2Hijo.Family = 'Data Center';
        product2Hijo.ProductCode = 'PR_COLOCACIONETB';
        product2Hijo.Name = 'Colocacion ETB';
        insert product2Hijo;
        
        PricebookEntry priceHijo = new PricebookEntry();
        priceHijo.UnitPrice = 0.0;
        priceHijo.Pricebook2Id = pricebookId;
        priceHijo.Product2Id = product2Hijo.Id;
        priceHijo.isActive = true;
        insert priceHijo;
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        
        Account accountService = new Account();
        accountService.Name = 'Account Service';
        accountService.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        accountService.Type = 'Service';
        accountService.Phone = '12345678';
        accountService.ParentId = accountBusiness.Id;
        insert accountService; 
        
        Account accountBilling = new Account();
        accountBilling.Name = 'Account Billing';
        accountBilling.Type = 'Billing';
        accountBilling.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
        accountBilling.ParentId = accountBusiness.id;
        accountBilling.Phone = '12345678';
        insert accountBilling; 
		
        Contact contact = new Contact();
        contact.Email = 'labsx@labsxd.com';
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Phone = '12345678';
        contact.AccountId = accountBusiness.Id;
        insert contact;
        
        accountBusiness.vlocity_cmt__PersonContactId__c = contact.Id;
        UPDATE accountBusiness;
        
        Opportunity ventaUnificadaOpp = new Opportunity();
        ventaUnificadaOpp.CloseDate = System.today()+1;
        ventaUnificadaOpp.Amount = 200000.0;
        ventaUnificadaOpp.CausaldePerdida__c ='Otro';
        //ventaUnificadaOpp.Linea_de_Negocio_Principal__c = 'ventaUnificadaOpp';
        ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
        ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
        ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
        ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
        ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
        ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
        ventaUnificadaOpp.StageName = 'En Estudio';
        ventaUnificadaOpp.Duracion_Dias__c = 10;
        ventaUnificadaOpp.AccountId = accountBusiness.Id;
        ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;
        
        Quote enterpriseQuote = new Quote();
        enterpriseQuote.OwnerId = Userinfo.getUserId();
        enterpriseQuote.Name = 'Enterprise Quote';
        enterpriseQuote.Pricebook2Id = pricebookId;
        enterpriseQuote.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote;
        
        QuoteLineItem quotelineitem = new QuoteLineItem();
        quotelineitem.QuoteId = enterpriseQuote.Id;
        quotelineitem.Quantity = 1.0;
        quotelineitem.UnitPrice = 0.0;
        quotelineitem.PricebookEntryId = price.Id;
        quotelineitem.vlocity_cmt__Action__c = 'Add';
        quotelineitem.vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}';
        quotelineitem.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        quotelineitem.vlocity_cmt__CurrencyPaymentMode__c = 'Currency';
        quotelineitem.vlocity_cmt__EffectiveOneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveOneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveQuantity__c = 1.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__LineNumber__c = '0001';
        quotelineitem.vlocity_cmt__OneTimeCalculatedPrice__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCharge__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCost__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeMargin__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (41010.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (75000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (75000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":75000.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":75000.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":75000.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":75000.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}],"REC_MNTH_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":41010.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":41010.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":41010.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":41010.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_CALC":75000.00,"REC_MNTH_STD_PRC":75000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":82.88,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST":41010.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"LogVersion":"3.0","PriceAsOfDateTime":"2022-05-04T16:36:02.576Z","LastPricingTime":"2022-05-04T16:36:02.576Z","ExternalPrices":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}';
        quotelineitem.Product2Id = product2.Id;
        quotelineitem.vlocity_cmt__Product2Id__c = product2.Id;
        quotelineitem.vlocity_cmt__ProductHierarchyGroupKeyPath__c = 'd74f9058-70b2-6370-0243-361d7f43829f';
        quotelineitem.vlocity_cmt__ProvisioningStatus__c = 'New';
        quotelineitem.vlocity_cmt__RecurringCalculatedPrice__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCharge__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringCost__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__RecurringMargin__c = 82.88;
        quotelineitem.vlocity_cmt__RecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringUOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__Recurring_UOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__RelationshipType__c = 'Child';
        quotelineitem.vlocity_cmt__RootItemId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__SequenceNumber__c = 1.0;
        quotelineitem.vlocity_cmt__ServiceAccountId__c = accountService.Id;
        quotelineitem.vlocity_cmt__UsageQuantity__c = 1.0;
        insert quotelineitem;
        
        QuoteLineItem quotelineitem1 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaNoViable.Id
            vlocity_cmt__LineNumber__c = '0001.0001');
        insert quotelineitem1;

        QuoteLineItem quotelineitem2 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaViable.Id
            vlocity_cmt__LineNumber__c = '0001.0002');
        insert quotelineitem2;
        
        String methodName = 'deleteCartsItems.PreInvoke';
        String jsonInput = '{"query":null,"hierarchy":-1,"lastRecordId":null,"pagesize":10,"includeAttachment":false,"validate":true,"price":true,"cartId":"'+enterpriseQuote.Id+'","fields":"vlocity_cmt__BillingAccountId__c,vlocity_cmt__ServiceAccountId__c,Quantity,vlocity_cmt__RecurringTotal__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__OneTimeCharge__c,ListPrice,vlocity_cmt__ParentItemId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__PremisesId__r.Name,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__EffectiveQuantity__c","filters":null,"id":"'+quotelineitem.Id+'","methodName":"deleteCartsItems"}';
        String jsonOutput = '{"errorCode":"INVOKE-200","error":"OK"}';
        String jsonOptions = '{}';


        
        ETB_GL_ConfPricing__mdt cfgtest = new ETB_GL_ConfPricing__mdt(); //ADN
        cfgtest.DeveloperName = 'PR_COLOCACIONETB';
        cfgtest.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  
        cfgtest.ETB_GL_Path__c='PR_COLOCACIONETB';

        Map<String, Object> map1 = new Map<String, Object>();
        map1.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest);
        

        Map<String,Object> input = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);
        Map<String,Object> output = (Map<String,Object>)JSON.deserializeUntyped(jsonOutput);
        Map<String,Object> options = (Map<String,Object>)JSON.deserializeUntyped(jsonOptions);

        CpqAppHandlerHookImplementation test = new CpqAppHandlerHookImplementation();
        test.invokeMethod(methodName, input, output, options);
    }*/

    @IsTest
    static void cloneCartItems(){
        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_COLOCACIONETB';
        product2.Name = 'Almacenamiento Externo Local ETB';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;
             
        Product2 product2Hijo = new Product2();
        product2Hijo.Family = 'Data Center';
        product2Hijo.ProductCode = 'PR_COLOCACION';
        product2Hijo.Name = 'Almacenamiento Externo Local';
        insert product2Hijo;
        
        PricebookEntry priceHijo = new PricebookEntry();
        priceHijo.UnitPrice = 0.0;
        priceHijo.Pricebook2Id = pricebookId;
        priceHijo.Product2Id = product2Hijo.Id;
        priceHijo.isActive = true;
        insert priceHijo;
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        
        Account accountService = new Account();
        accountService.Name = 'Account Service';
        accountService.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        accountService.Type = 'Service';
        accountService.Phone = '12345678';
        accountService.ParentId = accountBusiness.Id;
        insert accountService; 
        
        Account accountBilling = new Account();
        accountBilling.Name = 'Account Billing';
        accountBilling.Type = 'Billing';
        accountBilling.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
        accountBilling.ParentId = accountBusiness.id;
        accountBilling.Phone = '12345678';
        insert accountBilling; 
		
        Contact contact = new Contact();
        contact.Email = 'labsx@labsxd.com';
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Phone = '12345678';
        contact.AccountId = accountBusiness.Id;
        insert contact;
        
        accountBusiness.vlocity_cmt__PersonContactId__c = contact.Id;
        UPDATE accountBusiness;
        
        Opportunity ventaUnificadaOpp = new Opportunity();
        ventaUnificadaOpp.CloseDate = System.today()+1;
        ventaUnificadaOpp.Amount = 200000.0;
        ventaUnificadaOpp.CausaldePerdida__c ='Otro';
        //ventaUnificadaOpp.Linea_de_Negocio_Principal__c = 'ventaUnificadaOpp';
        ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
        ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
        ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
        ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
        ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
        ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
        ventaUnificadaOpp.StageName = 'En Estudio';
        ventaUnificadaOpp.Duracion_Dias__c = 10;
        ventaUnificadaOpp.AccountId = accountBusiness.Id;
        ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;
        
        Quote enterpriseQuote = new Quote();
        enterpriseQuote.OwnerId = Userinfo.getUserId();
        enterpriseQuote.Name = 'Enterprise Quote';
        enterpriseQuote.Pricebook2Id = pricebookId;
        enterpriseQuote.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote;
        
        QuoteLineItem quotelineitem = new QuoteLineItem();
        quotelineitem.QuoteId = enterpriseQuote.Id;
        quotelineitem.Quantity = 1.0;
        quotelineitem.UnitPrice = 0.0;
        quotelineitem.PricebookEntryId = price.Id;
        quotelineitem.vlocity_cmt__Action__c = 'Add';
        quotelineitem.vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}';
        quotelineitem.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        quotelineitem.vlocity_cmt__CurrencyPaymentMode__c = 'Currency';
        quotelineitem.vlocity_cmt__EffectiveOneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveOneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveQuantity__c = 1.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__LineNumber__c = '0001';
        quotelineitem.vlocity_cmt__OneTimeCalculatedPrice__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCharge__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCost__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeMargin__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (41010.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (75000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (75000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":75000.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":75000.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":75000.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":75000.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}],"REC_MNTH_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":41010.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":41010.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":41010.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":41010.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_CALC":75000.00,"REC_MNTH_STD_PRC":75000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":82.88,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST":41010.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"LogVersion":"3.0","PriceAsOfDateTime":"2022-05-04T16:36:02.576Z","LastPricingTime":"2022-05-04T16:36:02.576Z","ExternalPrices":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}';
        quotelineitem.Product2Id = product2.Id;
        quotelineitem.vlocity_cmt__Product2Id__c = product2.Id;
        quotelineitem.vlocity_cmt__ProductHierarchyGroupKeyPath__c = 'd74f9058-70b2-6370-0243-361d7f43829f';
        quotelineitem.vlocity_cmt__ProvisioningStatus__c = 'New';
        quotelineitem.vlocity_cmt__RecurringCalculatedPrice__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCharge__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringCost__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__RecurringMargin__c = 82.88;
        quotelineitem.vlocity_cmt__RecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringUOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__Recurring_UOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__RelationshipType__c = 'Child';
        quotelineitem.vlocity_cmt__RootItemId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__SequenceNumber__c = 1.0;
        quotelineitem.vlocity_cmt__ServiceAccountId__c = accountService.Id;
        quotelineitem.vlocity_cmt__UsageQuantity__c = 1.0;
        insert quotelineitem;
        
        QuoteLineItem quotelineitem1 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaNoViable.Id
            vlocity_cmt__LineNumber__c = '0001.0001');
        insert quotelineitem1;

        QuoteLineItem quotelineitem2 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaViable.Id
            vlocity_cmt__LineNumber__c = '0001.0002');
        insert quotelineitem2;
        
        String methodName = 'cloneItems.PreInvoke';
        String jsonInput = '{"cartId":"'+enterpriseQuote.Id+'","id":"'+quotelineitem2.Id+'","items":[{"itemId":"'+quotelineitem2.Id+'"}],"methodName":"cloneItems"}';
        String jsonOutput = '{"errorCode":"INVOKE-200","error":"OK"}';
        String jsonOptions = '{}';

        Map<String,Object> input = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);
        Map<String,Object> output = (Map<String,Object>)JSON.deserializeUntyped(jsonOutput);
        Map<String,Object> options = (Map<String,Object>)JSON.deserializeUntyped(jsonOptions);

        CpqAppHandlerHookImplementation test = new CpqAppHandlerHookImplementation();
        test.invokeMethod(methodName, input, output, options);
    }

    @IsTest
    static void deleteCartItems(){
        
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_COLOCACIONETB';
        product2.Name = 'Almacenamiento Externo Local ETB';
        insert product2;
        
        PricebookEntry price = new PricebookEntry();
        price.UnitPrice = 0.0;
        price.Pricebook2Id = pricebookId;
        price.Product2Id = product2.Id;
        price.isActive = true;
        insert price;
             
        Product2 product2Hijo = new Product2();
        product2Hijo.Family = 'Data Center';
        product2Hijo.ProductCode = 'PR_COLOCACION';
        product2Hijo.Name = 'Almacenamiento Externo Local';
        insert product2Hijo;
        
        PricebookEntry priceHijo = new PricebookEntry();
        priceHijo.UnitPrice = 0.0;
        priceHijo.Pricebook2Id = pricebookId;
        priceHijo.Product2Id = product2Hijo.Id;
        priceHijo.isActive = true;
        insert priceHijo;
        
        Account accountBusiness = new Account();
        accountBusiness.Name = 'Account Billing';
        accountBusiness.Type = 'Business';
        accountBusiness.Phone = '12345678';
        accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        
        Account accountService = new Account();
        accountService.Name = 'Account Service';
        accountService.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        accountService.Type = 'Service';
        accountService.Phone = '12345678';
        accountService.ParentId = accountBusiness.Id;
        insert accountService; 
        
        Account accountBilling = new Account();
        accountBilling.Name = 'Account Billing';
        accountBilling.Type = 'Billing';
        accountBilling.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Billing').getRecordTypeId();
        accountBilling.ParentId = accountBusiness.id;
        accountBilling.Phone = '12345678';
        insert accountBilling; 
		
        Contact contact = new Contact();
        contact.Email = 'labsx@labsxd.com';
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Phone = '12345678';
        contact.AccountId = accountBusiness.Id;
        insert contact;
        
        accountBusiness.vlocity_cmt__PersonContactId__c = contact.Id;
        UPDATE accountBusiness;
        
        Opportunity ventaUnificadaOpp = new Opportunity();
        ventaUnificadaOpp.CloseDate = System.today()+1;
        ventaUnificadaOpp.Amount = 200000.0;
        ventaUnificadaOpp.CausaldePerdida__c ='Otro';
        //ventaUnificadaOpp.Linea_de_Negocio_Principal__c = 'ventaUnificadaOpp';
        ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
        ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
        ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
        ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
        ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
        ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
        ventaUnificadaOpp.StageName = 'En Estudio';
        ventaUnificadaOpp.Duracion_Dias__c = 10;
        ventaUnificadaOpp.AccountId = accountBusiness.Id;
        ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;
        
        Quote enterpriseQuote = new Quote();
        enterpriseQuote.OwnerId = Userinfo.getUserId();
        enterpriseQuote.Name = 'Enterprise Quote';
        enterpriseQuote.Pricebook2Id = pricebookId;
        enterpriseQuote.OpportunityId = ventaUnificadaOpp.Id;
        enterpriseQuote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('EnterpriseQuote').getRecordTypeId();
        insert enterpriseQuote;
        
        QuoteLineItem quotelineitem = new QuoteLineItem();
        quotelineitem.QuoteId = enterpriseQuote.Id;
        quotelineitem.Quantity = 1.0;
        quotelineitem.UnitPrice = 0.0;
        quotelineitem.PricebookEntryId = price.Id;
        quotelineitem.vlocity_cmt__Action__c = 'Add';
        quotelineitem.vlocity_cmt__AssetReferenceId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Ancho_Banda":"Hasta 100 Mbps","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":12,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Nemonico":"SEGCE"}';
        quotelineitem.vlocity_cmt__BillingAccountId__c = accountBilling.Id;
        quotelineitem.vlocity_cmt__CurrencyPaymentMode__c = 'Currency';
        quotelineitem.vlocity_cmt__EffectiveOneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveOneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__EffectiveQuantity__c = 1.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__EffectiveRecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__LineNumber__c = '0001';
        quotelineitem.vlocity_cmt__OneTimeCalculatedPrice__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCharge__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCostTotal__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeCost__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeMargin__c = 0.0;
        quotelineitem.vlocity_cmt__OneTimeTotal__c = 0.0;
        quotelineitem.vlocity_cmt__PricingLogData__c = '{"LogData":{"REC_MNTH_STD_CST_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Cost (41010.00) + Rollup Recurring Cost Total (0.00)] x Quantity (1.00)"}],"OT_STD_CST_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Cost (0.00) + Rollup One Time Cost Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_TOTAL":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"[Recurring Calculated Price (75000.00) + Rollup Recurring Total (0.00)] x Quantity (1.00)"}],"REC_MNTH_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"Recurring Charge (75000.00) - Recurring Manual Discount (0.00%)"}],"OT_STD_PRC_TOTAL":[{"ChargeTiming":"One-Time","LogSequence":0,"DisplayText":"[One Time Calculated Price (0.00) + Rollup One Time Total (0.00)] x Quantity (1.00)"}],"OT_STD_PRC_CALC":[{"ChargeTiming":null,"LogSequence":0,"DisplayText":"One Time Charge (0.00) - One Time Manual Discount (0.00%)"}],"REC_MNTH_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":75000.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":75000.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":75000.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":75000.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_PRC":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_PRC","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}],"REC_MNTH_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":41010.00,"SubType":"Standard","Frequency":"Monthly","ChargeTiming":"Recurring","EndValue":41010.00,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"REC_MNTH_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":41010.00,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":41010.00,"AdjustmentType":"None","LogSequence":0}],"OT_STD_CST":[{"PriceListEntryId":null,"LogType":"PRICE","PricingElementGlobalKey":null,"StartValue":null,"SubType":"Standard","Frequency":null,"ChargeTiming":"One-time","EndValue":null,"DisplayText":"Priced from ETB-RangeAttributePricingProcedure","PricingVariableCode":"OT_STD_CST","PricingElementId":null,"PromotionId":null,"OfferId":null,"PriceListId":null,"BaseAdjustment":null,"BaseValue":null,"AdjustmentMethod":null,"AdjustmentValue":null,"Amount":null,"AdjustmentType":"None","LogSequence":0}]},"PricingVariableCodeFieldBinding":{"vlocity_cmt__RecurringManualDiscount__c":"REC_MNTH_STD_PRC_DISC_PCT_MAN","vlocity_cmt__OneTimeManualDiscount__c":"OT_STD_PRC_DISC_PCT_MAN","vlocity_cmt__EffectiveQuantity__c":"EFFECTIVE_QUANTITY","Quantity":"LINE_QUANTITY","vlocity_cmt__EffectiveRecurringTotal__c":"EFF_REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringTotal__c":"REC_MNTH_STD_PRC_TOTAL","vlocity_cmt__RecurringCalculatedPrice__c":"REC_MNTH_STD_PRC_CALC","vlocity_cmt__RecurringCharge__c":"REC_MNTH_STD_PRC","vlocity_cmt__EffectiveOneTimeTotal__c":"EFF_OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeTotal__c":"OT_STD_PRC_TOTAL","vlocity_cmt__OneTimeCalculatedPrice__c":"OT_STD_PRC_CALC","vlocity_cmt__OneTimeCharge__c":"OT_STD_PRC","vlocity_cmt__RecurringMargin__c":"REC_MNTH_MARGIN","vlocity_cmt__OneTimeMargin__c":"OT_MARGIN","vlocity_cmt__EffectiveRecurringCostTotal__c":"EFF_REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCostTotal__c":"REC_MNTH_STD_CST_TOTAL","vlocity_cmt__RecurringCost__c":"REC_MNTH_STD_CST","vlocity_cmt__EffectiveOneTimeCostTotal__c":"EFF_OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCostTotal__c":"OT_STD_CST_TOTAL","vlocity_cmt__OneTimeCost__c":"OT_STD_CST"},"PriceAdjustmentPromoKeys":[],"PricingVariableCodeValues":{"DISP_OT_STD_PRC":0.00,"ROLLUP_OT_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL":0.00,"ROLLUP_REC_MNTH_STD_CST_TOTAL":0.00,"ROLLUP_OT_STD_CST_TOTAL":0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN":0.00,"OT_STD_PRC_DISC_PCT_MAN":0.00,"EFFECTIVE_QUANTITY":1.00,"LINE_QUANTITY":1.00,"EFF_REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_TOTAL":75000.00,"REC_MNTH_STD_PRC_CALC":75000.00,"REC_MNTH_STD_PRC":75000.00,"EFF_OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_TOTAL":0.00,"OT_STD_PRC_CALC":0.00,"OT_STD_PRC":0.00,"REC_MNTH_MARGIN":82.88,"OT_MARGIN":0.00,"EFF_REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST_TOTAL":41010.00,"REC_MNTH_STD_CST":41010.00,"EFF_OT_STD_CST_TOTAL":0.00,"OT_STD_CST_TOTAL":0.00,"OT_STD_CST":0.00},"PricingVariableCodeBaseValues":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"LogVersion":"3.0","PriceAsOfDateTime":"2022-05-04T16:36:02.576Z","LastPricingTime":"2022-05-04T16:36:02.576Z","ExternalPrices":{"REC_MNTH_STD_PRC":75000.00,"OT_STD_PRC":null,"REC_MNTH_STD_CST":41010.00,"OT_STD_CST":null},"SequentialOffers":false,"SequentialPromotions":false,"SequentialDiscounts":false}';
        quotelineitem.Product2Id = product2.Id;
        quotelineitem.vlocity_cmt__Product2Id__c = product2.Id;
        quotelineitem.vlocity_cmt__ProductHierarchyGroupKeyPath__c = 'd74f9058-70b2-6370-0243-361d7f43829f';
        quotelineitem.vlocity_cmt__ProvisioningStatus__c = 'New';
        quotelineitem.vlocity_cmt__RecurringCalculatedPrice__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCharge__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringCostTotal__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringCost__c = 41010.0;
        quotelineitem.vlocity_cmt__RecurringManualDiscount__c = 0.0;
        quotelineitem.vlocity_cmt__RecurringMargin__c = 82.88;
        quotelineitem.vlocity_cmt__RecurringTotal__c = 75000.0;
        quotelineitem.vlocity_cmt__RecurringUOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__Recurring_UOM__c = 'Monthly';
        quotelineitem.vlocity_cmt__RelationshipType__c = 'Child';
        quotelineitem.vlocity_cmt__RootItemId__c = '4cbbdee9-cdef-aaf5-eed3-4efa0bc017de';
        quotelineitem.vlocity_cmt__SequenceNumber__c = 1.0;
        quotelineitem.vlocity_cmt__ServiceAccountId__c = accountService.Id;
        quotelineitem.vlocity_cmt__UsageQuantity__c = 1.0;
        insert quotelineitem;
        
        QuoteLineItem quotelineitem1 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":null,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaNoViable.Id
            vlocity_cmt__LineNumber__c = '0001.0001');
        insert quotelineitem1;

        QuoteLineItem quotelineitem2 = new QuoteLineItem(
            Quantity = 1.0,
            QuoteId	 = enterpriseQuote.Id,
            PricebookEntryId = priceHijo.Id,
            UnitPrice = 0.0,
            vlocity_cmt__Action__c = 'Add',
            vlocity_cmt__AttributeSelectedValues__c = '{"ATT_Vigencia_Viabilidad_Dias":3,"ATT_LlamadaRáfaga":false,"ATT_RangoNumeración":null,"ATT_Consumo_Minutos_Voz_Local_Mes":null,"ATT_NúmeroConexión":null,"ATT_MetrosTendidoUM_ETB":null,"ATT_Nemonico":"E1","ATT_EquipoAcceso":null,"ATT_Identificador_de_Servicio":null,"ATT_Tipo_de_Servicio_Gestor":null,"ATT_Comentarios":null,"ATT_Tipo_de_Servicio":null,"ATT_ReferenciaPlanta":"673fvs76w","ATT_MarcadePlanta":"43yug874","ATT_CantidadEnlaces":"4","ATT_TipoSeñalización":null,"ATT_TipoEnlace":null,"ATT_NúmeroConservar":null,"ATT_TiempoContratoDias":null,"ATT_Clausula_de_Terminacion_Anticipada":"Sí Acepta","ATT_TiempoContratoMeses":23,"ATT_TipoTráficodePlan":"Entrante por Consumo","ATT_CantidadSesionesSIP":null}',
            vlocity_cmt__BillingAccountId__c = accountBilling.Id,
            Product2Id = product2Hijo.Id,
            vlocity_cmt__Product2Id__c = product2Hijo.Id,
            vlocity_cmt__RelationshipType__c = 'Child',
            vlocity_cmt__SequenceNumber__c = 1.0,
            vlocity_cmt__ServiceAccountId__c = accountService.Id,
            vlocity_cmt__UsageQuantity__c = 1.0,
            //Viabilidad__c = viabilidadCerradaViable.Id
            vlocity_cmt__LineNumber__c = '0001.0002');
        insert quotelineitem2;
        
        String methodName = 'deleteCartsItems.PreInvoke';
        String jsonInput = '{"query":null,"hierarchy":-1,"lastRecordId":null,"pagesize":10,"includeAttachment":false,"validate":true,"price":true,"cartId":"'+enterpriseQuote.Id+'","fields":"vlocity_cmt__BillingAccountId__c,vlocity_cmt__ServiceAccountId__c,Quantity,vlocity_cmt__RecurringTotal__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__OneTimeCharge__c,ListPrice,vlocity_cmt__ParentItemId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__PremisesId__r.Name,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__EffectiveQuantity__c","filters":null,"id":"'+quotelineitem2.Id+'","methodName":"deleteCartsItems"}';
        String jsonOutput = '{"errorCode":"INVOKE-200","error":"OK"}';
        String jsonOptions = '{}';

        Map<String,Object> input = (Map<String,Object>)JSON.deserializeUntyped(jsonInput);
        Map<String,Object> output = (Map<String,Object>)JSON.deserializeUntyped(jsonOutput);
        Map<String,Object> options = (Map<String,Object>)JSON.deserializeUntyped(jsonOptions);

        CpqAppHandlerHookImplementation test = new CpqAppHandlerHookImplementation();
        test.invokeMethod(methodName, input, output, options);
    }
    
    	@isTest
    static void invokeMethodWithFields(){
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        input.put('fields', 'TestField');

        Test.startTest();
        Boolean result = handlerHookImplementation.invokeMethod('postCartsItems.PreInvoke',input,output,options);
        Test.stopTest();
        System.assertEquals(true, result);
    }
    
   @isTest
    static void invokeMethodWithoutFields(){
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Test.startTest();
        //product2 codigoProducto = [SELECT ProductCode FROM product2 where name ='Internet Dedicado'Limit 1];
        string codigoProducto ='PR_COLOCACIONETB';
        ETB_PricingHandlerCls.getMetadata(codigoProducto);

        Boolean result = handlerHookImplementation.invokeMethod('deleteCartsItems.PreInvoke',input,output,options);
        Test.stopTest();
        System.assertEquals(false, result);
    }
    
    @isTest
    static void invokeMethodWithError(){
        
        Id pricebookId = Test.getStandardPricebookId();
		Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_COLOCACIONETB';
        product2.Name = 'Colocacion ETB';
        insert product2;
        
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        input.put('fields', 'TestError');

        ETB_GL_ConfPricing__mdt cfgtest = new ETB_GL_ConfPricing__mdt(); //ADN
        cfgtest.DeveloperName = 'PR_COLOCACIONETB';
        cfgtest.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  
        cfgtest.ETB_GL_Path__c='etb_InternetDedicado';

        Map<String, Object> map1 = new Map<String, Object>();
        map1.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest);

        Test.startTest();
        Try{
        	Boolean result = handlerHookImplementation.invokeMethod('deleteCartsItems.PreInvoke',input,output,options);   
        }catch(Exception ex){
            System.assertEquals('Ocurrió un al invocar el metodo', ex.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void invokeMethodWithPutCartsItems(){
        
        Id pricebookId = Test.getStandardPricebookId();
		Product2 product2 = new Product2();
        product2.Family = 'Data Center';
        product2.ProductCode = 'PR_COLOCACIONETB';
        product2.Name = 'Colocacion ETB';
        insert product2;
        
        CpqAppHandlerHookImplementation handlerHookImplementation = new CpqAppHandlerHookImplementation();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        input.put('fields', 'TestError');

        ETB_GL_ConfPricing__mdt cfgtest = new ETB_GL_ConfPricing__mdt(); //ADN
        cfgtest.DeveloperName = 'PR_COLOCACIONETB';
        cfgtest.ETB_GL_ListaAtributos__c = 'ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses';  
        cfgtest.ETB_GL_Path__c='Colocacion ETB';
        Map<String, Object> map1 = new Map<String, Object>();
        map1.put('ATT_Tipo_de_Ultima_Milla;ATT_Ancho_Banda;ATT_Categoria_de_Enlace;ATT_Tipo_de_contrato;ATT_Ciudad_Nodo_Origen;ATT_Ciudad_Nodo_Destino;ATT_TiempoContratoMeses',cfgtest);

        Test.startTest();
        string codigoProducto ='PR_COLOCACIONETB';
        ETB_PricingHandlerCls.getMetadata(codigoProducto);
        Boolean result = handlerHookImplementation.invokeMethod('putCartsItems.PreInvoke',input,output,options);
        Test.stopTest();
        System.assertEquals(true, result);
    }
    
    
}