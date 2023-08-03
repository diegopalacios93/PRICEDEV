({
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component  
        helper.closeModal(component,event);
    },
    handleSubmit : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        fields.Identificador_Oferta_OP__c = component.get("v.idoferta");
        fields.Actividad__c = 'Entrega Soportes por Preventa';
        fields.Estado_Actividad__c = 'Pendiente';
        component.find('createForm').submit(fields);
        
    },
    handleSuccess : function(component, event, helper) {
 		var record = event.getParam("response");
        var myRecordId = record.id;
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: myRecordId,
            slideDevName: "detail"
        });
        navEvent.fire();
    },
    init : function(component, event, helper) {

        var action = component.get("c.getAccountId");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
                
        action.setCallback(this, function(response){
            if(response.getReturnValue() != null){
                component.set("v.accId", response.getReturnValue());
            }
        })
                
        $A.enqueueAction(action);
   }
})