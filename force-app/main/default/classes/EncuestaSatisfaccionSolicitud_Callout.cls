@isTest
global class EncuestaSatisfaccionSolicitud_Callout implements HttpCalloutMock {
  
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{ "WSResponseHeader": '+
              ' { ' +
              '  "System": { '+ 
               '     "name": "Salesforce", ' +
               '     "correlationID": "Salesforce-123", ' + 
               '     "processingServer": null ' +
              ' }, ' +
               ' "Service": { ' +
                  '  "status": "OK", ' +
                  '  "responseDate": "2021-12-16T10:08:45.7317036+00:00", '  +
                  '  "processingServer": null, ' +
                  '   "statusDetail": [ '  + 
                  '  { ' +
                        '    "errorCode": "OK_01", ' +
                        '    "errorDetailCode": "La solicitud fue exitosa", ' +
                        '    "errorMessage": "La solicitud Salesforce-123 fue exitosa" '  +
                       ' } ' +
                   ' ] ' +
               ' }, ' +
               ' "Property": [] ' + 
          '  } ' +
       ' }');
        response.setStatusCode(200);
        return response; 
    }

}