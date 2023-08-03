/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 05-05-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   05-05-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
import { api, LightningElement, track } from 'lwc';
import getMessageJSON from '@salesforce/apex/DEG_MessageChecker_ctr.getMessageJSON';

export default class deg_messagechecker_lwc extends LightningElement {
    chatKey = '';
    messageCheckerInitializated = false;
    
    connectedCallback() {
        window.lastMessageNumber = 0;
        lastMessageNumber=0;
        if (this.messageCheckerInitializated) {
            return;
        }
        this.checkForNewMessages();
        this.bindEvent(window,'message',function (e) {
            if( e.data.data && e.data.data.event === 'chasitorChatRequestSuccessful'){
                this.chatKey = e.data.data.chasitorData.chatKey;
            }
            if( e.data.data && e.data.data.event === 'chasitorChasitorChatEnded'){
                this.chatKey = '';
            }
           
         })
    }

    checkForNewMessages(){
        this.timeIntervalInstance = setInterval(function() {
            if (this.chatKey != ''){
                getMessageJSON({ chatKey: this.chatKey})
                .then(result => {
                    try{
                        var objResult = JSON.parse(result);
                        if(parseInt(objResult.number) > parseInt(window.lastMessageNumber)){
                            window.lastResponse = objResult.lastResponse;
                            window.sessionIdWatson = objResult.sessionIdWatson; 
                            window.postMessage( {
                                message: ' ',
                                type: "chasitor.sendMessage"
                              },
                              window.parent.location.href);
                              window.lastMessageNumber = parseInt(objResult.number);
                        }
                    }   
                    catch(error){
                    }                     
                }) 
                  .catch(error => {
                    console.log(error);
                }); }

        }, 5000);
    }

    bindEvent(element, eventName, eventHandler) {
        if (element.addEventListener){
            element.addEventListener(eventName, eventHandler, false);
        } else if (element.attachEvent) {
            element.attachEvent('on' + eventName, eventHandler);
        }
    }
}