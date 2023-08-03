({
    doInit: function(component, event, helper) {
      
        var id = component.get("v.recordId");
        var action = component.get("c.DescargarArchivo");
        action.setParams({ varId : id });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var jsonOBJ = response.getReturnValue()
                component.set("v.MapDataCMP", jsonOBJ);
                //alert("Descarga desde URL: " + component.get("v.MapDataCMP.URL"));
                component.set("v.action", component.get("v.MapDataCMP.accion"));
                component.set("v.idA", component.get("v.MapDataCMP.idA"));
                component.set("v.idS", component.get("v.MapDataCMP.idS"));
                component.set("v.tS", component.get("v.MapDataCMP.tS"));
                component.set("v.t_1", component.get("v.MapDataCMP.t"));
                if (component.get("v.t_1") == ''){
                	alert("URL Incorrecta, Falta parametro 't'");
                    $A.get("e.force:closeQuickAction").fire();
                }
                if (component.get("v.tS") == ''){
                	alert("URL Incorrecta, Falta parametro 'tS'");
                    $A.get("e.force:closeQuickAction").fire();
                }
                if (component.get("v.idS") == ''){
                	alert("URL Incorrecta, Falta parametro 'idS'");
                    $A.get("e.force:closeQuickAction").fire();
                }
                if (component.get("v.idA") == ''){
                	alert("URL Incorrecta, Falta parametro 'idA'");
                    $A.get("e.force:closeQuickAction").fire();
                }
                if (component.get("v.action") == ''){
                	alert("URL Incorrecta, Falta parametro 'action'");
                    $A.get("e.force:closeQuickAction").fire();
                }
					
            }
            else if (state === "INCOMPLETE") {
                alert("Petición incompleta desde el servidor");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    handleClick: function (component, event, helper) { 
 
            component.find("GetFileForm").getElement().submit();
        	$A.get("e.force:closeQuickAction").fire();
  
    }
    
})