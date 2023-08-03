/******************************************************************************* 
Desarrollado por:		Avanxo Colombia
Autor:					Andrés Garrido
Proyecto:				ETB - Integracion Suspenda
Descripcion:			Clase que arma el XML para Suspeda
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     18-01-2016  Andrés Garrido (AG)        Creacion de la clase
1.1 	14-11-2017	Mauricio Farias (MF)	   - se ajusta la clase para canbiar los servicios de susspenda por lo de colletions
											   - se ajustan los encabezados del servicio y los menasjes de salisda para los servicios de consulta y registro
											   - Se ajustan la estructura de los mensajes de respuesta para obtener los campos que se necesita en el desarrollo de consulta y 
												 registros de suspension.
****************************************************************************/
public class LTE_OperacionesSFDCSuspenda_cls {
	
	//Método que realiza la consulta de suspensiones en Suspenda
	public map<String, wrpRespuestaSuspenda> consultarSuspensionSevicios(set<String> idsServicios, String tipoTramite, Boolean flagHistorial, set<String> idsOCs){
        String tramite = '';
		String xmlConsulta = '';
		String correlationId = DateTime.now()+'';
		String strFechaActivacion = '';
		String strFlag = '';
		
		//Obtengo los datos de los servicios 
		list<ActivoETB__c> lstServicios = new list<ActivoETB__c>();
		if(idsServicios != null){
			lstServicios = [
				Select	Id, NumeroConexion__c, NombredelaCuenta__c, NombredelaCuenta__r.Tipodedocumento__c, 
						NombredelaCuenta__r.AccountNumber, Fecha_Activacion__c,CuentaFacturacion__r.Name
				From	ActivoETB__c
				Where	Id IN :idsServicios
			];
		}
		
		//Obtengo los datos de las operaciones comerciales 
		list<OperacionComercial__c> lstOCs = new list<OperacionComercial__c>();
		if(idsOCs != null){
			lstOCs = [
				Select 	Id, Estado__c, Activo__c, Activo__r.NumeroConexion__c, Activo__r.NombredelaCuenta__r.Tipodedocumento__c, Comentarios__c,
						Activo__r.NombredelaCuenta__r.AccountNumber, Activo__r.Fecha_Activacion__c, TipoSuspension__c, TOPP__r.TipodeOperacionporplan__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.Name
				From 	OperacionComercial__c
				Where 	Id IN : idsOCs
			];
		}
		
		//Valido el Boolean para colocar el valor esperado en Suspenda
		system.debug('flagHistorial --> ' + flagHistorial);
		if(flagHistorial)
			strFlag = '1';
		else
			strFlag = '0';
		system.debug('strFlag --> ' + strFlag);
				
		//armo el encabezado del xml
		xmlConsulta += 	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:quer="http://www.etb.com.co/schemas/collections/QueryTramitsOp.xsd" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0" xmlns:quer1="http://www.etb.com.co/schemas/collections/QueryTramits.xsd">';
		xmlConsulta += 	'<soapenv:Header/>';
		xmlConsulta += 	'<soapenv:Body>';
		xmlConsulta += 	'<quer:QueryTramitsInput>';
		xmlConsulta += 	'<v1:WSRequestHeader2>';
        xmlConsulta += 		'<v1:System>';
		xmlConsulta += 		 '<v1:name>SALESFORCE</v1:name>';
        xmlConsulta += 		 '<v1:correlationID>"'+correlationId+'"</v1:correlationID>'; 
        xmlConsulta += 		 '<v1:processingServer>SALESFORCE</v1:processingServer>'; 
       	xmlConsulta += 	   '</v1:System>';
        xmlConsulta += 	   '<v1:Property>';
        xmlConsulta += 	   '<v1:name>?</v1:name>';
        xmlConsulta += 	   '<v1:value>?</v1:value>';
        xmlConsulta += 	   '</v1:Property>';
		xmlConsulta += 	'</v1:WSRequestHeader2>';
		xmlConsulta += 	'<quer1:Request>';
        xmlConsulta += 	'<quer1:General>';
		xmlConsulta += 		'<quer1:sourceSystem>SALESFORCE</quer1:sourceSystem>';
        xmlConsulta += 		'<quer1:checkOrderHistory>true</quer1:checkOrderHistory>';
        xmlConsulta += 		'</quer1:General>';
        xmlConsulta += 		'<quer1:Queries>';
        
        System.debug('\n@@@xmlConsulta===>'+xmlConsulta);
		//Armo el xml para los diferentes servicios
		if(lstServicios != null && !lstServicios.isEmpty()){
			for(ActivoETB__c serv : lstServicios)
			{
				system.debug('tipoTramite --> ' + tipoTramite);
				if(LTE_ConsultaSuspenda__c.getAll().containsKey(tipoTramite))
				{
					LTE_ConsultaSuspenda__c tram = LTE_ConsultaSuspenda__c.getAll().get(tipoTramite);
					system.debug('tram --> ' + tram);
					String strTramite = tram.Valor__c;
					system.debug('strTramite --> ' + strTramite);
                    tramite = strTramite;
					strFechaActivacion = String.ValueOf(serv.Fecha_Activacion__c.Year()+ '/' + String.ValueOf(serv.Fecha_Activacion__c.Month()) + '/' + String.ValueOf(serv.Fecha_Activacion__c.Day()));
					system.debug('strFechaActivacion --> ' + strFechaActivacion);
                    xmlConsulta += 	'<quer1:Query>';
					xmlConsulta += 	'<quer1:Customer>';
                    xmlConsulta +=  '<quer1:id>'+serv.NombredelaCuenta__r.AccountNumber+'</quer1:id>';
                    xmlConsulta +=	'<quer1:idType>'+serv.NombredelaCuenta__r.Tipodedocumento__c+'</quer1:idType>';
                    xmlConsulta +=	'</quer1:Customer>';
                    xmlConsulta +=	'<quer1:Account>';
                    xmlConsulta +=	'<quer1:billingAccountId>'+serv.CuentaFacturacion__r.Name+'</quer1:billingAccountId>';
                    xmlConsulta +=	'<quer1:serviceAccountId></quer1:serviceAccountId>';
                    xmlConsulta +=	'</quer1:Account>';
                    xmlConsulta +=	'<quer1:Service>';
                    xmlConsulta +=	'<quer1:connectionNumber>'+serv.NumeroConexion__c+'</quer1:connectionNumber>';
                    xmlConsulta +=	'<quer1:activationDate>'+strFechaActivacion+'</quer1:activationDate>';
                    xmlConsulta +=	'</quer1:Service>';
                    xmlConsulta +=	'<quer1:Order>';
                    xmlConsulta +=	'<quer1:code>'+strTramite+'</quer1:code>';
                    xmlConsulta +=	'</quer1:Order>';
                    xmlConsulta +=	'</quer1:Query>';
                    /*xmlConsulta += 	'<req:NumerosConexion>';
					xmlConsulta += 		'<req:NumeroConexion>'+serv.NumeroConexion__c+'</req:NumeroConexion>';
					xmlConsulta += 		'<req:TipoTramite>'+strTramite+'</req:TipoTramite>';
					xmlConsulta += 		'<req:TipoDocumento>'+serv.NombredelaCuenta__r.Tipodedocumento__c+'</req:TipoDocumento>';
					xmlConsulta += 		'<req:NumeroDocumento>'+serv.NombredelaCuenta__r.AccountNumber+'</req:NumeroDocumento>';
					xmlConsulta += 		'<req:FechaActivacion>'	+strFechaActivacion+'</req:FechaActivacion>';			
					xmlConsulta += 	'</req:NumerosConexion>';*/
				}
			}
		}
		if(lstOcs != null && !lstOcs.isEmpty())
		{
			for(OperacionComercial__c oc : lstOcs)
			{
				//tipoTramite = (oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Suspención')?'Suspensión Voluntaria':((oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Reconexión')?'Reconexión Voluntaria':'');
				String tipoTramiteOC = oc.TOPP__r.TipodeOperacionporplan__c+', '+oc.TipoSuspension__c;
				if(LTE_ConsultaSuspenda__c.getAll().containsKey(tipoTramiteOC))
				{
					LTE_ConsultaSuspenda__c tram = LTE_ConsultaSuspenda__c.getAll().get(tipoTramiteOC);
					system.debug('tram --> ' + tram);
					String strTramite = tram.Valor__c;
                    tramite = strTramite;
					system.debug('strTramite --> ' + strTramite);
					strFechaActivacion = String.ValueOf(oc.Activo__r.Fecha_Activacion__c.Year()+ '/' +String.ValueOf(oc.Activo__r.Fecha_Activacion__c.Month()) + '/' + String.ValueOf(oc.Activo__r.Fecha_Activacion__c.Day()));
					system.debug('strFechaActivacion --> ' + strFechaActivacion);
                    xmlConsulta += 	'<quer1:Query>';
                    xmlConsulta += 	'<quer1:Customer>';
                    xmlConsulta +=  '<quer1:id>'+oc.Activo__r.NombredelaCuenta__r.AccountNumber+'</quer1:id>';
                    xmlConsulta +=	'<quer1:idType>'+oc.Activo__r.NombredelaCuenta__r.Tipodedocumento__c+'</quer1:idType>';
                    xmlConsulta +=	'</quer1:Customer>';
                    xmlConsulta +=	'<quer1:Account>';
                    xmlConsulta +=	'<quer1:billingAccountId>'+oc.CuentaFacturacion__r.Name+'</quer1:billingAccountId>';
                    xmlConsulta +=	'<quer1:serviceAccountId></quer1:serviceAccountId>';
                    xmlConsulta +=	'</quer1:Account>';
                    xmlConsulta +=	'<quer1:Service>';
                    xmlConsulta +=	'<quer1:connectionNumber>'+oc.Activo__r.NumeroConexion__c+'</quer1:connectionNumber>';
                    xmlConsulta +=	'<quer1:activationDate>'+strFechaActivacion+'</quer1:activationDate>';
                    xmlConsulta +=	'</quer1:Service>';
                    xmlConsulta +=	'<quer1:Order>';
                    xmlConsulta +=	'<quer1:code>'+strTramite+'</quer1:code>';
                    xmlConsulta +=	'</quer1:Order>';
                    xmlConsulta +=	'</quer1:Query>';
					/*xmlConsulta += 	'<req:NumerosConexion>';
					xmlConsulta += 		'<req:NumeroConexion>'+oc.Activo__r.NumeroConexion__c+'</req:NumeroConexion>';
					xmlConsulta += 		'<req:TipoTramite>'+strTramite+'</req:TipoTramite>';
					xmlConsulta += 		'<req:TipoDocumento>'+oc.Activo__r.NombredelaCuenta__r.Tipodedocumento__c+'</req:TipoDocumento>';
					xmlConsulta += 		'<req:NumeroDocumento>'+oc.Activo__r.NombredelaCuenta__r.AccountNumber+'</req:NumeroDocumento>';
					xmlConsulta += 		'<req:FechaActivacion>'+strFechaActivacion+'</req:FechaActivacion>';			
					xmlConsulta += 	'</req:NumerosConexion>';*/
				}
			}
		}
		
		xmlConsulta +=	'</quer1:Queries>';
		xmlConsulta += 	'</quer1:Request>';
		xmlConsulta += 	'</quer:QueryTramitsInput>';
		xmlConsulta += 	'</soapenv:Body>';
		xmlConsulta += 	'</soapenv:Envelope>';
		
		System.debug('\n@@@xmlConsulta===>'+xmlConsulta);
		map<String, wrpRespuestaSuspenda> mapRespuesta = new map<String, wrpRespuestaSuspenda>();
		try{
			//Envío de Información a Suspenda
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('SuspendaConsulta');
			String response = LibreriaUtilitariaJobs_cls.consultarServicio(xmlConsulta, sw.Action__c, sw.EndPoint__c);
			System.debug('\n@@@response ===> ' + response);
			
			crearLogTransaccion(correlationId, '', 'COMPLETE', xmlConsulta, response, 'ConsultaSuspenda');
			
			//Procesamiento de la respuesta
			mapRespuesta = recuperarRespuestaXMLConsulta(response, tramite);
		}
		catch(System.Exception ex){
			crearLogTransaccion(correlationId, ex.getMessage(), 'ERROR', xmlConsulta, '', 'ConsultaSuspenda');
		}
		
		return mapRespuesta;
	}
	
	public map<String, wrpRespuestaSuspenda> registrarSuspensionSevicios(set<String> idsOCs){
		String xmlConsulta = '';
		String correlationId = DateTime.now()+'';
		String strFecha = '';
		
		list<OperacionComercial__c> lstOCs = [
			Select	Id, NumeroConexion__c, Activo__r.NombredelaCuenta__r.Tipodedocumento__c, TipoSuspension__c, TOPP__r.TipodeOperacionporplan__c, 
					Activo__r.NombredelaCuenta__r.AccountNumber, CreatedDate, CuentaFacturacion__r.Name, Activo__r.NumeroConexion__c
			From	OperacionComercial__c
			Where	Id IN :idsOCs
		];
		
		xmlConsulta += 	'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.tibco.com/schemas/ETB.MDM.Collections.Interface/ETB.MDM.Collections.Interface.Core/RegisterTramits/Schema/Schema.xsd" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader2/v1.0" xmlns:col="Collection_Siebel">';
		xmlConsulta += 	'<soapenv:Header/>';
		xmlConsulta += 	'<soapenv:Body>';
		xmlConsulta += 	'<sch:RegisterTramitsInput>';
		xmlConsulta += 	'<v1:WSRequestHeader2>';
        xmlConsulta += 	'<v1:System>';
        xmlConsulta += 	'<v1:name>SALESFORCE</v1:name>';
        xmlConsulta += 	'<v1:correlationID>"'+correlationId+'"</v1:correlationID>';
        xmlConsulta += 	'<v1:processingServer>"SALESFORCE"</v1:processingServer>';
        xmlConsulta += 	'</v1:System>';
		xmlConsulta += 	'<v1:Property>';
        xmlConsulta += 	'<v1:name>?</v1:name>';
        xmlConsulta += 	'<v1:value>?</v1:value>';
        xmlConsulta += 	'</v1:Property>';
		xmlConsulta += 	'</v1:WSRequestHeader2>';
		
        System.debug('\n@@@xmlRegistro===>'+xmlConsulta);
        
		//Armo el xml para los diferentes servicios
		for(OperacionComercial__c oc : lstOCs){
			String tipoTramite = oc.TOPP__r.TipodeOperacionporplan__c+', '+oc.TipoSuspension__c;
			if(LTE_ConsultaSuspenda__c.getAll().containsKey(tipoTramite))
			{
				LTE_ConsultaSuspenda__c tram = LTE_ConsultaSuspenda__c.getAll().get(tipoTramite);
				system.debug('tram --> ' + tram);
				String strTramite = tram.Valor__c;
				system.debug('strTramite --> ' + strTramite);
				//String tipoTramite = (oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Suspención')?'Suspensión, Voluntaria':((oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Reconexión')?'Reconexión Voluntaria':'');
				strFecha = String.ValueOf(oc.CreatedDate.Month()) + '/' + String.ValueOf(oc.CreatedDate.Day() + '/' + String.ValueOf(oc.CreatedDate.Year()));
				system.debug('strFecha --> ' + strFecha);
                xmlConsulta += 	'<col:RegistroTramiteMasivo>';
                xmlConsulta +=	'<col:Origen>SALESFORCE</col:Origen>';
                xmlConsulta +=	'<col:DatosRegistro>';
                xmlConsulta +=	'<col:RequestRegistroTramiteMasivo>';
                xmlConsulta +=	'<col:Pedido>'+oc.Id+'</col:Pedido>';
                xmlConsulta +=	'<col:Abonado>'+oc.Activo__r.NumeroConexion__c+'</col:Abonado>';
                xmlConsulta +=	'<col:TipoTramite>'+strTramite+'</col:TipoTramite>'; 
                xmlConsulta +=	'<col:FechaIngresoTramite>'+strFecha+'</col:FechaIngresoTramite>';
                xmlConsulta +=	'<col:TipoDocumento>'+oc.Activo__r.NombredelaCuenta__r.Tipodedocumento__c+'</col:TipoDocumento>';
                xmlConsulta +=	'<col:NumeroDocumento>'+oc.Activo__r.NombredelaCuenta__r.AccountNumber+'</col:NumeroDocumento>';
                xmlConsulta +=	'<col:CuentaFacturacion>'+oc.CuentaFacturacion__r.Name+'</col:CuentaFacturacion>';
                xmlConsulta +=	'<col:CuentaServicio></col:CuentaServicio>';
                xmlConsulta +=	'<col:IdTransaccion>?</col:IdTransaccion>';
                xmlConsulta +=	'<col:sMotivo>?</col:sMotivo>';
                xmlConsulta +=	'<col:FechaOperacion>?</col:FechaOperacion>';
                xmlConsulta +=	'</col:RequestRegistroTramiteMasivo>';
                xmlConsulta +=	'</col:DatosRegistro>';
				/*xmlConsulta += 	'<req:NumerosConexion>';
				xmlConsulta += 		'<req:NumeroConexion>'+oc.Activo__r.NumeroConexion__c+'</req:NumeroConexion>';
				xmlConsulta += 		'<req:TipoTramite>'+strTramite+'</req:TipoTramite>';
				xmlConsulta += 		'<req:TipoDocumento>'+oc.Activo__r.NombredelaCuenta__r.Tipodedocumento__c+'</req:TipoDocumento>';
				xmlConsulta += 		'<req:NumeroDocumento>'+oc.Activo__r.NombredelaCuenta__r.AccountNumber+'</req:NumeroDocumento>';
				xmlConsulta += 		'<req:Fecha>'+strFecha+'</req:Fecha>';
				xmlConsulta += 		'<req:NumeroCtaFacturacion>'+oc.CuentaFacturacion__r.Name+'</req:NumeroCtaFacturacion>';
                xmlConsulta += 		'<req:IdPedido>'+oc.Id+'</req:IdPedido>';			
				xmlConsulta += 	'</req:NumerosConexion>';*/
			}
		}
		
		xmlConsulta += 	'</col:RegistroTramiteMasivo>';
		xmlConsulta += 	'</sch:RegisterTramitsInput>';
		xmlConsulta += 	'</soapenv:Body>';
		xmlConsulta += 	'</soapenv:Envelope>';
		
		System.debug('\n@@@xmlRegistro===>'+xmlConsulta);
		map<String, wrpRespuestaSuspenda> mapRespuesta = new map<String, wrpRespuestaSuspenda>();
		try{
			//Envío de Información a Suspenda
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('SuspendaRegistro');
            String response;
            if(!Test.isRunningTest())
				response = LibreriaUtilitariaJobs_cls.consultarServicio(xmlConsulta, sw.Action__c, sw.EndPoint__c);
            else{                
                string idTest = (new list<string>(idsOCs))[0];                    
                response = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:RegisterTramitsOutput xmlns:ns0="http://www.tibco.com/schemas/ETB.MDM.Collections.Interface/ETB.MDM.Collections.Interface.Core/RegisterTramits/Schema/Schema.xsd"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Tibco</ns1:name><ns1:correlationID>"2017-12-13 17:01:23"</ns1:correlationID><ns1:processingServer>Tibco MDM</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2017-12-13T12:01:39.091-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><RegistroTramiteMasivoResponse xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns="Collection_Siebel" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><RegistroTramiteMasivoResult><RespuestaTramiteMasivo><NumeroPedido>'+idTest+'</NumeroPedido><CodigoRespuesta>1</CodigoRespuesta><DescripcionRespuesta>Operacion Exitosa: Se registra el tramite correctamente</DescripcionRespuesta></RespuestaTramiteMasivo></RegistroTramiteMasivoResult></RegistroTramiteMasivoResponse></ns0:RegisterTramitsOutput></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            }
			System.debug('\n@@@response Registro ===> ' + response);
			crearLogTransaccion(correlationId, '', 'COMPLETE', xmlConsulta, response, 'RegistroSuspenda');
			
			//Procesamiento de la respuesta
			mapRespuesta = recuperarRespuestaXMLRegistro(response);
		}
		catch(System.Exception ex){            
			crearLogTransaccion(correlationId, ex.getMessage(), 'ERROR', xmlConsulta, '', 'RegistroSuspenda');
		}
		
		return mapRespuesta;
	}
	
	
	public void crearLogTransaccion(String correlationID, String errorApex, String estado, String infoEnviada, String infoRecibida, String nombre){
		LogTransacciones__c log = new LogTransacciones__c();
		log.CorrelationId__c = correlationID;
		log.Error_Apex__c = errorApex;
		log.Estado__c = estado;
		log.Informacion_Enviada__c = ( infoEnviada.length() > 100000 ? infoEnviada.SubString(0,100000) : infoEnviada );
		log.Informacion_Recibida__c = ( infoRecibida.length() > 100000 ? infoRecibida.SubString(0,100000) : infoRecibida );
		log.Name = nombre;
		insert log;
	}
	
	//metodo que arma la respuesta dependiendo del response
	public map<string,wrpRespuestaSuspenda> recuperarRespuestaXMLConsulta(String response, String tramiteOrden){
		//String response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wso="http://www.etb.com.co/LTE/WS/SuspensionsReconnections/ConsultaSuspenda_Masivo/WSOutputConsultaSuspenda" xmlns:v1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0" xmlns:res="http://www.etb.com.co/LTE/WS/SuspensionsReconnections/ConsultaSuspenda_Masivo/ResponseConsultaSuspenda"><soapenv:Header/><soapenv:Body><wso:WSOutputConsultaSuspenda><v1:WSResponseHeader><v1:System correlationID="12345" processingServer="Test">Salesforce</v1:System><v1:Service><v1:status>?</v1:status><!--Optional:--><v1:responseDate>2010-01-01</v1:responseDate><!--Zero or more repetitions:--><v1:statusDetail><v1:errorCode>?</v1:errorCode><!--Optional:--><v1:errorDetailCode>?</v1:errorDetailCode><v1:errorMessage>?</v1:errorMessage></v1:statusDetail></v1:Service><!--Zero or more repetitions:--></v1:WSResponseHeader><res:ResponseConsultaSuspenda><res:NumeroConexion>3017411905</res:NumeroConexion><res:TipoTramite>Susupensión, Voluntaria</res:TipoTramite><res:TipoDocumento>CC</res:TipoDocumento><res:NumeroDocumento>1032360007</res:NumeroDocumento><res:FechaActivacion>2010-01-01</res:FechaActivacion><res:CodigoRespuesta>1</res:CodigoRespuesta><res:DescripcionRespuesta>Respuesta 1</res:DescripcionRespuesta><!--1 or more repetitions:--><res:HistoriaTramites><res:Tramite>Tramite 1</res:Tramite><res:Fecha>2010-02-02</res:Fecha><res:Pedido>Id Pedido</res:Pedido></res:HistoriaTramites></res:ResponseConsultaSuspenda></wso:WSOutputConsultaSuspenda></soapenv:Body></soapenv:Envelope>';
		map<string,wrpRespuestaSuspenda> mapRespuestas = new map<string,wrpRespuestaSuspenda>();
		wrpRespuestaSuspenda wrpRes;
		
		Dom.Document doc = new Dom.Document();
		doc.load(response);
		Dom.XMLNode env= doc.getRootElement();
		system.debug('****'+env);
		system.debug(env.getNamespace());
		string namespace = env.getNamespace();
		
		/*Dom.XMLNode body=env.getChildElement('Body',namespace);
		system.debug('****Body==>'+body);
		Dom.XMLNode ResponseSuspenda;
		for(Dom.XmlNode nodo : body.getChildren()){
			system.debug('nombre: '+nodo.getName());
			if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSOutputConsultaSuspenda')) // QueryTramitsOutput
				ResponseSuspenda=nodo;
		}
		Dom.XMLNode ResponseHeader;
		Dom.XMLNode ResponseConsulta;
		
		for(Dom.XmlNode nodo : ResponseSuspenda.getChildren())
		{
			system.debug('nombre: '+nodo.getName());
			if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseHeader')) // WSResponseHeader2
				ResponseHeader=nodo;
			else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('ResponseConsultaSuspenda')) // Outcomes
				ResponseConsulta=nodo;
            else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('ResponseConsultaSuspenda')) // Result
				ResponseConsulta=nodo;
		}
		system.debug('Header::'+ResponseHeader.getChildren());
		system.debug('ResponseConsulta::'+ResponseConsulta.getChildren());
		
		
		for(Dom.XmlNode nodo1 : ResponseConsulta.getChildren())
		{
			Dom.XMLNode ResponseNumerosConexion;
			wrpRes = new wrpRespuestaSuspenda();
			if(nodo1.getName()!=null && nodo1.getName().equalsIgnoreCase('NumerosConexion')){ // 
				ResponseNumerosConexion=nodo1;
				system.debug('@@@@nombre: '+nodo1.getName());
				system.debug('@@@@nombreText: '+nodo1.getText());
				
				for(Dom.XmlNode nodo : ResponseNumerosConexion.getChildren()){
				
					if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('NumeroConexion')) // connectionNumber
						wrpRes.NumeroConexion = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('TipoTramite')) 
						wrpRes.TipoTramite = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('TipoDocumento'))
						wrpRes.TipoDocumento = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('NumeroDocumento')) // 
						wrpRes.NumeroDocumento = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('FechaActivacion')) // startDate
						wrpRes.FechaActivacion = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CodigoRespuesta')) // description
						wrpRes.CodigoRespuesta = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('DescripcionRespuesta')) // description
						wrpRes.DescripcionRespuesta = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CodigoFlujo')) // code
						wrpRes.CodigoFlujo = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('DescripcionFlujo')) // description
						wrpRes.DescripcionFlujo = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('DescripcionError')) // errorCode
						wrpRes.DescripcionError = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('HistoriaTramites')){ // 
						wrpRes.lstTramites = new list<wrpHistoriaTramite>();
						wrpHistoriaTramite histTra = new wrpHistoriaTramite();
						for(Dom.XmlNode nodoTramites : nodo.getChildren()){
							system.debug('@@@nombreH: '+nodoTramites.getName());
							system.debug('@@@nombreHT: '+nodoTramites.getText());
							
							if(nodoTramites.getName()!=null && nodoTramites.getName().equalsIgnoreCase('Tramite'))
								histTra.tramite = nodoTramites.getText();
							else if(nodoTramites.getName()!=null && nodoTramites.getName().equalsIgnoreCase('Fecha'))
								histTra.fecha = nodoTramites.getText();
							else if(nodoTramites.getName()!=null && nodoTramites.getName().equalsIgnoreCase('Pedido'))
								histTra.pedido = nodoTramites.getText();
						}
						wrpRes.lstTramites.add(histTra);
					}
				}
				
				String llave = tramite + '-' + wrpRes.NumeroConexion;
				System.debug('\n@@@llaveRes===>'+llave);	
				mapRespuestas.put(llave, wrpRes);
			}
			
		
			
		}*/
        
        Dom.XMLNode body=env.getChildElement('Body',namespace); // inicio
		system.debug('****Body==>'+body);
		Dom.XMLNode ResponseSuspenda;
		for(Dom.XmlNode nodo : body.getChildren()){
			system.debug('nombre: '+nodo.getName());
			if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('QueryTramitsOutput')) 
				ResponseSuspenda=nodo;
		}
		Dom.XMLNode ResponseHeader;
		Dom.XMLNode ResponseConsulta;
        Dom.XMLNode ResponseResult;
		
		for(Dom.XmlNode nodo : ResponseSuspenda.getChildren())
		{
			system.debug('nombre: '+nodo.getName());
			if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseHeader2')) 
				ResponseHeader=nodo;
			else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Outcomes')) 
				ResponseConsulta=nodo;
            else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Result')) 
				ResponseResult=nodo;
		}
		system.debug('Header::'+ResponseHeader.getChildren());
		system.debug('ResponseConsulta::'+ResponseConsulta.getChildren());
        system.debug('ResponseResult::'+ResponseResult.getChildren());
		
		
		for(Dom.XmlNode nodo1 : ResponseConsulta.getChildren())
		{
			Dom.XMLNode ResponseNumerosConexion;
			wrpRes = new wrpRespuestaSuspenda();
			if(nodo1.getName()!=null && nodo1.getName().equalsIgnoreCase('Outcome')){ 
				ResponseNumerosConexion=nodo1;
				system.debug('@@@@nombre: '+nodo1.getName());
				system.debug('@@@@nombreText: '+ResponseNumerosConexion);
                
                Dom.XMLNode ResponseService;
				Dom.XMLNode ResponseWorkPlan;
        		Dom.XMLNode ResponseOrders;
                Dom.XMLNode ResponseAction;
                
                for(Dom.XmlNode nodo : ResponseNumerosConexion.getChildren())
                {
                    
                    //system.debug('nombre: '+nodo.getName());
					if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Service')) 
						ResponseService=nodo;
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WorkPlan')) 
						ResponseWorkPlan=nodo;
            		else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Orders')) 
						ResponseOrders=nodo;
                    else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Action')) 
						ResponseAction=nodo;
                } 
                 system.debug('Service::'+ResponseService.getChildren());
				 system.debug('WorkPlan::'+ResponseWorkPlan.getChildren());
       			 system.debug('ResponseOrders::'+ResponseOrders.getChildren());
                 system.debug('ResponseAction::'+ResponseAction.getChildren());
                    
		        wrpRes = new wrpRespuestaSuspenda();  
                for(Dom.XmlNode nodo10 : ResponseService.getChildren())
                    {
						system.debug('nombre: '+nodo10.getName());
						if(nodo10.getName()!=null && nodo10.getName().equalsIgnoreCase('connectionNumber')) 
						    wrpRes.NumeroConexion = nodo10.getText();
						
					} 
                    
                 for(Dom.XmlNode nodo : ResponseWorkPlan.getChildren())
                    {
						system.debug('nombre: '+nodo.getName());
						if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('code')) 
						wrpRes.CodigoFlujo = nodo.getText();
						else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('description')) 
						wrpRes.DescripcionFlujo = nodo.getText();
						
					}  
                    
                  for(Dom.XmlNode nodo : ResponseAction.getChildren())
                      {
						system.debug('nombre: '+nodo.getName());
                          if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('code')) {
						wrpRes.CodigoRespuesta = nodo.getText();
                         wrpRes.TipoTramite = tramiteOrden;
						}else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('description')) 
						wrpRes.DescripcionRespuesta = nodo.getText();
                        else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('reason')) 
						wrpRes.DescripcionError = nodo.getText();
						
					} 
                
                
                
                    /*for(Dom.XmlNode nodo10 : ResponseOrders.getChildren())
                    {
						wrpRes.lstTramites = new list<wrpHistoriaTramite>();
						wrpHistoriaTramite histTra = new wrpHistoriaTramite();
                        system.debug('nombre: '+nodo.getName());
						if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('code')) 
								histTra.tramite = nodo.getText();
							else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('startDate')) 
								histTra.fecha = nodo.getText();
							else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('id')) 
								histTra.pedido = nodo.getText();
						
					} */
				
					//if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('connectionNumber')) 
						//wrpRes.NumeroConexion = nodo.getText();
					//if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('code')) // <quer1:Orders> <quer1:Order> <quer1:code>
						//wrpRes.TipoTramite = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('TipoDocumento'))
						//wrpRes.TipoDocumento = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('NumeroDocumento'))
						//wrpRes.NumeroDocumento = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('startDate')) // <quer1:Orders> <quer1:Order> <quer1:startDate> 
						//wrpRes.FechaActivacion = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('code')) //  <quer1:Action> <quer1:code>
						//wrpRes.CodigoRespuesta = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('description')) // <quer1:Action> <quer1:description>
						//wrpRes.DescripcionRespuesta = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('code')) // <quer1:WorkPlan> <quer1:code>?</quer1:code>
						//wrpRes.CodigoFlujo = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('description')) // <quer1:WorkPlan> <quer1:description>
						//wrpRes.DescripcionFlujo = nodo.getText();
					//else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('reason')) // <quer1:Action> <quer1:reason> 
						//wrpRes.DescripcionError = nodo.getText();
					
                
                //if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('ResponseOrders')){
						wrpRes.lstTramites = new list<wrpHistoriaTramite>();
						wrpHistoriaTramite histTra = new wrpHistoriaTramite();
						for(Dom.XmlNode nodoTramites : ResponseOrders.getChildren()){
							system.debug('@@@nombreH: '+nodoTramites.getName());
							system.debug('@@@nombreHT: '+nodoTramites.getText());
							
                            if(nodoTramites.getName()!=null && nodoTramites.getName().equalsIgnoreCase('code')){ // <quer1:Orders> <quer1:Order> <quer1:code>
								histTra.tramite = nodoTramites.getText();
                            }else if(nodoTramites.getName()!=null && nodoTramites.getName().equalsIgnoreCase('startDate')) // <quer1:Orders> <quer1:Order> <quer1:startDate>
								histTra.fecha = nodoTramites.getText();
							else if(nodoTramites.getName()!=null && nodoTramites.getName().equalsIgnoreCase('id')) // <quer1:Orders> <quer1:Order> <quer1:id>?</quer1:id>
								histTra.pedido = nodoTramites.getText();
						}
						wrpRes.lstTramites.add(histTra);
					//}
				//}
				
				String llave = tramiteOrden + '-' + wrpRes.NumeroConexion;
                system.debug('tramiteres: '+tramiteOrden);
				System.debug('\n@@@llaveRes===>'+llave);	
				mapRespuestas.put(llave, wrpRes);
			}
			
		
			
		} // fin
		
		System.debug('\n@@@MapaRespuestaConsulta===>'+mapRespuestas);
		
		return mapRespuestas;
	}
	
	//metodo que arma la respuesta dependiendo del response
	public map<string,wrpRespuestaSuspenda> recuperarRespuestaXMLRegistro(String response){
	//String response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wso="http://www.etb.com.co/LTE/WS/SuspensionsReconnections/ConsultaSuspenda_Masivo/WSOutputConsultaSuspenda" xmlns:v1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0" xmlns:res="http://www.etb.com.co/LTE/WS/SuspensionsReconnections/ConsultaSuspenda_Masivo/ResponseConsultaSuspenda"><soapenv:Header/><soapenv:Body><wso:WSOutputConsultaSuspenda><v1:WSResponseHeader><v1:System correlationID="12345" processingServer="Test">Salesforce</v1:System><v1:Service><v1:status>?</v1:status><!--Optional:--><v1:responseDate>2010-01-01</v1:responseDate><!--Zero or more repetitions:--><v1:statusDetail><v1:errorCode>?</v1:errorCode><!--Optional:--><v1:errorDetailCode>?</v1:errorDetailCode><v1:errorMessage>?</v1:errorMessage></v1:statusDetail></v1:Service><!--Zero or more repetitions:--></v1:WSResponseHeader><res:ResponseConsultaSuspenda><res:NumeroConexion>3017411905</res:NumeroConexion><res:TipoTramite>Susupensión, Voluntaria</res:TipoTramite><res:TipoDocumento>CC</res:TipoDocumento><res:NumeroDocumento>1032360007</res:NumeroDocumento><res:FechaActivacion>2010-01-01</res:FechaActivacion><res:CodigoRespuesta>1</res:CodigoRespuesta><res:DescripcionRespuesta>Respuesta 1</res:DescripcionRespuesta><!--1 or more repetitions:--><res:HistoriaTramites><res:Tramite>Tramite 1</res:Tramite><res:Fecha>2010-02-02</res:Fecha><res:Pedido>Id Pedido</res:Pedido></res:HistoriaTramites></res:ResponseConsultaSuspenda></wso:WSOutputConsultaSuspenda></soapenv:Body></soapenv:Envelope>';
		map<string,wrpRespuestaSuspenda> mapRespuestas = new map<string,wrpRespuestaSuspenda>();
		wrpRespuestaSuspenda wrpRes;
		
		Dom.Document doc = new Dom.Document();
		doc.load(response);
		Dom.XMLNode env= doc.getRootElement();
		system.debug('****'+env);
		system.debug(env.getNamespace());
		string namespace = env.getNamespace();
		
		Dom.XMLNode body=env.getChildElement('Body',namespace);
		system.debug('****Body==>'+body);
		Dom.XMLNode ResponseSuspenda;
		for(Dom.XmlNode nodo : body.getChildren()){
			system.debug('nombre: '+nodo.getName());
			if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('RegisterTramitsOutput')) //WSOutputRegistroSuspenda
				ResponseSuspenda=nodo;
		}
		Dom.XMLNode ResponseHeader;
		Dom.XMLNode ResponseRegistro;
		
		for(Dom.XmlNode nodo : ResponseSuspenda.getChildren())
		{
			system.debug('nombre: '+nodo.getName());
			if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseHeader2'))
				ResponseHeader=nodo;
			else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('RegistroTramiteMasivoResponse')) //ResponseRegistroSuspenda
				ResponseRegistro=nodo;
		}
		
		Dom.XMLNode NumConexion;
		for(Dom.XmlNode nodo1 : ResponseRegistro.getChildren()){
			system.debug('nombre: '+nodo1.getName());
			if(nodo1.getName()!=null && nodo1.getName().equalsIgnoreCase('RegistroTramiteMasivoResult'))
                NumConexion=nodo1;
                }
        Dom.XMLNode RespuestaTramiteMasivo;
		for(Dom.XmlNode nodo1 : NumConexion.getChildren())
		{
			system.debug('nombre: '+nodo1.getName());
			if(nodo1.getName()!=null && nodo1.getName().equalsIgnoreCase('RespuestaTramiteMasivo')){
				RespuestaTramiteMasivo=nodo1;
				
				wrpRes = new wrpRespuestaSuspenda();
				String llave = '';
				for(Dom.XmlNode nodo : RespuestaTramiteMasivo.getChildren())
				{
					system.debug('nombre: '+nodo.getName());
					system.debug('nombre: '+nodo.getText());
					if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('NumeroPedido'))
						llave = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CodigoRespuesta'))
						wrpRes.CodigoRespuesta = nodo.getText();
					else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('DescripcionRespuesta'))
						wrpRes.DescripcionRespuesta = nodo.getText();
				}
				System.debug('\n@@@llaveReg===>'+llave);	
				mapRespuestas.put(llave, wrpRes);
			}
				
			
		}
		
		system.debug('\n@@@MapaRespuestasRegistro===> '+mapRespuestas);
		return mapRespuestas;
	}
	
	
	public class wrpRespuestaSuspenda{
		public String idServicio						{get; set;}
		public String numeroConexion 					{get; set;}
		public String tipoTramite		 				{get; set;}
		public String tipoDocumento						{get; set;}
		public String numeroDocumento					{get; set;}
		public String FechaActivacion 					{get; set;}
		public String CodigoRespuesta 					{get; set;}
		public String DescripcionRespuesta 				{get; set;}
		public String CodigoFlujo						{get; set;}
		public String DescripcionFlujo					{get; set;}
		public String DescripcionError					{get; set;}
		public list<wrpHistoriaTramite> lstTramites 	{get; set;}
		
		public wrpRespuestaSuspenda(){}
	}
	
	public class wrpHistoriaTramite{
		public String tramite			 	{get; set;}
		public String fecha				 	{get; set;}
		public String pedido			 	{get; set;}
		
		public wrpHistoriaTramite(){}
	}

}