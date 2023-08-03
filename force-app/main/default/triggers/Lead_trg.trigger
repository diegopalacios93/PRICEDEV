/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripción:		Trigger para el objeto Lead

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripción
----	----------		--------------------		---------------
1.0		2014-03-18		Jorge Grimaldos (JG)		Creación de la clase.
***********************************************************************************************************************/
trigger Lead_trg on Lead (before insert, before update, before delete, after insert, after update, after delete, 
	after undelete) {
	if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        	Lead_cls.TrgCrearLupaPoblacion(trigger.new);
            Map<String,Account> mapAccount = new Map<String,Account>();
            Map<Id,Account> mapAccountTemp = new Map<Id,Account>();
            set<String> lstAccountNit = new set<String>();            
            for (Lead sglLead : trigger.new) {                
				if (String.isNotEmpty(sglLead.Nit_de_la_Empresa__c) && (sglLead.LeadSource=='Negocios Formulario Web–Contactenos' || sglLead.LeadSource=='Negocios Formulario Web - Contactenos' || sglLead.LeadSource=='Empresas Formulario Web–Contactenos' || sglLead.LeadSource=='Web – Contáctenos')) {
					lstAccountNit.add(sglLead.Nit_de_la_Empresa__c);
				}
			}
            
            mapAccountTemp = new Map<Id,Account>([select id,Name,OwnerId,Segmento__c,AccountNumber from Account WHERE RecordType.Name = 'Cliente Principal' AND (AccountNumber IN :lstAccountNit)]);
            for(Account sglAccountTemp:mapAccountTemp.values()){
                mapAccount.put(sglAccountTemp.AccountNumber,sglAccountTemp);
            }
            
            for (Lead sglLead : trigger.new) {
                if (String.isNotEmpty(sglLead.Nit_de_la_Empresa__c)){
                    if(mapAccount.containskey(sglLead.Nit_de_la_Empresa__c)){
                        sglLead.OwnerId = mapAccount.get(sglLead.Nit_de_la_Empresa__c).OwnerId;
                    }
                }
            }
        }
        if (Trigger.isUpdate) {
        }
        if (Trigger.isDelete) {
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {            
            List<Id> lstAssignationRule = new List<Id>();
            for (Lead sglLead : trigger.new) {                
                if(sglLead.OwnerId == sglLead.CreatedById /* && (sglLead.LeadSource=='Negocios Formulario Web–Contactenos' || sglLead.LeadSource=='Negocios Formulario Montesquieu' || sglLead.LeadSource=='Negocios Formulario Web - Contactenos')*/){
                    lstAssignationRule.add(sglLead.Id);
                }
            }
            if(!lstAssignationRule.isEmpty())
                Lead_cls.LeadAssign(lstAssignationRule);
        }
        if (Trigger.isUpdate) {
        }
        if (Trigger.isDelete) {
        }
        if (Trigger.isUnDelete) {
        }
    }
}