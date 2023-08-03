/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase llamada por el trigger sobre el obj Operación Comercial, encargada de 
						llenar algunos campos sobre operación comercial.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     18-10-2013  Andrés Cubillos (AAC)       Creación de la clase.
1.1 	18-02-2014	Jorge Grimaldos (JG)		Garantía: Bug de Sucursales
1.2		30-10-2015	Carlos Rodriguez [CR]		Condiciones para evitar null pointers
*******************************************************************************/ 
public class LlenarCamposOC_cls {
	
	public void LlenarCuenta(list<OperacionComercial__c> inLstOC){

		set<string> stActivo = new set<string>();
		set<string> stOpp = new set<string>();

		list<ActivoETB__c> lstAc = new list<ActivoETB__c>();
		list<Opportunity> lstOp = new list<Opportunity>();
		
		map<string,ActivoETB__c> mapActivo = new map<string,ActivoETB__c>();
		map<string,Opportunity> mapOpp = new map<string,Opportunity>();
		
		ActivoETB__c ac;
		Opportunity opp;
		
		for(OperacionComercial__c o: inLstOC){
			
			system.debug('==>o:'+o);
			stActivo.add(o.Activo__c);
			stOpp.add(o.Oportunidad__c);	
		}		
				
	/**
	*	1.1
	*	Adición del campo NombredelaCuenta__c al query
	**/
						
		lstAc= [select id, Oportunidad__r.AccountId
			, NombredelaCuenta__c
			from ActivoETB__c
			where id in:stActivo
			];
			
		system.debug('==>lstAc:'+lstAc);
		//[CR If para validar que la lista no esta vacia]
		if(!lstAc.isEmpty())
		{
			for(ActivoETB__c a:lstAc){
				mapActivo.put(a.id,a);
			}
		}
		
		
		lstOp=[select id, AccountId
			from Opportunity
			where id in:stOpp 
			];
			
		system.debug('==>lstOp:'+lstOp);
		//[CR If para validar que la lista no esta vacia]
		if(!lstOp.isEmpty())
		{
			for(Opportunity o:lstOp){
				mapOpp.put(o.id,o);
			}
		}
					
						
		for(OperacionComercial__c oc :inLstOC){
			//[CR Condición de que el tamaño del mapa mapOpp sea mayor a cero]
			if(oc.Oportunidad__c!=null && mapOpp.size()>0){
				opp=mapOpp.get(oc.Oportunidad__c);				
				if(opp.AccountId!=null){
					oc.CuentaCliente__c=opp.AccountId;
				}
			}
			//[CR Condición de que el tamaño del mapa mapActivo sea mayor a cero]
			else if(oc.Activo__c!=null && mapActivo.size()>0){				
				 ac=mapActivo.get(oc.Activo__c);				 
				 if(ac.Oportunidad__c!=null && ac.Oportunidad__r.AccountId!=null){
					oc.CuentaCliente__c=ac.Oportunidad__r.AccountId;
				 } 
	 /**
	 *	1.1
	 *	Asignación de la cuenta para los servicios sin Opp
	 **/
				 else if (ac.NombredelaCuenta__c != null) {
				 	oc.CuentaCliente__c = ac.NombredelaCuenta__c;
				 }
			}			
			
		}			
		
	}
}