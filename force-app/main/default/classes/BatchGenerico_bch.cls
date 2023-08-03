/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               Portafolio Superior I
Descripcion:            Batch generico que unifica los procesos
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------       ---------------
1.0     27-11-2019  John Guevara    (HB)      Creación de la clase
*******************************************************************************/
global class BatchGenerico_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    global set<id>idImediato=new set<id>();
    global PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor Operacion;
    
    global Database.Querylocator start(Database.Batchablecontext bc){
        String sObjeto = '';
        String query = '';
        if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA){
            sObjeto = 'Viabilidad__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_CONSULTIVA || Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO){
            sObjeto = 'OperacionComercial__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_GENERAL){
            sObjeto = 'OperacionComercial__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_LINEAS){
            sObjeto = 'Lineas_OC__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Operacion_Comercial__c IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CONFIRMACION){
            sObjeto = 'OperacionComercial__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CORREO){
            sObjeto = 'OperacionComercial__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CORREO){
            sObjeto = 'OperacionComercial__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.RETENCION){
            sObjeto = 'OperacionComercial__c';
            query = 'SELECT Id FROM '+sObjeto+' WHERE Id IN :idImediato';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope){
        Set<Id> idRegistros = new Set<Id>();
        for(SObject sglOp:scope){
            idRegistros.add(sglOp.Id);
        }
        
        if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA ||
          Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_CONSULTIVA || 
          Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO){
            PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
            Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(idRegistros,Operacion);
            pscls.IntegracionGestor(mapDatos,Operacion);
          }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.RETENCION){
              Fidelizacion_Servicio_cls sd = new Fidelizacion_Servicio_cls();
              Map<Id,Map<String,Object>> mapDatos = sd.LoadMap(idRegistros);
              sd.IntegracionGestor(mapDatos);
          }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_GENERAL){
              PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
              Map<Id,Map<String,Object>> mapDatos = sd.LoadMap(idRegistros);
              sd.TOPPDispatcher(mapDatos);
          }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_LINEAS){
              PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
              Map<Id,Map<String,Object>> mapDatos = sd.LoadMapLinea(idRegistros);
              sd.IntegracionLinea(mapDatos);
          }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CONFIRMACION){
              List<OperacionComercial__c> lstOC = [SELECT Id,Name,TOPP__r.TipodeOperacionporplan__c,Detalle_del_tramite__c, (SELECT Id,Name FROM Lineas_OC__r WHERE Estado__c != 'Declinada' AND Estado__c != 'Facturada') FROM OperacionComercial__c WHERE Id IN :idRegistros];
              List<OperacionComercial__c> lstOCActualizar = new List<OperacionComercial__c>(); 
              for(OperacionComercial__c sglOC: lstOC){
                  if(sglOC.Lineas_OC__r.size()==0){
                      lstOCActualizar.add(new OperacionComercial__c(Id=sglOC.Id,Estado__c = 'Facturado'));
                  }else{
                      lstOCActualizar.add(new OperacionComercial__c(Id=sglOC.Id,Estado__c = 'No Exitoso Facturacion'));
                  }
              }
              if(!lstOCActualizar.isEmpty())
                  update lstOCActualizar;
          }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CORREO){
              List<OperacionComercial__c> lstOC = [SELECT Id,Name,Detalle_del_tramite__c FROM OperacionComercial__c WHERE Id IN :idRegistros];
              EmailTemplate et = [Select id,Owner.username,IsActive from EmailTemplate where developername = 'Envio_Facturacion_PS' limit 1];
              List<Contact> ct = [SELECT Id,Email FROM Contact WHERE Email = :UserInfo.getUserName()];
              if(et.IsActive && !ct.isEmpty()){
                  for(OperacionComercial__c sglOC: lstOC){
                      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                      mail.setSenderDisplayName(et.Owner.username);
                      mail.setTargetObjectId(ct[0].Email);
                      mail.setTemplateId(et.Id);
                      mail.setWhatId(sglOC.id);
                      mail.setSaveAsActivity(false);
                      Messaging.SendEmailResult[] repuesta=Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
                  }
              }
          }
    }
    
    global void finish(Database.BatchableContext bc){
        set<id> idFuturo = new set<id>();
        PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor OperacionFuturo;
        if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_GENERAL){
            idFuturo=idImediato;
            OperacionFuturo = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_LINEAS;
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_LINEAS){
            idFuturo=idImediato;
            OperacionFuturo = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CONFIRMACION;
        }else if(Operacion == PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CONFIRMACION){
            idFuturo=idImediato;
            OperacionFuturo = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_CORREO;
        }
        if(!idFuturo.isEmpty()){
            BatchGenerico_bch bch = new BatchGenerico_bch();
            bch.idImediato = idFuturo;
            bch.Operacion = OperacionFuturo;
            ID batchprocessid = Database.executeBatch(bch,1);
        }
    }
}