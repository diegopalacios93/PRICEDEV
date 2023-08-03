import { api, track, LightningElement } from 'lwc';

export default class etb_AssetDetailsChild extends LightningElement {
    @api noHayDatos;
    @api showTable;
    @api maxData;
    @track pagedData = []; //Esta variable va a ser la que se coloque en las filas del datatable.
    data = [];
    pageSize = 10; //cantidad de registros que entran por pagina
    currentPage = 1;
    seBusco = false;
    textoABuscar = "";
    disabledNextButton = false;
    disabledPreviousButton = false;
    delayTimeout = setTimeout(() => { });


    @api
    get records() {
        return this.pagedData;
    };

    set records(value) {
        this.pagedData = value.slice();
        this.data = this.pagedData.slice();
    }
    get optionsPage() {
        return [
            { label: '1', value: 1 },
            { label: '10', value: 10 },
            { label: '25', value: 25 },
        ];
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

    connectedCallback() {
        console.log(this.pagedData);
        console.log(this.showTable);
        this.getMaxPages(this.pagedData);
        this.gotoPage(1, this.pagedData);
    }

    handleKeyUp(event) {
        window.clearTimeout(this.delayTimeout);
        const textoBuscado = event.target.value.toLowerCase();
        this.textoABuscar = event.target.value.toLowerCase();
        this.delayTimeout = setTimeout(() => {
            if (textoBuscado.length > 0) {
                this.seBusco = true;
                let arrayFiltrado = this.filtrado(textoBuscado, this.data);
                this.getMaxPages(arrayFiltrado);
                this.gotoPage(1, arrayFiltrado);
            } else {
                this.getMaxPages(this.data);
                this.gotoPage(1, this.data);
                this.seBusco = false;
            }
        }, 300);
    }
    handleButtonNext() {
        let nextPage = this.currentPage + 1;
        if (this.seBusco) {
            this.gotoPage(nextPage, this.pagedData);
        } else {
            this.gotoPage(nextPage, this.data);
        }
    }
    handleButtonLastPage() {
        let maxPages = 0;
        if (this.seBusco) {
            maxPages = this.getMaxPages(this.filtrado(this.textoABuscar, this.data));
        } else {
            maxPages = this.getMaxPages(this.data);
        }
        this.currentPage = maxPages;
        if (this.currentPage > 0 && this.currentPage <= maxPages) {
            this.gotoPage(this.currentPage, this.data);
            this.disabledNextButton = true;
            this.disabledPreviousButton = false;
        }
    }
    handleButtonPrevious() {
        let nextPage = this.currentPage - 1;
        if (this.seBusco) {
            this.gotoPage(nextPage, this.pagedData);
        } else {
            this.gotoPage(nextPage, this.data);
        }
    }
    handleButtonFirstPage() {
        this.currentPage = 1;
        if (this.seBusco) {
            this.gotoPage(1, this.filtrado(this.textoABuscar, this.data));
        } else {
            this.gotoPage(1, this.data);
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
        if (this.showTable) {
            let recordStartPosition, recordEndPosition;
            let maximumPages = this.maxPages;
            this.disabledPreviousButton = false;
            this.disabledNextButton = false;
            if (arrayParsear && !this.noHayDatos) {
                recordStartPosition = this.pageSize * (pageNumber - 1);
                recordEndPosition = recordStartPosition + parseInt(this.pageSize, 10);
                if (this.seBusco) {
                    this.pagedData = this.filtrado(this.textoABuscar, this.data).slice(
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
                this.getMaxPages(this.data);
                this.gotoPage(1, this.data);
            }, 400);
        } catch (error) {
            console.log("Error en elegirMaxMostrados ", error);
        }
    }

    filtrado(textoBuscado, array) {
        let nuevoArreglo = [];
        let buscaText = textoBuscado.toString();
        array.forEach((e) => {
            if (e.AssetName.toString().toLowerCase().includes(buscaText)) {
                nuevoArreglo.push(e);
            }
        });
        return nuevoArreglo;
    }
}