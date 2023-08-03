import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class Etb_DisplayCartMultiSite extends OmniscriptBaseMixin(LightningElement) {
    @api cartIdCart;
    @api opportunityId;
    @track showSpinner = false;
    @track cartURL;
    cartStrategy;

    _ns = getNamespaceDotNotation();
    multiServiceCPQbaseURL = 'apex/'+ this._ns.replace('.', '__') + 'MultiServiceCPQRedirect';
    hybridCPQbaseURL = 'apex/'+ this._ns.replace('.', '__') + 'HybridCPQ';
    
    selectedWrapperId;
    randomCount = 1;
    isToShow = false;

    connectedCallback() {
        console.log('Etb_DisplayCartMultiSite');
        this.url = `${window.location.href.split('.lightning.force')[0]}--vlocity-cmt.visualforce.com`;
        this.getURL();
    }

    disconnectedCallback(){
        window.removeEventListener('message', this.receiveMessage);
    }

    onSpinner() {
        this.showSpinner = false;
        window.addEventListener('message', this.receiveMessage.bind(this), false);
    }

    receiveMessage(evt)
    {
        if (evt?.origin !== this.url) {
            return;
        } else {   
            if(evt?.data?.event_id == 'cartMultiSite' && evt?.data?.isNext == true){
                console.log(evt?.data?.event_id);
                console.log(evt?.data?.isNext);
               this.omniApplyCallResp({
                   "validateStepMultiCartLWC": true
               });
            }else{
                console.log(evt?.data?.isNext);
                this.omniApplyCallResp({
                    "validateStepMultiCartLWC": false
                });
            }
        }
    }

    getURL = function() {
        this.isToShow = false;
        this.cartStrategy = this.omniJsonData.cartStrategy;

        if(!this.omniJsonData.cartId) {
            return '';
        }

        if(this.selectedWrapperId && this.omniJsonData.cartId === this.selectedWrapperId /*&& randomCount === $scope.bpTree.randomCount*/) {
            this.isToShow = true;
            return this.cartURL;
        }
        if(this.cartStrategy === 'single') {
            this.cartURL = this.getHybridCPQURL();
        } else if(this.cartStrategy === 'multiple') {
            this.cartURL = this.getMultiServiceCPQURL();
        }
        this.selectedWrapperId = this.cartIdCart;
        this.isToShow = true;
        console.log(this.cartURL);
    }

    getHybridCPQURL = function() {

        let groupPageSize = this.omniJsonData.groupPageSize; //verificar
        if(!groupPageSize) {
            groupPageSize = 20;
        }
        let memberPageSize = this.omniJsonData.memberPageSize;
        if(!memberPageSize) {
            memberPageSize = 20;
        }

        let parameters = [];
        parameters.push('id=' + this.cartIdCart);
        let url = this.url + '/' + this.hybridCPQbaseURL + '?' + parameters.join('&');

        return url;
    }

    getMultiServiceCPQURL = function() {
        
        if(!this.omniJsonData.cartType) {
            return undefined;
        }
        let groupPageSize = this.omniJsonData.groupPageSize;
        if(!groupPageSize) {
            groupPageSize = 20;
        }
        let memberPageSize = this.omniJsonData.memberPageSize;
        if(!memberPageSize) {
            memberPageSize = 20;
        }
        let parameters = [];

        parameters.push('contextId=' + this.cartIdCart);
        parameters.push('parentId='+ this.opportunityId);
        parameters.push('redirectToFirstGroup=true');
        parameters.push('groupPageSize=' + groupPageSize);
        parameters.push('memberPageSize=' + memberPageSize);
        parameters.push('cartType='+ this.omniJsonData.cartType);

        let url = this.url + '/' + this.multiServiceCPQbaseURL + '?' + parameters.join('&');

        return url;
    }
}