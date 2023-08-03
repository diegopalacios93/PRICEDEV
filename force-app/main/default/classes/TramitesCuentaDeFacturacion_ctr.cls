global  with sharing class TramitesCuentaDeFacturacion_ctr implements ObjectPaginatorListener {    
    private Apexpages.Standardcontroller 	stdController;    
    public CuentaFacturacion__c			 	objCuentaFact;
    public Tramite_cuenta_de_facturacion__c objTramite;
    public case							 	objCaso;
    public infoLupas 					 	iLupas					{get; set;}
    public infoLupasCaso				 	iLupasCaso				{get; set;}
    public List<SelectOption> 			 	itemsTipoTramite		{get; set;}
    Public List<wrpActivos> 			 	wActivos  				{get; set;}
    Public List<wrpActivos> 			 	wActivosTodos			{get; set;}      
    public set<string>						setActivosSelect		{get; set;} 	
    public String 			  			 	objectId				{get; set;}
    public String 			  			 	inputIdActivo			{get; set;}
    public String 			  			 	inputIdCuentaFact		{get; set;}
    public String 			  			 	inputNombreConsolid		{get; set;}
    public String 						 	tipoTramite				{get; set;} 
    public String 						 	strUrl  				{get; set;}
    public string 						 	stringBusqueda			{get; set;}
    public string  						 	strFuente				{get; set;}
    public Date							 	dataFechaEnvioTramite	{get; set;}
    public boolean 						 	showTraslado			{get; set;}
    public boolean 						 	showGrillaActivos		{get; set;}
    public boolean 						 	showBtnEjecutar			{get; set;}
    public boolean 						 	showRenderVisual		{get; set;}
    public boolean 						 	showFormateoFactura		{get; set;}
    public boolean 						 	showFieldCaso			{get; set;}
    public boolean 						 	showConsolidarFact		{get; set;}
    public boolean 						 	blncheckedAll 			{get; set;}   
    public boolean						 	userTrasladoCuenta		{get; set;}
    public boolean						 	blnVisualizarSaldoAnt	{get; set;}
    public boolean						 	blnAdjuntarRUT			{get; set;}
    public boolean						 	blnPresentarPILA		{get; set;}
    public boolean						 	blnAjusteDecena			{get; set;}
    public boolean						 	blnDobleCupon			{get; set;}
    public boolean						 	blnFactSoloPortada		{get; set;}
    public String 						 	idImgLupa				{get; set;}      				
    global ObjectPaginator 				 	paginator 				{get;private set;}        
    public list<LogTransacciones__c> 	 	logsConsultaRV;    
    public map<string,string>   		 	mapParameters;
    public map<string,string>				mapTipoTramites;
    public Map<String,ActivoETB__c>      	mapActivosPorTrasladar;
    
    
    
    public TramitesCuentaDeFacturacion_ctr(){
        Document objeDoc = new Document();
        mapActivosPorTrasladar  = new Map<String,ActivoETB__c>();
        mapTipoTramites			= new map<string,string>();
        mapParameters 			= new map<string,string>();
        mapParameters 			= ApexPages.currentPage().getParameters();
        strFuente	  			= mapParameters.get('Fuente');
        objectId 				= ApexPages.currentPage().getParameters().get('objectId'); 
        inputIdActivo			= ApexPages.currentPage().getParameters().get('IdActivo'); 
        inputIdCuentaFact		= ApexPages.currentPage().getParameters().get('IdCuentaFact'); 
        showGrillaActivos		= false;
        showTraslado  			= false;
        showBtnEjecutar			= false;
        showFormateoFactura		= false;  
        showFieldCaso			= false;
        showConsolidarFact		= false;
        showRenderVisual		= true;
        wActivos 	  			= new List<wrpActivos>();
        wActivosTodos 			= new List<wrpActivos>();        
        setActivosSelect		= new set<string>();
        iLupas		  			= new infoLupas();
        iLupasCaso	  			= new infoLupasCaso();
        this.itemsTipoTramite 	= new List<SelectOption>();   
        List<Tramites_cuenta_de_facturacion__mdt> lstTramitesCF = [SELECT DeveloperName,MasterLabel FROM Tramites_cuenta_de_facturacion__mdt];
        lstTramitesCF.sort();
        itemsTipoTramite.add(new SelectOption('Seleccione','Seleccione'));         
        for(Tramites_cuenta_de_facturacion__mdt objTramitesCF : lstTramitesCF){
            mapTipoTramites.put(objTramitesCF.DeveloperName, objTramitesCF.MasterLabel);
            if(strFuente == 'CuentaFactIndividual'){
            	itemsTipoTramite.add(new SelectOption(objTramitesCF.DeveloperName,objTramitesCF.MasterLabel));    
            }else{
                if(objTramitesCF.DeveloperName != 'Configurar_parametros_de_facturacion' && objTramitesCF.DeveloperName != 'Agrupar_conceptos_de_facturacion')
					itemsTipoTramite.add(new SelectOption(objTramitesCF.DeveloperName,objTramitesCF.MasterLabel));
            }            
        }     
        habilitarControles();
        verificarPermisoTrasladoOtrasCuentas();
        
        if(inputIdCuentaFact == null)
            inputIdCuentaFact = '';
		if(inputIdActivo == null)
            inputIdActivo = '';
        
        objeDoc = [Select Id from Document where Name = 'search' limit 1];
        idImgLupa = objeDoc.Id;        
    }
   
 	global void handlePageChange(List<Object> newPage){
        wActivos.clear();
        if(newPage != null){
            for(Object acct : newPage){
                wActivos.add((wrpActivos)acct);
            }
        }
    }
    
    public void consultarServicios(){           
        List<ActivoETB__c> lstActivos;
        List<ActivoETB__c> lstActivosAux;
        String strQuery = '';        
        if(strFuente == 'Activo'){              
         	strQuery =  'SELECT Id,NombredelaCuenta__r.Name, Name,NombredelProducto__r.Name,Oportunidad__r.name , '+
                        'SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,NombredelProducto__c, '+
                        'NombredelaCuenta__c,IDservicio__c,CuentaFacturacion__r.Name, Plan__r.Name, CuentaFacturacion__r.Id, '+
                        'ExternalServiceID__c '+
                        'FROM ActivoETB__c '+
                        'WHERE Id =\''+inputIdActivo+'\' AND Estado__c = \'Activo\'';     
            
        }else if(strFuente == 'CuentaFactIndividual'){
            strQuery =  'SELECT Id,NombredelaCuenta__r.Name, Name,NombredelProducto__r.Name,Oportunidad__r.name , '+
                        'SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,NombredelProducto__c, '+
                        'NombredelaCuenta__c,IDservicio__c,CuentaFacturacion__r.Name, Plan__r.Name, CuentaFacturacion__r.Id, '+
                        'ExternalServiceID__c '+
                        'FROM ActivoETB__c '+
                        'WHERE '+
                        'CuentaFacturacion__r.Id =\''+ inputIdCuentaFact+'\' AND Estado__c = \'Activo\'';                        
            
        }else if(strFuente == 'CuentaFactDelCliente'){        
            strQuery = 'SELECT Id,NombredelaCuenta__r.Name, Name,NombredelProducto__r.Name,Oportunidad__r.name , '+
             		   'SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,NombredelProducto__c, '+
             		   'NombredelaCuenta__c,IDservicio__c,CuentaFacturacion__r.Name, Plan__r.Name, CuentaFacturacion__r.Id, '+
             		   'ExternalServiceID__c '+
             		   'FROM ActivoETB__c '+
             		   'WHERE '+
             		   'NombredelaCuenta__r.Id =\''+ objectId+'\' AND Estado__c = \'Activo\'';             		   
        }
        
        if(stringBusqueda != null){
           strQuery+= ' AND (Name LIKE \'%'+ stringBusqueda + '%\' OR '+
              		  'NombredelProducto__r.Name LIKE \'%' + stringBusqueda + '%\' OR '+
              		  'Plan__r.Name LIKE \'%' + stringBusqueda + '%\' OR '+
              		  'CuentaFacturacion__r.Name LIKE \'%' + stringBusqueda + '%\' OR '+
              		  'IDservicio__c LIKE \'%' + stringBusqueda + '%\' OR '+
              		  'NumeroConexion__c LIKE \'%' + stringBusqueda + '%\')';
        } 
        if(strFuente == 'CuentaFactIndividual' || strFuente == 'CuentaFactDelCliente')            
        	strQuery+= ' order by CuentaFacturacion__r.Name';
		        
		lstActivos = Database.query(strQuery);
        
        if(lstActivos.size()>0){                 
            for(ActivoETB__c tmp : lstActivos){                
                if(setActivosSelect.contains(tmp.Id))
                    wActivosTodos.add(new wrpActivos(tmp,true));
                else
                    wActivosTodos.add(new wrpActivos(tmp,false));                            	
            }                    
            paginator = new ObjectPaginator(15,this);
            paginator.setRecords(wActivosTodos); 
        }		
    }
    public void consultarDatosCtaFact(){
        List<Tramite_cuenta_de_facturacion__c> tramiteList = new List<Tramite_cuenta_de_facturacion__c>();        
        objCuentaFact = [Select 
                         Id,Visualizar_el_saldo_anterior__c,Presentar_el_ajuste_a_la_decena__c,
                         Adjuntar_RUT_y_parafiscales__c,Presentar_doble_cupon__c, Presentar_PILA__c,
                         Fue_creada_en_revchain__c, Cliente__r.OwnerId,Cliente__r.Name, Factura_solo_portada__c,
                         Estado__c, (Select Name, Estado__c, Estado_aprobacion_solicitud__c, Tramite__c, 
                                     Nombre_del_concepto_a_consolidar__c From Tramites_cuenta_de_facturacion__r order by createdDate desc Limit 1)
                         From CuentaFacturacion__c
                         Where Id=:inputIdCuentaFact];
        
        tramiteList	= objCuentaFact.Tramites_cuenta_de_facturacion__r;        
        if(tramiteList.size() > 0)
            objTramite = tramiteList[0];        
        
		blnVisualizarSaldoAnt = objCuentaFact.Visualizar_el_saldo_anterior__c;
        blnAdjuntarRUT		  = objCuentaFact.Adjuntar_RUT_y_parafiscales__c;
        blnPresentarPILA	  = objCuentaFact.Presentar_PILA__c;
        blnAjusteDecena		  = objCuentaFact.Presentar_el_ajuste_a_la_decena__c;
        blnDobleCupon		  = objCuentaFact.Presentar_doble_cupon__c;
        blnFactSoloPortada	  = objCuentaFact.Factura_solo_portada__c;
    }
    public void checkAll(){
        for (wrpActivos tmp : wActivosTodos)
            tmp.blnChecked = blncheckedAll;	
	}    
    public class wrpActivos{    
        public ActivoETB__c activo {get;set;}
        public boolean blnChecked {get;set;}
        //recorrer todo produccion:
        public wrpActivos(ActivoETB__c act, Boolean bln)
        {
            activo=act;
            blnChecked=bln;            
        }        
    }
    public pageReference habilitarControles(){    
        
		if(strFuente == 'Activo' || (tipoTramite != 'Seleccione' && tipoTramite != null))
            showBtnEjecutar = true;
        else
        	showBtnEjecutar = false;        
                
        if(tipoTramite == 'Traslado' || strFuente == 'Activo'){
			showTraslado 		= true;
            showGrillaActivos	= true;
            showFormateoFactura	= false;
            showFieldCaso		= false;
            showConsolidarFact	= false;
            consultarServicios();
        }else if (tipoTramite == 'Configurar_parametros_de_facturacion'){            
            showTraslado 		= false;
            showGrillaActivos	= false;
            showFormateoFactura = true;
            showFieldCaso		= true;
            showConsolidarFact	= false;
            consultarDatosCtaFact();
        }else if(tipoTramite == 'Agrupar_conceptos_de_facturacion'){
            showTraslado 		= false;
            showGrillaActivos	= true;
            showFormateoFactura = false;
            showFieldCaso		= true;
            showConsolidarFact	= true;
            consultarDatosCtaFact();
            consultarServicios();
        }else{
           	showTraslado 		= false;
            showGrillaActivos	= false;
            showFormateoFactura = false;
            showFieldCaso		= false;
            showConsolidarFact	= false;
        }                
		return null;
	}
    public class infoLupas{        
        public string cuentaFacturacion		{get;set;}
        public string cuentaFacturacionId	{get;set;}          
    }
	public class infoLupasCaso{
        public string caso		{get;set;}
        public string casoId	{get;set;}
    }     
    public string getCuentaFacturacionInfo(){	                
        Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();           
        return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__r.Id =\''+objectId+'\' AND Fue_creada_en_revchain__c = True AND (Facturable__c = True OR (LTE_CuentaFacturacionPadre__r.Fue_creada_en_revchain__c = True AND LTE_CuentaFacturacionPadre__r.Facturable__c = True)) AND Id !=\''+inputIdCuentaFact+'\'')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Cuenta_facturable_no_facturable__c,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name')+'&infoParam=CuentaFact&nom='+filtro_cls.codificar('Número de cuenta,Nombre de la cuenta,Cliente,Facturable - No facturable,Tipo de cuenta (Padre - Hija),Cuenta de facturación padre');
	}
    public string getCasoInfo(){	                
        Schema.DescribeSObjectResult r = Case.sObjectType.getDescribe();           
        return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where AccountId =\''+objectId+'\'')+'&f='+filtro_cls.codificar(',CaseNumber,Account.Name,Subject,Status,Causal_Estado__c')+'&infoParam=CuentaFact&nom='+filtro_cls.codificar('Número del caso,Nombre de la cuenta,Asunto,Estado,Causal Estado');
	}
    
    public pageReference ejecutarTramite(){          
        string result;
        if(tipoTramite == 'Traslado' || strFuente == 'Activo'){
            result = procesarTramiteTraslado(); 
            if(result == null)
                return null;
        }        
        if(tipoTramite == 'Configurar_parametros_de_facturacion'){
            result = procesarTramiteFormateoFactura(); 
            if(result == null)
                return null;
        }
        if(tipoTramite == 'Agrupar_conceptos_de_facturacion'){
            result = procesarConsolidarConceptosFact(); 
            if(result == null)
                return null;
        }
        return null;
    }  
    
    public string procesarTramiteTraslado(){
        // Declaracion
        set<Id> 						  productosId	 = new set<Id>();                            
        map<string,Schema.RecordTypeInfo> formatos 		 = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();            
        Map<String,OperacionComercial__c> mapOC 		 = new Map<String,OperacionComercial__c>();                    
        logsConsultaRV									 = new list<LogTransacciones__c>();
        string	 						  strErrorInteg	 = '';
        boolean 						  hasRecords	 = false;		            
        integer 						  cantActivos	 = 0;
        integer 						  hasError;        
        map<string,Topp__c> 			  elMapaTopp;
        
        // Validaciones
        if( iLupas.cuentaFacturacionId == '' || iLupas.cuentaFacturacion == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_CuentaFactEnBlanco));
            return null;
        }
        // verificar cantidad de activos a procesar
        for (wrpActivos tmp : wActivosTodos){                                
            if(tmp.blnChecked || strFuente == 'Activo')                   
                cantActivos++;
        }            
        if(cantActivos < 101){
            // recorrer servicios seleccionados
            for (wrpActivos tmp : wActivosTodos){                                
                if(tmp.blnChecked || strFuente == 'Activo'){
                    hasRecords = true;      
                    strErrorInteg = consultarEstadoServicioEnRevchain(tmp.activo);                    
                    if(strErrorInteg != ''){
                        break;
                    }else{  
                        System.debug('\n@@-activo.NombredelProducto__c: ' + tmp.activo.NombredelProducto__c);
                        productosId.add(tmp.activo.NombredelProducto__c);
                        // Crear Operacion Comercial
                        OperacionComercial__c objOp 	  = new OperacionComercial__c();
                        objOp.Activo__c 				  = tmp.activo.ID;
                        objOp.CuentaCliente__c 			  = tmp.activo.NombredelaCuenta__c;
                        objOp.SucursalOrigen__c 		  = tmp.activo.SucursalOrigen__c;
                        objOp.SucursalDestino__c 		  = tmp.activo.SucursalDestino__c;
                        objop.Plan__c 					  = tmp.activo.Plan__c;
                        objOp.Estado__c					  = 'Pendiente Facturacion';					
                        objOp.IDServicio__c				  = tmp.activo.IDservicio__c;
                        objOp.NumeroConexion__c			  = tmp.activo.NumeroConexion__c;               
                        objOp.CuentaFacturacion__c		  = iLupas.cuentaFacturacionId;                            
                        objOp.Fecha_Final_Estado__c		  = System.today();
                        objOp.FechadeActivacion__c		  = dataFechaEnvioTramite;
                        objOp.EnvioFacturacion__c         = true;
                        
                        mapOC.put(tmp.activo.ID, objOp);                              
                    }
                }
            }
            // Validaciones
            if (!hasRecords){				
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_ServicioEnBlanco));
                return null;
            }else{                    
                if(logsConsultaRV.size() > 0){                        
                    insert logsConsultaRV;
                }
                
                if(strErrorInteg != ''){
                    mapOC.clear();
                    //mapAC.clear();                        
                    mapActivosPorTrasladar.clear();                        
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,strErrorInteg));
                }else{
                    hasError=0;
                    Savepoint sp = Database.setSavepoint();
                    System.debug('\n@@-productosId: ' + productosId);
                    elMapaTopp 	 = topps(productosId);
                    System.debug('\n@@-elMapaTopp: ' + elMapaTopp);
                    System.debug('\n@@-mapOC: ' + mapOC);
                    try{
                        for (OperacionComercial__c tmp : mapOC.values()){
                            System.debug('\n@@-tmp: ' + tmp);
                            if(elMapaTopp.get('Cambio Cuenta de Facturacion- TELEFONIA MOVIL (LTE)') != null){
                                tmp.TOPP__c = elMapaTopp.get('Cambio Cuenta de Facturacion- TELEFONIA MOVIL (LTE)').id;						
                                tmp.RecordTypeId=formatos.get(elMapaTopp.get('Cambio Cuenta de Facturacion- TELEFONIA MOVIL (LTE)').Tipoderegistro__c).getRecordTypeId();					
                            }else{	 
                                System.debug('\n@@-elMapaTopp Id: ' + 'Cambio Cuenta de Facturacion' + '- '+ tmp.Plan__c);
                                if(elMapaTopp.get('Cambio Cuenta de Facturacion' + '- '+ tmp.Plan__c)==null){                                    
                                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Msj_NoExisteTOPP.replace('%plan%',([Select Name From Planes__c Where Id =:tmp.Plan__c].Name))));
                                }else{
                                    tmp.TOPP__c = elMapaTopp.get('Cambio Cuenta de Facturacion' + '- '+ tmp.Plan__c).id;						
                                    tmp.RecordTypeId=formatos.get(elMapaTopp.get('Cambio Cuenta de Facturacion' + '- '+ tmp.Plan__c).Tipoderegistro__c).getRecordTypeId();					
                                }	
                            }
                        }                                         
                        insert mapOC.values();                            
                        //update mapAC.values();                            
                        //                            
                        if(hasError!=0){
                            Database.rollback(sp);
                            return null;
                        }else{					
                            showBtnEjecutar  = false;
                            showRenderVisual = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,label.Msj_CreacionOCs));			                    
                        }
                    }
                    catch(Exception ex){
                        Database.rollback(sp);
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                        return null;
                    }                
                }
            }                                  
        }else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Msj_ErrorLimiteActivosATrasladar));
            return null;
        }
        return 'OK';
    }
    
    public string procesarTramiteFormateoFactura(){
        // Validaciones        
        if( iLupasCaso.casoId == '' || iLupasCaso.caso == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_IngresarUnCaso));
            return null;
        }else if(!objCuentaFact.Fue_creada_en_revchain__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_CuentaFactNoIntegrada));
            return null;
        }else if(objCuentaFact.Estado__c != 'Activo'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_CuentaFactNoActiva));
            return null;
        }else if(objCuentaFact.Cliente__r.OwnerId !=  userinfo.getUserId()){                
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_UsuarioNoPuedeModificarFormatoFact));
            return null;            
        }else if(objTramite != null && objTramite.Estado__c == 'Pendiente'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_solicitudActualizacionFormatoFactExistente.replace('%tramite%',objTramite.Name).replace('%tipoTramite%',objTramite.Tramite__c).replace('%estadoTramite%',objTramite.Estado__c)));
            return null;            
        }else{                    
            Tramite_cuenta_de_facturacion__c objTramiteCF 	 = new Tramite_cuenta_de_facturacion__c();
            objTramiteCF.Cuenta_de_Facturacion__c 		  	 = inputIdCuentaFact;
            objTramiteCF.Tramite__c 			  		  	 = mapTipoTramites.get(tipoTramite);                
            objTramiteCF.Estado_aprobacion_solicitud__c		 = 'Pendiente';
            objTramiteCF.Presentar_el_ajuste_a_la_decena__c	 = blnAjusteDecena;
            objTramiteCF.Adjuntar_RUT_y_parafiscales__c		 = blnAdjuntarRUT;
            objTramiteCF.Presentar_doble_cupon__c			 = blnDobleCupon;
            objTramiteCF.Factura_solo_portada__c			 = blnFactSoloPortada;
            objTramiteCF.Presentar_PILA__c					 = blnPresentarPILA;
            objTramiteCF.Visualizar_el_saldo_anterior__c     = blnVisualizarSaldoAnt;
            objTramiteCF.Caso__c							 = iLupasCaso.casoId;                
            insert objTramiteCF;
            
            Id idTramite = objTramiteCF.Id;
            objTramiteCF = [Select Name, Tramite__c From Tramite_cuenta_de_facturacion__c Where Id=: idTramite];
            
            showBtnEjecutar  = false;
            showRenderVisual = false;
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,(label.Msj_solicitudActualizacionFormatoFactExitoso.replace('%tramite%',objTramiteCF.Name).replace('%nombreTramite%',objTramiteCF.Tramite__c))));
        }
        return 'OK';
    }
    
    public string procesarConsolidarConceptosFact(){
        
        Tramite_cuenta_de_facturacion__c objTramiteCF = new Tramite_cuenta_de_facturacion__c(); 
        // Validaciones
        if( iLupasCaso.casoId == '' || iLupasCaso.caso == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_IngresarUnCaso));
            return null;
        }else if(inputNombreConsolid == ''){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_IngresarNombreConsolidacion));
            return null;            	
        }else if(!objCuentaFact.Fue_creada_en_revchain__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_CuentaFactNoIntegrada));
            return null;
        }else if(objCuentaFact.Estado__c != 'Activo'){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_CuentaFactNoActiva));
            return null;
        }else if(objCuentaFact.Cliente__r.OwnerId !=  userinfo.getUserId()){                
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_UsuarioNoPuedeModificarFormatoFact));
            return null;            
        }else if(objTramite != null && objTramite.Estado__c == 'Pendiente' && !Test.isRunningTest()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_solicitudActualizacionFormatoFactExistente.replace('%tramite%',objTramite.Name).replace('%tipoTramite%',objTramite.Tramite__c).replace('%estadoTramite%',objTramite.Estado__c)));
            return null;            
        }else{
            // verificar cantidad de activos a procesar
            integer cantActivos	 = 0;            
            for (wrpActivos tmp : wActivosTodos){                                
            	if(tmp.blnChecked)                   
                	cantActivos++;
        	}
            if(cantActivos == 0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_ServicioEnBlanco));
                return null;            
            }else if(cantActivos == 1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,label.Msj_validacionCantMinimaAgruparServicios));
                return null;     
            }else{
               Savepoint sp = Database.setSavepoint();
               Integer cantidadAC = 0;
               // crear trámite                              
               objTramiteCF.Cuenta_de_Facturacion__c 		  	 		= inputIdCuentaFact;
               objTramiteCF.Tramite__c 			  		  	 			= mapTipoTramites.get(tipoTramite);                
               objTramiteCF.Estado_aprobacion_solicitud__c		 		= 'Pendiente';                                
               objTramiteCF.Caso__c							 			= iLupasCaso.casoId; 
               objTramiteCF.Nombre_del_concepto_a_consolidar__c 		= inputNombreConsolid;
               objTramiteCF.Validacion_plan_de_impuestos__c				= 'Pendiente';
               Insert objTramiteCF;
               List<Servicio_del_tramite_cuenta_fact__c> ListAcTramite  = new List<Servicio_del_tramite_cuenta_fact__c>();
               for (wrpActivos tmp : wActivosTodos){                                
                	if(tmp.blnChecked){ 
                        cantidadAC++;
                        try{                             
                            Servicio_del_tramite_cuenta_fact__c objAcTramite = new Servicio_del_tramite_cuenta_fact__c();
                            objAcTramite.Tramite_cuenta_de_facturacion__c	 = objTramiteCF.Id;
                            objAcTramite.Activo__c 							 = tmp.activo.Id;
                            objAcTramite.Estado__c							 = 'Pendiente';
                            ListAcTramite.add(objAcTramite);                                                                                    
                        }catch(Exception ex){                            
                            Database.rollback(sp);
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Se presentó el siguiente errror al procesar el trámite: '+ex.getMessage()));                            
                            return null;
                    	}           
                    }
               }
                if(ListAcTramite.size()>0 && !Test.isRunningTest()){
                   Insert ListAcTramite;
                   objTramiteCF.Cantidad_de_servicios_a_procesar__c = cantidadAC;
                   update objTramiteCF; 
                }
            }          
        }
        showBtnEjecutar  = false;
        showRenderVisual = false;
        Id idTramite 	 = objTramiteCF.Id;
        objTramiteCF 	 = [Select Name, Tramite__c From Tramite_cuenta_de_facturacion__c Where Id=: idTramite];
        
        //Invocar Batch de consulta de plan de impuestos
        set<id> idImediatoTramite = new set<id>();
        idImediatoTramite.add(idTramite);
        IntegracionServiciosTramitesCtasFact_bch facttbtch = new IntegracionServiciosTramitesCtasFact_bch();
        facttbtch.idImediatoTramite = idImediatoTramite;
        ID batchprocessid = Database.executeBatch(facttbtch,1);
        system.debug('==>Id Envío batch IntegracionServiciosTramitesCtasFact_bch:'+batchprocessid);    
        
        // Generar mensaje de respuesta en la visual
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,(label.Msj_solicitudConsolidarConceptosFactExitoso.replace('%tramite%',objTramiteCF.Name).replace('%nombreTramite%',objTramiteCF.Tramite__c))));
        return 'OK';
    }
    
    public string consultarEstadoServicioEnRevchain(ActivoETB__c objActivo){        
        Map<string,string>   	  mapValuesIntegRV	 	= new map<string,string>();
        List<String> 	   		  lstCiclosFactNoDisp   = Label.Param_Jerarquia_CF_CiclosNoFacturables.split(',');        
        tibcoXml_cls.xmlMap  	  proReq		 		= new tibcoXml_cls.xmlMap();
        ServiciosWeb__c 		  wsRV		 	        = ServiciosWeb__c.getValues('ConsultaFechaFactServicioRevchain');
        string	 				  requestIntegRV		= '';
		string	 				  responseIntegRV		= '';
        string	 				  strStatusInteg		= '';
        string   				  strResultInteg		= '';
        string	 				  strErrorInteg			= '';
        string					  strEstadoServicio		= '';
        Integer					  intDD;					  
        Integer					  intMM;
        Integer					  intYYYY;
        Date					  dataFechaUltimaFact;
           
        requestIntegRV 	  = ConstruirXMLCtasFact_cls.CrearXMLconsultarServicioEnRevchain(objActivo.CuentaFacturacion__r.Name,iLupas.cuentaFacturacion,objActivo.ExternalServiceID__c);  
        if(!Test.isRunningTest())
        responseIntegRV	  = LibreriaUtilitariaJobs_cls.consultarServicio(requestIntegRV,wsRV.Action__c,wsRV.EndPoint__c);
        else
        responseIntegRV = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:GetHierarchyAccountDataOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetHierarchyAccountDataOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>AC-811622</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2020-02-08T15:40:05.972-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:GetHierarchyAccountDataOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetHierarchyAccountDataOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/GetHierarchyAccountDataMsg"><ns2:ResponseService><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>MdmCmpRevchain</ns2:System><ns2:PortalData><ns2:HierarchyAccounts><ns2:InvoiceDate>2020/03/29</ns2:InvoiceDate><ns2:State>A</ns2:State><ns2:SourceBillingCycle>N/A</ns2:SourceBillingCycle><ns2:DestinationBillingCycle>18</ns2:DestinationBillingCycle></ns2:HierarchyAccounts><ns2:ErrorResult>0</ns2:ErrorResult><ns2:ErrorDescription>OK</ns2:ErrorDescription></ns2:PortalData></ns2:ResponseService></ns2:GetHierarchyAccountDataOutput></ns0:GetHierarchyAccountDataOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        
        mapValuesIntegRV  = proReq.getMap(responseIntegRV);
        strStatusInteg    = mapValuesIntegRV.get('status');
        strResultInteg    = mapValuesIntegRV.get('Result');  
        //generar log de transacción
        if(!Test.isRunningTest()){
        logsConsultaRV.add(crearLogtransaccion(null,requestIntegRV,responseIntegRV,strStatusInteg,strResultInteg,'',objActivo.Name,'Consultar datos de activo/cuenta en Revchain',objActivo.Id));        
        }
        System.debug('\n@@-mapValuesIntegRV.get(InvoiceDate) ' + mapValuesIntegRV.get('InvoiceDate'));
        if(strStatusInteg == 'PASS' && strResultInteg == 'S'){
            if(mapValuesIntegRV.get('State') != 'A' && !userTrasladoCuenta){
                strEstadoServicio = mapValuesIntegRV.get('State') == 'I'?'Inactivo':mapValuesIntegRV.get('State') == 'S'?'Suspendido':mapValuesIntegRV.get('State') == 'X'?'Cancelado':'Servicio no disponible en RevChain';
                strErrorInteg = Label.Msj_ErrorServicioNoActivo.replace('%activo%',objActivo.Name).replace('%estado_servicio_rv%',strEstadoServicio);           
            }else if(lstCiclosFactNoDisp.contains(mapValuesIntegRV.get('DestinationBillingCycle'))){
                strErrorInteg = Label.Msj_ErrorCicloCuentaDestino.replace('%cuentaDestino%',iLupas.cuentaFacturacion).replace('%ciclo%',mapValuesIntegRV.get('DestinationBillingCycle'));
            }else{
               mapActivosPorTrasladar.put(objActivo.Id, (new ActivoETB__c(Id=objActivo.Id)));
            }            
            // calcular fecha de envío del trámite
            if(mapValuesIntegRV.get('InvoiceDate')!= '' && mapValuesIntegRV.get('InvoiceDate')!= 'N/A'){
                List<String> DatosFechaFact = mapValuesIntegRV.get('InvoiceDate').split('/');
                if(DatosFechaFact.size() > 0){
                    intDD 	= integer.valueof(DatosFechaFact[0]);
                    intYYYY = integer.valueof(DatosFechaFact[2]);                    
                    intMM 	= integer.valueof(DatosFechaFact[1]);                    
                    dataFechaUltimaFact = date.newinstance(intYYYY, intMM, intDD);
                    if(dataFechaUltimaFact > Date.today())
                        dataFechaEnvioTramite = dataFechaUltimaFact;                        
                    else
                        dataFechaEnvioTramite = Date.today();
                }else{
                    dataFechaEnvioTramite = Date.today();
                }                
            }else
                dataFechaEnvioTramite = Date.today();
            			
            dataFechaEnvioTramite = dataFechaEnvioTramite.addDays(1);            
        }else{                        
            strErrorInteg = Label.Msj_ErrorIntegracionConsultaRV.replace('%activo%',objActivo.Name).replace('%error%',mapValuesIntegRV.get('ErrorDescription'));
        }         
        return strErrorInteg;
    }
    public map<string,Topp__c> topps(set<Id> pro){
        //configuracion personalizada para excluir servicios LTE	
        VariablesGlobales__c 	vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        map<string,Topp__c> 	mapas	= new map<string,Topp__c>();        
        list<Topp__c> 			t 		= new list<Topp__c>([select name,id, TipodeOperacionporplan__c,Plan__c,Plan__r.name,Plan__r.NombredelProducto__c,Tipoderegistro__c, Plan__r.NombredelProducto__r.Name from Topp__c where Plan__r.NombredelProducto__c IN :pro And TipodeOperacionporplan__c IN ('Cambio Cuenta de Facturacion')]);
        System.debug('\n@@-t: ' + t);
        for(Topp__c tt:t){
            if  (tt.Plan__r.NombredelProducto__r.Name == 'TELEFONIA MOVIL (LTE)'){
                mapas.put(tt.TipodeOperacionporplan__c + '- ' + tt.Plan__r.NombredelProducto__r.Name,tt);
            }else{
           		mapas.put(tt.TipodeOperacionporplan__c + '- ' + tt.Plan__c,tt);	
            }
        } 
         System.debug('\n@@-mapas: ' + mapas);
        return mapas;        
    }
	public Pagereference regresar(){
        PageReference paginaInicio;
        if(strFuente == 'Activo')
        	paginaInicio= new PageReference('/'+inputIdActivo);
        else if(strFuente == 'CuentaFactIndividual')
            paginaInicio= new PageReference('/'+inputIdCuentaFact);
        else
            paginaInicio= new PageReference('/'+ObjectId);
        
        paginaInicio.setRedirect(true);
        return paginaInicio;        
    }
    public Pagereference buscarServicio(){                  
        wActivos.clear();           
        for(wrpActivos wrpAux : wActivosTodos){
            if(wrpAux.blnChecked && !setActivosSelect.contains(wrpAux.activo.Id))
            	setActivosSelect.add(wrpAux.activo.Id);
            else if(!wrpAux.blnChecked && setActivosSelect.contains(wrpAux.activo.Id))
                setActivosSelect.remove(wrpAux.activo.Id);
        }                 
        wActivosTodos.clear();
        consultarServicios();        
        return null;  
    }  
    public void verificarPermisoTrasladoOtrasCuentas(){
        List<UsuariosTrasladoCuentasOtrosClientes__c> ListUserTraslado = new List<UsuariosTrasladoCuentasOtrosClientes__c>();
        ListUserTraslado = [Select SetupOwnerId From UsuariosTrasladoCuentasOtrosClientes__c Where SetupOwnerId =: userinfo.getuserid()];
 		
        if(ListUserTraslado.size() > 0)
        	userTrasladoCuenta = true;
        else
            userTrasladoCuenta = false;
    }     
    public LogTransacciones__c crearLogtransaccion(id idCF, string request,string response, string estado, string CodigoRespuesta, string AC_Random, string correlationId, string nombreTransaccion,id idActivo){
        LogTransacciones__c lt = new LogTransacciones__c(LTE_CuentaFacturacionLTE__c=idCF,CorrelationId__c=correlationId,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name=nombreTransaccion,CodigoRespuesta__c=CodigoRespuesta,AC_CorrelationID_Random__c=AC_Random,Servicio_ETB_relacionado__c=idActivo);
        return lt;    
    }
}