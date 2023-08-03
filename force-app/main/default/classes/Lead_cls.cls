/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Clase base para los desarrollos de Leads

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-03-18		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/
public with sharing class Lead_cls {

	static public void TrgCrearLupaPoblacion(list<Lead> lstNew) {
		if (lstNew != null && !lstNew.isEmpty()) {
			System.debug('lstNew:' + lstNew);
			for (Lead l : lstNew) {
				if (String.isNotEmpty(l.Poblacion_Texto__c)) {
					l.Poblacion__c = (Id)l.Poblacion_Texto__c;
				}
			}
		}
	}
    
    @Future
    public static void LeadAssign(List<Id> LeadIds)
    {   
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;        
        //dmo.AssignmentRuleHeader.assignmentRuleId = '01Q3300000034Wp';
        Lead Leads=[select id from lead where lead.id in :LeadIds];
        Leads.setOptions(dmo);
        update Leads;
    }
}