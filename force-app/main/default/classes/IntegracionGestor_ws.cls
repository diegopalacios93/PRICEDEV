/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase que expone el servicio y los métodos de integración con el Gestor

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2018-04-15   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
global class IntegracionGestor_ws {
    
    //Clases genericas
    
    global class Transaccion{
       webservice string nombreSistema ='';
       webservice string idTransaccion ='';
       webservice string fechaProcesamiento='';
       webservice string tipoTransaccion='';
       webservice DetalleTransaccion detalleTransaccion = new DetalleTransaccion();
    }
    
    global class DetalleTransaccion{
       webservice list<Parametro> parametro = new list<Parametro>();
    }
    
    global class Lineas{
       webservice list<Linea> linea = new list<Linea>();
    }
    
    global class Linea{
       webservice string Accion;
       webservice string Estado;
       webservice string Numero;
       webservice string ExternalId;
       webservice string TipoLinea;
    }
    
    global class Parametro{
       webservice string nombre;
       webservice string valor;
    }
    
    global class ParametroOp{
       webservice string nombre;
       webservice string valor;
       webservice string fila;
    }
    
    global class Item{
       webservice string elemento;
       webservice string referencia;
       webservice string cantidad;
       webservice string descripcion; 
    }
    
    global class MsgError{
        webservice string codigoError='';
        webservice string mensajeError='';
    }
    
    //Clases relacionadas con Respuesta Viabilidad
        
    global class DetalleOpcion{
       webservice list<ParametroOp> parametroOp = new list<ParametroOp>();
    }
    
    global class ConfiguracionServicio{
       webservice list<Item> item = new list<Item>();
    }
    
    global class Opcion{
       webservice string idOpcion;
       webservice string observaciones;
       webservice DetalleOpcion detalleOpcion = new DetalleOpcion();
       webservice ConfiguracionServicio configuracionServicio = new ConfiguracionServicio();
    }
    
    global class OpcionesViabilidad{
       webservice list<Opcion> opcion = new list<Opcion>();
 	}
    
    global class DetallesViabilidad{
       webservice list<Parametro> parametro = new list<Parametro>();
    }
    
    global class URLs{
       webservice list<Parametro> parametro = new list<Parametro>();
 	}
    
    global class RespuestaViabilidad{
        webservice string numeroViabilidad;
        webservice string estadoViabilidad;
        webservice string grupoAsignacion;
        webservice string responsable;
        webservice string respuestaViabilidad;
        webservice string respuesta;
        webservice string tipoViabilidad;
        webservice string aliado;
        webservice string tipoAliado;
        webservice string causal;        
        webservice OpcionesViabilidad opcionesViabilidad = new OpcionesViabilidad();
        webservice DetallesViabilidad detallesViabilidad = new DetallesViabilidad();
        webservice URLs URLs = new URLs();
    }
    
    global class MsgEntradaResVia{
       	webservice Transaccion transaccion;
		webservice RespuestaViabilidad respuestaViabilidad;
 	}
    
    global class MsgSalidaResVia{
        webservice string resultado='';
        webservice MsgError msgError = new MsgError();
    }

	//Clases relacionadas con actualización grupo propietario
	    
    global class DetallesActualizarGrupoPropietario{
       webservice list<Parametro> parametro = new list<Parametro>();
    }
    
    global class ActualizarGrupoPropietario{
       webservice string tipoSolicitud;
       webservice string numeroOC;
       webservice string numeroViabilidad;
       webservice string responsable;
       webservice string grupoAsignacion;
       webservice DetallesActualizarGrupoPropietario detallesActualizarGrupoPropietario = new DetallesActualizarGrupoPropietario();
    }
    
    global class MsgEntradaActGrupoPropietario{
       	webservice Transaccion transaccion;
		webservice ActualizarGrupoPropietario actualizarGrupoPropietario;
 	}
    
    global class MsgSalidaActGrupoPropietario{
        webservice string resultado='';
        webservice MsgError msgError = new MsgError();
    }

    //Clases relacionadas con inicio de facturación 
    
    global class DetallesInicioFacturacion{
       webservice list<Parametro> parametro = new list<Parametro>();
    }
    
    global class InicioFacturacion{
       webservice string grupoAsignacion;
       webservice string responsable;
       webservice string IDServicio;
       webservice string fechaInicioFacturacion;
       webservice string estado;
       webservice string numeroOC;
       webservice DetallesInicioFacturacion detallesInicioFacturacion = new DetallesInicioFacturacion();
       webservice Lineas lineas = new Lineas();
    }
    
    global class MsgEntradaInicioFacturacion{
       	webservice Transaccion transaccion;
		webservice InicioFacturacion inicioFacturacion;
 	}
    
    global class MsgSalidaInicioFacturacion{
        webservice string resultado='';
        webservice MsgError msgError = new MsgError();
    }
    
    global class SincronizacionLineas{
       webservice string numeroOC;
       webservice Lineas lineas = new Lineas();
    }
    
    global class MsgEntradaSincronizacionLineas{
       	webservice Transaccion transaccion;
		webservice SincronizacionLineas sincronizacionLinea;
 	}
    
    global class MsgSalidaSincronizacionLineas{
        webservice string resultado='';
        webservice MsgError msgError = new MsgError();
    }
    
    
    //Clases relacionadas con Actualización de estados 
    //
    global class DetallesActualizarEstado{
    	webservice list<Parametro> parametro = new list<Parametro>();
    }
    
    global class ActualizarEstado{
    	webservice string estado;
       	webservice string fase;
       	webservice string numeroOC;
       	webservice string numeroViabilidad; 
       	webservice string tipoSolicitud;
        webservice string imeis;        
       	webservice DetallesActualizarEstado detallesActualizarEstado = new DetallesActualizarEstado();
    }
    
    global class MsgEntradaActualizarEstado{
       	webservice Transaccion transaccion;
		webservice ActualizarEstado actualizarEstado;
 	}
    
    global class MsgSalidaActualizarEstado{
        webservice string resultado='';
        webservice MsgError msgError = new MsgError();
    }
    

    /*
	* @Método: 		WSRespuestaViabilidad
	* @Parámetros:	MsgEntradaResVia
	* @Descripción:	Método expuesto por WS para recibir respuesta de la viabilidad con opciones de aprovisionamiento.
	*/    
    
    webservice static MsgSalidaResVia WSRespuestaViabilidad(MsgEntradaResVia msgEntrada){
            
    	System.debug('Mensaje entrada respuesta viabilidad:' + msgEntrada);
        MsgSalidaResVia respuesta = new MsgSalidaResVia();
        
        // Insertar log de entrada
        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion;
        logServicio.Informacion_Recibida__c = String.valueOf(msgEntrada);
        logServicio.Name = 'Respuesta Viabilidad ' + msgEntrada.transaccion.idTransaccion;
        insert logServicio;
        	
        try{
        // Relacionar log de entrada a la viabilidad
        List<Viabilidad__c> Viabilidad = [SELECT Id FROM Viabilidad__c where name =: msgEntrada.respuestaViabilidad.numeroViabilidad];
        System.debug('Id de la viabilidad:' + Viabilidad);
        logServicio.NumeroViabilidad__c = Viabilidad[0].Id;
        logServicio.Name = 'Respuesta Viabilidad ' + msgEntrada.respuestaViabilidad.numeroViabilidad;
        update logServicio;
        
        //Invocación clase de implementación 
        respuesta = IntegracionGestor_cls.RespuestaViabilidadImp(msgEntrada);
        
        //Insertar log de salida  
        logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
        update logServicio;

        }catch(exception e){
            respuesta.msgError.mensajeError=e.getMessage();
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.codigoError='NOK';
            logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
	        update logServicio;
         }
        System.debug('respuesta: ' + respuesta);        
	    return respuesta;
        
    }
    
    /*
	* @Método: 		WSActualizarGrupoPropietario
	* @Parámetros:	MsgEntradaActGrupoPropietario
	* @Descripción:	Método expuesto por WS para recibir actualizaciones del grupo propietario.
	*/    
    
    webservice static MsgSalidaActGrupoPropietario WSActualizarGrupoPropietario(MsgEntradaActGrupoPropietario msgEntrada){
        
        System.debug('Mensaje entrada actualizacion grupo propietario:' + msgEntrada);
        MsgSalidaActGrupoPropietario respuesta = new MsgSalidaActGrupoPropietario();
        
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        
        // Insertar log de entrada
        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion;
        logServicio.Informacion_Recibida__c = String.valueOf(msgEntrada);
        logServicio.Name = 'Actualización Grupo Propietario ' + msgEntrada.transaccion.idTransaccion;
        insert logServicio;
        
        try{
            String sTipoSolicitud = String.isEmpty(msgEntrada.actualizarGrupoPropietario.tipoSolicitud)?'':msgEntrada.actualizarGrupoPropietario.tipoSolicitud;
            List<Homologacion_Gestor__mdt> lstHGsTipoSolicitud = new List<Homologacion_Gestor__mdt>();
            system.debug(sTipoSolicitud);
            
            if(String.isNotEmpty(sTipoSolicitud))
                lstHGsTipoSolicitud = [SELECT Id,Valor_API__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'TIPO_SOLICITUD_GESTOR' AND Valor_Usuario__c = :sTipoSolicitud];
            
            if(lstHGsTipoSolicitud.isEmpty()){
                respuesta.msgError.mensajeError='Tipo de solicitud no valido';
            }else{
                
                if(lstHGsTipoSolicitud[0].Valor_API__c == 'Viabilidad'){
                    
                    //Relacionar log de entrada con la viabilidad
                    List<Viabilidad__c> Viabilidad = [SELECT Id FROM Viabilidad__c where name =: msgEntrada.actualizarGrupoPropietario.numeroViabilidad];
                    System.debug('Id de la viabilidad:' + Viabilidad);
                    logServicio.NumeroViabilidad__c = Viabilidad[0].Id;
                    logServicio.Name = 'Actualización Grupo Propietario ' + msgEntrada.actualizarGrupoPropietario.numeroViabilidad;
                    update logServicio;
                    
                    //Invocación clase de implementación
                    respuesta = IntegracionGestor_cls.ActualizarGrupoPropietarioImp(msgEntrada);
                    
                } else if(lstHGsTipoSolicitud[0].Valor_API__c == 'Aprovisionamiento'){
                    
                    //Relacionar log de entrada con la OC
                    List<OperacionComercial__c> OC = [SELECT Id FROM OperacionComercial__c where name =: msgEntrada.actualizarGrupoPropietario.numeroOC];
                    System.debug('Id de la Operación Comercial:' + OC);
                    logServicio.LTE_Operacion_Comercial__c = OC[0].Id;
                    logServicio.Name = 'Actualización Grupo Propietario ' + msgEntrada.actualizarGrupoPropietario.numeroOC;
                    update logServicio;
                    
                    //Invocación clase de implementación
                    respuesta = IntegracionGestor_cls.ActualizarGrupoPropietarioImp(msgEntrada);
                    
                }else{
                    respuesta.msgError.mensajeError='No se envia tipo de solicitud correcta';
                }
            }
        
        }catch(exception e){
            respuesta.msgError.mensajeError=e.getMessage();
        }
        logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
        update logServicio;
        System.debug('respuesta: ' + respuesta);        
        return respuesta;
    }
    
    /*
	* @Método: 		WSIniciarFacturacion
	* @Parámetros:	MsgEntradaInicioFacturacion
	* @Descripción:	Método expuesto por WS para recibir la información del inicio de la facturación
	*/ 
    
    static webservice MsgSalidaInicioFacturacion WSIniciarFacturacion(MsgEntradaInicioFacturacion msgEntrada){
       	System.debug('Mensaje entrada iniciar facturación:' + msgEntrada);
        MsgSalidaInicioFacturacion respuesta = new MsgSalidaInicioFacturacion();
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        try{
            //Invocación clase de implementación 
            respuesta = IntegracionGestor_cls.IniciarFacturacionImp(msgEntrada);
        }catch(exception e){
            system.debug(e.getStackTraceString());
            respuesta.msgError.mensajeError=e.getMessage();
        }
        
        return respuesta;
    }
    
    /*
	* @Método: 		WSIniciarFacturacion
	* @Parámetros:	MsgEntradaInicioFacturacion
	* @Descripción:	Método expuesto por WS para recibir la información del inicio de la facturación
	*/ 
    
    static webservice MsgSalidaSincronizacionLineas WSSincronizarLinea(MsgEntradaSincronizacionLineas msgEntrada){
       	System.debug('Mensaje entrada sincronizar linea:' + msgEntrada);
        MsgSalidaSincronizacionLineas respuesta = new MsgSalidaSincronizacionLineas();
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        try{
            if(String.isNotEmpty(msgEntrada.sincronizacionLinea.numeroOC)){
                //Invocación clase de implementación 
                respuesta = IntegracionGestor_cls.SincronizarLineaImp(msgEntrada);
            }else{
                respuesta.msgError.mensajeError='No se porporciono numero de OC';
            }
        }catch(exception e){
            system.debug(e.getStackTraceString());
            respuesta.msgError.mensajeError=e.getMessage();
        }
        return respuesta;
    }
    
    /*
	* @Método: 		WSActualizarEstado
	* @Parámetros:	MsgEntradaActualizarEstado
	* @Descripción:	Método expuesto por WS para recibir actualizaciones de estado desde gestor.
	*/    
    
    static webservice MsgSalidaActualizarEstado WSActualizarEstado(MsgEntradaActualizarEstado msgEntrada){
        
        System.debug('Mensaje entrada actualizar estado:' + msgEntrada);
        MsgSalidaActualizarEstado respuesta = new MsgSalidaActualizarEstado();
        
        // Insertar log de entrada
        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion;
        logServicio.Informacion_Recibida__c = String.valueOf(msgEntrada);
        logServicio.Name = 'Actualizar Estado ' + msgEntrada.transaccion.idTransaccion;
        insert logServicio;
        
        try{
            
            String sTipoSolicitud = String.isEmpty(msgEntrada.actualizarEstado.tipoSolicitud)?'':msgEntrada.actualizarEstado.tipoSolicitud;
            List<Homologacion_Gestor__mdt> lstHGsTipoSolicitud = new List<Homologacion_Gestor__mdt>();
            system.debug(sTipoSolicitud);
            
            if(String.isNotEmpty(sTipoSolicitud))
                lstHGsTipoSolicitud = [SELECT Id,Valor_API__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'TIPO_SOLICITUD_GESTOR' AND Valor_Usuario__c = :sTipoSolicitud];
            
            if(lstHGsTipoSolicitud.isEmpty()){
                respuesta.msgError.mensajeError='Tipo de solicitud no valido';
            }else{
                
                if(lstHGsTipoSolicitud[0].Valor_API__c == 'Viabilidad'){
                
                    //Relacionar log de entrada con la viabilidad
                    List<Viabilidad__c> Viabilidad = [SELECT Id FROM Viabilidad__c where name =: msgEntrada.actualizarEstado.numeroViabilidad];
                    System.debug('Id de la viabilidad:' + Viabilidad);
                    logServicio.NumeroViabilidad__c = Viabilidad[0].Id;
                    logServicio.Name = 'Actualizar Estado ' + msgEntrada.actualizarEstado.numeroViabilidad;
                    update logServicio;
                    
                    //Invocación clase de implementación
                    respuesta = IntegracionGestor_cls.ActualizarEstadoImp(msgEntrada);
                    
                    //Insertar log de salida 
                    logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
                    update logServicio;
                    
                } else if(lstHGsTipoSolicitud[0].Valor_API__c == 'Aprovisionamiento'){
                    
                    //Relacionar log de entrada con la OC
                    List<OperacionComercial__c> OC = [SELECT Id FROM OperacionComercial__c where name =: msgEntrada.actualizarEstado.numeroOC];
                    System.debug('Id de la Operación Comercial:' + OC);
                    logServicio.LTE_Operacion_Comercial__c = OC[0].Id;
                    logServicio.Name = 'Actualizar Estado ' + msgEntrada.actualizarEstado.numeroOC;
                    update logServicio;
                    
                    //Invocación clase de implementación
                    respuesta = IntegracionGestor_cls.ActualizarEstadoImp(msgEntrada);
                    
                    //Insertar log de salida
                    logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
                    update logServicio; 
                    
                }else{
                    respuesta.msgError.mensajeError='No se envia tipo de solicitud correcta';
                    respuesta.resultado = 'Erroneo';
                    respuesta.msgError.codigoError='NOK';
                    logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
                    update logServicio;
                }
            }
        
        }catch(exception e){
            respuesta.msgError.mensajeError=e.getMessage();
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.codigoError='NOK';
            logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
	       	update logServicio;
        }
        System.debug('respuesta: ' + respuesta);        
        return respuesta;
    }       
    

    /**
    * @description Método del WS que actualiza el cambio de la fecha agenda del aprovisionamiento
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 05-09-2022 
    * @param msgEntrada 
    * @return MsgSalidaInicioFacturacion 
    **/
    static webservice MsgSalidaInicioFacturacion WSCambioFechaAgenda(MsgEntradaInicioFacturacion msgEntrada){
        System.debug('Mensaje entrada iniciar facturación:' + msgEntrada);
        MsgSalidaInicioFacturacion respuesta = new MsgSalidaInicioFacturacion();
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        try{
            //Invocación clase de implementación 
            respuesta = IntegracionGestor_cls.CambioFechaAgenda(msgEntrada);
        }catch(exception e){
            system.debug(e.getStackTraceString());
            respuesta.msgError.mensajeError=e.getMessage();
        }
        
        return respuesta;
    }
   
}