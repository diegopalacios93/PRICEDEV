import { LightningElement, api, track } from 'lwc';
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

// const FIELDSELECTION = {"label":"", "value": "vlocity_cmt__RecurringCharge__c"}

const FORMATTER = new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP' });

export default class etbTableManageDiscount extends OmniscriptBaseMixin(LightningElement) {
    _ns = getNamespaceDotNotation();
    @api sumrecurringtotal;
    @api sumtotaloriginal;
    @api quoteline;	
    @api quoteid;
    @track maxData = 0;
    spinnerActive = false; 
    lineaseleccionada = [];
    noValues = true;
    //Variables paginador y buscador
    textoABuscar = "";
    @track pagedData = [];  //Esta variable va a ser la que se coloque en las filas del datatable.
    currentPage = 1;
    maxPages = 1;
    pageSize = 25; //cantidad de registros que entran por pagina
    disabledPreviousButton = false;
    disabledNextButton = false;
    seBusco = false;
    @track isDiscount = false;
    @track rawAmount = '';
    totalDiscount = '';


    connectedCallback() {               
        this.cambiarSpinner(); //activo
        this.getData(false);      
        try {
            this.showTotalDiscount(this.sumrecurringtotal,this.sumtotaloriginal);
            this.rawAmount = FORMATTER.format(this.sumrecurringtotal).replace('$','COP');
            this.totalDiscount = FORMATTER.format(this.sumtotaloriginal).replace('$','COP');
        } catch (error) {
            console.log('Ocurrio error en connected callback ', error);
        }
    }

    showTotalDiscount(totalUno, totalDos){
        if (totalUno == totalDos) {
            this.isDiscount = false;
        }else{
            this.isDiscount = true
        }
    }

    get optionsPage() {
        return [
            { label: '1', value: 1 },
            { label: '5', value: 5 },
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
    
    get showTable() {
        return true;
    }
    get lengthLineasSeleccionadas() {
        return true;
    }

    cambiarSpinner() {
        try {
            this.spinnerActive = !this.spinnerActive;
        } catch (error) {
            console.log('Ocurrio un error en cambiarSpinner ', error);
        }
    }

    showToast(title, message, variant){
        const toastEvent = new ShowToastEvent({
            title : title,
            message : message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    getData(fromLWC) {
        try {

                if (fromLWC) {
                    try {
                        const input = {
                            quoteid: this.quoteid
                        };
                        const options = {
                            chainable: true
                        };
                        const params = {
                            input: JSON.stringify(input),
                            sClassName: `IntegrationProcedureService`,
                            sMethodName: 'etb_ManageDiscount',
                            options: JSON.stringify(options)
                        };
                        this.omniRemoteCall(params, false).then((response) => {

                                this.lineaseleccionada = response.result.IPResult.Items.map((record) => {
                                    return {
                                        ...record,
                                        'buttonEnabled': response.result.IPResult.Items.RecurringCharge == 0 && response.result.IPResult.Items.RecurringCost == 0 ? true : false,
                                        'isOk': true,
                                        'errorMessage': ''
                                    }
                                });
                                for (let index = 0; index < this.lineaseleccionada.length; index++) {
                                    if (this.lineaseleccionada[index].ManualPricing) {                                        
                                        if (this.lineaseleccionada[index].RecurringCharge == 0 && this.lineaseleccionada[index].RecurringCost == 0 && this.lineaseleccionada[index].DiscountToApply == 0) {
                                            this.lineaseleccionada[index].ManualPricing = false
                                        }
                                    }
                                }
                                this.maxData = this.lineaseleccionada.length;
                                this.getMaxPages(this.lineaseleccionada);  //lineaseleccionada es el array que tiene todo.
                                this.gotoPage(1, this.lineaseleccionada);
                                this.noValues = this.lineaseleccionada.length > 0;
                                this.showTotalDiscount(response.result.IPResult.sumRecurringTotal,response.result.IPResult.sumTotalOriginal);
                                this.rawAmount = FORMATTER.format(response.result.IPResult.sumRecurringTotal).replace('$','COP');
                                this.cambiarSpinner(); //desactivado
                            })
                            .catch((error) => {
                                window.console.log(error, 'error');
                            });
                                    
                    } catch (error) {
                        console.log('Error en getData ', error);
                    }
                }else{
                    this.lineaseleccionada = this.quoteline.map((record) => {
                        return {
                            ...record,
                            'buttonEnabled': false,
                            'isOk': true,
                            'errorMessage': ''
                        }
                    });
                    for (let index = 0; index < this.lineaseleccionada.length; index++) {
                        if (this.lineaseleccionada[index].ManualPricing) {                                        
                            if (this.lineaseleccionada[index].RecurringCharge == 0 && this.lineaseleccionada[index].RecurringCost == 0 && this.lineaseleccionada[index].DiscountToApply == 0) {
                                this.lineaseleccionada[index].ManualPricing = false
                            }
                        }
                    }
                    this.maxData = this.lineaseleccionada.length;
                    this.getMaxPages(this.lineaseleccionada);  //lineaseleccionada es el array que tiene todo.
                    this.gotoPage(1, this.lineaseleccionada);
                    this.noValues = this.lineaseleccionada.length > 0;
                    this.cambiarSpinner(); //desactivado
                }

        } catch (error) {
            console.log('Error en getData ', error);
        }
    }

    handleChangeDesc(event){
        const valueInput = event.target.value;
        const itemIndex = event.currentTarget.dataset.index; 
        const maxIptDsc = this.pagedData[itemIndex].MaxInputDiscount; 
        let status = event.target.validity.valid
        if(!status){
            this.pagedData[itemIndex].buttonEnabled = true;
            this.pagedData[itemIndex].isOk = false;
            this.pagedData[itemIndex].errorMessage = event.target.validationMessage;

        }else{
            this.pagedData[itemIndex].DiscountToApply = valueInput;
            this.pagedData[itemIndex].buttonEnabled = false;
            this.pagedData[itemIndex].isOk = true;
            this.pagedData[itemIndex].errorMessage = '';
        }

    }
    

    //Metodos Buscador
    delayTimeout = setTimeout(() => { });
    handleKeyUp(event) {
        window.clearTimeout(this.delayTimeout);
        const textoBuscado = event.target.value.toLowerCase();
        this.textoABuscar = event.target.value.toLowerCase();
        this.delayTimeout = setTimeout(() => {
            if (textoBuscado.length > 0) {
                this.seBusco = true;
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

    handleClick(event){
        const itemIndex = event.currentTarget.dataset.index; 
        const inputValue = Number(this.pagedData[itemIndex].DiscountToApply)*-1;
        const idQLI = this.pagedData[itemIndex].Id;
        this.cambiarSpinner();//activo
        try {
            const input = {
                quoteId: this.quoteid,
                quoteLineItemId: idQLI,
                discRate: inputValue
            };
            const options = {
                chainable: true
            };
            const params = {
                input: JSON.stringify(input),
                sClassName: `IntegrationProcedureService`,
                sMethodName: 'etb_ApplyDiscount',
                options: JSON.stringify(options)
            };
            this.omniRemoteCall(params, false).then((response) => {
                    if (response.result.IPResult && response.result.IPResult != null) {
                        let recVal = 0;
                        let title = '';
                        let message = '';
                        let variant = '';                       
                        if (!(response.result.IPResult.deleteExecuted) && !(response.result.IPResult.addExecuted)) {
                            title = 'No hay descuentos a aplicar';
                            message = 'Por favor, ingrese un valor de descuento a aplicar.';
                            variant = 'info'
                            this.showToast(title,message,variant);
                        }else if (response.result.IPResult.deleteExecuted && !(response.result.IPResult.addExecuted)) {
                            title = 'Descuento eliminado';
                            message = 'Descuento eliminado exitosamente.';
                            variant = 'success'
                            this.showToast(title,message,variant);
                        }else if (!(response.result.IPResult.deleteExecuted) && response.result.IPResult.addExecuted) {
                            recVal = FORMATTER.format(response.result.IPResult.NewRecurringPriceAdd).replace('$','COP');
                            title = 'Descuento aplicado';
                            message = `Descuento del ${inputValue}% aplicado exitosamente: ${recVal}`;
                            variant = 'success'
                            this.showToast(title,message,variant);
                        }else if (response.result.IPResult.deleteExecuted && response.result.IPResult.addExecuted) {
                            recVal = FORMATTER.format(response.result.IPResult.NewRecurringPriceAdd).replace('$','COP');
                            title = 'Descuento actualizado';
                            message = `Descuento del ${inputValue}% actualizado exitosamente: ${recVal}`;
                            variant = 'success'
                            this.showToast(title,message,variant);
                        }else{
                            title = 'Error';
                            message = 'Ha ocurrido un error';
                            variant = 'error'
                            this.showToast(title,message,variant);
                        }
                        this.getData(true);
                    }
                })
                .catch((error) => {
                    let title = 'Error';
                    let message = 'Ha ocurrido un error';
                    let variant = 'error'
                    this.showToast(title,message,variant);
                    this.cambiarSpinner();//desactivado
                    window.console.log(error, 'error');
                });
                        
        } catch (error) {
            console.log('Error en getData ', error);
            this.cambiarSpinner();//desactivado
        }
    }
}