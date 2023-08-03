import { LightningElement, track,wire,api } from 'lwc';
import lstContratoCompetencia from '@salesforce/apex/DetalleClienteHelper.traerListaContratoCompetencia';

export default class ContratosCompetencia extends LightningElement {
 
    @track columns = [{
        label: 'Nombre',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Proveedor',
        fieldName: 'Proveedor__c',
        type: 'text',
        sortable: true
    },
    {
        label: 'Modalidad de contratacion',
        fieldName: 'Modalidad_de_contratacion__c',
        type: 'text',
        sortable: true
    },
    {
        label: 'Productos y Servicios',
        fieldName: 'Productos_y_servicios__c',
        type: 'text',
        sortable: true
    },
    {
        label: 'Fecha Inicio',
        fieldName: 'Fecha_Inicio_contrato__c',
        type: 'date',
        sortable: true
    },
    {
        label: 'Fecha Final',
        fieldName: 'Fecha_final_contrato__c',
        type: 'date',
        sortable: true
    },
    {
        label: 'Valor',
        fieldName: 'Valor__c',
        type: 'currency',
        sortable: true
    }
];
    @api recordId;
    @track lstContratoscom; //All opportunities available for data table  
    @track error;
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number
    cuentaId = '';

    @wire(lstContratoCompetencia, {cuentaId:'$recordId'}) 
    WiredContratos({ error, data }) {
        if (data) {
            let recs = [];
        for(let i=0; i<data.length; i++){
            let contratocompetencia = {};
            contratocompetencia.rowNumber = ''+(i+1);
            contratocompetencia.oppLink = '/'+data[i].Id;
            contratocompetencia = Object.assign(contratocompetencia, data[i]);
            recs.push(contratocompetencia);
        }
        this.lstContratoscom = recs;
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
        if(this.lstContratoscom.length > 0){
            this.recordsToDisplay = event.detail;
            this.rowNumberOffset = this.recordsToDisplay[0].rowNumber-1;
        }
    }
}