import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import Tab from 'vlocity_cmt/tab';
import tmpl from './etb_AccountServices.html';

export default class Etb_AccountServices extends OmniscriptBaseMixin(LightningElement) {

    @track showValidation = false;
    @api accounts = [];
    @api options = [];
    @api value = 'none';
    @api recordtypename;
    messageError = '';
    esService = false;

    get labelRadioGroup() {

        if (this.accounts != null && this.accounts.length > 0) {
            if (this.recordtypename == 'Service') {
                return "Dirección de servicio";
            } else if (this.recordtypename == 'Billing') {
                return "Dirección de facturación";
            }
        }
        return "";
    }

    connectedCallback() {

        if (this.recordtypename == 'Service') {
            this.esService = true;
            this.options.push({ label: 'Continuar sin especificar una dirección de servicio', value: 'none' });
        } else {
            this.esService = false;
        }

        console.log("este es el recordtypename", this.recordtypename)
        console.log("es service", this.esService)

        if (this.accounts != null && this.accounts.length > 0) {
            this.options.unshift({ label: 'Otro', value: 'new' });
            // for (let i = 0; i < this.accounts.length; i++) {
            //     this.options.push({ label: this.accounts[i].TipoPrincipal + " " + this.accounts[i].NombrePrincipal + " No. " + this.accounts[i].NombreSecundaria + " - " + this.accounts[i].Numero + ", " + this.accounts[i].Ciudad_Municipio, value: i.toString() })
            // }
            this.accounts.forEach((acc, index) => {
                this.options.unshift({ label: acc.TipoPrincipal + " " + acc.NombrePrincipal + " No. " + acc.NombreSecundaria + " - " + acc.Numero + ", " + acc.Ciudad_Municipio, value: index.toString() })
            });
            if (this.recordtypename == 'Service') {
                this.messageError = 'Seleccione la dirección donde funcionará el servicio.';
            } else if (this.recordtypename == 'Billing') {
                this.messageError = 'Seleccione la dirección que desee ver reflejada en su factura';
            }
        } else {
            if (this.recordtypename == 'Service') {
                this.options.unshift({ label: 'Agregar dirección de servicio', value: 'new' });
                this.messageError = 'No se tienen direcciones de servicio registradas previamente.';
            } else if (this.recordtypename == 'Billing') {
                this.options.unshift({ label: 'Agregar dirección de facturación', value: 'new' });
                this.messageError = 'No se tienen direcciones de facturación registradas previamente.';
            }
        }
        if (this.recordtypename == 'Service') {
            this.omniApplyCallResp({
                "labelRadioGroup": 'none'
            });
        }
        if (this.recordtypename == 'Billing') {
            this.omniApplyCallResp({
                "labelRadioGroup": null
            });
        }
    }
    handleChange(event) {
        const position = event.detail.value;
        if (this.recordtypename == 'Service') {
            if (position != 'none' && position != 'new') {
                this.omniApplyCallResp({
                    "labelRadioGroup": this.accounts[position]
                });
            } else {
                this.omniApplyCallResp({
                    "labelRadioGroup": position
                });
            }
        } else if (this.recordtypename == 'Billing') {
            if (position != 'new') {
                this.omniApplyCallResp({
                    "labelRadioGroup": this.accounts[position]
                });
            } else {
                this.omniApplyCallResp({
                    "labelRadioGroup": position
                });
            }
        }

    }

}