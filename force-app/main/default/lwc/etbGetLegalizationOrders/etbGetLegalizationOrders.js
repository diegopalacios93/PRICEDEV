import { LightningElement, api, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
    import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
    export default class EtbGetLegalizationOrders extends OmniscriptBaseMixin(LightningElement) {
      
      //variables
    _ns = getNamespaceDotNotation();
   @api legalizationid;	
    comboboxValue;
    opcionesCombo = [];
    showspinner = true;
    columnas = [];
    lineaseleccionada = [];
    mesOption = [];
    noValues = true;
    mostrarTabla = false;
    mostrarGrafico = false;
    //Variables paginador y buscador
    textoABuscar = "";
    pagedData = [];  //Esta variable va a ser la que se coloque en las filas del datatable.
    currentPage = 1;
    maxPages = 1;
    pageSize = 25; //cantidad de registros que entran por pagina
    disabledPreviousButton = false;
    disabledNextButton = false;
    seBusco = false;
    
// Obtenemos el contextId desde la URL
   /* @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }
    setParametersBasedOnUrl() {
                console.log ("parametros de llegan", this.urlStateParameters);
        this.accountId = this.urlStateParameters.c__ContextId;
                
    }*/
    connectedCallback() {
				/*if (this.ContractId !=undefined || this.ContractId!=null) {
           // this.ContractId.forEach(element => {
             //this.Id = element.Id;
            //});
        console.log('this.options', this.ContractId);
       }*/
                
                console.log ("ID contrato", this.contractid);
                this.getData();
        
        try {
            /*console.log("SimCard =>" + this.omniJsonData.Lines);
            if (this.omniJsonData.Lines) {
                this.omniJsonData.Lines.forEach(
                    element => this.lineas.push(element.Linea)
                );
            }
            meses.forEach((mes, index) => {
                this.mesOption.push({ label: mes, value: (index + 1) + '' })
            })
            if (this.lineas != null) {
                this.lineas.forEach(line => {
                    this.opcionesCombo.push({ label: line, value: line });
                });
                this.cambiarSpinner();
            }*/
        } catch (error) {
            console.log('Ocurrio error en connected callback ', error);
        }
                this.cambiarSpinner();
    }
    
    get showTable() {
        //return this.comboboxValue && this.lengthLineasSeleccionadas;
                return true;
    }
    get lengthLineasSeleccionadas() {
        //return this.lineaseleccionada.length > 0;
                return true;
    }
    cambiarSpinner() {
        try {
            this.showspinner = !this.showspinner;
        } catch (error) {
            console.log('Ocurrio un error en cambiarSpinner ', error);
        }
    }
    
    cargarColumnas(){
        this.columnas = [
            {
                type: "text", fieldName: "OrderNumber", label: 'Numero de Orden'
            },
            {
                type: 'text', fieldName: "ProductName", label: 'Nombre del producto'
            },
            {
                type: "text", fieldName: "ServiceAccountName", label: 'Nombre de cuenta servicio'
            }
        ];
    }
            getData() {
                    try {
                const input = {
                    LegalizationId: this.legalizationid
                };
                console.log('Input enviado ', input)
                const params = {
                    input: JSON.stringify(input),
                    sClassName: `IntegrationProcedureService`,
                    sMethodName: 'etb_GetLegalizationOrders',
                    options: '{}'
                };
                console.log('Mostrar tabla 1', this.mostrarTabla);
                this.mostrarTabla = true;   
                            console.log('Mostrar tabla 2', this.mostrarTabla);
                            this.omniRemoteCall(params, false)
                    .then((response) => {
                        console.log('data que llega', JSON.stringify(response.result.IPResult));
                                    this.lineaseleccionada = response.result.IPResult;
                                 
                        this.cargarColumnas();
                        this.getMaxPages(this.lineaseleccionada);  //lineaseleccionada es el array que tiene todo.
                        this.gotoPage(1, this.lineaseleccionada);
                        this.cargarColumnas();
                        this.noValues = this.lineaseleccionada.length > 0;
                    })
                    .catch((error) => {
                        window.console.log(error, 'error');
                    });
                            
                    } catch (error) {
            console.log('Error en getData ', error);
        }
                    
                    
                    
            }
    /*getData() {
        try {
            let anio = Number.parseInt(this.anioValue);
            let currentYear = new Date().getFullYear();
            let validacionTamanio = true;
            let currentMonth = new Date().getMonth()+1;
            let validator = (anio > currentYear || (anio == currentYear && this.mesValue > currentMonth)) ? false:true;
            console.log('Valor de validator ', validator, ' mes actual ',  currentMonth, ' mes elegido ', this.mesValue, ' año actual ', currentYear, ' año elegido ' , anio)
      
            if (anio.toString().length !== 4) {
                validacionTamanio = false;
            }
            if (validator && this.mesValue != null && this.comboboxValue != null && validacionTamanio) {
                this.mensajeValidator = '';
                const input = {
                    msisdn: this.comboboxValue,
                    year: Number.parseInt(this.anioValue),
                    month: this.mesValue
                };
                console.log('Input enviado ', input)
                const params = {
                    input: JSON.stringify(input),
                    sClassName: `${this._ns}IntegrationProcedureService`,
                    sMethodName: 'MVNO_B2C_GetConsumerHistory',
                    options: '{}'
                };
                console.log('Mostrar tabla 1', this.mostrarTabla);
                this.mostrarTabla = true;
                this.omniRemoteCall(params, false)
                    .then((response) => {
                        //this.lineaseleccionada = JSON.parse(response.result.IPResult.data).listSummaryDTO;
                        this.lineaseleccionada = response.result.IPResult.data.listSummaryDTO;
                        this.cargarColumnas();
                        this.getMaxPages(this.lineaseleccionada);  //lineaseleccionada es el array que tiene todo.
                        this.gotoPage(1, this.lineaseleccionada);
                        this.cargarColumnas();
                        this.noValues = this.lineaseleccionada.length > 0;
                        this.mostrarGrafico = true;
                    })
                    .catch((error) => {
                        window.console.log(error, 'error');
                    });
            } else {
                this.mostrarGrafico = false;
                this.mostrarTabla = false;
                this.mensajeValidator = 'Asegúrese de elegir una línea, mes y año correcto para ver resultados.'
            }
        } catch (error) {
            console.log('Error en getData ', error);
        }
    }*/
 
    //Metodos Buscador
    delayTimeout = setTimeout(() => { });
    handleKeyUp(event) {
        window.clearTimeout(this.delayTimeout);
        const textoBuscado = event.target.value.toLowerCase();
        this.textoABuscar = event.target.value.toLowerCase();
        this.delayTimeout = setTimeout(() => {
            if (textoBuscado.length > 0) {
                this.seBusco = true;
                console.log('Se ejecuto handleKeyUp ');
                let arrayFiltrado = this.filtrado(textoBuscado, this.lineaseleccionada);
                this.getMaxPages(arrayFiltrado);
                this.gotoPage(1, arrayFiltrado);
            } else {
                this.getMaxPages(this.lineaseleccionada);
                this.gotoPage(1, this.lineaseleccionada);
                this.seBusco = false;
            }
        }, 300);
    }
    filtrado(textoBuscado, array) {
        let nuevoArreglo = [];
        let buscaText = textoBuscado.toString();
        array.forEach(e => {
            if (e.consumoDatosBytes.toString().toLowerCase().includes(buscaText)) {
                nuevoArreglo.push(e);
            }
        });
        return nuevoArreglo;
    }
    //metodos paginador
    handleButtonNext() {
        let nextPage = this.currentPage + 1;
        if (this.seBusco) {
            this.gotoPage(nextPage, this.pagedData);
        } else {
            this.gotoPage(nextPage, this.lineaseleccionada);
        }
    }
				getSelectedName(event) {
	try{
    let order = [];
     const selectedRows = event.detail.selectedRows;
     for (let i = 0; i < selectedRows.length; i++) {
            console.log('You selected: ' + selectedRows[i]);
       	    order.push({Id:selectedRows[i].OrderId });
        }
    this.omniUpdateDataJson(order);
  }catch(e){
								console.log (e);
						}
}
    handleButtonLastPage() {
        let maxPages = 0;
        if (this.seBusco) {
            cambiaColor();
            maxPages = this.getMaxPages(this.filtrado(this.textoABuscar, this.lineaseleccionada));
        } else {
            maxPages = this.getMaxPages(this.lineaseleccionada);
        }
        this.currentPage = maxPages;
        if (this.currentPage > 0 && this.currentPage <= maxPages) {
            this.gotoPage(this.currentPage, this.lineaseleccionada);
            this.disabledNextButton = true;
            this.disabledPreviousButton = false;
        }
    }
    handleButtonPrevious() {
        let nextPage = this.currentPage - 1;
        if (this.seBusco) {
            this.gotoPage(nextPage, this.pagedData);
        } else {
            this.gotoPage(nextPage, this.lineaseleccionada);
        }
    }
    handleButtonFirstPage() {
        this.currentPage = 1;
        if (this.seBusco) {
            this.gotoPage(1, this.filtrado(this.textoABuscar, this.lineaseleccionada));
        } else {
            this.gotoPage(1, this.lineaseleccionada);
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
                this.pagedData = this.filtrado(this.textoABuscar, this.lineaseleccionada).slice(
                    recordStartPosition,
                    recordEndPosition
                );
            } else {
                this.pagedData = arrayParsear.slice(recordStartPosition, recordEndPosition);
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
            let inputVal = event.target.value;
            if (!isFinite(inputVal)) {
                event.target.value = inputVal.toString().slice(0, -1);
            }
            let registrosMostrados = event.target.value;
            this.delayTimeout = setTimeout(() => {
                this.pageSize = registrosMostrados;
                this.getMaxPages(this.lineaseleccionada);
                this.gotoPage(1, this.lineaseleccionada);
            }, 400);
        } catch (error) {
            console.log('Error en elegirMaxMostrados ', error);
        }
    }
    
    }