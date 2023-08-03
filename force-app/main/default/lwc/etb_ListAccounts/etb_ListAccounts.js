import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Etb_ListAccounts extends OmniscriptBaseMixin(LightningElement) {
    @api delivery;
    @api options = [];
    @api accounts = [];
    @api selection = {};
    @api recordtypename;
    @track value = 'none';
    @track showValidation = false;
    messageError = '';
    tieneDireccion = false;
    esService = false;

    get labelSelection() {
        if (this.accounts != null && this.accounts.length > 0) {
            if (this.recordtypename == 'Service') {
                return "Dirección de " + ((this.delivery == 'true') ? 'envío' : 'servicio');
            } else if (this.recordtypename == 'Billing') {
                return "Dirección de facturación";
            }
        }
        return "";
    }

    connectedCallback() {
        if (this.accounts != null && this.accounts.length > 0) {
            this.tieneDireccion = true;
        } else {
            this.tieneDireccion = false;
        }

        console.log("connectedCallback");
        console.log("options", this.options);
        console.log("accounts", JSON.stringify(this.accounts));
        let seleccionado = false;
        if (this.selection != null && this.selection != '' && this.accounts != null) {
            for (let i = 0; i < this.accounts.length; i++) {
                if (this.accounts[i].Id == this.selection.Id) {
                    this.value = i.toString();
                    seleccionado = true;
                    break;
                }
            }
        }

        if (this.recordtypename == 'Service' && this.delivery != 'true') {
            this.esService = true;
            this.options.push({ label: 'Continuar sin especificar una dirección de servicio', value: 'none' });
        }
        if (this.accounts != null && this.accounts.length > 0) {
            this.options.unshift({ label: 'Otro', value: 'new' });
            this.accounts.forEach((acc, index) => {
                console.log("this.accounts.forEach((acc, index) => {");
                if (acc.Id) {
                    console.log("if (acc.Id) {");
                    console.log(acc.LTE);
                    this.options.unshift({ label: ((acc.ExternalId != undefined && acc.ExternalId != '')? + acc.ExternalId +  " - " : ''  ) + acc.TipoPrincipal + " " + acc.NombrePrincipal + " No. " + acc.NombreSecundaria + " - " + acc.Numero + ", " + acc.Ciudad_Municipio + ((acc.NombrePremise && acc.NombrePremise != '- null') ? (" " + acc.NombrePremise) : "") + ((acc.Hierarchy != undefined && acc.Hierarchy != '' )? ' - ' + acc.Hierarchy: '') + ((acc.LTE == true )? ' - LTE': '') , value: index.toString() })                }
            });
            if (this.delivery != 'true') {
                this.messageError = 'Seleccione la dirección ' + ((this.recordtypename == 'Service') ? 'donde funcionará el servicio.' : 'que desee ver reflejada en su factura');
            }
        } else {
            this.options.unshift({ label: ((this.recordtypename == 'Service') ? 'Agregar dirección de ' + ((this.delivery == 'true') ? 'envío' : 'servicio') : 'Agregar dirección de facturación'), value: 'new' });
            this.messageError = 'No se tienen direcciones de ' + ((this.recordtypename == 'Service') ? ((this.delivery == 'true') ? 'entrega' : 'servicio') : 'facturación') + ' registradas previamente.';
        }
        this.omniApplyCallResp({
            "labelRadioGroup": null
        });
        this.omniApplyCallResp({
            "labelRadioGroup": ((seleccionado) ? this.accounts[this.value] : ((this.delivery == 'true' || this.recordtypename == 'Billing') ? null : 'none'))
        });
        console.log("options", this.options);
    }

    handleChange(event) {
        const position = event.detail.value;
        this.omniApplyCallResp({
            "labelRadioGroup": null
        });
        if (this.recordtypename == 'Service') {
            this.omniApplyCallResp({
                "labelRadioGroup": ((position != 'none' && position != 'new') ? this.accounts[position] : position)
            });
        } else if (this.recordtypename == 'Billing') {
            this.omniApplyCallResp({
                "labelRadioGroup": ((position != 'new') ? this.accounts[position] : position)
            });
        }
    }
}