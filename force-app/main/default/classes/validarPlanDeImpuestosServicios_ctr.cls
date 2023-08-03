public class validarPlanDeImpuestosServicios_ctr {
    public  map<string,string>   			mapParameters;
    List<Tramite_cuenta_de_facturacion__c> 	ListTramite	= new List<Tramite_cuenta_de_facturacion__c>();
    public  string   			 			ObjectId;
	public pageReference GenerarIntegracion(){
        String resultValidaciones;
        mapParameters = new map<string,string>(ApexPages.currentPage().getParameters());        
        ObjectId 	  = mapParameters.get('ObjectId');        
        consultarTramite();
        if(ListTramite.size() > 0){
            actualizarEstadosDefault();
            //Invocar Batch de consulta de plan de impuestos
            set<id> idImediatoTramite = new set<id>();
            idImediatoTramite.add(ObjectId);
            IntegracionServiciosTramitesCtasFact_bch facttbtch = new IntegracionServiciosTramitesCtasFact_bch();
            facttbtch.idImediatoTramite = idImediatoTramite;
            ID batchprocessid = Database.executeBatch(facttbtch,1);
            system.debug('==>Id Envío batch IntegracionServiciosTramitesCtasFact_bch:'+batchprocessid);
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,(label.Msj_validacionPlanImpuestosCompatible)));
        }else
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,(label.Msj_validacionPlanImpuestosNoCompatible)));
        
        return null;
    }
    public void consultarTramite(){        
        ListTramite = [SELECT Id From Tramite_cuenta_de_facturacion__c Where Id=:ObjectId
                       AND Tramite__c = 'Agrupar conceptos de facturación' AND Estado__c = 'Pendiente'
                       AND Estado_aprobacion_solicitud__c = 'Pendiente'];                
    }
    public void actualizarEstadosDefault(){
        Integer cantidadServTramite = 0;
        Tramite_cuenta_de_facturacion__c objTramite = ListTramite[0];        
        
        List<Servicio_del_tramite_cuenta_fact__c> ListServicioTramiteUpdate = new List<Servicio_del_tramite_cuenta_fact__c>();
        //actualizar servicios del trámite
        for(Servicio_del_tramite_cuenta_fact__c objTramiteServicio : [Select Estado__c From Servicio_del_tramite_cuenta_fact__c Where Tramite_cuenta_de_facturacion__r.Id =:objTramite.Id]){
            if(objTramiteServicio.Estado__c != 'Facturado'){
            	objTramiteServicio.Estado__c = 'Pendiente';            
            	ListServicioTramiteUpdate.add(objTramiteServicio);
            }
            cantidadServTramite++;
        }
        if(ListServicioTramiteUpdate.size() > 0){
            update ListServicioTramiteUpdate;
            restablecerPlanDeImpuestos(ListServicioTramiteUpdate);
        }
        objTramite.Validacion_plan_de_impuestos__c 		= 'Pendiente';
        objTramite.Cantidad_de_servicios_a_procesar__c 	= cantidadServTramite;
        update objTramite;
    }
    public pageReference Cancelar(){
        PageReference p=null;
        if(ObjectId!=null){
           p = new PageReference('/'+ObjectId);
        }
        return p;
    } 
    private static void restablecerPlanDeImpuestos(List<Servicio_del_tramite_cuenta_fact__c> ListServicioTramiteUpdate){
        List<Plan_de_impuestos_servicio__c> ListPlanImpuestosServ = new List<Plan_de_impuestos_servicio__c>();
        set<Id> setIdServTramite = new set<Id>();
        for(Servicio_del_tramite_cuenta_fact__c objServTramite : ListServicioTramiteUpdate)
            setIdServTramite.add(objServTramite.Id);
        
        ListPlanImpuestosServ = [Select Id From Plan_de_impuestos_servicio__c 
                                 Where Servicio_del_tramite_cuenta_Fact__r.Id IN: setIdServTramite];
        
        if(ListPlanImpuestosServ.size()>0)
            delete ListPlanImpuestosServ;
                 
    }    
}