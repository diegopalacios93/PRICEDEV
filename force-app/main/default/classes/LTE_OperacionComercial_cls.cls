/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan Gabriel Duarte Pacheco
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase para actualizar la OC y el detalle de oferta para que descuente de la disponibilidad de equipos

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-08-14      Juan Gabriel Duarte P. (JGD)               Creación de la clase.
***********************************************************************************************************************/

public with sharing class LTE_OperacionComercial_cls {

		
	public void actualizaDetalleOferta(map<id,OperacionComercial__c> ocNew,map<id,OperacionComercial__c> ocOld) {
		
		list<Id> idsOcdecl=new list<Id>();
		
		for(Id ocId : ocNew.keySet())
		{
			if(ocNew.get(ocId).Estado__c=='Declinada' && ocOld.get(ocId).Estado__c!=ocNew.get(ocId).Estado__c)
			{
				ocNew.get(ocId).LTE_FechaDeclinada__c = System.today();
				idsOcdecl.add(ocId);
			}
		}

		List<LTE_DetalleOferta__c> lstDetalleOferta = [SELECT Id,LTE_Estado_Detalle_Oferta__c 
														FROM LTE_DetalleOferta__c 
														WHERE LTE_OperacionComercial__c IN:idsOcdecl];

		for(LTE_DetalleOferta__c objDO: lstDetalleOferta)
		{
			objDO.LTE_Estado_Detalle_Oferta__c = 'Declinado';
		}

		database.update(lstDetalleOferta);
	}
}