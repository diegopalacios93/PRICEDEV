({
    
    handleOnSuccess : function(cmp, event, helper) {
        helper.showToast("Contacto creado exitosamente","success");
        helper.closeQA();
    },
    handleOnError : function(cmp, event, helper) {
        helper.showToast(event.getParam("message"),"error");
    },
    
})