import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class etb_360ViewAssetContainerMoreDetails extends NavigationMixin(LightningElement) {
    @track isModalOpen = false;
    @api registro;
    Ubicacion = '';
    esmovilofija = false;
    precioFormateado = '';

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.showSpinner = true;
        if (this.registro.moreInfo) {
            if (this.registro.moreInfo.PremisePrincipalType != 'undefined' &&
                this.registro.moreInfo.PremisePrincipalType != undefined) {
                this.Ubicacion += this.registro.moreInfo.PremisePrincipalType + ' ';
            }
            if (this.registro.moreInfo.PremisePrincipalName != 'undefined' &&
                this.registro.moreInfo.PremisePrincipalName != undefined) {
                this.Ubicacion += this.registro.moreInfo.PremisePrincipalName + ' ';
            }
            if (this.registro.moreInfo.PremiseSecondaryName != 'undefined' &&
                this.registro.moreInfo.PremiseSecondaryName != undefined) {
                this.Ubicacion += 'No.' + this.registro.moreInfo.PremiseSecondaryName;
            }
            if (this.registro.moreInfo.PremiseNumberlocation != 'undefined' &&
                this.registro.moreInfo.PremiseNumberlocation != undefined) {
                this.Ubicacion += '-' + this.registro.moreInfo.PremiseNumberlocation;
            }
            if (this.registro.moreInfo.PremiseCity != 'undefined' &&
                this.registro.moreInfo.PremiseCity != undefined) {
                this.Ubicacion += ', ' + this.registro.moreInfo.PremiseCity;
            }
            let formatter = new Intl.NumberFormat('es-CO', {
                style: 'currency',
                currency: 'COP',
            });
            let string = String(this.registro.moreInfo.AssetPrice);
            this.precioFormateado = formatter.format(string);
        } else {
            this.registro.moreInfo = {
                PremisePrincipalType: "",
                PremisePrincipalName: "",
                PremiseSecondaryName: "",
                PremiseNumberlocation: "",
                PremiseCity: "",
                AssetPrice: "",
                AssetInstallationDate: "",
                AssetIdService: "",
                AssetEndDate: ""
            }
        }
        if (this.registro.AssetType == 'Mobile' || this.registro.AssetType == 'Fija') {
            this.esmovilofija = true;
        } else {
            this.esmovilofija = false;
        }
    }
    closeModal() {
        this.isModalOpen = false;
    }
}