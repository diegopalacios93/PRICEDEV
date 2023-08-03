/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Integraciones LTE Disponibilidad M6
Descripcion:            Batch Para obtener la Disponibilidad M6
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     09-08-2015  Hector Bayona (HB)      Creacion de la clase
2.0     09-08-2018  Javier Acero  (JA)      Adición de campo SDP INI9685
3.0		27-08-2018	Fernando Sarasty (FS)	Se incluye en el query del método "start", el campo "Activo__r.LTE_ICCID__c".
*******************************************************************************/
global class LTE_AvailabilitQueryOrder_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    
    global boolean limitQ=false;
    global integer limiteTotal=30;
    global boolean esVIP=false;
    global set<id>idImediato=new set<id>();
    
    global Database.Querylocator start(Database.Batchablecontext bc)
    {
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        string producto=vGlobal.get('NombreComercialLTE').valor__c;
        
        String query = 'SELECT  Id,Name,TipoSeleccion__c,CuentaCliente__c,Plan__r.TipodePlan__c,Plan__r.Pertenece_a_Troncal_SIP_Unificada__c,Activo__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c,Plan__r.LTE_MetodoDePago__c,Activo__r.LTE_ICCID__c'
            /*+' (SELECT Name, NumeracionM2M__c FROM Detalles_de_las_ofertas__r) '*/
            +' FROM OperacionComercial__c '
            +' WHERE ('
            +' (((Estado__c = \'Equipo entregado\' And Portacion__c=False And Legalizacion__r.Estado__c=\'Gestionado\') OR ((Estado__c = \'Pendiente\' OR Estado__c = \'Equipo entregado\') And Portacion__c=True  And FechadeActivacion__c <= TODAY)) AND TOPP__r.TipodeOperacionporplan__c=\'Venta\' AND Plan__r.TipodePlan__c!=\'Troncal SIP\') OR '
            +' (Estado__c = \'En Curso\' AND TOPP__r.TipodeOperacionporplan__c=\'Cambio Número\') OR '
            +' (Estado__c = \'En Curso\' AND TOPP__r.TipodeOperacionporplan__c=\'Venta\' AND Plan__r.TipodePlan__c=\'Troncal SIP\'And Legalizacion__r.Estado__c=\'Gestionado\') OR '
            +' ((TOPP__r.TipodeOperacionporplan__c=\'Renovación\' OR TOPP__r.TipodeOperacionporplan__c=\'Reposición\') AND (LTE_TipoTransaccion__c = \'SIM\' OR LTE_TipoTransaccion__c = \'Equipo más SIM\') And Estado__c = \'Equipo entregado\') )'
            +' AND TOPP__r.LTE_Catalogo_de_Producto__r.Name=\''+producto+'\' '
            +' AND Plan__r.NombredelProducto__r.Name=\''+producto+'\' '
            +' AND (LTE_ICCID__c!=null OR (LTE_ICCID__c=null AND Plan__r.TipodePlan__c=\'Troncal SIP\'))';
            
        if(!idImediato.isEmpty()){
            query+=' AND id IN :idImediato ';   
        }
        
        if(esVIP){
            query+=' AND LTE_AplicaOnline__c=true ';
        }
        
        if(limitQ){
            query+=' Limit '+limiteTotal+' ';
        }
        
        system.debug('\nConsultaBatch: '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
        
        system.debug(scope.size());
        
        List<LogTransacciones__c> logLst=new List<LogTransacciones__c>();
        //Realiza el llamdo
        list<consultaServ> con=new list<consultaServ>();
        
		//llamar todas las operaciones comerciales que tengan el check habilitado.
		EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('DisponibilidadM6');
		if(integra!=null && integra.Ejecucion__c==true)
		{
            //Consulta el servicio
            for(OperacionComercial__c col: scope){
                system.debug('AvailabilitQueryOrder:'+ col.Id);
                con.add(new consultaServ(col));
                try{
                    if(col.Estado__c=='Exitoso M6' || col.Estado__c=='Pendiente Activacion Bolsa'){
                        Map<Id,OperacionComercial__c>ocMap=New Map<Id,OperacionComercial__c>();
                        ocMap.put(col.Id,col);
                        system.debug('obtenerEstructurado');
                        LTE_Aprovisionamiento_cls.obtenerEstructurado(ocMap);
                    }           
                }catch(exception e){
                    col.Estado__c='Parametrización Fallida';
                    LogTransacciones__c logP=new LogTransacciones__c();
                    logP.LTE_Operacion_Comercial__c=col.id;
                    logP.Name='Error parametrizacion producto '+col.Name;
                    logP.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
                    logLst.add(logP);
                }
            }
            guardar(con,logLst);
        }
        
    }
    
    
    global void guardar(list<consultaServ> con, List<LogTransacciones__c> logLst){
        
        List<OperacionComercial__c> ocLst=new List<OperacionComercial__c>();
        
        for(consultaServ cs: con){
            ocLst.add(cs.oc);
            logLst.add(cs.log);
        }
        BanderasEjecucion.setEjecucion('ValidarPerfilesReglasOC');
        Database.SaveResult[] srList =Database.update(ocLst,false);
        
        for(Integer i=0;i<srList.size();i++){
            
            if (srList[i].isSuccess()) {
            }
            else {
                for(Database.Error err : srList[i].getErrors()) {
                    logLst[i].Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
                    system.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        system.debug(logLst);
        insert logLst;
        
    }
    
    global void finish(Database.BatchableContext bc){}
    
    global class consultaServ{
        
        public OperacionComercial__c oc;
        public string response='';
        public LogTransacciones__c log=new LogTransacciones__c();
        
        public consultaServ(OperacionComercial__c oc){
            this.oc=oc;
            consultar();
        }
        //Consume el servicio web
        public void consultar(){            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('DisponibilidadM6');
            map<string,string> values=new map<string,string>();
            string request='';
            string serv='';
            
            request=LTE_Aprovisionamiento_cls.AvailabilitQueryOrder(oc);            
            response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);            
            tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            
            values=proReq.getMap(response);
            
            if(values.get('status')=='PASS' && values.get('TIBCOResponseCode')=='01'){
                //oc.Estado__c='Pendiente aprovisionar';
                if(values.get('Number')!=null && values.get('Number')!=''){ 
                    oc.NumeroConexion__c=values.get('Number');
                }
                oc.LTE_PIN__c=values.get('PIN');
                oc.LTE_PIN2__c=values.get('PIN2');
                oc.LTE_PUK__c=values.get('PUK');
                oc.LTE_PUK2__c=values.get('PUK2');
                oc.LTE_IMSI__c=values.get('IMSI');
                oc.SDP__c=values.get('SDP');
                
                if(oc.Plan__r.TipodePlan__c == 'Troncal SIP'){
                    oc.Estado__c  ='Pendiente Activacion Bolsa';
                	log.Estado__c ='Pendiente Activacion Bolsa';                                   
                }else
                {
                	oc.Estado__c='Exitoso M6';
                	log.Estado__c='Exitoso M6';    
                }                
                //PIN,PUK,PIN2,PUK2
            }else{
                oc.Estado__c='Fallido M6';
                log.Estado__c='Fallido M6';                     
            }
            log.Informacion_Enviada__c=request;
            log.Informacion_Recibida__c=response;
            log.LTE_Operacion_Comercial__c=oc.id;
            log.Name='Disponibilidad M6 '+oc.Name;
            if(values.get('TIBCOResponseDescription')!=null){
                log.CodigoRespuesta__c=values.get('TIBCOResponseDescription').abbreviate(250);
            }            
        }        
    }
}