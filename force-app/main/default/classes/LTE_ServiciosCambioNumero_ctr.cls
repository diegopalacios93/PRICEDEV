/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de servicios de cambio de numero

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-01-22      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_ServiciosCambioNumero_ctr {
    
    private Apexpages.Standardcontroller stdController;
    public Reserva__c objReservaHomogeneo                       {get; set;}
    public Boolean blnBuscar                                    {get; set;}
    public Boolean blnBotonRegresar                             {get; set;}
    public Boolean blnBloqueServicios                           {get; set;}
    public Boolean blnBotonGuardar                              {get; set;}
    public Boolean blnBotonCerrar                               {get; set;}
    public Boolean esM2M										{get; set;}
    public Map<Id, Boolean> esM2MMap							{get; set;}
    public String numerosConexion                               {get; set;}
    public String numeroCaso                                    {get; set;}
    public List<ActivoETB__c> lstActivos                        {get; set;}
    public Id idPrimerActivo 									{get; set;}
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
    
    private Map<string,VariablesGlobales__c> vGlobal;
    
    /**
    * Constructor del controlador
    */
    public LTE_ServiciosCambioNumero_ctr(ApexPages.StandardController stdController){
        this.stdController = stdController;
        this.blnBuscar = true;
        this.blnBotonRegresar = false;
        this.blnBloqueServicios = false;
        this.blnBotonGuardar = false;
        this.blnBotonCerrar = false;
        this.esM2M = false;
        this.esM2MMap = new Map<Id, Boolean>();
        this.objReservaHomogeneo = new Reserva__c();
        this.numerosConexion = '';
        this.idCase = ApexPages.currentPage().getParameters().get('idCase');
        this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
        this.idContact = ApexPages.currentPage().getParameters().get('idContact');
        this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
        this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
        this.vGlobal = VariablesGlobales__c.getAll();
        
        this.lstActivos = new List<ActivoETB__c>();
        
        if(this.idCase == null){
            System.debug('=======> El parametro LTECambioNumero.idCase llego nulo o vacio a la pantalla de seleccion de servicios de cambio de numero');
            parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
            return;
        }
        
        if(this.idAccount == null){
            System.debug('=======> El parametro LTECambioNumero.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de cambio de numero.');
            parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
            return;
        }
        
        if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
            System.debug('=======> El parametro LTECambioNumero.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de cambio de numero.');
            parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
            return;
        }
        
        List<Contact> lstContactos = new  List<Contact>();
        lstContactos = [SELECT Id, LTE_RolLTE__c FROM Contact WHERE Id = :this.idContact];
        System.debug('=======> ' + lstContactos);
        if(lstContactos.isEmpty()){
            System.debug('=======> El caso no tiene un Contacto (Contact) asociado.');
            parametroInvalido(Label.LTE_Caso_Sin_Contacto);
            return;
        }
        
        if(!validaRolCambioNumero(lstContactos.get(0).LTE_RolLTE__c)){
            System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTECambioNumero').valor__c+' en el Rol LTE.');
            parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
            return;
        }
    }
    
    /**
    * Metodo encargado de validar si el rol del contacto del caso cumple con los
    * roles almacenados en al configuracion personalizada.
    */
    public Boolean validaRolCambioNumero(String rolContacto){
        String rolesLTE;
        String[] rolesLTESeparados;
        list<String> lstRolesLTE;
        
        if(String.isEmpty(rolContacto)){
            return false;
        }
        
        rolesLTE = vGlobal.get('RolLTECambioNumero').valor__c;
        rolesLTESeparados = rolesLTE.split(',');
        lstRolesLTE = new list<String>(rolesLTESeparados);
        
        for(String rol : lstRolesLTE){
            if(rolContacto.trim() == rol.trim()){
                return true;
            }
        }
        
        return false;
    }
    
    /**
    * Metodo ecargado de buscar los servicios asociados al numero de conexion digitado.
    */
    public PageReference buscar()
    {
        Boolean ocEnVuelo = false;
        
        if(numerosConexion == null || numerosConexion.trim().length() == 0 ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Digitar_Numero_Conexion_Cambio_Numero));
            return null;
        }
        
        this.blnBloqueServicios = true;
        
        String producto = vGlobal.get('NombreComercialLTE').valor__c;
        
        
        for(ActivoETB__c activo : [   
        SELECT Estado__c,Id,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,NumeroConexion__c,Plan__r.NombredelProducto__r.Name, Contrato__c, Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, IMEI_del_Equipo__c, LTE_ICCID__c, (select name,Estado__c,TOPP__r.TipodeOperacionporplan__c,TipoSeleccion__c, CreatedDate from Operaciones_Comerciales__r where Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento') ORDER BY CreatedDate DESC) 
        FROM ActivoETB__c 
        WHERE NombredelaCuenta__c = :this.idAccount 
		AND Plan__r.NombredelProducto__r.Name = :producto 
		AND Plan__r.TipodePlan__c != 'Troncal SIP' 
		AND NumeroConexion__c = :numerosConexion 
        AND Estado__c = 'Activo' Order By Name /*limit 100*/]) {
            if(this.idPrimerActivo == null) {
                this.idPrimerActivo = activo.Id;
            }
            
            this.esM2MMap.put(activo.Id, false); 
            this.lstActivos.add(activo);
        }
        
        if(this.lstActivos.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
            this.blnBotonGuardar = false;
        } else {
            Datetime dt = null;
            if(lstActivos.size() > 1) {
                for(Integer i = 1; i < lstActivos.size(); i++) {
					for(OperacionComercial__c oc : lstActivos[i].Operaciones_Comerciales__r) {
                        if(oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio Número') {
                            if(dt == null) {
                                dt = oc.CreatedDate;
                                this.esM2MMap.put(lstActivos[i].Id, oc.TipoSeleccion__c == 'M2M');
                            } else if(dt > oc.CreatedDate) {
                                dt = oc.CreatedDate;
                                this.esM2MMap.put(lstActivos[i].Id, oc.TipoSeleccion__c == 'M2M');
                            }
                        }
                    }
                }
            }
            
            dt = null;
            for(OperacionComercial__c oc : lstActivos.get(0).Operaciones_Comerciales__r){
                if(oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio Número') {
                    if(dt == null) {
                        dt = oc.CreatedDate;
                        this.esM2MMap.put(lstActivos.get(0).Id, oc.TipoSeleccion__c == 'M2M');
                    } else if(dt > oc.CreatedDate) {
                        dt = oc.CreatedDate;
                        this.esM2MMap.put(lstActivos.get(0).Id, oc.TipoSeleccion__c == 'M2M');
                    }
                    
                    ocEnVuelo = true;
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LTE_OC_Cambio_Numero_En_Vuelo + ' ' + numerosConexion));
                    break;
                }
            }
            if(ocEnVuelo){
                this.blnBotonGuardar = false;
            } else{
                this.blnBotonGuardar = true;
            }
        }
        
        return null;
    }
    
    /**
    * Metodo encargado de generar la Operacion Comercial para el tramite de
    * cambio de numero.
    */
    public PageReference guardar(){
        List<TOPP__c> lstTOPP = new List<TOPP__c>();
        List<RecordType> lstRecordType = new list<RecordType>();
        
        lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE id = :this.idTOPP];
        
        if(lstTOPP.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_TOPP_No_Encontrado));
            return null;
        }
        
        lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            
        if(lstRecordType.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
            return null;
        }  
        
        Savepoint sp = Database.setSavepoint();
        try{
            OperacionComercial__c objOC = new OperacionComercial__c();
            objOC.CuentaCliente__c = this.idAccount;
            objOC.Activo__c = lstActivos.get(0).Id;
            objOC.NumeroConexion__c = lstActivos.get(0).NumeroConexion__c;  
            objOC.Plan__c = lstActivos.get(0).Plan__c;
            objOC.TOPP__c = this.idTOPP;
            objOC.Estado__c = 'En Curso';
            objOC.RecordTypeId = lstRecordType.get(0).Id;
            objOC.Caso__c = this.idCase;
            objOC.TipoSeleccion__c = this.esM2MMap.get(lstActivos.get(0).Id) ? 'M2M' : null;
            //objOC.ValorTarifaPlan__c = dcmValorTotal;
            objOC.CuentaFacturacion__c = lstActivos.get(0).CuentaFacturacion__c;
            objOC.IMEI_del_Equipo__c = lstActivos.get(0).IMEI_del_Equipo__c;
            objOC.LTE_ICCID__c = lstActivos.get(0).LTE_ICCID__c;
            objOC.FechaInicioReconexion__c = Date.today();
            insert objOC;
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objOC: ' + objOC.Id));
            
            crearInfoCambioNumero(lstActivos.get(0).Id);
            this.blnBotonGuardar = false;
            this.blnBuscar = false;
            this.blnBotonCerrar = true;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.LTE_Proceso_Exitoso));
            return null;
        } catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
            Database.rollback(sp);
            System.Debug('====================== EXCEPCION ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=======================================================');
            return null;
        }
        
    }
    
    public void cambiarCheckboxM2M() {
        Boolean esM2M = this.esM2MMap.get(this.lstActivos.get(0).Id);
        this.esM2MMap.put(this.lstActivos.get(0).Id, !esM2M);
    }

    /**
    * Metodo encargado de regresar a la pagina de seleccion de tramines para el
    * proceso de cambio de plan.
    */
    public PageReference regresar(){
        PageReference returnPage = Page.LTE_SeleccionTramiteCambioPlan_pag;
        returnPage.getParameters().put('scontrolCaching', '1');
        returnPage.getParameters().put('id', this.idCase);
        returnPage.setRedirect(true);
        return returnPage;      
    }
    
    /**
    * Metodo encargado de no mostrar y ocultar los botones necesario en caso
    *  que halla uno parametro nulo, adicionalmente muestra un mensaje indicando
    *  que ocurrio un error.
    */
    private void parametroInvalido(String mensaje){
        this.blnBotonRegresar = true;
        this.blnBuscar = false;
        this.blnBloqueServicios = false;
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, mensaje));
    }
    
    
    /**
    * Metodo encargado de crear el parametro CAMBIO DE NUMERO? el cual no existia en fase 1 
    * Solo se creara si este parametro no existia
    */
    public void crearInfoCambioNumero(string idAc){
        
        list<LTE_Servicios_adicionales__c> servaAd=new list<LTE_Servicios_adicionales__c>([SELECT Id,LTE_ServiceActionCode__c,Name,LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,LTE_ServicioETB__r.Plan__r.Name,LTE_DetalleOfertaEReservadoRegContable__c,
            (select id,Name,LTE_ActionCode__c from SpecificationGroupXA__r)
            FROM LTE_Servicios_adicionales__c Where LTE_ServicioETB__c = :idAc and Name='NUMERO TELEFONICO LTE' limit 1]);
        
        map<string,LTE_SpecificationGroupXA__c> spGXmap=new map<string,LTE_SpecificationGroupXA__c>();
            
        if(!servaAd.isEmpty()){
            
            for(LTE_SpecificationGroupXA__c spGX: servaAd[0].SpecificationGroupXA__r){
                spGXmap.put(spGX.Name,spGX);            
            }   

            if(spGXmap.get('CAMBIO DE NUMERO?')==null){
                LTE_SpecificationGroupXA__c sGroupXA=new LTE_SpecificationGroupXA__c(
                LTE_ActionCode__c='ADD',
                Name='CAMBIO DE NUMERO?',
                LTE_Value__c='YES',
                LTE_ServiciosAdicionales__c=servaAd[0].id
                );
                insert sGroupXA;
            }
            
            if(spGXmap.get('Numero Anterior LTE')==null){
                LTE_SpecificationGroupXA__c sGroupXA=new LTE_SpecificationGroupXA__c(
                LTE_ActionCode__c='ADD',
                Name='Numero Anterior LTE',
                LTE_Value__c=lstActivos.get(0).NumeroConexion__c,
                LTE_ServiciosAdicionales__c=servaAd[0].id
                );
                insert sGroupXA;
            }
        }
    
    }
    
}