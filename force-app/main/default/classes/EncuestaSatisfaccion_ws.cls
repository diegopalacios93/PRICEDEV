global class EncuestaSatisfaccion_ws implements Queueable, Database.AllowsCallouts{

    public set<Id> idCasos;
 	public EncuestaSatisfaccion_ws(Set<Id> ids) {
        this.idCasos = ids;
    }
    public static Boolean encuestaCheck = true;
    public void execute(QueueableContext context) {
        String hoy = Datetime.now().format('MM/dd/yyyy hh:mm a zz', 'America/Bogota');
        String token =null;
        String recibido = '';
        List<Case> casosError = new List<Case>();
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('EncuestaSatisCasoCerradoAutenticacion'); 
        system.debug('SW: ' + sw);  
       	List<LogTransacciones__c> logs = new List<LogTransacciones__c>();
        ObtenerTokenWrapper obtenerTokenObj = new ObtenerTokenWrapper();
        ObtenerTokenWrapper.WSRequestHeader wsHeader = new ObtenerTokenWrapper.WSRequestHeader();
        ObtenerTokenWrapper.System1 system1 = new ObtenerTokenWrapper.System1();
        ObtenerTokenWrapper.Property property = new ObtenerTokenWrapper.Property();
        ObtenerTokenWrapper.WSRequestBody wsRequestBody= new ObtenerTokenWrapper.WSRequestBody();
        ObtenerTokenWrapper.Audit audit = new ObtenerTokenWrapper.Audit();
		LogTransacciones__c log = new LogTransacciones__c();
        system1.name = 'MAX';
        system1.correlationID = 'MAX-AUTENTICACION';
        wsHeader.System1 = system1;
        property.name = '';
        property.value = '';
        wsHeader.Property = property;

        wsRequestBody.Password = sw.Contrasena__c;
        wsRequestBody.Username = sw.Usuario__c;
        audit.Canal = 'ChatWeb';
        wsRequestBody.Audit = audit;

        obtenerTokenObj.WSRequestHeader = wsHeader;
        obtenerTokenObj.WSRequestBody = wsRequestBody;

        String sJson = JSON.serialize(obtenerTokenObj);
        sJson = sJson.replace('System1', 'System');
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(sw.EndPoint__c + sw.Action__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');   
            System.debug('Request--->'+sJson);
            // Set the body as a JSON object
            request.setBody(sJson);
       
            HttpResponse response = http.send(request);
        
            System.debug('RESPUESTA AUTH '+ response.getBody());
            recibido = response.getBody();
            // Parse the JSON 
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> respBody = (Map<String,Object>)results.get('WSResponseBody');
            System.debug(' ResponseBody'+ respBody);
            System.debug(' Response'+ response);
            if(response.getStatusCode() == 200) {
                // Obtener Security Token
                if((respBody.get('SecurityToken')) == null){
                    Map<String,Object> respHeader = (Map<String,Object>)results.get('WSResponseHeader');
                    Map<String,Object> serviceBody = (Map<String,Object>)respHeader.get('Service');
                    List<Map<String, Object>> data = new List<Map<String, Object>>();
                   
                    for (Object instance : (List<Object>)serviceBody.get('statusDetail')){
                        data.add((Map<String, Object>)instance);
                        
                        System.debug(instance.toString());
                    }   
                }else{
                     token = respBody.get('SecurityToken').toString();
                     System.debug('SECURITY TOKEN: '+token);
                }
    
            }else{
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                    
            }
           
                for(Id idCaso :idCasos){
                        
                    log.Name = 'EncuestaSatisfaccion_ws Get Token ' + hoy;
                    log.Caso__c = idCaso;
                    log.CodigoRespuesta__c = String.valueOf(response.getStatusCode());
                    log.Error_Apex__c = response.getStatus();
                    log.Estado__c = token != null ? 'Exitoso' : 'Error';
                    //log.Informacion_Enviada__c = sJson;
                    log.Informacion_Recibida__c = response.getBody();
                    logs.add(log);
                    Case c = new Case();
                    c.Id = idCaso;
                    c.NoIntentosEncuesta__c = 1;
                    casosError.add(c);
                }
            
        } catch(Exception e) {
            for(Id idCaso :idCasos){
                log.Name = 'EncuestaSatisfaccion_ws Get Token '+ hoy ;
                log.Caso__c = idCaso;
                log.CodigoRespuesta__c = '';
                log.Error_Apex__c = e.getMessage();
                log.Informacion_Recibida__c = recibido;
                log.Estado__c = 'Error';
                Case c = new Case();
                c.Id = idCaso;
                c.NoIntentosEncuesta__c = 1;
                casosError.add(c);
            }
            logs.add(log);            
        }
        
        if(token != null){
        	requestSatisfactionSurvey(token,idCasos,logs);
        }else{
            update casosError;
            insert logs;
        }
    }
   	
	public static void requestSatisfactionSurvey(String secToken, Set<Id> idCasos,List<LogTransacciones__c> logsToken){
        String hoy = Datetime.now().format('MM/dd/yyyy hh:mm a zz', 'America/Bogota');
        List<Case> casos = new List<Case>();
        List<Case> casosActualizar = new List<Case>();
        CrearSolicitudEncuestaWrapper csewObj = new CrearSolicitudEncuestaWrapper();
        CrearSolicitudEncuestaWrapper.WSRequestHeader wsRequestHeader = new CrearSolicitudEncuestaWrapper.WSRequestHeader();
        CrearSolicitudEncuestaWrapper.WSRequestBody wsRequestBody = new CrearSolicitudEncuestaWrapper.WSRequestBody();
        CrearSolicitudEncuestaWrapper.System1 system1 = new CrearSolicitudEncuestaWrapper.System1();
        CrearSolicitudEncuestaWrapper.Audit audit = new CrearSolicitudEncuestaWrapper.Audit();
        for(Case caso : casos){ idCasos.add(caso.Id);}
        
        casos = [SELECT Id,CaseNumber,CodigouniconumericoCUN__c,NoIntentosEncuesta__c,Account.AccountNumber,Account.Tipodedocumento__c,Account.Name,Account.Phone,Contact.Email FROM Case WHERE Id IN :idCasos];
        system1.name = 'SALESFORCE';
        
        List<LogTransacciones__c> logs = new List<LogTransacciones__c>();
        for(Case caso : casos){
            system1.correlationID = caso.Id;
        	wsRequestHeader.System1 = system1;
            wsRequestBody.Document_Number = caso.Account.AccountNumber;
            wsRequestBody.Document_Type = caso.Account.Tipodedocumento__c;
            wsRequestBody.Id = caso.CodigouniconumericoCUN__c != null ?  caso.CodigouniconumericoCUN__c : caso.CaseNumber;
            wsRequestBody.Email_Notify = caso.Contact.Email;
            wsRequestBody.Name = caso.Account.Name;
            wsRequestBody.Phone_Notify = caso.Account.Phone;
            wsRequestBody.Type_Notify = 'Encuesta Salesforce';
            audit.Canal = 'Web';
            wsRequestBody.Audit = audit;
            csewObj.WSRequestHeader = wsRequestHeader;
            csewObj.WSRequestBody = wsRequestBody;
            
            String sJson = JSON.serialize(csewObj);
            sJson = sJson.replace('System1', 'System');
    
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('EncuestaSatisCasoCerradoSolicitud'); 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(sw.EndPoint__c + sw.Action__c);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + secToken);
            request.setHeader('Content-Type', 'application/json');
            // Set the body as a JSON object
            request.setBody(sJson);
            HttpResponse response = http.send(request);
            System.debug('RESPUESTA SIST' +response.getBody());
            // Parse the JSON response
            if(response.getStatusCode() != 201) {
            	System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            } else {
            	System.debug(response.getBody());
            }
            LogTransacciones__c log = new LogTransacciones__c();
            log.Name = 'EncuestaSatisfaccion_ws '+hoy;
            log.Account__c = caso.AccountId;
            log.Caso__c = caso.Id;
            log.CodigoRespuesta__c = String.valueOf(response.getStatusCode());
            log.Contacto__c = caso.ContactId;
            log.Error_Apex__c = response.getStatus();
            log.Estado__c = response.getStatusCode() == 200 ? 'Exitoso' : 'Conexión Fallida';
            log.Informacion_Enviada__c = sJson;
            log.Informacion_Recibida__c = response.getBody();
            if(response.getStatusCode() == 200){
                Case c = new Case();
                c.Id = caso.Id;
                c.EncuestaProcesada__c = true;
                c.NoIntentosEncuesta__c = caso.NoIntentosEncuesta__c == null ? 1 : caso.NoIntentosEncuesta__c  + 1;
                casosActualizar.add(c);
            }
            logs.add(log);
            
        }
        	logs.addall(logsToken);
        system.debug('logs--->'+logs);
        if(!casosActualizar.isEmpty())
            update casosActualizar;
        if(!logs.isEmpty())
       		insert logs;
        
    }
}