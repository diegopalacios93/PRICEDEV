/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Fidelizacion
Descripción:			Clase de prueba Fidelizacion_Servicio

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		05-12-2014	Hector Bayona(HB)		Creación de la clase
*******************************************************************************/

public with sharing class Fidelizacion_Servicio_cls {
	
	public void crearOcActivos(list<Fidelizacion_Servicio__c> fidelServic){		
		map<id,Fidelizacion_Servicio__c> acFidelLst=new map<id,Fidelizacion_Servicio__c>();
        map<id,Fidelizacion__c> mpFidel=new map<id,Fidelizacion__c>();
        Set<Id> lstFide = new Set<Id>();
		
		//Identifico los activos/servicios a tramitar
		for(Fidelizacion_Servicio__c fs:fidelServic){
			acFidelLst.put(fs.Servicio_ETB__c,fs);
            if(!lstFide.contains(fs.Fidelizacion__c))
                lstFide.add(fs.Fidelizacion__c);
		}
		set<id>idac=acFidelLst.keySet();
		system.debug(idac);
		
		//Obtengo la informacion del activo
		String query = LibreriaUtilitaria_cls.getQuery('ActivoETB__c','where id = :idac',true);
    	list<sObject> sobjList = Database.query(query);
    	
        if(!lstFide.isEmpty())
            mpFidel = new map<id,Fidelizacion__c>([SELECT Id FROM Fidelizacion__c WHERE Id IN :lstFide]);
        
    	list<OperacionComercial__c> nuevasOc=new list<OperacionComercial__c>();
    	
    	Map<String,Schema.RecordTypeInfo> formatos = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();

    	
    	//Itera sobre el servicio creando el clon
    	for(sObject so:sobjList){
    		
			OperacionComercial__c oc=LibreriaUtilitaria_cls.clonarOc(so);
			
            if(acFidelLst.get(oc.Activo__c).Tipo_de_registro__c!=null){
                oc.TOPP__c=acFidelLst.get(oc.Activo__c).TOPP__c;
                oc.RecordTypeId=formatos.get(acFidelLst.get(oc.Activo__c).Tipo_de_registro__c).getRecordTypeId();
                oc.Estado__c='Pendiente';
                oc.Fidelizacion__c=acFidelLst.get(oc.Activo__c).id;
                if(mpFidel.containskey(oc.Fidelizacion__c))
                    oc.Caso__c = mpFidel.get(oc.Fidelizacion__c).NumerodeCaso__c;
                nuevasOc.add(oc);
            }
			
			if(acFidelLst.get(oc.Activo__c).Tipo_de_registro2__c!=null){
				OperacionComercial__c oc2=oc.clone(false,false,false,false);
                oc2.TOPP__c=acFidelLst.get(oc2.Activo__c).Tipo_Operacion_por_Plan_cambio_de_plan__c;
                oc2.RecordTypeId=formatos.get(acFidelLst.get(oc.Activo__c).Tipo_de_registro2__c).getRecordTypeId();
                oc2.Estado__c='Pendiente';
                oc2.Fidelizacion__c=acFidelLst.get(oc.Activo__c).id;
                nuevasOc.add(oc2);		
			}
			
		}
		
		try{
    		insert nuevasOc;
    		system.debug(nuevasOc);
    		//update cambios.values();
    	}catch(exception e){
    		
    	}
	}
    
    public Map<Id,Map<String,Object>> LoadMap(Set<Id> lstOCIds){
        
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Alarma Retencion'];
        String sFields = lstMensajes.Mensaje__c;
        Set<String> setFields = new Set<String>();
        setFields.addAll(sFields.split(','));
        
        String sql = 'SELECT '+sFields+' FROM OperacionComercial__c WHERE Id IN :lstOCIds';
        List<OperacionComercial__c> lstOC = Database.query(sql);
        
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        
        for(OperacionComercial__c sglOC:lstOC){
            
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            for(String sglfield:setFields){
                if(sglfield.trim()=='FechadeActivacion__c'){
                    Date dtFecha = (Date)sglOC.get(sglfield.trim());
                    Map<String,Object> mapDate = new Map<String,Object>();
                    mapDate.put('fulldate', String.valueOf(dtFecha));
                    mapDate.put('day', String.valueOf(dtFecha.day()).leftpad(2,'0'));
                    mapDate.put('month', String.valueOf(dtFecha.month()).leftpad(2,'0'));
                    mapDate.put('year', String.valueOf(dtFecha.year()));
                    tmpMapHierarchy.put(sglfield.trim(),mapDate);
                    //End_Date
                    Date dt_EndFecha = dtFecha.addDays(1);
                    Map<String,Object> mapDateEnd = new Map<String,Object>();
                    mapDateEnd.put('fulldate', String.valueOf(dt_EndFecha));
                    mapDateEnd.put('day', String.valueOf(dt_EndFecha.day()).leftpad(2,'0'));
                    mapDateEnd.put('month', String.valueOf(dt_EndFecha.month()).leftpad(2,'0'));
                    mapDateEnd.put('year', String.valueOf(dt_EndFecha.year()));
                    tmpMapHierarchy.put('Post_'+sglfield.trim(),mapDateEnd);
                }else{
                    tmpMapHierarchy.put(sglfield.trim(), LibreriaUtilitaria_cls.recorreCampos(sglOC, sglfield.trim()));
                }
            }
            mapHierarchy.put(sglOC.Id,tmpMapHierarchy.clone());
        }
        
        return mapHierarchy;
    }
    
    public Map<Id,String> IntegracionGestor(Map<Id,Map<String,Object>> MapHierarchy){
        List<OperacionComercial__c> lstOC = [SELECT Id,Name FROM OperacionComercial__c WHERE Id IN :MapHierarchy.keyset()];
        Map<Id,String> mpResultado = new Map<Id,String>();
        List<LogTransacciones__c> lstLogTransacciones = new List<LogTransacciones__c>();
        
        Map<String,String> mapMensajesIntegracion = new Map<String,String>();
        List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='PS_Alarma_Retencion'];
        for(Mensaje_Integracion__c sglMensaje:lstMensajes){
            mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
        }
        
        for(OperacionComercial__c sglOC:lstOC){
            try{
                Dom.Document docMessageTemplate = new Dom.Document();
                docMessageTemplate.load(mapMensajesIntegracion.get('PS_Alarma_Retencion'));
                
                PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
                Dom.Document docServices = clsHelper.PopulateXML(docMessageTemplate, MapHierarchy.get(sglOC.Id));
                DOM.Document docResponse;
                String correlationID = sglOC.Id;
                
                //Invocar servicio web 
                //---------------------------------
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('GestorSolicitudesAlarmaRetencion');
                String response=LibreriaUtilitariaJobs_cls.consultarServicio(docServices.toXmlString(),sw.Action__c,sw.EndPoint__c);
                
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.Name = 'Actualizar alarma retencion - ' + sglOC.Name;
                logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                logServicio.Informacion_Recibida__c = response;
                logServicio.AC_CorrelationID_Random__c = sglOC.Id;
                logServicio.LTE_Operacion_Comercial__c = sglOC.Id;
                //logServicio.Estado__c = String.isEmpty(mpResultado.get(sglRecord))?'Realizado':'Fallido';
                lstLogTransacciones.add(logServicio);
                //PS_InvokeServicesProvisioningRev_cls invokeServicesProvisioningRevchain = new PS_InvokeServicesProvisioningRev_cls();
                //docResponse = invokeServicesProvisioningRevchain.InvokeServiceProvisioning(correlationID, sglOC.Id, docServices);
            }catch(Exception e){
                //Insertar log de envió de facturación erróneo
                String Error_Description = 'Message: ' +  e.getMessage() + ', StackTraceString: ' +  e.getStackTraceString() + ', TypeName:' + e.getTypeName();
                system.debug('Error_Description:--->'+ Error_Description);
                LogTransacciones__c logServicio = new LogTransacciones__c();
                logServicio.AC_CorrelationID_Random__c = sglOC.Id;
                logServicio.LTE_Operacion_Comercial__c = sglOC.Id;
                logServicio.Error_Apex__c = Error_Description;
                logServicio.Estado__c = 'Fallido';
                logServicio.Name = 'Actualizar alarma retencion - ' + sglOC.Name;
                lstLogTransacciones.add(logServicio);
            }
        }
        
        if(!lstLogTransacciones.isEmpty())
            insert lstLogTransacciones;
        return mpResultado;
    }

}