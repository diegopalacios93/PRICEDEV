import { LightningElement, api } from 'lwc';
import Tab from 'vlocity_cmt/tab';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import tmpl from './etb_EndProcessMessage.html';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class Etb_EndProcessMessage extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api message = { Button: { "URL": false }, Action: "error", TopMessage: "Ocurrió un error", MiddleMessage: "Ocurrió un error", BottomMessage: "Ocurrió un error", SecondButton: "false", LabelFirstButton: "Finalizar", TabToNav: "Ocurrió un error" }
    configNavigateCrm;
    showCallSpinner = true;
    _ns = getNamespaceDotNotation();
    imageCheck = "/resource/ETB_StaticResources/img/008-xito-2-v2.png";
    imageAlert = "/resource/ETB_StaticResources/img/007-alerta-1-v2.png";
    imageError = "/resource/ETB_StaticResources/img/008-cancelar-1-v2.png";

    @api
    get statusImage() {
        if (this.message.Action.toLowerCase() == 'success') {
            return this.imageCheck;
        } else if (this.message.Action.toLowerCase() == 'warning') {
            return this.imageAlert;
        } else if (this.message.Action.toLowerCase() == 'error') {
            return this.imageError;
        }
    }
    get validateSuccess() {
        return this.message.Action.toLowerCase() == 'success'
    }

    get validateNoOrder() {
        if (this.message.Object != 'Order'){
            return 'outline-brand';
        }
        return 'brand'
    }

    connectedCallback() {
        console.log(JSON.stringify(this.message));
        this.redireccionar();
    }
    render() {
        return tmpl;
    }

    openUrl(event) {
        if (this.configNavigateCrm != undefined && !this.message.TabToNav) {
            this[NavigationMixin.Navigate](this.configNavigateCrm, true);
        } else if (this.configNavigateCrm != undefined && this.message.TabToNav) {
            this[NavigationMixin.Navigate](this.configNavigateCrm, false);
        }
    }
    openUrlOS(event) {
        if (this.configNavigateCrm != undefined) {
            this[NavigationMixin.Navigate](this.configNavigateCrm, true);
        }
    }
    redireccionar() {
        if(!this.message.TabToNav){
            this.configNavigateCrm = {
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.message.Button.URL,
                    objectApiName: this.message.ObjectRedirect,
                    actionName: 'view',
                    replace: true
                },
            }
            this.showCallSpinner = false;
        }else{
            this.configNavigateCrm = {
                type: 'standard__navItemPage',
                attributes: {
                    apiName: this.message.TabToNav,
                },
            }
            this.showCallSpinner = false;
        }
    }
}