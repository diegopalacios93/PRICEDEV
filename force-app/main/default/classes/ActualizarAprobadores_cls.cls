/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase encargada de poblar el campo manager del obj usuario según su cargo. 
						Invocada desde el trigger a objeto Opportunity

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     03-10-2013  Andrés Cubillos (AAC)       Creación de la clase..
*******************************************************************************/
public with sharing class ActualizarAprobadores_cls {
	
	public void Actualizar(list<Opportunity> lstInOpp){
		list<User> lstUser = new list<User>();
		set<string> stUser = new set<string>();
		map<string, User> mapUser = new map<string, User>();
		User usr;
		
		for(Opportunity o: lstInOpp){
			stUser.add(o.OwnerId);
		}		
		
		lstUser=[select id, ManagerId, Manager.ManagerId, EsGerente__c, EsDirector__c, 
				EsAsesor__c
				from User
				where id=:stUser];
		for(User u: lstUser){			
			mapUser.put(u.id, u);			
		}
		
		for(Opportunity o: lstInOpp){
			usr=mapUser.get(o.OwnerId);
			if(usr!=null && usr.EsAsesor__c){
				o.Director__c=usr.ManagerId;
				o.Gerente__c=usr.Manager.ManagerId;	
			}			
		}
		

	}	
}