import { LightningElement, api } from 'lwc';
import {OmniscriptBaseMixin} from 'vlocity_cmt/omniscriptBaseMixin';

export default class Etb_ShowClientHistory extends OmniscriptBaseMixin(LightningElement) {

    _ns = 'vlocity_cmt';
    @api recordId;
    @api contextId;
    history = [];
    all = [];
    hayDatos = false;
    optionSelected = "All";
    title = 'Historial del Cliente';

    get isCheckedAll(){
        return (this.optionSelected == "All");
    }
    get isCheckedOrder(){
        return (this.optionSelected == "Order");
    }
    get isCheckedCase(){
        return (this.optionSelected == "Case");
    }
    get isCheckedOpportunity(){
        return (this.optionSelected == "Opportunity");
    }
    
    async connectedCallback(){
        await this.getHistoryAccount();
        this.handleChangeOption({detail:{value:"All"}});
    }

    async getHistoryAccount(){

        const input = {
            "AccountId": this.recordId
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: `${this._ns}.IntegrationProcedureService`,
            sMethodName: 'etb_GetAccountHistory', 
            options: '{}' 
            }; 
        console.log('params: ',JSON.stringify(params));        
        await this.omniRemoteCall(params, false).then(response => { 
            if(response.result.IPResult.All.length > 0){
                this.hayDatos = true;
                this.all = response.result.IPResult.All;
            } 
        }).catch(error => {
            console.log('error: ',error);
        }); 
    }

    handleChangeOption(event){
        console.log('event: ',JSON.stringify(event));
        this.optionSelected = event.detail.value;
        switch (this.optionSelected) {
            case "All":
                this.title = 'Historial del Cliente';
                break;
            case "Order":
                this.title = 'Ordenes';
                break;
            case "Case":
                this.title = 'Casos';
                break;
            case "Opportunity":
                this.title = 'Oportunidades';
                break;
        
            default:
                this.title = 'Historial del Cliente';
                break;
        }
        if(this.optionSelected != 'All'){
            this.history = this.all.filter(x => x.Object == this.optionSelected);
        }else{
            this.history = this.all;
        }
        this.history = this.history.slice(0,10);
        this.omniApplyCallResp({
            "historyList": null
        });
        this.omniApplyCallResp({
            "historyList": this.history
        });

        console.log('history: ',JSON.stringify(this.history));
    }
    
}