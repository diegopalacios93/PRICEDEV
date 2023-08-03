global class IntegracionCollections_ws {

    global class MsgEntrada{
        webservice string accion='';        
        webservice msgCuentasFact lstCuentasFact;
    }
    global class msgCuentasFact{
        webservice list<MsgKeys> Keys;
    } 
    global class MsgKeys{
        webservice string NumeroDeCuenta='';        
    }
    global class MsgSalida{
        webservice string resultado='';                
        webservice MsgError msgError = new MsgError();
    }
     global class MsgError{
        webservice string codigoError='';
        webservice string mensajeError='';
    }
    
	//    
    webservice static MsgSalida WSActualizarServicios(MsgEntrada mensajeEntrada){
        MsgSalida respuesta = new MsgSalida();        
        boolean validacionInputCuentas = true;
        
        try{
            if(mensajeEntrada.accion == null || mensajeEntrada.accion == '' || mensajeEntrada.accion == '?')
            {
                respuesta.resultado = 'Erroneo';
                respuesta.msgError.codigoError = '-1';
                respuesta.msgError.MensajeError = Label.Collections_IngresarAccion;
                
            }else if(!LTE_TramitesSuspenda__c.getAll().containsKey(mensajeEntrada.accion)){
                    respuesta.resultado = 'Erroneo';
                    respuesta.msgError.codigoError = '-1';
                    respuesta.msgError.MensajeError = Label.Collections_AccionNoValida;
            }else{                                
                for(MsgKeys MsgKeyAux: MensajeEntrada.lstCuentasFact.Keys){                
                    if(MsgKeyAux.NumeroDeCuenta == null || MsgKeyAux.NumeroDeCuenta == '' || MsgKeyAux.NumeroDeCuenta == '?'){
                        validacionInputCuentas = false;
                        break;  
                    }                                 
                }
                if(!validacionInputCuentas){
                	respuesta.resultado = 'Erroneo';
                	respuesta.msgError.codigoError = '-1';
                	respuesta.msgError.MensajeError = Label.Collections_IngresarCuentasFact;
            	}
                else{
                    string tramiteAccion;
                    string causalAccion;
                    //Obtener trámite y causal a ejecutar
                    list<String> lstTramiteCausal = mensajeEntrada.accion.split(',');
                    if(lstTramiteCausal.size() == 2){
                        tramiteAccion = lstTramiteCausal[0];
                        causalAccion  = lstTramiteCausal[1];                
                        
                        //registrar transacción                        
                        LogTransacciones__c logTransaccion = new LogTransacciones__c();
                        logTransaccion.AC_CorrelationID_Random__c = dateTime.now()+'';
                        logTransaccion.Informacion_Recibida__c = String.valueOf(mensajeEntrada);
                        logTransaccion.Name = 'Proceso de Collections';
                        insert logTransaccion;                       
                        
                        //Procesar cuentas de facturación
                        map<string,string> mapInputData=new map<string,string>();
                        string jsonstringMapInputData;
                        for(MsgKeys MsgKeyAux: MensajeEntrada.lstCuentasFact.Keys){                
                            mapInputData.put('tramite',tramiteAccion);
                            mapInputData.put('causal', causalAccion);
                            mapInputData.put('cuentaFacturacion', MsgKeyAux.NumeroDeCuenta);
                            mapInputData.put('logID', logTransaccion.Id);
                            jsonstringMapInputData = JSON.serialize(mapInputData);
                            ProcesosCollections_cls.procesarAccion(jsonstringMapInputData);                            
                        }                                                                        
                        //respuesta petición enviada
                        respuesta.resultado = 'Exitoso ';
                    	respuesta.msgError.codigoError = '0';
                    }else{                        
                        respuesta.resultado = 'Erroneo';
                        respuesta.msgError.codigoError = '-1';
                        respuesta.msgError.MensajeError = Label.Collections_AccionNoValida;
                    }                    
                } 
            }
             
        }catch(exception e){
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.mensajeError=e.getMessage()+e.getStackTraceString();
            respuesta.msgError.codigoError='NOK-Apex';
        }        
        return respuesta;
    }
}