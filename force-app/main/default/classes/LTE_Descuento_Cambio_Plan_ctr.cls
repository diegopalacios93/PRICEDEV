/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David Uribe Ruiz
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase controladora para la creación de niveles de descuento desde la VF de cambio de plan

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-12-01      Juan David Uribe Ruiz (JDUR)               Creación de la clase a partir de la creada por JGD
***********************************************************************************************************************/
public with sharing class LTE_Descuento_Cambio_Plan_ctr {
	
	public LTE_NivelesDescuento__c objNivelDescuento 	{get; set;}
	public String strName 								{get;set;}
	public String strType 								{get;set;}
	public Integer intIndex								{get;set;}
 	
 	//Metodo constructor de la clase
	public LTE_Descuento_Cambio_Plan_ctr(ApexPages.Standardcontroller incontroller) {
		
		objNivelDescuento = (LTE_NivelesDescuento__c) incontroller.getRecord();
		strType	= ApexPages.currentPage().getParameters().get('type');
        strName = '';
        intIndex = 0;
	}

	//Metodo para persistir los niveles de descuento
	public PageReference guardar()
	{
		System.debug('objNivelDescuento-> '+objNivelDescuento);
		objNivelDescuento.LTE_Indice__c = intIndex;

		system.debug(objNivelDescuento.LTE_DescuentoNivel2__c+' '+objNivelDescuento.LTE_NoCuotasNivel2__c+' '+ objNivelDescuento.LTE_DescuentoNivel3__c);

		if((objNivelDescuento.LTE_DescuentoNivel2__c ==null || objNivelDescuento.LTE_NoCuotasNivel2__c ==null) && objNivelDescuento.LTE_DescuentoNivel3__c !=null)
		{
			Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Por favor diligencie completo el nivel 2 de descuentos si desea asignar un nivel 3'));
			return null;
		}


		if(objNivelDescuento.LTE_DescuentoNivel1__c > 100 || objNivelDescuento.LTE_DescuentoNivel2__c > 100 || objNivelDescuento.LTE_DescuentoNivel3__c > 100)
		{
			Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'El valor del descuento no puede superar el 100%'));
			return null;
		}
		
		try{
			upsert objNivelDescuento;
			strName = [SELECT Name FROM LTE_NivelesDescuento__c WHERE Id =:objNivelDescuento.Id].Name;
			Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,'El nivel de detalle se ha creado!'));
		}catch(Exception e){
			Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,e.getMessage()));
		}

		return null;
	}
	
	//Metodo para consultar la informacion de los niveles de descuento
	public PageReference poblarCampos()
	{
		if(!strName.equals(''))
		{
			List<LTE_NivelesDescuento__c> lstNivelDescuento = [SELECT Id,LTE_DescuentoNivel1__c,LTE_DescuentoNivel2__c,LTE_DescuentoNivel3__c,
									LTE_NoCuotasNivel1__c,LTE_NoCuotasNivel2__c,LTE_NoCuotasNivel3__c 
									FROM LTE_NivelesDescuento__c WHERE Name =:strName
									AND LTE_Indice__c =: intIndex];

			if(!lstNivelDescuento.isEmpty())
			{
				objNivelDescuento = lstNivelDescuento.get(0);
			}
		}
		return null;
	} 
	
}