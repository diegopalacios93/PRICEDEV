@isTest
private class APN_tst{
    static testMethod void APNTest() { 
        APN__c objAPN;
        Account acc;
        
        acc = new Account();
        acc.Name = 'cuentacuentacuenta123';        
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        insert acc;
        
        objAPN = new APN__c();
        objAPN.Charguing_Characteristics__c = '100';
        objAPN.Cuenta_Cliente__c = acc.Id;
        objAPN.Estado__c = 'Disponible';
        objAPN.Servicio__c = 'DATOS';
        objAPN.APN__c = 'empresas.etb.net.co';
        objAPN.Identificador_APN__c = '4';
        insert objAPN;
		
		objAPN = new APN__c();
        objAPN.Charguing_Characteristics__c = '100';
        objAPN.Cuenta_Cliente__c = acc.Id;
        objAPN.Estado__c = 'Disponible';
        objAPN.Servicio__c = 'DATOS';
        objAPN.APN__c = 'empresas.etb.net.co';
        objAPN.Identificador_APN__c = '4';
        insert objAPN;         
    }
}