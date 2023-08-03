global with sharing class ETB_ServiceProvisioningImplement implements vlocity_cmt.VlocityOpenInterface2 {
    private static final String PROVISIONED_STATUS_ORDERITEM = 'Aprovisionado';
    private static final String IN_PROVISIONED_STATUS_ORDERITEM = 'En Aprovisionamiento';
    private static final String PROVISIONED_STATUS_ORDER = 'Provisioned';
    private static final String IN_PROVISIONED_STATUS_ORDER = 'En Aprovisionamiento';
    private static final String ACTIVATED_STATUS_ORDER = 'Activated';

    global Object invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        try {
            switch on methodName {
                when 'updateBillingAccounts' {
                    updateBillingAccounts(inputMap);
                }
                when 'orderManagement' {
                    orderManagement(inputMap);
                }
                when 'sendEmail' {
                    sendEmail(inputMap);
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

    private static void updateBillingAccounts(Map<String, Object> inputMap) {
        List<Object> itemsToProcessSubsetList;
        Map<String, Object> accounts;
        List<Object> billingAccounts;
        List<Account> listaAccountsToUpdate;
        try {
            itemsToProcessSubsetList = (List<Object>) inputMap.get('itemsToProcessSubsetList');
            listaAccountsToUpdate = new List<Account>();
            for (Object objBillinAccount : itemsToProcessSubsetList) {
                Map<String, Object> mapBillingAccount = (Map<String, Object>) objBillinAccount;
                Account objNewAccount = new Account();
                objNewAccount.Id = String.valueOf(mapBillingAccount.get('Id'));
                objNewAccount.BillingAccountNumber__c = String.valueOf(mapBillingAccount.get('numberBillingAccount'));
                objNewAccount.vlocity_cmt__BillCycle__c = String.valueOf(mapBillingAccount.get('ciclodeFacturacion'));
                objNewAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
                listaAccountsToUpdate.add(objNewAccount);
            }
            upsert listaAccountsToUpdate;
        }
        catch(Exception e) {
            throw e;
        }
    }

    private static void orderManagement(Map<String, Object> inputMap) {
        List<Object> itemsToProcessSubsetList;
        List<OrderItem> listaOrderItems;

        try {
            itemsToProcessSubsetList = (List<Object>) inputMap.get('itemsToProcessSubsetList');

            //Actualización de OrderItems
            listaOrderItems = UpdateOrderItems(itemsToProcessSubsetList);

            //Actualización de Orders
            UpdateOrders(listaOrderItems);

            //Actualización de Assets

        }
        catch(Exception e) {
            throw e;
        }
    }

    private static List<OrderItem> updateOrderItems(List<Object> itemsToProcessSubsetList) {
        List<OrderItem> listaOrderItems;
        Map<String, Object> mapItem;
        List<String> listaOrderItemIds;
        List<OrderItem> auxListaOrderItems;
        Map<String, Object> mapAgendamiento;

        try {
            listaOrderItemIds = new List<String>();
            for(Object objItem : itemsToProcessSubsetList) {
                mapItem = (Map<String, Object>) objItem;
                listaOrderItemIds.add(String.valueOf(mapItem.get('idItem')));
            }
            listaOrderItems = [SELECT Id, OrderId, vlocity_cmt__ProvisioningStatus__c, FranjaAgendamiento__c, EstadoAgendamiento__c, FechaAgendamiento__c, ProvisioningEngineer__c, AllocationGroup__c, ProvisioningComments__c, GestorStatus__c, DeclineCause__c FROM OrderItem WHERE Id IN :listaOrderItemIds];

            for(OrderItem orderItem : listaOrderItems) {
                for(Object objItem : itemsToProcessSubsetList) {
                    mapItem = (Map<String, Object>) objItem;
                    if(String.valueOf(mapItem.get('idItem')).equals(orderItem.Id)) {
                        orderItem.vlocity_cmt__ProvisioningStatus__c = String.valueOf(mapItem.get('statusProvisioning'));
                        orderItem.ProvisioningEngineer__c = String.valueOf(mapItem.get('engineer'));
                        orderItem.AllocationGroup__c = String.valueOf(mapItem.get('groupAssigment'));
                        orderItem.ProvisioningComments__c = String.valueOf(mapItem.get('comments'));
                        orderItem.GestorStatus__c = String.valueOf(mapItem.get('statusGestor'));
                        orderItem.DeclineCause__c = String.valueOf(mapItem.get('causalDecline'));
                        mapAgendamiento = (Map<String, Object>) mapItem.get('agendamiento');
                        if(mapAgendamiento != null) {
                            orderItem.FranjaAgendamiento__c = String.valueOf(mapAgendamiento.get('agendaDate'));
                            orderItem.EstadoAgendamiento__c = String.valueOf(mapAgendamiento.get('agendaStrip'));
                            orderItem.FechaAgendamiento__c = String.valueOf(mapAgendamiento.get('agendaStatus'));
                        }
                    }
                }
            }
            update listaOrderItems;
            return listaOrderItems;
        }
        catch(Exception e) {
            throw e;
        }
    }

    private static void updateOrders(List<OrderItem> listaOrderItems) {
        List<String> listaOrderIds;
        List<Order> listaSubOrders;
        List<Order> listaOrdersToUpdate;
        Boolean hasItemsInProgress;
        integer itemsInProvisioning = 0;
        Order masterOrder;
        Boolean hasOrdersInProgress;

        try {
            //Obtención de SubOrders asociadas a OrderItems que se actualizaron.
            listaOrderIds = new List<String>();
            for(OrderItem orderItem : listaOrderItems) {
                if(orderItem.vlocity_cmt__ProvisioningStatus__c.equals(PROVISIONED_STATUS_ORDERITEM) 
                   || orderItem.vlocity_cmt__ProvisioningStatus__c.equals(IN_PROVISIONED_STATUS_ORDERITEM)) {
                    listaOrderIds.add(String.valueOf(orderItem.OrderId));
                }
            }
            listaSubOrders = [SELECT Id, vlocity_cmt__ParentOrderId__c, (SELECT Id, vlocity_cmt__ProvisioningStatus__c FROM OrderItems) FROM Order WHERE Id IN :listaOrderIds];

            //Validación de SubOrders que tengan todos sus OrderItems aprovisionados.
            listaOrdersToUpdate = new List<Order>();
            for(Order subOrder : listaSubOrders) {
                hasItemsInProgress = false;
                itemsInProvisioning = 0;
                for(OrderItem orderItem : subOrder.OrderItems) {
                    if(orderItem.vlocity_cmt__ProvisioningStatus__c == IN_PROVISIONED_STATUS_ORDERITEM) {
                        itemsInProvisioning++;
                    }
                    if(orderItem.vlocity_cmt__ProvisioningStatus__c != PROVISIONED_STATUS_ORDERITEM) {
                        hasItemsInProgress = true;
                        //break;
                    }
                }
                if(!hasItemsInProgress) {
                    subOrder.Status = PROVISIONED_STATUS_ORDER;
                    listaOrdersToUpdate.add(subOrder);
                }
                if(itemsInProvisioning > 0 && itemsInProvisioning == subOrder.OrderItems.size()){
                    subOrder.Status = IN_PROVISIONED_STATUS_ORDER;
                    listaOrdersToUpdate.add(subOrder);                    
                }
            }

            //Actualización de SubOrders
            if(listaOrdersToUpdate.size() > 0) {
                update listaOrdersToUpdate;
                if (!hasItemsInProgress){
                	checkoutOrders(listaOrdersToUpdate);
                }
            }

            //Validación de MasterOrder que tenga todas sus SubOrders aprovisionadas.
            if(listaSubOrders.size() > 0) {
                masterOrder = [SELECT Id, Status FROM Order WHERE Id = :listaSubOrders[0].vlocity_cmt__ParentOrderId__c];
                hasOrdersInProgress = false;
                for(Order subOrder : [SELECT Id, Status FROM Order WHERE vlocity_cmt__ParentOrderId__c = :masterOrder.Id]) {
                    if(subOrder.Status != PROVISIONED_STATUS_ORDER && subOrder.Status != ACTIVATED_STATUS_ORDER) {
                        hasOrdersInProgress = true;
                        break;
                    }
                }
                if(!hasOrdersInProgress) {
                    masterOrder.Status = PROVISIONED_STATUS_ORDER;
                    update masterOrder;
                }
            }
        }
        catch(Exception e) {
            throw e;
        }
    }

    private static void checkoutOrders(List<Order> listaOrders) {
        Map<String, Object> inputMap;
        Map<String, Object> outputMap;
        Map<String, Object> optionsMap;

        try {
            vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();

            for(Order order : listaOrders) {
                inputMap = new Map<String, Object>();
                inputMap.put('cartId', order.Id);
                inputMap.put('ContextId', order.Id);
                inputMap.put('methodName', 'checkout');
                outputMap = new Map<String, Object>();
                optionsMap = new Map<String, Object>();

                cpqAppHandler.invokeMethod('checkout', inputMap, outputMap, optionsMap);
            }
        }
        catch(Exception e) {
            throw e;
        }
    }

    private static void sendEmail(Map<String, Object> InputMap) {
        Map<String, Object> mapItemsProcessed;
        List<Object> listaSuccessfullyProcessedItems;
        List<Object> listaFailedProcessedItems;
        Map<String, Object> mapSuccessfullyProcessedItem;
        List<String> listaOrderItemIds;
        List<OrderItem> listaOrderItems;
        List<String> listaOrderIds;
        List<Order> listaOrders;
        List<Messaging.SingleEmailMessage> listaEmails;
        String emailBody;
        String emailSubject;
        Messaging.SingleEmailMessage email;
        List<String> emailTo;

        try {
            mapItemsProcessed = (Map<String, Object>) InputMap.get('itemsProcessed');
            listaSuccessfullyProcessedItems = (List<Object>) mapItemsProcessed.get('successfully');
            listaFailedProcessedItems = (List<Object>) mapItemsProcessed.get('failed');

            //Obtención el id de los OrderItems procesados exitosamente.
            listaOrderItemIds = new List<String>();
            for(Object objSuccessfullyProcessedItem : listaSuccessfullyProcessedItems) {
                mapSuccessfullyProcessedItem = (Map<String, Object>) objSuccessfullyProcessedItem;
                listaOrderItemIds.add(String.valueOf(mapSuccessfullyProcessedItem.get('idItem')));
            }
            listaOrderItems = [SELECT Id, OrderId FROM OrderItem WHERE Id IN :listaOrderItemIds];

            //Obtención de los datos de las SubOrders asociadas a los OrderItems procesados.
            listaOrderIds = new List<String>();
            for(OrderItem orderItem : listaOrderItems) {
                listaOrderIds.add(orderItem.OrderId);
            }
            listaOrders = [SELECT Id, OrderNumber, Account.Name, Status, vlocity_cmt__OpportunityId__r.Name, vlocity_cmt__OpportunityId__r.Owner.Email FROM Order WHERE Id IN :listaOrderIds];

            //Obtención de plantilla y armado de email.
            EmailTemplate emailTemplate = [SELECT Id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = 'NotificacionActualizacionOrden'];

            listaEmails = new List<Messaging.SingleEmailMessage>();
            for(Order order : listaOrders) {
                emailSubject = emailTemplate?.subject;
                emailSubject = emailSubject.replace('{!Order.OrderNumber}', String.valueOf(order.OrderNumber));

                emailBody = emailTemplate?.HtmlValue;
                emailBody = emailBody.replace('{!Order.OrderNumber}', String.valueOf(order.OrderNumber));
                emailBody = emailBody.replace('{!Order.AccountName}', String.valueOf(order.Account.Name));
                emailBody = emailBody.replace('{!Order.OpportunityName}', String.valueOf(order.vlocity_cmt__OpportunityId__r.Name));
                emailBody = emailBody.replace('{!Order.Status}', String.valueOf(order.Status));
                emailBody = emailBody.replace('{!Order.URL}', URL.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(order.Id));

                emailTo = new List<String>();
                emailTo.add(String.valueOf(order.vlocity_cmt__OpportunityId__r.Owner.Email));

                email = new Messaging.SingleEmailMessage();
                email.setToAddresses(emailTo);
                email.setSubject(emailSubject);
                email.setHtmlBody(emailBody);
                listaEmails.add(email);
            }
            Messaging.sendEmail(listaEmails);
        }
        catch(Exception e) {
            throw e;
        }
    }
}