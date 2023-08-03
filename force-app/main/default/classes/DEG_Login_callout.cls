@isTest
global class DEG_Login_callout implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(
            '{'+
            '  "WSResponseHeader": {'+
            '     "System": {'+
            '         "name": "MAX",'+
            '         "correlationID": "DE-0001",'+
            '         "processingServer": null'+
            '     },'+
            '     "Service": {'+
            '        "status": "OK",'+
            '        "responseDate": "2021-03-25T21:54:38.8825486+00:00",'+
            '        "processingServer": null,'+
            '        "statusDetail": [{'+
            '           "errorCode": "OK_01",'+
            '           "errorDetailCode": "La solicitud MIETB-25032021-16246191 fue exitosa",'+
            '           "errorMessage": "Se autenticó al usuario exitosamente"'+
            '        }]'+
            '     },'+
            '     "Property": []'+
            '  },'+
            '  "WSResponseBody": {}'+
            '}'
        
        );
        res.setStatusCode(200);
        return res;
    }
}