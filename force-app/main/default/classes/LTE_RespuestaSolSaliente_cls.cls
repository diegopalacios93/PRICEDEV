/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que consulta la informacion necesaria para construir el request para consumir el servicio 
					donde se envian las lineas que no fueron aprobadas, en el caso no existan lineas rechazadas se 
					envia confirmacion de proceder con el proceso.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-03      Raul Mora (RM)		        Creación de la clase.
2.0		2015-09-08		Walter Rodríguez M. (WRM)	Ajustes.
3.0		2015-09-18		Carlos Rodriguez [CR]		Adición de la logica para log de transacción.
***********************************************************************************************************************/
public class LTE_RespuestaSolSaliente_cls 
{
	//WRM
	private final Apexpages.Standardcontroller ctr;
	public static LTE_Lote__c lote {get; set;}
	public String strRespuesta {get; set;}
	
	public LTE_RespuestaSolSaliente_cls(Apexpages.Standardcontroller controller) // WRM
	{
		lote = new LTE_Lote__c();
		lote = (LTE_Lote__c)controller.getRecord(); 
		//strRespuesta = enviarPortabilidadSaliente(lote.Id);
	}
	/*
	* @Metodo: 		enviarPortabilidadSaliente
	* @Parametros:	String
	* @Descripcion:	Metodo que se encarga de consultar el lote y detalle del lote con el Id de lote
	*				especificado, con los datos obtenidos se construye el XML del cuerpo del servicio web,
	*				con el XML se consulta el servicio y se muestra el resultado.
	*/
	//public static String enviarPortabilidadSaliente( String strLoteId )
	public PageReference enviarPortabilidadSaliente()
	{
		//Lista para obtener el registro a consultar
		List<LTE_Lote__c> lstLote = new List<LTE_Lote__c>();
		//Mapa para almacenar y enviar la informacion para la construccion del XML
		map<String,String> mpValoresXML = new map<String,String>();
		//Cadena para almacenar XML
		String strCuerpoRequest = '';
		//Cadena a retornar por el metodo
		String strReturn;
		//Cadena para almacenar la respuesta del servicio
		String strResponse = '';
		//Se verifica que el id del lote no este vacio
		if( String.isNotEmpty( lote.Id ) )
		{
			lstLote = [ Select Id,Name, 
						LTE_Identificador__c, 
						LTE_Observaciones__c,
						( Select Id,Name, 
						  LTE_NumeroLinea__c, 
						  LTE_AdjuntoRechazo1__c, 
						  LTE_AdjuntoRechazo2__c,
						  LTE_AdjuntoRechazo3__c,
						  LTE_AdjuntoRechazo4__c,
						  LTE_CodigosRechazo__c
						  From Detalle_de_Lote__r 
						  Where LTE_Rechazado__c = true ) 
						From LTE_Lote__c 
						Where Id =: lote.Id ];
			if( !lstLote.isEmpty() )
			{
				//Se diligencian los tags del XML con los valores obtenidos del Lote y Detalle de Lote
				mpValoresXML.put( 'correlationID', lstLote.get(0).Id );
				mpValoresXML.put( 'Identificador', lstLote.get(0).LTE_Identificador__c != null ? lstLote.get(0).LTE_Identificador__c : '' );
				mpValoresXML.put( 'Observaciones', lstLote.get(0).LTE_Observaciones__c != null ? lstLote.get(0).LTE_Observaciones__c : '' );
				//Se consulta si no existe numero rechazado del lote para especificar la respuesta
				String strRespuestaABD = lstLote.get(0).Detalle_de_Lote__r.isEmpty() ? '1' : '0';
				mpValoresXML.put( 'RespuestaABD', strRespuestaABD );
				
				strCuerpoRequest = LTE_GenXmlPortabilidadSaliente_cls.generarXmlSolicitudPortabilidadSaliente( mpValoresXML, lstLote.get(0).Detalle_de_Lote__r );
				system.debug('\n\n .-.-.-. Cuerpo XML request \n'+strCuerpoRequest);
				if( !Test.isRunningTest() )
				{					
					ServiciosWeb__c sw = ServiciosWeb__c.getValues('Portabilidad');
					//strReturn = LibreriaUtilitaria_cls.consultarServicio( strCuerpoRequest, '/Service/intfPortabilidadImp-service.serviceagent/intfwsPortabilidadImpEndpoint1/PortabilidadCorp','http://201.245.171.239:7050/Service/Portabilidad-service.serviceagent/PortabilidadEndpoint' );
					strResponse = LibreriaUtilitaria_cls.consultarServicio(strCuerpoRequest, sw.Action__c, sw.EndPoint__c);
					tibcoXml_cls.xmlMapConsulta objReq = new tibcoXml_cls.xmlMapConsulta();
					set<String> datac = objReq.getMap( strResponse );
					strReturn = objReq.valores.get( 'Respuesta' );
					system.debug('RESPONSE SERVICIOWEB-----' + strResponse);
					system.debug('RETORNO-----' + strReturn);
				}
				else
				{
					strReturn = System.Label.LTE_Ack;
				}
				
			}
		} else
		{
			strReturn = System.Label.LTE_EnviarIdLote;
		}
		
		if( strReturn == System.Label.LTE_Ack )
		{
			strReturn = System.Label.LTE_RespuestaExito;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Se envío la respuesta de forma exitosa.'));//WRM
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Se presento el siguiente mensaje de error para el envío de la respuesta de la solicitud de portación: ' + ' ' + strReturn));//WRM
		}

		// [CR] Llamado al metodo para la creación del log de transacción.
		crearLogTransaccion(strCuerpoRequest, strResponse, strReturn, lstLote.get(0).Name);

		return null;
		//return strReturn;
	}

	/**
    *   @Method: crearLogTransaccion.
    *   @param strRequest: XML request.
    *   @param strResponse: XML response.
    *   @description: Se encarga crear el log de transacción del consumo del servicio web.
    *	@autor: Carlos Rodriguez. 
    */
	public static void crearLogTransaccion(String strRequest, String strResponse, String strReturn, String strLoteName)
	{
		LogTransacciones__c objLog = new LogTransacciones__c();
		objLog.Estado__c = strReturn;
		objLog.Informacion_Enviada__c = strRequest;
        objLog.Informacion_Recibida__c = strResponse;
        objLog.LTE_Lote__c = lote.Id;
        objLog.Name = strLoteName != null ? 'Portabilidad Saliente ' + strLoteName : 'Portabilidad Saliente';
        
        insert objLog;        
	}
}