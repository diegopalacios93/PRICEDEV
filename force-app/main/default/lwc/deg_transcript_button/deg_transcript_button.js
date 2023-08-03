import { LightningElement, api, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import transcriptConversation from '@salesforce/apex/DEG_TranscriptConversation_cls.transcriptConversation';
import activeTranscriptBody from '@salesforce/apex/DEG_TranscriptConversation_cls.activeTranscriptBody';

export default class Deg_transcript_button extends LightningElement {
    @track idTab;
    @api recordId;
    loading = true;
    showModal = false;
    showfooter = true;
    activeChatTranscripts = 0;
    _cache;
    isResult = false;
    isFirstRender = true;

    

    @wire(activeTranscriptBody, {valid:'$recordId' })
    handleChatTranscriptCount(valData) {
        this._cache = valData;
        if(valData.data != undefined) {
            this.activeChatTranscripts = valData.data;
            this.loading = false;
        }
    }

    handleShowModal() {
        this.showModal = true;
    }

    handleCloseModal() {
        this.showModal = false;
    }    

    handleTranscript( ) {
        if(this.activeChatTranscripts == 0) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Transcripción de Conversación',
                message: 'No existe ninguna conversación para transcribir',
                variant: 'warning'
            }));
            return;
        }        
        this.loading = true;
        this.showModal = false;
        transcriptConversation({valLiveChatTranscriptId : this.recordId})
        .then(valResult => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Resultado',
                message : valResult.error ? valResult.message : 'Transcripción Exitosa',
                variant : valResult.error ? 'error' : 'success',
                messageData: [
                    {
                        url: `/${valResult.record}`,
                        label: 'here'
                    }
                ]
            }));
            refreshApex(this._cache).then(() => {  
                this.loading = false;
                this.handleCloseModal();
            });
            getRecordNotifyChange([{recordId: this.recordId}]);
        })
        .catch(valError => console.log(valError));
    }

    handleSupport() {
        if (!window.DOMParser) return false;
        var parser = new DOMParser();
        try {
            parser.parseFromString('x', 'text/html');
        } catch(err) {
            return false;
        }
        return true;
    };

    handleStringToHTML(str) {

        if (this.handleSupport()) {
            var parser = new DOMParser();
            var doc = parser.parseFromString(str, 'text/html');
            return doc.documentElement.textContent;
        }
        var dom = document.createElement('div');
        dom.innerHTML = str;
        return dom;
    
    };
    
}