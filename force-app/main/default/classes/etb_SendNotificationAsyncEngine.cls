global with sharing class etb_SendNotificationAsyncEngine implements vlocity_cmt.VlocityOpenInterface2 {
    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        try {
            switch on methodName {
                when 'sendNotificationSalesOrder' {
                    sendNotificationSalesOrder(inputMap);
                }
                when 'sendNotificationLegalization'{
                    sendNotificationLegalization(inputMap);
                }
            }
            return outputMap;
        }
        catch(Exception e) {
            outputMap.put('failed', true);
            outputMap.put('statusCode', 400);
            outputMap.put('statusMessage', 'Ocurrió un error inesperado. StackTrace: ' + e.getStackTraceString() + '.');
            outputMap.put('technicalMessage', e.getMessage());
            return outputMap;
        }
    }
    
    private void sendNotificationSalesOrder(Map<String, Object> inputMap){
        Map<String,Object> additionalData = (Map<String,Object>)inputMap.get('additionalData');
        Set<String> recipientsIds = new Set<String>();
        String contractId = String.valueOf(additionalData.get('ContractId'));
        String userId = String.valueOf(additionalData.get('UserId'));
        String tittle = String.valueOf(additionalData.get('TittleMsg'));
        String body = String.valueOf(additionalData.get('BodyMsg'));
        String customNotificationName = String.valueOf(additionalData.get('CustomNotificationName'));
        recipientsIds.add(userId);
        etb_SendNotificationAsyncEngine.sendNotification(recipientsIds, contractId, tittle, body, customNotificationName);
    }
    
    private void sendNotificationLegalization(Map<String, Object> inputMap){
        Map<String, Object> mapItemsProcessed = (Map<String, Object>) inputMap.get('itemsProcessed');
        List<Object> listaFailedProcessedItems = (List<Object>) mapItemsProcessed.get('failed');


        Map<String,Object> additionalData = (Map<String,Object>)inputMap.get('additionalData');
        Set<String> recipientsIds = new Set<String>();
        String body ;
        String legalizationId = String.valueOf(additionalData.get('legalizationId'));
        String userId = String.valueOf(additionalData.get('UserId'));
        String tittle = String.valueOf(additionalData.get('TittleMsg'));
        if(listaFailedProcessedItems.size()==0){
          body = String.valueOf(additionalData.get('BodyMsg'));  
        }else{
          body = String.valueOf(additionalData.get('BodyFailMsg'));  
        }
        
        String customNotificationName = String.valueOf(additionalData.get('CustomNotificationName'));
        recipientsIds.add(userId);
        etb_SendNotificationAsyncEngine.sendNotification(recipientsIds, legalizationId, tittle, body, customNotificationName);
    }
    
    
    public static void sendNotification (Set<String> recipientsIds, String targetId, String tittle, String body, String customNotificationName){
        Boolean response = false;
        CustomNotificationType notificationType = [SELECT Id, DeveloperName 
                                                   FROM CustomNotificationType 
                                                   WHERE DeveloperName =: customNotificationName];
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(tittle);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        try {
            if(recipientsIds!=null && targetId != null ){
                notification.send(recipientsIds);
                System.debug('La notificación fue enviada exitosamente.');
            }
        }
        catch (Exception e) {
            System.debug('Problema al enviar notificación: ' + e.getMessage());
        }
    }

}