/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan Gabriel Duarte Pacheco
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase para el envio del proceso de aprobacion de la oferta economica

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-08-06      Juan Gabriel Duarte P. (JGD)               Creación de la clase.
***********************************************************************************************************************/

public with sharing class LTE_Opportunity_cls {
	
	public void EnviarProcesosAprovacionOpp( map<id,Opportunity> mpNuevaOpp )
	{

		VariablesGlobales__c vgLob = VariablesGlobales__c.getValues('LTEPerfilAnaSopLTE');



		Id lteId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
		
		for(Opportunity nuevo : mpNuevaOpp.values())
		{
			try{
				if(!nuevo.LTE_OportunidadBloqueada__c && nuevo.LTE_OfertaCustomizada__c && nuevo.EstadodeAprobacionDescuentos__c == null && nuevo.recordTypeId==lteId && UserInfo.getProfileId()!=vgLob.valor__c)
				{				
					Approval.ProcessSubmitRequest solicitud = new Approval.ProcessSubmitRequest();
					solicitud.setObjectId(nuevo.Id);				
					Approval.ProcessResult resultado = Approval.Process(solicitud);			
				}
			}catch(exception e){
				system.debug(e.getMessage());
				nuevo.addError(Label.LTE_MensajeErrorAprobadorLTE);
			
			}
		}
	}
}