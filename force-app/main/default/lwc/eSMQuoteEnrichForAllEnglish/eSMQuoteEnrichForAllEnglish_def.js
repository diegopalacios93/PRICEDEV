export const OMNIDEF = {"userTimeZone":-180,"userProfile":"System Administrator","userName":"devops@etb.com.co.siteetb","userId":"0050r000002KhsQAAS","userCurrencyCode":"COP","timeStamp":"2022-07-29T15:02:20.687Z","sOmniScriptId":"a6c7j000000GperAAC","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"wpm":false,"visualforcePagesAvailableInPreview":{},"trackingCustomData":{},"timeTracking":false,"stylesheet":{"newportRtl":"","newport":"","lightningRtl":"","lightning":""},"stepChartPlacement":"right","ssm":false,"showInputWidth":false,"seedDataJSON":{},"scrollBehavior":"auto","saveURLPatterns":{},"saveObjectId":"%ContextId%","saveNameTemplate":null,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveContentEncoded":false,"rtpSeed":false,"pubsub":false,"persistentComponent":[{"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl"},"label":"","itemsKey":"cartItems","id":"vlcCart"},{"render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"","modalController":""},"label":"","itemsKey":"knowledgeItems","id":"vlcKnowledge","dispOutsideOmni":false}],"message":{},"mergeSavedData":false,"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"hideStepChart":false,"errorMessage":{"custom":[]},"enableKnowledge":false,"elementTypeToHTMLTemplateMapping":{},"disableUnloadWarn":true,"currentLanguage":"en_US","currencyCode":"","consoleTabTitle":null,"consoleTabLabel":"New","consoleTabIcon":"custom:custom18","cancelType":"SObject","cancelSource":"%ContextId%","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","bLK":false,"autoSaveOnStepNext":false,"autoFocus":false,"allowSaveForLater":false,"allowCancel":true},"prefillJSON":"{}","lwcId":"fb28a262-320a-044a-7c65-a1d07dc1ee88","labelMap":{"Role":"ContactAssingment:NewContactInfo:Role","Phone":"ContactAssingment:NewContactInfo:Phone","Email":"ContactAssingment:NewContactInfo:Email","LastName":"ContactAssingment:NewContactInfo:LastName","FirstName":"ContactAssingment:NewContactInfo:FirstName","DocumentNumber":"ContactAssingment:NewContactInfo:DocumentNumber","DocumentType":"ContactAssingment:NewContactInfo:DocumentType","DRTAContact":"DRTAContact","Batch Success Message":"Success:Batch Success Message","ErrText":"Success:ErrText","NewContactInfo":"ContactAssingment:NewContactInfo","Contact-Block":"ContactAssingment:Contact-Block","ContactOptionRadioButtom":"ContactAssingment:ContactOptionRadioButtom","BillingAccount":"Payment:BillingAccount","Success":"Success","UpdateCartItemsBatch":"UpdateCartItemsBatch","UpdateCartItems":"UpdateCartItems","SVNewContactId":"SVNewContactId","SVContactId":"SVContactId","SetErrorsDuplicateContact":"SetErrorsDuplicateContact","VIPCreateNewContact":"VIPCreateNewContact","ContactAssingment":"ContactAssingment","Payment":"Payment","GetRecordTypeForBillingAccount":"GetRecordTypeForBillingAccount","AccountRecordType":"AccountRecordType","Contact":"ContactAssingment:Contact-Block:Contact"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[true,false],"show":null,"pubsub":false,"message":{},"label":null,"elementValueMap":{"SObjectType":"Account","DeveloperName":"Billing","AccountId":"%AccountId%"},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"AccountRecordType","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"AccountRecordType","lwcId":"lwc0"},{"type":"DataRaptor Extract Action","propSetMap":{"wpm":false,"validationRequired":"Step","ssm":false,"showPersistentComponent":[true,false],"show":null,"responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"postMessage":"Done","message":{},"label":null,"inProgressMessage":"In Progress","ignoreCache":false,"failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"dataRaptor Input Parameters":[{"inputParam":"DeveloperName","element":"DeveloperName"},{"inputParam":"SObjectType","element":"SObjectType"}],"controlWidth":12,"businessEvent":"","businessCategory":"","bundle":"GetRecordTypeByObjectType","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"GetRecordTypeForBillingAccount","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"bDataRaptorExtractAction":true,"JSONPath":"GetRecordTypeForBillingAccount","lwcId":"lwc1"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[true,false],"show":null,"saveMessage":"","saveLabel":"","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":3,"previousLabel":"","nextWidth":3,"nextLabel":"Siguiente","message":{},"label":"Pago","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":null,"cancelMessage":"Are you sure?","cancelLabel":"Cancel","businessEvent":"","businessCategory":"","allowSaveForLater":true,"HTMLTemplateId":"","uiElements":{"Payment":"","BillingAccount":""},"aggElements":{}},"offSet":0,"name":"Payment","level":0,"indexInParent":2,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Lookup","rootIndex":2,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":false,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"placeholder":"","label":"Buscar cuenta de facturación","inputWidth":12,"hide":false,"helpText":"","help":false,"errorMessage":{"default":null,"custom":[]},"disOnTplt":false,"defaultValue":null,"dataSource":{"type":"SObject","mapItems":{"phase2MapItems":[{"InterfaceFieldAPIName__c":"BillingAccount:Id","DomainObjectFieldAPIName__c":"name","DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON"},{"InterfaceFieldAPIName__c":"BillingAccount:Name","DomainObjectFieldAPIName__c":"value","DomainObjectCreationOrder__c":1,"DomainObjectAPIName__c":"JSON"}],"phase1MapItems":[{"InterfaceObjectName__c":"Account","InterfaceObjectLookupOrder__c":1,"InterfaceFieldAPIName__c":"RecordTypeId","FilterValue__c":"recId","FilterOperator__c":"=","DomainObjectFieldAPIName__c":"BillingAccount"},{"InterfaceObjectName__c":"Account","InterfaceObjectLookupOrder__c":1,"InterfaceFieldAPIName__c":"ParentId","FilterValue__c":"accId","FilterOperator__c":"=","DomainObjectFieldAPIName__c":"BillingAccount"}],"inputParameters":[{"inputParam":"accId","element":"AccountId"},{"inputParam":"recId","element":"RecordTypeId"}]}},"controlWidth":12,"conditionType":"Hide if False","clearValue":true,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"BillingAccount","level":1,"JSONPath":"Payment:BillingAccount","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bLookup":true,"lwcId":"lwc20-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"Payment","lwcId":"lwc2"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[true,false],"show":null,"saveMessage":"","saveLabel":"","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":"3","previousLabel":"Anterior","nextWidth":"3","nextLabel":"Guardar","message":{},"label":"Asignación de contacto","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":null,"cancelMessage":"Are you sure?","cancelLabel":"Cancel","businessEvent":"","businessCategory":"","allowSaveForLater":false,"HTMLTemplateId":"","uiElements":{"ContactAssingment":"","ContactOptionRadioButtom":"","Contact":"","Contact-Block":"","DocumentType":"","DocumentNumber":"","FirstName":"","LastName":"","Email":"","Phone":"","Role":"","NewContactInfo":""},"aggElements":{}},"offSet":0,"name":"ContactAssingment","level":0,"indexInParent":3,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Radio","rootIndex":3,"response":null,"propSetMap":{"show":null,"required":false,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"options":[{"value":"Buscar un contacto existente","name":"searchContact","developerName":null,"autoAdv":null},{"value":"Crear un nuevo contacto","name":"createNewContact","developerName":null,"autoAdv":null}],"optionWidth":100,"optionSource":{"type":"","source":""},"optionHeight":100,"label":"Seleccione una opción:","imageCountInRow":3,"horizontalMode":true,"hide":false,"helpTextPos":"","helpText":"","help":false,"enableCaption":true,"disOnTplt":false,"defaultValue":null,"controllingField":{"type":"","source":"","element":""},"controlWidth":12,"conditionType":"Hide if False","accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"ContactOptionRadioButtom","level":1,"JSONPath":"ContactAssingment:ContactOptionRadioButtom","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bRadio":true,"lwcId":"lwc30-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Type Ahead Block","rootIndex":3,"response":null,"propSetMap":{"useDataJson":false,"typeAheadKey":"ContactName","showInputWidth":false,"show":{"group":{"rules":[{"field":"ContactOptionRadioButtom","data":"searchContact","condition":"="}],"operator":"AND"}},"required":false,"readOnly":false,"newItemLabel":"","minLength":0,"maxLength":255,"label":"Buscar un contacto","inputWidth":12,"hideMap":true,"hideEditButton":false,"helpTextPos":"","helpText":"","help":false,"googleTransformation":{"street":"","postal_code":"","locality":"","country":"","administrative_area_level_2":"","administrative_area_level_1":""},"googleMapsAPIKey":"","googleAddressCountry":"all","enableLookup":false,"enableGoogleMapsAutocomplete":false,"editMode":false,"disableDataFilter":false,"debounceValue":0,"dataProcessorFunction":"","dataJsonPath":"","controlWidth":12,"conditionType":"Hide if False","callFrequency":300,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"Contact-Block","level":1,"JSONPath":"ContactAssingment:Contact-Block","indexInParent":1,"index":0,"children":[{"response":null,"level":2,"indexInParent":0,"eleArray":[{"type":"Type Ahead","rootIndex":1,"response":null,"propSetMap":{"taAction":{"type":"DataRaptor Extract Action","rootIndex":3,"response":null,"propSetMap":{"_di":1,"repeat":false,"readOnly":false,"wpm":false,"validationRequired":"Step","ssm":false,"showPersistentComponent":[true,false],"show":null,"responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"postMessage":"Done","message":{},"label":"DRTAContact","inProgressMessage":"In Progress","ignoreCache":false,"failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"dataRaptor Input Parameters":[{"inputParam":"ContactKey","element":"Contact"},{"inputParam":"AccountId","element":"AccountId"}],"controlWidth":12,"businessEvent":"","businessCategory":"","bundle":"etb_GetContactInfoForTA","HTMLTemplateId":""},"name":"DRTAContact","level":2,"JSONPath":"ContactAssingment:Contact-Block:Contact","indexInParent":0,"index":0,"children":[],"bHasAttachment":false},"useDataJson":false,"typeAheadKey":"ContactName","showInputWidth":false,"show":{"group":{"rules":[{"field":"ContactOptionRadioButtom","data":"searchContact","condition":"="}],"operator":"AND"}},"required":false,"readOnly":false,"newItemLabel":"","minLength":0,"maxLength":255,"label":"Buscar un contacto","inputWidth":12,"hideMap":true,"hideEditButton":false,"helpTextPos":"","helpText":"","help":false,"googleTransformation":{"street":"","postal_code":"","locality":"","country":"","administrative_area_level_2":"","administrative_area_level_1":""},"googleMapsAPIKey":"","googleAddressCountry":"all","enableLookup":false,"enableGoogleMapsAutocomplete":false,"editMode":false,"disableDataFilter":false,"debounceValue":0,"dataProcessorFunction":"","dataJsonPath":"","controlWidth":12,"conditionType":"Hide if False","callFrequency":300,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"Contact","level":2,"JSONPath":"ContactAssingment:Contact-Block:Contact","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTypeahead":true,"lwcId":"lwc3100-0"}],"bHasAttachment":false}],"bHasAttachment":false,"bTypeaheadBlock":true,"lwcId":"lwc31-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":2,"eleArray":[{"type":"Block","rootIndex":3,"response":null,"propSetMap":{"bus":true,"show":{"group":{"rules":[{"field":"ContactOptionRadioButtom","data":"createNewContact","condition":"="}],"operator":"AND"}},"repeatLimit":null,"repeatClone":false,"repeat":false,"label":"Crear un nuevo contacto","hide":false,"controlWidth":12,"conditionType":"Hide if False","collapse":false,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"NewContactInfo","level":1,"JSONPath":"ContactAssingment:NewContactInfo","indexInParent":2,"index":0,"children":[{"response":null,"level":2,"indexInParent":0,"eleArray":[{"type":"Select","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"options":[{"name":"Cédula de ciudadanía","value":"Cédula de ciudadanía"},{"name":"Cédula de extranjería","value":"Cédula de extranjería"},{"name":"Pasaporte","value":"Pasaporte"},{"name":"Permiso Especial de Permanencia","value":"Permiso Especial de Permanencia"}],"optionSource":{"type":"SObject","source":"Contact.Tipodedocumento__c"},"label":"Tipo de documento","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"controllingField":{"type":"","source":"","element":""},"controlWidth":6,"conditionType":"Hide if False","accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"DocumentType","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:DocumentType","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bSelect":true,"lwcId":"lwc3200-0"}],"bHasAttachment":false},{"response":null,"level":2,"indexInParent":1,"eleArray":[{"type":"Number","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"ptrnErrText":"Solo se permiten números.","placeholder":"","pattern":"^[0-9]+","mask":null,"label":"Número de documento","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"debounceValue":0,"controlWidth":6,"conditionType":"Hide if False","autocomplete":null,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"DocumentNumber","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:DocumentNumber","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bNumber":true,"lwcId":"lwc3201-0"}],"bHasAttachment":false},{"response":null,"level":2,"indexInParent":2,"eleArray":[{"type":"Text","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"ptrnErrText":"Por favor, ingrese un nombre válido.","placeholder":"","pattern":"^[a-zA-ZÀ-ÿ_-\\u00f1\\u00d1]+(\\s*[a-zA-ZÀ-ÿ\\u00f1\\u00d1]*)*[a-zA-ZÀ-ÿ\\u00f1\\u00d1-]+$","minLength":null,"maxLength":null,"mask":"","label":"Nombre","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"debounceValue":0,"controlWidth":4,"conditionType":"Hide if False","autocomplete":null,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"FirstName","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:FirstName","indexInParent":2,"index":0,"children":[],"bHasAttachment":false,"bText":true,"lwcId":"lwc3202-0"}],"bHasAttachment":false},{"response":null,"level":2,"indexInParent":3,"eleArray":[{"type":"Text","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"ptrnErrText":"Por favor, ingrese un apellido válido.","placeholder":"","pattern":"^[a-zA-ZÀ-ÿ_-\\u00f1\\u00d1]+(\\s*[a-zA-ZÀ-ÿ\\u00f1\\u00d1]*)*[a-zA-ZÀ-ÿ\\u00f1\\u00d1-]+$","minLength":0,"maxLength":255,"mask":"","label":"Apellido","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"debounceValue":0,"controlWidth":4,"conditionType":"Hide if False","autocomplete":null,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"LastName","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:LastName","indexInParent":3,"index":0,"children":[],"bHasAttachment":false,"bText":true,"lwcId":"lwc3203-0"}],"bHasAttachment":false},{"response":null,"level":2,"indexInParent":4,"eleArray":[{"type":"Email","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"ptrnErrText":"","placeholder":"","pattern":"","label":"Correo Electrónico","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"debounceValue":0,"controlWidth":4,"conditionType":"Hide if False","autocomplete":null,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"Email","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:Email","indexInParent":4,"index":0,"children":[],"bHasAttachment":false,"bEmail":true,"lwcId":"lwc3204-0"}],"bHasAttachment":false},{"response":null,"level":2,"indexInParent":5,"eleArray":[{"type":"Telephone","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"ptrnErrText":"Solo se permiten números.","placeholder":"","pattern":"[0-9]{10}","minLength":10,"maxLength":10,"mask":"","label":"Teléfono de contacto","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"debounceValue":0,"controlWidth":6,"conditionType":"Hide if False","autocomplete":null,"accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"Phone","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:Phone","indexInParent":5,"index":0,"children":[],"bHasAttachment":false,"bTelephone":true,"lwcId":"lwc3205-0"}],"bHasAttachment":false},{"response":null,"level":2,"indexInParent":6,"eleArray":[{"type":"Select","rootIndex":3,"response":null,"propSetMap":{"showInputWidth":false,"show":null,"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"options":[{"name":"Decisor","value":"Decisor"},{"name":"Prescriptor técnico","value":"Prescriptor técnico"},{"name":"Prescriptor funcional","value":"Prescriptor funcional"},{"name":"Gestor","value":"Gestor"},{"name":"Contacto clave","value":"Contacto clave"},{"name":"Secretaria","value":"Secretaria"},{"name":"Administrativo","value":"Administrativo"},{"name":"Técnico","value":"Técnico"},{"name":"Aprueba","value":"Aprueba"},{"name":"Decide","value":"Decide"},{"name":"Influencia","value":"Influencia"},{"name":"Evalúa","value":"Evalúa"},{"name":"Usuario","value":"Usuario"},{"name":"Comercial","value":"Comercial"},{"name":"Técnico y comercial","value":"Técnico y comercial"}],"optionSource":{"type":"SObject","source":"Contact.Rol__c"},"label":"Rol","inputWidth":12,"hide":false,"helpTextPos":"","helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"controllingField":{"type":"","source":"","element":""},"controlWidth":6,"conditionType":"Hide if False","accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"Role","level":2,"JSONPath":"ContactAssingment:NewContactInfo|1:Role","indexInParent":6,"index":0,"children":[],"bHasAttachment":false,"bSelect":true,"lwcId":"lwc3206-0"}],"bHasAttachment":false}],"bHasAttachment":false,"bBlock":true,"lwcId":"lwc32-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"ContactAssingment","lwcId":"lwc3"},{"type":"Integration Procedure Action","propSetMap":{"wpm":false,"validationRequired":"Step","useContinuation":false,"svgSprite":"","svgIcon":"","ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"field":"ContactAssingment:ContactOptionRadioButtom","data":"createNewContact","condition":"="}],"operator":"AND"}},"sendOnlyExtraPayload":true,"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"VIPCreateNewContact","remoteTimeout":30000,"remoteOptions":{"useFuture":false,"preTransformBundle":"","postTransformBundle":"","chainable":false},"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"preTransformBundle":"","postTransformBundle":"","postMessage":"Done","message":{},"label":"VIPCreateNewContact","integrationProcedureKey":"etb_CreateNewContact","inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","extraPayload":{"NewContactInfo":"%ContactAssingment:NewContactInfo%","AccountId":"%AccountId%"},"errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"controlWidth":12,"businessEvent":"","businessCategory":"","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"VIPCreateNewContact","level":0,"indexInParent":4,"bHasAttachment":false,"bEmbed":false,"bIntegrationProcedureAction":true,"JSONPath":"VIPCreateNewContact","lwcId":"lwc4"},{"type":"Set Errors","propSetMap":{"wpm":false,"validationRequired":"Step","ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"field":"VIPCreateNewContact:success","data":"false","condition":"="}],"operator":"AND"}},"pubsub":false,"message":{},"label":"SetErrorsDuplicateContact","elementErrorMap":{"DocumentNumber":"%VIPCreateNewContact:message%"},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetErrorsDuplicateContact","level":0,"indexInParent":5,"bHasAttachment":false,"bEmbed":false,"bSetErrors":true,"JSONPath":"SetErrorsDuplicateContact","lwcId":"lwc5"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"field":"ContactAssingment:ContactOptionRadioButtom","data":"searchContact","condition":"="},{"field":"ContactAssingment:Contact-Block:ContactId","data":null,"condition":"<>"}],"operator":"AND"}},"pubsub":false,"message":{},"label":"SVContactId","elementValueMap":{"SetValuesContactId":"=%ContactAssingment:Contact-Block:ContactId%"},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SVContactId","level":0,"indexInParent":6,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SVContactId","lwcId":"lwc6"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"field":"ContactAssingment:ContactOptionRadioButtom","data":"createNewContact","condition":"="}],"operator":"OR"}},"pubsub":false,"message":{},"label":"SVNewContactId","elementValueMap":{"SetValuesContactId":"=%VIPCreateNewContact:ContactId%"},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SVNewContactId","level":0,"indexInParent":7,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SVNewContactId","lwcId":"lwc7"},{"type":"Remote Action","propSetMap":{"wpm":false,"validationRequired":"Step","useContinuation":false,"svgSprite":"","svgIcon":"","ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"group":{"rules":[{"field":"BillingAccount","data":null,"condition":"<>"},{"field":"Installation:ConnectDate","data":null,"condition":"<>"},{"field":"ServiceIdentifier","data":null,"condition":"<>"},{"field":"SetValuesContactId","data":null,"condition":"<>"}],"operator":"OR"}},{"field":"RecordCount","data":"10","condition":"<="}],"operator":"AND"}},"sendOnlyExtraPayload":true,"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"updateCartItemsByField","remoteClass":"B2BCmexAppHandler","redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"preTransformBundle":"","postTransformBundle":"","postMessage":"Done","message":{},"label":null,"inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","extraPayload":{"objectType":"QuoteLineItem","fieldValues":{"LineItemContact__c":"%SetValuesContactId%","vlocity_cmt__ServiceIdentifier__c":"%ServiceIdentifier%","vlocity_cmt__ConnectDate__c":"%Installation:ConnectDate%","vlocity_cmt__BillingAccountId__c":"%BillingAccount%"},"cartItemIds":"%CartItemIds%"},"errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"controlWidth":12,"conditionType":"Hide if False","businessEvent":"","businessCategory":"","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"UpdateCartItems","level":0,"indexInParent":8,"bHasAttachment":false,"bEmbed":false,"bRemoteAction":true,"JSONPath":"UpdateCartItems","lwcId":"lwc8"},{"type":"Remote Action","propSetMap":{"wpm":false,"validationRequired":"Step","useContinuation":false,"svgSprite":"","svgIcon":"","ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"group":{"rules":[{"field":"BillingAccount","data":null,"condition":"<>"},{"field":"Installation:ConnectDate","data":null,"condition":"<>"},{"field":"ServiceIdentifier","data":null,"condition":"<>"},{"field":"SetValuesContactId","data":null,"condition":"<>"}],"operator":"OR"}},{"field":"RecordCount","data":"10","condition":">"}],"operator":"AND"}},"sendOnlyExtraPayload":true,"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"updateCartItemsByFieldInBatch","remoteClass":"B2BCmexAppHandler","redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"preTransformBundle":"","postTransformBundle":"","postMessage":"Done","message":{},"label":null,"inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","extraPayload":{"objectType":"QuoteLineItem","fieldValues":{"LineItemContact__c":"%SetValuesContactId%","vlocity_cmt__ServiceIdentifier__c":"%ServiceIdentifier%","vlocity_cmt__ConnectDate__c":"%Installation:ConnectDate%","vlocity_cmt__BillingAccountId__c":"%BillingAccount%"},"cartItemIds":"%CartItemIds%"},"errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"controlWidth":12,"conditionType":"Hide if False","businessEvent":"","businessCategory":"","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"UpdateCartItemsBatch","level":0,"indexInParent":9,"bHasAttachment":false,"bEmbed":false,"bRemoteAction":true,"JSONPath":"UpdateCartItemsBatch","lwcId":"lwc9"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[true,false],"show":null,"saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":"0","previousLabel":"","nextWidth":"0","nextLabel":"","message":{},"label":"Confirmación","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":null,"cancelMessage":"Are you sure?","cancelLabel":"Cancel","businessEvent":"","businessCategory":"","allowSaveForLater":true,"HTMLTemplateId":"","uiElements":{"Success":""},"aggElements":{}},"offSet":0,"name":"Success","level":0,"indexInParent":10,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Text Block","rootIndex":10,"response":null,"propSetMap":{"textKey":"","text":"<p>Ha ocurrido un error.</p>\n<p>%VIPCreateNewContact:message%</p>","show":{"group":{"rules":[{"field":"VIPCreateNewContact:success","data":"true","condition":"<>"},{"field":"ContactAssingment:ContactOptionRadioButtom","data":"createNewContact","condition":"="}],"operator":"AND"}},"sanitize":false,"label":"TextBlock1","dataJSON":false,"controlWidth":12,"HTMLTemplateId":""},"name":"ErrText","level":1,"JSONPath":"Success:ErrText","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc100-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Text Block","rootIndex":10,"response":null,"propSetMap":{"textKey":"","text":"<p>Hemos presentado los registros para actualizarlos. Por favor, actualice la pantalla, o compruebe el Presupuesto despu&eacute;s de alg&uacute;n tiempo.</p>","show":{"group":{"rules":[{"field":"RecordCount","data":"10","condition":">"}],"operator":"AND"}},"sanitize":false,"label":"TextBlock1","dataJSON":false,"controlWidth":12,"HTMLTemplateId":""},"name":"Batch Success Message","level":1,"JSONPath":"Success:Batch Success Message","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc101-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"Success","lwcId":"lwc10"}],"bReusable":false,"bpVersion":7,"bpType":"ESM","bpSubType":"QuoteEnrichForAll","bpLang":"English","bHasAttachment":false,"lwcVarMap":{}};