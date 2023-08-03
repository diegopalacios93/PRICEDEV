import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateXA from '@salesforce/apex/SeleccionProductoCatalogo_ctr.updateXA';
import getMapSVAyXA from '@salesforce/apex/SeleccionProductoCatalogo_ctr.getMapSVAyXA';

export default class ModificarSVA_modal extends LightningElement {
    disabled = false;
    loading = true;
    @api recordId;
    @track svaXA = [];
    @track msgError;
    @track mapData = [];   
    @track showModal = true;
    activeSections = [];
    @wire(getMapSVAyXA, { ocId: '$recordId' })
    getMap({ error, data }) {
        if (data) {
            this.svaXA = JSON.parse(JSON.stringify(data));
            //var tempPicklist;
            // console.log('this.svaXA: ', JSON.stringify(this.svaXA));
            for (var key in this.svaXA) {
                // console.log('this.svaXA[key]: ', JSON.stringify(this.svaXA[key]));
                var tempPicklist = this.svaXA[key].filter(s => s.LTE_ParametroFacturacion__r.Tipo_de_Campo__c == 'Picklist');
                var tempNoPicklist = this.svaXA[key].filter(s => s.LTE_ParametroFacturacion__r.Tipo_de_Campo__c != 'Picklist');
                //this.mapData.push({ value: this.svaXA[key], key: key });
                //this.mapData.push({ value: tempNoPicklist, key: key });
                console.log('mapData NORMAL: ',  JSON.stringify(this.mapData));
                this.activeSections.push(key);
               
                for (var e in tempPicklist) {
                    console.log('tempPicklist[e]: ', JSON.stringify(tempPicklist[e].LTE_ParametroFacturacion__r.Obligatorio__c));
                    let pregAux = {};
                    pregAux.key = tempPicklist[e].Id;
                    pregAux.Id = tempPicklist[e].Id;
                    pregAux.Name = tempPicklist[e].Name;
                    pregAux.Value = tempPicklist[e].LTE_Value__c;
                    let respuestas = [];
                    for (var str in tempPicklist[e].LTE_ParametroFacturacion__r.OpcionesPicklist__c.split(',')) {
                        respuestas.push({ label: tempPicklist[e].LTE_ParametroFacturacion__r.OpcionesPicklist__c.split(',')[str],
                                          value: tempPicklist[e].LTE_ParametroFacturacion__r.OpcionesPicklist__c.split(',')[str] });
                    }
                    pregAux.respuestas = respuestas;
                    pregAux.Obligatorio = tempPicklist[e].LTE_ParametroFacturacion__r.Obligatorio__c;                    
                    tempNoPicklist.push(pregAux);
                }
                
                this.mapData.push({ value: tempNoPicklist, key: key });
                console.log('mapData PL: ',  JSON.stringify(this.mapData));
               
               
                // this.activeSections.push(key);

            }
            console.log('mapData: ',  JSON.stringify(this.mapData));
            console.log('XXXXXXXXX: ');
            // console.log('this.svaXA: ', JSON.stringify(this.svaXA));
            // console.log('XXXXXXXXX: ');
            // console.log('this.preguntasPickList: ', JSON.stringify(this.preguntasPickList));
        } else if (error) {
            console.log(error.body.message);
            this.loading = false;
            this.msgError = error.body.message;
        }
    }


    handleChange(event) {
        //      Chequea el campo cambiado y cambia el valor anterior por el nuevo.
        let mapKey = this.mapData.filter(em => em.key == event.target.dataset.keyid);
        let mapValue = mapKey[0].value.filter(v => v.Id == event.target.dataset.mapvalueid ? v.LTE_Value__c = event.detail.value : '');
    }

    OnHandleChange(event) {

        console.log('Entró al evento');
        // console.log('event');
        // console.log(event);
        console.log('event.detail' + JSON.stringify(event.detail));
        console.log('event.target' + JSON.stringify(event.target.name));
        let tempPreguntas = [];
        // let tempPregunta = tempPreguntas.filter(preg => preg.Id == event.target.name);
        // tempPregunta[0].LTE_Value__c = event.detail.value;
        // this.svaXA = tempPreguntas;
        for (var key in this.svaXA) {
           // console.log('this.svaXA[key]: ', JSON.stringify(this.svaXA[key]));
            tempPreguntas = this.svaXA[key].filter(s => s.Id == event.target.name);
            console.log('tempPreguntas' + JSON.stringify(tempPreguntas));
            if(tempPreguntas.length>0)
            {
                break;
            }
        }
        tempPreguntas[0].LTE_Value__c = event.detail.value;
        //let mapValue = mapKey[0].value.filter(v => v.Id == event.target.name ? v.LTE_Value__c = event.detail.value : '');
        console.log('HUBO CAMBIO: ');
        //console.log('tempPreguntas' + JSON.stringify(tempPreguntas));
        console.log('this.svaXA: ', JSON.stringify(this.svaXA));
    }

    openModal() {
        //      Cambiando la variable a true mostrara el modal
        this.showModal = true;
    }

    closeModal() {
        //      Cambiando la variable a false ocultara el modal
        this.showModal = false;
        this.dispatchEvent(new CustomEvent(
            'redirect',
            {
                detail: { data: this.recordId },
                bubbles: true,
                composed: true,
            }
        ));
    }

    handleOnLoad() {
        this.loading = false;
    }



    onSubmit() {
        //       Metodo ejecutado al momento de
        if (this.validateFields()) {
            this.disabled = true;

            updateXA({ mapXA: this.svaXA })
                .then(() => {
                    this.disabled = false;
                    this.closeModal();

                })
                .catch(error => {
                    console.log('Error: ', error);
                    this.disabled = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error actualizando los datos.',
                            message: error.body.message,
                            variant: 'error'
                        }));
                });
        }
    }

    validateFields() {
        return [...this.template.querySelectorAll("lightning-input-field")].reduce((validSoFar, field) => {
            return (validSoFar && field.reportValidity());
        }, true);
    }
}