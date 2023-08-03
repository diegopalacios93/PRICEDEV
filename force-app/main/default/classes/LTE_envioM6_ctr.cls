public with sharing class LTE_envioM6_ctr {
    
    map<string,string> parametros =new map<string,string>();
    public OperacionComercial__c oc{get;set;}
    public LogTransacciones__c log{get;set;}
    public boolean error{get;set;}
    Map<string,VariablesGlobales__c> vGlobal;
    public string idOC;
    
    public LTE_envioM6_ctr(){
        log=new LogTransacciones__c();
        error=false;    
    }
    

    
    public void consultar(){
        
        parametros =ApexPages.currentPage().getParameters();
        idOC = parametros.get('Id');
        vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        
        list<OperacionComercial__c> ocList=new list<OperacionComercial__c>([select id,plan__r.TipodePlan__c,Name,CuentaCliente__c,Activo__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c,Plan__r.LTE_MetodoDePago__c,Plan__r.NombredelProducto__r.Name, APN__c, Tarifa_mensual_Bolsa_de_Moviles__c, Tarifa_mensual_Troncales_SIP__c
        from OperacionComercial__c
        where id=:parametros.get('Id') and
        (Estado__c = 'En Curso' AND TOPP__r.TipodeOperacionporplan__c='Venta' 
         AND ((Plan__r.TipodePlan__c='Troncal SIP' AND NumeroConexion__c != null AND LTE_ICCID__c!=null) 
              OR (Plan__r.NombredelProducto__r.Name=:productoLTE AND APN__c != null))
        )
        ]);
        
        if(ocList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'La Oc no cumple con los criterios para realizar la consulta en M6'));
            error=true;
            return;
        }else{
            if(ocList[0].Tarifa_mensual_Troncales_SIP__c == null || ocList[0].Tarifa_mensual_Troncales_SIP__c < 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Por favor ingrese un valor en el campo: "Tarifa mensual Troncales SIP".'));
                error=true;
            	return;            	
            }else if(ocList[0].Tarifa_mensual_Bolsa_de_Moviles__c == null || ocList[0].Tarifa_mensual_Bolsa_de_Moviles__c < 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Por favor ingrese un valor en el campo: "Tarifa mensual Bolsa de Moviles".'));
                error=true;
            	return;                    
            }else                                   
            	oc=ocList[0];
        }            
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('DisponibilidadM6');
        map<string,string> values=new map<string,string>();
        string request='';
        string response='';
        string serv='';
        
        oc.Portacion__c = true;
        request=LTE_Aprovisionamiento_cls.AvailabilitQueryOrder(oc);
        oc.Portacion__c = false;
        
        response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
        
        tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
        
        values=proReq.getMap(response);
        
        if(values.get('status')=='PASS' && values.get('TIBCOResponseCode')=='01'){
            if(values.get('Number')!=null && values.get('Number')!=''){ 
                oc.NumeroConexion__c=values.get('Number');
            }
            oc.LTE_PIN__c=values.get('PIN');
            oc.LTE_PIN2__c=values.get('PIN2');
            oc.LTE_PUK__c=values.get('PUK');
            oc.LTE_PUK2__c=values.get('PUK2');
            oc.LTE_IMSI__c=values.get('IMSI');
            //JACERO 01082018 Nuevo campo SDP
            oc.SDP__c=values.get('SDP');
            
            oc.Estado__c='Exitoso M6';
            log.Estado__c='Exitoso M6';
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
        
        try{
            if(oc.Estado__c=='Exitoso M6'){
                Map<Id,OperacionComercial__c>ocMap=New Map<Id,OperacionComercial__c>();
                ocMap.put(oc.Id,oc);
                LTE_Aprovisionamiento_cls.obtenerEstructurado(ocMap);
            }
        }catch(exception e){
            oc.Estado__c='Parametrización Fallida';
            log.LTE_Operacion_Comercial__c=oc.id;
            log.Name='Error parametrizacion producto '+oc.Name;
            log.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
        }
        
        update oc;
        insert log;
        
        system.debug('\n=======================================================\n'
                     +'oc.Estado__c = ' + oc.Estado__c + '\n'
                     +'oc.TOPP__r.TipodeOperacionporplan__c = ' + oc.TOPP__r.TipodeOperacionporplan__c + '\n'
                     +'oc.Plan__r.TipodePlan__c = ' + oc.Plan__r.TipodePlan__c + '\n'
                     +'=======================================================\n');
        if(oc.Estado__c == 'Exitoso M6' && oc.TOPP__r.TipodeOperacionporplan__c == 'Venta' && (oc.Plan__r.TipodePlan__c == 'Troncal SIP' || (oc.Plan__r.NombredelProducto__r.Name == productoLTE && oc.APN__c != null))){
            try{
                set<id> setIdOcs = new set<id>();
                setIdOcs.add(oc.Id);
                LTE_Aprovisionamiento_bch batchA = new LTE_Aprovisionamiento_bch();
                batchA.idImediato = setIdOcs;
                ID batchprocessid = Database.executeBatch(batchA, 1);
            }catch(exception e){
                LogTransacciones__c logSIP=new LogTransacciones__c();
                logSIP.LTE_Operacion_Comercial__c=oc.id;
                logSIP.Name='Error enviando a aprovisonamiento '+oc.Name;
                logSIP.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
                insert logSIP;
            }
        }            
    }
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+idOC;        
		PageReference page = new PageReference(url);
		return page;
	}	
}