({
    /**
     * On initialization of this component, set the prechatFields attribute and render pre-chat fields.
     * 
     * @param cmp - The component for this state.
     * @param evt - The Aura event.
     * @param hlp - The helper for this state.
     */


    
     onCheckpData: function(cmp, evt) {
		 var checkCmp = cmp.find("pData");
		 cmp.set("v.personalData", ""+checkCmp.get("v.value"));

	 },
     onCheckTerms: function(cmp, evt) {
		 var checkCmp = cmp.find("terms");
		 cmp.set("v.termsandConditions", ""+checkCmp.get("v.value"));
	 },

     handleChange: function(cmp, evt){
        let fieldName = evt.getSource().get("v.name");
        let key = evt.which;
        if(fieldName == 'FirstName') cmp.set("v.notName",false);
        else if(fieldName == 'LastName') cmp.set("v.notLastname",false);
        else if(fieldName == 'DEG_Tipo_de_Documento__c') cmp.set("v.notDocType",false);
        else if(fieldName == 'NumerodeIdentificacion__c') {
            cmp.set("v.notDocument",false);
            if (key != 8 && key != 0 && key < 48 || key > 57){
                evt.preventDefault();
            }
        }
        else if(fieldName == 'DEG_Numero_Celular__c') {
            cmp.set("v.notMobile",false);
            if (key != 8 && key != 0 && key < 48 || key > 57){
                evt.preventDefault();
            }
        }
        else if(fieldName == 'Email') cmp.set("v.notEmail",false);
     },

     
	onInit: function(cmp, evt, hlp) {


        hlp.getDocumentList(cmp);
        // Get pre-chat fields defined in setup using the prechatAPI component

     //   var buttonId = cmp.find("settingsAPI").getLiveAgentSettings().liveAgentButtonId;
    //    console.log('buttonId ',buttonId);
		//console.log('getLiveAgentSettings() ', cmp.find("settingsAPI").getLiveAgentSettings().liveAgentDeploymentId);
        var buttonId = cmp.find("settingsAPI").getLiveAgentSettings().liveAgentDeploymentId;
        hlp.getLiveChatLinkWrapperhelper(cmp, buttonId);
        
		var prechatFields = cmp.find("prechatAPI").getPrechatFields(); 
        // Get pre-chat field types and attributes to be rendered
        if(prechatFields[0].value!==undefined){
            cmp.set("v.showCheckboxes",false);
            cmp.set("v.personalData","true");
            cmp.set("v.termsandConditions","true");
        }

        



        // var prechatFieldComponentsArray = hlp.getPrechatFieldAttributesArray(prechatFields);
        
        // personalData asynchronous Aura call to create pre-chat field components
        // $A.createComponents(
        //     prechatFieldComponentsArray, 
        //     function(components, status, errorMessage) {
        //         if(status === "SUCCESS") {
        //             cmp.set("v.prechatFieldComponents", components);
        //         }
        //     }
        // );
    },
     
    /**
     * Event which fires when start button is clicked in pre-chat
     * 
     * @param cmp - The component for this state.
     * @param evt - The Aura event.
     * @param hlp - The helper for this state.
     */
    handleStartButtonClick: function(cmp, evt, hlp) {
        hlp.onStartButtonClick(cmp);
    }
});