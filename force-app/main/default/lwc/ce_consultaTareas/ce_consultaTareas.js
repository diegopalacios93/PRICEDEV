/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia
Descripción: LWC para la consulta de tareas y de su respectiva información en Remedy asociadas al caso
 
Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     14/12/2021      Raúl Andrés Gómez Ramírez      
***************************************************************************************************/
import { LightningElement, api, wire } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';

import TOAST_CSS from '@salesforce/resourceUrl/ce_agendaVisita';

import CATEGORIA_INVALIDA from '@salesforce/label/c.CE_CategoriaCasoInvalida';
import CATEGORIA_INCIDENTE from '@salesforce/label/c.CE_CasoCategoriaIncidente';
import CATEGORIA_REQUERIMIENTO from '@salesforce/label/c.CE_CasoCategoriaRequerimiento';

import obtenerTareas from '@salesforce/apex/CE_ConsultarTareasRemedy_cls.obtenerTareas';
import actualizarAgenda from '@salesforce/apex/CE_ConsultarTareasRemedy_cls.actualizarAgenda';

import SCHEDULE_OBJECT from '@salesforce/schema/CE_Schedule__c';
import CATEGORY_FIELD from '@salesforce/schema/Case.Categoria_legado__c';
import ID_SISTEMA_LEGADO_FIELD from '@salesforce/schema/Case.Id_Sistema_Legado__c';

//Acciones para el detalle de cada fila del data table
const actions = [
    { label: 'Ver Detalle', name: 'detalle' },
];

//Columnas designadas para el data table
const columns = [
    { label: 'Id Tarea', fieldName: 'TaskID', hideDefaultActions: true },
    { label: 'Grupo Asignado', fieldName: 'GrupoAsignado', hideDefaultActions: true },
    { label: 'Estado Tarea Remedy', fieldName: 'Estado', hideDefaultActions: true },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];

//Campos asociados al objeto caso
const caseFields = [CATEGORY_FIELD, ID_SISTEMA_LEGADO_FIELD];

export default class Ce_consultaTareas extends NavigationMixin(LightningElement) {
    //Objeto Agendamiento/CE_ScheduleCase__c
    objectApiName = SCHEDULE_OBJECT;
    //Campos asociados al objeto Caso
    @api recordId;
    idSistemaLegado;
    caseCategory;
    //Asignación de columnas para el data table
    columns = columns;
    //Habilitación de spinner de carga mientras se muestra la información en pantalla
    isRendering = true;
    //Habilitación de spinner de carga cuando se consulta la información de una fila
    isRendering2 = false;
    //Variable de control para saber si es un caso con la categoría adecuada para el consumo del servicio
    validCase = false;
    //Valores a mostrar en el data table
    tableValues = [];
    //Mensajes de error
    errorMessage;
    //Todos los valores obtenidos del servicio asociados al caso
    allTableValues = [];
    //Contador de registros a mostrar e ir adicionando
    counter = 10;
    //Etiquetas personalizadas
    label = {
        CATEGORIA_INVALIDA,
        CATEGORIA_INCIDENTE,
        CATEGORIA_REQUERIMIENTO
    };
    //Control de CSS para TOAST
    isCssLoaded = false;

    /**
     * @description método para asignar un css especial al Toast y que se puedan mostrar todos los mensajes de error en diferentes líneas
     * de texto
     */
     renderedCallback() {
        if (this.isCssLoaded) return
        this.isCssLoaded = true;
        loadStyle(this, TOAST_CSS);
    }

    /**
     * @description método para obtener todas las tareas asociadas al caso
     */
    getTasks() {
        obtenerTareas({ sistemaLegado: this.idSistemaLegado, caseId: this.recordId }).then(schedules => {
            this.allTableValues = schedules;
            this.tableValues = schedules.slice(0, this.counter);
            this.errorMessage = undefined;
            this.isRendering = false;
        }).catch(err => {
            this.errorMessage = reduceErrors(err);
            this.tableValues = undefined;
            this.caseCategory = undefined;
            this.isRendering = false;
        });
    }

    /**
     * @description se valida si el caso corresponde a una categoría adecuada y en caso de que sí se procede a realizar el consumo del
     * servicio para mostrar en un data table los valores obtenidos correspondientes a las tareas en Remedy asociadas al caso
     */
    @wire(getRecord, { recordId: '$recordId', fields: caseFields })
    caso({ data, error }) {
        if (data) {
            this.idSistemaLegado = getFieldValue(data, ID_SISTEMA_LEGADO_FIELD);
            this.caseCategory = getFieldValue(data, CATEGORY_FIELD);
            //Se valida que el caso sea de categoría "Incidente" o "Requerimiento"
            if (this.caseCategory === this.label.CATEGORIA_INCIDENTE || this.caseCategory === this.label.CATEGORIA_REQUERIMIENTO) {
                this.validCase = true;
                //Se obtienen los registros consumiendo el servicio
                this.getTasks();
            } else {
                this.validCase = false;
                this.isRendering = false;
            }
        } else if (error) {
            this.validCase = true;
            this.caseCategory = undefined;
            this.errorMessage = reduceErrors(error);
            this.tableValues = undefined;
            this.isRendering = false;
        }
    }

    /**
     * @description método para cargar más información en el data table de los registros de las tareas en Remedy obtenidas a medida
     * que el usuario hace scroll en la página
     */
    loadMoreData(event) {
        //Muestra un spinner para la carga de datos
        event.target.isLoading = true;
        //Se valida si ya se mostraron en pantalla todos los registros obtenidos
        if (this.tableValues >= this.allTableValues) {
            event.target.enableInfiniteLoading = false;
        } else {
            //Se aumenta el contador para mostrar más registros en pantalla en el data table
            this.counter = this.counter + 30;
            this.tableValues = this.allTableValues.slice(0, this.counter);
        }
        event.target.isLoading = false;
    }

    /**
     * @description getter para controlar la altura del data table según el número de registros que haya en pantalla
     */
    get dataTableHeight() {
        if (this.counter === 10) {
            return 'autoHeight';
        }
        else {
            return 'maxHeight';
        }
    }

    /**
     * @description método para obtener la información del agendamiento asociada a la tarea seleccionada
     */
    updateSchedule(rowDetail) {
        actualizarAgenda({ taskId : rowDetail.TaskID, caseId :  this.recordId}).then(response => {
            this.isRendering2 = false;
            const toast = new ShowToastEvent({
                variant: 'success',
                title: 'Consulta Exitosa',
                message: 'El registro ha sido actualizado exitosamente',
                mode: 'sticky',
            });
            this.dispatchEvent(toast);
            //Redirección a la página del registro de agendamiento asociado a la tarea
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: response,
                    objectApiName: this.objectApiName,
                    actionName: 'view',
                },
            });
        }).catch(err => {
            this.isRendering2 = false;
            let errMessage;
            if (err.message == undefined) {
                let errorArray = reduceErrors(err);
                errMessage = errorArray[0];
                for (let i = 1; i < errorArray.length; i++) {
                    errMessage = errMessage + '\n' + errorArray[i];
                }
            }
            else {
                errMessage = err.message;
            }
            const toast = new ShowToastEvent({
                variant: 'warning',
                title: 'Advertencia',
                message: errMessage,
                mode: 'sticky',
            });
            this.dispatchEvent(toast);
        });
    }

    /**
     * @description handler asociado al onrowaction del data table
     */
    getRowDetail(event) {
        this.isRendering2 = true;
        let rowDetail;
        const actionName = event.detail.action.name;
        const _rowDetail = event.detail.row;
        switch (actionName) {
            case 'detalle':
                //Se obtiene la información de la fila seleccionada en el data table
                rowDetail = this.tableValues.find(tableValue => tableValue.TaskID === _rowDetail.TaskID);
                this.updateSchedule(rowDetail);
                break;
            default:
        }
    }
}