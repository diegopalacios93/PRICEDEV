/**
 * @description       :
 * @author            : Pablo Arrieta
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   06-03-2021   Pablo Arrieta               Initial Version
 **/
import { LightningElement } from 'lwc';
import { publish, createMessageContext } from 'lightning/messageService';
import chatChannel from "@salesforce/messageChannel/deg_chatChannel__c";

export default class Deg_closechat_lwc extends LightningElement {

    context = createMessageContext();

    endChat() {
        publish(this.context, chatChannel, {
            eventMessage: 'endChat'
        });
    }

    closeModal() {
        publish(this.context, chatChannel, {
            eventMessage: 'closeModalEvent'
        });
    }

}