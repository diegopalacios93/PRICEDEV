/*******************************************************************************
Develope by:            ETB
Author:                 Javier Acero
Project:                ETB-LTE   
Description:            Contiene la logica para el controlador de la liberación de recursos
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     01/08/2018  Javier Acero.                  Class creation.
*******************************************************************************/
public class LTE_Release_Resources_ctr {

    map<string,string> parametros =new map<string,string>();
    public OperacionComercial__c oc{get;set;}
    //public OperacionComercial__c oc2{get;set;}
    public LogTransacciones__c log{get;set;}
    public boolean error{get;set;}
    Map<string,VariablesGlobales__c> vGlobal;
    public string resultadoTransaccion{get;set;}
    
    public LTE_Release_Resources_ctr(){
        log = new LogTransacciones__c();
        error = false;    
    }
    

    
    public void consultar(){
        
        parametros =ApexPages.currentPage().getParameters();
        
        vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;        
                
        list<OperacionComercial__c> ocList= new list<OperacionComercial__c>([select id,plan__r.TipodePlan__c,Name,CuentaCliente__c,Activo__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c,Plan__r.LTE_MetodoDePago__c,Plan__r.NombredelProducto__r.Name, APN__c, Tarifa_mensual_Bolsa_de_Moviles__c, Tarifa_mensual_Troncales_SIP__c, Estado__c, LTE_IMSI__c
        from OperacionComercial__c
        where id=:parametros.get('Id') and
        ((Estado__c = 'Exitoso M6' OR Estado__c = 'Pendiente Activacion Bolsa')
         AND ((Plan__r.TipodePlan__c='Troncal SIP' AND NumeroConexion__c != null AND LTE_ICCID__c!=null) 
              OR (Plan__r.NombredelProducto__r.Name=:productoLTE AND APN__c != null))
        )
        ]);
        
        if(ocList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'La OC no cumple con los criterios para realizar la liberación de recursos.'));
            this.resultadoTransaccion = 'La OC no cumple con los criterios para realizar la liberación de recursos.';
            error=true;
            return;
        }else{
			oc=ocList[0];
        }
        system.debug('oc: ' + oc); 
        system.debug('oc.Estado__c1********: ' + oc.Estado__c);
        log.Name='Liberación de recursos '+ oc.Name;
        log.LTE_Operacion_Comercial__c = oc.id;
        
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('LTE_Release_Resources');
        map<string,string> values=new map<string,string>();
        string request='';
        string response='';
        string serv='';
        
        request = LTE_Release_Resources_cls.ReleaseResourcesOrder(oc);
 		log.Informacion_Enviada__c = request; 
        response = LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
        tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
        log.Informacion_Recibida__c= response;
        insert log;
        values=proReq.getMap(response);
        system.debug('values******: ' + values);      

        if(values.get('status')=='PASS'){
			if(values.get('Result')=='KO' || values.get('Result') == null){
	            log.Estado__c='Fallido';
                update log;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No fué posible realizar la Liberación.'));
                this.resultadoTransaccion = 'No fué posible realizar la Liberación. Revisar el LogTransaccion de Liberación de recursos.';
                error=true;
               // return;   
            }else{
               oc.Estado__c='Pendiente';
               log.Estado__c='Exitoso'; 
               update log;
               update oc;
               this.resultadoTransaccion = 'Liberación Exitosa';
            }
        }else{
            log.Estado__c='Fallido'; 
            update log;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error técnico al consumir el servicio. Por favor valide que el servicio de liberación se encuentra disponible.'));
            this.resultadoTransaccion = 'Error técnico al consumir el servicio, por favor valide que el servicio de liberación se encuentra disponible. Revisar el LogTransaccion de Liberación de recursos.';
            error=true;
            return;
        }

/*
        if(values.get('TIBCOResponseDescription')!=null){
            system.debug('TIBCOResponseDescription******');
            log.CodigoRespuesta__c=values.get('TIBCOResponseDescription').abbreviate(250);
        }
        
        list<OperacionComercial__c> ocList2= new list<OperacionComercial__c>([select id,plan__r.TipodePlan__c,Name,CuentaCliente__c,Activo__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c,plan__c,LTE_TipoTransaccion__c,Plan__r.LTE_MetodoDePago__c,Plan__r.NombredelProducto__r.Name, APN__c, Tarifa_mensual_Bolsa_de_Moviles__c, Tarifa_mensual_Troncales_SIP__c, Estado__c, LTE_IMSI__c
        from OperacionComercial__c
        where id=:parametros.get('Id') ]);
        oc=ocList2[0];
        system.debug('oc.Estado__c2********: ' + oc.Estado__c);
        try{
            if(oc.Estado__c=='Pendiente'){
                Map<Id,OperacionComercial__c>ocMap = New Map<Id,OperacionComercial__c>();
                ocMap.put(oc.Id,oc);
                LTE_Aprovisionamiento_cls.obtenerEstructurado(ocMap);
            }
        }catch(exception e){
            
            oc.Estado__c='Parametrización Fallida';
            log.Estado__c='Parametrización Fallida'; 
            log.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
            update log;
            update oc;
        }
        //update oc;
*/
        
        system.debug('\n=======================================================\n'
                     +'oc.Estado__c = ' + oc.Estado__c + '\n'
                     +'oc.TOPP__r.TipodeOperacionporplan__c = ' + oc.TOPP__r.TipodeOperacionporplan__c + '\n'
                     +'oc.Plan__r.TipodePlan__c = ' + oc.Plan__r.TipodePlan__c + '\n'
                     +'=======================================================\n');
    }
    
    public PageReference regresar() {
         
        Pagereference pg =  new Pagereference('https://'+ System.URL.getSalesforceBaseURL().getHost() + '/' + ApexPages.currentPage().getParameters().get('id'));
       // Pagereference pg =  new Pagereference('https://cs20.salesforce.com/' + ApexPages.currentPage().getParameters().get('id')); 
        System.debug('pg: ' + pg);
        pg.setRedirect(true);
		return pg;
   }
    
   public String getResultadoOperacion() {
       string mensaje;
       mensaje = this.resultadoTransaccion;
       return mensaje; 
    }
    
}