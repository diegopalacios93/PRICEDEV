({
    mytimer: null,
    cleanUp: false,
    settimer : function (component, helper){
        cleanUp = false;
        mytimer = window.setInterval(
            $A.getCallback(function() {
               helper.translate();
            }),
            1000
        );
    },
    translate : function(component, helper) {
        var x = document.getElementsByClassName('slds-chat-message__text');
        
        for ( i = 0 ; i < x.length ; i++){
            var translated = '';
            var response = '';
            var mensajes = x[i].getElementsByTagName('span');
            for ( j = 0 ; j < mensajes.length ; j++){
                response = response + mensajes[j].innerText;
            }
            
            if( response.includes('{')){
                cleanUp = true;
                translated = '';
            }
            else{
                translated = response;
            }
            x[i].getElementsByTagName('span')[0].innerText = translated;
            if( x[i].getElementsByTagName('span')[1] != null ) x[i].getElementsByTagName('span')[1].innerText ='';
            if( x[i].getElementsByTagName('A')[0] != null ) x[i].getElementsByTagName('A')[0].innerText ='';
            
        }
        if (cleanUp){
            window.clearInterval(mytimer);
        }
    }
})