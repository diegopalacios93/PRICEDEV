import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Etb_ListRelatedOrderContract extends OmniscriptBaseMixin(LightningElement){
    @track value;
    options =[];
    @api ipoptions=[];
    @track allValues= [];
    ordersSelected = [];
    
    connectedCallback() {
        if (this.ipoptions!=undefined || this.ipoptions!=null) {
            
            this.ipoptions.forEach(element => {
                this.options.push({
                    label: element.OrderNumber + ' - ' + element.ProductName + ' - ' + element.ServiceAccountName,
                    value: element.OrderNumber,
                    orderId: element.OrderId
                })
            });
        console.log('this.options', this.options);
       }
    }
    handleChange(event){
        if(!this.allValues.includes(event.detail.value)){

            let orderSelected = this.options.filter(x => x.value == event.detail.value)[0];
            this.allValues.push(orderSelected);
            /*var objId = new Object();
            objId.Id = orderSelected.orderId;
            this.ordersSelected.push(objId);*/
            // console.log('test 123', this.ordersSelected);
            this.ordersSelected.push({Id: orderSelected.orderId});
            // console.log('test 123', this.ordersSelected);
            /*this.omniApplyCallResp({
                "OptionSelected": this.radioSelect.value
            });*/
            this.omniUpdateDataJson(this.ordersSelected);
            this.omniSaveState(this.ordersSelected);
        }
    }
    handleRemove(event){

        const valueRemoved =event.target.name;        
        this.allValues.splice(this.allValues.indexOf(valueRemoved),1);
        this.ordersSelected.splice(this.ordersSelected.indexOf(valueRemoved),1);
        this.omniUpdateDataJson(this.ordersSelected);
        this.omniSaveState(this.ordersSelected);
        
    }
    



       
     
    
    /*
        (este funciona)
        
        console.log(this.ordersSelected,'orders ',valueRemoved,'value');
        console.debug('Json deleted');




        const valueremoved = event.detail.index ? event.detail.index : event.detail.name;
        const optionsremoved = this.allValues;
        optionsremoved.splice(valueremoved,1);
        this.ordersSelected= [...optionsremoved];
        console.log(valueremoved,this.allValues);
        
        
         handleRemove(event){
            let valueRemoved =event.target.name;
            console.log('valueRemoved: ',valueRemoved);
            console.log('this.allValues: ',JSON.stringify(this.allValues));
            //this.deleteOrderSelected(valueRemoved)
            this.allValues.forEach(element,index => {
                console.log('assertEquals: ', element.orderId == valueRemoved ? true : false);
            });
            for (let index = 0; index < this.allValues.length; index++) {
                const element = array[index];
                console.log('index: ',index);
                console.log('element: ',element);
                if(element.value == valueRemoved){
                    console.log('element.orderId: ',element.orderId);
                    this.ordersSelected.splice(this.ordersSelected.indexOf(element.orderId),1);
                    
                    this.omniUpdateDataJson(this.ordersSelected);
                    this.omniSaveState(this.ordersSelected);
                    this.allValues.splice(index,1);
                    //this.ordersSelected.splice(this.ordersSelected.indexOf(valueRemoved),1);
                
                }
            }



    removePill(event) {
        var value = event.currentTarget.name;
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.optionData));
        for(var i = 0; i < options.length; i++) {
            if(options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
            }
            if(options[i].selected) {
                count++;
            }
        }
        this.optionData = options;
        if(this.multiSelect)
            this.searchString = count + ' Option(s) Selected';
    }
    
        
    } */
            
    

    
   
    
}