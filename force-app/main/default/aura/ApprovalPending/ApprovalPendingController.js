({
    init : function(component, event, helper) {
        var action = component.get("c.WrapList");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.wp", resp);
                
                
            }
        });
        $A.enqueueAction(action);
	}
})