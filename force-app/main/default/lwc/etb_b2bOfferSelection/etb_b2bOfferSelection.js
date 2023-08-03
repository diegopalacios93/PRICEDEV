import { LightningElement } from "lwc";
    import b2bOfferSelection from "vlocity_cmt/b2bOfferSelection";
    import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
    export default class etb_b2bOfferSelection extends OmniscriptBaseMixin(b2bOfferSelection){
        // your properties and methods here
        
  connectedCallback(){
      super.connectedCallback();
      //nList can be any variable, need to store the route Quote property
      this.nList = this.route.Quote;
  }

    }