/**
 * @description       : 
 * @author            : Pablo Arrieta
 * @group             : 
 * @last modified on  : 06-16-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   06-16-2021   Pablo Arrieta   Initial Version
**/
global with sharing class DEG_ConsumeOrquestador_mck implements HttpCalloutMock{
    private String responseType;
    public DEG_ConsumeOrquestador_mck(String responseType){
        this.responseType = responseType;
    }

    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        switch on responseType {
       
            when  'welcomeMessage' {
                res.setBody(welcomeMessage);
                res.setStatusCode(200);
            }

            when  'evento' {
                res.setBody(evento);
                res.setStatusCode(200);
            }
            when  'pasoagente' {
                res.setBody(pasoagente);
                res.setStatusCode(200);
            }
            when  'dateRange' {
                res.setBody(dateRange);
                res.setStatusCode(200);
            }
           
            when  'getTokenWatsonString' {
                res.setBody(getTokenWatsonString);
                res.setStatusCode(200);
            }
            when  'getSessionIdWatsonString' {
                res.setBody(getSessionIdWatsonString);
                res.setStatusCode(200);
            }
            when  'cobertura' {
                res.setBody(cobertura);
                res.setStatusCode(200);
            }
            when  'getCalloutToken' {
                res.setBody(getCalloutToken);
                res.setStatusCode(200);
            }
            when  'respuestaPipe' {
                res.setBody(respuestaPipe);
                res.setStatusCode(200);
            }
            when  'responseCalendario' {
                res.setBody(responseCalendario);
                res.setStatusCode(200);
            }
            when  'responseBtnSeleccion' {
                res.setBody(btnSeleccion);
                res.setStatusCode(200);
            }
            when  'pasoAgenteRetencion' {
                res.setBody(pasoAgenteRetencion);
                res.setStatusCode(200);
            }
            when  'responseTipoNumeroDocumento' {
                res.setBody(responseTipoNumeroDocumento);
                res.setStatusCode(200);
            }
            
        }
        return res;
    }

    public final String  responseTipoNumeroDocumento = '{"data":{"messages":[{"response_type":"text","text":"¿Quiero confirmar que el número de NIT sea el correcto 800000001? ((botones seleccion: Si; No )) {card:true}"}],"watson_session_id":"80bd09ca-1e57-4da6-b2dd-97aa74c3d8a1","client_session_id":"Etb 57029000000I4l7AAC"},"meta":{"success":true,"status":200,"message":"Successful execution"}}'; 

    public String welcomeMessage = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Datos recuperados:  * Nombres: Daniel*Apellidos: Galvis*Documento: 1213123*Celular: 3017421106*Terminos: true*Origen: etbHogares*TipoDocumento: CC * Correo: eee@gmail.com"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Bienvenido Daniel soy Max tu asistente virtual, estoy listo para ayudarte con:"'+
    '          },'+
    '          {'+
    '              "time": 2000,'+
    '              "typing": true,'+
    '              "response_type": "pause"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "((botones seleccion: Solicitar soporte técnico; Consultar factura; Consultar consumos; Solicitar Trámites; Solicitar reconexión; Adquirir nuestros servicios)) {card:true}"'+
    '          },'+
    '          {'+
    '              "time": 2000,'+
    '              "typing": true,'+
    '              "response_type": "pause"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo"'+
    '          }'+
    '      ]'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '           }'+
    '}';

    
    public String evento = '{'+   
    '   "data": {'+
    '       "messages": ['+
    '           {'+
    '               "response_type": "event",'+
    '               "id": "cobertura",'+
    '               "url": "https://hostname.domain" '+
    '           }'+
    '        ]'+
    '    },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '           }'+
    '}';
    public String dateRange = '{'+   
    '   "data": {'+
    '       "messages": ['+
    '           {'+
    '           "response_type": "event",'+
    '           "id": "rango_fechas",'+
    '           "dias": "60"'+
    '           }'+
    '        ]'+
    '    },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '           }'+
    '}';

    
    public String pasoagente = '{'+
    '   "data":{'+
    '        "messages":  ['+
    '           {'+
    '               "response_type":  "text",'+
    '               "text":  "PasoAgente_FallaWS_max_route"'+
    '           },'+
    '           {'+
    '               "response_type":  "event",'+
    '               "id":  "asesor",'+
    '               "url":  "https://asistencia.webv2.allus.com.co/WebAPI802/ChatETB/AdvancedChat/HtmlChatPanel.jsp?origen=Chat&idBot=whatsApp_573125127626&nombre=Hola  chava&tipo=CC&documento=1080363204&correo=fsdf@dd.com&asunto=HogaresMoviles&uen=&fasep=&estado=&motivoc=&segmento=movil&tecnologia=&PhoneNumber=573125127626&motivopsa=PasoAgente_FallaWS_max_route"'+
    '           }'+
    '         ]'+
    '   },'+
    '       "meta":  {'+
    '           "success":  true,'+
    '           "status":  200,'+
    '           "message":  "Successful  execution"'+
    '       }'+
    '  }';
        
    
    

    public String getTokenWatsonString = '{'+
    '    "data": [ '+
    '       {'+
    '           "user": "digital.dev",'+
    '           "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJib3QiOiJrb25lY3RhLWV0YiIsInNpdGUiOiI2MkxiQjgwY0pCQSIsImNvbnYiOiIzTzNwVVd3dk9zeFRWUkVpbU9HUzZqLUEiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvZXRiLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC9ldGIvIiwidXNlciI6ImRpZ2l0YWwuZGV2IiwiaWF0IjoxNjE4MjQ0OTA4LCJleHAiOjE2MTgzMzEzMDh9.-xmRo3Aw2kcEErs96bCXi2JRXf-wCImGl4ICE8LD-MQ",'+
    '           "expiration": "2021-04-13T16:28:28.000"'+
    '       }'+
    '    ],'+
    '    "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful Authentication"'+
    '    }'+
    ' }';

    public String getSessionIdWatsonString = '{'+
    '    "data": { '+
    '       "session_id": "40a731d1-013c-4809-a3e1-4aad52bfd49a",'+
    '       "session_date": "2021-04-13T16:46:17.343",'+
    '       "session_expires": "2021-04-13T16:56:17.347",'+
    '       "session_status": "Created"'+
    '    },'+
    '    "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '    }'+
    ' }';

    public String cobertura = '{'+
    '    "data":{'+
    '      "messages":['+
    '          {'+
    '            "response_type":"text",'+
    '            "text":"La dirección de tu predio es: AC 13 18 90 &#124;&#124; ¿Es correcta? ((botones seleccion: Confirmar dirección; Modificar dirección)) "'+
    '          },'+
    '          {'+
    '            "response_type":"event",'+
    '            "closeIframe":true'+
    '          }'+
    '       ]'+
    '    },'+
    '    "meta":{'+
    '       "success":true,'+
    '       "status":200,'+
    '       "message":"Successful execution"'+
    '    }'+
    ' }';

    public String getCalloutToken = '{'+
    '    "WSResponseHeader": {'+
    '        "System": {'+
    '            "name": "DIGITAL",'+
    '            "correlationID": "DEG-WEB-57029000000Hw0IAAS",'+
    '            "processingServer": null'+
    '        },'+
    '        "Service": {'+
    '            "status": "OK",'+
    '            "responseDate": "2021-04-15T14:51:39.9852057+00:00",'+
    '            "processingServer": null,'+
    '            "statusDetail": ['+
    '                {'+
    '                    "errorCode": "OK_01",'+
    '                    "errorDetailCode": "La solicitud fue exitosa, el cliente fue consultado",'+
    '                    "errorMessage": "La solicitud DEG-WEB-57029000000Hw0IAAS fue exitosa. El cliente fue consultado."'+
    '                }'+
    '            ]'+
    '        },'+
    '        "Property": []'+
    '    },'+
    '    "WSResponseBody": {'+
    '        "Address": "CRA 8 20 00",'+
    '        "Addresses": ['+
    '            {'+
    '                "Address": "CRA 8 20 00",'+
    '                "Address_Type": "CORRESPONDENCIA",'+
    '                "Departament": "BOGOTA",'+
    '                "Id": 402,'+
    '                "Name": null,'+
    '                "Selected": false,'+
    '                "State": null,'+
    '                "Town": "BOGOTA D.C."'+
    '            },'+
    '            {'+
    '                "Address": "CRA 8 20 00",'+
    '                "Address_Type": "CORRESPONDENCIA",'+
    '                "Departament": "BOGOTA",'+
    '                "Id": 402,'+
    '                "Name": null,'+
    '                "Selected": false,'+
    '                "State": null,'+
    '                "Town": "BOGOTA D.C."'+
    '            }'+
    '        ],'+
    '        "Birthday": null,'+
    '        "Business": null,'+
    '        "Category": "",'+
    '        "City": "BOGOTA D.C.",'+
    '        "City_DANE": "11001",'+
    '        "City_Mongo": "5a282b36445afc416c7c2b16",'+
    '        "Civil_Status": null,'+
    '        "Contacts": ['+
    '            {'+
    '                "Address": "",'+
    '                "Authorized": false,'+
    '                "Document_Number": "3058629484",'+
    '                "Document_Type": "CC",'+
    '                "Habeas_Data": null,'+
    '                "Name": "Hernan",'+
    '                "Second_Surname": "",'+
    '                "Surname": "Valero",'+
    '                "Email": "hernanv80@hotmail.com"'+
    '            },'+
    '            {'+
    '                "Address": "",'+
    '                "Authorized": false,'+
    '                "Document_Number": "1213123",'+
    '                "Document_Type": "CC",'+
    '                "Habeas_Data": {'+
    '                    "Canal": "Tienda",'+
    '                    "Decision": "AUTORIZACION",'+
    '                    "Decision_Date": "2021-03-30T14:27:05.907Z",'+
    '                    "Id_PQR": "MDM-PQR-4047925"'+
    '                },'+
    '                "Name": "eeee",'+
    '                "Second_Surname": "",'+
    '                "Surname": "eeee",'+
    '                "Email": "wwww@eee.com"'+
    '            },'+
    '            {'+
    '                "Address": "",'+
    '                "Authorized": false,'+
    '                "Document_Number": "10333698510",'+
    '                "Document_Type": "CC",'+
    '                "Habeas_Data": {'+
    '                    "Canal": "TIENDA",'+
    '                    "Decision": "AUTORIZACION",'+
    '                    "Decision_Date": "2020-11-25T10:10:24.101Z",'+
    '                    "Id_PQR": "MDM-PQR-4020990"'+
    '                },'+
    '                "Name": "eeee",'+
    '                "Second_Surname": "",'+
    '                "Surname": "eeee",'+
    '                "Email": "wwww@eee.com"'+
    '            }'+
    '        ],'+
    '        "Company_Short_Name": null,'+
    '        "Customer_Type": "NATURAL",'+
    '        "Datacredit_Authorization": null,'+
    '        "Departament": "BOGOTA",'+
    '        "Departament_DANE": "11",'+
    '        "Departament_Mongo": "59484c5eec96a369378eb4c8",'+
    '        "District": null,'+
    '        "Document_Issuance": null,'+
    '        "Document_Number": "16077158",'+
    '        "Document_Type": "CC",'+
    '        "Email": "pruebas@hotmail.com",'+
    '        "Habeas_Data": null,'+
    '        "Landline": "17485784",'+
    '        "Location": null,'+
    '        "Mobile_Phone": "3005454545",'+
    '        "Name": "HERNAN DARIO VALERO DIAZ",'+
    '        "Names": "HERNAN DARIO",'+
    '        "Score_FTTx": null,'+
    '        "Score_LTE": null,'+
    '        "Second_Surname": "DIAZ",'+
    '        "Segment": "Hogares",'+
    '        "Segment_UEN": "Hogares",'+
    '        "Services": ['+
    '            {'+
    '                "BillingAccount": "12051832788",'+
    '                "Line_Type": "",'+
    '                "Phone": "",'+
    '                "Principal_State": "Activo",'+
    '                "Product": null,'+
    '                "Technology": "FTTH",'+
    '                "Type": "Titular"'+
    '            },'+
    '            {'+
    '                "BillingAccount": "12051832788",'+
    '                "Line_Type": "",'+
    '                "Phone": "",'+
    '                "Principal_State": "Activo",'+
    '                "Product": null,'+
    '                "Technology": "FTTH",'+
    '                "Type": "Titular"'+
    '            }'+
    '        ],'+
    '        "State": null,'+
    '        "Surname": "VALERO",'+
    '        "UEN": "Hogares",'+
    '        "Value": null'+
    '    }'+
    '}';
    public String respuestaPipe='{'+
    '   "data": {'+
    '       "messages": ['+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Es importante que sepas que con tu servicio móvil puedes alcanzar máximo 10.000 Kb en descarga, los TyC se encuentran publicados el siguiente enlace https://etb.com/tyc.aspx "'+
    '           },'+
    '           {'+
    '               "time": 7000,'+
    '               "typing": true,'+
    '               "response_type": "pause"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "La velocidad de tu servicio móvil depende de la condiciones de red en la cobertura que te encuentres 4G LTE, 3G y 2G, aquí podrás validar la zona de cobertura http://etbserver.etb.co/cobertura4G/   \n\nQuiero darte algunos consejos para intentar solucionar la falla en tus datos móviles 📱"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Fallas técnicas : Soporte Datos📱((video:,\nhttps://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2)) {card:true} ((boton enlace: Ampliar video, https://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2))"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Fallas técnicas : Soporte Datos📱((imagen:,\nhttps://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2)) {card:true} || ((boton enlace: Ampliar video, https://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2))"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "¿Con alguno de estos consejos pudiste solucionar la falla? || ((botones seleccion: Si;No)) {card:true}"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "¿Con alguno de estos consejos pudiste solucionar la falla? || ((botones sugerencia: Si;No)) {card:true}"'+
    '           }'+
    '       ],'+
    '       "watson_session_id": "2bbbb85f-c678-4db3-a3cd-4c1c87e1284e",'+
    '       "client_session_id": "Etb 12298791-1122211"'+
    '   },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '   }'+
    '}';
    public String responseCalendario='{'+
    '  "data": {"messages":    ['+
    '           {'+
    '        "time": 1000,'+
    '        "typing": true,'+
    '        "response_type": "pause"'+
    '     },'+
    '           {'+
    '        "response_type": "text",'+
    '        "text": "En la ventana del lado izquierdo, por favor selecciona la fecha para que tu portabilidad quede cumplida."'+
    '     },'+
    '           {'+
    '        "response_type": "event",'+
    '        "id": "calendario_web",'+
    '        "url": "calendario",'+
    '        "dias_permitidos":          ['+
    '           {"Date": "2021-03-11"},'+
    '           {"Date": "2021-03-24"},'+
    '           {"Date": "2021-03-26"},'+
    '           {"Date": "2021-05-19"}'+
    '        ]'+
    '     }'+
    '  ]},'+
    '  "meta":    {'+
    '     "success": true,'+
    '     "status": 200,'+
    '     "message": "Successful execution"'+
    '  }'+
    '}';
    public String btnSeleccion = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Nos encanta que quieras hacer parte de los nuestros. Por favor haz clic en el siguiente botón  y déjanos tu número celular, un especialista de ventas te contactará para brindarte toda la información de nuestros planes y servicios. ((boton enlace: Conoce nuestros planes,https://bit.ly/3rptzMt)){card:true}"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "¿Tienes alguna consulta adicional? ((botones sugerencia: Si; No)) {card:true}"'+
    '          }'+
    '      ],'+
    '      "watson_session_id": "d8292165-bf72-4a73-9c23-b69baaad5e05",'+
    '      "client_session_id": "Etb 57029000000HwstAAC"'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  } '+
    '}';
    public String pasoAgenteRetencion = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "PasoAgente_Retenciones"'+
    '          },'+
    '          {'+
    '              "response_type": "event",'+
    '              "id": "asesor",'+
    '              "url": "https://asistencia.webv2.allus.com.co/WebAPI802/ChatETB/AdvancedChat/HtmlChatPanel.jsp?origen=Chat&idBot=Etb 57029000000HwxQAAS&nombre=William Castiblanco&tipo=paola.marin@grupokonecta.co&documento=675675&correo=57029000000HwxQAAS&asunto=HogaresRetencion&uen=HOGARES&fasep=Identificación necesidad&estado=Activo&motivoc=&segmento=movil&tecnologia=LTE&PhoneNumber=null&motivopsa=PasoAgente_Retenciones"'+
    '          }'+
    '      ],'+
    '      "watson_session_id": "e203f764-7448-45a3-9165-ed2e26d61076",'+
    '      "client_session_id": "Etb 57029000000HwxQAAS"'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
}