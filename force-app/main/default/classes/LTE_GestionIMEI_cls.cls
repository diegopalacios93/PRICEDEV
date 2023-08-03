/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Manuel Cortes
Proyecto:           LTE Evolutivos
Descripción:        Clase que contiene la lógica para la gestión de IMEI

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     19-07-2016  Manuel Cortes (MC)        Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_GestionIMEI_cls {
	
	
	/**************************************
	* Este Map debe tener los atributos:
	* userName
	* strIMEI
	* strTipoDoc
	* strDoc 
	**************************************/
	
	public static Map<String, String> consultarIMEI(Map<String, String> datos){
    	String request = null;
    	String response = null;
    	Map<String, String> valuesResponse = null;
    	ServiciosWeb__c sw = ServiciosWeb__c.getValues('ConsultaIMEI');
    	
    	tibcoXml_cls.xmlMap mapperXml = new tibcoXml_cls.xmlMap();
    	request = tibcoXml_cls.reqConsultaBDO_XML(datos);
    	
    	try{
    		System.debug('Request----> '+request);
    		response = LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
    		System.debug('Response----> ' + response);
    		valuesResponse = mapperXml.getMap(response);
    		valuesResponse.put('XML_REQUEST' ,request);
    		valuesResponse.put('ERROR' ,'false');
    		valuesResponse.put('XML_RESPONSE' , response);
    		
    		if(valuesResponse.containsKey('CodigoRespuestaListas') &&  (valuesResponse.get('CodigoRespuestaListas') == '3' )){
    			valuesResponse.put('ERROR' ,'true');
    			valuesResponse.put('CODIGO_RESPUESTA' ,valuesResponse.get('CodigoRespuestaListas'));
    			
    		}
    		if(valuesResponse.containsKey('NomError')){
    			valuesResponse.put('ERROR' ,'true');
    			valuesResponse.put('ERROR_MSG' ,valuesResponse.get('NomError'));
    		}
    	}catch(Exception e){
    		valuesResponse = new Map<string,string>();
    		valuesResponse.put('ERROR' ,'true');
    		valuesResponse.put('XML_RESPONSE' , null);
    		valuesResponse.put('ERROR_MSG' , e.getMessage());
    		valuesResponse.put('ERROR_STACK_TRACE' , e.getMessage());
    	}
    	
        return valuesResponse;
    	
    }
    
    
	/*********************************************************
	* Metodo encargado de retornar la configuracion de los mensajes
	* de respuesta del desbloqueo de IMEI LTE_Respuesta_Desbloqueo_IMEI__c
	*********************************************************/
	public static LTE_Respuesta_Desbloqueo_IMEI__c getRespuestaDesbloqueo(String strCodigo){
		return LTE_Respuesta_Desbloqueo_IMEI__c.getAll().get(strCodigo);
	}
}