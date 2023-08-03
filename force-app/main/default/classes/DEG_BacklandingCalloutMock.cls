@isTest
global class DEG_BacklandingCalloutMock implements WebServiceMock {
global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
    // start - specify the response you want to send
    DEG_BacklandingService.ActualizaLeadsResponse_element response_x = 
        new DEG_BacklandingService.ActualizaLeadsResponse_element();
    response_x.ActualizaLeadsResult ='ok';
    // end
    response.put('response_x', response_x);


}
}