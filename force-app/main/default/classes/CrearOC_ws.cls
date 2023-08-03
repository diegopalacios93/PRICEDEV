@RestResource(UrlMapping='/CrearOC/')
global without sharing class CrearOC_ws{
    @HttpPost 
    global static CrearOCWrapper doPost(String idPlan,String idCuenta,Integer cantidad,String idContactoAdministrativo,String idContactoTecnico,String idSucursal,Double valorTotal,String descripcionOrden,Integer duracionMes, List<CrearOCWrapper.XA> XAs) {
        CrearOCWrapper responseObj = new CrearOCWrapper();
        CrearOCWrapper requestObj = new CrearOCWrapper();
        String estado = 'procesado';
        String hoy = '';
        Boolean error = false;
        String message = '';
        integer cantidadAux = 1;
        responseObj.XAs= XAs;
        responseObj.idPlan = idPlan;
        responseObj.idCuenta = idCuenta;
        responseObj.idContactoAdministrativo = idContactoAdministrativo;
        responseObj.idContactoTecnico = idContactoTecnico;
        responseObj.idSucursal = idSucursal;
        responseObj.valorTotal = valorTotal;
        responseObj.descripcionOrden = descripcionOrden;
        responseObj.duracionMes = duracionMes;
        responseObj.cantidad = cantidad;
        requestObj= responseObj;
        if(idPlan == null || idPlan == ''){
            error = true;
            message = 'el campo idPlan de la orden es requerido';
         }
        if(idCuenta == null || idCuenta == '')	{
            
            message = error ? message + ' ; ':'';
            message = message + 'el campo idCuenta de la orden es requerido';
            error = true;
        }

        if(idContactoAdministrativo == null || idContactoAdministrativo == ''){
            message = error ? message + ' ; ':'';
            message = message + 'La orden debe contener un Contacto administrativo';
            error = true;
        }

        if(idContactoTecnico == null || idContactoTecnico == ''){
            message = error ? message + ' ; ':'';
            message = message + 'La orden debe contener un Contacto tecnico';
            error = true;
        }

        if(idSucursal == null || idSucursal == ''){
            message = error ? message + ' ; ':'';
            message = message + 'La orden debe contener una Sucursal';
            error = true;
        }
        if(!error){
            Account cuenta = [SELECT Id,Owner.email FROM Account WHERE Id=: idCuenta];
            try{           
            Opportunity oportunidad = new Opportunity();
            Id idEspecial = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Licitacion').getRecordTypeId();
            Id idOC = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Oferta_Comercial').getRecordTypeId();
            Planes__c plan = [SELECT Id,Name,NombredelProducto__c FROM Planes__c WHERE Id =: idPlan];
            oportunidad.AccountId = Id.valueOf(idCuenta);
            oportunidad.Amount = valorTotal;            
            oportunidad.Valor_Recurrente_Anterior_ETB__c = valorTotal;            
            oportunidad.Tipo_de_Operacion__c = 'Venta';
			oportunidad.CloseDate = Date.TODAY()+ 30;
            oportunidad.Probability = 60;
            oportunidad.PDC__c = '60% - Probabilidad de Éxito';
            oportunidad.Duracion_Meses__c = duracionMes != null ? duracionMes : 0 ;  
			oportunidad.Plan__c = Id.valueOf(idPlan);
            hoy = Datetime.now().format('MM/dd/yyyy hh:mm a zz', 'America/Bogota');
            //oportunidad.OportunidadCSC__c = true;
            if (plan.Name.Contains('Linea Telefonica'))
                cantidadAux = cantidad;
            
            if (plan.Name.Contains('Unificadas')){
                EmailTemplate et = [Select id,Owner.username,IsActive from EmailTemplate where developername = 'NotificacionCUCSC' limit 1];
                oportunidad.Name = 'Oportunidad especial CSC - '+ hoy;
                oportunidad.RecordTypeId = idEspecial;
                oportunidad.StageName = 'Diseño de la solución';
                oportunidad.Descripci_n_VIA_Consultiva__c = descripcionOrden;
                oportunidad.Tipo_de_Oportunidad__c = 'ComunicacionesUnificadas';
                oportunidad.Contacto__c = Id.ValueOf(idContactoAdministrativo);
                oportunidad.Canal_Externo__c = 'CENTRO SERVICIOS COMPARTIDOS';
                insert oportunidad;
             	enviarCorreo(cuenta,et.Id,oportunidad,null);
                responseObj.resultadoOperacion = '200, Se proceso la orden';
            }else {
                oportunidad.Name = 'Oportunidad comercial CSC - '+ hoy;
                oportunidad.Descripci_n_VIA_Consultiva__c = descripcionOrden;
                oportunidad.Contacto__c = Id.ValueOf(idContactoAdministrativo);
                oportunidad.StageName = 'Diseño de la solución';
                oportunidad.ForecastCategoryName = 'En Construcción';
                oportunidad.RecordTypeId = idOC;
                oportunidad.Canal_Externo__c = 'CENTRO SERVICIOS COMPARTIDOS';
                insert oportunidad;
                EmailTemplate et = [Select id,Owner.username,IsActive from EmailTemplate where developername = 'NotificacionCSC' limit 1];
                TOPP__c topp = [SELECT Id,Tipoderegistro__c FROM TOPP__c WHERE TipodeOperacionporplan__c='Venta' AND Plan__c =:idPlan LIMIT 1];
                Id toppRT = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByDeveloperName().get(topp.Tipoderegistro__c).getRecordTypeId(); 
                
				List<OperacionComercial__c> ocs = new List<OperacionComercial__c>();
                List<ActivoETB__c> servicios = new List<ActivoETB__c>();
                for(Integer i = 0;i<cantidadAux;i++){
                    ActivoETB__c servicio = new ActivoETB__c();
                    servicio.NombredelaCuenta__c = Id.valueOf(idCuenta);
                    servicio.Plan__c = Id.valueOf(idPlan);
                    servicio.NombredelProducto__c = plan.NombredelProducto__c;
                    servicio.Oportunidad__c = oportunidad.Id;
                    //servicio.ServicioCSC__c = true;
                    servicios.add(servicio);
                }
                
                insert servicios;
                for(Integer i = 0;i<cantidadAux;i++){
                   	OperacionComercial__c OC = new OperacionComercial__c();
                    OC.CuentaCliente__c = Id.valueOf(idCuenta);
                    OC.Activo__c = servicios[i].Id;
                    OC.Plan__c = plan.Id;
                    OC.TOPP__c = topp.Id;
                    OC.Oportunidad__c = oportunidad.Id;
                    OC.RecordTypeId = toppRT;
                    OC.Contacto_Administrativo__c = Id.valueOf(idContactoAdministrativo);
                    OC.Contacto_Tecnico__c = Id.valueOf(idContactoTecnico);
                    OC.SucursalOrigen__c = Id.valueOf(idSucursal);
                    ocs.add(OC);
                }
                insert ocs;
                String ocsCreadas = '';
				List<LTE_Servicios_adicionales__c> SAs = new List<LTE_Servicios_adicionales__c>();
                Set<Id> idsOC = new Set<Id>();
                for(Integer i = 0;i<cantidadAux;i++){
                    idsOC.add(ocs[i].Id);
                    LTE_Servicios_adicionales__c SA = new LTE_Servicios_adicionales__c();
                    SA.Name = 'Servicio Adicional CSC - '+ Datetime.now();
                    SA.LTE_ServicioETB__c = servicios[i].Id;
                    SA.LTE_Operacion_Comercial_SVA__c = ocs[i].Id;
                    SAs.add(SA);
 
                }
                
                List<OperacionComercial__c> ocsName = [SELECT Name FROM OperacionComercial__c WHERE Id IN :idsOC];
                for(OperacionComercial__c OC : ocsName){
                    ocsCreadas = ocsCreadas +' '+OC.Name;
                }
                insert SAs;
                List<LTE_SpecificationGroupXA__c> listXA = new List<LTE_SpecificationGroupXA__c>();
                for(LTE_Servicios_adicionales__c SA : SAs ){
                    for(CrearOCWrapper.XA xa : XAs){
                        LTE_SpecificationGroupXA__c xaNew = new LTE_SpecificationGroupXA__c();
                        xaNew.LTE_Value__c = String.valueOf(xa.value);
                        xaNew.ApiName__c = xa.apiName;
                        xaNew.LTE_ServiciosAdicionales__c = SA.Id;
                        listXA.add(xaNew);
                    }
                }
                insert listXA;
                responseObj.resultadoOperacion = '200, Se proceso la orden';
                responseObj.codigoRespuesta = '200';
                //enviarCorreo(cuenta,et.Id,oportunidad,OC);
                notificacionOC(cuenta,oportunidad,ocsCreadas);
            }
            
        }catch (Exception ex){
            responseObj.resultadoOperacion = 'No se pudo procesar la orden, información del error: '+ex.getMessage();
            responseObj.codigoRespuesta = '500';
            estado = 'Error';
        }  
            
        }else{
            responseObj.resultadoOperacion = 'No se pudo procesar la orden, información del error: '+message;
            responseObj.codigoRespuesta = '500';
            estado = 'Error';
        }
		LogTransacciones__c objLog		= new LogTransacciones__c(
							                Informacion_Enviada__c  = JSON.serialize(responseObj),
							                Informacion_Recibida__c = JSON.serialize(requestObj),
							                Estado__c               = estado,
							                Name                    = 'Venta generada en CSC '+ hoy ,
							                CodigoRespuesta__c      = responseObj.codigoRespuesta,
            								Account__c              = idCuenta != '' ?  Id.valueOf(idCuenta) : null 
							             );
        insert objLog;
        return responseObj;
    }
    public static void enviarCorreo(Account owner,Id templateId,Opportunity op,OperacionComercial__c oc){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {owner.Owner.email};
        mail.setSenderDisplayName(owner.Owner.Email);
        mail.setToAddresses(toAddresses);
        mail.setTargetObjectId(op.Contacto__c);
        mail.setTemplateId(templateId);
        mail.setWhatId(owner.id);
        mail.setWhatId(op.Id);
        if(oc != null) mail.setWhatId(oc.Id);
        mail.setSaveAsActivity(false);
 		Messaging.SendEmailResult[] repuesta=Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});

    }
    public static void notificacionOC(Account cuenta,Opportunity op,String ocsCreadas){
        cuenta = [SELECT Id,Name,Owner.Name,Owner.Email,AccountNumber FROM Account WHERE Id=:cuenta.Id];
        op = [SELECT Descripci_n_VIA_Consultiva__c,Consecutivooportunidades__c,Contacto__r.Name,Contacto__r.Phone FROM Opportunity WHERE Id=:op.Id];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {cuenta.Owner.email};
        email.setToAddresses(toAddresses);
        
        email.setSubject('Notificación Venta');
        
        email.setHtmlBody('Hola '+cuenta.Owner.Name+', <br/><br/>Esta notificación fue generada automáticamente por Salesforce, para informarle que el cliente '+ cuenta.Name+', identificado con el NIT '+cuenta.AccountNumber+', registró la compra de los siguientes productos a través del portal Mi ETB:<br/>'+ op.Descripci_n_VIA_Consultiva__c+'<br/><br/>El sistema generó los siguientes registros relacionados con la solicitud del cliente:<br/>Oportunidad: '+op.Consecutivooportunidades__c+'<br/>Operaciones comerciales: '+ocsCreadas+'<br/>Contacto: '+op.Contacto__r.Name+' - '+op.Contacto__r.Phone+'<br/><br/>Gracias');
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
}