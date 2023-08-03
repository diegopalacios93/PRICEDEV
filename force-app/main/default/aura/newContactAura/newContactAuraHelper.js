({
    showToast: function(text, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
			duration: type == 'success' ? '5000': '20000',
            type: type,
            message: text,
        });
        toastEvent.fire();
    },
    closeQA : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})