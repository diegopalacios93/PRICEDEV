export const OMNIDEF = {"userTimeZone":-180,"userProfile":"System Administrator","userName":"devops@etb.com.co.siteetb","userId":"0050r000002KhsQAAS","userCurrencyCode":"COP","timeStamp":"2022-07-28T13:47:27.916Z","sOmniScriptId":"a6c7j000000GpeXAAS","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"wpm":false,"visualforcePagesAvailableInPreview":{},"trackingCustomData":{},"timeTracking":false,"stylesheet":{"newportRtl":"","newport":"etb_removeStepBar","lightningRtl":"","lightning":"etb_removeStepBar"},"stepChartPlacement":"right","ssm":false,"showInputWidth":false,"seedDataJSON":{},"scrollBehavior":"auto","saveURLPatterns":{},"saveObjectId":"%ContextId%","saveNameTemplate":null,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveContentEncoded":false,"rtpSeed":false,"pubsub":false,"persistentComponent":[{"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl"},"label":"","itemsKey":"cartItems","id":"vlcCart"},{"render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"","modalController":""},"label":"","itemsKey":"knowledgeItems","id":"vlcKnowledge","dispOutsideOmni":false}],"message":{},"mergeSavedData":false,"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"hideStepChart":true,"errorMessage":{"custom":[]},"enableKnowledge":false,"elementTypeToHTMLTemplateMapping":{},"disableUnloadWarn":true,"designTokenOverride":"","currentLanguage":"en_US","currencyCode":"","consoleTabTitle":null,"consoleTabLabel":"New","consoleTabIcon":"custom:custom18","cancelType":"SObject","cancelSource":"%ContextId%","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","bLK":false,"autoSaveOnStepNext":false,"autoFocus":false,"allowSaveForLater":true,"allowCancel":true},"prefillJSON":"{}","lwcId":"b13e0495-5482-9bac-fc74-8a1baaa693c3","labelMap":{"ShowProcessFailInformation":"failStatusStep:ShowProcessFailInformation","ShowProcessInformation":"currentStatusStep:ShowProcessInformation","failStatusStep":"failStatusStep","currentStatusStep":"currentStatusStep","SetValuesMsgInfo":"SetValuesMsgInfo","SVBottonMessage":"SVBottonMessage","SetValuesMiddleMessage":"SetValuesMiddleMessage","IPGetMessage":"IPGetMessage"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"Integration Procedure Action","propSetMap":{"wpm":false,"validationRequired":"Step","useContinuation":false,"svgSprite":"","svgIcon":"","ssm":false,"showPersistentComponent":[false,false],"show":null,"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"IPGetMessage","remoteTimeout":30000,"remoteOptions":{"useFuture":false,"preTransformBundle":"","postTransformBundle":"","chainable":false},"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"preTransformBundle":"","postTransformBundle":"","postMessage":"Done","message":{},"label":"IPGetMessage","integrationProcedureKey":"etb_GetMessages","inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","extraPayload":{"orderNumber":"%orderNumber%","codeMessage":"%topMessage%","ContextId":"%targetIdCustom%"},"errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"IPGetMessage","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bIntegrationProcedureAction":true,"JSONPath":"IPGetMessage","lwcId":"lwc0"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":null,"pubsub":false,"message":{},"label":"SetValueMiddleMessage","elementValueMap":{"TransactionMessage":"=IF(%MiddleMessage%, \"Nro. de transacción: %MiddleMessage%\")"},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetValuesMiddleMessage","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SetValuesMiddleMessage","lwcId":"lwc1"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[true,false],"show":null,"pubsub":false,"message":{},"label":"SVBottonMessage","elementValueMap":{"bottomMessage":"=IF(%IPGetMessage:message:TitleMessage%, %IPGetMessage:message:TitleMessage%, %bottomMessage%)"},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SVBottonMessage","level":0,"indexInParent":2,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SVBottonMessage","lwcId":"lwc2"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[true,false],"show":null,"pubsub":false,"message":{},"label":"SetValuesMsgInfo","elementValueMap":{"message":{"TopMessage":"%IPGetMessage:message:MainMessage%","TabToNav":"%tabToNav%","SecondButton":"%secondButton%","OrderNumber":"%OrderNumber%","ObjectRedirect":"%sObjectRedirect%","Object":"%sObject%","MiddleMessage":"%TransactionMessage%","LabelSecondButton":"%labelSecondButton%","LabelFirstButton":"%labelFirstButton%","ErrorOs":"%errorOs%","Button":{"URL":"%targetIdCustom%"},"BottomMessage":"%bottomMessage%","Action":"%IPGetMessage:message:Action%"}},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetValuesMsgInfo","level":0,"indexInParent":3,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SetValuesMsgInfo","lwcId":"lwc3"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"message:ErrorOs","data":"true","condition":"<>"}],"operator":"AND"}},"saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":0,"previousLabel":"","nextWidth":0,"nextLabel":"","message":{},"label":"¡Listo!","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"disOnTplt":false,"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":"","cancelMessage":"Are you sure?","cancelLabel":"Cancel","allowSaveForLater":false,"HTMLTemplateId":"","uiElements":{"currentStatusStep":""},"aggElements":{"ShowProcessInformation":""}},"offSet":0,"name":"currentStatusStep","level":0,"indexInParent":4,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":4,"response":null,"propSetMap":{"show":null,"lwcName":"etb_EndProcessMessage","label":"Current Status","hide":false,"disOnTplt":false,"customAttributes":[{"source":"%message%","name":"message"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"ShowProcessInformation","level":1,"JSONPath":"currentStatusStep:ShowProcessInformation","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent1":true,"lwcId":"lwc40-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"currentStatusStep","lwcId":"lwc4"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"message:ErrorOs","data":"true","condition":"="}],"operator":"AND"}},"saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":0,"previousLabel":"","nextWidth":0,"nextLabel":"","message":{},"label":"¡Error!","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"disOnTplt":false,"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":"","cancelMessage":"Are you sure?","cancelLabel":"Cancel","allowSaveForLater":false,"HTMLTemplateId":"","uiElements":{"failStatusStep":""},"aggElements":{"ShowProcessFailInformation":""}},"offSet":0,"name":"failStatusStep","level":0,"indexInParent":5,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":5,"response":null,"propSetMap":{"show":null,"lwcName":"etb_EndProcessMessage","label":"ShowProcessFailInformation","hide":false,"disOnTplt":false,"customAttributes":[{"source":"%message%","name":"message"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"ShowProcessFailInformation","level":1,"JSONPath":"failStatusStep:ShowProcessFailInformation","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent2":true,"lwcId":"lwc50-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"failStatusStep","lwcId":"lwc5"}],"bReusable":true,"bpVersion":5,"bpType":"etb","bpSubType":"endProcessInfo","bpLang":"English","bHasAttachment":false,"lwcVarMap":{"message":null}};