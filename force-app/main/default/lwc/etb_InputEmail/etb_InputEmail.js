import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class etb_InputEmail extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

  //Variables
  emailValue = "";
  confirmacionEmailValue = "";
  emailOk = true;
  primeraVez = true;

  @api checkValidity() {
    if (this.emailValue != '' && /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.emailValue) &&this.emailValue == this.confirmacionEmailValue){
        this.omniApplyCallResp({
            "BillingAccountEmail": this.emailValue
        });
        //this.omniNextStep();
        return true;
    } else {

        if (!this.primeraVez) {
            let confirmacionEmailVal = this.template.querySelector('.inputConfirmacionEmailClass');
            confirmacionEmailVal.reportValidity();
            let emailVal = this.template.querySelector('.inputEmailClass');
            emailVal.reportValidity();
        } else {
            this.primeraVez = false;
        }

        this.omniApplyCallResp({
            "BillingAccountEmail": null
        });
        return false;
    }
  }

  inputChangeEmail(event) {
    this.emailValue = event.detail.value;

    if (this.emailValue == this.confirmacionEmailValue){
        this.emailOk = true;
    } else {
        this.emailOk = false;
    }
  }

  inputChangeConfirmacionEmail(event) {
    this.confirmacionEmailValue = event.detail.value;

    if (this.emailValue == this.confirmacionEmailValue){
        this.emailOk = true;
    } else {
        this.emailOk = false;
    }
  }

  handlePaste(event) {
    event.preventDefault(); 
  };

  handleContext(event) {
    event.preventDefault(); 
  };

}