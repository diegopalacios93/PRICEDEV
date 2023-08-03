/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 04-05-2022
 * @last modified by  : j.martinez.mercado
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   03-23-2021   Harlinsson Chavarro (HCH)   Initial Version
 **/
 import { LightningElement, api, track, wire } from "lwc";
 import { NavigationMixin } from "lightning/navigation";
 import { CurrentPageReference } from "lightning/navigation";
 import lwcChatPackLibrary from '@salesforce/resourceUrl/LwcChatPack';
 import { loadScript } from "lightning/platformResourceLoader";
 
 const ua = navigator.userAgent;
 export default class Lwcchatpack_url extends NavigationMixin(LightningElement) {
   @api inputParams;
   @track recordPageUrl;
   @wire(CurrentPageReference)
   pageRef;
   @api idEvent = "";
   @api idUrl = "";
   @api styles1 = "";
   @api styles2 = "";
 
   isMobile = (/(tablet|ipad|playbook|silk)|(android(?!.*mobi))/i.test(ua) || /Mobile|Android|iP(hone|od)|IEMobile|BlackBerry|Kindle|Silk-Accelerated|(hpw|web)OS|Opera M(obi|ini)/.test(ua));
   isRendered = true;
   getStyle(vId){
       var styleObj = {
           cobertura:  this.isMobile ?{
             main:"box-shadow: -9px 4px 9px #3e3e3e94; border-radius: 10px; z-index: 5001; background: white; position: absolute; bottom: 0px; right: 0px; width: var(--lwc-sidebarWidth, 100%); height: 90%; max-height: min-content; overflow-y: hidden; padding: 0;",
             inside:"padding: 0px; height:100%; overflow:hidden"
           }:{
             main:"box-shadow: -9px 4px 9px #3e3e3e94; border-radius: 10px; z-index: 5001; background: white; position: absolute; bottom: 0px; right: 0px; width: 60%; height: var(--lwc-sidebarHeight, 100%); inset: 19% 0px 0px 9%; max-height: min-content; overflow-y: hidden; padding: 0;",
             inside:"padding: 0px; height:100%; overflow:hidden"
           },
           default: this.isMobile ?{
             main:"box-shadow: -9px 4px 9px #3e3e3e94; border-radius: 10px; z-index: 5001; background: white; position: absolute; bottom: 0px; right: 0px; height: 90%; width: var(--lwc-sidebarWidth, 100%); max-height: min-content; padding: 0; overflow-y: hidden;",
             inside:"padding: 0px; height:100%; overflow:hidden"
           }:{
             main:"box-shadow: -9px 4px 9px #3e3e3e94; border-radius: 10px; z-index: 5001; background: white; position: absolute; bottom: 0px; right: 0px; height: var(--lwc-sidebarHeight, 100%); width: var(--lwc-sidebarWidth, 100%); max-height: min-content; inset: 19.5% 0px 0px 45%; padding: 0; overflow-y: hidden;",
             inside:"padding: 0px; height:100%; overflow:hidden"
           }
       };
       return (vId == 'cobertura') ? styleObj.cobertura : styleObj.default;
   }
 
   connectedCallback() {
     Promise.all([
       loadScript(this, lwcChatPackLibrary + "/jquery-3.6.0.min.js")
     ])
       .then(() => {
         Promise.all([
           loadScript(this, lwcChatPackLibrary + "/opensidetab.js")
         ])
           .then(() => {
             window.opensidetab(this.returnUrl());
             Promise.all(
               [
                 loadScript(this, lwcChatPackLibrary + '/moveDiv.js')
               ]
             ).then(() => {
               console.log('Script Cargado...');
             }).catch((error) => {
               console.log('Error cargando moveDiv.js');
               throw error;
             });
           })
           .catch((error) => {
             throw error;
           });
       })
       .catch((error) => {
         throw error;
       });
     
       console.log('Params');
       console.log(this.inputParams[0].idEvent);
       console.log(this.inputParams[0].urlEvent);
       console.log('End Params');
     this.idEvent = this.inputParams[0].idEvent;
     this.urlEvent = this.inputParams[0].urlEvent;
 
     let vStyle = this.getStyle(this.idEvent);
 
     this.styles1 = vStyle.main;
     this.styles2 = vStyle.inside;
 
    this.bindEvent(window,'message',function (e) {
       if(e.data == 'closeModal'){
         console.log('Cerrando...');
         window.closesidetab('sectionId');
         document.getElementById('sectionId').style.display = 'none';
         document.getElementById('sectionId').style.zIndex = 4999;
         document.getElementById('sectionId').remove();
       }
    })
 
   }
 
   renderedCallback(){
     if ('virtualKeyboard' in navigator) {
       navigator.virtualKeyboard.overlaysContent = true;
     }
   }
 
   navigateToRecordViewPage(theId) {
     // View a custom object record.
     this[NavigationMixin.Navigate]({
       type: "standard__recordPage",
       attributes: {
         recordId: theId,
         actionName: "view"
       }
     });
   }
 
   returnUrl() {
     return ( 
       `
       <div id='section' data-id='sectionId' class="iframe-container" style='${this.styles1}'>
       <div id='sectionheader' class='iframe-container-header' 
       style=' padding: 0.5rem;
               cursor: move;
               background-color: #2196F3;
               border-radius: 10px 10px 0px 0px;
               color: #fff;
               z-index: 5002;
               position: sticky;
               text-align: center;'>Mantega pulsado para mover</div>
         <iframe style='overflow:hidden; width: 100%; height: 100%;' data-id='iframeId' class='responsive-iframe' src='${this.urlEvent}'"></iframe>
       </div>
       `
     );
   }
 
   bindEvent(element, eventName, eventHandler) {
     if (element.addEventListener){
         element.addEventListener(eventName, eventHandler, false);
     } else if (element.attachEvent) {
         element.attachEvent('on' + eventName, eventHandler);
     }
   }
 
 
   closeIframe(element){
     setTimeout(function(){  
       element.remove();
     }, 5000);
   }
   
 }