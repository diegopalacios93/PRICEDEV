import { LightningElement, track, api } from "lwc";
import dateRangePickerLibrary from "@salesforce/resourceUrl/deg_DateRangePicker";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";

import sendDate from "@salesforce/apex/DEG_DatePicker_ctr.sendDate";
import sendDateRange from "@salesforce/apex/DEG_DatePicker_ctr.sendDateRange";
import cancelDate from "@salesforce/apex/DEG_DatePicker_ctr.cancelDate";
import cancelDateRange from "@salesforce/apex/DEG_DatePicker_ctr.cancelDateRange";

let contextJS = {};

export default class deg_datepicker extends LightningElement {
  @track showSaveDate = false;
  @track showModal = true;
  @track isDateRangePicker = false;
  @api days;
  @api datesLst;
  @api sessionId;
  @api token;
  @track requestInput = {};
  @track dateVisita = "";

  DatePickerPluginInitialized = false;

  connectedCallback() {
    contextJS = this;

    this.requestInput.tokenWhatson = '';
    this.requestInput.sessionId = window.sessionIdWatson;

    contextJS.showModal = true;
    contextJS.showSaveDate = false;
    //en caso de que especifique los dias es un un DateRangePicker
    if (this.days != null && this.days !== "") {
      this.isDateRangePicker = true;
    }

    if (this.DatePickerPluginInitialized) {
      return;
    }

    this.DatePickerPluginInitialized = true;

    // first load jquery file
    Promise.all([
      loadScript(this, dateRangePickerLibrary + "/jquery-3.6.0.min.js"),
      loadScript(this, dateRangePickerLibrary + "/moment.min.js")
    ])
      .then(() => {
        Promise.all([
          loadStyle(this, dateRangePickerLibrary + "/daterangepicker.css"),
          loadScript(this, dateRangePickerLibrary + "/daterangepicker.js"),
          loadScript(this, dateRangePickerLibrary + "/generateChatResponse.js")

        ])
          .then(() => {
            if (this.isDateRangePicker) {
              this.enableDateRangePicker(this.days);
            } else {
              this.enableDatePicker(this.datesLst);
            }
          })
          .catch((error) => {
            throw error;
          });
      })
      .catch((error) => {
        throw error;
      });
  }

  cancelDate() {
    this.showModal = false;
    if (this.isDateRangePicker) {
      cancelDateRange({ requestInput: this.requestInput })
        .then((result) => {
          console.log(result);
        })
        .catch((error) => {
          console.log(error);
        });
    } else {
      cancelDate({ requestInput: this.requestInput })
        .then((result) => {
          console.log(result);
        })
        .catch((error) => {
          console.log(error);
        });
    }
    window.postMessage('awaitForDB', '*');
  }

  validateDate() {
    if (this.isDateRangePicker) {
      sendDateRange({ requestInput: this.requestInput })
        .then((result) => {
          console.log(result);
        })
        .catch((error) => {
          console.log(error);
        });
    } else {
      sendDate({ requestInput: this.requestInput })
        .then((result) => {
          console.log(result);
        })
        .catch((error) => {
          console.log(error);
        });
    }
    this.showModal = false;
  }

  enableDateRangePicker(maxDays) {
    let dateElement = this.template.querySelector("input[data-id=dataRange]");
    window.$(dateElement).daterangepicker(
      {
        minDate: new Date(),
        opens: "left",
        autoApply: false,
        startDate: moment(),
        maxSpan: {
          days: maxDays
        },
        locale: {
          format: "YYYY/MM/DD",
          separator: " - ",
          applyLabel: "Aplicar",
          cancelLabel: "Cancelar",
          fromLabel: "From",
          toLabel: "To",
          customRangeLabel: "Custom",
          weekLabel: "W",
          daysOfWeek: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sá"],
          monthNames: [
            "Enero",
            "Febrero",
            "Marzo",
            "Abril",
            "Mayo",
            "Junio",
            "Julio",
            "Agosto",
            "Septiembre",
            "Octubre",
            "Noviembre",
            "Diciembre"
          ],
          firstDay: 1
        }
      },
      function (start, end) {
        contextJS.requestInput.dateini = start.format("YYYY-DD-MM");
        contextJS.requestInput.dateend = end.format("YYYY-DD-MM");
        contextJS.requestInput.days = end.diff(start, "days");
        contextJS.showSaveDate = true;
      }
    );
  }
  enableDatePicker(objeto) {
    const fechas = objeto;
    // objeto.forEach((element) => fechas.push(element));
    const dateElement = this.template.querySelector(
      "input.chatbot-pratech-aside-input"
    );
    window.$(dateElement).daterangepicker(
      {
        singleDatePicker: true,
        showDropdowns: true,
        isInvalidDate: function (date) {
          var formatted = date.format("YYYY-MM-DD");
          return fechas.indexOf(formatted) < false;
        },
        minDate: new Date(),
        opens: "left",
        startDate: moment(),
        locale: {
          format: "DD/MM/YYYY",
          separator: " / ",
          applyLabel: "Aplicar",
          cancelLabel: "Cancelar",
          fromLabel: "From",
          toLabel: "To",
          customRangeLabel: "Custom",
          weekLabel: "W",
          daysOfWeek: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sá"],
          monthNames: [
            "Enero",
            "Febrero",
            "Marzo",
            "Abril",
            "Mayo",
            "Junio",
            "Julio",
            "Agosto",
            "Septiembre",
            "Octubre",
            "Noviembre",
            "Diciembre"
          ],
          firstDay: 1
        }
      },
      function (start) {
        contextJS.requestInput.dateVisita = start.format("YYYY-DD-MM");
        contextJS.showSaveDate = true;
      }
    );
  }
}