/*
* @Author:      Edinson Apolinar <eapolinar@labsxd.com>
* @Company:     Salesforce/LabsXD
* @Date:        12-MAY-2022
* @Reviewer:    Jorge Seibert <jseibert@labsxd.com>
* @Review Date: 28-JUN-2022

* Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  ----------------------  ------------------------------------
1.0     28-06-2022  E Apolinar              Versión inicial.
1.1		16-11-2022  F Sarasty				Se obtiene mapping de los campos idContacto y billingAccId
                                            enviados por la integración.
*******************************************************************************/

@RestResource(urlMapping='/ServiceViability/*')
global with sharing class etb_ServiceViability {
    private static final String ASYNC_PROCESS_COTIZACIONES = 'Servicio Viabilidad - Cotizaciones';
    private static final String ASYNC_PROCESS_VIABILIDADES = 'Servicio Viabilidad - Viabilidades';
    private static List<Object> listaCotizaciones = new List<Object>();

    /**************************************************************************************************************************************
    * @description Metodo invocado Cuando se ejecuta el servicio donde se va a armar el json con el tipo de viabildiad, el id de la oportunidad, 
    * la lista de producto si contiene cotizaciones  y la lista de lista de viabilidades si contiene if((requestBody.containsKey('listadeProduct')) y if(requestBody.containsKey('listaViabilidad')))
    */
    @HttpPost
    global static void ServiceQuote() {
        RestResponse response;
        RestRequest request;
        Map<String, Object> requestBody;
        List<Object> listaProductos;
        List<Object> listaViabilidades;
        Map<String, Object> additionalData;
        Map<String, Object> output;
        Map<String, Object> responseJSON;

        try {
            response = RestContext.response;
            response.statuscode = 200;
            request = RestContext.request;
            requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
            responseJSON = new Map<String, Object>();

            //Creación de cotizaciones
            if(requestBody.containsKey('listadeProduct')) {
                System.debug('JFRC: Tiene lista de productos');
                listaProductos = (List<Object>) requestBody.get('listadeProduct');
                additionalData = new Map<String, Object>();
                additionalData.put('orderOM', String.valueOf(requestBody.get('orderOM')));
                additionalData.put('tipoSolicitud', String.valueOf(requestBody.get('tipoSolicitud')));
                if(listaProductos != null && listaProductos.size() > 0) {
                    //Creación de las diferentes combinaciones
                    crearListaCombinaciones(listaProductos, null, String.valueOf(requestBody.get('opportunityId')));
					System.debug('JFRC: Genero las combinaciones');
                    //Creación de proceso asíncrono
                    output = new Map<String, Object>();
                    System.debug('JFRC: Manda a llamar al proceso: Lista de Productos');
                    System.debug('JFRC: ASYNC_PROCESS_COTIZACIONES--' + ASYNC_PROCESS_COTIZACIONES);
                    System.debug('JFRC: listaCotizaciones--' +listaCotizaciones );
                    System.debug('JFRC: additionalData--' + additionalData);
                    callAsyncEngine(ASYNC_PROCESS_COTIZACIONES, listaCotizaciones, additionalData, output);

                    //Generación de response para cotizaciones
                    if(output != null && !output.isEmpty()) {
                        output = (Map<String, Object>) output.get('Output');
                        if(output != null && !output.isEmpty()) {
                            responseJSON.put(ASYNC_PROCESS_COTIZACIONES, String.valueOf(output.get('asyncProcessId')));
                        }
                    }
                }
            }

            //Actualización de viabilidades
            if(requestBody.containsKey('listaViabilidad')) {
                System.debug('JFRC: Tiene lista de listaViabilidad');
                listaViabilidades = (List<Object>) requestBody.get('listaViabilidad');
                additionalData = new Map<String, Object>();
                additionalData.put('orderOM', String.valueOf(requestBody.get('orderOM')));
                additionalData.put('tipoSolicitud', String.valueOf(requestBody.get('tipoSolicitud')));
                if(listaViabilidades != null && listaViabilidades.size() > 0) {
                    //Creación de proceso asíncrono
                    output = new Map<String, Object>();
                     System.debug('JFRC: Manda a llamar al proceso: Lista de Viabilidades');
                    System.debug('JFRC: ASYNC_PROCESS_VIABILIDADES--' + ASYNC_PROCESS_VIABILIDADES);
                    System.debug('JFRC: listaViabilidades--' +listaViabilidades );
                    System.debug('JFRC: additionalData--' + additionalData);
                    callAsyncEngine(ASYNC_PROCESS_VIABILIDADES, listaViabilidades, additionalData,output);

                    //Generación de response para viabilidades
                    if(output != null && !output.isEmpty()) {
                        output = (Map<String, Object>) output.get('Output');
                        if(output != null && !output.isEmpty()) {
                            responseJSON.put(ASYNC_PROCESS_VIABILIDADES, String.valueOf(output.get('asyncProcessId')));
                        }
                    }
                }
            }

            //Generación de response
            if(!responseJSON.isEmpty()) {
                response.responseBody = Blob.valueOf(JSON.serialize(responseJSON));
            }
        }
        catch(Exception e) {
            response.statuscode = 417;
        }
    }

    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo ServiceQuote para guardar todas las combinaciones de productos posibles
    * @param listaProductosAProcesar Lista de productos que llegarán del gestor
    * @param acumulado null
    * @param opportunityId Id de la oportunidad
    */
    private static void crearListaCombinaciones(List<Object> listaProductosAProcesar, String acumulado, String opportunityId) {
        try {
            if (listaProductosAProcesar != null && listaProductosAProcesar.size() > 0) {
                Map<String, Object> productoEnProceso = (Map<String, Object>) listaProductosAProcesar.remove(0);
                String combinacion = (String.isNotBlank(acumulado)) ? acumulado + '##' : '';
    
                List<Object> listaConfiguraciones = (List<Object>) productoEnProceso.get('listaConfiguraciones');
                for (Object objConfig : listaConfiguraciones) {
                    Map<String, Object> configuracionProducto = (Map<String, Object>) objConfig;
                    Map<String, Object> productoAAgregar = new Map<String, Object>();
                    productoAAgregar.put('Operacion', productoEnProceso.get('Operacion'));
                    productoAAgregar.put('QuoteLineItemId', productoEnProceso.get('QuoteLineItemId'));
                    productoAAgregar.put('productCode', productoEnProceso.get('productCode'));
                    productoAAgregar.put('parentId', productoEnProceso.get('parentId'));
                    productoAAgregar.put('ServiceAccId', productoEnProceso.get('ServiceAccId'));
                    productoAAgregar.put('idOrigen', productoEnProceso.get('idOrigen'));
                    productoAAgregar.put('idContacto', productoEnProceso.get('idContacto'));
                    productoAAgregar.put('billingAccId', productoEnProceso.get('billingAccId'));
                    productoAAgregar.put('Quantity', configuracionProducto.get('Quantity'));
                    productoAAgregar.put('parametros', configuracionProducto.get('parametros'));                    
                    crearListaCombinaciones(listaProductosAProcesar.clone(), combinacion + JSON.serialize(productoAAgregar), opportunityId);
                }
            }
            else {
                List<Map<String, Object>> listaProductos = new List<Map<String, Object>>();
                for (String strProducto : acumulado.split('##')) {
                    Map<String, Object> mapProducto = (Map<String, Object>) JSON.deserializeUntyped(strProducto);
                    listaProductos.add(mapProducto);
                }
                Map<String, Object> mapCotizacion = new Map<String, Object>();
                mapCotizacion.put('listaProductos', listaProductos);
                mapCotizacion.put('OpportunityId', opportunityId);
                listaCotizaciones.add(mapCotizacion);                 
            }
        }
        catch(Exception e) {
            throw e;
        }
    }


    /**************************************************************************************************************************************
    * @description Metodo invocado desde el metodo ServiceQuote ejecutar los procesos asincronicos (cotizaciones y viabilidad)
    * @param asyncProcessName Variable donde se le pasa el tipo de proceso (Servicio Viabilidad - Cotizaciones ,'Servicio Viabilidad - Viabilidades')
    * @param itemsToProcessList Map<String, Object> estructura que almacena parametros de entrada pasados como argumentos desde el componente Vlocity
    * @param additionalData Map<String, Object> estructura que almacena parametros de salida enviados como respuesta desde el metodo hacia el componente Vlocity
    * @param outMap Map<String, Object> estructura que almacena la respuesta del servicio.
    */
    private static void callAsyncEngine(String asyncProcessName, List<Object> itemsToProcessList, Map<String, Object> additionalData,Map<String, Object> outMap) {
        Map<String, Object> asyncProcessRequest;
        Map<String, Object> output;
        Map<String, Object> options;
        List<Object> asyncProcessSteps;
        Map<String, Object> processStep;
        Map<String, Object> asyncJobDetails;
        Map<String, Object> startProcess;
        Map<String, Object> executeProcess;
        Map<String, Object> finishProcess;

        try {
            if(asyncProcessName.equals(ASYNC_PROCESS_COTIZACIONES)) {
                asyncProcessSteps = new List<Object>();
                processStep = new Map<String, Object>();
                processStep.put('stepName', 'Creación de cotización');
                asyncJobDetails = new Map<String, Object>();
                executeProcess = new Map<String, Object>();
                executeProcess.put('type', 'Vlocity Open Interface');
                executeProcess.put('name', 'etb_ServiceViabilityImplement');
                executeProcess.put('action', 'startJob');
                executeProcess.put('itemsToProcessPerAsyncJob', 1);
                executeProcess.put('executeAsyncJobsInSequence', true);
                executeProcess.put('asyncJobNumberOfRetriesOnFail', 0);
                //finishProcess = new Map<String, Object>();
                //finishProcess.put('type', 'Integration Procedure');
                //finishProcess.put('name', 'etb_FinishProcViabAprov');
                asyncJobDetails.put('executeProcess', executeProcess);
                //asyncJobDetails.put('finishProcess', finishProcess);
                processStep.put('asyncJobDetails', asyncJobDetails);
                asyncProcessSteps.add(processStep);
                additionalData.put('ServiceName','ServiceViability');
                additionalData.put('TypeProcess','Cotizacion');

                asyncProcessRequest = new Map<String, Object>();
                options = new Map<String, Object>();
                asyncProcessRequest.put('asyncProcessName', asyncProcessName);
                asyncProcessRequest.put('itemsToProcessList', itemsToProcessList);
                asyncProcessRequest.put('additionalData', additionalData);
                asyncProcessRequest.put('asyncProcessSteps', asyncProcessSteps);
                output = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('etb_AsyncEngine', asyncProcessRequest, options);
                System.debug('JFRC: Resultado del llamado del sync cotizaciones:--'+ output);
                outMap.put('Output',output.get('Output'));
            }
            else if(asyncProcessName.equals(ASYNC_PROCESS_VIABILIDADES)) {
                //additionalData = new Map<String, Object>();

                asyncProcessSteps = new List<Object>();
                processStep = new Map<String, Object>();
                processStep.put('stepName', 'Actualización de viabilidades');
                asyncJobDetails = new Map<String, Object>();
                executeProcess = new Map<String, Object>();
                executeProcess.put('type', 'Integration Procedure');
                executeProcess.put('name', 'etb_UpdateViabilidad');
                executeProcess.put('itemsToProcessPerAsyncJob', 1);
                executeProcess.put('executeAsyncJobsInSequence', true);
                executeProcess.put('asyncJobNumberOfRetriesOnFail', 0);
                //finishProcess = new Map<String, Object>();
                //finishProcess.put('type', 'Integration Procedure');
                //finishProcess.put('name', 'etb_FinishProcViabAprov');
                //finishProcess.put('action', 'sendEmailViabilidades');
                asyncJobDetails.put('executeProcess', executeProcess);
                //asyncJobDetails.put('finishProcess', finishProcess);
                processStep.put('asyncJobDetails', asyncJobDetails);
                asyncProcessSteps.add(processStep);
                additionalData.put('ServiceName','ServiceViability');
                additionalData.put('TypeProcess','Viabilidades');

                asyncProcessRequest = new Map<String, Object>();
                options = new Map<String, Object>();
                asyncProcessRequest.put('asyncProcessName', asyncProcessName);
                asyncProcessRequest.put('itemsToProcessList', itemsToProcessList);
                asyncProcessRequest.put('additionalData', additionalData);
                asyncProcessRequest.put('asyncProcessSteps', asyncProcessSteps);
                output = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService('etb_AsyncEngine', asyncProcessRequest, options);
                System.debug('JFRC: Resultado del llamado del sync viablilidades:--'+ output);
                outMap.put('Output',output.get('Output'));
            }
        }
        catch(Exception e) {
            System.debug('Error en el sync: ' + e.getMessage());
            throw e;
        }
    }
}