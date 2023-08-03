trigger legalizacion_tgr on Legalizacion__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
	Legalizacion_cls legClass = new Legalizacion_cls();
	LTE_EnviarInfoFactEquipos_cls legClassLte= new LTE_EnviarInfoFactEquipos_cls();
    

    
    	if (trigger.isBefore) {
        //  Bloque de ejecuci?n Before Insert
        if (trigger.isInsert) {
            
        }

        //  Bloque de ejecuci?n Before Update
        if (trigger.isUpdate){
        	//ejecutar las validaciones solo si el usuario no esta dentro de las excepciones.
        	if(!legClass.ValidacionPerfil(UserInfo.getProfileId()))
        	{
        		legClass.ValidacionOperacionComercial(trigger.newMap,trigger.oldMap);
        		legClass.ValidacionNegociacionCerrada(trigger.newMap,trigger.oldMap);
        	}
			//legClass.relacionarSDWANconEnlaces(trigger.newMap,trigger.oldMap);
            //legClass.relacionarServiciosOffice365(trigger.newMap,trigger.oldMap);
            //legClass.actualizarEstadoOCsDemos(trigger.newMap,trigger.oldMap);
            legClass.procesosLegalizacionOCs(trigger.newMap,trigger.oldMap);
        }

        //  Bloque de ejecuci?n Before Delete
        if (trigger.isDelete) {

        }

    }
    
    //  Bloque de ejecuci?n After
    if (trigger.isAfter) {

        //  Bloque de ejecuci?n After Insert
        if (trigger.isInsert) {

        }

        //  Bloque de ejecuci?n After Update
        system.debug(BanderasEjecucion.ValidarEjecucion('DesenCadenaLegalizacion'));
        if (trigger.isUpdate && !BanderasEjecucion.ValidarEjecucion('DesenCadenaLegalizacion')) {
            
            BanderasEjecucion.setEjecucion('DesenCadenaLegalizacion');
            system.debug(BanderasEjecucion.ValidarEjecucion('DesenCadenaLegalizacion'));
            legClass.identificarCambiosLeg(trigger.newMap,trigger.oldMap);
            //legClass.ActualizarOperacionesComerciales(trigger.newMap,trigger.oldMap);
        	
            // Enviar informacion de facturacion de Equipos para el Formateador
            legClassLte.enviarInfoFactEquipos(trigger.new,trigger.oldMap); // lrpa LTE-FASE1
            
            // Activar las OC de venta de eequipos, cuando la legalizacion pasa a estado Gestioando
        	legClass.ActualizarOperacionComercialVentaEquipos(trigger.newMap,trigger.oldMap); // lrpa LTE-FASE1
        	
        	//Metodo que se encarga de declinar todas las operaciones comerciales de una legalizacion que se declina.
        	// Carlos A. Rodriguez B. [CR] 25/08/2015
        	BanderasEjecucion.setEjecucion('DesenCadenaLegalizacion');
        	legClass.declinarLegalizacion(trigger.old, trigger.new);
            
            set<Id> idLegs = new set<id>();
            list<OperacionComercial__c> listOC = new list<OperacionComercial__c>();
            Map<Id,Contract> mpContract = new Map<Id,Contract>();
            for(Id idLeg :trigger.newMap.keySet())
            {
                if(trigger.newMap.get(idLeg).Estado__c!=null && trigger.newMap.get(idLeg).Estado__c=='Gestionado' && trigger.oldMap.get(idLeg).Estado__c!='Gestionado')
                {
                    idLegs.add(idLeg);
                }
            }
            if(!idLegs.isEmpty())
                listOC = [select id,Plan__r.Notificacion_Contrato__c,Legalizacion__c,Legalizacion__r.Contrato__c,TOPP__r.TipodeOperacionporplan__c from OperacionComercial__c where Legalizacion__c in :idLegs];
            for(OperacionComercial__c OC :listOC)
            {
                if(OC.Plan__r.Notificacion_Contrato__c == true && OC.TOPP__r.TipodeOperacionporplan__c == 'Venta' && OC.Legalizacion__r.Contrato__c != null){
                    if(!mpContract.containskey(OC.Legalizacion__r.Contrato__c)){
                        mpContract.put(OC.Legalizacion__r.Contrato__c, new Contract(Id = OC.Legalizacion__r.Contrato__c, Notificacion_Cierre__c = 'Larga Distancia'));
                    }
                }
            }
            if(!mpContract.isEmpty())
                update mpContract.values();
        }

        //  Bloque de ejecuci?n After Delete
        if (trigger.isDelete) {
            
        }

        //  Bloque de ejecuci?n After Undelete
        if (trigger.isUndelete) {

        }

    }

}