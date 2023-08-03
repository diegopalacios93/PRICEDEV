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
@isTest
private class Mecna_tst {

    static testMethod void asociarCuenta() {
        objPruebas_tst obj =new objPruebas_tst();
        
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;
    	
    	Mecna__c Mecna=new Mecna__c(AccountNumber__c=cliente.AccountNumber,TipodedocumentoM__c=cliente.Tipodedocumento__c);
    	insert Mecna;
    	
    }
}