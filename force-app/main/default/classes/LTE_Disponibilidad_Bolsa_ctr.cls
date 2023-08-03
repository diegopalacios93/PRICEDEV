public with sharing class LTE_Disponibilidad_Bolsa_ctr {
    
    public map<string,string> parametros =new map<string,string>();
    public OperacionComercial__c oc{get;set;}
    public LogTransacciones__c log{get;set;}
    public boolean error{get;set;}    
    public Integer total{get;set;}
    Map<string,VariablesGlobales__c> vGlobal;
      
    public LTE_Disponibilidad_Bolsa_ctr(){
        log=new LogTransacciones__c();
        error=false;    
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        parametros =ApexPages.currentPage().getParameters();
        if(parametros.get('Id')!=null){
           p = new PageReference('/'+parametros.get('Id'));
        }
        return p;
    }
    
    public void consultar(){   
        parametros =ApexPages.currentPage().getParameters();        
        list<OperacionComercial__c> ocList=new list<OperacionComercial__c>([select id,plan__r.TipodePlan__c,Name,CuentaCliente__c,Activo__c,Activo__r.Id, Activo__r.LTE_ICCID__c, LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c,Plan__r.LTE_MetodoDePago__c,Plan__r.NombredelProducto__r.Name, APN__c, Tarifa_mensual_Bolsa_de_Moviles__c, Tarifa_mensual_Troncales_SIP__c
        FROM OperacionComercial__c
        WHERE id=:parametros.get('Id') and
        (Estado__c = 'En Curso' AND TOPP__r.TipodeOperacionporplan__c='Venta' AND
         Plan__r.TipodePlan__c= 'Troncal SIP') AND
		 Legalizacion__r.Estado__c= 'Gestionado']);
        
        if(ocList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'La OC no cumple con los criterios para realizar disponibilidad de la bolsa de Troncal SIP.'));
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
        try{
            total = Integer.valueOf(VariablesGlobales__c.getValues('aprovisionamientoOnline').Valor__c);
            if(!Test.isRunningTest()){
            	oc.LTE_AplicaOnline__c = true;
            	update oc;
            }
            set<id> setIdOcs = new set<id>();
            setIdOcs.add(oc.Id);
            LTE_AvailabilitQueryOrder_bch batchA = new LTE_AvailabilitQueryOrder_bch();
            batchA.idImediato = setIdOcs;
            batchA.limitQ = true;
			batchA.limiteTotal=total;
			batchA.esVIP=true;
            if(!Test.isRunningTest())
            	ID batchprocessid = Database.executeBatch(batchA, 1);
                
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Proceso de disponibilidad enviado, por favor validar la actualización de la operación comercial.'));            
            error=false;
            return;
      	}catch(exception e){
            LogTransacciones__c logSIP=new LogTransacciones__c();
            logSIP.LTE_Operacion_Comercial__c=oc.id;
            logSIP.Name='Error ejecutando batch de disponibilidad '+oc.Name;
            logSIP.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
            insert logSIP;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error ejecutando batch de disponibilidad '+e.getMessage()));            
            error=false;
            return;
    	}     
    }
}