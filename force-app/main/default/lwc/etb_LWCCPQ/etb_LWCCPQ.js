import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class etb_LWCCPQ extends OmniscriptBaseMixin(LightningElement) {
    @api cartid;
    @api carrito;
    url;
    srcfile;
    @track showSpinner = true;
    _ns = getNamespaceDotNotation();


    connectedCallback() {
        this.url = window.location.href.split('.lightning.force')[0];
        this.srcfile = `${this.url}--vlocity-cmt.visualforce.com/apex/hybridcpq?id=${this.cartid}`;
    }

    disconnectedCallback(){
        window.removeEventListener("message", this.receiveMessage);
    }
  
    receiveMessage(evt)
    {
        if (evt?.origin !== `${this.url}--vlocity-cmt.visualforce.com`) {
            return;
        } else {   
            if(evt?.data == 'true'){
               this.omniApplyCallResp({
                   "validateProductLWC": true
               });
            }else{
                this.omniApplyCallResp({
                    "validateProductLWC": false
                });
            }
        }
    }

    onSpinner() {
        window.addEventListener('message', this.receiveMessage.bind(this), false);
        this.showSpinner = false;
    }
}