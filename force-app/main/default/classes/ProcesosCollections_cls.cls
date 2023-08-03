public class ProcesosCollections_cls {
    
    @Future(callout=true)
    public static void procesarAccion(string jsonStringInputData) {          
        Map<string, string> mapInputData = (Map<string, string>)System.JSON.deserialize(jsonStringInputData, Map<string, string>.class);
        string tramiteAccion		= mapInputData.get('tramite').trim();
        string causalAccion			= mapInputData.get('causal').trim();		
        string cuentaFacturacion	= mapInputData.get('cuentaFacturacion').trim();
        string logID				= mapInputData.get('logID');
        string errorTransaccion		= '';
                
        //Obtener los tipos de operación por plan relacionados con el trámite a procesar
        list<TOPP__c> lstTOPP 		= getTiposOperacionPorPlan(tramiteAccion);
        
        //Mapa para guardar los tipos de operacion por plan a procesar
        map<String, TOPP__c> mapTOPP = new map<String, TOPP__c>();
        set<String> setRT = new set<String>();
        
        for(TOPP__c topp : lstTOPP){
            if(topp.Plan__c !=  null)
            	mapTOPP.put(topp.TipodeOperacionporplan__c + topp.Plan__c, topp);               
            else
                mapTOPP.put(topp.TipodeOperacionporplan__c + topp.LTE_Catalogo_de_Producto__c, topp);                
            
            setRT.add(topp.Tipoderegistro__c);
        }         
        
        //Obtener los tipos de registro asociados a los TOPPs
        map<String, RecordType> mapRT = getMapTipoRegistroPorTOPP(setRT);
        
        //Obtener las cuentas de facturación a procesar y su jerarquía
        set<String> setCF = getCuentasFacturacion(cuentaFacturacion);

        //Obtener los servicios asociados a la cuenta de facturación
        list<ActivoETB__c> ListServicios = getServicios(setCF, tramiteAccion);
        
        //Generar las operaciones comerciales
        if(ListServicios.size() > 0){            
            map<String, OperacionComercial__c> mapOCs = new map<String, OperacionComercial__c>();
            List<ActivoETB__c> listActualizarServicios = new List<ActivoETB__c>();
            LTE_TramitesSuspenda__c objTramite = LTE_TramitesSuspenda__c.getAll().get(tramiteAccion+', '+causalAccion);
            
            for(ActivoETB__c servicio : ListServicios){                
                string llaveRegistro;                
                if(servicio.NombredelProducto__r.Name == label.LTE)
                    llaveRegistro = tramiteAccion + servicio.NombredelProducto__r.Id;
                else
                    llaveRegistro = tramiteAccion + servicio.Plan__r.Id;
                
                if(mapTOPP.containsKey(llaveRegistro)){                                   
                    OperacionComercial__c oc 	= new OperacionComercial__c();
                    oc.CuentaCliente__c 		= servicio.NombredelaCuenta__c;
                    oc.Activo__c 				= servicio.Id;
                    oc.Plan__c 					= servicio.Plan__c;
                    oc.CuentaFacturacion__c 	= servicio.CuentaFacturacion__c;
                    oc.TOPP__c 					= mapTOPP.get(llaveRegistro).Id;
                    oc.RecordTypeId 			= mapRT.get(mapTOPP.get(llaveRegistro).Tipoderegistro__c).Id;
                    oc.FechaInicioReconexion__c = Date.today();
                    oc.FechaRetiro__c 			= Date.today();
                    oc.Estado__c 				= 'Facturado';
                    oc.TipoSuspension__c 		= causalAccion;     
                    oc.Comentarios__c			= Label.Collections_ComentarioEnOC;
                                    
                    if(tramiteAccion == 'Retiro')
                        oc.CausalRetiro__c = causalAccion;
                    
                    mapOCs.put(servicio.Id, oc);
                    
                    // Actualizar servicio
                    servicio.Estado__c     			= objTramite.LTE_EstadoServicio__c;
                    servicio.LTE_Causal__c 			= objTramite.LTE_Causal__c;
                    servicio.AccionCollections__c	= tramiteAccion;                        
                    listActualizarServicios.add(servicio);                    
                }     
            } 
            if(!mapOCs.isEmpty()){
                System.Savepoint svPoint;
                try{                    
                    svPoint = Database.setSavepoint();
                	BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            		insert mapOCs.values();
                	update listActualizarServicios;
                	BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    
                }catch(Exception e) {
                    errorTransaccion = e.getMessage()+' - '+e.getStackTraceString();
                    system.debug('ErrorCollection :: '+errorTransaccion);
                    Database.rollback(svPoint);
                }finally{                        
                    if(logID != null && logID != ''){                        
                        LogTransacciones__c logTransaccion = new LogTransacciones__c(Id=logID);
                        if(errorTransaccion.length() > 0){
                            errorTransaccion = errorTransaccion.substring(0, 250);
                            logTransaccion.Error_Apex__c = errorTransaccion;
                        }else
                            logTransaccion.Error_Apex__c = 'OK con registros';
                        
                        update logTransaccion;
                    }
                }
            }
        }else{
        	if(logID != null && logID != ''){
                LogTransacciones__c logTransaccion = new LogTransacciones__c(Id=logID);
				logTransaccion.Error_Apex__c = 'OK sin registros';
				update logTransaccion;
        	}
        }
    }  
    public static list<TOPP__c> getTiposOperacionPorPlan(String tramite){
        return new list<TOPP__c>([
            Select  Id, TipodeOperacionporplan__c, Tipoderegistro__c, LTE_Catalogo_de_Producto__c, Plan__c
            From    TOPP__c
            Where   TipodeOperacionporplan__c =: tramite And 
            		(Plan__r.NombredelProducto__r.Tipo_de_Producto__c = 'Basico' or LTE_Catalogo_de_Producto__r.Name = :label.LTE)
        ]); 
    }
    public static map<String, RecordType> getMapTipoRegistroPorTOPP(set<String> setRT){
        list<RecordType> lstRT = [
            Select  Id, DeveloperName, SObjectType
            From    RecordType
            Where   DeveloperName IN :setRT
        ];
        map<String, RecordType> mapRT = new map<String, RecordType>();
        for(RecordType rt :lstRT)
            mapRT.put(rt.DeveloperName, rt);
            
        return mapRT;
    }
    public static set<String> getCuentasFacturacion(String cuentaFacturacion){     
        set<String> setCF = new set<String>();
        list<CuentaFacturacion__c> listCuentasFact = new list<CuentaFacturacion__c>([
            Select  Name
            From    CuentaFacturacion__c
            Where   Name =: cuentaFacturacion OR LTE_CuentaFacturacionPadre__r.Name =: cuentaFacturacion]);
        
        for(CuentaFacturacion__c cuentaFact : listCuentasFact){
            setCF.add(cuentaFact.Name);
        }
        return setCF;
    }
    
    public static list<ActivoETB__c> getServicios(set<String> cuentasFacturacion, string tramiteAccion){
        string soql_query;
        list<ActivoETB__c> listActivos = new list<ActivoETB__c>();
        soql_query = 'Select  Id, NumeroConexion__c, NombredelaCuenta__c, NombredelaCuenta__r.AccountNumber, '
            	    +'NombredelaCuenta__r.Tipodedocumento__c, Estado__c, CuentaFacturacion__c, '
                    +'Plan__c, LTE_Causal__c, NombredelProducto__r.Id, NombredelProducto__r.Name, '
            		+'Plan__r.Id, AccionCollections__c '
            		+'From ActivoETB__c '
            		+'Where CuentaFacturacion__r.Name IN : cuentasFacturacion ';
        
        if(tramiteAccion == 'Suspensión')
            soql_query += 'AND (Estado__c != \'Inactivo\' AND Estado__c != \'Suspendido\')';        
        else if(tramiteAccion == 'Reconexión')
            soql_query += 'AND (Estado__c = \'Suspendido\' AND AccionCollections__c = \'Suspensión\')';        
        else if(tramiteAccion == 'Retiro')
            soql_query += 'AND Estado__c != \'Inactivo\'';
        else
            soql_query = '';
                
        if(soql_query != '')
        	listActivos = database.query(soql_query);        
        
        return listActivos;        
    }
}