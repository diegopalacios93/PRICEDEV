import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Etb_NotStandardAccountSelection extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api imgs;
    // @api options = [];
    @api AccountId;
    @api labelradiogroup;
    @api selectedlocation;
    @track inputLocation;
    @track valueOfCombobox;
    @track isSelectedLocation = false;
    @track isSelectedRadioOption = false;
    radioSelectBackup;
    stateDataSelected;
    isSelectionPickUp = false;
    seEjecutoElBotonContinuar = false;
    showMessageErrorRadioOption = false;
    radioSelect = { title: '', value: '', pos: '', isDisabled: false };

    @api checkValidity() {
        console.log("this.valueOfCombobox", this.valueOfCombobox)
        if (this.seEjecutoElBotonContinuar) {
            if (this.isSelectedRadioOption) {
                    console.log('28');
                    this.omniNextStep();
                    return true;
            } else {
                console.log('45');
                this.showMessageErrorRadioOption = true;
            }
        } else {
            console.log('53');
            this.seEjecutoElBotonContinuar = true;
        }
        return false;
    }

    get getStyleForRadioOption() {
        return "slds-visual-picker slds-visual-picker_large" + ((this.showMessageErrorRadioOption) ? " notSelected" : "");
    }

    connectedCallback() {
        if (this.imgs !== undefined && Array.isArray(this.imgs)) {
            let auxImgs = [];
            for (var i = 0; i < this.imgs.length; i++) {
                auxImgs.push({
                    title: this.imgs[i].title,
                    value: this.imgs[i].value,
                    url: this.imgs[i].url,
                    isDisabled: ((this.imgs[i].disable !== undefined && this.imgs[i].disable == true) ? true : false)
                });
            }
            this.imgs = auxImgs;
        }
        if (this.selectedlocation != null) {
            this.handleSelectedLocation({
                "target": {
                    "value": this.selectedlocation
                }
            });
        }

    }

    renderedCallback() {
        this.stateDataSelected = this.omniGetSaveState();
        if (this.stateDataSelected != null) {
            const selectInput = this.template.querySelector('[data-pos="' + this.stateDataSelected.pos + '"]');
            this.radioSelectBackup = JSON.parse(JSON.stringify(this.stateDataSelected));
            selectInput.click();
        }
        if (this.imgs !== undefined && Array.isArray(this.imgs)) {
            for (var i = 0; i < this.imgs.length; i++) {
                if (this.imgs[i].isDisabled) {
                    const auxSelectInput = this.template.querySelector('[data-pos="' + i + '"]');
                    auxSelectInput.setAttribute("disabled", "true");
                }
            }
        }
    }

    handleSelectedRadioOption(event) {
        this.isSelectedRadioOption = true;
        this.showMessageErrorRadioOption = false;
        let pos = event.currentTarget.dataset.pos;
        // if (pos == "0") {
        //     this.isSelectionPickUp = false;
        // } else if (pos == "1") {
        //     this.isSelectionPickUp = true;
        // }
        if (pos !== undefined) {
            this.radioSelect = this.imgs[parseInt(pos)];
            this.radioSelect.pos = pos;
            console.log('this.radioSelect --> ',JSON.stringify(this.radioSelect));
            this.omniApplyCallResp({                   
                "OptionSelected": this.radioSelect.value
            });
            this.omniUpdateDataJson(this.radioSelect);
            this.omniSaveState(this.radioSelect);
        }
    }

    // handleSelectedLocation(event) {
    //     this.reportValidityOnInputComboBox();
    //     this.isSelectedLocation = true;
    //     this.valueOfCombobox = event.target.value;
    //     this.omniApplyCallResp({
    //         "selectedlocation": this.valueOfCombobox
    //     });
    //     this.omniUpdateDataJson("selectedlocation", this.valueOfCombobox);
    // }

    // reportValidityOnInputComboBox() {
    //     console.log('132');
    //     if (this.radioSelect.pos == "1") {
    //         console.log('134');
    //         let queryOfCombobox = this.template.querySelector('.inputComboBoxSelectLocation');
    //         queryOfCombobox.reportValidity();
    //     }
    // }
}