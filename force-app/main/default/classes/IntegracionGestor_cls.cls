/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase que declara los métodos de integracion con el Gestor.

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2018-04-15   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
global class IntegracionGestor_cls {
	
    /*
	* @Método: 		RespuestaViabilidadImp
	* @Parámetros:	IntegracionGestor_ws.MsgEntradaResVia
	* @Descripción:	Método donde se implementa la inserción de la respuesta de la viabilidad con sus opciones de aprovisionamiento
    *               en un objeto Opcion_Aprovisionamiento__c de Salesforce.   
	*/
    
    public static IntegracionGestor_ws.MsgSalidaResVia RespuestaViabilidadImp(IntegracionGestor_ws.MsgEntradaResVia msgEntrada){
        
        IntegracionGestor_ws.MsgSalidaResVia respuesta = new IntegracionGestor_ws.MsgSalidaResVia();
        
	    try{
            //Encontrar viabilidad relacionada
            List<Viabilidad__c> Viabilidad = [SELECT Id,OperacionComercial__c, OperacionComercial__r.Id FROM Viabilidad__c where name =: msgEntrada.respuestaViabilidad.numeroViabilidad];
            System.debug('Id de la viabilidad RespuestaViabilidadImp:' + Viabilidad);
            
            
            Map<String, String> ApiNamesOC = new Map<String, string>();
            Map<String, String> HomologVIA = new Map<String, string>();
            HomologVIA.put('AliadoColaborador__c','Aliado__c');
            HomologVIA.put('TipoVenta__c','Tipo_de_Aliado__c');
            ApiNamesOC = obtenerListaNameApinames('Viabilidad__c',ApiNamesOC);
      		//Insertar las opciones de la viabilidad en objeto Opcion_Aprovisionamiento__c de salesforce
            //System.debug('opcionesViabilidad:' + msgEntrada.respuestaViabilidad.opcionesViabilidad);
            if(msgEntrada.respuestaViabilidad.opcionesViabilidad != null){
                if(msgEntrada.respuestaViabilidad.opcionesViabilidad.opcion != null){
                    for (IntegracionGestor_ws.Opcion opc : msgEntrada.respuestaViabilidad.opcionesViabilidad.opcion) {
                        
                        //Crear objeto Opcion_Aprovisionamiento__c por cada opción
                        Opcion_Aprovisionamiento__c opcionAprovisionamiento = new Opcion_Aprovisionamiento__c();
                        opcionAprovisionamiento.NumeroViabilidad__c = Viabilidad[0].Id;
                        opcionAprovisionamiento.Operaci_n_Comercial__c = Viabilidad[0].OperacionComercial__c;
                        opcionAprovisionamiento.IdOpcion__c = opc.idOpcion;
                        opcionAprovisionamiento.Observaciones__c = opc.observaciones;
                        opcionAprovisionamiento.DetallesOpcion__c = '';
                        opcionAprovisionamiento.ConfiguracionServicio__c ='';
                        System.debug('opc.detalleOpcion: ' + opc.detalleOpcion);
                        if(opc.detalleOpcion != null){
                            System.debug('opc.detalleOpcion.parametroOp: ' + opc.detalleOpcion.parametroOp);
                            if(opc.detalleOpcion.parametroOp != null){
                                System.debug('Numero de parametros para IdOpcion ' + opc.idOpcion + ': ' + opc.detalleOpcion.parametroOp.size());
                                for (IntegracionGestor_ws.ParametroOp par : opc.detalleOpcion.parametroOp) {
                                    opcionAprovisionamiento.DetallesOpcion__c = opcionAprovisionamiento.DetallesOpcion__c + (par.nombre + ';'+ par.valor +';' + par.fila +'|');
                                    System.debug('DetallesOpcion: ' + opcionAprovisionamiento.DetallesOpcion__c);
                                    if(HomologVIA.containskey(par.nombre)){
                                        if(ApiNamesOC.containskey(HomologVIA.get(par.nombre))){
                                            try{
                                                if(par.nombre == 'AliadoColaborador__c'){
                                                    Account ObjAccount = [SELECT Id FROM Account WHERE Name =: par.valor AND RecordType.DeveloperName = 'Aliado' LIMIT 1];
                                                    if(ObjAccount != null)
                                                        Viabilidad[0].put(HomologVIA.get(par.nombre), ObjAccount.Id);
                                                }else
                                                    Viabilidad[0].put(HomologVIA.get(par.nombre),par.valor);
                                            }catch(Exception e){}
                                        }
                                    }
                                }
                            }
                        }
                        System.debug('opc.configuracionServicio: ' + opc.configuracionServicio);
                        if(opc.configuracionServicio != null){
                            System.debug('opc.configuracionServicio.item: ' + opc.configuracionServicio.item);
                            if(opc.configuracionServicio.item != null){
                                for (IntegracionGestor_ws.Item it : opc.configuracionServicio.item) {
                                    opcionAprovisionamiento.ConfiguracionServicio__c = opcionAprovisionamiento.ConfiguracionServicio__c + (it.elemento + ';'+ it.referencia +';' + it.cantidad +';' + it.descripcion + ' ' +'|');
                                    System.debug('Configuración servicio: ' + opcionAprovisionamiento.DetallesOpcion__c);
                                }
                            }
                        }
                     insert opcionAprovisionamiento;
                    }
                }
            }
            
            //Insertar los objetos URL_Archivo con las URLs recibidas en el servicio 
            System.debug('URLs: ' + msgEntrada.respuestaViabilidad.URLs);
            if(msgEntrada.respuestaViabilidad.URLs != null){
            	if(msgEntrada.respuestaViabilidad.URLs.parametro != null){
            		InsertarURLs(Viabilidad[0].Id,msgEntrada.respuestaViabilidad.URLs);
                }
            }
                        
            //Actualizar valores de la viabilidad recibidas en el servicio
            ActualizarViabilidadResVia(Viabilidad[0], msgEntrada);
        	
            respuesta.resultado = 'Exitoso';
        }catch(exception e){
            respuesta.msgError.mensajeError=e.getMessage();
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.codigoError='NOK';
        }
      return respuesta;
    }
    
    /*
	* @Método: 		ObtenerOpcionesViaclass
	* @Descripcion:	Método implementado para convertir una lista de objetos Opcion_Aprovisionamiento__c en clases 
	*               de salesforce OpcionesViabilidad.   
	*/
    
    public static IntegracionGestor_ws.OpcionesViabilidad ObtenerOpcionesViaclass(List<Opcion_Aprovisionamiento__c> listaoaprv){
        
    	IntegracionGestor_ws.OpcionesViabilidad ov = new IntegracionGestor_ws.OpcionesViabilidad();
        //Iterar por las opciones encontradas 
        for(Opcion_Aprovisionamiento__c oaprv :listaoaprv){
        	 System.debug('opcion ObtenerOpcionesViaclass : ' + oaprv.IdOpcion__c);
           	 System.debug('DetallesOpcion__c : ' + oaprv.DetallesOpcion__c);
        	IntegracionGestor_ws.Opcion o = new IntegracionGestor_ws.Opcion();
            o.idOpcion=oaprv.IdOpcion__c;
            System.debug('idOpcion: ' + o.idOpcion);
            o.observaciones=oaprv.Observaciones__c;
            System.debug('observaciones: ' + o.observaciones);
            System.debug('oaprv.DetallesOpcion__c: ' + oaprv.DetallesOpcion__c);
            
            //Obtener los detalles para cada opción 
            IntegracionGestor_ws.DetalleOpcion detop = new IntegracionGestor_ws.DetalleOpcion();
            if(oaprv.DetallesOpcion__c!= null){
            	System.debug('oaprv.DetallesOpcion__c: ' + oaprv.DetallesOpcion__c);
            	//System.debug('oaprv.DetallesOpcion__c.contains | ' + oaprv.DetallesOpcion__c.contains('|'));
            	List<String> optionDetails = oaprv.DetallesOpcion__c.split('\\|');
            	System.debug('optionDetails: ' + optionDetails);
            	for (String optionDetail : optionDetails) {
           			List<String> optionParameters = optionDetail.split(';');
             		//System.debug('optionParameters: ' + optionParameters);
             		IntegracionGestor_ws.ParametroOp pop =new IntegracionGestor_ws.ParametroOp();
             		pop.nombre=optionParameters[0];
             		pop.valor=optionParameters[1];
             		pop.fila=optionParameters[2];
	         		detop.parametroOp.add(pop);
	        		//System.debug('detop:' + detop);
		    	}
            	o.detalleOpcion=detop;
            }else{
            	o.detalleOpcion=detop;
            }
            
            System.debug('o.detalleOpcion ' + o.detalleOpcion);
           	//Obtener la configuración del servicio para cada opción
           	IntegracionGestor_ws.ConfiguracionServicio conser = new IntegracionGestor_ws.ConfiguracionServicio();
            if(oaprv.ConfiguracionServicio__c!=null){
          		List<String> configServicios = oaprv.ConfiguracionServicio__c.split('\\|');
                for (String ConfigServicio : configServicios) {
           			List<String> items = ConfigServicio.split(';');
                    System.debug('items de la config servicio: ' + items);
                	IntegracionGestor_ws.Item it =new IntegracionGestor_ws.Item();
                    if(items[0] != 'null'){
                    	it.elemento=items[0];
                    }else{
                    	it.elemento='';                          
                    }
                    if(items[1] != 'null'){
                    	it.referencia=items[1];
                    }else{
                        it.referencia='';
                    }
                    if(items[2] != 'null'){
                    	it.cantidad=items[2];
                    }else{
                        it.cantidad='';
                    }
                    if(items[3] != 'null '){
                        it.descripcion=items[3];
                    }else{
                        it.descripcion = '';
                    }
               		conser.item.add(it);
                	//System.debug('configuracion servicio:' + conser);
		       	}
            	o.configuracionServicio=conser;
           }else{
               o.configuracionServicio=conser;
           }
            ov.opcion.add(o);
        }         
        System.debug('OpcionesViabilidad: ' + ov);
        return ov;
    } 
    
    /*
	* @Método: 		ObtenerOpcionclass
	* @Descripcion:	Método implementado para convertir un objeto Opcion_Aprovisionamiento__c en clase de salesforce.   
	*/    
    
    public static IntegracionGestor_ws.Opcion ObtenerOpcionclass(Opcion_Aprovisionamiento__c oaprv){
        
    	System.debug('opcion : ' + oaprv.IdOpcion__c);
        // System.debug('DetallesOpcion__c : ' + oaprv.DetallesOpcion__c);
        IntegracionGestor_ws.Opcion o = new IntegracionGestor_ws.Opcion();
        o.idOpcion=oaprv.IdOpcion__c;
        //System.debug('idOpcion: ' + o.idOpcion);
        o.observaciones=oaprv.Observaciones__c;
        //System.debug('observaciones: ' + o.observaciones);

        //Obtener los detalles para cada opción 
        List<String> optionDetails = oaprv.DetallesOpcion__c.split('\\|');
        //System.debug('optionDetails: ' + optionDetails);
        IntegracionGestor_ws.DetalleOpcion detop = new IntegracionGestor_ws.DetalleOpcion();
        for (String optionDetail : optionDetails) {
        	List<String> optionParameters = optionDetail.split(';');
            //System.debug('optionParameters: ' + optionParameters);
            IntegracionGestor_ws.ParametroOp pop =new IntegracionGestor_ws.ParametroOp();
            pop.nombre=optionParameters[0];
            pop.valor=optionParameters[1];
            pop.fila=optionParameters[2];
	        detop.parametroOp.add(pop);
	        //System.debug('detop:' + detop);
		 }
         o.detalleOpcion=detop;
          
         //Obtener la configuración del servicio para dada opción
         List<String> configServicios = oaprv.ConfiguracionServicio__c.split('\\|');
         IntegracionGestor_ws.ConfiguracionServicio conser = new IntegracionGestor_ws.ConfiguracionServicio();
         for (String ConfigServicio : configServicios) {
         	List<String> items = ConfigServicio.split(';');
            IntegracionGestor_ws.Item it =new IntegracionGestor_ws.Item();
            it.elemento=items[0];
            it.referencia=items[1];
            it.cantidad=items[2];
            it.descripcion=items[3];
            conser.item.add(it);
            //System.debug('configuracion servicio:' + conser);
		 }
         o.configuracionServicio=conser;
         System.debug('OpcionViabilidad: ' + o);
         return o;
    }

    /*
	* @Método: 		obtenerListaNameApinames
	* @Descripcion:	Método implementado para generar arreglo de ApiNmaes y Names de un objeto.   
	*/ 
     
    public static  Map<String, String> obtenerListaNameApinames(string apiname, Map<String,String> listaNombresApi){
        
		SObjectType objToken = Schema.getGlobalDescribe().get(apiname);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        Set<String> fieldSet = fields.keySet();
        for(String s:fieldSet)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            //System.debug('Apiname:'+ selectedField.getName());
            //System.debug('Name' + selectedField.getLabel());
            listaNombresApi.put(selectedField.getName(),selectedField.getLabel());
        }
        //System.debug('listaNombresApi:'+ listaNombresApi);
        return listaNombresApi;
    }
    
    /*
	* @Método: 		ObtenerIdAliado
	* @Descripcion:	Método implementado para obtener el id del aliado con el Nombre enviado en el servicio.   
	*/ 
     
    public static  id ObtenerIdAliado(String nombreAliado){
        
        Id idAliado;
        List<Account> Account = [SELECT Id,Name FROM Account where name =: nombreAliado AND RecordType.DeveloperName = 'Aliado'];
		idAliado = Account[0].Id;
	    System.debug('idAliado:'+ idAliado);
        return idAliado; 
    }
    
    /*
	* @Método: 		ActualizarViabilidadResVia
	* @Descripcion:	Método implementado para actualizar el objeto Viabilidad__c con la informacion recibida por el servicio.   
	*/ 
     
    public static  void ActualizarViabilidadResVia(Viabilidad__c viabilidad , IntegracionGestor_ws.MsgEntradaResVia msgEntrada){

        System.debug('ActualizarViabilidadResVia :: viabilidad: ' + viabilidad);
        System.debug('ActualizarViabilidadResVia :: msgEntrada: ' + msgEntrada);
        if(msgEntrada.respuestaViabilidad.aliado != null){
        	if(msgEntrada.respuestaViabilidad.aliado != ''){
	    		viabilidad.Aliado__c = ObtenerIdAliado(msgEntrada.respuestaViabilidad.aliado);
            }
        }
        if(msgEntrada.respuestaViabilidad.causal != null && msgEntrada.respuestaViabilidad.causal != ''){            
            //Actualizar oportunidad            
            Viabilidad__c viaAux;
            string viaAdicional;
            viaAux = [Select Oportunidad__r.Id from Viabilidad__c Where Name =: msgEntrada.respuestaViabilidad.numeroViabilidad LIMIT 1];
             
            if(viaAux.Oportunidad__r.Id != null){        	    
                Opportunity oportunidad = new Opportunity(Id = viaAux.Oportunidad__r.Id);                
                viaAdicional = msgEntrada.respuestaViabilidad.causal;
                                 
                if(viaAdicional != null && viaAdicional != ''){
                	oportunidad.Viabilidad_Adicional__c = viaAdicional;
                	update oportunidad;                     
                }
            }           
        	viabilidad.Causal__c = msgEntrada.respuestaViabilidad.causal;        	
        }
        if(msgEntrada.respuestaViabilidad.estadoViabilidad != null && msgEntrada.respuestaViabilidad.estadoViabilidad != ''){
        	viabilidad.EstadoViabilidad__c = msgEntrada.respuestaViabilidad.estadoViabilidad;
        }
        if(msgEntrada.respuestaViabilidad.grupoAsignacion != null && msgEntrada.respuestaViabilidad.grupoAsignacion != ''){
        	viabilidad.Grupo_de_Asignacion__c = msgEntrada.respuestaViabilidad.grupoAsignacion;
        }
        
        if(msgEntrada.respuestaViabilidad.responsable != null && msgEntrada.respuestaViabilidad.responsable != ''){
        	viabilidad.Ing_Factibilidad__c = msgEntrada.respuestaViabilidad.responsable;
        }
        if(msgEntrada.respuestaViabilidad.respuesta != null && msgEntrada.respuestaViabilidad.respuesta != ''){
            String srespuesta = ((msgEntrada.respuestaViabilidad.respuesta).replaceAll('<!\\[CDATA\\[', '')).replaceAll('\\]\\]>', '');
       		viabilidad.Observaciones__c = srespuesta.length()>50000?srespuesta.substring(0, 50000):srespuesta;
       		viabilidad.Respuesta_Gestor__c = (srespuesta.unescapeHtml4()).unescapeHtml4();
        }
        if(msgEntrada.respuestaViabilidad.respuestaViabilidad != null && msgEntrada.respuestaViabilidad.respuestaViabilidad != ''){
        	viabilidad.Respuestadeviabilidad__c = msgEntrada.respuestaViabilidad.respuestaViabilidad;            
            viabilidad.EstadoViabilidad__c = 'Cerrada';
            viabilidad.Fecha_Cierre_Cambio_Factibilidad__c = Date.today();
        }
        if(msgEntrada.respuestaViabilidad.tipoAliado != null && msgEntrada.respuestaViabilidad.tipoAliado != ''){
        	viabilidad.Tipo_de_Aliado__c = msgEntrada.respuestaViabilidad.tipoAliado;
        }
        if(msgEntrada.respuestaViabilidad.tipoViabilidad != null && msgEntrada.respuestaViabilidad.tipoViabilidad != ''){
        	viabilidad.Tipo_de_Viabilidad__c = msgEntrada.respuestaViabilidad.tipoViabilidad;
        }
        //JACERO 25072018 ACTUALIZA CAMPOS DINAMICAMENTE CON ARREGLO LLAVE, VALOR
        if(msgEntrada.respuestaViabilidad.detallesViabilidad.parametro != null){
            for (IntegracionGestor_ws.parametro ActEstViab : msgEntrada.respuestaViabilidad.detallesViabilidad.parametro) {
                
                //Se actualiza campos
                ActCamposDinamicosViabilidad(viabilidad, ActEstViab);
            }
        }
        
        update viabilidad; 
        System.debug('ActualizarViabilidadResVia salida :: viabilidad: ' + viabilidad);
        
    }
    
        /*
	* @Método: 		InsertarURLs
	* @Descripcion:	Método implementado para insertar los objetos URL_Archivo y relacionarlos con la Viabilidad.   
	*/ 
     
    public static  void InsertarURLs(Id idViabilidad , IntegracionGestor_ws.URLs listaURLs){

        System.debug('listaURLs: '+ listaURLs);	
        if(listaURLs != null){
        for (IntegracionGestor_ws.Parametro URLParametro : listaURLs.parametro){
        	URL_Archivo__c URLArchivo = new URL_Archivo__c();
            URLArchivo.URL__c = URLParametro.valor;
            if(URLParametro.nombre.Length()>80)
            	URLArchivo.Name = URLParametro.nombre.substring(0, 80);
            else
                URLArchivo.Name = URLParametro.nombre;
            
            URLArchivo.Nombre_completo__c = URLParametro.nombre;
            URLArchivo.NumeroViabilidad__c = idViabilidad;
            insert URLArchivo;
            System.debug('URL_Archivo: '+ URLArchivo);
            }
        }
    }
    
    /*
	* @Método: 		ObtenerCamposURL
	* @Descripcion:	Método para consumo por JavaScript implementado para obtener desde la URL los campos necesarios para 
    *               la solicitud POST hacia Gestor.   
	*/
    
    static webservice String ObtenerCamposURL(String url, String nombreCampo) {
        
        System.debug('url: '+ url);
        System.debug('nombreCampo: ' + nombreCampo);
        String valorCampo='';
        String action='';
        Map<String, String> m = new Map<String, String>();
        m.put('accion', url.substringBefore('?'));
        //System.debug('accion: ' + m);      
        If(url != '' ){
        	String cadenaDatos = url.substringAfter('?');
        	//System.debug('cadenaDatos: '+ cadenaDatos);
        	List<String> campos = cadenaDatos.split('&');
        	//System.debug('campos: '+ campos);
            For(String campo : campos){
        	    m.put(campo.substringBefore('='), campo.substringAfter('='));  
        	}
        }
        if(String.isNotEmpty(nombreCampo)){
            if(m.containskey(nombreCampo)){
                valorCampo = m.get(nombreCampo);
            }
        }
        return String.isEmpty(valorCampo)?'':valorCampo;
/*        //System.debug('m: '+ m);
        If(nombreCampo == 'accion'){
        valorCampo = m.get('accion');
        }
        If(nombreCampo == 'idA'){
            valorCampo = m.get('idA');
        }
        If(nombreCampo == 'idS'){
            valorCampo = m.get('idS');
        }
        If(nombreCampo == 'tS'){
            valorCampo = m.get('tS');
        }
         If(nombreCampo == 't'){
            valorCampo = m.get('t');
        }
        If(nombreCampo == ''){
            valorCampo = '';
        }
        System.debug('valorCampo: ' + valorCampo);
        If (valorCampo == null){
            return '';
        }else{
   		 return valorCampo;
        }*/
    }
    
    /*
	* @Método: 		ActualizarGrupoPropietarioImp
	* @Parámetros:	IntegracionGestor_ws.MsgEntradaActGrupoPropietario
	* @Descripcion:	Método donde se implementa la actualización de la información del grupo propietario.   
	*/
    
    public static IntegracionGestor_ws.MsgSalidaActGrupoPropietario ActualizarGrupoPropietarioImp(IntegracionGestor_ws.MsgEntradaActGrupoPropietario msgEntrada){
    	
        IntegracionGestor_ws.MsgSalidaActGrupoPropietario respuesta = new IntegracionGestor_ws.MsgSalidaActGrupoPropietario();
  		try{
            
            String sTipoSolicitud = String.isEmpty(msgEntrada.actualizarGrupoPropietario.tipoSolicitud)?'':msgEntrada.actualizarGrupoPropietario.tipoSolicitud;
            List<Homologacion_Gestor__mdt> lstHGsTipoSolicitud = new List<Homologacion_Gestor__mdt>();
            system.debug(sTipoSolicitud);
            
            if(String.isNotEmpty(sTipoSolicitud))
                lstHGsTipoSolicitud = [SELECT Id,Valor_API__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'TIPO_SOLICITUD_GESTOR' AND Valor_Usuario__c = :sTipoSolicitud];
            
            if(lstHGsTipoSolicitud.isEMpty()){
                respuesta.msgError.mensajeError='Tipo de solicitud no valido';
                respuesta.resultado = 'Erroneo';
                respuesta.msgError.codigoError='NOK';
            }
            else{
                if(lstHGsTipoSolicitud[0].Valor_API__c == 'Viabilidad'){
                    
                    Viabilidad__c viabilidad = new Viabilidad__c();
                    //Encontrar viabilidad relacionada
                    List<Viabilidad__c> viabilidades = [SELECT Id, OperacionComercial__r.Id FROM Viabilidad__c where name =: msgEntrada.actualizarGrupoPropietario.numeroViabilidad];
                    //System.debug('viabilidades:' + viabilidades);
                    viabilidad = viabilidades[0];
                    
                    //Actualizar valores de la Viabilidad
                    //System.debug('grupoAsignacion: ' + msgEntrada.actualizarGrupoPropietario.grupoAsignacion);
                    if(msgEntrada.actualizarGrupoPropietario.grupoAsignacion != null && msgEntrada.actualizarGrupoPropietario.grupoAsignacion != ''){
                        viabilidad.Grupo_de_Asignacion__c = msgEntrada.actualizarGrupoPropietario.grupoAsignacion;
                    }
                    //System.debug('responsable: ' + msgEntrada.actualizarGrupoPropietario.responsable); 
                    if(msgEntrada.actualizarGrupoPropietario.responsable != null && msgEntrada.actualizarGrupoPropietario.responsable != ''){               
                        viabilidad.Ing_Factibilidad__c = msgEntrada.actualizarGrupoPropietario.responsable;
                    }
                    
                    //JACERO 25072018 ACTUALIZA CAMPOS DINAMICAMENTE CON ARREGLO LLAVE, VALOR
                    if(msgEntrada.actualizarGrupoPropietario.detallesActualizarGrupoPropietario.parametro != null){
                        for (IntegracionGestor_ws.parametro ActEstViab : msgEntrada.actualizarGrupoPropietario.detallesActualizarGrupoPropietario.parametro) {
                            
                            //Se actualiza campos
                            ActCamposDinamicosViabilidad(viabilidad, ActEstViab);
                        }
                    }
                    
                    update viabilidad;
                    System.debug('viabilidad: ' + viabilidad);            
                }
                else if(lstHGsTipoSolicitud[0].Valor_API__c == 'Aprovisionamiento'){
                    
                    OperacionComercial__c operacioncomercial = new OperacionComercial__c();
                    //Encontrar la OC relacionada
                    List<OperacionComercial__c> OCs = [SELECT Id FROM OperacionComercial__c where name =: msgEntrada.actualizarGrupoPropietario.numeroOC];
                    System.debug('Id de la Operación Comercial:' + OCs);
                    operacioncomercial = OCs[0];
                    
                    //Actualizar valores de la OC
                    //System.debug('grupoAsignacion: ' + msgEntrada.actualizarGrupoPropietario.grupoAsignacion);
                    if(msgEntrada.actualizarGrupoPropietario.grupoAsignacion != null && msgEntrada.actualizarGrupoPropietario.grupoAsignacion != ''){               
                        operacioncomercial.Grupo_de_Asignaci_n__c = msgEntrada.actualizarGrupoPropietario.grupoAsignacion;
                    }
                    //System.debug('responsable: ' + msgEntrada.actualizarGrupoPropietario.responsable);
                    if(msgEntrada.actualizarGrupoPropietario.responsable != null && msgEntrada.actualizarGrupoPropietario.responsable != ''){
                        operacioncomercial.Responsable_Red_Inteligente__c = msgEntrada.actualizarGrupoPropietario.responsable;
                    }
                    
                    //JACERO 25072018 ACTUALIZA CAMPOS DINAMICAMENTE CON ARREGLO LLAVE, VALOR
                    if(msgEntrada.actualizarGrupoPropietario.detallesActualizarGrupoPropietario.parametro != null){
                        for (IntegracionGestor_ws.parametro ActEstAprov : msgEntrada.actualizarGrupoPropietario.detallesActualizarGrupoPropietario.parametro) {
                            
                            //Se actualiza campos
                            ActCamposDinamicosAprov(operacioncomercial, ActEstAprov);
                        }
                    }
                    
                    update operacioncomercial;
                    System.debug('operacioncomercial: ' + operacioncomercial);
                }
                respuesta.resultado = 'Exitoso';
                respuesta.msgError.codigoError='';
            }
        }catch(exception e){
            respuesta.msgError.mensajeError=e.getMessage();
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.codigoError='NOK';
        }
        return respuesta;
    }
    
    /*
	* @Método: 		IniciarFacturacionImp
	* @Parámetros:	IntegracionGestor_ws.MsgEntradaInicioFacturacion
	* @Descripcion:	Método donde se implementa la actualización de la información para el inicio de la facturación.   
	*/
    
    public static IntegracionGestor_ws.MsgSalidaInicioFacturacion IniciarFacturacionImp(IntegracionGestor_ws.MsgEntradaInicioFacturacion msgEntrada){
        LogTransacciones__c logServicio = new LogTransacciones__c(AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion,Informacion_Recibida__c = String.valueOf(msgEntrada),Name = 'Iniciar Facturación ' + msgEntrada.transaccion.idTransaccion);
        IntegracionGestor_ws.MsgSalidaInicioFacturacion respuesta = new IntegracionGestor_ws.MsgSalidaInicioFacturacion();
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        List<Linea__c> lstLineas = new List<Linea__c>();
        String sErrorMessage = '';
        List<Id> lstNumeroAbb = new List<Id>();
        try{
        List<OperacionComercial__c> lstOC = [SELECT Id, Name, RangoNumeracion__c,FechadeActivacion__c,Activo__c,TOPP__r.Actualiza_Servicio_en_Gestor__c, TOPP__r.Requiere_Numeracion__c, Plan__r.Name, Plan__r.Plan_Troncales_Sip_Movil__c, Plan__r.TipodePlan__c, Plan__r.NombredelProducto__r.Name,topp__r.TipodeOperacionporplan__c,Operacion_Comercial_Relacionada__c, Numero_Abreviado__c, Numero_Abreviado_segunda_opcion__c, RecordTypeId FROM OperacionComercial__c where name =: msgEntrada.inicioFacturacion.numeroOC];
            if(!lstOC.isEmpty()){
                OperacionComercial__c sglOC=lstOC[0];
                try{
                    String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c;
                    System.debug('**producto '+producto);
                    String sNumeracion10D = VariablesGlobales__c.getValues('Numeracion10Digitos').valor__c;
                    if(String.isNotEmpty(msgEntrada.inicioFacturacion.estado)){
                        if(sglOC.Plan__r.NombredelProducto__r.Name != producto || 
                        (sglOC.Plan__r.NombredelProducto__r.Name == producto && 
                        ((sglOC.Plan__r.TipodePlan__c == 'Troncal SIP' &&
                         (sglOC.topp__r.TipodeOperacionporplan__c == 'Modificación Servicio'||sglOC.topp__r.TipodeOperacionporplan__c == 'Modificación Estándar')) 
                         || (sglOC.Plan__r.TipodePlan__c == 'Principal' && sglOC.Plan__r.Plan_Troncales_Sip_Movil__c == true))))
                         {
                            sglOC.Estado__c = (msgEntrada.inicioFacturacion.estado=='Activo' || msgEntrada.inicioFacturacion.estado=='Suspendido' || msgEntrada.inicioFacturacion.estado=='Inactivo')?'Activa':msgEntrada.inicioFacturacion.estado;
                            if(sglOC.topp__r.TipodeOperacionporplan__c=='Cambio de Suscriptor Nuevo' && sglOC.Operacion_Comercial_Relacionada__c!=null){
                                OperacionComercial__c sglOCRel = new OperacionComercial__c(Id=sglOC.Operacion_Comercial_Relacionada__c);
                                sglOCRel.Estado__c = msgEntrada.inicioFacturacion.estado=='Activo'?'Activa':msgEntrada.inicioFacturacion.estado;
                                if(String.isNotEmpty(msgEntrada.inicioFacturacion.fechaInicioFacturacion)){
                                    sglOCRel.FechadeActivacion__c = date.parse(msgEntrada.inicioFacturacion.fechaInicioFacturacion);
                                }
                                ActualizarObjeto(SerializarLista(new List<OperacionComercial__c>{sglOCRel}));
                                //update sglOCRel;
                            }
                        }
                       
                        if(sglOC.Plan__r.NombredelProducto__r.Name == producto && sglOC.Plan__r.TipodePlan__c == 'Troncal SIP' && sglOC.topp__r.TipodeOperacionporplan__c == 'Modificación Servicio'){
                            List<LTE_Servicios_adicionales__c> lstSVA = [SELECT Id,LTE_ServicioETB__c FROM LTE_Servicios_adicionales__c WHERE LTE_OC_Tramite__c = :sglOC.Id AND LTE_ServicioETB__c != :sglOC.Activo__c];
                            for(LTE_Servicios_adicionales__c sglSVA:lstSVA){
                                sglSVA.LTE_ServicioETB__c = sglOC.Activo__c;
                            }
                            if(!lstSVA.isEmpty())
                                update lstSVA;
                        }
                    }
                    if(String.isNotEmpty(msgEntrada.inicioFacturacion.fechaInicioFacturacion)){
                        sglOC.FechadeActivacion__c = date.parse(msgEntrada.inicioFacturacion.fechaInicioFacturacion);
                    }
                    if(String.isNotEmpty(msgEntrada.inicioFacturacion.IDServicio)){
                        sglOC.IDServicio__c = msgEntrada.inicioFacturacion.IDServicio;
                    }                             
					if(sglOC.RecordTypeId == Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Numeración Abreviada').getRecordTypeId()){                                               
                       lstNumeroAbb.add(sglOC.Numero_Abreviado__c);
                       lstNumeroAbb.add(sglOC.Numero_Abreviado_segunda_opcion__c);
                    }                    
                    if(msgEntrada.inicioFacturacion.detallesInicioFacturacion.parametro != null){
                        PoblarCamposDinamicosGestor('GESTOR_INICIOFACT', sglOC, msgEntrada.inicioFacturacion.detallesInicioFacturacion.parametro);
                    }               
                    if(String.isEmpty(sErrorMessage) && (msgEntrada.inicioFacturacion.estado=='Activo'?'Activa':msgEntrada.inicioFacturacion.estado)=='Activa' && sglOC.Plan__r.NombredelProducto__r.Name == producto && sglOC.Plan__r.TipodePlan__c == 'Troncal SIP' && msgEntrada.inicioFacturacion.Lineas != null){
                        sErrorMessage = ActualizarLineasVoz(msgEntrada.inicioFacturacion.Lineas.Linea, sglOC);
                    }
                    if(String.isNotEmpty(sglOC.NumeroConexion__c))
                        if(sNumeracion10D=='Verdadero' && sglOC.NumeroConexion__c.length()<10){
                            sErrorMessage = 'El numero de arranque debe ser mayor a 10 digitos';
                        }
                    if(String.isEmpty(sErrorMessage) && sglOC.Estado__c == 'Activa' && (sglOC.TOPP__r.Requiere_Numeracion__c == true || String.isnotEmpty(sglOC.RangoNumeracion__c))){
                        Map<String,String> mpEnlace = RangoNumeracionEnlaceVoz(sglOC.RangoNumeracion__c);
                        IntegracionGestor_ws.Lineas wrpLineasVoz = new IntegracionGestor_ws.Lineas();
                        list<IntegracionGestor_ws.Linea> lstlineaVoz = new list<IntegracionGestor_ws.Linea>();
                        
                        if(String.isEmpty(mpEnlace.get('ErrorMessage'))){
                            for(String sgllinea:mpEnlace.keyset()){
                                if(sgllinea!='ErrorMessage'){
                                    IntegracionGestor_ws.Linea linea = new IntegracionGestor_ws.Linea();
                                    linea.Accion = mpEnlace.get(sgllinea)=='ADD'?'Adicion':'Retiro';
                                    linea.Estado = mpEnlace.get(sgllinea)=='ADD'?'Ocupada':'Libre';
                                    linea.Numero = sgllinea;
                                    if(sNumeracion10D=='Falso')
                                        linea.ExternalId = sgllinea.length()<10?'60'+sgllinea:sgllinea;
                                    else{
                                        linea.ExternalId = sgllinea;
                                    }
                                    linea.TipoLinea = '';
                                    lstlineaVoz.add(Linea);
                                    //Linea__c linea = new Linea__c();
                                    //linea.Name = sgllinea;
                                    //linea.Codigo_de_linea__c = sgllinea;
                                    //Linea.Estado_Aprovisionamiento__c = mpEnlace.get(sgllinea)=='ADD'?'Activo':'Inactivo';
                                    //Linea.OperacionComercialTramite__c = sglOC.Id;
                                    //lstLineas.add(Linea);
                                }
                            }
                            wrpLineasVoz.linea = lstlineaVoz;
                            msgEntrada.inicioFacturacion.Lineas = wrpLineasVoz;
                            sErrorMessage = ActualizarLineasVoz(msgEntrada.inicioFacturacion.Lineas.Linea, sglOC);
                        }else{
                            sErrorMessage=mpEnlace.get('ErrorMessage');
                        }
                        
                        if(sglOC.topp__r.TipodeOperacionporplan__c=='Retiro' && String.isNotEmpty(sErrorMessage)){
                            sErrorMessage = '';
                            //Los retiros no se pueden evaluar aun hasta que apv defina una regla para las migraciones de tecnologia
                        }
                    }
                    if(String.isnotEmpty(sglOC.RangoNumeracion__c))
                        sglOC.RangoNumeracion__c = sglOC.RangoNumeracion__c.length()>255?sglOC.RangoNumeracion__c.substring(0, 255):sglOC.RangoNumeracion__c;
                    
                    if(sglOC.RecordTypeId == Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Numeración Abreviada').getRecordTypeId()){
                        if(sglOC.Numero_Abreviado__c !=null && !lstNumeroAbb.IsEmpty()){  
                            if(lstNumeroAbb.contains(sglOC.Numero_Abreviado__c)){
                                List<Numero__c> lstNumeros = [SELECT Id, name, Cuenta__c, Estado__c, OperacionComercial__c FROM Numero__c WHERE Id in :lstNumeroAbb];
                                for(Numero__c numero  :lstNumeros){
                                    if(numero.Id == sglOC.Numero_Abreviado__c){
                                        sglOC.Numero_Abreviado_segunda_opcion__c = null;
                                    } else{
                                        numero.Estado__c = 'Disponible';
                                        numero.Cuenta__c = null;
                                        numero.OperacionComercial__c = null;
                                    } 
                                }                    
                                update lstNumeros;
                            }else{
                                sErrorMessage = 'El número ó el formato del número es incorrecto. Ejemplo(#123)';				
                            }
                        }else{
                            sErrorMessage = 'Es requerido el #ABB asignado por la CRC. Ejemplo(#123)';
                        }                        
                    }                    
                    System.debug(sErrorMessage);
                    if(String.isEmpty(sErrorMessage)){
                        update sglOC;
                        
                        if(!lstLineas.isEmpty())
                            Database.UpsertResult[] cr = Database.upsert(lstLineas, Linea__c.Fields.Codigo_de_linea__c, false);
                        if(String.isNotEmpty(msgEntrada.inicioFacturacion.fechaInicioFacturacion) && String.isNotEmpty(msgEntrada.inicioFacturacion.estado)){
                            if(sglOC.TOPP__r.Actualiza_Servicio_en_Gestor__c == true)
                                PS_ActualizarServicioEnGestor_cls.ActualizarServicioEnGestor(msgEntrada.inicioFacturacion.numeroOC, msgEntrada.inicioFacturacion.IDServicio);
                        }
                        respuesta.resultado = 'Exitoso';
                        respuesta.msgError.codigoError='';
                    }else{
                        respuesta.msgError.mensajeError = sErrorMessage;
                    }
                }catch(exception e){
                    system.debug(e.getStackTraceString());
                    respuesta.msgError.mensajeError=e.getMessage();
                }
                logServicio.AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion;
                logServicio.LTE_Operacion_Comercial__c = sglOC.Id;
                logServicio.Name = 'Iniciar Facturación ' + sglOC.Name;
                logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
            }else{
                respuesta.msgError.mensajeError='Operacion Comercial no encontrada';
            }
        }catch(exception e){
            system.debug(e.getStackTraceString());
            respuesta.msgError.mensajeError=e.getMessage();
        }
        logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
        insert logServicio;
        return respuesta;
    }
    
    /*
	* @Método: 		IniciarFacturacionImp
	* @Parámetros:	IntegracionGestor_ws.MsgEntradaInicioFacturacion
	* @Descripcion:	Método donde se implementa la actualización de la información para el inicio de la facturación.   
	*/
    
    public static IntegracionGestor_ws.MsgSalidaSincronizacionLineas SincronizarLineaImp(IntegracionGestor_ws.MsgEntradaSincronizacionLineas msgEntrada){
        LogTransacciones__c logServicio = new LogTransacciones__c(AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion,Informacion_Recibida__c = String.valueOf(msgEntrada),Name = 'Iniciar Facturación ' + msgEntrada.transaccion.idTransaccion);
        IntegracionGestor_ws.MsgSalidaSincronizacionLineas respuesta = new IntegracionGestor_ws.MsgSalidaSincronizacionLineas();
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        List<Linea__c> lstLineas = new List<Linea__c>();
        String sErrorMessage = '';
        try{
            List<OperacionComercial__c> lstOC = [SELECT Id, Name, RangoNumeracion__c,FechadeActivacion__c,Activo__c,TOPP__r.Actualiza_Servicio_en_Gestor__c, TOPP__r.Requiere_Numeracion__c, Plan__r.Name, Plan__r.Plan_Troncales_Sip_Movil__c, Plan__r.TipodePlan__c, Plan__r.NombredelProducto__r.Name,topp__r.TipodeOperacionporplan__c,Operacion_Comercial_Relacionada__c FROM OperacionComercial__c where name =: msgEntrada.sincronizacionLinea.numeroOC];
            if(!lstOC.isEmpty()){
                OperacionComercial__c sglOC=lstOC[0];
                try{
                    sErrorMessage = ActualizarLineasVoz(msgEntrada.sincronizacionLinea.Lineas.Linea, sglOC);
                    if(String.isNotEmpty(sErrorMessage)){
                        respuesta.msgError.mensajeError = sErrorMessage;
                    }else{
                        respuesta.resultado = 'Exitoso';
                        respuesta.msgError.codigoError='';
                        respuesta.msgError.mensajeError = '';
                    }
                }catch(exception e){
                    system.debug(e.getStackTraceString());
                    respuesta.msgError.mensajeError=e.getMessage();
                }
                logServicio.AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion;
                logServicio.LTE_Operacion_Comercial__c = sglOC.Id;
                logServicio.Name = 'Iniciar Facturación ' + sglOC.Name;
                logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
            }
            else{
                respuesta.msgError.mensajeError='Operacion Comercial no encontrada';
            }
        }catch(exception e){
            system.debug(e.getStackTraceString());
            respuesta.msgError.mensajeError=e.getMessage();
        }
        logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
        insert logServicio;
        return respuesta;
    }
    
    public static String ActualizarLineasVoz(List<IntegracionGestor_ws.Linea> lstlineas,OperacionComercial__c sglOC){
        String sErrorMessage = '';
        String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c;
        String sNumeracion10D = VariablesGlobales__c.getValues('Numeracion10Digitos').valor__c;
        system.debug('ActualizarLineasVoz');
        List<Linea__c> lstLineasBD = new List<Linea__c>();
        List<Lineas_OC__c> lstLineasOC = [SELECT Id,Linea__r.Name,Linea__r.Codigo_de_linea__c FROM Lineas_OC__c WHERE Operacion_Comercial__c = :sglOC.Id];
        
        Set<String> lstLineasTotal = new Set<String>();
        system.debug(lstLineasOC);
        Map<String,Lineas_OC__c> MapLineasOC = new Map<String,Lineas_OC__c>();
        for(Lineas_OC__c sglLineaOC:lstLineasOC){
            if(!MapLineasOC.containskey(sglLineaOC.Linea__r.Codigo_de_linea__c)){
                MapLineasOC.put(sglLineaOC.Linea__r.Codigo_de_linea__c,sglLineaOC);
                if(!lstLineasTotal.contains(sglLineaOC.Linea__r.Codigo_de_linea__c))
                    lstLineasTotal.add(sglLineaOC.Linea__r.Codigo_de_linea__c);
            }
        }
        
        Map<String,IntegracionGestor_ws.Linea> mpLineasGestor = new Map<String,IntegracionGestor_ws.Linea>();
        for(IntegracionGestor_ws.Linea sglLinea:lstlineas){
            if(sNumeracion10D=='Verdadero')
                if(sglLinea.ExternalId.length()<10){
                    sErrorMessage = 'La linea ' + sglLinea.ExternalId + ' debe contener mas de 10 digitos';
                    break;
                }
            sglLinea.Accion = (sglLinea.Accion == 'Adicion'?'Adicionar':(sglLinea.Accion == 'Retiro'?'Retirar':'None'));
            if(sglLinea.Estado == 'Ocupada' || sglLinea.Estado == 'Libre')
                sglLinea.Estado = 'Activa';
            else{
                sErrorMessage = 'La linea ' + sglLinea.ExternalId + ' no se ha ocupado';
                break;
            }
            if(!mpLineasGestor.containskey(sglLinea.ExternalId)){
                mpLineasGestor.put(sglLinea.ExternalId,sglLinea);
                if(!lstLineasTotal.contains(sglLinea.ExternalId))
                    lstLineasTotal.add(sglLinea.ExternalId);
            }
        }
        
        system.debug(lstLineasTotal);
        if(String.isEmpty(sErrorMessage))
            lstLineasBD = [SELECT Id,Name,Contacto_Relacionado__c,Codigo_de_linea__c,Linea_ETB__c,Tipo__c,Tipo_servicio__c,(SELECT Id,Estado__c,Operacion_Comercial__c,Operacion_Comercial__r.Name FROM Lineas_OC__r WHERE (Estado__c != 'Declinada' AND Estado__c != 'Facturada' AND Estado__c != 'Activa') OR Operacion_Comercial__c=:sglOC.Id), (SELECT Id,Activo__c,Activo__r.Name FROM Lineas_AC__r WHERE Estado__c != 'Inactiva') FROM Linea__c WHERE Codigo_de_linea__c IN :lstLineasTotal];
		Set<String> lstLineasExistentes = new Set<String>();
        
        Map<String,Lineas_OC__c> mpLineasOcActualizar = new Map<String,Lineas_OC__c>();
        Map<String,Linea_AC__c> mpLineasAcActualizar = new Map<String,Linea_AC__c>();
        
        for(Linea__c sglLineasBD:lstLineasBD){
            lstLineasExistentes.add(sglLineasBD.Codigo_de_linea__c);
            
            system.debug(sglLineasBD.Codigo_de_linea__c);
            system.debug(sglLineasBD.Lineas_OC__r.size());
            
            if(sglLineasBD.Lineas_OC__r.size()==0){
                if(!mpLineasOcActualizar.containskey(sglLineasBD.Codigo_de_linea__c)){
                    if(mpLineasGestor.containskey(sglLineasBD.Codigo_de_linea__c)){
                        mpLineasOcActualizar.put(sglLineasBD.Codigo_de_linea__c, new Lineas_OC__c(Estado__c = mpLineasGestor.get(sglLineasBD.Codigo_de_linea__c).Estado,Accion__c = mpLineasGestor.get(sglLineasBD.Codigo_de_linea__c).Accion,Operacion_Comercial__c = sglOC.Id,Linea__c=sglLineasBD.Id,Tipo_relacion__c='Producto Ppal Voz',FechadeActivacion__c = sglOC.FechadeActivacion__c));
                    }else{
                        sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' posee un error de datos [0]';
                        break;
                    }
                }else{
                    sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' aparece duplicada en el listado';
                    break;
                }
            }else if(sglLineasBD.Lineas_OC__r.size()==1){
                if(sglLineasBD.Lineas_OC__r[0].Operacion_Comercial__c == sglOC.Id){
                    if(!mpLineasOcActualizar.containskey(sglLineasBD.Codigo_de_linea__c)){
                        if(sglLineasBD.Lineas_OC__r[0].Estado__c != 'Facturada'){
                            if(mpLineasGestor.containskey(sglLineasBD.Codigo_de_linea__c)){
                                mpLineasOcActualizar.put(sglLineasBD.Codigo_de_linea__c, new Lineas_OC__c(Id = sglLineasBD.Lineas_OC__r[0].Id,Estado__c = mpLineasGestor.get(sglLineasBD.Codigo_de_linea__c).Estado,FechadeActivacion__c = sglOC.FechadeActivacion__c));
                            }else if(MapLineasOC.containskey(sglLineasBD.Codigo_de_linea__c)){
                                mpLineasOcActualizar.put(sglLineasBD.Codigo_de_linea__c, new Lineas_OC__c(Id = MapLineasOC.get(sglLineasBD.Codigo_de_linea__c).Id,Estado__c = 'Declinada'));
                            }else{
                                sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' posee un error de datos [1]';
                                break;
                            }
                        }else{
                            sErrorMessage = 'El estado de la linea '+sglLineasBD.Codigo_de_linea__c+' no es válido';
                            break;
                        }
                    }else{
                        sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' aparece duplicada en el listado';
                        break;
                    }
                }else{
                    sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' es usada en otra operacion comercial' + sglLineasBD.Lineas_OC__r[0].Operacion_Comercial__r.NAme;
                    break;
                }
            }else{
                sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' es usada en varias operaciones comerciales';
                break;
            }
            
            if(mpLineasOcActualizar.containskey(sglLineasBD.Codigo_de_linea__c)){
                if(mpLineasOcActualizar.get(sglLineasBD.Codigo_de_linea__c).Estado__c == 'Activa'){
                    if(sglLineasBD.Lineas_AC__r.size()==0){
                        if(!mpLineasAcActualizar.containskey(sglLineasBD.Codigo_de_linea__c)){
                            if(mpLineasGestor.containskey(sglLineasBD.Codigo_de_linea__c)){
                                mpLineasAcActualizar.put(sglLineasBD.Codigo_de_linea__c, new Linea_AC__c(Estado__c = mpLineasGestor.get(sglLineasBD.Codigo_de_linea__c).Accion=='Adicionar'?'Activa':'Inactiva',Activo__c = sglOC.Activo__c,Linea__c=sglLineasBD.Id,Tipo_relacion__c='Producto Ppal Voz'));
                            }else{
                                sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' posee un error de datos [0].';
                                break;
                            }
                        }else{
                            sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' aparece duplicada en el listado';
                            break;
                        }
                    }else if(sglLineasBD.Lineas_AC__r.size()==1){
                        if(sglLineasBD.Lineas_AC__r[0].Activo__c == sglOC.Activo__c){
                            if(!mpLineasAcActualizar.containskey(sglLineasBD.Codigo_de_linea__c)){
                                if(!mpLineasGestor.containskey(sglLineasBD.Codigo_de_linea__c)){
                                    mpLineasAcActualizar.put(sglLineasBD.Codigo_de_linea__c, new Linea_AC__c(Estado__c = mpLineasGestor.get(sglLineasBD.Codigo_de_linea__c).Accion=='Adicionar'?'Activo':'Inactivo'));
                                }
                            }else{
                                sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' aparece duplicada en el listado';
                                break;
                            }
                        }else{
                            sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' es usada en otro servicio'+ sglLineasBD.Lineas_AC__r[0].Activo__r.Name;
                            break;
                        }
                    }else{
                        sErrorMessage = 'La linea '+sglLineasBD.Codigo_de_linea__c+' es usada en varios servicios';
                        break;
                    }
                }
            }
        }
        system.debug(sErrorMessage);
        if(String.isEmpty(sErrorMessage)){
            List<Linea__c> lstLinea = new List<Linea__c>();
            for(String sglLineaGestor:mpLineasGestor.keyset()){
                if(!lstLineasExistentes.contains(sglLineaGestor)){
                    Linea__c sglLinea = new Linea__c(Name=mpLineasGestor.get(sglLineaGestor).Numero,Codigo_de_linea__c=sglLineaGestor,Linea_ETB__c=(sglOC.Plan__r.NombredelProducto__r.Name == producto?'ETB Movil':'ETB Fija'));
                    lstLinea.add(sglLinea);
                }
            }
            if(!lstLinea.isEmpty()){
                insert lstLinea;
                for(Linea__c sglLinea:lstLinea){
                    mpLineasOcActualizar.put(sglLinea.Codigo_de_linea__c, new Lineas_OC__c(Estado__c = mpLineasGestor.get(sglLinea.Codigo_de_linea__c).Estado,Accion__c = mpLineasGestor.get(sglLinea.Codigo_de_linea__c).Accion,Operacion_Comercial__c = sglOC.Id,Linea__c=sglLinea.Id,Tipo_relacion__c='Producto Ppal Voz',FechadeActivacion__c = sglOC.FechadeActivacion__c));
                    if(mpLineasGestor.get(sglLinea.Codigo_de_linea__c).Estado=='Activa')
                        mpLineasAcActualizar.put(sglLinea.Codigo_de_linea__c, new Linea_AC__c(Estado__c = mpLineasGestor.get(sglLinea.Codigo_de_linea__c).Accion=='Adicionar'?'Activa':'Inactiva',Activo__c = sglOC.Activo__c,Linea__c=sglLinea.Id,Tipo_relacion__c='Producto Ppal Voz'));
                }
            }
            system.debug(mpLineasOcActualizar);
            if(!mpLineasOcActualizar.isEmpty())
                upsert mpLineasOcActualizar.values();
            if(!mpLineasAcActualizar.isEmpty())
                upsert mpLineasAcActualizar.values();
        }
        return sErrorMessage;
    }
    
    public static void PoblarCamposDinamicosGestor(String strLista, SObject objObjeto, List<IntegracionGestor_ws.Parametro> lstParametros){
        List<Homologacion_Gestor__mdt> lstHG = [SELECT Id,Valor_API__c,Valor_Usuario__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = :strLista];
        Map<String,String> mpHG = new Map<String,String>();
        for(Homologacion_Gestor__mdt sglHG:lstHG){
            mpHG.put(sglHG.Valor_Usuario__c,sglHG.Valor_API__c);
        }        
        if(!mpHG.isEmpty()){
            for(IntegracionGestor_ws.Parametro sglParametro:lstParametros){
                if(String.isNotEmpty(sglParametro.nombre)){
                    if(mpHG.containskey(sglParametro.nombre)){
                        if((sglParametro.nombre) =='NUMERAL ABB ASIGNADO (#ABB)' && (sglParametro.valor !=null || !String.isEmpty(sglParametro.valor))){
                            String numeroABB = sglParametro.valor;
                            List<Numero__c> lstNumero = [SELECT Id FROM Numero__c WHERE name = :numeroABB]; 
                            if (!lstNumero.IsEmpty())
                            	sglParametro.valor= lstNumero[0].Id;
                        }
                        objObjeto.put(mpHG.get(sglParametro.nombre),sglParametro.valor);
                    }
                }
            }
        }
    }
    
        /*
	* @Método: 		ActualizarEstadoImp
	* @Parámetros:	IntegracionGestor_ws.MsgEntradaActualizarEstado
	* @Descripcion:	Método donde se implementa la actualización de estados.   
	*/
    
    public static IntegracionGestor_ws.MsgSalidaActualizarEstado ActualizarEstadoImp(IntegracionGestor_ws.MsgEntradaActualizarEstado msgEntrada){
    	
        IntegracionGestor_ws.MsgSalidaActualizarEstado respuesta = new IntegracionGestor_ws.MsgSalidaActualizarEstado();
  		try{

			String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c; 
            
            
            String sTipoSolicitud = String.isEmpty(msgEntrada.actualizarEstado.tipoSolicitud)?'':msgEntrada.actualizarEstado.tipoSolicitud;
            List<Homologacion_Gestor__mdt> lstHGsTipoSolicitud = new List<Homologacion_Gestor__mdt>();
            system.debug('sTipoSolicitud');
            system.debug(sTipoSolicitud);
            
            if(String.isNotEmpty(sTipoSolicitud))
                lstHGsTipoSolicitud = [SELECT Id,Valor_API__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'TIPO_SOLICITUD_GESTOR' AND Valor_Usuario__c = :sTipoSolicitud];
            
            if(lstHGsTipoSolicitud.isEMpty()){
                respuesta.msgError.mensajeError='Tipo de solicitud no valido';
                respuesta.resultado = 'Erroneo';
                respuesta.msgError.codigoError='NOK';
            }
            else{
                if(lstHGsTipoSolicitud[0].Valor_API__c == 'Viabilidad'){
                    
                    Viabilidad__c viabilidad = new Viabilidad__c();
                    //Encontrar viabilidad relacionada
                    List<Viabilidad__c> viabilidades = [SELECT Id,Fase_Gestor__c,Estado_Gestor__c, OperacionComercial__r.Id FROM Viabilidad__c where name =: msgEntrada.actualizarEstado.numeroViabilidad];
                    //System.debug('viabilidades:' + viabilidades);
                    viabilidad = viabilidades[0];
                    
                    //Actualizar valores de la Viabilidad
                    //System.debug('fase: ' + msgEntrada.actualizarEstado.fase);
                    if(msgEntrada.actualizarEstado.fase != null && msgEntrada.actualizarEstado.fase != ''){
                        viabilidad.Fase_Gestor__c = msgEntrada.actualizarEstado.fase;
                    }
                    //System.debug('estado: ' + msgEntrada.actualizarEstado.estado);  
                    if(msgEntrada.actualizarEstado.estado != null && msgEntrada.actualizarEstado.estado != ''){              
                        viabilidad.Estado_Gestor__c = msgEntrada.actualizarEstado.estado;
                    }
                    if(String.isNotEmpty(viabilidad.Fase_Gestor__c) && String.isNotEmpty(viabilidad.Estado_Gestor__c)){
                        String strValorGestor = viabilidad.Fase_Gestor__c+'|'+viabilidad.Estado_Gestor__c;
                        List<Homologacion_Gestor__mdt> lstHG = [SELECT Id,Valor_Usuario__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'ESTADOS_VIA' AND Valor_API__c = :strValorGestor];
                        if(!lstHG.isEmpty()){
                            viabilidad.EstadoViabilidad__c = lstHG[0].Valor_Usuario__c;
                        }
                    }
                    //JACERO 25072018 ACTUALIZA CAMPOS DINAMICAMENTE CON ARREGLO LLAVE, VALOR
                    if(msgEntrada.ActualizarEstado.detallesActualizarEstado.parametro != null){
                        for (IntegracionGestor_ws.parametro ActEstViab : msgEntrada.ActualizarEstado.detallesActualizarEstado.parametro) {
                            
                            //Se actualiza campos
                            ActCamposDinamicosViabilidad(viabilidad, ActEstViab);
                        }
                    }
                    
                    update viabilidad;
                    System.debug('viabilidad: ' + viabilidad);            
                    
                } else if(lstHGsTipoSolicitud[0].Valor_API__c == 'APROVISIONAMIENTO'){

                    System.Debug('Entró al if de APROVISIONAMIENTO');
                    OperacionComercial__c operacioncomercial = new OperacionComercial__c();
                    //Encontrar la OC relacionada
                    List<OperacionComercial__c> OCs = [SELECT Id,Plan__r.NombredelProducto__r.Name,Plan__r.TipodePlan__c, Plan__r.Plan_Troncales_Sip_Movil__c, CuentaFacturacion__r.Id FROM OperacionComercial__c where name =: msgEntrada.actualizarEstado.numeroOC];
                    List<CuentaFacturacion__c> cuentaFacturacionList = [SELECT Id, Name, IMEISCF__c, ContieneIMEI__c FROM CuentaFacturacion__c WHERE Id =:OCs[0].CuentaFacturacion__r.Id];
                    System.debug('Id de la Operación Comercial:' + OCs);
                    operacioncomercial = OCs[0];
                    String imeisConcatenados='';
                    
                    //Actualizar valores de la OC
                    if(msgEntrada.actualizarEstado.fase != null && msgEntrada.actualizarEstado.fase != ''){ 
                        operacioncomercial.Fase_Gestor__c = msgEntrada.actualizarEstado.fase;
                    }
                    //Accenture - Andres Fellipe Romero Hernandez
                    //**************Logica para rear registros Detalle oferta basados en lo recibido en el campo imeis********
                    System.Debug('msgEntrada.actualizarEstado '+msgEntrada.actualizarEstado);
                    System.Debug('msgEntrada.transaccion '+msgEntrada.transaccion);

                    Map<String,String> transaccionMap = new Map<String,String>();

                    for(IntegracionGestor_ws.Parametro p : msgEntrada.transaccion.DetalleTransaccion.parametro )
                    {
                        transaccionMap.put(p.nombre, p.valor);
                    }

                    //if( msgEntrada.actualizarEstado.imeis != null && msgEntrada.actualizarEstado.imeis != ''){
                    if( transaccionMap.get('IMEIS') != null && transaccionMap.get('IMEIS') != ''){
                        //blob blobT = EncodingUtil.base64Decode(msgEntrada.actualizarEstado.imeis);
                        blob blobT = EncodingUtil.base64Decode(transaccionMap.get('IMEIS'));
                        System.debug('**blobT '+blobT);
                        String blobS = blobT.toString();
                        System.debug('**blobS '+blobS);
                       
                        List<String> tablaDeIMEIs = blobS.split('\n');
                        List<String> datosDeImei = new List<String>();                      
                        List<LTE_SpecificationGroupXA__c> XAsList = new List<LTE_SpecificationGroupXA__c>();
                        LTE_Servicios_adicionales__c servicioAdicional = new LTE_Servicios_adicionales__c();
                        servicioAdicional.LTE_OC_Tramite__c = operacioncomercial.Id;
                        insert servicioAdicional;

                        for (String  t:tablaDeIMEIs){
                            datosDeImei = t.split(',');                            
                            LTE_SpecificationGroupXA__c sGXA = new LTE_SpecificationGroupXA__c();
                            sGXA.LTE_ServiciosAdicionales__c = servicioAdicional.Id;
                            sGXA.Name = 'referencia '+ datosDeImei[0];
                            sGXA.LTE_Value__c = 'IMEI  '+ datosDeImei[1];
                            imeisConcatenados+= datosDeImei[0]+' '+ datosDeImei[1]+'#';
                            XAsList.add(sGXA);
                        }

                        if(!XAsList.isEmpty()){
                            insert XAsList;
                            if(cuentaFacturacionList!=null && cuentaFacturacionList.size()>0)
                            {   
                                System.Debug('imeisConcatenados '+imeisConcatenados );
                                imeisConcatenados = imeisConcatenados.replace('\r\n', ' ');
                                System.Debug('imeisConcatenados '+imeisConcatenados );
                                imeisConcatenados = imeisConcatenados.replace('\n', ' ');
                                System.Debug('imeisConcatenados '+imeisConcatenados );
                                imeisConcatenados = imeisConcatenados.replace('\r', ' ');
                                System.Debug('imeisConcatenados '+imeisConcatenados );
                                if(String.IsBlank(cuentaFacturacionList[0].IMEISCF__c))
                                {
                                    cuentaFacturacionList[0].IMEISCF__c = cuentaFacturacionList[0].Name +' '+ imeisConcatenados.Substring(0,imeisConcatenados.Length()-1);
                                }
                                else
                                {
                                    if( cuentaFacturacionList[0].IMEISCF__c.contains(cuentaFacturacionList[0].Name))
                                    {
                                        cuentaFacturacionList[0].IMEISCF__c += '#'+imeisConcatenados.Substring(0,imeisConcatenados.Length()-1);
                                    }
                                    else
                                    {
                                        cuentaFacturacionList[0].IMEISCF__c = cuentaFacturacionList[0].Name +' '+  cuentaFacturacionList[0].IMEISCF__c +'#' + imeisConcatenados.Substring(0,imeisConcatenados.Length()-1);
                                    }
                                }
                                cuentaFacturacionList[0].ContieneIMEI__c = true;
                                update cuentaFacturacionList;
                            }
                        }
                        //**************Fin Logica para rear registros Detalle oferta basados en lo recibido en el campo imeis********
                    }
                    //System.debug('estado: ' + msgEntrada.actualizarEstado.estado);  
                    if(msgEntrada.actualizarEstado.estado != null && msgEntrada.actualizarEstado.estado != ''){ 
                        operacioncomercial.Estado_Gestor__c = msgEntrada.actualizarEstado.estado;
                        if(msgEntrada.actualizarEstado.estado == 'EN DEVOLUCION'){
                            operacioncomercial.EstadoAprovisionamiento__c = '';
                            operacioncomercial.EstadoAprovisionamiento__c = 'Devuelto';
                        }
                    }
                    List<Homologacion_Gestor__mdt> lstHG_CamposDinamicos = [SELECT Id,Valor_Usuario__c, Valor_API__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'APV_CAMPOS_DIN'];
                    Map<String,String> mpCamposDin = new Map<String,String>();
                    for(Homologacion_Gestor__mdt sglHG_CamposDinamicos:lstHG_CamposDinamicos){
                        mpCamposDin.put(sglHG_CamposDinamicos.Valor_Usuario__c,sglHG_CamposDinamicos.Valor_API__c);
                        system.debug('sglHG_CamposDinamicos.Valor_API__c' + sglHG_CamposDinamicos.Valor_API__c);
                        system.debug('sglHG_CamposDinamicos.Valor_Usuario__c' + sglHG_CamposDinamicos.Valor_Usuario__c);
                    }
                    //JACERO 25072018 ACTUALIZA CAMPOS DINAMICAMENTE CON ARREGLO LLAVE, VALOR
                    if(msgEntrada.Transaccion.detalleTransaccion.parametro != null){

                        for (IntegracionGestor_ws.parametro ActEstAprov : msgEntrada.Transaccion.detalleTransaccion.parametro) {
                            if(mpCamposDin.containsKey(ActEstAprov.nombre)){
                                operacioncomercial.put(mpCamposDin.get(ActEstAprov.nombre),ActEstAprov.valor);
                            }
                            
                            if(ActEstAprov.nombre == 'CausalFinalizacionApv' && msgEntrada.actualizarEstado.estado == 'NO EXITOSO'){
                                operacioncomercial.Causal_Declinaci_n__c = ActEstAprov.valor;
                                operacioncomercial.Tipo_causal_declinaci_n__c = 'Técnica';
                            }
                            
                        }
                    }
                    
                    if(String.isNotEmpty(msgEntrada.actualizarEstado.fase) && String.isNotEmpty(msgEntrada.actualizarEstado.estado)){
                        if(operacioncomercial.Plan__r.NombredelProducto__r.Name != producto  || (operacioncomercial.Plan__r.NombredelProducto__r.Name == producto && operacioncomercial.Plan__r.TipodePlan__c == 'Principal' && operacioncomercial.Plan__r.Plan_Troncales_Sip_Movil__c == true)){
                            String strValorGestor = msgEntrada.actualizarEstado.fase+'|'+msgEntrada.actualizarEstado.estado;
                            List<Homologacion_Gestor__mdt> lstHG = [SELECT Id,Valor_Usuario__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'ESTADOS_APV' AND Valor_API__c = :strValorGestor];
                            if(!lstHG.isEmpty()){
                                operacioncomercial.Estado__c = lstHG[0].Valor_Usuario__c;
                            }
                        }
                    }
                    BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    update operacioncomercial;
                    BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    System.debug('operacioncomercial: ' + operacioncomercial);
                }
                respuesta.resultado = 'Exitoso';
            }
        }catch(exception e){
            respuesta.msgError.mensajeError=e.getMessage();
            respuesta.resultado = 'Erroneo';
            respuesta.msgError.codigoError='NOK';
        }
        return respuesta;
    }
	
    /*
	* @Método: 		ActCamposDinamicosAprov
	* @Descripcion:	Método implementado para actualizar dinámicamente campos de la Operación Comercial.   
	*/ 
     
    public static  void ActCamposDinamicosAprov(OperacionComercial__c operacioncomercial, IntegracionGestor_ws.Parametro MsgPar){
        System.debug('ActEstAprov.nombre: ' + MsgPar.nombre);
        System.debug('ActEstAprov.valor: ' + MsgPar.valor);

        //Preguntar que campo viene y actualizar
        if(MsgPar.nombre == 'ObservacionesFinalizacionApv'){
            operacioncomercial.Comentarios_Aprovisionamiento__c = MsgPar.valor;
        }
        if(MsgPar.nombre == 'CausalFinalizacionApv'){
            operacioncomercial.Causal_Siebel__c = MsgPar.valor;
        }
        //Preguntar que campo viene y actualizar
        if(MsgPar.nombre == 'EstadoAprovisionamiento'){
            operacioncomercial.EstadoAprovisionamiento__c = MsgPar.valor;
        }
					
        System.debug('ActualizarCamposAprovisionamiento salida :: OperacionComercial: ' + operacioncomercial);
    }

    /*
	* @Método: 		ActCamposDinamicosViabilidad
	* @Descripcion:	Método implementado para actualizar dinámicamente los campos que se deseen de la Viabilidad.   
	*/ 

    public static  void ActCamposDinamicosViabilidad(Viabilidad__c viabilidad, IntegracionGestor_ws.Parametro MsgPar){

        System.debug('ActEstViab.nombre: ' + MsgPar.nombre);
        System.debug('ActEstViab.valor: ' + MsgPar.valor);
        //Si contiene el mail del Ingeniero, lo guardamos
        if(MsgPar.nombre == 'Correo' && MsgPar.valor != ''){
            viabilidad.Correo_Ing_Factibilidad__c = MsgPar.valor;
        }
        //Preguntar que campo viene y actualizar
        if(MsgPar.nombre == 'Causal'){
            viabilidad.Causal__c = MsgPar.valor;
        }
        if(MsgPar.nombre == 'TECNOLOGIA SERVICIO SDWAN' && MsgPar.valor != ''){
            actualizarTecnologiaProductoSDWAN(viabilidad,MsgPar.valor);
        }
        System.debug('ActualizarCamposViabilidad salida :: viabilidad: ' + viabilidad);
    }
    
    public static Map<String,String> RangoNumeracionEnlaceVoz(String sMensaje){
        //Manejo de errores
        String sErrorMEssage = '';
        
        //Listado final de numeros
        //Set<string> lstNumeros = new Set<string>();
        Map<String,String> mpNumeros = new Map<String,String>();
        
        // Variable de entrada
        //LogTransacciones__c sglLog = [SELECT Informacion_Enviada__c FROM LogTransacciones__c WHERE Id = 'a0Um0000005AGIt'];
        //String sMensaje = sglLog.Informacion_Enviada__c;
        
        if(String.isNotEmpty(sMensaje)){
            system.debug(sMensaje);
            
            //Se quita el enter para manejar mejor el regex
            sMensaje = sMensaje.replaceAll('\\r\\n', '');
            sMensaje = sMensaje.replaceAll('\\n', '');
            sMensaje = sMensaje.replaceAll('\\r', '');
            system.debug(sMensaje);
            
            // Validacion inicial para verificar si la cadena cumple el patron para ahorrar procesamiento
            Boolean bEsValido = Pattern.matches('((?:[A][D][D][\\:]|[D][E][L][\\:])(?:[0-9]{8,10}[-]?(?:[0-9]{8,10})?[\\;])+)+', sMensaje);
            if(bEsValido){
                //Si el patron es valido se procesa la cadena para sacar la numeracion
                pattern pttnCadena = pattern.compile('([A][D][D][\\:]|[D][E][L][\\:])(?:[0-9]{8,10}[-]?(?:[0-9]{8,10})?[\\;])+');
                matcher mtchCadena = pttnCadena.matcher(sMensaje);
                
                while(mtchCadena.find() && String.isEmpty(sErrorMEssage)){
                    //Se elimina la palabra del comienzo de la cadena para que queden solo los rangos de numeracion
                    String sglCadena = mtchCadena.group(0).replaceAll(mtchCadena.group(1),'');
                    String sAccion = mtchCadena.group(1).replaceAll('\\:','');
                    Map<String,String> mpNumerostemp = RangoNumeracion(sglCadena,sAccion);
                    for(String sglNumerotemp:mpNumerostemp.keyset()){
                        if(sglNumerotemp!='ErrorMessage'){
                            if(!mpNumeros.containskey(sglNumerotemp))
                                mpNumeros.put(sglNumerotemp,sAccion);
                            else
                                sErrorMEssage = 'El numero '+sglNumerotemp+' se encuentra duplicado.';
                        }else{
                            sErrorMEssage = mpNumeros.get(sglNumerotemp);
                        }
                    }
                    
                }
            }else{
                sErrorMEssage = 'El rango de numeracion no es valido';
            }
            //system.debug(lstNumeros);
        }else{
            sErrorMEssage = 'El rango de numeracion no puede estar vacio';
        }
        mpNumeros.put('ErrorMessage',sErrorMEssage);
        system.debug(mpNumeros);
        return mpNumeros;
    }
    
    public static Map<String,String> RangoNumeracion(String sglCadena,String sAccion){
        //Manejo de errores
        String sErrorMEssage = '';
        
        //Listado final de numeros
        Map<String,String> mpNumeros = new Map<String,String>();
        
        Boolean bEsValido = Pattern.matches('(([0-9]{8,10}[-]?(?:[0-9]{8,10})?)[\\;]?)+', sglCadena);
        if(bEsValido){
            pattern pttnNumeracion = pattern.compile('([0-9]{8,10}[-]?(?:[0-9]{8,10})?)[\\;]?');
            matcher mtchNumeracion = pttnNumeracion.matcher(sglCadena);
            while(mtchNumeracion.find() && String.isEmpty(sErrorMEssage)){
                system.debug(mtchNumeracion.group(1));
                
                // Se separa cada bloque de numero por sepado, puede ser un arreglo o un numero sencillo
                String sBloqueNumero = mtchNumeracion.group(1);
                if(sBloqueNumero.contains('-')){
                    String[] arrNumeros = sBloqueNumero.split('-');
                    if(arrNumeros.size()==2){
                        Double iNumeroA = Double.valueOf(arrNumeros[0]);
                        Double iNumeroB = Double.valueOf(arrNumeros[1]);
                        if(iNumeroA<iNumeroB){
                            while(iNumeroA<=iNumeroB && String.isEmpty(sErrorMEssage)){
                                if(!mpNumeros.containskey(String.valueOf(iNumeroA)))
                                    mpNumeros.put(String.valueOf(iNumeroA.longValue()),sAccion);
                                //if(!lstNumeros.contains(String.valueOf(iNumeroA)))
                                //	lstNumeros.add(String.valueOf(iNumeroA));
                                else
                                    sErrorMEssage = 'El numero '+String.valueOf(iNumeroA.longValue())+' se encuentra duplicado.';
                                iNumeroA++;
                            }
                        }else{
                            sErrorMEssage = 'El rango '+sBloqueNumero+' no es valido, el numero inicial debe ser menor al numero final';
                        }
                    }else{
                        sErrorMEssage = 'El rango '+sBloqueNumero+' no es valido, debe poseer numero inicial y final';
                    }
                }else{
                    if(!mpNumeros.containskey(sBloqueNumero))
                        mpNumeros.put(sBloqueNumero,sAccion);
                    //if(!lstNumeros.contains(sBloqueNumero))
                    //	lstNumeros.add(sBloqueNumero);
                    else
                        sErrorMEssage = 'El numero '+sBloqueNumero+' se encuentra duplicado';
                }
            }
        }else{
            sErrorMEssage = 'Numeración no valida: '+sglCadena;
        }
        mpNumeros.put('ErrorMessage',sErrorMEssage);
        system.debug(mpNumeros);
        return mpNumeros;
    }
    
    public static void actualizarTecnologiaProductoSDWAN(Viabilidad__c viabilidad, string tecnologia){
     	List<OperacionComercial__c> ocListAux = new List<OperacionComercial__c>();   
        ocListAux = [Select Id, Tecnologia_servicio_SDWAN__c From OperacionComercial__c WHERE Id =: viabilidad.OperacionComercial__r.Id];
        string strTecnologia = String.valueOf(tecnologia);
        
        if(ocListAux.size() > 0){
            if(strTecnologia == 'CiscoViptela')
                strTecnologia = 'Cisco Viptela';
            
            if(strTecnologia == 'CiscoMeraki')
                strTecnologia = 'Cisco Meraki';
                               
            ocListAux[0].Tecnologia_servicio_SDWAN__c = String.valueOf(strTecnologia);            
            update ocListAux;
        }
    }    
    
    
    
    
    @Future   
    public static void ActualizarObjeto(String jsonString){
        List<SObject> sObjs = new List<SObject>();
        sObjs = (List<SObject>) JSON.deserialize(jsonString, List<SObject>.class);
        if(!sObjs.isEmpty()) {
            update sObjs;
        }
    }
    
    public static String SerializarLista(List<SObject> sObjs) {
        try {
            return JSON.serialize(sObjs);
        } catch (Exception e) {
            System.debug('Error in SObject List serialization');
        }
        return null;
    }


    public static IntegracionGestor_ws.MsgSalidaInicioFacturacion CambioFechaAgenda(IntegracionGestor_ws.MsgEntradaInicioFacturacion msgEntrada){
        LogTransacciones__c logServicio = new LogTransacciones__c(AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion,Informacion_Recibida__c = String.valueOf(msgEntrada),Name = 'Cambio Fecha Agenda ' + msgEntrada.transaccion.idTransaccion);
        IntegracionGestor_ws.MsgSalidaInicioFacturacion respuesta = new IntegracionGestor_ws.MsgSalidaInicioFacturacion();
        respuesta.resultado = 'Erroneo';
        respuesta.msgError.codigoError='NOK';
        List<Linea__c> lstLineas = new List<Linea__c>();
        String sErrorMessage = '';
        List<Id> lstNumeroAbb = new List<Id>();
        try{
            System.debug('Error in SObject List serialization');
        List<OperacionComercial__c> lstOC = [SELECT Id, Name, Fecha_de_Agenda__c FROM OperacionComercial__c where name =: msgEntrada.inicioFacturacion.numeroOC AND  CuentaCliente__r.Segmento__c = 'MiPymes'];
            if(!lstOC.isEmpty()){
                OperacionComercial__c sglOC=lstOC[0];
                try{
                   
                    if(String.isNotEmpty(msgEntrada.inicioFacturacion.fechaInicioFacturacion)){
                        sglOC.Fecha_de_Agenda__c = date.parse(msgEntrada.inicioFacturacion.fechaInicioFacturacion);       
                    } 
                    else {
                        sErrorMessage = 'La fecha de Agenda no fue suministrada.';
                    }           

                    if(String.isEmpty(sErrorMessage)){
                        System.debug('sglOC '+sglOC);
                        update sglOC;            
                        respuesta.resultado = 'Exitoso';
                        respuesta.msgError.codigoError='';
                    }else{
                        respuesta.msgError.mensajeError = sErrorMessage;
                    }
                }catch(exception e){
                    system.debug('**exec '+e.getStackTraceString());
                    system.debug('**exec '+e.getMessage());
                    respuesta.msgError.mensajeError=e.getMessage();
                }
                logServicio.AC_CorrelationID_Random__c = msgEntrada.transaccion.idTransaccion;
                logServicio.LTE_Operacion_Comercial__c = sglOC.Id;
                logServicio.Name = 'Cambio Fecha Agenda ' + sglOC.Name;
                logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
            }else{
                respuesta.msgError.mensajeError='Operacion Comercial ' +msgEntrada.inicioFacturacion.numeroOC+' no encontrada. Recuerde que el segmento de la cuenta a la que pertenece la OC, debe ser MiPymes.';
            }
        }catch(exception e){
            system.debug(e.getStackTraceString());
            respuesta.msgError.mensajeError=e.getMessage();
        }
        logServicio.Informacion_Enviada__c = String.valueOf(respuesta);
        insert logServicio;
        return respuesta;
    }
}