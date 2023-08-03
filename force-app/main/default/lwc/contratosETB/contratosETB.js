import { LightningElement, track,wire,api } from 'lwc';
import lstContratoETB from '@salesforce/apex/DetalleClienteHelper.traerListaContratoETB';

export default class ContratosETB extends LightningElement {
    @track columns = [{
        label: 'Número de Contrato',
        fieldName: 'ContractNumber',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Nombre del contrato',
        fieldName: 'Name',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Contrato relacionado',
        fieldName: 'Contrato_relacionado_Formula__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },    
    {
        label: 'Número del contrato MCG',
        fieldName: 'NumeroContratoSGC__c',
        type: 'text',
        initialWidth: 250,
        sortable: true
    },
    {
        label: 'Modalidad de selección',
        fieldName: 'Modalidad_de_contratacion__c',
        type: 'text',
        initialWidth: 250,
        sortable: true
    },
    {
        label: 'Tipo de contrato ETB',
        fieldName: 'TipodecontratoETB__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Fecha de Venta',
        fieldName: 'Fecha_de_Venta__c',
        type: 'date',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Fecha inicio contrato',
        fieldName: 'StartDate',
        type: 'date',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Fecha fin contrato',
        fieldName: 'fecha_final_contrato__c',
        type: 'date',
        initialWidth: 200,
        sortable: true
    },    
    {
        label: 'Fecha Final Prima',
        fieldName: 'Fecha_Final_Prima__c',
        type: 'date',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Valor total contrato sin IVA',
        fieldName: 'ValorTotaldelcontrato__c',
        type: 'currency',
        initialWidth: 300,
        sortable: true
    },
    {
        label: 'Monto Prima',
        fieldName: 'Monto_Prima__c',
        type: 'currency',
        initialWidth: 300,
        sortable: true
    },
    {
        label: 'Monto Prima Total',
        fieldName: 'Monto_Prima_Total__c',
        type: 'currency',
        initialWidth: 300,
        sortable: true
    }
];
    @api recordId;
    @track lstContratoETB; //All opportunities available for data table
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    cuentaId = '';

    @wire(lstContratoETB, {cuentaId:'$recordId'}) 
    WiredContratos({ error, data }) {
        if (data) {
            let recs = [];
        for(let i=0; i<data.length; i++){
            let contratoETB = {};
            contratoETB.rowNumber = ''+(i+1);
            contratoETB.oppLink = '/'+data[i].Id;
            contratoETB = Object.assign(contratoETB, data[i]);
            recs.push(contratoETB);
        }
        this.lstContratoETB = recs;
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
        if(this.lstContratoETB.length > 0){
            this.recordsToDisplay = event.detail;
            this.rowNumberOffset = this.recordsToDisplay[0].rowNumber-1;    
        }
    }
}