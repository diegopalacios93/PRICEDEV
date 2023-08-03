import { LightningElement, track,wire,api } from 'lwc';
import lstLineasNegocio from '@salesforce/apex/DetalleClienteHelper.traerListaLineaNegocioXContrato';

export default class LineasNegocio extends LightningElement {
    
    @track columns = [{
        label: 'Nombre',
        fieldName: 'nombre',
        type: 'text',
        sortable: true
    },
    {
        label: 'Linea de negocio',
        fieldName: 'lineaNegocio',
        type: 'text',
        sortable: true
    }
];
    @api recordId;
    @track lstLN; //All opportunities available for data table
    @track error;
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    cuentaId = '';

    @wire(lstLineasNegocio, {cuentaId:'$recordId'}) 
    WiredContratos({ error, data }) {
        if (data) {
            let recs = [];
        for(let i=0; i<data.length; i++){
            let lN = {};
            lN.rowNumber = ''+(i+1);
            lN.oppLink = '/'+data[i].Id;
            lN = Object.assign(lN, data[i]);
            recs.push(lN);
        }
        this.lstLN = recs;
        this.showTable = true;
        } else if (error) {
            this.error = error;
        }
    }
    handleToggleSection(event) {
            this.section = event.detail.openSection;
    }
    //Capture the event fired from the paginator component
    handlePaginatorChange(event){
        if(this.lstLN.length > 0){
            this.recordsToDisplay = event.detail;
            this.rowNumberOffset = this.recordsToDisplay[0].rowNumber-1;
        }   
    }
}