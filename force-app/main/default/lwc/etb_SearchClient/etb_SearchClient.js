import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';

export default class etb_SearchClient extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {

  //Variables
  @api accountsData = [];
  _ns = getNamespaceDotNotation();
  showSpinner = false;
  optionValue = "";
  inputValue = "";
  nit = false;
  razon = false;
  cedula = false;
  showInputSearch = false;
  inputType = 'text';
  nodataV = false;
  emptyV = false;
  nitInput = '';
  cedulaInput = ''
  temp = '';
  validNit = false;
  validCedula = false;
  validationSpaceBottom = true;

  //Paginado
  maxData = 0;
  pagedData = []; //Esta variable va a ser la que se coloque en las filas del datatable.
  currentPage = 1;
  maxPages = 1;
  pageSize = 10; //cantidad de registros que entran por pagina
  disabledPreviousButton = false;
  disabledNextButton = false;
  seBusco = false;

  get options() {
    return [
      { label: 'NIT', value: 'NIT' },
      { label: 'Cédula', value: 'Cedula' },
      { label: 'Razón Social', value: 'RazonSocial' }
    ];
  }
  get optionsPage() {
    return [
      { label: '1', value: 1 },
      { label: '10', value: 10 },
      { label: '25', value: 25 },
    ];
  }
  get getValidacion() {
    return ((this.maxData > 0) ? true : false);
  }
  get getDatosMostrados() {
    let mult = 1 + ((this.currentPage - 1) * this.pageSize);
    if (this.maxData < mult) {
      return this.maxData;
    }
    return mult;
  }
  get getDataShow() {
    return this.pageSize * this.currentPage;
  }
  get isMoreDataThanDataShow() {
    return this.maxData > this.pageSize;
  }

  get leadFound() {
    for (const iterator of this.pagedData) {
      if (!iterator.isAccount) {
        return true;
      }
    }
    return false;
  }

  comboChange(event) {
    this.inputValue = "";
    this.optionValue = event.detail.value;
    if (this.optionValue == 'NIT') {
      this.nit = true;
      this.razon = false;
      this.cedula = false;
    } else if (this.optionValue == 'RazonSocial') {
      this.razon = true;
      this.nit = false;
      this.cedula = false;
    } else if (this.optionValue == 'Cedula') {
      this.cedula = true;
      this.nit = false;
      this.razon = false;
    }
    this.emptyV = false;
    this.nitInput = '';
    this.cedulaInput = '';
    this.inputValue = '';
    this.validCedula = false;
    this.validNit = false;

    if (this.optionValue != '') {
      this.showInputSearch = true;
    }
  }

  inputChange(event) {
    this.inputValue = event.detail.value;
  }

  search() {
    if (this.inputValue.length > 0 || this.validNit || this.validCedula) {
      this.validationSpaceBottom = false;
      this.showSpinner = true;
      if (this.validNit) {
        this.inputValue = this.nitInput;
      }
      if (this.validCedula) {
        // Se elimina '.' si se desea volver a una version anterior quitar el replace
        this.inputValue = this.cedulaInput.replace(/\./g, '');
      }
      const input = {
        SearchBy: this.optionValue,
        SearchValue: this.inputValue
      };

      const params = {
        input: JSON.stringify(input),
        sClassName: `${this._ns}IntegrationProcedureService`,
        sMethodName: 'etb_SearchClient',
        options: '{}'
      };

      this.omniRemoteCall(params, false)
        .then((response) => {
          console.log('VIP Request', input);
          console.log('VIP Response', response.result.IPResult);
          this.pagedData = [];
          let listRecords = [];
          if (Array.isArray(response.result.IPResult.Account) || Array.isArray(response.result.IPResult.Lead)) {
            if (response.result.IPResult.Account != null) {
              for (const iterator of response.result.IPResult.Account) {
                iterator.isAccount = true;
                listRecords.push(iterator);
                iterator.NIT = ((iterator.NITT) ? iterator.NITT : '') + ((iterator.DigitoVerificacion) ? ' - ' + iterator.DigitoVerificacion : '');

              }
            }
            if (response.result.IPResult.Lead != null) {
              for (const iterator of response.result.IPResult.Lead) {
                iterator.isAccount = false;
                iterator.Type = "Candidato";
                listRecords.push(iterator);
              }
            }
            if (listRecords.length > 0) {
              this.seBusco = true;
              this.accountsData = listRecords;
              this.maxData = this.accountsData.length;
              this.getMaxPages(this.accountsData);
              this.gotoPage(1, this.accountsData);
              this.emptyV = false;
              this.nodataV = false;
            } else {
              this.maxData = 0;
              this.emptyV = false;
              this.nodataV = true;
              this.getMaxPages([]);
              this.gotoPage(1, []);
              this.accountsData = [];
            }
          } else {
            this.emptyV = false;
            this.nodataV = true;
            this.accountsData = [];
            this.seBusco = false;
            this.maxData = 0;
            this.getMaxPages([]);
            this.gotoPage(1, []);
          }
          this.showSpinner = false;
        })
        .catch((error) => {
          window.console.log(error, 'error');
          this.showSpinner = false;
        });
    } else {
      if (this.nitInput.length == 0 && this.cedulaInput.length == 0) {
        this.emptyV = true;
        this.nodataV = false;
        this.accountsData = [];
        this.seBusco = false;
        this.maxData = 0;
        this.getMaxPages([]);
        this.gotoPage(1, []);
      }
      this.showSpinner = false;
    }
  }

  handleButtonNext() {
    let nextPage = this.currentPage + 1;
    if (this.seBusco) {
      this.gotoPage(nextPage, this.pagedData);
    } else {
      this.gotoPage(nextPage, this.accountsData);
    }
  }

  handleButtonLastPage() {
    let maxPages = 0;
    if (this.seBusco) {
      maxPages = this.getMaxPages(this.accountsData);
    } else {
      maxPages = this.getMaxPages(this.accountsData);
    }
    this.currentPage = maxPages;
    if (this.currentPage > 0 && this.currentPage <= maxPages) {
      this.gotoPage(this.currentPage, this.accountsData);
      this.disabledNextButton = true;
      this.disabledPreviousButton = false;
    }
  }

  handleButtonPrevious() {
    let nextPage = this.currentPage - 1;
    if (this.seBusco) {
      this.gotoPage(nextPage, this.pagedData);
    } else {
      this.gotoPage(nextPage, this.accountsData);
    }
  }

  handleButtonFirstPage() {
    this.currentPage = 1;
    if (this.seBusco) {
      this.gotoPage(1, this.accountsData);
    } else {
      this.gotoPage(1, this.accountsData);
    }
    this.disabledNextButton = false;
    this.disabledPreviousButton = true;
  }

  getMaxPages(array) {
    let result = 1;
    let divideValue;
    if (array) {
      divideValue = array.length / this.pageSize;
      result = Math.ceil(divideValue);
    }
    this.maxPages = result;
    return result;
  }

  gotoPage(pageNumber, arrayParsear) {
    let recordStartPosition, recordEndPosition;
    let maximumPages = this.maxPages;

    this.disabledPreviousButton = false;
    this.disabledNextButton = false;

    if (arrayParsear) {
      recordStartPosition = this.pageSize * (pageNumber - 1);
      recordEndPosition = recordStartPosition + parseInt(this.pageSize, 10);

      if (this.seBusco) {
        this.pagedData = this.accountsData.slice(
          recordStartPosition,
          recordEndPosition
        );
      } else {
        this.pagedData = arrayParsear.slice(
          recordStartPosition,
          recordEndPosition
        );
      }
    }
    this.currentPage = pageNumber;
    if (maximumPages === this.currentPage) {
      this.disabledNextButton = true;
    }
    if (this.currentPage === 1) {
      this.disabledPreviousButton = true;
    }
  }

  elegirMaxMostrados(event) {
    try {
      window.clearTimeout(this.delayTimeout);
      this.delayTimeout = setTimeout(() => {
        this.pageSize = event.detail.value;
        this.getMaxPages(this.accountsData);
        this.gotoPage(1, this.accountsData);
      }, 400);
    } catch (error) {
    }
  }

  handleNitChange(e) {
    this.nitInput = e.detail.value.replace(/[^0-9]/gi, '');
    e.target.value = e.detail.value.replace(/[^0-9]/gi, '');
    this.validNit = true;
    this.inputValue = this.nitInput;
    if (this.nitInput.length <= 0) {
      this.validNit = false;
    }
  }


  handleCedulaChange(e) {
    this.cedulaInput = e.detail.value.replace(/[^a-zA-Z0-9]/gi, '');
    e.target.value = e.detail.value.replace(/[^a-zA-Z0-9]/gi, '');
    this.validCedula = true;
    this.inputValue = this.cedulaInput;
    if (this.cedulaInput.length <= 0) {
      this.validCedula = false;
    }

  }

  format(value, pattern) {
    var i = 0,
      v = value.toString();
    return pattern.replace(/#/g, _ => v[i++]);
  }


}