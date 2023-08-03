/**
 * @description       :
 * @author            : Harlinsson Chavarro (HCH)
 * @group             :
 * @last modified on  : 06-04-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   03-09-2021   Harlinsson Chavarro (HCH)   Initial Version
 **/
import { LightningElement, api, track } from "lwc";
export default class Deg_lwcchatpackbtnenlace_lwc extends LightningElement {
  @api inputParams;
  @api btnLinkLstParams = [];
  @track messages;
  @track textMsj = "";
  @track textBtnLink = "";
  @track urlBtnLink = "";
  @track esBtnLink = false;

  connectedCallback() {
    //Procesa mensaje en lwc btn enlace
    this.messages = this.inputParams;
    let lstBtnLink = this.btnLinkLstParams;
    if (lstBtnLink.length > 0) {
      if (lstBtnLink[0].texto != "") this.textMsj = lstBtnLink[0].texto;
      else this.textMsj = !lstBtnLink[1].texto || lstBtnLink[1].texto == ""
        ? ""
        : lstBtnLink[1].texto;

      // this.textMsj =
      //   lstBtnLink[1].texto == "" || lstBtnLink[1].texto == undefined
      //     ? ""
      //     : lstBtnLink[1].texto;

      // lstBtnLink.forEach((element) => {
      //   if (element.texto == lstBtnLink[0].texto) {
      //     this.textMsj =
      //       lstBtnLink[0].texto == "" || lstBtnLink[0].texto == undefined
      //         ? ""
      //         : lstBtnLink[0].texto;
      //   } else {
      //     if (!element.texto.includes("http")) {
      //       this.textBtnLink += element.texto + " \n ";
      //     }
      //   }
      // });
      this.urlBtnLink = lstBtnLink[0].url;
      this.esBtnLink = true;
    }
  }

  handleBoton(event) {
    window.open(event.target.dataset.id, "_blank");
  }
}