/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Samuel Rodríguez
Proyecto:           INI26058 - C.D. Ajuste Proceso Batch Cargue de Activos Salesforce - MDM
Descripción:        Clase para integrar online la creación y actualización de Clientes y Contactos desde Salesforce a MDM.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2020-10-22      Samuel Rodríguez (SR)       Creación de la clase.
***********************************************************************************************************************/
public without sharing class IntegracionMDMDataServices_cls {
    
    
    public void InsertarDatosCuenta(Account sglAccount,String set_type){
                 
    	String now = '';
        String xml = '';
        Boolean ServiciosPS = false;
        Map<String,String> AccountData = new Map<String,String>();
        
        now = System.now().format('yyyy-MM-dd') + 'T' + System.now().format('HH:mm:ss') + '.000Z';
        AccountData = ObtenerDatosCuenta(sglAccount);
        ServiciosPS = ValidarserviciosCuenta(sglAccount.Id);
        xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mdm="http://www.etb.com.co/Gateway/MDM_Data_Services">';
                  xml+='<soapenv:Header/>';
                       xml+='<soapenv:Body>';
                          xml+='<mdm:Set_Customer>';
                             xml+='<mdm:WSRequestHeader>';
                                xml+='<mdm:system>';
                                   xml+='<mdm:name>Salesforce</mdm:name>';
                                   xml+='<mdm:correlationId>' +sglAccount.AccountNumber +'</mdm:correlationId>';
                                    xml+='<mdm:processingServer>MDM</mdm:processingServer>';
                                xml+='</mdm:system>';
                              xml+='</mdm:WSRequestHeader>';
                             xml+='<mdm:WSRequestBody>';
               					if(set_type=='U'){
                                	xml+='<mdm:Id>' + AccountData.get('Identificador_Cuenta_Mongo__c') + '</mdm:Id>';
                                }else{
                                    xml+='<mdm:Id></mdm:Id>';
                                }
                                xml+='<mdm:Tipo_Documento>' + sglAccount.Tipodedocumento__c +'</mdm:Tipo_Documento>';
                                xml+='<mdm:Tipo_Cliente>' + sglAccount.Segmento__c +'</mdm:Tipo_Cliente>';
                                xml+='<mdm:Numero_Identificacion>' + sglAccount.AccountNumber +'</mdm:Numero_Identificacion>';
                                xml+='<mdm:Nombre_Cliente>' + sglAccount.Name +'</mdm:Nombre_Cliente>';
                                xml+='<mdm:Estado>' + sglAccount.Estado_Cuenta__c +'</mdm:Estado>';
                                xml+='<mdm:Segmento>' + sglAccount.SubSegmento__c +'</mdm:Segmento>';
                                xml+='<mdm:Segmento_UEN>' + sglAccount.Segmento__c +'</mdm:Segmento_UEN>';
                                xml+='<mdm:UEN>' + sglAccount.UEN__c + '</mdm:UEN>';
                                if(sglAccount.ValordeCliente__c != Null && sglAccount.ValordeCliente__c != ''){
                                    xml+='<mdm:Cliente_Valor>' + sglAccount.ValordeCliente__c +'</mdm:Cliente_Valor>';
                                }
       							if(sglAccount.Phone != Null && sglAccount.Phone != ''){
                                	xml+='<mdm:Telefono_Fijo>' + sglAccount.Phone +'</mdm:Telefono_Fijo>';
                                }
       						    if(sglAccount.Telefonodecontacto1__c != Null && sglAccount.Telefonodecontacto1__c != ''){
                                	xml+='<mdm:Telefono_Movil>' + sglAccount.Telefonodecontacto1__c +'</mdm:Telefono_Movil>';
                                }
         						if(sglAccount.OtroTelefonodecontacto2__c != Null && sglAccount.OtroTelefonodecontacto2__c != ''){
                               		xml+='<mdm:Telefono_Movil2>' + sglAccount.OtroTelefonodecontacto2__c +'</mdm:Telefono_Movil2>';
                                }
                                //xml+='<mdm:Correo_Electronico></mdm:Correo_Electronico>';
                                xml+='<mdm:Direccion>' + sglAccount.Direccion__c +'</mdm:Direccion>';
                                //xml+='<mdm:Cobertura></mdm:Cobertura>';
                                xml+='<mdm:Codigo_Dane_Ciudad>' + AccountData.get('CodigoDane__c') + '</mdm:Codigo_Dane_Ciudad>';
                                xml+='<mdm:Barrio>' + sglAccount.Departamento__c +'</mdm:Barrio>';
                                //xml+='<mdm:Localidad></mdm:Localidad>';
                                //xml+='<mdm:Estrato></mdm:Estrato>';
                                xml+='<mdm:Usuario_Creador>' + sglAccount.CreatedById +'</mdm:Usuario_Creador>';
                                xml+='<mdm:Usuario_Modificador>' + sglAccount.LastModifiedById +'</mdm:Usuario_Modificador>';
                                //xml+='<mdm:Autorizacion_Datacredito></mdm:Autorizacion_Datacredito>';
                                //xml+='<mdm:Fecha_Expedicion_Documento></mdm:Fecha_Expedicion_Documento>';
                                //xml+='<mdm:Fecha_Nacimiento></mdm:Fecha_Nacimiento>';
                                //xml+='<mdm:Genero></mdm:Genero>';
                                //xml+='<mdm:Rango_Edad></mdm:Rango_Edad>';
                                //xml+='<mdm:Estado_Civil></mdm:Estado_Civil>';
                                //xml+='<mdm:Ciudad_Exp_Documento></mdm:Ciudad_Exp_Documento>';
                                //xml+='<mdm:Depto_Exp_Documento></mdm:Depto_Exp_Documento>';
                                xml+='<mdm:Scoring>Ninguno</mdm:Scoring>';
                                //xml+='<mdm:Tipo_Scoring></mdm:Tipo_Scoring>';
                                //xml+='<mdm:Clasificacion_Scoring></mdm:Clasificacion_Scoring>';
                                //xml+='<mdm:Fecha_Scoring></mdm:Fecha_Scoring>';
                                xml+='<mdm:Sistema_Origen>Salesforce</mdm:Sistema_Origen>';
       						    xml+='<mdm:set_type>' + set_type +'</mdm:set_type>';
       							if(sglAccount.Primer_Nombre__c != Null && sglAccount.Primer_Nombre__c != ''){
                                	xml+='<mdm:Nombres>' + sglAccount.Primer_Nombre__c +'</mdm:Nombres>';
        						}
        						if(sglAccount.Primer_Apellido__c != Null && sglAccount.Primer_Apellido__c != ''){
                                	xml+='<mdm:Primer_Apellido>' + sglAccount.Primer_Apellido__c +'</mdm:Primer_Apellido>';
        						}
        						if(sglAccount.Segundo_Apellido__c != Null && sglAccount.Segundo_Apellido__c != ''){
                                	xml+='<mdm:Segundo_Apellido>' + sglAccount.Segundo_Apellido__c +'</mdm:Segundo_Apellido>';
        						}
                                if(sglAccount.Autoriza_Tratamiento_de_Datos_Personales__c != Null && sglAccount.Autoriza_Tratamiento_de_Datos_Personales__c != ''){
                                    xml+='<mdm:ATDP>';
                                     if(sglAccount.Autoriza_Tratamiento_de_Datos_Personales__c == 'No' || sglAccount.Autoriza_Tratamiento_de_Datos_Personales__c == 'Ninguno'){
                                       xml+='<mdm:HABEAS_DATA>false</mdm:HABEAS_DATA>';
                                     }else{
                                       xml+='<mdm:HABEAS_DATA>true</mdm:HABEAS_DATA>';
                                     }
                                       xml+='<mdm:FECHA>'+ now +'</mdm:FECHA>';
                                       //xml+='<mdm:USUARIO></mdm:USUARIO>';
                                       //xml+='<mdm:CANAL></mdm:CANAL>';
                                       //xml+='<mdm:PQR_ASOCIADA></mdm:PQR_ASOCIADA>';
                                    xml+='</mdm:ATDP>';
                                }
                                if(sglAccount.ValordeCliente__c != Null && sglAccount.ValordeCliente__c != ''){
                                    xml+='<mdm:Categoria>' + sglAccount.ValordeCliente__c +'</mdm:Categoria>';
                                }
                                if(sglAccount.Esquema_de_Atencion__c != Null && sglAccount.Esquema_de_Atencion__c != ''){
                                    xml+='<mdm:EsquemaAtencion>' + sglAccount.Esquema_de_Atencion__c +'</mdm:EsquemaAtencion>';
                                }
								xml+='<mdm:ServiciosPS>' + ServiciosPS +'</mdm:ServiciosPS>';
                             xml+='</mdm:WSRequestBody>';
                          xml+='</mdm:Set_Customer>';
                       xml+='</soapenv:Body>';
                    xml+='</soapenv:Envelope>';
         
        	system.debug('DatosCuenta--> Request > '+ xml);
            GenerarIntegracionServiciosSet(xml,'Cuenta',sglAccount.Id); 
        
     }
    
    
    public void ObtenerCliente(Account sglAccount){
        
        String xml = '';
        
        xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mdm="http://www.etb.com.co/Gateway/MDM_Data_Services">';
                   xml+='<soapenv:Header/>';
                   xml+='<soapenv:Body>';
                      xml+='<mdm:Get_Customer>';
                         xml+='<mdm:WSRequestHeader>';
                            xml+='<mdm:system>';
                               xml+='<mdm:name>Salesforce</mdm:name>';
                               xml+='<mdm:correlationId>' +sglAccount.AccountNumber + '</mdm:correlationId>';
                               xml+='<mdm:processingServer>MDM</mdm:processingServer>';
                            xml+='</mdm:system>';
                         xml+='</mdm:WSRequestHeader>';
                         xml+='<mdm:WSRequestBody>';
                            xml+='<mdm:id></mdm:id>';
                            xml+='<mdm:document_type>' + sglAccount.Tipodedocumento__c + '</mdm:document_type>';
                            xml+='<mdm:document_number>' + sglAccount.AccountNumber + '</mdm:document_number>';
                            xml+='<mdm:id_origin_system></mdm:id_origin_system>';
                         xml+='</mdm:WSRequestBody>';
                      xml+='</mdm:Get_Customer>';
                   xml+='</soapenv:Body>';
                xml+='</soapenv:Envelope>';
        
         	system.debug('ObtenerCliente--> Request > '+ xml);
            GenerarIntegracionServiciosGet(xml,sglAccount.Id); 
        
    }

    
    public void InsertarDatosContacto(Contact sglContact,String set_type){
        
        String now = '';
        String xml = '';
        Map<String,String> DatosCuenta = new Map<String,String>();
        Map<String,String> DatosContacto = new Map<String,String>();
        
        now = System.now().format('yyyy-MM-dd') + 'T' + System.now().format('HH:mm:ss') + '.000Z';
        if(sglContact.AccountId!=null){
        DatosCuenta = ObtenerDatosCuentaContacto(sglContact.AccountId);
        DatosContacto = ObtenerDatosContacto(sglContact);
        xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mdm="http://www.etb.com.co/Gateway/MDM_Data_Services">';
                       xml+='<soapenv:Header/>';
                       xml+='<soapenv:Body>';
                          xml+='<mdm:Set_Customer_Contact>';
                          xml+='<mdm:WSRequestHeader>';
                                xml+='<mdm:system>';
                                   xml+='<mdm:name>Salesforce</mdm:name>';
                                    xml+='<mdm:correlationId>' + sglContact.NumerodeIdentificacion__c + '</mdm:correlationId>';
                                   xml+='<mdm:processingServer>MDM</mdm:processingServer>';
                                xml+='</mdm:system>';
                             xml+='</mdm:WSRequestHeader>';
                             xml+='<mdm:WSRequestBody>';
        						if(set_type=='U'){
                                	xml+='<mdm:Id>' + DatosContacto.get('Identificador_Contacto_Mongo__c') + '</mdm:Id>';
                                }else{
                                    xml+='<mdm:Id></mdm:Id>';
                                }
                                xml+='<mdm:Id_Cliente>' + DatosCuenta.get('Identificador_Cuenta_Mongo__c') + '</mdm:Id_Cliente>';
                                xml+='<mdm:Tipo_Documento_Contacto>' + sglContact.Tipodedocumento__c + '</mdm:Tipo_Documento_Contacto>';
                                xml+='<mdm:Numero_Documento_Contacto>' + sglContact.NumerodeIdentificacion__c + '</mdm:Numero_Documento_Contacto>';
                                xml+='<mdm:Nombre_Contacto>' + DatosContacto.get('Name') + '</mdm:Nombre_Contacto>';
                                xml+='<mdm:Telefono_Contacto>' + sglContact.Phone + '</mdm:Telefono_Contacto>';
                                xml+='<mdm:Movil_Contacto>' + sglContact.MobilePhone + '</mdm:Movil_Contacto>';
                                xml+='<mdm:Email_Contacto>' + sglContact.Email + '</mdm:Email_Contacto>';
                                xml+='<mdm:Direccion_Asociada_Contacto>' + sglContact.Direccion__c + '</mdm:Direccion_Asociada_Contacto>';
                                xml+='<mdm:Codigo_Dane_Ciudad_Contacto>' + DatosContacto.get('CodigoDane__c') + '</mdm:Codigo_Dane_Ciudad_Contacto>';
                                //xml+='<mdm:Localidad_Contacto></mdm:Localidad_Contacto>';
                                //xml+='<mdm:Barrio_Contacto></mdm:Barrio_Contacto>';
                                //xml+='<mdm:Estrato_Contacto></mdm:Estrato_Contacto>';
                                xml+='<mdm:set_type>' + set_type + '</mdm:set_type>';
                                xml+='<mdm:Nombre_Individual>' + sglContact.FirstName + '</mdm:Nombre_Individual>';
                                xml+='<mdm:Primer_Apellido>' + sglContact.LastName + '</mdm:Primer_Apellido>';
                                //xml+='<mdm:Segundo_Apellido>?</mdm:Segundo_Apellido>';
                                xml+='<mdm:Codigo_DANE>' + DatosContacto.get('CodigoDane__c') + '</mdm:Codigo_DANE>';
                                xml+='<mdm:Usuario_Modificador>' + sglContact.LastModifiedById + '</mdm:Usuario_Modificador>';
        						if(sglContact.Autoriza_Tratamiento_de_Datos_Personales__c != Null && sglContact.Autoriza_Tratamiento_de_Datos_Personales__c != ''){
                                    xml+='<mdm:ATDP>';
                                    if(sglContact.Autoriza_Tratamiento_de_Datos_Personales__c == 'No' || sglContact.Autoriza_Tratamiento_de_Datos_Personales__c == 'Ninguno'){
                                       xml+='<mdm:HABEAS_DATA>false</mdm:HABEAS_DATA>';
                                    }else{
                                       xml+='<mdm:HABEAS_DATA>true</mdm:HABEAS_DATA>'; 
                                    }
                                       xml+='<mdm:FECHA>' + now + '</mdm:FECHA>';
                                       //xml+='<mdm:USUARIO></mdm:USUARIO>';
                                       //xml+='<mdm:CANAL></mdm:CANAL>';
                                       //xml+='<mdm:PQR_ASOCIADA></mdm:PQR_ASOCIADA>';
                                    xml+='</mdm:ATDP>';
                                }
        						if(sglContact.OtherPhone != Null && sglContact.OtherPhone != ''){
                                	xml+='<mdm:Movil_Contacto2>' + sglContact.OtherPhone + '</mdm:Movil_Contacto2>';
                                }
                             xml+='</mdm:WSRequestBody>';
                          xml+='</mdm:Set_Customer_Contact>';
                       xml+='</soapenv:Body>';
                    xml+='</soapenv:Envelope>';
        
            system.debug('InsertarDatosContacto--> Request > '+ xml);
            GenerarIntegracionServiciosSet(xml,'Contacto',sglContact.Id); 
        }
    }

    public void ObtenerClienteDesdeContacto(Contact sglContacto){
        
		Map<String,String> DatosCuenta = new Map<String,String>();
        String xml = '';
        if(sglContacto.AccountId!=null){
            DatosCuenta = ObtenerDatosCuentaContacto(sglContacto.AccountId);
            xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mdm="http://www.etb.com.co/Gateway/MDM_Data_Services">';
            xml+='<soapenv:Header/>';
            xml+='<soapenv:Body>';
            xml+='<mdm:Get_Customer>';
            xml+='<mdm:WSRequestHeader>';
            xml+='<mdm:system>';
            xml+='<mdm:name>Salesforce</mdm:name>';
            xml+='<mdm:correlationId>' + sglContacto.NumerodeIdentificacion__c + '</mdm:correlationId>';
            xml+='<mdm:processingServer>MDM</mdm:processingServer>';
            xml+='</mdm:system>';
            xml+='</mdm:WSRequestHeader>';
            xml+='<mdm:WSRequestBody>';
            xml+='<mdm:id></mdm:id>';
            xml+='<mdm:document_type>' + DatosCuenta.get('Tipodedocumento__c') + '</mdm:document_type>';
            xml+='<mdm:document_number>' + DatosCuenta.get('AccountNumber') + '</mdm:document_number>';
            xml+='<mdm:id_origin_system></mdm:id_origin_system>';
            xml+='</mdm:WSRequestBody>';
            xml+='</mdm:Get_Customer>';
            xml+='</soapenv:Body>';
            xml+='</soapenv:Envelope>';
            
            system.debug('ObtenerClienteDesdeContacto--> Request > '+ xml);
            GenerarIntegracionServiciosGetContacto(xml,sglContacto.Id,sglContacto.NumerodeIdentificacion__c); 
        }
    }
    
    public static void GenerarIntegracionServiciosSet(String xml, String Action, String Id){
        
        ServiciosWeb__c sw;
        String Tipo='';
        
        if(Action == 'Cuenta'){
            sw = ServiciosWeb__c.getValues('Set_Customer');
            Tipo = 'Set_Customer';
  		}else{
            sw = ServiciosWeb__c.getValues('Set_Customer_Contact');
         	Tipo = 'Set_Customer_Contact';
		}

        consultarServicioSet(xml,sw.Action__c,sw.EndPoint__c,Id,Tipo);

    }
    
    public static void GenerarIntegracionServiciosGet(String xml, String Id){

        ServiciosWeb__c sw;
        
        sw = ServiciosWeb__c.getValues('Get_Customer');
        consultarServicioGet(xml,sw.Action__c,sw.EndPoint__c,Id, 'Get_Customer',Id);

    }
    
    public static void GenerarIntegracionServiciosGetContacto(String xml, String Id,String NumeroDocumentoContacto){

        ServiciosWeb__c sw;
        
        sw = ServiciosWeb__c.getValues('Get_Customer');
        consultarServicioGetContacto(xml,sw.Action__c,sw.EndPoint__c,Id, 'Get_Customer',Id,NumeroDocumentoContacto);

    }
    
    //Metodo encargado de consultar soap via Http los servicios Set_Customer y Set_Customer_Contact
    @future(callout=true)
    public static void consultarServicioSet(string xml,string metodo,string endpoint, String Id,String Tipo){

        String bodyRes = '';
        Http h = new Http();
        HttpResponse res;
        LogTransacciones__c logServicio = new LogTransacciones__c();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        req.setBody(xml);
        req.setEndpoint(endpoint);
 
        try {
            res = h.send(req);
            bodyRes = res.getBody();
            system.debug(bodyRes);
            if(res.getStatusCode()>=400){
            	bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>Error: '+res.getStatusCode()+'</NomError>';
            }
        }
            catch(System.CalloutException e) {
           		bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>'+e.getMessage()+'</NomError>';
        }
        
        system.debug('--> consultarServicioSet > bodyRes: '+ bodyRes);

        logServicio.Name = Tipo + '_MDM';
        logServicio.Informacion_Enviada__c = xml;
        logServicio.Informacion_Recibida__c = bodyRes;
        logServicio.Estado__c = 'Realizado';
        if(Tipo == 'Set_Customer'){
            logServicio.Account__c=Id;
  		}else{
            logServicio.Contacto__c=Id;
		}

        BanderasEjecucion.ValidarEjecucion('UpdateAccountMDM');
        BanderasEjecucion.ValidarEjecucion('UpdateContactMDM');
        BanderasEjecucion.ValidarEjecucion('InsertContactMDM');
        insert logServicio;

    }
    
    //Metodo encargado de consultar soap via Http el servicio Get_Customer para Clientes
    @future(callout=true)
    public static void consultarServicioGet(string xml,string metodo,string endpoint, String Id,String Tipo, Id AccountId){
        
        String bodyRes = '';
        String IdCuentaMongo = '';
        HttpResponse res;
        Dom.Document docResponse = new Dom.Document();
        LogTransacciones__c logServicio = new LogTransacciones__c();
        datetime start = System.now();
        
        while(System.now() < start.addSeconds(4)){
           //system.debug('Obtener_Cliente--> Wait start time > '+ start);
        }
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        req.setBody(xml);
 
        req.setEndpoint(endpoint);
 
        try {
            res = h.send(req);
            bodyRes = res.getBody();
            system.debug(bodyRes);
            if(res.getStatusCode()>=400){
            	bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>Error: '+res.getStatusCode()+'</NomError>';
            }
        }
        	catch(System.CalloutException e){
           	bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>'+e.getMessage()+'</NomError>';
        }
        
        system.debug('--> consultarServicioGet > bodyRes: '+ bodyRes);
        logServicio.Name = Tipo + '_MDM';
        logServicio.Account__c=Id;
        logServicio.Informacion_Enviada__c = xml;
        logServicio.Informacion_Recibida__c = bodyRes;
        logServicio.Estado__c = 'Realizado';
        
        //Manejo de la respuesta 
    
        docResponse.load(bodyRes);
        Dom.XMLNode WSResponseBodyNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'WSResponseBody');
        System.debug('WSResponseBodyNode---------->' + WSResponseBodyNode);
        if(WSResponseBodyNode.getName() !='Vacio'){
            IdCuentaMongo = WSResponseBodyNode.getChildElement('Id', WSResponseBodyNode.getNamespace()).getText();
        }
        
        Account objOcUpdate = new Account(Id=AccountId);
        objOcUpdate.Identificador_Cuenta_Mongo__c = IdCuentaMongo;
        BanderasEjecucion.setEjecucion('UpdateAccountMDM');
        Update objOcUpdate;
        BanderasEjecucion.setEjecucion('UpdateAccountMDM');
        insert logServicio;
        BanderasEjecucion.setEjecucion('UpdateAccountMDM');
 
    }
    
    //Metodo encargado de consultar soap via Http el servicio Get_Customer desde los Contactos
    @future(callout=true)
    public static void consultarServicioGetContacto(string xml,string metodo,string endpoint, String Id,String Tipo, Id ContactId,String NumeroDocumento){

        Dom.Document docResponse = new Dom.Document();
        Map<String,String> DatosContacto = new Map<String,String>();
        datetime start = System.now();
        
        while(System.now() < start.addSeconds(4)){
           //system.debug('consultarServicioGetContacto--> Wait start time > '+ start);
        }
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        req.setBody(xml);
 
        req.setEndpoint(endpoint);
 
        string bodyRes = '';
        
        HttpResponse res;

        try {
            	res = h.send(req);
            	bodyRes = res.getBody();
                system.debug(bodyRes);
                if(res.getStatusCode()>=400){
                    bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>Error: '+res.getStatusCode()+'</NomError>';
                }
            }
            catch(System.CalloutException e) {
           		bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>'+e.getMessage()+'</NomError>';
            }
        
        system.debug('--> consultarServicio > bodyRes: '+ bodyRes);

        //Manejo de la respuesta 
    
        docResponse.load(bodyRes);
        Dom.XMLNode WSResponseBodyNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'WSResponseBody');
        if(WSResponseBodyNode.getName() !='Vacio'){
            Dom.XMLNode ContactoNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(WSResponseBodyNode,'Contacto');
            System.debug('ContactoNode---------->' + ContactoNode);
            if(ContactoNode.getName() !='Vacio'){
                for(Dom.XMLNode child: ContactoNode.getChildElements()) {
                   DatosContacto.put(child.getChildElement('Numero_Documento', child.getNamespace()).getText(),child.getChildElement('Id', child.getNamespace()).getText());
                }
       		}
            
    	}

        System.debug('DatosContacto: ' + DatosContacto);       
        
        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.Name = Tipo + '_Contact_MDM';
        logServicio.Contacto__c=Id;
        logServicio.Informacion_Enviada__c = xml;
        logServicio.Informacion_Recibida__c = bodyRes;
        logServicio.Estado__c = 'Realizado';
       
        Contact objContact = new Contact(Id=ContactId);
        objContact.Identificador_Contacto_Mongo__c = DatosContacto.get(NumeroDocumento);
        BanderasEjecucion.setEjecucion('UpdateContactMDM');
        Update objContact;
        BanderasEjecucion.setEjecucion('UpdateContactMDM');
        insert logServicio;
        BanderasEjecucion.setEjecucion('UpdateContactMDM');
 
    }
    
    public static Map<String,String> ObtenerDatosCuenta(Account sglAccount){
        
        Map<String,String> DatosCuenta = new Map<String,String>();
        List<Account> ListaCuentas = new List<Account>(); 
        
        ListaCuentas = [Select Id, Name, Ciudad__r.CodigoDane__c,Identificador_Cuenta_Mongo__c From Account WHERE Id =: sglAccount.Id Limit 1];
        DatosCuenta.put('CodigoDane__c',ListaCuentas[0].Ciudad__r.CodigoDane__c);
        DatosCuenta.put('Identificador_Cuenta_Mongo__c',ListaCuentas[0].Identificador_Cuenta_Mongo__c);
        system.debug('--> ObtenerDatosCuenta > DatosCuenta: '+ DatosCuenta);

     	return DatosCuenta;    
        
    }
    
    public static Map<String,String> ObtenerDatosCuentaContacto(Id IdCuenta){
        
        Map<String,String> DatosCuenta = new Map<String,String>();
        List<Account> ListaCuentas = new List<Account>(); 
        
        ListaCuentas = [Select Id, Tipodedocumento__c, AccountNumber,Ciudad__r.CodigoDane__c,Identificador_Cuenta_Mongo__c From Account WHERE Id =: IdCuenta Limit 1];
        DatosCuenta.put('CodigoDane__c',ListaCuentas[0].Ciudad__r.CodigoDane__c);
        DatosCuenta.put('Identificador_Cuenta_Mongo__c',ListaCuentas[0].Identificador_Cuenta_Mongo__c);
        DatosCuenta.put('Tipodedocumento__c',ListaCuentas[0].Tipodedocumento__c);
        DatosCuenta.put('AccountNumber',ListaCuentas[0].AccountNumber);
        system.debug('--> ObtenerDatosCuentaContacto > DatosCuenta: '+ DatosCuenta);
        
     	return DatosCuenta;    
        
    }
    
    public static Map<String,String> ObtenerDatosContacto(Contact Contacto){
        
        Map<String,String> DatosContacto = new Map<String,String>();
        List<Contact> ListaContactos = new List<Contact>();  
        
        ListaContactos = [Select Id, Name, Identificador_Contacto_Mongo__c,NumerodeIdentificacion__c,Ciudad__r.CodigoDane__c 
                          From Contact WHERE Id =: Contacto.Id Limit 1];
        DatosContacto.put('Identificador_Contacto_Mongo__c',ListaContactos[0].Identificador_Contacto_Mongo__c);
        DatosContacto.put('NumerodeIdentificacion__c',ListaContactos[0].NumerodeIdentificacion__c);
        DatosContacto.put('Name',ListaContactos[0].Name);
        DatosContacto.put('CodigoDane__c',ListaContactos[0].Ciudad__r.CodigoDane__c);
        system.debug('--> ObtenerDatosContacto > DatosContacto: '+ DatosContacto);
        
     	return DatosContacto;    
        
    }
    
    public static boolean ValidarserviciosCuenta(Id sglAccountId){
        
        Boolean TieneServicios = false;
        List<ActivoETB__c> ListaServicios = new List<ActivoETB__c>(); 
        ListaServicios = [Select id, Estado__c From ActivoETB__c where NombredelaCuenta__c =: sglAccountId  and Estado__c = 'Activo'];
        if(ListaServicios.size() > 0 ){
            TieneServicios = true;
        }
     	return TieneServicios; 
    }
    
}