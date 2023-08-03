trigger ContentDocument_tgr on ContentDocument (before update) {
/*    Map<String,Object> mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Acceso_Funcionalidad__mdt','');
    Boolean blnPermiteCrearNota = PS_IntegracionSalidaGestor_cls.validarUsuarioLV(userinfo.getUserId(),(List<Map<String,String>>)mpListaValores.get('PER_EDITARNOTA_CASO'),'Valor_API__c');
    List<ContentDocumentLink> lstContentDoc = [SELECT ContentDocumentId,LinkedEntity.Type FROM ContentDocumentLink WHERE ContentDocumentId = :Trigger.newMap.keyset()];
    for(ContentDocumentLink sglContentDoc:lstContentDoc){
        if(sglContentDoc.LinkedEntity.Type=='Case'){
            if(!blnPermiteCrearNota){
                trigger.newMap.get(sglContentDoc.ContentDocumentId).addError(' No posee permisos para editar la nota, por favor cree otra.');
            }
        }
    }*/
    system.debug('ContentDocument');
}