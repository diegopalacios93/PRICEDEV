let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"DataRaptor","value":{"bundle":"etb_GetAccountInfo","dsDelay":0,"inputMap":{"AccountId":"{recordId}"},"resultVar":""}},"enableLwc":true,"isFlex":true,"lwc":{"DeveloperName":"cfEtb_ShowErrorIfRestriction_1_ETB","Id":"0Rb780000008SibCAE","ManageableState":"unmanaged","MasterLabel":"cfEtb_ShowErrorIfRestriction_1_ETB","NamespacePrefix":"c"},"selectableMode":"Multi","states":[{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"children":[{"class":"slds-col ","element":"flexIcon","elementLabel":"Block-0-Icon-0","key":"element_element_block_0_0_flexIcon_0_0","name":"Icon","parentElementKey":"element_block_0_0","property":{"card":"{card}","color":"#C23934","extraclass":"slds-icon_container slds-icon__svg--default ","iconName":"utility:error","iconType":"Salesforce SVG","imgsrc":"","record":"{record}","size":"small","variant":"error"},"size":{"default":"1","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_center slds-m-top_x-small ","container":{"class":""},"elementStyleProperties":{"color":"#C23934"},"inlineStyle":"","margin":[{"label":"top:x-small","size":"x-small","type":"top"}],"maxHeight":"42pt","minHeight":"","padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"     : #ccc 1px solid; \n       max-height:42pt;  ","text":{"align":"center","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_center slds-m-top_x-small ","container":{"class":""},"elementStyleProperties":{"color":"#C23934"},"inlineStyle":"","margin":[{"label":"top:x-small","size":"x-small","type":"top"}],"maxHeight":"42pt","minHeight":"","padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"     : #ccc 1px solid; \n       max-height:42pt;  ","text":{"align":"center","color":""}}}],"type":"element"},{"class":"slds-col ","element":"outputField","elementLabel":"Block-0-Text-1","key":"element_element_block_0_0_outputField_1_0","name":"Text","parentElementKey":"element_block_0_0","property":{"card":"{card}","mergeField":"%3Cdiv%3EEste%20cliente%20no%20es%20elegible%20para%20la%20venta%20en%20este%20momento.%3C/div%3E","record":"{record}"},"size":{"default":"11","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_left ","container":{"class":""},"elementStyleProperties":{},"height":"","inlineStyle":"color: #514F4D;\nfont-size: 13px;\nletter-spacing: 0;\nmargin-top: 7pt;\n","margin":[],"maxHeight":"42pt","minHeight":"","padding":[],"size":{"default":"11","isResponsive":false},"sizeClass":"slds-size_11-of-12 ","style":"     : #ccc 1px solid; \n       max-height:42pt;  color: #514F4D;\nfont-size: 13px;\nletter-spacing: 0;\nmargin-top: 7pt;\n","text":{"align":"left","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_left ","container":{"class":""},"elementStyleProperties":{},"height":"","inlineStyle":"color: #514F4D;\nfont-size: 13px;\nletter-spacing: 0;\nmargin-top: 7pt;\n","margin":[],"maxHeight":"42pt","minHeight":"","padding":[],"size":{"default":"11","isResponsive":false},"sizeClass":"slds-size_11-of-12 ","style":"     : #ccc 1px solid; \n       max-height:42pt;  color: #514F4D;\nfont-size: 13px;\nletter-spacing: 0;\nmargin-top: 7pt;\n","text":{"align":"left","color":""}}}],"type":"text"}],"class":"slds-col ","element":"block","elementLabel":"Block-0","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"data-conditions":{"group":[{"field":"CausalRestriccionVenta","id":"state-new-condition-3","operator":"==","type":"custom","value":"true"}],"id":"state-condition-object","isParent":true},"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#F5E2E2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"3px","style":"","type":"","width":""},"class":"slds-p-around_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"minHeight":"42pt","padding":[{"label":"around:x-small","size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F5E2E2;     : #cccccc 1px solid; \n    border-radius:3px;  min-height:42pt;   ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"#F5E2E2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"3px","style":"","type":"","width":""},"class":"slds-p-around_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"minHeight":"42pt","padding":[{"label":"around:x-small","size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F5E2E2;     : #cccccc 1px solid; \n    border-radius:3px;  min-height:42pt;   ","text":{"align":"","color":""}}}],"type":"block"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-card ","container":{"class":"slds-card"},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}}}],"theme":"slds","title":"etb_ShowErrorIfRestriction","Id":"a987j000000GmwyAAC","vlocity_cmt__GlobalKey__c":"etb_ShowErrorIfRestriction/ETB/1/1641309238688"};
  export default definition