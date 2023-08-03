/**
* @author LabsXD.Com Gustavo Torres <gtorres@labsxd.com>
* @date 2022
*
* @group Utilities
*
* @description Clase de proposito general para el procesamiento de funcionalidades
* relacionadas a componentes Vlocity
*/
global without sharing class etb_Utilities implements vlocity_cmt.VlocityOpenInterface2 {
    //Method Names
    @TestVisible
    private static final String METHOD_GET_FIELD_LABEL          = 'getFieldLabel';
    @TestVisible
    private static final String METHOD_FILTER_PRODUCT           = 'filterProduct';
    @TestVisible
    private static final String METHOD_GET_PICKLIST_VALUE       = 'getPicklistValue';
    //Nuevo metodo
    @TestVisible
    private static final String METHOD_SLICE_JSON_LIST       	= 'sliceJSONList';
    @TestVisible
    private static final String METHOD_ITEMID_JSON_LIST       	= 'getItemsId';
 	@TestVisible
    private static final String METHOD_CONVERT_LEAD_TO_CLIENT   = 'convertLeadToClient';
    @TestVisible
    private static final String METHOD_RELIES_ON_ORD_ITEMS   	= 'reliesOnOrderItemsUpdate';
    @TestVisible
    private static final String METHOD_SEND_NOTIFICATION_BY_ASYNC_PROCESS   = 'sendNotificationByAsyncProcess';
    @TestVisible
    private static final String METHOD_GET_ORIGINAL_TOTAL_PRICE   = 'getOriginalTotalPrice';
    @TestVisible
    private static final String METHOD_TRANSFORM_JSON   = 'transformJson';
    
    //Input Parameters
    @TestVisible
    private static String INPUT_FIELD_NAME                      = 'fieldName';
    @TestVisible
    private static String INPUT_SOBJECT_NAME                    = 'objectName';
    @TestVisible
    private static String INPUT_FIELD_VALUE_ID                  = 'fieldValueID';
    @TestVisible
    private static String INPUT_PRODUCT2_ID                     = 'product2ID';
    @TestVisible
    private static String INPUT_PRODUCTS                        = 'products';
    @TestVisible
    private static String INPUT_ARGUMENTS                       = 'arguments';
    //Nuevo parametro
    @TestVisible
    private static String INPUT_JSON							= 'HistoryList';
    @TestVisible
    private static String INPUT_LEAD_ID                       	= 'LeadId';
    @TestVisible
    private static String INPUT_ACCOUNT_ID                       	= 'AccountId';
    @TestVisible
    private static String INPUT_CONTACT_ID                       	= 'ContactId';
    /**************************************************************************************************************************************
    * @description Metodo invocado desde el componente Vlocity para dar acceso a la funcionalidad requerida
    * @param methodName Nombre del metodo que se requiere invocar
    * @param inputMap Map<String, Object> estructura que almacena parametros de entrada pasados como argumentos desde el componente Vlocity
    * @param outMap Map<String, Object> estructura que almacena parametros de salida enviados como respuesta desde el metodo hacia el componente Vlocity
    * @param options Map<String, Object> estructura que almacena parametros adicionales de entrada pasados como argumentos desde el componente Vlocity
    * @return respuesta enviada por el metodo invocado, responde con el valor indicado por el programador
    * @example
    * ImeiUtil util = new ImeiUtil();
	* Map<String, Object> inputMap = new Map<String, Object>();
	* Map<String, Object> outMap = new Map<String, Object>();
	* Map<String, Object> options = new Map<String, Object>();
	* String lsIMEI = '50809025150138';
	* String lsDigito;
	* inputMap.put('IMEI',lsIMEI);
	* Boolean lbUtil;
	* lbUtil = util.InvokeMethod('ValidateImei',inputMap,outMap,options);
	* lsDigito = (String)outMap.get('Digit');
	* System.debug('Este es el resultado => ' + lsDigito);
    */
    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            if (METHOD_GET_FIELD_LABEL.equalsIgnoreCase(methodName)) {
                List<Object> arguments = (List<Object>)inputMap.get('arguments');
            	outMap.put('result', getFieldLabel(arguments));
                return true;
            } else if (METHOD_FILTER_PRODUCT.equalsIgnoreCase(methodName)) {
                return filterProduct(inputMap, outMap, options);
            } else if (METHOD_GET_PICKLIST_VALUE.equalsIgnoreCase(methodName)) {
                return getPicklistValue(inputMap, outMap, options);
            } else if (METHOD_SLICE_JSON_LIST.equalsIgnoreCase(methodName)) {
                return sliceJSONList(inputMap, outMap, options);
            }else if (METHOD_ITEMID_JSON_LIST.equalsIgnoreCase(methodName)) {
                return getItemsId(inputMap, outMap, options);
            }else if (METHOD_CONVERT_LEAD_TO_CLIENT.equalsIgnoreCase(methodName)) {
                return convertLeadToClient(inputMap, outMap, options);
            }else if (METHOD_RELIES_ON_ORD_ITEMS.equalsIgnoreCase(methodName)) {
                return reliesOnOrderItemsUpdate(inputMap, outMap, options);
           }//else if (METHOD_SEND_NOTIFICATION_BY_ASYNC_PROCESS.equalsIgnoreCase(methodName)) {
                //return sendNotificationByAsyncProcess(inputMap, outMap, options);
            //}
        	else if (METHOD_GET_ORIGINAL_TOTAL_PRICE.equalsIgnoreCase(methodName)) {
                List<Object> arguments = (List<Object>)inputMap.get('arguments');
            	outMap.put('result', getOriginalTotalPrice(arguments));
                return true;
            }else if (METHOD_TRANSFORM_JSON.equalsIgnoreCase(methodName)) {
                List<Object> arguments = (List<Object>)inputMap.get('arguments');
            	outMap.put('result', transformJson(arguments));
                return true;
            }
            else {
                return false;
            }
        }
        catch(Exception e) {
            outMap.put('failed', true);
            outMap.put('statusCode', 400);
            outMap.put('statusMessage', 'Ocurrió un error inesperado. StackTrace: ' + e.getStackTraceString() + '.');
            outMap.put('technicalMessage', e.getMessage());
            return outMap;
        }
    }
    
    private Boolean sliceJSONList(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Entrada: '+JSON.serialize(inputMap));
        List < Object > history = (List < Object >) inputMap.get(INPUT_JSON);
        List < Object > newList = new List < Object >();
        Integer listSize = history.size();
        if(listSize <= 10){
            return false;
        }
        for(Integer i=0; i<10; i++){
            newList.add(history[i]);
        }
        outMap.put('HistoryList',newList);
        System.debug('Salida: '+JSON.serialize(outMap));

		return true;
    }

	/**************************************************************************************************************************************
    * @description Metodo invocado desde un dataraptor Vlocity utilizado para obtener los textos de las etiquetas de un campo picklist
    * @param List<Object> arguments 
    * @example
    * Map<String, Object> input = new Map<String, Object>();
    * Map<String, Object> output = new Map<String, Object>();
    * Map<String, Object> options = new Map<String, Object>();
	* input.put(INPUT_OBJECT_NAME, 'UserUnknown');
    * input.put(INPUT_FIELD_NAME, 'Countrycode');
    * input.put(INPUT_FIELD_VALUE_ID, 'Ar');
    * Object result = new etb_Utilities().invokeMethod('getFieldLabel', input, output, options);
    */
    private String getFieldLabel(List<Object> arguments) {
        System.debug('input: '+arguments);
        String fieldLabel = '';
        String objectName = String.valueOf(arguments[0]);
        String fieldName = String.valueOf(arguments[1]);
        String fieldValueID = String.valueOf(arguments[2]);
        System.debug('fieldValueID: '+fieldValueID);
        String[] values = new String[]{};
        String[] types = new String[]{objectName};
            
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        
        for(Schema.DescribeSobjectResult res : results) {
        
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                
                if (entry.isActive() && entry.getValue().equalsIgnoreCase(fieldValueID)) {
                    fieldLabel = entry.getLabel();
                    break;
                }
            }
        }
        System.debug('output: '+fieldLabel);        
        return fieldLabel;
    }

    private Boolean filterProduct(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        String product2id = String.valueOf(inputMap.get(INPUT_PRODUCT2_ID));
        List < Object > productos = (List < Object >) inputMap.get(INPUT_PRODUCTS);

        for (Integer i = (productos.size()-1) ; i>= 0 ; i--){
            Map<String, Object> prod = (Map<String, Object>) productos[i];
            String product2IdItem = String.valueOf(prod.get('Product2Id'));
            if (product2id.equalsIgnoreCase(product2IdItem)){
                productos.remove(i);
                break;
            }
        }

        outMap.put('products',productos);
        return true;
    }

    private Boolean getPicklistValue(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            List<Object> arguments = (List<Object>) inputMap.get(INPUT_ARGUMENTS);
            System.debug('Args: ' + arguments);
            String sObjectName = (String) arguments[0];
            System.debug('sObjectName: ' + sObjectName);
            String field = (String) arguments[1];
            System.debug('field: ' + field);
            String recordId = (String) arguments[2];
            System.debug('recordId: ' + recordId);
            String picklistValue = '';

            switch on sObjectName {
                when 'Account' {
                    switch on field {
                        when 'vlocity_cmt__Status__c' {
                            picklistValue = String.valueOf([SELECT toLabel(vlocity_cmt__Status__c) FROM Account WHERE Id = :recordId][0].vlocity_cmt__Status__c);
                        }
                    }
                }
                when 'Order' {
                    switch on field {
                        when 'Status' {
                            picklistValue = String.valueOf([SELECT toLabel(Status) FROM Order WHERE Id = :recordId][0].Status);
                        }
                        when 'Substatus__c' {
                            //picklistValue = String.valueOf([SELECT toLabel(Substatus__c) FROM Order WHERE Id = :recordId][0].Substatus__c);
                        }
                        when 'Type' {
                            picklistValue = String.valueOf([SELECT toLabel(Type) FROM Order WHERE Id = :recordId][0].Type);
                        }
                    }
                }
                when 'Case' {
                    switch on field {
                        when 'Status' {
                            picklistValue = String.valueOf([SELECT toLabel(Status) FROM Case WHERE Id = :recordId][0].Status);
                        }
                    }
                }
            }

            outMap.put('result', picklistValue);
            return true;
        }
        catch (Exception e) {
            System.debug('Message: ' + e.getMessage());
            System.debug('LineNumber: ' + e.getLineNumber());
            System.debug('Stack Trace: ' + e.getStackTraceString());
            return false;
        }
    }

    private Boolean getItemsId(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
        String orderItems= ''; 
        System.debug(LoggingLevel.DEBUG, 'input '+ JSON.serializePretty(inputMap));
        Map<String,Object>  getcartitem = ( Map<String,Object> ) inputMap.get('GetCartsItem');
        System.debug('List object 1 '+ getcartitem);

        List < Object > Items = (List < Object >) getcartitem.get('records');
        System.debug('List object 2 '+ Items);
        
        for (Integer i = (Items.size()-1) ; i>= 0 ; i--){
            Map<String, Object> idItems = (Map<String, Object>) Items[i];
            System.debug('IdItems ' + idItems);
            Map<String, Object> iditem = (Map<String, Object>)idItems.get('Id');
            if(orderItems == ''){
                orderItems = String.valueOf(iditem.get('value'));
            }else{
                orderItems = orderItems + ',' + String.valueOf(iditem.get('value'));
            }
        }

        outMap.put('idItems', orderItems);
        return true;
    }
    /**************************************************************************************************************************************
    * @description Este metodo se utiliza para asignar el valor true al campo "isConverted" en el objeto Lead (Candidato) debido a que el campo
    * esta bloqueado y solo se puede ejecutar desde una clase APEX, ya que si este campo no es colocado a true el registro continua visulizandose
    * como Lead (Candidato) aunque ya este convertido
	* @return true
	* @example
    * Map<String, Object> inputMap = new Map<String, Object>();
    * Map<String, Object> outMap = new Map<String, Object>();
    * Map<String, Object> options = new Map<String, Object>();
    * Account acc = [Select Id From Account Where Type = 'Business' LIMIT 1];
    * Contact con = [Select Id From Contact LIMIT 1];
    * Lead lead = [Select Id From Lead LIMIT 1];
    * inputMap.put('AccountId', acc.Id); // Id de la cuenta creada a partir del Lead (Candidato) que se esta creando
    * inputMap.put('ContactId', con.Id); // Id del contacto asociado a la cuenta creada a partir del Lead (Candidato) que se esta creando
    * inputMap.put('LeadId', lead.Id);   // Id del registro del Lead (Candidato) que se esta conviertiendo 
    * Object result = new etb_Utilities().invokeMethod(etb_Utilities.convertLeadToClient, inputMap, outMap, options);
    */
	private boolean convertLeadToClient(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        
        Id leadId = (Id)String.valueOf(inputMap.get(INPUT_LEAD_ID));
        Id accountId = (Id)String.valueOf(inputMap.get(INPUT_ACCOUNT_ID));
        Id contactId = (Id)String.valueOf(inputMap.get(INPUT_CONTACT_ID));
        System.debug('leadId: ' + leadId);
        System.debug('accountId: ' + accountId);
        System.debug('contactId: ' + contactId);
        
        //Lead myLead = [SELECT Id FROM Lead WHERE Id =: leadId];
        //insert myLead;

        Lead myLead = [SELECT Id,RecordType.DeveloperName FROM Lead WHERE Id =:leadId Limit 1];
        etb_ProcessLeadStatus__mdt etbProcessLeadStatus = [SELECT Id,Status__c FROM etb_ProcessLeadStatus__mdt WHERE QualifiedApiName =: myLead.RecordType.DeveloperName LIMIT 1];
     
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setDoNotCreateOpportunity(true);
        lc.setAccountId(accountId);
        lc.setContactId(contactId);
        lc.setLeadId(leadId);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true AND MasterLabel =: etbProcessLeadStatus.Status__c LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        try{
        	Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            outMap.put('LeadConvertResult', lcr.isSuccess());
            return true;
        }catch(Exception ex){
            System.debug('Ocurrió un error en la conversión de Leads: ' + ex.getMessage());
            return false;
        }
    }

    
    // MAMB: Nueva versión del método para actualizar el order item hijo con el Id del Orden Item Padre
    // de acuerdo a la búsqueda por AssetReferenceId 
    private boolean reliesOnOrderItemsUpdate(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
    	Map<String,OrderItem> parentProd = new Map<String,OrderItem>();        
        
        String OrderId = (String)inputMap.get('parentOrderId'); // ID de la Master Order
        
        List<Map<String,Object>> relatedParent = new List<Map<String,Object>>();
        
        List<OrderItem> OrderItems = [SELECT id, Related_Item__c,vlocity_cmt__ReliesOnItemId__c FROM OrderItem WHERE Order.vlocity_cmt__ParentOrderId__c = :OrderId AND vlocity_cmt__ReliesOnItemId__c != ''];
                        //Todos los order items padres
        if(OrderItems.size() <= 0){
            return true;
        }
        
        Map<String,String> parentIds = new Map<String,String>();
        
        relatedParent = (List<Map<String,Object>>)inputMap.get('ParentItems');
        
         for (Map<String,Object> parentId : relatedParent){
             parentIds.put((String)parentId.get('AssetReferenceId'),(String)parentId.get('Id'));             
         }        

        String orderItemParent;
        
        for (OrderItem item :OrderItems){
            String reference = (String)item.vlocity_cmt__ReliesOnItemId__c;
            //String orderItemId = (String)item.Id;
            
            if(parentIds.containskey(reference) ){
                String itemKey = (String)parentIds.get(reference);
                item.Related_Item__c = itemKey;
            } 
        }
        try{
        	update OrderItems;
        	System.debug('Items => ' + JSON.serializePretty(OrderItems));
        }catch(exception exp){
            System.debug('Problema al actualizar el order product: ' + exp.getMessage());
            outMap.put('error',exp.getMessage());
            outMap.put('result','error');
            return false;
        }
        outMap.put('result','success');
        return true;
    }
    
    /*
	private boolean reliesOnOrderItemsUpdate(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
       	Id parentOrderId = (ID)inputMap.get('parentOrderId');
        
        List<OrderItem> subOrderItems = [Select Id, Product2Id, vlocity_cmt__ReliesOnItemId__c from OrderItem where  Order.vlocity_cmt__ParentOrderId__c = :parentOrderId and Product2Id IN (Select vlocity_cmt__RelatedProductId__c from vlocity_cmt__ProductRelationship__c  where vlocity_cmt__RelationshipType__c = 'ReliesOn')  ];
     	Map<Id,vlocity_cmt__ProductRelationship__c> parentProd = new Map<Id,vlocity_cmt__ProductRelationship__c>();
        
        System.debug('Sub Order Items => ' + JSON.serializePretty(subOrderItems));
        
        
        for(vlocity_cmt__ProductRelationship__c relProd :[select id, vlocity_cmt__RelationshipType__c, vlocity_cmt__Product2Id__r.Name, vlocity_cmt__Product2Id__c, vlocity_cmt__RelatedProductId__c from vlocity_cmt__ProductRelationship__c Where vlocity_cmt__RelationshipType__c = 'ReliesOn']){
            parentProd.put(relProd.vlocity_cmt__RelatedProductId__c,relProd);            
        }
        
        System.debug('Parent Items => ' + JSON.serializePretty(parentProd));
        
        for(OrderItem itemToSet :subOrderItems){
            if(parentProd.containsKey(itemToSet.Product2Id)){
               	vlocity_cmt__ProductRelationship__c parentItem = (vlocity_cmt__ProductRelationship__c)parentProd.get(itemToSet.Product2Id);
                
                itemToSet.vlocity_cmt__ReliesOnItemId__c = parentItem.vlocity_cmt__Product2Id__c;
            }
        }
        
        outMap.put('Response','Proceso ejecutado OK');
        update subOrderItems;
        
        System.debug('Items => ' + JSON.serializePretty(subOrderItems));
     
        return true;
    }
    
*/
    public static String getUrlStaticResource(String staticResourceName){

        String sfUrl;
        StaticResource static_resource = [SELECT Id, Name, SystemModStamp
                                        FROM StaticResource 
                                        WHERE Name =: staticResourceName
                                        LIMIT 1];

        if(static_resource != null){
            String urlFileRef = '/resource/'
                                + String.valueOf(((DateTime)static_resource.get('SystemModStamp')).getTime())
                                + '/' 
                                + static_resource.get('Name') ;
    
            sfUrl = 'https://' + URL.getSalesforceBaseUrl().getHost();
            if(sfUrl.contains('.my.')){
                String customDomain=sfUrl.split('.my.')[0];
                System.debug(customDomain);
                sfUrl = customDomain + '--c.visualforce.com' + urlFileRef;
            }
        } else {
            sfUrl = 'Static Resource Name is invalid or not exists!!!';
        }
        return sfUrl;
    }

    public static boolean sendNotification (Set<String> recipientsIds, String targetId, String tittle, String body){
        Boolean response = false;
        CustomNotificationType notificationType = 
        [SELECT Id, DeveloperName 
        FROM CustomNotificationType 
        WHERE DeveloperName='Notificacion_Viabilidad'];

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(tittle);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);

        try {
            if(recipientsIds!=null && targetId != null ){
                notification.send(recipientsIds);
                System.debug('La notificación fue enviada exitosamente.');
                response=true;
            }
        }
        catch (Exception e) {
            System.debug('Problema al enviar notificación: ' + e.getMessage());
            response=false;
        }
        return response;
    }
    	//Se llevo a la clase etb_SendNotificationAsyncEngine
    	/*private Object sendNotificationByAsyncProcess(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
            Boolean response = false;
            Map<String,Object> additionalData = (Map<String,Object>)inputMap.get('additionalData');
            Set<String> recipientsIds = new Set<String>();
            String contractId = String.valueOf(additionalData.get('ContractId'));
            String userId = String.valueOf(additionalData.get('UserId'));
            String tittle = String.valueOf(additionalData.get('TittleMsg'));
            String body = String.valueOf(additionalData.get('BodyMsg'));
            String customNotificationName = String.valueOf(additionalData.get('CustomNotificationName'));
            System.debug('contractId: ' + contractId);
            System.debug('userId: ' + userId);
            System.debug('tittle: ' + tittle);
            System.debug('body: ' + body);
            System.debug('customNotificationName: ' + customNotificationName);
            recipientsIds.add(userId);
            etb_Utilities.sendNotification(recipientsIds, contractId, tittle, body, customNotificationName);
            return outMap;
        }

    
        public static boolean sendNotification (Set<String> recipientsIds, String targetId, String tittle, String body, String customNotificationName){
        Boolean response = false;
        CustomNotificationType notificationType = 
        [SELECT Id, DeveloperName 
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
                response=true;
            }
        }
        catch (Exception e) {
            System.debug('Problema al enviar notificación: ' + e.getMessage());
            response=false;
        }
        return response;
    }*/
    
    public static boolean sendEmail (Viabilidad__c viabilidad){
        System.debug('##################');
        system.debug(viabilidad);
        Boolean response = false;   
        EmailTemplate et=[Select id, HtmlValue, Subject from EmailTemplate where name = 'Viabilidad_Vencida_Test' limit 1];
        String htmlBody = et?.HtmlValue;

        User user = [SELECT Id, Email FROM User WHERE Id =: viabilidad.OwnerId ];
        StaticResource static_resource = [SELECT Id, Name, SystemModStamp
                                        FROM StaticResource 
                                        WHERE Name = 'logo_etb_slogan'
                                        LIMIT 1];
        String sfUrl = getUrlStaticResource('logo_etb_slogan');
        System.debug('URL Static Resource: ' + sfUrl);

        String nombreCliente = String.isBlank(viabilidad.Quote_Line_Item__r.Quote.Account.Name) ? '' : viabilidad.Quote_Line_Item__r.Quote.Account.Name ;

        htmlBody = htmlBody.replace('{!Viabilidad.Nombre}', viabilidad.Name);
        htmlBody = htmlBody.replace('{!Cliente.Nombre}', nombreCliente);
        htmlBody = htmlBody.replace('{!Viabilidad.dias}', String.valueOf(viabilidad.Tiempo_Entrega_ETB_dias__c));
        htmlBody = htmlBody.replace('{!Viabilidad.link}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + viabilidad.Id);
        htmlBody = htmlBody.replace('{!Source}', sfUrl);
        List<String> toAddress = new List<String>();
        toAddress.add(user.Email);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setTargetObjectId(user.Id);
        message.setTemplateId(et?.Id);
        message.setHtmlBody(htmlBody);
        message.setToAddresses(toAddress);
        message.setSubject('Recordatorio Vencimiento de Viabilidad');
        message.setSaveAsActivity(false);
        message.setUseSignature(false);
            
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        
        try{
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('El email fue enviado exitosamente.');
                response = true;
                System.debug('##############'); 
                System.debug(messages);
            } else {
                System.debug('Ocurrió un error al enviar el email: ' + results[0].errors[0].message);
                response = false;
            }

        }catch(Exception ex){
            System.debug('Ocurrió un error en el envio de Email: ' + ex.getMessage());
            response = false;
        }
            
        return response;
    }
    
@InvocableMethod
	public static void sendEmailAndNotification(){  
        List<Viabilidad__c> lstViabilidades = [SELECT Id, Fecha_Final_Estado__c, CreatedDate, LastModifiedDate, OwnerId, 
                                                Quote_Line_Item__r.vlocity_cmt__AttributeSelectedValues__c, Owner.Name,Owner.Email, Name,
                                                EstadoViabilidad__c, Quote_Line_Item__r.Quote.Account.Name, Tiempo_Entrega_ETB_dias__c 
                                            FROM Viabilidad__c 
                                            WHERE EstadoViabilidad__c = 'En proceso' 
                                            AND Fecha_Final_Estado__c != null];
        System.debug('lstViabilidades --> '+ lstViabilidades.Size());
        Map<String,List<Viabilidad__c>> mapViabilidades = new Map<String,List<Viabilidad__c>>();
        Date todayDate = Date.today();
        etb_ProcesoViabilidad__mdt umbral = etb_ProcesoViabilidad__mdt.getInstance('umbralDeVencimiento');
    	Integer cantidadDiasUmbral = (Integer)umbral.umbralDeVencimiento__c;
        System.debug('cantidadDiasUmbral --> '+cantidadDiasUmbral);
        String objOwnerIdOld = '';
        Boolean entraPrimeraVez = true;
        List<Viabilidad__c> objLstsViabilidad = new List<Viabilidad__c>();
        String bodyEmail = '';
        String tittle = 'Vencimiento de viabilidad';
        Integer diasMaxViab = 90; //se podria parametrizar en el mtd
        Date fechaMax;
        Integer difDays;
        for(Viabilidad__c viabilidad:lstViabilidades){
            String jsonSelectedAttQLI = viabilidad.Quote_Line_Item__r.vlocity_cmt__AttributeSelectedValues__c;
            if(jsonSelectedAttQLI != null){ //algunos productos no tienen atributos seleccionados
                Map<String, Object> mapJsonSelectedAttQLI =(Map<String, Object>)JSON.deserializeUntyped(jsonSelectedAttQLI);//mapa con el json deserializado
                Integer vigenciaViabilidadDias = (Integer)mapJsonSelectedAttQLI.get('ATT_Vigencia_Viabilidad_Dias');//obtenemos valor attributo
                System.debug('vigenciaViabilidadDias *** --> '+vigenciaViabilidadDias);
                // if(viabilidad.Fecha_Final_Estado__c == null && vigenciaViabilidadDias == null){ //quiere decir que NO contesto gestor
                //     Date fechaCreated = Date.newinstance(viabilidad.CreatedDate.year(), viabilidad.CreatedDate.month(), viabilidad.CreatedDate.day());
                //     fechaMax = fechaCreated.addDays(diasMaxViab);
                //     difDays = todayDate.daysBetween(fechaMax);
                //     System.debug('SIN GESTOR');
                //     System.debug('fechaMax --> '+difDays+' para viabilidad: '+viabilidad.Name);
                //     System.debug('difDays --> '+difDays+' para viabilidad: '+viabilidad.Name);
				// 	if(difDays>=0 && difDays <= cantidadDiasUmbral){ //solo notifica la cantidad de dias que tiene el umbral
                //         if(!mapViabilidades.containsKey(viabilidad.OwnerId)){
                //             mapViabilidades.put(viabilidad.OwnerId,new List<Viabilidad__c>());
                //         }
                //         objLstsViabilidad = mapViabilidades.get(viabilidad.OwnerId);
                //         objLstsViabilidad.add(viabilidad);
                //         mapViabilidades.put(viabilidad.OwnerId,objLstsViabilidad);
                //         Set<String> recipientsIds = new Set<String>();
                //         recipientsIds.add((String)viabilidad.OwnerId);
                //         String targetId = viabilidad.Id;                
                //         String body = 'Una viabilidad se encuentra próxima a vencer: '+viabilidad.Name;
                //         boolean response = etb_Utilities.sendNotification(recipientsIds, targetId, tittle, body); 
                //    	}else if(difDays < 0 ){
                //         viabilidad.EstadoViabilidad__c = 'Cerrado No Viable';
                //         viabilidad.Respuestadeviabilidad__c = 'No Viable';
                //         update viabilidad;
                //     }
                // }else if(viabilidad.Fecha_Final_Estado__c != null && vigenciaViabilidadDias == null){
                if(viabilidad.Fecha_Final_Estado__c != null && vigenciaViabilidadDias == null){
                    Date fechaFinalEstado = viabilidad.Fecha_Final_Estado__c;
                    fechaMax = fechaFinalEstado.addDays(diasMaxViab);
                    difDays = todayDate.daysBetween(fechaMax);
                    System.debug('GESTOR SIN VVD');
                    System.debug('fechaMax --> '+difDays+' para viabilidad: '+viabilidad.Name);
                    System.debug('difDays --> '+difDays+' para viabilidad: '+viabilidad.Name);
                    if(difDays>=0 && difDays <= cantidadDiasUmbral){ //solo notifica la cantidad de dias que tiene el umbral
                        if(!mapViabilidades.containsKey(viabilidad.OwnerId)){
                            mapViabilidades.put(viabilidad.OwnerId,new List<Viabilidad__c>());
                        }
                        objLstsViabilidad = mapViabilidades.get(viabilidad.OwnerId);
                        objLstsViabilidad.add(viabilidad);
                        mapViabilidades.put(viabilidad.OwnerId,objLstsViabilidad);
                        Set<String> recipientsIds = new Set<String>();
                        recipientsIds.add((String)viabilidad.OwnerId);
                        String targetId = viabilidad.Id;                
                        String body = 'Una viabilidad se encuentra próxima a vencer: '+viabilidad.Name;
                        boolean response = etb_Utilities.sendNotification(recipientsIds, targetId, tittle, body); 
                   	}else if(difDays < 0 ){
                        viabilidad.EstadoViabilidad__c = 'Cerrado No Viable';
                        viabilidad.Respuestadeviabilidad__c = 'No Viable';
                        update viabilidad;
                    }
                }else if(viabilidad.Fecha_Final_Estado__c != null && vigenciaViabilidadDias != null){ //quiere decir que SI contesto gestor
					Date fechaFinalEstado = viabilidad.Fecha_Final_Estado__c;
                    fechaMax = fechaFinalEstado.addDays(vigenciaViabilidadDias);
                    difDays = todayDate.daysBetween(fechaMax);
                    
                    System.debug('GESTOR CON VVD');
                    System.debug('fechaMax --> '+fechaMax+' para viabilidad: '+viabilidad.Name);
                    System.debug('difDays --> '+difDays+' para viabilidad: '+viabilidad.Name);  
                    if(difDays>=0 && difDays <= cantidadDiasUmbral){ //solo notifica la cantidad de dias que tiene el umbral
                        // MAMB
                        viabilidad.Tiempo_Entrega_ETB_dias__c = difDays;
                        // MAMB
                        System.debug('ENTRO A MANDAR MAIL');
                        if(!mapViabilidades.containsKey(viabilidad.OwnerId)){
                            mapViabilidades.put(viabilidad.OwnerId,new List<Viabilidad__c>());
                        }
                        objLstsViabilidad = mapViabilidades.get(viabilidad.OwnerId);
                        System.debug('****************');
                        System.debug(viabilidad);
                        objLstsViabilidad.add(viabilidad);
                        mapViabilidades.put(viabilidad.OwnerId,objLstsViabilidad);
                        Set<String> recipientsIds = new Set<String>();
                        recipientsIds.add((String)viabilidad.OwnerId);
                        String targetId = viabilidad.Id;                
                        String body = 'Una viabilidad se encuentra próxima a vencer: '+viabilidad.Name;
                        boolean response = etb_Utilities.sendNotification(recipientsIds, targetId, tittle, body); 
                   	}else if(difDays < 0 ){
                        viabilidad.EstadoViabilidad__c = 'Cerrado No Viable';
                        viabilidad.Respuestadeviabilidad__c = 'No Viable';
                        update viabilidad;
                    }
                }
            }    
        }
        for (String mapVia : mapViabilidades.keySet()) {
            boolean responseEmail;
            System.debug('Mapa de Viabilidades: ' + mapViabilidades.get(mapVia));
            for (Viabilidad__c viabilidad : mapViabilidades.get(mapVia)) {
                System.debug('Viabilidad ' + viabilidad);
                responseEmail = etb_Utilities.sendEmail(viabilidad);
            }
        }         
    }
    
    
    private Integer getOriginalTotalPrice(List<Object> arguments) {
        Id QLIId = String.valueOf(arguments[0]);
        QuoteLineItem QLI = [SELECT Id, vlocity_cmt__PricingLogData__c FROM QuoteLineItem WHERE Id =: QLIId ].get(0);
        System.debug('PLD ' + JSON.deserializeUntyped(QLI.vlocity_cmt__PricingLogData__c));
        Map<String, Object> PLD = (Map<String, Object>) JSON.deserializeUntyped(QLI.vlocity_cmt__PricingLogData__c);
        System.debug('PricingVariableCodeBaseValues ' + PLD.get('PricingVariableCodeBaseValues'));
        Map<String, Object> PricingVariableCodeBaseValues = (Map<String, Object>) PLD.get('PricingVariableCodeBaseValues');
        Integer result;
        String pricingVariable_REC_MNTH_STD_PRC = 'REC_MNTH_STD_PRC';
        if(PricingVariableCodeBaseValues.containsKey(pricingVariable_REC_MNTH_STD_PRC)) {
            if(Integer.valueOf(PricingVariableCodeBaseValues.get(pricingVariable_REC_MNTH_STD_PRC)) > 0) {
                result = Integer.valueOf(PricingVariableCodeBaseValues.get(pricingVariable_REC_MNTH_STD_PRC));
            }else {
                system.debug('else');
                Map<String, Object> LogData = (Map<String, Object>) PLD.get('LogData');
                System.debug('obj LogData ' + JSON.serialize(PLD.get('LogData')));
                List<Object> listaRecurringMonthStdPrice = (List<Object>) LogData.get(pricingVariable_REC_MNTH_STD_PRC);
                List<Map<String, Object>> auxListLogOverride = new List<Map<String, Object>>();
                System.debug('LogData: ' + JSON.serialize(listaRecurringMonthStdPrice));
                for(Object objLog : listaRecurringMonthStdPrice) {
                    Map<String, Object> mapLog = (Map<String, Object>) objLog;
                    if(String.valueOf(mapLog.get('LogType')).equals('OVERRIDE')){
                        auxListLogOverride.add(mapLog);
                    }
                }
                
                if(auxListLogOverride.isEmpty()) {
                    result = 0;
                }
                else {
                    DateTime auxDateTime;
                    Map<String, Object> auxMapLog = new Map<String, Object>();
                    for(Map<String, Object> mapLogOverride : auxListLogOverride) {
                        if(auxDateTime == null) {
                            auxDateTime = DateTime.valueOf(String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' '));
                            auxMapLog = mapLogOverride;
                        }
                        else {
                            if(DateTime.valueOf(String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' ')) > auxDateTime) {
                                auxDateTime = DateTime.valueOf(String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' '));
                                auxMapLog = mapLogOverride;
                            }
                        }
                    }
                    result = Integer.valueOf(auxMapLog.get('Amount'));
                }
            }
            
        }else {
            system.debug('else');
            Map<String, Object> LogData = (Map<String, Object>) PLD.get('LogData');
            System.debug('obj LogData ' + JSON.serialize(PLD.get('LogData')));
            List<Object> listaRecurringMonthStdPrice = (List<Object>) LogData.get(pricingVariable_REC_MNTH_STD_PRC);
            List<Map<String, Object>> auxListLogOverride = new List<Map<String, Object>>();
            System.debug('LogData: ' + JSON.serialize(listaRecurringMonthStdPrice));
            for(Object objLog : listaRecurringMonthStdPrice) {
                Map<String, Object> mapLog = (Map<String, Object>) objLog;
                if(String.valueOf(mapLog.get('LogType')).equals('OVERRIDE')){
                    auxListLogOverride.add(mapLog);
                }
            }
            System.debug('size ' + auxListLogOverride.size());
            if(auxListLogOverride.size() == 1) {
                System.debug('auxListLogOverride' + auxListLogOverride.get(0));
                Map<String, Object> mapLog = auxListLogOverride.get(0);
                result = Integer.valueOf(mapLog.get('Amount'));
            }
            else {
                DateTime auxDateTime;
                Map<String, Object> auxMapLog = new Map<String, Object>();
                for(Map<String, Object> mapLogOverride : auxListLogOverride) {
                    System.debug('fecha edit ' + String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' '));
                    if(auxDateTime == null) {
                        auxDateTime = DateTime.valueOf(String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' '));
                        auxMapLog = mapLogOverride;
                    }
                    else {
                        if(DateTime.valueOf(String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' ')) > auxDateTime) {
                            auxDateTime = DateTime.valueOf(String.valueOf(mapLogOverride.get('DateApplied')).replace('T',' '));
                            auxMapLog = mapLogOverride;
                        }
                    }
                }
                result = Integer.valueOf(auxMapLog.get('Amount'));
            }
        } 
        
        return result;
    }
    
    
    public static List<Object> transformJson(List<Object> paramMap){      
    
    List<Object> finalJson = new List<Object>();   //Lista donde se almacenarán los objetos    
    string jsonInput = JSON.serialize(paramMap[0]); //Conversión del parámetro a JSON     
    Map<String, Object> deserializedInput = (Map<String, Object>) JSON.deserializeUntyped(jsonInput); //Deserialización del JSON del parámetro    
    //Estructura de objeto a utilizar para insertar en la lista (Los valores de codigoAccion y tipo pueden variar en un futuro).    
    string structure = '{"nombre": "ATT_RangoNumeración","valor": "null","codigoAccion": "add","tipo": "comercial","codigo": "ATT_RangoNumeración"}';
    //Estructura con todos los atributos presentes.    
    string jsonOI = '{"ATT_CantidadSesionesSIP": null,"ATT_TipoTráficodePlan": "Entrante por Consumo","ATT_Clausula_de_Terminacion_Anticipada": "Sí Acepta","ATT_TiempoContratoMeses":12,"ATT_TiempoContratoDias":null,"ATT_NúmeroConservar":null,"ATT_TipoEnlace": null,"ATT_TipoSeñalización":null,"ATT_CantidadEnlaces": "2","ATT_MarcadePlanta": "g","ATT_ReferenciaPlanta": "h","ATT_Tipo_de_Servicio": null,"ATT_Comentarios": null,"ATT_Tipo_de_Servicio_Gestor": null,"ATT_Identificador_de_Servicio": null,"ATT_EquipoAcceso": null,"ATT_Nemonico": "E1","ATT_MetrosTendidoUM_ETB": null,"ATT_NúmeroConexión": null,"ATT_Vigencia_Viabilidad_Dias": null,"ATT_Consumo_Minutos_Voz_Local_Mes": null,"ATT_RangoNumeración": null,"ATT_LlamadaRáfaga": false}';    
    //Map<String, Object> jsonOIDeserialized = (Map<String, Object>) JSON.deserializeUntyped(jsonOI); //Deserialización de la estructura con los atributos 
    Map<String, Object> jsonOIDeserialized = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
        
    //Se itera cada atributo de jsonOI, seteando el valor de la key al atributo "nombre" de la estructura
    //Luego se le asigna el valor correspondiente a dicha key en el JSON del parámetro al campo "valor"
    //Una vez asignados los valores, se agrega la estructura al objeto formattedJson
          
	for(String key:jsonOIDeserialized.keyset()) {        
        Map<String, Object> formattedJson = (Map<String, Object>) JSON.deserializeUntyped(structure); //Estructura de objeto deserializada.        
        formattedJson.put('nombre',key);					   //Asignar nombre del atributo a nombre.
        formattedJson.put('codigo',key);					   //Asignar nombre del atributo a codigo.
        if(String.isNotEmpty(String.valueOf(deserializedInput.get(key)))){
         formattedJson.put('valor',String.valueOf(deserializedInput.get(key))); //Asignar el valor del campo correspondiente desde paramMap.
        }else{
            formattedJson.put('valor',''); //Asignar el valor del campo correspondiente desde paramMap.
        }
        finalJson.add(formattedJson); 						   //Agregar el valor a la lista.     
    }
        return finalJson;
    }
    
}