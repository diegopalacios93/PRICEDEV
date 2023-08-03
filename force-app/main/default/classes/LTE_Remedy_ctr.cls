/***************************************************************************************************************************
*** Desarrollado por:     Avanxo Colombia                                                                                ***
*** Autor:                Andrés Oliva (AO)                                                                              ***
*** Proyecto:             ETB - LTE                                                                                      ***
*** Descripcion:          Clase Controladora de la página visual force que invoca el Servicio Web de Remedy              ***
***                                                                                                                      ***
***                                                                                                                      ***
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***  
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***            No.      Fecha              Autor         Descripción                                                     ***  
***           -----    ----------    --------------------  ---------------                                               ***
*** @version   1.0     2015-08-12    Andrés Oliva (AO)      Class created                                                ***
***************************************************************************************************************************/
public class LTE_Remedy_ctr 
{
	public Case objCase { get; set; }
    
	public String strGarantiaSelec {set;get;}
    public String strFuenteIncidente{get;set;}
    public String strNota {get;set;}
    public String strEstadoIni;
    public String strErrorMessage;
    public String strLineaNegocio;
    public String strResponsable{get;set;}
    public String strSubResponsable{get;set;}
    
    public List<BusinessLogic_Caso_ctr.TareasRemedy> lstTareas {get;set;}
    public List<Tareas_Salesforce> lstTareasSalesforce {get;set;}
    private Map<String,Object> sglDataMap;
    
    public Boolean blnHabilitarIntegracion {get;set;}
    public Boolean blnCreadoRemedy {get;set;}
    public Boolean blnMostrarTareas {get;set;}
    public Boolean blnActualizarEstado {get;set;}
    public Boolean blnActualizar {get;set;}
    public Boolean blnActualizarNota {get;set;}
    public Boolean blnHabilitarIntegracionPS {get;set;}
    
    public Integer intTotalTareasRemedy {get;set;}
    public Integer intActualTareasRemedy {get;set;}
    
	public List<SelectOption> lstResponsable {get;set;}
	public List<SelectOption> lstSubResponsable {get;set;}

	public LTE_Remedy_ctr() 
	{
        strLineaNegocio = '';
        blnHabilitarIntegracion = false;
        blnHabilitarIntegracionPS = false;
        blnActualizarEstado = false;
        blnActualizar = false;
        blnMostrarTareas = false;
        blnCreadoRemedy = false;
        blnActualizarNota = false;
        lstTareasSalesforce = new List<Tareas_Salesforce>();
		Id id = ApexPages.currentPage().getParameters().get('id');
		//objcases = (id == null) ? new Case() :
		//objcases=[SELECT Id, Nivel_1__c, Nivel_2__c,Nivel_3__c,Account.Id,Account.Name,Account.Phone,Account.TipodeAtencion__c,Account.Direccion__c,Account.Tipodedocumento__c,Account.AccountNumber,Contact.Name,Contact.Email,Contact.Phone,LTE_Servicio__r.Id,LTE_Servicio__r.SucursalDestino__r.Direccion__c FROM Case WHERE Id = '50056000000cL1J'];
		//objCase=[SELECT Id,CaseNumber,CreatedDate,Origin,Description, CodigouniconumericoCUN__c,Agrupacion__c,Nivel_1__c,LTE_Garantia__c,Proceso__c ,Nivel_2__c,Tipologia__c ,Nivel_3__c,Account.Id,Account.AccountNumber,Account.Name,Account.Phone,Account.TipodeAtencion__c,Account.Direccion__c,Account.Tipodedocumento__c,Contact.Name,Contact.Email,Contact.Phone,LTE_Servicio__r.Id,LTE_Servicio__r.SucursalDestino__r.Direccion__c,LTE_IntentosSistemaLegado__c,LTE_EstEnvioSistLegado__c FROM Case WHERE Id =:Id];
        
        try{
            Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Caso Remedy PS'];
            String sParamFields = lstMensajes.Mensaje__c;
            String selectParametersQuery = 'SELECT ' + sParamFields + ' FROM Case where Id =:id';
            list<Case> lstCaso = Database.query(selectParametersQuery);
            objCase = lstCaso[0];
            EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('Remedy');
            if(integra!=null && integra.Ejecucion__c==true){
                VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
                if(objCase.LTE_Servicio__c!=null){
                    if(objCase.LTE_Servicio__r.NombredelProducto__c!=null && objCase.LTE_Servicio__r.Plan__c!=null){
                        if(objCase.LTE_Servicio__r.NombredelProducto__r.Name==vGlobal.Valor__c && (objCase.LTE_Servicio__r.Plan__r.TipodePlan__c == 'Troncal SIP' || (objCase.LTE_Servicio__r.Plan__r.TipodePlan__c == 'Principal' && objCase.LTE_Servicio__r.Plan__r.Plan_Troncales_Sip_Movil__c == true))){
                            strLineaNegocio = 'Portafolio Superior';
                        }else if(objCase.LTE_Servicio__r.NombredelProducto__r.Name==vGlobal.Valor__c){
                            strLineaNegocio = 'LTE';
                        }else if(objCase.LTE_Servicio__r.NombredelProducto__r.Catalogo__c=='Portafolio Superior'){
                            strLineaNegocio = 'Portafolio Superior';
                        }else if(objCase.LTE_Servicio__r.NombredelProducto__r.Catalogo__c=='Aliado'){
                            strLineaNegocio = 'Aliado';
                        }
                    }else{
                        strErrorMessage = 'El servicio asociado al caso no posee un producto o plan relacionado';
                    }
                }else if(objCase.Plan__c!=null){
                        if(objCase.Plan__r.NombredelProducto__r.Name==vGlobal.Valor__c && (objCase.Plan__r.TipodePlan__c == 'Troncal SIP' || (objCase.Plan__r.TipodePlan__c == 'Principal' && objCase.Plan__r.Plan_Troncales_Sip_Movil__c == true))){
                            strLineaNegocio = 'Portafolio Superior';
                        }else if(objCase.Plan__r.NombredelProducto__r.Name==vGlobal.Valor__c){
                            strLineaNegocio = 'LTE';
                        }else if(objCase.Plan__r.NombredelProducto__r.Catalogo__c=='Portafolio Superior'){
                            strLineaNegocio = 'Portafolio Superior';
                        }else if(objCase.Plan__r.NombredelProducto__r.Catalogo__c=='Aliado'){
                            strLineaNegocio = 'Aliado';
                        }
                }else{
                    strErrorMessage = 'Se requiere se asocie un servicio al caso para la integracion con Remedy';
                }
            }else{
                strErrorMessage = 'La integracion se encuentra deshabilita, por favor comunicarse con el area de Soporte';
            }
            
            if(String.isEmpty(strErrorMessage)){
                if(strLineaNegocio == 'LTE'){
                    if(String.isEmpty(objCase.CodigouniconumericoCUN__c)){
                        strErrorMessage = 'Los casos de servicios LTE requieren el CUN de manera obligatoria para el envio a Remedy';
                        blnHabilitarIntegracion = false;
                    }else{
                        blnHabilitarIntegracion = true;
                    }
                }else if(strLineaNegocio == 'Aliado'){
                    if(objCase.FechaTipificacion__c == null){
                        strErrorMessage = 'No se ha tipificado el caso';
                    }else{
                        blnHabilitarIntegracionPS=true;
                        blnActualizarNota = false;
                                blnHabilitarIntegracion = true;
                    }
                }else if(strLineaNegocio == 'Portafolio Superior'){
                    if(objCase.Integrar_con_gestor__c){
                        if(objCase.FechaInicioAfectacion__c==null || objCase.FechaTipificacion__c == null || objCase.Grupo_Aseguramiento__c==null){
                            strErrorMessage = 'No se ha diligenciado toda la informacion para el envio a Remedy';
                        }else{
                            blnHabilitarIntegracionPS=true;
                            blnActualizarNota = true;
                            if(String.isNotEmpty(objCase.Id_Sistema_Legado__c)){
                                List<Homologacion_Remedy__mdt> lstHomologacion = new List<Homologacion_Remedy__mdt>();
                                
                                if(objCase.Categoria_legado__c=='Incidente'){
                                    lstHomologacion = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'MATRIZ_REMEDY_ESTADO_INC' AND Valor_API__c = :objCase.EstadoSistemaLegado__c];
                                }else{
                                    lstHomologacion = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'ESTADO_REMEDY_IN' AND Valor_API__c = :objCase.EstadoSistemaLegado__c];
                                }
                                if(!lstHomologacion.isEmpty()){
                                    blnActualizarEstado = true;
                                }
                                blnHabilitarIntegracion = false;
                                blnCreadoRemedy = true;
                                blnActualizar = true;
                                
                                List<Task> lstTask = [SELECT Id, Subject,ID_externo__c,ActivityDate,Status,Grupo_Aseguramiento__r.Nivel3__c,ConsecutivodeTareas__c,Description FROM Task WHERE WhatId =:objCase.Id];
                                for(Task sglTarea:lstTask){
                                    Tareas_Salesforce newTarea = new Tareas_Salesforce();
                                    newTarea.objTarea = sglTarea;
                                    newTarea.IntegrarLegado = false;
                                    lstTareasSalesforce.add(newTarea);
                                }
                            }else{
                                blnHabilitarIntegracion = true;
                                if(objCase.Categoria_legado__c=='Requerimiento'){
                                    blnActualizarNota=false;
                                }
                                lstResponsable = new List<SelectOption>();
                                lstSubResponsable = new List<SelectOption>();
                                lstResponsable.add(new SelectOption('',''));
                                strResponsable = String.isEmpty(objCase.Responsable_Legado__c)?'':objCase.Responsable_Legado__c;
                                strSubResponsable = String.isEmpty(objCase.SubResponsable_Legado__c)?'':objCase.SubResponsable_Legado__c;
                                List<LV_Remedy__mdt> lstlvResponsable = [SELECT Id,Valor_Usuario__c,Valor_API__c FROM LV_Remedy__mdt WHERE Tipo_Lista__c = 'RESPONSABLE'];
                                if(!lstlvResponsable.isEmpty()){
                                    for(LV_Remedy__mdt sgllvResponsable:lstlvResponsable){
                                        lstResponsable.add(new SelectOption(sgllvResponsable.Valor_API__c,sgllvResponsable.Valor_Usuario__c));
                                    }
                                }
                                CargarSubResponsable();
                            }
                        }
                    }else{
                        strErrorMessage = 'No se ha marcado el check del Gestor';
                    }
                }else{
                    strErrorMessage = 'No se logro relacionar el servicio asociado a un producto que soporte la Integracion';
                }
                
                strFuenteIncidente = objCase.Fuente_Reportada_Legado__c;
                BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
                Map<Id,Map<String,Object>> mapDatos = sc.GenerarDatamapCaso(lstCaso,'Homologacion_Remedy__mdt');
                sglDataMap = mapDatos.get(objCase.Id);
                strEstadoIni = objCase.Causal_Estado__c;
            }
        }catch(Exception e){
            strErrorMessage = e.getMessage();
        }
        system.debug(strErrorMessage);
	}

    public void CargarSubResponsable(){
        lstSubResponsable = new List<SelectOption>();
        system.debug('CargarSubResponsable - '+strResponsable);
        if(String.isNotEmpty(strResponsable)){
            List<LV_Remedy__mdt> lstlvSubResponsable = [SELECT Id,Valor_Usuario__c,Valor_API__c FROM LV_Remedy__mdt WHERE Tipo_Lista__c = 'SUBRESPONSABLE' AND Tipo_Lista_Padre__c = 'RESPONSABLE' AND Valor_API_Padre__c = :strResponsable];
            system.debug(lstlvSubResponsable);
            if(!lstlvSubResponsable.isEmpty()){
                for(LV_Remedy__mdt sgllvSubResponsable:lstlvSubResponsable){
                    lstSubResponsable.add(new SelectOption(sgllvSubResponsable.Valor_API__c,sgllvSubResponsable.Valor_Usuario__c));
                }
                if(String.isEmpty(strSubResponsable))
                    strSubResponsable=lstlvSubResponsable[0].Valor_API__c;
                system.debug(lstSubResponsable);
            }else{
                if(String.isEmpty(strSubResponsable))
                    strSubResponsable='';
                lstSubResponsable.add(new SelectOption(strSubResponsable,strSubResponsable));
            }
        }else{
            lstSubResponsable.add(new SelectOption('',''));
            strSubResponsable='';
        }
    }
	
	public PageReference validacionInicial()
	{
        system.debug('strErrorMessage'+strErrorMessage);
		if(String.isNotEmpty(strErrorMessage))
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,strErrorMessage));
		}
		return null;
	}
    
    public PageReference ConsultarTareasRemedy(){
        String strErrMessage = '';
        try{
            blnMostrarTareas = false;
            
            BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
            Map<Integer,BusinessLogic_Caso_ctr.TareasRemedy> mpTareas = new Map<Integer,BusinessLogic_Caso_ctr.TareasRemedy>();
            
            Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
            mapDatos.put(objCase.Id,sglDataMap);
            mpTareas = sc.ConsultaTareasRemedy(objCase, mapDatos);
            if(!mpTareas.isEmpty()){
                if(mpTareas.containskey(0)){
                    strErrMessage = mpTareas.get(0).TaskID;
                }else{
                    lstTareas = mpTareas.values();
                    if(!lstTareas.isEmpty()){
                        blnMostrarTareas = true;
                        intTotalTareasRemedy = Integer.valueof(Math.ceil(lstTareas.size()/10));
                        intActualTareasRemedy = 1;
                    }
                }
            }
        }catch(Exception e){
            strErrMessage = e.getMessage();
        }
        if(String.isNotEmpty(strErrMessage)){
            system.debug(strErrMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strErrMessage));
        }
        return null;
    }
    
	@future(callout=true)
    public static void SincronizarNota(String strNota, Id id){
        String strErrMessage = '';
        try{
            if(String.isNotEmpty(strNota)){
                Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Caso Remedy PS'];
                String sParamFields = lstMensajes.Mensaje__c;
                String selectParametersQuery = 'SELECT ' + sParamFields + ' FROM Case where Id =:id';
                list<Case> lstCaso = Database.query(selectParametersQuery);
                Case objCase = lstCaso[0];
                
                Map<String,Object> sglDataMap = new Map<String,Object>();
                BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
                Map<Id,Map<String,Object>> mapDatos = sc.GenerarDatamapCaso(lstCaso,'Homologacion_Remedy__mdt');
                sglDataMap = mapDatos.get(objCase.Id);
                
                Datetime dtFecha = Datetime.now();
                Map<String,String> mapNota = new Map<String,String>();
                mapNota.put('Descripcion',strNota);
                mapNota.put('FechaCreacion',dtFecha.format('yyyy-MM-dd\'T\'HH:mm:ssXXX','America/Bogota'));
                sglDataMap.put('Nota',mapNota);
                mapDatos.put(objCase.Id,sglDataMap);
                
                strErrMessage = sc.CreaNotaRemedy(objCase, mapDatos);
                String strdesc = strNota;
                if (strdesc.contains('\n'))
                {
                    strdesc = '<p>' + strdesc.replaceAll('\n','</p><p>') + '</p>';
                }
                
                String sUsuarioNota = '';
                if(sglDataMap.containskey('Homologacion')){
                    Map<String,Object> tmpMap = (Map<String,Object>)sglDataMap.get('Homologacion');
                    if(tmpMap.containskey('PERMISOS')){
                        List<Map<String,Object>> lstHomologacion = (List<Map<String,Object>>)tmpMap.get('PERMISOS');
                        for(Map<String,Object> sglHomologacion:lstHomologacion){
                            if(sglHomologacion.containskey('Valor_Usuario__c') && sglHomologacion.containskey('Valor_API__c')){
                                if(String.valueOf(sglHomologacion.get('Valor_API__c'))=='OWNER_NOTE'){
                                    if(String.isNotEmpty(String.valueOf(sglHomologacion.get('Valor_Usuario__c')))){
                                        sUsuarioNota = String.valueOf(sglHomologacion.get('Valor_Usuario__c'));
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                List<User> uOwnerNote = [SELECT Id FROM User WHERE UserName = :sUsuarioNota];
                ContentNote sglComment = new ContentNote();
                sglComment.Title = 'Seguimiento Remedy';
                sglComment.Content = Blob.valueOf(strdesc);
                if(!uOwnerNote.isEmpty())
                    sglComment.OwnerId = uOwnerNote[0].Id;
                insert sglComment;
                insert new ContentDocumentLink(LinkedEntityId=objCase.Id , ContentDocumentId=sglComment.Id, ShareType='V');
                /*
                CaseComment objNota = new CaseComment();
                objNota.CommentBody = strNota;
                objNota.ParentId = objCase.Id;
                insert objNota;
				*/
            }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            strErrMessage = e.getMessage();
        }
    }
    
    public PageReference Actualizar(){
        String strErrMessage = '';
        PageReference returnPage = null;
        try{
            BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
            Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
            if(blnActualizarEstado){
                String strEstadoAPI = String.isEmpty(objCase.EstadoSistemaLegado__c)?'':objCase.EstadoSistemaLegado__c;
                List<Homologacion_Remedy__mdt> lstHomologacionEstados = new List<Homologacion_Remedy__mdt>();
                if(objCase.Categoria_legado__c=='Incidente'){
                    List<Homologacion_Remedy__mdt> lstHomologacionEstadosTmp = [SELECT Id,Valor_API__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'ESTADO_REMEDY' AND Valor_Usuario__c = :objCase.Causal_Estado__c AND Valor_API__c != :strEstadoAPI];
                    if(!lstHomologacionEstadosTmp.isEmpty()){
                        lstHomologacionEstados = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'MATRIZ_REMEDY_ESTADO_INC' AND Valor_Usuario__c = :lstHomologacionEstadosTmp[0].Valor_API__c AND Valor_API__c = :strEstadoAPI];
                    }
                }else{
                    lstHomologacionEstados = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'ESTADO_REENVIO' AND Valor_Usuario__c = :objCase.Causal_Estado__c AND Valor_API__c != :strEstadoAPI];
                }
                if(lstHomologacionEstados.isEmpty()){
                    strErrMessage = 'Estado no valido para la integracion';
                    if(String.isNotEmpty(strNota)){
                        strErrMessage = '';
                    }
                }else{
                    sglDataMap.put('Causal_Estado__c',objCase.Causal_Estado__c);
                    sglDataMap.put('SubCausal_Estado__c',String.isEmpty(objCase.SubCausal_Estado__c)?'':objCase.SubCausal_Estado__c);
                    mapDatos.put(objCase.Id,sglDataMap);
                    strErrMessage = sc.ActualizaRemedy(objCase, mapDatos);
                    if(String.isEmpty(strErrMessage)){
                        if(sglDataMap.containskey('Homologacion')){
                            Map<String,Object> tmpMap = (Map<String,Object>)sglDataMap.get('Homologacion');
                            if(tmpMap.containskey('ESTADO_REMEDY')){
                                List<Map<String,Object>> lstHomologacion = (List<Map<String,Object>>)tmpMap.get('ESTADO_REMEDY');
                                for(Map<String,Object> sglHomologacion:lstHomologacion){
                                    if(sglHomologacion.containskey('Valor_Usuario__c')){
                                        if(sglHomologacion.get('Valor_Usuario__c')==objCase.Causal_Estado__c){
                                            objCase.CategoriaResolucionN1__c = '';
                                            objCase.CategoriaResolucionN2__c = '';
                                            objCase.CategoriaResolucionN3__c = '';
                                            objCase.CategoriaResolucionN4__c = '';
                                            objCase.CategoriaResolucionN5__c = '';
                                            objCase.SolucionSistemaLegado__c = '';
                                            objCase.EstadoSistemaLegado__c = (String)sglHomologacion.get('Valor_API__c');
                                            objCase.FechaResolucionSistemaLegado__c = null;  
                                            objCase.Pertinencia_Horas__c = null;
                                            objCase.Pertinencia_Minutos__c = null;
                                            objCase.Pertinencia_Segundos__c = null;
                                            objCase.Codigo_Cierre__c = '';
                                            objCase.Responsable_Legado__c = '';
                                            objCase.SubResponsable_Legado__c = '';
                                        }
                                    }
                                }
                            }
                        }
                        update objCase;
                    }
                }
            }
            system.debug(strErrMessage);
            if(String.isEmpty(strErrMessage)){
                if(String.isNotEmpty(strNota)){
                    SincronizarNota(strNota, objCase.Id);
                    returnPage = new PageReference('/' + objCase.Id);
                    returnPage.setRedirect(true);
                    return returnPage;
                }
            }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            strErrMessage = e.getMessage();
        }
        if(String.isNotEmpty(strErrMessage)){
            system.debug(strErrMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strErrMessage));
        }else{
            returnPage = new PageReference('/' + objCase.Id);
            returnPage.setRedirect(true);
            return returnPage;
        }
    	return returnPage;
    }
    
    public PageReference IntegrarTareasRemedy(){
        String strErrMessage = '';
        try{
            BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
            
            for(Tareas_Salesforce sglTareasSF:lstTareasSalesforce){
                if(sglTareasSF.IntegrarLegado){
                    Map<String,String> mapTareas = new Map<String,String>();
                    mapTareas.put('Subject',sglTareasSF.objTarea.Subject);
                    mapTareas.put('Description',sglTareasSF.objTarea.Description);
                    mapTareas.put('Id',sglTareasSF.objTarea.Id);
                    mapTareas.put('Grupo_Aseguramiento__r.Nivel3__c',sglTareasSF.objTarea.Grupo_Aseguramiento__r.Nivel3__c);
                    mapTareas.put('ConsecutivodeTareas__c',sglTareasSF.objTarea.ConsecutivodeTareas__c);
                    sglDataMap.put('Tarea',mapTareas);
                    
                    Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
                    mapDatos.put(objCase.Id,sglDataMap);
                    strErrMessage = sc.CreaTareaRemedy(objCase, sglTareasSF.objTarea, mapDatos);
                }
            }
        }catch(Exception e){
            strErrMessage = e.getMessage();
        }
        if(String.isNotEmpty(strErrMessage)){
            system.debug(strErrMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strErrMessage));
        }
        return null;
    }

	public PageReference guardar()
    {
    	PageReference returnPage;
    	//si la URL tiene id como parametro, se actualizará dicho registro.

        if ( ApexPages.currentPage().getParameters().get('Id') != null)
        {
        	Datetime datToday 		= system.now();
            String strFechaIncidente =objCase.CreatedDate.format('MM/dd/yyyy hh:mm:ss');
        	String strCorrelationId = objCase.Id + system.now().format('yyyyMMddhhmmss');
            strFuenteIncidente = String.isEmpty(strFuenteIncidente)?'':strFuenteIncidente;
            //objCase.Id 				= ApexPages.currentPage().getParameters().get('Id');
            //objCase.LTE_Garantia__c	= strGarantiaSelec;
            
            String TipoCaso = '';
            VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
            
            if(strLineaNegocio == 'LTE'){
                String strRequest 				= LTE_Aseguramiento_cls.remedy(objCase, strCorrelationId,strFechaIncidente,strFuenteIncidente);
                system.debug('REQUEST REMEDY---------->' + strRequest);
                invocarServicioRemedy(strRequest);
            }if(strLineaNegocio == 'Aliado'){
                String strErrMessage = '';
                String response = '';
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('OrchAliadoCasos');
                system.debug(sglDataMap.get('LTE_Servicio__r.Fecha_Activacion__c'));
                //system.debug((Date.valueOf(sglDataMap.get('LTE_Servicio__r.Fecha_Activacion__c'))));
                String sActivacionDt = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                
                String sParametros = '[\n';
                if(sglDataMap.containskey('ParametrosXA')){
                    List<Map<String,Object>> lstTmpXA = (List<Map<String,Object>>)sglDataMap.get('ParametrosXA');
                    integer i = 0;
                    for(Map<String,Object> sglTmpXA:lstTmpXA){
                        i++;
                        sParametros += '{\n';
                        sParametros += '"Nombre":"'+sglTmpXA.get('Name')+'",\n';
                        sParametros += '"Valor":"'+sglTmpXA.get('LTE_Value__c')+'",\n';
                        sParametros += '"CodigoAccion":"'+sglTmpXA.get('LTE_ActionCode__c')+'",\n';
                        sParametros += '"Grupo":"'+sglTmpXA.get('LTE_ServiciosAdicionales__r.Name')+'",\n';
                        sParametros += '"Tipo":"Nuevo"\n';
                        sParametros += (i<lstTmpXA.Size())?'},\n':'}\n';
                    }
                }
                sParametros += ']';
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(sw.EndPoint__c);
                req.setMethod('POST');
                req.setHeader( 'Content-Type', 'application/json' );
                String srequest = '{\n'+
                    '"NumeroTiquete":"'+String.ValueOf(sglDataMap.get('CaseNumber'))+'",\n'+
                    '"Asunto":"'+String.ValueOf(sglDataMap.get('Subject'))+'",\n'+
                    '"Descripcion":"'+String.ValueOf(sglDataMap.get('Description'))+'",\n'+
                    //'"FechaInicio":"'+ (((DateTime)sglDataMap.get('LTE_Servicio__r.Fechaderadicacion__c')).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) +'",\n'+
                    //'"FechaLimite":"'+ (((DateTime)sglDataMap.get('LTE_Servicio__r.Fecha_limite__c')).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) +'",\n'+
                    '"Tipo":"",\n'+
                    '"Prioridad":"",\n'+
                    '"Estado":"Pendiente",\n'+
                    '"Comentarios":"' + (String.isEmpty(strNota)?'':strNota) + '",\n'+
                    '"SistemaOrigen":"Salesforce",\n'+
                    '"NumeroTiquetePadre":"'+String.ValueOf(sglDataMap.get('LTE_Servicio__r.Parent.CaseNumber'))+'",\n'+
                    '"Cliente":{\n'+
                        '"TipoDocumento":"'+String.ValueOf(sglDataMap.get('Account.Tipodedocumento__c'))+'",\n'+
                        '"NumeroDocumento":"'+String.ValueOf(sglDataMap.get('Account.AccountNumber'))+'",\n'+
                        '"Nombre":"'+String.ValueOf(sglDataMap.get('Account.Name'))+'",\n'+
                        '"Direccion":"'+String.ValueOf(sglDataMap.get('Account.Direccion__c'))+'",\n'+
                        '"UEN":"'+String.ValueOf(sglDataMap.get('Account.UEN__c'))+'",\n'+
                        '"Segmento":"'+String.ValueOf(sglDataMap.get('Account.Segmento__c'))+'",\n'+
                        '"SegmentoUEN":"'+String.ValueOf(sglDataMap.get('Account.SubSegmento__c'))+'",\n'+
                        '"Categoria":"'+String.ValueOf(sglDataMap.get('Account.Esquema_de_Atencion__c'))+'"\n'+
                    '},\n'+
                    '"Contactos":[\n{\n'+
                        	'"CodigoContacto":"'+String.ValueOf(sglDataMap.get('ContactId'))+'",\n'+
                        	'"Nombres":"'+String.ValueOf(sglDataMap.get('Contact.FirstName'))+'",\n'+
                        	'"Apellidos":"'+String.ValueOf(sglDataMap.get('Contact.LastName'))+'",\n'+
                        	'"CorreoElectronico":"'+String.ValueOf(sglDataMap.get('Contact.Email'))+'",\n'+
                        	'"Telefono":"'+String.ValueOf(sglDataMap.get('Contact.Phone'))+'",\n'+
                        	'"TelefonoMovil":"'+String.ValueOf(sglDataMap.get('Contact.MobilePhone'))+'",\n'+
                        	'"Direccion":"'+String.ValueOf(sglDataMap.get('Contact.Direccion__c'))+'",\n'+
                        	'"AutorizaDatos":"'+String.ValueOf(sglDataMap.get('Contact.Autoriza_Tratamiento_de_Datos_Personales__c'))+'",\n'+
                        	'"Tipo":"Contacto Tecnico"\n'+
                    '}\n],\n'+
                    '"Parametros":[\n{\n'+
                        '"Nombre":"Codigo Tipologia",\n'+
                        '"Valor":"'+String.ValueOf(sglDataMap.get('Matriz_de_Tipificacion__r.Id_Externo__c'))+'"\n'+
                    '}\n,{\n'+
                        '"Nombre":"Nivel 1",\n'+
                        '"Valor":"'+String.ValueOf(sglDataMap.get('Matriz_de_Tipificacion__r.Nivel_1__c'))+'"\n'+
                    '}\n,{\n'+
                        '"Nombre":"Nivel 2",\n'+
                        '"Valor":"'+String.ValueOf(sglDataMap.get('Matriz_de_Tipificacion__r.Nivel_2__c'))+'"\n'+
                    '}\n,{\n'+
                        '"Nombre":"Nivel 3",\n'+
                        '"Valor":"'+String.ValueOf(sglDataMap.get('Matriz_de_Tipificacion__r.Nivel_3__c'))+'"\n'+
                    '}\n],\n'+
                    '"Servicios":[\n{\n'+
                    '"NumeroServicio ":"'+String.ValueOf(sglDataMap.get('LTE_Servicio__r.Name'))+'",\n'+
                    '"IdServicio ":"'+String.ValueOf(sglDataMap.get('LTE_Servicio__r.IDservicio__c'))+'",\n'+
                    '"TipoRelacion ":"Principal Afectado",\n'+
                    '"Estado ":"'+String.ValueOf(sglDataMap.get('LTE_Servicio__r.Estado__c'))+'",\n'+
                    '"CodigoProducto ":"'+String.ValueOf(sglDataMap.get('LTE_Servicio__r.Plan__r.Codigo_Plan__c'))+'",\n'+
                    '"ClaseProducto ":"eCommerce ViveTech Class",\n'+
                    '"FechaActivacion ":"'+ sActivacionDt +'",\n'+
                    '"Parametros":'+sParametros+'\n'+
                    '}\n]\n'+
                    
                    '}';
                
                req.setBody(srequest);
                try{
                    HttpResponse res = h.send(req);
                    response = res.getBody();
                    LogTransacciones__c logServicio = new LogTransacciones__c();
                    //logServicio.put(sCampoRelacionLog,sglRecord);
                    logServicio.Caso__c = String.ValueOf(sglDataMap.get('Id'));
                    logServicio.Name = 'Envio ViveTech - '+String.ValueOf(sglDataMap.get('CaseNumber'));
                    logServicio.Informacion_Enviada__c = srequest;
                    logServicio.Informacion_Recibida__c = response;
                    insert logServicio;
                }catch(Exception e){
                    response = e.getMessage();
                    strErrMessage=response;
                }
                if(String.isNotEmpty(strErrMessage)){
                    system.debug(strErrMessage);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strErrMessage));
                    return null;
                }
            }
            else if(strLineaNegocio == 'Portafolio Superior'){
                objCase.Fuente_Reportada_Legado__c = strFuenteIncidente;
                List<Case> lstCaso = new List<Case>();
                lstCaso.add(objCase);
                BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
                Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
                if(objCase.Estimado_Afectados__c==null){objCase.Estimado_Afectados__c=1;}
                sglDataMap.put('FuenteReportada',strFuenteIncidente);
                sglDataMap.put('Estimado_Afectados__c',String.valueOf(objCase.Estimado_Afectados__c));
                sglDataMap.put('Grupo',objCase.Grupo_Aseguramiento__r.ID_externo__c);
                sglDataMap.put('Nota',String.isEmpty(strNota)?'':strNota);
                sglDataMap.put('Responsable_Legado__c',String.isEmpty(strResponsable)?'':strResponsable);
                sglDataMap.put('SubResponsable_Legado__c',String.isEmpty(strSubResponsable)?'':strSubResponsable);
                mapDatos.put(objCase.Id,sglDataMap);
                String strErrMessage = sc.EnvioRemedy(lstCaso,mapDatos);
                if(String.isNotEmpty(strErrMessage)){
                    system.debug(strErrMessage);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,strErrMessage));
                    return null;
                }
            }
            
            try{
                update objCase;
            }
            catch(exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error al actualizar el caso: '+e.getMessage()));
                return null;
            }

            returnPage = new PageReference('/' + objCase.Id);
            returnPage.setRedirect(true);
        }
    	return returnPage;
    }

    public List<SelectOption> getFuenteIncidente() {
        List<SelectOption> incidentOptions = new List<SelectOption>();
        List<Homologacion_Remedy__mdt> lstHomologacion = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'FUENTE_REPORTADA_LTE'];
        
        if ( ApexPages.currentPage().getParameters().get('Id') != null)
        {
            System.debug('strLineaNegocio: '+strLineaNegocio);
            if(strLineaNegocio == 'Portafolio Superior'){
                lstHomologacion = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'FUENTE_REPORTADA'];
            }
        }
        for(Homologacion_Remedy__mdt sglOption:lstHomologacion){
            incidentOptions.add(new SelectOption(sglOption.Valor_Usuario__c,sglOption.Valor_Usuario__c));
        }
        return incidentOptions;
    }

    public void invocarServicioRemedy(String strRequest)
    {
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('Remedy');
        LogTransacciones__c log=new LogTransacciones__c();
        String strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest,sw.Action__c,sw.EndPoint__c);
        System.debug('Response----------->' + strResponse);
        map<string,string> values=new map<string,string>();
        
        tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();            
        values=proReq.getMap(strResponse);
        
        system.debug('\n Estado en Remedy: \n'+values.get('acknowledge')); 
        system.debug('\n Estado en Remedy: \n'+values); 
        system.debug(objCase);
        
        if(values.get('status')=='PASS' && values.get('acknowledge')=='Exitoso')
        {
            log.Estado__c='Envío a Remedy exitoso';
            objCase.LTE_EstEnvioSistLegado__c = 'Exitoso';
            objCase.LTE_IntentosSistemaLegado__c = 0;
        }
        else
        {
            log.Estado__c='Fallo en remedy';  
            objCase.LTE_EstEnvioSistLegado__c = 'Fallido';
            objCase.LTE_IntentosSistemaLegado__c = objCase.LTE_IntentosSistemaLegado__c != null ? objCase.LTE_IntentosSistemaLegado__c + 1 : 1;                    
        }
        
        log.Informacion_Enviada__c=strRequest;
        log.Informacion_Recibida__c=strResponse;
        log.Name='Remedy: '+objCase.CaseNumber;
        log.Caso__c =objCase.Id;
        insert log;
        system.debug('\n Log transacciones del SW Remedy: \n'+log.Id);        
	}
    
    public class Tareas_Salesforce{
        public Task objTarea {get; set;}
        public Boolean IntegrarLegado {get; set;}
        public Boolean validoIntegracion {get{ return String.isEmpty(objTarea.Id_externo__c);}}
    }
}