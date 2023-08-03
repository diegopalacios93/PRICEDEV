import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';


export default class Etb_AssetsStatus extends NavigationMixin(LightningElement) {
    @api registro;
    activo = false;
    suspendido = false;
    cancelado = false;


    connectedCallback(){
        if(this.registro.AssetStatus == 'Active'){
            this.activo = true;
        }else if(this.registro.AssetStatus == 'Suspended'){
            this.suspendido = true;
        }else if(this.registro.AssetStatus == 'Disconnected' || this.registro.AssetStatus == 'Obsoleto'){
            this.cancelado = true;
        }
    }

}