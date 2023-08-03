/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Clase que maneja el cálculo de las cantidades de dinero
						en las oportundiades a partir de las OC
						
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		03-02-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/
public with sharing class CalculoValoresMonetarios_cls {
	
	private map<Id, OperacionComercial__c> mapOCCambioTopp = new map<Id, OperacionComercial__c>(); 

	public void CalcularValoresMonetarios(map<Id, OperacionComercial__c> mapNew, map<Id, OperacionComercial__c> mapOld, boolean blnTrgUpdate) {
		System.debug('Tipos_No_Agregables_OC__c:' + Tipos_No_Agregables_OC__c.getAll());
		//	Condición de entrada
		if (mapNew != null && !mapNew.isEmpty()) {
			//	Análisis para determinar los registros de interés
			map<Id, OperacionComercial__c> mapOCCambio = new map<Id, OperacionComercial__c>();
			set<Id> setIdOpp = new set<Id>();
			for (OperacionComercial__c oc : mapNew.values()) {
				if ( (blnTrgUpdate? EvaluarCambioDinero(oc, mapOld) : true) ) {
					setIdOpp.add(oc.Oportunidad__c);
					mapOCCambio.put(oc.id, oc);
				}
			}
			//	Obtener las Oportunidades de interés y sus hijos
			list<Opportunity> lstOportunidades = new list<Opportunity>();
			if (!setIdOpp.isEmpty()) {
				lstOportunidades = ObtenerOportunidades(setIdOpp);
			}
			//	Evaluar las Oportunidades de interés y agregar los hijos
			if (!lstOportunidades.isEmpty()) {
                mapOCCambioTopp = new map<Id, OperacionComercial__c>([Select Id, TOPP__r.TipodeOperacionporplan__c from OperacionComercial__c where id in : mapOCCambio.keyset()]);
                System.debug('mapOCCambioTopp:' + mapOCCambioTopp);
                for (Opportunity o : lstOportunidades) {
                    AgregarHijos(o, mapOCCambio, mapOld);
                }
                //	Actualizar las oportunidades
                try {
                    update lstOportunidades;
                } catch (Dmlexception e) {
                    mapNew.values()[0].addError(e.getDmlMessage(0));
                }catch (Exception e) {
                    mapNew.values()[0].addError(e.getMessage());
                }
			}
		}		
	}
	
	private boolean EvaluarCambioDinero(OperacionComercial__c oc, map<Id, OperacionComercial__c> mapOld) {
		boolean blnRetorno = 
			(oc.Valor_Recurrente_Aliado__c != mapOld.get(oc.Id).Valor_Recurrente_Aliado__c) || 
			(oc.Valor_unica_Vez_Aliado__c != mapOld.get(oc.Id).Valor_unica_Vez_Aliado__c) ||
            (oc.Valor_Recurrente_ETB_Anterior__c != mapOld.get(oc.Id).Valor_Recurrente_ETB_Anterior__c) ||
			(oc.ValorTarifaPlan__c != mapOld.get(oc.Id).ValorTarifaPlan__c) ||
			(oc.Valorunicavez__c != mapOld.get(oc.Id).Valorunicavez__c);/* || 
			* Se comentarea porque ocasiona problemas en el complete de apv y facturacion porque se evalua nuevamente la regla
			(oc.Estado__c != mapOld.get(oc.Id).Estado__c);*/
		return (blnRetorno);
	}
	
	private list<Opportunity> ObtenerOportunidades(set<Id> setIdOpp) {
		return [
			select id, (
				select id, Valor_Recurrente_Aliado__c, 
					Valor_unica_Vez_Aliado__c, ValorTarifaPlan__c,
					Valorunicavez__c, Valor_Recurrente_ETB_Anterior__c,
                	TOPP__r.TipodeOperacionporplan__c, Estado__c
				from Operaciones_Comerciales__r
				)
			from Opportunity
			where id in :setIdOpp
		];
	}
	
	private void LimpiarValores( Opportunity o) {
		o.Valor_Recurrente_Aliado__c = 0;
		o.Valor_unica_vez_Aliado__c = 0;
		o.Valor_unica_vez_ETB__c = 0;
        o.Valor_Recurrente_Anterior_ETB__c = 0;
        o.Cantidad_OC__c = 0;
		o.Amount = 0;
	}

	private void SumarCantidades( Opportunity o , OperacionComercial__c oc) {
		System.debug('o:' + o);
		System.debug('oc:' + oc);
		o.Valor_Recurrente_Aliado__c += (oc.Valor_Recurrente_Aliado__c != null ? oc.Valor_Recurrente_Aliado__c : 0);
		o.Valor_unica_vez_Aliado__c += (oc.Valor_unica_Vez_Aliado__c != null ? oc.Valor_unica_Vez_Aliado__c : 0);
		o.Valor_unica_vez_ETB__c += (oc.Valorunicavez__c != null ? oc.Valorunicavez__c : 0);
		o.Valor_Recurrente_Anterior_ETB__c += (oc.Valor_Recurrente_ETB_Anterior__c != null ? oc.Valor_Recurrente_ETB_Anterior__c : 0);
		o.Amount += (oc.ValorTarifaPlan__c != null ? oc.ValorTarifaPlan__c : 0);
        o.Cantidad_OC__c += 1;
	}
	
	private void AgregarHijos( Opportunity o, map<Id, OperacionComercial__c> mapOCCambio, map<Id, OperacionComercial__c> mapOld ) {
		LimpiarValores(o);
		for (OperacionComercial__c oc : o.Operaciones_Comerciales__r) {
			if (
				!mapOCCambio.containsKey(oc.id) && 
				!Tipos_No_Agregables_OC__c.getAll().keyset().contains(oc.TOPP__r.TipodeOperacionporplan__c) &&
				oc.Estado__c != 'Declinada') {
				SumarCantidades(o, oc);
			}
		}
		for (OperacionComercial__c oc : mapOCCambio.values()) {
			if (
				oc.Oportunidad__c == o.Id &&
				!Tipos_No_Agregables_OC__c.getAll().keyset().contains(mapOCCambioTopp.get(oc.id).TOPP__r.TipodeOperacionporplan__c) &&
				oc.Estado__c != 'Declinada'				
				) {
				SumarCantidades(o, oc);				
			}
		}
	}	
}