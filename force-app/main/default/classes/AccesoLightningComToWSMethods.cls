/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           Migración Lightning
Descripción:        Clase que implementa métodos para acceder desde Lightning componentes de métodos 
					webservice llamados desde JavaScript.

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2020-01-17   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
public with sharing class AccesoLightningComToWSMethods {

    /*
	* @Método: 		ActualizarEstadosOC
	* @Descripción:	Método que implementa logica del método ActualizarEstadosOC de la clase ProcesosAPN_cls invocada por JavaScript.
	*/
    
    @AuraEnabled
    public static String ActualizarEstadosOC(String varId) {

        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        String sEstado = vGlobal.get('EstadoActualizaOC').valor__c;
        List<OperacionComercial__c> lstOc = new List<OperacionComercial__c>();
    
        if(String.isNotBlank(varId))
        	lstOc = [SELECT Id FROM OperacionComercial__c WHERE (caso__c = :varId OR Legalizacion__c = :varId) and Plan__r.NombredelProducto__r.Name = :productoLTE limit 100];
        
        for(OperacionComercial__c sglOC:lstOc){
            sglOC.Estado__c = sEstado;
        }
        
        if(!lstOC.isEmpty())
            update lstOC;
        
        system.debug('ActualizarEstadosOC, registros actualizados: ' + String.valueOf(lstOC.size()));
        return String.valueOf(lstOC.size()) + ' registros actualizados';

    }
    
    /*
	* @Método: 		DescargarArchivo
	* @Descripción:	Método que implementa logica para descargar archivos mediante accion rapida en el objeto URL_Archivo__c.
	*/
    
    @AuraEnabled
    public static map<String,String> DescargarArchivo(String varId) {

        Map<String,String> MapData = new Map<String,String>();
        List<URL_Archivo__c> lstURLArchivos = new List<URL_Archivo__c>();
        String accion = '';
        String idA = '';
        String idS = '';
        String tS = '';
        String t = '';
        String URL = ''; 
    
        if(String.isNotBlank(varId))
        	lstURLArchivos = [SELECT Id,URL__c, Nombre_completo__c, Migrado__c FROM URL_Archivo__c WHERE Id = :varId];
        URL = lstURLArchivos[0].URL__c;
        system.debug('DescargarArchivo.URL: ' + URL);
        MapData.put('URL',URL);
        MapData.put('accion', url.substringBefore('?'));
        If(URL != '' ){
        	String cadenaDatos = url.substringAfter('?');
        	List<String> campos = cadenaDatos.split('&');
            For(String campo : campos){
        	    MapData.put(campo.substringBefore('='), campo.substringAfter('='));  
        	}
        }
        System.debug('DescargarArchivo.MapData: '+ MapData);
        
        return MapData;

    }
    
}