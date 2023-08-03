({
        handleClick: function (component, event, helper) { 
            var id = component.get("v.recordId"); 
            var action = component.get('c.ActualizarEstadosOC');
            
            action.setParams({ varId : id });
            action.setCallback(this, function(response) {
                var state = response.getState();
	            if (state === "SUCCESS") {
 	               alert("From server: " + response.getReturnValue());
                   var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
			       dismissActionPanel.fire(); 
    	        }
    	        else if (state === "INCOMPLETE") {
                    
  	             	var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
			     	dismissActionPanel.fire();
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                            console.log("Error message: " + errors[0].message);
                            var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
			       			dismissActionPanel.fire();
                        }
                    } else {
                        console.log("Unknown error");
                        var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
			       		dismissActionPanel.fire();
                    }
            	}
            });
    
            $A.enqueueAction(action);            
    
    } 

   
})