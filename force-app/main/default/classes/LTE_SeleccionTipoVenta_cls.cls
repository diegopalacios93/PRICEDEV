/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Ventana de selecction de Venta LTE

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-02-08      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_SeleccionTipoVenta_cls {
	
	private Apexpages.Standardcontroller stdController;
	public Opportunity objOportunidad                               {get; set;}
	public List<SelectOption> items			                    	{get; set;}
	public String tipoVenta		                                 	{get; set;}
	public Boolean blnBotonContinuar								{get; set;}
	
	private Map<string, LTE_Tipo_Venta__c> mapTipoVenta;
	
	/**
	* Controlador de la clase.
	*/
	public LTE_SeleccionTipoVenta_cls(ApexPages.StandardController stdController){
		
		this.stdController = stdController;
        this.objOportunidad = (Opportunity)stdController.getRecord();
		this.mapTipoVenta = LTE_Tipo_Venta__c.getAll();
		this.items = new List<SelectOption>(); 
		this.blnBotonContinuar = true; 
		
		//Consulta informacion de la oportunidad
        this.objOportunidad = getOportunidad();
		
		if(mapTipoVenta != null){
			for(LTE_Tipo_Venta__c tipoVenta : mapTipoVenta.values()){
				items.add(new SelectOption(tipoVenta.Name, tipoVenta.Name));
			}
		}
		
		if(!items.isEmpty()){
			items.sort();
		}
		
		if(objOportunidad.isClosed)
        {
            this.blnBotonContinuar = false; 
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.fatal,Label.LTE_OportunidadCerrada));
        }
        
        if(!objOportunidad.Operaciones_Comerciales__r.isEmpty())
        {
            this.blnBotonContinuar = false; 
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.fatal,Label.LTE_OportunidadOC));
        }
	}
	
	public Opportunity getOportunidad(){
    
    	return [SELECT Id,AccountId,LTE_CodigoAprobacionInicial__c,LTE_CodigoAprobacion__c,EstadodeAprobacionDescuentos__c,LTE_ValorOferta__c,isClosed, 
                    LTE_OfertaConProductoEspecial__c,LTE_OfertaCustomizada__c,LTE_NumeroLinea__c,LTE_OportunidadBloqueada__c,
                    LTE_PagoAnticipado__c,LTE_RequiereBolsas__c,LTE_RequiereDescuentos__c,LTE_RequiereSVAS__c,LTE_ScoringMensual__c, 
                    (Select Id From Operaciones_Comerciales__r) 
                    FROM Opportunity 
                    WHERE Id =: objOportunidad.Id];
    
    }
	
	/**
	* Metodo encargado de redireccionar hacia la pagina seleccionada.
	*/
	public PageReference continuar(){
		String url = Site.getBaseUrl() + this.mapTipoVenta.get(this.tipoVenta).URL__c;
		url = url.replace('<<id>>', this.objOportunidad.Id);
		PageReference prVenta = new PageReference(url);
		return prVenta;
	}
    
}