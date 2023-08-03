import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import loadData  from '@salesforce/apex/deg_updatecsv_ctr.readCSVFile';
 
export default class Deg_updatefiles_lwc extends LightningElement {
    @api disabledfile=false;
    @api  mtdname='';
    @api  recordtype='';
    @track resultstr;
    @track resultjson;
    @track idresult;

    error;
    isLoaded = false;

    get acceptedFormats() {
        return ['.csv'];
    }
    
    uploadFileHandler( event ) {
        console.log(this.mtdname);
        console.log(this.recordtype);
        this.isLoaded = true;
        const uploadedFiles = event.detail.files;

        loadData( { contentDocumentId : uploadedFiles[0].documentId,namemdt : this.mtdname, idrt : this.recordtype} )
        .then( result => {

            this.isLoaded = false;
            window.console.log('result ===> '+result);
            this.resultstr=result;
            this.resultjson=JSON.parse(this.resultstr);
            this.idresult=this.resultjson.recordid;
            window.console.log(this.resultjson);
            window.console.log(this.resultjson.strmessage);
            window.console.log('this.idresult');
            window.console.log(this.idresult[0]);
            this.strMessage = result;
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Success',
                    message: this.resultjson.strmessage,
                    variant: this.resultjson.variant.includes("success") ? 'success' : 'error',
                    mode: 'sticky'
                } ),
            );
            const passEvent = new CustomEvent('pasedata', {
                detail: this.idresult
            });
            this.dispatchEvent(passEvent);

        })
        .catch( error => {
            console.log(error);
            this.isLoaded = false;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Error!!',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'sticky'
                } ),
            );     

        } )

    }
}