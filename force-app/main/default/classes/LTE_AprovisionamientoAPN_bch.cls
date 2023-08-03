/*******************************************************************************
Desarrollado por:       SQDM
Autor:                  John Guevara
Proyecto:               ETB - Integraciones LTE APN
Descripcion:            Batch para los servicios de APN
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     21-10-2016  John Guevara		      Creacion de la clase
*******************************************************************************/
global class LTE_AprovisionamientoAPN_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    
    global boolean limitQ=false;
    global integer limiteTotal=30;
    global boolean esVIP=false;
    global set<id>idImediato=new set<id>();
    
    global Database.Querylocator start(Database.Batchablecontext bc)
    {
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        
        String query = 'SELECT Id, Name, Caso__c, NumeroConexion__c, Estado_APN__c, Estado__c, Tipo_Operacion_APN__c, APN__c, APN__r.Charguing_Characteristics__c, APN__r.Servicio__c, POOL_de_APN__c, POOL_de_APN__r.Producto__c, POOL_de_APN__r.Direccionamiento__c, IP__c, IP__r.Name, Activo__c, Activo__r.IP__c, Activo__r.POOL_de_APN__c, Activo__r.APN__c, Activo__r.Pool_de_APN_Autopista__c, Pool_de_APN_Autopista__c, Activo__r.Pool_de_APN_Chico__c, Pool_de_APN_Chico__c, Activo__r.Tipo_de_APN__c, Tipo_de_Plan_APN__c, Tipo_de_APN__c, Activo__r.Tipo_de_Plan_APN__c, Activo__r.IP__r.Estado__c '
		+'FROM OperacionComercial__c '
		+'WHERE Aplica_APN__c=true AND Plan__r.NombredelProducto__r.Name=\''+vGlobal.Valor__c+'\' AND (Tipo_Operacion_APN__c = \'Adicion\' OR Tipo_Operacion_APN__c = \'Retiro\') AND Estado_APN__c <> \'Exitoso\' AND  Estado_APN__c <> \'Exitoso APN Datos\' '
        + 'AND ('
            +'(RecordType.Name = \'Gestion APN/IP\' AND Caso__c <> null AND Estado__c IN (\'Pendiente\',\'En Curso\')) '
            +'OR (RecordType.Name = \'Venta LTE\' AND APN__c <> null AND (Estado__c IN (\'Facturado\') OR (Estado__c IN (\'No Exitoso Facturacion\',\'Activa\') AND LTE_AplicaOnline__c=true)))'
        +')  ';
        
        if(esVIP){
            query+=' AND LTE_AplicaOnline__c=true ';
        }
        
        if(!idImediato.isEmpty()){
            query+=' AND id IN :idImediato ';   
        }
        
        query+=' ORDER BY LastModifiedDate DESC ';
        
        if(limitQ){
            query+=' Limit '+limiteTotal+' ';       
        }
        return Database.getQueryLocator(query);
    }
    	
    global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
        list<LTE_AprovisionamientoAPN_cls.consultaServ> cs=new list<LTE_AprovisionamientoAPN_cls.consultaServ>();
        
		//llamar todas las operaciones comerciales que tengan el check habilitado.
		EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('Aprovisionamiento');
		if(integra!=null && integra.Ejecucion__c==true)
		{
            for(OperacionComercial__c oc:scope){
                cs.add(new LTE_AprovisionamientoAPN_cls.consultaServ(oc, 'Exitoso'));
            }
            
            guardar(cs);
        }
    }
    
    global void finish(Database.BatchableContext bc){}
    
    global void guardar(list<LTE_AprovisionamientoAPN_cls.consultaServ> con){
        
        List<OperacionComercial__c> ocLst=new List<OperacionComercial__c>();
        List<ActivoETB__c> acLst=new List<ActivoETB__c>();
        List<IP__c> ipLst=new List<IP__c>();
        Map<Id,LogTransacciones__c> logLst=new Map<Id,LogTransacciones__c>();
        Map<Id,Id> mapIPxAC=new Map<Id,Id>();
        
        for(LTE_AprovisionamientoAPN_cls.consultaServ cs: con){
            ocLst.add(cs.oc);
            
            if(cs.ac != null){
                acLst.add(cs.ac);
                if(cs.objIP!=null){
                    ipLst.add(cs.objIP);
                    mapIPxAC.put(cs.ac.Id, cs.objIP.Id);
                }
            	logLst.put(cs.ac.Id, cs.log);
            }else{
                logLst.put(cs.oc.Activo__c, cs.log);
            }
        }
        
        Database.SaveResult[] srListac =Database.update(acLst,false);
        
        for (Integer iac = 0; iac < acLst.size(); iac++) {
            Database.SaveResult s = srListac[iac];
            ActivoETB__c origACRecord = acLst[iac];
            if (!s.isSuccess()) {
                if(logLst.containsKey(origACRecord.Id)){
                    for(Database.Error err : s.getErrors()) logLst.get(origACRecord.Id).Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
                    logLst.put(origACRecord.Id, logLst.get(origACRecord.Id));
                }
                system.debug(s.getId()); // I get null here
                system.debug(origACRecord.Id); //This should be the Id you're looking for
           } 
        }
        
        
        Database.SaveResult[] srListip =Database.update(ipLst,false);
        
        for (Integer iip = 0; iip < ipLst.size(); iip++) {
            Database.SaveResult s = srListac[iip];
            IP__c origIPRecord = ipLst[iip];
            if (!s.isSuccess()) {
                if(mapIPxAC.containsKey(origIPRecord.Id)){
                    if(logLst.containsKey(mapIPxAC.get(origIPRecord.Id))){
                        for(Database.Error err : s.getErrors()) logLst.get(mapIPxAC.get(origIPRecord.Id)).Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
                        logLst.put(mapIPxAC.get(origIPRecord.Id), logLst.get(mapIPxAC.get(origIPRecord.Id)));
                    }
                }
                system.debug(s.getId()); // I get null here
                system.debug(origIPRecord.Id); //This should be the Id you're looking for
            } 
        }
        
        Database.SaveResult[] srList =Database.update(ocLst,false);
        
        for (Integer ioc = 0; ioc < ocLst.size(); ioc++) {
            Database.SaveResult s = srList[ioc];
            OperacionComercial__c origOCRecord = ocLst[ioc];
            if (!s.isSuccess()) {
                if(logLst.containsKey(origOCRecord.Activo__r.Id)){
                    for(Database.Error err : s.getErrors())logLst.get(origOCRecord.Activo__r.Id).Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
                    logLst.put(origOCRecord.Activo__r.Id, logLst.get(origOCRecord.Activo__r.Id));
                }
                system.debug(s.getId()); // I get null here
                system.debug(origOCRecord.Id); //This should be the Id you're looking for
             } 
        }
        
        insert logLst.values();
    }

}