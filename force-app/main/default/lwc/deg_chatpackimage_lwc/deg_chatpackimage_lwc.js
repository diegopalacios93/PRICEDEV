/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 01-20-2022
 * @last modified by  : j.martinez.mercado
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   03-09-2021   Harlinsson Chavarro (HCH)   Initial Version
 **/
 import { LightningElement, api, track } from "lwc";

 export default class Lwcchatpack_carousel extends LightningElement {
   @api inputParams;
   @api imageLstParams;
   @track tiles = [];
   @track imgIndex = 0;
 
   connectedCallback() {
     this.messages = this.inputParams;
     let lstImages = this.imageLstParams;
     let urlComplete = "";
     let key = 0;
     if (lstImages.length > 0) {
       let cont = 1;
       lstImages.forEach((elem) => {
         console.log(`elem: ${JSON.stringify(elem)}`);
         if (elem.url.includes("http")) {
           urlComplete = elem.url;
         }
         if (!elem.texto.includes("http")) {
           this.tiles.push({
             title: elem.texto,
             src: urlComplete,
             key: "img"+ key
           });
           key++;
           cont++;
         }
       });
       this.tiles.forEach((obj)=>{
         console.log(`Objeto tile: ${JSON.stringify(obj)}`);
       });
     }
   }
   openImg(event){
     let source = event.target.getAttribute('src');
     window.open(source);
   }
 
 }