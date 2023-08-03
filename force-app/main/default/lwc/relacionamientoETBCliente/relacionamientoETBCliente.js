import {LightningElement,track,api,wire} from 'lwc';
import getTreeData from '@salesforce/apex/DetalleClienteHelper.getTreeData';


export default class RelacionamientoETBCliente extends LightningElement {
    @track treeItems;
    @track error;
    @api recordId;
    cuentaId = '';

    @wire(getTreeData,{cuentaId:'$recordId'})
    wireTreeData({
        error,
        data
    }) {
        if (data) {
            this.treeItems = data;
            //console.log(JSON.stringify(data, null, '\t'));
        } else {
            this.error = error;
        }
    }
}