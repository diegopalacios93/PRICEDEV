global class IntegracionTramitesCuentasFact_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    global set<id>idImediato=new set<id>();
    
    global Database.Querylocator start(Database.Batchablecontext bc){   
        String query = 'SELECT Id, Name, Estado__c, Estado_aprobacion_solicitud__c, Tramite__c 	From Tramite_cuenta_de_facturacion__c '
            		 + 'WHERE Estado__c = \'Pendiente\' AND '
            		 + '(Estado_aprobacion_solicitud__c =  \'Solicitud aprobada\' AND ' 
            		 + '(Tramite__c = \'Configurar parámetros de facturación\' OR Tramite__c = \'Agrupar conceptos de facturación\'))';
            		 
        
        if(!idImediato.isEmpty())
            query+=' AND id IN :idImediato ';   
        
        query+=' ORDER BY createdDate DESC ';
        
        system.debug('\n Tramites Cta Fact - ConsultaBatch: '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Tramite_cuenta_de_facturacion__c> scope){       	
        for(Tramite_cuenta_de_facturacion__c objTramite : scope){            
            system.debug('\n Tramites Cta Fact - Envío a integrar el trámite: '+objTramite.Name);
            if(objTramite.Tramite__c == 'Configurar parámetros de facturación')                
                IntegracionTramitesCuentasFact_cls.integrarRevchainPreferenciasFacturacion(objTramite.Id);
            
            if(objTramite.Tramite__c == 'Agrupar conceptos de facturación')                
                IntegracionTramitesCuentasFact_cls.integrarRevchainConsolidarConceptosFact(objTramite.Id);            
        }
    }
    global void finish(Database.BatchableContext bc){      
        IntegracionTramitesCuentasFact_sch.ProgramarJob();
    }
}