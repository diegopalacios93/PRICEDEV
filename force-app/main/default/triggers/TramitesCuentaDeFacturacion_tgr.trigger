/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Descripción:            trigger para ejecutar procesos de los trámites relacionados con las cuentas de facturación

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     13-01-2021  Fernando Sarasty (FS)      Creación de trigger
*******************************************************************************/

trigger TramitesCuentaDeFacturacion_tgr on Tramite_cuenta_de_facturacion__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	//  Bloque de ejecución Before
	if (trigger.isBefore) {
        //  Bloque de ejecución Before Insert
        if (trigger.isInsert) {}

        //  Bloque de ejecución Before Update
        if (trigger.isUpdate){}

        //  Bloque de ejecución Before Delete
        if (trigger.isDelete) {}
    }    
    //  Bloque de ejecución After
    if (trigger.isAfter) {
        //  Bloque de ejecución After Insert
        if (trigger.isInsert) {
            List<Approval.ProcessSubmitRequest> requestsList = new List<Approval.ProcessSubmitRequest>();
            for(Id ids:trigger.newMap.keySet()){
                if(trigger.newMap.get(ids).Estado_aprobacion_solicitud__c == 'Pendiente' &&
                   (trigger.newMap.get(ids).Tramite__c == 'Configurar parámetros de facturación')){
                    // invocar proceso de aprobación para modificación de parámetros de la factura de la cuenta.                    
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setObjectId(ids);
                    requestsList.add(approvalRequest);
                       
                    approvalRequest.setComments('envío solicitud de aprobación de ajustes de formato de factura');
                    approvalRequest.setObjectId(trigger.newMap.get(ids).Id);                    
                    system.debug('===> Update Preferencias Cta Fact: Solicitud de aprobacion de modificacion del trámite: '+trigger.newMap.get(ids).Name+' Enviado.');                                                    
                }
            }
            if(requestsList.size()>0)
                Approval.ProcessResult[] processResults = Approval.process(requestsList);            
        }
        //  Bloque de ejecución After Update
        if (trigger.isUpdate) {
            List<Approval.ProcessSubmitRequest> requestsList = new List<Approval.ProcessSubmitRequest>();
            for(Id ids:trigger.newMap.keySet()){
                if(trigger.newMap.get(ids).Tramite__c == 'Agrupar conceptos de facturación' &&
                   trigger.newMap.get(ids).Estado_aprobacion_solicitud__c == 'Pendiente' &&
                   (trigger.newMap.get(ids).Validacion_plan_de_impuestos__c != trigger.oldMap.get(ids).Validacion_plan_de_impuestos__c) &&
                   trigger.newMap.get(ids).Validacion_plan_de_impuestos__c == 'Plan de impuesto de los servicios compatible')
                {
                    // invocar proceso de aprobación para modificación de parámetros de la factura de la cuenta.                    
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setObjectId(ids);
                    requestsList.add(approvalRequest);                           
                    approvalRequest.setComments('envío solicitud de aprobación de consolidación de plan de impuestos');
                    approvalRequest.setObjectId(trigger.newMap.get(ids).Id);                    
                    system.debug('===> Consolidacion Plan de Impuestos: Solicitud de aprobacion del trámite: '+trigger.newMap.get(ids).Name+' Enviado.');
                }
            } 
            if(requestsList.size()>0)
                Approval.ProcessResult[] processResults = Approval.process(requestsList);            
        }
        
        //  Bloque de ejecución After Delete
        if (trigger.isDelete) {}

        //  Bloque de ejecución After Undelete
        if (trigger.isUndelete) {}
    }
}