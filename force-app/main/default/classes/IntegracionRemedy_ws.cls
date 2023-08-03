/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase que expone el servicio y los métodos de integración con Remedy

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2019-07-12   John Guevara (ETB)       Creación de la clase.
***********************************************************************************************************************/
global class IntegracionRemedy_ws {
    
    global class MsgEntrada{
        webservice string Id='';
        webservice String NombreObjeto='';
        webservice msgParameters lstParametros;
        webservice msgObjetosHijosRelacionados lstObjetosHijosRelacionados;
    }
    
    global class msgParameters{
        webservice list<MsgKeys> Keys;
    }
    
    global class msgObjetosHijosRelacionados{
        webservice List<ObjetoHijoRelacionado> ObjetosHijosRelacionados;
    }
    
    global class ObjetoHijoRelacionado{
        webservice string Id='';
        webservice string NombreRelacion;
        webservice msgParameters lstParametros;
    }
    
    global class MsgKeys{
        webservice string Campo='';
        webservice string Valor='';
    }
    
    global class MsgSalida{
        webservice string resultado='';
        webservice string Id='';
        webservice string Name='';
        webservice msgParameters lstParametros;
        webservice MsgError msgError = new MsgError();
    }
    
    global class MsgError{
        webservice string codigoError='';
        webservice string mensajeError='';
    }
    
    global class MsgSalidaListaCaso{
        webservice string resultado='';
        webservice MsgListCaso lstCasos = new MsgListCaso();
    }
    
    global class MsgListCaso{
        webservice List<MsgEntrada> caso;
    }
    
    /*
* @Método:      WSActualizarCaso
* @Parámetros:  MsgEntrada
* @Descripción: Método expuesto por WS para crear o actualizar un caso desde Remedy.
*/
    webservice static MsgSalida WSActualizarObjeto(MsgEntrada mensajeEntrada){
        MsgSalida respuesta = new MsgSalida();
        Map<String,Object> mapParameters = new Map<String,Object>();
        
        LogTransacciones__c logServicio = new LogTransacciones__c(Name = 'ActualizacionRemotaCaso' + mensajeEntrada.NombreObjeto);
        logServicio.AC_CorrelationID_Random__c = mensajeEntrada.Id;
        logServicio.Informacion_Recibida__c = String.valueOf(mensajeEntrada);
        logServicio.Estado__c = 'Fallido';
        
        mapParameters.put('Id',String.isNotEmpty(mensajeEntrada.Id)?mensajeEntrada.Id:'');
        try{
            mapParameters.put(mensajeEntrada.NombreObjeto,MapDynamicObject(mensajeEntrada.lstParametros,mensajeEntrada.NombreObjeto,'').clone());
            system.debug('Existe'+mapParameters.containskey('Param_Case'));
            
            List<ObjetoHijoRelacionado> tmpObjNotes = new List<ObjetoHijoRelacionado>();
            if(mensajeEntrada.lstObjetosHijosRelacionados != null){
                if(mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados!=null){
                    for(ObjetoHijoRelacionado sglObjetoHijoRelacionado:mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados){
                        if(String.isNotEmpty(sglObjetoHijoRelacionado.NombreRelacion)){
                            if(sglObjetoHijoRelacionado.NombreRelacion=='CaseComments'){
                                if(sglObjetoHijoRelacionado.lstParametros!=null){
                                    if(sglObjetoHijoRelacionado.lstParametros.Keys!=null){
                                        for(MsgKeys sglKey:sglObjetoHijoRelacionado.lstParametros.Keys){
                                            if(sglKey.Campo=='CommentBody'){
                                                system.debug(sglKey.Valor.length());
                                                ObjetoHijoRelacionado tmpNoteObj = new ObjetoHijoRelacionado();
                                                tmpNoteObj.NombreRelacion='ContentNote';
                                                MsgKeys tmpNoteKey = new MsgKeys();
                                                tmpNoteKey.Campo = 'Content';
                                                tmpNoteKey.Valor = sglKey.Valor;
                                                list<MsgKeys> tmpNoteKeys = new list<MsgKeys>();
                                                tmpNoteKeys.add(tmpNoteKey);
                                                msgParameters tmpNoteParam = new msgParameters();
                                                tmpNoteParam.keys = tmpNoteKeys;
                                                tmpNoteObj.lstParametros = tmpNoteParam;
                                                tmpObjNotes.add(tmpNoteObj);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            for(ObjetoHijoRelacionado sgltmpObjNote:tmpObjNotes){
                mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados.add(sgltmpObjNote);
            }
            if(mensajeEntrada.lstObjetosHijosRelacionados != null){
                if(mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados!=null){
                    for(ObjetoHijoRelacionado sglObjetoHijoRelacionado:mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados){
                        if(String.isNotEmpty(sglObjetoHijoRelacionado.NombreRelacion)){
                            system.debug('NombreRelacion'+sglObjetoHijoRelacionado.NombreRelacion);
                            List<SObject> lstDynObject = new List<SObject>();
                            if(sglObjetoHijoRelacionado.lstParametros!=null){
                                if(!mapParameters.containskey(sglObjetoHijoRelacionado.NombreRelacion)){
                                    List<Map<String,Object>> lstDynRelatedObject = new List<Map<String,Object>>();
                                    lstDynRelatedObject.add(MapDynamicObject(sglObjetoHijoRelacionado.lstParametros,mensajeEntrada.NombreObjeto,sglObjetoHijoRelacionado.NombreRelacion).clone());
                                    mapParameters.put(sglObjetoHijoRelacionado.NombreRelacion,lstDynRelatedObject);
                                }else{
                                    List<Map<String,Object>> lstDynRelatedObject = (List<Map<String,Object>>)mapParameters.get(sglObjetoHijoRelacionado.NombreRelacion);
                                    lstDynRelatedObject.add(MapDynamicObject(sglObjetoHijoRelacionado.lstParametros,mensajeEntrada.NombreObjeto,sglObjetoHijoRelacionado.NombreRelacion).clone());
                                    mapParameters.put(sglObjetoHijoRelacionado.NombreRelacion,lstDynRelatedObject);
                                }
                            }
                        }
                    }
                }
            }
            system.debug('Existe'+mapParameters.containskey('Param_Case'));
        }catch(Exception e){
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.mensajeError=e.getMessage()+e.getStackTraceString();
            respuesta.msgError.codigoError='NOK-Apex';
            logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
            insert logServicio;
        }
        
        if(String.isEmpty(respuesta.msgError.mensajeError)){
            try{
                Map<String,String> mpDatos =BusinessLogic_Caso_ctr.ActualizarCaso(mapParameters);
                List<MsgKeys> lstKeys = new List<MsgKeys>();
                for(String strVal:mpDatos.keyset()){
                    if(strVal=='Id')
                        respuesta.Id = mpDatos.containsKey('Id')?mpDatos.get('Id'):'';
                    else if(strVal=='Error')
                        respuesta.msgError.mensajeError = mpDatos.containsKey('Error')?mpDatos.get('Error'):'';
                    else if(strVal=='Name')
                        respuesta.Name = mpDatos.containsKey('Name')?mpDatos.get('Name'):'';
                    else{
                        msgParameters outParametros = new msgParameters();
                        MsgKeys sglMsgKey = new MsgKeys();
                        sglMsgKey.Campo = strVal;
                        sglMsgKey.Valor = mpDatos.get(strVal);
                        lstKeys.add(sglMsgKey);
                        outParametros.Keys = lstKeys;
                        respuesta.lstParametros = outParametros;
                    }
                }
                
                if(String.isNotEmpty(respuesta.msgError.mensajeError)){
                    system.debug(respuesta);
                    respuesta.msgError.codigoError='NOK';
                    if(String.isNotEmpty(respuesta.Id))
                        logServicio.Caso__c = respuesta.Id;
                    logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
                    insert logServicio;
                }
            }catch(exception e){
                respuesta.resultado = 'Erroneo';
                respuesta.msgError.mensajeError=e.getMessage()+e.getStackTraceString();
                respuesta.msgError.codigoError='NOK-Apex';
                logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
                insert logServicio;
            }
            if(String.isEmpty(respuesta.msgError.mensajeError)){
                respuesta.resultado = 'Exitoso';
            }
        }
        return respuesta;
    }
    
    global static Map<String,Object> MapDynamicObject(msgParameters lstParametros, String strObject, String strRelationship){
        Map<String,Object> mapParameters = new Map<String,Object>();
        Map<String,Object> mpParametrosDinamicos = new Map<String,Object>();
        String strRelationField = '';
        
        Schema.SObjectType otDynObject = Schema.getGlobalDescribe().get(strObject);
        
        if(String.isNotEmpty(strRelationship)){
            Boolean validName = false;
            for(Schema.ChildRelationship cr: otDynObject.getDescribe().getChildRelationships()){
                if(cr.getRelationshipName() == strRelationship){
                    strObject = cr.getChildSObject().getDescribe().getLocalName();
                    strRelationField = cr.getField().getDescribe().getLocalName();
                    validName = true;
                }
            }
            if(validName)
                otDynObject = Schema.getGlobalDescribe().get(strObject);
            else{
                if(strRelationship=='ContentNote'){
                    strObject = 'ContentNote';
                    otDynObject = Schema.getGlobalDescribe().get('ContentNote');
                }else{
                    return mapParameters;
                }
            }
        }
        
        Sobject dynObject = otDynObject.newSobject();
        Map <String, Schema.SObjectField> fieldMap = otDynObject.getDescribe().fields.getMap();
        
        if(lstParametros!=null){
            if(lstParametros.Keys!=null){
                for(MsgKeys sglKey:lstParametros.Keys){
                    system.debug(sglKey);
                    if(fieldMap.containskey(sglKey.Campo)){
                        if(fieldMap.get(sglKey.Campo).getDescribe().isUpdateable()){
                            if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.STRING){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),sglKey.Valor.length()>fieldMap.get(sglKey.Campo).getDescribe().getLength()?sglKey.Valor.substring(0,fieldMap.get(sglKey.Campo).getDescribe().getLength()):sglKey.Valor);
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.BOOLEAN){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),sglKey.Valor);
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.DOUBLE){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),decimal.valueOf(sglKey.Valor));
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.INTEGER){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),integer.valueOf(sglKey.Valor));
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.ID){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),sglKey.Valor);
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.DATE){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),date.valueOf(sglKey.Valor));
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.DATETIME){
                                if(String.isNotEmpty(sglKey.Valor)){
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),datetime.valueOf(sglKey.Valor));
                                }
                            }else if(fieldMap.get(sglKey.Campo).getDescribe().getSOAPType() == Schema.SOAPType.BASE64BINARY){
                                String strdesc = sglKey.Valor;
                                if (strdesc.contains('\n'))
                                {
                                    strdesc = '<p>' + strdesc.replaceAll('\n','</p><p>') + '</p>';
                                }
                                dynObject.put(fieldMap.get(sglKey.Campo).getDescribe().getName(),Blob.valueOf(strdesc));
                            }else{
                            system.debug('Campo no formateado');
                                mpParametrosDinamicos.put(String.valueof(sglKey.Campo),sglKey.Valor);
                        system.debug('campo'+fieldMap.get(sglKey.Campo).getDescribe().getSOAPType()+sglKey.Campo+''+sglKey.Valor);
                            }
                        }else{
                            system.debug('No es actualizable');
                            mpParametrosDinamicos.put(sglKey.Campo,sglKey.Valor);
                        system.debug('campo'+sglKey.Campo+''+sglKey.Valor);
                        }
                    }else{
                        system.debug('campo'+sglKey.Campo+''+sglKey.Valor);
                        mpParametrosDinamicos.put(String.valueof(sglKey.Campo),String.valueof(sglKey.Valor));
        system.debug(mpParametrosDinamicos);
                    }
                }
            }
        }
        mapParameters.put(strObject, dynObject);
        system.debug('mpParametrosDinamicos'+mpParametrosDinamicos.size());
        system.debug(mpParametrosDinamicos);
        system.debug('Param_'+strObject);
        mapParameters.put('Param_'+strObject,mpParametrosDinamicos);
        system.debug('Existe'+mapParameters.containskey('Param_Case'));
        if(String.isNotEmpty(strRelationField))
            mapParameters.put('Relation_field', strRelationField);
        
        return mapParameters;
    }
    
    webservice static MsgSalidaListaCaso WsConsultaLista(MsgEntrada msjEntrada){
        MsgSalidaListaCaso msgSalida = new MsgSalidaListaCaso();
        
        List<sObject> lstObject = new List<sObject>();
        List<MsgEntrada> lstmsgSalida = new List<MsgEntrada>();
        
        List<String> lstQuery = new List<String>();
        String strQuery = '';
        if(msjEntrada!=null){
            String strMensajeN = 'Campos_WsConsultaLista_'+msjEntrada.NombreObjeto;
            Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name = :strMensajeN];
            
            String sFields = lstMensajes.Mensaje__c;
            Set<String> setFields = new Set<String>();
            setFields.addAll(sFields.split(','));
            
            String selectParametersQuery = 'SELECT ' + sFields + ' FROM '+msjEntrada.NombreObjeto;
            if(msjEntrada.lstParametros!=null){
                if(msjEntrada.lstParametros.Keys!=null){
                    for(MsgKeys sglInMsgKey:msjEntrada.lstParametros.Keys){
                        if(String.isNotEmpty(sglInMsgKey.Campo)){
                            if(sglInMsgKey.Campo=='Condicion'){
                                if(String.isNotEmpty(sglInMsgKey.Valor)){
                                    strQuery = sglInMsgKey.Valor;
                                }
                            }
                        }
                    }
                }
            }
            if(String.isNotEmpty(strQuery)){
                selectParametersQuery += ' WHERE '+strQuery;
                lstObject = Database.query(selectParametersQuery);
            }
            
            for(sObject sglObject:lstObject){
                MsgEntrada sglmensajeSalida = new MsgEntrada();
                sglmensajeSalida.Id = sglObject.Id;
                sglmensajeSalida.NombreObjeto = msjEntrada.NombreObjeto;
                
                List<MsgKeys> lstKeys = new List<MsgKeys>();
                for(String sglfield:setFields){
                    String sTemp = sglfield.trim();
                    SObject objTemp = sglObject;
                    MsgKeys sglMsgKey = new MsgKeys();
                    sglMsgKey.Campo = sglfield;
                    
                    if (sTemp.contains('.')){
                        while(sTemp.contains('.')){
                            objTemp = objTemp.getSobject(sTemp.substringBefore('.'));
                            sTemp = objTemp!=null?sTemp.substringAfter('.'):'';
                        }
                    }
                    sglMsgKey.Valor = String.isNotEmpty(sTemp)?(objTemp.get(sTemp)!=null?String.valueOf(objTemp.get(sTemp)):''):'';
                    lstKeys.add(sglMsgKey);
                }
                
                msgParameters tmsgParameters = new msgParameters();
                tmsgParameters.Keys = lstKeys.clone();
                sglmensajeSalida.lstParametros = tmsgParameters;
                lstmsgSalida.add(sglmensajeSalida);
            }
        }
        MsgListCaso lstCasos = new MsgListCaso();
        lstCasos.caso = lstmsgSalida;
        msgSalida.lstCasos = lstCasos;
        
        return msgSalida;
    }
    
    webservice static MsgEntrada WsConsultaDetalle(MsgEntrada MensajeEntrada){        
        MsgEntrada mensajeSalida = new MsgEntrada();
        mensajeSalida.Id = MensajeEntrada.Id;
        mensajeSalida.NombreObjeto = MensajeEntrada.NombreObjeto;
        String strQuery = '';
        
        if(String.isEmpty(mensajeSalida.Id)){
            if(MensajeEntrada.lstParametros!=null){
                if(MensajeEntrada.lstParametros.Keys!=null){
                    for(MsgKeys sglInMsgKey:MensajeEntrada.lstParametros.Keys){
                        if(String.isNotEmpty(sglInMsgKey.Campo)){
                            if(sglInMsgKey.Campo=='Condicion'){
                                if(String.isNotEmpty(sglInMsgKey.Valor)){
                                    strQuery = sglInMsgKey.Valor;
                                }
                            }
                        }
                    }
                }
            }
        }else{
            strQuery = 'Id=\''+mensajeSalida.Id+'\'';
        }
        system.debug(strQuery);
        
        if(String.isNotEmpty(strQuery)){
            String strMensajeN = 'Campos_WsConsultaDetalle_'+MensajeEntrada.NombreObjeto;
            Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name =:strMensajeN];
            
            String sFields = lstMensajes.Mensaje__c;
            Set<String> setFields = new Set<String>();
            setFields.addAll(sFields.split(','));
            
            String selectParametersQuery = 'SELECT ' + sFields + ' FROM '+MensajeEntrada.NombreObjeto+' WHERE '+strQuery+'';
            List<SObject> lstMainObject = Database.query(selectParametersQuery);
            
            if(!lstMainObject.isEmpty()){
                SObject sglMainObject = lstMainObject[0];
                
                List<MsgKeys> lstKeys = new List<MsgKeys>();
                for(String sglfield:setFields){
                    String sTemp = sglfield.trim();
                    SObject objTemp = sglMainObject;
                    MsgKeys sglMsgKey = new MsgKeys();
                    sglMsgKey.Campo = sTemp;
                    
                    if (sTemp.contains('.')){
                        while(sTemp.contains('.')){
                            objTemp = objTemp.getSobject(sTemp.substringBefore('.'));
                            sTemp = objTemp!=null?sTemp.substringAfter('.'):'';
                        }
                    }
                    sglMsgKey.Valor = String.isNotEmpty(sTemp)?(objTemp.get(sTemp)!=null?String.valueOf(objTemp.get(sTemp)):''):'';
                    lstKeys.add(sglMsgKey);
                }
                
                msgParameters tmsgParameters = new msgParameters();
                tmsgParameters.Keys = lstKeys.clone();
                mensajeSalida.lstParametros = tmsgParameters;
                
                List<ObjetoHijoRelacionado> lstHijos = new List<ObjetoHijoRelacionado>();            
                
                Set<String> stNombreHijos = new Set<String>();
                if(mensajeEntrada.lstObjetosHijosRelacionados!=null){
                    if(mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados!=null){
                        for(ObjetoHijoRelacionado slgHijoRelated:mensajeEntrada.lstObjetosHijosRelacionados.ObjetosHijosRelacionados){
                            if(slgHijoRelated.NombreRelacion!=null){
                                if(!stNombreHijos.contains(slgHijoRelated.NombreRelacion)){
                                    stNombreHijos.add(MensajeEntrada.NombreObjeto+'_'+slgHijoRelated.NombreRelacion);
                                }
                            }
                        }
                    }
                }
                
                if(!stNombreHijos.isEmpty()){
                    List<Mensaje_Integracion__c> lstMensajeHijos = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name IN :stNombreHijos];
                    Schema.SObjectType otDynObject = Schema.getGlobalDescribe().get(MensajeEntrada.NombreObjeto);
                    for(Mensaje_Integracion__c sglMensajeHijo:lstMensajeHijos){
                        String strRelationship = sglMensajeHijo.Name.substringAfter('_');
                        String strObject = '';
                        String strRelationField = '';
                        
                        for(Schema.ChildRelationship cr: otDynObject.getDescribe().getChildRelationships()){
                            if(cr.getRelationshipName() == strRelationship){
                                strObject = cr.getChildSObject().getDescribe().getLocalName();
                                strRelationField = cr.getField().getDescribe().getLocalName();
                            }
                        }
                        if(String.isNotEmpty(strObject) && String.isNotEmpty(strRelationField)){
                            String sHijosFields = sglMensajeHijo.Mensaje__c;
                            Set<String> setHijosFields = new Set<String>();
                            setHijosFields.addAll(sHijosFields.split(','));
                            
                            String selectParametersQueryHijo = 'SELECT ' + sHijosFields + ' FROM '+strObject+' WHERE '+strRelationField+' =\''+mensajeSalida.Id+'\'';
                            List<SObject> lstSObjectHijo = Database.query(selectParametersQueryHijo);
                            
                            for(SObject sglObjectHijo:lstSObjectHijo){
                                ObjetoHijoRelacionado sglHijo = new ObjetoHijoRelacionado();
                                sglHijo.Id = sglObjectHijo.Id;
                                sglHijo.NombreRelacion = strRelationship;
                                lstKeys.clear();
                                for(String sglfield:setHijosFields){
                                    String sTemp = sglfield.trim();
                                    SObject objTemp = sglObjectHijo;
                                    MsgKeys sglMsgKey = new MsgKeys();
                                    sglMsgKey.Campo = sglfield;
                                    
                                    if (sTemp.contains('.')){
                                        while(sTemp.contains('.')){
                                            objTemp = objTemp.getSobject(sTemp.substringBefore('.'));
                                            sTemp = objTemp!=null?sTemp.substringAfter('.'):'';
                                        }
                                    }
                                    sglMsgKey.Valor = String.isNotEmpty(sTemp)?(objTemp.get(sTemp)!=null?String.valueOf(objTemp.get(sTemp)):''):'';
                                    lstKeys.add(sglMsgKey);
                                }
                                msgParameters tmpParamHijo = new msgParameters();
                                tmpParamHijo.Keys = lstKeys.clone();
                                sglHijo.lstParametros = tmpParamHijo;
                                lstHijos.add(sglHijo);
                            }
                        }
                        
                    }
                }
                msgObjetosHijosRelacionados objHijos = new msgObjetosHijosRelacionados();
                objHijos.ObjetosHijosRelacionados = lstHijos;
                mensajeSalida.lstObjetosHijosRelacionados = objHijos;
                
            }
        }
        return mensajeSalida;
    }
}