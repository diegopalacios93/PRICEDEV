/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Mecna
Descripci�n:			Clase de prueba para el controlador Mecna_cls
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci�n
------  ----------  --------------------        ---------------
1.0		25-10-2014	Hector Bayona (HB)		Creaci�n de la clase
*******************************************************************************/
public with sharing class Mecna_cls {
	@future
	public static void relacionarCuenta(Set<Id> mNewMecna){
        Set<Mecna__c> mNew = new Set<Mecna__c>([SELECT Id, AccountNumber__c,Tipodedocumento__c FROM Mecna__C WHERE Id IN :mNewMecna]);
		map<string,Mecna__c> mecnaIdLst=new map<string,Mecna__c>();
		system.debug(mNew);
		for(Mecna__c m:mNew){
            if(String.isNotEmpty(m.AccountNumber__c)){
                mecnaIdLst.put(m.AccountNumber__c,m);
            }
		}
		system.debug(mecnaIdLst);
		list<Account> cuentas=new list<Account>();
        if(!mecnaIdLst.isEmpty()){
            cuentas = [select id,AccountNumber,Tipodedocumento__c from Account where (AccountNumber IN :mecnaIdLst.keySet()) and (RecordType.name='Cliente Principal'and AccountNumber!=null)];
            
            if(!cuentas.isEmpty()){
                for(Account c:cuentas){
                    if(mecnaIdLst.get(c.AccountNumber).Tipodedocumento__c==c.Tipodedocumento__c){
                        system.debug(mecnaIdLst.get(c.AccountNumber).id);
                        c.Mecna__c=mecnaIdLst.get(c.AccountNumber).id;	
                        c.EstadoRestriccionVenta__c=true;
                        c.LTE_CausalRestriccionVenta__c = 'Fraude';
                    }
                }
                update cuentas;
            }
        }
	}
}