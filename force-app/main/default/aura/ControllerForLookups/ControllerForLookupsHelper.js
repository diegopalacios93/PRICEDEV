({
    //Function to toggle the record list drop-down
    toggleLookupList : function (component, ariaexpanded, classadd, classremove) {
        component.find("lookupdiv").set("v.aria-expanded", true);
        $A.util.addClass(component.find("lookupdiv"), classadd);
        $A.util.removeClass(component.find("lookupdiv"), classremove);
    },

    //function to call SOSL apex method.
    searchSOSLHelper : function (component,searchText) {
        //console.log("searchSOSLHelper - searchText: " + searchText);

        //validate the input length. Must be greater then 3.
        //This check also manages the SOSL exception. Search text must be greater then 2.
        if(searchText && searchText.length > 2) {
            //show the loading icon for search input field
            component.find("searchInput").set("v.isLoading", true);

            //server side callout. returns the list of record in JSON string
            var action = component.get("c.search");
            action.setStorable();
            action.setParams({
                "objectAPIName": component.get("v.objectAPIName"),
                "searchText": searchText,
                "whereClause": component.get("v.filter"),
                "extrafields": component.get("v.subHeadingFieldsAPI")
            });

            action.setCallback(this, function(a) {
                var state = a.getState();

                if(component.isValid() && state === "SUCCESS") {
                    //parsing JSON return to Object[]
                    var result = [].concat.apply([], JSON.parse(a.getReturnValue()));
                    component.set("v.matchingRecords", result);
                    //console.log("matchingRecords: ", result);

                    //Visible the list if record list has values
                    if(a.getReturnValue() && a.getReturnValue().length > 0) {
                        this.toggleLookupList(component,
                                              true,
                                              'slds-is-open',
                                              'slds-combobox-lookup');

                        //hide the loading icon for search input field
                        component.find("searchInput").set("v.isLoading", false);
                    } else {
                        this.toggleLookupList(component,
                                              false,
                                              'slds-combobox-lookup',
                                              'slds-is-open');
                    }
                } else if(state === "ERROR") {
                    console.log('error in searchRecords');
                }
            });
            $A.enqueueAction(action);
        } else {
            //hide the drop down list if input length less then 3
            this.toggleLookupList(component,
                                  false,
                                  'slds-combobox-lookup',
                                  'slds-is-open');
        }
    },

    //function to call SOQL apex method.
    searchSOQLHelper : function (component,field,searchText) {
        //console.log("searchSOQLHelper - busca registros recientes");
        if(searchText && searchText.length > 2) {
        component.find("searchInput").set("v.isLoading", true);
        var selectedIds = component.get("v.selectedIds");
        var action = component.get("c.getRecentlyViewed");
        action.setStorable();
        action.setParams({
            "objectAPIName" : component.get("v.objectAPIName"),
            "selectedIds" : selectedIds,
            "whereClause" : component.get("v.filter"),
            "searchText": searchText,
            "field" : field,
            "extrafields" : component.get("v.subHeadingFieldsAPI")
        });

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.matchingRecords", response.getReturnValue());
                    //console.log("matchingRecords: " + component.get("v.matchingRecords"));

                    if(response.getReturnValue().length > 0) {
                        this.toggleLookupList(component,
                                              true,
                                              'slds-is-open',
                                              'slds-combobox-lookup');
                    } else {
                        //hide the drop down list if no results
                        this.toggleLookupList(component,
                                              false,
                                              'slds-combobox-lookup',
                                              'slds-is-open');
                    }
                    component.find("searchInput").set("v.isLoading", false);
                }
            } else {
                console.log('Error in getRecentlyViewed: ' + state);
            }
        });
        $A.enqueueAction(action);
    } else {
        //hide the drop down list if input length less then 3
        this.toggleLookupList(component,
                              false,
                              'slds-combobox-lookup',
                              'slds-is-open');
    }
    }
})