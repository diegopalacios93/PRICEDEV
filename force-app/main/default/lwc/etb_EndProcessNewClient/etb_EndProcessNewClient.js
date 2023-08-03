import { LightningElement, api } from 'lwc';
import Tab from 'vlocity_cmt/tab';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import tmpl from './etb_EndProcessNewClient.html';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class Etb_EndProcessNewClient extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api message = { Button: { "URL": false }, Action: "error", TopMessage: "Ocurrió un error", MiddleMessage: "Ocurrió un error", BottomMessage: "Ocurrió un error", SecondButton: "false", LabelFirstButton: "Finalizar" }

    _ns = getNamespaceDotNotation();
    configNavigateCrm;
    showCallSpinner = true;
    nroTrans = true;
    buttonsEmpr = false;
    buttonsMiPy = false;
    imageAlert = "/resource/ETB_StaticResources/img/007-alerta-1-v2.png";
    imageError = "/resource/ETB_StaticResources/img/008-cancelar-1-v2.png";
    imageCheck = "/resource/ETB_StaticResources/img/008-xito-2-v2.png";

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
        if(this.message.UenName == 'MiPymes'){
            this.buttonsMiPy = true;
        }else if(this.message.UenName == 'Empresas'){
            this.buttonsEmpr = true;
        }
        
        console.log(JSON.stringify(this.message));
        this.redireccionar();
    }
    render() {
        return tmpl;
    }

    openUrl(event) {
        // "https://etb--devetb--vlocity-cmt.visualforce.com/apex/vlocity_cmt__OmniScriptUniversalPage?id="+this.message.ObjectRedirect+"&layout=lightning#/OmniScriptType/etb/OmniScriptSubType/NuevaVenta/OmniScriptLang/English/ContextId/"+this.message.ObjectRedirect+"/PrefillDataRaptorBundle//true"
        // if (this.configNavigateCrm != undefined) {
        //     this[NavigationMixin.Navigate](this.configNavigateCrm, true);
        // }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.message.Button.URL,
                objectApiName: this.message.ObjectRedirect,
                actionName: 'view'
            }
        });
    }

    openLeadEmpresa(){
        console.log('empreJSON: ')
        console.log('recordId: ',this.message.Button.URL)
        console.log('objectApiName: ',this.message.ObjectRedirect)
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