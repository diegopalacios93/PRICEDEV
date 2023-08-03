import { LightningElement, api } from 'lwc';
import Tab from 'vlocity_cmt/tab';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import tmpl from './etbEndProcessMessage.html';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class EtbEndProcessMessage extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api message = { "Button": { "URL": false }, "Action": "error", "TitleMessage": "Ocurrió un error", "MainMessage": "Ocurrió un error", "OrderMessage": "Ocurrió un error" }

    _ns = getNamespaceDotNotation();
    configNavigateCrm;
    showCallSpinner = true;
    imageAlert = "/resource/ETB_StaticResources/img/007-alerta-1-v2.png";
    imageError = "/resource/ETB_StaticResources/img/008-cancelar-1-v2.png";
    imageCheck = "/resource/ETB_StaticResources/img/008-xito-2-v2.png";

    // NAOrder
    // &c__tabLabel=Proceso Exitoso
    // &c__tabIcon=standard:buyer_account
    // &c__TargetId=%etb_CartRecord:cartId%
    // &c__titleMessage=¡La orden se ha creado con éxito!
    // &c__orderMessage=Puede consultar los detalles en el historial de su cliente.
    // &c__action=Success
    // &c__sObject=Order

    // NAQuote
    // &c__tabLabel=Proceso Exitoso
    // &c__tabIcon=standard:buyer_account
    // &c__TargetId=%etb_CartRecord:cartId%
    // &c__titleMessage=¡La cotización se ha creado con éxito!
    // &c__orderMessage=Puede consultar los detalles en el historial de su cliente y en la página de la cotización misma.
    // &c__action=Success
    // &c__sObject=Quote

    // NAOrderError
    // &c__tabLabel=Proceso Erroneo
    // &c__tabIcon=standard:buyer_account
    // &c__TargetId=%ContextId%
    // &c__titleMessage=¡La orden no pudo ser creada!
    // &c__orderMessage=Contactese con un asesor para recibir mas información.
    // &c__action=Error
    // &c__sObject=Account

    // NAQuoteError
    // &c__tabLabel=Proceso Erroneo
    // &c__tabIcon=standard:buyer_account
    // &c__TargetId=%ContextId%
    // &c__titleMessage=¡La cotización no pudo ser creada!
    // &c__orderMessage=Contactese con un asesor para recibir mas información.
    // &c__action=Error
    // &c__sObject=Account


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
        console.log(JSON.stringify(this.message));
        this.redireccionar();
    }
    render() {
        return tmpl;
    }

    openUrl(event) {
        if (this.configNavigateCrm != undefined) {
            this[NavigationMixin.Navigate](this.configNavigateCrm, true);
        }
    }
    redireccionar() {
        this.configNavigateCrm = {
            type: 'standard__recordPage',
            attributes: {
                recordId: this.message.Button.URL,
                objectApiName: this.message.Object,
                actionName: 'view',
                replace: true
            },
        }
        this.showCallSpinner = false;
    }
}