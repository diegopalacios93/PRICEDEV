import { LightningElement, track,wire,api } from 'lwc';
import lstOportunidades from '@salesforce/apex/DetalleClienteHelper.traerListaOportunidades';

export default class SeccionContratos extends LightningElement {

    @track columns = [{
        label: 'Nombre de la oportunidad',
        fieldName: 'Name',
        type: 'text',
        initialWidth: 250,
        sortable: true
    },
    {
        label: 'Consecutivo oportunidades',
        fieldName: 'Consecutivooportunidades__c',
        type: 'text',
        initialWidth: 250,
        sortable: true
    },
    {
        label: 'Tipo de operación',
        fieldName: 'Tipo_de_Operacion__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Etapa',
        fieldName: 'StageName',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Probabilidad de Cierre',
        fieldName: 'PDC__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Motivo de la perdida',
        fieldName: 'Motivo_de_la_perdida__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Fecha de cierre',
        fieldName: 'CloseDate',
        type: 'date',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Valor Total ETB',
        fieldName: 'Valor_Total_ETB__c',
        type: 'currency',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Valor Total Aliado',
        fieldName: 'Valor_Total_Aliado__c',
        type: 'currency',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Presupuesto de Inversión proyectada',
        fieldName: 'PresupuestoInversionProyectada__c',
        type: 'currency',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Clasificación del proyecto',
        fieldName: 'Clasificacion_del_proyecto__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Tiempo de Cumplimiento',
        fieldName: 'Tiempo_de_Cumplimiento_de_la_Oportunidad__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    //
    {
        label: 'Importancia estratégica para Nosotros',
        fieldName: 'importancia_estrategica_para_nosotros__c',
        type: 'boolean',
        initialWidth: 250,
        sortable: true,
        cellAttributes: { alignment: 'center' }
    },
    {
        label: 'Proyecto incluido en Plan de adquisición de la entidad o en planeación estratégica de la empresa',
        fieldName: 'ProyectoIncluidoPlan__c',
        type: 'boolean',
        initialWidth: 200,
        sortable: true,
        cellAttributes: { alignment: 'center' }
    },
    {
        label: 'La Empresa cuenta con el presupuesto',
        fieldName: 'EmpresaCuentaConPresupuesto__c',
        type: 'boolean',
        initialWidth: 200,
        sortable: true,
        cellAttributes: { alignment: 'center' }
    },
    {
        label: 'Monto del Presupuesto',
        fieldName: 'MontoPresupuesto__c',
        type: 'currency',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Modalidad de Contratacion',
        fieldName: 'ModalidadContratacion__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Monto Recurrente Mensual',
        fieldName: 'MontoRecurrenteMensual__c',
        type: 'currency',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Monto One Time',
        fieldName: 'MontoOneTime__c',
        type: 'currency',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Tiempo Contrato Meses',
        fieldName: 'Tiempo_de_contrato_meses__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Tiempo Contrato Días',
        fieldName: 'Tiempo_de_contrato_dias__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Interesada En Realizar Contrato',
        fieldName: 'InteresadaEnContrato__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Modelo de Contratación',
        fieldName: 'ModeloContratacion__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Otro Modelo De Contratación',
        fieldName: 'OtroModeloDeContratacion__c',
        type: 'text',
        initialWidth: 200,
        sortable: true
    },
    {
        label: 'Potencializa la compra con otras entidades adscritas o vinculadas',
        fieldName: 'PotencializaCompraOtrasEntidades__c',
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

    @wire(lstOportunidades, {cuentaId:'$recordId'}) 
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