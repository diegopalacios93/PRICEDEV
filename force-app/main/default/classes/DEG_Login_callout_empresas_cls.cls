@isTest
global class DEG_Login_callout_empresas_cls implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(

            '{'+
            ' {"Respuesta": [{'+
            '   "Nombre_emp": null,'+
            '   "Nit": null,'+
            '    "UserName": null,'+
            '    "Cuenta": null,'+
            '   "Mensaje": "Consulta Exitosa",'+
            '    "ListaCuentas": null,'+
            '    "Resultado": null,'+
            '    "UrlGestionUnificada": null'+
            '    "UrlMRTG": null'+
            ' }]'+
            '}'
        );
        res.setStatusCode(200);
        return res;
    }
}