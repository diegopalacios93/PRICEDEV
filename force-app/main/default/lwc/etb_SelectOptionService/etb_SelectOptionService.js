import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Etb_SelectOptionService extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api boxValue;
    @api checkboxSelected;
    @api typeAheadSelected;
    @track first = true;

    @api checkValidity() {
        if (this.boxValue == 'unique' || this.boxValue == 'multiple' || this.boxValue == 'none') {
            if (!this.first) {
                this.omniNextStep();
                return true
            } else {
                this.first = false;
                return false;
            }
        } else {
            return false;
        }
    }

    renderedCallback() {
        this.boxValue = this.omniGetSaveState();
        if (this.boxValue != null) {
            const selectInput = this.template.querySelector('[data-pos="' + this.boxValue + '"]');
            selectInput.click();
            this.first = true;
        }
    }

    handleClick(event) {
        this.first = false;
        var select = event.target.value;
        this.boxValue = select;
        this.omniApplyCallResp({
            "SelectedBox": this.boxValue,
            "multisite": ((select == 'multiple') ? 'si' : 'no')
        });
        this.omniSaveState(select);
    }
}