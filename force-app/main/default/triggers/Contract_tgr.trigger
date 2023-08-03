/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 03-04-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
trigger Contract_tgr on Contract (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {    
    string idContrato;

    ActualizarTipoFacturacionVariable_cls cls = new ActualizarTipoFacturacionVariable_cls(); //SAO
    contratos_cls contratos=new contratos_cls(); 
    if (trigger.isBefore) {        
        //  Bloque de ejecucion Before Insert
        if (trigger.isInsert || trigger.isUpdate) {			
            for ( Contract tmp : trigger.new){
                Integer meses = 0;
                Integer dias  = 0;
                
                if(trigger.isInsert){
                    if(tmp.Repositoriodocumentoscontrato__c != null ){
                        tmp.Fecharepositoriodocumentoscontrato__c = system.now();
                    }
                }else if(trigger.isUpdate){
                    if(tmp.Repositoriodocumentoscontrato__c != null && tmp.Repositoriodocumentoscontrato__c != Trigger.oldMap.get(tmp.Id).Repositoriodocumentoscontrato__c){
                        tmp.Fecharepositoriodocumentoscontrato__c = system.now();
                    }
                }
                if( tmp.ContractTerm == 0 ) tmp.ContractTerm = null;
                if( tmp.StartDate != null ){
                    if( tmp.ContractTerm != null )
                        meses = Integer.valueOf(tmp.ContractTerm);
                    if( tmp.Duracion__c != null )
                        dias  = Integer.valueOf(tmp.Duracion__c);
                    
                    tmp.EndDate = (tmp.StartDate.addMonths(meses)).addDays(dias);
                }
                if(Schema.SObjectType.Contract.getRecordTypeInfosById().get(tmp.recordtypeid).getname() == 'Anexo Colaborador')
              		contratos.procesarContratoColaborador(tmp,trigger.isInsert);    
                               
            }
            ////-SAO- Si los contratos  tienen facturacion especial actualizar el tipo facturacion de las OCs
            //Usuario desconoce la funcionalidad y se pide retirar ya que afecta la integracion del 
            //producto Herramientas y Monitoreo
/*
            List<Contract> lstContratos = new List<Contract>();
            for(Integer i=0; i<trigger.new.size(); i++){
                if(trigger.new[i].Forma_de_Pago__c == 'Si')
                        lstContratos.add(trigger.new[i]);
            }
            if(!lstContratos.isEmpty()){
                cls.ActualizarTipoFacturacionVariable(lstContratos);               
            }
*/      system.Debug('Pasó before');
       	}            
        //  Bloque de ejecucion Before Delete
        if (trigger.isDelete) {
        }        
    }
    
    //  Bloque de ejecucion After
    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate) {
            for ( Contract tmp : trigger.new){                
            }
        }
        //  Bloque de ejecuci?n After Insert
        if (trigger.isInsert) {
            contratos.validarCambios(trigger.oldMap,trigger.newMap );
            // contratos.ActualizarVigenciaActivo(trigger.newMap, trigger.oldMap );
        }
        //  Bloque de ejecuci?n After Update
        if (trigger.isUpdate) {
            contratos.validarCambios(trigger.oldMap,trigger.newMap );
            system.Debug('antes de ActualizarVigenciaActivo');
            contratos.ActualizarVigenciaActivo(trigger.newMap, trigger.oldMap );
            system.Debug('despues de ActualizarVigenciaActivo');
        }
        //  Bloque de ejecuci?n After Delete
        if (trigger.isDelete) {
            
        }
        //  Bloque de ejecuci?n After Undelete
        if (trigger.isUndelete) {

        }
    }
}