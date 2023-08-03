/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Daniel Guana
Proyecto:               ETB - CRM etapa 1
Descripción:            Clase de prueba para encargada de actualizar la oportunidad cuando haya una operación comercial
                        con estado igua a activa.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     16-10-2013  Daniel Guana (DGUANA)       Creación de la clase. (78%)
*******************************************************************************/
@isTest
private class ActualizarOportunidad_tst {
    static testMethod void myUnitTest() {
        
        List<VariablesGlobales__c> lstVariablesGlobales = new List<VariablesGlobales__c>{
            new VariablesGlobales__c(Name = 'NombreComercialLTE', Valor__c = 'TELEFONIA MOVIL (LTE)'),
            new VariablesGlobales__c(Name = 'NombreComercialAPN', Valor__c = 'APN CORPORATIVO')
            };
        insert lstVariablesGlobales;
        
        List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>{
            new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'),
            new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable')
        };
        insert lstLTEAPN;
		
		List<Perfiles_Reglas_OC__c> lstPerfilesReglasOC = new List<Perfiles_Reglas_OC__c>();
        Perfiles_Reglas_OC__c vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario01';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zweAAA';
        vPerfil.Detalles__c = 'si la operación comercial no aplica para preventa y no tiene legalización';
        lstPerfilesReglasOC.add(vPerfil);
		vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario08';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zwYAAQ,00e400000014I5jAAE,00e400000013zwcAAA,00e40000001FZVvAAO,00e400000013zweAAA';
        vPerfil.Detalles__c = 'en estado activa o declinada';
        lstPerfilesReglasOC.add(vPerfil);
        insert lstPerfilesReglasOC;
        
        GeneraData_cls.generarData();
        String id  = GeneraData_cls.generarActivoETB();
        ActivoETB__c act = new ActivoETB__c(Id=id, Estado__c = 'Activo');
        update act;
        Map<Id, ActivoETB__c> inlistAC = new Map<Id, ActivoETB__c>();
        inlistAC.put(act.Id, act);
        ActualizarOportunidad_cls cls = new ActualizarOportunidad_cls();
        }


    static testMethod void myUnitTest2() {
        
        List<VariablesGlobales__c> lstVariablesGlobales = new List<VariablesGlobales__c>{
            new VariablesGlobales__c(Name = 'NombreComercialLTE', Valor__c = 'TELEFONIA MOVIL (LTE)'),
            new VariablesGlobales__c(Name = 'NombreComercialAPN', Valor__c = 'APN CORPORATIVO')
            };
        insert lstVariablesGlobales;
        
        List<LTE_APN__c> lstLTEAPN = new List<LTE_APN__c>{
            new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'),
            new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable')
        };
        insert lstLTEAPN;
		
		List<Perfiles_Reglas_OC__c> lstPerfilesReglasOC = new List<Perfiles_Reglas_OC__c>();
        Perfiles_Reglas_OC__c vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario01';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zweAAA';
        vPerfil.Detalles__c = 'si la operación comercial no aplica para preventa y no tiene legalización';
        lstPerfilesReglasOC.add(vPerfil);
		vPerfil = new Perfiles_Reglas_OC__c();
        vPerfil.Name = 'Escenario08';
        vPerfil.Perfiles__c = '00e400000014GBIAA2,00e400000013ynYAAQ,00e400000013zwYAAQ,00e400000014I5jAAE,00e400000013zwcAAA,00e40000001FZVvAAO,00e400000013zweAAA';
        vPerfil.Detalles__c = 'en estado activa o declinada';
        lstPerfilesReglasOC.add(vPerfil);
        insert lstPerfilesReglasOC;
        
        /* GeneraData_cls.generarData();
        String id  = GeneraData_cls.generarOperacionComercial();
        OperacionComercial__c oc = [SELECT Id, Estado__c,Activo__c FROM OperacionComercial__c WHERE Id=:id];
        ActivoETB__c ac = [SELECT Id,Oportunidad__c FROM ActivoETB__c WHERE Id=:oc.Activo__c];
        ac.Oportunidad__c = null;
        update ac;
        oc.Estado__c = 'Activa';
        update oc;
        Map<Id, OperacionComercial__c> inlistOC = new Map<Id, OperacionComercial__c>();
        inlistOC.put(oc.Id, oc);
        ActualizarOportunidad_cls cls = new ActualizarOportunidad_cls();
        cls.ActualizarOportunidad(inlistOC); */ 
    }
}