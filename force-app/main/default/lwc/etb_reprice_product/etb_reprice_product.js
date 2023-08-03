import { LightningElement, wire, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
//import getQuoteParams from "@salesforce/apex/etb_reprice_ctr.get_Quote_Params";
//import getQuoteCost from "@salesforce/apex/etb_reprice_ctr.get_Quote_Costs";

export default class Etb_reprice_product extends OmniscriptBaseMixin(LightningElement) {

    @api jsonCostos;
    @api jsonParameters;
    @api soloLectura=false;

    @track quoteParameters = new Array();
    @track quoteCost = new Array();
    jsonCost;

    connectedCallback() {
        this.getQuoteParameters();
        this.getQuoteCostValues();        
        this.omniUpdateDataJson(this.jsonCost,true);  
        this.omniValidate();
        this.reportValidity();
    }

    getQuoteParameters(){               
        let quoteParameters = JSON.parse(this.jsonParameters);
        var arrayParameters = new Array();
        Object.entries(quoteParameters).forEach(([key, value]) => {
            arrayParameters.push({key:key,value:value});                       
        })
        this.quoteParameters = arrayParameters;  
    } 

    getQuoteCostValues(){        
        var quoteCost = JSON.parse(this.jsonCostos);
        var arrayCost = new Array();
        Object.entries(quoteCost).forEach(([key, value]) => {
            arrayCost.push({key:key,value:value});                        
        })
        this.quoteCost = arrayCost;
        //this.jsonCost = quoteCost;
        this.jsonCost = {};          
    }
    
    handleChange(event) {
        let varName = event.target.name;
        let changeValue = event.detail.value; 
        let newElement = {};
        newElement['Valor'] = Number(changeValue);
        let keys = Object.keys(this.jsonCost);
        //this.jsonCost[varName]['Valor'] = Number(changeValue);
        this.jsonCost[varName]=newElement;
        
        this.omniUpdateDataJson(this.jsonCost,true);  
        this.omniValidate();
        this.reportValidity();
    }

}