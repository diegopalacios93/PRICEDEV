import { LightningElement } from "lwc";
    import b2bOfferConfig from "vlocity_cmt/b2bOfferConfig";
    import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
    export default class etb_b2bOfferConfig extends OmniscriptBaseMixin(b2bOfferConfig){
        // your properties and methods here
        
  connectedCallback(){
      super.connectedCallback();
      //nList can be any variable, need to store the route Quote property
      this.nList = this.route.Quote;
  }
    }