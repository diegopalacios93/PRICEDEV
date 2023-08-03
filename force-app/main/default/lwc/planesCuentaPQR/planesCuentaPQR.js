import { LightningElement, track,wire,api } from 'lwc';
import lstCasos from '@salesforce/apex/DetalleClienteHelper.traerListaCasos';

export default class PlanesCuentaPQR extends LightningElement {

    @track columns = [{
        label: 'Número del caso',
        fieldName: 'CaseNumber',
        type: 'text',
        initialWidth: 250,
        sortable: true
    },
    {
        label: 'Fecha de radicación',
        fieldName: 'Fechaderadicacion__c',
        type: 'text',
        initialWidth: 250,
        sortable: true
    },
    {
        label: 'ID Servicio',
        fieldName: 'IDServicio__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Plan',
        fieldName: 'Plan__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },  
    {
        label: 'Estado',
        fieldName: 'status',
        type: 'text',
        initialWidth: 200,
        sortable: true
    }, 
    {
        label: 'Causal Estado',
        fieldName: 'Causal_Estado__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    }, 
    {
        label: 'Prioridad',
        fieldName: 'Priority',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Asunto',
        fieldName: 'Subject',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
];
    @api recordId;
    @track lstOpor; //All opportunities available for data table
    @track error;
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    cuentaId = '';

    @wire(lstCasos, {cuentaId:'$recordId'}) 
    WiredContratos({ error, data }) {
        if (data) {
            let recs = [];
        for(let i=0; i<data.length; i++){
            let opp = {};
            opp.rowNumber = ''+(i+1);
            opp.oppLink = '/'+data[i].Id;
            opp = Object.assign(opp, data[i]);
            recs.push(opp);
        }
        this.lstOpor = recs;
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
        if(this.lstOpor.length > 0){
            this.recordsToDisplay = event.detail;
            this.rowNumberOffset = this.recordsToDisplay[0].rowNumber-1;
        }   
    }
}