({
    doInit: function(component, event, helper) {        
        helper.getMotivoPicklist(component, event);
    },
     
    handleOfferSave : function(component, event, helper) {
        helper.saveOffer(component, event);
    }

})