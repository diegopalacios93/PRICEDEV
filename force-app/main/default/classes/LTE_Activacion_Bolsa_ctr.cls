public with sharing class LTE_Activacion_Bolsa_ctr {
    map<string,string> parametros =new map<string,string>();
    public OperacionComercial__c oc{get;set;}
    public LogTransacciones__c log{get;set;}
    public boolean error{get;set;}
    Map<string,VariablesGlobales__c> vGlobal;
    
    public LTE_Activacion_Bolsa_ctr(){
        log=new LogTransacciones__c();
        error=false;    
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(parametros.get('Id')!=null){
           p = new PageReference('/'+parametros.get('Id'));
        }
        return p;
    }
    
    public void consultar(){          
        parametros =ApexPages.currentPage().getParameters();        
        vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        
        list<OperacionComercial__c> ocList=new list<OperacionComercial__c>([select id,plan__r.TipodePlan__c,Name,CuentaCliente__c,Activo__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c,Plan__r.LTE_MetodoDePago__c,Plan__r.NombredelProducto__r.Name, APN__c, Tarifa_mensual_Bolsa_de_Moviles__c, Tarifa_mensual_Troncales_SIP__c
        FROM OperacionComercial__c
        WHERE id=:parametros.get('Id') and
        (Estado__c = 'Pendiente Activacion Bolsa' AND TOPP__r.TipodeOperacionporplan__c='Venta' AND
         Plan__r.TipodePlan__c= 'Troncal SIP') AND
		 Legalizacion__r.Estado__c= 'Gestionado']);
        
        if(ocList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'La OC no cumple con los criterios para realizar la activación de la bolsa de Troncal SIP.'));
            error=true;
            return;
        }else{
            if(ocList[0].NumeroConexion__c == null || ocList[0].NumeroConexion__c == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Por favor ingrese el número de conexión.'));
                error=true;
            	return;            	                               
            }else                                   
            	oc=ocList[0];
        }          
		//actualizar estado de la OC, para que pueda ser procesado por el batch de aprovisionamiento.         
		if(!Test.isRunningTest()){
        	oc.Estado__c='Exitoso M6';
        	update oc;
        }
            
        // Generación de integración
        try{
            set<id> setIdOcs = new set<id>();
            setIdOcs.add(oc.Id);
            LTE_Aprovisionamiento_bch batchA = new LTE_Aprovisionamiento_bch();
            batchA.idImediato = setIdOcs;
            ID batchprocessid = Database.executeBatch(batchA, 1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Proceso de aprovisionamiento enviado, por favor validar la actualización de la operación comercial.'));            
            error=false;
            return;
        }catch(exception e){
            LogTransacciones__c logSIP=new LogTransacciones__c();
            logSIP.LTE_Operacion_Comercial__c=oc.id;
            logSIP.Name='Error ejecutando batch de aprovisionamiento '+oc.Name;
            logSIP.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
            insert logSIP;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error ejecutando batch de aprovisionamiento '+e.getMessage()));            
            error=false;
            return;
        }        
    }
}