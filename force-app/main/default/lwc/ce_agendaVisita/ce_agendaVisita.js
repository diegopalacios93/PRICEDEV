/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez, Brisleydi Calderón
Proyecto: ETB DE Experiencia
Descripción: LWC para los agendamientos asociados a los casos de soporte técnico  
 
Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     05/11/2021      Raúl Andrés Gómez Ramírez, Brisleydi Calderón   
***************************************************************************************************/
import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';
import { loadStyle } from 'lightning/platformResourceLoader';

import TOAST_CSS from '@salesforce/resourceUrl/ce_agendaVisita';

import orquestarIntegracion from '@salesforce/apex/CE_ConstruirCanonicoScheduleRemedy_cls.orquestarIntegracion';

import ID_SISTEMA_LEGADO_FIELD from '@salesforce/schema/Case.Id_Sistema_Legado__c';

import SCHEDULE_OBJECT from '@salesforce/schema/CE_Schedule__c';
import CASE_FIELD from '@salesforce/schema/CE_Schedule__c.CE_ScheduleCase__c';
import VISIT_INPUT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_VisitDateInput__c';
import ZONE_FIELD from '@salesforce/schema/CE_Schedule__c.CE_ZoneInput__c';
import TYPE_INPUT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_RequestTypeInput__c';
import TIME_FIELD from '@salesforce/schema/CE_Schedule__c.CE_TimeZoneInput__c';
import GROUP_INPUT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_GroupInput__c';
import WORK_SKILL_FIELD from '@salesforce/schema/CE_Schedule__c.CE_WorkSkillInput__c';
import ACTION_TYPE_FIELD from '@salesforce/schema/CE_Schedule__c.CE_ActionType__c';
import REQUEST_OBSERVATION_FIELD from '@salesforce/schema/CE_Schedule__c.CE_RequestObservation__c';
import TIME_FORMAT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_TimeFormat__c';
import GROUP_LABEL_FIELD from '@salesforce/schema/CE_Schedule__c.CE_XAGrupoEtiqueta__c';
import ID_SCHEDULE_FIELD from '@salesforce/schema/CE_Schedule__c.CE_ScheduleIdOutput__c';
import TYPE_OUTPUT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_RequestTypeOutput__c';
import STATUS_FIELD from '@salesforce/schema/CE_Schedule__c.CE_StatusOutput__c';
import PROCESS_STATUS_FIELD from '@salesforce/schema/CE_Schedule__c.CE_SchedulingProcessStatusOutput__c';
import SUB_STATUS_FIELD from '@salesforce/schema/CE_Schedule__c.CE_SubStatusOutput__c';
import GROUP_OUTPUT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_AssignedGroupOutput__c';
import VISIT_OUTPUT_FIELD from '@salesforce/schema/CE_Schedule__c.CE_ScheduleConfirmedDateOutput__c';
import ID_TASK_FIELD from '@salesforce/schema/CE_Schedule__c.CE_TaskId__c';
import TECHNICIAN_IDS_FIELD from '@salesforce/schema/CE_Schedule__c.CE_AssignedTechnicianIds__c'
import TECHNICIAN_NAMES_FIELD from '@salesforce/schema/CE_Schedule__c.CE_AssignedTechnicianNames__c'
import INCOME_SUPPORTS_FIELD from '@salesforce/schema/CE_Schedule__c.CE_IncomeSupports__c'

import ALERTA_AGENDAMIENTO from '@salesforce/label/c.CE_AlertaAgendamiento';
import AGENDAMIENTO_ALERTA from '@salesforce/label/c.CE_AgendamientoExitosoAlerta';
import AGENDAMIENTO_EXITOSO from '@salesforce/label/c.CE_AgendamientoExitoso';
import AGEND_EXI_RESP_MESSAGE from '@salesforce/label/c.CE_AgendExitosoRespMessage';

const camposCaso = [ID_SISTEMA_LEGADO_FIELD];

export default class Ce_agendaVisita extends NavigationMixin(LightningElement) {
    //Campos asociados al objeto Caso
    @api recordId;
    idSistemaLegado;
    //Objeto Agendamiento/CE_ScheduleCase__c
    objectApiName = SCHEDULE_OBJECT;
    //Campos asociados al objeto Agendamiento diligenciados en Salesforce
    caseField = CASE_FIELD;
    visitInputField = VISIT_INPUT_FIELD;
    zoneField = ZONE_FIELD;
    typeInputField = TYPE_INPUT_FIELD;
    timeField = TIME_FIELD;
    groupInputField = GROUP_INPUT_FIELD;
    workSkillField = WORK_SKILL_FIELD;
    actionTypeField = ACTION_TYPE_FIELD;
    requestObservationField = REQUEST_OBSERVATION_FIELD;
    groupLabelField = GROUP_LABEL_FIELD;
    timeFormatField = TIME_FORMAT_FIELD;
    //Campos asociados al objeto Agendamiento diligenciados en ETA
    idScheduleField = ID_SCHEDULE_FIELD;
    typeOutputField = TYPE_OUTPUT_FIELD;
    statusField = STATUS_FIELD;
    processStatusField = PROCESS_STATUS_FIELD;
    subStatusField = SUB_STATUS_FIELD;
    groupOutputField = GROUP_OUTPUT_FIELD;
    visitOutputField = VISIT_OUTPUT_FIELD;
    idTaskField = ID_TASK_FIELD;
    technicianIdsField = TECHNICIAN_IDS_FIELD;
    technicianNamesField = TECHNICIAN_NAMES_FIELD;
    incomeSupportsField = INCOME_SUPPORTS_FIELD;
    //Etiquetas personalizadas
    label = {
        ALERTA_AGENDAMIENTO,
        AGENDAMIENTO_EXITOSO,
        AGENDAMIENTO_ALERTA,
        AGEND_EXI_RESP_MESSAGE
    };
    //Response de la integración con ETA
    responseMessage;
    //Control de CSS para TOAST
    isCssLoaded = false;
    //Deshabilitación de los botones del formulario
    disabledButton = false;
    //Habilitación de spinner de carga cuando se envía el formulario
    isRendering = false;

    /**
     * @description se obtiene la información necesaria asociada al caso de soporte técnico en pantalla
     */
    @wire(getRecord, { recordId: '$recordId', fields: camposCaso })
    caso({data, error}){
        if (data) {
            this.idSistemaLegado = getFieldValue(data, ID_SISTEMA_LEGADO_FIELD);
        } else if (error) {
            this.idSistemaLegado = null;
        }
    }

    /**
     * @description getter para saber si el caso asociado ya posee el Id sistema legado otorgado por Remedy y mostrar el formulario del 
     * agendamiento
     */
    get sistemaLegado() {
        if (this.idSistemaLegado != null && this.idSistemaLegado != '') {
            return true;
        }
        else {
            return false;
        }
    }

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
     * @description método para reiniciar los diferentes campos del formulario que estén asociados a la clase "ResetField" en el HTML
     */
    handleReset() {
        const inputFields = this.template.querySelectorAll(
            '.ResetField'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    /**
    * @description método para procesar los mensajes de error generados por validaciones del sistema y mostrarlos de forma ordenada al 
    * usuario
    */
    handleError(event) {
        this.isRendering = false;
        let mensajeError;
        if (event.detail.output.errors != null) {
            let arregloErrores = reduceErrors(event.detail.output.errors);
            mensajeError = arregloErrores[0];
            for (let i = 1; i < arregloErrores.length; i++) {
                mensajeError = mensajeError + '\n' + arregloErrores[i];
            }
        }
        else {
            mensajeError = event.detail.message;
        }
        const toast = new ShowToastEvent({
            variant: 'error',
            title: 'Aviso',
            message: mensajeError,
            mode: 'sticky',
        });
        this.dispatchEvent(toast);
        this.disabledButton = false;
    }

    /**
     * @description lógica para hacer el reseteo completo del formulario en caso tal de que haya sido exitosa la creación del agendamiento
     * y redirigirlo al registro creado
     */
    handleSuccess(event) {
        this.handleReset();
        this.isRendering = false;
        let successMessage;
        //Se valida si el agendamiento es programado sin alerta
        if(this.responseMessage.DetalleEstado === this.label.AGEND_EXI_RESP_MESSAGE){
            successMessage = this.label.AGENDAMIENTO_EXITOSO;
        }
        else{
            successMessage = this.label.AGENDAMIENTO_ALERTA;
        }
        const toast = new ShowToastEvent({
            variant: 'success',
            title: 'Agenda creada',
            message: successMessage,
            mode: 'sticky',
        });
        this.dispatchEvent(toast);
        //Redirección a la página del registro de agendamiento creado
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: this.objectApiName,
                actionName: 'view',
            },
        });
        this.disabledButton = false;
    }

    /**
    * @description lógica para procesar la respuesta del consumo al servicio web del orquestador de ETA, validar si se puede crear o no
    * el agendamiento y en caso tal completar la información traída desde ETA para dicha creación
    */
    afterCallout(fields) {
        /*Se valida si se creó el agendamiento en ETA o no. En caso de que sí se hace llenado de la información complementaria traída
        por ETA a los campos ocultos en el formulario*/
        if (!this.responseMessage.Codigo.startsWith("F") && !this.responseMessage.Codigo.startsWith("f")) {
            fields.CE_ScheduleIdOutput__c = this.responseMessage.IdAgenda;
            fields.CE_StatusOutput__c = this.responseMessage.Estado;
            fields.CE_SchedulingProcessStatusOutput__c = this.responseMessage.EstadoProcesadoAgendamiento;
            let fechaEntrega = new Date(this.responseMessage.FechaHoraAgendaConfirmada);
            fields.CE_ScheduleConfirmedDateOutput__c = fechaEntrega.toISOString();
            fields.CE_AssignedGroupOutput__c = this.responseMessage.GrupoAsignado;
            fields.CE_SubStatusOutput__c = this.responseMessage.SubEstado;
            fields.CE_RequestTypeOutput__c = this.responseMessage.TipoSolicitud;
            fields.CE_TaskId__c = this.responseMessage.IdTareaCreadaRemedy;
            fields.CE_AssignedTechnicianIds__c = this.responseMessage.CedulasTecnicos;
            fields.CE_AssignedTechnicianNames__c = this.responseMessage.TecnicosAsignados;
            fields.CE_IncomeSupports__c = this.responseMessage.SoportesIngreso;
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
        else {
            this.isRendering = false;
            const toast = new ShowToastEvent({
                variant: 'warning',
                title: 'Agenda no creada',
                message: this.responseMessage.DetalleEstado,
                mode: 'sticky',
            });
            this.dispatchEvent(toast);
            this.disabledButton = false;
        }
    }

    /**
    * @description lógica para el procesamiento de la información sumistrada en el formulario para hacer el consumo al servicio web del 
    * orquestador de ETA y validar si se puede realizar el agendamiento o no
    */
    handleSchedule(event) {
        this.disabledButton = true;
        this.isRendering = true;
        //Se previene la creación por defecto desde el formulario
        event.preventDefault();
        const fields = event.detail.fields;
        this.responseMessage = null;
        //Se obtiene la información diligenciada en el formulario por el usuario
        let scheduleFields = {'date' : fields.CE_VisitDateInput__c, 
                        'timeSlot' : fields.CE_TimeZoneInput__c , 
                        'resourceId' : fields.CE_GroupInput__c ,
                        'aworkzone' : fields.CE_ZoneInput__c , 
                        'XA_Grupo' : fields.CE_XAGrupoEtiqueta__c,
                        'XA_request_type' : fields.CE_RequestTypeInput__c,
                        'XA_Zone' : fields.CE_GroupInput__c ,
                        'WorkSkill' : fields.CE_WorkSkillInput__c,
                        'XA_Action_Type' : fields.CE_ActionType__c,
                        'XA_Description' : fields.CE_RequestObservation__c.replace(/([&<>])/g,'y'),
                        'timeFormat' : fields.CE_TimeFormat__c}
        //Llamado al servicio web de ETA
        orquestarIntegracion({ scheduleForm : scheduleFields , caseID : this.recordId}).then(response => {
            this.responseMessage = response;
            this.afterCallout(fields);
        }).catch(error => {
            this.isRendering = false;
            let mensajeError;
            if (error.message == undefined) {
                let arregloErrores = reduceErrors(error);
                mensajeError = arregloErrores[0];
                for (let i = 1; i < arregloErrores.length; i++) {
                    mensajeError = mensajeError + '\n' + arregloErrores[i];
                }
            }
            else {
                mensajeError = error.message;
            }
            const toast = new ShowToastEvent({
                variant: 'error',
                title: 'Aviso',
                message: mensajeError,
                mode: 'sticky',
            });
            this.dispatchEvent(toast);
            this.disabledButton = false;
        });
    }
}