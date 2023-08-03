import { LightningElement,track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';
import { fetchCustomLabels } from "vlocity_cmt/utility";
export default class Etb_ReliesOnModal extends LightningElement {
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    @track isSpinnerOpen = true;
    quoteId;
    listQLI;
    qliOptions;
    qliValue;
    parentQli;
    changedQli;
    labels = {};
    @api idQli;
    // Obtenemos el contextId desde la URL
    @wire(CurrentPageReference)

    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.quoteId = this.urlStateParameters.c__cartId;
    }

    connectedCallback(){
        this.getCustomLabels();
    }

    renderedCallback(){
        if(!this.listQLI){
            this._actionUtil = new OmniscriptActionCommonUtil();
            let inputJSON = {'qliId': this.idQli, 'quoteId': this.quoteId};
            const params = {
                input: JSON.stringify(inputJSON),
                sClassName: 'vlocity_cmt.IntegrationProcedureService',
                sMethodName: 'etb_getQLIRelatedProducts',
                options: '{}',
            };
         
            this._actionUtil
                .executeAction(params, null, this, null, null)
                .then(response => {
                    let rp = response.result.IPResult.rpProdId;
                    let allQliList = response.result.IPResult.qliCart;
                    this.parentQli = response.result.IPResult.parentQli;
                    let qliFilterList = [];
                    let qliOp = [];
                    //REMOVE LATER if length 18

                    if(rp.length != 18){
                        for(let i = 0; i<rp.length; i++){
                            for(let j=0; j<allQliList.length; j++){
                                if(rp[i] == allQliList[j].Product2Id){
                                    let qli = {"label": allQliList[j].Product2.Name + ' - ' + allQliList[j].vlocity_cmt__QuoteMemberId__r.Name + ', '+  allQliList[j].vlocity_cmt__QuoteMemberId__r.vlocity_cmt__City__c + ', '+ allQliList[j].vlocity_cmt__QuoteMemberId__r.vlocity_cmt__State__c,
                                               "value" : allQliList[j].Id};
                                    qliOp.push(qli);
                                    qliFilterList.push(allQliList[j]);
                                    
                                    if(this.parentQli.vlocity_cmt__AssetReferenceId__c == allQliList[j].vlocity_cmt__ReliesOnItemId__c){
                                       this.qliValue = allQliList[j].Id;
                                       this.selectedQli = allQliList[j];
                                    }
                                }
                            }
                        }
                    }else{
                        for(let j=0; j<allQliList.length; j++){
                            if(rpId == allQliList[j].Product2Id){
                                let qli = {"label": allQliList[j].Product2.Name + ' - ' + allQliList[j].vlocity_cmt__QuoteMemberId__r.Name + ', '+  allQliList[j].vlocity_cmt__QuoteMemberId__r.vlocity_cmt__City__c + ', '+ allQliList[j].vlocity_cmt__QuoteMemberId__r.vlocity_cmt__State__c,
                                           "value" : allQliList[j].Id};
                                qliOp.push(qli);
                                qliFilterList.push(allQliList[j]);
                                
                                if(this.parentQli.vlocity_cmt__AssetReferenceId__c == allQliList[j].vlocity_cmt__ReliesOnItemId__c){
                                   this.qliValue = allQliList[j].Id;
                                   this.selectedQli = allQliList[j];
                                }
                            }
                        }
                    }
                    this.qliOptions = qliOp;
                    this.listQLI = qliFilterList;
                    this.isSpinnerOpen = false;
                    this.isModalOpen = true;
                })
                .catch(error => {
                    const evt = new ShowToastEvent({
                        title: this.labels.error,
                        message: this.labels.noproductosrelacionados,
                        variant: "error",
                    });
                    this.dispatchEvent(evt);
                    this.isSpinnerOpen = false;
                    console.log('!!Error reliesOnModal renderedCallback');
                });

        }
    }

    openModal() {
        this.isModalOpen = true;
    }

    submitDetails() {
            if(this.changedQli != undefined){
                this.isSpinnerOpen = true;
                this.isModalOpen = false;

                let items = [];
                for(let i = 0; i<this.changedQli.length; i++){
                    let itemsToSend = {
                        itemId: this.changedQli[i].Id,
                        fieldsToUpdate: {
                            vlocity_cmt__ReliesOnItemId__c: this.changedQli[i].vlocity_cmt__ReliesOnItemId__c, 
                            Related_Item__c: this.changedQli[i].vlocity_cmt__ReliesOnItemId__c ? this.idQli : ""
                        }
                    };
                    items.push(itemsToSend);
                }
                let inputJSON = {'items': items, 'cartId': this.quoteId};

                this._actionUtil = new OmniscriptActionCommonUtil();
                const params = {
                    input: JSON.stringify(inputJSON),
                    sClassName: 'vlocity_cmt.IntegrationProcedureService',
                    sMethodName: 'etb_postCartItemsReliesOn',
                    options: '{}',
                };
                this._actionUtil
                .executeAction(params, null, this, null, null)
                .then(response => {
                    if(response.result.error == "OK"){
                        const evt = new ShowToastEvent({
                            title: this.labels.exito, //put this in custom label
                            message: this.labels.productorelacionado,
                            variant: "success",
                        });
                        this.dispatchEvent(evt);
                        this.isSpinnerOpen = false;
                    }
                })
                .catch(error => {
                    console.log('!!Error reliesOnModal closeModal');
                });
            }else{
                const evt = new ShowToastEvent({
                    title: this.labels.error,
                    message: this.labels.favorrelacionarproducto,
                    variant: "error",
                });
                this.dispatchEvent(evt);
        }
    }

    handleChange(evt){
        const selectedOption = evt.detail.value;
        let qliListNew = this.listQLI;
        let newListQli = [];
        for(let i = 0; i<qliListNew.length; i++){
            if(qliListNew[i].Id == selectedOption && qliListNew[i].Id != this.qliValue){
                qliListNew[i].vlocity_cmt__ReliesOnItemId__c =  this.parentQli.vlocity_cmt__AssetReferenceId__c;
                newListQli.push(qliListNew[i]);
            }
            if(qliListNew[i].Id == this.qliValue){
                qliListNew[i].vlocity_cmt__ReliesOnItemId__c = "";
                newListQli.push(qliListNew[i]);
            }
        }
        this.listQLI = qliListNew;
        this.changedQli = newListQli;
    }

    getCustomLabels() {
        fetchCustomLabels(["noproductosrelacionados", "productorelacionado", "favorrelacionarproducto", "exito", "error"], "es")
          .then(data => {
              console.log('data: ' + JSON.stringify(data));
            this.labels = data;
          })
          .catch(error => console.error(error));
      };
    
}