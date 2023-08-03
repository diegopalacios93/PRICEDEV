import { LightningElement, track } from "lwc";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import b2bConfigCard from "vlocity_cmt/b2bConfigCard";

export default class etb_b2bConfigCard extends OmniscriptBaseMixin(b2bConfigCard){
        _ns = getNamespaceDotNotation();
        @track isEditable = true;
        @track customCssIsEditable = "nds-b2b-attribute_value nds-text-align_right";
        @track spinnerActive = true;

        connectedCallback(){
            super.connectedCallback();
            //nList can be any variable, need to store the route Quote property
            this.nList = this.route.Quote;
            this.menuList=this.menuList.splice(1,1);
            console.log('precios ' + JSON.stringify(this.offer));
            this.getDataForEditPrice();
            // this.menuList.forEach(x,index => {
            //     if (x.id === 'adjust') {
            //         this.menuList.splice(index,1);
            //     }
            // });
        }

        getDataForEditPrice(){
            try {
                const input = {
                    productid: this.offer.productId
                };
                const params = {
                    input: JSON.stringify(input),
                    sClassName: `IntegrationProcedureService`,
                    sMethodName: 'etb_GetProfileAndProductData',
                    options: '{}'
                };
                this.omniRemoteCall(params, false).then((response) => {
                        console.log('response: ',JSON.stringify(response.result.IPResult));
                        if (!(response.result.IPResult.PriceUpdateAvailable)) {
                            this.isEditable = false;
                            this.customCssIsEditable = "nds-b2b-attribute_value nds-text-align_right nds-b2b-no-border";
                        }
                        this.spinnerActive = false;
                    })
                    .catch((error) => {
                        window.console.log(error, 'error');
                    });
                            
            } catch (error) {
                console.log('Error en getDataForEditPrice ', error);
            }    
        }
}