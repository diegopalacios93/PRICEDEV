@isTest
global with sharing class DEG_ConsumeOrquestadorAsyncWhatsApp_mck implements HttpCalloutMock{
    private String responseType;
    public DEG_ConsumeOrquestadorAsyncWhatsApp_mck(String responseType){
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
            when  'mensajeVideoWsp' {
                res.setBody(mensajeVideoWsp);
                res.setStatusCode(200);
            }
            when  'infousuario' {
                res.setBody(infousuario);
                res.setStatusCode(200);
            }
            when  'whatappButtons' {
                res.setBody(whatappButtons);
                res.setStatusCode(200);
            }
            when  'eventoWhatApp' {
                res.setBody(eventoWhatApp);
                res.setStatusCode(200);
            }
            when  'askDocTypeResponseBussiness' {
                res.setBody(askDocTypeResponseBussiness);
                res.setStatusCode(200);
            }
            when  'askDocNumberResposeBussiness' {
                res.setBody(askDocNumberResposeBussiness);
                res.setStatusCode(200);
            }
            when  'confirmationResponseBussiness' {
                res.setBody(confirmationResponseBussiness);
                res.setStatusCode(200);
            }
            when  'askNameRequestResponse' {
                res.setBody(askNameRequestResponse);
                res.setStatusCode(200);
            }
            when  'askLastNameRequestResponse' {
                res.setBody(askLastNameRequestResponse);
                res.setStatusCode(200);
            }
            when  'askDocumentTypeResponse' {
                res.setBody(askDocumentTypeResponse);
                res.setStatusCode(200);
            }
            when  'askDocumentNumberResponse' {
                res.setBody(askDocumentNumberResponse);
                res.setStatusCode(200);
            }
            when  'askEmailResponse' {
                res.setBody(askEmailResponse);
                res.setStatusCode(200);
            }
            when  'askTermsAndConditions' {
                res.setBody(askTermsAndConditions);
                res.setStatusCode(200);
            }
            when  'confirmationResponse' {
                res.setBody(confirmationResponse);
                res.setStatusCode(200);
            }
            when  'motivoContacto' {
                res.setBody(motivoContacto);
                res.setStatusCode(200);
            }
            when  'pasoagente' {
                res.setBody(pasoagente);
                res.setStatusCode(200);
            }
            when  'requestManagementError' {
                res.setBody(requestManagementError);
                res.setStatusCode(401);
            }
            when 'fueradeHorario'{
                res.setBody(fueradeHorario);
                res.setStatusCode(200);
            }
            when  'infogeneral' {
                res.setBody(infoGeneral);
                res.setStatusCode(200);
            }
        }
        return res;
    }
    String welcomeMessage = '{'+
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


    String whatappButtons = '{'+
    '   "data": {'+
    '       "messages": ['+
    '           {'+
    '               "response_type": "text",'+
    '               "text": null'+
    '           },'+
    '           {  '+
    '               "response_type": "text",'+
    '               "text": "Selecciona tu tipo de documento ((botones seleccion: NIT; CC; CE; RUT; PASAPORTE; TARJETA DE IDENTIDAD)) {card:true}"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Es importante que aceptes nuestros términos y condiciones, puedes consultarlos en el siguiente link. "'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "https://bit.etb.com/2JTveql"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "¿Aceptas? ((botones sugerencia: Sí; No)) {card:true}"'+
    '           }'+
    '        ]'+
    '    },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '           }'+
    '}';
    String eventoWhatApp = '{'+
    '   "data": {'+
    '       "messages": ['+
    '         {'+
    '           "response_type": "text",'+
    '           "text": "Rodrigo para consultar los servicios que Etb puede instalar en tu predio, debo validar la cobertura, es decir, conocer la tecnología que tenemos disponible. "'+
    '          },'+
    '          {'+
    '              "time": 2000,'+
    '              "typing": true,'+
    '              "response_type": "pause"'+
    '          },'+
    '          {'+
    '              "time": 1000,'+
    '              "typing": true,'+
    '              "response_type": "pause"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "En este momento ve al siguiente link https://portaldireccioneswidgetinteg.portallteqa.p.azurewebsites.net/login?token=QjBNNy9uL090V0lBR3ErVW5TcVE0RncxaDA1ZUdsQWYzN2t3cjhmcmNnM3orWGtSUkJnZnFnPT0=&cobertura=true&id=MAX-488cc4ee-b685-4209-91eb-ae8935b835ce&idConversacion=whatsapp_3125127626&Canal=5d8NYNHckbIzBCyruR/U7Q==&nombreBot=Max&palabraClave=Cobertura&palabraClaveCancelacion=CoberturaCancelacion&palabraClaveTimeout=CoberturaTimeout para que ingreses tu dirección."'+
    '          },'+
    '          {'+
    '              "response_type": "event",'+
    '              "id": "cobertura",'+
    '              "url": "https://portaldireccioneswidgetinteg.portallteqa.p.azurewebsites.net/login?token=QjBNNy9uL090V0lBR3ErVW5TcVE0RncxaDA1ZUdsQWYzN2t3cjhmcmNnM3orWGtSUkJnZnFnPT0=&cobertura=true&id=MAX-488cc4ee-b685-4209-91eb-ae8935b835ce&idConversacion=whatsapp_3125127626&Canal=5d8NYNHckbIzBCyruR/U7Q==&nombreBot=Max&palabraClave=Cobertura&palabraClaveCancelacion=CoberturaCancelacion&palabraClaveTimeout=CoberturaTimeout"'+
    '           }'+
    '       ]'+
    '   },'+
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

    public String motivoContacto = '{'+
    '   "data":{'+
    '        "messages":  ['+
    '           {'+
    '               "response_type":  "text",'+
    '               "text":  "MotivoContacto_Informacion_factura"'+
    '           },'+
    '           {'+
    '               "response_type":  "event",'+
    '               "id":  "asesor",'+
    '               "url":  ""'+
    '           }'+
    '         ]'+
    '   },'+
    '       "meta":  {'+
    '           "success":  true,'+
    '           "status":  200,'+
    '           "message":  "Successful  execution"'+
    '       }'+
    '  }';

    String mensajeVideoWsp = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Te entiendo, antes de continuar quisiera darte algunos consejos para intentar solucionar la falla en tu voz móvil. "'+
    '          },'+
    '          {'+
    '              "time": 3000,'+
    '              "typing": true,'+
    '              "response_type": "pause"'+
    '          },'+
    '          {'+
    '               "response_type": "text",'+
    '               "text": "Fallas técnicas : Soporte Datos📱((video:,\nhttps://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2)) {card:true} ((boton enlace: Ampliar video, https://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2))"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Fallas técnicas : Soporte Datos📱((imagen:,\nhttps://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2)) {card:true} || ((boton enlace: Ampliar video, https://www.youtube.com/watch?v=Ck7GvmE57PM&list=PL2ln7GlIrPsacEVHiqWdyfNKgjPwc0LSv&index=2))"'+
    '           },'+
    '          {'+
    '              "time": 1000,'+
    '              "typing": true,'+
    '              "response_type": "pause"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "¿Con alguno de estos consejos pudiste solucionar la falla? ((botones seleccion: Si; No)) {card:true}"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Estoy listo para ayudarte con: ((botones seleccion: Solicitar soporte técnico; Consultar factura; Consultar consumos; Solicitar Trámites; Solicitar reconexión; Adquirir nuestros servicios)) {card:true} || Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo."'+
    '          },'+
    '          {'+
    '              "response_type": "event",'+
    '              "id": "asesor",'+
    '              "url": "https://asistencia.webv2.allus.com.co/WebAPI802/ChatETB/AdvancedChat/HtmlChatPanel.jsp?origen=Chat&idBot=whatsApp_573125127626&nombre=Hola chava&tipo=CC&documento=1080363204&correo=fsdf@dd.com&asunto=HogaresMoviles&uen=&fasep=&estado=&motivoc=&segmento=movil&tecnologia=&PhoneNumber=573125127626&motivopsa=PasoAgente_FallaWS_max_route"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "INFOUSUARIO_BELLE MARIE::OLIVOS MENDOZA::5730570004::99103420::CC::victor.aparicio@tivit.com"'+
    '          }'+
    '      ]'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
    
    String infousuario = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "\"INFOUSUARIO_BELLE MARIE::OLIVOS MENDOZA::573057000430::99103420::CC::victor.aparicio@tivit.com"'+
    '          },'+
    '      ]'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
    
    
    String error = '<!DOCTYPE html>'+
    '   <html>'+
    '   '+
    '   <head>'+
    '       <meta name="viewport" content="width=device-width, initial-scale=1">'+
    '       <meta charset="utf-8">'+
    '       <title>Application Error</title>'+
    '       <style media="screen">'+
    '           html,'+
    '           body,'+
    '           iframe {'+
    '               margin: 0;'+
    '               padding: 0;'+
    '           }'+
    '   '+
    '           html,'+
    '           body {'+
    '               height: 100%;'+
    '               overflow: hidden;'+
    '           }'+
    '   '+
    '           iframe {'+
    '               width: 100%;'+
    '               height: 100%;'+
    '               border: 0;'+
    '           }'+
    '       </style>'+
    '   </head>'+
    '   '+
    '   <body>'+
    '       <iframe src="//www.herokucdn.com/error-pages/application-error.html"></iframe>'+
    '   </body>'+
    '   '+
    '   </html>';

    String askDocTypeResponseBussiness ='{'+
    '       "data": {'+
    '           "messages": ['+
    '               {'+
    '                   "response_type": "text",'+
    '                   "text": "En nombre del equipo de Empresas y Ciudades inteligentes le damos la bienvenida."'+
    '               },'+
    '               {'+
    '                   "response_type": "text",'+
    '                   "text": "Para comenzar, por favor indíqueme el tipo de documento  de su compañía ((botones seleccion: NIT; CC; CE)) {card:true}"'+
    '               }'+
    '           ]'+
    '       },'+
    '       "meta": {'+
    '           "success": true,'+
    '           "status": 200,'+
    '           "message": "Successful execution"'+
    '       }'+
    '   }';

    String askDocNumberResposeBussiness = '{'+
    '    "data": {'+
    '        "messages": ['+
    '            {'+
    '                "response_type": "text",'+
    '                "text": "Señor(a), me informa el número de NIT"'+
    '            }'+
    '        ]'+
    '    },'+
    '    "meta": {'+
    '        "success": true,'+
    '        "status": 200,'+
    '        "message": "Successful execution"'+
    '    }'+
    '}';

    String confirmationResponseBussiness = '{'+
    '   "data": {'+
    '       "messages": ['+
    '           {'+
    '               "time": 3000,'+
    '               "typing": true,'+
    '               "response_type": "pause"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Para orientar mejor la atención que le vamos a brindar, por favor infórmenos si requiere atención posventa o atención de soporte técnico ((botones seleccion: Posventa; Soporte Técnico)) {card:true}"'+
    '           }'+
    '       ]'+
    '   },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '   }'+
    ' }';
    /* Flujo WhatsApp Masivo  */
    String askNameRequestResponse ='{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Bienvenido soy Max tu asistente virtual y estoy aquí para ayudarte con tus solicitudes. Por favor escribe tu primer nombre"'+
    '          }'+
    '      ]'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
    String askLastNameRequestResponse = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Ahora tu apellido"'+
    '          }'+
    '      ]'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
    String askDocumentTypeResponse = '{'+
    '   "data": {'+
    '       "messages": ['+
    '           {  '+
    '               "response_type": "text",'+
    '               "text": "Selecciona tu tipo de documento ((botones seleccion: NIT; CC; CE; RUT; PASAPORTE; TARJETA DE IDENTIDAD)) {card:true}"'+
    '           }'+
    '        ]'+
    '    },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 200,'+
    '       "message": "Successful execution"'+
    '           }'+
    '   }';
    String  askDocumentNumberResponse= '{'+
    '    "data": {'+
    '        "messages": ['+
    '            {'+
    '                "response_type": "text",'+
    '                "text": "¿Cuál es tu número de documento?"'+
    '            }'+
    '        ]'+
    '    },'+
    '    "meta": {'+
    '        "success": true,'+
    '        "status": 200,'+
    '        "message": "Successful execution"'+
    '    }'+
    '}';
    String askEmailResponse =  '{'+
    '     "data": {'+
    '         "messages": ['+
    '             {'+
    '                 "response_type": "text",'+
    '                 "text": "¿Cuál es tu correo electrónico? "'+
    '             }'+
    '         ]'+
    '     },'+
    '     "meta": {'+
    '         "success": true,'+
    '         "status": 200,'+
    '         "message": "Successful execution"'+
    '     }'+
    ' }';
    String askTermsAndConditions = '{'+
    '  "data": {'+
    '      "messages": ['+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "Es importante que aceptes nuestros términos y condiciones, puedes consultarlos en el siguiente link. "'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "https://bit.etb.com/2JTveql"'+
    '          },'+
    '          {'+
    '              "response_type": "text",'+
    '              "text": "¿Aceptas? ((botones sugerencia: Sí; No)) {card:true}"'+
    '          }'+
    '      ]'+
    '  },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
    String confirmationResponse = '{'+
    '    "data": {'+
    '        "messages": ['+
    '            {'+
    '                "response_type": "text",'+
    '                "text": "Estoy listo para ayudarte con: ((botones seleccion: Solicitar soporte técnico; Consultar factura; Consultar consumos; Solicitar Trámites; Solicitar reconexión; Adquirir nuestros servicios)) {card:true} || Si tu inquietud no está dentro de las opciones, escríbela en un solo párrafo."'+
    '            },'+
    '            {'+
    '                "response_type": "text",'+
    '                "text": "Una vez hayas dado respuesta a alguna de mis preguntas, te pido me des un momento para consultar la información y poder continuar con nuestra conversación."'+
    '            }'+
    '        ]'+
    '    },'+
    '    "meta": {'+
    '        "success": true,'+
    '        "status": 200,'+
    '        "message": "Successful execution"'+
    '    }'+
    '}';
    String requestManagementError = '{'+
    '   "data": {'+
    '       "messages": ['+
    '           {'+
    '               "response_type": "text",'+
    '               "text": null'+
    '           },'+
    '           {  '+
    '               "response_type": "text",'+
    '               "text": "Selecciona tu tipo de documento ((botones seleccion: NIT; CC; CE; RUT; PASAPORTE; TARJETA DE IDENTIDAD)) {card:true}"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "Es importante que aceptes nuestros términos y condiciones, puedes consultarlos en el siguiente link. "'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "https://bit.etb.com/2JTveql"'+
    '           },'+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "¿Aceptas? ((botones sugerencia: Sí; No)) {card:true}"'+
    '           }'+
    '        ]'+
    '    },'+
    '   "meta": {'+
    '       "success": true,'+
    '       "status": 401,'+
    '       "message": "Error"'+
    '           }'+
    '}';
    String fueradeHorario = '{'+
    '    "data": {'+
    '       "messages": ['+
    '           {'+
    '               "response_type": "text",'+
    '               "text": "FueradeHorario"'+
    '           }'+
    '        ]'+
    '      }'+
    '}';
    public String infoGeneral = '{'+
    '    "data": {'+
    '       "messages": ['+
    '           {'+
    '    			"response_type": "text",'+
    '               "text": "InfoGeneral",'+
    '               "InfoGeneral":{'+
    '                   "Telefono":"3121212332",'+
    '                   "Tecnologia":"FTTH",'+
    '                   "Segmento":"Masivo"'+
    '               }'+
    '           }'+
    '       ]'+
    '   },'+
    '  "meta": {'+
    '      "success": true,'+
    '      "status": 200,'+
    '      "message": "Successful execution"'+
    '  }'+
    '}';
}