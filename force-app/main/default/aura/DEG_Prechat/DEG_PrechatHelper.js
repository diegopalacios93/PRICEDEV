/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-03-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-03-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
({
    /**
	 * Map of pre-chat field label to pre-chat field name (can be found in Setup)
	 */
//    fieldLabelToName: {
//         "Nombre": "FirstName",
//         "Apellidos": "LastName",
//         "Tipo de Documento": "DEG_Tipo_de_Documento__c",
//         "Número de Identificación":"NumerodeIdentificacion__c",
//         "Número Celular":"DEG_Numero_Celular__c",
//         "Correo electrónico": "Email",

//     },
    fieldNameToLabel: {
        "FirstName": "Nombre",
        "LastName": "Apellidos",
        "DEG_Tipo_de_Documento__c": "Tipo de Documento",
        "NumerodeIdentificacion__c": "Número de Identificación",
        "DEG_Numero_Celular__c": "Número Celular",
        "Email": "Correo electrónico",

    },
    /**
      
	 * Event which fires the function to start a chat request (by accessing the chat API component)
	 *
	 * @param cmp - The component for this state.
	 */
    onStartButtonClick: function(cmp) {
        var prechatFieldComponents = cmp.find("prechatField");
        var fields;
        var celularValidar= new RegExp("^(3){1}[0-9]{9}$");
        var documentoValidar= new RegExp("^[0-9]{4,20}$");
        var notrightemails2= new RegExp('([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})');

        // Make an array of field objects for the library
        fields = this.createFieldsArray(prechatFieldComponents);

        

        // Campos Formulario en Blanco
        fields.forEach(field => {
            if(field.value =="" || field.value== null || field.value ==" "){
                cmp.set("v.blankfieldForm",true);
            }else{
                cmp.set("v.blankfieldForm",false);
                // var outtext = cmp.find('outputTextBlankFieldForm');
                // $A.util.removeClass(outtext, 'textClass');
            }
        });

        // Validacion Nombre
        if(!fields[0].value || fields[0].value == ''){
            cmp.set("v.notName",true);
        } else {
            cmp.set("v.notName",false);
            let outtext = cmp.find('outputTextName');
            $A.util.addClass(outtext, 'textClass');
        }

        // Validacion Apellido
        if(!fields[1].value || fields[1].value == ''){
            cmp.set("v.notLastname",true);
        } else {
            cmp.set("v.notLastname",false);
            let outtext = cmp.find('outputTextLastname');
            $A.util.addClass(outtext, 'textClass');
        }

        // Validacion Tipo Documento
        if(!fields[2].value || fields[2].value == ''){
            cmp.set("v.notDocType",true);
        } else {
            cmp.set("v.notDocType",false);
            let outtext = cmp.find('outputTextTypeDoc');
            $A.util.addClass(outtext, 'textClass');
        }

        // Validacion Numero Documento
        if(!fields[3].value.match(documentoValidar)){
            cmp.set("v.notDocument",true);
        }else{
            cmp.set("v.notDocument",false);
            var outtext = cmp.find('outputTextNumDoc');
       		$A.util.removeClass(outtext, 'textClass');
        }

        //Validacion Celular
        if(!fields[4].value.match(celularValidar)){
            cmp.set("v.notMobile",true);
        }else{
            cmp.set("v.notMobile",false);
            var outtext = cmp.find('outputTextMobile');
       		$A.util.removeClass(outtext, 'textClass');
        }

        //Validacion Email
        if(!fields[5].value.match(notrightemails2)){
            cmp.set("v.notEmail",true);
        }else{
            cmp.set("v.notEmail",false);
            var outtext = cmp.find('outputTextEmail');
       		$A.util.removeClass(outtext, 'textClass');
        }

        // If the pre-chat fields pass validation, start a chat
        if(cmp.find("prechatAPI").validateFields(fields).valid) {
            let terms=cmp.get("v.termsandConditions");
            let badEmail=cmp.get("v.notEmail");
            let badMobile=cmp.get("v.notMobile");
            let badNumDoc=cmp.get("v.notDocument");
            let badName=cmp.get("v.notName");
            let badLastname=cmp.get("v.notLastname");
            let badType=cmp.get("v.notDocType");
            let blankFields=cmp.get("v.blankfieldForm");
            console.log(JSON.stringify(fields));
            if(terms=='true'&&badEmail==false&&badMobile==false&&blankFields==false&&badNumDoc==false&&badName==false&&badLastname==false&&badType==false){
            	cmp.find("prechatAPI").startChat(fields);
            }
            else if(badName==true){
                let outtext = cmp.find('outputTextName');
                $A.util.addClass(outtext, 'textClass');
            }
            else if(badLastname==true){
                let outtext = cmp.find('outputTextLastname');
                $A.util.addClass(outtext, 'textClass');
            }
            else if(badType==true){
                let outtext = cmp.find('outputTextTypeDoc');
                $A.util.addClass(outtext, 'textClass');
            }
            else if(badNumDoc==true){
                let outtext = cmp.find('outputTextNumDoc');
                $A.util.addClass(outtext, 'textClass');
            }
            // else if(blankFields==true){
            //     var outtext = cmp.find('outputTextBlankFieldForm');
            //        $A.util.addClass(outtext, 'textClass');
            // }
            else if(badMobile==true){
                let outtext = cmp.find('outputTextMobile');
                $A.util.addClass(outtext, 'textClass');
            }
            else if(badEmail==true){
                let outtext = cmp.find('outputTextEmail');
       			$A.util.addClass(outtext, 'textClass');
            	}else{
                cmp.set("v.notCheckboxes",true); 
                let outtext = cmp.find('outputTextId');
       			$A.util.addClass(outtext, 'textClass');
            }
        } else {
            console.warn("Prechat fields did not pass validation!");
        }
    },

    /**
	 *
	 * @param cmp - The component for this state.
	 */
    getDocumentList: function(cmp) {
        var action = cmp.get('c.getPicklistsValue');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.typePickList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    /**
	 * Create an array of field objects to start a chat from an array of pre-chat fields
	 * 
	 * @param fields - Array of pre-chat field Objects.
	 * @returns An array of field objects.
	 */
    createFieldsArray: function(fields) {
        if(fields.length) {
            return fields.map(function(fieldCmp) {
                return {
                    name: fieldCmp.get("v.name"),
                    label: this.fieldNameToLabel[fieldCmp.get("v.name")],
                    value: fieldCmp.get("v.value"),
                };
            }.bind(this));
        } else {
            return [];
        }
    },
    
    /**
     * Create an array in the format $A.createComponents expects
     * 
     * Example:
     * [["componentType", {attributeName: "attributeValue", ...}]]
     * 
	 * @param prechatFields - Array of pre-chat field Objects.
	 * @returns Array that can be passed to $A.createComponents
     */
    getPrechatFieldAttributesArray: function(prechatFields) {
        // $A.createComponents first parameter is an array of arrays. Each array contains the type of component being created, and an Object defining the attributes.
        var prechatFieldsInfoArray = [];
        // For each field, prepare the type and attributes to pass to $A.createComponents
        prechatFields.forEach(function(field) {
            var componentName = (field.type === "inputSplitName") ? "inputText" : field.type;
            var componentInfoArray = ["ui:" + componentName];
            var attributes = {
                "aura:id": "prechatField",
                required: field.required,
                placeholder: field.label,
                disabled: field.readOnly,
                maxlength: field.maxLength,
                class: field.className,
                value: field.value
            };
            // Special handling for options for an input:select (picklist) component
            if(field.type === "inputSelect" && field.picklistOptions) attributes.options = field.picklistOptions;
            
            // Append the attributes Object containing the required attributes to render this pre-chat field
            componentInfoArray.push(attributes);
            
            // Append this componentInfoArray to the fieldAttributesArray
            prechatFieldsInfoArray.push(componentInfoArray);
        });
        
        return prechatFieldsInfoArray;
    },
    getLiveChatLinkWrapperhelper: function (component, buttonId) {
        //call apex class method
        var action = component.get('c.getHyperLinksDetail');
        action.setParams({
            currentIdDeployment: buttonId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.liveChatLinksWrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
});