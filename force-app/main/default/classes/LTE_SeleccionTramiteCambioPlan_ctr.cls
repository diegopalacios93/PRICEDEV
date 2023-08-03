/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia 
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de selección del Trámite 

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-11-26      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_SeleccionTramiteCambioPlan_ctr {
    
    private Apexpages.Standardcontroller stdController;
    public Case objCaso                                         {get; set;}
    public List<TOPP__c> lstTipoOperacion                       {get; set;}
    public List<SelectOption> items                             {get; set;}
    public List<SelectOption> types                             {get; set;}
    public Boolean blnBotonContinuar                            {get; set;}
    public String tipoOperacion                                 {get; set;}
    public String tipoTramite                                   {get; set;}
    public String strTOPPId                                     {get; set;}
    public Boolean blnDisabled                                  {get; set;}
    
    private Map<string,VariablesGlobales__c> vGlobal;
    public Map<Id,TOPP__c> mapTipoOperacion;
    private Map<string, LTE_Tipos_SubTOPP__c> mapSubTOPP;
    
    /** 
    * Constructor del controlador encargado de inicializar las variables
    * y hacer unas validaciones iniciales.
    */
    public LTE_SeleccionTramiteCambioPlan_ctr(ApexPages.StandardController stdController){
        
        List<Case> lstCasos = new  List<Case>();
        
        this.stdController      = stdController;
        this.objCaso            = (Case)stdController.getRecord();
        this.blnBotonContinuar  = true;
        this.mapSubTOPP         = LTE_Tipos_SubTOPP__c.getAll();
        this.blnDisabled        = true;
        this.items              = new List<SelectOption>(); 
        this.types              = new List<SelectOption>(); 
        
        lstCasos = [SELECT AccountId, CaseNumber, ContactId, Status, Aprobaciones__c  FROM Case WHERE Id =: objCaso.Id];
        
        if(lstCasos.isEmpty()){
            this.blnBotonContinuar = false;
            System.debug('======> Error inesperado, no se encontro ningun registro para el numero de caso: ' + objCaso.Id);
            return;
        } else{
            this.objCaso = lstCasos.get(0);
            if(this.objCaso.AccountId == null || String.isEmpty(this.objCaso.AccountId)){
                this.blnBotonContinuar = false;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Caso_Sin_Cliente));
                return;
            } 
            
            if(this.objCaso.Status == 'Cerrado' || this.objCaso.Status == 'Cancelado'){
                this.blnBotonContinuar = false;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Caso_Cerrado));
                return;
            } 
        }
        
        items = obtenerItems();
        if(!items.isEmpty()){
            this.tipoOperacion = items.get(0).getValue();
            obtenerSubTOPP();
        }
    }
    
    /**
    * Metodo encargado de consultar el listado de las operaciones a mostrar
    * en la lista de seleccion.
    */
    public List<SelectOption> obtenerItems() {
        this.vGlobal    = VariablesGlobales__c.getAll();
        String producto = vGlobal.get('NombreComercialLTE').valor__c;
        
        if(mapTipoOperacion == null){
            mapTipoOperacion = new Map<Id,TOPP__c>();
        }
        
        this.lstTipoOperacion = [SELECT Id, Name, Tipoderegistro__c From TOPP__c Where LTE_Catalogo_de_Producto__r.Name =: producto And DisponibleVentainicial__c = false And LTE_Parte_caso__c = true
                                    ORDER BY Name ASC];
        
        List<SelectOption> lstOpcionesTipoOperacion = new List<SelectOption>();
        
        if(!this.lstTipoOperacion.isEmpty())
        {
            mapTipoOperacion = new Map<Id,TOPP__c>(lstTipoOperacion);
            
            for(TOPP__c objTipoOperacion : this.lstTipoOperacion)
            {
                lstOpcionesTipoOperacion.add(new SelectOption(objTipoOperacion.Id, objTipoOperacion.Name));                
            }
        }
        
        return lstOpcionesTipoOperacion;
    }
    
    
    public void obtenerSubTOPP(){
        this.types = new List<SelectOption>(); 
        for(LTE_Tipos_SubTOPP__c tipoSubTOPP : mapSubTOPP.values()){
            //System.Debug('Name: ' + tipoSubTOPP.Name + 'TOPP__c: ' + tipoSubTOPP.TOPP__c + 'Sub_TOPP__c: ' + tipoSubTOPP.Sub_TOPP__c + 'URL__c: ' + tipoSubTOPP.URL__c);
            if(mapTipoOperacion.get(this.tipoOperacion).Name == tipoSubTOPP.TOPP__c && tipoSubTOPP.Disponible_postventa__c){
                this.types.add(new SelectOption(tipoSubTOPP.Sub_TOPP__c, tipoSubTOPP.Sub_TOPP__c));
            }
        }
        
        if(types.isEmpty()){
            blnDisabled = true;
        } else{
            blnDisabled = false;
        }
    }

    
    
    /**
    * Metodo ecargado de redireccionar hacia otra pagina.
    */
    public PageReference continuar()
    {
        String url;
        String aprobacion;
        System.debug('\n\n=============================');
        System.debug('\n\n' + mapTipoOperacion );
        System.debug('\n\n=============================');
        //Obtenemos la URL hacia donde sera redirigida la pagina
        for(LTE_Tipos_SubTOPP__c objTipoSubTOPP : mapSubTOPP.values()){
            System.debug('============ Entro al FOR');
            System.debug('============ ' + mapTipoOperacion.get(this.tipoOperacion).Name + ' == ' + objTipoSubTOPP.TOPP__c);
            System.debug('============ ' + this.tipoTramite + ' == ' + objTipoSubTOPP.Sub_TOPP__c);
            if(mapTipoOperacion.get(this.tipoOperacion).Name == objTipoSubTOPP.TOPP__c && this.tipoTramite != null && this.tipoTramite == objTipoSubTOPP.Sub_TOPP__c){
                url = objTipoSubTOPP.URL__c;
                System.debug('============ url: ' + url);
            }
        }

        if( mapTipoOperacion.get(this.tipoOperacion).Name == 'Cambio de Plan- TELEFONIA MOVIL (LTE)'){
            if(this.objCaso.Aprobaciones__c != null){
                aprobacion = this.objCaso.Aprobaciones__c;
            } else{
                aprobacion = '';
            }
            
            PageReference prServiciosCambioPlan;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<estadoAprobacion>>', aprobacion);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            
            if(this.tipoTramite == 'Troncal SIP'){
                prServiciosCambioPlan = new PageReference(url);
                prServiciosCambioPlan.setRedirect(true);
                return prServiciosCambioPlan;
            } else{
                //Validamos el estado  de la aprobacion del caso
                if(String.isEmpty(this.objCaso.Aprobaciones__c) || this.objCaso.Aprobaciones__c == 'Inicial' || this.objCaso.Aprobaciones__c == 'Oferta Realizada'){
                    prServiciosCambioPlan = new PageReference(url);
                    prServiciosCambioPlan.setRedirect(true);
                    return prServiciosCambioPlan;
                }
                
                if(this.objCaso.Aprobaciones__c == 'Enviado a aprobación'){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.LTE_Caso_Enviado_Aprobacion));
                    return null;
                }
                
                if(this.objCaso.Aprobaciones__c == 'Aprobado'){
                    PageReference prAprovisionarAprobar = Page.LTE_AprovisionarAprobarTramite_pag;
                    prAprovisionarAprobar.getParameters().put('idCaso', this.objCaso.Id);
                    prAprovisionarAprobar.setRedirect(true);
                    return prAprovisionarAprobar;
                }
                
                if(this.objCaso.Aprobaciones__c == 'Rechazado'){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.LTE_Caso_Rechazado));
                    return null; 
                }
                
                if(this.objCaso.Aprobaciones__c == 'Enviado aprovisionamiento'){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.LTE_Caso_Enviado_Aprovisionamiento));
                    return null; 
                }
                
                return null; 
            }
        } 
        //MHPG - 28/12/2015
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Suspensión- TELEFONIA MOVIL (LTE)')
        {
            PageReference prSuspensionVoluntaria;
            
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            url = url.replaceAll('<<strTipo>>', this.tipoTramite);
            prSuspensionVoluntaria = new PageReference(url);
            prSuspensionVoluntaria.setRedirect(true);
            return prSuspensionVoluntaria;
        } 
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Cambio Número- TELEFONIA MOVIL (LTE)')
        {
            PageReference prServiciosCambioNumero;
            
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prServiciosCambioNumero = new PageReference(url);
            prServiciosCambioNumero.setRedirect(true);
            return prServiciosCambioNumero;
        }
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Modificación Servicio- TELEFONIA MOVIL (LTE)')
        {
            PageReference prServiciosModificacioServicio;
            
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prServiciosModificacioServicio = new PageReference(url);
            prServiciosModificacioServicio.setRedirect(true);
            return prServiciosModificacioServicio;
        }
        //MHPG - 25/01/2015 
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Reconexión- TELEFONIA MOVIL (LTE)')
        {
            PageReference prReconexionVoluntaria;
            
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            url = url.replaceAll('<<strTipo>>', this.tipoTramite);
            prReconexionVoluntaria = new PageReference(url);
            prReconexionVoluntaria.setRedirect(true);
            return prReconexionVoluntaria;          
        }
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Adición SVA- TELEFONIA MOVIL (LTE)')
        {
            PageReference prAdicionSVA_BolsaRecurrente;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prAdicionSVA_BolsaRecurrente = new PageReference(url);
            prAdicionSVA_BolsaRecurrente.setRedirect(true);
            return prAdicionSVA_BolsaRecurrente;            
        }
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Retiro SVA- TELEFONIA MOVIL (LTE)')
        {
            PageReference prRetiroSVA_BolsaRecurrente;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            url = url.replaceAll('<<tipoTramite>>', this.tipoTramite);
            prRetiroSVA_BolsaRecurrente = new PageReference(url);
            prRetiroSVA_BolsaRecurrente.setRedirect(true);
            return prRetiroSVA_BolsaRecurrente;
        }
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == Label.LTETipoOperacionGestionIMEI)
        {
            PageReference prGestionIMEI;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            url = url.replaceAll('<<SubTOPP>>', this.tipoTramite);            
            
            prGestionIMEI = new PageReference(url);
            system.debug(url);
            prGestionIMEI.setRedirect(true);
            return prGestionIMEI;
        }
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Gestion APN/IP- TELEFONIA MOVIL (LTE)')
        {
            PageReference prReconexionVoluntaria;
            
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            url = url.replaceAll('<<strTipo>>', this.tipoTramite);
            prReconexionVoluntaria = new PageReference(url);
            prReconexionVoluntaria.setRedirect(true);
            return prReconexionVoluntaria;          
        }
        //[FSARASTY, 2020/05/01]: Bolsas compartidas
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Adición bolsa compartida- TELEFONIA MOVIL (LTE)')
        {
            PageReference prAdicionBolsaCompartida;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prAdicionBolsaCompartida = new PageReference(url);
            prAdicionBolsaCompartida.setRedirect(true);
            return prAdicionBolsaCompartida;            
        }
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Reducción bolsa compartida- TELEFONIA MOVIL (LTE)')
        {
            PageReference prAdicionBolsaCompartida;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prAdicionBolsaCompartida = new PageReference(url);
            prAdicionBolsaCompartida.setRedirect(true);
            return prAdicionBolsaCompartida;            
        }        
        //[FSARASTY, 2020/09/01]: Adición trámite Modificación estándar 
        else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Modificación Estándar- TELEFONIA MOVIL (LTE)')
        {
            PageReference prModificacionEstandar;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prModificacionEstandar = new PageReference(url);
            prModificacionEstandar.setRedirect(true);
            return prModificacionEstandar;            
        }
		else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Conversión Demo a Venta- TELEFONIA MOVIL (LTE)')
        {           
            PageReference prConversionDemoaVenta;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prConversionDemoaVenta = new PageReference(url);
            prConversionDemoaVenta.setRedirect(true);
            return prConversionDemoaVenta;
        }
		else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Ampliación de Tiempo Demo- TELEFONIA MOVIL (LTE)')
        {
            PageReference prAmpliacionTiempoDemo;
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            prAmpliacionTiempoDemo = new PageReference(url);
            prAmpliacionTiempoDemo.setRedirect(true);
            return prAmpliacionTiempoDemo;
        } else if(mapTipoOperacion.get(this.tipoOperacion).Name == 'Modificación periodo de suspensión voluntaria- TELEFONIA MOVIL (LTE)'){
            PageReference prModificacionSuspensionVoluntaria;
            
            url = url.replaceAll('<<caseNumber>>', this.objCaso.CaseNumber);
            url = url.replaceAll('<<idAccount>>', this.objCaso.AccountId);
            url = url.replaceAll('<<idCase>>', this.objCaso.Id);
            url = url.replaceAll('<<idContact>>', this.objCaso.ContactId);
            url = url.replaceAll('<<idTOPP>>', this.tipoOperacion);
            url = url.replaceAll('<<strTipo>>', this.tipoTramite);
            prModificacionSuspensionVoluntaria = new PageReference(url);
            prModificacionSuspensionVoluntaria.setRedirect(true);
            return prModificacionSuspensionVoluntaria;
        }else{
            return null;
        }
        
    }
    
}