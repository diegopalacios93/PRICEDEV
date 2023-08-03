/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Carlos Gonzalez
Proyecto:           LTE Evolutivos
Descripción:        Controlador para la Ventana de gestión de IMEI

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     31-05-2016  Carlos Gonzalez (CG)        Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_gestionIMEI_ctr 
{

    private static final String LTE_ServicioAdicional = 'LTE Customer Equipment Class';
    
    private Apexpages.Standardcontroller stdController;
    
    public String strNumeroIMEI {get;set;}
    
    public boolean blnDesbloqueo {get;set;}  
    
    public boolean blnConsultaXIMEI {get;set;} 
    
    public List<LTE_DetalleOferta__c> lstDetalleOferta {get;set;}   
    
    public List<DetalleWrapper> lstDetalleWrapper {get;set;}  
    
    public Boolean blnAllChecked {get;set;}
    
    public String strIdSelect {get;set;}
    
    private Id idAccount;
    
    private Id idCase;
    
    private Id idContact;
    
    public Boolean blnHabilitar {get;set;}
    
    public String strSubTOPP {get;set;}
    
    public String idTOPP {get;set;}
    
    public String strLabel1 {get;set;}
    
    public String strDoc {get;set;}
    
    public String strTipoDoc {get;set;}
    
    private Boolean blnPermiso = true;
    
    public List<SelectOption> lstTipDoc {get;set;}
    
    private List<OperacionComercial__c> lstOC_bch {get;set;}

    /**
    * Constructor del controlador
    */
    public LTE_gestionIMEI_ctr(ApexPages.StandardController stdController){
        this.stdController = stdController;
        blnPermiso = true;
        strDoc = '';
        strTipoDoc = '';
        blnHabilitar = false;
        blnConsultaXIMEI = false;
        strIdSelect = '';
        strSubTOPP = ApexPages.currentPage().getParameters().get('SubTOPP');
        idTOPP = ApexPages.currentPage().getParameters().get('idTOPP');
        strLabel1 = Label.LTE_Cambio_Plan_Num_Conexion;
        if(strSubTOPP!=null)
        {            
            blnDesbloqueo = (strSubTOPP.contains('Desbloquear IMEI') ? true : false );
            strSubTOPP = (blnDesbloqueo ? 'Desbloquear IMEI' : strSubTOPP );
            
            Profile[] lstURole = [SELECT Description,Name FROM Profile WHERE Id = : UserInfo.getProfileId() ];
            Map<String, PerfilDesbloqeoIMEI__c> mapPerfiles = PerfilDesbloqeoIMEI__c.getAll();
            
            if(!mapPerfiles.containsKey(lstURole[0].name))
            {
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error,'Perfil NO Autorizado'));                
                blnPermiso = false;
            }       
                        
        }
        else
        {
            blnDesbloqueo = true;
            strLabel1 = 'IMEI';
            blnConsultaXIMEI = true;
        }
                
        this.idAccount = ApexPages.currentPage().getParameters().get('idAccount');
        this.idCase = ApexPages.currentPage().getParameters().get('idCase');
        this.idContact = ApexPages.currentPage().getParameters().get('idContact');
        
         map<String,ValoresIntegracionTiposDocumento__c> mapValoresTipoDoc = ValoresIntegracionTiposDocumento__c.getAll();
         lstTipDoc = new List<SelectOption>();
         lstTipDoc.add(new SelectOption('' ,'Seleccione...'));
         for(String strKey : mapValoresTipoDoc.keySet() )
         {
            lstTipDoc.add(new SelectOption(mapValoresTipoDoc.get(strKey).Valor__c ,strKey));       
         }
         
    }
    
    /**
    * Constructor del batch
    */
    public LTE_gestionIMEI_ctr(List<OperacionComercial__c> scope)
    {
        
        lstDetalleWrapper = new List<DetalleWrapper>();
        lstOC_bch = scope;
        for(OperacionComercial__c objOC : lstOC_bch)
        {
            lstDetalleWrapper.add(
                new DetalleWrapper(objOC.Id, objOC.NumeroConexion__c, objOC.IMEI_del_Equipo__c, objOC.Activo__r.Name, objOC.Estado__c, true, true)
            );
        }
        
    }
    
    public void seleccionarTodos(){
        for(Integer i = 0; i < lstDetalleWrapper.size(); i++)
        {
            if(!lstDetalleWrapper[i].blnAplica)
                lstDetalleWrapper[i].blnSelect = blnAllChecked;
        }           
    }
    
    public void selectRecords(){
        for(Integer i = 0; i < lstDetalleWrapper.size(); i++)
        {
            //if(strIdSelect == lstDetalleWrapper[i].strId)
                //lstDetalleWrapper[i].blnSelect = (lstDetalleWrapper[i].blnSelect ? false : true);
        }     
    }

    public PageReference buscar()
    {
        List<String> lstNumeros = new List<String>();
        blnHabilitar = false;
        if(strNumeroIMEI.length() == 0)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Digitar_Numero_Conexion_Cambio_Numero));
            return null;
        }
         
        // SOLO UN IMEI        
        //for(String strIMEI : strNumeroIMEI.split(',') )
        //{
        //    lstNumeros.add(strIMEI); 
        //}
        
        if( lstNumeros.size() == 0)
        {
            lstNumeros.add(strNumeroIMEI);
        }
        
        lstDetalleWrapper = new List<DetalleWrapper>();
        
        if(!blnConsultaXIMEI)
        {
                       
            List<ActivoETB__c> lstActivoETB  = [SELECT Plan__c, CuentaFacturacion__c, LTE_DetalleOferta__r.Id, NumeroConexion__c, Name FROM ActivoETB__c WHERE NumeroConexion__c IN: lstNumeros 
                                                AND NombredelaCuenta__c =: idAccount ];
            
            List<Id> lstDetalleOfertaIds = new List<Id>();
            
            for(ActivoETB__c objTemp : lstActivoETB )
            {
                lstDetalleOfertaIds.add(objTemp.LTE_DetalleOferta__r.Id);
            }
            
            
            List<LTE_SpecificationGroupXA__c> lstLTE_Servicios_adicionales = [SELECT LTE_Value__c, 
                                                                            LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.Name,
                                                                            LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c  
                                                                            FROM LTE_SpecificationGroupXA__c 
                                                                            WHERE Name = 'IMEI' AND
                                                                            LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c IN: lstDetalleOfertaIds ];
            
            //lstDetalleOferta = [SELECT LTE_IMEI__c, Name FROM LTE_DetalleOferta__c WHERE LTE_IMEI__c IN: lstNumeroIMEI AND LTE_Cliente__c =: idAccount ];
            
            String strNumeroLin = '';
            String strActivo = '';
            Id idPlan;
            Id idCuentaFac;
            Id idActivo;
            for(LTE_SpecificationGroupXA__c objTemp : lstLTE_Servicios_adicionales )
            {
                strNumeroLin = '';
                strActivo = '';
                idPlan = null;
                idCuentaFac = null;
                idActivo = null;                
                for(ActivoETB__c objAC : lstActivoETB )
                {
                    if(objAC.LTE_DetalleOferta__r.Id == objTemp.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c)
                    {
                        strNumeroLin = objAC.NumeroConexion__c;
                        strActivo = objAC.Name;
                        idPlan = objAC.Plan__c;
                        idCuentaFac = objAC.CuentaFacturacion__c;
                        idActivo = objAC.Id;
                    }
                }
                
                DetalleWrapper tmpDetalle = new DetalleWrapper(objTemp.Id, strNumeroLin, objTemp.LTE_Value__c, strActivo, 'Sin Verificar', false, true);
                tmpDetalle.idPlan = idPlan;
                tmpDetalle.idCuentaFac = idCuentaFac;
                tmpDetalle.idActivo = idActivo;

                lstDetalleWrapper.add(tmpDetalle);
                blnHabilitar = true;
            }
            
            if(!blnHabilitar)
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'No se encontraron datos!'));
            }
            else
            {
                consultarEstado();
            }
            blnHabilitar = blnPermiso ; 
        }
        else
        {               
            lstDetalleWrapper.add(new DetalleWrapper('1', '', lstNumeros[0] , '', 'Sin Verificar', false, true));
            consultarEstado();
            blnHabilitar = false;
        }
        
        return null;
    }
    
    private void consultarEstado()
    {
        map<string,string> values=new map<string,string>();
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('ConsultaIMEI');    

        String request = '';
        String response  = ''; 
        for(Integer i = 0; i < lstDetalleWrapper.size(); i++)
        {
            request = reqConsultaBDO_XML(lstDetalleWrapper[i]);   
            response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
        
            System.debug('Request----> '+request);
            System.debug('Response----> '+response);
            
            tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            
            values=proReq.getMap(response);
            System.debug('Valores: ' + values);
            if(values.get('status')=='PASS')
            {                
                lstDetalleWrapper[i].strEstado = values.get('Estado');
                lstDetalleWrapper[i].strMarca = values.get('Marca');
                lstDetalleWrapper[i].strModelo = values.get('Modelo');
                lstDetalleWrapper[i].strCodigoError = values.get('CodigoError');
                lstDetalleWrapper[i].strDescripcionError = values.get('DescripcionError'); 
                lstDetalleWrapper[i].strCodRtaLst = values.get('CodigoRespuestaListas');
                lstDetalleWrapper[i].strRtaGSMA = values.get('RespuestaGSMA');
                lstDetalleWrapper[i].strRtaPruebaRedETB = values.get('RespuestaPruebaRedETB');
                lstDetalleWrapper[i].strProbadoETB = values.get('ProbadoRedETB');
                lstDetalleWrapper[i].strHomologadoColombia = values.get('HomologadoColombia');
                
                  
                if(lstDetalleWrapper[i].strCodRtaLst != null &&  lstDetalleWrapper[i].strCodRtaLst == '3' && blnPermiso )
                {
                    lstDetalleWrapper[i].blnAplica = false;
                }
            }else{
                lstDetalleWrapper[i].strEstado = 'Error en el llamado a TIBCO';
            }          
            
        }
    
    }

    private void desbloquear()
    {
        map<string,string> values=new map<string,string>();
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('DesbloqueoIMEI');    

        String request = '';
        String response  = ''; 
        for(Integer i = 0; i < lstDetalleWrapper.size(); i++)
        {
            if(lstDetalleWrapper[i].blnSelect)
            {                                    
                request = reqCancelaRegistroNegativo_XML(lstDetalleWrapper[i]);   
                response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
                
                System.debug('Request----> '+request);
                System.debug('Response----> '+response);
                
                tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
                
                values=proReq.getMap(response);
                
                lstDetalleWrapper[i].strRequest = request;
                lstDetalleWrapper[i].strResponse = response;
                
                if(values.get('status')=='PASS')
                {   String strEstado = values.get('RegistroNegativoResult');    
                    
                    LTE_Respuesta_Desbloqueo_IMEI__c objConfig = LTE_GestionIMEI_cls.getRespuestaDesbloqueo(strEstado);
                    
                    if(objConfig != null){
                        lstDetalleWrapper[i].strEstado =  objConfig.Descripcion__c;
                        lstDetalleWrapper[i].blnExitosoDesbloqueo = objConfig.Es_Exitoso__c;
                        lstDetalleWrapper[i].strAccionRespuesta =  '('+objConfig.Name+') - ' + objConfig.Accion__c;
                    }else{
                        // No esta configurado el codigo de respuesta
                        System.debug('No esta configurado el codigo de respuesta  ' +strEstado);
                        lstDetalleWrapper[i].strAccionRespuesta =  'No hay configuración para el código de respuesta ('+strEstado+')';
                        lstDetalleWrapper[i].strEstado = 'No hay configuración para el código de respuesta ('+strEstado+')';
                        lstDetalleWrapper[i].blnExitosoDesbloqueo = false;
                         
                    }
                }           
            }
        }       
    }
    
    public void debloquearBch()
    {
        desbloquear();
        
        List<LogTransacciones__c> lstLog = new List<LogTransacciones__c>();
        for(Integer i = 0; i < lstOC_bch.size(); i++ )
        {
            for(DetalleWrapper detalle : lstDetalleWrapper)         
            {
                if(lstOC_bch[i].Id == detalle.strId)
                {
                    lstOC_bch[i].Comentarios__c = detalle.strAccionRespuesta;
                    lstOC_bch[i].Estado__c = (detalle.blnExitosoDesbloqueo ? 'Activa' : 'Declinada');
                    lstLog.add(log(lstOC_bch[i], detalle.strRequest, detalle.strResponse, lstOC_bch[i].Comentarios__c ));
                }
            }
        }
        
        update lstOC_bch;

        if(lstLog.size() > 0)
        {
           Insert lstLog; 
        }       
    }
    
    public PageReference guardar(){
        
        if(!blnPermiso){ 
            blnHabilitar = blnPermiso ; 
            return null; 
        }
        
        validate();
            
        desbloquear();
        
        Savepoint sp = Database.setSavepoint();
        try{
            Id gestionId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get(Label.LTE_Titulo_Gestion_IMEI).getRecordTypeId();
            
            List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
            List<LogTransacciones__c> lstLog = new List<LogTransacciones__c>();
            for(Integer i = 0; i < lstDetalleWrapper.size(); i++)
            {
                if(lstDetalleWrapper[i].blnSelect)
                {                                    
                    OperacionComercial__c objOC = new OperacionComercial__c();
                    objOC.CuentaCliente__c = this.idAccount;
                    objOC.Activo__c = lstDetalleWrapper[i].idActivo;
                    objOC.Plan__c = lstDetalleWrapper[i].idPlan;
                    objOC.TOPP__c = this.idTOPP;
                    objOC.CuentaFacturacion__c = lstDetalleWrapper[i].idCuentaFac;
                    objOC.RecordTypeId = gestionId;

                    objOC.Caso__c = this.idCase;
                    objOC.Contacto_Administrativo__c = this.idContact;
                    
                    objOC.NumeroConexion__c = lstDetalleWrapper[i].strNumero;
                    objOC.IMEI_del_Equipo__c =  (lstDetalleWrapper[i].strIMEI_Alterno.length() > 0 ? lstDetalleWrapper[i].strIMEI_Alterno : lstDetalleWrapper[i].strIMEI) ;
                    
                    objOC.FechadeActivacion__c = Date.today();
                    
                    String strAviso ='IMEI: ' + (lstDetalleWrapper[i].strIMEI_Alterno.length() > 0 ? lstDetalleWrapper[i].strIMEI_Alterno : lstDetalleWrapper[i].strIMEI);
                    
                    lstDetalleWrapper[i].strEstadoDesb = lstDetalleWrapper[i].strEstado;
                    
                    objOC.Comentarios__c = lstDetalleWrapper[i].strAccionRespuesta;
                    
                    ////lstOC_bch[i].Estado__c = (detalle.blnExitosoDesbloqueo ? 'Activa' : 'Declinada');
                    if(lstDetalleWrapper[i].blnExitosoDesbloqueo!= null && lstDetalleWrapper[i].blnExitosoDesbloqueo){   
                        objOC.Estado__c = 'Activa';
                        Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.CONFIRM , lstDetalleWrapper[i].strEstado));
                    }
                    else{
                        objOC.Estado__c = 'En Curso';
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, lstDetalleWrapper[i].strEstado));                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    lstOC.add(objOC);
                    
                    //strAviso += ' - ' + objOC.Name;
                    
                }
            }
            
            if(lstOC.size() > 0)
            {
                Insert lstOC;
                for(OperacionComercial__c tempOC : lstOC)
                {
                    for(DetalleWrapper tempDetalle : lstDetalleWrapper)
                    {
                        if(tempOC.IMEI_del_Equipo__c == tempDetalle.strIMEI || tempOC.IMEI_del_Equipo__c == tempDetalle.strIMEI_Alterno)
                        {
                            lstLog.add(log(tempOC, tempDetalle.strRequest, tempDetalle.strResponse, tempDetalle.strEstadoDesb ));                             
                        }                        
                    }
                    
                }
                
                if(lstLog.size() > 0)
                {
                   Insert lstLog; 
                }
            }

        } catch(Exception e){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
            Database.rollback(sp);
            System.Debug('====================== EXCEPCION ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=======================================================');
        }    
    
        return null;
    }
    
    private LogTransacciones__c log(OperacionComercial__c oc, String strReq, String strRes, String strEstado)
    {
        LogTransacciones__c log=new LogTransacciones__c();
        log.Name='Desbloqueo IMEI';
        log.Informacion_Enviada__c =string.valueOf(strReq).abbreviate(99999);
        log.Informacion_Recibida__c=string.valueOf(strRes).abbreviate(99999);
        log.LTE_Operacion_Comercial__c=oc.Id;
        log.Estado__c=strEstado;
        
        return log;
        
    }
    
    public PageReference regresar(){
        PageReference returnPage = Page.LTE_SeleccionTramiteCambioPlan_pag;
        returnPage.getParameters().put('scontrolCaching', '1');
        returnPage.getParameters().put('id', this.idCase);
        returnPage.setRedirect(true);
        return returnPage;      
    }    
    
    public PageReference validate() 
    {
        for(Integer i = 0; i < lstDetalleWrapper.size(); i++)
        {
            lstDetalleWrapper[i].errorMessage = ''; 
            if ( lstDetalleWrapper[i].strIMEI_Alterno.length() > 0 
                && !Pattern.matches('\\d{15}?',lstDetalleWrapper[i].strIMEI_Alterno))
            {             
                lstDetalleWrapper[i].errorMessage = 'IMEI Invalido'; 
                lstDetalleWrapper[i].blnSelect = false;
                lstDetalleWrapper[i].blnAplica = true;
            } 
            else
            {
                lstDetalleWrapper[i].blnSelect = true;
                lstDetalleWrapper[i].blnAplica = false;
                
            }
        }
        
        return null;
    }
    
    public class DetalleWrapper
    {   
        public String  strId     {get;set;} 
        public String  strNumero {get;set;}
        public String  strIMEI   {get;set;}
        public String  strNombre {get;set;}
        public String  strEstado {get;set;}
        public String  strAccionRespuesta {get;set;}
        public Boolean blnSelect {get;set;}
        public Boolean blnAplica {get;set;}
        public Boolean blnExitosoDesbloqueo {get;set;}
        public String  strIMEI_Alterno   {get;set;}
        
        public String strCodRtaLst {get;set;}
        public String strMarca {get;set;}
        public String strModelo {get;set;}
        public String strCodigoError {get;set;}
        public String strDescripcionError {get;set;}
        public String strRtaGSMA {get;set;}
        public String strProbadoETB {get;set;}
        public String strRtaPruebaRedETB {get;set;}
        public String strHomologadoColombia {get;set;}

        public String classInputPostalCode {get;set;} 
        public String errorMessage {get;set;} 
        
        public Id idPlan {get;set;}
        public Id idCuentaFac {get;set;}
        public Id idActivo {get;set;}
        
        public String strRequest {get;set;}
        public String strResponse {get;set;}
        public String strEstadoDesb {get;set;}
        
        public Integer intEstadoDesbloqueo {get;set;} // 0.Inicial 1.Exitoso 2.Error 
                
        public DetalleWrapper(String strId, String  strNumero, String strIMEI, String strNombre, String strEstado, Boolean blnSelect, Boolean blnAplica)
        {
            this.strId = strId;
            this.strNumero = strNumero;
            this.strIMEI = strIMEI;
            this.strNombre = strNombre;
            this.strEstado = strEstado;
            this.blnSelect = blnSelect;
            this.blnAplica = blnAplica;
            
            strIMEI_Alterno = '';
            strCodRtaLst = '';
            strMarca = '';
            strModelo = '';
            strCodigoError = '';
            strDescripcionError = '';
            
            intEstadoDesbloqueo = 0; 
            
            strRequest = '';
            strResponse = '';
            strEstadoDesb = '';
        }
    }
    
    public String reqConsultaBDO_XML(DetalleWrapper detalle)
    {
        map<string,string> values = new map<string,string>();
        
        values.put('userName',UserInfo.getUserName());
        values.put('strIMEI',(detalle.strIMEI_Alterno.length() > 0 ? detalle.strIMEI_Alterno : detalle.strIMEI));
        values.put('strTipoDoc',strTipoDoc);
        values.put('strDoc',strDoc);
        values.put('correlationID',getCorrelationID('CE'));
        
        return tibcoXml_cls.reqConsultaBDO_XML(values);
        
    }

    public String reqCancelaRegistroNegativo_XML(DetalleWrapper detalle)
    {
        
        map<string,string> values = new map<string,string>();
        
        values.put('userName',UserInfo.getUserName());
        values.put('strIMEI',(detalle.strIMEI_Alterno.length() > 0 ? detalle.strIMEI_Alterno : detalle.strIMEI));
        values.put('strTipoDoc',strTipoDoc);
        values.put('strDoc',strDoc);
        values.put('correlationID',getCorrelationID('DE'));
        
        
        return tibcoXml_cls.reqCancelaRegistroNegativo_XML(values);     
        
    }   
    
    /**************************************************
    * Método encargado para generar un id único de identificacion
    **************************************************/
    private static String getCorrelationID(String strPrefix){
		return (strPrefix.toUppercase()+EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128))).SubString(0,18);
    }

}