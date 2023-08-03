({
    afterScriptsLoaded: function(component,event,helper){
        //console.log('Entra funcion js');
        var os = platform.os;
        var version = platform.version;
        var description = platform.description;
        var layout = platform.layout;
        var manufacturer = platform.manufacturer;
        var name = platform.name;
        var product = platform.product;
        component.set('v.Name',name); 
        component.set('v.Version',version); 
        component.set('v.Layout',layout);
        component.set('v.OS',os);
        component.set('v.Description',description);
        component.set('v.Manufacturer',manufacturer);
        component.set('v.Product',product);
        
        /*console.log('os:',os);
        console.log('version',version);
        console.log('descripción',description);
        console.log('layout',layout);
        console.log('manofactura',manufacturer);
        console.log('nombre',name);
        console.log('producto',product);
        console.log('dispositivo:', component.get('v.Device'));*/
        
    },
    handleLikeButtonClick : function (component) {
        component.set('v.liked', true);
        component.set('v.disliked', false);
        component.set('v.newHistorialArt.Calificaci_n__c','Like');
        component.set('v.newHistorialArt.Articulo_de_base_de_conocimiento__c',component.get("v.recordId"));
    },
    handleDisLikeButtonClick : function (component) {
        component.set('v.liked', false);
        component.set('v.disliked', true);
        component.set('v.newHistorialArt.Calificaci_n__c','Dislike');
        component.set('v.newHistorialArt.Articulo_de_base_de_conocimiento__c',component.get("v.recordId"));
    },
    handlesendcomments: function(component,event,helper){
        console.log('handlesendcomments function');
        var email = component.get("v.newHistorialArt.Correo_Electronico__c");
        var Coments = component.get("v.newHistorialArt.Comentario__c");
        //console.log(email);
        //console.log(Coments);
        
        if((email==null || email=="" || email==undefined) || (Coments==null || Coments=="" || Coments==undefined)){
            //console.log("valores nulos  :( ");
            component.set("v.showError",true);
            component.set("v.errorMessage",'Asegurate de llenar los campos obligatorios');
        }else{
            component.set("v.showError",false);
            component.set("v.errorMessage",'');
            var action = component.get("c.CreaRegistro");
            action.setParams({ 
                SObj : component.get("v.newHistorialArt"),
                vnav : component.get("v.Version"),
                dnav : component.get("v.Description"),
                nnav : component.get("v.Name"),
                disp : component.get("v.Device")
                
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    //console.log('Comentarios enviados');
                    component.set("v.showForm",false);
                    component.set("v.disabledThumb",true);
                }
            });
        }
        
        $A.enqueueAction(action);
    }
})