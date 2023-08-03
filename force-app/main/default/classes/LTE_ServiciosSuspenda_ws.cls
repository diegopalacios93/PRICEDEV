global class LTE_ServiciosSuspenda_ws {
	
    global class consultaOrden{
        //webservice string OrderId;
        webservice string numeroDeConexion='';
        webservice string tipoDocumento='';
        webservice string numeroDocumento='';
        webservice string tramite='';
        
    }
    
    global class respuestaOrden{
        webservice string OrderId='';
        webservice string numeroDeConexion='';
        //webservice string tramite='';
        webservice string tipoDocumento='';
        webservice string numeroDocumento='';
        webservice string mensajeError='';
        webservice string codigo='';
    }
    
    
    
    
    
    static webservice list<respuestaOrden> actualizacionEstadosOrdenes(list<consultaOrden> co){
    	

        LogTransacciones__c logServicio = new LogTransacciones__c();
        logServicio.AC_CorrelationID_Random__c = dateTime.now()+'';
        logServicio.Informacion_Recibida__c = String.valueOf(co);
        logServicio.Name = 'Actualizacion Estados Ordenes';
        insert logServicio;
        
        //Wrapper para guardar los datos de la consulta, la respuesta y otros valores comunes
        map<string,wrapper> mapWrapper=new map<string,wrapper>();
    	
    	//Set con los numeros de conexión
    	set<string> numeroConexion=new set<string>();
    	
    	//Lista para guardar la respuesta del servicio web
    	list<respuestaOrden> respuesta = new list<respuestaOrden>();
    	
    	set<String> setTramites = new set<String>();
    	set<String> setTipoDoc = new set<String>();
    	set<String> setNumDoc = new set<String>();
    	
        for(consultaOrden ordenes:co){
            
    		System.debug('\n@@@@ ordenes===>'+ordenes);
    		
    		//Inicializo un wrapper por cada registro enviado
    		respuestaOrden res = new respuestaOrden();
    		wrapper wrp = new wrapper(ordenes, res);
    	
    		
    		//Valido que el numero de conexión esté diligenciado
    		if(ordenes.numeroDeConexion != null && ordenes.numeroDeConexion != ''){
    			numeroConexion.add(ordenes.numeroDeConexion);
    			wrp.ro.numeroDeConexion = ordenes.numeroDeConexion;
    		}
    		else{
    			wrp.ro.mensajeError += Label.LTE_SuspendaNumeroConexionError+' ';
    			wrp.ro.codigo = '2';
    		}
    		
    		//Valido que el tipo de documento esté diligenciado
    		if(ordenes.tipoDocumento != null && ordenes.tipoDocumento != ''){
    			wrp.ro.tipoDocumento = ordenes.tipoDocumento;
    			setTipoDoc.add(ordenes.tipoDocumento);
    		}
    		else{
    			wrp.ro.mensajeError += Label.LTE_SuspendaTipoDocumentoError+' ';
    			wrp.ro.codigo = '2';
    		}
    		
    		//Valido que el numero de documento esté diligenciado
    		if(ordenes.numeroDocumento != null && ordenes.numeroDocumento != ''){
    			wrp.ro.numeroDocumento = ordenes.numeroDocumento;
    			setNumDoc.add(ordenes.numeroDocumento);
    		}
    		else{
    			wrp.ro.mensajeError += Label.LTE_SuspendaNumeroDocumentoError+' ';
    			wrp.ro.codigo = '2';
    		}
    		
    		//Valido que el tipo de tramite esté diligenciado
    		if(ordenes.tramite == null || ordenes.tramite == ''){
    			wrp.ro.mensajeError += Label.LTE_SuspendaTramiteError+' ';
    			wrp.ro.codigo = '2';
    		}
    		else{
    			//wrp.ro.tramite = ordenes.tramite;
    			//Valido que el tramite enviado esté parametrizado en la configuración personalizada
    			if(LTE_TramitesSuspenda__c.getAll().containsKey(ordenes.tramite)){
	    			
	    			//Separo el tramite de la causal
	    			list<String> lstValores = ordenes.tramite.split(',');
	    			if(lstValores.size()==2){
	    				wrp.tramite = lstValores[0];
	    				wrp.causal = lstValores[1];
	    				
	    				setTramites.add(wrp.tramite);
	    			}
	    			else{
	    				wrp.ro.mensajeError += Label.LTE_SuspendaTramiteInvalido+' ';
	    				wrp.ro.codigo = '2';
	    			}
    			}
    			else{
    				wrp.ro.mensajeError += Label.LTE_SuspendaTramiteInvalido+' ';
    				wrp.ro.codigo = '2';	
    			}
    		}
    		
    	
    		string key=ordenes.numeroDeConexion+ordenes.tipoDocumento+ordenes.numeroDocumento;
    		key=key.toLowerCase();
    		System.debug('\n@@@key===>'+key);
    		System.debug('\n@@@wrp===>'+wrp);
    		mapWrapper.put(key,wrp);
    
    	}  	
    	//Obtengo un mapa con las cuentas asociadas a los tipos y numero de documentos
    	//map<String, Account> mapAcc = LTE_ServiciosSuspenda_ws.getMapCuentas(setTipoDoc, setNumDoc);
    	
    	//Obtengo los tipos de operación por plan relacionados con los tramites que envía suspenda
    	list<TOPP__c> lstTOPP =  LTE_ServiciosSuspenda_ws.getTiposOperacionPorPlan(setTramites);
    	
    	//Mapa para guardar los tipos de operacion por plan
    	map<String, TOPP__c> mapTOPP = new map<String, TOPP__c>();
    	set<String> setRT = new set<String>();
    	
    	for(TOPP__c topp : lstTOPP){
    		mapTOPP.put(topp.TipodeOperacionporplan__c, topp);
    		setRT.add(topp.Tipoderegistro__c);
    	}
        //Obtener los tramites de suspension
        Map<string,LTE_TramitesSuspenda__c> vTramitesSuspenda = LTE_TramitesSuspenda__c.getAll(); // (FS) 11-04-2018        
        string portabilidadSaliente=vTramitesSuspenda.get('Retiro, Portabilidad Saliente').LTE_Causal__c; // (FS) 11-04-2018
        string retiorpago=vTramitesSuspenda.get('Retiro, Pago').LTE_Causal__c;
    	
    	//Obtengo los tipos de registro asociados a las OC
    	map<String, RecordType> mapRT = LTE_ServiciosSuspenda_ws.getMapTiposRegistroTOPP(setRT);
    	
    	//Obtengo los servicios asociados a los numeros de conexión
    	list<ActivoETB__c> servicios = LTE_ServiciosSuspenda_ws.getServicios(numeroConexion);
    	//mapa para guardar los servicios asociados a los numeros de conexion
    	map<String, ActivoETB__c> mapActivos = new map<String, ActivoETB__c>();
    	for(ActivoETB__c serv:servicios){
    		string key=serv.NumeroConexion__c+serv.NombredelaCuenta__r.Tipodedocumento__c+serv.NombredelaCuenta__r.AccountNumber;  	
    		key=key.toLowerCase();
    		if(!mapActivos.containsKey(key) || (mapActivos.containsKey(key) && serv.Estado__c=='Activo'))
    			mapActivos.put(key, serv);
    	}
    	
    	map<String, OperacionComercial__c> mapOCs = new map<String, OperacionComercial__c>();
    	
    	for(consultaOrden ordenes:co){
    		string key=ordenes.numeroDeConexion+ordenes.tipoDocumento+ordenes.numeroDocumento;
    		key=key.toLowerCase();
    		
    		wrapper wrpAux = mapWrapper.get(key);
    		if(wrpAux.ro.mensajeError == ''){
	    		if(mapActivos.containsKey(key)){
	    			LTE_TramitesSuspenda__c tram = LTE_TramitesSuspenda__c.getAll().get(ordenes.tramite);
	    			
	    			OperacionComercial__c oc = new OperacionComercial__c();
	    			oc.CuentaCliente__c = mapActivos.get(key).NombredelaCuenta__c;
	    			oc.Activo__c = mapActivos.get(key).Id;
	    			oc.Plan__c = mapActivos.get(key).Plan__c;
	    			oc.CuentaFacturacion__c = mapActivos.get(key).CuentaFacturacion__c;
	    			oc.TOPP__c = mapTOPP.get(wrpAux.tramite).Id;
	    			oc.RecordTypeId = mapRT.get(mapTOPP.get(wrpAux.tramite).Tipoderegistro__c).Id;
	    			oc.FechaInicioReconexion__c = Date.today();
	    			oc.FechaRetiro__c = Date.today();
	    			oc.Estado__c = 'Facturado';
	    			oc.TipoSuspension__c = tram.LTE_Causal__c;                    
	    			mapOCs.put(key, oc);
	    			
	    			if(wrpAux.tramite == 'Retiro'){
                        if(tram.LTE_Causal__c == portabilidadSaliente){ 
	    					oc.Estado__c = 'Activa'; // (FS) 11-04-2018
                            mapActivos.get(key).Estado__c = 'Inactivo'; // (FS) 11-04-2018                       
                        }else if (tram.LTE_Causal__c == retiorpago){
                            oc.Estado__c = 'Facturado'; // (MF) 04-10-2018
                            mapActivos.get(key).Estado__c = 'Inactivo'; // (MF) 04-10-2018  
                        }else{
                            oc.Estado__c = 'Pendiente';
                        }                        
	    				oc.CausalRetiro__c = tram.LTE_Causal__c;                        
	    			}
	    			else{
	    				mapActivos.get(key).Estado__c = tram.LTE_EstadoServicio__c;
	    				mapActivos.get(key).LTE_Causal__c = tram.LTE_Causal__c;
	    			}
	    			
	    			(mapWrapper.get(key)).ro.codigo = '1';
	    		}
	    		else{
	    			(mapWrapper.get(key)).ro.mensajeError += Label.LTE_SuspendaSinServicioError+' ';
	    			(mapWrapper.get(key)).ro.codigo = '3';
	    		}
    		}
    		
    	}
    
    	if(!mapOCs.isEmpty()){
    		insert mapOCs.values();
    		update mapActivos.values();
    	}
    		
    	for(consultaOrden ordenes:co){
    		string key=ordenes.numeroDeConexion+ordenes.tipoDocumento+ordenes.numeroDocumento;
    		key=key.toLowerCase();
    		
    		wrapper wrp = mapWrapper.get(key);
    		if(mapOCs.containsKey(key))
    			wrp.ro.OrderId = mapOCs.get(key).Id;
			
			respuesta.add(wrp.ro);    		
    	}
    		
    	return respuesta;    
    }
    
    public static list<ActivoETB__c> getServicios(set<String> numeroConexion){
    	return new list<ActivoETB__c>([	
    		Select  Id,NumeroConexion__c,NombredelaCuenta__c,NombredelaCuenta__r.AccountNumber,NombredelaCuenta__r.Tipodedocumento__c, Estado__c,
    				CuentaFacturacion__c, Plan__c, LTE_Causal__c
    		From 	ActivoETB__c
    		Where 	NumeroConexion__c IN :numeroConexion And Estado__c != 'Inactivo'
    	]);
    }
    
    public static list<TOPP__c> getTiposOperacionPorPlan(set<String> tramites){
    	return new list<TOPP__c>([
    		Select 	Id, TipodeOperacionporplan__c, Tipoderegistro__c, LTE_Catalogo_de_Producto__r.Name
    		From	TOPP__c
    		Where	TipodeOperacionporplan__c IN :tramites And LTE_Catalogo_de_Producto__r.Name = :label.LTE
    	]);
    }
    
    public static map<String, RecordType> getMapTiposRegistroTOPP(set<String> setRT){
    	list<RecordType> lstRT = [
    		Select 	Id, DeveloperName, SObjectType
    		From	RecordType
    		Where	DeveloperName IN :setRT
    	];
    	map<String, RecordType> mapRT = new map<String, RecordType>();
    	for(RecordType rt :lstRT)
    		mapRT.put(rt.DeveloperName, rt);
    		
    	return mapRT;
    }
    
    /*public static map<String, Account> getMapCuentas(set<String> setTipoDoc, set<String> setNumDoc){
    	list<Account> lstAcc = [
    		Select	Id, Name, Tipodedocumento__c, AccountNumber 
    		From	Account
    		Where	AccountNumber IN :setNumDoc And Tipodedocumento__c IN :setTipoDoc
    	];
    	map<String, Account> mapAcc = new map<String, Account>();
    	
    	for(Account acc :lstAcc)
    		mapAcc.put((acc.Tipodedocumento__c+''+acc.AccountNumber),acc);
    	
    	return mapAcc;
    }*/
    
    public class wrapper{
    	public respuestaOrden ro;
    	public OperacionComercial__c oc; 
    	public consultaOrden co;
    	public String tramite='';
    	public String causal='';
    	
    	public wrapper(consultaOrden co, respuestaOrden ro){
	   		this.co=co;
	   		this.ro=ro;
    	}
    }

}