import { LightningElement } from 'lwc';

import GestionComercial from '@salesforce/label/c.GestionComercial';
import CausalesRetiroOC from '@salesforce/label/c.CausalesRetiroOC';
import ProformaOferta from '@salesforce/label/c.ProformaOferta';
import CreacionClientes from '@salesforce/label/c.CreacionClientes';
import ContratoUnificado from '@salesforce/label/c.ContratoUnificado';
import BusquedaIdServicio from '@salesforce/label/c.BusquedaIdServicio';
import ConsolidadoCartasVentas from '@salesforce/label/c.ConsolidadoCartasVentas';
import ExperienciaCliente from '@salesforce/label/c.ExperienciaCliente';
import ONLINE from '@salesforce/label/c.ONLINE';

export default class CustomLinks extends LightningElement {
    sfdcBaseURL;
    vGestionComercial;
    vCausalesRetiroOC;
    vProformaOferta;
    vCreacionClientes;
    vContratoUnificado;
    vBusquedaIdServicio;
    vConsolidadoCartasVentas;
    vExperienciaCliente;

    label = {
        GestionComercial,
        CausalesRetiroOC,
        ProformaOferta,
        CreacionClientes,
        ContratoUnificado,
        BusquedaIdServicio,
        ConsolidadoCartasVentas,
        ExperienciaCliente,
        ONLINE
    };

    renderedCallback() {
        this.sfdcBaseURL = window.location.origin;
        this.vGestionComercial = this.sfdcBaseURL + "/" + GestionComercial;
        this.vCausalesRetiroOC = this.sfdcBaseURL + "/" + CausalesRetiroOC;
        this.vProformaOferta = this.sfdcBaseURL + "/" + ProformaOferta;
        this.vCreacionClientes = this.sfdcBaseURL + "/" + CreacionClientes;
        this.vContratoUnificado = this.sfdcBaseURL + "/" + ContratoUnificado;
        this.vBusquedaIdServicio = this.sfdcBaseURL + "/" + BusquedaIdServicio;
        this.vConsolidadoCartasVentas = this.sfdcBaseURL + "/" + ConsolidadoCartasVentas;
        this.vExperienciaCliente = this.sfdcBaseURL + "/" + ExperienciaCliente;
    } 
}