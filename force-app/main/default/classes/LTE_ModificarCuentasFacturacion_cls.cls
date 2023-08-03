/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE   
Description:            Clase encargada de recolectar y manejar la información necesaria para el consumo del servicio de edición de cuentas de facturación.
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     11/08/2015  Carlos A. Rodriguez B.          Class creation.
*******************************************************************************/
public class LTE_ModificarCuentasFacturacion_cls 
{
	public list<CuentaFacturacion__c> lstCuentaFact;
	public LogTransacciones__c objLog = new LogTransacciones__c();
	private map<string,string> valores = new map<string,string>();
	private String strRequest = '';
	private String strResponse = '';
	private String strNombreCtaTemp = '';
	private String strIdCtaTemp = '';

	//Clase que contiene todos los datos requeridos por el servicio web de actualización de cuentas.
	public class EdicionCuentas
	{
		public String strCorrelationId = '';
		public String strSubscriberId = '';
		public String strAddress = '';
		public String strCity = '';
		public String strCityCode = '';
		public String strCountryCode = '';
		public String strStateCode = '';
		public String strDeliveryType = '';
		public String strEmail = '';
		public String strMethodName = '';
	}

	public LTE_ModificarCuentasFacturacion_cls()
	{		
	}

	/**
    *   @Method: modificarCuentaRevchain
    *   @param objCtaFact: cuenta de facturación que se va a actualizar.
    *   @param objPoblacion: objeto población con la información de ciudad, estado y codigos dane de la cuenta de facturación   
    *   @return LogTransacciones__c: objeto con la información del resultado de la operación con el servicio web.
    *   @description: Se encarga de obtener la información requerida para el servicio web e invocar el servicio.. 
    */
    public LogTransacciones__c modificarCuentaRevchain(CuentaFacturacion__c objCtaFact, Poblacion__c objPoblacion)
    {
    	EdicionCuentas objEdicionCta 	= new EdicionCuentas();
    	Datetime datToday 				= system.now();
    	strNombreCtaTemp 				= objCtaFact.Name;
        strIdCtaTemp 					= objCtaFact.Id;

        // se concatena el id de la cta de facturación con el dia, el mes, el año, la hora, los minutos y los segundos para que sea un identificador unico.
    	objEdicionCta.strCorrelationId 	= objCtaFact.Id + String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) 
    									+ String.valueOf(datToday.hour()) + String.valueOf(datToday.minute()) + String.valueOf(datToday.second());
    	objEdicionCta.strSubscriberId 	= objCtaFact.Name;
    	objEdicionCta.strAddress 		= objCtaFact.LTE_DireccionFacturacion__c;
    	objEdicionCta.strCity 			= objPoblacion.Name;
    	objEdicionCta.strCityCode 		= objPoblacion.CodigoDane__c;
    	objEdicionCta.strCountryCode 	= '1';
    	objEdicionCta.strStateCode 		= recortarDane(objPoblacion.Padre__r.CodigoDane__c);

    	if(objCtaFact.LTE_MetodoEnvio__c == label.LTE_ServicioPostal)
			objEdicionCta.strDeliveryType = label.LTE_PostalService;
		if(objCtaFact.LTE_MetodoEnvio__c == label.LTE_Email)
			objEdicionCta.strDeliveryType = label.LTE_Email;
		if(objCtaFact.LTE_MetodoEnvio__c == label.LTE_Serviciopostal_Email)
			objEdicionCta.strDeliveryType = label.LTE_PostalService_Email;
		if(objCtaFact.LTE_MetodoEnvio__c == null)
			objEdicionCta.strDeliveryType = '';

		objEdicionCta.strEmail 			= objCtaFact.LTE_Email__c;
		objEdicionCta.strMethodName 	= label.LTE_CuentasResumidas;

		//Llamado de la clase para contruir el respectivo XML.
		strRequest = LTE_ConstruirXMLCtasFact_cls.XMLActualizarCuentaFact(objEdicionCta);
		//Invocación del servicio web.
        invocarServicioEditarCuentaFact(strRequest);

        return objLog;
    }

    /**
    *   @Method: recortarDane.
    *   @param strCod: Codigo dane a recortar.      
    *   @return String: codigo dane recortado.
    *   @description: Se encarga de recortar el codigo dane cuendo es necesario para el servicio web. 
    */
	public String recortarDane(String strCod)
	{
		String strCodigo='';
		if(strCod.length()==5)
		{
			strCodigo=strCod.substring(0,2);
		}
		else if(strCod.length()==4)
		{
			strCodigo=strCod.substring(0,1);
		}
		return strCodigo;
	}

	/**
    *   @Method: invocarServicioEditarCuentaFact.
    *   @param strRequest: XML request.
    *   @description: Se encarga de invocar el servicio web para la creación de cuentas de facturación. 
    */
	public void invocarServicioEditarCuentaFact(String strRequest)
	{
		//Obtiene la informacion del servicio web almacenado en la configuración personalizada ServiciosWeb__c.
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('EdicionCuentasFact');
		//Consume el servicio y almacena el response.	
		strResponse=LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);
		System.debug('Response----------->' + strResponse);
		getMapXMLResponseFact(strResponse);
	}

	/**
    *   @Method: getMapXMLResponseFact
    *   @param strResponse: XML respuesta del servicio web.
    *   @description: Se encarga de convertir la respuesta del servicio web en dom. 
    */
	public void getMapXMLResponseFact(String strResponse)
	{		
		Dom.Document doc = new Dom.Document();
		doc.load(strResponse);
		Dom.XMLNode WS = doc.getRootElement();				
		iterarXmlResponseFact(WS);
		crearLogtransaccion();
	}
	
	/**
    *   @Method: iterarXmlResponseFact
    *   @param dataXml: XML respuesta del servicio web convertido en dom.
    *   @description: Se encarga de iterar el XML encontrando etiquetas necesarias. 
    */
	public void iterarXmlResponseFact(dom.XMLNode dataXml)
	{			
		List<dom.XMLNode> lstXmlValues = dataXml.getChildElements();
		if(lstXmlValues.size()>0)
		{
			for( dom.XMLNode dxm : lstXmlValues)
			{
				if(dxm.getName()=='status')
				{
					system.debug('ENCONTRO STATUS-------->' + dxm.getText());
					valores.put(dxm.getName(),dxm.getText());					
				}
				if(dxm.getName()=='Code')
				{
					system.debug('ENCONTRO Code-------->' + dxm.getText());
					valores.put(dxm.getName(),dxm.getText());
				}
				if(dxm.getName()=='Description')
				{
					system.debug('ENCONTRO Description-------->' + dxm.getText());
					valores.put(dxm.getName(),dxm.getText());
				}
				iterarXmlResponseFact(dxm);
			}			
		}
	}

	/**
    *   @Method: crearLogtransaccion
    *   @description: Se encarga de crear el log de transacción del consumo del servisio web.
    */	
	public void crearLogtransaccion()
	{
		system.debug('STATUS Y CODE------->' + valores.get('status') + '   ' + valores.get('Code'));
		if(valores.get('status') == 'PASS' && valores.get('Code') == '0')
			objLog.Estado__c='Exitoso';
		else
			objLog.Estado__c='Fallido';

		system.debug('ID CTA FACT LOG-----' + strIdCtaTemp);
		objLog.Informacion_Enviada__c 		= strRequest;
		objLog.Informacion_Recibida__c 		= strResponse;
		objLog.LTE_CuentaFacturacionLTE__c	= strIdCtaTemp;
		objLog.Name 						= 'Actualización ' + label.LTE_CuentaFacturacion + ' ' + strNombreCtaTemp;
		objLog.CodigoRespuesta__c 			= valores.get('Description');

		system.debug('OBJETO LOG-----' + objLog);	
	}
}