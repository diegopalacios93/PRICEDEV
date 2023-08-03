global class IntegracionServiciosTramitesCtasFact_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    global set<id>idImediato		= new set<id>();    
    global set<id>idImediatoTramite	= new set<id>();
    global Database.Querylocator start(Database.Batchablecontext bc){   
        String query = 'SELECT Id, Name, Activo__r.Name, Activo__r.Id, Activo__r.CuentaFacturacion__r.Name, Estado__c, Tramite_cuenta_de_facturacion__r.Tramite__c, Tramite_cuenta_de_facturacion__r.Id, '
            		 + 'Tramite_cuenta_de_facturacion__r.Estado__c, Tramite_cuenta_de_facturacion__r.Estado_aprobacion_solicitud__c, Tramite_cuenta_de_facturacion__r.Validacion_plan_de_impuestos__c '
            		 + 'FROM Servicio_del_tramite_cuenta_fact__c '
            		 + 'WHERE Estado__c = \'Pendiente\' AND Tramite_cuenta_de_facturacion__r.Validacion_plan_de_impuestos__c = \'Pendiente\' AND '
            		 + 'Tramite_cuenta_de_facturacion__r.Estado_aprobacion_solicitud__c = \'Pendiente\' AND Tramite_cuenta_de_facturacion__r.Tramite__c = \'Agrupar conceptos de facturación\'';
            		         
        if(!idImediato.isEmpty())
            query+=' AND id IN :idImediato ';   
        
        if(!idImediatoTramite.isEmpty())
            query+=' AND Tramite_cuenta_de_facturacion__r.Id IN :idImediatoTramite ';   
        
        query+=' ORDER BY createdDate DESC';
        
        if(Test.isRunningTest())
            query+=' LIMIT 1';
        
        system.debug('\n Activos de Tramites Cta Fact - ConsultaBatch: '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Servicio_del_tramite_cuenta_fact__c> scope){
       	
        for(Servicio_del_tramite_cuenta_fact__c objTramite : scope){            
            system.debug('\n Activos de Tramites Cta Fact - Envío a integrar el activo: '+objTramite.Activo__r.Name);
            Map<string,string> MapDatosActivo = new Map<string,string>();
            MapDatosActivo.put('IdServicioTramite',objTramite.Id);
            MapDatosActivo.put('ExternalServiceId',objTramite.Activo__r.Name);
            MapDatosActivo.put('IdActivo',objTramite.Activo__r.Id);
            MapDatosActivo.put('CuentaFacturacion',objTramite.Activo__r.CuentaFacturacion__r.Name);            
            MapDatosActivo.put('IdTramite',objTramite.Tramite_cuenta_de_facturacion__r.Id);            
            IntegracionTramitesCuentasFact_cls.integrarRevchainConsultaPlanImpuestos(MapDatosActivo);
        }
    }
    global void finish(Database.BatchableContext bc){
    }
}