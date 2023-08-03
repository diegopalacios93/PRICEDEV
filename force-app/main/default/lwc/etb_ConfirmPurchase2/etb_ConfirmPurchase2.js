import { LightningElement, api } from 'lwc';
import tmpl from './etb_ConfirmPurchase2.html';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class Etb_ConfirmPurchase2 extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api message = { Button: { "URL": false }, Action: "error", TopMessage: "Ocurrió un error", MiddleMessage: "Ocurrió un error", BottomMessage: "Ocurrió un error", SecondButton: "false", LabelFirstButton: "Finalizar" }
    nroTrans = true;
    configNavigateCrm;
    buttonsEmpr = false;
    buttonsMiPy = false;
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

    connectedCallback() {
        if (this.message.MiddleMessage == 'Nro. de transacción: null') {
            this.nroTrans = false;
        }
        if (this.message.UenName == 'MiPymes') {
            this.buttonsMiPy = true;
        } else if (this.message.UenName == 'Empresas') {
            this.buttonsEmpr = true;
        }
        this.redireccionar();
    }
    render() {
        return tmpl;
    }

    openUrl(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.message.Button.URL,
                objectApiName: this.message.ObjectRedirect,
                actionName: 'view'
            }
        });
    }
    openLeadEmpresa() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.message.Button.URL,
                objectApiName: this.message.ObjectRedirect,
                actionName: 'view'
            }
        }, true);
    }
    openUrlOS(event) {
        this.configNavigateCrm = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.message.Button.URL,
                objectApiName: this.message.ObjectRedirect,
                actionName: 'view',
                replace: true
            },
        }
    }
    redireccionar() {
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
    }
}