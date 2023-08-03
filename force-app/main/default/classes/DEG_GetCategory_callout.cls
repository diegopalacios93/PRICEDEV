@isTest
global class DEG_GetCategory_callout implements HttpCalloutMock {
    private String statusStr;
    global DEG_GetCategory_callout(String statusStr){
        this.statusStr = statusStr;

    }
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        res.setBody(
            '{'+
    '"WSResponseHeader": {'+
        '"System": {"name": "DIGITAL","correlationID": "DEG-WPP-ALFANÚMERICO ","processingServer": "DIGITAL"},'+
        '"Service": {'+
            '"status": "OK",'+
            '"responseDate": "2021-03-31T10:52:27.8073943+00:00",'+
            '"processingServer": null,'+
            '"statusDetail": ['+
                '{'+
                    '"errorCode": "OK_01",'+
                    '"errorDetailCode": "La solicitud fue exitosa, el cliente fue consultado",'+
                    '"errorMessage": "La solicitud DEG-WPP-ALFANÚMERICO  fue exitosa. El cliente fue consultado."'+
                '}]'+
        '},'+
        '"Property": []'+
    '},'+
    '"WSResponseBody": {'+
        '"Address": "CL 165 50 28 IN 3 AP 410",'+
        '"Addresses": [],'+
        '"Birthday": "",'+
        '"Business": null,'+
        '"Category": "PLATA",'+
        '"City": "BOGOTA D.C.",'+
        '"City_DANE": "11001",'+
        '"City_Mongo": "5a282b36445afc416c7c2b16",'+
        '"Civil_Status": "",'+
        '"Contacts": [],'+
        '"Company_Short_Name": "UNDEFINED",'+
        '"Customer_Type": "NATURAL",'+
        '"Datacredit_Authorization": "n",'+
        '"Departament": "BOGOTA",'+
        '"Departament_DANE": "11",'+
        '"Departament_Mongo": "59484c5eec96a369378eb4c8",'+
        '"District": "FTO34",'+
        '"Document_Issuance": null,'+
        '"Document_Number": "1033698510",'+
        '"Document_Type": "CC",'+
        '"Email": "wilmer.galvism@gmail.com",'+
        '"Habeas_Data": {},'+
        '"Landline": "3057663082",'+
        '"Location": "",'+
        '"Mobile_Phone": "3057663082",'+
        '"Name": "SINLISIM GALVIS MONROY",'+
        '"Names": "SINLISIM",'+
        '"Score_FTTx": {"Date": "2019-04-25T00:00:00","Score": 900},'+
        '"Score_LTE": null,'+
        '"Second_Surname": "MONROY",'+
        '"Segment": "Hogares",'+
        '"Segment_UEN": "Hogares",'+
        '"Services": [],'+
        '"State": "ACTIVO",'+
        '"Surname": "GALVIS",'+
        '"UEN": "Hogares",'+
        '"Value": ""'+
    '}}'                
                   );

    switch on statusStr {
        when  '200' {
            res.setStatusCode(200);
        }
        when  '201' {
            res.setStatusCode(201);
        }
    }
        
        return res;
    }
}