/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 08-24-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   02-02-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
import BaseChatHeader from 'lightningsnapin/baseChatHeader';
import { APPLICATION_SCOPE, subscribe, unsubscribe, createMessageContext, publish } from 'lightning/messageService';
import chatChannel from "@salesforce/messageChannel/deg_chatChannel__c";
import lwcChatPackLibrary from '@salesforce/resourceUrl/LwcChatPack';
import MAX_GIF from '@salesforce/resourceUrl/DEG_LogoLuz';
import { loadScript } from "lightning/platformResourceLoader";
import botName from '@salesforce/label/c.DEG_NombreBotWebChat';

export default class Header extends BaseChatHeader {
    /**
     * Text to display in h2 element.
     * @type {string}
     */

       // Expose the labels to use in the template.
    label = {
        botName   
    };
    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';
    context = createMessageContext();
    state = '';
    subscription = null;
    maxLogoGif = MAX_GIF;

    handlermethod(params) {
        const event = params.eventMessage;
        if (event == 'endChat') {
            this.close();
            window.postMessage("endChatSession", "*");
        }
    }

    subscribeEvent() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.context, chatChannel, (params) => {
            this.handlermethod(params);
        }, { scope: APPLICATION_SCOPE }
        );
    }

    unsubscribeEvent() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    loadScript() {
        Promise.all([
            loadScript(this, lwcChatPackLibrary + "/closeChat.js"),
        ]).then(() => { console.log('script iniciado') });
    }

    connectedCallback() {
        this.loadScript();
        this.subscribeEvent();
        this.assignHandler("prechatState", (data) => {
            this.state = 'prechatState';
            this.setText(data.label);
        });
        this.assignHandler("offlineSupportState", (data) => {
            this.state = 'offlineSupportState';
            this.setText(data.label);
        });
        this.assignHandler("waitingState", (data) => {
            this.state = 'waitingState';
            this.setText(data.label);
        });
        this.assignHandler("waitingEndedState", (data) => {
            console.log('---> Ended state');
            this.state = 'waitingEndedState';
            this.setText(data.label);
        });
        this.assignHandler("chatState", (data) => {
            this.state = 'chatState'
            this.setText(data.label);
        });
        this.assignHandler("chatTimeoutUpdate", (data) => {
            this.state = 'chatTimeoutUpdate'
            this.setText(data.label);
        });
        this.assignHandler("chatTimeoutClear", (data) => {
            this.state = 'chatTimeoutClear'
            this.setText(data.label);
        });
        this.assignHandler("chatEndedState", (data) => {
            this.state = 'chatEndedState'
            this.setText(data.label);
        });
        this.assignHandler("reconnectingState", (data) => {
            this.state = 'reconnectingState';
            this.setText(data.label);
        });
        this.assignHandler("postchatState", (data) => {
            this.state = 'postchatState';
            this.setText(data.label);
        });
        this.assignHandler("chatConferenceState", (data) => {
            this.state = 'chatConferenceState';
            this.setText(data.label);
        });
    }

    disconnectedCallback() {
        this.unsubscribeEvent();
    }

    setText(str) {
        if (typeof str !== "string") {
            throw new Error("Expected text value to be a `String` but received: " + str + ".");
        }
        this.text = '¡HOLA, SOY MAX!';
    }
    openModal() {
        if (this.state == 'prechatState') this.close();
        else {
            if (this.state == 'chatState') {
                publish(this.context, chatChannel, {
                    eventMessage: 'openModal'
                });
            }
            else this.close();
        }
    }

}