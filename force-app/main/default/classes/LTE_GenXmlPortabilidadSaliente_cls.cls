/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que contiene la logica para generar el cuerpo del request en formato valido XML para consumir
					el servicio portabilidad saliente.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-04      Raul Mora (RM)		        Creación de la clase.
***********************************************************************************************************************/
public class LTE_GenXmlPortabilidadSaliente_cls 
{
	/*
	* @Metodo: 		generarXmlSolicitudPortabilidadSaliente
	* @Parametros:	map<String,String>, List<String>
	* @Descripcion:	Metodo que se encarga de obtener un mapa con los valores requeridos para cada tag del cuerpo del request
	*				del servicio, los organizar en formato XML y almacena en cadena.
	*/
	public static String generarXmlSolicitudPortabilidadSaliente( map<String,String> mpCampos, List<LTE_DetalleLote__c> lstDetaLote )
	{
		String strXml = '';
		strXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/lte/ws/webserviceportability/corp/in/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/lte/portability/corp/v1.0">'
				+'<soapenv:Header/>'
				+'<soapenv:Body>'
					+'<ns:WSRequestPortabilidad>'
						+' <v1:WSRequestHeader>'
							+'<v1:System correlationID="' + mpCampos.get('Identificador') + '" processingServer="Salesforce">Salesforce</v1:System>'
							+'<v1:Property name="" value=""></v1:Property>'
						+'</v1:WSRequestHeader>'
						+'<v11:PortabilidadMsg>'
							+'<CabeceraMensaje>'
								+'<Identificador>' + mpCampos.get('Identificador') + '</Identificador>'
								+'<Observaciones>' + mpCampos.get('Observaciones') + '</Observaciones>'
							+'</CabeceraMensaje>'
							+'<CuerpoMensaje>'
								+'<RespuestaSolicitudPortacionDonante>'
									+'<RespuestaABD>' + mpCampos.get('RespuestaABD') + '</RespuestaABD>'
									+generaXmlListaNumeracion( lstDetaLote )
								+'</RespuestaSolicitudPortacionDonante>'
							+'</CuerpoMensaje>'
						+'</v11:PortabilidadMsg>'
					+'</ns:WSRequestPortabilidad>'
				+'</soapenv:Body>'
			+'</soapenv:Envelope>';
		return strXml;	
	}
	
	/*
	* @Metodo: 		generaXmlListaNumeracion
	* @Parametros:	List<LTE_DetalleLote__c>
	* @Descripcion:	Metodo encargado de generar la lista de los numeros que presentaron rechazo de portabilidad.
	*/
	public static String generaXmlListaNumeracion( List<LTE_DetalleLote__c> lstDetLot )
	{
		
		String strXmlNumeracion = '';
		if( !lstDetLot.isEmpty() )
		{
			strXmlNumeracion += '<ListaNumeracionRechazada>';
			for( LTE_DetalleLote__c objDetLot : lstDetLot )
			{
				//Se verifican si las variables tienen valor para evitar pasar el valor null
				String strDocFC = String.isNotEmpty( objDetLot.LTE_AdjuntoRechazo1__c ) ? objDetLot.LTE_AdjuntoRechazo1__c : '';
				String strDocDC = String.isNotEmpty( objDetLot.LTE_AdjuntoRechazo2__c ) ? objDetLot.LTE_AdjuntoRechazo2__c : '';
				String strDocFR = String.isNotEmpty( objDetLot.LTE_AdjuntoRechazo3__c ) ? objDetLot.LTE_AdjuntoRechazo3__c : '';
				String strDocUO = String.isNotEmpty( objDetLot.LTE_AdjuntoRechazo4__c ) ? objDetLot.LTE_AdjuntoRechazo4__c : '';
				strXmlNumeracion += 	'<NumeracionRechazada>'
											+'<Numero>' + objDetLot.LTE_NumeroLinea__c + '</Numero>'
											+generarXmlCodigosRechazo( objDetLot.LTE_CodigosRechazo__c == null ? '' : objDetLot.LTE_CodigosRechazo__c )
											+'<DocumentoFC>'+ strDocFC +'</DocumentoFC>'
											+'<DocumentoDC>'+ strDocDC +'</DocumentoDC>'
											+'<DocumentoFR>'+ strDocFR +'</DocumentoFR>'
											+'<DocumentoUO>'+ strDocUO +'</DocumentoUO>'
										+'</NumeracionRechazada>';
			}
			strXmlNumeracion += '</ListaNumeracionRechazada>';
		}
		return strXmlNumeracion;
	}
	
	/*
	* @Metodo: 		generarXmlCodigosRechazo
	* @Parametros:	String
	* @Descripcion:	Metodo encargado de estructurar la lista de codigos de rechazo.
	*/
	public static String generarXmlCodigosRechazo( String strCodRec )
	{
		String strXmlCodRec = '';
		if( String.isNotEmpty( strCodRec ) )
		{
			List<String> lstCodRec = strCodRec.split( ';' );
			strXmlCodRec += '<CodigosRechazo>'; 
			for(String strCR : lstCodRec)
			{
				strXmlCodRec += '<CodigoRechazo>' + strCR + '</CodigoRechazo>';
			}
			strXmlCodRec += '</CodigosRechazo>';
		}
		
		return strXmlCodRec;
	}
}