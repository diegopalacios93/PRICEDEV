import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { LightningElement,api, track, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import updateXA from '@salesforce/apex/SeleccionProductoCatalogo_ctr.updateXA';
import getMapSVAyXA from '@salesforce/apex/SeleccionProductoCatalogo_ctr.getMapSVAyXA';

export default class ModificarAtributos extends LightningElement {
    @api recordId;
    @api isClassic;
    @track svaXA = [];
    @track msgError;
    @track mapData = [];
    @track activeSections= [];
    @track resultList = [];
    disabled = false;
    loading = true;

    @wire(getMapSVAyXA, { ocId: '$recordId' })
    getMap(result) {
        //Metodo wire que trae un Mapa de Listas de XA's anidados juntos a sus SVA correspondientes.
        //Clase Apex SeleccionProductoCatalogo_ctr
        this.resultList = result;

         if (result.data) {
            this.loading= false;
            this.svaXA = JSON.parse(JSON.stringify(result.data));
            this.msgError = undefined;
            console.log(result.data);

            // for (var key in this.svaXA) {
            //      this.mapData.push({ value: this.svaXA[key], key: key });
            //      this.activeSections.push(key);

            // }

            for (var key in this.svaXA) {
                // console.log('this.svaXA[key]: ', JSON.stringify(this.svaXA[key]));
                // console.log('this.svaXA[key]: ', JSON.stringify(this.svaXA[key]));
                var tempPicklist = this.svaXA[key].filter(s => s.LTE_ParametroFacturacion__r.Tipo_de_Campo__c == 'Picklist');
                var tempNoPicklist = this.svaXA[key].filter(s => s.LTE_ParametroFacturacion__r.Tipo_de_Campo__c != 'Picklist');
                //this.mapData.push({ value: this.svaXA[key], key: key });
                //this.mapData.push({ value: tempNoPicklist, key: key });
                // console.log('mapData NORMAL: ',  JSON.stringify(this.mapData));
                this.activeSections.push(key);
               
                for (var e in tempPicklist) {
                    // console.log('tempPicklist[e]: ', JSON.stringify(tempPicklist[e]));
                    let pregAux = {};
                    pregAux.key = tempPicklist[e].Id;
                    pregAux.Id = tempPicklist[e].Id;
                    pregAux.Name = tempPicklist[e].Name;
                    pregAux.Value = tempPicklist[e].LTE_Value__c;
                    let respuestas = [];
                    for (var str in tempPicklist[e].LTE_ParametroFacturacion__r.OpcionesPicklist__c.split(',')) {
                        respuestas.push({ label: tempPicklist[e].LTE_ParametroFacturacion__r.OpcionesPicklist__c.split(',')[str].trim(),
                                          value: tempPicklist[e].LTE_ParametroFacturacion__r.OpcionesPicklist__c.split(',')[str].trim() });
                    }
                    pregAux.respuestas = respuestas;
                    pregAux.Obligatorio = tempPicklist[e].LTE_ParametroFacturacion__r.Obligatorio__c;
                    console.log('pregAux: ', JSON.stringify(pregAux));    
                    console.log('XXXXXXXX');                
                    tempNoPicklist.push(pregAux);
                }
                
                this.mapData.push({ value: tempNoPicklist, key: key });
                // console.log('mapData PL: ',  JSON.stringify(this.mapData));
               
            }

        } else if (result.error) {
            this.msgError = error.body.message;
            this.loading= false;
        }
    }

    handleChange(event) {
        //      Cambia el valor anterior por el nuevo.
        let mapKey = this.mapData.filter(em => em.key == event.target.dataset.keyid);
        let mapValue = mapKey[0].value.filter(v => v.Id == event.target.dataset.mapvalueid ? v.LTE_Value__c = event.detail.value : '');    
    }

    OnHandleChange(event) {
       
        let tempPreguntas = [];  
            
        for (var key in this.svaXA) {          
            tempPreguntas = this.svaXA[key].filter(s => s.Id == event.target.name);            
            if(tempPreguntas.length>0)
            {
                break;
            }
        }
        tempPreguntas[0].LTE_Value__c = event.detail.value;
    }

    closeQuickAction() {
        //Metodo para cerrar el Screen Action
        if (this.isClassic) {
            this.dispatchEvent(new CustomEvent(
                'redirect', 
            {
                detail: { data: this.recordId },
                bubbles: true,
                composed: true,
            }
        ));  
        }
            else{

                this.dispatchEvent(new CloseActionScreenEvent());
  
            }
    }

    handleSubmit(event) {
        //       Metodo ejecutado al momento de guardar cambios
        
        if (this.validateFields()){

        this.disabled = true;
        //Metodo Apex  de clase SeleccionProductoCatalogo_ctr
        updateXA({ mapXA: this.svaXA })
            .then(() => {
                this.disabled = false;
                this.closeQuickAction();
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Actualizacion completa!',
                        message: 'Campos actualizados correctamente!',
                        variant: 'success',
                        mode: 'dismissable'

                }));
                //Refresca la vista una vez updateados los datos correctamente.
                return refreshApex(this.resultList);
                
            })
            .catch(error => {
                this.disabled = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Ups! Hubo un error, vuelva a intentarlo.',
                        message: error.body.message,
                        variant: 'error'
                }));
           });
        }
    }

    handleOnLoad(){
        this.loading = false;
    }

    validateFields() {
        //Metodo que chequea y valida los campos required.
        return [...this.template.querySelectorAll("lightning-input-field")].reduce((validSoFar, field) => {
            return (validSoFar && field.reportValidity());
        }, true);
    }
}