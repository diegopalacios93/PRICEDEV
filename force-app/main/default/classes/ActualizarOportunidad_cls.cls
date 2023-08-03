/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase encargada de actualizar la Cuenta (cliente) cuando haya una operación comercial
						con estado igua a activa.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     16-10-2013  Andrés Cubillos (AAC)       Creación de la clase.
1.1		27-11-2013	Daniel Guana (DGUANA)		Creación de metodo para validar si se tienen Viabilidades pendientes.
1.2		30-06-2017	Mauricio Farias (MF)		Creacion de cosulta por lista para que no actualice una a una.
*******************************************************************************/
public class ActualizarOportunidad_cls {
	
	//DGUANA
	public void validarViabilidad(OperacionComercial__c inOC){
		List<Viabilidad__c> lstVia = [select id from Viabilidad__c where OperacionComercial__c= :inOC.Id and EstadoViabilidad__c in ('Pendiente','En proceso')];
		if(lstVia!=null && lstVia.size()>0){
			inOc.addError(Label.ActualizarOpp_ValidarViabilidad);
		}
	}
	//FIN DGUANA
	
	public ActualizarOportunidad_cls(){
		
	}
	
	public static void ActualizarOportunidad(Map<Id, ActivoETB__c> inlistAC){
		list<ActivoETB__c> lstAC = new list<ActivoETB__c>();
		Account acc;
        
        lstAC=[select id, NombredelaCuenta__r.type, Estado__c
               from ActivoETB__c
               where id=:inlistAC.keyset()
               and NombredelaCuenta__r.type='Prospecto'
               and Estado__c = 'Activo'
              ];
    
    	Map<Id,Account> lstAccount = new Map<Id,Account>();
        
        for(ActivoETB__c inAC:lstAC){
            acc=inAC.NombredelaCuenta__r;
            acc.Type='Cliente';
            if(!lstAccount.containsKey(acc.Id))
                lstAccount.put(acc.Id, acc);
        }		
        update lstAccount.values();
	}
	

}