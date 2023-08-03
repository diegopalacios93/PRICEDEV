/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 04-20-2022
 * @last modified by  : a.tsukamoto.pena
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   07-06-2021   Harlinsson Chavarro (HCH)   Initial Version
 * 2.0   04-20-2022   ALejandro Peña T            Satisfaction Surveys rollback
**/
trigger Case_tgr on Case (before insert, before update, after insert, after update) {

    Boolean seDebeEjecutar = !BanderasEjecucion.ValidarEjecucion('TriggerCase');
    //Valida si se debe ejecutar ya que hay varios procesos en los cuales no se requiere
    //ejecutar el trigger
    if(seDebeEjecutar){
        if (trigger.isBefore) {
            Set<Id> lstIdServicio = new Set<Id>();
            Map<Id,ActivoETB__c> mpServicio = new Map<Id,ActivoETB__c>();
            if (trigger.isInsert) {
                System.debug('Case TGR isBefore isInsert');
                //consultamos tipo de registro para evitar flujos establecidos por etb.
                Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
                Id masivoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
               // Id facebookRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_Facebook').getRecordTypeId();

                for(Case sglCase:trigger.new){
                    if (sglCase.RecordTypeId != ventasRTId && sglCase.RecordTypeId != masivoRTId) {
                        if(sglCase.LTE_Servicio__c!=null){
                            lstIdServicio.add(sglCase.LTE_Servicio__c);
                        }
                    }
                }
            }
            if (trigger.isUpdate) {    
                System.debug('Case TGR isBefore isUpdate');
                //This List has each value used to Digital Engagement
                list<String> profileNameLst = new list<String>{'Administrador del sistema','System Administrator','Integraciones'};
                Map<Id,Profile> profileNameMap = new Map<Id,Profile>([SELECT Name FROM Profile WHERE Name IN:profileNameLst]);
                System.debug('##profileNameMap '+profileNameMap);
                list<String> statusDEGLst = new list<String>{'Canal WhatsApp','Canal WhatsApp Mipymes','Canal WhatsApp Hogares','Canal Web Chat','Canal Messenger','Canal Web Ventas','Canal WhatsApp Ventas', 'Canal Web Chat MiPymes', 'Canal Web Chat Hogares','Canal WhatsApp Empresas','Canal Facebook'};
                Id masivoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
                Id casePQRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
                Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
              //  Id facebookRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_Facebook').getRecordTypeId();
                
                String status = '';
                for(Case sglCase : trigger.new){
                    Case oldCase = trigger.oldMap.get(sglCase.Id);
                    //Validate that not in next process for DEG
                    if(!statusDEGLst.contains(sglCase.Origin)) {
                        if(sglCase.LTE_Servicio__c != Trigger.oldMap.get(sglCase.Id).LTE_Servicio__c && sglCase.LTE_Servicio__c!=null){
                            lstIdServicio.add(sglCase.LTE_Servicio__c);
                        }
                    }
                    else {
                        System.debug('##sglCase '+sglCase);
                        if((sglCase.RecordTypeId == masivoRTId ||
                            sglCase.RecordTypeId == casePQRTId ||
                            //sglCase.RecordTypeId == facebookRTId ||
                            sglCase.RecordTypeId == ventasRTId) &&
                            sglCase.Status != oldCase.Status &&
                            oldCase.Status == 'Resuelto' &&
                            !profileNameMap.containsKey(userinfo.getProfileId()))

                        {
                            if(Limits.getQueries() < Limits.getLimitQueries()){
                                if(sglCase.Origin == 'Canal Web Chat' || sglCase.Origin == 'Canal Web Chat Hogares' || sglCase.Origin == 'Canal Web Chat MiPymes'){
                                    status = [SELECT Status FROM LiveChatTranscript WHERE CaseId =: sglCase.Id LIMIT 1].Status;
                                    if(status == 'Completed' || status == 'Missed'){
                                        sglCase.addError(System.label.DEG_ErrorUpdateCase);
                                        }
                                    }      
                                else if(sglCase.Origin == 'Canal WhatsApp' || sglCase.Origin == 'Canal WhatsApp Mipymes' || sglCase.Origin == 'Canal WhatsApp Hogares'|| sglCase.Origin == 'Canal WhatsApp Empresas'|| sglCase.Origin =='Canal Facebook'){
                                    status = [SELECT Status FROM MessagingSession WHERE CaseId =: sglCase.Id LIMIT 1].Status;
                                    if(status == 'Ended'){
                                        sglCase.addError(System.label.DEG_ErrorUpdateCase);
                                    }
                                }else if(sglCase.Origin == 'Canal Web Ventas' ||sglCase.Origin == 'Canal WhatsApp Ventas'){
                                    sglCase.addError(System.label.DEG_ErrorUpdateCase);
                                }
                            }
                        }     
                    }
                }
            if((trigger.new[0].RecordTypeId ==  ventasRTId) &&(trigger.new[0].DEG_Nivel1__c != trigger.old[0].DEG_Nivel1__c ||trigger.new[0].DEG_Nivel2__c != trigger.old[0].DEG_Nivel2__c||trigger.new[0].DEG_Nivel3__c != trigger.old[0].DEG_Nivel3__c)  ){
            DEG_BacklandingActualizar.inicializarMetodo(trigger.new[0].Id);
            }
            
            }
            if(!lstIdServicio.isEmpty()){
                System.debug('Case TGR isBefore !lstIdServicio.isEmpty()');
                mpServicio = new Map<Id,ActivoETB__c>([SELECT Id,IDservicio__c,NumeroConexion__c,plan__c,SucursalOrigen__c,SucursalOrigen__r.Direccion__c,SucursalOrigen__r.Ciudad__c FROM ActivoETB__c WHERE Id IN :lstIdServicio]);
            }
            if (trigger.isInsert || trigger.isUpdate){
                System.debug('Case TGR isBefore isInsert||isUpdate');                
                for(Case sglCase:trigger.new){

                    if(sglCase.LTE_Servicio__c!=null){
                        if(mpServicio.containskey(sglCase.LTE_Servicio__c)){
                            sglCase.IDServicio__c = mpServicio.get(sglCase.LTE_Servicio__c).IDservicio__c;
                            sglCase.NumeroConexion__c = mpServicio.get(sglCase.LTE_Servicio__c).NumeroConexion__c;
                            sglCase.Plan__c = mpServicio.get(sglCase.LTE_Servicio__c).Plan__c;
                            if(mpServicio.get(sglCase.LTE_Servicio__c).SucursalOrigen__c!=null){
                                sglCase.Direccion_Instalacion__c = mpServicio.get(sglCase.LTE_Servicio__c).SucursalOrigen__r.Direccion__c;
                                sglCase.Ciudad_Instalacion__c =  mpServicio.get(sglCase.LTE_Servicio__c).SucursalOrigen__r.Ciudad__c;
                            }
                        }
                    }
                }
            }
            if (trigger.isUpdate) {
                System.debug('Case TGR isBefore isUpdate2');
                User usr = [SELECT Id, username, profileId FROM User WHERE username LIKE 'autoproc%' LIMIT 1];
                for (Case cs : Trigger.new) {
                    if(
                        (cs.Origin == 'Canal WhatsApp' || cs.Origin == 'Canal WhatsApp Mipymes' || cs.Origin == 'Canal WhatsApp Hogares' || cs.Origin == 'Canal Web Chat' || cs.Origin == 'Canal Web Chat Hogares' || cs.Origin == 'Canal Web Chat MiPymes' || cs.Origin == 'Canal Facebook'|| cs.Origin == 'Canal WhatsApp Empresas') &&
                        cs.DEG_GestionadoPor__c == 'Bot' && cs.Status == 'Resuelto' && cs.DEG_SentToIntegration__c == false
                    )
                    {
                        cs.OwnerId = usr.Id;
                    }
                }
            }
        }
        if(trigger.isAfter){
            if (trigger.isInsert) {
                System.debug('Case TGR isAfter isInsert');
                Id casePQRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
                Id caseSOPORTETId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SOPORTE_TECNICO').getRecordTypeId();
                List<id> lstUser = new List<id>();
                List<id> lstGroup = new List<id>();
                Map<id,User> mapUser = new Map<id,User>();
                Map<id,Group> mapGroup = new Map<id,Group>();
                Map<String,List<Map<String,String>>> mpListaValores = new Map<String,List<Map<String,String>>>();
                List<Case> lstCase = new List<Case>();
                List<Fidelizacion__c> lstRetenciones = new List<Fidelizacion__c>();
                List<Cronometros__c> lstNewTimes = new List<Cronometros__c>();
                PS_IntegrationHelper_ctr cls = new PS_IntegrationHelper_ctr();
                for(Case sglCase:trigger.new){
                    if(sglCase.RecordTypeId == casePQRTId || sglCase.RecordTypeId == caseSOPORTETId){
                        if(sglCase.OwnerId!=null){
                            if(sglCase.OwnerId.getSObjectType().getDescribe().getName() == 'User'){
                                lstUser.add(sglCase.OwnerId);
                            }else{
                                lstGroup.add(sglCase.OwnerId);
                            }
                        }
                    }
                }
                if(!lstUser.isEmpty()){
                    mapUser = new Map<Id,User>([select id, Area__c,UserRole.Name,Username from User WHERE Id IN :lstUser]);
                }
                if(!lstGroup.isEmpty()){
                    mapGroup = new Map<Id,Group>([select id, Name from Group WHERE Id IN :lstGroup]);
                    mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('LV_Compleja__mdt','Tipo_Lista__c = \'GRUPOS\'');
                }
                
                for(Case sglCase:trigger.new){
                    if(sglCase.RecordTypeId == casePQRTId || sglCase.RecordTypeId == caseSOPORTETId){
                        String strareaExperiencia = '';
                        String strNombreUsuario = '';
                        Id IdPropietario = null;
                        if(sglCase.OwnerId != null){
                            if(sglCase.OwnerId.getSObjectType().getDescribe().getName() == 'User'){
                                strNombreUsuario = mapUser.get(sglCase.OwnerId).username;
                                IdPropietario = sglCase.OwnerId;
                                if(String.isNotEmpty(mapUser.get(sglCase.OwnerId).Area__c))
                                    strareaExperiencia = mapUser.get(sglCase.OwnerId).Area__c;
                                else
                                    strareaExperiencia = mapUser.get(sglCase.OwnerId).UserRole.Name;
                            }else{
                                if(!mpListaValores.isEmpty())
                                    for(Map<String,String> sglListaValores:mpListaValores.get('GRUPOS')){
                                        if(mapGroup.get(sglCase.OwnerId).Name == sglListaValores.get('Valor_API__c')){
                                            strareaExperiencia = sglListaValores.get('Valor_Usuario__c');
                                        }
                                    }
                                if(String.isEmpty(strareaExperiencia))
                                    strareaExperiencia = mapGroup.get(sglCase.OwnerId).Name;
                                strNombreUsuario = mapGroup.get(sglCase.OwnerId).Name;
                            }
                            if(String.isNotEmpty(strareaExperiencia)){
                                lstCase.add(new Case(id=sglCase.id, Area__c = strareaExperiencia));
                                lstNewTimes.add(new Cronometros__c(Caso__c= sglCase.id,FechaInicio__c=system.now(),NombreUsuario__c=strNombreUsuario,Usuario__c=IdPropietario,Estado__c = 'En Curso', Area__c = strareaExperiencia));
                                if(strareaExperiencia.contains('Retenciones')){
                                    lstRetenciones.add(new Fidelizacion__c(Origen_de_la_Retencion__c = 'Cliente',Estado_de_cierre__c = 'Abierta',Cuenta__c = sglCase.AccountId,NumerodeCaso__c = sglCase.id,Contacto__c = sglCase.contactId,RecordTypeId = SObjectType.Fidelizacion__c.getRecordTypeInfosByDeveloperName().get('Retencion').getRecordTypeId()));
                                }
                            }
                        }
                    }
                }
                if(!lstRetenciones.isEmpty())
                    insert lstRetenciones;
                if(!lstNewTimes.isEmpty())
                    insert lstNewTimes;
                if(!lstCase.isEmpty())
                    update lstCase;
            }
            if(trigger.isUpdate){
                System.debug('Case TGR isAfter isUpdate');
                Id casePQRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
                Id caseSOPORTETId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SOPORTE_TECNICO').getRecordTypeId();
                List<id> lstUser = new List<id>();
                List<id> lstGroup = new List<id>();
                Map<id,User> mapUser = new Map<id,User>();
                Map<id,Group> mapGroup = new Map<id,Group>();
                List<Case> lstCase = new List<Case>();
                List<Case> lstCasosFidelizacion = new List<Case>();
                Map<id,id> mapCasosFidelizacion = new Map<id,id>();
                List<Fidelizacion__c> lstRetenciones = new List<Fidelizacion__c>();
                //List<Case> lstActividades = new List<Case>();
                //Map<id,Task> mapCasosTask = new Map<id,Task>();
                Map<id,Cronometros__c> mapCasosCrono = new Map<id,Cronometros__c>();
                List<Task> lstOldTask = new List<Task>();
                List<Cronometros__c> lstNewTimes = new List<Cronometros__c>();
                List<Cronometros__c> lstOldTimes = new List<Cronometros__c>();
                Map<String,List<Map<String,String>>> mpListaValores = new Map<String,List<Map<String,String>>>();
                for(Case sglCase:trigger.new){
                    if(sglCase.RecordTypeId == casePQRTId || sglCase.RecordTypeId == caseSOPORTETId){
                        if(sglCase.OwnerId!=null && sglCase.OwnerId != Trigger.oldMap.get(sglCase.Id).OwnerId){
                            if(sglCase.OwnerId.getSObjectType().getDescribe().getName() == 'User'){
                                lstUser.add(sglCase.OwnerId);
                            }else{
                                lstGroup.add(sglCase.OwnerId);
                            }
                        }
                        lstCasosFidelizacion.add(sglCase);
                    }
                }
                if(!lstUser.isEmpty()){
                    mapUser = new Map<Id,User>([select id, Area__c,UserRole.Name,Username from User WHERE Id IN :lstUser]);
                }
                if(!lstGroup.isEmpty()){
                    mapGroup = new Map<Id,Group>([select id, Name from Group WHERE Id IN :lstGroup]);
                }
                if(!lstUser.isEmpty() || !lstGroup.isEmpty())
                    mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('LV_Compleja__mdt','Tipo_Lista__c = \'GRUPOS\'');
                //Map<id,Task> mapTasks = new Map<id,Task>([select id, Fecha_Inicio__c, Fecha_Fin__c, WhatId, OwnerId from task where WhatId IN :lstCasosFidelizacion AND Subject = 'Seguimiento de tiempo' AND Status = 'En curso']);
                Map<id,Cronometros__c> mapCronometros = new Map<id,Cronometros__c>([select id, FechaInicio__c, FechaFin__c, Usuario__c,Caso__c from Cronometros__c where Caso__c IN :lstCasosFidelizacion AND Estado__c = 'En Curso']);
                
                Map<id,Fidelizacion__c> mapFidelizacion = new Map<id,Fidelizacion__c>([select id, NumerodeCaso__c from Fidelizacion__c WHERE NumerodeCaso__c IN :lstCasosFidelizacion]);
                for(Fidelizacion__c sglFidelizacion:mapFidelizacion.values()){
                    mapCasosFidelizacion.put(sglFidelizacion.NumerodeCaso__c,sglFidelizacion.id);
                }
                BusinessHours bhToUse = null;
                if(!mapCronometros.isEmpty()){
                    bhToUse = [SELECT Id FROM BusinessHours WHERE Name = 'Horario Cronometro Casos'];
                    for(Cronometros__c sglCronometro:mapCronometros.values()){
                        mapCasosCrono.put(sglCronometro.Caso__c,sglCronometro);
                    }
                }
                for(Case sglCase:trigger.new){
                    if(sglCase.RecordTypeId == casePQRTId || sglCase.RecordTypeId == caseSOPORTETId){
                        String strareaExperiencia = '';
                        String strNombreUsuario = '';
                        Id IdPropietario = null;
                        if(sglCase.OwnerId != Trigger.oldMap.get(sglCase.id).OwnerId){
                            if(mapCasosCrono.containsKey(sglCase.id)){
                                lstOldTimes.add(new Cronometros__c(Id=mapCasosCrono.get(sglCase.id).Id,Estado__c = 'Completada',Duracion__c = PS_IntegrationHelper_ctr.obtenerHoras(bhToUse,mapCasosCrono.get(sglCase.id).FechaInicio__c,system.now()),FechaFin__c = system.now()));
                            }
                            if(sglCase.OwnerId.getSObjectType().getDescribe().getName() == 'User'){
                                strNombreUsuario = mapUser.get(sglCase.OwnerId).username;
                                IdPropietario = sglCase.OwnerId;
                                if(String.isNotEmpty(mapUser.get(sglCase.OwnerId).Area__c))
                                    strareaExperiencia = mapUser.get(sglCase.OwnerId).Area__c;
                                else
                                    strareaExperiencia = mapUser.get(sglCase.OwnerId).UserRole.Name;
                            }else{
                                if(!mpListaValores.isEmpty())
                                    for(Map<String,String> sglListaValores:mpListaValores.get('GRUPOS')){
                                        if(mapGroup.get(sglCase.OwnerId).Name == sglListaValores.get('Valor_API__c')){
                                            strareaExperiencia = sglListaValores.get('Valor_Usuario__c');
                                        }
                                    }
                                if(String.isEmpty(strareaExperiencia))
                                    strareaExperiencia = mapGroup.get(sglCase.OwnerId).Name;
                                strNombreUsuario = mapGroup.get(sglCase.OwnerId).Name;
                            }
                            if(String.isNotEmpty(strareaExperiencia)){
                                lstCase.add(new Case(id=sglCase.id, Area__c = strareaExperiencia));
                                lstNewTimes.add(new Cronometros__c(Caso__c= sglCase.id,FechaInicio__c=system.now(),NombreUsuario__c=strNombreUsuario,Usuario__c=IdPropietario,Estado__c = 'En Curso', Area__c = strareaExperiencia));
                                if(strareaExperiencia.contains('Retenciones') && !mapCasosFidelizacion.containsKey(sglCase.id)){
                                    lstRetenciones.add(new Fidelizacion__c(Origen_de_la_Retencion__c = 'Cliente',Estado_de_cierre__c = 'Abierta',Cuenta__c = sglCase.AccountId,NumerodeCaso__c = sglCase.id,Contacto__c = sglCase.contactId,RecordTypeId = SObjectType.Fidelizacion__c.getRecordTypeInfosByDeveloperName().get('Retencion').getRecordTypeId()));
                                }
                            }
                        }
                        if((sglCase.Status == 'Cerrado' || sglCase.isClosed) && sglCase.Status != Trigger.oldMap.get(sglCase.id).Status && mapCasosCrono.containsKey(sglCase.id)){
                            lstOldTimes.add(new Cronometros__c(Id=mapCasosCrono.get(sglCase.id).Id,Estado__c = 'Completada',Duracion__c = PS_IntegrationHelper_ctr.obtenerHoras(bhToUse,mapCasosCrono.get(sglCase.id).FechaInicio__c,system.now()),FechaFin__c = system.now()));
                        }
                    }
                }
                if(!lstRetenciones.isEmpty())
                    insert lstRetenciones;
                if(!lstNewTimes.isEmpty())
                    insert lstNewTimes;
                if(!lstOldTimes.isEmpty())
                    update lstOldTimes;
                if(!lstCase.isEmpty())
                    update lstCase;
            }
        }
        
        if(trigger.isAfter){
            if(trigger.isUpdate){
                Id casePQRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
                Id caseSOPORTETId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SOPORTE_TECNICO').getRecordTypeId();
                String Estado = 'Cerrado';
                List<Case> lstCasosFidelizacion = new List<Case>();
                List<Id> lstBusinessHours = new List<Id>();
                Map<id,id> mapCasosFidelizacion = new Map<id,id>();
                Map<id,Cronometros__c> mapCasosCrono = new Map<id,Cronometros__c>();
                List<Task> lstOldTask = new List<Task>();
                List<Cronometros__c> lstOldTimes = new List<Cronometros__c>();
                Set<Id> idsCasos = new Set<Id>();
                for(Case sglCase:trigger.new){
                    if(sglCase.RecordTypeId == casePQRTId || sglCase.RecordTypeId == caseSOPORTETId){
                        lstCasosFidelizacion.add(sglCase);
                        idsCasos.add(sglCase.Id);
                    }
                }
                Map<id,Cronometros__c> mapCronometros = new Map<id,Cronometros__c>([select id, FechaInicio__c, FechaFin__c, Usuario__c,Caso__c,Caso__r.Matriz_de_Tipificacion__c,Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c from Cronometros__c where Caso__c IN :lstCasosFidelizacion AND Estado__c = 'En Curso']);
                //BusinessHours bhToUse = null;
                if(!mapCronometros.isEmpty()){
                    //bhToUse = [SELECT Id FROM BusinessHours WHERE Name = 'Horario Cronometro Casos'];
                    for(Cronometros__c sglCronometro:mapCronometros.values()){
                        mapCasosCrono.put(sglCronometro.Caso__c,sglCronometro);
                        if(sglCronometro.Caso__r.Matriz_de_Tipificacion__c!=null){
                            if(sglCronometro.Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c!=null){
                                lstBusinessHours.add(sglCronometro.Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c);
                            }
                        }
                    }
                }
                Map<id,BusinessHours> mpBusinessHours = new Map<id,BusinessHours>([SELECT Id FROM BusinessHours WHERE Id IN :lstBusinessHours]);
                Set<Id> encuestas = new Set<Id>();
                Map<Id,Case> mapCasos = New Map<Id,Case>([SELECT Id,Account.Segmento__c FROM Case WHERE Id IN :idsCasos]);
                for(Case sglCase:trigger.new){
                    if(sglCase.RecordTypeId == casePQRTId || sglCase.RecordTypeId == caseSOPORTETId){
                        String strareaExperiencia = '';
                        String strNombreUsuario = '';
                        Id IdPropietario = null;
                        Id IdtmpBH = null;
                        if(sglCase.OwnerId != Trigger.oldMap.get(sglCase.id).OwnerId){
                            if(mapCasosCrono.containsKey(sglCase.id)){
                                if(mapCasosCrono.get(sglCase.id).Caso__r.Matriz_de_Tipificacion__c!= null){
                                    if(mapCasosCrono.get(sglCase.id).Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c!=null){
                                        IdtmpBH = mapCasosCrono.get(sglCase.id).Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c;
                                    }
                                }
                                lstOldTimes.add(new Cronometros__c(Id=mapCasosCrono.get(sglCase.id).Id,Estado__c = 'Completada',Duracion__c = (!mpBusinessHours.containskey(IdtmpBH)?0:PS_IntegrationHelper_ctr.obtenerHoras(mpBusinessHours.get(IdtmpBH),mapCasosCrono.get(sglCase.id).FechaInicio__c,system.now())),FechaFin__c = system.now()));
                            }
                        }
                        if((sglCase.Status == 'Cerrado' || sglCase.isClosed) && sglCase.Status != Trigger.oldMap.get(sglCase.id).Status && mapCasosCrono.containsKey(sglCase.id)){
                            if(mapCasosCrono.get(sglCase.id).Caso__r.Matriz_de_Tipificacion__c!= null){
                                if(mapCasosCrono.get(sglCase.id).Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c!=null){
                                    IdtmpBH = mapCasosCrono.get(sglCase.id).Caso__r.Matriz_de_Tipificacion__r.Horas_de_negocio__c;
                                }
                            }
                            lstOldTimes.add(new Cronometros__c(Id=mapCasosCrono.get(sglCase.id).Id,FechaFin__c = system.now(),Duracion__c = (!mpBusinessHours.containskey(IdtmpBH)?0:PS_IntegrationHelper_ctr.obtenerHoras(mpBusinessHours.get(IdtmpBH),mapCasosCrono.get(sglCase.id).FechaInicio__c,system.now())),Estado__c = 'Completada'));
                            system.debug(lstOldTimes);
                        }
                        System.debug('Caso--->'+sglCase);
                        if((sglCase.Status == Estado ) && sglCase.EncuestaProcesada__c == false && (sglCase.NoIntentosEncuesta__c == 0 || sglCase.NoIntentosEncuesta__c == null) && mapCasos.get(sglCase.Id).Account.Segmento__c == 'MiPymes'){
                            encuestas.add(sglCase.Id);
                        }
                    }
                }
                
                if(!encuestas.isEmpty() && EncuestaSatisfaccion_ws.encuestaCheck){
                    EncuestaSatisfaccion_ws.encuestaCheck = false;
                    EncuestaSatisfaccion_ws job = new EncuestaSatisfaccion_ws(encuestas);
                    ID jobID = System.enqueueJob(job);
                }
                if(!lstOldTimes.isEmpty())
                    update lstOldTimes;
            }
        }
    }

}