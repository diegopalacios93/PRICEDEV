/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 05-27-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   03-02-2021   Harlinsson Chavarro (HCH)   Initial Version
 **/
 import { LightningElement, api, track } from "lwc";
 import enlaceEmbebed from "@salesforce/label/c.DEG_DomainYoutube";
 import watchYoutube from "@salesforce/label/c.DEG_GetIdUrlYoutube";
 
 export default class Deg_lwcchatpackVideo_lwc extends LightningElement {
   @api inputParams;
   @api videoLstParams = [];
   @api btnLinkLstParams = [];
   @track messages;
   @track url;
   @track titleVideo = "";
   @track subTitleVideo = ""; //It show in label of button
   @track urlComplete = ""; //It show in url i a new tab
   @track textBtnLink = "";
   @track urlBtnLink = "";
   @track esBtnLink = false;
 
   label = {
     enlaceEmbebed,
     watchYoutube
   };
   connectedCallback() {
     //Procesa mensaje en lwc video
     let underScoreLine = "________________";
     this.messages = this.inputParams;
     let lstVideos = this.videoLstParams;
     let lstBtnLink = this.btnLinkLstParams;
     if (lstVideos.length > 0) {
       lstVideos.forEach((element) => {
         if (element.texto == lstVideos[0].texto) {
           this.titleVideo =
             lstVideos[0].texto == undefined ||
               lstVideos[0].texto == underScoreLine
               ? ""
               : lstVideos[0].texto;
         } else {
           if (!element.texto.includes("http")) {
             this.subTitleVideo += element.texto + " \n ";
           }
         }
       });
       lstVideos.forEach((item) => {
         if(item.texto.includes('https') && item.url.includes('https')){
           let pos = item.url.indexOf(this.label.watchYoutube);
           let urltemp = item.url.substring(pos);
           if (urltemp.includes("&")) {
             let pos2 = urltemp.indexOf("&");
             urltemp = urltemp.substring(0, pos2);
           }
           urltemp = urltemp.replace(this.label.watchYoutube, "");
           this.url = enlaceEmbebed + urltemp;
         }
       })
       /*this.urlComplete = lstVideos[3].texto;
       let pos = lstVideos[3].url.indexOf(this.label.watchYoutube);
       let urltemp = lstVideos[3].url.substring(pos);
       if (urltemp.includes("&")) {
         let pos2 = urltemp.indexOf("&");
         urltemp = urltemp.substring(0, pos2);
       }
       urltemp = urltemp.replace(this.label.watchYoutube, "");
       this.url = enlaceEmbebed + urltemp;*/
     }
     // if (lstBtnLink.length > 0) {
     //   lstBtnLink.forEach((element) => {
     //     if (!element.texto.includes("http")) {
     //       this.textBtnLink += element.texto + " \n ";
     //     }
     //   });
     //   this.urlBtnLink = lstBtnLink[1].url;
     //   this.esBtnLink = true;
     // }
   }
 }