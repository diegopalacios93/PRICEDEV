/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 01-06-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
trigger ActivoETB_tgr on ActivoETB__c (before update) {
    if (trigger.isBefore) {
        if (trigger.isUpdate)
        {
            //N-00865-HU Modificación de números Cabecera Para Cobro Revertido Automático -85300
            //Miguel R. Gómez  miguel.rafael.gomez@accenture.com 12-29-2021
            ActivoETBHandler_cls.AlarmaCambioNumeroConexion(Trigger.Old,Trigger.New);
            ActualizarOportunidad_cls.ActualizarOportunidad(trigger.newmap);
            Set <Id> lstACDeclina = new Set <Id>();
            for(ActivoETB__c sglAC:trigger.new){
                if(sglAC.Estado__c=='Inactivo' && sglAC.Estado__c != Trigger.oldMap.get(sglAC.Id).Estado__c && String.isNotBlank(sglAC.APN__c)){
                    lstACDeclina.add( sglAC.Id );
                }
            }
            if(!lstACDeclina.isEmpty())
                ProcesosAPN_cls.OCDesasociaAPN(lstACDeclina, Schema.ActivoETB__c.getSObjectType(), trigger.NewMap);
        }
    }
}