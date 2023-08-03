import { LightningElement, track,wire,api } from 'lwc';
import ObtenerPotencialIngresosOperacionales from '@salesforce/apex/DetalleClienteHelper.ObtenerPotencialIngresosOperacionales';

export default class PotencialIngresosOperacionales extends LightningElement {
    
    @api recordId;   
    cuentaId = '';
    datos = [];
    potencial = '';
    ingresosOperacionales = 0;
    @track error;

    @wire(ObtenerPotencialIngresosOperacionales, {cuentaId:'$recordId'}) 
    WiredDatos({ error, data }) {
        if (data) {
            
            this.datos = data;
            console.log('data '+ JSON.stringify( this.datos));
            this.potencial = this.datos[0];
            this.ingresosOperacionales = this.datos[1];
        }
        else if (error) {
            this.error = error;
        }
    }
}