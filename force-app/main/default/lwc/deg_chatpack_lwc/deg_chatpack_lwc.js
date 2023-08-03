/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 03-03-2022
 * @last modified by  : j.martinez.mercado
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   02-15-2021   Harlinsson Chavarro (HCH)   Initial Version
 * 1.1   04-13-2021   Rodrigo de la Cas           Async Version
 * 1.2   04-19-2021   Rodrigo de la Cas           Disable buttons on older messages
 * 1.3   01-05-2022   Juan David Mercado          Added timeout functionality
 **/
import BaseChatMessage from "lightningsnapin/baseChatMessage";
import { APPLICATION_SCOPE, subscribe, unsubscribe, createMessageContext } from 'lightning/messageService';
import chatChannel from "@salesforce/messageChannel/deg_chatChannel__c";
//new
import { track, api } from "lwc";
//---
const CHAT_CONTENT_CLASS = "chat-content";
const AGENT_USER_TYPE = "agent";
const CHASITOR_USER_TYPE = "chasitor";
const SUPPORTED_USER_TYPES = [AGENT_USER_TYPE, CHASITOR_USER_TYPE];
//new
var timeoutHandle = null;
var waitingUser = false;
var isEnded = false;
const timeOfWarningDefault = 1200;
//---

export default class Lwcchatpack extends BaseChatMessage {

  @track strMessage;
  @track isBaseTextVisible = false;
  @track esVideo = false;
  @track esImage = false;
  @track esBtnLink = false;
  @track esEventUrl = false;
  @track esFecha = false;
  @track esLogin = false;
  @track esLoginEmp = false;
  //new
  @api showPopupFin = false;
  //---
  @track videoLst = [];
  @track btnLinkLst = [];
  @track imageLst = [];
  @track messageStyle = "";
  @track space = "";
  @track eventLst = [];
  @track datesLst = [];
  @track sessionId = "";
  @track token = "";
  @track closeChat = false;
  context = createMessageContext();
  subscription = null;

  handlermethod(params) {
    const event = params.eventMessage;
    if (event == 'openModal') this.closeChat = true;
    if (event == 'closeModalEvent') this.closeChat = false;
    //new
    if (event === 'warningClose'){
      waitingUser = true;
      this.showPopupFin = false;
    }
    //---
  }
  //new
  waitPopUp(timeForPopup){
    window.clearTimeout(timeoutHandle);
      timeoutHandle = window.setTimeout(function() {
        if (this.showPopupFin !== null) {
          this.showPopupFin = true;
        }
      }.bind(this), timeForPopup * 1000);
  }

  activityRecognition(time){
    document.onmousemove = (_) => {
      this.waitPopUp(time);
    }
    document.onclick = (_) => {
      this.waitPopUp(time);
    }
    document.onkeydown = (_) => {
      this.waitPopUp(time);
    }
    document.onwheel = (_) => {
      this.waitPopUp(time);
    }
  }
  //---
  
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

  connectedCallback() {
    this.subscribeEvent();
    this.strMessage = this.messageContent.value;
    if (this.strMessage.trim() != "" && this.strMessage.trim().length > 0) {
      if (this.isSupportedUserType(this.userType)) {
        // Set our messageStyle class to decorate the message based on the user.
          this.messageStyle = `${CHAT_CONTENT_CLASS} ${this.userType}`;
          this.space = "space";
          // Create a temporary element to strip out markup from the message.
          if (this.userType === "agent") {
            //new
            this.showPopupFin = false;
            isEnded = false;
            //---
            let messages = this.htmlDecode(this.strMessage);
            this.strMessage = messages.trim();
            if (this.strMessage === ":") {
              window.postMessage("awaitForDB", "*");
              this.space = "escribiendo";
              this.strMessage = `<div style= "color: #fff; 
                                              background: #2791bb !important; 
                                              border-radius: 10px 10px 10px 0; 
                                              padding: 6px; 
                                              width: 50%; 
                                              max-width: 50%;"
                                              >  Escribiendo... </div>`;
              this.isBaseTextVisible = true;
            } else if (window.lastResponse) {
              this.strMessage = window.lastResponse;
              this.isBaseTextVisible = false;
              if (this.strMessage && this.strMessage.length > 0) {
                this.strMessage.forEach((msj) => {
                  // msj.showMsj = true;
                  //console.log('##msj '+JSON.stringify(msj));
                  if (msj.closeModal === true) {
                    window.postMessage("closeModal", "*");
                  }
                  else if (msj.waitForDB === true) {
                    window.postMessage("awaitForDB", "*");
                  } 
                  else{
                    window.postMessage("awaitForUser", "*");
                    //new
                    if (!waitingUser) {
                      waitingUser = true;
                    }
                    //---
                  }

                  //if (msj.sessionIdWatson != null && msj.sessionIdWatson != '' &&  msj.tokenWatson != null && msj.tokenWatson != '') {
                  if (msj.sessionIdWatson != null && msj.sessionIdWatson != "") {
                    //this.token = msj.tokenWatson;
                    this.sessionId = msj.sessionIdWatson;
                  }
                  if (msj.esMsn && !msj.esBtnLink) {
                    msj.validMsn = msj.mensaje && msj.mensaje.trim() != '';
                  } else {
                    msj.esMsn = false;
                  }
                  if (msj.esVideo) {
                    this.videoLst = msj.videoLst;
                  }
                  if (msj.esBtnLink) {
                    this.btnLinkLst = msj.btnLinkLst;
                  }
                  if (msj.esImage) {
                    this.imageLst = msj.imageLst;
                  }
                  if (
                    msj.idEvent != null &&
                    msj.idEvent !== "" &&
                    msj.idEvent !== "asesor"
                  ) {
                    if (
                      msj.idEvent === "calendario_web" ||
                      msj.idEvent === "rango_fechas"
                    ) {
                      this.esFecha = true;
                      this.datesLst = msj.datesLst;
                      this.days = msj.days;
                    } else if (msj.idEvent === "autenticacion") {
                      this.esLogin = true;
                    }
                      else if (msj.idEvent === "autenticacion_empresas") {
                        this.esLoginEmp = true;
                    } else {
                      if (
                        msj.urlEvent != null &&
                        msj.urlEvent !== "" &&
                        msj.idEvent !== "asesor"
                      ) {
                        this.esEventUrl = true;
                        this.eventLst.push({
                          idEvent: msj.idEvent,
                          urlEvent: msj.urlEvent
                        });
                      }
                    }
                  }
                });

              }
              window.lastResponse = null;
            } else {
              this.isBaseTextVisible = true;
              this.strMessage =
                `<div 
                    style= "color: #fff; 
                            background: #2791bb !important; 
                            border-radius: 10px 10px 10px 0; 
                            padding: 10px; 
                            padding-top: 2px;"
                  >${this.strMessage}</div>`;
            }
          }
          if (this.userType === "chasitor") {
               this.isBaseTextVisible = true;
          }
        

      } else {
        throw new Error("Unsupported user type passed in: ${this.userType}");
      }
    }
  }
  
  //new
  renderedCallback(){
    if(!isEnded){
        if (waitingUser && !this.showPopupFin) {
          try {
              this.waitPopUp(timeOfWarning);
              this.activityRecognition(timeOfWarning);
          } catch (error) {
              console.log('Def');
            // this.waitPopUp(timeOfWarningDefault);
            // this.activityRecognition(timeOfWarningDefault);
          }
        }else{
          if (timeoutHandle !== null) {
            window.clearTimeout(timeoutHandle); 
          }
          document.onmousemove, document.onclick, document.onkeydown, document.onwheel = null;
        }
    }else{
        if (timeoutHandle !== null) {
          window.clearTimeout(timeoutHandle); 
        }
        document.onmousemove, document.onclick, document.onkeydown, document.onwheel = null;
        return;
    }
  }
  //---

  disconnectedCallback() {
    //new
    isEnded = true;
    waitingUser = false;
    //---
    this.unsubscribeEvent();
  }

  isSupportedUserType(userType) {
    return SUPPORTED_USER_TYPES.some(
      (supportedUserType) => supportedUserType === userType
    );
  }

  handlePostMessage(event) {
    const value = event.target.dataset.id;
    let test = this.template.querySelectorAll("button");
    for (var i = 0, len = test.length; i < len; i++) {
      test[i].disabled = true;
    }
    window.postMessage(
      {
        message: value,
        type: "chasitor.sendMessage"
      },
      window.parent.location.href
    );
  }

  htmlDecode(input) {
    var doc = new DOMParser().parseFromString(input, "text/html");
    return doc.documentElement.textContent;
  }
}