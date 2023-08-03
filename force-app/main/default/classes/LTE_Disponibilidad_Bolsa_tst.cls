@isTest
private class LTE_Disponibilidad_Bolsa_tst{
    static testMethod void LTE_Disponibilidad_Bolsa_1(){
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'aprovisionamientoOnline';
        vGlobal.Valor__c = '1';        
        insert vGlobal;
        LTE_Disponibilidad_Bolsa_ctr cls = new LTE_Disponibilidad_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('Id',GeneraData_cls.oc4.Id);
        cls.consultar();
        cls.cancelar();
    }    
    
    static testMethod void LTE_Disponibilidad_Bolsa_2(){         
        GeneraData_cls.generarData();        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'aprovisionamientoOnline';
        vGlobal.Valor__c = '1';
        insert vGlobal;
        LTE_Disponibilidad_Bolsa_ctr cls = new LTE_Disponibilidad_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('Id',GeneraData_cls.oc3.Id);
        cls.consultar();
        cls.cancelar();
    }
    
    static testMethod void LTE_Disponibilidad_Bolsa_3(){ 		
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'aprovisionamientoOnline';
        vGlobal.Valor__c = '1';
        insert vGlobal;
        LTE_Disponibilidad_Bolsa_ctr cls = new LTE_Disponibilidad_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('Id',GeneraData_cls.oc5.Id);
        cls.consultar();
        cls.cancelar();
    }
    
    static testMethod void LTE_Disponibilidad_Bolsa_4(){ 		
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'aprovisionamientoOnline';
        vGlobal.Valor__c = '1';
        insert vGlobal;
        LTE_Disponibilidad_Bolsa_ctr cls = new LTE_Disponibilidad_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('Id',GeneraData_cls.oc8.Id);
        cls.consultar();
        cls.cancelar();
    }
}