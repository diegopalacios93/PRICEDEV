/**
 * @description       : 
 * @author            : j.martinez.mercado
 * @group             : 
 * @last modified on  : 01-11-2022
 * @last modified by  : j.martinez.mercado
**/
import { api, LightningElement } from 'lwc';
import { publish, createMessageContext } from 'lightning/messageService';
import chatChannel from "@salesforce/messageChannel/deg_chatChannel__c";

var endSession;
const timeForSessionToEnd = 180000;

export default class Deg_popupsessiontimeout_lwc extends LightningElement {
    @api closePopup = false;
    handleShowPopup(event){
        console.log(event.detail.message);
    }
    context = createMessageContext();
    handleClick(_) {
        try {
            window.clearTimeout(endSession);
            publish(this.context, chatChannel, {
                eventMessage: 'warningClose'
            });
        } catch (e) {
            console.log(e);
        }
        this.closePopup = true;
    }

    renderedCallback(){
        if (!this.closePopup) {
            endSession = window.setTimeout(()=>{
                let popupState = document.querySelector('c-deg_chatpack_lwc').showPopupFin;
                if (!popupState) {
                    this.closePopup = true;
                    publish(this.context, chatChannel, {
                        eventMessage: 'endChat'
                    });
                }
            }, timeForSessionToEnd);
        }
    }

}