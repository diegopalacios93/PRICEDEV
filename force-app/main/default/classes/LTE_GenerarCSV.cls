/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan Gabriel Duarte Pacheco
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase controladora para la generacion del detalle de Oferta en formato CSV

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-08-09      Juan Gabriel Duarte P. (JGD)               Creación de la clase.
***********************************************************************************************************************/

public with sharing class LTE_GenerarCSV {
	
	public String oppId {get; set;}
    /**
     * Metodo constructor de la clase, recibe como parametro el identificador de la oportunidad
     */
	public LTE_GenerarCSV() {
		oppId = ApexPages.currentPage().getParameters().get('Id');
		system.debug(oppId);
	} 
	/**
     * Obtiene los detalles de la oferta
     * @return Una coleccion de tipo lista con los detalles de la oferta
     */
    public List<LTE_DetalleOferta__c> getDetalleOferta()
    {
        return [SELECT Id,LTE_IMEI__c,LTE_NumeroLinea__c,Plan__r.Name,LTE_MinutoVoz__r.Name, LTE_DatosNavegacion__r.Name,
                	LTE_Oferta_Economica__c,LTE_ReferenciaEquipo__r.Name,LTE_RequierePortacion__c,
                	LTE_Sucursal__c,LTE_Donante__c,  LTE_Tipo_de_Servicio__c, LTE_SolicitadoPorTercero__c
                FROM LTE_DetalleOferta__c 
                WHERE LTE_Oferta_Economica__r.Oportunidad__c=:oppId ORDER BY Plan__c];
    }
    /**
     * Metodo para generar el archivo csv
     * @return una cadena de tipo string con la informacion del los detalles de oferta
     */
    public string getCSV(){
    	
    	String csv='IdSalesforce,Referencia,Plan,Voz,Datos,IMEI,RequierePortacion,NumeroLinea,Sucursal,Donante, TipoServicio,SolicitadoTercero';
    	
    	for(LTE_DetalleOferta__c con:getDetalleOferta()){
    		csv+='\n"'+con.Id+'","'+con.LTE_ReferenciaEquipo__r.Name+'","'+con.Plan__r.Name+'","'+con.LTE_MinutoVoz__r.Name+'","'+con.LTE_DatosNavegacion__r.Name+'","'+con.LTE_IMEI__c+'",'+con.LTE_RequierePortacion__c+',"'+con.LTE_NumeroLinea__c+'","'+con.LTE_Sucursal__c+'","'+con.LTE_Donante__c+'","'+con.LTE_Tipo_de_Servicio__c+'",'+con.LTE_SolicitadoPorTercero__c+'';
    	}
    	
    	csv=csv.replace('"null"','""');
    
    	
    	return csv;
    }
}