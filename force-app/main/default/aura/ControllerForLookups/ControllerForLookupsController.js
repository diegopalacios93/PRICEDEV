({
    //Function to handle the sObjectLookupSelectEvent. Sets the chosen record Id and Name
    handleLookupSelectEvent : function (component,event,helper) {
        console.log("handleLookupSelectEvent - selectedRecordId: " + event.getParam("recordId") + ', selectedRecordLabel: ' + event.getParam("recordLabel"));
        component.set("v.selectedRecordLabel", event.getParam("recordLabel"));
        component.set("v.selectedRecord",JSON.parse(JSON.stringify(event.getParam("record")))); 
        component.set("v.selectedRecordId", event.getParam("recordId"));
        component.find("searchInput").showHelpMessageIfInvalid();

        /*if(component.get("v.selectedRecordId")) {
            component.set("v.readOnly", true);
            //component.set("v.type", "text");
        }*/

        helper.toggleLookupList(component,
                                false,
                                'slds-combobox-lookup',
                                'slds-is-open');
    },

    validate: function(component, event, helper) {
        if(component.get("v.required") == false) {
            return true;
        } else {
            if(component.get("v.selectedRecordId")) {
                return true;
            } else {
                var searchInput = component.find("searchInput");
                searchInput.set("v.value", null);
                searchInput.showHelpMessageIfInvalid();
                return false;
            }
        }
    },

    //Function for finding the records as for given search input
    searchRecords : function (component,event,helper) {
        /*var input = document.getElementById("input-3");
        console.log('input: ' + input);
        if(input.getAttribute("autocomplete") !== "off"){
            input.setAttribute("autocomplete", "off");
        }*/

        var searchText = component.find("searchInput").get("v.value");
        var object = component.get("v.objectAPIName");
        console.log("searchRecords - searchText: " + searchText + ', selectedRecordId: ' + component.get("v.selectedRecordId"));
        var field = component.get("v.field");
        if(object != 'AccountContactRelation' && object != 'PricebookEntry') {
            component.set("v.selectedRecordId", null);
            if(!component.get("v.selectedRecordId")) {
                
                component.set("v.readOnly", false);
                component.set("v.type", "search");
                console.log("selectedRecordId: " + component.get("v.selectedRecordId"));
                helper.searchSOSLHelper(component, searchText);
            }
        } else {
            component.set("v.selectedRecordId", null);
            component.set("v.readOnly", false);
            component.set("v.type", "search");
            helper.searchSOQLHelper(component,field,searchText);
        }
    },

    //function to hide the list on onblur event.
    hideList :function (component,event,helper) {
        //Using timeout and $A.getCallback() to avoid conflict between LookupChooseEvent and onblur
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    helper.toggleLookupList(component,
                                            false,
                                            'slds-combobox-lookup',
                                            'slds-is-open'
                                           );
                }
            }), 200
        );
    }
})