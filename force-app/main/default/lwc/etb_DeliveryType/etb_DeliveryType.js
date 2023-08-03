import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class Etb_DeliveryType extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api imgs;
    @api options = [];
    @api AccountId;
    @api labelradiogroup;
    @api selectedlocation;
    @track inputLocation;
    @track valueOfCombobox;
    @track isSelectedLocation = false;
    @track isSelectedRadioOption = false;
    @track direccion;
    @track sede;
    @track ciudad;
    @track isDetailsStore = false;
    @track listdata = [];
    radioSelectBackup;
    stateDataSelected;
    isSelectionPickUp = false;
    seEjecutoElBotonContinuar = false;
    showMessageErrorRadioOption = false;
    radioSelect = { title: '', value: '', pos: '', isDisabled: false };
    inputValue = "";
    _ns = getNamespaceDotNotation();

    @api checkValidity() {
        console.log("this.valueOfCombobox", this.valueOfCombobox)
        if (this.seEjecutoElBotonContinuar) {
            if (this.isSelectedRadioOption) {
                if (this.isSelectedLocation) {
                    this.omniNextStep();
                    return true;
                } else if (this.isSelectionPickUp == false && this.labelradiogroup != null) {
                    this.omniNextStep();
                    return true;
                } else if (this.isSelectionPickUp == false && this.labelradiogroup == null) {
                    this.omniApplyCallResp({
                        "SV_FlagDeliveryShowMsg": "1"
                    });
                } else {
                    this.reportValidityOnInputComboBox();
                }
            } else {
                this.showMessageErrorRadioOption = true;
            }
        } else {
            if (this.seEjecutoElBotonContinuar && !this.isSelectedRadioOption) {
                this.reportValidityOnInputComboBox();
            }
            this.seEjecutoElBotonContinuar = true;
        }
        return false;
    }

    get getStyleForRadioOption() {
        return "slds-visual-picker slds-visual-picker_medium" + ((this.showMessageErrorRadioOption) ? " notSelected" : "");
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
        if (pos == "0") {
            this.isSelectionPickUp = false;
            this.isDetailsStore = false;
        } else if (pos == "1") {
            this.isSelectionPickUp = true;
            if(this.direccion){
                this.isDetailsStore = true;
            }
        }
        if (pos !== undefined) {
            this.radioSelect = this.imgs[parseInt(pos)];
            this.radioSelect.pos = pos;
            this.omniApplyCallResp({
                "labelRadioGroup": this.radioSelect
            });
            this.omniUpdateDataJson(this.radioSelect);
            this.omniSaveState(this.radioSelect);
        }
    }

    handleSelectedLocation(event) {
        this.reportValidityOnInputComboBox();
        this.isSelectedLocation = true;
        this.valueOfCombobox = event.target.value;
        // this.idOperatindHoursOfStore(this.valueOfCombobox);
        this.omniApplyCallResp({
            "selectedlocation": this.valueOfCombobox
        });
        this.omniUpdateDataJson("selectedlocation", this.valueOfCombobox);
    }

    reportValidityOnInputComboBox() {
        if (this.radioSelect.pos == "1") {
            let queryOfCombobox = this.template.querySelector('.inputComboBoxSelectLocation');
            queryOfCombobox.reportValidity();
        }
    }

    idOperatindHoursOfStore(idstore){
        this.listdata = [];
        this.options.forEach(element => {

            if(element.value == idstore){
                this.direccion = element.Street;
                this.ciudad = element.City;
                this.sede = element.Sede;
                this.inputValue = element.OperatingHoursId;

                const input = { OpHoursId: this.inputValue };
            
                  const params = {
                    input: JSON.stringify(input),
                    sClassName: `vlocity_cmt.IntegrationProcedureService`,
                    sMethodName: 'etb_OperatingHoursEntry',
                    options: '{}'
                  };
            
                  this.omniRemoteCall(params, false)
                    .then((response) => {
                        console.log('VIP Response', JSON.stringify(response.result.IPResult));
                        response.result.IPResult.Operating.forEach(element => {
                            console.log(element.Horario.includes('Lunes'));
                            if(element.Horario.includes('Lunes')){
                                this.listdata.unshift(element);
                            }else{
                                this.listdata.push(element);
                            }
                        });
                        console.log('lista de valores ', this.listdata);
                    });
                this.isDetailsStore = true;
            }
        });
    }
}