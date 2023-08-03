({
    getMotivoPicklist: function(component, event) {
        var action = component.get("c.getMotivo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var motivoMap = [];
                for(var key in result){
                    motivoMap.push({key: key, value: result[key]});
                }
                component.set("v.motivoMap", motivoMap);
            }
        });
        $A.enqueueAction(action);
    },
     
    saveOffer : function(component, event) {

        var off = component.get("v.oferta");
        var offId = component.get("v.recordId");
        var action = component.get("c.createOffer");

        action.setParams({
            objOferta : off,
            offerId : offId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
                var navEvent = $A.get("e.force:navigateToSObject");
                navEvent.setParams({
                    recordId: response.getReturnValue(),
                    slideDevName: "detail"
                });
                navEvent.fire(); 

            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });       
        
        $A.enqueueAction(action);
    }
})