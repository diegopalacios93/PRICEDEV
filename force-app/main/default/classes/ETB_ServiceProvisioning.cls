/*
* @Author:      Jean Nieto <jnieto@labsxd.com>
* @Company:     Salesforce/LabsXD
* @Date:        12-MAY-2022
* @Reviewer:    Jorge Seibert <jseibert@labsxd.com>
* @Review Date: 28-JUN-2022

* Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  ----------------------  ------------------------------------
1.0     28-06-2022  J Nieto                 Versión inicial.
*******************************************************************************/

@RestResource(urlMapping='/ServiceProvisioning/*')
global with sharing class ETB_ServiceProvisioning {
    private static final String ASYNC_PROCESS_APROVISIONAMIENTO = 'Servicio Aprovisionamiento - Aprovisionamiento';
    private static final String ASYNC_PROCESS_CTAFACTURACION = 'Servicio Aprovisionamiento - Cuentas de Facturación';
    private enum ASYNC_PROCESS_NAMES {ASYNC_PROCESS_APROVISIONAMIENTO, ASYNC_PROCESS_CTAFACTURACION}

    @HttpPost
    global static void ServiceProvisioning() {
        RestResponse response;
        RestRequest request;
        Map<String, Object> requestBody;
        List<Object> listaItems;
        Map<String, Object> mapAccount;
        List<Object> listaBillingAccounts;

        try {
            response = RestContext.response;
            response.statuscode = 200;
            request = RestContext.request;
            requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());

            //Aprovisionamiento de Orders
            if(requestBody.containsKey('items')) {
                listaItems = (List<Object>) requestBody.get('items');
                if(listaItems != null && listaItems.size() > 0) {
                    callAsyncEngine(ASYNC_PROCESS_APROVISIONAMIENTO, listaItems);
                }
            }

            //Actualización de BillingAccounts
            if(requestBody.containsKey('accounts')) {
                mapAccount = (Map<String, Object>) requestBody.get('accounts');
                if(mapAccount.containsKey('billingAccounts')) {
                    listaBillingAccounts = (List<Object>) mapAccount.get('billingAccounts');
                    if(listaBillingAccounts != null && listaBillingAccounts.size() > 0) {
                        callAsyncEngine(ASYNC_PROCESS_CTAFACTURACION, listaBillingAccounts);
                    }
                }
            }
        }
        catch(Exception e) {
            response.statuscode = 417;
            System.debug(LoggingLevel.DEBUG,'RespuestaNoOk ' + response.statuscode);
            System.debug(LoggingLevel.DEBUG,'RespuestaNoOk ' + e.getMessage());
            System.debug(LoggingLevel.DEBUG,'RespuestaNoOk ' + e.getStackTraceString());
        }
    }

    private static void callAsyncEngine(String asyncProcessName, List<Object> itemsToProcessList) {
        Map<String, Object> asyncProcessRequest;
        Map<String, Object> output;
        Map<String, Object> options;
        Map<String, Object> additionalData;
        List<Object> asyncProcessSteps;
        Map<String, Object> processStep;
        Map<String, Object> asyncJobDetails;
        Map<String, Object> startProcess;
        Map<String, Object> executeProcess;
        Map<String, Object> finishProcess;

        try {
            if(asyncProcessName.equals(ASYNC_PROCESS_APROVISIONAMIENTO)) {
                additionalData = new Map<String, Object>();

                asyncProcessSteps = new List<Object>();
                processStep = new Map<String, Object>();
                processStep.put('stepName', 'Assetización');
                asyncJobDetails = new Map<String, Object>();
                executeProcess = new Map<String, Object>();
                executeProcess.put('type', 'Vlocity Open Interface');
                executeProcess.put('name', 'ETB_ServiceProvisioningImplement');
                executeProcess.put('action', 'orderManagement');
                executeProcess.put('itemsToProcessPerAsyncJob', 1);
                executeProcess.put('executeAsyncJobsInSequence', true);
                executeProcess.put('asyncJobNumberOfRetriesOnFail', 0);
                finishProcess = new Map<String, Object>();
                finishProcess.put('type', 'Vlocity Open Interface');
                finishProcess.put('name', 'ETB_ServiceProvisioningImplement');
                finishProcess.put('action', 'sendEmail');
                asyncJobDetails.put('executeProcess', executeProcess);
                asyncJobDetails.put('finishProcess', finishProcess);
                processStep.put('asyncJobDetails', asyncJobDetails);
                asyncProcessSteps.add(processStep);

                asyncProcessRequest = new Map<String, Object>();
                options = new Map<String, Object>();
                asyncProcessRequest.put('asyncProcessName', asyncProcessName);
                asyncProcessRequest.put('itemsToProcessList', itemsToProcessList);
                asyncProcessRequest.put('additionalData', additionalData);
                asyncProcessRequest.put('asyncProcessSteps', asyncProcessSteps);
                output = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('etb_AsyncEngine', asyncProcessRequest, options);
            }
            else if(asyncProcessName.equals(ASYNC_PROCESS_CTAFACTURACION)) {
                additionalData = new Map<String, Object>();

                asyncProcessSteps = new List<Object>();
                processStep = new Map<String, Object>();
                processStep.put('stepName', 'Actualización de cuentas de facturación');
                asyncJobDetails = new Map<String, Object>();
                executeProcess = new Map<String, Object>();
                executeProcess.put('type', 'Vlocity Open Interface');
                executeProcess.put('name', 'ETB_ServiceProvisioningImplement');
                executeProcess.put('action', 'updateBillingAccounts');
                executeProcess.put('itemsToProcessPerAsyncJob', 1);
                executeProcess.put('executeAsyncJobsInSequence', true);
                executeProcess.put('asyncJobNumberOfRetriesOnFail', 0);
                asyncJobDetails.put('executeProcess', executeProcess);
                processStep.put('asyncJobDetails', asyncJobDetails);
                asyncProcessSteps.add(processStep);

                asyncProcessRequest = new Map<String, Object>();
                options = new Map<String, Object>();
                asyncProcessRequest.put('asyncProcessName', asyncProcessName);
                asyncProcessRequest.put('itemsToProcessList', itemsToProcessList);
                asyncProcessRequest.put('additionalData', additionalData);
                asyncProcessRequest.put('asyncProcessSteps', asyncProcessSteps);
                output = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('etb_AsyncEngine', asyncProcessRequest, options);
            }
        }
        catch(Exception e) {
            System.debug(LoggingLevel.DEBUG,'callAsyncEngine Message: ' + e.getMessage());
            System.debug(LoggingLevel.DEBUG,'callAsyncEngine StackTraceString: ' + e.getStackTraceString());
            throw e;
        }
    }
}