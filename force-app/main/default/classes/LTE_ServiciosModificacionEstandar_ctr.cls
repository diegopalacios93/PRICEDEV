/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Fernando Sarasty
Proyecto:           Evolutivos
Descripción:        Controlador para la Ventana de servicios de modificación estándar

Cambios (Versiones)
--------------------------------------
----    ----------      --------------              ---------------
1.0     2020-09-01      Fernando Sarasty            Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_ServiciosModificacionEstandar_ctr {
    
    private Apexpages.Standardcontroller stdController;
    public Boolean blnBuscar                                    {get; set;}
    public Boolean blnBotonRegresar                             {get; set;}
    public Boolean blnBloqueServicios                           {get; set;}
    public Boolean blnBotonGuardar                              {get; set;}
    public Boolean blnBotonCerrar                               {get; set;}
    public String numerosConexion                               {get; set;}
    public String numeroCaso                                    {get; set;}
    public List<ActivoETB__c> lstActivos                        {get; set;}
    private Id idCase;
    private Id idAccount;
    private Id idContact;
    private Id idTOPP;
    public String strDetalleTramite {get;set;}
    public List<SelectOption> lstDetalleTramite {get;set;}
    
    private Map<string,VariablesGlobales__c> vGlobal;
    
    /**
    * Constructor del controlador
    */
    public LTE_ServiciosModificacionEstandar_ctr(ApexPages.StandardController stdController){
        this.stdController = stdController;
        this.blnBuscar = true;
        this.blnBotonRegresar = false;
        this.blnBloqueServicios = false;
        this.blnBotonGuardar = false;
        this.blnBotonCerrar = false;
        this.numerosConexion = '';
        this.idCase = ApexPages.currentPage().getParameters().get('idCase');
        this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
        this.idContact = ApexPages.currentPage().getParameters().get('idContact');
        this.numeroCaso = ApexPages.currentPage().getParameters().get('caseNumber');
        this.idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
        this.vGlobal = VariablesGlobales__c.getAll();
        
        this.lstActivos = new List<ActivoETB__c>();
        
        if(this.idCase == null){
            System.debug('=======> El parametro LTEModificacionServicio.idCase llego nulo o vacio a la pantalla de seleccion de servicios de modificacion servicio');
            parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
            return;
        }
        
        if(this.idAccount == null){
            System.debug('=======> El parametro LTEModificacionServicio.idAccount llego nulo o vacio a la pantalla de seleccion de servicios de modificacion servicio.');
            parametroInvalido(Label.LTE_Servicios_Cambio_Plan_Parametro_Invalido);
            return;
        }
        
        if(this.numeroCaso == null || this.numeroCaso.trim().length() == 0){
            System.debug('=======> El parametro LTEModificacionServicio.caseNumber llego nulo o vacio a la pantalla de seleccion de servicios de modificacion servicio.');
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
            System.debug('=======> La cuenta asociada al caso no tiene un nivel '+vGlobal.get('RolLTEModificacionEstandar').valor__c+' en el Rol LTE.');
            parametroInvalido(Label.LTE_Cliente_Sin_Rol_LTE);
            return;
        }
        
        List<TOPP__c> listTOPP = [SELECT Id,Detalle_del_tramite__c FROM TOPP__c WHERE Id = :this.IdTOPP];
        if(listTOPP.size()>0){
            lstDetalleTramite = new List<SelectOption>();
            lstDetalleTramite.add(new SelectOption('' ,'Seleccione...'));
            if(String.isNotEmpty(listTOPP[0].Detalle_del_tramite__c)){
                String sDetalles = listTOPP[0].Detalle_del_tramite__c;
                list<String> lstDetalles = sDetalles.split(';');
                for(String strKey : lstDetalles )
                {
                    lstDetalleTramite.add(new SelectOption(strKey ,strKey));       
                }
            }
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
        
        rolesLTE = vGlobal.get('RolLTEModificacionEstandar').valor__c;
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
        
        this.lstActivos = [SELECT Estado__c,Id,IDServicio__c,Name,NombredelaCuenta__c,Nombredelcliente__c,Plan__c,ExternalServiceID__c,NumeroConexion__c,Plan__r.Name,Plan__r.NombredelProducto__r.Name, Contrato__c, Contrato__r.LTE_Contrato_negociado__c, CuentaFacturacion__c, CuentaFacturacion__r.LTE_CicloFacturacion__c, IMEI_del_Equipo__c, LTE_ICCID__c, (select name,Estado__c,TOPP__r.TipodeOperacionporplan__c  from Operaciones_Comerciales__r where Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento')) 
        FROM ActivoETB__c 
        WHERE NombredelaCuenta__c = :this.idAccount 
		AND Plan__r.NombredelProducto__r.Name = :producto 
		AND Plan__r.TipodePlan__c = 'Troncal SIP' 
		//AND Plan__r.Estado__c != 'Inactivo' 
		AND NumeroConexion__c = :numerosConexion 
		AND Estado__c = 'Activo' Order By Name /*limit 100*/];
        
        if(this.lstActivos.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.LTE_Numero_Conexion_Sin_Registros));
            this.blnBotonGuardar = false;
        } else{
            for(OperacionComercial__c oc : lstActivos.get(0).Operaciones_Comerciales__r){
                //if(oc.TOPP__r.TipodeOperacionporplan__c == 'Modificación Servicio'){
                    ocEnVuelo = true;
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LTE_OC_Cambio_Numero_En_Vuelo + ' ' + numerosConexion));
                    break;
                //}
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
        String producto = vGlobal.get('NombreComercialLTE').valor__c;
        
        if(String.isEmpty(strDetalleTramite)){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El detalle del tramite no puede estar vacio'));
            return null;
        }
        
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
            objOC.IDServicio__c = lstActivos.get(0).IDServicio__c; 
            objOC.Plan__c = lstActivos.get(0).Plan__c;
            objOC.TOPP__c = this.idTOPP;
            objOC.Estado__c = 'En Curso';
            objOC.Detalle_del_tramite__c = strDetalleTramite;
            objOC.RecordTypeId = lstRecordType.get(0).Id;
            objOC.Caso__c = this.idCase;
            //objOC.ValorTarifaPlan__c = dcmValorTotal;
            objOC.CuentaFacturacion__c = lstActivos.get(0).CuentaFacturacion__c;
            objOC.IMEI_del_Equipo__c = lstActivos.get(0).IMEI_del_Equipo__c;
            objOC.LTE_ICCID__c = lstActivos.get(0).LTE_ICCID__c;
            objOC.FechaInicioReconexion__c = Date.today();
            insert objOC;
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objOC: ' + objOC.Id));
            
            List<LTE_Servicios_adicionales__c> lstSVA = new List<LTE_Servicios_adicionales__c>();
            List<SubPlanFacturacion__c> subPlanes = [SELECT Id, Name FROM SubPlanFacturacion__c WHERE Name = 'COBRO UNICA VEZ LTE'];
            
            for(SubPlanFacturacion__c sglSbPlan:subPlanes){
                LTE_Servicios_adicionales__c newSVA = new LTE_Servicios_adicionales__c();
                newSVA.Name = sglSbPlan.Name;
                newSVA.LTE_Operacion_Comercial_SVA__c = objOC.Id;
                newSVA.LTE_OC_Tramite__c = objOC.Id;
                newSVA.LTE_ServicioETB__c = lstActivos.get(0).Id;
                newSVA.LTE_ServiceActionCode__c = 'NONE';
                newSVA.LTE_SubPlaFacturacion__c = sglSbPlan.Id;
                lstSVA.add(newSVA);
                
                if(!lstSVA.isEmpty())
                    insert lstSVA;
            }
            
            
	    	LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
			set<Id> setIdOcs = new set<Id>();
			
			setIdOcs.add(objOC.Id);
			
			// Parametrizar Servicios adicionales y  generar XA's
			LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcs,'OCSVA');
			
			// Actualizar servicios adicionales
			update wrData.servAD; 	
			
			// Insertar XA's
			insert wrData.SpgXA;

            List<LTE_Servicios_adicionales__c> lstSVAupd = [SELECT Id,Name FROM LTE_Servicios_adicionales__c WHERE LTE_ServicioETB__c = :lstActivos.get(0).Id AND LTE_ServiceActionCode__c != 'DELETE' AND LTE_ServiceActionCode__c != 'ELIMINADO' AND (Name = :lstActivos.get(0).Plan__r.Name OR Name = :producto OR LTE_PlanFacturacion__c != null OR LTE_SubPlaFacturacion__c != null OR (Name = 'COBRO UNICA VEZ LTE' AND LTE_OC_Tramite__c = :objOC.Id))];
            for(LTE_Servicios_adicionales__c sglSVAupd:lstSVAupd){
                sglSVAupd.LTE_Operacion_Comercial_SVA__c = objOC.Id;
                sglSVAupd.LTE_OC_Tramite__c = objOC.Id;
                if(sglSVAupd.Name == producto){
                    sglSVAupd.LTE_ServiceActionCode__c = 'UPDATE';
                }else if(sglSVAupd.Name == 'COBRO UNICA VEZ LTE'){
                    sglSVAupd.LTE_ServiceActionCode__c = 'DELETE';
                }else{
                    sglSVAupd.LTE_ServiceActionCode__c = 'NONE';
                }
            }
            
            update lstSVAupd;
            
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
    
}