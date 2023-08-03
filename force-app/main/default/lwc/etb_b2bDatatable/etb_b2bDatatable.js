import { LightningElement, track, wire, api } from 'lwc';
import B2bDatatable from 'vlocity_cmt/b2bDataTable';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class Etb_b2bDatatable extends NavigationMixin(B2bDatatable, LightningElement) {

    openReliesOnQuoteModal = false;
    //reliesOn quote modal
    @track qliId;

    connectedCallback(){
        this.summaryActionList.splice(1,0,{label:'Relacionar Producto',method:'reliesOnQuote'});
    }

    executeAction(evt){
        let indexRow = Number(evt.currentTarget.dataset.index);
        this.qliId = this.tablePageData[indexRow].columns[0].config.rowData.id;
        const func = evt.currentTarget.dataset.method;
        if(func == "reliesOnQuote" && this.openReliesOnQuoteModal){
            this.openReliesOnQuoteModal = false;
        }
        if(func == "reliesOnQuote" && !this.openReliesOnQuoteModal){
            this.openReliesOnQuoteModal = true;
        }
        if(func == "processRow"){
            this.deleteChildProcessRow();
        }
        this[func](evt);
    }

    deleteChildProcessRow(){
        let inputJSON = {'qliId': this.qliId};
        this._actionUtil = new OmniscriptActionCommonUtil();
        const params = {
            input: JSON.stringify(inputJSON),
            sClassName: 'vlocity_cmt.IntegrationProcedureService',
            sMethodName: 'etb_clearReliesOn',
            options: '{}',
        };
        this._actionUtil
            .executeAction(params, null, this, null, null)
            .then(response => {
                console.log('response: ' + JSON.stringify(response.result));
            })
            .catch(error => {
                console.log('!!Error etb_b2bDatatable processRow');
            });  
    }
}