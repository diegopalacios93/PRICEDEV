/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase que implementa los métodos necesarios para las funcionalidades en el objeto Case.
					Clases de Test: LTE_Remedy_tst, IntegracionRemedy_tst

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-07-12   John Guevara (ETB)   	  Creación de la clase.
***********************************************************************************************************************/
public class BusinessLogic_Caso_ctr {

    public static Map<String,String> ActualizarCaso(Map<String,Object> mapParametrosEntrada){
        Map<String,String> mpDatos = new Map<String,String>();
        String sreturn = '';
        String idCaso = '';
        String IdSistemaLegado = '';
        String NumeroCaso = '';
        Boolean blnMasivo = false;
        
        List<Homologacion_Remedy__mdt> lstHomologacion = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt];
        Map<String,Map<String,String>> mpHomologaciones = new Map<String,Map<String,String>>();
        for(Homologacion_Remedy__mdt sglHomologacion:lstHomologacion){
            if(mpHomologaciones.containskey(sglHomologacion.Tipo_Lista__c)){
                mpHomologaciones.get(sglHomologacion.Tipo_Lista__c).put(sglHomologacion.Valor_API__c,sglHomologacion.Valor_Usuario__c);
            }else{
                Map<String,String> tmpHomologacion = new Map<String,String>();
                tmpHomologacion.put(sglHomologacion.Valor_API__c,sglHomologacion.Valor_Usuario__c);
                mpHomologaciones.put(sglHomologacion.Tipo_Lista__c,tmpHomologacion);
            }
        }
        
        if(mapParametrosEntrada!=null){
            Case nCaso;
            if(mapParametrosEntrada.containskey('Id')){
                idCaso = mapParametrosEntrada.get('Id').toString();
                if(String.isNotEmpty(idCaso)){
                    List<Case> lstCasos = [SELECT Id,Id_Sistema_Legado__c,CaseNumber FROM Case WHERE Id = :idCaso];
                    if(!lstCasos.isEmpty()){
                        nCaso = lstCasos[0];
                    }else{
                        sreturn = 'El Identificador del caso no es valido';
                        mpDatos.put('Error',sreturn);
                        return mpDatos;
                    }
                }
            }
            
            if(mapParametrosEntrada.containskey('Case')){
                Map<String,Object> mptmpCase = (Map<String,Object>)mapParametrosEntrada.get('Case');
                Case CasoEntrada = (Case)mptmpCase.get('Case');
                if(mptmpCase.containskey('Param_Case')){
                    system.debug('Param_Case');
                    Map<String,Object> mptmpCaseParam = (Map<String,Object>)mptmpCase.get('Param_Case');
                    if(mptmpCaseParam.containskey('NumeroDocumento')){
                        String NumDoc = String.valueof(mptmpCaseParam.get('NumeroDocumento'));
                        if(String.isNotEmpty(NumDoc)){
                            List<Account> lsttmpAcc = [SELECT Id FROM Account WHERE (AccountNumber = :NumDoc OR External_Id__c = :NumDoc) AND RecordType.Name = 'Cliente Principal'];
                            if(!lsttmpAcc.isEmpty()){
                                CasoEntrada.AccountId = lsttmpAcc[0].Id;
                            }
                        }
                    }
                    if(mptmpCaseParam.containskey('GrupoAseguramiento')){
                        String sGrupAseg = String.valueof(mptmpCaseParam.get('GrupoAseguramiento'));
                        if(String.isNotEmpty(sGrupAseg)){
                            List<Grupo_Aseguramiento__c> lsttmpGAseg = [SELECT Id FROM Grupo_Aseguramiento__c WHERE ID_externo__c = :sGrupAseg];
                            if(!lsttmpGAseg.isEmpty()){
                                CasoEntrada.Grupo_Aseguramiento__c = lsttmpGAseg[0].Id;
                            }
                        }
                    }
                    system.debug('Parent'+mptmpCaseParam.containskey('ParentId'));
                    if(mptmpCaseParam.containskey('FallaMasiva')){
                        String sFallas = String.valueof(mptmpCaseParam.get('FallaMasiva'));
                        if(sFallas=='Si'){blnMasivo=true;}
                    }
                    
                    
                    
                    if(mptmpCaseParam.containskey('ID_Servicio')){
                        String IdServicio = String.valueof(mptmpCaseParam.get('ID_Servicio'));
                        if(String.isNotEmpty(IdServicio)){
                            List<ActivoETB__c> lsttmpAcc = [SELECT Id FROM ActivoETB__c WHERE IDservicio__c = :IdServicio];
                            if(!lsttmpAcc.isEmpty()){
                                CasoEntrada.LTE_Servicio__c = lsttmpAcc[0].Id;
                            }
                        }
                    }
                }
            	
                if(String.isNotEmpty(idCaso)){
                    //Actualizacion de caso, solo se actualizan los valores que vengan del sistema legado
                    if(String.isNotEmpty(CasoEntrada.CategoriaResolucionN1__c))
                        nCaso.CategoriaResolucionN1__c = CasoEntrada.CategoriaResolucionN1__c;
                    if(String.isNotEmpty(CasoEntrada.CategoriaResolucionN2__c))
                        nCaso.CategoriaResolucionN2__c = CasoEntrada.CategoriaResolucionN2__c;
                    if(String.isNotEmpty(CasoEntrada.CategoriaResolucionN3__c))
                        nCaso.CategoriaResolucionN3__c = CasoEntrada.CategoriaResolucionN3__c;
                    if(String.isNotEmpty(CasoEntrada.CategoriaResolucionN4__c))
                        nCaso.CategoriaResolucionN4__c = CasoEntrada.CategoriaResolucionN4__c;
                    if(String.isNotEmpty(CasoEntrada.CategoriaResolucionN5__c))
                        nCaso.CategoriaResolucionN5__c = CasoEntrada.CategoriaResolucionN5__c;
                    if(String.isNotEmpty(CasoEntrada.SolucionSistemaLegado__c))
                        nCaso.SolucionSistemaLegado__c = CasoEntrada.SolucionSistemaLegado__c;
                    if(CasoEntrada.FechaResolucionSistemaLegado__c!=null)
                        nCaso.FechaResolucionSistemaLegado__c = CasoEntrada.FechaResolucionSistemaLegado__c;
                    if(CasoEntrada.Id_Sistema_Legado__c!=null)
                        nCaso.Id_Sistema_Legado__c = CasoEntrada.Id_Sistema_Legado__c;
                    if(CasoEntrada.ParentId!=null)
                        nCaso.ParentId = CasoEntrada.ParentId;
                    if(CasoEntrada.Pertinencia_Horas__c!=null)
                        nCaso.Pertinencia_Horas__c = CasoEntrada.Pertinencia_Horas__c;
                    if(CasoEntrada.Pertinencia_Minutos__c!=null)
                        nCaso.Pertinencia_Minutos__c = CasoEntrada.Pertinencia_Minutos__c;
                    if(CasoEntrada.Pertinencia_Segundos__c!=null)
                        nCaso.Pertinencia_Segundos__c = CasoEntrada.Pertinencia_Segundos__c;
                    if(CasoEntrada.FechaFinAfectacion__c!=null)
                        nCaso.FechaFinAfectacion__c = CasoEntrada.FechaFinAfectacion__c;
                    if(CasoEntrada.Codigo_Cierre__c!=null)
                        nCaso.Codigo_Cierre__c = CasoEntrada.Codigo_Cierre__c;
                    if(CasoEntrada.Responsable_Legado__c!=null)
                        nCaso.Responsable_Legado__c = CasoEntrada.Responsable_Legado__c;
                    if(CasoEntrada.SubResponsable_Legado__c!=null)
                        nCaso.SubResponsable_Legado__c = CasoEntrada.SubResponsable_Legado__c;
                    if(String.isNotEmpty(CasoEntrada.EstadoSistemaLegado__c)){
                        nCaso.EstadoSistemaLegado__c = CasoEntrada.EstadoSistemaLegado__c;
                        if(mpHomologaciones.containskey('ESTADO_REMEDY')){
                            if(mpHomologaciones.get('ESTADO_REMEDY').containskey(nCaso.EstadoSistemaLegado__c)){
                                nCaso.Status = mpHomologaciones.get('ESTADO_REMEDY').get(nCaso.EstadoSistemaLegado__c);
                            }
                        }
                        if(mpHomologaciones.containskey('ESTADO_CIERRE')){
                            if(mpHomologaciones.get('ESTADO_CIERRE').containskey(nCaso.EstadoSistemaLegado__c)){
                                nCaso.Status = mpHomologaciones.get('ESTADO_CIERRE').get(nCaso.EstadoSistemaLegado__c);
                                nCaso.Comments = String.isNotEmpty(CasoEntrada.SolucionSistemaLegado__c)?(CasoEntrada.SolucionSistemaLegado__c.length()>4000?CasoEntrada.SolucionSistemaLegado__c.substring(0,3500):CasoEntrada.SolucionSistemaLegado__c):'';
                                if(CasoEntrada.Responsable_Legado__c!=null)
                                    nCaso.DescripcionSolucion__c = CasoEntrada.Responsable_Legado__c=='Cliente'?'NO Accede':'Accede';
                                if(CasoEntrada.SubResponsable_Legado__c!=null)
                                	nCaso.Arearesponsable__c = String.isNotEmpty(CasoEntrada.SubResponsable_Legado__c)?CasoEntrada.SubResponsable_Legado__c:'';
                                if(CasoEntrada.Codigo_Cierre__c!=null)
                                    nCaso.CausaImputabilidad__c = String.isNotEmpty(CasoEntrada.Codigo_Cierre__c)?CasoEntrada.Codigo_Cierre__c:'';
                            }
                        }
                        if(mpHomologaciones.containskey('ESTADO_REMEDY_IN')){
                            if(mpHomologaciones.get('ESTADO_REMEDY_IN').containskey(nCaso.EstadoSistemaLegado__c)){
                                nCaso.Causal_Estado__c = mpHomologaciones.get('ESTADO_REMEDY_IN').get(nCaso.EstadoSistemaLegado__c);
                            }
                        }
                    }
                }else{
                    //Creacion de caso: Se crea con los campos que informe el sistema legado
                        system.debug('Param_Case');
                    
                        system.debug('blnMasivo'+blnMasivo);
                    
                    if(String.isNotEmpty(CasoEntrada.Id_Sistema_Legado__c)){
                        nCaso = CasoEntrada;
                        Id stRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SOPORTE TECNICO').getRecordTypeId();
                        nCaso.RecordTypeId = stRecordTypeId;
                        nCaso.Origin = 'Proactivos';
                        nCaso.LTE_SistemaLegado__c='Remedy';
                        nCaso.Integrar_con_gestor__c=true;
                        nCaso.FechaTipificacion__c=System.now();
                        nCaso.TipoCaso__c='SOPORTE TECNICO';
                    }else{
                        sreturn = 'Se debe suministrar Id Sistema Legado y Cuenta Cliente';
                        mpDatos.put('Error', sreturn);
                        return mpDatos;
                    }
                }
            }
            
            if(nCaso!=null){
                
                Savepoint sp = Database.setSavepoint();
                
                try{
                    if(blnMasivo){
                        nCaso.Categoria_legado__c = 'Masivo';
                    }
                    upsert nCaso;
                    nCaso = [SELECT Id,Id_Sistema_Legado__c,CaseNumber,Subject FROM Case WHERE Id = :nCaso.Id];
                }catch(exception ex){
                    Database.rollback(sp);
                    sreturn = 'Error en la entidad caso: '+ex.getMessage();
                    mpDatos.put('Error', sreturn);
                    return mpDatos;
                }
                idCaso = nCaso.Id;
                IdSistemaLegado = nCaso.Id_Sistema_Legado__c;
                NumeroCaso = nCaso.CaseNumber;
                system.debug('idCaso: '+idCaso);
                
                if(mapParametrosEntrada.containskey('CaseComments')){
                    /*
                    List<Map<String,Object>> lstmpCaseComment = (List<Map<String,Object>>)mapParametrosEntrada.get('CaseComments');
                    if(!lstmpCaseComment.isEmpty()){
                        List<CaseComment> lstCaseComment = new List<CaseComment>();
                        for(Map<String,Object> mpCaseComment : lstmpCaseComment){
                            if(!mpCaseComment.isEmpty()){
                                if(mpCaseComment.containskey('CaseComment')){
                                    CaseComment sglComment = (CaseComment)mpCaseComment.get('CaseComment');
                                    sglComment.ParentId = idCaso;
                                    if(mpCaseComment.containskey('Param_CaseComment')){
                                        Map<String,Object> mpParametrosDinamicos = (Map<String,Object>)mpCaseComment.get('Param_CaseComment');
                                        if(mpParametrosDinamicos.containsKey('Id')){
                                            sglComment.Id = mpParametrosDinamicos.get('Id').toString();
                                        }
                                    }
                                    
                                    lstCaseComment.add(sglComment);
                                }
                            }
                        }
                        
                        try{
                            if(!lstCaseComment.isEmpty())
                                upsert lstCaseComment;
                        }catch(exception ex){
                            Database.rollback(sp);
                            sreturn = 'Error al insertar los comentarios: '+ex.getMessage();
                            mpDatos.put('Error', sreturn);
                            return mpDatos;
                        }
                    }
					*/
                }
                
                if(mapParametrosEntrada.containskey('Tasks')){
                    List<Map<String,Object>> lstmpTask = (List<Map<String,Object>>)mapParametrosEntrada.get('Tasks');
                    if(!lstmpTask.isEmpty()){
                        List<Task> lstTask = new List<Task>();
                        for(Map<String,Object> mpTask : lstmpTask){
                            if(!mpTask.isEmpty()){
                                if(mpTask.containskey('Task')){
                                    Task sglTask = (Task)mpTask.get('Task');
                                    sglTask.WhatId = idCaso;
                                    if(mpTask.containskey('Param_Task')){
                                        Map<String,Object> mpParametrosDinamicos = (Map<String,Object>)mpTask.get('Param_Task');
                                        if(mpParametrosDinamicos.containsKey('Id')){
                                            sglTask.Id = mpParametrosDinamicos.get('Id').toString();
                                        }
                                    }
                                    lstTask.add(sglTask);
                                }
                            }
                        }
                        
                        try{
                            if(!lstTask.isEmpty())
                                upsert lstTask;
                        }catch(exception ex){
                            Database.rollback(sp);
                            sreturn = 'Error al insertar los comentarios: '+ex.getMessage();
                            mpDatos.put('Error', sreturn);
                            return mpDatos;
                        }
                    }
                }
                
                if(mapParametrosEntrada.containskey('ContentNote')){
                    List<Map<String,Object>> lstmpCaseNote = (List<Map<String,Object>>)mapParametrosEntrada.get('ContentNote');
                    if(!lstmpCaseNote.isEmpty()){
                        system.debug('ContentNote');
                        List<ContentNote> lstCaseNote = new List<ContentNote>();
                        for(Map<String,Object> mpCaseNote : lstmpCaseNote){
                            if(!mpCaseNote.isEmpty()){
                        system.debug('ContentNote22');
                                system.debug(mpCaseNote);
                                if(mpCaseNote.containskey('ContentNote')){
                                    system.debug('ContentNote2');
                                    ContentNote sglComment = (ContentNote)mpCaseNote.get('ContentNote');
                                    sglComment.Title = 'Seguimiento Remedy';
                                    lstCaseNote.add(sglComment);
                                }
                            }
                        }
                        
                        try{
                            if(!lstCaseNote.isEmpty()){
                                insert lstCaseNote;
                                List<ContentDocumentLink> lstCaseNoteLink = new List<ContentDocumentLink>();
                                for(ContentNote sglCaseNote:lstCaseNote){
                                    lstCaseNoteLink.add(new ContentDocumentLink(LinkedEntityId=idCaso , ContentDocumentId=sglCaseNote.Id, ShareType='V'));
                                }
                                insert lstCaseNoteLink;
                            }
                        }catch(exception ex){
                            Database.rollback(sp);
                            sreturn = 'Error al insertar las notas: '+ex.getMessage();
                            mpDatos.put('Error', sreturn);
                            return mpDatos;
                        }
                    }
                }
            }else{
                sreturn = 'No se pasaron los parametros para el caso';
                mpDatos.put('Error', sreturn);
                return mpDatos;
            }
        }else{
            sreturn = 'No se identificaron parametros de entrada';
            mpDatos.put('Error', sreturn);
            return mpDatos;
        }
        if(String.isEmpty(idCaso)){
            sreturn = 'Error al encontrar el caso';
        }
        mpDatos.put('Error', sreturn);
        mpDatos.put('Id', idCaso);
        mpDatos.put('Name', NumeroCaso);
        return mpDatos;
    }
    
    public Map<Id,Map<String,Object>> GenerarDatamapCaso(List<Case> lstCasos,String strListaHomlogacion){
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Caso Remedy PS'];
        String sFields = lstMensajes.Mensaje__c;
        Set<String> setFields = new Set<String>();
        setFields.addAll(sFields.split(','));
        
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        
        //List<SObject> lstHomologacion = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt];
        
        String selectParametersQuery = 'SELECT ' + 'Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c' + ' FROM '+strListaHomlogacion;
        List<SObject> lstHomologacion = Database.query(selectParametersQuery);
        Map<String,Object> tmpMapHierarchy_TipoHomologacion = new Map<String,Object>();
        
        List<Map<String,Object>> lstMapHierarchy_Homologacion = new List<Map<String,Object>>();
        for(SObject sglHomologacion:lstHomologacion){
            if(tmpMapHierarchy_TipoHomologacion.containskey(String.valueof(sglHomologacion.get('Tipo_Lista__c')))){
                lstMapHierarchy_Homologacion = (List<Map<String,Object>>)tmpMapHierarchy_TipoHomologacion.get(String.valueof(sglHomologacion.get('Tipo_Lista__c')));
				Map<String,Object> tmpMapHierarchy_Homologacion = new Map<String,Object>();
                tmpMapHierarchy_Homologacion.put('Valor_API__c',String.valueof(sglHomologacion.get('Valor_API__c')));
                tmpMapHierarchy_Homologacion.put('Valor_Usuario__c',String.valueof(sglHomologacion.get('Valor_Usuario__c')));
                lstMapHierarchy_Homologacion.add(tmpMapHierarchy_Homologacion);
                tmpMapHierarchy_TipoHomologacion.put(String.valueof(sglHomologacion.get('Tipo_Lista__c')),lstMapHierarchy_Homologacion);
            }else{
                lstMapHierarchy_Homologacion = new List<Map<String,Object>>();
				Map<String,Object> tmpMapHierarchy_Homologacion = new Map<String,Object>();
                tmpMapHierarchy_Homologacion.put('Valor_API__c',String.valueof(sglHomologacion.get('Valor_API__c')));
                tmpMapHierarchy_Homologacion.put('Valor_Usuario__c',String.valueof(sglHomologacion.get('Valor_Usuario__c')));
                lstMapHierarchy_Homologacion.add(tmpMapHierarchy_Homologacion);
                tmpMapHierarchy_TipoHomologacion.put(String.valueof(sglHomologacion.get('Tipo_Lista__c')),lstMapHierarchy_Homologacion);
            }
        }
        
        Map<String, Schema.SObjectField> oCaseType = Schema.SObjectType.Case.fields.getMap();
        for(Case sglCaso:lstCasos){
            
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            for(String sglfield:setFields){
                if(oCaseType.containskey(sglfield.trim())){
                    if(oCaseType.get(sglfield.trim()).getDescribe().getType()==Schema.DisplayType.DATETIME){
                        Datetime dtFecha = (Datetime)sglCaso.get(sglfield.trim());
                        Map<String,Object> mapDate = new Map<String,Object>();
                        mapDate.put('fulldate', dtFecha!=null?String.valueOf(dtFecha):'');
                        mapDate.put('GTZ', dtFecha!=null?dtFecha.format('yyyy-MM-dd\'T\'HH:mm:ssXXX','America/Bogota'):'');
                        mapDate.put('day', dtFecha!=null?String.valueOf(dtFecha.day()).leftpad(2,'0'):'');
                        mapDate.put('month', dtFecha!=null?String.valueOf(dtFecha.month()).leftpad(2,'0'):'');
                        mapDate.put('year', dtFecha!=null?String.valueOf(dtFecha.year()):'');
                        tmpMapHierarchy.put(sglfield.trim(),mapDate);
                    }else{
                        tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglCaso, sglfield.trim()));
                    }
                }else{
                    tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglCaso, sglfield.trim()));
                }
                if(tmpMapHierarchy.get(sglfield.trim())==null){
                    tmpMapHierarchy.put(sglfield.trim(), '');
                }
            }
            tmpMapHierarchy.put('Homologacion', tmpMapHierarchy_TipoHomologacion);
            mapHierarchy.put(sglCaso.Id,tmpMapHierarchy.clone());
        }
        system.debug(mapHierarchy);
        return mapHierarchy;
    }
    
    public String EnvioRemedy(List<Case> lstCase, Map<Id,Map<String,Object>> mapDatos){
        String strErrMessage = '';
        ServiciosWeb__c sw;
        List<LogTransacciones__c> lstLogTransacciones = new List<LogTransacciones__c>();
        String sIdCaso = '';
        try{
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Remedy_CrearIncidente_PS' OR Name = 'Remedy_CrearRequerimiento_PS'];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplateIncidente = new Dom.Document();
            docMessageTemplateIncidente.load(mapMensajesIntegracion.get('Remedy_CrearIncidente_PS'));
            
            Dom.Document docMessageTemplateRequerimiento = new Dom.Document();
            docMessageTemplateRequerimiento.load(mapMensajesIntegracion.get('Remedy_CrearRequerimiento_PS'));
            Dom.Document docServices;
            
            for(Case sglCaso:lstCase){
                strErrMessage = '';
                sIdCaso = sglCaso.Id;
                PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
                if(sglCaso.Categoria_legado__c=='Requerimiento')
                    docServices = clsHelper.PopulateXML(docMessageTemplateRequerimiento, mapDatos.get(sglCaso.Id));
                else
                    docServices = clsHelper.PopulateXML(docMessageTemplateIncidente, mapDatos.get(sglCaso.Id));
                DOM.Document docResponse;
                String correlationID = sglCaso.Id;
                
                
                if(sglCaso.Categoria_legado__c=='Requerimiento')
                    sw = ServiciosWeb__c.getValues('Remedy_CreateRequest_PS');
                else
                    sw = ServiciosWeb__c.getValues('Remedy_CreateIncident_PS');
                String endpoint = sw.EndPoint__c;
                String method = sw.Action__c;
                system.debug('Endpoint - '+endpoint+' - '+method);
                //Invocar servicio web 
                PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
                docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
                
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.Caso__c = sglCaso.Id;
                logServicio.Name = 'Envio Remedy Creacion Caso';
                logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
                try{
                    strErrMessage = RespuestaRemedy(docResponse,sglCaso);
                }catch(Exception e){
                    strErrMessage = e.getMessage() + e.getStackTraceString();
                }
                logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
                if(String.isNotEmpty(strErrMessage))
                    logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
                lstLogTransacciones.add(logServicio);
            }
        }catch(Exception e){
            strErrMessage = e.getMessage();
            if(String.isNotEmpty(sIdCaso)){
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.Caso__c = sIdCaso;
                logServicio.Name = 'Envio Remedy Creacion Caso';
                logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
                logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
                lstLogTransacciones.add(logServicio);
            }
        }
        if(!lstLogTransacciones.isEmpty())
        	insert lstLogTransacciones;
        return strErrMessage;
    }
    
    public String RespuestaRemedy(DOM.Document docResponse, Case sglCaso){
        String strErrMessage = 'Error en la integracion';
        sglCaso.LTE_EstEnvioSistLegado__c = 'Fallido';
        if(GetResult(docResponse)){
            if(sglCaso.Categoria_legado__c=='Requerimiento'){
                Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Aknowledge');
                system.debug(responseNode);
                if(ResponseNode.getName() !='Vacio'){
                    if (responseNode.getText() == 'Exitoso'){
                        Dom.XMLNode IdIncidentNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_WorkOrderID');
                        if(IdIncidentNode.getName() !='Vacio'){
                            sglCaso.Id_Sistema_Legado__c = IdIncidentNode.getText();
                            sglCaso.LTE_EstEnvioSistLegado__c = 'Exitoso';
                            strErrMessage = '';
                        }
                    }else{
                        Dom.XMLNode msgErrorRemedy = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Error_Remedy');
                        if(msgErrorRemedy.getName() !='Vacio'){
                            strErrMessage = msgErrorRemedy.getText();
                        }else{
                            Dom.XMLNode msgError = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Error');
                            if(msgError.getName() !='Vacio'){
                                strErrMessage = msgError.getText();
                            }
                        }
                    }
                }
            }else{
                Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Aknowledge');
                
                if(ResponseNode.getName() !='Vacio'){
                    if (responseNode.getText() == 'Exitoso'){
                        Dom.XMLNode IdIncidentNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Incident_ID');
                        if(IdIncidentNode.getName() !='Vacio'){
                            sglCaso.Id_Sistema_Legado__c = IdIncidentNode.getText();
                            sglCaso.EstadoSistemaLegado__c = 'ASIGNADO';
                            sglCaso.LTE_EstEnvioSistLegado__c = 'Exitoso';
                            strErrMessage = '';
                        }
                    }else{
                        Dom.XMLNode msgErrorRemedy = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Error_remedy');
                        if(msgErrorRemedy.getName() !='Vacio'){
                            strErrMessage = msgErrorRemedy.getText();
                        }else{
                            Dom.XMLNode msgError = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Error_Mensaje');
                            if(msgError.getName() !='Vacio'){
                                strErrMessage = msgError.getText();
                            }
                        }
                    }
                }
            }
        }else{
            Dom.XMLNode errorMessageNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'errorMessage');
            if(errorMessageNode.getName() !='Vacio'){
                strErrMessage = errorMessageNode.getText();
            }
        }
        
        sglCaso.LTE_IntentosSistemaLegado__c = sglCaso.LTE_IntentosSistemaLegado__c != null ? sglCaso.LTE_IntentosSistemaLegado__c + 1 : 1;    
        sglCaso.Fecha_Envio_Sistema_Legado__c = Datetime.now();
        system.debug(strErrMessage);
        return strErrMessage;
    }
        
    public Boolean GetResult(DOM.Document docResponse){
        String status = '';
        Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
        if(serviceResponseNode.getName() !='Vacio'){
            status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();
        }
        system.debug('status'+status);
        if (status == 'PASS'){
            return true;
        }
        return false;
    }
    
    public Map<Integer,TareasRemedy> ConsultaTareasRemedy(Case sglCaso, Map<Id,Map<String,Object>> mapDatos){
        Map<Integer,TareasRemedy> mpRespuesta = new Map<Integer,TareasRemedy>();
        String strErrMessage = '';
        try{
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Remedy_ConsultarTareas_PS'];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplate = new Dom.Document();
            docMessageTemplate.load(mapMensajesIntegracion.get('Remedy_ConsultarTareas_PS'));
            
            PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
            Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, mapDatos.get(sglCaso.Id));
            DOM.Document docResponse;
            String correlationID = sglCaso.Id;
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Remedy_ConsultTaskArrayOP_PS');
            String endpoint = sw.EndPoint__c;
            String method = sw.Action__c;
            system.debug('Endpoint - '+endpoint+' - '+method);
            //Invocar servicio web 
            PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
            docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
            
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Caso__c = sglCaso.Id;
            logServicio.Name = 'Envio Remedy Consulta Tareas Caso';
            logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
            logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
            try{
                mpRespuesta = RespuestaConsultaTareasRemedy(docResponse);
                strErrMessage = mpRespuesta.containskey(0)?mpRespuesta.get(0).TaskID:'';
            }catch(Exception e){
                strErrMessage = e.getMessage();
            }
            logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
            if(String.isNotEmpty(strErrMessage))
            	logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
            insert logServicio;
            
        }catch(exception e){
            TareasRemedy sglTareas = new TareasRemedy();
            sglTareas.TaskID = e.getMessage();
            mpRespuesta.put(0,sglTareas);
        }
        return mpRespuesta;
    }
    
    public Map<Integer,TareasRemedy> RespuestaConsultaTareasRemedy(DOM.Document docResponse){
        Integer contador = 1;
        Map<Integer,TareasRemedy> mapTareas = new Map<Integer,TareasRemedy>();
        if(GetResult(docResponse)){
            Dom.XMLNode lstTareasRem = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'ConsultaResponse');
            if(lstTareasRem.getName() !='Vacio'){
                for(Dom.XMLNode sglTareasRem: lstTareasRem.getChildElements()){
                    if(sglTareasRem.getName()=='getListOperation'){
                        TareasRemedy sglTareas = new TareasRemedy();
                        for(Dom.XMLNode sglAttribRem: sglTareasRem.getChildElements()){
                            if(sglAttribRem.getName() == 'TaskID')
                                sglTareas.TaskID = sglAttribRem.getText();
                            if(sglAttribRem.getName() == 'NombreTask')
                                sglTareas.NombreTask = sglAttribRem.getText();
                            if(sglAttribRem.getName() == 'Estado_SF')
                                sglTareas.Estado_SF = sglAttribRem.getText();
                            if(sglAttribRem.getName() == 'Estado_RMD')
                                sglTareas.Estado_RMD = sglAttribRem.getText();
                            if(sglAttribRem.getName() == 'ID_Tarea_SF')
                                sglTareas.ID_Tarea_SF = sglAttribRem.getText();
                        }
                        mapTareas.put(contador,sglTareas);
                        contador++;
                    }
                }
            }
        }else{
            system.debug('Error');
            Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
            if(serviceResponseNode.getName() !='Vacio'){
                Dom.XMLNode strErrorMessage = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(serviceResponseNode,'errorMessage');
                if(strErrorMessage.getName() !='Vacio'){
                    TareasRemedy sglTareas = new TareasRemedy();
                    sglTareas.TaskID = strErrorMessage.getText();
                    system.debug(sglTareas);
                    mapTareas.put(0,sglTareas);
                }
            }
        }
        return mapTareas;
    }
    
    public class TareasRemedy{
        public String TaskID {get; set;}
        public String NombreTask {get; set;}
        public String Estado_SF {get; set;}
        public String Estado_RMD {get; set;}
        public String ID_Tarea_SF {get; set;}
    }
    
    public String ActualizaRemedy(Case sglCaso, Map<Id,Map<String,Object>> mapDatos){
        String strErrMessage = '';
        
        try{
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Remedy_ActualizarIncidente_PS'];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplate = new Dom.Document();
            docMessageTemplate.load(mapMensajesIntegracion.get('Remedy_ActualizarIncidente_PS'));
            
            PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
            Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, mapDatos.get(sglCaso.Id));
            DOM.Document docResponse;
            String correlationID = sglCaso.Id;
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Remedy_UpdateStatusOp_PS');
            String endpoint = sw.EndPoint__c;
            String method = sw.Action__c;
            system.debug('Endpoint - '+endpoint+' - '+method);
            //Invocar servicio web 
            PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
            docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
            
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Caso__c = sglCaso.Id;
            logServicio.Name = 'Envio Remedy Actualizar Caso';
            logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
            logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
            try{
                strErrMessage = RespuestaActualizaRemedy(docResponse);
            }catch(Exception e){
                strErrMessage = e.getMessage();
            }
            logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
            if(String.isNotEmpty(strErrMessage))
            	logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
            insert logServicio;
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            strErrMessage = e.getMessage();
        }
        return strErrMessage;
    }
    
    public String RespuestaActualizaRemedy(DOM.Document docResponse){
        String strErrMessage = 'Error en la integracion';
        if(GetResult(docResponse)){
            Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_AKNOWLEDGE');
            
            if(ResponseNode.getName() !='Vacio'){
                system.debug(responseNode.getText());
                if (responseNode.getText() == 'OK'){
                    strErrMessage = '';
                }else{
                    Dom.XMLNode msgErrorRemedy = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_ERROR_RMD');
                    if(msgErrorRemedy.getName() !='Vacio'){
                        strErrMessage = msgErrorRemedy.getText();
                    }else{
                        Dom.XMLNode msgError = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_ERROR_EDO');
                        system.debug(msgError.getText());
                        if(msgError.getName() !='Vacio'){
                            strErrMessage = msgError.getText();
                        }
                    }
                }
            }
        }
        return strErrMessage;
    }
    
    public String CreaTareaRemedy(Case sglCaso, Task sglTask, Map<Id,Map<String,Object>> mapDatos){
        String strErrMessage = '';
        
        try{
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Remedy_CreaTarea_PS'];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplate = new Dom.Document();
            docMessageTemplate.load(mapMensajesIntegracion.get('Remedy_CreaTarea_PS'));
            
            PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
            Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, mapDatos.get(sglCaso.Id));
            DOM.Document docResponse;
            String correlationID = sglCaso.Id;
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Remedy_CreateNewTaskOP_PS');
            String endpoint = sw.EndPoint__c;
            String method = sw.Action__c;
            system.debug('Endpoint - '+endpoint+' - '+method);
            //Invocar servicio web 
            PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
            docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
            
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Caso__c = sglCaso.Id;
            logServicio.Name = 'Envio Remedy Crear Tarea Caso';
            logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
            logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
            try{
                strErrMessage = RespuestaCreaTareaRemedy(docResponse, sglTask);
            }catch(Exception e){
                strErrMessage = e.getMessage();
            }
            logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
            if(String.isNotEmpty(strErrMessage))
            	logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
            insert logServicio;
            
        }catch(Exception e){
            strErrMessage = e.getMessage();
        }
        return strErrMessage;
    }
    
    public String RespuestaCreaTareaRemedy(DOM.Document docResponse, Task sglTask){
        String strErrMessage = 'Error en la integracion';
        if(GetResult(docResponse)){
            Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Aknowledge');
            
            if(ResponseNode.getName() !='Vacio'){
                system.debug(responseNode.getText());
                if (responseNode.getText() == 'OK'){
                    Dom.XMLNode responseIdTaskNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_ID_Task');
                    
                    if(responseIdTaskNode.getName() !='Vacio'){
                        sglTask.ID_externo__c = responseIdTaskNode.getText();
                        update sglTask;
                    }
                    strErrMessage = '';
                }else{
                    Dom.XMLNode msgErrorRemedy = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'OUT_Error');
                    if(msgErrorRemedy.getName() !='Vacio'){
                        strErrMessage = msgErrorRemedy.getText();
                    }
                }
            }else{
                
                Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
                if(serviceResponseNode.getName() !='Vacio'){
                    Dom.XMLNode strErrorMessage = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(serviceResponseNode,'errorMessage');
                    if(strErrorMessage.getName() !='Vacio'){
                        strErrMessage = strErrorMessage.getText();
                    }
                }
            }
        }
        return strErrMessage;
    }
    
    public String CreaNotaRemedy(Case sglCaso, Map<Id,Map<String,Object>> mapDatos){
        String strErrMessage = '';
        String sMensaje = 'Remedy_CreaNota_PS';
        try{
            if(sglCaso.Categoria_legado__c=='Requerimiento')
                sMensaje = 'Remedy_CreaNota_Req_PS';
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name =:sMensaje];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplate = new Dom.Document();
            docMessageTemplate.load(mapMensajesIntegracion.get(sMensaje));
            
            PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
            Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, mapDatos.get(sglCaso.Id));
            DOM.Document docResponse;
            String correlationID = sglCaso.Id;
            ServiciosWeb__c sw;
            
            if(sglCaso.Categoria_legado__c=='Requerimiento')
                sw = ServiciosWeb__c.getValues('Remedy_CreateNewNoteRequestOP_PS');
            else
                sw = ServiciosWeb__c.getValues('Remedy_CreateNewNoteOP_PS');
            
            String endpoint = sw.EndPoint__c;
            String method = sw.Action__c;
            system.debug('Endpoint - '+endpoint+' - '+method);
            //Invocar servicio web 
            PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
            docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
            
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Caso__c = sglCaso.Id;
            logServicio.Name = 'Envio Remedy Crear Nota Caso';
            logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
            logServicio.Informacion_Recibida__c = String.valueOf(docResponse.toXmlString());
            try{
                strErrMessage = RespuestaCreaNotaRemedy(docResponse, sglCaso);
            }catch(Exception e){
                strErrMessage = e.getMessage();
            }
            logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
            if(String.isNotEmpty(strErrMessage))
            	logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
            insert logServicio;
            
        }catch(Exception e){
            strErrMessage = e.getMessage();
        }
        return strErrMessage;
    }
    
    public String RespuestaCreaNotaRemedy(DOM.Document docResponse, Case sglCaso){
        String strErrMessage = 'Error en la integracion';
        if(GetResult(docResponse)){
            Dom.XMLNode responseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,sglCaso.Categoria_legado__c=='Requerimiento'?'Creat_Note_WOIResponse':'Create_Note_HPDResponse');
            
            if(ResponseNode.getName() !='Vacio'){
                system.debug(responseNode.getText());
                strErrMessage = '';
                
            }
        }else{
            Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
            if(serviceResponseNode.getName() !='Vacio'){
                Dom.XMLNode strErrorMessage = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(serviceResponseNode,'errorMessage');
                if(strErrorMessage.getName() !='Vacio'){
                    strErrMessage = strErrorMessage.getText();
                }
            }
        }
        return strErrMessage;
    }/*
    
    public String EncriptarSHA_TOA(String sWord){
        Blob targetBlob = Blob.valueOf(sWord);
        Blob hashSHA1 = Crypto.generateDigest('SHA-256', targetBlob);
        //String hashBase64SHA1 = EncodingUtil.base64encode (hashSHA1);
        String hashBase64SHA1 = EncodingUtil.convertToHex (hashSHA1);
        return hashBase64SHA1;
    }
    
    public String SolicitarAgenda(Case sglCaso, Map<Id,Map<String,Object>> mapDatos){
        String strErrMessage = '';
        
        try{
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='TOA_SolicitarAgenda_PS'];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            
            Dom.Document docMessageTemplate = new Dom.Document();
            docMessageTemplate.load(mapMensajesIntegracion.get('TOA_SolicitarAgenda_PS'));
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('TOA_SolicitarAgenda_PS');
            String endpoint = sw.EndPoint__c;
            String method = sw.Action__c;
            system.debug('Endpoint - '+endpoint+' - '+method);
            
            Map<String,Object> sglDataMap = mapDatos.get(sglCaso.Id);
            String strFecha = system.now().format('yyyy-MM-dd\'T\'HH:mm:ss.sssXXX','America/Bogota');
            String strLogin = sw.Usuario__c;
            String strPass = sw.Contrasena__c;
            String strAuthToken  = EncriptarSHA_TOA(strFecha+EncriptarSHA_TOA(strPass+EncriptarSHA_TOA(strLogin)));
            sglDataMap.put('user_now',strFecha);
            sglDataMap.put('user_login',strLogin);
            sglDataMap.put('user_pass',strPass);
            sglDataMap.put('user_auth_string',strAuthToken);
            
            PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
            Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, sglDataMap);
            DOM.Document docResponse;
            String correlationID = sglCaso.Id;
            
            //Invocar servicio web 
            PS_UtilitaryMethodsClass_cls PS_UtilitaryMethodsClass = new PS_UtilitaryMethodsClass_cls();
            //docResponse = PS_UtilitaryMethodsClass.InvokeServiceRequestDOM(docServices, method, endpoint);
            String response=LibreriaUtilitariaJobs_cls.consultarServicio(docServices.toXmlString(),sw.Action__c,sw.EndPoint__c);
            
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Caso__c = sglCaso.Id;
            logServicio.Name = 'Envio TOA Solicitar Agenda';
            logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
            logServicio.Informacion_Recibida__c = response;
            try{
                //strErrMessage = RespuestaActualizaRemedy(docResponse);
                docResponse = new Dom.Document();
                docResponse.load(response);
                
                strErrMessage = RespuestaSolicitarAgenda(docResponse,sglCaso,sglDataMap);
            }catch(Exception e){
                strErrMessage = e.getMessage();
            }
            logServicio.Estado__c = String.isEmpty(strErrMessage)?'Realizado':'Fallido';
            if(String.isNotEmpty(strErrMessage))
            	logServicio.Error_Apex__c = strErrMessage.length()>255?strErrMessage.substring(0, 255):strErrMessage;
            insert logServicio;
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            strErrMessage = e.getMessage();
        }
        return strErrMessage;
    }
    
    
    
    public String RespuestaSolicitarAgenda(DOM.Document docResponse, Case sglCaso,Map<String,Object> sglDataMap){
        String strErrMessage = 'Error en la integracion';
        
        Dom.XMLNode dataNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'data');
        if(dataNode.getName() !='Vacio'){
            Dom.XMLNode reportNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(dataNode,'report');
            Dom.XMLNode aidNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(dataNode,'aid');
            Dom.XMLNode dateNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(dataNode,'date');
            if(reportNode.getName() !='Vacio'){
                for(Dom.XMLNode sglMessageNode: reportNode.getChildElements()){
                    Dom.XMLNode descriptionNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(sglMessageNode,'description');
                    Dom.XMLNode resultNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(sglMessageNode,'result');
                    if(resultNode.getName() !='Vacio'){
                        if(resultNode.getText()=='error' && descriptionNode.getName() !='Vacio'){
                            strErrMessage = descriptionNode.getText();
                            break;
                        }
                        if(resultNode.getText()=='success' && aidNode.getName() !='Vacio' && dateNode.getName() !='Vacio'){
                            sglCaso.TOA_External_Id__c = aidNode.getText();
                            sglCaso.TOA_Fecha_Agenda__c = system.now();
                            sglCaso.TOA_Fecha__c = Date.valueOf(dateNode.getText());
                            sglCaso.TOA_TimeSlot__c = String.valueOf(sglDataMap.get('TOA_TimeSlot__c'));
                            sglCaso.TOA_Tipo_Actividad__c = String.valueOf(sglDataMap.get('TOA_Tipo_Actividad__c'));
                            sglCaso.TOA_Zona__c = String.valueOf(sglDataMap.get('TOA_Zona__c'));
                            update sglCaso;
                            strErrMessage = '';
                            break;
                        }
                    }
                }
            }
        }
        return strErrMessage;
    }*/
}