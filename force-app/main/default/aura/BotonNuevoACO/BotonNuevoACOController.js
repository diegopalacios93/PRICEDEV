({
    handleShowModal: function(component, evt, helper) {
        var modalBody;
        var recId= component.get('v.recordId');
        $A.createComponent("c:nuevoACO", {recordId:recId},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Nuevo ACO",
                       body: modalBody, 
                       showCloseButton: true,
                       /*closeCallback: function() {
                           alert('You closed the modal!');
                       }*/
                   })
               }                               
           });
    },
})