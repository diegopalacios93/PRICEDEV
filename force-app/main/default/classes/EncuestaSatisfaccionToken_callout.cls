@isTest
global class EncuestaSatisfaccionToken_callout implements HttpCalloutMock {
    private String responseType;
    public EncuestaSatisfaccionToken_callout(String responseType){
        this.responseType = responseType;
    }

    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        switch on responseType  {
            when  'WithToken' {
                response.setBody(WithToken);
                response.setStatusCode(200);
            }
            when  'WithoutToken' {
                response.setBody(WithoutToken);
                response.setStatusCode(200);
            }
        }
        
        return response; 
    }

        public String WithToken = ' { "WSResponseHeader":'+
             ' { '+
               ' "System": { ' +
               '     "name": "Salesforce", ' +
               '     "correlationID": "Salesforce-123", ' +
               '     "processingServer": ""  ' +
               ' }, ' +
               '"Service": { ' +
               '    "status": "OK", ' +
               '    "responseDate": "2021-12-16T10:10:57.3450276+00:00", ' +
               '    "processingServer": null, ' +
               '    "statusDetail": null ' +
               ' }, ' +
               ' "Property": [] ' +
               ' }, ' +
            ' "WSResponseBody": { ' + 
                ' "MinutesExpire": "1440", ' + 
                ' "SecurityToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IktPTkVDVEEiLCJuYmYiOjE2Mzk2Njc0NTcsImV4cCI6MTYzOTc1Mzg1NywiaWF0IjoxNjM5NjY3NDU3LCJpc3MiOiJodHRwOi8vYm90ZGV2LnBvcnRhbGx0ZXFhLnAuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJodHRwOi8vYm90ZGV2LnBvcnRhbGx0ZXFhLnAuYXp1cmV3ZWJzaXRlcy5uZXQifQ.IO6pk4t2TjKYmZgozC1rcFToKUQQoBFpf4VgDVweJIA" ' +
            ' } ' +
         ' } ' ; 
        

         public String WithoutToken = ' { "WSResponseHeader":'+
             ' { '+
               ' "System": { ' +
               '     "name": "Salesforce", ' +
               '     "correlationID": "Salesforce-123", ' +
               '     "processingServer": ""  ' +
               ' }, ' +
               '"Service": { ' +
               '    "status": "FAIL", ' +
               '    "responseDate": "2021-12-16T10:10:57.3450276+00:00", ' +
               '    "processingServer": null, ' +
             '    "statusDetail": [{"errorCode": "ERROR_05"}] ' +
               ' }, ' +
               ' "Property": [] ' +
               ' }, ' +
            ' "WSResponseBody": { ' + 
                ' "MinutesExpire": null, ' + 
                ' "SecurityToken": null ' +
            ' } ' +
         ' } ' ; 

}