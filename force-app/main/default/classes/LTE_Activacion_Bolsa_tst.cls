@isTest
private class LTE_Activacion_Bolsa_tst{
    static testMethod void LTE_Activacion_Bolsa_1(){        
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        LTE_Activacion_Bolsa_ctr cls = new LTE_Activacion_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.oc6.id);                 
        cls.consultar();
        cls.cancelar();
    }
    
    static testMethod void LTE_Activacion_Bolsa_2(){         
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        LTE_Activacion_Bolsa_ctr cls = new LTE_Activacion_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.oc7.id);                 
        cls.consultar();
        cls.cancelar();
    }
    
    static testMethod void LTE_Activacion_Bolsa_3(){         
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        LTE_Activacion_Bolsa_ctr cls = new LTE_Activacion_Bolsa_ctr();
        ApexPages.currentPage().getParameters().put('id',GeneraData_cls.oc5.id);                 
        cls.consultar();
        cls.cancelar();
    }
}