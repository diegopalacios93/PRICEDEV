import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

export default class etb_PopulateCountryDepartmentCity extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

    @api addresstype;
    @api cityid;
    @api stateid;
    @api countryid;
    @api 
    _ns = 'vlocity_cmt';
    inputCountry = "";
    countries = [];
    states = [];
    cities = [];
    optionsCountry = [];
    optionsState = [];
    optionsCity = [];
    displayCountry = false;
    displayState = false;
    displayCity = false;
    optionValueState = null;
    optionValueCity = null;
    seEjecutoElBotonContinuar = false;
    primeraVez = true;
    primeravezseleccion = true;
    cargado = false;

    @api checkValidity() {
        if (this.optionValueCountry && this.optionValueState && this.optionValueCity){
            return true;
        } else {
    
            if (!this.primeraVez && this.cargado) {
                let Country = this.template.querySelector('.comboCountryClass');
                Country.reportValidity();
                let State = this.template.querySelector('.comboStateClass');
                State.reportValidity();
                let City = this.template.querySelector('.comboCityClass');
                City.reportValidity();
            } else {
                this.primeraVez = false;
            }
            return false;
        }
    }

    connectedCallback() {
        this.getCountry();
        // this.getState();
        // this.getCity();
    }

    getCountry() {
        const input = {
            "TerritoryType": "Country"
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: `${this._ns}.IntegrationProcedureService`,
            sMethodName: 'etb_GetCountryStateCity',
            options: '{}'
        };
        this.omniRemoteCall(params, false).then(response => {
            if (response.result.IPResult.length > 0) {
                this.countries = response.result.IPResult;
                this.countries.forEach(country => {
                    this.optionsCountry.push({ label: country.Name, value: country.Id});
                });
                this.getState();
            }
        }).catch(error => {
            console.log('error: ', error);
        });
    }

    getState() {
        const input = {
            "TerritoryType": "State"
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: `${this._ns}.IntegrationProcedureService`,
            sMethodName: 'etb_GetCountryStateCity',
            options: '{}'
        };
        this.omniRemoteCall(params, false).then(response => {
            if (response.result.IPResult.length > 0) {
                this.states = response.result.IPResult;
                this.getCity();
            }
        }).catch(error => {
            console.log('error: ', error);
        });
    }

    getCity() {
        const input = {
            "TerritoryType": "City"
        };
        const params = {
            input: JSON.stringify(input),
            sClassName: `${this._ns}.IntegrationProcedureService`,
            sMethodName: 'etb_GetCountryStateCity',
            options: '{}'
        };
        this.omniRemoteCall(params, false).then(response => {
            if (response.result.IPResult.length > 0) {
                this.cities = response.result.IPResult;
                if (this.countryid && this.primeravezseleccion) {
                    // this.optionValueCountry = this.countryid;
                    this.comboChangeCountry(null)
                }
                this.displayCountry = true;
                this.displayState = true;
                this.displayCity = true;
                this.cargado = true;
            }
        }).catch(error => {
            console.log('error: ', error);
        });
    }

    comboChangeCountry(event) {
        this.optionsState = [];
        this.optionsCity = [];
        this.optionValueState = null;
        this.optionValueCity = null;
        this.optionValueCountry = event ? event.detail.value : this.countryid;
        this.passData(this.optionValueCountry, this.optionValueState, this.optionValueCity, this.addresstype);
        if (this.states.filter(state => state.Padre == this.optionValueCountry).length > 0) {
            for (let i = 0; i < this.states.length; i++) {
                // if (this.states[i].Padre == event.detail.value) {
                if (this.states[i].Padre == this.optionValueCountry) {
                    this.optionsState.push({ label: this.states[i].Name, value: this.states[i].Id });

                } else if (this.states[i].Padre != this.optionValueCountry) {
                    this.optionValueState = null;
                    this.optionValueCity = null;
                }
            }
            if (this.stateid && this.primeravezseleccion) {
                // this.optionValueState = this.stateid;
                this.comboChangeState(null);
            }
        }
    }

    comboChangeState(event) {
        this.optionsCity = [];
        this.optionValueCity = null;
        this.optionValueState = event ? event.detail.value : this.stateid;
        this.passData(this.optionValueCountry, this.optionValueState, this.optionValueCity, this.addresstype);
        if (this.cities.filter(city => city.Padre == this.optionValueState).length > 0) {
            for (let i = 0; i < this.cities.length; i++) {
                if (this.cities[i].Padre == this.optionValueState) {
                // if (this.cities[i].Padre == event.detail.value) {
                    this.optionsCity.push({ label: this.cities[i].Name, value: this.cities[i].Id });

                } else if (this.cities[i].Padre != this.optionValueState) {
                    this.optionValueCity = null;
                }
            }
            if (this.cityid && this.primeravezseleccion) {
                // this.optionValueCity = this.cityid;
                this.comboChangeCity(null);
            }
        }                    
    }

    comboChangeCity(event) {
        this.optionValueCity = event ? event.detail.value : this.cityid;
        this.passData(this.optionValueCountry, this.optionValueState, this.optionValueCity, this.addresstype);
        this.primeravezseleccion = false;
    }

    passData(idCountry, idState, idCity, type) {
        switch (type) {
            case 'service':
                let labelCity = null;
                for (let i = 0; i < this.cities.length; i++) {
                    if (this.cities[i].Id == idCity) {
                       labelCity = this.cities[i].Name;
                       break;
                    }
                }
                this.omniApplyCallResp({                   
                    "ServiceAccount": {
                        "ServiceAddressBlock": {
                            "ServiceCountry": idCountry,
                            "ServiceState": idState,
                            "ServiceCity": idCity,
                            "ServiceCityLabel": labelCity

                         }
                    }
                });
                break;
            case 'billing':
                this.omniApplyCallResp({
                    "BillingAccount": {
                        "BillingAddressBlock": {
                            "BillingCountry": idCountry,
                            "BillingState": idState,
                            "BillingCity": idCity
                        }
                    }
                });
                break;
            case 'sameservice':
                this.omniApplyCallResp({
                    "BillingAccount": {
                        "BillingAddressBlock": {
                            "SameServiceCountry": idCountry,
                            "SameServiceState": idState,
                            "SameServiceCity": idCity
                        }
                    }
                });
                break;
            case 'shipping':
                this.omniApplyCallResp({
                    "deliveryMethodStep": {
                        "ServiceAddressBlock": {
                            "ServiceCountry": idCountry,
                            "ServiceState": idState,
                            "ServiceCity": idCity
                        }
                    }
                });
                break;
        
            default:
                break;
        }
    }
}