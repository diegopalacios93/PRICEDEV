({
    loadValues : function (component) {
        var record = component.get("v.record");
        var subheading = '';
        for(var i=0; i<component.get("v.subHeadingFieldsAPI").length ;i++ ){
            if(record[component.get("v.subHeadingFieldsAPI")[i]]){
                subheading = subheading + record[component.get("v.subHeadingFieldsAPI")[i]] + ' • ';
            }
        }
        subheading = subheading.substring(0,subheading.lastIndexOf('•'));
        component.set("v.subHeadingFieldValues", subheading);
    },

    choose : function (component,event) {
        var chooseEvent = component.getEvent("lookupSelect");
        //console.log("chooseEvent---->>>" + JSON.stringify(component.getEvent("lookupSelect")));
        var name = component.get("v.record.Name");
        if( name != '' && name != null){
            chooseEvent.setParams({
                "recordId" : component.get("v.record").Id,
                "recordLabel":component.get("v.record").Name,
                "record" : component.get("v.record")
            });
        }else{
            chooseEvent.setParams({
                "recordId" : component.get("v.record").ContactId,
                "recordLabel":component.get("v.record").Contact.Name,
                "record" : component.get("v.record")
            });
        }
        chooseEvent.fire();
        //console.log('event fired');
    }
})